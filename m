Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4965FCA1D
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 16:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfKNPmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 10:42:16 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27664 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726339AbfKNPmQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 10:42:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573746134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ARPICKAxmtP2MVkr6VaLyHVW9D7RJyeAIgFKiZQZmQU=;
        b=fwzYKR3xOkc4SK0z+0hqdRgFFZtJPXISoOdShV0hGMxUkQEq6yir8ep2Dv1es516nmCNys
        Aakvi0KASg0BtjxZIexlXulIEPr/H3sxCVyZBKo/YtBrlL3rbhNV/ltAhI9Uw9A0SNlQps
        eXp1ZwpAtFJuHdrmHqOK7irIxLdWzmE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-IefI5EYDMiOc1--aqTEYxQ-1; Thu, 14 Nov 2019 10:41:44 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13701102C868;
        Thu, 14 Nov 2019 15:41:43 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ADCCE5ED4D;
        Thu, 14 Nov 2019 15:41:38 +0000 (UTC)
Date:   Thu, 14 Nov 2019 16:41:36 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, mihajlov@linux.ibm.com, mimu@linux.ibm.com,
        gor@linux.ibm.com
Subject: Re: [RFC 17/37] DOCUMENTATION: protvirt: Instruction emulation
Message-ID: <20191114164136.0be3f058.cohuck@redhat.com>
In-Reply-To: <20191114162024.13f17aa9@p-imbrenda.boeblingen.de.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-18-frankja@linux.ibm.com>
        <20191114161526.1100f4fe.cohuck@redhat.com>
        <20191114162024.13f17aa9@p-imbrenda.boeblingen.de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: IefI5EYDMiOc1--aqTEYxQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Nov 2019 16:20:24 +0100
Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> On Thu, 14 Nov 2019 16:15:26 +0100
> Cornelia Huck <cohuck@redhat.com> wrote:
>=20
> > On Thu, 24 Oct 2019 07:40:39 -0400
> > Janosch Frank <frankja@linux.ibm.com> wrote:
> >  =20
> > > As guest memory is inaccessible and information about the guest's
> > > state is very limited, new ways for instruction emulation have been
> > > introduced.
> > >=20
> > > With a bounce area for guest GRs and instruction data, guest state
> > > leaks can be limited by the Ultravisor. KVM now has to move
> > > instruction input and output through these areas.
> > >=20
> > > Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> > > ---
> > >  Documentation/virtual/kvm/s390-pv.txt | 47
> > > +++++++++++++++++++++++++++ 1 file changed, 47 insertions(+)
> > >=20
> > > diff --git a/Documentation/virtual/kvm/s390-pv.txt
> > > b/Documentation/virtual/kvm/s390-pv.txt index
> > > e09f2dc5f164..cb08d78a7922 100644 ---
> > > a/Documentation/virtual/kvm/s390-pv.txt +++
> > > b/Documentation/virtual/kvm/s390-pv.txt @@ -48,3 +48,50 @@
> > > interception codes have been introduced. One which tells us that
> > > CRs have changed. And one for PSW bit 13 changes. The CRs and the
> > > PSW in the state description only contain the mask bits and no
> > > further info like the current instruction address. +
> > > +
> > > +Instruction emulation:
> > > +With the format 4 state description the SIE instruction already   =
=20
> >=20
> > s/description/description,/
> >  =20
> > > +interprets more instructions than it does with format 2. As it is
> > > not +able to interpret all instruction, the SIE and the UV
> > > safeguard KVM's   =20
> >=20
> > s/instruction/instructions/
> >  =20
> > > +emulation inputs and outputs.
> > > +
> > > +Guest GRs and most of the instruction data, like IO data
> > > structures   =20
> >=20
> > Hm, what 'IO data structures'? =20
>=20
> the various IRB and ORB of I/O instructions

Would be good to mention them as examples :)

>=20
> > > +are filtered. Instruction data is copied to and from the Secure
> > > +Instruction Data Area. Guest GRs are put into / retrieved from the
> > > +Interception-Data block.
> > > +
> > > +The Interception-Data block from the state description's offset
> > > 0x380 +contains GRs 0 - 16. Only GR values needed to emulate an
> > > instruction +will be copied into this area.
> > > +
> > > +The Interception Parameters state description field still contains
> > > the +the bytes of the instruction text but with pre-set register
> > > +values. I.e. each instruction always uses the same instruction
> > > text, +to not leak guest instruction text.
> > > +
> > > +The Secure Instruction Data Area contains instruction storage
> > > +data. Data for diag 500 is exempt from that and has to be moved
> > > +through shared buffers to KVM.   =20
> >=20
> > I find this paragraph a bit confusing. What does that imply for diag
> > 500 interception? Data is still present in gprs 1-4? =20
>=20
> no registers are leaked in the registers. registers are always only
> exposed through the state description.

So, what is so special about diag 500, then?

>=20
> > (Also, why only diag 500? Because it is the 'reserved for kvm'
> > diagnose call?)
> >  =20
> > > +
> > > +When SIE intercepts an instruction, it will only allow data and
> > > +program interrupts for this instruction to be moved to the guest
> > > via +the two data areas discussed before. Other data is ignored or
> > > results +in validity interceptions.
> > > +
> > > +
> > > +Instruction emulation interceptions:
> > > +There are two types of SIE secure instruction intercepts. The
> > > normal +and the notification type. Normal secure instruction
> > > intercepts will +make the guest pending for instruction completion
> > > of the intercepted +instruction type, i.e. on SIE entry it is
> > > attempted to complete +emulation of the instruction with the data
> > > provided by KVM. That might +be a program exception or instruction
> > > completion. +
> > > +The notification type intercepts inform KVM about guest environment
> > > +changes due to guest instruction interpretation. Such an
> > > interception   =20
> >=20
> > 'interpretation by SIE' ?
> >  =20
> > > +is recognized for the store prefix instruction and provides the new
> > > +lowcore location for mapping change notification arming. Any KVM
> > > data +in the data areas is ignored, program exceptions are not
> > > injected and +execution continues on next SIE entry, as if no
> > > intercept had +happened.   =20
> >  =20
>=20

