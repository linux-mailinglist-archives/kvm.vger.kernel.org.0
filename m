Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E332F8031
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 17:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbhAOQDy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 11:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbhAOQDx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 11:03:53 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92330C061757
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 08:03:11 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id md11so5312672pjb.0
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 08:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fCPfG9LsFbF5pUdBcRPDC/qyAT9h91VaEcLXFtL/FYM=;
        b=igXXWkIXfwa49Tbt4D9HiBBBGrQ0B0aRunRux6EHOhRS8MW509ZPQacLnhBIwIvz7C
         iYBAi9ZFq6MvNdnMl4DIy4c8q9N14T1oMRmYZ+qsGil504S+9hNx5NPv0gbFUItBaBhP
         U3t13nMfJb9iouTwaNsy06ja/RewHu4tWYDEgjFSzy9ueVhI+rySrsMf7kFOVrPE88Du
         Wv2SDy9p6D47yfmMYrHVl9lar6MvqSu/A1jh9wJ5Z4JxjNuX6EgVtzqhVXEJjQrm7WPj
         zx+dSoBznIWwtgmoTsfbf7LXLZVAK8wThAWen9sO2awtJuVvAcvxT8i+O4wAjjLYio6u
         g7MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fCPfG9LsFbF5pUdBcRPDC/qyAT9h91VaEcLXFtL/FYM=;
        b=LFPyy+bzzboAWLUuRf+AxqUVb00iANkFdGE6USxw7jjyEqt9bsMW8BcHak1B8NZ3t1
         aBIm2HCnPGGP0LMfnbjcRx5rIuynlJQo4yAYyhicx08R5dynCf6wGe+HkAcTvpzejOaY
         jwVd9ZCCW/DKd0RRjezMqMs/PBVUbp+nDa6qlIanhGg8ua8m0NGDclV3Fp8bHf2l4tM7
         CX1q44MjrCz5xFtz1QU7QqG9Yo9vKlZOHljFiBYwX19v/PH9a+tdZ5n2iqHqvj1nExev
         L3pNAFmkSNTe/hPbSr40pDhBb8ZX734cmXe2QSyiZ66BleGuilAUVRI2nMuDV/jzxbW1
         dpVw==
X-Gm-Message-State: AOAM5321YRGEJbqFzbkinJxmpTRizEeH0buVTF98pCuXfBcRfyDU9N2i
        kH5HNWjeuDFYMfDlqOdcbmbvTw==
X-Google-Smtp-Source: ABdhPJzH0DTNaRVayRcAM4sw1+MDLXHE1m25YRMHjehHEym5VD9/5Uwt0k6RPiO/fgDodZc4m7hNiw==
X-Received: by 2002:a17:90a:5308:: with SMTP id x8mr11212677pjh.151.1610726590886;
        Fri, 15 Jan 2021 08:03:10 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id 123sm8866593pgf.38.2021.01.15.08.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 08:03:09 -0800 (PST)
Date:   Fri, 15 Jan 2021 08:03:03 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH RFC 0/4] KVM: x86: Drastically raise KVM_USER_MEM_SLOTS
 limit
Message-ID: <YAG8t9ww/dgFaFht@google.com>
References: <20210115131844.468982-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115131844.468982-1-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 15, 2021, Vitaly Kuznetsov wrote:
> TL;DR: any particular reason why KVM_USER_MEM_SLOTS is so low?

Because memslots were allocated statically up until fairly recently (v5.7), and
IIRC consumed ~92kb.  Doubling that for every VM would be quite painful. 

> Longer version:
> 
> Current KVM_USER_MEM_SLOTS limit (509) can be a limiting factor for some
> configurations. In particular, when QEMU tries to start a Windows guest
> with Hyper-V SynIC enabled and e.g. 256 vCPUs the limit is hit as SynIC
> requires two pages per vCPU and the guest is free to pick any GFN for
> each of them, this fragments memslots as QEMU wants to have a separate
> memslot for each of these pages (which are supposed to act as 'overlay'
> pages).

What exactly does QEMU do on the backend?  I poked around the code a bit, but
didn't see anything relevant.

> Memory slots are allocated dynamically in KVM when added so the only real
> limitation is 'id_to_index' array which is 'short'. We don't have any
> KVM_MEM_SLOTS_NUM/KVM_USER_MEM_SLOTS-sized statically defined arrays.
> 
> We could've just raised the limit to e.g. '1021' (we have 3 private
> memslots on x86) and this should be enough for now as KVM_MAX_VCPUS is
> '288' but AFAIK there are plans to raise this limit as well.
> 
> Vitaly Kuznetsov (4):
>   KVM: x86: Drop redundant KVM_MEM_SLOTS_NUM definition
>   KVM: mips: Drop KVM_PRIVATE_MEM_SLOTS definition
>   KVM: Define KVM_USER_MEM_SLOTS in arch-neutral
>     include/linux/kvm_host.h
>   KVM: x86: Stop limiting KVM_USER_MEM_SLOTS
> 
>  arch/mips/include/asm/kvm_host.h | 2 --
>  arch/x86/include/asm/kvm_host.h  | 3 +--
>  include/linux/kvm_host.h         | 4 ++++
>  3 files changed, 5 insertions(+), 4 deletions(-)
> 
> -- 
> 2.29.2
> 
