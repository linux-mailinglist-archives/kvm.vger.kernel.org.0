Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF04233B2D
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 00:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbgG3WSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 18:18:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49065 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728110AbgG3WSY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 18:18:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596147502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OHlPvXY5r8GpAstWTsHHnLvHA/eSZd9buijhWGMebrs=;
        b=YqSJKkY74k4amTqlpPtxnzbgKPLARNWHKr/AqxYsxUUceltcm69XbdgqbAIFMJrgw8W0JS
        8nxuXRWdS+CnCv+Hak6J+vPVPFPcNZM4d3idjyEOZntDL8h1GKp0is6y3XI+C/jOoefykH
        24nMYjI/Lqq1hq7LBEyp8xURg/8frU0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-tubFfEaNO2yXlqPXY8VyVA-1; Thu, 30 Jul 2020 18:18:21 -0400
X-MC-Unique: tubFfEaNO2yXlqPXY8VyVA-1
Received: by mail-wm1-f71.google.com with SMTP id l5so2643904wml.7
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 15:18:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OHlPvXY5r8GpAstWTsHHnLvHA/eSZd9buijhWGMebrs=;
        b=MC+Bimd1/zD1pcV9gjFvitwou7X3WztMgeKVrVKBz3vNbrst87r8VazmfsB0C/l9Nr
         h6N/UqJOVXy+5SFgbH1Yuyy6eegTEzEvbr+T0X6BDZFJAGT/Myc0sZFq+MK54XlLjJM3
         6UCxl3n4c8qIYv65fqfQzXay18T3jCM2PhKi0tP54gpg+ZZNP6dI6UbOp+NvjAbkwi+b
         t4v6TXGlMT4PnhZWwXBxuHb/E/tdB6cVHgf+gf8GuJtxgQM39G1vT2v7BQB6mDRBXcJw
         +aHoCCOso0rmJ54PB23qyPwipy5gDMIZlwdLGuBpGGXL/1aT0+rXt81BGYOrS0nLj9ra
         wG8g==
X-Gm-Message-State: AOAM531FGLnGnynZgBShHfOso3/8/ld5O9YWRPoCa2D6hfOiWAKQuqyh
        HNioMD48+Kg1Q1QBHCf1qE6QPpZF4umxAWu7c0ymJyP9yawUsJsPr9Tjjy+Zjc/FOonbC+BZpwq
        ZE3ZudpxyoprE
X-Received: by 2002:adf:fd91:: with SMTP id d17mr654741wrr.234.1596147499683;
        Thu, 30 Jul 2020 15:18:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXntMW1aXxzBuJoRLRbqWwGtvoK9BLwCPhKA25oLBfVj0O8s1h/uYA3kJIGxEV3HLW8xbeeg==
X-Received: by 2002:adf:fd91:: with SMTP id d17mr654731wrr.234.1596147499442;
        Thu, 30 Jul 2020 15:18:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:310b:68e5:c01a:3778? ([2001:b07:6468:f312:310b:68e5:c01a:3778])
        by smtp.gmail.com with ESMTPSA id z6sm11706927wml.41.2020.07.30.15.18.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 15:18:18 -0700 (PDT)
Subject: Re: [PATCH 0/9] KVM: x86: TDP level cleanups and shadow NPT fix
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200716034122.5998-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6249777c-8adb-51ca-2d40-4b9a7583b41f@redhat.com>
Date:   Fri, 31 Jul 2020 00:18:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200716034122.5998-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/07/20 05:41, Sean Christopherson wrote:
> The primary purpose of this series is to implement a suggestion from Paolo
> to have the MMU make the decision between 4 and 5 level EPT/TDP (when
> 5-level page tables are supported).  Having the MMU "own" the decision of
> whether or not to use 5-level paging leads to a variety of nice cleanups,
> and ultimately gets rid of another kvm_x86_ops.
> 
> Patch 1 is a fix for SVM's shadow NPT that is compile tested only.  I
> don't know enough about the shadow NPT details to know if it's a "real"
> bug or just a supericial oddity that can't actually cause problems.
> 
> "Remove temporary WARN on expected vs. actual EPTP level mismatch" could
> easily be squashed with "Pull the PGD's level from the MMU instead of
> recalculating it", I threw it in as a separate patch to provide a
> bisection helper in case things go sideways.
> 
> Sean Christopherson (9):
>   KVM: nSVM: Correctly set the shadow NPT root level in its MMU role
>   KVM: x86/mmu: Add separate helper for shadow NPT root page role calc
>   KVM: VMX: Drop a duplicate declaration of construct_eptp()
>   KVM: VMX: Make vmx_load_mmu_pgd() static
>   KVM: x86: Pull the PGD's level from the MMU instead of recalculating
>     it
>   KVM: VXM: Remove temporary WARN on expected vs. actual EPTP level
>     mismatch
>   KVM: x86: Dynamically calculate TDP level from max level and
>     MAXPHYADDR
>   KVM: x86/mmu: Rename max_page_level to max_huge_page_level
>   KVM: x86: Specify max TDP level via kvm_configure_mmu()
> 
>  arch/x86/include/asm/kvm_host.h |  9 ++---
>  arch/x86/kvm/cpuid.c            |  2 --
>  arch/x86/kvm/mmu.h              | 10 ++++--
>  arch/x86/kvm/mmu/mmu.c          | 63 +++++++++++++++++++++++++--------
>  arch/x86/kvm/svm/nested.c       |  1 -
>  arch/x86/kvm/svm/svm.c          |  8 ++---
>  arch/x86/kvm/vmx/nested.c       |  2 +-
>  arch/x86/kvm/vmx/vmx.c          | 31 +++++++---------
>  arch/x86/kvm/vmx/vmx.h          |  6 ++--
>  arch/x86/kvm/x86.c              |  1 -
>  10 files changed, 81 insertions(+), 52 deletions(-)
> 

Queued, thanks.

Paolo

