Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992F6496E1D
	for <lists+kvm@lfdr.de>; Sat, 22 Jan 2022 22:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234934AbiAVVix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jan 2022 16:38:53 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:60923 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230339AbiAVViw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 22 Jan 2022 16:38:52 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id B31AA5802A6;
        Sat, 22 Jan 2022 16:38:51 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sat, 22 Jan 2022 16:38:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=turner.link; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; bh=MsViZzLF8Kq6HOdr8iHnwG72oVaccjfy8JbG24
        /A8XM=; b=BaVO64CFNCl14UaN1iXZ5HD7QFcdTRYaBRpbTDciSr3gyP7ujk9Vmx
        B6MFRCT6GKfuvsr1QiJ1eMtFE6ZW/uNTPhsiZPKd3IY0ElAcB0ubjGQ7IEIymtQh
        n+1xCJy1RqQljRrRi1yK2mwhbu2P2Vb+1VCIRe2ROLWAgPrMffBYfTFyFIxX/oNw
        /uAfakYLKqROBYc/XHjL3PwjpignZkAao/QvG7DrQV6WpBTgJj0y0HdFbK/PjNOo
        oQiDUtXYZ/wmIaSShFoZ0AR078ztRtk7kGnKTYH3LsNlaqUFjgL9TzbWdfXDlHQf
        4+3rMHNmnPmPwR9PQV5kyZdSm8pAcUOw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=MsViZzLF8Kq6HOdr8
        iHnwG72oVaccjfy8JbG24/A8XM=; b=KFEkrIVKNzlC5WO9zT68QI+pffxmYHKRl
        +TcDFrUZh+xL1dRc/ucNnZwGca1Y8k2XKK7IWMwvBAQurhqBlfjBAtJHX03pkC0h
        3Qckz2ghniY4pisdXEjke+rB4D6PB6TX5rHFTlEgniQzN4UTrV0NDDJospwgetE7
        2IVmniPay70zbZZxGotOff1f/NqNYNWBeVeO/wRqIgxzPVd/V0qTKq/eQWJjw5Vc
        Ilnakbupl0/9zqz3UneLsDrJu3rPi+BciK/ssHG+c3rgjInUNKHj0kAE/F4JkbbQ
        fQu3Z1QpA7n54ldPxk2wihngZVnCW8R71TGb8ndikvw5EWK1YRQEw==
X-ME-Sender: <xms:a3nsYRcAVeLoznYBFOIN9rAomBHI__VSU3Q9KBKlCzAfhPJ3UP7uCg>
    <xme:a3nsYfPPbwuqtLAxyO89nP-9SbFv8pVsJ4YEFomX08lU8Ocd97NYJqgObR0gHbAcq
    dmx9JdtHiVc4BRs7Q>
X-ME-Received: <xmr:a3nsYag01LgO-MrezA50wVPoMpLgXXcd4u71q_Gml9S5iRZwpWiG0tH0GnHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrvddvgdduhedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfhfhvffuffgjkfggtgesthdtredttddttdenucfhrhhomheplfgrmhgvshcu
    vfhurhhnvghruceolhhinhhugihkvghrnhgvlhdrfhhoshhssegumhgrrhgtqdhnohhnvg
    drthhurhhnvghrrdhlihhnkheqnecuggftrfgrthhtvghrnheptedvfeduheeiueefgffh
    vdetiedttdevhfeiteeuhfelveduvedttdffgffggfetnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheplhhinhhugihkvghrnhgvlhdrfhhoshhs
    segumhgrrhgtqdhnohhnvgdrthhurhhnvghrrdhlihhnkh
X-ME-Proxy: <xmx:a3nsYa_HbNlh01OToipZGyFTiZrDRc15AEX9OKOAv4UqcdFsrSfvIg>
    <xmx:a3nsYdsDUGLZZHE5gStW8bNSqOmEeoYU0FvXNgdVn-7KaU1MwdaS7g>
    <xmx:a3nsYZECU7jeWJJqxgXEsSeqAXlz6MNXqWMSCQBZG4LLivcwQBjRSQ>
    <xmx:a3nsYeOYkJCmJ45IwgFYSH84jAHm5CKnMkMX9QQqZC7a3hdeigzGww>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 22 Jan 2022 16:38:51 -0500 (EST)
References: <87ee57c8fu.fsf@turner.link>
 <acd2fd5e-d622-948c-82ef-629a8030c9d8@leemhuis.info>
 <87a6ftk9qy.fsf@dmarc-none.turner.link> <87zgnp96a4.fsf@turner.link>
 <fc2b7593-db8f-091c-67a0-ae5ffce71700@leemhuis.info>
 <CADnq5_Nr5-FR2zP1ViVsD_ZMiW=UHC1wO8_HEGm26K_EG2KDoA@mail.gmail.com>
 <87czkk1pmt.fsf@dmarc-none.turner.link>
 <BYAPR12MB46140BE09E37244AE129C01A975C9@BYAPR12MB4614.namprd12.prod.outlook.com>
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
Date:   Sat, 22 Jan 2022 16:11:13 -0500
In-reply-to: <BYAPR12MB46140BE09E37244AE129C01A975C9@BYAPR12MB4614.namprd12.prod.outlook.com>
Message-ID: <87sftfqwlx.fsf@dmarc-none.turner.link>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Lijo,

