Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CF4201BF6
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 22:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387544AbgFSUFC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 16:05:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50164 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730512AbgFSUFB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 16:05:01 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05JK3Sf4084882;
        Fri, 19 Jun 2020 16:04:44 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31rwwu3j89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Jun 2020 16:04:44 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05JK4hIZ088122;
        Fri, 19 Jun 2020 16:04:43 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31rwwu3j5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Jun 2020 16:04:43 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05JJuhKr023294;
        Fri, 19 Jun 2020 20:04:36 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 31quaxbj7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Jun 2020 20:04:36 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05JK3GhF66191722
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jun 2020 20:03:16 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA4D45205A;
        Fri, 19 Jun 2020 20:04:33 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.147.95])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 18CD15204E;
        Fri, 19 Jun 2020 20:04:33 +0000 (GMT)
Date:   Fri, 19 Jun 2020 22:04:31 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, pair@us.ibm.com,
        brijesh.singh@amd.com, frankja@linux.ibm.com, kvm@vger.kernel.org,
        david@redhat.com, cohuck@redhat.com, qemu-devel@nongnu.org,
        dgilbert@redhat.com, qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        pbonzini@redhat.com, Richard Henderson <rth@twiddle.net>,
        mdroth@linux.vnet.ibm.com, Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH v3 9/9] host trust limitation: Alter virtio default
 properties for protected guests
Message-ID: <20200619220431.54288e84.pasic@linux.ibm.com>
In-Reply-To: <20200619121638.GK700896@redhat.com>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
        <20200619020602.118306-10-david@gibson.dropbear.id.au>
        <20200619101245.GC700896@redhat.com>
        <20200619074432-mutt-send-email-mst@kernel.org>
        <20200619074630-mutt-send-email-mst@kernel.org>
        <20200619121638.GK700896@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-19_21:2020-06-19,2020-06-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 cotscore=-2147483648
 clxscore=1015 mlxscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 phishscore=0 bulkscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006190141
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 19 Jun 2020 13:16:38 +0100
Daniel P. Berrangé <berrange@redhat.com> wrote:

[..]

> > > > > @@ -1165,6 +1167,15 @@ void machine_run_board_init(MachineState *machine)
> > > > >           * areas.
> > > > >           */
> > > > >          machine_set_mem_merge(OBJECT(machine), false, &error_abort);
> > > > > +
> > > > > +        /*
> > > > > +         * Virtio devices can't count on directly accessing guest
> > > > > +         * memory, so they need iommu_platform=on to use normal DMA
> > > > > +         * mechanisms.  That requires disabling legacy virtio support
> > > > > +         * for virtio pci devices
> > > > > +         */
> > > > > +        object_register_sugar_prop(TYPE_VIRTIO_PCI, "disable-legacy", "on");
> > > > > +        object_register_sugar_prop(TYPE_VIRTIO_DEVICE, "iommu_platform", "on");
> > > > >      }  
> > > > 
> > > > Silently changing the user's request configuration like this is a bad idea.
> > > > The "disable-legacy" option in particular is undesirable as that switches
> > > > the device to virtio-1.0 only mode, which exposes a different PCI ID to
> > > > the guest.
> > > > 
> > > > If some options are incompatible with encryption, then we should raise a
> > > > fatal error at startup, so applications/admins are aware that their requested
> > > > config is broken.  
> > >
> > > Agreed - my suggestion is an on/off/auto property, auto value
> > > changes automatically, on/off is validated.  
> > 
> > In fact should we extend all bit properties to allow an auto value?  
> 
> If "auto" was made the default that creates a similar headache, as to
> preserve existing configuration semantics we expose to apps, libvirt
> would need to find all the properties changed to use "auto" and manually
> set them back to on/off explicitly.

Hm, does that mean we can't change the default for any qemu property?

I would expect that the defaults most remain invariant for any
particular machine version. Conceptually, IMHO the default could change
with a new machine version, but we would need some mechanism to ensure
compatibility for old machine versions.

Regards,
Halil
