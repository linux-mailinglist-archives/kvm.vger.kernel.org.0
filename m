Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F041F3767
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 11:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgFIJ5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 05:57:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45927 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728570AbgFIJ5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jun 2020 05:57:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591696669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ibKboGqiSHs1nijcwRb9DLkPlnX80F1iqE0itbybiSs=;
        b=bUFzZ32AEZXPXvaT9y4HYDsA7d3FKJ2MSMrdaT4nop3E+ro/vflHraMeoYXso7xRPydQv9
        zfJVF2h5dEGrCtk2TpKvQ9U4prqs2El2VwvMee2XZkP83Gc74IvtjEEsMPXuP8D3m4ai66
        uzD2DdYPx+DAPZOW902LvJXB8mpfBGM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-83KFp1dBNmyGU3FRfD454Q-1; Tue, 09 Jun 2020 05:57:46 -0400
X-MC-Unique: 83KFp1dBNmyGU3FRfD454Q-1
Received: by mail-wr1-f71.google.com with SMTP id l18so8451278wrm.0
        for <kvm@vger.kernel.org>; Tue, 09 Jun 2020 02:57:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ibKboGqiSHs1nijcwRb9DLkPlnX80F1iqE0itbybiSs=;
        b=DDDdiCF2q/hBh7h6uCmeLtVLUkoUoQyyoBLn1c3nGixSyc2vzk3VxYSckaUzvtilpF
         1r2YzQ0TMSz3f6XGu+oFt5UkEf4/sU5QNRk4t/CSbaYbR5znSRVTqp5DQ5SgbXrzuTUU
         LQ4td6Fl+Cfme/8RWs/hDwkVYA/Tg7sU8aSj7mCCjAU5FOjOy8RiOueOK4XTUxLc1/Vv
         hAt94c8VOkW6sAvCSKEOmPzvI/k/wPAttmt8K/Rx709sfFDJIOzmFATnrkR+vVmDKJBs
         rU2QOWFYGRtTPFmdG9P04yeXOxBnJxWS9hgLeT2KlK9OkncP+oVRo5agqC3Spotf/iDO
         cLlQ==
X-Gm-Message-State: AOAM532z9pnQdyd7GGDNt9issPtoqoN7dB2MKDXN2ZoCAJRP5EPfocvz
        OTuZbPdlSrzCO02lelbFyC4Sq3A6IuO7HJ1H2bDEU6s0j73hh7dMhxb7nqBYkeG2ZwO6ZkeEiE2
        J8YypRmTPkkOV
X-Received: by 2002:adf:fe07:: with SMTP id n7mr3395318wrr.240.1591696665234;
        Tue, 09 Jun 2020 02:57:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwtipR1s180DRqzHexaQK8/Pl5cmXEYzJQ9vM4Nx4WXQAdi8dM4n59u6aYCvm3glAXpAyFksA==
X-Received: by 2002:adf:fe07:: with SMTP id n7mr3395299wrr.240.1591696665042;
        Tue, 09 Jun 2020 02:57:45 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.172.168])
        by smtp.gmail.com with ESMTPSA id t14sm2849805wrb.94.2020.06.09.02.57.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2020 02:57:44 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: x86: Unexport x86_fpu_cache and make it static
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200608180218.20946-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8f94b6f1-d7f8-60d8-1d2e-59706ec8c763@redhat.com>
Date:   Tue, 9 Jun 2020 11:57:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200608180218.20946-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/06/20 20:02, Sean Christopherson wrote:
> Make x86_fpu_cache static now that FPU allocation and destruction is
> handled entirely by common x86 code.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> 
> v2: Rebased to kvm/queue, commit fb7333dfd812 ("KVM: SVM: fix calls ...").
> 
>  arch/x86/include/asm/kvm_host.h | 1 -
>  arch/x86/kvm/x86.c              | 3 +--
>  2 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1da5858501ca..7030f2221259 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1306,7 +1306,6 @@ struct kvm_arch_async_pf {
>  extern u64 __read_mostly host_efer;
>  
>  extern struct kvm_x86_ops kvm_x86_ops;
> -extern struct kmem_cache *x86_fpu_cache;
>  
>  #define __KVM_HAVE_ARCH_VM_ALLOC
>  static inline struct kvm *kvm_arch_alloc_vm(void)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c26dd1363151..e19f7c486d64 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -239,8 +239,7 @@ u64 __read_mostly host_xcr0;
>  u64 __read_mostly supported_xcr0;
>  EXPORT_SYMBOL_GPL(supported_xcr0);
>  
> -struct kmem_cache *x86_fpu_cache;
> -EXPORT_SYMBOL_GPL(x86_fpu_cache);
> +static struct kmem_cache *x86_fpu_cache;
>  
>  static struct kmem_cache *x86_emulator_cache;
>  
> 

Queued, thanks.

Paolo

