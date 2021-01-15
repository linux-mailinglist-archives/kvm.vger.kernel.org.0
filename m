Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963922F844D
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 19:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388197AbhAOSZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 13:25:18 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47892 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388047AbhAOSZR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 13:25:17 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10FICwr3086890;
        Fri, 15 Jan 2021 13:24:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 message-id : reply-to : references : mime-version : content-type :
 in-reply-to : subject; s=pp1;
 bh=+ryAA7tFRy7NpZrkGCvfEnNHPOAC3BE2pscL10x1U4M=;
 b=RjGNuYJjBsCPkeLc+SlkRKDxB7fPTDsaH3IK/f+8aydsHnoEHbUp+t7HLs7AeUMIRfA5
 DBfZHuv9Xr+NGOFSaszn1n8p9daaE8IYpSjKi+hmAbl1TumjRMiysObOGn78rUKp7H2A
 Esp5dNWqNQt1YRe6PVZmSfgFL4AmnvKikD+KVlrPdla6pCoxk5XjiL8RF3ignHfJa70N
 FutuCwqcEJ91Cr6zuDbjU/M9CsjPsUghtvl+et7ECc/ZFRBVrxq8Gx3s+ozVz+3TkYKG
 Bp9QFY9PapL9jPVtG1heCXOMRJw9ePQi8Ep0zTmt3QBWOQMe8YZqIjas14WI83eji/MH yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 363g4k88q8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 13:24:20 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10FIETtV090047;
        Fri, 15 Jan 2021 13:24:20 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 363g4k88p7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 13:24:20 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10FIDUOh022500;
        Fri, 15 Jan 2021 18:24:18 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 35y448003h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 18:24:18 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10FIOAHB28967230
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 18:24:10 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69200A4062;
        Fri, 15 Jan 2021 18:24:15 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BBBF3A4069;
        Fri, 15 Jan 2021 18:24:10 +0000 (GMT)
Received: from ram-ibm-com.ibm.com (unknown [9.160.82.178])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 15 Jan 2021 18:24:10 +0000 (GMT)
Date:   Fri, 15 Jan 2021 10:24:07 -0800
From:   Ram Pai <linuxram@us.ibm.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, Greg Kurz <groug@kaod.org>,
        pair@us.ibm.com, brijesh.singh@amd.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org,
        frankja@linux.ibm.com, david@redhat.com, mdroth@linux.vnet.ibm.com,
        David Gibson <david@gibson.dropbear.id.au>, thuth@redhat.com,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org, rth@twiddle.net, berrange@redhat.com,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-ppc@nongnu.org,
        pbonzini@redhat.com
Message-ID: <20210115182407.GA24076@ram-ibm-com.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20201218124111.4957eb50.cohuck@redhat.com>
 <20210104071550.GA22585@ram-ibm-com.ibm.com>
 <20210104134629.49997b53.pasic@linux.ibm.com>
 <20210104184026.GD4102@ram-ibm-com.ibm.com>
 <20210105115614.7daaadd6.pasic@linux.ibm.com>
 <20210105204125.GE4102@ram-ibm-com.ibm.com>
 <20210111175914.13adfa2e.cohuck@redhat.com>
 <20210113124226.GH2938@work-vm>
 <6e02e8d5-af4b-624b-1a12-d03b9d554a41@de.ibm.com>
 <20210114103643.GD2905@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114103643.GD2905@work-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
