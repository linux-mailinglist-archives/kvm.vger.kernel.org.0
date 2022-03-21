Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F224E1EF1
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 03:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344126AbiCUCDX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Mar 2022 22:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238328AbiCUCDT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Mar 2022 22:03:19 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CA1160167;
        Sun, 20 Mar 2022 19:01:55 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C579D5C010A;
        Sun, 20 Mar 2022 22:01:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 20 Mar 2022 22:01:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=turner.link; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=uXQFEtZDztyGX9AqVl1DV7goVhiMjSgo2VCtiW
        c9Ki8=; b=ZARfCnE0qOE6r2TNSfo5JUnuSRgVMItuvc+hzB1EuKdG87zevOdYOk
        9e6856l2J2TYvMr2fhsC705gBJ23mlHBTJJkZ/Gcdcy0/xheFs6ICIHeN75PVT7G
        iqBs/4UWq/2EmZia8TPmlZr+nIYr08SGXpZw+GEdHRBlzOZl9dupzWOYcBePz2Cx
        GPSn1/ABJ6e0+IUeQA0k0lr8J4cdJwA8Dbbkn/Tx+ZkKBUU0XAtwAjQ0xlIIap2n
        7RaSw+DFsizjC/rjWVt/9omoPalsWtMXuI4+t/1KsqTRPxv7L7ybWVNH85YDbILs
        OWcNbZmEWhcEErBCdU1mvdV/WkUkcWwg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=uXQFEtZDztyGX9AqV
        l1DV7goVhiMjSgo2VCtiWc9Ki8=; b=QvSwI85adgO3ty/9m5FB9zLE9x3Gf/nOT
        /HD/CNxZtbczkOOuWaQjiSQO4TbxKPVGdoM6+ShctBBliwIXqbHPYEFkqjaK6xMt
        mOWdkmT2j7ZHatiEjjhUDZSnVzf7kMgvU5dd2hsgd3ig6OMPlr3adz5I8Z0PijKX
        QU5QE3cIpdjWZm31HD5uFg1dJsKwbYwjCursog3VM2ROlW0m7k7jmNL3NzzcUd3g
        agkIAR8dE3SDGp5PK4kYi3JLA5rjtG+eQm1TjLCuTDEPb21OuvdIG31G8pL2R0/O
        hKNfbTsPLOik9q/UJtw4sZguf3UIqZfLXb/+zHH+3zID41XBiqVDw==
X-ME-Sender: <xms:kNw3YvWHFKGgbMX_qpuRPJjMnzq5sqk6B92Ytu8ohIlwZ5Tk0f3xug>
    <xme:kNw3YnkdthuW8-IXpAeMrQSDgw6mOhr1TFD8sx4B0-VHt-IuZ4R2Z2YGLQt-k86XJ
    Djf2VrryevIDTA2zw>
X-ME-Received: <xmr:kNw3Yraa8XthFjCkwZQM_7o1VmzL-hHAO8DqjqBdFKhxmKAppVorfKkl2f09Z-JwV-WN7KcyRe_3TioUda3pQNN1-1OQx2EN6pQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudegvddggeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfhfhvffuffgjkfggtgesthdtredttddttdenucfhrhhomheplfgrmhgvshcu
    vfhurhhnvghruceolhhinhhugihkvghrnhgvlhdrfhhoshhssegumhgrrhgtqdhnohhnvg
    drthhurhhnvghrrdhlihhnkheqnecuggftrfgrthhtvghrnhepfffhveeugfevteeileej
    vdeltdegtdeggfeujefgveekueevkeehheehffduleevnecuffhomhgrihhnpegrrhgthh
    hlihhnuhigrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomheplhhinhhugihkvghrnhgvlhdrfhhoshhssegumhgrrhgtqdhnohhnvgdrth
    hurhhnvghrrdhlihhnkh
X-ME-Proxy: <xmx:kNw3YqXPiY-kEqyj9eZYEkRKkTK-VSv-wHKOmIigxQmuO2L9tKfDyw>
    <xmx:kNw3Yplrm6z9OuMM72uhI218UV6yFyOdpffW8AhGe3sojdx04sRa9w>
    <xmx:kNw3YnfiyoDDNxyJ4CnebyAfuUReEKaz4lJ2j4hjDHeACI3BuwBBtQ>
    <xmx:kNw3Yu-UqEZOZ0UEJSMqnW6mmSMsR5FIMcXZOJZHOpWluFpTx-vXTw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 20 Mar 2022 22:01:51 -0400 (EDT)
References: <87ee57c8fu.fsf@turner.link>
 <87sftfqwlx.fsf@dmarc-none.turner.link>
 <BYAPR12MB4614E2CFEDDDEAABBAB986A0975E9@BYAPR12MB4614.namprd12.prod.outlook.com>
 <87ee4wprsx.fsf@turner.link>
 <4b3ed7f6-d2b6-443c-970e-d963066ebfe3@amd.com>
 <87pmo8r6ob.fsf@turner.link>
 <5a68afe4-1e9e-c683-e06d-30afc2156f14@leemhuis.info>
 <CADnq5_MCKTLOfWKWvi94Q9-d5CGdWBoWVxEYL3YXOpMiPnLOyg@mail.gmail.com>
 <87pmnnpmh5.fsf@dmarc-none.turner.link>
 <CADnq5_NG_dQCYwqHM0umjTMg5Uud6zC4=MiscH91Y9v7mW9bJA@mail.gmail.com>
 <092b825a-10ff-e197-18a1-d3e3a097b0e3@leemhuis.info>
 <877d96to55.fsf@dmarc-none.turner.link> <87lexdw8gd.fsf@turner.link>
 <d541b534-8b83-b566-56eb-ea8baa7c998e@leemhuis.info>
 <40b3084a-11b8-0962-4b33-34b56d3a87a3@molgen.mpg.de>
 <bc714e87-d1dc-cdda-5a29-25820faaff40@leemhuis.info>
 <20220318084625.27d42a51.alex.williamson@redhat.com>
 <CADnq5_OE7JpffYggKsu92DAjur1CCSqZQ7LbMqcfmAk68FerDA@mail.gmail.com>
 <20220318092552.518a50ef.alex.williamson@redhat.com>
