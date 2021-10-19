Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D3843366E
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 14:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235761AbhJSM6k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 08:58:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59316 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235678AbhJSM6j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Oct 2021 08:58:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634648186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cdk0NlQmQrkJmaesjBsPd19ZiJOSEwCeL0p/j6FST9g=;
        b=E34Uyrd+u9r4UWzqlTZiJyJ6qk0CmEj2qgEH6h5xZFmHr0uJP+LIVj4juU5eaYuJBdvCeZ
        Cs7OnA4zD2zKO1W2IZ9hIvYaKVjzgkxRXyere9VtFouR/FyGOtJHIpUvOKzw2GU+uQLor2
        VhfgZIbEXYlgG85UCMyvnJoJJNUgWnw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-566-zD1xVM_-P2Wcuac1bD-v2g-1; Tue, 19 Oct 2021 08:56:24 -0400
X-MC-Unique: zD1xVM_-P2Wcuac1bD-v2g-1
Received: by mail-wr1-f72.google.com with SMTP id p12-20020adfc38c000000b00160d6a7e293so10091444wrf.18
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 05:56:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cdk0NlQmQrkJmaesjBsPd19ZiJOSEwCeL0p/j6FST9g=;
        b=Vo1Szf8zp+fKc7w45wRvnct+dX8LYrcG8YZpb9ibEnoawA6iEp74H1AUHKjaZ8Y5mY
         0sMZ+B3OqGPVgTeKMNvnoat3y0dCWhsYUVggKIXI9fDRvh89gt6gehdicJWdI3+gRfuU
         AwDCkPbF1csa6q2h1685Wmxat0mnbCThFnPYivSNV5SY4UgBEJJqcFjNiSfXyutTRjXu
         gJ95TYi5gmqDWu2k/ygCQx8JSN33Jate768fR9NLeQPYSb4aDt2kAgjtHeBRv1vu3yv3
         SNR8rV/x7+lkoU9ZCsmxHV/y/gbDNDGUP2fK6i+8J2WDqa8uEea/FcRtLmi8q6DgPFI2
         q1Tg==
X-Gm-Message-State: AOAM531mXrEtJJFyiKfdY09L5eTSWDs5g6eYpFZC0ja0rV4ALW/YL6/E
        DmiVrKYgspGjJzRfwDqdXjIbi8X/8lqbuoB0/5JmzjJft+Q8ulZ4QDlhMRMjQC6fJ2R+37U0P0N
        e0k2+yiF+q/Mg
X-Received: by 2002:a1c:2b81:: with SMTP id r123mr5977985wmr.136.1634648183663;
        Tue, 19 Oct 2021 05:56:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUa/Ik8xgjtFDOtVONsrc7zDJQ7+gy4v3DbixdWxjShh15bKY6cJa/+tLzCLTijaaVaT3/SA==
X-Received: by 2002:a1c:2b81:: with SMTP id r123mr5977950wmr.136.1634648183462;
        Tue, 19 Oct 2021 05:56:23 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:8e02:b072:96b1:56d0? ([2001:b07:6468:f312:8e02:b072:96b1:56d0])
        by smtp.gmail.com with ESMTPSA id h206sm2199558wmh.33.2021.10.19.05.56.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 05:56:23 -0700 (PDT)
Message-ID: <b2713829-1dad-de6b-5850-0c3a74e2f6f3@redhat.com>
Date:   Tue, 19 Oct 2021 14:56:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: x86/mmu: Warn on nx_huge_pages when initializing kvm
Content-Language: en-US
To:     Li Yu <liyu.yukiteru@bytedance.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211019121848.245347-1-liyu.yukiteru@bytedance.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211019121848.245347-1-liyu.yukiteru@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/10/21 14:18, Li Yu wrote:
> Add warning when `nx_huge_pages` is enabled by kvm mmu for hint that
> huge pages may be splited by kernel.
> 
> Signed-off-by: Li Yu <liyu.yukiteru@bytedance.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1a64ba5b9437..b75dbaf29f2d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6091,12 +6091,17 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
>   	return 0;
>   }
>   
> +#define ITLB_MULTIHIT_MSG "iTLB multi-hit CPU bug present and cpu mitigations enabled, huge pages may be splited by kernel for security. See CVE-2018-12207 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/multihit.html for details.\n"

Shouldn't it warn if mitigations are disabled but the bug is present?

Paolo

>   int kvm_mmu_module_init(void)
>   {
>   	int ret = -ENOMEM;
>   
> -	if (nx_huge_pages == -1)
> +	if (nx_huge_pages == -1) {
>   		__set_nx_huge_pages(get_nx_auto_mode());
> +		if (is_nx_huge_page_enabled())
> +			pr_warn_once(ITLB_MULTIHIT_MSG);
> +	}
>   
>   	/*
>   	 * MMU roles use union aliasing which is, generally speaking, an
> 

