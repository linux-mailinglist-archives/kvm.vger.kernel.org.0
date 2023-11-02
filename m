Return-Path: <kvm+bounces-429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4EB67DF977
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 19:04:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90A72281CB2
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 18:04:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D31321114;
	Thu,  2 Nov 2023 18:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I/I4KR3/"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD9C208A4
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 18:04:11 +0000 (UTC)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FAD3C02;
	Thu,  2 Nov 2023 11:01:59 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-4083f613272so10884975e9.1;
        Thu, 02 Nov 2023 11:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698948115; x=1699552915; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s9v7fSZdeM5lhEwx+RSQKLoMZAxQbqm89rXIxNUF1qU=;
        b=I/I4KR3/t4STPpazSdJQC5wM7BplxiqHhYNo1M6bljYUVoYlEDfuO+9fHyA+ktSMFg
         Bih9oVYwMthfvmUHawyXaP+HZpNYdUJP9oYxQ+oH/V0bmiX6s5tSizM8X8h+ccuIlG93
         CNeSPZuFL+IUDOupMZbwsRBKxDl9PiW38sOqrCFfMLvmko97TDK88pDudR4rBmOoxiUh
         3quLuAPWSxxIK6X05Lb1zyzfff42fhV7Jax3/m8RqKMVwL3Hv6leYNhqQW3kcTeSBkpG
         XMsqtdZUQFef+WwqGiaBfxOc1TIPLJDiFULZp7mIORtlwRTb8k744Gbce5uQosuNQCJc
         v1ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698948115; x=1699552915;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s9v7fSZdeM5lhEwx+RSQKLoMZAxQbqm89rXIxNUF1qU=;
        b=A8rZEYNU0n7IWt9SwUCoFRFU9y1+8ySGrmi+ftWKy09THzDR1a8g1AD47hWQqIsAt5
         wAqPaWFp0Wc4UPAJrj8VSTGysNAPR5JiKi0wB79xX5kE4aM6UHzDLCLmcKpTJDPvUfYg
         cNE+LZ0WT5h2lgcIXocFknxcy9eLgHuUqbNs2AN40yURw2755a8qolhfOXfcd/9yVX6p
         Gco8fXr1dHCVCm+8wZJEXqXcOu1Jh4NrOCu2FSyrK6j/y6FPSszCQKrGW+3gHHL8rgkY
         w92/SLA+FSEs50dF8/yWUDYI6vdermwqStFEsMwDj/13mZHLUi73RWQAlxHyZB0t7qyu
         nwjQ==
X-Gm-Message-State: AOJu0YwlL5jnwQgy+w5Eixn2Z2T5TERFmk9nij6bg7OzrWrQ+XzK08QT
	uWVx43aCekuQjhGLi9I3b44=
X-Google-Smtp-Source: AGHT+IEZGqW/vxesUw1UMzhtf2vnCkMbF2yFSaqWJA+rHOg1Bsq4xatZmZCYotCXR2brSZnSlLimqg==
X-Received: by 2002:a05:6000:2c7:b0:32d:d2ef:b0e4 with SMTP id o7-20020a05600002c700b0032dd2efb0e4mr19025433wry.0.1698948114541;
        Thu, 02 Nov 2023 11:01:54 -0700 (PDT)
Received: from [192.168.14.38] (54-240-197-227.amazon.com. [54.240.197.227])
        by smtp.gmail.com with ESMTPSA id b11-20020a5d4d8b000000b0032d8354fb43sm3018823wru.76.2023.11.02.11.01.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Nov 2023 11:01:43 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <8c6f06ae-d1d3-40ea-9bed-8ca949eaff5f@xen.org>
Date: Thu, 2 Nov 2023 18:01:35 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v7 05/11] KVM: pfncache: allow a cache to be activated
 with a fixed (userspace) HVA
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>,
 Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>
References: <20231002095740.1472907-1-paul@xen.org>
 <20231002095740.1472907-6-paul@xen.org> <ZUGScpSFlojjloQk@google.com>
Organization: Xen Project
In-Reply-To: <ZUGScpSFlojjloQk@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31/10/2023 23:49, Sean Christopherson wrote:
> On Mon, Oct 02, 2023, Paul Durrant wrote:
>> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
>> index 6f4737d5046a..d49946ee7ae3 100644
>> --- a/include/linux/kvm_types.h
>> +++ b/include/linux/kvm_types.h
>> @@ -64,7 +64,7 @@ struct gfn_to_hva_cache {
>>   
>>   struct gfn_to_pfn_cache {
>>   	u64 generation;
>> -	gpa_t gpa;
>> +	u64 addr;
> 
> Holy moly, we have unions for exactly this reason.
> 
> 	union {
> 		gpa_t gpa;
> 		unsigned long addr;
> 	};
> 
> But that's also weird and silly because it's basically the exact same thing as
> "uhva".  If "uhva" stores the full address instead of the page-aligned address,
> then I don't see a need for unionizing the gpa and uhva.
> 

Ok, I think that'll be more invasive but I'll see how it looks.

> kvm_xen_vcpu_get_attr() should darn well explicitly check that the gpc stores
> the correct type and not bleed ABI into the gfn_to_pfn_cache implementation.
> 

I guess if we leave gpa alone and make it INVALID_GPA for caches 
initialized using an HVA then that can be checked. Is that what you mean 
here?

> If there's a true need for a union, the helpers should WARN.
> 
>> +unsigned long kvm_gpc_hva(struct gfn_to_pfn_cache *gpc)
>> +{
>> +	return !gpc->addr_is_gpa ? gpc->addr : 0;
> 
> '0' is a perfectly valid address.  Yeah, practically speaking '0' can't be used
> these days, but we already have KVM_HVA_ERR_BAD.  If y'all want to use the for the
> Xen ABI, then so be it.  But the common helpers need to use a sane value.

Ok.

   Paul

