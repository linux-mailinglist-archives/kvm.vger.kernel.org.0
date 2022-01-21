Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33D0495833
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 03:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378499AbiAUCWq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 21:22:46 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34885 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348465AbiAUCWp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jan 2022 21:22:45 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 99EBD5C00ED;
        Thu, 20 Jan 2022 21:22:44 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 20 Jan 2022 21:22:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=turner.link; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; bh=4XU/BlLV/TXBXQh4V2w5kzAu/G0xNQpyok0qRK
        am/ys=; b=RaqvGWH6PnR5Xx0addhwKwQ31sKikf8I6iHUsTL+5beOkeqThjXYyH
        V0nTu8KvZ3quTvew0+mCaBBN6geH+v+LePk7VMms/NfNgjT4TMKT0cMxp8sE11De
        /PmIxLr5eULrgPxz8yj9IyH6m2x5tzB+uKVrsnnyWLLD5SC5/8E4PwxEIwnm9bxu
        +VyNBHJo6bMpwACb81O072ghmRRfHNQnOi7LLyMvBExWiAULzKwCzBLO6GXURn18
        In9xx8LiagR/nR9VOtDq5lj9m0Vxx1R/WhMsf97fsWen6tXbH5mc9kaE3nYkoN6D
        vnoYAV6dOw/Z9NQH4EmU2k9CoeJFT8dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=4XU/BlLV/TXBXQh4V
        2w5kzAu/G0xNQpyok0qRKam/ys=; b=OQ/ub9RsnAR9lfA29lmzvM67sJ7cF676o
        YtjiFZfi/fIzoMqw334oGW82bmmXCL6/SJE1k5IT1Y1fCjH6myQ2sSLfZzn2BZ8V
        VXAGdyk6Eq4A+PjL/BXNtZ8CXHh16SoO8fBaNijennjAvAjBBmbiGEk9B8/YZyEL
        /8YWehitQsncYfM3nwjRSU44vASKMYnVlBqOynU/ZiaKgbtfBYtQyzUAuRt4h+8N
        KBOzRp+HDvXgBm2KO+ZF9Di2i2kwoTkR8tmLlBQVmnQVQq6apMuT4lKH96ePbu63
        l96U27cPeYhUi905PvYQDdoecTwbtCdx6FPBm3lUKn/cZB3wOieQg==
X-ME-Sender: <xms:9BjqYUV5emhHXzwBL-syRrJQ1WMDZvrRD7bmaNcproVLA51rFpcqiA>
    <xme:9BjqYYm8q266rqP7Nx35443sPsM64uQHM859dHHSl79yL9Tv6GvdHT1nNwHRDEV3P
    ocqRwuJ3LS16Y7zjA>
X-ME-Received: <xmr:9BjqYYa0Lv7s7eeMFS2eUL3GZPUhEt7YTEcFgDrq2NOtSDnq0L15g84mhiB3>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudelgdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpehfhffvufffjgfkgggtsehttdertddttddtnecuhfhrohhmpeflrghmvghsucfv
    uhhrnhgvrhcuoehlihhnuhigkhgvrhhnvghlrdhfohhsshesughmrghrtgdqnhhonhgvrd
    htuhhrnhgvrhdrlhhinhhkqeenucggtffrrghtthgvrhhnpefhkeehvdevfeeiteeitdeh
    jeejgfegffduuefhveehhfelgefgteejuefhieetjeenucffohhmrghinhepfhhrvggvug
    gvshhkthhophdrohhrghdpkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgep
    tdenucfrrghrrghmpehmrghilhhfrhhomheplhhinhhugihkvghrnhgvlhdrfhhoshhsse
    gumhgrrhgtqdhnohhnvgdrthhurhhnvghrrdhlihhnkh
X-ME-Proxy: <xmx:9BjqYTWtfhTO2pKPexWTjil-GwrP_4QTbil42VwQB1kec4uCYmL0Mg>
    <xmx:9BjqYekhrWicn6C34ZdkjAyS5QVIwda2xJPGc5ni54eAA8rfHjjCGA>
    <xmx:9BjqYYdi4e85OYOf9LJ2lADF8VAseab9w8Fp1N99Ne5tFrHBrJVkrg>
    <xmx:9BjqYQV7kTGp27gB_sKdMTHAKcYIPVe300y2gr2ZUZWKBKwm1b_GiA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 20 Jan 2022 21:22:44 -0500 (EST)
References: <87ee57c8fu.fsf@turner.link>
 <acd2fd5e-d622-948c-82ef-629a8030c9d8@leemhuis.info>
 <87a6ftk9qy.fsf@dmarc-none.turner.link>
From:   James Turner <linuxkernel.foss@dmarc-none.turner.link>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, regressions@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] Too-low frequency limit for AMD GPU
 PCI-passed-through to Windows VM
Date:   Thu, 20 Jan 2022 21:13:06 -0500
In-reply-to: <87a6ftk9qy.fsf@dmarc-none.turner.link>
Message-ID: <87zgnp96a4.fsf@turner.link>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

I finished the bisection (log below). The issue was introduced in
f9b7f3703ff9 ("drm/amdgpu/acpi: make ATPX/ATCS structures global (v2)").

Would any additional information be helpful?

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
# good: [f43ae2d1806c2b8a0934cb4acddd3cf3750d10f8] drm/amdgpu: Fix inconsistent indenting
git bisect good f43ae2d1806c2b8a0934cb4acddd3cf3750d10f8
# good: [6566cae7aef30da8833f1fa0eb854baf33b96676] drm/amd/display: fix odm scaling
git bisect good 6566cae7aef30da8833f1fa0eb854baf33b96676
# good: [5ac1dd89df549648b67f4d5e3a01b2d653914c55] drm/amd/display/dc/dce/dmub_outbox: Convert over to kernel-doc
git bisect good 5ac1dd89df549648b67f4d5e3a01b2d653914c55
# good: [a76eb7d30f700e5bdecc72d88d2226d137b11f74] drm/amd/display/dc/dce110/dce110_hw_sequencer: Include header containing our prototypes
git bisect good a76eb7d30f700e5bdecc72d88d2226d137b11f74
# good: [dd1d82c04e111b5a864638ede8965db2fe6d8653] drm/amdgpu/swsmu/aldebaran: fix check in is_dpm_running
git bisect good dd1d82c04e111b5a864638ede8965db2fe6d8653
# bad: [f9b7f3703ff97768a8dfabd42bdb107681f1da22] drm/amdgpu/acpi: make ATPX/ATCS structures global (v2)
git bisect bad f9b7f3703ff97768a8dfabd42bdb107681f1da22
# good: [f1688bd69ec4b07eda1657ff953daebce7cfabf6] drm/amd/amdgpu:save psp ring wptr to avoid attack
git bisect good f1688bd69ec4b07eda1657ff953daebce7cfabf6
# first bad commit: [f9b7f3703ff97768a8dfabd42bdb107681f1da22] drm/amdgpu/acpi: make ATPX/ATCS structures global (v2)

James
