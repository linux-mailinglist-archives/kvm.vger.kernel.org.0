Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17FF5368D92
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 09:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240393AbhDWHFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 03:05:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49249 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236430AbhDWHFd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 03:05:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619161496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=26egp8w78ciutRscKuA1JMKEhbElgHLLx+FcXJkKOgQ=;
        b=fSjy0ZNtUhiRq1v2qxaPPw5xoh28sSKYE3CcoPuIn7jZa+KmDvRssJUuIJ7i3ETgKDGSMV
        IH8UrUdvZ98C30S7Wh1DqMRGTXUoFcsrJdWXxE5Irx0A3ryU1sj59BPSiGe7ymzvFb93Sw
        W1iczG5R+zM1cBN3ndUpev1jJGUQJ2w=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-7wYYBFuJP3yn8XI-p5dnJQ-1; Fri, 23 Apr 2021 03:04:55 -0400
X-MC-Unique: 7wYYBFuJP3yn8XI-p5dnJQ-1
Received: by mail-ej1-f70.google.com with SMTP id bx15-20020a170906a1cfb029037415131f28so8102229ejb.18
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 00:04:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=26egp8w78ciutRscKuA1JMKEhbElgHLLx+FcXJkKOgQ=;
        b=YBvECi64leIz6q1vgDOWsEJ76IRXFhGCftAtBLVCKpDLzzUBTprOHWBM55hkJqxNAu
         2FEgZ8vtrh6Dmw8bTSYWZxZVD7vxMDm7SedL9Wu1ksrUY/1WuYK6dX05GQuKejSChPOb
         K8Zxs/T9Srfrb/3JobsPHURE6FW54mpjMhx0s2cvG4FU4DLqFUtu46qtXtSS4sFCBEGN
         JzW0KMKDA/ljJvVEz53g8oQf5orxWYnlv23IiVmgSKsjQheUmpl5BtEGosTZMNgEFOWL
         laUk4KtEzB/vwVHHThHKmX0gq+xqecECtDyrEZwlTFNPWnqfpuUfnm30rCyWIS8lHI/a
         9PXQ==
X-Gm-Message-State: AOAM530WKwSRyn5T6K9BLRVFcHYRbr6YU/UK4f2LWSvEExIDFTzcT57n
        TygnTSO1BKL5OvivyQpOm0VJCQBrOHj9JCDf3W9nG2FhH6nHa9JKPEgSmh3SEQMB51GE+eMxJLj
        U4JH3ucDRm601
X-Received: by 2002:a17:906:3a45:: with SMTP id a5mr2691601ejf.288.1619161493990;
        Fri, 23 Apr 2021 00:04:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyUF0hDNObT2Jc9NMcZiLwERleMHFOFp4SJgw0WEy/cG+Cr+oKbVFdv5KVr3qdOULZjBs66nQ==
X-Received: by 2002:a17:906:3a45:: with SMTP id a5mr2691584ejf.288.1619161493836;
        Fri, 23 Apr 2021 00:04:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id cz2sm3889235edb.13.2021.04.23.00.04.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 00:04:53 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: use EPT_VIOLATION_GVA_TRANSLATED instead of
 0x100
To:     Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@gmail.com, Yao Yuan <yuan.yao@intel.com>
References: <724e8271ea301aece3eb2afe286a9e2e92a70b18.1619136576.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <040c4154-99c6-a9e3-3500-9f66a63286b6@redhat.com>
Date:   Fri, 23 Apr 2021 09:04:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <724e8271ea301aece3eb2afe286a9e2e92a70b18.1619136576.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/21 02:22, Isaku Yamahata wrote:
> Use symbolic value, EPT_VIOLATION_GVA_TRANSLATED, instead of 0x100
> in handle_ept_violation().
> 
> Signed-off-by: Yao Yuan <yuan.yao@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6501d66167b8..2791c2b4c917 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5398,7 +5398,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
>   			EPT_VIOLATION_EXECUTABLE))
>   		      ? PFERR_PRESENT_MASK : 0;
>   
> -	error_code |= (exit_qualification & 0x100) != 0 ?
> +	error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) != 0 ?
>   	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
>   
>   	vcpu->arch.exit_qualification = exit_qualification;
> 

Queued, thanks.

Paolo

