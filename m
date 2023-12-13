Return-Path: <kvm+bounces-4336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E9E78112F1
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 14:32:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 117281F21560
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 13:32:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A10BE2D042;
	Wed, 13 Dec 2023 13:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WUbAju55"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1986E10A
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 05:31:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702474306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6ZKsZXAGZPzGdkl/Bds/E/0NRdRFaaRkoaeJez+DeeI=;
	b=WUbAju55neVpt0AUOTcWy+B33D0HS3h81dzrBJx6jThjeH8kxtwDtwk1Yjoi9Yz+VMujdH
	V+3/fMUGNIEy+NdO5AaOTU08wvRHZmjVHJ1wwqlqA7ii8qyP9zlCIU9zhEg2QdXy4OG1cy
	ef5xsQlqCb/gapYNAr+sAwcyY0NqxKI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-R5zgAqAUOBe5ZkIRjEYjmQ-1; Wed, 13 Dec 2023 08:31:45 -0500
X-MC-Unique: R5zgAqAUOBe5ZkIRjEYjmQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a1d1c249b3aso371886666b.0
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 05:31:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702474304; x=1703079104;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6ZKsZXAGZPzGdkl/Bds/E/0NRdRFaaRkoaeJez+DeeI=;
        b=qTSK8t4u+K3GYCtC15yMNGJMdn6b6ojbvfBCeyrki7BzGAxP16mrkUGMV3azXHlHyw
         Z53VgH5mknWtSWzNzvnzvraZaCkzJ5iA9R9OwucL7Zqai1PgC9iuTdDFWIS3S2G4Wnhg
         J4xpaynY/SXS/UfICb8DrwDCBn1BWMtTQvW6ILeIcBnSkJmUquriSsWiXe6CQ56kTM68
         38sAFnRTaJ9VbRALVsLubdknE1zGb+3kO7AcEkJVHKcX0DBobK4dACd5xEw93WlE37CJ
         b3bnVJF0YzyOyB8Va1vqZlKq3c3BHKWmp6sxAT1TjToKAqQof8yMcO6MxgJf2rrFct6l
         IblA==
X-Gm-Message-State: AOJu0YxCw4qRHgBbQJFSI5AH9n81cSEUuexSqidSLjcBkZbgAsMubKfQ
	hA37kr5TmCJhsXc+iJ+FM7eDyYw4Ivvvzg46+02NxaYi2dyVxHtHMFQ8jWK11+KMy8XHP81B1W4
	MQmRi1J2OTKDL
X-Received: by 2002:a17:906:2:b0:a23:482:ee74 with SMTP id 2-20020a170906000200b00a230482ee74mr251954eja.28.1702474303954;
        Wed, 13 Dec 2023 05:31:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFPrwg34mR9QL3IK9lbbz36ejShRG3Tw1YL7unA2WVHwsE4ZIHQYfrs0+x2kBoMmIZzjvL3FA==
X-Received: by 2002:a17:906:2:b0:a23:482:ee74 with SMTP id 2-20020a170906000200b00a230482ee74mr251933eja.28.1702474303726;
        Wed, 13 Dec 2023 05:31:43 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id tg10-20020a1709078dca00b00a178b965899sm7819372ejc.100.2023.12.13.05.31.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Dec 2023 05:31:43 -0800 (PST)
Message-ID: <f08334c6-24b4-4451-b1e1-3834b933f2fa@redhat.com>
Date: Wed, 13 Dec 2023 14:31:37 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 23/50] KVM: SEV: Make AVIC backing, VMSA and VMCB
 memory allocation SNP safe
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, marcorr@google.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
 pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
 Brijesh Singh <brijesh.singh@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-24-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20231016132819.1002933-24-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/23 15:27, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Implement a workaround for an SNP erratum where the CPU will incorrectly
> signal an RMP violation #PF if a hugepage (2mb or 1gb) collides with the
> RMP entry of a VMCB, VMSA or AVIC backing page.
> 
> When SEV-SNP is globally enabled, the CPU marks the VMCB, VMSA, and AVIC
> backing pages as "in-use" via a reserved bit in the corresponding RMP
> entry after a successful VMRUN. This is done for _all_ VMs, not just
> SNP-Active VMs.
> 
> If the hypervisor accesses an in-use page through a writable
> translation, the CPU will throw an RMP violation #PF. On early SNP
> hardware, if an in-use page is 2mb aligned and software accesses any
> part of the associated 2mb region with a hupage, the CPU will
> incorrectly treat the entire 2mb region as in-use and signal a spurious
> RMP violation #PF.

I don't understand if this can happen even if SEV-SNP is not in use, 
just because it is supported on the host?  If so, should this be Cc'd to 
stable?  (I can tweak the wording and submit it).

Paolo


