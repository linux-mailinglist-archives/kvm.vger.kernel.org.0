Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1FA4358938
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 18:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbhDHQFg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 12:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbhDHQFg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 12:05:36 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279DDC061760
        for <kvm@vger.kernel.org>; Thu,  8 Apr 2021 09:05:25 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id t23so1382033pjy.3
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 09:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tMpvuw4Dh1XLxT2uBdDI6pLUzC3nDjV8ZP4ZU+oHty0=;
        b=psxEOtbqErsbiYdmdyyqxvSUlj08ZH3OMBVs8rhyASQ7AZzbbAtbkeLl9b7UZtY+Ah
         ZWUw7063Eg9YW+MJfHfOGqbrWqixOlkkD2E24K756JRYVOH8N6rywbYECmiqzXufBAdQ
         EUjPZlPmtIPvAjV3mIcW5H3hjvBXlONmgjIWaodyPs+ZovRIMc9jPbSZwWouWdfkrx1A
         lXYj8jaGkGfMX7EBNobmMTCgRW6VxPj9gAo/7XXxN05iJauutjgm85iU/vWYUKn2TUGL
         VfwzNs8t/WBBTn0t5u0kbhIXKnfc5dP93zvslSIh9I5Osbr0OxYtUiQwldANslXDz317
         itIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tMpvuw4Dh1XLxT2uBdDI6pLUzC3nDjV8ZP4ZU+oHty0=;
        b=stsWjI5OjaCyqaQSIPkChuqX0S6mW/Y2fML6nXYwCTxdoNrGyHNFreoix50z4cwgLq
         anX8ADyuQZSdm4PZjTM5oEL1lOPrABnJfyHxYD9JOizq+tojhy/Bb55j6XK7VVxvXVd4
         242hAgNGmfXRwUtwRmG71cL/0aaDCL4mZf5ECFidpT132SQXVFL5yy24fzPXI0Qt31GH
         5u3hDtL2n+3dgECG6xzMUWgsHv4qGsWrpWvi/BOsBK/92I8Q2IwnXyEe+xO1uA7ElAXB
         /0GFWs/yYZHMCa/PSxOSi9TT6vrK3aiRiVhu09FhutqX1Xz7oBFDVzP+US0IJ8ykX8QC
         j6Jw==
X-Gm-Message-State: AOAM5337xM5pKEdKUmweD/KljyEf5PRBpG4Oo2AiGW5FA4oxXBvTqp1Z
        JS0IM0RjF2NKacYuMbHUNJlZ1Q==
X-Google-Smtp-Source: ABdhPJwIlEU51j1XgwiAhmy2QSaGgS/XhMa9JJ03cZQJngGCYpl4RB1baYPrEthuG1pe4SgqQz8fuQ==
X-Received: by 2002:a17:90a:e60c:: with SMTP id j12mr9386207pjy.13.1617897924535;
        Thu, 08 Apr 2021 09:05:24 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id 6sm25374609pfv.179.2021.04.08.09.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 09:05:23 -0700 (PDT)
Date:   Thu, 8 Apr 2021 16:05:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     lihaiwei.kernel@gmail.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org,
        Haiwei Li <lihaiwei@tencent.com>
Subject: Re: [PATCH] KVM: vmx: add mismatched size in vmcs_check32
Message-ID: <YG8pwERmjxYQoquP@google.com>
References: <20210408075436.13829-1-lihaiwei.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408075436.13829-1-lihaiwei.kernel@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 08, 2021, lihaiwei.kernel@gmail.com wrote:
> From: Haiwei Li <lihaiwei@tencent.com>
> 
> vmcs_check32 misses the check for 64-bit and 64-bit high.

Can you clarify in the changelog that, while it is architecturally legal to
access 64-bit and 64-bit high fields with a 32-bit read/write in 32-bit mode,
KVM should never do partial accesses to VMCS fields.  And/or note that the
32-bit accesses are done in vmcs_{read,write}64() when necessary?  Hmm, maybe:

  Add compile-time assertions in vmcs_check32() to disallow accesses to
  64-bit and 64-bit high fields via vmcs_{read,write}32().  Upper level
  KVM code should never do partial accesses to VMCS fields.  KVM handles
  the split accesses automatically in vmcs_{read,write}64() when running
  as a 32-bit kernel.

With something along those lines:

Reviewed-and-tested-by: Sean Christopherson <seanjc@google.com> 

> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> ---
>  arch/x86/kvm/vmx/vmx_ops.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
> index 692b0c3..164b64f 100644
> --- a/arch/x86/kvm/vmx/vmx_ops.h
> +++ b/arch/x86/kvm/vmx/vmx_ops.h
> @@ -37,6 +37,10 @@ static __always_inline void vmcs_check32(unsigned long field)
>  {
>  	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && ((field) & 0x6000) == 0,
>  			 "32-bit accessor invalid for 16-bit field");
> +	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && ((field) & 0x6001) == 0x2000,
> +			 "32-bit accessor invalid for 64-bit field");
> +	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && ((field) & 0x6001) == 0x2001,
> +			 "32-bit accessor invalid for 64-bit high field");
>  	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && ((field) & 0x6000) == 0x6000,
>  			 "32-bit accessor invalid for natural width field");
>  }
> -- 
> 1.8.3.1
> 
