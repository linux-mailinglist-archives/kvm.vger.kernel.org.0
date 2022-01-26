Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A29F49CF1D
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 17:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235524AbiAZQFg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 11:05:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60203 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231276AbiAZQFf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 11:05:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643213134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tXp1kCQwqJ4o9Do0kiE0pBfB82AEFKSqEr3EbL8QkxQ=;
        b=JESWYZCuYXLKmBKkW6hCOEsCV02qlAsi2TU2YLyTS+RnEiT7D99mw2VlGYL9CaXX6gbjLz
        efTH+pCthusP+zZtu2MZeuFWqGFGPurMXiiDdw2aPjRTyB/DNTiUS2vZYRftyr+1vzP13X
        aGD8bMNH6HXPYDfY9tBsKIz84H5q1HE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-IE5unW5YNvGYOh2kExbgSA-1; Wed, 26 Jan 2022 11:05:33 -0500
X-MC-Unique: IE5unW5YNvGYOh2kExbgSA-1
Received: by mail-ed1-f70.google.com with SMTP id k10-20020a50cb8a000000b00403c8326f2aso16951105edi.6
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 08:05:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tXp1kCQwqJ4o9Do0kiE0pBfB82AEFKSqEr3EbL8QkxQ=;
        b=qmLDIyNc7Canch2/vHpCrbsol2ulzLNJ42TMMiRSgkFz0vllLUB/eZvwNwQGLGgJd6
         wFYv8TJubDooibfF/dzwpfgqUWotQOCX3dzXseZrRwI/MUyoO62HB/cPwdZNs7Xdz8V5
         vtxF1eCOXyGB4Tcv+L5b1qlaYVIKNkUG8dBHw/PKbohMbjGCkNekUIOFCond401gqKu1
         8M4MjymYjI68DnXqBq9ntokUchAWYoGI2/KYjFs9h8N+U30OJiR9LPT7kIE+mjpEZ1KJ
         CG3OlNgEt1aHd5fkg3wSaFTifeu9YZ0WHdGSwa0tgFvBF0l4dUrQ64XdV1SePBKqg5gI
         vJxA==
X-Gm-Message-State: AOAM531QuPOScW4ZUn5ONOC8aW4cpg/AAu7lumCgHdvrvw5yLJblkFVc
        EySQWHIf7hkKamOVD51STrHY6yGVnbLTYq2GQx9d+hWfVi43NWdag/nI6Pu2ud4paDk6oiCIu56
        OnohDhwaCxwUx
X-Received: by 2002:a05:6402:40d5:: with SMTP id z21mr22472809edb.239.1643213132078;
        Wed, 26 Jan 2022 08:05:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwbC0lCdymtOtM4+kKjEtqy3QzwTeDO/fGzCIbzeQr+TYlQ/duyFjLW5r0RETLMzr+MOO59rw==
X-Received: by 2002:a05:6402:40d5:: with SMTP id z21mr22472769edb.239.1643213131825;
        Wed, 26 Jan 2022 08:05:31 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id a23sm9936111eda.94.2022.01.26.08.05.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 08:05:31 -0800 (PST)
Message-ID: <053bb241-ea71-abf8-262b-7b452dc49d37@redhat.com>
Date:   Wed, 26 Jan 2022 17:05:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: nVMX: WARN on any attempt to allocate shadow VMCS
 for vmcs02
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220125220527.2093146-1-seanjc@google.com>
 <87r18uh4of.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87r18uh4of.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/26/22 16:56, Vitaly Kuznetsov wrote:
>> -	WARN_ON(loaded_vmcs == &vmx->vmcs01 && loaded_vmcs->shadow_vmcs);
>> +	if (WARN_ON(loaded_vmcs != &vmx->vmcs01 || loaded_vmcs->shadow_vmcs))
>> +		return loaded_vmcs->shadow_vmcs;
> Stupid question: why do we want to care about 'loaded_vmcs' at all,
> i.e. why can't we hardcode 'vmx->vmcs01' in alloc_shadow_vmcs()? The
> only caller is enter_vmx_operation() and AFAIU 'loaded_vmcs' will always
> be pointing to 'vmx->vmcs01' (as enter_vmx_operation() allocates
> &vmx->nested.vmcs02 so 'loaded_vmcs' can't point there!).
> 

Well, that's why the WARN never happens.  The idea is that if shadow 
VMCS _virtualization_ (not emulation, i.e. running L2 VMREAD/VMWRITE 
without even a vmexit to L0) was supported, then you would need a 
non-NULL shadow_vmcs in vmx->vmcs02.

Regarding the patch, the old WARN was messy but it was also trying to 
avoid a NULL pointer dereference in the caller.

What about:

	if (WARN_ON(loaded_vmcs->shadow_vmcs))
		return loaded_vmcs->shadow_vmcs;

	/* Go ahead anyway.  */
	WARN_ON(loaded_vmcs != &vmx->vmcs01);

?

Paolo

