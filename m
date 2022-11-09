Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C10B62284B
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 11:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiKIKXI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 05:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiKIKXH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 05:23:07 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F02B22283;
        Wed,  9 Nov 2022 02:23:05 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1osiEZ-0002Hd-H0; Wed, 09 Nov 2022 11:23:03 +0100
Message-ID: <1197176f-3508-0405-fad8-3645c81f474e@leemhuis.info>
Date:   Wed, 9 Nov 2022 11:23:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Content-Language: en-US, de-DE
To:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220731050342.56513-1-khuey@kylehuey.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [PATCH] x86/fpu: Allow PKRU to be (once again) written by ptrace.
In-Reply-To: <20220731050342.56513-1-khuey@kylehuey.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1667989385;16c15d3c;
X-HE-SMSGID: 1osiEZ-0002Hd-H0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Note: this mail is primarily send for documentation purposes and/or for
regzbot, my Linux kernel regression tracking bot. That's why I removed
most or all folks from the list of recipients, but left any that looked
like a mailing lists. These mails usually contain '#forregzbot' in the
subject, to make them easy to spot and filter out.]

[TLDR: I'm adding this regression report to the list of tracked
regressions; all text from me you find below is based on a few templates
paragraphs you might have encountered already already in similar form.]

Hi, this is your Linux kernel regression tracker.

On 31.07.22 07:03, Kyle Huey wrote:
> From: Kyle Huey <me@kylehuey.com>
> 
> When management of the PKRU register was moved away from XSTATE, emulation
> of PKRU's existence in XSTATE was added for APIs that read XSTATE, but not
> for APIs that write XSTATE. This can be seen by running gdb and executing
> `p $pkru`, `set $pkru = 42`, and `p $pkru`. On affected kernels (5.14+) the
> write to the PKRU register (which gdb performs through ptrace) is ignored.

Seem I missed this one, but apparently it needs tracking.

#regzbot ^introduced e84ba47e313dbc
#regzbot title x86/fpu: emulation of PKRU's existence in XSTATE missing
for APIs that write XSTATE
#regzbot ignore-activity
#regzbot monitor
https://lore.kernel.org/all/20221107063807.81774-1-khuey@kylehuey.com/

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.
