Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B64D30C8C8
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 19:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238135AbhBBSAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 13:00:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38957 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233941AbhBBR6J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 12:58:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612288600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dN94EaBZoEheJv2bVKF3aVQ488mV21cwDUunabYy/Qg=;
        b=O4kFm8mKlvgXxlcInVD0S6PfytYVLzNoidU3OsipJP4ZvXcSX/S4PWDwDM0dmAr0tdSXTy
        20zxm87KO+0i6ZWWVGb7tp2vUmJasboBxqjEADzpyssOLFrU2FYDnskAzSFx8plH0rI43b
        4gaeLcA4egXZZ8OqGAZV37guWYqF9lc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-CE4SB14bPaig1ECmxC2T6g-1; Tue, 02 Feb 2021 12:56:36 -0500
X-MC-Unique: CE4SB14bPaig1ECmxC2T6g-1
Received: by mail-ed1-f69.google.com with SMTP id f21so10017816edx.23
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 09:56:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dN94EaBZoEheJv2bVKF3aVQ488mV21cwDUunabYy/Qg=;
        b=ZgMSG8Wij98Votz92WYvLUgaslYVocguKIOgG5eodhSv3WnxqiS7qZhdOn31cRQeW+
         CsfdYH7mL2r5RVb8h913Y+g2+EgSK7v0HS8AB2xfwsdSDw6dLuxcqjd5bqYFwHyKTlpQ
         g3jlmzw6VX3ZoECuvDYxFSzP4Kd5waH0fHUNqikxl5C/7kPz35aSwY7DlnjgunUgchD6
         MAdpj8oqWt3ImOsBvyEs4dNxngc3V6FAytCCdFNddyJROa3IU2P2zo+6+1jKBIwkykTX
         P1wQvMxEg2Cj3A/z1eRKgTeCjYV2Abpc5H5yTEWbMdhxwaC/7FnQT7tJ5NRpOxtCSEsX
         k9NA==
X-Gm-Message-State: AOAM531k8uXLiLgbXVEtOfYZI6pUTfjWJI+/GCIGE5+Vqn5aCooUCC7Y
        AOJ3jS0PNZDCOwSiqZlOzctnw784Z9RkbhxQhYxe8ZzWpphInLFg/7SLPiqOK0FPCsSQ79+R4mA
        tHfc7DhI810oG
X-Received: by 2002:aa7:c884:: with SMTP id p4mr139200eds.212.1612288595839;
        Tue, 02 Feb 2021 09:56:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJweACfB87YxeuSAxTmHEDhxNUQg9iEM2Fqa37a/m/k4cY0OXCQZyW6QjL2h5dDB1cEfiavzBA==
X-Received: by 2002:aa7:c884:: with SMTP id p4mr139189eds.212.1612288595650;
        Tue, 02 Feb 2021 09:56:35 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z20sm10334643edx.15.2021.02.02.09.56.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 09:56:34 -0800 (PST)
Subject: Re: [RFC PATCH v3 01/27] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
To:     Kai Huang <kai.huang@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, seanjc@google.com,
        luto@kernel.org, haitao.huang@intel.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
References: <cover.1611634586.git.kai.huang@intel.com>
 <aefe8025b615f75eae3ff891f08191bf730b3c99.1611634586.git.kai.huang@intel.com>
 <ca0fa265-0886-2a37-e686-882346fe2a6f@intel.com>
 <3a82563d5a25b52f0b5f01560d70c50a2323f7e5.camel@intel.com>
 <YBVdNl+pTBBm6igw@kernel.org>
 <20210201130151.4bfb5258885ca0f0905858c6@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <89755f15-a873-badc-b3d6-d4f0f817326e@redhat.com>
Date:   Tue, 2 Feb 2021 18:56:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210201130151.4bfb5258885ca0f0905858c6@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/02/21 01:01, Kai Huang wrote:
>>> I think we can remove comment for SGX1, since it is basically SGX.
>>>
>>> For SGX2, how about below?
>>>
>>> /* SGX Enclave Dynamic Memory Management */
>> (EDMM)
> Does EDMM obvious to everyone, instead of explicitly saying Enclave Dynamic
> Memory Management?
> 
> Also do you think we need a comment for SGX1 bit? I can add /* Basic SGX */,
> but I am not sure whether it is required.
> 

Yes, please use

/* "" Basic SGX */
/* "" SGX Enclave Dynamic Memory Mgmt */

Paolo

