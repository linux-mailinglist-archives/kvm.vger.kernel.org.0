Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05008730D50
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 04:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237923AbjFOCny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 22:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235116AbjFOCnx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 22:43:53 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162C9185
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 19:43:51 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-652699e72f7so5700544b3a.3
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 19:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686797030; x=1689389030;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CxCZkvy5CRmJqiPa7JJmlai93hOqrgA6UMh4PzPRLXQ=;
        b=jZk0O+85Vc8ng3Z+WAZtZg80rlz7vJdqN6RzRISvR8WDlk6LfayCiJrD4cQwb902SU
         KH7gRpD2qjPxsnA7np8OYFoqD+vjjrW4sHqD5tG9Y2CK+XWJkfiB2gfONdQDu21hJ4+g
         V6hogrIR3eFWMkDhAKUPyDaUTAOCGEqUpDBa6AhvzJO5lELtke4ZwftmottY/eCTnK8B
         V94ltqBg10e+JedEQ0hoIEvMm4YOFvVBkseQo7Hpca7MINzEeiMXzltHMgD0StriD/N/
         IiTcZBdS8Yf/LgLiVMJBQQv6xEc3zL0nyvM8FgF+CbgG7teAW/212XRKvAhB2qNxtnIE
         Z90g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686797030; x=1689389030;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CxCZkvy5CRmJqiPa7JJmlai93hOqrgA6UMh4PzPRLXQ=;
        b=T0svKJy/SwuUrPZEYGpw72bQuze2ORwEZuLbNqNSNhGDIo44ACUOkYPR4+CXBfQ0p4
         KywOHDisKFlL3rQCPO8e5XN8IRfEoOI77dtVrbsvsCdwDrCpfr3ZopOGH0+p/qlhpvOs
         v2sKJ/D7PKL1Y6Ff5jmA3KjM4tH+NgoLMIKj96RRXQpKgBtPeT1BWMKYie62Ef6I1xry
         EFDBxB8uiAuSL6a2+ftxcswzu9qVNoMlm2Yom1PL6vYM0oMkPz+AMri2U+Hg5i/QUCaB
         hkRp4ivbR2n7CryI3EyKFyApNAkAMsmSNTMZljaXJeMGZYcbK0CZgHwheudzzhDbySRd
         mzdg==
X-Gm-Message-State: AC+VfDx3oEUrVDHrVm4XjIzUDuMWRF4FFSbRXCApWEM6dfX9o7fTLCZV
        HH0RDcCSBodgnYn1/efNnBc=
X-Google-Smtp-Source: ACHHUZ4sxVWEp4CkSEL0T8BuWhDfBI0ssqyECY9RQCHka3kQoz553dN4xmWXeF4q/z85WlXH02cVZQ==
X-Received: by 2002:a05:6a00:9a4:b0:664:2f24:5578 with SMTP id u36-20020a056a0009a400b006642f245578mr4361236pfg.13.1686797030477;
        Wed, 14 Jun 2023 19:43:50 -0700 (PDT)
Received: from [172.27.232.119] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b0065992d334f4sm11316966pff.177.2023.06.14.19.43.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 19:43:50 -0700 (PDT)
Message-ID: <d4131051-8b71-fab3-59a8-2f15381c2d41@gmail.com>
Date:   Thu, 15 Jun 2023 10:43:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
From:   Robert Hoo <robert.hoo.linux@gmail.com>
Subject: Re: [PATCH v4 08/16] KVM: x86: Annotate -EFAULTs from
 kvm_handle_error_pfn()
To:     Anish Moorthy <amoorthy@google.com>, seanjc@google.com,
        oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
References: <20230602161921.208564-1-amoorthy@google.com>
 <20230602161921.208564-9-amoorthy@google.com>
Content-Language: en-US
In-Reply-To: <20230602161921.208564-9-amoorthy@google.com>
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

On 6/3/2023 12:19 AM, Anish Moorthy wrote:
> Implement KVM_CAP_MEMORY_FAULT_INFO for efaults generated by
> kvm_handle_error_pfn().
> 
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c8961f45e3b1..cb71aae9aaec 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3291,6 +3291,10 @@ static void kvm_send_hwpoison_signal(struct kvm_memory_slot *slot, gfn_t gfn)
>   
>   static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   {
> +	uint64_t rounded_gfn;
> +	uint64_t fault_size;
> +	uint64_t fault_flags;
> +
>   	if (is_sigpending_pfn(fault->pfn)) {
>   		kvm_handle_signal_exit(vcpu);
>   		return -EINTR;
> @@ -3309,6 +3313,15 @@ static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
>   		return RET_PF_RETRY;
>   	}
>   
> +	fault_size = KVM_HPAGE_SIZE(fault->goal_level);

IIUC, here fault->goal_level is always PG_LEVEL_4K.
goal_level could be adjusted in later kvm_tdp_mmu_map() --> 
kvm_mmu_hugepage_adjust(), if kvm_faultin_pfn() doesn't fail, that is to say, 
code path doesn't go through here.

I wonder, if you would like put (kind of) kvm_mmu_hugepage_adjust() here as 
well, reporting to user space the maximum map size it could do with, OR, just 
report 4K size, let user space itself to detect/decide max possible size (but 
now I've no idea how to).

> +	rounded_gfn = round_down(fault->gfn * PAGE_SIZE, fault_size);
> +
> +	fault_flags = 0;
> +	if (fault->write)
> +		fault_flags |= KVM_MEMORY_FAULT_FLAG_WRITE;
> +	if (fault->exec)
> +		fault_flags |= KVM_MEMORY_FAULT_FLAG_EXEC;
> +	kvm_populate_efault_info(vcpu, rounded_gfn, fault_size, fault_flags);
>   	return -EFAULT;
>   }
>   

