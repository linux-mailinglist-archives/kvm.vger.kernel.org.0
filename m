Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB70347A693
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 10:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhLTJGU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 04:06:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhLTJGT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 04:06:19 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18281C061574;
        Mon, 20 Dec 2021 01:06:19 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id b13so6860956edd.8;
        Mon, 20 Dec 2021 01:06:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HTTnCfgCcrt6LxVaeYrzEl8F3KYAdIIEEay+IZlQGS8=;
        b=Rh2dXZzc7lswejaViMw3Qfmz+qc+Xw7rVkh9PzXXWbYyMu26yjDW1iMuwUkHYD2Bx3
         osKBk94O53Z8zL3g7x/uuIixSPc7jg1p+sdptBglPqpC4ZuLftDhhs9zgMfXuiWAc90v
         Ocpn/XxavqjBq5DLwH0yWFYAmTJPVKgPumc5dF5DY+t5AYcz+q8QoAySBTPr/GKwdssG
         Uzx/vPPRxwx4SkSmFio82CkhcqlkU/gI3w3mNTUq3Hjg0fxVtegoWeZ1Td0oYLbckZad
         ZKvuExDurVDawezpT5Kykww6N2KJrslNs5lb8EYknEEM2GEoaR20FycECPbRUx71Fe66
         FwRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HTTnCfgCcrt6LxVaeYrzEl8F3KYAdIIEEay+IZlQGS8=;
        b=keaA+6KiRXUAQ9mqaH3qzFQu3+RxWFaqIt9XQMHgaK68ZT4OepjiSC/cwbOEMvYdow
         jEfJXZCwzbCmOemU/4lIQQ1GdiYEl8x7E6nGCN8Fq6G8SCo/+RC0KP/qi44eR1NpRKBc
         fcJU4kYv7nRGxq3s7r+vzeNTgg63PHt0DZdmr1BiurvCnTYuJRfopdkEpyIXVMqNB87e
         FGQFJ0J8c87+Awwg86rSWWt+4NrnyMS2jweKkk6OEHrwhaJX/gBzwvLWzZ/ZdB9pt0i3
         w3K3FRRH40rDxmIVzEcsOek2gy4y/k10SwJc5GUF+xUzublSwFxCcqirAbOjD/R5f1l7
         KC5A==
X-Gm-Message-State: AOAM532EGNSGqlEdjlTlYEBfYj7SdgOcr/4Mwbz9op2hXkmP48DxOHlp
        b+qyboUyUBE8o6PTO8zJIyE=
X-Google-Smtp-Source: ABdhPJy5YdQtlhpTHzHYvHryQtXyfXD8Emy10J9axnkmFsjaaSMkLClW1a2sSN/m8fsqDgIEtTkTZQ==
X-Received: by 2002:aa7:c990:: with SMTP id c16mr14566768edt.330.1639991177640;
        Mon, 20 Dec 2021 01:06:17 -0800 (PST)
Received: from [192.168.10.118] ([93.56.160.36])
        by smtp.googlemail.com with ESMTPSA id sc7sm949001ejc.87.2021.12.20.01.06.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 01:06:17 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <39ca9998-e936-8a5b-4cd8-596d907f4d8f@redhat.com>
Date:   Mon, 20 Dec 2021 10:04:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 20/23] docs: kvm: Add KVM_GET_XSAVE2
Content-Language: en-US
To:     Jing Liu <jing2.liu@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, guang.zeng@intel.com,
        wei.w.wang@intel.com, yang.zhong@intel.com
References: <20211217153003.1719189-1-jing2.liu@intel.com>
 <20211217153003.1719189-21-jing2.liu@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211217153003.1719189-21-jing2.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/21 16:30, Jing Liu wrote:
> From: Wei Wang <wei.w.wang@intel.com>
> 
> Update the api doc with the new KVM_GET_XSAVE2 ioctl, which is used
> when KVM_CAP_XSAVE2 is negotiated with the userspace. KVM_SET_XSAVE
> ioctl is re-used when KVM_CAP_XSAVE2 is used. The kvm_xsave struct
> is updated to support data size larger that the legacy hardcoded 4KB.

This commit message is incorrect, since KVM_ENABLE_CAP(KVM_CAP_XSAVE2) 
was removed from the API.  You can squash this patch in patch 18, and 
also add to the documentation the same notes that I made in the reply.

Thanks,

Paolo

> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> Signed-off-by: Jing Liu <jing2.liu@intel.com>
> ---
>   Documentation/virt/kvm/api.rst | 29 ++++++++++++++++++++++++++++-
>   1 file changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index eb5671ca2dba..0f4ed2d4aea6 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1566,15 +1566,18 @@ otherwise it will return EBUSY error.
>   
>     struct kvm_xsave {
>   	__u32 region[1024];
> +	__u32 extra[0];
>     };
>   
>   This ioctl would copy current vcpu's xsave struct to the userspace.
> +Application should use KVM_GET_XSAVE2 if xsave states are larger than
> +4KB.
>   
>   
>   4.43 KVM_SET_XSAVE
>   ------------------
>   
> -:Capability: KVM_CAP_XSAVE
> +:Capability: KVM_CAP_XSAVE and KVM_CAP_XSAVE2
>   :Architectures: x86
>   :Type: vcpu ioctl
>   :Parameters: struct kvm_xsave (in)
> @@ -1585,9 +1588,12 @@ This ioctl would copy current vcpu's xsave struct to the userspace.
>   
>     struct kvm_xsave {
>   	__u32 region[1024];
> +	__u32 extra[0];
>     };
>   
>   This ioctl would copy userspace's xsave struct to the kernel.
> +Application can use this ioctl for xstate buffer in any size
> +returned from KVM_CHECK_EXTENSION(KVM_CAP_XSAV2).

Typo, s/XSAV2/XSAVE2/

>   
>   4.44 KVM_GET_XCRS
> @@ -5507,6 +5513,27 @@ the trailing ``'\0'``, is indicated by ``name_size`` in the header.
>   The Stats Data block contains an array of 64-bit values in the same order
>   as the descriptors in Descriptors block.
>   
> +4.42 KVM_GET_XSAVE2
> +------------------
> +
> +:Capability: KVM_CAP_XSAVE2
> +:Architectures: x86
> +:Type: vcpu ioctl
> +:Parameters: struct kvm_xsave (out)
> +:Returns: 0 on success, -1 on error
> +
> +
> +::
> +
> +  struct kvm_xsave {
> +	__u32 region[1024];
> +	__u32 extra[0];
> +  };
> +
> +This ioctl would copy current vcpu's xsave struct to the userspace.
> +Application can use this ioctl for xstate buffer in any size
> +returned from KVM_CHECK_EXTENSION(KVM_CAP_XSAV2).

Typo, s/XSAV2/XSAVE2/

> +
>   5. The kvm_run structure
>   ========================
>   
> 

