Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F50D2E9D38
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 19:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbhADSle (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 13:41:34 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24928 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727091AbhADSle (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Jan 2021 13:41:34 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 104IWfdH160001;
        Mon, 4 Jan 2021 13:40:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 message-id : reply-to : references : mime-version : content-type :
 in-reply-to : subject; s=pp1;
 bh=e0FrvDiDaGp4PO1G8Wdkr2pDY+yqLmE82+FyReAJKqg=;
 b=Du2Bja68aEwzRQ+UtuwAdBbEqddqSkoFFwqafBJfVdY1zaRjQ3JCiBDF8eJMSk7tMwMk
 hLKyHINiPHXqnKdWcanomvFDhqr2RmQ37MzOgOEjtFqM+Xc6C9QMbCkWWXF3xl+XUAoo
 Fwjn0QEJ4hdBo4G0/hDzJKJNvxdmZJybVDr2SDKSeJiGRQ0Efvan/Dbg3cIymFoGdsoO
 o7/ZoyJR0pvoIkO0mKEgFpQ/CxYOy7jtjv+hAtjjoSw3MHypMYf2J1AhnDiw8aGhedyJ
 UOlul4nHNn9tYHk8+TVI7IhsJ5cNDOBXrBQXXHTguhAwtL0z6eC6gUvky+F1R8Y5hkKj Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35v8bh073s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 13:40:38 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 104IWqtb160447;
        Mon, 4 Jan 2021 13:40:38 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35v8bh0736-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 13:40:38 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 104ISEkB005944;
        Mon, 4 Jan 2021 18:40:36 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 35tgf893jf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jan 2021 18:40:36 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 104IeWVJ35783074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Jan 2021 18:40:32 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B18A652050;
        Mon,  4 Jan 2021 18:40:32 +0000 (GMT)
Received: from ram-ibm-com.ibm.com (unknown [9.163.29.145])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 967A952059;
        Mon,  4 Jan 2021 18:40:28 +0000 (GMT)
Date:   Mon, 4 Jan 2021 10:40:26 -0800
From:   Ram Pai <linuxram@us.ibm.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, Greg Kurz <groug@kaod.org>,
        pair@us.ibm.com, brijesh.singh@amd.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org,
        frankja@linux.ibm.com, david@redhat.com, mdroth@linux.vnet.ibm.com,
        borntraeger@de.ibm.com, David Gibson <david@gibson.dropbear.id.au>,
        thuth@redhat.com, Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        dgilbert@redhat.com, qemu-s390x@nongnu.org, rth@twiddle.net,
        berrange@redhat.com, Marcelo Tosatti <mtosatti@redhat.com>,
        qemu-ppc@nongnu.org, pbonzini@redhat.com
Message-ID: <20210104184026.GD4102@ram-ibm-com.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
 <20201204054415.579042-12-david@gibson.dropbear.id.au>
 <20201214182240.2abd85eb.cohuck@redhat.com>
 <20201217054736.GH310465@yekko.fritz.box>
 <20201217123842.51063918.cohuck@redhat.com>
 <20201217151530.54431f0e@bahia.lan>
 <20201218124111.4957eb50.cohuck@redhat.com>
 <20210104071550.GA22585@ram-ibm-com.ibm.com>
 <20210104134629.49997b53.pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104134629.49997b53.pasic@linux.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
Subject: RE: [for-6.0 v5 11/13] spapr: PEF: prevent migration
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-04_11:2021-01-04,2021-01-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 impostorscore=0 phishscore=0 malwarescore=0 clxscore=1015
 adultscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101040118
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 04, 2021 at 01:46:29PM +0100, Halil Pasic wrote:
> On Sun, 3 Jan 2021 23:15:50 -0800
> Ram Pai <linuxram@us.ibm.com> wrote:
> 
> > On Fri, Dec 18, 2020 at 12:41:11PM +0100, Cornelia Huck wrote:
> > > On Thu, 17 Dec 2020 15:15:30 +0100
> [..]
> > > > > > > > +int kvmppc_svm_init(SecurableGuestMemory *sgm, Error **errp)
> > > > > > > >  {
> > > > > > > >      if (!kvm_check_extension(kvm_state, KVM_CAP_PPC_SECURABLE_GUEST)) {
> > > > > > > >          error_setg(errp,
> > > > > > > > @@ -54,6 +58,11 @@ static int kvmppc_svm_init(Error **errp)
> > > > > > > >          }
> > > > > > > >      }
> > > > > > > >  
> > > > > > > > +    /* add migration blocker */
> > > > > > > > +    error_setg(&pef_mig_blocker, "PEF: Migration is not implemented");
> > > > > > > > +    /* NB: This can fail if --only-migratable is used */
> > > > > > > > +    migrate_add_blocker(pef_mig_blocker, &error_fatal);      
> > > > > > > 
> > > > > > > Just so that I understand: is PEF something that is enabled by the host
> > > > > > > (and the guest is either secured or doesn't start), or is it using a
> > > > > > > model like s390x PV where the guest initiates the transition into
> > > > > > > secured mode?      
> > > > > > 
> > > > > > Like s390x PV it's initiated by the guest.
> > > > > >     
> > > > > > > Asking because s390x adds the migration blocker only when the
> > > > > > > transition is actually happening (i.e. guests that do not transition
> > > > > > > into secure mode remain migratable.) This has the side effect that you
> > > > > > > might be able to start a machine with --only-migratable that
> > > > > > > transitions into a non-migratable machine via a guest action, if I'm
> > > > > > > not mistaken. Without the new object, I don't see a way to block with
> > > > > > > --only-migratable; with it, we should be able to do that. Not sure what
> > > > > > > the desirable behaviour is here.      
> > > > > >     
> > > > 
> > > > The purpose of --only-migratable is specifically to prevent the machine
> > > > to transition to a non-migrate state IIUC. The guest transition to
> > > > secure mode should be nacked in this case.  
> > > 
> > > Yes, that's what happens for s390x: The guest tries to transition, QEMU
> > > can't add a migration blocker and fails the instruction used for
> > > transitioning, the guest sees the error.
> > > 
> > > The drawback is that we see the failure only when we already launched
> > > the machine and the guest tries to transition. If I start QEMU with
> > > --only-migratable, it will refuse to start when non-migratable devices
> > > are configured in the command line, so I see the issue right from the
> > > start. (For s390x, that would possibly mean that we should not even
> > > present the cpu feature bit when only_migratable is set?)  
> > 
> > What happens in s390x,  if the guest tries to transition to secure, when
> > the secure object is NOT configured on the machine?
> > 
> 
> Nothing in particular.
> 
> > On PEF systems, the transition fails and the guest is terminated.
> > 
> > My point is -- QEMU will not be able to predict in advance, what the
> > guest might or might not do, regardless of what devices and objects are
> > configured in the machine.   If the guest does something unexpected, it
> > has to be terminated.
> 
> We can't fail transition to secure when the secure object is not
> configured on the machine, because that would break pre-existing
> setups.

So the instruction to switch-to-secure; which I believe is a ultracall
on S390,  will return success even though the switch-to-secure has failed?
Will the guest continue as a normal guest or as a secure guest?

> This feature is still to be shipped, but secure execution has
> already been shipped, but without migration support.
> 
> That's why when you have both the secure object configured, and mandate
> migratability, the we can fail. Actually we should fail now, because the
> two options are not compatible: you can't have a qemu that is guaranteed
> to be migratable, and guaranteed to be able to operate in secure
> execution mode today. Failing early, and not on the guests opt-in would
> be preferable.
> 
> After migration support is added, the combo should be fine, and probably
> also the default for secure execution machines.
> 
> > 
> > So one possible design choice is to let the guest know that migration
> > must be facilitated. It can then decide if it wants to continue as a
> > normal VM or terminate itself, or take the plunge and switch to secure.
> > A well behaving guest will not switch to secure.
> > 
> 
> I don't understand this point. Sorry.

Qemu will present the 'must-support-migrate' and the 'secure-object' capability
to the guest.

The secure-aware guest, has three choices
   (a) terminate itself. OR
   (b) not call the switch-to-secure ucall, and continue as normal guest. OR
   (c) call the switch-to-secure ucall.

Legacy guests which are not aware of secure-object, will continue to do
(b).   New Guests which are secure-object aware, will observe that 
'must-support-migrate' and 'secure-object' capabilities are
incompatible.  Hence will choose (a) or (b), but will never choose
(c).



The main difference between my proposal and the other proposal is...

  In my proposal the guest makes the compatibility decision and acts
  accordingly.  In the other proposal QEMU makes the compatibility
  decision and acts accordingly. I argue that QEMU cannot make a good
  compatibility decision, because it wont know in advance, if the guest
  will or will-not switch-to-secure.


RP
