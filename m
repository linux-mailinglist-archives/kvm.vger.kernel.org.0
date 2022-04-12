Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6250C4FCB94
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 03:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243925AbiDLBK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 21:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350975AbiDLBKe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 21:10:34 -0400
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C22E13FA7;
        Mon, 11 Apr 2022 18:07:29 -0700 (PDT)
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1ne503-0007LK-4Y; Tue, 12 Apr 2022 03:07:19 +0200
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Anup Patel <apatel@ventanamicro.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: Fixes tags need some work in the kvm-fixes tree
Date:   Tue, 12 Apr 2022 03:07:18 +0200
Message-ID: <2099797.irdbgypaU6@diego>
In-Reply-To: <20220412080045.301da5ef@canb.auug.org.au>
References: <20220412080045.301da5ef@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am Dienstag, 12. April 2022, 00:00:45 CEST schrieb Stephen Rothwell:
> Hi all,
> 
> In commit
> 
>   4054eee92902 ("RISC-V: KVM: include missing hwcap.h into vcpu_fp")
> 
> Fixes tag
> 
>   Fixes: 0a86512dc113 ("RISC-V: KVM: Factor-out FP virtualization into separate

hmm, when I sent it [0], the fixes tag was
Fixes: 0a86512dc113 ("RISC-V: KVM: Factor-out FP virtualization into separate sources")

Did it get somehow mangled when the patch got applied?


[0] https://lore.kernel.org/all/20220408092415.1603661-1-heiko@sntech.de/

> 
> has these problem(s):
> 
>   - Subject has leading but no trailing parentheses
>   - Subject has leading but no trailing quotes
> 
> In commit
> 
>   ebdef0de2dbc ("KVM: selftests: riscv: Fix alignment of the guest_hang() function")
> 
> Fixes tag
> 
>   Fixes: 3e06cdf10520 ("KVM: selftests: Add initial support for RISC-V
> 
> has these problem(s):
> 
>   - Subject has leading but no trailing parentheses
>   - Subject has leading but no trailing quotes
> 
> In commit
> 
>   fac372536439 ("KVM: selftests: riscv: Set PTE A and D bits in VS-stage page table")
> 
> Fixes tag
> 
>   Fixes: 3e06cdf10520 ("KVM: selftests: Add initial support for RISC-V
> 
> has these problem(s):
> 
>   - Subject has leading but no trailing parentheses
>   - Subject has leading but no trailing quotes
> 
> Please do not split fixes tags over more than one line.
> 
> 




