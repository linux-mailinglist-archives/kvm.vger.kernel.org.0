Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8CB2FA223
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 14:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404625AbhARNjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 08:39:15 -0500
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:54887 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404618AbhARNjD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 08:39:03 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 330AC1660;
        Mon, 18 Jan 2021 08:38:15 -0500 (EST)
Received: from imap1 ([10.202.2.51])
  by compute6.internal (MEProxy); Mon, 18 Jan 2021 08:38:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type:content-transfer-encoding; s=fm1; bh=k1mhz
        fATNT9R6DArKVul7Ge0zcThqls3LajWZsnCZ2M=; b=Yq5ZAPe8+7elKI8yzam6A
        f+xMu/SkR3g5itwu8nsPhQ2GzqXHu/3SdV2J54yneIfmjoMrcuKBoeiBGMgxeIoT
        7ub5upZx1lcHWDxgnjXGyP+Xa2sraH+fXespCRXS0rjsA5leuVHnOwpA9GazQRwd
        fHUYFnUDmUDnwxUE61oUGmDH0X+sWqFTpbUNlziursrg2H9UxRFb9kz9z71Z0aOq
        fKziXHQj7QUna/0ynL1r81Dwm3pqmbNFoBVFFzahJP9d8kBwFAJrYBk+VAh5ZnkC
        0uUZFMNEiW0pHegfOsubEC+o9r0Wo33ba0EUkYCEQitSlUDKUR73EZy1zvyyvIbZ
        Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=k1mhzfATNT9R6DArKVul7Ge0zcThqls3LajWZsnCZ
        2M=; b=rGHWsd5jB9SBOYU2G9WV19IYTvJ2mkkTAtN9Khm/7+Kf3+UqhwiWb2Wwg
        DIwYo4s7iJRO/xcB0yNfqFCD7cZF9OikysYYhIZ2zpJc15OlwZYgaw0V1/a8jSg8
        7SRuFRWbIO8CBdIwWwr/Zz6MMBeHN8WKchhQ7cOjSNF8H+L/ELD/3T0l1yOLRjm5
        1FMq8szOH77RaJCVSiD0pfLMfJqP/T7uO1I1y2PydqV54NmVBzXhhSd1Z8KIPgOz
        z6v6PVdeLwYF852DGBeIurbp833ZeV0dEyIEUN3PflCwAVo+IPLC1e7PzwBZBMSB
        /jVmyEgsUExg+kGG3NC4+593ULL+g==
X-ME-Sender: <xms:RI8FYD1oG49NjUqSnTp1IJK8wWJoju8MV0TNJ9ewdX1qWUq4-1_jPQ>
    <xme:RI8FYCFMhNQkQ39rVyh-_QGP4RYfJvPsfbLQWkKMEW5B5ZO9SDOdxI6D0nCGWVOaD
    ds6TL8RJ2qg7DBni4E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdekgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtgfesthhqredtreerjeenucfhrhhomhepfdflihgr
    gihunhcujggrnhhgfdcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqe
    enucggtffrrghtthgvrhhnpeefteegkeevfeethffgudehgedvueduvdeifedvvdelhfef
    heekteefueektdefjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:RI8FYD5ohhypol032FUHZ0ANchk4431xVRISyEL1SoFFNKE4UOYJwQ>
    <xmx:RI8FYI2C7Qg-QWrANXpKBSLBLDzdUMwVvdTCf2hSr2mnD4GuwIZJYA>
    <xmx:RI8FYGEIqwyWw9RZXE49AOxiBzOp0Em6ing082TGZ-fpGAzFFkvxow>
    <xmx:Ro8FYEHDAar9kcNobc2cLZnd22WL447kxH4PAaUynYiWDE1ep1auyxzG8SuAONbi>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id B8FAEC200A6; Mon, 18 Jan 2021 08:38:12 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-45-g4839256-fm-20210104.001-g48392560
Mime-Version: 1.0
Message-Id: <fb7308f2-ecc7-48b8-9388-91fd30691767@www.fastmail.com>
In-Reply-To: <20210118101159.GC1789637@redhat.com>
References: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
 <20210118063808.12471-10-jiaxun.yang@flygoat.com>
 <20210118101159.GC1789637@redhat.com>
Date:   Mon, 18 Jan 2021 21:37:49 +0800
From:   "Jiaxun Yang" <jiaxun.yang@flygoat.com>
To:     =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc:     "BALATON Zoltan via" <qemu-devel@nongnu.org>,
        "Fam Zheng" <fam@euphon.net>,
        "Laurent Vivier" <lvivier@redhat.com>,
        "Thomas Huth" <thuth@redhat.com>,
        "Viktor Prutyanov" <viktor.prutyanov@phystech.edu>,
        kvm@vger.kernel.org,
        =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
        "Alistair Francis" <alistair@alistair23.me>,
        "Greg Kurz" <groug@kaod.org>,
        "Wainer dos Santos Moschetta" <wainersm@redhat.com>,
        "Max Reitz" <mreitz@redhat.com>, qemu-ppc@nongnu.org,
        "Kevin Wolf" <kwolf@redhat.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>, qemu-block@nongnu.org,
        =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "David Gibson" <david@gibson.dropbear.id.au>
Subject: Re: [PATCH v2 9/9] gitlab-ci: Add alpine to pipeline
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On Mon, Jan 18, 2021, at 6:11 PM, Daniel P. Berrang=C3=A9 wrote:
> On Mon, Jan 18, 2021 at 02:38:08PM +0800, Jiaxun Yang wrote:
> > We only run build test and check-acceptance as their are too many
> > failures in checks due to minor string mismatch.
>=20
> Can you give real examples of what's broken here, as that sounds
> rather suspicious, and I'm not convinced it should be ignored.

Mostly Input/Output error vs I/O Error.

- Jiaxun
