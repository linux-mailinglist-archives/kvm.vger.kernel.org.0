Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE447BC54D
	for <lists+kvm@lfdr.de>; Sat,  7 Oct 2023 09:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343635AbjJGHAy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Oct 2023 03:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343619AbjJGHAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Oct 2023 03:00:52 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D690B9;
        Sat,  7 Oct 2023 00:00:50 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-5a24b03e22eso34936527b3.0;
        Sat, 07 Oct 2023 00:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696662049; x=1697266849; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YnfoQgMMaMo+kmoHZw9YFZRQVA12CCqdV8ZSaSWHNtA=;
        b=VTKak95uQDiNkUcKU3wAupEaJOulTMzHHnulQSSAZ2p1BbK8sDrZcBVdUdFlbZw6oA
         WdSlWc+TLx6Be0R8h3jGwuPc9ci0i7xKPvCx6ZOqEEwcmvuTvx9kBf/z4izrWdLr2rL2
         fr+3sNGtlHh3EqHrmWfaa9Sci8sFQahj4rdO39z9ALSc96bpE+9+xEQ2UvNg6Aq66nVh
         8LYibxkUH+KvuN6ETPd5uBxH/3O6jgmPF20Lpn26WPzIisYBsfdifZ+tWXpcJHkuCZpZ
         yHnhh16uEuiH7UA4UQQ4q+lD+8X03ahENfchkMm0w+Q9qIMW6AWLE/MoIc4Z7DRPPIY4
         Yp/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696662049; x=1697266849;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YnfoQgMMaMo+kmoHZw9YFZRQVA12CCqdV8ZSaSWHNtA=;
        b=GoaknORBrHWe1o8fqKLrHwLWJEh+DfTcnt2huL0JXSy5OYmmD/NaC2V794FR5XjHI/
         sAoMvQ4BbTFKxc60ae+n7Yd88b6romJGSXuyKewLYwkHEeNRHeI7k6rE5rukltUcmgIo
         lPL5wL68X09SNreK272aYOSADpPiZ5Ehg6uX9VYz68Vv/C0CnnwysYWyg0LxRIS2fbFL
         8Yuk68ifQ/PsQ1pg+NqLBN+jQNQzR7QK32vytoZ2dXY9BT0L5b95u57asGSyigL1Ae/z
         u3fheyQOO8egoHrfIpncAWSIQdOzvzbho2g3cgq5OBDSpDQ5OKni+nPMF1xCSseo2uvv
         5lUA==
X-Gm-Message-State: AOJu0YyBTXzIkZU8qtTe6KMj0OmhaAa6LfHxPShd8+dL7jJbqFzkylmk
        oCoJb4gkWA+H2fiSriIjTMg=
X-Google-Smtp-Source: AGHT+IHm1JJM1ZfN+0J2queRTRUBuKWa9i9CdExJECEhQkTndOqSZakxmSbnH+E+OkmiXFRxD8kQXA==
X-Received: by 2002:a05:690c:3207:b0:5a5:7ec:dc12 with SMTP id ff7-20020a05690c320700b005a507ecdc12mr6999509ywb.33.1696662049514;
        Sat, 07 Oct 2023 00:00:49 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id n20-20020a638f14000000b00563e1ef0491sm4497586pgd.8.2023.10.07.00.00.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Oct 2023 00:00:48 -0700 (PDT)
Message-ID: <553e3a0f-156b-e5d2-037b-2d9acaf52329@gmail.com>
Date:   Sat, 7 Oct 2023 15:00:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v4 01/12] KVM: x86/mmu: helpers to return if KVM honors
 guest MTRRs
Content-Language: en-US
To:     Yan Zhao <yan.y.zhao@intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        robert.hoo.linux@gmail.com, yuan.yao@linux.intel.com,
        kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230714064656.20147-1-yan.y.zhao@intel.com>
 <20230714065006.20201-1-yan.y.zhao@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230714065006.20201-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/7/2023 2:50 pm, Yan Zhao wrote:
> Added helpers to check if KVM honors guest MTRRs.
> The inner helper __kvm_mmu_honors_guest_mtrrs() is also provided to
> outside callers for the purpose of checking if guest MTRRs were honored
> before stopping non-coherent DMA.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>   arch/x86/kvm/mmu.h     |  7 +++++++
>   arch/x86/kvm/mmu/mmu.c | 15 +++++++++++++++
>   2 files changed, 22 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 92d5a1924fc1..38bd449226f6 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -235,6 +235,13 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>   	return -(u32)fault & errcode;
>   }
>   
> +bool __kvm_mmu_honors_guest_mtrrs(struct kvm *kvm, bool vm_has_noncoherent_dma);
> +
> +static inline bool kvm_mmu_honors_guest_mtrrs(struct kvm *kvm)
> +{
> +	return __kvm_mmu_honors_guest_mtrrs(kvm, kvm_arch_has_noncoherent_dma(kvm));
> +}
> +
>   void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
>   
>   int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1e5db621241f..b4f89f015c37 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4516,6 +4516,21 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
>   }
>   #endif
>   
> +bool __kvm_mmu_honors_guest_mtrrs(struct kvm *kvm, bool vm_has_noncoherent_dma)

According to the motivation provided in the comment, the function will no
longer need to be passed the parameter "struct kvm *kvm" but will rely on
the global parameters (plus vm_has_noncoherent_dma), removing "*kvm" ?

> +{
> +	/*
> +	 * If the TDP is enabled, the host MTRRs are ignored by TDP
> +	 * (shadow_memtype_mask is non-zero), and the VM has non-coherent DMA
> +	 * (DMA doesn't snoop CPU caches), KVM's ABI is to honor the memtype
> +	 * from the guest's MTRRs so that guest accesses to memory that is
> +	 * DMA'd aren't cached against the guest's wishes.
> +	 *
> +	 * Note, KVM may still ultimately ignore guest MTRRs for certain PFNs,
> +	 * e.g. KVM will force UC memtype for host MMIO.
> +	 */
> +	return vm_has_noncoherent_dma && tdp_enabled && shadow_memtype_mask;
> +}
> +
>   int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   {
>   	/*
