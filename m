Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8DC3C1714
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 18:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbhGHQd0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 12:33:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28579 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229468AbhGHQd0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Jul 2021 12:33:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625761843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n3O76+nvGmM0mqj/tRy/JidZpIj8VUJL+4rKAr009LU=;
        b=hQ2SMJSFVBDX5kbJW+BFAmS+8L5Ai8YQmY/xtlYbYUqG3DiWfsdwto01a/yNC1etpLZ+WU
        mbUTB0VOnhQEPCfJ189XdhfveZ0Y4lSQm4aIbPvmMysbOhAptvo5EtRXqyevUalOUpKyrh
        v6KJ2BY+SpiujgL6OrwlRyICzKI7F7s=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-O21GRGVXOPGhHIpYtMeCow-1; Thu, 08 Jul 2021 12:30:42 -0400
X-MC-Unique: O21GRGVXOPGhHIpYtMeCow-1
Received: by mail-ej1-f71.google.com with SMTP id d2-20020a1709072722b02904c99c7e6ddfso2071618ejl.15
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 09:30:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n3O76+nvGmM0mqj/tRy/JidZpIj8VUJL+4rKAr009LU=;
        b=luJ4N4hN4nWBKTMrMfpCh9xG0tUkLCx6yYVU2uOoyRLFxQpp+oASoq6Bv8ww1arOie
         TB3hnCy+CzhmZvFwl5AngpqmNR0C8v7PnFKxeDQzKzk5JQI1JI97hzndDIyUh6ks4G9O
         MG2etJ9rJRSU+deLYU3Lm6zv8OB1jsBHzC4M7YM2f7/UsNC2eqw1vvGxLLYYJdTZZkos
         DkhX4Z30FehDIP+56MvTML0HjQzmOo8z+Gl4/aAhUXkkh5N/8VChH9fZ4YeSR1WiEN2r
         ndOI82mGiibd5q0KrGn+7QBa/fNa09W2xqqeOUYS/zQ6Y2/FM5QZKoZ5IU7p8tuAhD2x
         KWdw==
X-Gm-Message-State: AOAM533PtlgPkzJtn79fcYYMSWuUWgenYswCfUJ94RuVrFXUHm03MdtI
        xH+OQH3HokVK+hQYEW4Z9SZc5yLM/VaHdvI510sKWYzIKuyvZoFaokddBKIEyitIgigWv2HmDLM
        raX9HXuGmBT/o
X-Received: by 2002:a05:6402:5203:: with SMTP id s3mr32864309edd.353.1625761841459;
        Thu, 08 Jul 2021 09:30:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyasSg+PY1RAPaYCFiCyAbI/uYXfdvuQUyEoZ6VHLFFAVFYbfTsHADOeVyRlOHkyrlbVl+wdQ==
X-Received: by 2002:a05:6402:5203:: with SMTP id s3mr32864280edd.353.1625761841267;
        Thu, 08 Jul 2021 09:30:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id dd24sm1532844edb.45.2021.07.08.09.30.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 09:30:40 -0700 (PDT)
Subject: Re: [PATCH 0/2] KVM: SVM: Final C-bit fixes?
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20210625020354.431829-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e406b31f-64bd-eb88-51bb-dd534719fb6e@redhat.com>
Date:   Thu, 8 Jul 2021 18:30:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210625020354.431829-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/06/21 04:03, Sean Christopherson wrote:
> Patch 01 reverts the C-bit truncation patch as the reserved #PF was
> confirmed to be due to a magic HyperTransport region (how many magic
> addresses are there!?!).  Hopefully the original patch simply be dropped,
> but just in case...
> 
> Patch 02 reverts the C-bit clearing in the #NPF handler.  If that somehow
> turns out to be incorrect, i.e. there are flows where the CPU doesn't
> mask off the C-bit, then it can be conditional on a SEV guest.
> 
> I'll be offline for the next two weeks, fingers crossed I've undone all
> the damage.  :-)
> 
> Thanks!
> 
> Sean Christopherson (2):
>    Revert "KVM: x86: Truncate reported guest MAXPHYADDR to C-bit if SEV
>      is supported"
>    KVM: SVM: Revert clearing of C-bit on GPA in #NPF handler
> 
>   arch/x86/kvm/cpuid.c   | 11 -----------
>   arch/x86/kvm/svm/svm.c | 39 +++++++++------------------------------
>   arch/x86/kvm/x86.c     |  3 ---
>   arch/x86/kvm/x86.h     |  1 -
>   4 files changed, 9 insertions(+), 45 deletions(-)
> 

Queued, thanks.

Paolo

