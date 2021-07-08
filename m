Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E893BF767
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 11:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhGHJVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 05:21:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39076 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231324AbhGHJVV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Jul 2021 05:21:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625735919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KHU1Vmvm7F12r1PAslF5dEr4adP4DAjY+fw1RfKa6y0=;
        b=Pm5/uGnKTyjbOx4tA1Hu1CukQrTSiuuSxLJjLO85HxRPQsq+BpQShW1UaiMKvmFniBXOVB
        en2FcJf35Saa/HTldhk2LW+rE8MSIuEY9FA6ToKEXZSLJj59Y1sWffewS6Nm8J8pqgXsVw
        ZNcZzWiDHBx+gWXDrwUQhZCojeyvqAo=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-QIYtnobTOCSnbiraHe2jRw-1; Thu, 08 Jul 2021 05:18:36 -0400
X-MC-Unique: QIYtnobTOCSnbiraHe2jRw-1
Received: by mail-ej1-f70.google.com with SMTP id jx16-20020a1709077610b02904e0a2912b46so1550438ejc.7
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 02:18:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KHU1Vmvm7F12r1PAslF5dEr4adP4DAjY+fw1RfKa6y0=;
        b=dyHNUf4Gcouaae1TG73I8xxSw/0kjH2qpKGSXhuFkjdj9cF9CdLcDpPHcJhh2x7MLl
         +uj3NT0oIi9izp1MgwFkEuNO5a8bgiO3WxFAHjz8FkPnhOUC/NpZ9kjumkxFvKtPWoFy
         43hdu5K8vsSkgI9umJxvGOiawKT+tKSDeQTPIYb5C1roJdY+dOV6cQWNj8OyrdL+Mzrj
         iwqAlMpet2XelcNNQL23FxHkGK6OiuVCBYJJRHDXf0YRln6kXHel9AfTPXuWpLhHqBZ9
         X7fOMAM2Qc9rEyXejpXGnaXEwyymOfrw92yM6y7y4gg9+PBG2He3pZXiHpiQ6k9Zt2qC
         DE3A==
X-Gm-Message-State: AOAM530b5qssMtzyHfBJzAOKSX+3zx5qlMICyqP/lgMEI4kyn6dwPp5S
        IS6n+xnkQ2dk8tjNcmDtO6xckpi0FgnN+q3RNNXgizb8BqowYrQuiEZx0kFjGUPmqiYyPzH0ukp
        qRpWigOuHgjoC
X-Received: by 2002:a17:906:e0e:: with SMTP id l14mr9138375eji.501.1625735915536;
        Thu, 08 Jul 2021 02:18:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxifn4rGSLVNiWgp2jP6bilACMyMlJDH3BLCSzTzOMJEiHwS01lRdGsL3R/9D4VvMBOp99ILA==
X-Received: by 2002:a17:906:e0e:: with SMTP id l14mr9138354eji.501.1625735915367;
        Thu, 08 Jul 2021 02:18:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q24sm940031edc.82.2021.07.08.02.18.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 02:18:34 -0700 (PDT)
Subject: Re: [PATCH V2] x86/kvmclock: Stop kvmclocks for hibernate restore
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Lenny Szubowicz <lszubowi@redhat.com>, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210326024143.279941-1-lszubowi@redhat.com>
 <YOawSzWrNtUIlSuE@8bytes.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ee8c4344-b6b2-07b4-bb5c-48f6462f0931@redhat.com>
Date:   Thu, 8 Jul 2021 11:18:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YOawSzWrNtUIlSuE@8bytes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/21 09:59, Joerg Roedel wrote:
> Hi Paolo,
> 
> On Thu, Mar 25, 2021 at 10:41:43PM -0400, Lenny Szubowicz wrote:
>> Reported-by: Xiaoyi Chen <cxiaoyi@amazon.com>
>> Tested-by: Mohamed Aboubakr <mabouba@amazon.com>
>> Signed-off-by: Lenny Szubowicz <lszubowi@redhat.com>
>> ---
>>   arch/x86/kernel/kvmclock.c | 40 ++++++++++++++++++++++++++++++++++----
>>   1 file changed, 36 insertions(+), 4 deletions(-)
> 
> What is the status of this patch? Are there any objections?

It was replaced by these:

0a269a008f83 x86/kvm: Fix pr_info() for async PF setup/teardown
8b79feffeca2 x86/kvm: Teardown PV features on boot CPU as well
c02027b5742b x86/kvm: Disable kvmclock on all CPUs on shutdown
3d6b84132d2a x86/kvm: Disable all PV features on crash
384fc672f528 x86/kvm: Unify kvm_pv_guest_cpu_reboot() with kvm_guest_cpu_offline()

Thanks,

Paolo

