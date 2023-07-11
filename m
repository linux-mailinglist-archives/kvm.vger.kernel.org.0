Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40DB174F354
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 17:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbjGKPYu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 11:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbjGKPYq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 11:24:46 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A1710F1;
        Tue, 11 Jul 2023 08:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1689089042; x=1689693842; i=deller@gmx.de;
 bh=X5J8IwR1yeKrwbjkpPsX7TYJjlXNjW6vNyFiaXSONCI=;
 h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
 b=GN6pEgcKFc3TiPb2BrkoJgWpY3wT6K0R5RBigRXBblVMjch41be3tnm2swuTsuX+Os7iA/8
 Z9v2vToEYoOPOQ4s3z2aViTvBbo31jTtusNzIKxOpiwD7D9NwU7sqcIn+JNbk0jHZjwhfVLl2
 d6iWR9cqVyWu0u7qANiT81Cpfdu3Eqc00ZipKFbQhesar/5TX1xB7U9VpXwXmNRtS/1YNiPfU
 SRgIgcZf4Vy4C2hoDDHbvEMYqAxah1b5gF/4wDuoYtNwfTn8iZrmD7X6N5eREBk0mQ+SO7vLm
 XJUXEar9IV97stc6Qd3jl7GNwSx3M24HJnop1aHhCU7ipk3XBcaQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.149.147]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N4hzZ-1ps3V72pTb-011i72; Tue, 11
 Jul 2023 17:24:02 +0200
Message-ID: <bf439387-6b13-0fd9-f61b-1a5cbf731187@gmx.de>
Date:   Tue, 11 Jul 2023 17:24:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 00/17] fbdev: Remove FBINFO_DEFAULT and
 FBINFO_FLAG_DEFAULT flags
Content-Language: en-US
To:     Sam Ravnborg <sam@ravnborg.org>,
        Thomas Zimmermann <tzimmermann@suse.de>
Cc:     javierm@redhat.com, linux-fbdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        linux-geode@lists.infradead.org, dri-devel@lists.freedesktop.org,
        linux-input@vger.kernel.org, linux-nvidia@lists.surfsouth.com,
        linux-omap@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <20230710130113.14563-1-tzimmermann@suse.de>
 <20230710171903.GA14712@ravnborg.org>
 <ab92f8d9-36ab-06bc-b85b-d52b7a1bfe9a@suse.de>
 <20230711144744.GA117276@ravnborg.org>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <20230711144744.GA117276@ravnborg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6I/u9K9DZKAMaYzMuqb+xXVwXoFF+h72slV7307qnBcsm0Dzs1x
 nG8x0xILsiEhhUVyajytT1uvIrwO9pRmYfPk78Yjls8o/KkVUspWf98tkujsctomDLRF6u0
 UdBWhjkxLyl8NlhxrYI/AySAPNbWQr6NnCxEKWsR0EsTYbybHP0PZ/RgD80PFRH8fmhW/rk
 TAn21cXKojNy9UOEmBO4g==
