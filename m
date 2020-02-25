Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9F3116E932
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 16:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730953AbgBYPA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 10:00:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24992 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730317AbgBYPA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 10:00:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582642857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3H8npfbWdmh4zPKaCHNXPRWoIVLSdCPbN2mOYmIHU80=;
        b=c7H2GvBm61pHHy5TrHcxPwv6tCtB6BxurfXyQLF84AmxIEaDYERhsld+LpH0+NXdzVQcbT
        W64Q3W2bXUKdF9bWt+q7DpDt3b35KW89qvc3JGCGnOkohfggBQlLiwnBsXlgXcBO+oEWl+
        EUJrzM1Ws5EOkNKsY82lurqrCwJLuPI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-y-qjMHC2N_-myrPOMDN_MQ-1; Tue, 25 Feb 2020 10:00:52 -0500
X-MC-Unique: y-qjMHC2N_-myrPOMDN_MQ-1
Received: by mail-wm1-f71.google.com with SMTP id m4so974612wmi.5
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 07:00:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3H8npfbWdmh4zPKaCHNXPRWoIVLSdCPbN2mOYmIHU80=;
        b=S0gSUOi7lrd+dgxDoIzThWoOb6IDQR/s/NR5vCzzyzhqR0NedL5FLbznq0kCkDAsIU
         ND9KS2ryN975ueoVndvuLXugwWxjBeNrAqNOIpN1U4a53A+Xv/KpgZp5fr7hJxg1hEeH
         dAmbUppwiDO+2kGRvV8e/wVTtsci6PGZxv3z640RTcxIWIoWzwaYD6l6YcJ80MlcL8rf
         CHmgV/y7TIBPWf+lAvQqvxwdC4k+8FmkPPu/48KLguGanbqvj+u0irlMFEP/CtHz1TjA
         ZAo3HJ8q5c/05mZu/oFvyp9kYtwJWICjzJS1h0rONrEyJgnOhUQJTIGH6/x/ND1eStNF
         ChRw==
X-Gm-Message-State: APjAAAX1op8HI8OfSEbecudoCNXV4Wq7z+DxrFcP9FHp4kIY140VUYFc
        VJBCO1AA7P6EukJbXDf4SIawG/CmDoji80eOZhxzK/qjMwO5jMh3/CK/lnmFpNJVkbcHIvG0Dh1
        J/LWY1rsAF3/Z
X-Received: by 2002:adf:f986:: with SMTP id f6mr76268251wrr.182.1582642851018;
        Tue, 25 Feb 2020 07:00:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqyBzTy7Urhf32MJINJ0M8dRKWGI5MgfBTVJZ1Mh+1hF+3v/CspRn3IbJXFjwdREllDRoZmRNA==
X-Received: by 2002:adf:f986:: with SMTP id f6mr76268230wrr.182.1582642850775;
        Tue, 25 Feb 2020 07:00:50 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:3577:1cfe:d98a:5fb6? ([2001:b07:6468:f312:3577:1cfe:d98a:5fb6])
        by smtp.gmail.com with ESMTPSA id c74sm4663111wmd.26.2020.02.25.07.00.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 07:00:50 -0800 (PST)
Subject: Re: [PATCH 29/61] KVM: x86: Add Kconfig-controlled auditing of
 reverse CPUID lookups
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-30-sean.j.christopherson@intel.com>
 <87a758oztt.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1875741b-402d-d113-86ff-48adbf782727@redhat.com>
Date:   Tue, 25 Feb 2020 16:00:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <87a758oztt.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/02/20 14:54, Vitaly Kuznetsov wrote:
>> --- a/arch/x86/kvm/cpuid.h
>> +++ b/arch/x86/kvm/cpuid.h
>> @@ -98,6 +98,11 @@ static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned x86_feature)
>>  static __always_inline u32 *__cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
>>  						  const struct cpuid_reg *cpuid)
>>  {
>> +#ifdef CONFIG_KVM_CPUID_AUDIT
>> +	WARN_ON_ONCE(entry->function != cpuid->function);
>> +	WARN_ON_ONCE(entry->index != cpuid->index);
>> +#endif
>> +
>>  	switch (cpuid->reg) {
>>  	case CPUID_EAX:
>>  		return &entry->eax;
> Honestly, I was thinking we should BUG_ON() and even in production builds
> but not everyone around is so rebellious I guess, so

BUG_ON is too much, but I agree the cost is so small that unconditional
WARN_ON makes sense.

Paolo

