Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7750D27923A
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 22:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgIYUdN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 16:33:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49458 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726037AbgIYUUa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 16:20:30 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601065228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OIVZsjCbRDX/aepPaR0Uwnnx59y20L2Av4pvbF4EM40=;
        b=GSYpUfWzF8jFtgNvZew2Y4eqSAROYcYvydg0S13akv/mVCtztmoKtSJe8/Tf24NZ49jv+M
        yTZ5NQOABJRBG+++uNI19k32C24WSaN+YuH6//U797g7c1RFXU/VTdfqjfmsPyD7rf0RS6
        mdbl+ZxXrh4iWkQcZ1HtW2nN0AlyChE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-d5a8gA73MwCwoTO2iabhQA-1; Fri, 25 Sep 2020 15:50:05 -0400
X-MC-Unique: d5a8gA73MwCwoTO2iabhQA-1
Received: by mail-wm1-f72.google.com with SMTP id c200so35023wmd.5
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 12:50:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OIVZsjCbRDX/aepPaR0Uwnnx59y20L2Av4pvbF4EM40=;
        b=DL/dYwpbE3QeTRw66Bse2gvhnq4Nb6XQd1k7gBSHpj/ETtkdq9kaivfd3K+Dw/PIUC
         lhDKw+2U41KKXIGQxnIyapk+caM3/WTTl9I5MZAToBDFGTaTUQtkDrMdmnR2O1gmKjTL
         D8LCRZ3yusRnSpa9jU5hWOxUbcaXZMngdo55rR6PseRgNiQ9uTkQ8TDf98IuK24EXcXn
         e48EiZ/TSoPEXhcAxTJ6VQWcVDXM6PMYNpHT3GZhLVBuCRF8/GgXfGnms6P9mNjczChf
         X2OfpeDHTF+scr/E5uwp+SNoEvFCbB2AvTdw2TQrUgSHoyQY2Jt/0YBnaKb69DjeRhow
         2tbA==
X-Gm-Message-State: AOAM533IAe6CKjjpKuPiBXwMtMRvH3soDEjgcOqo6g8eiz2iet3MAGIA
        RgrN6bYzuiOBI7sXOBoTId2ysvTTMFeOl168MHQXj12yhhLJVfEmjwWVGjo/B2hTa6cWizd9fbr
        OPRleoZ/0kOky
X-Received: by 2002:adf:e407:: with SMTP id g7mr6102470wrm.349.1601063404440;
        Fri, 25 Sep 2020 12:50:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2BKPdK568rDKnVy0f3oYUrL5JAXlwiTjQ7YwfwmKIieoyeOCAVT75UmfZAbM9RySzYJX0EA==
X-Received: by 2002:adf:e407:: with SMTP id g7mr6102444wrm.349.1601063404156;
        Fri, 25 Sep 2020 12:50:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id u186sm75789wmu.34.2020.09.25.12.50.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 12:50:03 -0700 (PDT)
Subject: Re: [PATCH v3 0/5] KVM: VMX: Clean up RTIT MAXPHYADDR usage
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200924194250.19137-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3f694762-6b8c-be1b-c0f0-5f7897866b66@redhat.com>
Date:   Fri, 25 Sep 2020 21:50:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200924194250.19137-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/20 21:42, Sean Christopherson wrote:
> Stop using cpuid_query_maxphyaddr() for a random RTIT MSR check, unexport
> said function to discourage future use, and do additional related cleanup.
> 
> Paolo, feel free to reorder/squash these as you see fit.  Five patches
> feels more than a bit gratuitous, but every time I tried to squash things
> I ended up with changelogs that ran on and on...
> 
> v2:
>   - Rebased to kvm/queue, commit e1ba1a15af73 ("KVM: SVM: Enable INVPCID
>     feature on AMD").
> 
> Sean Christopherson (5):
>   KVM: VMX: Use precomputed MAXPHYADDR for RTIT base MSR check
>   KVM: x86: Unexport cpuid_query_maxphyaddr()
>   KVM: VMX: Replace MSR_IA32_RTIT_OUTPUT_BASE_MASK with helper function
>   KVM: x86: Move illegal GPA helper out of the MMU code
>   KVM: VMX: Use "illegal GPA" helper for PT/RTIT output base check
> 
>  arch/x86/kvm/cpuid.c   |  1 -
>  arch/x86/kvm/cpuid.h   |  5 +++++
>  arch/x86/kvm/mmu.h     |  5 -----
>  arch/x86/kvm/mmu/mmu.c |  2 +-
>  arch/x86/kvm/vmx/vmx.c | 13 ++++++++-----
>  5 files changed, 14 insertions(+), 12 deletions(-)
> 

Queued, thanks.

Paolo

