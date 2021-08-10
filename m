Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E41D3E809A
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 19:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235449AbhHJRu5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 13:50:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39382 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236981AbhHJRt4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 13:49:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628617773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0KzzWWydf8LiVFF2bszHb+kRn/d06ypSq2y4qAppX7o=;
        b=P/Y/MLQgvH+cKLmT+nd6yMGyJ3ue0Xms5AjP9j0GHNK4q+XTbDzsqwACnqmLnmEpYchY5C
        vnFzWkOasDMmrezy5Eu4AifgjO8BdboV2InDpL0f+jba8EGiV7DIZUwTGjOLkwpcEY1MX9
        5JqqulEZG0EOX0tg9Hdonl4ZWheRY0o=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-f2nEXgmNPraQjk8BW7-9fA-1; Tue, 10 Aug 2021 13:49:32 -0400
X-MC-Unique: f2nEXgmNPraQjk8BW7-9fA-1
Received: by mail-ej1-f69.google.com with SMTP id nb40-20020a1709071ca8b02905992266c319so5843754ejc.21
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 10:49:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0KzzWWydf8LiVFF2bszHb+kRn/d06ypSq2y4qAppX7o=;
        b=GpewRp/zmjCTKQ4b6RYENl9kmyELoi/r881TghBYpQTV1mIHUbzzSZDmNUWRCdL+cY
         2ri6MukJg2kdRBMpX6Rarnd94W+Pbf24HeGS4ii7fjlsuj/dZE5DzlDy5pvbPvGrauWM
         FrG3I+rssWcm5h23hz9EH2ZN8iXbtnBlS3DHUbpzHI28L4meUwHh2oM/tIQIkJR5Xi6V
         GksHWm1XHOVhTqIjWquInP8DstDdO4BMoTZd58gm4LOxSDZ1MaIz0xxefq/pcwclNs/H
         +bs0gfT0jkBuTXP/LZ4OE3ePDKjYTnkn7eA/Ewv5TJkk8EEdRI/USL3vIdkvj4RCKUE6
         sHIQ==
X-Gm-Message-State: AOAM531MqqVBSUPM3/4872eGeQG2WsH2bbyi1elUoX/kecJoUP0nmpCz
        O5dBkE9HIqiAyo3du/wFsTOohFxQ5jX+EicXKzbGPNIN5qZSSPPTOFzqaV+k1L/g8Y0DptDpAEh
        HP1q9wFNqLVD3
X-Received: by 2002:a05:6402:70b:: with SMTP id w11mr2346223edx.189.1628617771034;
        Tue, 10 Aug 2021 10:49:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzc8mKJwbEt3nN63BHijnIyUS2fSh7WQ3lAt8zxs3wriUF7hc6nhgOSWAOjEeXeelREBygcnQ==
X-Received: by 2002:a05:6402:70b:: with SMTP id w11mr2346207edx.189.1628617770874;
        Tue, 10 Aug 2021 10:49:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id ks26sm7123999ejb.58.2021.08.10.10.49.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 10:49:30 -0700 (PDT)
Subject: Re: [PATCH 3/5] KVM: x86: Clean up redundant ROL16(val, n) macro
 definition
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210809093410.59304-1-likexu@tencent.com>
 <20210809093410.59304-4-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <04cd9384-5f03-207e-19f2-c67e49705d0d@redhat.com>
