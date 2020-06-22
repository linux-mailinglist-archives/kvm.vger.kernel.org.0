Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A62D2033F5
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 11:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbgFVJuU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 05:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbgFVJuT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 05:50:19 -0400
Received: from merlin.infradead.org (unknown [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72349C061794;
        Mon, 22 Jun 2020 02:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FgJqhSMDuS1bEt5YpsIUnPInR/NPLkaZgZVBwXeZAhg=; b=P7xlkvAjUReLOyGYIDhsQodRGg
        ppOFu3b69WkAHligAX7DWYSi34He90JPkvSOJ+QxpjuX6UxudeeLYOrABMSKKd5AbBTjmlBCY+RqW
        K2PmlLLjCvaSPYNDzfrHC805q7oLj/CLtshH8bUBwsw0uSmr/MVANtjjAb5dx8EUuuRSLYgVx2fVi
        0kb9xMewkeVXElWHG4Bvpv/QiNQRC5ZG8UiiR0DFMvK6wt40UGDKrUcgJ0pb3UN+fwYqtm+Qm09BW
        5kalJb/xSGHFPMW+/EcWI66iOKuy1AbyV3wh3Eqe39wZnrn90N1B/b1W+Qd3Hd8PxjLGesqpSqQyG
        AslqJH5g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jnJ4w-0007qp-2S; Mon, 22 Jun 2020 09:49:26 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id EAFE830018A;
        Mon, 22 Jun 2020 11:49:23 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5685129C119A6; Mon, 22 Jun 2020 11:49:23 +0200 (CEST)
Date:   Mon, 22 Jun 2020 11:49:23 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     syzbot <syzbot+dbf8cf3717c8ef4a90a0@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org,
        elver@google.com
Subject: Re: linux-next build error (9)
Message-ID: <20200622094923.GP576888@hirez.programming.kicks-ass.net>
References: <000000000000c25ce105a8a8fcd9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000c25ce105a8a8fcd9@google.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 22, 2020 at 02:37:12AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    27f11fea Add linux-next specific files for 20200622
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=138dc743100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=41c659db5cada6f4
> dashboard link: https://syzkaller.appspot.com/bug?extid=dbf8cf3717c8ef4a90a0
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+dbf8cf3717c8ef4a90a0@syzkaller.appspotmail.com
> 
> ./arch/x86/include/asm/kvm_para.h:99:29: error: inlining failed in call to always_inline 'kvm_handle_async_pf': function attribute mismatch
> ./arch/x86/include/asm/processor.h:824:29: error: inlining failed in call to always_inline 'prefetchw': function attribute mismatch
> ./arch/x86/include/asm/current.h:13:44: error: inlining failed in call to always_inline 'get_current': function attribute mismatch
> arch/x86/mm/fault.c:1353:1: error: inlining failed in call to always_inline 'handle_page_fault': function attribute mismatch
> ./arch/x86/include/asm/processor.h:576:29: error: inlining failed in call to always_inline 'native_swapgs': function attribute mismatch
> ./arch/x86/include/asm/fsgsbase.h:33:38: error: inlining failed in call to always_inline 'rdgsbase': function attribute mismatch
> ./arch/x86/include/asm/irq_stack.h:40:29: error: inlining failed in call to always_inline 'run_on_irqstack_cond': function attribute mismatch
> ./include/linux/debug_locks.h:15:28: error: inlining failed in call to always_inline '__debug_locks_off': function attribute mismatch
> ./include/asm-generic/atomic-instrumented.h:70:1: error: inlining failed in call to always_inline 'atomic_add_return': function attribute mismatch
> kernel/locking/lockdep.c:396:29: error: inlining failed in call to always_inline 'lockdep_recursion_finish': function attribute mismatch
> kernel/locking/lockdep.c:4725:5: error: inlining failed in call to always_inline '__lock_is_held': function attribute mismatch

Hurmph, I though that was cured in GCC >= 8. Marco?
