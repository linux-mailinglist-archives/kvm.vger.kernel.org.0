Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9161F734A26
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 04:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjFSCX7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Jun 2023 22:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjFSCX6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 18 Jun 2023 22:23:58 -0400
Received: from 189.cn (ptr.189.cn [183.61.185.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1867DE4D;
        Sun, 18 Jun 2023 19:23:56 -0700 (PDT)
HMM_SOURCE_IP: 10.64.8.41:49476.941168508
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-114.242.206.180 (unknown [10.64.8.41])
        by 189.cn (HERMES) with SMTP id 1E2E1102981;
        Mon, 19 Jun 2023 10:23:44 +0800 (CST)
Received: from  ([114.242.206.180])
        by gateway-151646-dep-75648544bd-xwndj with ESMTP id 98b384fdfd3f4a748b7a9c050bde1861 for suijingfeng@loongson.cn;
        Mon, 19 Jun 2023 10:23:55 CST
X-Transaction-ID: 98b384fdfd3f4a748b7a9c050bde1861
X-Real-From: 15330273260@189.cn
X-Receive-IP: 114.242.206.180
X-MEDUSA-Status: 0
Sender: 15330273260@189.cn
Message-ID: <bef70e09-491a-9f40-1cad-1b413896de2e@189.cn>
Date:   Mon, 19 Jun 2023 10:23:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v7 2/8] PCI/VGA: Deal only with VGA class devices
Content-Language: en-US
To:     Sui Jingfeng <suijingfeng@loongson.cn>,
        Alex Deucher <alexdeucher@gmail.com>
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-fbdev@vger.kernel.org, kvm@vger.kernel.org,
        nouveau@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org, linux-pci@vger.kernel.org
References: <20230613030151.216625-1-15330273260@189.cn>
 <20230613030151.216625-3-15330273260@189.cn>
 <dbf0d89f-717a-1f78-aef2-f30506751d4d@loongson.cn>
 <CADnq5_N6vVtzH6tzguZdHnP_TdRoG1G-Cr94O+X03jvtk=vhag@mail.gmail.com>
 <3c1c86ab-96ea-aa1c-c9c5-9a4012644fd6@loongson.cn>
 <CADnq5_Px-HWfwetv8LZsCnCeV7SMt_uqtLwMVK7648ZQiP2RCQ@mail.gmail.com>
 <f08b6a76-6c90-b59b-ff43-c779ef759d09@loongson.cn>
 <CADnq5_PFoM2O8mCd6+VFfu9Nc-Hg_HTnwEMxrq0FGRpva1kKiA@mail.gmail.com>
 <c2cdc3ca-20de-0133-b198-1118fcea7902@loongson.cn>
From:   Sui Jingfeng <15330273260@189.cn>
In-Reply-To: <c2cdc3ca-20de-0133-b198-1118fcea7902@loongson.cn>
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


On 2023/6/18 20:11, Sui Jingfeng wrote:
> And screen_info is more about video specifci thing. 


screen_info is something more about video specific thing.

