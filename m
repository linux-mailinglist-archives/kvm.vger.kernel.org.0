Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB4BF65AF9B
	for <lists+kvm@lfdr.de>; Mon,  2 Jan 2023 11:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbjABKeN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Jan 2023 05:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbjABKeL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Jan 2023 05:34:11 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7F710F9;
        Mon,  2 Jan 2023 02:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.ch; s=s31663417;
        t=1672655640; bh=le00TsP+r/dWYsocjTldOuUeZzcZibPnf3GxCIea4CA=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=iTn9OPao7ePOAIjyccAwFpnncZZzO7FjlsLUX55IorZOF8UUcJQCCOQsjNfYbe0H7
         NMKng8t57OaDYeRMTyYfQofrmSgyXFXDpwbQNziisTKferPjFWo5H4rATtXOqc1iGi
         2eTHU71xOtZNaDi6Wp1D5jzzwOktVoltkQUbePXIGWreBY1AIHJbQgtO2qpzO35G+E
         cfcr3uii80ZthHGikhaINiRgClTCCdJ9+S+wwFTLz8MLFLo9Y6DKof7OTBedcr5e3T
         NpX9BGvMDyOKsf1WWJ+LMbpzayeZdNrrhty8TYvfgyq7IRM0bS2+B5k5Nz9cN9lN5C
         Pc115o5H4X86Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.106] ([89.217.230.95]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MBDjA-1p6Dbi2H8A-00Clya; Mon, 02
 Jan 2023 11:34:00 +0100
Message-ID: <4ddb5909-0f1e-d701-5678-ce7f3a57446b@gmx.ch>
Date:   Mon, 2 Jan 2023 11:33:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 2/2] vfio/pci: Remove console drivers
Content-Language: en-US
To:     "mb@lab.how" <mb@lab.how>, Thomas Zimmermann <tzimmermann@suse.de>
Cc:     kvm@vger.kernel.org, airlied@linux.ie,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Alex Williamson <alex.williamson@redhat.com>,
        kraxel@redhat.com, lersek@redhat.com
References: <CAEdEoBYXHq9cCzsbMYTpG1B41Yz=-QAjFx7bJDOnPanN5Tmo7A@mail.gmail.com>
 <20221204175142.658d5c37.alex.williamson@redhat.com>
 <1e4d62cf-8893-0bff-51f5-5a2e419ed5a0@suse.de>
 <CAEdEoBYZa9cg0nq=P7EDsDS9m2EKYrd8M8ucqi8U0Csj0mtjDg@mail.gmail.com>
 <c1c8bfa5-8ba4-c365-1663-535f656ca353@suse.de>
 <CAEdEoBaixaTEuNfQGv1das7TwHKV9MiRMKQM0kLspveJmipzyg@mail.gmail.com>
From:   Shawn Michaels <shawn_michaels@gmx.ch>
In-Reply-To: <CAEdEoBaixaTEuNfQGv1das7TwHKV9MiRMKQM0kLspveJmipzyg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:qqG346XXu7KgwSPHUbVfmllcgd5cT4QzwWYi1Ot1NgviNO1WbqX
 AeJvhaKR67wBUgK1L1PQP/ywUImVLYd3GGb/rxRGQcJGnlSz/bB/cOyUQdzx2kIgwo6DD7E
 12QofRuibf2Ng2c1/l6hQFoNK7Qh5rZTg6D8kgSA4EIO20aYyukUEyJ3dcAZukJ3v9fGSWI
 nGqNJl0jPf0mBbgPXQPqg==
