Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C52E52EE91
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 16:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350529AbiETO6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 10:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236905AbiETO6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 10:58:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2662117569D
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 07:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653058715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W5PE8Uk2oYa+VoHfEMjlD4iZa8PScAGrCy7OUZyaWMs=;
        b=JZEPpG58/XAfGv4hPljJlnWb72SXMudJp6BLuaP+wBEmdKAUeSWoQ/Fdn0Pt6BvSq2tC0O
        brYix3YVaraXEeCMj82JE0xWxA8TAnz+WeX4wRMWifzyEByckCVNPZ4g+Ai2KznLrL13Z1
        9DsHVPOgzlMRyWZoLrrTxiaORkr5d1o=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-PaIphvQ7MUKaQu2vA3YgFQ-1; Fri, 20 May 2022 10:58:33 -0400
X-MC-Unique: PaIphvQ7MUKaQu2vA3YgFQ-1
Received: by mail-ed1-f72.google.com with SMTP id o10-20020aa7c7ca000000b0042a4f08405fso5820459eds.22
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 07:58:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=W5PE8Uk2oYa+VoHfEMjlD4iZa8PScAGrCy7OUZyaWMs=;
        b=gDSN6qt3sWyF6Ci+JuVStyAh3oWo6IlLQUX4Xt/0khxiQnI8zL/OX/y0qmKztWN3CI
         Dyc1zjNlkpBpGGyOHu+83hE9ZGJspC33IFrKD27yEmw7bNl1Sr+jExpzs3S1bq299WOd
         he6x46s6ZzSWu/ruuboC+vgAQe3IVrcuMxEXIesqeH9N3WEDEvkT5Mfi7lyMV0YwqA+Z
         u+8gG1CVd+WOCBoVoGN8BEiYv1N1iwg7s4gnCpEHeeUioTX/5u6P4y2JN7+SeXDUhRPN
         TNfVQu34n6PXlv+fEmPACqURKziV02YZW1h7oMTg9spJQgg/MnflsCh4x5IFa4eSHVRa
         fo+A==
X-Gm-Message-State: AOAM532EvrGRJUfuRW52VBZ3oWcQFz50WOAFESjiNmu8+Fzvm2mGjmc7
        C3wErBrhxTSqextmudTl6XHsuHO03gXCAw4ZzqUAG2TCakBU2An2dihjaKHi8rm21O9MMPvJflP
        EX7pLqy2mU7ta
X-Received: by 2002:a05:6402:270a:b0:42b:3721:4e76 with SMTP id y10-20020a056402270a00b0042b37214e76mr1314176edd.51.1653058712522;
        Fri, 20 May 2022 07:58:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy08bBsUNhjsu3pqF5HeEJDA+JDxr04/Yu0wudNL2HXf303wIBw3SV/FlGyhA7gvTkU+Qg/Iw==
X-Received: by 2002:a05:6402:270a:b0:42b:3721:4e76 with SMTP id y10-20020a056402270a00b0042b37214e76mr1314150edd.51.1653058712136;
        Fri, 20 May 2022 07:58:32 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id e4-20020a170906648400b006fe7d269db8sm3325018ejm.104.2022.05.20.07.58.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 07:58:31 -0700 (PDT)
Message-ID: <4c617e69-f80a-1ee1-635e-c198cf93187e@redhat.com>
Date:   Fri, 20 May 2022 16:58:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 6/8] KVM: Fix multiple races in gfn=>pfn cache refresh
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>,
        Mingwei Zhang <mizhang@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20220427014004.1992589-1-seanjc@google.com>
 <20220427014004.1992589-7-seanjc@google.com>
 <035a5300-27e1-e212-1ed7-0449e9d20615@redhat.com>
