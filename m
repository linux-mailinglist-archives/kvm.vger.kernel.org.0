Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1027E742AEF
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 19:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbjF2RAX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 13:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjF2RAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 13:00:22 -0400
Received: from 189.cn (ptr.189.cn [183.61.185.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0E3242D4C;
        Thu, 29 Jun 2023 10:00:18 -0700 (PDT)
HMM_SOURCE_IP: 10.64.8.31:48394.1297546617
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-114.242.206.180 (unknown [10.64.8.31])
        by 189.cn (HERMES) with SMTP id 05A4C10020D;
        Fri, 30 Jun 2023 01:00:13 +0800 (CST)
Received: from  ([114.242.206.180])
        by gateway-151646-dep-75648544bd-xp9j7 with ESMTP id 2713aa1564624f348fd6c097b85f39d9 for helgaas@kernel.org;
        Fri, 30 Jun 2023 01:00:17 CST
X-Transaction-ID: 2713aa1564624f348fd6c097b85f39d9
X-Real-From: 15330273260@189.cn
X-Receive-IP: 114.242.206.180
X-MEDUSA-Status: 0
Sender: 15330273260@189.cn
Message-ID: <bcfdc77d-a94d-bca1-56e3-5e14e91f6fd9@189.cn>
Date:   Fri, 30 Jun 2023 01:00:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v7 6/8] PCI/VGA: Introduce is_boot_device function
 callback to vga_client_register
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Sui Jingfeng <suijingfeng@loongson.cn>
Cc:     Bjorn Helgaas <bhelgaas@google.com>, linux-fbdev@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Karol Herbst <kherbst@redhat.com>,
        nouveau@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        dri-devel@lists.freedesktop.org, YiPeng Chai <YiPeng.Chai@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Likun Gao <Likun.Gao@amd.com>,
        David Airlie <airlied@gmail.com>,
        Ville Syrjala <ville.syrjala@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, kvm@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, Jason Gunthorpe <jgg@ziepe.ca>,
        Ben Skeggs <bskeggs@redhat.com>, linux-pci@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Bokun Zhang <Bokun.Zhang@amd.com>,
        intel-gfx@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Maxime Ripard <mripard@kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Pan Xinhui <Xinhui.Pan@amd.com>, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian Konig <christian.koenig@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>
References: <20230629155436.GA397963@bhelgaas>
Content-Language: en-US
From:   Sui Jingfeng <15330273260@189.cn>
In-Reply-To: <20230629155436.GA397963@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FROM_LOCAL_DIGITS,
        FROM_LOCAL_HEX,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2023/6/29 23:54, Bjorn Helgaas wrote:
> On Thu, Jun 22, 2023 at 01:08:15PM +0800, Sui Jingfeng wrote:
>> Hi,
>>
>>
>> A nouveau developer(Lyude) from redhat send me a R-B,
>>
>> Thanks for the developers of nouveau project.
>>
>>
>> Please allow me add a link[1] here.
>>
>>
>> [1] https://lore.kernel.org/all/0afadc69f99a36bc9d03ecf54ff25859dbc10e28.camel@redhat.com/
> 1) Thanks for this.  If you post another version of this series,
>     please pick up Lyude's Reviewed-by and include it in the relevant
>     patches (as long as you haven't made significant changes to the
>     code Lyude reviewed).

Yes, no significant changes. Just fix typo.

I also would like to add support for other DRM drivers.

But I think this deserve another patch.

>   Whoever applies this should automatically
>     pick up Reviewed-by/Ack/etc that are replies to the version being
>     applied, but they won't go through previous revisions to find them.
>
> 2) Please mention the commit to which the series applies.  I tried to
>     apply this on v6.4-rc1, but it doesn't apply cleanly.

Since I'm a graphic driver developer, I'm using drm-tip.

I just have already pulled, it still apply cleanly on drm-tip.

> 3) Thanks for including cover letters in your postings.  Please
>     include a little changelog in the cover letter so we know what
>     changed between v6 and v7, etc.

No change between v6 and v7,

it seems that it is because the mailbox don't allow me to sending too 
many mails a day.

so some of the patch is failed to delivery because out of quota.


> 4) Right now we're in the middle of the v6.5 merge window, so new
>     content, e.g., this series, is too late for v6.5.  Most
>     maintainers, including me, wait to merge new content until the
>     merge window closes and a new -rc1 is tagged.  This merge window
>     should close on July 9, and people will start merging content for
>     v6.6, typically based on v6.5-rc1.

I'm wondering

Would you will merge all of the patches in this series (e.g. including 
the patch for drm/amdgpu(7/8) and drm/radeon(8/8)) ?

Or just part of them?

Emm, I don't know because my patch seems across different subsystem of 
Linux kernel.

There is also a developer for AMDGPU (Mario) give me a R-B for the 
patch-0002 of this series.

So, at least, PATCH-0001, PATCH-0002, PATCH-0003, PATCH-0004, PATCH-0006 
are already OK(got reviewed by).

Those 5 patch are already qualified to be merged, I think.

I means that if you could merge those 5 patch first, then there no need 
to send another version again.

I will refine the rest patch with more details and description.

I'm fear of making too much noise.

> Bjorn
