Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA6D8D35C
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 14:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfHNMly (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 08:41:54 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39736 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbfHNMly (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 08:41:54 -0400
Received: by mail-wr1-f65.google.com with SMTP id t16so20838177wra.6
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2019 05:41:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7qa+OQc+EfgC/AsxQHiSyd8uUAoFVOGXxd9MGXVO4gQ=;
        b=Ni969W7t5lGc1xMi90FgCViK+M0Polk+Uv6bbD+qsa7OOxDYSB9TWtSs55U0VjL4+P
         urS4J6g/K21N0zwwzO/U03gkABBWCgOSkpy6I6X4T1QxmqRzYFPV+3VK/j0PpbraBJhd
         vTvq6nVSJTCLc2fbxdOJQlzKO7XjM7K7wKUJ0qVVw+jcRCcz8cxIAWNzTYppJTkBP1k5
         YAm4V/j5uf4gkfeGKuw2b1VwqI/RQPWQy2OSI2b+OOBntco6dbhDBcsPPG8oBCM9DY2V
         pvoJKfwml4ZgzYvzMmTt025ZuzPFilQ6UlTtC/5eskc3i5EBaLIGKox0dewQkd//SZi9
         PmWQ==
X-Gm-Message-State: APjAAAXxchq4MDMRDUIiebhGFwUSNflknOLracSUxGyrCTSWMVodKiyg
        0q0aLc4ewzzyw0tbuGPuznIIZg==
X-Google-Smtp-Source: APXvYqyFfdmqgMJPuWJLiLxbPu3wBmT00xVThG/XUqZUJSxYCcYrkDMswuc970cUCzcCLjdzY5jv+w==
X-Received: by 2002:a5d:528d:: with SMTP id c13mr51718475wrv.247.1565786512550;
        Wed, 14 Aug 2019 05:41:52 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a26sm3507255wmg.45.2019.08.14.05.41.51
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 05:41:51 -0700 (PDT)
Subject: Re: [PATCH] KVM : remove redundant assignment of var new_entry
To:     Miaohe Lin <linmiaohe@huawei.com>, joro@8bytes.org,
        rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     mingfangsen@huawei.com
References: <20190812023300.20153-1-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ce3a477a-d323-32ce-b950-470e50e0811d@redhat.com>
Date:   Wed, 14 Aug 2019 14:41:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812023300.20153-1-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/08/19 04:33, Miaohe Lin wrote:
> new_entry is reassigned a new value next line. So
> it's redundant and remove it.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/svm.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index d685491fce4d..e3d3b2128f2b 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1714,7 +1714,6 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>  	if (!entry)
>  		return -EINVAL;
>  
> -	new_entry = READ_ONCE(*entry);
>  	new_entry = __sme_set((page_to_phys(svm->avic_backing_page) &
>  			      AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK) |
>  			      AVIC_PHYSICAL_ID_ENTRY_VALID_MASK);
> 

Queued, thanks.

Paolo
