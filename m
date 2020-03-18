Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D610A189C82
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 14:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgCRNFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 09:05:44 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:46537 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726619AbgCRNFo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 09:05:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584536743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZkaCpn6X3ojkC9QhiPVu3kih5zKrO75Q+2APioIdYPI=;
        b=Gtq3rU1r6zhq4z6BMSQP/fbOInlT2jPVXkxmk8CYyyzjj/YscG8TMHWWPPsscU+WHyBdJo
        GPdpCnBrgJGT7SitfEfD07XhobB13gdmzzis+EpK3Nz1WBKWKuUObcuX2jIpdRsaJxJwC5
        em3DpA+7Kln+oa/oCuz1xQ9+HA1RXfs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-3ivSIVqJNPmJMwY4klGNww-1; Wed, 18 Mar 2020 09:05:40 -0400
X-MC-Unique: 3ivSIVqJNPmJMwY4klGNww-1
Received: by mail-wm1-f70.google.com with SMTP id 20so1031156wmk.1
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 06:05:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZkaCpn6X3ojkC9QhiPVu3kih5zKrO75Q+2APioIdYPI=;
        b=U7WJqhhIia2C0N6hMdIdYb0BUA718XwmJy+SquBbkkNlDr5Vwz34XCBhLBb6gsGpQu
         fiwj9n/d9nAzpBYyLnye+381XfQF/3p0CZhmqyM+oeamz1lkXm8UNLQO6RpeECQZ+KJx
         iMXgFa/IXaIIowUlQEhG4UsqbC1GMNqvGJcpjVVxGN1q5mhtvoL0NcOWLPewmFouCb45
         REuutx7SaXrZ6YLjLXdLRUYsJZhqNoBrMLpi0OSiiZdHEF8LKo1PJV1SrQJ/8ff7P5Ad
         G1NuXlMYaADmKcjQ8Jn0HHjjuE3SN2psY/h1Q+xHbQQoq/hoeytHm9Vu1+1Cw++M+rN7
         TVQA==
X-Gm-Message-State: ANhLgQ3Kj/XReEOyLNtDebTdcggTTcljva6OuXuc7WVQ6ERsdZgQOuJk
        JVdOJP4r3/Jsn8BSUVR6FkbcG6DTDAYxxZeZY0u96nOMDIFMWduG9gRmUSYbeLUd5tw16Y2RTu/
        97Rfkd3/VzEn7
X-Received: by 2002:adf:b245:: with SMTP id y5mr5331655wra.136.1584536738538;
        Wed, 18 Mar 2020 06:05:38 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtPhqqH7GoQGtGR1qDUke2gX5UyDmHFJnjxEcKacgbD29xkclCmkhgNsGDRTocZ2mNGR/tqNA==
X-Received: by 2002:adf:b245:: with SMTP id y5mr5331639wra.136.1584536738275;
        Wed, 18 Mar 2020 06:05:38 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.43])
        by smtp.gmail.com with ESMTPSA id b4sm3793259wmj.12.2020.03.18.06.05.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 06:05:37 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: x86: Remove unnecessary brackets in
 kvm_arch_dev_ioctl()
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200229025212.156388-1-xiaoyao.li@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <faafb5ba-56cf-ec32-e5b5-244d7939c19a@redhat.com>
Date:   Wed, 18 Mar 2020 14:05:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200229025212.156388-1-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/02/20 03:52, Xiaoyao Li wrote:
> In kvm_arch_dev_ioctl(), the brackets of case KVM_X86_GET_MCE_CAP_SUPPORTED
> accidently encapsulates case KVM_GET_MSR_FEATURE_INDEX_LIST and case
> KVM_GET_MSRS. It doesn't affect functionality but it's misleading.
> 
> Remove unnecessary brackets and opportunistically add a "break" in the
> default path.
> 
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/kvm/x86.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5de200663f51..e49f3e735f77 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3464,7 +3464,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
>  		r = 0;
>  		break;
>  	}
> -	case KVM_X86_GET_MCE_CAP_SUPPORTED: {
> +	case KVM_X86_GET_MCE_CAP_SUPPORTED:
>  		r = -EFAULT;
>  		if (copy_to_user(argp, &kvm_mce_cap_supported,
>  				 sizeof(kvm_mce_cap_supported)))
> @@ -3496,9 +3496,9 @@ long kvm_arch_dev_ioctl(struct file *filp,
>  	case KVM_GET_MSRS:
>  		r = msr_io(NULL, argp, do_get_msr_feature, 1);
>  		break;
> -	}
>  	default:
>  		r = -EINVAL;
> +		break;
>  	}
>  out:
>  	return r;
> 

Queued as "KVM: x86: Code style cleanup in kvm_arch_dev_ioctl()", thanks.

Paolo

