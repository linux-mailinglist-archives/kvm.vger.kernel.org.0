Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308C6509198
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 22:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382115AbiDTUvP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 16:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238184AbiDTUvO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 16:51:14 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72303109D;
        Wed, 20 Apr 2022 13:48:26 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id t6so441283wra.4;
        Wed, 20 Apr 2022 13:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TSW1iFgn1Xy/aKBnGEpEPUheBPzavT/6AKHca6xBdvM=;
        b=Us6ywq8gVIIsfmEA9YcuptZrFOT0fbx3c0q8ni8g6WfV2Bp3WEJN2t2rgGbLDVRNLC
         JtTqqpFyJLRqHpSpyPexHV9XHXXCaiB8U2FiuJVno5TnkrrdrEOU6ETKeI24xty7N7wC
         /xGVzSAdU968/4ersUJ53d/x0IM4Yb5ElcUD9oKVVtqPoGNyCNzd52c+QRBOxyVolIKn
         Nn6XWOYbjjeAvn4woGDY90q6WQu29W7FBFySSJ4N7JAAeb0QtzHXr9xae7hckr/kit09
         XHHDy3oDXs4mL30RFIGTu7DPwSs5DfmBrZxZyKgCjsP5DTcQ0A5Md7FyvvBJxekzGWxn
         vAuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TSW1iFgn1Xy/aKBnGEpEPUheBPzavT/6AKHca6xBdvM=;
        b=0Dmr+wab7IL1DnmVJJj/0og3GXr9L95PdRAc6lU+eTkWZ/3H1dfS2gWuy/nFYiu22j
         J65IU7Cofm/xaCeWuxh9V12jIDfMKS7rdv4XqWoIPnXq7RHTan7FaDLdCihLK6tjovFH
         tzk/lpFckAGMi6tDXoKBt2TsBdAJzRfVZA2rFyxE5VZwZbS8fAcL6+Re+jUR90p1AgFn
         4zHhNtK/J1Eq6njiKYZ9lgJI6xz9LiHp9fFJ1pxV+hoCWdQZAuXdpbPzveKnJOYIIVMu
         BklZoMLE3c23IEusD1KYbmdKbYXO8dmt4Oag6xjtn+bC1nH7NXpm+GiG5PkIy1DyfPWw
         wzZQ==
X-Gm-Message-State: AOAM531KxUwyrrx3gAt/Fk4LzHb/8tI7Ejak7sNYWuD0lJBnJ0gR2eeo
        NmF+98RKGF8+HFILf5xaCm8=
X-Google-Smtp-Source: ABdhPJyegno6HYecW5+wZ38ikrPpA+fKsuAd9qmYp2Ons7DjZ9o2rl8uuVBYX/q45d51pgsL3FMDuQ==
X-Received: by 2002:a5d:584e:0:b0:20a:9034:e312 with SMTP id i14-20020a5d584e000000b0020a9034e312mr14805525wrf.518.1650487705039;
        Wed, 20 Apr 2022 13:48:25 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id f7-20020a05600c4e8700b00391dd70a0aesm367653wmq.41.2022.04.20.13.48.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 13:48:24 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <7ebe81f7-ca97-0c0f-861e-7c7ae4af2f82@redhat.com>
Date:   Wed, 20 Apr 2022 22:48:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/2] KVM: X86/MMU: Add sp_has_gptes()
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20220420131204.2850-1-jiangshanlai@gmail.com>
 <20220420131204.2850-2-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220420131204.2850-2-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/20/22 15:12, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> Add sp_has_gptes() which equals to !sp->role.direct currently.
> 
> Shadow page having gptes needs to be write-protected, accounted and
> responded to kvm_mmu_pte_write().
> 
> Use it in these places to replace !sp->role.direct and rename
> for_each_gfn_indirect_valid_sp.
> 
> -#define for_each_gfn_indirect_valid_sp(_kvm, _sp, _gfn)			\
> +#define for_each_gfn_valid_sp_has_gptes(_kvm, _sp, _gfn)		\

Small nit, for_each_gfn_valid_sp_with_gptes might be a little more 
grammatical (not much).

>   	for_each_valid_sp(_kvm, _sp,					\
>   	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])	\
> -		if ((_sp)->gfn != (_gfn) || (_sp)->role.direct) {} else
> +		if ((_sp)->gfn != (_gfn) || !sp_has_gptes(_sp)) {} else
>   
>   static bool kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>   			 struct list_head *invalid_list)
> @@ -2112,7 +2120,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>   	sp->gfn = gfn;
>   	sp->role = role;
>   	hlist_add_head(&sp->hash_link, sp_list);
> -	if (!direct) {
> +	if (sp_has_gptes(sp)) {
>   		account_shadowed(vcpu->kvm, sp);
>   		if (level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
>   			kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
> @@ -2321,7 +2329,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
>   	/* Zapping children means active_mmu_pages has become unstable. */
>   	list_unstable = *nr_zapped;
>   
> -	if (!sp->role.invalid && !sp->role.direct)
> +	if (!sp->role.invalid && sp_has_gptes(sp))
>   		unaccount_shadowed(kvm, sp);
>   
>   	if (sp->unsync)
> @@ -2501,7 +2509,7 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
>   	pgprintk("%s: looking for gfn %llx\n", __func__, gfn);
>   	r = 0;
>   	write_lock(&kvm->mmu_lock);
> -	for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
> +	for_each_gfn_valid_sp_has_gptes(kvm, sp, gfn) {
>   		pgprintk("%s: gfn %llx role %x\n", __func__, gfn,
>   			 sp->role.word);
>   		r = 1;
> @@ -2563,7 +2571,7 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
>   	 * that case, KVM must complete emulation of the guest TLB flush before
>   	 * allowing shadow pages to become unsync (writable by the guest).
>   	 */
> -	for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
> +	for_each_gfn_valid_sp_has_gptes(kvm, sp, gfn) {
>   		if (!can_unsync)
>   			return -EPERM;
>   
> @@ -5311,7 +5319,7 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>   
>   	++vcpu->kvm->stat.mmu_pte_write;
>   
> -	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn) {
> +	for_each_gfn_valid_sp_has_gptes(vcpu->kvm, sp, gfn) {
>   		if (detect_write_misaligned(sp, gpa, bytes) ||
>   		      detect_write_flooding(sp)) {
>   			kvm_mmu_prepare_zap_page(vcpu->kvm, sp, &invalid_list);

