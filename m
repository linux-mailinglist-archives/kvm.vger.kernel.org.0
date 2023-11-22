Return-Path: <kvm+bounces-2317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E9B877F4BA9
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 16:53:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 278CC1C20B13
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 15:53:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D843B4E1A6;
	Wed, 22 Nov 2023 15:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CKtrTajc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC80F9A;
	Wed, 22 Nov 2023 07:53:02 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2c887d1fb8fso35620481fa.0;
        Wed, 22 Nov 2023 07:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700668381; x=1701273181; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RlnRw7VYfGh/cCRGjlDuIvXRCgYuMpmQluWY6EzpRsc=;
        b=CKtrTajcBTHMRpwYT/eNKAatl2bPV8Qa1d6EcIhA2ZvF6a+6k2Vn+LTMCcVeVpHRaO
         +J/xM2Ihj0ahC9zggDE+l3dDqrFZtkqtFn4ntYxq45MAoBudDLaOLfOLnR8Xf8VtrVrA
         hGzJc1g7tDkbYOyPbJs3nq40OgIcUZwjHsKpknzIkJPQ0kytwcIpduajyNMbZ53bdZR9
         es8MhUfCZscwX5eclMF2V9ui1XWLbebsswODLr4/i2Sg+bUOx0zak6UNXH3cMYKwB6p7
         k81ylnkH7Rg09B151LPZsRGjMvhUELclobyAdoawoNQhxmqCh6/L8gEaDfD+Ym7s4CrG
         K4FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700668381; x=1701273181;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RlnRw7VYfGh/cCRGjlDuIvXRCgYuMpmQluWY6EzpRsc=;
        b=v3IffwPnFKx/Dv0vLcwdVZa1BrE7wn6wIAERAwTpa8+8AwIIG0sDonAoQLBEeF/3MF
         nXsknDVQC2JSE8qrML61Wckz0S/L9X7gm1AdMm0T2xxD66DdbqBy5pv4kKmbjcS5yxmh
         mOHmaJmWuSSxAoVCP0FCWkWUBcMoftqri5fVhUTpHZvEpF/llaMgYOvUWhQ8jvucEVHs
         WkCcSaq98yiIv7jZvQrR78y9pZl4/RQEmzlJtXVOjjVVuLxacHQOlZ3utEXB0Sg7SugT
         5uQooNA8vPRJjuNDQc6R7sBEauf0jwtQ/xZu6BmqNm9QwbwKYapGopTA3VBl4GZ78xfv
         ro9Q==
X-Gm-Message-State: AOJu0YxnPO/EQ8p4FYqFlnxTuKNNi9InG4cVHxVETa3seeBK2iTxvQ3C
	Uv6Nt6z2oG0gezhjmzGEZzE=
X-Google-Smtp-Source: AGHT+IFxxizTMfU6YJC1kLyZxdTbNn/EvI77c+LoUT4/bo2vkbNsRST8rq7e6SpabpbCLPSerqoZJQ==
X-Received: by 2002:a2e:9b4b:0:b0:2c8:7665:adb0 with SMTP id o11-20020a2e9b4b000000b002c87665adb0mr2021685ljj.46.1700668380812;
        Wed, 22 Nov 2023 07:53:00 -0800 (PST)
Received: from [10.95.134.92] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id m3-20020a05600c4f4300b0040b297fce5fsm2622058wmq.10.2023.11.22.07.52.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Nov 2023 07:53:00 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <b2728518-f490-4dab-a7c5-fba607352a48@xen.org>
Date: Wed, 22 Nov 2023 15:52:58 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v8 07/15] KVM: pfncache: include page offset in uhva and
 use it consistently
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>, Xu Yilun <yilun.xu@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20231121180223.12484-1-paul@xen.org>
 <20231121180223.12484-8-paul@xen.org>
 <ZV3Bwghwz63LmgMu@yilunxu-OptiPlex-7050>
 <b6b864e500cbb38f76739fcfb4dcc6e9c6705d0b.camel@infradead.org>
 <ZV4PyvTBOohiRyLS@yilunxu-OptiPlex-7050>
 <7a038a4c2ae4387fb366f6c2e9b1ce512f5345bc.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <7a038a4c2ae4387fb366f6c2e9b1ce512f5345bc.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 22/11/2023 15:42, David Woodhouse wrote:
> On Wed, 2023-11-22 at 22:27 +0800, Xu Yilun wrote:
>> On Wed, Nov 22, 2023 at 09:12:18AM +0000, David Woodhouse wrote:
>>> On Wed, 2023-11-22 at 16:54 +0800, Xu Yilun wrote:
>>>>
>>>>> @@ -259,13 +258,25 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa,
>>>>>                          ret = -EFAULT;
>>>>>                          goto out;
>>>>>                  }
>>>>> +
>>>>> +               hva_change = true;
>>>>> +       } else {
>>>>> +               /*
>>>>> +                * No need to do any re-mapping if the only thing that has
>>>>> +                * changed is the page offset. Just page align it to allow the
>>>>> +                * new offset to be added in.
>>>>
>>>> I don't understand how the uhva('s offset) could be changed when both gpa and
>>>> slot are not changed. Maybe I have no knowledge of xen, but in later
>>>> patch you said your uhva would never change...
>>>
>>> It doesn't change on a normal refresh with kvm_gpc_refresh(), which is
>>> just for revalidation after memslot changes or MMU invalidation.
>>>
>>> But it can change if the gpc is being reinitialized with a new address
>>> (perhaps because the guest has made another hypercall to set the
>>> address, etc.)
>>>
>>> That new address could happen to be in the *same* page as the previous
>>
>> In this case, the lower bits of new gpa should be different to gpc->gpa,
>> so will hit "if (gpc->gpa != gpa ...)" branch.
> 
> I think that 'if (gpc->gpa != gpa); branch is also gratuitously
> refreshing when it doesn't need to; it only needs to refresh if the
> *aligned* gpas don't match.
> 

I did look at that but decided that gfn_to_hva_memslot() was 
sufficiently lightweight that it was not really worth optimising.

> But it was like that already, so I won't heckle Paul any further :)

I appreciate it! :-)

   Paul

