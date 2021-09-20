Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0DA84115D5
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 15:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbhITNcm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 09:32:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40056 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230072AbhITNcm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 09:32:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632144675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xz1yHvJT5G0H7LDF/uZnPMGXqDofxfq2CbtHSEBu2sk=;
        b=c07ygDcbu2CzBFVPzNYtvzDQoKV5uAmnp3TPG/xmd/MV1uuUBF48ME9cgvjgflPMZ2lH3X
        yNfEsGik4hmJVdUwLpZ3Ks+X8bafpc8YrzpUAwLL5TqrD6trfUWi3pCmt2CmnZC/loIRhf
        lsCeDfWuwR6G3ZK9th4gGRH+Y900VtM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-aEcUDycKOtalwTP0GGlfpw-1; Mon, 20 Sep 2021 09:31:13 -0400
X-MC-Unique: aEcUDycKOtalwTP0GGlfpw-1
Received: by mail-ed1-f72.google.com with SMTP id d1-20020a50f681000000b003d860fcf4ffso2889504edn.22
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 06:31:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xz1yHvJT5G0H7LDF/uZnPMGXqDofxfq2CbtHSEBu2sk=;
        b=IRfil1A2/NplsImZ87K3XOb3qOoeZ4b6/5uJRe1dp7RP+V3/SkQwP1KUsFOSYgdF0S
         RDq9CPkYDXgbPKCn/SxEA8bpb+t6pP+gtegPjAUoR5MH4eFmgaj1eOLVOu4mXINBtzVk
         lwhlMHkY9DEqzMiKOLN2T/xLmyE+DPq370rU6Jx3ArANm9A2olv2rTKZM0x9tmsABrii
         RU7ywXKBUUKnslwJg2Qt5w/MHEQrV/swZSrPUOXsWB7YD+qKlbM9Mx+zENms3lwiBBK/
         fSh9NaVbFEGU6gXfBzAaP881Hl0g3K98cmRggAcDwU5I7g3OpO3wImrz/foqzNVzNYlj
         +gig==
X-Gm-Message-State: AOAM531/CcZBwyFRxn7c3FA+d9zoFVyhjgpHgtRGqfj1EutFzb5Zg+Pi
        05L0GRPvBctyLdybuIx0DJ07VLSBP/W+WDG22KdTBqL3f9TYWhN4GuWygo1PEhn+tuJ4JPnGcfD
        03vYs3pr++FIV
X-Received: by 2002:a17:906:3854:: with SMTP id w20mr27327201ejc.537.1632144671352;
        Mon, 20 Sep 2021 06:31:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGXwIILRfcZIcuNMjTC0OYZlD8U2iRcDRsn9jNsaRBkPErPU3iHJcHI4ysvtjAFHIkhD3StA==
X-Received: by 2002:a17:906:3854:: with SMTP id w20mr27327186ejc.537.1632144671151;
        Mon, 20 Sep 2021 06:31:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n19sm3401902ejl.78.2021.09.20.06.31.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 06:31:10 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v3 0/7] x86: Fix duplicate symbols w/ clang
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Bill Wendling <morbo@google.com>
References: <20210909183207.2228273-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8e3f9f5a-77cf-5ad6-f5fd-7cb5cf85852b@redhat.com>
Date:   Mon, 20 Sep 2021 15:31:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210909183207.2228273-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/09/21 20:32, Sean Christopherson wrote:
> Add a "noinline" macro to mirror the kernel's wrapping of the attribute
> and to save typing, and use it to fix a variety of duplicate symbol errors
> that pop up with some versions of clang due to clang aggressively inlining
> functions that define globally visible labels in inline asm blobs.
> 
> Bill Wendling (5):
>    lib: define the "noinline" macro
>    x86: realmode: mark exec_in_big_real_mode as noinline
>    x86: svm: mark test_run as noinline
>    x86: umip: mark do_ring3 as noinline
>    x86: vmx: mark some test_* functions as noinline
> 
> Sean Christopherson (2):
>    lib: Drop x86/processor.h's barrier() in favor of compiler.h version
>    lib: Move __unused attribute macro to compiler.h
> 
>   lib/libcflat.h       | 3 +--
>   lib/linux/compiler.h | 2 ++
>   lib/x86/processor.h  | 5 -----
>   x86/pmu_lbr.c        | 4 ++--
>   x86/realmode.c       | 4 +++-
>   x86/svm.c            | 2 +-
>   x86/umip.c           | 2 +-
>   x86/vmx.c            | 6 +++---
>   8 files changed, 13 insertions(+), 15 deletions(-)
> 

Queued, thanks.

Paolo

