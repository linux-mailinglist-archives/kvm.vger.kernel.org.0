Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A75DF17063D
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 18:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgBZRiP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 12:38:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53910 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726631AbgBZRiP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 12:38:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582738693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JIvcJetTmqzJRCF3gD6AW+GFXpGbWVjJD/mid1Qq4MM=;
        b=J0Mn0wyCTuH7+5B9M+G8ChJNIA7Ttdfma0nYtxklvGXK60hAZ8UouckjOIk/TtQnGgQ2Z3
        hhT7HRPTQf0FKImOhgFcAB3Q03CHpQFt7fmSNX80lUZnRQcvpmd4UYGsiGbIlrw3NvBmqO
        Tka3sAgpyilY38GSKeGA80d5D8jJXDc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-P8RxZXrRMa67lIlpcMcHZg-1; Wed, 26 Feb 2020 12:38:12 -0500
X-MC-Unique: P8RxZXrRMa67lIlpcMcHZg-1
Received: by mail-wr1-f70.google.com with SMTP id s13so72862wru.7
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 09:38:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=JIvcJetTmqzJRCF3gD6AW+GFXpGbWVjJD/mid1Qq4MM=;
        b=cdVvkgNaBvqwypgXiQ83NXwvh/vptVweCRkU+9EcPNpKCj8Ygtm8L1n4Tz+wvODLdG
         M8k+VYgh/PJpe9FHwFoAE1jgoR69Qdjbg6clLsx5toxvBckivQE8I3Vw8BTrPupcolkR
         rLyn83tFIU2ljud/4rILUIxMFBEzGzrX9UC+gaDw0tmZh/NW0/tNDdT9uDieWz63Qvvh
         f0zJiu2BRs/8VdhC2DeYCvU/v5Z2KX5ZDDSRf7ynHWWIWCSzr6D1AnceJRKZkoqb4hBn
         zEeYzq3D3v/GVH61DHCFrBlvfNlCyngdT7KT0rZieymLhf5Avf8XYd6jAgIARmDSciGr
         QKow==
X-Gm-Message-State: APjAAAXE0ZTTDiMe9+QWYiwK+7IqY0UkIgydPh1P96oAd7KsZ5GWM6im
        ApVa9+W/PGEPfSS508mCfs+Xxk4LtkYm0JKFZwHQfE+xNIra5mlwoFxUosDVcuT6rLIfry96vEb
        auUqNxnYJWh4i
X-Received: by 2002:adf:cd03:: with SMTP id w3mr6741585wrm.191.1582738690459;
        Wed, 26 Feb 2020 09:38:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqzrY86IU6qo6nd3QByKKtzOkBd7TWA9gnCHxcFLnRePpBlQv+dnI0/gyCoFAKIAUZZdreP2kg==
X-Received: by 2002:adf:cd03:: with SMTP id w3mr6741568wrm.191.1582738690226;
        Wed, 26 Feb 2020 09:38:10 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id z1sm3649957wmf.42.2020.02.26.09.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 09:38:09 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 09/13] KVM: x86: Move kvm_emulate.h into KVM's private directory
In-Reply-To: <20200218232953.5724-10-sean.j.christopherson@intel.com>
References: <20200218232953.5724-1-sean.j.christopherson@intel.com> <20200218232953.5724-10-sean.j.christopherson@intel.com>
Date:   Wed, 26 Feb 2020 18:38:08 +0100
Message-ID: <87tv3di70f.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Now that the emulation context is dynamically allocated and not embedded
> in struct kvm_vcpu, move its header, kvm_emulate.h, out of the public
> asm directory and into KVM's private x86 directory.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h             | 5 ++++-
>  arch/x86/kvm/emulate.c                      | 2 +-
>  arch/x86/{include/asm => kvm}/kvm_emulate.h | 0
>  arch/x86/kvm/mmu/mmu.c                      | 1 +
>  arch/x86/kvm/x86.c                          | 1 +
>  arch/x86/kvm/x86.h                          | 1 +
>  6 files changed, 8 insertions(+), 2 deletions(-)
>  rename arch/x86/{include/asm => kvm}/kvm_emulate.h (100%)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e069f71667b1..0dfe11f30d7f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -182,7 +182,10 @@ enum exit_fastpath_completion {
>  	EXIT_FASTPATH_SKIP_EMUL_INS,
>  };
>  
> -#include <asm/kvm_emulate.h>
> +struct x86_emulate_ctxt;

Not this patchset's problem (and particular forward declaration is
likely needed), but 

$ grep 'struct x86_emulate_ctxt' arch/x86/include/asm/kvm_host.h
struct x86_emulate_ctxt;
	struct x86_emulate_ctxt *emulate_ctxt;
struct x86_emulate_ctxt;

The second forward declaration is not needed and this patch (or
patchset) may be a good place to get rid of it)

> +struct x86_exception;
> +enum x86_intercept;
> +enum x86_intercept_stage;
>  
>  #define KVM_NR_MEM_OBJS 40
>  
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 1e394cb190ce..0bceb3f71220 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -20,7 +20,7 @@
>  
>  #include <linux/kvm_host.h>
>  #include "kvm_cache_regs.h"
> -#include <asm/kvm_emulate.h>
> +#include "kvm_emulate.h"
>  #include <linux/stringify.h>
>  #include <asm/fpu/api.h>
>  #include <asm/debugreg.h>
> diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> similarity index 100%
> rename from arch/x86/include/asm/kvm_emulate.h
> rename to arch/x86/kvm/kvm_emulate.h
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7011a4e54866..d9064be28089 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -19,6 +19,7 @@
>  #include "mmu.h"
>  #include "x86.h"
>  #include "kvm_cache_regs.h"
> +#include "kvm_emulate.h"
>  #include "cpuid.h"
>  
>  #include <linux/kvm_host.h>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5ab7d4283185..370af9fe0f5b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -22,6 +22,7 @@
>  #include "i8254.h"
>  #include "tss.h"
>  #include "kvm_cache_regs.h"
> +#include "kvm_emulate.h"
>  #include "x86.h"
>  #include "cpuid.h"
>  #include "pmu.h"
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 8409842a25d9..f3c6e55eb5d9 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -5,6 +5,7 @@
>  #include <linux/kvm_host.h>
>  #include <asm/pvclock.h>
>  #include "kvm_cache_regs.h"
> +#include "kvm_emulate.h"
>  
>  #define KVM_DEFAULT_PLE_GAP		128
>  #define KVM_VMX_DEFAULT_PLE_WINDOW	4096

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

