Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6237580398
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 19:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbiGYRjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 13:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiGYRjJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 13:39:09 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C842E1C92B
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 10:39:08 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id c13so4356750pla.6
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 10:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j/9axANDPZzcW8GWRZp/PFt+K4lZyPsMVU9uKkGSr9A=;
        b=Sf7oKuXYBBXQ/VOAOuwVu1q0feOolaNLZ2haVuLZSdExMVMpBVePGTPr0gU0dn4PmZ
         HlwDBV+JrWjVB2V1HFbhaexvXZAY1JihUV2NLMGTXNgNzToqvus6WTcPIYOpskQY4M4p
         vZAapAWpsejAnseXUSLQ0v2zbeeJfLkrTSaLvpY+RVRYtBodsnKcH9QSTWsuQ+o2kK8S
         Ti2Fz+BSRsESrHmGkU/6qZaw1BfS9hkQ23Q2LV0yLXGvS+Q4smCLBRLO1DF6tf9VZ6DN
         Ohw2SRr1KdkHLPxSeFKeXDwH8MVf9UtHdHJKKDn+7N0xufBjvw7GkjZftQNHRei7Lz72
         C//w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j/9axANDPZzcW8GWRZp/PFt+K4lZyPsMVU9uKkGSr9A=;
        b=viNLSQ5mMXmBGUwNP9YCR5ma8AGOS4M+Fv3ERz6X9piqm1GDhcLCZ2ObjetmUSyHVV
         EA93FidZyB4Dt8Qv/M3OgVjXzQ02IX3MweebazYfvOZMvK4tgpj+Nl/yrATFbIceuPat
         dIHQNVr5DHizGWN1vnFrk8q+932I9gBp2OLI6H+93SD4YkF/iznxcef5epjMZDL8A/Rf
         EOCN4d0MC2iTmZZfbh72TdbYgo64cf0YwVNBRS4wJTGcQ+iLPhCWcOfFRJTqHgO5EJKw
         n1rTmWopJ8HfI8CObHAFri6bUsWR4XUORb3AaVDcEgWWOIaeG8xOVtoBN/ZF7IoBypGq
         Ffdw==
X-Gm-Message-State: AJIora/+UnyqiYsJVpgcQHEEpz+QB8BB3fylGcjOUKjXeGcvpkx+Mdyf
        01d6Rnz6qhuzU/csOY1KvdnN/+UsvLP5ww==
X-Google-Smtp-Source: AGRyM1vRN2V6JdWnQVnPi6awlkCEIn6TcU7EFG+7AkvMZf5ZLT51K5DoeO+mZWyjuRt/zkbnJb6EMg==
X-Received: by 2002:a17:90b:681:b0:1f2:147a:5e55 with SMTP id m1-20020a17090b068100b001f2147a5e55mr15425522pjz.159.1658770748088;
        Mon, 25 Jul 2022 10:39:08 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id v12-20020aa799cc000000b00528f9597fb3sm9858745pfi.197.2022.07.25.10.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 10:39:07 -0700 (PDT)
Date:   Mon, 25 Jul 2022 10:39:02 -0700
From:   David Matlack <dmatlack@google.com>
To:     Junaid Shahid <junaids@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Subject: Re: [PATCH] kvm: x86: mmu: Drop the need_remote_flush() function
Message-ID: <Yt7VNt2bsdNtyqZl@google.com>
References: <20220723024316.2725328-1-junaids@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220723024316.2725328-1-junaids@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 22, 2022 at 07:43:16PM -0700, Junaid Shahid wrote:
> This is only used by kvm_mmu_pte_write(), which no longer actually
> creates the new SPTE and instead just clears the old SPTE. So we
> just need to check if the old SPTE was shadow-present instead of
> calling need_remote_flush(). Hence we can drop this function. It was
> incomplete anyway as it didn't take access-tracking into account.
> 
> This patch should not result in any functional change.

Even if we don't assume anything about the new SPTE, this commit flushes
TLBs in a superset of the current cases. So this change should
definitely be safe.

And then if we assume new SPTE is 0 (which it should be), I agree this
should not result in any functional change.

Reviewed-by: David Matlack <dmatlack@google.com>

> 
> Signed-off-by: Junaid Shahid <junaids@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index f0d7193db455..39959841beee 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5333,19 +5333,6 @@ void kvm_mmu_free_obsolete_roots(struct kvm_vcpu *vcpu)
>  	__kvm_mmu_free_obsolete_roots(vcpu->kvm, &vcpu->arch.guest_mmu);
>  }
>  
> -static bool need_remote_flush(u64 old, u64 new)
> -{
> -	if (!is_shadow_present_pte(old))
> -		return false;
> -	if (!is_shadow_present_pte(new))
> -		return true;
> -	if ((old ^ new) & SPTE_BASE_ADDR_MASK)
> -		return true;
> -	old ^= shadow_nx_mask;
> -	new ^= shadow_nx_mask;
> -	return (old & ~new & SPTE_PERM_MASK) != 0;
> -}
> -
>  static u64 mmu_pte_write_fetch_gpte(struct kvm_vcpu *vcpu, gpa_t *gpa,
>  				    int *bytes)
>  {
> @@ -5491,7 +5478,7 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>  			mmu_page_zap_pte(vcpu->kvm, sp, spte, NULL);
>  			if (gentry && sp->role.level != PG_LEVEL_4K)
>  				++vcpu->kvm->stat.mmu_pde_zapped;
> -			if (need_remote_flush(entry, *spte))
> +			if (is_shadow_present_pte(entry))
>  				flush = true;
>  			++spte;
>  		}
> 
> base-commit: a4850b5590d01bf3fb19fda3fc5d433f7382a974
> -- 
> 2.37.1.359.gd136c6c3e2-goog
> 
