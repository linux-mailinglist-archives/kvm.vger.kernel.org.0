Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D362FFC817
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 14:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfKNNrw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 08:47:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43550 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726469AbfKNNrw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 08:47:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573739269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=61Im+QPZFQJdXU/FdfY59uPqIIvlWDz8/t0U8zWanMo=;
        b=Hq27QzD/cvCXQRwgwi82gTxZ0+8d/7vu3uCqiQPzjZTiyzsyNjt/c2Jq4r3J+I83XVN6+K
        ym0IjBvNV/BJubNFa085XpN8P11/S9j6FuaraJvle5k2QYSINEzfN7NM8NNKgArbYlZ+z4
        TO9qP8zOfQ1nYuPADKb39XUKVmIpV04=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-CoIWNYVHNAy7Rc59aoaIxw-1; Thu, 14 Nov 2019 08:47:46 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0BB8A8048E8;
        Thu, 14 Nov 2019 13:47:45 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 845CC619A8;
        Thu, 14 Nov 2019 13:47:40 +0000 (UTC)
Date:   Thu, 14 Nov 2019 14:47:38 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, mihajlov@linux.ibm.com, mimu@linux.ibm.com,
        gor@linux.ibm.com
Subject: Re: [RFC 11/37] DOCUMENTATION: protvirt: Interrupt injection
Message-ID: <20191114144738.19915998.cohuck@redhat.com>
In-Reply-To: <20191114142500.55f985b1@p-imbrenda.boeblingen.de.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-12-frankja@linux.ibm.com>
        <20191114140946.7bca2350.cohuck@redhat.com>
        <20191114142500.55f985b1@p-imbrenda.boeblingen.de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: CoIWNYVHNAy7Rc59aoaIxw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Nov 2019 14:25:00 +0100
Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> On Thu, 14 Nov 2019 14:09:46 +0100
> Cornelia Huck <cohuck@redhat.com> wrote:
>=20
> > On Thu, 24 Oct 2019 07:40:33 -0400
> > Janosch Frank <frankja@linux.ibm.com> wrote:
> >  =20
> > > Interrupt injection has changed a lot for protected guests, as KVM
> > > can't access the cpus' lowcores. New fields in the state
> > > description, like the interrupt injection control, and masked
> > > values safeguard the guest from KVM.
> > >=20
> > > Let's add some documentation to the interrupt injection basics for
> > > protected guests.
> > >=20
> > > Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> > > ---
> > >  Documentation/virtual/kvm/s390-pv.txt | 27
> > > +++++++++++++++++++++++++++ 1 file changed, 27 insertions(+)
> > >=20
> > > diff --git a/Documentation/virtual/kvm/s390-pv.txt
> > > b/Documentation/virtual/kvm/s390-pv.txt index
> > > 86ed95f36759..e09f2dc5f164 100644 ---
> > > a/Documentation/virtual/kvm/s390-pv.txt +++
> > > b/Documentation/virtual/kvm/s390-pv.txt @@ -21,3 +21,30 @@ normally
> > > needed to be able to run a VM, some changes have been made in SIE
> > > behavior and fields have different meaning for a PVM. SIE exits are
> > > minimized as much as possible to improve speed and reduce exposed
> > > guest state. +
> > > +
> > > +Interrupt injection:
> > > +
> > > +Interrupt injection is safeguarded by the Ultravisor and, as KVM
> > > lost +access to the VCPUs' lowcores, is handled via the format 4
> > > state +description.
> > > +
> > > +Machine check, external, IO and restart interruptions each can be
> > > +injected on SIE entry via a bit in the interrupt injection control
> > > +field (offset 0x54). If the guest cpu is not enabled for the
> > > interrupt +at the time of injection, a validity interception is
> > > recognized. The +interrupt's data is transported via parts of the
> > > interception data +block.   =20
> >=20
> > "Data associated with the interrupt needs to be placed into the
> > respective fields in the interception data block to be injected into
> > the guest."
> >=20
> > ? =20
>=20
> when a normal guest intercepts an exception, depending on the exception
> type, the parameters are saved in the state description at specified
> offsets, between 0xC0 amd 0xF8
>=20
> to perform interrupt injection for secure guests, the same fields are
> used to specify the interrupt parameters that should be injected into
> the guest

Ok, maybe add that as well.

>=20
> > > +
> > > +Program and Service Call exceptions have another layer of
> > > +safeguarding, they are only injectable, when instructions have
> > > +intercepted into KVM and such an exception can be an emulation
> > > result.   =20
> >=20
> > I find this sentence hard to parse... not sure if I understand it
> > correctly.
> >=20
> > "They can only be injected if the exception can be encountered during
> > emulation of instructions that had been intercepted into KVM." =20
> =20
> yes
>=20
> >  =20
> > > +
> > > +
> > > +Mask notification interceptions:
> > > +As a replacement for the lctl(g) and lpsw(e) interception, two new
> > > +interception codes have been introduced. One which tells us that
> > > CRs +0, 6 or 14 have been changed and therefore interrupt masking
> > > might +have changed. And one for PSW bit 13 changes. The CRs and
> > > the PSW in   =20
> >=20
> > Might be helpful to mention that this bit covers machine checks, which
> > do not get a separate bit in the control block :)
> >  =20
> > > +the state description only contain the mask bits and no further
> > > info +like the current instruction address.   =20
> >=20
> > "The CRs and the PSW in the state description only contain the bits
> > referring to interrupt masking; other fields like e.g. the current
> > instruction address are zero." =20
>=20
> wait state is saved too
>=20
> CC is write only, and is only inspected by hardware/firmware when
> KVM/qemu is interpreting an instruction that expects a new CC to be set,
> and then only the expected CCs are allowed (e.g. if an instruction only
> allows CC 0 or 3, 2 cannot be specified)

So I'm wondering how much of that should go into the document... maybe
just

"The CRs and the PSW in the state description contain less information
than for normal guests: most information that does not refer to
interrupt masking is not available to the hypervisor."

?

