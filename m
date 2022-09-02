Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1CE5AACDA
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 12:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235959AbiIBKyR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 06:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235880AbiIBKyL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 06:54:11 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEBA2C9253;
        Fri,  2 Sep 2022 03:54:10 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1oU4JL-00041d-4F; Fri, 02 Sep 2022 12:54:07 +0200
Message-ID: <57c596f7-014f-1833-3173-af3bad2ca45d@leemhuis.info>
Date:   Fri, 2 Sep 2022 12:54:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [LKP] Re: [KVM] c3e0c8c2e8:
 leaking-addresses.proc..data..ro_after_init.
Content-Language: en-US, de-DE
To:     Philip Li <philip.li@intel.com>
Cc:     kernel test robot <oliver.sang@intel.com>,
        Kai Huang <kai.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        lkp@lists.01.org, lkp@intel.com, regressions@lists.linux.dev
References: <YvpZYGa1Z1M38YcR@xsang-OptiPlex-9020>
 <04ce8956-3285-345a-4ce5-b78500729e42@leemhuis.info>
 <YxCyhTES9Nk+S94y@rli9-MOBL1.ccr.corp.intel.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <YxCyhTES9Nk+S94y@rli9-MOBL1.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1662116050;0eb7858f;
X-HE-SMSGID: 1oU4JL-00041d-4F
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01.09.22 15:24, Philip Li wrote:
> On Thu, Sep 01, 2022 at 02:12:39PM +0200, Thorsten Leemhuis wrote:
>> Hi, this is your Linux kernel regression tracker.
>>
>> On 15.08.22 16:34, kernel test robot wrote:
>>> Greeting,
>>>
>>> FYI, we noticed the following commit (built with gcc-11):
>>>
>>> commit: c3e0c8c2e8b17bae30d5978bc2decdd4098f0f99 ("KVM: x86/mmu: Fully re-evaluate MMIO caching when SPTE masks change")
>>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
>>>
>>> in testcase: leaking-addresses
>>> version: leaking-addresses-x86_64-4f19048-1_20220518
>>> with following parameters:
>>>
>>> 	ucode: 0x28
>>>
>>> on test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz with 16G memory
>>>
>>> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
>>>
>>> If you fix the issue, kindly add following tag
>>> Reported-by: kernel test robot <oliver.sang@intel.com>
>>>
>>> [...]
>>>
>>> #regzbot introduced: c3e0c8c2e8
>>
>> Removing this from the list of tracked regressions:
>>
>> #regzbot invalid: report from the kernel test report that was ignored by
>> developers, so I assume it's not something bad
>>
>> To explain: Yeah, maybe tracking regressions found by CI systems in
>> regzbot might be a good idea now or in the long run. If you are from
>> Intel and would like to discuss how to do this, please get in touch (I
>> tried recently, but got no answer[1]).
> 
> Sorry, this was a mistake that we missed [1] to provide our reply. I will
> reply to the questions in that one soon.

Thx!

>> But I'm not sure if it's a good idea right now to get regzbot involved
>> by default (especially as long as the reports are not telling developers
>> to add proper "Link:" tags that would allow regzbot to notice when fixes
>
> Apologize again that we started to track mainline regression we found before
> we fully understand [2], which probably not the effective usage. Especially
> we missed the initial touch and led to more improper usage.

No worries, as maybe it's a good thing to have the 0day reports in
there, even if some of its reports don't get any traction. But having
them in the list of tracked regressions gives them some more visibility
for a while -- and at least one more set of eyes (mine) that take a look
at it. And it's not that much work for me or anybody else to close the
issue in regzbot (say after a week or two) if no developer acts on it
because it's irrelevant from their point of view. But would still be
better if they'd state that publicly themselves; in that case they even
could tell regzbot to ignore the issue; your report's could tell people
how to do that (e.g. "#regzbot invalid some_reason").

>> for the problem are posted or merged; see [1] and [2]), as it looks like
>> developers ignore quite a few (many?) reports like the one partly quoted
>> above.
>>
>> I guess there are various reasons why developers do so (too many false
>> positives? issues unlikely to happen in practice? already fixed?).
> 
> agree, not all reports we send out got response even it was reported on
> mainline (0day does wide range testing include the repos from developer,
> so the reports are against these repos and mainline/next).
> 
> Usuaally, we also ping/discuss with developer when an issue enters
> mainline if there's no response. This is one reason we tries to connect
> with regzbot to track the issue on mainline, but we missed the point that
> you mention below (it need look important).

I just want to prevent the list of tracked regressions becoming too long
(and thus obscure) due to many issues that are not worth tracking, as I
fear people will then start to ignore regzbot and its reports. :-/

>> Normally I'd say "this is a regression and I should try to find out and
>> prod developers to get it fixed". And I'll do that if the issue
>> obviously looks important to a Linux kernel generalist like me.
> 
> got it, thanks for the info, i found earlier you tracked a bug from kernel
> test robot, which should be the case that you thought it was important.

Yeah, some of the reports are valuable, that's why I guess it makes
sense to track at least some of them. The question is, how to filter the
bad ones out or how to pick just the valuable ones...

Are you or someone from the 0day team an LPC? Then we could discuss this
in person there.

>> But that doesn't appear to be the case here (please correct me if I
>> misjudged!). I hence chose to ignore this report, as there are quite a
>> few other reports that are waiting for my attention, too. :-/
> 
> Thanks, we will revisit our process and consult you before we do any actual
> action, and sorry for causing you extra effort to do cleanup.

No need to be sorry, everything is fine, up to some point I liked what
you did. :-D

Ciao, Thorsten
