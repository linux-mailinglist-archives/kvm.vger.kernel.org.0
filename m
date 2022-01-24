Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B113549817D
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 14:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235284AbiAXNy4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 08:54:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:35615 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229696AbiAXNy4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 08:54:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643032495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/3Zaur0RiXMvQoYarsskyjbAUyo7mdjsj0Z7CFVYRXE=;
        b=Pd9uN+UOoTrOP7jkiWhPJzLnBEknUAttpbLkP4rvZWE8hjAJlvKZF0Mx8MYjiwzWQGvq4H
        hjQGboLInH1udnY6tbHXq7EslGYssjMZglgaLoNjg16AvxuUUue7G/dsX1Y8kJn3sJE2WI
        0T069HeRIljRH6L79gn37sf48tnZ2Qo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-255-V88-i3zjPnCkydSPFg-5Pg-1; Mon, 24 Jan 2022 08:54:54 -0500
X-MC-Unique: V88-i3zjPnCkydSPFg-5Pg-1
Received: by mail-ej1-f69.google.com with SMTP id 9-20020a170906218900b0065e2a9110b9so2100317eju.11
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 05:54:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/3Zaur0RiXMvQoYarsskyjbAUyo7mdjsj0Z7CFVYRXE=;
        b=mymLAujNjqTQOdbIZMKvB+rv7mOod3f35OK8gFwn0Hu1gyteD/4wS+sZ53MNf9YXtF
         ugQ6sY7URT8u/Wd7y2B4I5UwVYxfR0XAp8cyoQ3yknO5rNAyeemlEyDyGXwu8UEcD50W
         bAFaXJ2CVogYkImoDpAk7ouWv9ddaJERc/FVcmwVjUty0u34P12va7QRFpRIpWx0kozr
         HdJ1YA8x1TwA0JmO3u7X5b9gMtv3+qrrYRuZgUa7z1b/HQ2mvFXcUo2IB12njFP/X1Bw
         CzcbkGDWIF4lsdO6vL9oM2RcPGlVdS9YHwd8SCmv1umB3rcWWd5cMTr+Yl1jzoOum6oy
         WGrg==
X-Gm-Message-State: AOAM533GRk3MmEX85t8GLWgqhvpp48k36yUMPPfBCSzlkDY/OoyESjxb
        XuEkFfqwQG6vROHPRJmnPZBM9PFhO8bptVptFZ+5N1zUAzyOv2VP3e6r1FpYkJ7Z+3S305cWEtb
        DmNwuDXntipCU
X-Received: by 2002:a17:906:f986:: with SMTP id li6mr12367427ejb.175.1643032492885;
        Mon, 24 Jan 2022 05:54:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJymqDgBWmnVcfUVI2SVKWFtt9uJD92FqsAwiMmp9N8DafCXiA4FzKnkBFHMFNdZDWpCeC4fBw==
X-Received: by 2002:a17:906:f986:: with SMTP id li6mr12367415ejb.175.1643032492674;
        Mon, 24 Jan 2022 05:54:52 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id a20sm6646957edb.12.2022.01.24.05.54.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 05:54:52 -0800 (PST)
Message-ID: <f23b9a9d-8d37-9863-50cc-0e0c4befafdb@redhat.com>
Date:   Mon, 24 Jan 2022 14:54:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: remove async parameter of hva_to_pfn_remapped()
Content-Language: en-US
To:     Xianting Tian <xianting.tian@linux.alibaba.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220124020456.156386-1-xianting.tian@linux.alibaba.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220124020456.156386-1-xianting.tian@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/24/22 03:04, Xianting Tian wrote:
> The async parameter of hva_to_pfn_remapped() is not used, so remove it.
> 
> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> ---
>   virt/kvm/kvm_main.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 9a20f2299..876315093 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2463,9 +2463,8 @@ static int kvm_try_get_pfn(kvm_pfn_t pfn)
>   }
>   
>   static int hva_to_pfn_remapped(struct vm_area_struct *vma,
> -			       unsigned long addr, bool *async,
> -			       bool write_fault, bool *writable,
> -			       kvm_pfn_t *p_pfn)
> +			       unsigned long addr, bool write_fault,
> +			       bool *writable, kvm_pfn_t *p_pfn)
>   {
>   	kvm_pfn_t pfn;
>   	pte_t *ptep;
> @@ -2575,7 +2574,7 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
>   	if (vma == NULL)
>   		pfn = KVM_PFN_ERR_FAULT;
>   	else if (vma->vm_flags & (VM_IO | VM_PFNMAP)) {
> -		r = hva_to_pfn_remapped(vma, addr, async, write_fault, writable, &pfn);
> +		r = hva_to_pfn_remapped(vma, addr, write_fault, writable, &pfn);
>   		if (r == -EAGAIN)
>   			goto retry;
>   		if (r < 0)

Queued, thanks.

Paolo