Subject: RE: [for-6.0 v5 11/13] spapr: PEF: prevent migration
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_09:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 adultscore=0 lowpriorityscore=0
 impostorscore=0 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150106
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 14, 2021 at 10:36:43AM +0000, Dr. David Alan Gilbert wrote:
> * Christian Borntraeger (borntraeger@de.ibm.com) wrote:
> > 
> > 
> > On 13.01.21 13:42, Dr. David Alan Gilbert wrote:
> > > * Cornelia Huck (cohuck@redhat.com) wrote:
> > >> On Tue, 5 Jan 2021 12:41:25 -0800
> > >> Ram Pai <linuxram@us.ibm.com> wrote:
> > >>
> > >>> On Tue, Jan 05, 2021 at 11:56:14AM +0100, Halil Pasic wrote:
> > >>>> On Mon, 4 Jan 2021 10:40:26 -0800
> > >>>> Ram Pai <linuxram@us.ibm.com> wrote:
> > >>
> > >>>>> The main difference between my proposal and the other proposal is...
> > >>>>>
> > >>>>>   In my proposal the guest makes the compatibility decision and acts
> > >>>>>   accordingly.  In the other proposal QEMU makes the compatibility
> > >>>>>   decision and acts accordingly. I argue that QEMU cannot make a good
> > >>>>>   compatibility decision, because it wont know in advance, if the guest
> > >>>>>   will or will-not switch-to-secure.
> > >>>>>   
> > >>>>
> > >>>> You have a point there when you say that QEMU does not know in advance,
> > >>>> if the guest will or will-not switch-to-secure. I made that argument
> > >>>> regarding VIRTIO_F_ACCESS_PLATFORM (iommu_platform) myself. My idea
> > >>>> was to flip that property on demand when the conversion occurs. David
> > >>>> explained to me that this is not possible for ppc, and that having the
> > >>>> "securable-guest-memory" property (or whatever the name will be)
> > >>>> specified is a strong indication, that the VM is intended to be used as
> > >>>> a secure VM (thus it is OK to hurt the case where the guest does not
> > >>>> try to transition). That argument applies here as well.  
> > >>>
> > >>> As suggested by Cornelia Huck, what if QEMU disabled the
> > >>> "securable-guest-memory" property if 'must-support-migrate' is enabled?
> > >>> Offcourse; this has to be done with a big fat warning stating
> > >>> "secure-guest-memory" feature is disabled on the machine.
> > >>> Doing so, will continue to support guest that do not try to transition.
> > >>> Guest that try to transition will fail and terminate themselves.
> > >>
> > >> Just to recap the s390x situation:
> > >>
> > >> - We currently offer a cpu feature that indicates secure execution to
> > >>   be available to the guest if the host supports it.
> > >> - When we introduce the secure object, we still need to support
> > >>   previous configurations and continue to offer the cpu feature, even
> > >>   if the secure object is not specified.
> > >> - As migration is currently not supported for secured guests, we add a
> > >>   blocker once the guest actually transitions. That means that
> > >>   transition fails if --only-migratable was specified on the command
> > >>   line. (Guests not transitioning will obviously not notice anything.)
> > >> - With the secure object, we will already fail starting QEMU if
> > >>   --only-migratable was specified.
> > >>
> > >> My suggestion is now that we don't even offer the cpu feature if
> > >> --only-migratable has been specified. For a guest that does not want to
> > >> transition to secure mode, nothing changes; a guest that wants to
> > >> transition to secure mode will notice that the feature is not available
> > >> and fail appropriately (or ultimately, when the ultravisor call fails).
> > >> We'd still fail starting QEMU for the secure object + --only-migratable
> > >> combination.
> > >>
> > >> Does that make sense?
> > > 
> > > It's a little unusual; I don't think we have any other cases where
> > > --only-migratable changes the behaviour; I think it normally only stops
> > > you doing something that would have made it unmigratable or causes
> > > an operation that would make it unmigratable to fail.
> > 
> > I would like to NOT block this feature with --only-migrateable. A guest
> > can startup unprotected (and then is is migrateable). the migration blocker
> > is really a dynamic aspect during runtime. 
> 
> But the point of --only-migratable is to turn things that would have
> blocked migration into failures, so that a VM started with
> --only-migratable is *always* migratable.

I believe, the proposed behavior, does follow the above rule. The
VM started with --only-migratable will always be migratable. Any
behavior; in the guest, to the contrary will disallow the behavior or
terminate the guest, but will never let the VM transition to a
non-migratable state.


RP
