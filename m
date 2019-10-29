Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4FBEE8531
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2019 11:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728964AbfJ2KOa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Oct 2019 06:14:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38782 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfJ2KOa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Oct 2019 06:14:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=X1R5IVBASQ5ORVml6FyX2cr6AOsLH2Mknjf9io4LIe8=; b=1yhI3BeqAbf7io9KPunNhkjBt
        DMZBPHf0OXV1rwba2CMC0qnqdHjFe9PEA3U2Wu7gxdBkYxL0gSBOvFmqGmo+R4N9NpV+r9/rW67If
        5y2uJfVHiA3Mp48dL6Ips2wGNBOH0dEhxahiI83qaal1nVyKAnqlzTF3v9wj6cFt0jqhP1Y4SqfCa
        XiHp26Pg7OL3p72pAbQjP+WK9ZkKWxzlhmja24RX9SS1LVQzLZbHxN6r4e82qHUC6/+PYbmnZ8fCb
        NhH/c7qrHGi+OzmWM/xr7+1C3vA5zdJ7ZsYrkcDU6mG4K+1BVgKKK6X5M/5RmhBYIMW9QMJGyubTF
        EcN6dbBZA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPOUo-0001oh-Km; Tue, 29 Oct 2019 10:13:55 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2F656300596;
        Tue, 29 Oct 2019 11:11:59 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5F1392B3F7754; Tue, 29 Oct 2019 11:13:00 +0100 (CET)
Date:   Tue, 29 Oct 2019 11:13:00 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Saurav Girepunje <saurav.girepunje@gmail.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        saurav.girepunje@hotmail.com
Subject: Re: [PATCH] arch: x86: kvm: mmu.c: use true/false for bool type
Message-ID: <20191029101300.GK4114@hirez.programming.kicks-ass.net>
References: <20191029094104.GA11220@saurav>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029094104.GA11220@saurav>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 29, 2019 at 03:11:04PM +0530, Saurav Girepunje wrote:
> Use true/false for bool type "dbg" in mmu.c
> 
> Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
> ---
>  arch/x86/kvm/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 24c23c66b226..c0b1df69ce0f 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -68,7 +68,7 @@ enum {
>  #undef MMU_DEBUG
>  
>  #ifdef MMU_DEBUG
> -static bool dbg = 0;
> +static bool dbg = true;

You're actually changing the value from false to true. Please, if you
don't know C, don't touch things.
