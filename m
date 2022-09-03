Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D475ABE75
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 12:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiICK13 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Sep 2022 06:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiICK10 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Sep 2022 06:27:26 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008AB86C1A;
        Sat,  3 Sep 2022 03:27:24 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1oUQMz-0000Ns-D2; Sat, 03 Sep 2022 12:27:21 +0200
Message-ID: <e633e50a-a72a-0d55-7c96-a1853eff1b8e@leemhuis.info>
Date:   Sat, 3 Sep 2022 12:27:19 +0200
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
 <57c596f7-014f-1833-3173-af3bad2ca45d@leemhuis.info>
 <YxH2X8gMWyJeKPRa@rli9-MOBL1.ccr.corp.intel.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <YxH2X8gMWyJeKPRa@rli9-MOBL1.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1662200845;1b1e06bf;
X-HE-SMSGID: 1oUQMz-0000Ns-D2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02.09.22 14:26, Philip Li wrote:
> On Fri, Sep 02, 2022 at 12:54:05PM +0200, Thorsten Leemhuis wrote:
>> On 01.09.22 15:24, Philip Li wrote:
>>> On Thu, Sep 01, 2022 at 02:12:39PM +0200, Thorsten Leemhuis wrote:
>
> [...]
>
> Thanks for the encouragement :-) The flow/process is very helpful. We will follow
> up a few things before we resuming the tracking
> [...]

Great, thx!

>>> Usuaally, we also ping/discuss with developer when an issue enters
>>> mainline if there's no response. This is one reason we tries to connect
>>> with regzbot to track the issue on mainline, but we missed the point that
>>> you mention below (it need look important).
>>
>> I just want to prevent the list of tracked regressions becoming too long
>> (and thus obscure) due to many issues that are not worth tracking, as I
>> fear people will then start to ignore regzbot and its reports. :-/
> 
> got it, we will be very careful to selectly tracking. Maybe we don't need
> track the issue if it is responsed by developer quickly and can be solved
> directly.

Maybe, but that will always bear the risk that something gets in the way
(say a big problem is found in the proposed fix) and the regression in
the end gets forgotten and remains unfixed -- which my tracking tries to
prevent. Hence I'd say doing it the other way around (adding all
regressions reported by the 0-day folks to regzbot and remove reports
after a week or two if it's apparently something that can be ignored)
would be the better approach.

> But only track the one that is valuable, while it need more discussion, extra
> testing, investigation and so one, that such problem can't be straight forward
> to solve in short time. For such case, the tracking helps us to get back to this
> even when there's a pause, like developer is blocked by testing or need switch
> to other effort. This is just my thinking.

Yeah, the problem is just: it's easy to forget the regression to the
tracking. :-/

>> Are you or someone from the 0day team an LPC? Then we could discuss this
>> in person there.
> 
> We will join 2 MC (Rust, Testing) but all virtually, thus not able to discuss in
> person :-( 

Okay, was worth asking. :-D

> But we are glad to join any further discussion or follow the suggested
> rule if you have some discussion with other CI and reporters.

Yeah, I'm pretty sure we'll find a way to make everybody happy.

Ciao, Thorsten