> Could you provide the pp_dpm_* values in sysfs with and without the
> patch? Also, could you try forcing PCIE to gen3 (through pp_dpm_pcie)
> if it's not in gen3 when the issue happens?

AFAICT, I can't access those values while the AMD GPU PCI devices are
bound to `vfio-pci`. However, I can at least access the link speed and
width elsewhere in sysfs. So, I gathered what information I could for
two different cases:

- With the PCI devices bound to `vfio-pci`. With this configuration, I
  can start the VM, but the `pp_dpm_*` values are not available since
  the devices are bound to `vfio-pci` instead of `amdgpu`.

- Without the PCI devices bound to `vfio-pci` (i.e. after removing the
  `vfio-pci.ids=...` kernel command line argument). With this
  configuration, I can access the `pp_dpm_*` values, since the PCI
  devices are bound to `amdgpu`. However, I cannot use the VM. If I try
  to start the VM, the display (both the external monitors attached to
  the AMD GPU and the built-in laptop display attached to the Intel
  iGPU) completely freezes.

The output shown below was identical for both the good commit:
f1688bd69ec4 ("drm/amd/amdgpu:save psp ring wptr to avoid attack")
and the commit which introduced the issue:
f9b7f3703ff9 ("drm/amdgpu/acpi: make ATPX/ATCS structures global (v2)")

Note that the PCI link speed increased to 8.0 GT/s when the GPU was
under heavy load for both versions, but the clock speeds of the GPU were
different under load. (For the good commit, it was 1295 MHz; for the bad
commit, it was 501 MHz.)


# With the PCI devices bound to `vfio-pci`

## Before starting the VM

% ls /sys/module/amdgpu/drivers/pci:amdgpu
module  bind  new_id  remove_id  uevent  unbind

% find /sys/bus/pci/devices/0000:01:00.0/ -type f -name 'current_link*' -print -exec cat {} \;
/sys/bus/pci/devices/0000:01:00.0/current_link_width
8
/sys/bus/pci/devices/0000:01:00.0/current_link_speed
8.0 GT/s PCIe

## While running the VM, before placing the AMD GPU under heavy load

% find /sys/bus/pci/devices/0000:01:00.0/ -type f -name 'current_link*' -print -exec cat {} \;
/sys/bus/pci/devices/0000:01:00.0/current_link_width
8
/sys/bus/pci/devices/0000:01:00.0/current_link_speed
2.5 GT/s PCIe

## While running the VM, with the AMD GPU under heavy load

% find /sys/bus/pci/devices/0000:01:00.0/ -type f -name 'current_link*' -print -exec cat {} \;
/sys/bus/pci/devices/0000:01:00.0/current_link_width
8
/sys/bus/pci/devices/0000:01:00.0/current_link_speed
8.0 GT/s PCIe

## While running the VM, after stopping the heavy load on the AMD GPU

% find /sys/bus/pci/devices/0000:01:00.0/ -type f -name 'current_link*' -print -exec cat {} \;
/sys/bus/pci/devices/0000:01:00.0/current_link_width
8
/sys/bus/pci/devices/0000:01:00.0/current_link_speed
2.5 GT/s PCIe

## After stopping the VM

% find /sys/bus/pci/devices/0000:01:00.0/ -type f -name 'current_link*' -print -exec cat {} \;
/sys/bus/pci/devices/0000:01:00.0/current_link_width
8
/sys/bus/pci/devices/0000:01:00.0/current_link_speed
2.5 GT/s PCIe


# Without the PCI devices bound to `vfio-pci`

% ls /sys/module/amdgpu/drivers/pci:amdgpu
0000:01:00.0  module  bind  new_id  remove_id  uevent  unbind

% for f in /sys/module/amdgpu/drivers/pci:amdgpu/*/pp_dpm_*; do echo "$f"; cat "$f"; echo; done
/sys/module/amdgpu/drivers/pci:amdgpu/0000:01:00.0/pp_dpm_mclk
0: 300Mhz
1: 625Mhz
2: 1500Mhz *

/sys/module/amdgpu/drivers/pci:amdgpu/0000:01:00.0/pp_dpm_pcie
0: 2.5GT/s, x8
1: 8.0GT/s, x16 *

/sys/module/amdgpu/drivers/pci:amdgpu/0000:01:00.0/pp_dpm_sclk
0: 214Mhz
1: 501Mhz
2: 850Mhz
3: 1034Mhz
4: 1144Mhz
5: 1228Mhz
6: 1275Mhz
7: 1295Mhz *

% find /sys/bus/pci/devices/0000:01:00.0/ -type f -name 'current_link*' -print -exec cat {} \;
/sys/bus/pci/devices/0000:01:00.0/current_link_width
8
/sys/bus/pci/devices/0000:01:00.0/current_link_speed
8.0 GT/s PCIe


James
