Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37D2153F9D3
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 11:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239555AbiFGJbZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 05:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239655AbiFGJbM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 05:31:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04C21E7300
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 02:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654594266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H2QEcF9zNfxK83VYiyTObfACqmNnbnuvwkQeHfTVQI8=;
        b=RX6Sa8rSDNNbj3vYOxPwQwtUSK4xXtJ1E1xaIuuLj9C8hACj5QNP+5YuEiJR6lJrNOZqK8
        uRaokfchWKg5nT5XmxWRswmIzTvYVK1jP/mV1cbTDO44hu/LhDO9l4+EgNn259L2p5/axt
        56H+s0u6ErL1v6hsGXL6AOm6vA9KHts=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-532-CxxZwTn_PW-U-DT_pIEikg-1; Tue, 07 Jun 2022 05:30:55 -0400
X-MC-Unique: CxxZwTn_PW-U-DT_pIEikg-1
Received: by mail-qv1-f71.google.com with SMTP id o99-20020a0c906c000000b00456332167ffso10460816qvo.13
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 02:30:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=H2QEcF9zNfxK83VYiyTObfACqmNnbnuvwkQeHfTVQI8=;
        b=WuTsvN2htmJ7yYcp62qeinrSdplglHgeb042t98wds5eA+gJoH/Gezs4P1gQTGPxP2
         bvJVqA73kUr/eiTqyBQa6jrw8xqEzlLlzIZUTq2ZnjImTJvil0Jyw0b2GkKO2EO7Hlii
         dZIktpw97cBaxOhcSMk7AGexlSm6lgGbA9tDo+2I4Rb6TQduG46m28nN1lekps0NxCtk
         FYyZVGiCpgbrajFMcdv7kHdrXQfroIYNmxCw3pBeRCyee9jZ8i2EZZBnwPe5Z0c57A8s
         7VnfwY9xk7EVKqq/hs6Lgt1lCvdRbF/1QKZDRPCz7k0r0csh9RhfLrdeG4cD569hUbvL
         9Hhw==
X-Gm-Message-State: AOAM530hOk5omop0Wd3i9tZ4J7/CcjNsBtdsU+afS40NevDLnLxPNk/R
        mojxlB3+5Uwimupx9JfR8jXO3L9dPd/N2wC09BQAIh9O7Gs6l5jnYkggij+dHELeNz/AA5CEKeB
        Jk2CaaR8RHGfa
X-Received: by 2002:a05:6214:76e:b0:467:cf81:7f3e with SMTP id f14-20020a056214076e00b00467cf817f3emr19178855qvz.89.1654594254669;
        Tue, 07 Jun 2022 02:30:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/yPpEqaQDpRYGzCS2MyTcWsJ1tIH3tkk9Os89pUL7Clazk1lVE+iO+ak9RitX1LJgcVIa0g==
X-Received: by 2002:a05:6214:76e:b0:467:cf81:7f3e with SMTP id f14-20020a056214076e00b00467cf817f3emr19178834qvz.89.1654594254405;
        Tue, 07 Jun 2022 02:30:54 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id hf22-20020a05622a609600b002f940d5ab2csm11116760qtb.74.2022.06.07.02.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 02:30:53 -0700 (PDT)
Message-ID: <0a7cada4844181d50b7ca971af5d8a4731171336.camel@redhat.com>
Subject: Re: [PATCH v6 05/38] KVM: x86: hyper-v: Handle
 HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls gently
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 07 Jun 2022 12:30:50 +0300
In-Reply-To: <20220606083655.2014609-6-vkuznets@redhat.com>
References: <20220606083655.2014609-1-vkuznets@redhat.com>
         <20220606083655.2014609-6-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-06 at 10:36 +0200, Vitaly Kuznetsov wrote:
