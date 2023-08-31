Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21AD78E9AE
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 11:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245653AbjHaJmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 05:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbjHaJmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 05:42:36 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F6ECF4;
        Thu, 31 Aug 2023 02:42:33 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1qbeC8-000162-8G; Thu, 31 Aug 2023 11:42:32 +0200
Message-ID: <d1157d83-1a1e-f20a-57a7-aa4d0388866b@leemhuis.info>
Date:   Thu, 31 Aug 2023 11:42:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Fwd: kvm: Windows Server 2003 VM fails to work on 6.1.44 (works
 fine on 6.1.43)
Content-Language: en-US, de-DE
To:     Linux Regressions <regressions@lists.linux.dev>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux KVM <kvm@vger.kernel.org>
References: <8cc000d5-9445-d6f1-f02e-4629a4a59e0e@gmail.com>
 <ZN2Ocgp63T0FBuZn@debian.me>
From:   "Linux regression tracking #update (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <ZN2Ocgp63T0FBuZn@debian.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1693474953;5f36d784;
X-HE-SMSGID: 1qbeC8-000162-8G
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[TLDR: This mail in primarily relevant for Linux kernel regression
tracking. See link in footer if these mails annoy you.]

On 17.08.23 05:05, Bagas Sanjaya wrote:
> On Wed, Aug 16, 2023 at 04:29:32PM +0700, Bagas Sanjaya wrote:
>> #regzbot introduced: v6.1.43..v6.1.44 https://bugzilla.kernel.org/show_bug.cgi?id=217799
>> #regzbot title: Windows Server 2003 VM boot hang (only 64MB RAM allocated)
> 
> #regzbot fix: https://lore.kernel.org/all/20230811155255.250835-1-seanjc@google.com

#regzbot fix: b41eb316c95c98d16dba2045c4890a3020f0a5
#regzbot ignore-activity

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.



