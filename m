Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55878325E98
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 09:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbhBZIEy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 03:04:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20923 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229954AbhBZIEx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Feb 2021 03:04:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614326606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CPnOIjDZYXeNRWYCqamKS1PZpsu8x/uzl+V1b5s0iw8=;
        b=BP63UJqjgWegagGVJfq31u9OXBUlrsYoqNKh9OMOoIvU1j65hf6HFddXd8liL3DXfD1krf
        aei4JxOf1kFjb37oqf8fOZ2BIkKn/s4qkki90kr03iliEiEQdznZSxDJ8d6eSRZNQYtIpt
        G244bXMbC8xPUxP/rM6gTdhqb+IpW1k=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-jq0Yhso6NcOjCaB4LYJ5KA-1; Fri, 26 Feb 2021 03:03:24 -0500
X-MC-Unique: jq0Yhso6NcOjCaB4LYJ5KA-1
Received: by mail-ej1-f72.google.com with SMTP id v10so3866362ejh.15
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 00:03:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CPnOIjDZYXeNRWYCqamKS1PZpsu8x/uzl+V1b5s0iw8=;
        b=CTn1hZrrdX4SgCGUJasmnJHNOJO0LT9T0YOdSNEyeBVXsm545Ka8nay8nQlziPXrLy
         ahsZUfosBJ3/nBk6DgtDJVmrGpqmi2/WKuycu6ztWGPEtMjY+qIfAVCzc/GM6AgDXesM
         flv5fFmYEamcOKtCJpDDTBG3qtOZVcXy09CNVMdMHHZ6vT4pEQgqHZ2DGEmOAcpqP+kO
         tMf+sdXSed6RE2e4He8Q61Qdum5LK4zLiNZtaZJC8wG1eEIXfL+zOYdZ+94gY4JA4anj
         4XZncmCm70vxjsAY5UAu4PE8z16ALq1FvXVfGJ9bVnX4xPoPYemK9YlBuOiT0jRvMzD/
         iidA==
X-Gm-Message-State: AOAM533ds3k0S8KGfRwEPrfKqNUZzGO2De9I+rjBhyiQrv5gcKp8Lvup
        cBCLFAnjC9YgrnEnoIheIxcEVBIgdcp6HdvBIuQJXSntohcUXwaT+qTgrsP4QLQhVty/iMIJG64
        nuVKkh/FGkVUh
X-Received: by 2002:a17:906:bc85:: with SMTP id lv5mr1985198ejb.412.1614326603148;
        Fri, 26 Feb 2021 00:03:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzx4ypKh5EdCVtEubF3HXKELpdlAIDE42Z3LFmZxc9/XlfnJVuK8HdKXKabBE/JYJ4o3+hSJw==
X-Received: by 2002:a17:906:bc85:: with SMTP id lv5mr1985186ejb.412.1614326603008;
        Fri, 26 Feb 2021 00:03:23 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i7sm5113867edq.87.2021.02.26.00.03.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 00:03:22 -0800 (PST)
Subject: Re: [PATCH] KVM: Documentation: rectify rst markup in kvm_run->flags
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210226075541.27179-1-chenyi.qiang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3461a412-f214-fb75-3b82-97466aca03f4@redhat.com>
Date:   Fri, 26 Feb 2021 09:03:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210226075541.27179-1-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/02/21 08:55, Chenyi Qiang wrote:
> Commit c32b1b896d2a ("KVM: X86: Add the Document for
> KVM_CAP_X86_BUS_LOCK_EXIT") added a new flag in kvm_run->flags
> documentation, and caused warning in make htmldocs:
> 
>    Documentation/virt/kvm/api.rst:5004: WARNING: Unexpected indentation
>    Documentation/virt/kvm/api.rst:5004: WARNING: Inline emphasis start-string without end-string
> 
> Fix this rst markup issue.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>   Documentation/virt/kvm/api.rst | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index aed52b0fc16e..0717bf523034 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5000,7 +5000,8 @@ local APIC is not used.
>   	__u16 flags;
>   
>   More architecture-specific flags detailing state of the VCPU that may
> -affect the device's behavior. Current defined flags:
> +affect the device's behavior. Current defined flags::
> +
>     /* x86, set if the VCPU is in system management mode */
>     #define KVM_RUN_X86_SMM     (1 << 0)
>     /* x86, set if bus lock detected in VM */
> 

Queued, thanks.

Paolo

