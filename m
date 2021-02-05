Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D483109C5
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 12:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbhBELEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 06:04:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47691 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231949AbhBELCa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Feb 2021 06:02:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612522864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hlQHxvz68herj6uUlAqo6cNNlISG8mBPX3iyJA1YfgY=;
        b=U2R7dq0veCLLFAVwqOxvVea3BPvYdvokhPTfULuAhI6A4XeySy63DjAVyJcnCbRVrkR6zX
        Wpn5bRZyNzi+n8f6hFmcNpvvdV3YNIGn1/hNYjea7bwdvNBMVohSoXQmT8Fiv/NzsjcCn4
        xvWmheoU8pNCX+B64VpCHF2LcEveh0E=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-1__g6rOUPPGlwnW1Za16rQ-1; Fri, 05 Feb 2021 06:01:02 -0500
X-MC-Unique: 1__g6rOUPPGlwnW1Za16rQ-1
Received: by mail-ed1-f69.google.com with SMTP id p18so6753401edr.20
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 03:01:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hlQHxvz68herj6uUlAqo6cNNlISG8mBPX3iyJA1YfgY=;
        b=CbwhBSaVtCNPu0+2TL7s85Mt0kkkUtcZ0vUTg0MzKcPWzEVSOepGvpxVoeCVFGv8b9
         5W0ErOPIlIwbAPNJey3/1PVOixVmfdO3XXalWRcuokUBWOp/lyNRC4py2Pwq3Hf7RTiZ
         khjSgPpUbSWCdFpPvSZVdZpTmrojo9K+pEmQiJpiOPsTKTLbcEYfq/jXRrQG9cU+3HQA
         PSY5fiAGPXIcEEodw5hWG6vTOeeJGejKX5Bv5YBEiDQVn5izKEjIiPIdn7qwzNbTdl0d
         TQjzG4qAelBWNpzoVmFFMuq+/H5ZxOfjz7HvkcT7dvatOORuhMwHuq/KP15plvb9GF4U
         XC0w==
X-Gm-Message-State: AOAM531ZJGQ44T4h4OcoboV3ILcd1wOmnYeSUhrNHxA0sqGNEEtXl8sV
        AFvHBluZ4Rz66LtUP9QybBLnmbY3tgH6U9Ye/vW19/rpq0e0bmXxBG2TERVQwuIUFhOMF3tOhYf
        sdID7woqcPYdi
X-Received: by 2002:a17:906:d84:: with SMTP id m4mr3483453eji.437.1612522861733;
        Fri, 05 Feb 2021 03:01:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy4F1t/R+DPSOQFVqV3fjaYushABxmKmxDzt7PERmONeplKqUD5cGkaLMtwig78BxPe+5fXxw==
X-Received: by 2002:a17:906:d84:: with SMTP id m4mr3483425eji.437.1612522861540;
        Fri, 05 Feb 2021 03:01:01 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x25sm3802377edv.65.2021.02.05.03.00.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 03:01:00 -0800 (PST)
Subject: Re: [PATCH v2 4/4] KVM: x86: Expose Architectural LBR CPUID and its
 XSAVES bit
To:     "Xu, Like" <like.xu@intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
References: <20210203135714.318356-1-like.xu@linux.intel.com>
 <20210203135714.318356-5-like.xu@linux.intel.com>
 <8321d54b-173b-722b-ddce-df2f9bd7abc4@redhat.com>
 <219d869b-0eeb-9e52-ea99-3444c6ab16a3@intel.com>
 <b73a2945-11b9-38bf-845a-c64e7caa9d2e@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7698fd6c-94da-e352-193f-e09e002a8961@redhat.com>
Date:   Fri, 5 Feb 2021 12:00:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <b73a2945-11b9-38bf-845a-c64e7caa9d2e@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/02/21 09:16, Xu, Like wrote:
> Hi Paolo,
> 
> I am wondering if it is acceptable for you to
> review the minor Architecture LBR patch set without XSAVES for v5.12 ?
> 
> As far as I know, the guest Arch LBR  can still work without XSAVES 
> support.

I dopn't think it can work.  You could have two guests on the same 
physical CPU and the MSRs would be corrupted if the guests write to the 
MSR but they do not enable the LBRs.

Paolo

