Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2A7346EA0
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 02:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234332AbhCXBXX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 21:23:23 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:53505 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234202AbhCXBWz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Mar 2021 21:22:55 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id DE9895809A5;
        Tue, 23 Mar 2021 21:22:52 -0400 (EDT)
Received: from imap1 ([10.202.2.51])
  by compute6.internal (MEProxy); Tue, 23 Mar 2021 21:22:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type:content-transfer-encoding; s=fm1; bh=c+ae5
        ABAYnNsKU013IHA/pxBS9krhy3J/UsGITJ5lDI=; b=zJ/nOvAXvTkEAFmHLygGT
        LyE2zhB0swVOAJdkXBIv4Es9wjHrpLIbILgV2u44cyCCxnEM67St+YB97+wcWAYI
        A+HwAjY8y1NmwU2gi30w/7D27Y8eRpBe4KcDT/m5zNseVJpoyq9rY+pqASE+mVUp
        kTFVdB3Nb6V5z5m618/kG32AWTEVNc7WXnnRuHrbH8JkCMOTBXzBrOJaF2hbAevi
        weO+g6xCrpQMB8KkKwbLhmMoUxN/IXSwlfO5N8abknOmlPpMrQjdfiJchNjta3uD
        jxUkDvVAzHjkMF4FqIOaJnzOqIJ7AcFfebTj5obycehOnYaTz+6jbiYPa2XNT7gQ
        A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=c+ae5ABAYnNsKU013IHA/pxBS9krhy3J/UsGITJ5l
        DI=; b=Z0D7U2nhXnuYLt3ff/c+g0KBh2P7sRtatgDCjrmUN6/5darvM3Dm7mbiB
        arw0c+gNEm9zcvTar3/m7lYvoyeAHrQf31FswKh7tOok3qHKb9YaSLzCLsMzTkh8
        XrVjEBZ6NXCNsKgih8rl4KA/AONfAw77g+BUmT5Nnsj1Pjh99RU1sAY/D+bp868v
        YKniH3pAsLaSY4/1SX4nGaOCFFt2nQLPuMXhOnBK9S9XaHlZfozYzu6FsO6SQfWL
        S68yGLhHJx60cws+wOYGN1s6w6no00xm/B2admah1mNa/IDuqeKpVhOke33A4+D6
        aWFbMbo9VRctKc/tGs1G0wVw0//tA==
X-ME-Sender: <xms:a5RaYLLIcGHm37Xl-BSFqMIsbS7rJjfcXXaki0FHhKXS_Xa0mTsruQ>
    <xme:a5RaYPJ7Y3lsBdfrcRQjzox16M4JM7yZPpe0reGim33CzRSQLRzIePzKRiZr1Z0aV
    9kFBPIT2Vt1LrCvUSU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegjedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgfgsehtqhertderreejnecuhfhrohhmpedflfhi
    rgiguhhnucgjrghnghdfuceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomh
    eqnecuggftrfgrthhtvghrnhepfeetgeekveeftefhgfduheegvdeuuddvieefvddvlefh
    feehkeetfeeukedtfeejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomh
X-ME-Proxy: <xmx:a5RaYDuKLycdQ1-tCLtBfH_fGDHaBXL-fn6xMWJHYhXVK4EbyTaJtw>
    <xmx:a5RaYEZJtkJSKvUFR9DZ-ZUSSgXvp-nh6AWK1Za2dkg01qQKVQ6LRQ>
    <xmx:a5RaYCbbParC6qxNLYz69MIQDIZ3kYMsLfzPTdnsbPrBldgeeCspyg>
    <xmx:bJRaYIN3kUyoAy98GNtxL7O_VjZqHO9PB8vEffvaTBiVrYCUPYTX2A>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id A2251130005E; Tue, 23 Mar 2021 21:22:51 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-273-g8500d2492d-fm-20210323.002-g8500d249
Mime-Version: 1.0
Message-Id: <16018289-0b28-4412-854b-0d30519588ca@www.fastmail.com>
In-Reply-To: <62b12fe2-01db-76c0-b2fd-f730b4157285@amsat.org>
References: <1602059975-10115-1-git-send-email-chenhc@lemote.com>
 <1602059975-10115-3-git-send-email-chenhc@lemote.com>
 <0dfbe14a-9ddb-0069-9d86-62861c059d12@amsat.org>
 <CAAhV-H63zhXyUizwOxUtXdQQOR=r82493tgH8NfLmgXF0g8row@mail.gmail.com>
 <9fc6161e-cf27-b636-97c0-9aca77d0f9cd@amsat.org>
 <CAAhV-H5wPZQ+TGdZL=mPV4YQcjHarJFoEH-nobr10PdesR-ySg@mail.gmail.com>
 <62b12fe2-01db-76c0-b2fd-f730b4157285@amsat.org>
Date:   Wed, 24 Mar 2021 09:22:30 +0800
From:   "Jiaxun Yang" <jiaxun.yang@flygoat.com>
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        "Huacai Chen" <chenhuacai@gmail.com>
Cc:     "Huacai Chen" <zltjiangshi@gmail.com>,
        "Thomas Huth" <thuth@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Peter Maydell" <peter.maydell@linaro.org>,
        "Aleksandar Rikalo" <aleksandar.rikalo@syrmia.com>,
        "BALATON Zoltan via" <qemu-devel@nongnu.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Aurelien Jarno" <aurelien@aurel32.net>,
        "YunQiang Su" <syq@debian.org>
Subject: Re: [PATCH V13 2/9] meson.build: Re-enable KVM support for MIPS
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On Tue, Mar 23, 2021, at 9:56 PM, Philippe Mathieu-Daud=C3=A9 wrote:
> Hi Huacai,
>=20
> We are going to tag QEMU v6.0-rc0 today.
>=20
> I only have access to a 64-bit MIPS in little-endian to
> test KVM.
>=20
> Can you test the other configurations please?
> - 32-bit BE
> - 32-bit LE
> - 64-bit BE

+syq
As Loongson doesn't have Big-Endian processor and Loongson 3A won't run =
32bit kernel.

Probably wecan test on boston or malta board?=20

Thanks.=20


>=20
> Thanks!
>=20
> Phil.
>=20
>=20
[...]

--=20
- Jiaxun
