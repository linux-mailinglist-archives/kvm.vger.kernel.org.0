Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDF172A181
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 19:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjFIRn5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 13:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjFIRny (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 13:43:54 -0400
Received: from 189.cn (ptr.189.cn [183.61.185.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E6B5E35B3;
        Fri,  9 Jun 2023 10:43:44 -0700 (PDT)
HMM_SOURCE_IP: 10.64.8.43:47690.1937665454
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-114.242.206.180 (unknown [10.64.8.43])
        by 189.cn (HERMES) with SMTP id AEDBE100212;
        Sat, 10 Jun 2023 01:43:39 +0800 (CST)
Received: from  ([114.242.206.180])
        by gateway-151646-dep-75648544bd-7vx9t with ESMTP id 0877e90f4b584cbe94a878d807b39f22 for helgaas@kernel.org;
        Sat, 10 Jun 2023 01:43:43 CST
X-Transaction-ID: 0877e90f4b584cbe94a878d807b39f22
X-Real-From: 15330273260@189.cn
X-Receive-IP: 114.242.206.180
X-MEDUSA-Status: 0
Sender: 15330273260@189.cn
Message-ID: <2cf50ad0-e4fa-17a3-3e22-7fd8d4a316ed@189.cn>
Date:   Sat, 10 Jun 2023 01:43:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [Intel-gfx] [PATCH v3 4/4] PCI/VGA: introduce is_boot_device
 function callback to vga_client_register
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Sui Jingfeng <suijingfeng@loongson.cn>
Cc:     Somalapuram Amaranath <Amaranath.Somalapuram@amd.com>,
        Karol Herbst <kherbst@redhat.com>,
        nouveau@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        dri-devel@lists.freedesktop.org, YiPeng Chai <YiPeng.Chai@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        David Airlie <airlied@gmail.com>,
        Ville Syrjala <ville.syrjala@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, kvm@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, Jason Gunthorpe <jgg@ziepe.ca>,
        Ben Skeggs <bskeggs@redhat.com>, linux-pci@vger.kernel.org,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Bokun Zhang <Bokun.Zhang@amd.com>,
        intel-gfx@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        loongson-kernel@lists.loongnix.cn,
        Alex Williamson <alex.williamson@redhat.com>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Yishai Hadas <yishaih@nvidia.com>, Li Yi <liyi@loongson.cn>,
        Pan Xinhui <Xinhui.Pan@amd.com>, linux-kernel@vger.kernel.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian Konig <christian.koenig@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>
References: <20230609164850.GA1251187@bhelgaas>
Content-Language: en-US
From:   Sui Jingfeng <15330273260@189.cn>
In-Reply-To: <20230609164850.GA1251187@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FROM_LOCAL_DIGITS,
        FROM_LOCAL_HEX,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2023/6/10 00:48, Bjorn Helgaas wrote:
> On Fri, Jun 09, 2023 at 10:27:39AM +0800, Sui Jingfeng wrote:
>> On 2023/6/9 03:19, Bjorn Helgaas wrote:
>>> On Thu, Jun 08, 2023 at 07:43:22PM +0800, Sui Jingfeng wrote:
>>>> From: Sui Jingfeng <suijingfeng@loongson.cn>
>>>>
>>>> The vga_is_firmware_default() function is arch-dependent, which doesn't
>>>> sound right. At least, it also works on the Mips and LoongArch platforms.
>>>> Tested with the drm/amdgpu and drm/radeon drivers. However, it's difficult
>>>> to enumerate all arch-driver combinations. I'm wrong if there is only one
>>>> exception.
>>>>
>>>> With the observation that device drivers typically have better knowledge
>>>> about which PCI bar contains the firmware framebuffer, which could avoid
>>>> the need to iterate all of the PCI BARs.
>>>>
>>>> But as a PCI function at pci/vgaarb.c, vga_is_firmware_default() is
>>>> probably not suitable to make such an optimization for a specific device.
>>>>
>>>> There are PCI display controllers that don't have a dedicated VRAM bar,
>>>> this function will lose its effectiveness in such a case. Luckily, the
>>>> device driver can provide an accurate workaround.
>>>>
>>>> Therefore, this patch introduces a callback that allows the device driver
>>>> to tell the VGAARB if the device is the default boot device. This patch
>>>> only intends to introduce the mechanism, while the implementation is left
>>>> to the device driver authors. Also honor the comment: "Clients have two
>>>> callback mechanisms they can use"
>>> s/bar/BAR/ (several)
>>>
>>> Nothing here uses the callback.  I don't want to merge this until we
>>> have a user.
>> This is chicken and egg question.
>>
>> If you could help get this merge first, I will show you the first user.
>>
>>> I'm not sure why the device driver should know whether its device is
>>> the default boot device.
>> It's not that the device driver should know,
>>
>> but it's about that the device driver has the right to override.
>>
>> Device driver may have better approach to identify the default boot
>> device.
> The way we usually handle this is to include the new callback in the
> same series as the first user of it.  That has two benefits:
> (1) everybody can review the whole picture and possibly suggest
> different approaches, and (2) when we merge the infrastructure,
> we also merge a user of it at the same time, so the whole thing can be
> tested and we don't end up with unused code.

OK, acceptable

I will try to prepare the user code of this callback and respin the patch.

I may resend it with another patch set in the future, this series 
already drop it,

see v5[1]

[1] https://patchwork.freedesktop.org/series/119134/

> Bjorn
