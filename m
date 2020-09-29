Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C8827CC0D
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 14:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732185AbgI2Mcr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 08:32:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47285 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729567AbgI2McP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 08:32:15 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601382734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/xuPRosGJHmnFbDkUJ7GVHpJ/0cFk6esAt8TsgTMXzo=;
        b=HzZL1hpdmaU5nZP0fVBOZeL6n4QtNgnEC5JYaMR22aK7FR5x9E2Q3SmsDHQS1M+8+WIMBA
        OupDgvV4rOjAW8FzOi1VkfVuLpbMCOscIFovotUUjM94jrjKaoI4yW7uBBmKf07mV3lCbr
        zecIPjR6QSu/W/WF61cNfqvdo7YJnw4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-hhmZbKVONE-uXTe3wbRZ9Q-1; Tue, 29 Sep 2020 08:32:12 -0400
X-MC-Unique: hhmZbKVONE-uXTe3wbRZ9Q-1
Received: by mail-wr1-f72.google.com with SMTP id b7so1703105wrn.6
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 05:32:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/xuPRosGJHmnFbDkUJ7GVHpJ/0cFk6esAt8TsgTMXzo=;
        b=G0sy08zDXM48kKSu1CsU6mmsOx5hss3v8ElLgqCMmdl4ma8CKEofsfLIRmzapjVqNA
         19tlDaNN4C/U8Vap2Jw9/OOmBJstKehDDVOmhH0b3OeZcGOMi9pr4zORmAlH9wzBLx6l
         uQ0lU9mssWrs8K5ppVTkxXA/ByUeFB8pV/CMhyHwHNFwZMHTx6Q7AiI1T2RX5I4+ib1R
         8gjQtEZKXngOkMBEcBnRCi6Xspbsowlk88NAvcXMoH5ovav41FRqcGTHvXSOZ9uZZVPg
         w9UupRsy2/c8hHLjBuBy9ByDWJN2h1IfrjI/1VIHIWXxRtPyrKSJVMA/6rHhybTYt5lY
         FmtQ==
X-Gm-Message-State: AOAM530GZroHY0MsBaoSTBU/QA6k/70kNSYriuJVPxqu/kgOwbBhJIuG
        x4vV5nCMWbAg0Zf3G+qR2Lrdg1IBpY7H4vAmfeJohkFr9Exw7ifQpg27fWQHENzZGQnTaT7hRX2
        p15O7UriZvQvj
X-Received: by 2002:a5d:60d0:: with SMTP id x16mr4062384wrt.196.1601382731020;
        Tue, 29 Sep 2020 05:32:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfM1LJZvMB+SUK5BSnC141MgJ7rpuDw9SJ4012KdEPU7u5BE8E8XFxPIwy57TYpi4clYLhYg==
X-Received: by 2002:a5d:60d0:: with SMTP id x16mr4062356wrt.196.1601382730759;
        Tue, 29 Sep 2020 05:32:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9dbe:2c91:3d1b:58c6? ([2001:b07:6468:f312:9dbe:2c91:3d1b:58c6])
        by smtp.gmail.com with ESMTPSA id w14sm5683761wrk.95.2020.09.29.05.32.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 05:32:10 -0700 (PDT)
Subject: Re: [PATCH -next] x86/kvm: Fix build with CONFIG_SMP disabled
To:     Wang ShaoBo <bobo.shaobowang@huawei.com>
Cc:     weiyongjun1@huawei.com, huawei.libin@huawei.com,
        cj.chengjian@huawei.com, sean.j.christopherson@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <20200929115013.3913359-1-bobo.shaobowang@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <38a60580-ef79-474f-030f-f15f2f1af6bf@redhat.com>
Date:   Tue, 29 Sep 2020 14:32:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200929115013.3913359-1-bobo.shaobowang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/09/20 13:50, Wang ShaoBo wrote:
> When CONFIG_SMP is disabled, build failed like this:
> 
> arch/x86/kernel/kvm.c: In function ‘kvm_alloc_cpumask’:
> arch/x86/kernel/kvm.c:823:35: error: ‘kvm_send_ipi_mask_allbutself’
>  undeclared (first use in this function); did you mean ‘apic_send_IPI_allbutself’?
>   apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
>                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>                                    apic_send_IPI_allbutself
> arch/x86/kernel/kvm.c:823:35: note: each undeclared identifier
>  is reported only once for each function it appears in
> 
> It is because the declaration of kvm_send_ipi_mask_allbutself() is guarded
> by CONFIG_SMP. kvm_send_ipi_mask_allbutself() do not need do anything at
> this time.
> 
> Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
> ---
>  arch/x86/kernel/kvm.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index a44398d2bc44..47d65864e29c 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -611,6 +611,13 @@ static int kvm_cpu_down_prepare(unsigned int cpu)
>  	local_irq_enable();
>  	return 0;
>  }
> +
> +#else /* !CONFIG_SMP */
> +
> +static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
> +{
> +}
> +
>  #endif
>  
>  static void kvm_flush_tlb_others(const struct cpumask *cpumask,
> 

Hi,

a patch for this is already on the list, though I haven't committed it yet.

Thanks for the report.

Paolo

