Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9047B23178
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 12:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731091AbfETKjd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 06:39:33 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33047 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfETKjd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 06:39:33 -0400
Received: by mail-wr1-f67.google.com with SMTP id d9so1035876wrx.0
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 03:39:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LSXvvjLM2HBXWG9qhIrfISHU3rhydRFpcgUUVJCwNBc=;
        b=pE0OYv1biVvUwlHJKze1cqA7JbRC2P6if8HCI0+BVd3iW6Rk6mQgRjfxkBWCBuUv8r
         R2wIaphhvwdAXkS6As1hUpm221+wrQ1MvPUuRO7b3S1z0Tl6fiZ8tDx8phg7ZDp6Ij+f
         YSBKQHdOIXms5MxBWM/0GChYLtROVxTWrLDK8xc82TmF8KNf4ZLJ+z4fES9iA8u0yIe5
         phcw1BQZPXUKHy7cSZVWg5f+8jV7ZEY2MLKnpB3IzjMjeFvW3JgpJsPqzLg/xVfTCGgi
         DgtEnOqjf0y2O+zAfzjt3jHtySaTbF8n7bPXF/gfKX3lbnlQryB+GwmAUnYvt6MzEx15
         EOHQ==
X-Gm-Message-State: APjAAAXznf2bJeogGs/pCz1AMnl2DVf6ls6MAoDM21V5yhWVv5W+8onn
        8nQdJ0ow/lMURkqf3PMpGtdc7A==
X-Google-Smtp-Source: APXvYqxfM+AbzlMq4FVA03dUQrFO7n+VwiQjUOMIWGa8PFwNSVyl0na3x5bC/WWRAhmCS1nkMNk3pA==
X-Received: by 2002:a5d:5743:: with SMTP id q3mr5645987wrw.92.1558348771961;
        Mon, 20 May 2019 03:39:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id z202sm2751084wmc.18.2019.05.20.03.39.31
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 03:39:31 -0700 (PDT)
Subject: Re: [PATCH] kvm: vmx: Fix -Wmissing-prototypes warnings
To:     Yi Wang <wang.yi59@zte.com.cn>
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1558326467-48530-1-git-send-email-wang.yi59@zte.com.cn>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4babb584-27d6-a5be-c8a9-828079920130@redhat.com>
Date:   Mon, 20 May 2019 12:39:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1558326467-48530-1-git-send-email-wang.yi59@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/19 06:27, Yi Wang wrote:
> We get a warning when build kernel W=1:
> arch/x86/kvm/vmx/vmx.c:6365:6: warning: no previous prototype for ‘vmx_update_host_rsp’ [-Wmissing-prototypes]
>  void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
> 
> Add the missing declaration to fix this.
> 
> Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
> ---
>  arch/x86/kvm/vmx/vmx.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index f879529..9cd72de 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -314,6 +314,7 @@ struct kvm_vmx {
>  void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
>  struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
>  void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
> +void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
>  
>  #define POSTED_INTR_ON  0
>  #define POSTED_INTR_SN  1
> 

Queued, thanks.

Paolo
