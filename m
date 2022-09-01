Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783995A966C
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 14:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiIAMMq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 08:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIAMMp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 08:12:45 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989C797507;
        Thu,  1 Sep 2022 05:12:43 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1oTj3o-0000jP-Dm; Thu, 01 Sep 2022 14:12:40 +0200
Message-ID: <04ce8956-3285-345a-4ce5-b78500729e42@leemhuis.info>
Date:   Thu, 1 Sep 2022 14:12:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Content-Language: en-US, de-DE
To:     kernel test robot <oliver.sang@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        lkp@lists.01.org, lkp@intel.com, regressions@lists.linux.dev
References: <YvpZYGa1Z1M38YcR@xsang-OptiPlex-9020>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [KVM] c3e0c8c2e8: leaking-addresses.proc..data..ro_after_init.
In-Reply-To: <YvpZYGa1Z1M38YcR@xsang-OptiPlex-9020>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1662034363;299e0616;
X-HE-SMSGID: 1oTj3o-0000jP-Dm
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, this is your Linux kernel regression tracker.

On 15.08.22 16:34, kernel test robot wrote:
> Greeting,
> 
> FYI, we noticed the following commit (built with gcc-11):
> 
> commit: c3e0c8c2e8b17bae30d5978bc2decdd4098f0f99 ("KVM: x86/mmu: Fully re-evaluate MMIO caching when SPTE masks change")
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> 
> in testcase: leaking-addresses
> version: leaking-addresses-x86_64-4f19048-1_20220518
> with following parameters:
> 
> 	ucode: 0x28
> 
> 
> 
> on test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz with 16G memory
> 
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> 
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <oliver.sang@intel.com>
>
> [...]
>
> #regzbot introduced: c3e0c8c2e8

Removing this from the list of tracked regressions:

#regzbot invalid: report from the kernel test report that was ignored by
developers, so I assume it's not something bad

To explain: Yeah, maybe tracking regressions found by CI systems in
regzbot might be a good idea now or in the long run. If you are from
Intel and would like to discuss how to do this, please get in touch (I
tried recently, but got no answer[1]).

But I'm not sure if it's a good idea right now to get regzbot involved
by default (especially as long as the reports are not telling developers
to add proper "Link:" tags that would allow regzbot to notice when fixes
for the problem are posted or merged; see [1] and [2]), as it looks like
developers ignore quite a few (many?) reports like the one partly quoted
above.

I guess there are various reasons why developers do so (too many false
positives? issues unlikely to happen in practice? already fixed?).
Normally I'd say "this is a regression and I should try to find out and
prod developers to get it fixed". And I'll do that if the issue
obviously looks important to a Linux kernel generalist like me.

But that doesn't appear to be the case here (please correct me if I
misjudged!). I hence chose to ignore this report, as there are quite a
few other reports that are waiting for my attention, too. :-/

Ciao, Thorsten

[1]
https://lore.kernel.org/all/384393c2-6155-9a07-ebd4-c2c410cbe947@leemhuis.info/


[2] https://docs.kernel.org/process/handling-regressions.html
