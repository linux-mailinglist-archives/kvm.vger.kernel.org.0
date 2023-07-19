Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCB1C75A1F8
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 00:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbjGSWcY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 18:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbjGSWcX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 18:32:23 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2CB4C1FDC;
        Wed, 19 Jul 2023 15:32:20 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.43])
        by gateway (Coremail) with SMTP id _____8BxXetzZLhkQnUHAA--.13743S3;
        Thu, 20 Jul 2023 06:32:19 +0800 (CST)
Received: from [10.20.42.43] (unknown [10.20.42.43])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cx_c5zZLhkDh41AA--.15520S3;
        Thu, 20 Jul 2023 06:32:19 +0800 (CST)
Message-ID: <f87a48c6-909e-39ba-62b0-289e78798540@loongson.cn>
Date:   Thu, 20 Jul 2023 06:32:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 4/9] PCI/VGA: Improve the default VGA device selection
Content-Language: en-US
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Sui Jingfeng <sui.jingfeng@linux.dev>
Cc:     David Airlie <airlied@gmail.com>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian Konig <christian.koenig@amd.com>,
        Pan Xinhui <Xinhui.Pan@amd.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        YiPeng Chai <YiPeng.Chai@amd.com>,
        Bokun Zhang <Bokun.Zhang@amd.com>,
        Likun Gao <Likun.Gao@amd.com>,
        Ville Syrjala <ville.syrjala@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
References: <20230719193233.GA511659@bhelgaas>
From:   suijingfeng <suijingfeng@loongson.cn>
In-Reply-To: <20230719193233.GA511659@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf8Cx_c5zZLhkDh41AA--.15520S3
X-CM-SenderInfo: xvxlyxpqjiv03j6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoW7WF18WFW7Cw1kAr15Zr15Jrc_yoW5Jr1rp3
        yaga1akrs7XFWUtry7A34kXFyavw4fX3yrGr1rG34j9398G3s5JrW8Ka15Ka47Zw18WF42
        vFy8tw12kay5Z3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUP529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPvb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
        6r4UJVWxJr1ln4kS14v26r1q6r43M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
        xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q
        6rW5McIj6I8E87Iv67AKxVWxJVW8Jr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
        8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vI
        r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jw0_GFylx2IqxVAqx4xG67
        AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26rWY6r4UJwCI
        c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF0xvE2Ix0cI8IcVCY1x0267
        AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Cr0_
        Gr1UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxU-J
        KIDUUUU
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2023/7/20 03:32, Bjorn Helgaas wrote:
> [+cc linux-pci (please cc in the future since the bulk of this patch
> is in drivers/pci/)]
>
> On Wed, Jul 12, 2023 at 12:43:05AM +0800, Sui Jingfeng wrote:
>> From: Sui Jingfeng <suijingfeng@loongson.cn>
>>
>> Currently, the strategy of selecting the default boot on a multiple video
>> card coexistence system is not perfect. Potential problems are:
>>
>> 1) This function is a no-op on non-x86 architectures.
> Which function in particular is a no-op for non-x86?


I refer to the vga_is_firmware_default() function,

I will improve the commit message at the next version. (To make it more 
human readable).

Thanks you point it out.


>> 2) It does not take the PCI Bar may get relocated into consideration.
>> 3) It is not effective for the PCI device without a dedicated VRAM Bar.
>> 4) It is device-agnostic, thus it has to waste the effort to iterate all
>>     of the PCI Bar to find the VRAM aperture.
>> 5) It has invented lots of methods to determine which one is the default
>>     boot device, but this is still a policy because it doesn't give the
>>     user a choice to override.
> I don't think we need a list of *potential* problems.  We need an
> example of the specific problem this will solve, i.e., what currently
> does not work?

1) The selection of primary GPU on Non-x86 platform. (Arm64, risc-v, 
powerpc etc)

Mostly server platforms have equipped with aspeed bmc, and such hardware 
platforms have a lot PCIe slot.

So I think, aspeed bmc V.S (P.K) radeon(or amdgpu) is very common.


2) The ability to pass the control back to the end user.

Convert the *device driven* to the "driver driven" or "human driven".

Currently, it is the machine making the decision.

Emm, I probably will be able to give some examples at the next version.


> The drm/ast and maybe drm/loongson patches are the only ones that use
> the new callback, so I assume there are real problems with those
> drivers.
>
> CONFIG_DRM_AST is a tristate.  We're talking about identifying the
> boot-time console device.  So if CONFIG_DRM_AST=m, I guess we don't
> get the benefit of the new callback unless the module gets loaded?
>
Since, this patch set is mostly for the user of X server.

It is actually okey if CONFIG_DRM_AST=m. (it will be works no matter CONFIG_DRM_AST=m or CONFIG_DRM_AST=y)


As the device and the driver bound at a latter time.

So we are lucky, we need this behavior to implement the override.

