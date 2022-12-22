Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA917653EA5
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 12:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235288AbiLVLDi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 06:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbiLVLDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 06:03:36 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB14427B26;
        Thu, 22 Dec 2022 03:03:34 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id t11-20020a17090a024b00b0021932afece4so5338179pje.5;
        Thu, 22 Dec 2022 03:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2JybBkP/4Api1q6jsYezNC9gOhJqBgbusIGr/vmF+qI=;
        b=AlXQb2rr5h296Q+gKK1IziCV2lepuGRfwRO7wi6zrqnZN2lyb8n0RoT20uM4D/id2v
         d9xLy3r99qYth7sTtTBfsmox2EMMMGt1I0wJRKh2X+sDkJ2aQU7eJya/gxInW8DbGleR
         yGfyBYVoQXteMFgaEdbvxdv+iH+4pL6JrlZQctGoYu4NgSmKBFUrbfs9V1CvTkjBOcci
         SSMXuUasXFHtqG61HT7YO2TnKGQzRUlv/7Z6OOEdxi1ZxV/KUN4+3PY4hU3TfSGEXcIa
         Hq70RJwHdciYP+B2BwzTQB+Ny7G21YxXWA30Cj00yXaB9O/T6Lp08TsCt7KnssoyPCYw
         B0MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2JybBkP/4Api1q6jsYezNC9gOhJqBgbusIGr/vmF+qI=;
        b=F5k3Xc8Gr8/VvB6pqE6GIx3vtd/FiOXKp5xWL/ww9Th4Cj8WIEcfLAP3n0OLcSoaGg
         eu/MuyG0lVqFSwhbnqzCL+A/p2sgWqd+xliXF+ilSAyZcg3bnZwqVT5o3vxAojt22ODq
         IjYQtCVbByPJrS8YFZdMlTbdB8eVUPBnTOjdsE0XL1GCSrt9mWLbfm/W2hsHynRzA4hx
         kVvU7FkZSK5iqAdzpwoY7IgwCRZyy8mvo0keryaipy+l36oxts0rBMr3WaloyTPvA2lx
         p5KTWipPaTWWSUe7yZDNsOGYvVKzOxH0NWc8k0SXvn2ftpvHB/RH/p/Z/l07NdsmhHxx
         MvoQ==
X-Gm-Message-State: AFqh2kqIHLnMkgYFvCX1UN3ZesBzbphEw8NYuEulBomidCM5KY4XQFAS
        F1NJNk6rzbh5rvSDPS0q/cs=
X-Google-Smtp-Source: AMrXdXv7XGEITzrsJ3djoszvt/R8yeMDTqJ1IWaMsRflOe7fSaHC7xAeoLAI97065MVAmY5W8xx/mw==
X-Received: by 2002:a17:902:e411:b0:18c:cde:fdda with SMTP id m17-20020a170902e41100b0018c0cdefddamr4690363ple.37.1671707014531;
        Thu, 22 Dec 2022 03:03:34 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t7-20020a1709027fc700b00186ae20e8dcsm200532plb.271.2022.12.22.03.03.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Dec 2022 03:03:34 -0800 (PST)
Message-ID: <41f13d29-b375-da1a-543e-7cfcc052a5ed@gmail.com>
Date:   Thu, 22 Dec 2022 19:03:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [PATCH v2 15/15] KVM: x86/cpuid: Advertise Arch LBR feature in
 CPUID
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kan.liang@linux.intel.com, wei.w.wang@intel.com, seanjc@google.com,
        pbonzini@redhat.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-16-weijiang.yang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20221125040604.5051-16-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/11/2022 12:06 pm, Yang Weijiang wrote:
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 85e3df6217af..60b3c591d462 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -134,6 +134,19 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
>   		if (vaddr_bits != 48 && vaddr_bits != 57 && vaddr_bits != 0)
>   			return -EINVAL;
>   	}
> +	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR)) {
> +		best = cpuid_entry2_find(entries, nent, 0x1c, 0);
> +		if (best) {
> +			unsigned int eax, ebx, ecx, edx;
> +
> +			/* Reject user-space CPUID if depth is different from host's.*/

Try to verify this in the KVM selftest, as this behavior is different from the host.

> +			cpuid_count(0x1c, 0, &eax, &ebx, &ecx, &edx); > +
> +			if ((eax & 0xff) &&
> +			    (best->eax & 0xff) != BIT(fls(eax & 0xff) - 1))
> +				return -EINVAL;
> +		}
> +	}
