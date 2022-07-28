Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B085842BE
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 17:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiG1POv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 11:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiG1POt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 11:14:49 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE435509B
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 08:14:48 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id l23so3697188ejr.5
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 08:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=J3mUKvqOIhR1isEB4odixIq+ylAJLUqOplX2ZGxP8jk=;
        b=MXZq5yDphA/cWKMgPecWnmU1ItmtyfoMt5mZF9NJaG+Cc/zsGhHRNzpbk/xpwFH3gr
         jRv5FFT/peMTn7u4SqbpH0Y455I0CR0TRa3CVGZ3fu4ngu2Hh/KBbrEkpegEoJ7JKR5x
         aSyqtn4ZhfiljUKvHva3drt0ts6pD5tHPfKrxavS++qCXTE8Oc7zv4+RO1WPfER69O8n
         uhUXoJqvnqCKwCBVguFIm+ZMQLPMyZjMPU7dh56jSQu3Cw483dd1R/bR31AYNTsg76TO
         m8zPM9u+Si773Y1ae38HuwB6WRyKU5FIBgsx+pQsKGBbXvnddcx8PosYgCrEHFW/eO3V
         HNLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=J3mUKvqOIhR1isEB4odixIq+ylAJLUqOplX2ZGxP8jk=;
        b=0ezJZsjc980Ac3/jlT2pa+jdwl3pcepPV93vYZLagTMfnVhBF3t1U6TqQxqXsRjVIa
         f7GbKpIGgvEqeV1Rr5dY6LdUt8khtBU/nBMLcEeTCoCm6cNf9hr478i2xcaO2bWH1qWs
         a5kRB3IBG/f9Hc6l2YZnjxTWf27ffLzsTwDuJZ+Am67qs7/VDiNoz8HHgpAt/UC4s2bc
         P4zdOnWoNPrsdRBrBEqxwHM8ywuUwoyUPsP/fa3jkqxRuLqV04FEaNQWu85zfCbdyBPW
         f1cK3Guq8IXO6lOU/roP+8VM7M8XJqkyL05HBemSV+plcgEMHlx7IUnITTMIeZb4u6ph
         kD1A==
X-Gm-Message-State: AJIora9kNqOfd+CCrHbHQt/PjRS/pR3Yif1L83K0byhbPiXB7nicP3nc
        SO/zk15TjXVez0QhLF9jp0SxxvLGCOUhRQ==
X-Google-Smtp-Source: AGRyM1uPm1ILXUHdqMBfMwSNpZAJVhk7zd36VYQQjuLvHC/I4QK4+l3K+aReikop+q2AWugSqfqLlg==
X-Received: by 2002:a17:906:9b86:b0:6fe:d37f:b29d with SMTP id dd6-20020a1709069b8600b006fed37fb29dmr21412459ejc.327.1659021286565;
        Thu, 28 Jul 2022 08:14:46 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id c12-20020a056402120c00b0043cc2c9f5adsm803625edw.40.2022.07.28.08.14.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 08:14:46 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <5ebdd6a3-9e45-f44e-9309-50bb00912326@redhat.com>
Date:   Thu, 28 Jul 2022 17:14:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3] KVM, x86/mmu: Fix the comment around
 kvm_tdp_mmu_zap_leafs()
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org
Cc:     seanjc@google.com, bgardon@google.com
References: <20220728030452.484261-1-kai.huang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220728030452.484261-1-kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/28/22 05:04, Kai Huang wrote:
> Now kvm_tdp_mmu_zap_leafs() only zaps leaf SPTEs but not any non-root
> pages within that GFN range anymore, so the comment around it isn't
> right.
> 
> Fix it by shifting the comment from tdp_mmu_zap_leafs() instead of
> duplicating it, as tdp_mmu_zap_leafs() is static and is only called by
> kvm_tdp_mmu_zap_leafs().
> 
> Opportunistically tweak the blurb about SPTEs being cleared to (a) say
> "zapped" instead of "cleared" because "cleared" will be wrong if/when
> KVM allows a non-zero value for non-present SPTE (i.e. for Intel TDX),
> and (b) to clarify that a flush is needed if and only if a SPTE has been
> zapped since MMU lock was last acquired.
> 
> Fixes: f47e5bbbc92f ("KVM: x86/mmu: Zap only TDP MMU leafs in zap range and mmu_notifier unmap")
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> v2->v3:
> 
>   - s/leafs/leaf
>   - Added Sean's Reviewed-by.
> 
> ---
>   arch/x86/kvm/mmu/tdp_mmu.c | 10 +++-------
>   1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 40ccb5fba870..bf2ccf9debca 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -924,9 +924,6 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>   }
>   
>   /*
> - * Zap leafs SPTEs for the range of gfns, [start, end). Returns true if SPTEs
> - * have been cleared and a TLB flush is needed before releasing the MMU lock.
> - *
>    * If can_yield is true, will release the MMU lock and reschedule if the
>    * scheduler needs the CPU or there is contention on the MMU lock. If this
>    * function cannot yield, it will not release the MMU lock or reschedule and
> @@ -969,10 +966,9 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
>   }
>   
>   /*
> - * Tears down the mappings for the range of gfns, [start, end), and frees the
> - * non-root pages mapping GFNs strictly within that range. Returns true if
> - * SPTEs have been cleared and a TLB flush is needed before releasing the
> - * MMU lock.
> + * Zap leaf SPTEs for the range of gfns, [start, end), for all roots. Returns
> + * true if a TLB flush is needed before releasing the MMU lock, i.e. if one or
> + * more SPTEs were zapped since the MMU lock was last acquired.
>    */
>   bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
>   			   bool can_yield, bool flush)

Queued, thanks.

Paolo
