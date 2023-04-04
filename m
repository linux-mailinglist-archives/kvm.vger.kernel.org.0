Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E86EF6D5B07
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 10:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbjDDIkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 04:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233526AbjDDIkU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 04:40:20 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5D91BE3;
        Tue,  4 Apr 2023 01:40:18 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id w9so127445396edc.3;
        Tue, 04 Apr 2023 01:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680597616;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0g1zh4gal+KFE+knYqoXUdddS5/tpwNhgt+RevVrSxE=;
        b=AU3CBFODpkyNLNVHkwO6BWoeZXz61njrlDJWOR0z8vx/+1PeusFEIkZFlLjasZ34aF
         pCzYxERfZasTk2LuqmYCIoYSVE7EC5SzIW9qjqvPAJgGjZ/teLYf7pg3/Sj4I+PjQKBM
         wOpOKcnHUWjbRM2m7OfDoK6EW88Boj2gRzGH57DYFfweSefpTP1MmvGTT4o1lUfiEERC
         OmDuq7INpTgDveg5v/1KKaCMqnAD8+J0GpKoqS7YjBWo4h9Fl88YV0n9t2qO7nfrY6r4
         N/a/IdDN5o5ZPUuFdifbwjU1Nv8fUGN14B+IXPJdDWx6fYWEzfAnZ4MPz11s8S6Te34O
         MvqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680597616;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0g1zh4gal+KFE+knYqoXUdddS5/tpwNhgt+RevVrSxE=;
        b=f5tHoXIjYgNdXOpk57j0eyKpDJIdcIa0Yq9bvSuJAq29DeZ5HO3yDMzI675GuBspsH
         5dpyWMb4BhoVggSDJ5bt7WNaoRCwNsUm3vOQ4nnzKW+oygaEWQsCscgACtgWYbjgUG6I
         MCu+n2yaZGg2Kaq0keRBb2V9az5Cl/xcYMLTNLdMwjULLlbPLNuyILTtWGyr8j3jGMJG
         RRFd28Y72C9Z4+UhVs/mlNrk8cVRkPdwYUEQ2/k9NHY3OAz0rh8M6m96EzEfAwKkR39u
         GcBA25ZvNTtMrXHPpEBZISe4ZmCvrIJUaB51SkoI6N5zVH1ai2Fu88TAiFIyy5sGhens
         dXlA==
X-Gm-Message-State: AAQBX9e2DQ3/LVmJN2hnjh6xz7Bz59GIaRd7DD+AfMrrEvikrVn4goNK
        o9dmuJqpOvmtgLFra0yjujic+fukV3o7tQ8s
X-Google-Smtp-Source: AKy350bbGCk0nU42wqlFMXm5MfKxnTxLJjembj7J7w4vX+oZfI09DyrsNhCV7y2GvSoXHbI0RR9r/A==
X-Received: by 2002:a05:6402:2044:b0:501:d43e:d1e6 with SMTP id bc4-20020a056402204400b00501d43ed1e6mr2180381edb.4.1680597616461;
        Tue, 04 Apr 2023 01:40:16 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r19-20020a50c013000000b004fd29e87535sm5555239edb.14.2023.04.04.01.40.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 01:40:15 -0700 (PDT)
Message-ID: <4235f3f7-bae5-1f5e-582e-077bc5d03306@gmail.com>
Date:   Tue, 4 Apr 2023 16:40:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH REBASED] KVM: x86: SVM: Fix one redefine issue about
 VMCB_AVIC_APIC_BAR_MASK
Content-Language: en-US
To:     "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>, Xinghui Li <korantli@tencent.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        korantwork@gmail.com, seanjc@google.com, tglx@linutronix.de,
        mingo@redhat.com, mlevitsk@redhat.com
References: <20230403095200.1391782-1-korantwork@gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230403095200.1391782-1-korantwork@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/2023 5:52 pm, korantwork@gmail.com wrote:
> From: Xinghui Li <korantli@tencent.com>
> 
> VMCB_AVIC_APIC_BAR_MASK is defined twice with the same value in svm.h,
> which is meaningless. Delete the duplicate one.
> 
> Fixes: 391503528257 ("KVM: x86: SVM: move avic definitions from AMD's spec to svm.h")
> Signed-off-by: Xinghui Li <korantli@tencent.com>

Reviewed-by: Like Xu <likexu@tencent.com>

Do we have any tool to find out more similar issues across numerous subsystems ?

> ---
>   arch/x86/include/asm/svm.h | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 770dcf75eaa9..e236b896f8b4 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -278,7 +278,6 @@ static_assert((AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == AVIC_MAX_
>   static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_MAX_PHYSICAL_ID);
>   
>   #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
> -#define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
>   
>   
>   struct vmcb_seg {
