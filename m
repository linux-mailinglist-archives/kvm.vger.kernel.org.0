Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D420F321E89
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 18:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbhBVRwl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 12:52:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60603 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231130AbhBVRwg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 12:52:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614016269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O+4avbp3iRC9wzL9kQsBbVb6oEaX3FYxbdrqhd4FEnE=;
        b=Clv4kh7GSvD2HRhUCWeK154FrGJ81/aE6f/NHvOZZzh9abzdmNU+e5P/O4f7w0Nmq9UE8J
        9etBYfunuKv8UCErrdW7T5exl1/8BIEfT1eP5zzCpg4VVvqdpgqAdIhvxkji/5a8mmBXMh
        OB5G1QCz/qNuGPb4Y1BHClKZ5JwS660=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-BUheIuS7NaiFmeoxrS7BDQ-1; Mon, 22 Feb 2021 12:51:05 -0500
X-MC-Unique: BUheIuS7NaiFmeoxrS7BDQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D0F2801965;
        Mon, 22 Feb 2021 17:51:01 +0000 (UTC)
Received: from gondolin (ovpn-113-115.ams2.redhat.com [10.36.113.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE0141001281;
        Mon, 22 Feb 2021 17:50:46 +0000 (UTC)
Date:   Mon, 22 Feb 2021 18:50:44 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Aurelien Jarno <aurelien@aurel32.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-ppc@nongnu.org, qemu-s390x@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        xen-devel@lists.xenproject.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-arm@nongnu.org, Stefano Stabellini <sstabellini@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Leif Lindholm <leif@nuviainc.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Alistair Francis <alistair@alistair23.me>,
        Paul Durrant <paul@xen.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?B?SGVydsOp?= Poussineau <hpoussin@reactos.org>,
        Greg Kurz <groug@kaod.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <f4bug@amsat.org>
Subject: Re: [PATCH v2 01/11] accel/kvm: Check MachineClass kvm_type()
 return value
Message-ID: <20210222185044.23fccecc.cohuck@redhat.com>
In-Reply-To: <bc37276d-74cc-22f0-fcc0-4ee5e62cf1df@redhat.com>
References: <20210219173847.2054123-1-philmd@redhat.com>
        <20210219173847.2054123-2-philmd@redhat.com>
        <20210222182405.3e6e9a6f.cohuck@redhat.com>
        <bc37276d-74cc-22f0-fcc0-4ee5e62cf1df@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 22 Feb 2021 18:41:07 +0100
Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> wrote:

> On 2/22/21 6:24 PM, Cornelia Huck wrote:
> > On Fri, 19 Feb 2021 18:38:37 +0100
> > Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> wrote:
> >  =20
> >> MachineClass::kvm_type() can return -1 on failure.
> >> Document it, and add a check in kvm_init().
> >>
> >> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
> >> ---
> >>  include/hw/boards.h | 3 ++-
> >>  accel/kvm/kvm-all.c | 6 ++++++
> >>  2 files changed, 8 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/include/hw/boards.h b/include/hw/boards.h
> >> index a46dfe5d1a6..68d3d10f6b0 100644
> >> --- a/include/hw/boards.h
> >> +++ b/include/hw/boards.h
> >> @@ -127,7 +127,8 @@ typedef struct {
> >>   *    implement and a stub device is required.
> >>   * @kvm_type:
> >>   *    Return the type of KVM corresponding to the kvm-type string opt=
ion or
> >> - *    computed based on other criteria such as the host kernel capabi=
lities.
> >> + *    computed based on other criteria such as the host kernel capabi=
lities
> >> + *    (which can't be negative), or -1 on error.
> >>   * @numa_mem_supported:
> >>   *    true if '--numa node.mem' option is supported and false otherwi=
se
> >>   * @smp_parse:
> >> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> >> index 84c943fcdb2..b069938d881 100644
> >> --- a/accel/kvm/kvm-all.c
> >> +++ b/accel/kvm/kvm-all.c
> >> @@ -2057,6 +2057,12 @@ static int kvm_init(MachineState *ms)
> >>                                                              "kvm-type=
",
> >>                                                              &error_ab=
ort);
> >>          type =3D mc->kvm_type(ms, kvm_type);
> >> +        if (type < 0) {
> >> +            ret =3D -EINVAL;
> >> +            fprintf(stderr, "Failed to detect kvm-type for machine '%=
s'\n",
> >> +                    mc->name);
> >> +            goto err;
> >> +        }
> >>      }
> >> =20
> >>      do { =20
> >=20
> > No objection to this patch; but I'm wondering why some non-pseries
> > machines implement the kvm_type callback, when I see the kvm-type
> > property only for pseries? Am I holding my git grep wrong? =20
>=20
> Can it be what David commented here?
> https://www.mail-archive.com/qemu-devel@nongnu.org/msg784508.html
>=20

Ok, I might be confused about the other ppc machines; but I'm wondering
about the kvm_type callback for mips and arm/virt. Maybe I'm just
confused by the whole mechanism?

