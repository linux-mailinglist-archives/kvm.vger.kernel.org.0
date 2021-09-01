Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0758C3FD4D9
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 10:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242892AbhIAIDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 04:03:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43062 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242777AbhIAIDZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Sep 2021 04:03:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630483342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t+nKp+2THLvSwMHH3W4CrKkRm3I1qSRf6x+wufAoR9s=;
        b=Oz5jeKCAnuus8kYw08v42x2F5qTT6zd5pfQo+8tbCSk/BYOmxphW6lpWgjYynmeZDwaOoV
        mXy8RbVyfpKlHRcFCPgOOGPLDmHRJBjRITNfBtsk7oeicl51xpT/E8rdwBpleOMYdtCPKX
        WV+jke7yPgpHAJeiEzj0uN/jUOcwKLk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-6uorYyM-PkaC9-6yoRp6Zw-1; Wed, 01 Sep 2021 04:02:21 -0400
X-MC-Unique: 6uorYyM-PkaC9-6yoRp6Zw-1
Received: by mail-wr1-f72.google.com with SMTP id t15-20020a5d42cf000000b001565f9c9ee8so519603wrr.2
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 01:02:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=t+nKp+2THLvSwMHH3W4CrKkRm3I1qSRf6x+wufAoR9s=;
        b=c6HY2x3av9PJSkiXq3/QbZsJGxIE0G8+c2Oc2CpLLM+OFSuWgtEBAE/8Y2iDQx7dJ5
         gACSMjInE7lEeIYtRmqyh3mwV7NaJvuzrEzCG6HLD0+o/Nlf8bsojURYDmrntTZOXslJ
         plsXJC9l7AV4Fydc1OimaGUCJogeoUFvtnF8yQlMp9Xn5N5haZWGhptHC08qROXYHmB6
         nStNXA+9945ECP0FQ5sIU92Num2oEQGWFcbAylXvKfo4vPD42E9YbgSO1bTu8Jj5AHrP
         VHwuZFTLHBko8aU1SHOjukebdVdi7ahTJaXfyOufAlEaqjOVYfM2Y4JYk+VxFzkWm+7t
         X5Eg==
X-Gm-Message-State: AOAM531pwPyucHScPL5Lm5mmH5nL3ol9fUHxDtl2BVOaiZTpdOuOE+Ok
        JHVncSjt2lSBKVIgJ3cE6tNSgWoi8xlAH0mZdAuJV2GBU5ShMBqZJVMW1GWU7PQqcK7FVADTADY
        avTNjd5HAFXnp
X-Received: by 2002:a5d:6ac7:: with SMTP id u7mr36837467wrw.390.1630483339921;
        Wed, 01 Sep 2021 01:02:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzkgBHBDv1S3YvagSZoXp5l3fedPXVzobffJCjW2/eH1e6fx5TjBzQv0qkLZ40yg5JaZq4iw==
X-Received: by 2002:a5d:6ac7:: with SMTP id u7mr36837446wrw.390.1630483339679;
        Wed, 01 Sep 2021 01:02:19 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id h16sm20676700wre.52.2021.09.01.01.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 01:02:19 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] kvm: x86: Increase MAX_VCPUS to 710
In-Reply-To: <20210831204535.1594297-1-ehabkost@redhat.com>
References: <20210831204535.1594297-1-ehabkost@redhat.com>
Date:   Wed, 01 Sep 2021 10:02:18 +0200
Message-ID: <87sfyooh9x.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eduardo Habkost <ehabkost@redhat.com> writes:

> Support for 710 VCPUs has been tested by Red Hat since RHEL-8.4.
> Increase KVM_MAX_VCPUS and KVM_SOFT_MAX_VCPUS to 710.
>
> For reference, visible effects of changing KVM_MAX_VCPUS are:
> - KVM_CAP_MAX_VCPUS and KVM_CAP_NR_VCPUS will now return 710 (of course)
> - Default value for CPUID[HYPERV_CPUID_IMPLEMENT_LIMITS (00x40000005)].EAX
>   will now be 710
> - Bitmap stack variables that will grow:
>   - At kvm_hv_flush_tlb()  kvm_hv_send_ipi():
>     - Sparse VCPU bitmap (vp_bitmap) will be 96 bytes long
>     - vcpu_bitmap will be 92 bytes long
>   - vcpu_bitmap at bioapic_write_indirect() will be 92 bytes long
>     once patch "KVM: x86: Fix stack-out-of-bounds memory access
>     from ioapic_write_indirect()" is applied
>
> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index af6ce8d4c86a..f76fae42bf45 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -37,8 +37,8 @@
>  
>  #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
>  
> -#define KVM_MAX_VCPUS 288
> -#define KVM_SOFT_MAX_VCPUS 240
> +#define KVM_MAX_VCPUS 710

Out of pure curiosity, where did 710 came from? Is this some particular
hardware which was used for testing (weird number btw). Should we maybe
go to e.g. 1024 for the sake of the beauty of powers of two? :-)

> +#define KVM_SOFT_MAX_VCPUS 710

Do we really need KVM_SOFT_MAX_VCPUS which is equal to KVM_MAX_VCPUS?

Reading 

commit 8c3ba334f8588e1d5099f8602cf01897720e0eca
Author: Sasha Levin <levinsasha928@gmail.com>
Date:   Mon Jul 18 17:17:15 2011 +0300

    KVM: x86: Raise the hard VCPU count limit

the idea behind KVM_SOFT_MAX_VCPUS was to allow developers to test high
vCPU numbers without claiming such configurations as supported.

I have two alternative suggestions:
1) Drop KVM_SOFT_MAX_VCPUS completely.
2) Raise it to a higher number (e.g. 2048)

>  #define KVM_MAX_VCPU_ID 1023

1023 may not be enough now. I rememeber there was a suggestion to make
max_vcpus configurable via module parameter and this question was
raised:

https://lore.kernel.org/lkml/878s292k75.fsf@vitty.brq.redhat.com/

TL;DR: to support EPYC-like topologies we need to keep
 KVM_MAX_VCPU_ID = 4 * KVM_MAX_VCPUS

>  /* memory slots that are not exposed to userspace */
>  #define KVM_PRIVATE_MEM_SLOTS 3

-- 
Vitaly

