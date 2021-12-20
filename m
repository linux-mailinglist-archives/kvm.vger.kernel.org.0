Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E368247A697
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 10:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhLTJHA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 04:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhLTJG7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 04:06:59 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199E4C061574;
        Mon, 20 Dec 2021 01:06:59 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id x15so35527244edv.1;
        Mon, 20 Dec 2021 01:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7rGLuctH17X86MIT1q+VjDiELEpLEz54V+ybICfliCY=;
        b=F1QKF6JdEydW7dva1Vc3CloUwYkLRRuBBi1rFQoQkey9y87fWPDjY7jyKdd8q7N1yy
         Z1rOXCgDYVFDwRpGHhfvbQQeij0lzofm5YBTOMAYqPl3/1kz0/+s7oLg15nh7Xguo6SO
         pqvM9a3VZNXjGoOTOTI3LjjRF/5zq2mmgCioYBNOPkHGrB+gCKk3Nq3t1sT3TqNFSfPc
         BTclqTcKrqeQIsn7WjxZ2t4l/rJF3o0wxtdW8Ixm8dLvujyr0xDh8Ht3+FUqEXqSscYp
         4Cdaks5LweoPuZFUxHrKgrLou9zgLGiRV25ey5RbBv/UcGMnqS8/8kgPsjrNmiyyvDWF
         YlHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7rGLuctH17X86MIT1q+VjDiELEpLEz54V+ybICfliCY=;
        b=LK8lNXfU+EFZWURHiuMadvF7HXjbXjoSGqNyBkSdYfokl7bwe7FEACkB022zoCS3Qi
         fCQs49tQuTmByBATHN8Bhaq16RpTlhG008tgrca2LpygFSQ5uh3v5EXGA936zl/EHGDj
         IGFUovZjmuIAJJn4HAxe5DxXEntazFGk3SBQrvt6aYI49rVpg3KD47T0WIagoF2foHN+
         hweywDPBjdVWL2XUZFi+yWBhL90LhFgPFB84cUp/kce8wKS3ykmxMf941dd8QKAuOlTt
         uMgpFO3wl225Aq82a06Jkvuo+P/Sb4RCO4xEBVnKXLnb1jeCuRQXzgLtztPLRl7oMkYU
         PosQ==
X-Gm-Message-State: AOAM533RYCVXfTGBs+CpblgmB0trXcW3gdaeZoPeErgRunlQ1fSEINgl
        mtfNKG8rueA+5ACAGXqivbw=
X-Google-Smtp-Source: ABdhPJxc4+56LGUN6NrNDOuFE0g4DQGtvm2CHJtn9p7lYvB0aYj1Nve5TSxIftjZ3OV/mVNPsJk7Ig==
X-Received: by 2002:a05:6402:2747:: with SMTP id z7mr3774719edd.321.1639991217578;
        Mon, 20 Dec 2021 01:06:57 -0800 (PST)
Received: from [192.168.10.118] ([93.56.160.36])
        by smtp.googlemail.com with ESMTPSA id n12sm4009071edb.86.2021.12.20.01.06.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 01:06:57 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <3ffa47eb-3555-5925-1c55-f89a07ceb4bc@redhat.com>
Date:   Mon, 20 Dec 2021 10:04:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 18/23] kvm: x86: Get/set expanded xstate buffer
Content-Language: en-US
To:     Jing Liu <jing2.liu@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, guang.zeng@intel.com,
        wei.w.wang@intel.com, yang.zhong@intel.com
References: <20211217153003.1719189-1-jing2.liu@intel.com>
 <20211217153003.1719189-19-jing2.liu@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211217153003.1719189-19-jing2.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/21 16:29, Jing Liu wrote:
> +/* for KVM_CAP_XSAVE and KVM_CAP_XSAVE2 */
>   struct kvm_xsave {
> +	/*
> +	 * KVM_GET_XSAVE only uses the first 4096 bytes.
> +	 *
> +	 * KVM_GET_XSAVE2 must have the size match what is returned by
> +	 * KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2).
> +	 *
> +	 * KVM_SET_XSAVE uses the extra field if guest_fpu::fpstate::size
> +	 * exceeds 4096 bytes.

KVM_GET_XSAVE2 and KVM_SET_XSAVE respectively write and read as many 
bytes as are returned by KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2), when 
invoked on the vm file descriptor.  Currently, 
KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2) will only return a value that is 
greater than 4096 bytes if any dynamic features have been enabled with 
``arch_prctl()``; this however may change in the future.

The offsets of the state save areas in struct kvm_xsave follow the 
contents of CPUID leaf 0xD on the host.

Paolo
