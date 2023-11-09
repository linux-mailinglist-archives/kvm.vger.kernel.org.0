Return-Path: <kvm+bounces-1310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 565437E653D
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 09:26:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E6DA3B20FA0
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 08:26:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4F731097E;
	Thu,  9 Nov 2023 08:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LKvY9/9h"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E811094D
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 08:25:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC542D55
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 00:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699518350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=odt/5xMXbjMgZlXR9oRA3wdW/adm1/gNuEpMj2VBGmk=;
	b=LKvY9/9hLR8xEqYc7DZvB4Z0Jc6fA83ZMmSFKBMQ5UULJKfjDsr1VSlY0PZO59RfM7rlYz
	x+JkEVTIRlGnTGOy5I9cE1/e603ku3y4Mc29L4OUK9JH6kVbbYtR5+Im04ySbMJTa1Y4y5
	tU9v8kNo1NXBYxEbheD3POyFTAFFUKE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-361-1NWmOpozMmCtWJL07jw2CQ-1; Thu, 09 Nov 2023 03:25:47 -0500
X-MC-Unique: 1NWmOpozMmCtWJL07jw2CQ-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-54061ad6600so414222a12.3
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 00:25:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699518347; x=1700123147;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=odt/5xMXbjMgZlXR9oRA3wdW/adm1/gNuEpMj2VBGmk=;
        b=mlxsgm6/ICuyDOSBQOarsExPsOvr0qH7tLhkeUhzDOlLmdd14v67qkahxgaaVAgFoX
         p7GMrcxWY1TM0cq55ODxSxr04K2iMv5My97zj1lPM9JGLZTOY/kvQWu6/jmN+k4Rb0l2
         PToxr/BGGO9RtmFHsgCKV1Wt/NgSnijaIpK1IecUwtNPNV5L7AQOvPixwjNVxAZSCTI4
         8n2XmUNP4KrDgkxJjeR9rOziAA9yuhsmuabQIIP0jehIkTnwELKh3uOWvf4M0TwHZZU1
         h0jdMgqbPunVpTi11SpRleOAO7kzeg4aJorZ3+tg3WxwEDDt8w89G1r7+uEMWIQwIG7T
         LESQ==
X-Gm-Message-State: AOJu0YyNtcyCllRjf5tWxEzFmR4bYRg3IfAFFQozj9pRX013AwzV+fed
	HVZdJRMfXbVprIQ3b+aCYZWvCpeaE3u/N2jcIvDwFET5BDFCZYbdvRVqiMwcTqk2QU3SSHSKHAQ
	od6eoJXaHBv4q
X-Received: by 2002:a50:9f4e:0:b0:540:ccde:5 with SMTP id b72-20020a509f4e000000b00540ccde0005mr3348777edf.37.1699518346873;
        Thu, 09 Nov 2023 00:25:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGc/8h7txNeYrJdeIJbeZLdKa5Ej0cD8Q6TYT5qVu8zzxOyeTh4hQuHi7CupWqz8J3PkKtaWg==
X-Received: by 2002:a50:9f4e:0:b0:540:ccde:5 with SMTP id b72-20020a509f4e000000b00540ccde0005mr3348751edf.37.1699518346536;
        Thu, 09 Nov 2023 00:25:46 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id j28-20020a508a9c000000b0053e3839fc79sm8007819edj.96.2023.11.09.00.25.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Nov 2023 00:25:45 -0800 (PST)
Message-ID: <143f5411-9fc0-4e88-9e35-6f3679b6f930@redhat.com>
Date: Thu, 9 Nov 2023 09:25:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 27/34] KVM: selftests: Introduce VM "shape" to allow tests
 to specify the VM type
Content-Language: en-US
To: Anish Moorthy <amoorthy@google.com>
Cc: ackerleytng@google.com, akpm@linux-foundation.org, anup@brainfault.org,
 aou@eecs.berkeley.edu, brauner@kernel.org, chao.p.peng@linux.intel.com,
 chenhuacai@kernel.org, david@redhat.com, dmatlack@google.com,
 isaku.yamahata@gmail.com, isaku.yamahata@intel.com, jarkko@kernel.org,
 kirill.shutemov@linux.intel.com, kvm-riscv@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev, liam.merwick@oracle.com,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
 linux-mm@kvack.org, linux-riscv@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, mail@maciej.szmigiero.name, maz@kernel.org,
 mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au,
 oliver.upton@linux.dev, palmer@dabbelt.com, paul.walmsley@sifive.com,
 qperret@google.com, seanjc@google.com, tabba@google.com,
 vannapurve@google.com, vbabka@suse.cz, viro@zeniv.linux.org.uk,
 wei.w.wang@intel.com, willy@infradead.org, xiaoyao.li@intel.com,
 yilun.xu@intel.com, yu.c.zhang@linux.intel.com
References: <CAF7b7mrGYuyjyEPAesYzZ6+KDuNAmvRxEonT7JC8NDPsSP+qDA@mail.gmail.com>
 <20231108233723.3380042-1-amoorthy@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20231108233723.3380042-1-amoorthy@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/9/23 00:37, Anish Moorthy wrote:
> On Wed, Nov 8, 2023 at 9:00 AM Anish Moorthy <amoorthy@google.com> wrote:
>>
>> This commit breaks the arm64 selftests build btw: looks like a simple oversight?
> 
> Yup, fix is a one-liner. Posted below.
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> index eb4217b7c768..08a5ca5bed56 100644
> --- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> @@ -705,7 +705,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>   
>   	print_test_banner(mode, p);
>   
> -	vm = ____vm_create(mode);
> +	vm = ____vm_create(VM_SHAPE(mode));

Yes, this is similar to the s390 patch I sent yesterday 
(https://patchew.org/linux/20231108094055.221234-1-pbonzini@redhat.com/).

Paolo


