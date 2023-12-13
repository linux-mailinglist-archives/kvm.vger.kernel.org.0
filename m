Return-Path: <kvm+bounces-4348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92D0D811475
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 15:18:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E414282801
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 14:18:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CFF62E852;
	Wed, 13 Dec 2023 14:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cwx1JGJ+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149A4F5
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 06:18:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702477104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Fws0gJvMeLr/QEe2P9D0VBdduPdR7zo8ED97N4rFNAU=;
	b=Cwx1JGJ+etOOL9jfEA19tblFnXXNs2XtJKygOu+GsWe+xrW3dCy10kzlDoI3sUAFEe48u6
	yPDpNyD5VuSBGQaJ0JSJyBBG+LumGFC0QiilpaIO3VfWjk7LfYCB49B5sHZHBy1KGwIVaI
	sdgqb6VTNZQjNgviNmcyOo+Bo5BGPlY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-620-J13x2G-AMUqa9ijmFJH8Ow-1; Wed, 13 Dec 2023 09:18:23 -0500
X-MC-Unique: J13x2G-AMUqa9ijmFJH8Ow-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9fd0a58549bso771767266b.0
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 06:18:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702477102; x=1703081902;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fws0gJvMeLr/QEe2P9D0VBdduPdR7zo8ED97N4rFNAU=;
        b=oEZFPEZrLjxKpIOjcgTKh1zU6J4T2WKJXVadCOwR7RfoSARqZtlJGE1k7s8O/vexQR
         ZwrBa093BjQLQZTJ8i17aKeaSgxHcbbIo7uNRo73URr3I8L2KFdQlYuxJYN4FldOqQ2v
         I1Q8+3oCs7GBvB0kXbDfWxhkE8BHJNSnJM3DD0xWWjzVTpbiXY35+T/HvER3AuiUzQAk
         Rfe0tfKyClzZdF/dQiBV26mUAW2xz50qqVVsrAU/O9ks8TxGXUnDgXOL3sDi0mQWYDUG
         hrG2eoK6hyCTcb7NKYutuoksNSXvtKGMahPvQYeufFCTyhH33E3VyQt6FgOzt5nbShDw
         sZ5g==
X-Gm-Message-State: AOJu0YwG84E6iq+/sLzNxTxwdMtZp4ZM905e7D+5jOrsTZn7UtyM9KSl
	iT3Ml/tmhKH3tjanUMNnvMgy8Al4LF94wumDCiAs/e+dLUNvfsNG7+0Ahgs8BPkcoAKsnoQUFem
	/xn9pNUOC3UJF
X-Received: by 2002:a17:906:24d:b0:a22:e7d2:5a52 with SMTP id 13-20020a170906024d00b00a22e7d25a52mr2784681ejl.71.1702477101806;
        Wed, 13 Dec 2023 06:18:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGrQokzT8zXusJ+hPGTT9RJ5H7cGwq+NBw1vIEMeKjoo6GUcHW4Rk0RO9/h3vuME7VBPouVjg==
X-Received: by 2002:a17:906:24d:b0:a22:e7d2:5a52 with SMTP id 13-20020a170906024d00b00a22e7d25a52mr2784659ejl.71.1702477101439;
        Wed, 13 Dec 2023 06:18:21 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id tk3-20020a170907c28300b00a1cd54ec021sm7876334ejc.57.2023.12.13.06.18.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Dec 2023 06:18:20 -0800 (PST)
Message-ID: <b4aab361-4494-4a4b-b180-d7df05fd3d5b@redhat.com>
Date: Wed, 13 Dec 2023 15:18:17 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 04/50] x86/cpufeatures: Add SEV-SNP CPU feature
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz,
 kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
 marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com,
 zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>,
 Jarkko Sakkinen <jarkko@profian.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-5-michael.roth@amd.com>
 <0b2eb374-356c-46c6-9c4a-9512fbfece7a@redhat.com>
 <20231213131324.GDZXmt9LsMmJZyzCJw@fat_crate.local>
 <40915dc3-4083-4b9f-bc64-7542833566e1@redhat.com>
 <20231213133628.GEZXmzXFwA1p+crH/5@fat_crate.local>
 <9ac2311c-9ccc-4468-9b26-6cb0872e207f@redhat.com>
 <20231213134945.GFZXm2eTkd+IfdsjVE@fat_crate.local>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20231213134945.GFZXm2eTkd+IfdsjVE@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/23 14:49, Borislav Petkov wrote:
> On Wed, Dec 13, 2023 at 02:40:24PM +0100, Paolo Bonzini wrote:
>> Why are they dead code?  X86_FEATURE_SEV_SNP is set automatically based on
>> CPUID, therefore patch 5 is a performance improvement on all processors that
>> support SEV-SNP.  This is independent of whether KVM can create SEV-SNP
>> guests or not.
> 
> No, it is not. This CPUID bit means:
> 
> "RMP table can be enabled to protect memory even from hypervisor."
> 
> Without the SNP host patches, it is dead code.

-	if ((ia32_cap & ARCH_CAP_IBRS_ALL) || cpu_has(c, X86_FEATURE_AUTOIBRS)) {
+	if ((ia32_cap & ARCH_CAP_IBRS_ALL) ||
+	    (cpu_has(c, X86_FEATURE_AUTOIBRS) &&
+	     !cpu_feature_enabled(X86_FEATURE_SEV_SNP))) {

Surely we can agree that cpu_feature_enabled(X86_FEATURE_SEV_SNP) has nothing
to do with SEV-SNP host patches being present?  And that therefore retpolines
are preferred even without any SEV-SNP support in KVM?

And can we agree that "Acked-by" means "feel free and take it if you wish,
I don't care enough to merge it through my tree or provide a topic branch"?

I'm asking because I'm not sure if we agree on these two things, but they
really seem basic to me?

Paolo

> And regardless, arch/x86/kvm/ patches go through the kvm tree. The rest
> of arch/x86/ through the tip tree. We've been over this a bunch of times
> already.


> If you don't agree with this split, let's discuss it offlist with all
> tip and kvm maintainers, reach an agreement who picks up what and to put
> an end to this nonsense.
> 
> Thx.
> 