From:   James Turner <linuxkernel.foss@dmarc-none.turner.link>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Alex Deucher <alexdeucher@gmail.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Xinhui Pan <Xinhui.Pan@amd.com>, regressions@lists.linux.dev,
        kvm@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Lijo Lazar <lijo.lazar@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Christian =?utf-8?Q?K=C3=B6nig?= <Christian.Koenig@amd.com>
Subject: Re: [REGRESSION] Too-low frequency limit for AMD GPU
 PCI-passed-through to Windows VM
Date:   Sun, 20 Mar 2022 21:26:51 -0400
In-reply-to: <20220318092552.518a50ef.alex.williamson@redhat.com>
Message-ID: <87mthkkqr4.fsf@turner.link>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>>> Right, interference from host drivers and pre-boot environments is
>>> always a concern with GPU assignment in particular. AMD GPUs have a
>>> long history of poor behavior relative to things like PCI secondary
>>> bus resets which we use to try to get devices to clean, reusable
>>> states for assignment. Here a device is being bound to a host driver
>>> that initiates some sort of power control, unbound from that driver
>>> and exposed to new drivers far beyond the scope of the kernel's
>>> regression policy. Perhaps it's possible to undo such power control
>>> when unbinding the device, but it's not necessarily a given that
>>> such a thing is possible for this device without a cold reset.
>>>
>>> IMO, it's not fair to restrict the kernel from such advancements. If
>>> the use case is within a VM, don't bind host drivers. It's difficult
>>> to make promises when dynamically switching between host and
>>> userspace drivers for devices that don't have functional reset
>>> mechanisms.

To clarify, the GPU is never bound to the `amdgpu` driver on the host.
I'm binding it to `vfio-pci` on the host at boot, specifically to avoid
issues with dynamic rebinding. To do this, I'm passing
`vfio-pci.ids=1002:6981,1002:aae0` on the kernel command line, and I've
confirmed that this option is working:

% lspci -nnk -d 1002:6981
01:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Lexa XT [Radeon PRO WX 3200] [1002:6981]
	Subsystem: Dell Device [1028:0926]
	Kernel driver in use: vfio-pci
	Kernel modules: amdgpu

% lspci -nnk -d 1002:aae0
01:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Baffin HDMI/DP Audio [Radeon RX 550 640SP / RX 560/560X] [1002:aae0]
	Subsystem: Dell Device [1028:0926]
	Kernel driver in use: vfio-pci
	Kernel modules: snd_hda_intel

Starting with
f9b7f3703ff9 ("drm/amdgpu/acpi: make ATPX/ATCS structures global (v2)")
this is insufficient for the GPU to work properly in the VM, since the
`amdgpu` module is calling global ACPI methods which affect the GPU even
though it's not bound to the `amdgpu` driver.

>> Additionally, operating the isolated device in a VM on a constrained
>> environment like a laptop may have other adverse side effects.  The
>> driver in the guest would ideally know that this is a laptop and needs
>> to properly interact with APCI to handle power management on the
>> device.  If that is not the case, the driver in the guest may end up
>> running the device out of spec with what the platform supports.  It's
>> also likely to break suspend and resume, especially on systems which
>> use S0ix since the firmware will generally only turn off certain power
>> rails if all of the devices on the rails have been put into the proper
>> state.  That state may vary depending on the platform requirements.

Fwiw, the guest Windows AMD driver can tell that it's a mobile GPU, and
as a result, the driver GUI locks various performance parameters to the
defaults. The cooling system and power supply seem to work without
issues. As the load on the GPU increases, the fan speed increases. The
GPU stays below the critical temperature with plenty of margin, even at
100% load. The voltage reported by the GPU adjusts with the load, and I
haven't experienced any glitches which would suggest that the GPU is not
getting enough power or something. I haven't tried suspend/resume.

What are the differences between a laptop and desktop, aside from the
size of the cooling system? Could the issue reported here affect desktop
systems, too?

As far as what to do for this issue: Personally, I don't mind
blacklisting `amdgpu` on my machine. My primary concerns are:

1. Other users may experience this issue and have trouble figuring out
   what's happening, or they may not even realize that they're
   experiencing significantly-lower-than-expected performance.

2. It's possible that this issue affects some machines which use an AMD
   GPU for the host and a second AMD GPU for the guest. For those
   machines, blacklisting `amdgpu` would not be an option, since that
   would disable the AMD GPU for the host.

I've tried to help with concern 1 by mentioning this issue on the Arch
Linux Wiki [1]. Another thing that would help is to print a warning
message to the kernel ring buffer when an AMD GPU is bound to `vfio-pci`
and the `amdgpu` module is loaded. (It would say something like,
"Although the <GPU_NAME> device is bound to `vfio-pci`, loading the
`amdgpu` module may still affect it via ACPI. Consider blacklisting
`amdgpu` if the GPU does not behave as expected.")

I'm not sure if there's any way to address concern 2, aside from fixing
the firmware / Windows AMD driver.

I thought of one more thing I could test -- I could try a Linux guest
instead of a Windows guest to determine if the issue is due to the
firmware or the guest Windows AMD driver. Would that be helpful?

[1]: https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF#Too-low_frequency_limit_for_AMD_GPU_passed-through_to_virtual_machine

James
