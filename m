Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C0E3F0A51
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 19:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbhHRRd1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 13:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhHRRdZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 13:33:25 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E60C0613CF
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 10:32:50 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 18so2861141pfh.9
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 10:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fVKZsT+Q3OfgRc24D0p1eUapXHm5LE2GOxGEpWBijc8=;
        b=n6cuZ8j3fQluVHZ3YlBe7mWWvyjrELvnmRdKYkP5jtO8TUJeG9/E2Fuag7tvA/jxa0
         y96Q+LRNT8Tl8+HxbhlBeV1J6bsr8p7/1MWmKfCTtQNXxMMuFxEjlqPaxcGe1A996FQM
         f9DGwU3yYk1EcUZ57r5xBoAwyoVAW4x99I6LGBkFiKdZ5OqpoEezjSrUa68rrWRdcRXx
         KV3pqP9ykKetG6Xrom6vFvdGEN4pbnvocU5iJluB4cqjCjNvOxKRgrPIVk/11SEN8HFK
         ttYPHTP2MwIzVoCtbw0Oq5aQOlcKsepVi0dSF4M6qr/2Ydzorg6GQE16XGPCCozSITAI
         XoEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fVKZsT+Q3OfgRc24D0p1eUapXHm5LE2GOxGEpWBijc8=;
        b=DfcX2SSxNTt4oDUDcwDE5mWeM3ffS5o6p1I61ZBd9S6gSn69nNyISdo5igHezfEfpr
         f1bkpZ79/yicaM3QkCmq4Uz4SmhkhuXv5pGcG3QNvb0B+5ihcOhXJv7a5/NGGnC+YF55
         iplGmjaYM+ZnQecTx5mv8wwuBEYxHUD+CJ1RPyhNi+XmSWtGpNAuGChbQr0yD503AUhG
         Fr+ssHW+Thj4VM25IEVM+hOmnMNXJivt1TLCHWgkUeP+R3uyELhJqJkIaJ8Ok7Q4t9hH
         U1QlCGwcMyKiSXhpvaKoK7fP9zCH7kx1Nl2Xre+FIcSf8uJkBzSrTF+WYLzU0pVZ4EE2
         6Kow==
X-Gm-Message-State: AOAM531+knEbWZ4W+2nuEwz+pR+t8nRcypbRAF8hwi9aBLPhh2l4rgQf
        MzTUzv87QUzAK6UH7dzofLNMWA==
X-Google-Smtp-Source: ABdhPJy1pmTvyBJyBvUJtt9Nc7Er+ERsJc+J559LHncLHpgPB0qRGSKCQF+6cpmHhIL+mBqFasCuPw==
X-Received: by 2002:a63:1c66:: with SMTP id c38mr9951678pgm.286.1629307970276;
        Wed, 18 Aug 2021 10:32:50 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l12sm341988pff.182.2021.08.18.10.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 10:32:49 -0700 (PDT)
Date:   Wed, 18 Aug 2021 17:32:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wei Huang <wei.huang2@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com
Subject: Re: [PATCH v3 3/3] KVM: SVM: Add 5-level page table support for SVM
Message-ID: <YR1EPNRNtIZZ7LXd@google.com>
References: <20210818165549.3771014-1-wei.huang2@amd.com>
 <20210818165549.3771014-4-wei.huang2@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818165549.3771014-4-wei.huang2@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 18, 2021, Wei Huang wrote:
> When the 5-level page table is enabled on host OS, the nested page table
> for guest VMs must use 5-level as well. Update get_npt_level() function
> to reflect this requirement. In the meanwhile, remove the code that
> prevents kvm-amd driver from being loaded when 5-level page table is
> detected.
> 
> Signed-off-by: Wei Huang <wei.huang2@amd.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

If this patch authored by Paolo, he needs to be attributed via From:.  If Paolo
is a co-author, he needs a Co-developed-by:.  If either of those is true, your
SOB needs to be last in the chain since you are the last handler of the patch.
If neither is true, Paolo's SOB should be removed.

> ---
>  arch/x86/kvm/svm/svm.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b34840a2ffa7..ecc4bb8e4ea0 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -261,7 +261,9 @@ u32 svm_msrpm_offset(u32 msr)
>  static int get_max_npt_level(void)
>  {
>  #ifdef CONFIG_X86_64
> -	return PT64_ROOT_4LEVEL;
> +	bool la57 = (cr4_read_shadow() & X86_CR4_LA57) != 0;
> +
> +	return la57 ? PT64_ROOT_5LEVEL : PT64_ROOT_4LEVEL;

Why obfuscate this?  KVM is completely hosed if pgtable_l5_enabled() doesn't
match host CR4.  E.g.

	return pgtable_l5_enabled() ? PT64_ROOT_5LEVEL : PT64_ROOT_4LEVEL;

>  #else
>  	return PT32E_ROOT_LEVEL;
>  #endif
> @@ -462,11 +464,6 @@ static int has_svm(void)
>  		return 0;
>  	}
>  
> -	if (pgtable_l5_enabled()) {
> -		pr_info("KVM doesn't yet support 5-level paging on AMD SVM\n");
> -		return 0;
> -	}
> -
>  	return 1;
>  }
>  
> -- 
> 2.31.1
> 
