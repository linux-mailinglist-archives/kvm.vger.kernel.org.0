Return-Path: <kvm+bounces-423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 817707DF85F
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 18:09:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2758E281C63
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 17:09:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A2B41DFCC;
	Thu,  2 Nov 2023 17:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nur0BZKJ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D62A1C2A3
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 17:09:45 +0000 (UTC)
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3939F123;
	Thu,  2 Nov 2023 10:09:44 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-32d849cc152so717176f8f.1;
        Thu, 02 Nov 2023 10:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698944982; x=1699549782; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EbGxNbLJRmahSx99LzM7d9094Ni7ib3XOyEeixN5wWY=;
        b=Nur0BZKJc/9og572BHAgrcyS+fCmYdYvRpF8UiS+BwK/eLhpFfeeCG+Fzd3f4EMUJq
         qhloGEZmK2qxCIRXbWzi1diLiliubLULHQFU7ZgjJpipqh0WEDTiLH3Z2TNDo6Buvnbz
         YK10R09/8+zZB9N3x9rRvKkAZb9GQiO49OZ5MsTw43KSc4yVGGtT/UCrper8ubJCZGCM
         JkxdRMjJn7jeCXjaW6hpE/LMsWFLITFEXm9rM1YZkHzWNf28TAlS0M8jKM2b1yamzBOU
         XJ4WIT3QppBFy8vRn2augqsYpPkFcOX2brLZJnHAQCrEtyDxLGJdTMoyzY0Ono5oatja
         dAUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698944982; x=1699549782;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EbGxNbLJRmahSx99LzM7d9094Ni7ib3XOyEeixN5wWY=;
        b=o9hIcQDg9TudFQFq/es13vZFViXBRa+r2oJXfxdYL6JUBCDigobugriqNTUQ+0qSJD
         DYj09+n1A5LZEtELM1cFt3I7G3VY6T1U8EDgNyHUruY4C+l12hXjQQgAHygMGc/FpY/s
         cttmTDF/1NlvCcHDW0iQc9glazKzYwpUeukNcu7GyIxiDbx/c0eMft+OHDcB6+4aDdaa
         eusmnpnQd9rn4RIdTdhVSB/AkgJ/WKcL9zbFpxNel9J0rct2KXDnkCS8x5EdNVMahd9+
         oYWISGZNKzdVsMcd5ogEoOPTB4Cd2g2Sdeb/PfPY99FeC9et0vYFWQzsvSLNjy4BzYY7
         zK/A==
X-Gm-Message-State: AOJu0YxqU9aPPR5FWZ0gcc5efAmxQjFD/TjGfubdJiZIst8iWMUVRiKq
	jqPHsTFEOrFORRKHi+p3w4c=
X-Google-Smtp-Source: AGHT+IHdxgBwu6GEmKfbAa5TiXS6dvNkS7jGNo6S0td2v1WOhtU70ix2Gq0dKcH7l5+HpNiUSDIs0w==
X-Received: by 2002:adf:e68b:0:b0:32d:87e1:c349 with SMTP id r11-20020adfe68b000000b0032d87e1c349mr13334118wrm.57.1698944982345;
        Thu, 02 Nov 2023 10:09:42 -0700 (PDT)
Received: from [192.168.14.38] (54-240-197-235.amazon.com. [54.240.197.235])
        by smtp.gmail.com with ESMTPSA id e6-20020adfe386000000b0032f983f7306sm2942733wrm.78.2023.11.02.10.09.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Nov 2023 10:09:41 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <d912e3ee-f2e5-4c40-99cd-214b16fe8fac@xen.org>
Date: Thu, 2 Nov 2023 17:09:40 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v7 01/11] KVM: pfncache: add a map helper function
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>,
 David Woodhouse <dwmw2@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>
References: <20231002095740.1472907-1-paul@xen.org>
 <20231002095740.1472907-2-paul@xen.org> <ZUGL0syLTH09BbsI@google.com>
