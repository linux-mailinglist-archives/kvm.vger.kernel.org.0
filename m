Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D001E78B0
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 10:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgE2Irh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 04:47:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26749 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725306AbgE2Irf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 04:47:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590742052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TC044dR3OSla2e2jOr1hQDaPo8ct77ckTcoEOVeGup0=;
        b=CJYT857G9/uAraNWVtqDhmlqH9BXvruieAp9I7d9Lm+Mh4cwT1kUH625lwg9W2Qu/bHlg4
        cxOuCAalYxAi5S+L91kgHs4CwS2KxOVIuyXwd3+Ez4XWoeyLRocq6yphZF3AE5uGfnzICr
        /x8hWSjfTPsSVGtcNDOBI5oraE3iYPI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-jYdTv1VlN76LjPtIumRg9Q-1; Fri, 29 May 2020 04:47:30 -0400
X-MC-Unique: jYdTv1VlN76LjPtIumRg9Q-1
Received: by mail-wr1-f70.google.com with SMTP id n6so762820wrv.6
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 01:47:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TC044dR3OSla2e2jOr1hQDaPo8ct77ckTcoEOVeGup0=;
        b=YR7xHvjLcKwF2BdEVSIIydZ39tQCBja6zRE5DQlyQ5DYPSl2FSsbAC/CWYpgd65j1A
         U5i2W20F92bL8S/TW3qa3Jp2m+SHJSDAMH5N+VBL+ZiEa2LmHvPEJFAFkB48x01/6U2k
         zIpq/cH1P0OYKmsLvyoayFImgb2d9kiYJXrS44Mc/WmKDoKg7i1VgjIouoj+h/Ost081
         PlfxTiZ9XRugUp8v85kZWuHwfYNfK+9Gdc8JCiRaV3Fir4A/Xgye4ZqSMiVWi9Tk4l6H
         clUmZavTvlmSmZXnjHGQhgnIPKOx4EpCKt2RBG2+Wa/XIFHeTGyV3TPme8U2seHJhnGd
         rIRw==
X-Gm-Message-State: AOAM530/SnzPKZHMpUaYsU7lcSn9k2ar5n/8PZZBO3icEq+2TD8NNcep
        EipsbDFCQx6ASGACW57KvuyF8z73ZH17hulrfXr5u2uQZ+9wrgniHJ+J3lLqlZtBQOMRXRmm1I4
        N6EUNCOCjv1tK
X-Received: by 2002:adf:a55e:: with SMTP id j30mr8410866wrb.60.1590742048998;
        Fri, 29 May 2020 01:47:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJymqvTlBW+7kW1wAuWaPZwjkZSe8LlrehYX8zniYkylzs7yqPj5Jm1359wcy8rb0GyyAgXDrw==
X-Received: by 2002:adf:a55e:: with SMTP id j30mr8410839wrb.60.1590742048779;
        Fri, 29 May 2020 01:47:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b096:1b7:7695:e4f7? ([2001:b07:6468:f312:b096:1b7:7695:e4f7])
        by smtp.gmail.com with ESMTPSA id h137sm12589680wme.0.2020.05.29.01.47.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 01:47:28 -0700 (PDT)
Subject: Re: [PATCH RESEND] Enable full width counting for KVM: x86/pmu
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200529074347.124619-1-like.xu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8ff77a5b-21fd-31f0-b97c-d188ec776808@redhat.com>
Date:   Fri, 29 May 2020 10:47:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200529074347.124619-1-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/05/20 09:43, Like Xu wrote:
> Hi Paolo,
> 
> As you said, you will queue the v3 of KVM patch, but it looks like we
> are missing that part at the top of the kvm/queue tree.
> 
> For your convenience, let me resend v4 so that we can upstream this
> feature in the next merged window. Also this patch series includes
> patches for qemu and kvm-unit-tests. Please help review.
> 
> Previous:
> https://lore.kernel.org/kvm/f1c77c79-7ff8-c5f3-e011-9874a4336217@redhat.com/
> 
> Like Xu (1):
>   KVM: x86/pmu: Support full width counting
>   [kvm-unit-tests] x86: pmu: Test full-width counter writes 
>   [Qemu-devel] target/i386: define a new MSR based feature
>  word - FEAT_PERF_CAPABILITIES
> 
> Wei Wang (1):
>   KVM: x86/pmu: Tweak kvm_pmu_get_msr to pass 'struct msr_data' in
> 
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/cpuid.c            |  2 +-
>  arch/x86/kvm/pmu.c              |  4 +-
>  arch/x86/kvm/pmu.h              |  4 +-
>  arch/x86/kvm/svm/pmu.c          |  7 ++--
>  arch/x86/kvm/vmx/capabilities.h | 11 +++++
>  arch/x86/kvm/vmx/pmu_intel.c    | 71 +++++++++++++++++++++++++++------
>  arch/x86/kvm/vmx/vmx.c          |  3 ++
>  arch/x86/kvm/x86.c              |  6 ++-
>  9 files changed, 87 insertions(+), 22 deletions(-)
> 

Thanks, I was busy with AMD stuff as you saw. :)  I've queued it now.

Paolo

