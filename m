Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A505C5AD0A4
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 12:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237475AbiIEKrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 06:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237058AbiIEKr2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 06:47:28 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABB35247D;
        Mon,  5 Sep 2022 03:47:25 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1oV9dT-0007a7-OO; Mon, 05 Sep 2022 12:47:23 +0200
Message-ID: <7f2cf157-2d1e-8b19-57ef-adce50db047b@leemhuis.info>
Date:   Mon, 5 Sep 2022 12:47:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Content-Language: en-US, de-DE
To:     regressions@lists.linux.dev
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        lkp@lists.01.org
References: <Yvn60W/JpPO8URLY@xsang-OptiPlex-9020>
 <Yvq9wzXNF4ZnlCdk@google.com>
 <5034abb9-e176-d480-c577-1ec5dd47182b@redhat.com>
 <9bfeae26-b4b1-eedb-6cbd-b4f9f1e1cc55@redhat.com>
 <YvwYxeE4vc/Srbil@google.com>
 <d8290cbe-5d87-137a-0633-0ff5c69d57b0@redhat.com>
From:   Thorsten Leemhuis <linux@leemhuis.info>
Subject: Re: [KVM] e923b0537d: kernel-selftests.kvm.rseq_test.fail #forregzbot
In-Reply-To: <d8290cbe-5d87-137a-0633-0ff5c69d57b0@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1662374846;460815a9;
X-HE-SMSGID: 1oV9dT-0007a7-OO
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TWIMC: this mail is primarily send for documentation purposes and for
regzbot, my Linux kernel regression tracking bot. These mails usually
contain '#forregzbot' in the subject, to make them easy to spot and filter.

On 17.08.22 02:06, Gavin Shan wrote:
> 
> Yeah, the system for the coverage was likely having high CPU loads,
> which is similar
> to my (simulated) environment. I usually have my system being idle when
> running the
> coverage test cases. I didn't hit this specific failure before.
> 
> Lets leave it as of being. We can improve if needed in future :)

In that case:

#regzbot invalid: 0-day report that apparently can be ignoreD

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.
