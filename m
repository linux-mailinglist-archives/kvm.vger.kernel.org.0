Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20893149F63
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 09:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgA0ICN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 03:02:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45285 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726191AbgA0ICN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 03:02:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580112133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L0QENZKK5dUzUUb2dkjcWSCrsRRVFKQaiKNvctVwRUg=;
        b=NIqWSx9v/ajszTSFi7Ko/VvaVec4bJ/T+Vea530CxXKmrqZJdieokYUsKdzw6nheW4WAyC
        BC1agGb11nTt6iy+kSdziAyZsi6fjIsmjFZDQU+j56IcgtJj7nvBoneHWMTGOKrM5AJj8O
        e5PG2J7HnhsNpw5jqsKbhAAHwxO3VZw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-066bo0a1MneNHz2UyyYlcQ-1; Mon, 27 Jan 2020 03:02:09 -0500
X-MC-Unique: 066bo0a1MneNHz2UyyYlcQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A651DBA6;
        Mon, 27 Jan 2020 08:02:08 +0000 (UTC)
Received: from gondolin (ovpn-116-220.ams2.redhat.com [10.36.116.220])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 058FB863A3;
        Mon, 27 Jan 2020 08:02:06 +0000 (UTC)
Date:   Mon, 27 Jan 2020 09:02:04 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: force push to kvm/next coming
Message-ID: <20200127090204.33b7c0a6.cohuck@redhat.com>
In-Reply-To: <6b568513-5646-29ae-2165-95dbeb185697@redhat.com>
References: <8f43bd04-9f4e-5c06-8d1d-cb84bba40278@redhat.com>
        <c1564d41-0925-f0fd-c145-bea67a8b100e@de.ibm.com>
        <6b568513-5646-29ae-2165-95dbeb185697@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 25 Jan 2020 10:31:27 +0100
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 25/01/20 09:29, Christian Borntraeger wrote:
> >=20
> >=20
> > On 24.01.20 09:38, Paolo Bonzini wrote: =20
> >> Linux-next merge reported some bad mistakes on my part, so I'm
> >> force-pushing kvm/next.  Since it was pushed only yesterday and the co=
de
> >> is the same except for two changed lines, it shouldn't be a big deal.
> >>
> >> Paolo
> >> =20
> > current KVM/next has the following compile error (due to Seans rework).
> >=20
> >   CC [M]  arch/s390/kvm/kvm-s390.o
> > arch/s390/kvm/kvm-s390.c: In function =E2=80=98kvm_arch_vcpu_create=E2=
=80=99:
> > arch/s390/kvm/kvm-s390.c:3026:32: error: =E2=80=98id=E2=80=99 undeclare=
d (first use in this function); did you mean =E2=80=98fd=E2=80=99?
> >  3026 |  vcpu->arch.sie_block->icpua =3D id;
> >       |                                ^~
> >       |                                fd
> > arch/s390/kvm/kvm-s390.c:3026:32: note: each undeclared identifier is r=
eported only once for each function it appears in
> > arch/s390/kvm/kvm-s390.c:3028:39: error: =E2=80=98kvm=E2=80=99 undeclar=
ed (first use in this function)
> >  3028 |  vcpu->arch.sie_block->gd =3D (u32)(u64)kvm->arch.gisa_int.orig=
in;
> >       |                                       ^~~
> > make[2]: *** [scripts/Makefile.build:266: arch/s390/kvm/kvm-s390.o] Err=
or 1
> > make[1]: *** [scripts/Makefile.build:503: arch/s390/kvm] Error 2
> > make: *** [Makefile:1693: arch/s390] Error 2
> >=20
> > Is this part of the fixup that you will do or another issue? =20
>=20
> Nope, I trusted Conny's review on that. :(

Sorry about missing that, reviewed too late in the year :(

[If I actually test something, I'm usually explicitly mentioning that.]

