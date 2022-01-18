Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36071492BAE
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 17:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244011AbiARQzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 11:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347071AbiARQy4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 11:54:56 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA07C06161C
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 08:54:55 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id s15so13535547pfw.1
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 08:54:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7AkN9AuvNoGXQoG3HKbel6VdbW2Q5OGliihki1blcTs=;
        b=IPE2u9kVruA4IKI9IR2AFOUHMcMHjH1QfU+httwrf0Ab6ZroQKTmaCds+dI/L+khmi
         T8XHZeJFjSUN+NU2BSAIIaGxwLP6vwCOZjvbq7mEGUvh5m5ZNsLu39W5ezETpzKZoHlE
         q5YeJZIpcJG3Z8hJ+qJdukHqYJ1cU2Hf1MAqqUky/HbMgo8ElKfjeA51z+K6BQkQHuX0
         TrJq10G9LDLPaY6+qEkKYDiKrQKoYygxt+LwlaBEFUHZPS3zBr/ETnaWV7rK852is8Q5
         Q3GSz5WRyVPlJH5+gLOVf4fz5MipMeqwfsLJHRqfVSumphj0a3PHOHZq0wOmxZiFE2fn
         0kdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7AkN9AuvNoGXQoG3HKbel6VdbW2Q5OGliihki1blcTs=;
        b=erKHw+LGWLg8z6GuEoaXpD4ax8YYxNLSORup8ijI7RHmC8g86c8r6OBbueDwNrMCxW
         P+Fw5z19WO1HvwdRWV8BjYAswCHe6zDs/UJakz4XmJ0YRlHU4UQ3oFnezihfUapiiSth
         0syvQF08Xju5N0+2pYDTYUvhOU0ZoH3DWyQbJPMh8h5ZF2cIkUQBrPFzezQE6Eh1EgsZ
         scrAKZWedyvZ6CxklYDu0U265a+6b6VOD0HA9oCMlDmyzWLpJ8A44cNSaC/sfB0FRWLj
         tMGwYyStorDTlHEEmJOVhv8lyT4/jW18kxO2MkdnUtu0lMPrXLouy0Skpf8sLE3EAoc7
         sK0w==
X-Gm-Message-State: AOAM531k43OOUha6jISlAU3lBka+XqQ0ZJ4kgifLUhzy+Au1YnGkWZ9l
        TA9xAcuPpRk71V95u09GJ+nRoQ==
X-Google-Smtp-Source: ABdhPJxT3k697xg51NMUb6/aq192Zci2ULSDPh/hST/Fth7OmzYFS4WtQbbefquFDpfS0hXIBYM4hA==
X-Received: by 2002:a65:4cc2:: with SMTP id n2mr18533478pgt.535.1642524895201;
        Tue, 18 Jan 2022 08:54:55 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p186sm17571289pfp.128.2022.01.18.08.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 08:54:54 -0800 (PST)
Date:   Tue, 18 Jan 2022 16:54:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Zhong <yang.zhong@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 1/2] kvm: selftests: Sync KVM_CAP_XSAVE2 from linux header
Message-ID: <Yebw2wQu4OuS0CB2@google.com>
References: <20220118140144.58855-1-yang.zhong@intel.com>
 <20220118140144.58855-2-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118140144.58855-2-yang.zhong@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 18, 2022, Yang Zhong wrote:
> Need sync KVM_CAP_XSAVE2 from linux header to here.
> 
> Signed-off-by: Yang Zhong <yang.zhong@intel.com>
> ---
>  tools/include/uapi/linux/kvm.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> index f066637ee206..63b96839186c 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -1131,7 +1131,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
>  #define KVM_CAP_ARM_MTE 205
>  #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
> -#define KVM_CAP_XSAVE2 207
> +#define KVM_CAP_XSAVE2 208

Any reason not to opportunistically sync the entire file?  E.g. this diff looks
rather confusing without pulling in KVM_CAP_VM_GPA_BITS (that consumes "207").

>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
