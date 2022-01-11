Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBEDD48A924
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 09:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348823AbiAKIPt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 03:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235106AbiAKIPt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 03:15:49 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB51C06173F;
        Tue, 11 Jan 2022 00:15:46 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id l15so15974302pls.7;
        Tue, 11 Jan 2022 00:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=65e4pY8c6IKP5/BwWsThn09+viwP4Cyof2rq2OFXBLA=;
        b=JLj76DTnuqGLWS3wL4xskV1uf4xVSbCIclOhGiKxT4Hc6rpcJ2AiCFloz539jmg1tB
         gYw2AQWFbPKnqcRywJmHXil9qd1TZzxd9Uin5bgWv9cOIHVXIaCWQJxBmJ3J6dMwxnuD
         RCCN3K2varbNOyS8dNBGUNpCvOyhnoTBuQl3mUGDDv7R4535j+zNflkkacYgjY+lVCfb
         5yX+JJ1L4UCdyUZX800upmeHwDpO0iJo5XHvsYUVIiXhXjr6YGIh6+nBV4mV2RsymYYm
         tCTflUZQ2cUsjrEwh0Xb0SfRYGqfbNZbDiSUzOHwqakXFavykXv9zQTcyqxugKzeqlG4
         y88A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=65e4pY8c6IKP5/BwWsThn09+viwP4Cyof2rq2OFXBLA=;
        b=e7+TSipJ6iA95JDrxnA6hcVb4kZYt/dSOK1aQlhZLwVhu9OzRbGcHlZLBiWnbmPJXz
         I6RH/ks44rEk5PFWuehq2NOqywNtlTOBuWT7QgY7QpxP9ScKLZotRgnuuDQdhfYVlZQd
         +FbeZRkCPKrELRo8eouAnk7k1Yln5mk/bfLYppHtJti+RzE6yWCeYDAAI0r+ftNQS2+I
         PVLvs4aHZRlfwgIvn4bX8sC23UK2iYfsyaG6+Ds162AngpAghDhor3MpWAH3XD9ufjvT
         ktr6F0MsN7xPG0mS1bc9IQFYN5myplu4ea8UE7VOef1cHqqZRVLHN/4QWbpBFZVWV7B1
         TwyQ==
X-Gm-Message-State: AOAM530UqBgVUP/DyF6Od9Xaj0A0FakWs0PPmvTWFgxZJEIKd7A1YZ34
        D6ps8T/S0NsdtTOUNFPRk3Q=
X-Google-Smtp-Source: ABdhPJwFGoWgo+kK/ZP3yeqM9tGaVtD51Vubm7aOGIatueuMYBzU5Sxlpw+VCc4s4DBYEVh0nCDXgQ==
X-Received: by 2002:a17:90b:3ecc:: with SMTP id rm12mr1851434pjb.225.1641888946117;
        Tue, 11 Jan 2022 00:15:46 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id g6sm7621531pgk.37.2022.01.11.00.15.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 00:15:45 -0800 (PST)
Message-ID: <4afbaf27-04a9-91a6-f9fa-178e4624b482@gmail.com>
Date:   Tue, 11 Jan 2022 16:15:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
References: <20220110034747.30498-1-likexu@tencent.com>
 <YdzV33X5w6+tCamI@google.com>
 <80b40829-0d25-eb84-7bd7-f21685daeb20@gmail.com>
 <8a6e5b96-1191-7693-314a-1714cb7c9c9c@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH v2] KVM: x86/pt: Ignore all unknown Intel PT capabilities
In-Reply-To: <8a6e5b96-1191-7693-314a-1714cb7c9c9c@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/1/2022 3:59 pm, Xiaoyao Li wrote:
>>
>> +#define GUEST_SUPPORTED_CPUID_14_EBX    \
>> +    (BIT(0) | BIT(1) | BIT(2) | BIT(3) | BIT(4) | BIT(5))
>> +
>> +#define GUEST_SUPPORTED_CPUID_14_ECX    \
>> +    (BIT(0) | BIT(1) | BIT(2) | BIT(3) | BIT(31))
>> +
> 
> I doubt BIT(3) of CPUID_14_ECX can be exposed to guest directly.
> 
> It means "output to Trace Transport Subsystem Supported". If I understand 
> correctly, it at least needs passthrough of the said Transport Subsystem or 
> emulation of it.

I'm not surprised that we can route Intel Guest PT output to a platform-specific
trace endpoint (e.g., physical or emulated JTAG) as an MMIO debug port.
