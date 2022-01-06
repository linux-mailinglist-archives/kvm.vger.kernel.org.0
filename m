Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162A8485F37
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 04:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiAFD3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 22:29:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiAFD3d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 22:29:33 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ECF3C061245;
        Wed,  5 Jan 2022 19:29:33 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id i8so1405383pgt.13;
        Wed, 05 Jan 2022 19:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=tjtACa9dE3yrERfBZgjLjugoAKnm+TzTAioGUarOG2g=;
        b=fdS0Ewrp3lhlDeRpuNhaM+HtKAAd+U6bqXE1bMfSzOMQ3CWl/qmkGHFQzkKuqztQME
         K1tkCMVKmkFeQUjteo4qeP2cyEEd0CFuez/MABKMNbsw79Dee9LJRKkZLBcOjC4wfh5S
         vdbNrTJTec01DKgu7PLdeXwjZtcskgDkvwa6TR+D9ruruROpFAqjkvqcjFnqlfPpLHEq
         bhqD5bohcM4BzZ9D2nmqJwIDxHeM8PmdTfG7cXRDdt3GwBZ4YPiMISjLOn9PvZicTUZY
         jP7WQbRcws+35uLRSv0jifzphpZSZdPTa4q4H666+dVMPxDpMrHx525zzitj3qo0+b/P
         igMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=tjtACa9dE3yrERfBZgjLjugoAKnm+TzTAioGUarOG2g=;
        b=UL2et+RxXZ+OcPKy6bwnsjlm3e9vcqIhnWK+WgKv4x8uaf9ldLd8QY3ZwjxKZKS3fF
         XKLaI8l/GO/nijapgwMPi7Y0zEpDFrem7qv7pMq/mgDPyNRcydo3B3IZCjpSaY7SilAk
         W0QA3gY/DN+Qp4Glje1dtUUmuSIRajwkO3DoLhgZqC/82q6IXSofEvMMcjaNotksqfhn
         PBMn6uFS0dtPTvdNsz4SaPEqFOjQwFNpHrVQjXe+AxbAUG+KStmYDyYr4i0BsziEal/R
         YjVoJ9FqPgvFMCoaOCjzFYnlxkkjCXFaYy4nBHQKL0h6/gJ9WbOoaPFosjKldCZhzVeg
         RkOQ==
X-Gm-Message-State: AOAM532zgoIp7q0pYAtDYMMZjHiBzbq60cp5UA7FeBdMuIq3p1l5MbF5
        PMlbulwBvv14s3yWhMx60yeeR9O9ESfzeOO4yo215w==
X-Google-Smtp-Source: ABdhPJywRfexzWwcSLBCIzGj14LT9dcmfvwd6/YztzU5gZr7oIKz4U/00eaD51mR7yNqrz+DWI7Lpw==
X-Received: by 2002:a63:d046:: with SMTP id s6mr50389112pgi.367.1641439770484;
        Wed, 05 Jan 2022 19:29:30 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id k3sm372968pgq.54.2022.01.05.19.29.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 19:29:30 -0800 (PST)
Message-ID: <212cea42-e445-d6f2-2730-88ccaa65b2cb@gmail.com>
Date:   Thu, 6 Jan 2022 11:29:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <likexu@tencent.com>,
        Dongli Cao <caodongli@kingsoft.com>,
        Li RongQing <lirongqing@baidu.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Thomas Gleixner (kernel-recipes.org)" <tglx@linutronix.de>,
        "Borislav Petkov (kernel-recipes.org)" <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>
References: <20211222133428.59977-1-likexu@tencent.com>
 <CALMp9eTgO4XuNHwuxWahZc7jQqZ10DchW8xXvecBH2ovGPLU9g@mail.gmail.com>
 <d3a9a73f-cdc2-bce0-55e6-e4c9f5c237de@gmail.com>
 <CALMp9eTm7R-69p3z9P37yXmD6QpzJhEJO564czqHQtDdCRK-SQ@mail.gmail.com>
 <CALMp9eTVjKztZC_11-DZo4MFhpxoVa31=p7Am2LYnEPuYBV8aw@mail.gmail.com>
 <22776732-0698-c61b-78d9-70db7f1b907d@gmail.com>
 <CALMp9eQQ7SvDNy3iKSrRTn9QUR9h1M-tSnuYO0Y4_-+bgV72sg@mail.gmail.com>
 <bf7fc07f-d49c-1c73-9a31-03585e99ff09@gmail.com>
 <CALMp9eQmO1zS9urH_B8DeoLp30P7Yxxp9qMwavjmoyt_BSC23A@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH v2] KVM: X86: Emulate APERF/MPERF to report actual vCPU
 frequency
In-Reply-To: <CALMp9eQmO1zS9urH_B8DeoLp30P7Yxxp9qMwavjmoyt_BSC23A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/1/2022 6:51 am, Jim Mattson wrote:
> On Thu, Dec 30, 2021 at 11:48 PM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> On 31/12/2021 9:29 am, Jim Mattson wrote:
> 
>>> At sched-in:
>>> 1. Save host APERF/MPERF values from the MSRs.
>>> 2. Load the "current" guest APERF/MPERF values into the MSRs (if the
>>> vCPU configuration allows for unintercepted reads).
>>>
>>> At sched-out:
>>> 1. Calculate the guest APERF/MPERF deltas for use in step 3.
>>> 2. Save the "current" guest APERF/MPERF values.
>>> 3. "Restore" the host APERF/MPERF values, but add in the deltas from step 1.
>>>
>>> Without any writes to IA32_MPERF, I would expect these MSRs to be
>>> synchronized across all logical processors, and the proposal above
>>> would break that synchronization.
> 
> I am learning more about IA32_APERF and IA32_MPERF this year. :-)

Uh, thanks for your attention.

> 
> My worry above is unfounded. These MSRs only increment in C0, so they
> are not likely to be synchronized.
> 
> This also raises another issue with your original fast-path
> implementation: the host MSRs will continue to count while the guest
> is halted. However, the guest MSRs should not count while the guest is
> halted.
> 

The emulation based on guest TSC semantics w/ low precision may work it out.
TBH, I still haven't given up on the idea of a pass-through approach.

