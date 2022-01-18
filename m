Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C46491D2E
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 04:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352083AbiARD0f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 22:26:35 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:58215 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348467AbiARDXV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 22:23:21 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id EDE4732007F9;
        Mon, 17 Jan 2022 22:23:18 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 17 Jan 2022 22:23:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=turner.link; h=
        references:from:to:cc:subject:date:in-reply-to:message-id
        :mime-version:content-type; s=fm1; bh=GzsJPLk0WQC7EG+Ldejqutyl0x
        GDNSzs8Fui0V7sUQo=; b=fs3Daa+DjKJ6E50ffeCnCe0frj8Ykq5LYCzvt6gisF
        YhtuVVtoJPFegxI6IeYp4BPcvPPiOwrlCFY57AwVg5A26q4uzjAx8lMURK1//ftO
        ESuB7BxODj3kZcpcXqv+bSxlPXF3/7vzX6GYbWPGUMQoJ/8vlybiZ8S2exg5aspw
        ZNkuyLHFus6hTlMFCZd1tVsgGrwiS/flmqQYf2cConVPeCvGFuGCjTv6at2wOxCH
        vQBR3fg4+V97O0TnmbKaPk3tLs7Ja7Jyr6jrqab/00w24nSiRGco9+CtOhCkFrlu
        iVv+iSGXkoZugfjBwLJSBFjVUjTsGOgUzNjrT5gmpVZg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=GzsJPL
        k0WQC7EG+Ldejqutyl0xGDNSzs8Fui0V7sUQo=; b=WwZGFHf2grx6ZmEe0xmZOV
        sfxvZTYjW3SfWujBY8QxA1y+vvuT/QZglOsHRDSev7UCMynLPHFEGVW20abvPGOt
        HHsjlLjLrTwOuNTuH3hwG1HvUyr9fAW+U0aEwuGb0Kw3hNVFpduE+cuMVJrf1s9n
        kQQtpYOAWgFYZXRE6T7V2kpIA1mn15V1sNCg6aTDQhKpkszWd2RaX1ULgUN/5VMS
        6x+IFXYgdmHN0dl3Beg3TCcyiYyBcvasXpXkmSV3F267ZM+OnwepO1u531jmUmEp
        VUMucD56QomHP6SeWi8eevWiCsV1yFeTeWvBWgB1a3O0wTuCNEiNeHwr7KgrEiQQ
        ==
X-ME-Sender: <xms:pjLmYWfyMSdP0UrPHoxdjFok6pnhj9g_4T0tqSxZKhNdY67xiiHmEQ>
    <xme:pjLmYQPc9qBJb1q6A6GVdldxqXxQb8FOf5EPtJ4J_NkCjHShkN_U3blXwCBtWfGdy
    cFd_e10yC6gSycwmQ>
X-ME-Received: <xmr:pjLmYXi36rYWy7DZBsD-qVNiq9RZOGmywwq-_2bJNB7el89EROyO1_bcGkm4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddvgdehkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpehfhffvufffjgfkgggtsehttdertddttddtnecuhfhrohhmpeflrghmvghsucfv
    uhhrnhgvrhcuoehlihhnuhigkhgvrhhnvghlrdhfohhsshesughmrghrtgdqnhhonhgvrd
    htuhhrnhgvrhdrlhhinhhkqeenucggtffrrghtthgvrhhnpefhkeehvdevfeeiteeitdeh
    jeejgfegffduuefhveehhfelgefgteejuefhieetjeenucffohhmrghinhepfhhrvggvug
    gvshhkthhophdrohhrghdpkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgep
    tdenucfrrghrrghmpehmrghilhhfrhhomheplhhinhhugihkvghrnhgvlhdrfhhoshhsse
    gumhgrrhgtqdhnohhnvgdrthhurhhnvghrrdhlihhnkh
X-ME-Proxy: <xmx:pjLmYT9aSTo3EeqXIQs4Zt000vybDbPZJugOCABfYt1AzWERO9aYuA>
    <xmx:pjLmYSvLp8jiDhmTQRuYCHaOHb39Z11qOouwZYHP4dK7inTGJwYhIA>
    <xmx:pjLmYaG_hEZehwevx4Uv8QYuaNxlGgIXySN7guW8UW-NPN7YgALpIg>
    <xmx:pjLmYWi_rHmnWh5wIwZ0hs6h30hu7YxAE6UpiDR4UICf0piXYcBsiw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 17 Jan 2022 22:23:17 -0500 (EST)
References: <87ee57c8fu.fsf@turner.link>
 <acd2fd5e-d622-948c-82ef-629a8030c9d8@leemhuis.info>
From:   James Turner <linuxkernel.foss@dmarc-none.turner.link>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        regressions@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] Too-low frequency limit for AMD GPU
 PCI-passed-through to Windows VM
Date:   Mon, 17 Jan 2022 22:14:19 -0500
In-reply-to: <acd2fd5e-d622-948c-82ef-629a8030c9d8@leemhuis.info>
Message-ID: <87a6ftk9qy.fsf@dmarc-none.turner.link>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I finished about half of the bisection process today. The log so far is
below. I'll follow up again once I've narrowed it down to a single
commit.

git bisect start
# bad: [e73f0f0ee7541171d89f2e2491130c7771ba58d3] Linux 5.14-rc1
git bisect bad e73f0f0ee7541171d89f2e2491130c7771ba58d3
# good: [62fb9874f5da54fdb243003b386128037319b219] Linux 5.13
git bisect good 62fb9874f5da54fdb243003b386128037319b219
# bad: [e058a84bfddc42ba356a2316f2cf1141974625c9] Merge tag 'drm-next-2021-07-01' of git://anongit.freedesktop.org/drm/drm
git bisect bad e058a84bfddc42ba356a2316f2cf1141974625c9
# good: [a6eaf3850cb171c328a8b0db6d3c79286a1eba9d] Merge tag 'sched-urgent-2021-06-30' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good a6eaf3850cb171c328a8b0db6d3c79286a1eba9d
# good: [007b312c6f294770de01fbc0643610145012d244] Merge tag 'mac80211-next-for-net-next-2021-06-25' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next
git bisect good 007b312c6f294770de01fbc0643610145012d244
# bad: [18703923a66aecf6f7ded0e16d22eb412ddae72f] drm/amdgpu: Fix incorrect register offsets for Sienna Cichlid
git bisect bad 18703923a66aecf6f7ded0e16d22eb412ddae72f
# good: [c99c4d0ca57c978dcc2a2f41ab8449684ea154cc] Merge tag 'amd-drm-next-5.14-2021-05-19' of https://gitlab.freedesktop.org/agd5f/linux into drm-next
git bisect good c99c4d0ca57c978dcc2a2f41ab8449684ea154cc
# good: [43ed3c6c786d996a264fcde68dbb36df6f03b965] Merge tag 'drm-misc-next-2021-06-01' of git://anongit.freedesktop.org/drm/drm-misc into drm-next
git bisect good 43ed3c6c786d996a264fcde68dbb36df6f03b965
# bad: [050cd3d616d96c3a04f4877842a391c0a4fdcc7a] drm/amd/display: Add support for SURFACE_PIXEL_FORMAT_GRPH_ABGR16161616.
git bisect bad 050cd3d616d96c3a04f4877842a391c0a4fdcc7a

James
