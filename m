Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8ED177EC48
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 23:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346679AbjHPVyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 17:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236987AbjHPVxf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 17:53:35 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A2E2713
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 14:53:33 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-58c6564646aso20279097b3.2
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 14:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692222813; x=1692827613;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5U/ye/HLLHU/JJfiRkVc60C30cItgmeRYpMYP9FcKiM=;
        b=PWKIkyBQUmD6JPUwrnxbzNd/8go2kuU6pqHijYG6MCKbS9kxanLME/QPzswYYRp4Va
         WoUU6LxZ914BeCpkNYWlb+cvhi3jLBPQKu1t3sDe6WOzE2HQspYB65pEcFCznl+c1mPs
         fO9uXz3YD1XBECwkDUz2fn6669jnR+3PObslQ1IYmj1cdnShetOhqL3bhPjmz8vdQoFF
         91b6xWQXOXFioytRPTeMWM55Png+68nEIeEGxz56vStWZUOkG0+E4/w+5qoqo8nSHopv
         6N006dtsCweGdCw7Ot56OdHWsfE8zfsKhZ+OYDvh6bth827Dw6EByt9TbhXBcSnrTz9k
         xYvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692222813; x=1692827613;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5U/ye/HLLHU/JJfiRkVc60C30cItgmeRYpMYP9FcKiM=;
        b=e4cYwUDW6OKsBXSueqjvDbUij+RfEVlxdenWDOe33CZoYp7Poom/OrzMc5CEh5NxK7
         YhzoJK4m5jZ9jqgPDO46HezUJhs7iZ69bcSwAB2qlVWlJtAnu82/f2eSrFm5gN/rBAOM
         DRaXj0iRVSqG3iTWmVjTyOabYaOFlkKAeC5LqgepjiaV3Ln5Nu6LcWXEnU8AAdr5XWS/
         A3zf0a5yHqBvJJCO/UqteIb5GzPdxzQbOxPeD4P528+CC2VsfUBJVmG8v3RJSumBpwph
         1ixh+HBSFkWJEoi57Ai/y1mw/JAVxqRQNRTWxTlMjh8ymx3u+8JpiY4tWAZXkh1s0amo
         51sw==
X-Gm-Message-State: AOJu0YxB8dc8iN9Lp6Z5oFuPls3UCy2+qSzcIyzyNfrCkvi9NKWn5qJJ
        MeRqFaT9qKjy5k5qLIAb95Cfip6+5lU=
X-Google-Smtp-Source: AGHT+IGQotSeqquzPZzglE1yO40ugG8Roq/D5aKi1TxCw/8m7cn22zOorE24QGwVCCegSkXo40u2q2Wy9yM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ae52:0:b0:58c:8c9f:c05a with SMTP id
 g18-20020a81ae52000000b0058c8c9fc05amr40828ywk.9.1692222813109; Wed, 16 Aug
 2023 14:53:33 -0700 (PDT)
Date:   Wed, 16 Aug 2023 14:53:31 -0700
In-Reply-To: <20230719144131.29052-10-binbin.wu@linux.intel.com>
Mime-Version: 1.0
References: <20230719144131.29052-1-binbin.wu@linux.intel.com> <20230719144131.29052-10-binbin.wu@linux.intel.com>
Message-ID: <ZN1FW7krxOVs9uA8@google.com>
Subject: Re: [PATCH v10 9/9] KVM: x86: Expose LAM feature to userspace VMM
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com,
        guang.zeng@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

s/Expose/Advertise

And I would add an "enable" in there somehwere, because to Kai's point earlier in
the series about kvm_cpu_cap_has(), the guest can't actually use LAM until this
patch.  Sometimes we do just say "Advertise", but typically only for features
where there's not virtualization support, e.g. AVX instructions where the guest
can use them irrespective of what KVM says it supports.

This?

KVM: x86: Advertise and enable LAM (user and supervisor)

On Wed, Jul 19, 2023, Binbin Wu wrote:
> From: Robert Hoo <robert.hu@linux.intel.com>
> 
> LAM feature is enumerated by CPUID.7.1:EAX.LAM[bit 26].
> Expose the feature to userspace as the final step after the following
> supports:
> - CR4.LAM_SUP virtualization
> - CR3.LAM_U48 and CR3.LAM_U57 virtualization
> - Check and untag 64-bit linear address when LAM applies in instruction
>   emulations and VMExit handlers.
> 
> Exposing SGX LAM support is not supported yet. SGX LAM support is enumerated
> in SGX's own CPUID and there's no hard requirement that it must be supported
> when LAM is reported in CPUID leaf 0x7.
> 
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 7ebf3ce1bb5f..21d525b01d45 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -645,7 +645,7 @@ void kvm_set_cpu_caps(void)
>  	kvm_cpu_cap_mask(CPUID_7_1_EAX,
>  		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
>  		F(FZRM) | F(FSRS) | F(FSRC) |
> -		F(AMX_FP16) | F(AVX_IFMA)
> +		F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
>  	);
>  
>  	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
> -- 
> 2.25.1
> 