> Currently, HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls are handled
> the exact same way as HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE{,EX}: by
> flushing the whole VPID and this is sub-optimal. Switch to handling
> these requests with 'flush_tlb_gva()' hooks instead. Use the newly
> introduced TLB flush fifo to queue the requests.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.c | 100 +++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 88 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 762b0b699fdf..956072592e2f 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1806,32 +1806,82 @@ static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
>                                   sparse_banks, consumed_xmm_halves, offset);
>  }
>  
> -static void hv_tlb_flush_enqueue(struct kvm_vcpu *vcpu)
> +static int kvm_hv_get_tlb_flush_entries(struct kvm *kvm, struct kvm_hv_hcall *hc, u64 entries[],
> +                                       int consumed_xmm_halves, gpa_t offset)
> +{
> +       return kvm_hv_get_hc_data(kvm, hc, hc->rep_cnt, hc->rep_cnt,
> +                                 entries, consumed_xmm_halves, offset);
> +}
> +
> +static void hv_tlb_flush_enqueue(struct kvm_vcpu *vcpu, u64 *entries, int count)
>  {
>         struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
>         struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
>         u64 entry = KVM_HV_TLB_FLUSHALL_ENTRY;
> +       unsigned long flags;
>  
>         if (!hv_vcpu)
>                 return;
>  
>         tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo;
>  
> -       kfifo_in_spinlocked(&tlb_flush_fifo->entries, &entry, 1, &tlb_flush_fifo->write_lock);
> +       spin_lock_irqsave(&tlb_flush_fifo->write_lock, flags);
> +
> +       /*
> +        * All entries should fit on the fifo leaving one free for 'flush all'
> +        * entry in case another request comes in. In case there's not enough
> +        * space, just put 'flush all' entry there.
> +        */
> +       if (count && entries && count < kfifo_avail(&tlb_flush_fifo->entries)) {
> +               WARN_ON(kfifo_in(&tlb_flush_fifo->entries, entries, count) != count);
> +               goto out_unlock;
> +       }
> +
> +       /*
> +        * Note: full fifo always contains 'flush all' entry, no need to check the
> +        * return value.
> +        */
> +       kfifo_in(&tlb_flush_fifo->entries, &entry, 1);
Very tiny nitpick: maybe call this flush_all_entry instead,
just so that it is a tiny bit easier to notice.


> +
> +out_unlock:
> +       spin_unlock_irqrestore(&tlb_flush_fifo->write_lock, flags);
>  }
>  
>  void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
>         struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +       u64 entries[KVM_HV_TLB_FLUSH_FIFO_SIZE];
> +       int i, j, count;
> +       gva_t gva;
>  
> -       kvm_vcpu_flush_tlb_guest(vcpu);
> -
> -       if (!hv_vcpu)
> +       if (!tdp_enabled || !hv_vcpu) {
I haven't noticed that in the review I did back then, but
any reason why !tdp_enabled? Just curious.

> +               kvm_vcpu_flush_tlb_guest(vcpu);
>                 return;
> +       }
>  
>         tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo;
>  
> +       count = kfifo_out(&tlb_flush_fifo->entries, entries, KVM_HV_TLB_FLUSH_FIFO_SIZE);
> +
> +       for (i = 0; i < count; i++) {
> +               if (entries[i] == KVM_HV_TLB_FLUSHALL_ENTRY)
> +                       goto out_flush_all;
> +
> +               /*
> +                * Lower 12 bits of 'address' encode the number of additional
> +                * pages to flush.
> +                */
> +               gva = entries[i] & PAGE_MASK;
> +               for (j = 0; j < (entries[i] & ~PAGE_MASK) + 1; j++)
> +                       static_call(kvm_x86_flush_tlb_gva)(vcpu, gva + j * PAGE_SIZE);
> +
> +               ++vcpu->stat.tlb_flush;
> +       }
> +       return;
> +
> +out_flush_all:
> +       kvm_vcpu_flush_tlb_guest(vcpu);
>         kfifo_reset_out(&tlb_flush_fifo->entries);
>  }
>  
> @@ -1841,11 +1891,21 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>         struct hv_tlb_flush_ex flush_ex;
>         struct hv_tlb_flush flush;
>         DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
> +       /*
> +        * Normally, there can be no more than 'KVM_HV_TLB_FLUSH_FIFO_SIZE'
> +        * entries on the TLB flush fifo. The last entry, however, needs to be
> +        * always left free for 'flush all' entry which gets placed when
> +        * there is not enough space to put all the requested entries.
> +        */
> +       u64 __tlb_flush_entries[KVM_HV_TLB_FLUSH_FIFO_SIZE - 1];
> +       u64 *tlb_flush_entries;
>         u64 valid_bank_mask;
>         u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
>         struct kvm_vcpu *v;
>         unsigned long i;
>         bool all_cpus;
> +       int consumed_xmm_halves = 0;
> +       gpa_t data_offset;
>  
>         /*
>          * The Hyper-V TLFS doesn't allow more than 64 sparse banks, e.g. the
> @@ -1861,10 +1921,12 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>                         flush.address_space = hc->ingpa;
>                         flush.flags = hc->outgpa;
>                         flush.processor_mask = sse128_lo(hc->xmm[0]);
> +                       consumed_xmm_halves = 1;
>                 } else {
>                         if (unlikely(kvm_read_guest(kvm, hc->ingpa,
>                                                     &flush, sizeof(flush))))
>                                 return HV_STATUS_INVALID_HYPERCALL_INPUT;
> +                       data_offset = sizeof(flush);
>                 }
>  
>                 trace_kvm_hv_flush_tlb(flush.processor_mask,
> @@ -1888,10 +1950,12 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>                         flush_ex.flags = hc->outgpa;
>                         memcpy(&flush_ex.hv_vp_set,
>                                &hc->xmm[0], sizeof(hc->xmm[0]));
> +                       consumed_xmm_halves = 2;
>                 } else {
>                         if (unlikely(kvm_read_guest(kvm, hc->ingpa, &flush_ex,
>                                                     sizeof(flush_ex))))
>                                 return HV_STATUS_INVALID_HYPERCALL_INPUT;
> +                       data_offset = sizeof(flush_ex);
>                 }
>  
>                 trace_kvm_hv_flush_tlb_ex(flush_ex.hv_vp_set.valid_bank_mask,
> @@ -1907,25 +1971,37 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>                         return HV_STATUS_INVALID_HYPERCALL_INPUT;
>  
>                 if (all_cpus)
> -                       goto do_flush;
> +                       goto read_flush_entries;
>  
>                 if (!hc->var_cnt)
>                         goto ret_success;
>  
> -               if (kvm_get_sparse_vp_set(kvm, hc, sparse_banks, 2,
> -                                         offsetof(struct hv_tlb_flush_ex,
> -                                                  hv_vp_set.bank_contents)))
> +               if (kvm_get_sparse_vp_set(kvm, hc, sparse_banks, consumed_xmm_halves,
> +                                         data_offset))
> +                       return HV_STATUS_INVALID_HYPERCALL_INPUT;
> +               data_offset += hc->var_cnt * sizeof(sparse_banks[0]);
> +               consumed_xmm_halves += hc->var_cnt;
> +       }
> +
> +read_flush_entries:
> +       if (hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE ||
> +           hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX ||
> +           hc->rep_cnt > ARRAY_SIZE(__tlb_flush_entries)) {
> +               tlb_flush_entries = NULL;
> +       } else {
> +               if (kvm_hv_get_tlb_flush_entries(kvm, hc, __tlb_flush_entries,
> +                                               consumed_xmm_halves, data_offset))
>                         return HV_STATUS_INVALID_HYPERCALL_INPUT;
> +               tlb_flush_entries = __tlb_flush_entries;
>         }
>  
> -do_flush:
>         /*
>          * vcpu->arch.cr3 may not be up-to-date for running vCPUs so we can't
>          * analyze it here, flush TLB regardless of the specified address space.
>          */
>         if (all_cpus) {
>                 kvm_for_each_vcpu(i, v, kvm)
> -                       hv_tlb_flush_enqueue(v);
> +                       hv_tlb_flush_enqueue(v, tlb_flush_entries, hc->rep_cnt);
>  
>                 kvm_make_all_cpus_request(kvm, KVM_REQ_HV_TLB_FLUSH);
>         } else {
> @@ -1935,7 +2011,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>                         v = kvm_get_vcpu(kvm, i);
>                         if (!v)
>                                 continue;
> -                       hv_tlb_flush_enqueue(v);
> +                       hv_tlb_flush_enqueue(v, tlb_flush_entries, hc->rep_cnt);
>                 }
>  
>                 kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH, vcpu_mask);


Besides the nitpick, dont see anything wrong, but I might have missed something.

Best regards,
	Maxim Levitsky

