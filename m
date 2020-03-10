Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8089180493
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 18:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgCJROR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 13:14:17 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36604 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbgCJROR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 13:14:17 -0400
Received: by mail-wr1-f67.google.com with SMTP id s5so12989936wrg.3;
        Tue, 10 Mar 2020 10:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YxvAecFulSD8TnYu6Bdw3yluyHTPsAWlb/0EQPhybgQ=;
        b=SPr60n6OSWbLna/pRLxYdMcGAsdyqT7XCIi+09nutJD29iRPlx6m8oVdZcK4iApRtG
         32KAdMaO2Jg1mWSXym/DmureZCJ/qe0xzsc43FZIHpa3fjwf4IKfNfuEo7MIJoLhe29o
         CfHEnQy1CRQbOSggcj1urjjYJ7QWJB4bgmCGbxziFgvBV5h1hJwHbts5FhOIicctDb9T
         7rmZBDpsMH9msitNbBC6bKKlf6Hwxn6t9cNjKdhoupY6J1SPg/eYRg5P1xk3rmEciOiq
         IZOLzaqiwYk9+rNcR2ZDHJu1zhwJm5eUwoY4ltmH1FbCM31wO8R/HZyyvLeq7j7UIz+E
         O74Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YxvAecFulSD8TnYu6Bdw3yluyHTPsAWlb/0EQPhybgQ=;
        b=oYDUz98Gvdit9NvWuifZisrVaoNk5WLjKgWYrWzWGEwBf9MgL5X6C1oiJjPBk6SRHz
         H7ORrxY60MxfYTXtPJkyyJ+OiknFNXKIsCpjvSP6IqPoPeoNKvS80DEqYLXC3nzVHS7y
         9C3I6pUJdZDwIwcatpRVG+zTdEZnyRmLqZ6QZyLV6M6GmjesABpkFXtjlyd8VaiUxrZ1
         KA6LscbDPcTsB8FvxkLj2Cn2R23qsWjN1GrIfVRD7jl1CE81/P94LEyVJKGqpPxwaZlN
         0AuVhoMxJ36GK/4/xSNsG2T6JB9/P7qfjF4Z2tHdkAi2eLOPFI7QfR7eRBiCpFMgdzFf
         UhFQ==
X-Gm-Message-State: ANhLgQ2bV4HWh/W/KmaeUFEXbJQAjo4/wwwd3KHcJLFgcvB34DqSvH4z
        n5cK8uwiDh38FEupSVX5jKmzpIAKQBU=
X-Google-Smtp-Source: ADFU+vthAIE2MZTZEesfjfcou/8n96q9par0YA5nRJM1HOgesSd20O6u7XfzN09curTSNmGTLof0zw==
X-Received: by 2002:adf:9d8f:: with SMTP id p15mr25885968wre.160.1583860453844;
        Tue, 10 Mar 2020 10:14:13 -0700 (PDT)
Received: from jondnuc (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id i6sm1963972wru.40.2020.03.10.10.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 10:14:13 -0700 (PDT)
Date:   Tue, 10 Mar 2020 19:14:12 +0200
From:   Jon Doron <arilou@gmail.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v4 1/5] x86/kvm/hyper-v: Explicitly align hcall param for
 kvm_hyperv_exit
Message-ID: <20200310171412.GC13767@jondnuc>
References: <20200309182017.3559534-1-arilou@gmail.com>
 <20200309182017.3559534-2-arilou@gmail.com>
 <87k13sb14a.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87k13sb14a.fsf@vitty.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/03/2020, Vitaly Kuznetsov wrote:
>Jon Doron <arilou@gmail.com> writes:
>
>> Signed-off-by: Jon Doron <arilou@gmail.com>
>> ---
>>  include/uapi/linux/kvm.h | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 4b95f9a31a2f..7acfd6a2569a 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -189,6 +189,7 @@ struct kvm_hyperv_exit {
>>  #define KVM_EXIT_HYPERV_SYNIC          1
>>  #define KVM_EXIT_HYPERV_HCALL          2
>>  	__u32 type;
>> +	__u32 pad;
>>  	union {
>>  		struct {
>>  			__u32 msr;
>
>Sorry if I missed something but I think the suggestion was to pad this
>'msr' too (in case we're aiming at making padding explicit for the whole
>structure). Or is there any reason to not do that?
>
>Also, I just noticed that we have a copy of this definition in
>Documentation/virt/kvm/api.rst - it will need to be updated (and sorry
>for not noticing it earlier).
>
>-- 
>Vitaly
>

Heh sure no problem will fix in v5, but going to wait for a verdict on 
the location for the new CPUID leafs and MSRs for the synthetic 
debugger.

-- Jon.