In-Reply-To: <035a5300-27e1-e212-1ed7-0449e9d20615@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/20/22 16:49, Paolo Bonzini wrote:
> On 4/27/22 03:40, Sean Christopherson wrote:
>> +         * Wait for mn_active_invalidate_count, not mmu_notifier_count,
>> +         * to go away, as the invalidation in the mmu_notifier event
>> +         * occurs_before_  mmu_notifier_count is elevated.
>> +         *
>> +         * Note, mn_active_invalidate_count can change at any time as
>> +         * it's not protected by gpc->lock.  But, it is guaranteed to
>> +         * be elevated before the mmu_notifier acquires gpc->lock, and
>> +         * isn't dropped until after mmu_notifier_seq is updated.  So,
>> +         * this task may get a false positive of sorts, i.e. see an
>> +         * elevated count and wait even though it's technically safe to
>> +         * proceed (becase the mmu_notifier will invalidate the cache
>> +         *_after_  it's refreshed here), but the cache will never be
>> +         * refreshed with stale data, i.e. won't get false negatives.
> 
> I am all for lavish comments, but I think this is even too detailed.  
> What about:

And in fact this should be moved to a separate function.

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 50ce7b78b42f..321964ff42e1 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -112,6 +112,36 @@ static void gpc_release_pfn_and_khva(struct kvm *kvm, kvm_pfn_t pfn, void *khva)
  	}
  }
  
+
+static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long mmu_seq)
+{
+	/*
+	 * mn_active_invalidate_count acts for all intents and purposes
+	 * like mmu_notifier_count here; but we cannot use the latter
+	 * because the invalidation in the mmu_notifier event occurs
+	 * _before_ mmu_notifier_count is elevated.
+	 *
+	 * Note, it does not matter that mn_active_invalidate_count
+	 * is not protected by gpc->lock.  It is guaranteed to
+	 * be elevated before the mmu_notifier acquires gpc->lock, and
+	 * isn't dropped until after mmu_notifier_seq is updated.
+	 */
+	if (kvm->mn_active_invalidate_count)
+		return true;
+
+	/*
+	 * Ensure mn_active_invalidate_count is read before
+	 * mmu_notifier_seq.  This pairs with the smp_wmb() in
+	 * mmu_notifier_invalidate_range_end() to guarantee either the
+	 * old (non-zero) value of mn_active_invalidate_count or the
+	 * new (incremented) value of mmu_notifier_seq is observed.
+	 */
+	smp_rmb();
+	if (kvm->mmu_notifier_seq != mmu_seq)
+		return true;
+	return false;
+}
+
  static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
  {
  	/* Note, the new page offset may be different than the old! */
@@ -129,7 +159,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
  	 */
  	gpc->valid = false;
  
-	for (;;) {
+	do {
  		mmu_seq = kvm->mmu_notifier_seq;
  		smp_rmb();
  
@@ -188,32 +218,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
  		 * attempting to refresh.
  		 */
  		WARN_ON_ONCE(gpc->valid);
-
-		/*
-		 * mn_active_invalidate_count acts for all intents and purposes
-		 * like mmu_notifier_count here; but we cannot use the latter
-		 * because the invalidation in the mmu_notifier event occurs
-		 * _before_ mmu_notifier_count is elevated.
-		 *
-		 * Note, it does not matter that mn_active_invalidate_count
-		 * is not protected by gpc->lock.  It is guaranteed to
-		 * be elevated before the mmu_notifier acquires gpc->lock, and
-		 * isn't dropped until after mmu_notifier_seq is updated.
-		 */
-		if (kvm->mn_active_invalidate_count)
-			continue;
-
-		/*
-		 * Ensure mn_active_invalidate_count is read before
-		 * mmu_notifier_seq.  This pairs with the smp_wmb() in
-		 * mmu_notifier_invalidate_range_end() to guarantee either the
-		 * old (non-zero) value of mn_active_invalidate_count or the
-		 * new (incremented) value of mmu_notifier_seq is observed.
-		 */
-		smp_rmb();
-		if (kvm->mmu_notifier_seq == mmu_seq)
-			break;
-	}
+	} while (mmu_notifier_retry_cache(kvm, mmu_seq);
  
  	gpc->valid = true;
  	gpc->pfn = new_pfn;

