Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1BE0189C35
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 13:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgCRMpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 08:45:09 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:41237 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726616AbgCRMpI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 08:45:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584535507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uvQfnaEYBfnYBDItpt1iU+ao5bricI+fV0mKZwprprw=;
        b=P6OAqRChVVoZHxAo/m5fE9wQmya4S4bvYpUoPSv9kB2a424Ctk0oVQ1jEw9Lt3HaMl8rAM
        +eP5jWxqkjV71epRa9KoFxsBBDVn8e0DzYRYkPIKDIbP+pqHilLPHQvylo2zaUEyOH1Zug
        3rS3bwR38rce7ursnyrFdAwxLiJHReI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-HV16sdYqO5iFrwvjsQS_hA-1; Wed, 18 Mar 2020 08:45:06 -0400
X-MC-Unique: HV16sdYqO5iFrwvjsQS_hA-1
Received: by mail-wr1-f71.google.com with SMTP id t10so6003623wrp.15
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 05:45:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uvQfnaEYBfnYBDItpt1iU+ao5bricI+fV0mKZwprprw=;
        b=ZfX0GTJzqEZNL3XgdoggqKp2Ba5dUjYainVSDBU8kFaSCaPGJKzbCtMcJX0eI8KTvX
         uXOZHwFj5LVsx7EEIN3XvwZevHPfJWMaHPNcj0xtRbYUKVwgMervsbS7rxrodbjL8Kak
         qOmcTn8xvDZtHTIjlC+Z1J/ubqZPcQ1e5/xaTFE3PyqciTP/vKX+CruZ+EpLm9da1IxX
         xbk9YCPj4cvYpfGJvS/ZtwHnDnqhFaJe8eeV35HjV6xFDsuW+ElZKE4xPEIMHnUjSCx8
         sTN7yKia98ggkGIW8NyhwjUWD03O29a7nIbZnhICak3DusCpUSwfT9KxFaJ6FzxguaGK
         Wy3Q==
X-Gm-Message-State: ANhLgQ0qyZ13KMaUUFFSKNwbTByLhL7i/q1rRxuWmhepQ9+H3b+A+fo5
        0YUq571xp0VgS6uoQfzLAAfCmoT1bs+DatlbIMb6ojnee+sp/6mnErHE2UnVwKLyQQA+j95DOkA
        qU1Biqzw+mUHt
X-Received: by 2002:a1c:1d15:: with SMTP id d21mr5014145wmd.101.1584535503090;
        Wed, 18 Mar 2020 05:45:03 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvmhqCfpHfDDmiDeF3eEE/k96DNeOLsWLMMYaoFqlBqailxyi6r8qeWRvzFsEqwr7wAB8fj5w==
X-Received: by 2002:a1c:1d15:: with SMTP id d21mr5014125wmd.101.1584535502837;
        Wed, 18 Mar 2020 05:45:02 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.43])
        by smtp.gmail.com with ESMTPSA id h81sm4001319wme.42.2020.03.18.05.45.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 05:45:01 -0700 (PDT)
Subject: Re: [PATCH 0/2] KVM: x86: CPUID tracepoint enhancements
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
References: <20200317195354.28384-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f7a1a4a0-7730-93a7-564e-fc4dcad4ee2c@redhat.com>
Date:   Wed, 18 Mar 2020 13:45:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200317195354.28384-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/03/20 20:53, Sean Christopherson wrote:
> Two enhancements to the CPUID tracepoint.  Patch 01 was originally in the
> CPUID ranges series, but I unintentionally dropped it in v2.
> 
> The final output looks like:
> 
>   kvm_cpuid: func 0 idx 0 rax d rbx 68747541 rcx 444d4163 rdx 69746e65, cpuid entry found
>   kvm_cpuid: func d idx 444d4163 rax 0 rbx 0 rcx 0 rdx 0, cpuid entry not found
>   kvm_cpuid: func 80000023 idx 1 rax f rbx 240 rcx 0 rdx 0, cpuid entry not found, used max basic
>   kvm_cpuid: func 80000023 idx 2 rax 100 rbx 240 rcx 0 rdx 0, cpuid entry not found, used max basic
> 
> I also considered appending "exact" to the "found" case, which is more
> directly what Jan suggested, but IMO "found exact" implies there's also a
> "found inexact", which is not true.  AIUI, calling out that KVM is using
> the max basic leaf values is what's really important to avoid confusion.
> 
> Ideally, the function of the max basic leaf would also be displayed, but
> doing that without printing garbage for the other cases is a lot of ugly
> code for marginal value.
> 
> Sean Christopherson (2):
>   KVM: x86: Add requested index to the CPUID tracepoint
>   KVM: x86: Add blurb to CPUID tracepoint when using max basic leaf
>     values
> 
>  arch/x86/kvm/cpuid.c |  9 ++++++---
>  arch/x86/kvm/trace.h | 18 ++++++++++++------
>  2 files changed, 18 insertions(+), 9 deletions(-)
> 

Queued, thanks.

Paolo

