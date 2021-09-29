Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB2941C4FE
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 14:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343938AbhI2M5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 08:57:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51216 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343910AbhI2M5f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Sep 2021 08:57:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632920153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oHHoz5hSfSYkAdHIHrMpSEd2w0Wf9S7kBxpqY6OLo4c=;
        b=a+sN7iLzlx1fwHfGDykWkYL/Lifwm+RKgixsddFTH4TVDNKHKA9FCDUDrhhc6SsSFK/ZX+
        IZoOGqsdgF3wvKVReunRHmsVaCUyTodmhD58CEl4ZQp4DPlP9y8pxfDuPzlrnZDa244r9T
        wVk7R1vpduriiXEnSdrfa3jwALZYUm4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-7LeIM8gkMjOS6BMbtGkRJg-1; Wed, 29 Sep 2021 08:55:52 -0400
X-MC-Unique: 7LeIM8gkMjOS6BMbtGkRJg-1
Received: by mail-ed1-f70.google.com with SMTP id z62-20020a509e44000000b003da839b9821so2282563ede.15
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 05:55:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oHHoz5hSfSYkAdHIHrMpSEd2w0Wf9S7kBxpqY6OLo4c=;
        b=hEO8CNmqtRhyZ9lNi9B3HiPf0h/7IQWXJtwSkaQMAOXssrRgMT9M+atknVWizm+GGb
         fWpBJRduUhq4K7MOqFjaQrsmSrEqNnTulT7281p5KDF1kP8Tv4tUTN4OEOswZKiljXWp
         aCVGV83UubBmEudE6J5tOebuOFoAAVHEC+cnz5ymNVdVtLZLB99pGd5lfTAMoJsyozp9
         s4lQZ95g03vH87u1z8ziJHua5IPoT+Ors9cuoLa0hYVJwq8xz59/a6l0Smx72TY+B8Un
         eU6OEfl01ewfh8h/HTCix6D5EWxTgAEqTXHiMIhAR0EzBjb8NM/UYV1yjvlZZhJ9axPR
         Y8fw==
X-Gm-Message-State: AOAM532T15TaBNwcBwC6ubExZPCVama0xV8UsKW0elA6ZxYxvLYtR9iS
        pAkxj8uL1n028ee0pcJfAYKFPS6FznqbTG9GGIjr8oP+1uLKrpuajHHoMggXvuuMP6sq5RroIO9
        A/E6Ud7mwneje
X-Received: by 2002:a50:da07:: with SMTP id z7mr14803659edj.301.1632920151488;
        Wed, 29 Sep 2021 05:55:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnijlA+Suv1yZ7nvg6/PmlavVog5wCQhvw8hN3J1hEM8QAnQNFWgkO9hGUcLAsv1xKMPFzOQ==
X-Received: by 2002:a50:da07:: with SMTP id z7mr14803641edj.301.1632920151269;
        Wed, 29 Sep 2021 05:55:51 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id dc8sm1518212edb.28.2021.09.29.05.55.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 05:55:50 -0700 (PDT)
Message-ID: <3721a326-b728-787e-0ef7-a1925941b17b@redhat.com>
Date:   Wed, 29 Sep 2021 14:55:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 0/2] Cleanups for pointer usages in nVMX.
Content-Language: en-US
To:     Yu Zhang <yu.c.zhang@linux.intel.com>, seanjc@google.com,
        vkuznets@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
References: <20210929175154.11396-1-yu.c.zhang@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210929175154.11396-1-yu.c.zhang@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/09/21 19:51, Yu Zhang wrote:
> Replace usages of "-1ull" with INVALID_GPA. And reset the vmxon_ptr
> when emulating vmxoff.
> 
> v2:
>    Added patch to replace usages of "-1ull" with INVALID_GPA.
> 
> Vitaly Kuznetsov (1):
>    KVM: nVMX: Reset vmxon_ptr upon VMXOFF emulation.
> 
> Yu Zhang (1):
>    KVM: nVMX: Use INVALID_GPA for pointers used in nVMX.
> 
>   arch/x86/kvm/vmx/nested.c | 61 ++++++++++++++++++++-------------------
>   arch/x86/kvm/vmx/vmx.c    |  5 ++--
>   2 files changed, 34 insertions(+), 32 deletions(-)
> 

Queued, thanks.

Paolo

