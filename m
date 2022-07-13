Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8762A573588
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 13:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236065AbiGMLf5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 07:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiGMLf4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 07:35:56 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E9A83F2F;
        Wed, 13 Jul 2022 04:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=U1F/5wzv0m7wpoKemUgjlptyrRXhgHhVMVcmpHAB8AE=; b=ouXY6Sii0FO9X18TUWdXujmX+l
        nT8Tesdc6ekDaNHh/OnAGW3bI55SeuvzZZVYS9MxYlzg4sI6H1GGQFGL5lik9ww4fMhpzGjHfO4VO
        tXl4pgnvLC3CPa3Ld8gEkDvGyQyJVS9wD3ckp2EQfi+TeQ6yCcbyF0BtQzjvpWGT+U1RTo2Sen9XJ
        jG/XiI+PcUpX7nge8bsfjndRNavOnJQ1vdkd/gtNcTCq1zyBYo9zJrMIUEBBwWzAlSGcR6V97ht49
        ZV4gee4B9sXAeIBajt9QNvvT3FjLL6wBQyUNvOMBDyAf/PoNa8BpLu5iaMBsLc6CKEF2HxQHUuWaa
        xx8Rn2gg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oBaeL-003XvT-8O; Wed, 13 Jul 2022 11:35:25 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7297C300238;
        Wed, 13 Jul 2022 13:35:22 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 57578201ECFBD; Wed, 13 Jul 2022 13:35:22 +0200 (CEST)
Date:   Wed, 13 Jul 2022 13:35:22 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>, Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: mainline build failure due to fc02735b14ff ("KVM: VMX: Prevent
 guest RSB poisoning attacks with eIBRS")
Message-ID: <Ys6t+q4/y4DTjLQh@hirez.programming.kicks-ass.net>
References: <Ys6sZj6KYthnDppq@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys6sZj6KYthnDppq@debian>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 13, 2022 at 12:28:38PM +0100, Sudip Mukherjee (Codethink) wrote:
> Hi All,
> 
> The latest mainline kernel branch fails to build for x86_64 allmodconfig
> with clang and the error is:
> 
> arch/x86/kernel/cpu/bugs.c:58:21: error: section attribute is specified on redeclared variable [-Werror,-Wsection]
> DEFINE_PER_CPU(u64, x86_spec_ctrl_current);
>                     ^
> ./arch/x86/include/asm/nospec-branch.h:283:12: note: previous declaration is here
> extern u64 x86_spec_ctrl_current;
> 
> 
> git bisect pointed to fc02735b14ff ("KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS")
> 
> I will be happy to test any patch or provide any extra log if needed.

I suspect something like this will do.

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index bb05ed4f46bd..6398d39e66b0 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -280,7 +280,7 @@ static inline void indirect_branch_prediction_barrier(void)
 
 /* The Intel SPEC CTRL MSR base value cache */
 extern u64 x86_spec_ctrl_base;
-extern u64 x86_spec_ctrl_current;
+DECLARE_PER_CPU(u64, x86_spec_ctrl_current);
 extern void write_spec_ctrl_current(u64 val, bool force);
 extern u64 spec_ctrl_current(void);
 
