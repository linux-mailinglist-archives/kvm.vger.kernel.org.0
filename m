Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D316673CF05
	for <lists+kvm@lfdr.de>; Sun, 25 Jun 2023 09:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbjFYHoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 03:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbjFYHod (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 03:44:33 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE9EE41;
        Sun, 25 Jun 2023 00:44:32 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-66c729f5618so866002b3a.1;
        Sun, 25 Jun 2023 00:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687679072; x=1690271072;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=neXY6jFf5rj9eQqLL93VzLNnPS2lbHcmyz9yh8r+rt8=;
        b=bnjx7r5qxdwXBqbQZwiVNQBpMixVG+rERy/3rkFI/f/FYxvZUFcDkTZpBhxbp3t4cw
         ZzLBLhJ01nxGWp/P6ELflDd9xcUxtPo5ordUHsqYVM7ocwxOopMLJ3XId4dRYJelyGrb
         XlJX20GcTgjtSLbMxcrTk2RR6jesbt+6lHdqLyVdPPuYBeMZMhpuZuDPsE9FfHKC/R2N
         WYIa1RqOKocxrBg/Gjfu57bwIRZ7w6I6X8B9wV4d5MgQgp5HPUeaKiTP2/rYp+JcEMhF
         6oKR8t65qyJGuCjueND6Lt/ZLJoICJcJ9XiZkyCGfJvH7oJ0CO7ELWWTa7TOi5n+HlR2
         ZMyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687679072; x=1690271072;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=neXY6jFf5rj9eQqLL93VzLNnPS2lbHcmyz9yh8r+rt8=;
        b=SqxVd0Uo4AUS8/5PjN2pBaN2bSD0LRefdY2BdxC3wnkSmsIsWtJ0glwMJPDX+bqgNO
         V35CPxFTsop+qq/lhhdmPZi+Yg6ieovcghojc4vGiJtLzQBXyS16awCGYvVvBk2qy60B
         IoYfW7TFYInGb+rArOmZrxur1uhStFTDyoPs9VHGxTxcubY0fX4gz5EWZs5dx+jy7cut
         cYMjbscqT7jeLLDOoTKmg5VMdje+lZLlkP7cPq7MGvPy15nlp2T8q54nZRBE4zVoNsRy
         en2GJWBDhb9bc23ImiLBdtrZx7AO05PAU4nqSdSOk5c4mgVxFRGugCxddVZ9wG/BKz7b
         z9bA==
X-Gm-Message-State: AC+VfDyPADnufnTD/+7+BDAelnqXjy2SKSkmV5i3Gw8psDt+/A7UAxtA
        rO7/7vX2hmyqlxCVGB3fhcY=
X-Google-Smtp-Source: ACHHUZ5CtLgdbmzpBs7x4v3vyTriQY7cmHDMyauQBQHe2dlAdEy6raDKswrsJGO4fXRCcEKR7cmtCg==
X-Received: by 2002:a05:6a00:2309:b0:668:7744:10ea with SMTP id h9-20020a056a00230900b00668774410eamr24033021pfh.18.1687679071861;
        Sun, 25 Jun 2023 00:44:31 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id c19-20020aa78813000000b00671aa6b4962sm684118pfo.114.2023.06.25.00.44.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Jun 2023 00:44:31 -0700 (PDT)
Message-ID: <a5398e4b-bb9f-9913-c436-7528479be2ee@gmail.com>
Date:   Sun, 25 Jun 2023 15:44:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH v4 06/13] KVM: x86/mmu: Bypass __handle_changed_spte()
 when clearing TDP MMU dirty bits
To:     Sean Christopherson <seanjc@google.com>,
        Vipin Sharma <vipinsh@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230321220021.2119033-1-seanjc@google.com>
 <20230321220021.2119033-7-seanjc@google.com>
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230321220021.2119033-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/3/2023 6:00 am, Sean Christopherson wrote:
> From: Vipin Sharma <vipinsh@google.com>
> 
> Drop everything except marking the PFN dirty and the relevant tracepoint
> parts of __handle_changed_spte() when clearing the dirty status of gfns in
> the TDP MMU.  Clearing only the Dirty (or Writable) bit doesn't affect
> the SPTEs shadow-present status, whether or not the SPTE is a leaf, or
> change the SPTE's PFN.  I.e. other than marking the PFN dirty, none of the
> functional updates handled by __handle_changed_spte() are relevant.
> 
> Losing __handle_changed_spte()'s sanity checks does mean that a bug could
> theoretical go unnoticed, but that scenario is extremely unlikely, e.g.
> would effectively require a misconfigured or a locking bug elsewhere.
> 
> Opportunistically remove a comment blurb from __handle_changed_spte()
> about all modifications to TDP MMU SPTEs needing to invoke said function,
> that "rule" hasn't been true since fast page fault support was added for
> the TDP MMU (and perhaps even before).
> 
> Tested on a VM (160 vCPUs, 160 GB memory) and found that performance of
> clear dirty log stage improved by ~40% in dirty_log_perf_test (with the
> full optimization applied).
> 
> Before optimization:
> --------------------
> Iteration 1 clear dirty log time: 3.638543593s
> Iteration 2 clear dirty log time: 3.145032742s
> Iteration 3 clear dirty log time: 3.142340358s
> Clear dirty log over 3 iterations took 9.925916693s. (Avg 3.308638897s/iteration)
> 
> After optimization:
> -------------------
> Iteration 1 clear dirty log time: 2.318988110s
> Iteration 2 clear dirty log time: 1.794470164s
> Iteration 3 clear dirty log time: 1.791668628s
> Clear dirty log over 3 iterations took 5.905126902s. (Avg 1.968375634s/iteration)
> 
> Link: https://lore.kernel.org/all/Y9hXmz%2FnDOr1hQal@google.com
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Reviewed-by: David Matlack <dmatlack@google.com>
> [sean: split the switch to atomic-AND to a separate patch]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/tdp_mmu.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 950c5d23ecee..467931c43968 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -517,7 +517,6 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
>    *	    threads that might be modifying SPTEs.
>    *
>    * Handle bookkeeping that might result from the modification of a SPTE.
> - * This function must be called for all TDP SPTE modifications.
>    */
>   static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>   				  u64 old_spte, u64 new_spte, int level,
> @@ -1689,8 +1688,10 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
>   							iter.old_spte, dbit,
>   							iter.level);
>   
> -		__handle_changed_spte(kvm, iter.as_id, iter.gfn, iter.old_spte,
> -				      iter.old_spte & ~dbit, iter.level, false);
> +		trace_kvm_tdp_mmu_spte_changed(iter.as_id, iter.gfn, iter.level,

Here the first parameter "kvm" is no longer used in this context.

Please help confirm that for clear_dirty_pt_masked(), should the "struct kvm 
*kvm" parameter
be cleared from the list of incoming parameters ?

> +					       iter.old_spte,
> +					       iter.old_spte & ~dbit);
> +		kvm_set_pfn_dirty(spte_to_pfn(iter.old_spte));
>   	}
>   
>   	rcu_read_unlock();
