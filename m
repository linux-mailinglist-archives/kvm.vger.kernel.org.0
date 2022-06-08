Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EECC54308E
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 14:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239400AbiFHMhk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 08:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239182AbiFHMhi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 08:37:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 53066192C6A
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 05:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654691854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8dky9Q0grtxm6b93mWl07j//u8P3MPxwBKG9VP1vCco=;
        b=dDZWGZtSZDgERd5NOxVJGx7Zhu6t2y35oTaPN0JYJr0zgo1iKazB4ajBDtVQ686ywgLOBK
        ih/aI0oRJF87hQTo59QJ/CDVeZqUQt3vJXbxeSYziYNluNR0K8gPjDXL0YdgTN/MwHgZTW
        UYG/nZsoNbnz4i0NTcbcWD2ZihZs97s=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-475-X-SYKxFXMmy9YdXfaN_LYQ-1; Wed, 08 Jun 2022 08:37:33 -0400
X-MC-Unique: X-SYKxFXMmy9YdXfaN_LYQ-1
Received: by mail-wm1-f70.google.com with SMTP id p42-20020a05600c1daa00b0039c62488f7eso1054535wms.7
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 05:37:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8dky9Q0grtxm6b93mWl07j//u8P3MPxwBKG9VP1vCco=;
        b=tdui/bo7Fkxn8+/JnV7nldKJSJDBwnpwNRYvxIR3iJWsr7Rk9bi9fFNC0syirp9Ftz
         HDQoXKfP+lBGSnT5ldvhnBnT20+Qom13y3eWY2M09+e5L1hgjH3bp6Iqahi6iJzF+7l1
         qdIVp9J6K02+jzU7pRzrKooabfaso4MGFG3jyPZ3FVCNku4IZit3Rn2bfi/tP9T3B+wq
         7A6HNj6g38vNHh/uDp+pbFkH7+xAIsNVPey+pD9WCswSBnSBSJb6HFZnHRVlS3D45683
         nSZIBgovhCOPPz0EIXAzlLurpXbvdXriXIO0XY8frX98koP95Hx/hR/LSqUJoYp8pDd0
         ZbOw==
X-Gm-Message-State: AOAM5318DnEMzOhTjS7J0wR3d1Uc7QS8RV2Qy+8ioWpGvsHm9MRieiXr
        UCoeMAsUYnIiI75++o4j9AIwoSP7pPkBjMlXarT890a4NeGivoBO18UXiqe7uTxsoWzNCodHY5J
        AH/d4qKzezEz+
X-Received: by 2002:adf:f3ce:0:b0:211:55a:a604 with SMTP id g14-20020adff3ce000000b00211055aa604mr32701454wrp.213.1654691852006;
        Wed, 08 Jun 2022 05:37:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy77EGhhtl0nBMLfucR5OSuKH4gN4JaC0XpDm2yOcYvhL8P5ZHh72RlDtKtlyCqqJROaD5wXQ==
X-Received: by 2002:adf:f3ce:0:b0:211:55a:a604 with SMTP id g14-20020adff3ce000000b00211055aa604mr32701429wrp.213.1654691851724;
        Wed, 08 Jun 2022 05:37:31 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id o5-20020a1c7505000000b0039c4ba160absm12429479wmc.2.2022.06.08.05.37.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jun 2022 05:37:31 -0700 (PDT)
Message-ID: <6a9e17c5-c49a-e5c4-b74b-b8a97f7dc675@redhat.com>
Date:   Wed, 8 Jun 2022 14:37:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/1] KVM: x86/mmu: Set memory encryption "value", not
 "mask", in shadow PDPTRs
Content-Language: en-US
To:     Yuan Yao <yuan.yao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kai Huang <kai.huang@intel.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
References: <20220608012015.19566-1-yuan.yao@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220608012015.19566-1-yuan.yao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/8/22 03:20, Yuan Yao wrote:
> Assign shadow_me_value, not shadow_me_mask, to PAE root entries,
> a.k.a. shadow PDPTRs, when host memory encryption is supported.  The
> "mask" is the set of all possible memory encryption bits, e.g. MKTME
> KeyIDs, whereas "value" holds the actual value that needs to be
> stuffed into host page tables.
> 
> Using shadow_me_mask results in a failed VM-Entry due to setting
> reserved PA bits in the PDPTRs, and ultimately causes an OOPS due to
> physical addresses with non-zero MKTME bits sending to_shadow_page()
> into the weeds:
> 
> set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
> BUG: unable to handle page fault for address: ffd43f00063049e8
> PGD 86dfd8067 P4D 0
> Oops: 0000 [#1] PREEMPT SMP
> RIP: 0010:mmu_free_root_page+0x3c/0x90 [kvm]
>   kvm_mmu_free_roots+0xd1/0x200 [kvm]
>   __kvm_mmu_unload+0x29/0x70 [kvm]
>   kvm_mmu_unload+0x13/0x20 [kvm]
>   kvm_arch_destroy_vm+0x8a/0x190 [kvm]
>   kvm_put_kvm+0x197/0x2d0 [kvm]
>   kvm_vm_release+0x21/0x30 [kvm]
>   __fput+0x8e/0x260
>   ____fput+0xe/0x10
>   task_work_run+0x6f/0xb0
>   do_exit+0x327/0xa90
>   do_group_exit+0x35/0xa0
>   get_signal+0x911/0x930
>   arch_do_signal_or_restart+0x37/0x720
>   exit_to_user_mode_prepare+0xb2/0x140
>   syscall_exit_to_user_mode+0x16/0x30
>   do_syscall_64+0x4e/0x90
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Fixes: e54f1ff244ac ("KVM: x86/mmu: Add shadow_me_value and repurpose shadow_me_mask")
> Signed-off-by: Yuan Yao <yuan.yao@intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index efe5a3dca1e0..6bd144f1e60c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3411,7 +3411,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
>   			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
>   					      i << 30, PT32_ROOT_LEVEL, true);
>   			mmu->pae_root[i] = root | PT_PRESENT_MASK |
> -					   shadow_me_mask;
> +					   shadow_me_value;
>   		}
>   		mmu->root.hpa = __pa(mmu->pae_root);
>   	} else {

Queued, thanks.

Paolo