UI-OutboundReport: notjunk:1;M01:P0:XNImko0fYwY=;AiV+j1oEN7JVd7gQE4GAf5pZu6m
 wj99cJ2LSeHJsHr2sKsT5CY1HR5Yi2t55wwqJhZ6uGfcqxHOW/2sn0V3JJ1io82GaOhNRHzvt
 zR9PmCQCilcJeIgDWCjc0NTIJrJwKg9hfWHSI53inWj0QmjAnOKmMCU3wO+aUNaQN4UL9Li4U
 pS0CQrlM7YGW4BTIwfY0xyXtCF6IMWdx7BHqF3QxocVpNzMqT/GVE2zmfibCAiVqoVQY40T+o
 NfQL+Sjc8hRtasBpRBrc2z21M5uGIuje56htBn3GdlF1wxQAOhS7U4WVJMB/RUoYnHtqc+5C7
 Y3Z39Ph2nMGi4aLfGFPQ8o5aDWO2iSZAEyXK9ibsLnG8FE5wcp3HfnnPdYVrcXXRMfCi9Y0y8
 dPaGqnM2nlp1XoENCoUkPedNE+amwXmHeMkLsw4/azwj2BHBlZDUJbT5TEDhDYiUleyOTHX6w
 9DrDsMO8KTBvWuKxlyh6SvhMiT5th1mL55DNnDe9iAzx5CzX3I/WPmvRDiOsFpDevTdtc/8Ul
 fXWMM1JgkhhzesMwjc3WGGL0WR7ZLDoAXdy6HgvU6DYnM5ZKWbGaU0kGq3Xt62kPOP/TPi57t
 7xnqiNwytZ9sHQk0abZBXvyhMmffWWlPi7PkmADCqAImC+5wCWCuFIzRZjFe8toJm2oLadiV3
 knPTCfauwkQqsirUUTKP+Fvtut4kgg/lM/XFnPlOr6ONXkR+PAt+jXB02SliulYmhRIkG9Cps
 DEGpDks4ZL0YBrtLU06OAYGJk5e79ZlPpMsMOxggmhzdOq5gASDzlXo2v/5WI4kajcTiXWshU
 AsE+znIk2ZnZVFDRN2aKd1kxacUupl9dFU1lXpXl4FV9iCrgKo+mSF8JrBT4S2N98M8WXk/wg
 j6ZDK2VfivJIrmvtPfy2OGuo6dP1yz/NEjvVfotUNvuZgi41Wa3hoMtQxYuWKIroLVVgCW7x4
 ElEk/ywwPT4Kak54lZ31n9Y0OxE=
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/11/23 16:47, Sam Ravnborg wrote:
> Hi Thomas,
>
> On Tue, Jul 11, 2023 at 08:24:40AM +0200, Thomas Zimmermann wrote:
>> Hi Sam
>>
>> Am 10.07.23 um 19:19 schrieb Sam Ravnborg:
>>> Hi Thomas,
>>>
>>> On Mon, Jul 10, 2023 at 02:50:04PM +0200, Thomas Zimmermann wrote:
>>>> Remove the unused flags FBINFO_DEFAULT and FBINFO_FLAG_DEFAULT from
>>>> fbdev and drivers, as briefly discussed at [1]. Both flags were maybe
>>>> useful when fbdev had special handling for driver modules. With
>>>> commit 376b3ff54c9a ("fbdev: Nuke FBINFO_MODULE"), they are both 0
>>>> and have no further effect.
>>>>
>>>> Patches 1 to 7 remove FBINFO_DEFAULT from drivers. Patches 2 to 5
>>>> split this by the way the fb_info struct is being allocated. All flag=
s
>>>> are cleared to zero during the allocation.
>>>>
>>>> Patches 8 to 16 do the same for FBINFO_FLAG_DEFAULT. Patch 8 fixes
>>>> an actual bug in how arch/sh uses the tokne for struct fb_videomode,
>>>> which is unrelated.
>>>>
>>>> Patch 17 removes both flag constants from <linux/fb.h>
>>>
>>> We have a few more flags that are unused - should they be nuked too?
>>> FBINFO_HWACCEL_FILLRECT
>>> FBINFO_HWACCEL_ROTATE
>>> FBINFO_HWACCEL_XPAN
>>
>> It seems those are there for completeness. Nothing sets _ROTATE,

I think some fbdev drivers had hardware acceleration for ROTATE in the
past. HWACCEL_XPAN is still in some drivers.

>> the others are simply never checked. According to the comments,
>> some are required, some are optional. I don't know what that
>> means.

I think it's OK if you remove those flags which aren't used anywhere,
e.g. FBINFO_HWACCEL_ROTATE.

>> IIRC there were complains about performance when Daniel tried to remove
>> fbcon acceleration, so not all _HWACCEL_ flags are unneeded.

Correct. I think COPYAREA and FILLRECT are the bare minimum to accelerate
fbcon, IMAGEBLIT is for showing the tux penguin (?),
XPAN/YPAN and YWRAP for some hardware screen panning needed by some driver=
s
(not sure if this is still used as I don't have such hardware, Geert?).

>> Leaving them in for reference/completeness might be an option; or not. =
I
>> have no strong feelings about those flags.

I'd say drop FBINFO_HWACCEL_ROTATE at least ?

>>> Unused as in no references from fbdev/core/*
>>>
>>> I would rather see one series nuke all unused FBINFO flags in one go.
>>> Assuming my quick grep are right and the above can be dropped.
>>
>> I would not want to extend this series. I'm removing _DEFAULT as it's
>> absolutely pointless and confusing.

Yes, Ok.

Helge
