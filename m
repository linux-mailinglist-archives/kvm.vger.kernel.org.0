Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13DE6351312
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 12:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233850AbhDAKNe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 06:13:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22457 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233383AbhDAKM5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 06:12:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617271977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0xVtkud0FGFVllFbRHTCHeF0n3q4DIXws1lAIbt6JHY=;
        b=WsltBaGYHmfrWwWwsM4O1mlhtHF7hYTT0mQBFvleJiMuz8I9xm8VcBIh2N55vfCJ9v6DM2
        tb7mw1Aaa688adYAjVzUew18H9uBU5w+y63hw2JfRAYsnnlOutuF97ubIMAlRFggCcrdT6
        F8QbKT6Rh0piV0ZKPQCPS2cD6D4Yx5o=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-pQX9KeqbOoKeDTl6FfAlAA-1; Thu, 01 Apr 2021 06:12:55 -0400
X-MC-Unique: pQX9KeqbOoKeDTl6FfAlAA-1
Received: by mail-ed1-f71.google.com with SMTP id r6so2604114edh.7
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 03:12:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0xVtkud0FGFVllFbRHTCHeF0n3q4DIXws1lAIbt6JHY=;
        b=ard8oouBH5YFzqv5tT3h54xWkN7LY/7y3TmH2qRVvbiyMxPDqBEMC056Bt3WtEulLn
         EalSNiItDWufpXf5WOs/v9HEEZY9JMcl7hhCViCw9ycWSpmXAY99UerpE9Be3lEK/wvc
         mIGo90DbuLgR5xv4FjSAm1Y+OS+QLPHYCsImqaTjxgWmRwyO5SuRvo01cOJr86mzq1HA
         XbLb0xFWdWRXcZg3oys2Xo+6fmQ9pOY4kDYvtXUeQjgXK49apcPfpQcf/TNpD+W3xchG
         MHzJhgtNEhQo2YT4FPYQQzgqXlMi4Z/o/um5k67S0qHuCSBjcvM8DZSKchyeOsqBNpgc
         9WpQ==
X-Gm-Message-State: AOAM531nXH/H6AwF07otdFo41OKOTo2EeKdE7I+4xDMFk9t260B0xRzw
        1RagLFVybEtpjZk+GZPl+oDnpJ223p2gPBA/M1YMAx9hA50b7ffG50fCLjKiG5Mo6ufRSPysu5m
        VfOItDyuf2oRq
X-Received: by 2002:a05:6402:375:: with SMTP id s21mr8925792edw.287.1617271974373;
        Thu, 01 Apr 2021 03:12:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybUDAIY2pZzNujL1X/TNW7x2ha+e8W7ahPYGzrvN5rd/bAcBeSWCPMWWfNv5LJZC8H7IIMKQ==
X-Received: by 2002:a05:6402:375:: with SMTP id s21mr8925778edw.287.1617271974245;
        Thu, 01 Apr 2021 03:12:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id hy13sm2526147ejc.32.2021.04.01.03.12.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 03:12:53 -0700 (PDT)
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210331210841.3996155-1-bgardon@google.com>
 <20210331210841.3996155-11-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 10/13] KVM: x86/mmu: Allow zapping collapsible SPTEs to
 use MMU read lock
Message-ID: <51034a41-2d03-103e-6c11-1ed27a952de2@redhat.com>
Date:   Thu, 1 Apr 2021 12:12:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210331210841.3996155-11-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/03/21 23:08, Ben Gardon wrote:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index dcbfc784cf2f..81967b4e7d76 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5610,10 +5610,13 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
>   
>   	write_lock(&kvm->mmu_lock);
>   	slot_handle_leaf(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
> -
> -	if (is_tdp_mmu_enabled(kvm))
> -		kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot);
>   	write_unlock(&kvm->mmu_lock);
> +
> +	if (is_tdp_mmu_enabled(kvm)) {
> +		read_lock(&kvm->mmu_lock);
> +		kvm_tdp_mmu_zap_collapsible_sptes(kvm, memslot);
> +		read_unlock(&kvm->mmu_lock);
> +	}
>   }

Same here, this will conflict with

KVM: x86/mmu: Coalesce TLB flushes when zapping collapsible SPTEs

Again, you will have to add back some "if (flush)" before the write_unlock.

Paolo

