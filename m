Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7119F4BD607
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 07:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbiBUGPD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 01:15:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiBUGPC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 01:15:02 -0500
Received: from new3-smtp.messagingengine.com (new3-smtp.messagingengine.com [66.111.4.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F1329A
        for <kvm@vger.kernel.org>; Sun, 20 Feb 2022 22:14:38 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 8E9645801D7;
        Mon, 21 Feb 2022 01:14:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 21 Feb 2022 01:14:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=irrelevant.dk;
         h=cc:cc:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; bh=+cVvRwUGwXInxREMrP53yrhsbPf2ic
        rS/lMxsX+UmDc=; b=GeQ3mxD/0EW04Qq+KqZqFAYvdM+siYLRxzMWsTAvub3xou
        cnXDW2N24YSYdq/kEvkvVSBgKulXbFMcYS/z1aMZtS6SfQUwUDP0MVRC6gyYaQcl
        78ATMQCiDH2Ajq04VAYr00KfGEV3mpQggU5W/DJ2Vi1hHzkGjACvfnLPANfL8JW2
        w22qZDRuQesVYDvPQngG6//jQkTEPn2GUs2MubjIPFXu94F/6tR2tVxtgGRTNunQ
        L8a95wOkpa+ELvBq3glCd91xktvd9trWzNFial7CbYu1Z7vaQTB6sdGO1Bs3dQAV
        eHB9n0XSDnVY/P3tAdLTcAI/X0pds3WQImqYxaiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+cVvRwUGwXInxREMr
        P53yrhsbPf2icrS/lMxsX+UmDc=; b=SMERIfk/1fUp3S5gtOD8RnyzSFeZhUNDn
        9xd2Oxf+mYRPv/t4hzEmb5raq0bAfoaRZG9KSgHchPQqC86n5K4YDDTiwWwKqgaM
        5aCldrecrQauui9HQXxT/BpluOarIOqo2sYMM2DeO3DwZo+Epd+YdA2PWvSD91UH
        ZQTZLanWT944lr1Qmqmgv90t5TpEc2iafmvpJyGiGpL4EXVooviqsGqO7wRc3ymy
        a4vcFljmRavDrvagLNQ/aZbaXW0zpAMdAfg4ai/E3oSBg2Myi8dGAiQG6tBH1cqk
        xTsPMMnoVSLYLbeJpuIVf7pIej/xrtOXsPoyy4MxuXdgQzaB7RlHA==
X-ME-Sender: <xms:yi0TYmqE9Qbx36zUnyED7H6R0z_9TQOUt-ryoCj3FD9hhZXD-mPTBQ>
    <xme:yi0TYkq5LtEpq5kBwSKe1eBzfC-MAueUSivPrti2RHs4pbGzq_6O-rU-WsVmzrfxC
    cjyKKaVx_XFusxuUsE>
X-ME-Received: <xmr:yi0TYrO49f5GiiKec_YmWu5P5CxURU49ducO2sSoOSI2LAhUzP2rRzSHlkFBZ1lQ6QDCeEBvhieLWnp8dg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkeehgdeludcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesghdtroertddtjeenucfhrhhomhepmfhlrghushcu
    lfgvnhhsvghnuceoihhtshesihhrrhgvlhgvvhgrnhhtrdgukheqnecuggftrfgrthhtvg
    hrnhepkeeugfdugfeitdeigfetkeektdefjedvlefftdevtdduffffueeuheeitdejffej
    necuffhomhgrihhnpeifihhthhhgohhoghhlvgdrtghomhdpohhuthhrvggrtghhhidroh
    hrghdphihouhhtuhgsvgdrtghomhdpqhgvmhhurdhorhhgnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihhtshesihhrrhgvlhgvvhgrnhhtrd
    gukh
X-ME-Proxy: <xmx:yi0TYl7idxYesBlDPxXRrDo69hZhlagcMmcD1bYV9hhcVJZJl_aYEg>
    <xmx:yi0TYl6aV7XBRcyAJ-O_XKl1SxUW5YU1BFK4F78CfntzS-HxkuEAkA>
    <xmx:yi0TYljKiz69iKUjg7l1DKShVUf8fR-F9SgSImmyRve-_j-42UUVzg>
    <xmx:yy0TYizLXeX7OHyDf8GFaaumT4fAXG0LfaTRkUQ0jEQ4I3N-ISEzUA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Feb 2022 01:14:31 -0500 (EST)
Date:   Mon, 21 Feb 2022 07:14:29 +0100
From:   Klaus Jensen <its@irrelevant.dk>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Hannes Reinecke <hare@suse.de>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        "Florescu, Andreea" <fandree@amazon.com>, hreitz@redhat.com,
        Alex Agache <aagch@amazon.com>,
        =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
Message-ID: <YhMtxWcFMjdQTioe@apples>
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="D1jVKPmCNvGXGCes"
Content-Disposition: inline
In-Reply-To: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--D1jVKPmCNvGXGCes
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Jan 28 15:47, Stefan Hajnoczi wrote:
> Dear QEMU, KVM, and rust-vmm communities,
> QEMU will apply for Google Summer of Code 2022
> (https://summerofcode.withgoogle.com/) and has been accepted into
> Outreachy May-August 2022 (https://www.outreachy.org/). You can now
> submit internship project ideas for QEMU, KVM, and rust-vmm!
>=20
> If you have experience contributing to QEMU, KVM, or rust-vmm you can
> be a mentor. It's a great way to give back and you get to work with
> people who are just starting out in open source.
>=20
> Please reply to this email by February 21st with your project ideas.
>=20
> Good project ideas are suitable for remote work by a competent
> programmer who is not yet familiar with the codebase. In
> addition, they are:
> - Well-defined - the scope is clear
> - Self-contained - there are few dependencies
> - Uncontroversial - they are acceptable to the community
> - Incremental - they produce deliverables along the way
>=20
> Feel free to post ideas even if you are unable to mentor the project.
> It doesn't hurt to share the idea!
>=20
> I will review project ideas and keep you up-to-date on QEMU's
> acceptance into GSoC.
>=20
> Internship program details:
> - Paid, remote work open source internships
> - GSoC projects are 175 or 350 hours, Outreachy projects are 30
> hrs/week for 12 weeks
> - Mentored by volunteers from QEMU, KVM, and rust-vmm
> - Mentors typically spend at least 5 hours per week during the coding per=
iod
>=20
> Changes since last year: GSoC now has 175 or 350 hour project sizes
> instead of 12 week full-time projects. GSoC will accept applicants who
> are not students, before it was limited to students.
>=20
> For more background on QEMU internships, check out this video:
> https://www.youtube.com/watch?v=3DxNVCX7YMUL8
>=20
> Please let me know if you have any questions!
>=20
> Stefan
>=20

Hi,

I'd like to revive the "NVMe Performance" proposal from Paolo and Stefan
=66rom two years ago.

  https://wiki.qemu.org/Internships/ProjectIdeas/NVMePerformance

I'd like to mentor, but since this is "iothread-heavy", I'd like to be
able to draw a bit on Stefan, Paolo if possible.


Klaus

--D1jVKPmCNvGXGCes
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEUigzqnXi3OaiR2bATeGvMW1PDekFAmITLbkACgkQTeGvMW1P
Dek0wAgAqvx5HIaOX9kOtHFkqxCHoHFh2MShUrm+yH4PotqoLyKuK6QlLvs+fAcV
ad8w3Q6TNznQQFKx7KBqehIIKtd1dztYzss7SEpMLEUh9inON7oEFBBfckxP3NUQ
jNWIJJgyi5A+NKkbgCGC2vP3ClJAIqwgHHZJRboPrkF/KIQkZ5tsrcfouXDGaRyX
g8C66sz2Pp2Vo7XlvdhQMoTB97/dzT0ZvZ/sXDHnn8YukRKb7kMvtDy0ckNTrd8f
fMaB1CtyV9yLMcsHyoaDBlCtuZ3BV7ogD4cn3xUW9pAsYjqUttFsCdxWVbtA4+y6
fdB8MEoFdJoaaPEgyGWB6Yn/QEkLpw==
=bKi3
-----END PGP SIGNATURE-----

--D1jVKPmCNvGXGCes--
