Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A4C79BE90
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbjIKUsF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238093AbjIKNg7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 09:36:59 -0400
Received: from isrv.corpit.ru (isrv.corpit.ru [86.62.121.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4516ECC3
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 06:36:54 -0700 (PDT)
Received: from tsrv.corpit.ru (tsrv.tls.msk.ru [192.168.177.2])
        by isrv.corpit.ru (Postfix) with ESMTP id 6410320D21;
        Mon, 11 Sep 2023 16:36:54 +0300 (MSK)
Received: from [192.168.177.130] (mjt.wg.tls.msk.ru [192.168.177.130])
        by tsrv.corpit.ru (Postfix) with ESMTP id 4431627462;
        Mon, 11 Sep 2023 16:36:52 +0300 (MSK)
Message-ID: <36a09211-1137-c7fc-4291-89ced56e0d8a@tls.msk.ru>
Date:   Mon, 11 Sep 2023 16:36:52 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH] target/i386: Re-introduce few KVM stubs for Clang debug
 builds
Content-Language: en-US
To:     Kevin Wolf <kwolf@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>
Cc:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org
References: <20230911103832.23596-1-philmd@linaro.org>
 <CAJSP0QWDcNhso5nNBMNziLSXZczcrGp=6FgGNOXvYEQ6=Giiug@mail.gmail.com>
 <ZP8I9B3O4CTwTTie@redhat.com>
From:   Michael Tokarev <mjt@tls.msk.ru>
In-Reply-To: <ZP8I9B3O4CTwTTie@redhat.com>
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

11.09.2023 15:32, Kevin Wolf wrote:
..
> 
> The approach with static inline functions defined only for a very
> specific configuration looks a lot more fragile to me. In fact, I'm
> surprised that it works because I think it requires that the header
> isn't used in any files that are shared between user space and system
> emulation - and naively cpu.c sounded like something that could be
> shared. Looks like this patch only works because the linux-user target
> uses a separate build of the same CPU emulation source file.

That's why both I and Stephan disliked the #ifdef condition, not the
approach.  If it were me, I'd change the condition to be !KVM and keep
the inline functions (or #defines for that matter), instead of re-
introducing stubs in a separate .c file.

/mjt
