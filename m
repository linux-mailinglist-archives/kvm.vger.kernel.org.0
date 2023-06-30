Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66ADB7433AB
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 06:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjF3EnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 00:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbjF3EnL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 00:43:11 -0400
Received: from 189.cn (ptr.189.cn [183.61.185.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 33987210E;
        Thu, 29 Jun 2023 21:43:08 -0700 (PDT)
HMM_SOURCE_IP: 10.64.8.41:36042.36167694
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-114.242.206.180 (unknown [10.64.8.41])
        by 189.cn (HERMES) with SMTP id C76A010013F;
        Fri, 30 Jun 2023 12:43:02 +0800 (CST)
Received: from  ([114.242.206.180])
        by gateway-151646-dep-6d8594f54d-zsdp9 with ESMTP id 5b3173dd4b264e9cbf3fad1bf2583dd6 for mario.limonciello@amd.com;
        Fri, 30 Jun 2023 12:43:06 CST
X-Transaction-ID: 5b3173dd4b264e9cbf3fad1bf2583dd6
X-Real-From: 15330273260@189.cn
X-Receive-IP: 114.242.206.180
X-MEDUSA-Status: 0
Sender: 15330273260@189.cn
Message-ID: <b7528e1d-7f71-016c-f0ef-a044586b7765@189.cn>
Date:   Fri, 30 Jun 2023 12:42:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v7 6/8] PCI/VGA: Introduce is_boot_device function
 callback to vga_client_register
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Sui Jingfeng <suijingfeng@loongson.cn>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Karol Herbst <kherbst@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Chai, Thomas" <YiPeng.Chai@amd.com>,
        "Gao, Likun" <Likun.Gao@amd.com>, David Airlie <airlied@gmail.com>,
        Ville Syrjala <ville.syrjala@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Ben Skeggs <bskeggs@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Kevin Tian <kevin.tian@intel.com>,
        "Lazar, Lijo" <Lijo.Lazar@amd.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        "Zhang, Bokun" <Bokun.Zhang@amd.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Maxime Ripard <mripard@kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Zhang, Hawking" <Hawking.Zhang@amd.com>
References: <20230629155436.GA397963@bhelgaas>
 <bcfdc77d-a94d-bca1-56e3-5e14e91f6fd9@189.cn>
 <MN0PR12MB6101CDB6FF9DC8F8EDEF5F45E225A@MN0PR12MB6101.namprd12.prod.outlook.com>
Content-Language: en-US
From:   Sui Jingfeng <15330273260@189.cn>
In-Reply-To: <MN0PR12MB6101CDB6FF9DC8F8EDEF5F45E225A@MN0PR12MB6101.namprd12.prod.outlook.com>
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

On 2023/6/30 01:44, Limonciello, Mario wrote:
> I think what you can do is pick up all the tags in your next version.  Once the
> whole series has tags we can discuss how it merges.

Yes, you are right.

I will prepare the next version.

But I think, I should only gather the reverent part together.

I means that I probably should divide the 8 patches in V7 into 4 + 4.

The first four patch form a group, and the last four patch form another 
group.


Certainly, I will pick up the precious tags I got in the next version.

Thanks you!

