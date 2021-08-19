Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8086E3F1E3D
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 18:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhHSQo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 12:44:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23120 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230089AbhHSQo1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Aug 2021 12:44:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629391430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ovmo8eHJLt09NnHE2KsMUgZOEZ1fOMoSIqw+9nEdI3o=;
        b=ZUMJVEpP1xrmW7YNVk9CRMYFcOoeFAmJpqZbUz0D238R/Zoa69hP8VBeSfP0xBn6ftIjlO
        B42ELNnRoIfCALfxnpGqIH8+fftJKaxkECCkd+EdslTBdz4CyC9IE6W32o9MIflJYX6E0O
        HBUJRxCsnlXorZQxxTRCOjwiVQoR7Qw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-3LQAQfCRMOmwPMNU7b6jaA-1; Thu, 19 Aug 2021 12:43:49 -0400
X-MC-Unique: 3LQAQfCRMOmwPMNU7b6jaA-1
Received: by mail-ed1-f70.google.com with SMTP id e18-20020a0564020892b02903be9702d63eso3110289edy.17
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 09:43:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ovmo8eHJLt09NnHE2KsMUgZOEZ1fOMoSIqw+9nEdI3o=;
        b=TawHuL4mVqUUDpMWLEqc4DPAbl1Q0k2v87b6bHJ4nm8cv/Onc1AB02njvwjL0QgQ3x
         EdEkqLJWNRNMtRuNIHnAAwGID//BpqG1BQLYTSi8+85Mujt132VPX6FB1xrBQtrHnOaM
         Xwd/tnj3a5hxvomR6I49xHCoyKWrrQ1coTmXiCu6YcQFEickhKJkz3nHwgFB8/Ijt4hL
         vqSSX8Mecx5+YfRZBG0SVy/qJ4+wL59Kl++W/BNQSCnYhFu3YYDOCnBHcns06f/v6/Gp
         FYf8lvGTRguzbHYefprElItsGzAQsleNKhZgQ3E9kntk3aoSRXQ1ITUpgFkeaT7O/SCT
         xIYg==
X-Gm-Message-State: AOAM532pI/v4Qj7Nu/cKcNAYGJ/W9akFGrNFiujNxxRabmCfSP7Dq5uT
        4s6DALIiKj6wZdmc5cEgF+X13zsBhDg+rm0AVMhsWZrBdFeDFs1Gi2ESE2t35Bmqt2mgSs2gjWp
        I6fB86oPcFV/J
X-Received: by 2002:a05:6402:2926:: with SMTP id ee38mr17265803edb.95.1629391428204;
        Thu, 19 Aug 2021 09:43:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxBQI9xf53Gfkx4OcP68mxTenuILG5G2+AguBk/JQcIho0t27TP75Z4OOF/3/ibyGxTkTNgoA==
X-Received: by 2002:a05:6402:2926:: with SMTP id ee38mr17265786edb.95.1629391428020;
        Thu, 19 Aug 2021 09:43:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id q21sm1504758eji.59.2021.08.19.09.43.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 09:43:47 -0700 (PDT)
Subject: Re: [PATCH v3 0/3] SVM 5-level page table support
To:     Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        seanjc@google.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com
References: <20210818165549.3771014-1-wei.huang2@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <46a54a13-b934-263a-9539-6c922ceb70d3@redhat.com>
Date:   Thu, 19 Aug 2021 18:43:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210818165549.3771014-1-wei.huang2@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/08/21 18:55, Wei Huang wrote:
> This patch set adds 5-level page table support for AMD SVM. When the
> 5-level page table is enabled on host OS, the nested page table for guest
> VMs will use the same format as host OS (i.e. 5-level NPT). These patches
> were tested with various combination of different settings and test cases
> (nested/regular VMs, AMD64/i686 kernels, kvm-unit-tests, etc.)
> 
> v2->v3:
>   * Change the way of building root_hpa by following the existing flow (Sean)
> 
> v1->v2:
>   * Remove v1's arch-specific get_tdp_level() and add a new parameter,
>     tdp_forced_root_level, to allow forced TDP level (Sean)
>   * Add additional comment on tdp_root table chaining trick and change the
>     PML root table allocation code (Sean)
>   * Revise Patch 1's commit msg (Sean and Jim)
> 
> Thanks,
> -Wei
> 
> Wei Huang (3):
>    KVM: x86: Allow CPU to force vendor-specific TDP level
>    KVM: x86: Handle the case of 5-level shadow page table
>    KVM: SVM: Add 5-level page table support for SVM
> 
>   arch/x86/include/asm/kvm_host.h |  6 ++--
>   arch/x86/kvm/mmu/mmu.c          | 56 ++++++++++++++++++++++-----------
>   arch/x86/kvm/svm/svm.c          | 13 ++++----
>   arch/x86/kvm/vmx/vmx.c          |  3 +-
>   4 files changed, 49 insertions(+), 29 deletions(-)
> 

Queued, thanks, with NULL initializations according to Tom's review.

Paolo