Date:   Tue, 10 Aug 2021 19:49:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210809093410.59304-4-likexu@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/21 11:34, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> The ROL16(val, n) macro is repeatedly defined in several vmcs-related
> files, and it has never been used outside the KVM context.
> 
> Let's move it to vmcs.h without any intended functional changes.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>   arch/x86/kvm/vmx/evmcs.c  | 1 -
>   arch/x86/kvm/vmx/evmcs.h  | 4 ----
>   arch/x86/kvm/vmx/vmcs.h   | 2 ++
>   arch/x86/kvm/vmx/vmcs12.c | 1 -
>   arch/x86/kvm/vmx/vmcs12.h | 4 ----
>   5 files changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index 896b2a50b4aa..0dab1b7b529f 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -14,7 +14,6 @@ DEFINE_STATIC_KEY_FALSE(enable_evmcs);
>   
>   #if IS_ENABLED(CONFIG_HYPERV)
>   
> -#define ROL16(val, n) ((u16)(((u16)(val) << (n)) | ((u16)(val) >> (16 - (n)))))
>   #define EVMCS1_OFFSET(x) offsetof(struct hv_enlightened_vmcs, x)
>   #define EVMCS1_FIELD(number, name, clean_field)[ROL16(number, 6)] = \
>   		{EVMCS1_OFFSET(name), clean_field}
> diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
> index 2ec9b46f0d0c..152ab0aa82cf 100644
> --- a/arch/x86/kvm/vmx/evmcs.h
> +++ b/arch/x86/kvm/vmx/evmcs.h
> @@ -73,8 +73,6 @@ struct evmcs_field {
>   extern const struct evmcs_field vmcs_field_to_evmcs_1[];
>   extern const unsigned int nr_evmcs_1_fields;
>   
> -#define ROL16(val, n) ((u16)(((u16)(val) << (n)) | ((u16)(val) >> (16 - (n)))))
> -
>   static __always_inline int get_evmcs_offset(unsigned long field,
>   					    u16 *clean_field)
>   {
> @@ -95,8 +93,6 @@ static __always_inline int get_evmcs_offset(unsigned long field,
>   	return evmcs_field->offset;
>   }
>   
> -#undef ROL16
> -
>   static inline void evmcs_write64(unsigned long field, u64 value)
>   {
>   	u16 clean_field;
> diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
> index 4b9957e2bf5b..6e5de2e2b0da 100644
> --- a/arch/x86/kvm/vmx/vmcs.h
> +++ b/arch/x86/kvm/vmx/vmcs.h
> @@ -11,6 +11,8 @@
>   
>   #include "capabilities.h"
>   
> +#define ROL16(val, n) ((u16)(((u16)(val) << (n)) | ((u16)(val) >> (16 - (n)))))
> +
>   struct vmcs_hdr {
>   	u32 revision_id:31;
>   	u32 shadow_vmcs:1;
> diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
> index d9f5d7c56ae3..cab6ba7a5005 100644
> --- a/arch/x86/kvm/vmx/vmcs12.c
> +++ b/arch/x86/kvm/vmx/vmcs12.c
> @@ -2,7 +2,6 @@
>   
>   #include "vmcs12.h"
>   
> -#define ROL16(val, n) ((u16)(((u16)(val) << (n)) | ((u16)(val) >> (16 - (n)))))
>   #define VMCS12_OFFSET(x) offsetof(struct vmcs12, x)
>   #define FIELD(number, name)	[ROL16(number, 6)] = VMCS12_OFFSET(name)
>   #define FIELD64(number, name)						\
> diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
> index 5e0e1b39f495..2a45f026ee11 100644
> --- a/arch/x86/kvm/vmx/vmcs12.h
> +++ b/arch/x86/kvm/vmx/vmcs12.h
> @@ -364,8 +364,6 @@ static inline void vmx_check_vmcs12_offsets(void)
>   extern const unsigned short vmcs_field_to_offset_table[];
>   extern const unsigned int nr_vmcs12_fields;
>   
> -#define ROL16(val, n) ((u16)(((u16)(val) << (n)) | ((u16)(val) >> (16 - (n)))))
> -
>   static inline short vmcs_field_to_offset(unsigned long field)
>   {
>   	unsigned short offset;
> @@ -385,8 +383,6 @@ static inline short vmcs_field_to_offset(unsigned long field)
>   	return offset;
>   }
>   
> -#undef ROL16
> -
>   static inline u64 vmcs12_read_any(struct vmcs12 *vmcs12, unsigned long field,
>   				  u16 offset)
>   {
> 

Queued, thanks.

Paolo

