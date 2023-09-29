Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F917B3115
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 13:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbjI2LMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 07:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjI2LM2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 07:12:28 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848ABBF;
        Fri, 29 Sep 2023 04:12:26 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1qmBPz-0006y6-Mo; Fri, 29 Sep 2023 13:12:23 +0200
Message-ID: <a7a2bf25-cfc1-47a8-baf4-487a8574fb5a@leemhuis.info>
Date:   Fri, 29 Sep 2023 13:12:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] virtio: features
Content-Language: en-US, de-DE
From:   "Linux regression tracking #update (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
To:     Linux kernel regressions list <regressions@lists.linux.dev>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>,
          Linux regressions mailing list 
          <regressions@lists.linux.dev>
References: <20230903181338-mutt-send-email-mst@kernel.org>
 <20230926130451.axgodaa6tvwqs3ut@amd.com>
 <86d04b92-1b1e-4676-95e3-87e8e0082526@leemhuis.info>
In-Reply-To: <86d04b92-1b1e-4676-95e3-87e8e0082526@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1695985946;2c5a440b;
X-HE-SMSGID: 1qmBPz-0006y6-Mo
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27.09.23 15:18, Linux regression tracking #adding (Thorsten Leemhuis)
wrote:
> On 26.09.23 15:04, Michael Roth wrote:
>> On Sun, Sep 03, 2023 at 06:13:38PM -0400, Michael S. Tsirkin wrote:
>>>       virtio_net: merge dma operations when filling mergeable buffers
>>
>> This ^ patch (upstream commit 295525e29a) seems to cause a
>> network-related regression when using SWIOTLB in the guest. I noticed
>> this initially testing SEV guests, which use SWIOTLB by default, but
>> it can also be seen with normal guests when forcing SWIOTLB via
>> swiotlb=force kernel cmdline option. I see it with both 6.6-rc1 and
>> 6.6-rc2 (haven't tried rc3 yet, but don't see any related changes
>> there), and reverting 714073495f seems to avoid the issue.
>>
>> Steps to reproduce:
>>> [...]
> 
> Thanks for the report. To be sure the issue doesn't fall through the
> cracks unnoticed, I'm adding it to regzbot, the Linux kernel regression
> tracking bot:
> 
> #regzbot ^introduced 295525e29a
> #regzbot title virtio: network-related regression when using SWIOTLB in
> the guest
> #regzbot ignore-activity

Regzbot missed the fix due to a fluke:

#regzbot monitor:
https://lore.kernel.org/all/20230927055246.121544-1-xuanzhuo@linux.alibaba.com/
#regzbot fix: virtio_net: fix the missing of the dma cpu sync
#regzbot ignore-activity

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.


