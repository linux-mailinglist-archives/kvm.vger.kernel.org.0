Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653C2371822
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 17:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhECPlH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 11:41:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31854 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230122AbhECPlG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 11:41:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620056413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ecMiMtDwOcYd8qIxuahdOpynUJcA9qmTkIzOJwjDg3g=;
        b=hmcpaKE0pJrRP8ruVBaq0V57MfEuU210LhgP9LyjLKqeL5j1ikhr+UoL78Dau7pl1CN9WN
        PpPhH98PUAL8Tvf2NactSjzEZApV0KUh7zwUCzscbS9dJVJcLpv6rEBG/WMqbg5n9Fijfq
        s2tiwgijI3sZQ4zAJ+pj5l6fB+sbhkY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-aqBJJQslNaGGCuyaCLPLEA-1; Mon, 03 May 2021 11:40:10 -0400
X-MC-Unique: aqBJJQslNaGGCuyaCLPLEA-1
Received: by mail-ej1-f70.google.com with SMTP id z15-20020a170906074fb029038ca4d43d48so2224683ejb.17
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 08:40:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ecMiMtDwOcYd8qIxuahdOpynUJcA9qmTkIzOJwjDg3g=;
        b=sBEPZ5ovELgri0l1igbf2BwRg9TDjN29qlMqoTIh220Oih1IgdEC6qc8Qkmo6M3XOz
         P4KTbJgt3D+xrQvM4o3goicmL1uP+ZPHszAvp80wow70owvMf+fnnccyT6M/I+bY84B9
         N6LQJC8feRJ5Uj5wlKglQ5w7ev7rqARJumSr5T095odEo8k6v9Tzf8XA1LNaRDQ3ua+1
         X3fXQ7Kct4GO2qOAUU3/Nu9OkmMRMgWnyuodsgxX5DfPdC5H8iDDe5Adm89tmfvq1fnm
         7w83Vd35qctCk631LhATcxPB1a/W3Vnn4/T74eQGYagcpCLbFdQ7KCvEdIKYyG7QFBJG
         cA4Q==
X-Gm-Message-State: AOAM533c2BQ1cbf8gy+hIzGyofq5WpFYAYRWIshIndx7V35/e3nMxmHt
        TOex98vjS96VDLzpV1MgkIF+ECu9ERmyMhffuADXpyUk5eWTZL8ytlvuHEkieljM+NynLzEwWjW
        87xh84onQxDlM
X-Received: by 2002:a05:6402:3495:: with SMTP id v21mr20519078edc.117.1620056409232;
        Mon, 03 May 2021 08:40:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyCSWEMOnAvKantgHsr2jFZf8+i4gKIV4OBcQbyNrP5M1pmL92Cx59EovfRT5ncXaNeES8sUw==
X-Received: by 2002:a05:6402:3495:: with SMTP id v21mr20519062edc.117.1620056409030;
        Mon, 03 May 2021 08:40:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y16sm37248ejp.36.2021.05.03.08.40.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 08:40:08 -0700 (PDT)
Subject: Re: [PATCH] doc/kvm: Fix wrong entry for KVM_CAP_X86_MSR_FILTER
To:     Siddharth Chandrasekaran <sidcha@amazon.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Graf <graf@amazon.com>
Cc:     Alexander Graf <graf@amazon.de>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210503120059.9283-1-sidcha@amazon.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9be335ec-dcd4-97de-5f50-92c0dfc37df7@redhat.com>
Date:   Mon, 3 May 2021 17:40:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210503120059.9283-1-sidcha@amazon.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/05/21 14:00, Siddharth Chandrasekaran wrote:
> The capability that exposes new ioctl KVM_X86_SET_MSR_FILTER to
> userspace is specified incorrectly as the ioctl itself (instead of
> KVM_CAP_X86_MSR_FILTER). This patch fixes it.
> 
> Fixes: 1a155254ff93 ("KVM: x86: Introduce MSR filtering")
> Cc: Alexander Graf <graf@amazon.de>
> Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
> ---
>   Documentation/virt/kvm/api.rst | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 307f2fcf1b02..e778f4aa08f4 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4713,7 +4713,7 @@ KVM_PV_VM_VERIFY
>   4.126 KVM_X86_SET_MSR_FILTER
>   ----------------------------
>   
> -:Capability: KVM_X86_SET_MSR_FILTER
> +:Capability: KVM_CAP_X86_MSR_FILTER
>   :Architectures: x86
>   :Type: vm ioctl
>   :Parameters: struct kvm_msr_filter
> @@ -6586,7 +6586,7 @@ accesses that would usually trigger a #GP by KVM into the guest will
>   instead get bounced to user space through the KVM_EXIT_X86_RDMSR and
>   KVM_EXIT_X86_WRMSR exit notifications.
>   
> -8.27 KVM_X86_SET_MSR_FILTER
> +8.27 KVM_CAP_X86_MSR_FILTER
>   ---------------------------
>   
>   :Architectures: x86
> 

Queued, thanks.

Paolo

