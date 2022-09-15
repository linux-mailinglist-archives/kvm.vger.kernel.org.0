Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A86C35BA257
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 23:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiIOVed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 17:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiIOVeb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 17:34:31 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5ED3DA8
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 14:34:29 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 2AC823200AD1;
        Thu, 15 Sep 2022 17:34:25 -0400 (EDT)
Received: from imap44 ([10.202.2.94])
  by compute4.internal (MEProxy); Thu, 15 Sep 2022 17:34:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1663277664; x=
        1663364064; bh=/eknyiWI+rvegyztt8Mdl0E4m3Bnu9X/oPwwi5PsQQw=; b=e
        VypKgdBVzJ9gixTIDZIQpCVsMpIxart+PkBdJaVg6+iPZMVgzZ8rrYFbL1fPhhwF
        ew3AdFFJEOZ3wxDrCJDp7Ljy8Uj+f7yZQVRJ/4m47oC0yw7bRK5GOeMB5zqrLbMd
        /Bibrca5bDPTnSaADPSakygKPlLWw3vk/OMm+YMyGkc/68VRtfKOkOgHbSjugp32
        UBotkWhNXOPjQJ/MheR3JH9eFS8ckeF9pWi06w94Bt6kTilZB8r/5jHHVNp7y0Ss
        xD/6zV49Ld88fQwfuUAoSMYUf2iwZ77d627ZM5fRin3h4h4qUXYoVZt97mkm8htc
        XApT2x7X/NTaW4TO+s3dA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1663277664; x=
        1663364064; bh=/eknyiWI+rvegyztt8Mdl0E4m3Bnu9X/oPwwi5PsQQw=; b=A
        o3xkaFJQl6eeSgi7vKKICLYp5eJ4wq3L6GD/lpSxI/yWT10ly6gonL/aoMz2x6/N
        6RRZmAAVSpbwjh2ypsfjqnj2MdAzol5tmOd8eLGHlehboUkVdZqjxRglJS4hNb8s
        F5xz11UaNSf88ux2HnUMblhKZBkmnP701ThBe4Q4gyKvDcRSDuDbJhdWDKlufgZf
        EntowMYVyUPiMB6NJDs1ePDLrSWFv4igcAZYxtmru6n4YA75eAq4s1/Feb/hTIZz
        HaVRpPbRQEw95FSrBwnpWiL1ef1Mvxs1I+4mASQhKSWeBMQbJ03JCbO2c2zTlsDe
        o/we2FumaSeav/wfhgidA==
X-ME-Sender: <xms:YJojY6WYT5AlssLNnDe9kVYMvUbS-kfdmHKfRyWZKHKXhZQ-jymUxA>
    <xme:YJojY2lYGgtVGxSQKodwndm4vQOUdWcbLiMaVxXB367uBveenTf9UBY0muMCi2eKN
    -wy2fABseNTX_fK-AM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeduledgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefofgggkfgjfhffhffvvefutgfgse
    htqhertderreejnecuhfhrohhmpedflfhirgiguhhnucgjrghnghdfuceojhhirgiguhhn
    rdihrghnghesfhhlhihgohgrthdrtghomheqnecuggftrfgrthhtvghrnhepudefgeefte
    dugeehffdtheefgfevffelfefghefhjeeugeevtefhudduvdeihefgnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghngh
    esfhhlhihgohgrthdrtghomh
X-ME-Proxy: <xmx:YJojY-ZS0uujzEpchMQCE4HMisHnEnN8h_Xz9-TmAcIp1RHzKgaHcg>
    <xmx:YJojYxVc84MbJkywROkNOcRA9wHXufzIGO6uIiOl8YiCr3afUCn2ZA>
    <xmx:YJojY0nX-CiIKGcOjt_yHbYxYpX3_eMHToy2Lat12lft4N_clrNv9A>
    <xmx:YJojY5wkIgeD4Z-HDf3jJ-ySxMfBPC5lzTY06syv8XzRVQ94YUV2Zg>
Feedback-ID: ifd894703:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 3E76C36A0073; Thu, 15 Sep 2022 17:34:24 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-935-ge4ccd4c47b-fm-20220914.001-ge4ccd4c4
Mime-Version: 1.0
Message-Id: <ec4a6ecf-f432-4dd0-abf6-61d7b587a61b@www.fastmail.com>
In-Reply-To: <699535de25ac2d696cdf218bbb1f401bcd6048c1.camel@infradead.org>
References: <9e1d3ba6-48ac-4a97-8b65-87e395898c2a@www.fastmail.com>
 <699535de25ac2d696cdf218bbb1f401bcd6048c1.camel@infradead.org>
Date:   Thu, 15 Sep 2022 22:34:03 +0100
From:   "Jiaxun Yang" <jiaxun.yang@flygoat.com>
To:     "David Woodhouse" <dwmw2@infradead.org>, iommu@lists.linux.dev
Cc:     kvm@vger.kernel.org, ath11k@lists.infradead.org, kvalo@kernel.org
Subject: Re: ath11k VFIO MSI issue with DMAR
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



=E5=9C=A82022=E5=B9=B49=E6=9C=8813=E6=97=A5=E4=B9=9D=E6=9C=88 =E4=B8=8B=E5=
=8D=883:55=EF=BC=8CDavid Woodhouse=E5=86=99=E9=81=93=EF=BC=9A
> On Tue, 2022-09-13 at 15:09 +0100, Jiaxun Yang wrote:
[...]
>
> Your best bet is probably to have the hypervisor trap accesses to the
> ath11k_ce_srng_msi_ring_params_setup and ath11k_dp_srng_msi_setup
> registers and do the same trick of allocating a host IRQ route and
> writing the converted MSI message.
>
> The alternative is to build some kind of enlightenment to let the guest
> ask the hypervisor to tell it the correct remappable format message to
> use... but that's going to get very horrid very quickly. If your
> hardware allows you to read the MSI(X) table via some other indirect
> route which isn't trapped by the hypervisor to give you back the
> "original" thing you wrote, perhaps you could write to an unused MSI
> and then read back what the hardware *actually* contains... then write
> that to the special register? But that's kind of awful.

Indeed both ideas sound awful...

My current approach is raise a guest APIC interrupt when 0x25 fault happ=
ens.
Though I'm currently hardcoding guest APIC destination but I think it's =
possible
to check fault MSI address/data from fault event address/data registers =
against
DMAR interrupt mapping table to determine actual destination?

It's bit of trap and emulation, think that will enable DMAR driver to ha=
ndle such
situtation.

Thanks.

>
> =E9=99=84=E4=BB=B6:
> * smime.p7s

--=20
- Jiaxun
