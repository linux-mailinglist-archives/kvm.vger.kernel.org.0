Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1FF71998F5
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 16:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730533AbgCaOv7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 10:51:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37039 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730153AbgCaOv6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 10:51:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585666317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BDECw4Jp5diyRW+zp7XYY468nsqeU3iwo9Wu7xQsHVE=;
        b=NJB3JmEr+1RjW41SBCtJFHsiSGW8hNslv6Y2vJGOfDGCtKGbfggm+BkvUndgDqbYJD47tQ
        rntAFyzAiZ8tti6eifzqDJ6a6+CkH4HX4TSarz2y9lrP38hrsGcrM2obXKlV5s1JGtqFar
        hewcHu2Th1/53YDe0VOxIaWfYaFOXD0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-LnhbRzj3PnuncsFGdnrhJg-1; Tue, 31 Mar 2020 10:51:56 -0400
X-MC-Unique: LnhbRzj3PnuncsFGdnrhJg-1
Received: by mail-wm1-f69.google.com with SMTP id w8so1164805wmk.5
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 07:51:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BDECw4Jp5diyRW+zp7XYY468nsqeU3iwo9Wu7xQsHVE=;
        b=gJ2WpetxktmdhaV9yzBGwR6tWT7KIs2WttpAiD0NkEpyRDVorIzuNHomfJ6s3/6EtM
         jndlS42YJk4BR6jSz9mC8f75z7Oa9fs4w4hJya3lJUxp+JQpB+VEHpYD4J/B73dBYrr+
         ilQyWe/pCHHa5L/rRvsuxgzp+FHyHGfgjHJMGCojnZ2S+M4evuBP/IApLB+SartzrrG+
         X7E6A1dFhKCvPodvwawcznvtvpFIt/T/B16zl7YnX6X60cKe61amNmNlFiOIiLl8WgKL
         WrW4I4+IbWsZBbW36oNwzktlU5f2Wbtd0mouf7m0g1WpZnUTZlHofc7Ts0C1B7CUPt2i
         MrGQ==
X-Gm-Message-State: ANhLgQ22VXpa3ry+zIlJn0cvcE/h7jQPq0DVRdEkge1wlBMLrjHGHub6
        6Dl6JALkyyPwwyBHyICyzlibj1iCYfzXGaKicnjY5H9aBAYaMjwJVVrNbYlN+n0rmS31LttaAPP
        PyJeECs12oO3q
X-Received: by 2002:adf:de01:: with SMTP id b1mr19917335wrm.376.1585666315009;
        Tue, 31 Mar 2020 07:51:55 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vupXM5pQZMzUDS/XKpSKnf+xfUggsYlgWDrPztm8ckKXsUeZM/TnUcNGpHowo5uD4xx1p4Ydw==
X-Received: by 2002:adf:de01:: with SMTP id b1mr19917312wrm.376.1585666314721;
        Tue, 31 Mar 2020 07:51:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b55d:5ed2:8a41:41ea? ([2001:b07:6468:f312:b55d:5ed2:8a41:41ea])
        by smtp.gmail.com with ESMTPSA id a13sm19618574wrt.64.2020.03.31.07.51.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2020 07:51:54 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Fix BUILD_BUG() in __cpuid_entry_get_reg() w/
 CONFIG_UBSAN=y
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
References: <20200325191259.23559-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d2f9a3a5-5ade-c810-4c61-cf8e9c92c93d@redhat.com>
Date:   Tue, 31 Mar 2020 16:51:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200325191259.23559-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/03/20 20:12, Sean Christopherson wrote:
> Take the target reg in __cpuid_entry_get_reg() instead of a pointer to a
> struct cpuid_reg.  When building with -fsanitize=alignment (enabled by
> CONFIG_UBSAN=y), some versions of gcc get tripped up on the pointer and
> trigger the BUILD_BUG().
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Fixes: d8577a4c238f8 ("KVM: x86: Do host CPUID at load time to mask KVM cpu caps")
> Fixes: 4c61534aaae2a ("KVM: x86: Introduce cpuid_entry_{get,has}() accessors")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 2 +-
>  arch/x86/kvm/cpuid.h | 8 ++++----
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 08280d8a2ac9..16d3ae432420 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -269,7 +269,7 @@ static __always_inline void kvm_cpu_cap_mask(enum cpuid_leafs leaf, u32 mask)
>  	cpuid_count(cpuid.function, cpuid.index,
>  		    &entry.eax, &entry.ebx, &entry.ecx, &entry.edx);
>  
> -	kvm_cpu_caps[leaf] &= *__cpuid_entry_get_reg(&entry, &cpuid);
> +	kvm_cpu_caps[leaf] &= *__cpuid_entry_get_reg(&entry, cpuid.reg);
>  }
>  
>  void kvm_set_cpu_caps(void)
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 23b4cd1ad986..63a70f6a3df3 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -99,9 +99,9 @@ static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned int x86_featu
>  }
>  
>  static __always_inline u32 *__cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
> -						  const struct cpuid_reg *cpuid)
> +						  u32 reg)
>  {
> -	switch (cpuid->reg) {
> +	switch (reg) {
>  	case CPUID_EAX:
>  		return &entry->eax;
>  	case CPUID_EBX:
> @@ -121,7 +121,7 @@ static __always_inline u32 *cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
>  {
>  	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
>  
> -	return __cpuid_entry_get_reg(entry, &cpuid);
> +	return __cpuid_entry_get_reg(entry, cpuid.reg);
>  }
>  
>  static __always_inline u32 cpuid_entry_get(struct kvm_cpuid_entry2 *entry,
> @@ -189,7 +189,7 @@ static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu,
>  	if (!entry)
>  		return NULL;
>  
> -	return __cpuid_entry_get_reg(entry, &cpuid);
> +	return __cpuid_entry_get_reg(entry, cpuid.reg);
>  }
>  
>  static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu,
> 

Queued, thanks.

Paolo

