Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67913720A7
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 21:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhECTmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 15:42:39 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49260 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhECTmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 15:42:38 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620070904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R89mha3W7dggNcHio8mKK09HcaBedKHLYwCG8+sIhQk=;
        b=baebpRmFzGasqi47KSv9CzosBnOiLYNu8TAQWs4HYL8bMXuO3WHl9PW+6B2wB2AHbx27rY
        oOoUfxBV37pDJYArt3WLnjTje5ja5x3UuYgZe+3XejjGC6KButNajyEr+v07Edoyiy3kHY
        c48uBhmkG0bWfoGuoCo8YiNsgbQDzNgJBfBp97ly7hDxC0o2vlwN5eDjufS0Kj2655+N9I
        1sRye9evLpVS4KWl2tnj1rrHO1TOMwMmvmTZSo/oiNE52v5yb9gRdFgMRILpKdoV9cp4oz
        YN6n4Am8JaNeey9jU2D5lUWhA6o6aTZm1mb5xm32PwtUdtQPjc9kG8iGX5ILXQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620070904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R89mha3W7dggNcHio8mKK09HcaBedKHLYwCG8+sIhQk=;
        b=VsoMRqDg8qyFRWUYjcU0Jkt5wjqQb3YctqCuac4VSxwB6NvvlM+s+7EveLibUxsYy8sW9y
        F+QEywnUKLPnq5CQ==
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Joerg Roedel <jroedel@suse.de>, Jian Cai <caij2003@gmail.com>,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH 1/4] x86/xen/entry: Rename xenpv_exc_nmi to noist_exc_nmi
In-Reply-To: <87r1ind4ee.ffs@nanos.tec.linutronix.de>
References: <20210426230949.3561-1-jiangshanlai@gmail.com> <20210426230949.3561-2-jiangshanlai@gmail.com> <87r1ind4ee.ffs@nanos.tec.linutronix.de>
Date:   Mon, 03 May 2021 21:41:44 +0200
Message-ID: <87h7jjk3k7.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 03 2021 at 21:05, Thomas Gleixner wrote:

> On Tue, Apr 27 2021 at 07:09, Lai Jiangshan wrote:
>> From: Lai Jiangshan <laijs@linux.alibaba.com>
>>
>> There is no any functionality change intended.  Just rename it and
>> move it to arch/x86/kernel/nmi.c so that we can resue it later in
>> next patch for early NMI and kvm.
>
> 'Reuse it later' is not really a proper explanation why this change it
> necessary.
>
> Also this can be simplified by using aliasing which keeps the name
> spaces intact.

Aside of that this is not required to be part of a fixes series which
needs to be backported.

Thanks,

        tglx