Organization: Xen Project
In-Reply-To: <ZUGL0syLTH09BbsI@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31/10/2023 23:20, Sean Christopherson wrote:
> On Mon, Oct 02, 2023, Paul Durrant wrote:
>> From: Paul Durrant <pdurrant@amazon.com>
> 
> Please make the changelog standalone, i.e. don't rely on the shortlog to provide
> context.  Yeah, it can be silly and repetive sometimes, particularly when viewing
> git commits where the shortlog+changelog are bundled fairly close together, but
> when viewing patches in a mail client, e.g. when I'm doing initial review, the
> shortlog is in the subject which may be far away or even completely hidden (as is
> the case as I'm typing this).
> 
> I could have sworn I included this in Documentation/process/maintainer-kvm-x86.rst,
> but I'm not finding it.
> 

OK, I'll add some more text.

>> We have an unmap helper but mapping is open-coded. Arguably this is fine
> 
> Pronouns.
> 

Sorry... didn't realize that was an issue.

>> because mapping is done in only one place, hva_to_pfn_retry(), but adding
>> the helper does make that function more readable.
>>
>> No functional change intended.
>>
>> Signed-off-by: Paul Durrant <pdurrant@amazon.com>
>> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
>> ---
>> Cc: Sean Christopherson <seanjc@google.com>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>   virt/kvm/pfncache.c | 43 +++++++++++++++++++++++++------------------
>>   1 file changed, 25 insertions(+), 18 deletions(-)
>>
>> diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
>> index 2d6aba677830..0f36acdf577f 100644
>> --- a/virt/kvm/pfncache.c
>> +++ b/virt/kvm/pfncache.c
>> @@ -96,17 +96,28 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, unsigned long len)
>>   }
>>   EXPORT_SYMBOL_GPL(kvm_gpc_check);
>>   
>> -static void gpc_unmap_khva(kvm_pfn_t pfn, void *khva)
>> +static void *gpc_map(kvm_pfn_t pfn)
>> +{
>> +	if (pfn_valid(pfn))
>> +		return kmap(pfn_to_page(pfn));
>> +#ifdef CONFIG_HAS_IOMEM
>> +	else
> 
> There's no need for the "else", the happy path is terminal.
> 
>> +		return memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
>> +#endif
> 
> This needs a return for CONFIG_HAS_IOMEM=n.  I haven't tried to compile, but I'm
> guessing s390 won't be happy.
> 

Oops, yes, of course.

> This?
> 
> static void *gpc_map(kvm_pfn_t pfn)
> {
> 	if (pfn_valid(pfn))
> 		return kmap(pfn_to_page(pfn));
> 
> #ifdef CONFIG_HAS_IOMEM
> 	return memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
> #else
> 	return NULL;
> #endif
> }
> 

Looks good. Thanks,

   Paul

>> +}
>> +
>> +static void gpc_unmap(kvm_pfn_t pfn, void *khva)
>>   {
>>   	/* Unmap the old pfn/page if it was mapped before. */
>> -	if (!is_error_noslot_pfn(pfn) && khva) {
>> -		if (pfn_valid(pfn))
>> -			kunmap(pfn_to_page(pfn));
>> +	if (is_error_noslot_pfn(pfn) || !khva)
>> +		return;
>> +
>> +	if (pfn_valid(pfn))
>> +		kunmap(pfn_to_page(pfn));
>>   #ifdef CONFIG_HAS_IOMEM
>> -		else
>> -			memunmap(khva);
>> +	else
>> +		memunmap(khva);
>>   #endif
> 
> I don't mind the refactoring, but it needs to be at least mentioned in the
> changelog.  And if we're going to bother, it probably makes sense to add a WARN
> in the CONFIG_HAS_IOMEM=n path, e.g.
> 
> 	/* Unmap the old pfn/page if it was mapped before. */
> 	if (is_error_noslot_pfn(pfn) || !khva)
> 		return;
> 
> 	if (pfn_valid(pfn))
> 		kunmap(pfn_to_page(pfn));
> 	else
> #ifdef CONFIG_HAS_IOMEM
> 		memunmap(khva);
> #else
> 		WARN_ON_ONCE(1);
> #endif
> 


