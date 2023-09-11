Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A242279BED6
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234549AbjIKUsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237147AbjIKME5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 08:04:57 -0400
Received: from isrv.corpit.ru (isrv.corpit.ru [86.62.121.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888BBE4B
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 05:04:49 -0700 (PDT)
Received: from tsrv.corpit.ru (tsrv.tls.msk.ru [192.168.177.2])
        by isrv.corpit.ru (Postfix) with ESMTP id 4B1C120C95;
        Mon, 11 Sep 2023 15:04:47 +0300 (MSK)
Received: from [192.168.177.130] (mjt.wg.tls.msk.ru [192.168.177.130])
        by tsrv.corpit.ru (Postfix) with ESMTP id 42CCB273DD;
        Mon, 11 Sep 2023 15:04:45 +0300 (MSK)
Message-ID: <4a3b1bee-52ed-d1e3-8ab4-7414c608329b@tls.msk.ru>
Date:   Mon, 11 Sep 2023 15:04:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH] target/i386: Re-introduce few KVM stubs for Clang debug
 builds
Content-Language: en-US
To:     Stefan Hajnoczi <stefanha@gmail.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
Cc:     qemu-devel <qemu-devel@nongnu.org>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm <kvm@vger.kernel.org>, Kevin Wolf <kwolf@redhat.com>
References: <20230911103832.23596-1-philmd@linaro.org>
 <CAJSP0QWDcNhso5nNBMNziLSXZczcrGp=6FgGNOXvYEQ6=Giiug@mail.gmail.com>
 <CAJSP0QVmxRPBVVq-JShUwiCvTK0WS2rM01c7=jDFquw3CRE+qw@mail.gmail.com>
From:   Michael Tokarev <mjt@tls.msk.ru>
In-Reply-To: <CAJSP0QVmxRPBVVq-JShUwiCvTK0WS2rM01c7=jDFquw3CRE+qw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

11.09.2023 14:56, Stefan Hajnoczi:
> Or instead of using linker behavior, maybe just change the #ifdef so it only applies when KVM is disabled. I didn't look at the code to see if this is 
> possible, but it would be nice to avoid the very specific #ifdef condition in this patch.

Yeah, this is definitely preferrable to define it based on !kvm instead of !optimize.

I mean the same thing when replied in the pullreq which broke things, - to base
it on !kvm.  But use something very similar to what Philippe did with the functions
themselves (not with the condition).

/mjt
