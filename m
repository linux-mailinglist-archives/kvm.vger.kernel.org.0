Return-Path: <kvm+bounces-4555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D58F3814445
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 10:12:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AAEB2848E2
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 09:12:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98C92179A2;
	Fri, 15 Dec 2023 09:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZbNW5OX/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177D62D78C
	for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 09:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-33642ab735dso306129f8f.0
        for <kvm@vger.kernel.org>; Fri, 15 Dec 2023 01:10:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702631444; x=1703236244; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=xyr5TJLNSb1EUEDsHZ/ywW0qW51i7FAN+0eNJUcIkvA=;
        b=ZbNW5OX/F0xCTPdGV7qUszEXmtmTj+S6iSfkTuEXAzv3G+YKyAIM7FGKgBwWBuDykg
         xkO0j2TOjWb69AeU995Q0h95N1KoRG73DgNt0G6pXpJztLXh6JNlkGJQiIVKi+tjFln5
         S6teUUcNOIQgN/C7gIL/9STAjxR2mI3NlHqkTlCND1CcyKXmGmEgZMrBjsPCyfcGXqY9
         zvIcsmbQwpchKfDPmG8yfXvL3Z86OyNJ0Qlx3dTqi0aqXEkv6FcmtsGOvLr+0xFJI5SI
         rsgHvXZRS72hrIuPhN/CXncy+2GZ+EWAo1IOUMNVLfVKwaMWRq30naIue9KfgDzQKh/7
         qDEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702631444; x=1703236244;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xyr5TJLNSb1EUEDsHZ/ywW0qW51i7FAN+0eNJUcIkvA=;
        b=WQE7wwJ57iqsfNtLny5breDs6an+uuEGpkspCmOr6gIJGfk8ePEDx6dN/GRdrg7i2t
         s2BHRoJ63oLqQO6Sn+71orbWkUqc914gXlNYzUCZM26uguL5zMwgKmHmZq/eclzW1dyV
         P8y54tlaGwYHOlQNYCWX2qStk0pF9cH4ofgDyJXSk9k5086499CQH+1A34aGXoFuQ2g4
         5hBLJlUFDUk9L7FlncDdfGPE62UzRNAArAiCq8Fg2ZCLhCf4GD8Q9z+RKlUHgzZnl377
         NlUE8XgW9yjmu/1y/bRwZNsBsRcxQ7TppWqLgiIW7ZggVvUhG6m2rZ+qJ5Kw9ypqLhhU
         r/ww==
X-Gm-Message-State: AOJu0YyBmzo+XO8fccCn/5HXTgFXSBMVIcp+WfiR9dFvmpXXNZLa5WST
	7AUWNJGtV7MA5ybQBjr2+0s=
X-Google-Smtp-Source: AGHT+IFH8ThZBlDiZwIvA7bZGSq08OJQRA8x7iJzDU0CMOm7QfRCv6JE4/Om6fMKh532v5xpgV7w6w==
X-Received: by 2002:a05:6000:128b:b0:336:3aa2:4458 with SMTP id f11-20020a056000128b00b003363aa24458mr1060771wrx.154.1702631444074;
        Fri, 15 Dec 2023 01:10:44 -0800 (PST)
Received: from [192.168.2.124] (54-240-197-233.amazon.com. [54.240.197.233])
        by smtp.gmail.com with ESMTPSA id g6-20020a5d5546000000b003364ee1fcf7sm1327901wrw.19.2023.12.15.01.10.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Dec 2023 01:10:43 -0800 (PST)
Message-ID: <ff8768e1-5150-4d06-9d6e-eabb7f30aa56@gmail.com>
Date: Fri, 15 Dec 2023 09:10:42 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v2] KVM: x86/xen: Inject vCPU upcall vector when local
 APIC is enabled
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Paul Durrant <paul@xen.org>
References: <884c08981d44f420f2a543276141563d07464f9b.camel@infradead.org>
From: "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <884c08981d44f420f2a543276141563d07464f9b.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14/12/2023 16:56, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Linux guests since commit b1c3497e604d ("x86/xen: Add support for
> HVMOP_set_evtchn_upcall_vector") in v6.0 onwards will use the per-vCPU
> upcall vector when it's advertised in the Xen CPUID leaves.
> 
> This upcall is injected through the local APIC as an MSI, unlike the
> older system vector which was merely injected by the hypervisor any time
> the CPU was able to receive an interrupt and the upcall_pending flags is
> set in its vcpu_info.
> 
> Effectively, that makes the per-CPU upcall edge triggered instead of
> level triggered.
> 
> We lose edges.
> 
> Specifically, when the local APIC is *disabled*, delivering the MSI
> will fail. Xen checks the vcpu_info->evtchn_upcall_pending flag when
> enabling the local APIC for a vCPU and injects the vector immediately
> if so.
> 
> Since userspace doesn't get to notice when the guest enables a local
> APIC which is emulated in KVM, KVM needs to do the same.
> 
> Astute reviewers may note that kvm_xen_inject_vcpu_vector() function has
> a WARN_ON_ONCE() in the case where kvm_irq_delivery_to_apic_fast() fails
> and returns false. In the case where the MSI is not delivered due to the
> local APIC being disabled, kvm_irq_delivery_to_apic_fast() still returns
> true but the value in *r is zero. So the WARN_ON_ONCE() remains correct,
> as that case should still never happen.
> 
> Fixes: fde0451be8fb3 ("KVM: x86/xen: Support per-vCPU event channel upcall via local APIC")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
> v2:
>   • Add Fixes: tag.
> 
> 
>   arch/x86/kvm/lapic.c |  5 ++++-
>   arch/x86/kvm/xen.c   |  2 +-
>   arch/x86/kvm/xen.h   | 18 ++++++++++++++++++
>   3 files changed, 23 insertions(+), 2 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


