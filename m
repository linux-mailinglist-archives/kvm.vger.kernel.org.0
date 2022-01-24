Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B2449A66E
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 03:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345711AbiAYB6S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 20:58:18 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:60353 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S3414335AbiAYAot (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 19:44:49 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 8BAC1580389;
        Mon, 24 Jan 2022 19:44:48 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 24 Jan 2022 19:44:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=turner.link; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; bh=Hg+/kJzRpMwyU8RBBG9lM29Q4G3SCNyE5PQExK
        Qjrjg=; b=BqhV2/LX+jA/ib0C3suNSFwh8doiJauUSvPVxk+uBbNEorrAZbP1iR
        5gNpFk2LgQ7cLfef4t7YtlVJSeAE1tg7pNCtVRYvd5IfU96XR2wTMxWkt5EgqN5O
        xbZYT20AVlZSDY6PPGchtxHvVVZxZh+6cPw4ahe/8gK2gmshQA7Rb5oAruoy5iD9
        0lpJlFpQzx8xBboXOi81OZfCQl5D2CoNFJMi4EUzEbEORp5XHpGY1Ae0zEJQFMcG
        irXojU99SQzfbYshiyxeHeKgyKApQLq43HdA+0p7iRoIL+aYSMhIDLLINo475C4T
        JiMKE71bQGkV8LTe7hWUbRgrjFnaiyOg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Hg+/kJzRpMwyU8RBB
        G9lM29Q4G3SCNyE5PQExKQjrjg=; b=NnF9YKvTgV+/CzqonPrhH6bqt2WlJ4u/V
        0e5EIJr4hxAwC9+fPKCyjMjLQFL7qrbjxjXFIPrdrUTGfM7J6s3SHwnq67rYY35f
        AAdyTDYdeqWTj4LCnd+TZ70KSgKLAVdSglmbXgwa+ajA6n/uUMX1EpFmSlYkwj/D
        w8Xjd3ybbGdoY1DGBiQn2dxoQV8DpbD0T3IQ2uw6cxeFgp9p/TCwyaO+BhzpE0mF
        LxR/XD6IxXdjTGUUAozzYQknbIZf0gvWcm4ExzybZRggNr/xbIys/rnbBcng0jOh
        pyPxkrjIS0E8x1ywdW+MBOVpvlDmppAIOE3MijQ16LRpMyXnYn9Yw==
X-ME-Sender: <xms:_0fvYQ-EfYy1x8ckLKQOASpfF1f8VG1P-YWrZzzpxTHBK9WYhNxFsA>
    <xme:_0fvYYvQ4J3beV2uRjLa31Bh_ODGeg6dL4-lMaqx4Up28gOo3QlSTswv6YiD-Vtpg
    IJHUY5k-MA4iSAy4w>
X-ME-Received: <xmr:_0fvYWAFmvUzQxh0iBiGiqD4fBbfMq3-4nNy1vMXlMHn1BXiEot-KL-OXqPk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrvdekgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpehfhffvufffjgfkgggtsehttdertddttddtnecuhfhrohhmpeflrghmvghsucfv
    uhhrnhgvrhcuoehlihhnuhigkhgvrhhnvghlrdhfohhsshesughmrghrtgdqnhhonhgvrd
    htuhhrnhgvrhdrlhhinhhkqeenucggtffrrghtthgvrhhnpeetvdefudehieeufefghfdv
    teeitddtvefhieetuefhleevudevtddtfffggffgteenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehlihhnuhigkhgvrhhnvghlrdhfohhsshes
    ughmrghrtgdqnhhonhgvrdhtuhhrnhgvrhdrlhhinhhk
X-ME-Proxy: <xmx:AEjvYQf2y2zGcFgoCWUciNn9b9e2Ec0Y-WL5xhNm2ABYSv_7GMV4IA>
    <xmx:AEjvYVPPma5oQKL6quJ8Jk66URimEX_lrvguofqERLdCMTYsPQQsZQ>
    <xmx:AEjvYal0LCNI_T_XPDgs4DgaDQO3NOORXHUTsx1RGMbZkpFy197sug>
    <xmx:AEjvYbv6u5vmUwQ8EAKjckw9E1-Hpdolaz4WyHTPJldFQw-3yZxqSQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Jan 2022 19:44:47 -0500 (EST)
References: <87ee57c8fu.fsf@turner.link>
 <acd2fd5e-d622-948c-82ef-629a8030c9d8@leemhuis.info>
 <87a6ftk9qy.fsf@dmarc-none.turner.link> <87zgnp96a4.fsf@turner.link>
 <fc2b7593-db8f-091c-67a0-ae5ffce71700@leemhuis.info>
 <CADnq5_Nr5-FR2zP1ViVsD_ZMiW=UHC1wO8_HEGm26K_EG2KDoA@mail.gmail.com>
 <87czkk1pmt.fsf@dmarc-none.turner.link>
 <BYAPR12MB46140BE09E37244AE129C01A975C9@BYAPR12MB4614.namprd12.prod.outlook.com>
 <87sftfqwlx.fsf@dmarc-none.turner.link>
 <BYAPR12MB4614E2CFEDDDEAABBAB986A0975E9@BYAPR12MB4614.namprd12.prod.outlook.com>
From:   James Turner <linuxkernel.foss@dmarc-none.turner.link>
To:     "Lazar, Lijo" <Lijo.Lazar@amd.com>
Cc:     Alex Deucher <alexdeucher@gmail.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>
Subject: Re: [REGRESSION] Too-low frequency limit for AMD GPU
 PCI-passed-through to Windows VM
Date:   Mon, 24 Jan 2022 18:58:10 -0500
In-reply-to: <BYAPR12MB4614E2CFEDDDEAABBAB986A0975E9@BYAPR12MB4614.namprd12.prod.outlook.com>
Message-ID: <87ee4wprsx.fsf@turner.link>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Lijo,

> Not able to relate to how it affects gfx/mem DPM alone. Unless Alex
> has other ideas, would you be able to enable drm debug messages and
> share the log?

Sure, I'm happy to provide drm debug messages. Enabling everything
(0x1ff) generates *a lot* of log messages, though. Is there a smaller
subset that would be useful? Fwiw, I don't see much in the full drm logs
about the AMD GPU anyway; it's mostly about the Intel GPU.

All the messages in the system log containing "01:00" or "1002:6981" are
identical between the two versions.

I've posted below the only places in the logs which contain "amd". The
commit with the issue (f9b7f3703ff9) has a few drm log messages from
amdgpu which are not present in the logs for f1688bd69ec4.


# f1688bd69ec4 ("drm/amd/amdgpu:save psp ring wptr to avoid attack")

[drm] amdgpu kernel modesetting enabled.
vga_switcheroo: detected switching method \_SB_.PCI0.GFX0.ATPX handle
ATPX version 1, functions 0x00000033
amdgpu: CRAT table not found
amdgpu: Virtual CRAT table created for CPU
amdgpu: Topology: Add CPU node


# f9b7f3703ff9 ("drm/amdgpu/acpi: make ATPX/ATCS structures global (v2)")

[drm] amdgpu kernel modesetting enabled.
vga_switcheroo: detected switching method \_SB_.PCI0.GFX0.ATPX handle
ATPX version 1, functions 0x00000033
[drm:amdgpu_atif_pci_probe_handle.isra.0 [amdgpu]] Found ATIF handle \_SB_.PCI0.GFX0.ATIF
[drm:amdgpu_atif_pci_probe_handle.isra.0 [amdgpu]] ATIF version 1
[drm:amdgpu_acpi_detect [amdgpu]] SYSTEM_PARAMS: mask = 0x6, flags = 0x7
[drm:amdgpu_acpi_detect [amdgpu]] Notification enabled, command code = 0xd9
amdgpu: CRAT table not found
amdgpu: Virtual CRAT table created for CPU
amdgpu: Topology: Add CPU node


Other things I'm willing to try if they'd be useful:

- I could update to the 21.Q4 Radeon Pro driver in the Windows VM. (The
  21.Q3 driver is currently installed.)

- I could set up a Linux guest VM with PCI passthrough to compare to the
  Windows VM and obtain more debugging information.

- I could build a kernel with a patch applied, e.g. to disable some of
  the changes in f9b7f3703ff9.

James
