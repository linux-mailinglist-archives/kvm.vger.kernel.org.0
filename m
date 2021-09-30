Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2461E41DB4C
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 15:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351733AbhI3Nnp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 09:43:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:20545 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351466AbhI3Nno (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Sep 2021 09:43:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633009320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PDMqNfSKGf/ERQRj6wC7MdYJINADeGqp707yfUyPD08=;
        b=IbA0ZxEs0FVIBTPsaRzG8LRWSu9Q60Gp4OC1iaFY+zUzQZH3o0rgudQpasrKZYHhlYrS8B
        loSdMwFtgaGs2VcTJD5psAmvD1pxYxZ6Pht+Ey0f2g5JLIcsGTJzvPCP9049yVGvP2SMj7
        Q+1y1ibmDE1MpKZPIv8X2qzDuNiKLKw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-NdFrSMP-P0CahewvNmwdvA-1; Thu, 30 Sep 2021 09:41:59 -0400
X-MC-Unique: NdFrSMP-P0CahewvNmwdvA-1
Received: by mail-wm1-f69.google.com with SMTP id p63-20020a1c2942000000b0030ccf0767baso4339227wmp.6
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 06:41:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PDMqNfSKGf/ERQRj6wC7MdYJINADeGqp707yfUyPD08=;
        b=4t7fNJV0ZvvsCkOArkA3YQqF8fRUREwBD+qHLwE4OGwxbhZ9SRiaCat5UePam8C2+M
         sxMk9pJirL1wgztDrzXkOR+S67REHp8Je9H7JmCf0g99yg1S15VNWF28KTF096jXsZ5o
         dMfCZIGLp6p+B7DncrpTicoPT893Eo9dLGEh9kRg/fgan5g6AFEhFB+Z/FCYbQuoROI5
         WV6u40OYXtLx7JbLpoit9iWs0uvgnosfZ4doZ5b7bWTAleDp4CaBw+w9TqdHj1VINhWA
         ku2CiLYDLRG9bYZaOnA3mLScEBJU+wXz7vbcY8NXiWFL6V+Qkb3+V+vjUtL++pWNSANX
         c7Mw==
X-Gm-Message-State: AOAM531WrFqBbO8S3axCGxIDp89k9ZyGzOb5buyNPSta9zg1pDGC/wOF
        lnpLo6FryCTzxF0lNm4YRWyvlvzY0vTXeHUkL+YHCpEq4I3u1F6HasW/1dX0EWJ0TbPyLwJpdaf
        0KD2YxKUjdOo+
X-Received: by 2002:a1c:ed1a:: with SMTP id l26mr7780430wmh.119.1633009318222;
        Thu, 30 Sep 2021 06:41:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4l2Yfv0mO85HCocdYZNYG7Bb9tAUaBu0z8GxFMLgJdjcgyHpMcnggFkyTGeyjID5O7FoAyA==
X-Received: by 2002:a1c:ed1a:: with SMTP id l26mr7780413wmh.119.1633009318027;
        Thu, 30 Sep 2021 06:41:58 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y7sm4655050wmj.37.2021.09.30.06.41.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 06:41:57 -0700 (PDT)
Message-ID: <2a02b09c-785c-605d-5ab4-e2ce0f5b9e80@redhat.com>
Date:   Thu, 30 Sep 2021 15:41:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: x86: Expose Predictive Store Forwarding Disable
Content-Language: en-US
To:     Babu Moger <babu.moger@amd.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org
Cc:     hpa@zytor.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tony.luck@intel.com, peterz@infradead.org,
        kyung.min.park@intel.com, wei.huang2@amd.com, jgross@suse.com,
        andrew.cooper3@citrix.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <163244601049.30292.5855870305350227855.stgit@bmoger-ubuntu>
 <d1b1e0da-29f0-c443-6c86-9549bbe1c79d@redhat.com>
 <44cef2e9-2ba1-82c6-60bf-c3fe4b5ed9ff@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <44cef2e9-2ba1-82c6-60bf-c3fe4b5ed9ff@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/09/21 22:27, Babu Moger wrote:
> 
> On 9/28/21 11:04 AM, Paolo Bonzini wrote:
>> On 24/09/21 03:15, Babu Moger wrote:
>>>    arch/x86/include/asm/cpufeatures.h |    1 +
>>>    arch/x86/kvm/cpuid.c               |    2 +-
>>>    2 files changed, 2 insertions(+), 1 deletion(-)
>> Queued, with a private #define instead of the one in cpufeatures.h:
> Thanks Paolo. Don't we need change in guest_has_spec_ctrl_msr?

Not strictly necessary unless you expect processors to have PSFD and not 
SSBD; but yes it's cleaner.

Paolo

