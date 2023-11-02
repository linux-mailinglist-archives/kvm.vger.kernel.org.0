Return-Path: <kvm+bounces-427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0657D7DF932
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 18:52:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22F511C20FA6
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 17:52:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A32C8208DC;
	Thu,  2 Nov 2023 17:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i5j20IA2"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BBC1DFE4
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 17:52:08 +0000 (UTC)
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06471191;
	Thu,  2 Nov 2023 10:52:07 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2c6ec78a840so16737901fa.1;
        Thu, 02 Nov 2023 10:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698947525; x=1699552325; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=q770rsugPPCkF1cWD5uxABhz/caP+0OTOYrkOR8/nmQ=;
        b=i5j20IA2wvim0xWvFwl5ZLjaqR1QxXaa68lZiADqddJzHOCdQ2DL1H0upf4KfP1XCb
         ooCHvzS/60AKc8CtuBHqSVu67nDIeX+HE63DJ23m5l2F+s6oZNxqnxwUMIowWGtXiSKx
         OBIXOQcwl3447nepGBtsoaiAMu8CADW5rjtJDqHMSdd/lxLUMu5a+ZyLfd4r9Imm+96x
         C4+XeN536nLTXb/yLE1BApRaVqBt0Oddw2lm6NyFWKFUXpy7C3XMkit2lqKv3D+jdL2F
         1b4VLbnupOwDACwb6H3CL5iec3yXChund+ccjlGyqqr0fVBgUc8cLJ50JJp7NzQb3SSY
         Giog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698947525; x=1699552325;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q770rsugPPCkF1cWD5uxABhz/caP+0OTOYrkOR8/nmQ=;
        b=iHvnsNhTPMgwSjZM/3ABY4elsat2Xx1CzaNXMoNRFRllziTrwSBJpG4rzvKAQ/CEXH
         WelgqfNf09FFpBijoakD3At964cXdBTjjRp8uxym9x9XGMDFPXUWLuisiCfmzMiQcNh/
         QMLM/gE5q00T7uNc49M6eHtlxT2NNV1dhqNzccbjsU4/VMrDUFn6XeuY0hk32yjdyLHH
         f03xgWQtPiB7AGTYgx1NALeDVB4WeyFrzixaloZgLS2v+WRhd5pTBTpBbZNXo1WVKbG/
         +3aQ13efK1FQ2yU3KeTJ3kVgIoPoyb4f+jxbzQUHmh7F4oFMrXtZCWjAF36m0Lql206D
         QLrg==
X-Gm-Message-State: AOJu0YxoAJPz037VRokc5FS4mAfdD9MxlozXedLPIS8mhyC1iopVqUmV
	o1JWyPHEakN+VoBUnaIxgq8=
X-Google-Smtp-Source: AGHT+IF9n1L9IgXb/mFn0TMSbRMzwN8X5GGRqDBuJOE5erOkckOdvz0+ZY9R9SBketoVe83X47cmmw==
X-Received: by 2002:a05:651c:10b5:b0:2b9:3684:165 with SMTP id k21-20020a05651c10b500b002b936840165mr13328610ljn.8.1698947524968;
        Thu, 02 Nov 2023 10:52:04 -0700 (PDT)
Received: from [192.168.14.38] (54-240-197-227.amazon.com. [54.240.197.227])
        by smtp.gmail.com with ESMTPSA id h18-20020a05600c351200b004094c5d929asm223247wmq.10.2023.11.02.10.52.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Nov 2023 10:52:04 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <734ac3e7-9fc4-47a4-9951-2fa04e10fe7d@xen.org>
Date: Thu, 2 Nov 2023 17:52:02 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v7 02/11] KVM: pfncache: add a mark-dirty helper
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>,
 David Woodhouse <dwmw2@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
References: <20231002095740.1472907-1-paul@xen.org>
 <20231002095740.1472907-3-paul@xen.org> <ZUGNkCljRm5VXcGg@google.com>
Organization: Xen Project
In-Reply-To: <ZUGNkCljRm5VXcGg@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31/10/2023 23:28, Sean Christopherson wrote:
> On Mon, Oct 02, 2023, Paul Durrant wrote:
>> From: Paul Durrant <pdurrant@amazon.com>
>>
>> At the moment pages are marked dirty by open-coded calls to
>> mark_page_dirty_in_slot(), directly deferefencing the gpa and memslot
>> from the cache. After a subsequent patch these may not always be set
>> so add a helper now so that caller will protected from the need to know
>> about this detail.
>>
>> NOTE: Pages are now marked dirty while the cache lock is held. This is
>>        to ensure that gpa and memslot are mutually consistent.
> 
> This absolutely belongs in a separate patch.  It sounds like a bug fix (haven't
> spent the time to figure out if it actually is), and even if it doesn't fix
> anything, burying something like this in a "add a helper" patch is just mean.
> 

Ok, I can split it out. It's a pretty minor fix so didn't seem worth it.

> 
>> diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
>> index 0f36acdf577f..b68ed7fa56a2 100644
>> --- a/virt/kvm/pfncache.c
>> +++ b/virt/kvm/pfncache.c
>> @@ -386,6 +386,12 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
>>   }
>>   EXPORT_SYMBOL_GPL(kvm_gpc_activate);
>>   
>> +void kvm_gpc_mark_dirty(struct gfn_to_pfn_cache *gpc)
>> +{
> 
> If there's actually a reason to call mark_page_dirty_in_slot() while holding @gpc's
> lock, then this should have a lockdep.  If there's no good reason, then don't move
> the invocation.
> 
>> +	mark_page_dirty_in_slot(gpc->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_gpc_mark_dirty);
> 
> This doesn't need to be exported.  Hrm, none of the exports in this file are
> necessary, they likely all got added when we were thinking this stuff would be
> used for nVMX.  I think we should remove them, not because I'm worried about
> sub-modules doing bad things, but just because we should avoid polluting exported
> symbols as much as possible.

That in a separate clean-up patch too, I assume?

   Paul