UI-OutboundReport: notjunk:1;M01:P0:kXnMy45TwZM=;YdKfddT3ITGr9r4YtRKUBXCg8hC
 K8yx3Hjh2XQPqWHG8zbACmM6bpStxyNsiPFS3Qh3J6soI3qY1s9mGOwiner5QOCvyGns0CHHp
 YoqB4UjaXb5UKkWNIJRXE14E2Kf5WBBT+7C7l4PhQX4xCw2diiPXA9l2pYniWBbRuAATitj0K
 f0ocDZxIHMEh1YtCInbGogPim82/8gfIzIi0pYE14dwrVyDlNZvuhAnYlCG4MyAEDVlraoVtv
 gEQCon3XLHoE6iFwbV49ZOLo64nEpSF0InDGBW/ToTTF35QLtVevXctt0auXQQohsbilPoom2
 7vmQkQwblFjLniufyVRmeU6vMF6NQt4zBWd6Z+UHGQnw3MCmf5+ARMHf/aXae2C8Uyc1TKOm3
 RI8Ey514q2k6kd9jBtYsD4eZN9UI/T+oBWSV4+lQTeblzrQ7CPYfAGkbTxtbWEoraOk10Ysyy
 cFOhqB6rgs/QiTGv6HaPXiO3heKnQblzIimQEgEZCML6M6uHlTIGTelsWTGMxY4iEDnboVauU
 jdleYp1IE7M+E7dUtmwT6VsieTuHMKz6kVDLNGS5QSG2b/KtFyyzjIowYbUjYq22evBnnO9qL
 A5qatYU4hULENSLIl0dSMsEdAA7hTgMUxCWGZqy5To6nRNlflK1t4/9Fs6iieeoeaD7se2vcX
 jYBK6SQ63K0ceGk+312Hcg8NTmfKMc5ayuiWvGUNNt/4EcPNGU4YtuA7LiTEFuyZ1QAJx02sY
 rb6G9KHBLzex7dewBVFQwB4QHZK1zakAhquXNwQ6aWgLM8/CGzU/xW5sEXrM18S5r42aGL1rd
 7Fmhe226jqLtj1hALbGaF+nYd0C+M5ArnRdEDInVqBHN2CbeqF1JXPnlK54fxMMQ8yevrWfdj
 Ao2tTRnuNhmLNAfy4QjLTVUvCWTifNFSM1QpGtkx9BcZudwKAtSSrCD+rSzL4gbtgOBrHiVVc
 kLuXIQ4o9qqiBn1Hcm5oVtY+kBw=
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I just upgraded my system (after 7 months) and I also lost my framebuffer on boot.
At first, I thought that my computer was freezing on startup, but it turns out
that it is running fine (I can SSH to it and even startx remotely), only the
framebuffer stops working very early on boot:

	:: running early hook [udev]
	Starting systemd-udevd version 252.4-2-arch
	[3.400568] VFIO - User Level meta-driver version: 0.3
	*LOSING FRAMEBUFFER HERE*

Running startx from an SSH session starts my X server and display works again.

I have two identical GPU cards (nVidia GTX 1070). I have been using the method
from [1] for years in order to prevent the nvidia driver from grabbing my guest
GPU. As mb already pointed out, vfio_pci now kills the framebuffer of the host
GPU even though it is assigned to the guest GPU. I could isolate it to the
following line from [1]:

	echo "vfio-pci" > "$GPU/driver_override"

I also double checked and this is correctly written to the guest GPU, and not
to the host GPU. My kernel version is:

	Linux cc 6.1.1-arch1-1 #1 SMP PREEMPT_DYNAMIC Wed, 21 Dec 2022 22:27:55 +0000 x86_64 GNU/Linux

You can find people having the same issue in threads from [2] and [3]. There are
also some reports on the VFIO discord server.

This is a problem for people using an encrypted filesystem (password needs to be
typed blindly) or in case boot fails for some reason (and you cannot see console
logs). In my case, I switched from manually starting X with startx to using a
graphical login manager. Blacklisting the vfio_pci module by passing the following
kernel parameter brings the boot console back:

	module_blacklist=vfio_pci

Happy new year everyone

Shawn

[1] https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF#Passthrough_all_GPUs_but_the_boot_GPU
[2] https://bbs.archlinux.org/viewtopic.php?pid=2063423
[3] https://forum.level1techs.com/t/linux-kernel-6-seems-to-be-incompatible-with-the-vfio-pci-module-needed-for-pci-passthrough/190039/11

