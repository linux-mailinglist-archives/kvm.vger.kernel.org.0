Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCE2297BCD
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 12:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760891AbgJXKNZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 06:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760883AbgJXKNY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 06:13:24 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B71C0613CE;
        Sat, 24 Oct 2020 03:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=VrOlEdgYzVSu/rPZ4DA6y/W/9F3qMOPwzdl6CQveV68=; b=07eZ7bx/DZjHoVv5HhGdMW2B9p
        YV/MF2mAVWzwE/1DalXTizu1e5VVrkTzsOLmhX2pD2BHC3b0iTxy9qsc6x1SnbD2uYIPh3d95ZWyF
        iKSED5Iw1T8OZEtoKb5VqMCMZVL5KXqbF+sria9X17LONNTdqz/ywBdLR//UJ1TRDqMW9a7Syqiw2
        KZfei1rn1/qXCjxs5ZpgYZ5c5u4jJstOVsvRzUiwL2T/K1yWg6eWuHjgKaEXempRcSiuAvVOKbtu0
        H/cSA9U1i8XmvWTLSkANTddDKFNE5zIU0PYnZgXkmX+wNcVi9n77ICExK6wN/znUO6OjYoV8QyUPy
        YbPLTpjQ==;
Received: from [2a01:4c8:1484:e7ad:d26a:9749:72d:510a]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWGY0-0007Ox-V3; Sat, 24 Oct 2020 10:13:17 +0000
Date:   Sat, 24 Oct 2020 11:13:06 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <ddf17616-04c7-9593-eae8-8e9e473ecd90@redhat.com>
References: <87y2jy542v.fsf@nanos.tec.linutronix.de> <C53CAD52-38F8-47D7-A5BE-4F470532EF20@infradead.org> <87d01863a2.fsf@nanos.tec.linutronix.de> <be564fccc341efa730b8cdfe18ef4d7e709ebf50.camel@infradead.org> <ddf17616-04c7-9593-eae8-8e9e473ecd90@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 8/8] x86/ioapic: Generate RTE directly from parent irqchip's MSI message
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
CC:     kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <A2753AD1-9BE8-43D8-870D-236C394A892B@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 24 October 2020 10:13:36 BST, Paolo Bonzini <pbonzini@redhat=2Ecom> wro=
te:
>On 24/10/20 10:26, David Woodhouse wrote:
>> I was also hoping Paolo was going to take the patch which just
>defines
>> the KVM_FEATURE_MSI_EXT_DEST_ID bit=C2=B2 ASAP, so that we end up with =
a
>> second patch=C2=B3 that *just* wires it up to x86_init=2Emsi_ext_dest_i=
d()
>for
>> KVM=2E
>>=20
>> =C2=B9
>https://git=2Einfradead=2Eorg/users/dwmw2/linux=2Egit/commitdiff/734719c1=
f4
>> =C2=B2
>https://git=2Einfradead=2Eorg/users/dwmw2/linux=2Egit/commitdiff/3f371d67=
49
>> =C2=B3
>https://git=2Einfradead=2Eorg/users/dwmw2/linux=2Egit/commitdiff/8399e14e=
b5
>
>Yes, I am going to take it=2E
>
>I was already sort of playing with fire with the 5=2E10 pull request (and
>with me being lousy in general during the 5=2E10 development period, to
>be
>honest), so I left it for rc2 or rc3=2E  It's just docs and it happened
>to
>conflict with another documentation patch that had gone in through Jon
>Corbet's tree=2E

OK, thanks=2E I'll rework Thomas's tree with that first and the other chan=
ges I'd mentioned in my parts, as well as fixing up that unholy chim=C3=A6r=
a of struct/union in which we set some bitfields from each side of the unio=
n, test and push it out later today=2E

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
