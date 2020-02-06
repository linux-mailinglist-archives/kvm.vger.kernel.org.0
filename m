Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC711154325
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 12:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbgBFLco (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 06:32:44 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41259 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727007AbgBFLco (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 06:32:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580988762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vfKiIFJre8rU6R84zmGnIBpFraIbyL/mEllIRLEr2yE=;
        b=GQJERPZ0KXDH8Ze/cdyg6++5x/oxB/1HD27g2dh603bCaJ1nxprHEz8iZoGhsLVRlwj9cn
        UiKumRjgFsg7P/8hZQlm7kFQHQ2ciRIKyDF12tnsN09kZk/reh0UP1EAb4QcPPIT25ihV4
        kCfbLTyErHcDVEP/SqEmBHtfDZPfRV4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-qVub004WN1qdBWx0WhJmng-1; Thu, 06 Feb 2020 06:32:41 -0500
X-MC-Unique: qVub004WN1qdBWx0WhJmng-1
Received: by mail-wr1-f71.google.com with SMTP id 90so3237911wrq.6
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 03:32:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=vfKiIFJre8rU6R84zmGnIBpFraIbyL/mEllIRLEr2yE=;
        b=SLW2ebFQDCH1/lISJ0GDzSoqLVbI/nb4XKjPD5aBd+7jfJ2nMq8+0guCSFnTB+XweC
         /E1+S6mpSN1FQCOqZJuyTzR3TZ3EcT5FlmfT6OeVnsVCla1cksLq/uIEZuUIhWYr8WPu
         dNrJ3wqf4uj9kv6M/YMU4ZuDXH8J3wim+AK4GddLY6vaPosJ6o+tVDUEkET32e1S3fIl
         aTPDCNalH36bt+qQB3953ufvi11LNZ7KnB+J4aPFTiuTK/ZttD/O3D4wEGcBj8GIlXJ5
         j1JG9Wzd8yyZJvpOC4nOg1PdDRtW41It45p1lOlkiXlpovzxcT1pQVe0KbCt6TIwXfeS
         UnwA==
X-Gm-Message-State: APjAAAWwiE/RLQoFUfE9m8y8DN02UTlAklPzEQrJiOOcZOiVg1HbW0jZ
        oNiembeXPwSo4TlIF0W6miDjo3WyDxKv6azz9XYo4b2oTkAQ0RBqzeH0bBaNfOC014uHulKO3gD
        +kaMplvrGOTyt
X-Received: by 2002:a1c:4c10:: with SMTP id z16mr4073521wmf.136.1580988760121;
        Thu, 06 Feb 2020 03:32:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqzBL/yven/IvonS1V+mhAoNkpl5Eby6Yd4zH8jRlVa4WeZjCniUuBZ76KTaqkY/l8KB+iTj7w==
X-Received: by 2002:a1c:4c10:: with SMTP id z16mr4073501wmf.136.1580988759907;
        Thu, 06 Feb 2020 03:32:39 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id e18sm3689392wrw.70.2020.02.06.03.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 03:32:39 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH] KVM: nVMX: Fix some comment typos and coding style
In-Reply-To: <1580956162-5609-1-git-send-email-linmiaohe@huawei.com>
References: <1580956162-5609-1-git-send-email-linmiaohe@huawei.com>
Date:   Thu, 06 Feb 2020 12:32:38 +0100
Message-ID: <87a75wgdd5.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> From: Miaohe Lin <linmiaohe@huawei.com>
>
> Fix some typos in the comments. Also fix coding style.
>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 +-
>  arch/x86/kvm/vmx/nested.c       | 5 +++--
>  2 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4dffbc10d3f8..8196a4a0df8b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -782,7 +782,7 @@ struct kvm_vcpu_arch {
>  
>  	/*
>  	 * Indicate whether the access faults on its page table in guest

Indicates?

> -	 * which is set when fix page fault and used to detect unhandeable
> +	 * which is set when fix page fault and used to detect unhandleable
>  	 * instruction.

I have to admit that shadow MMU in KVM is not my strong side but this
comment reads weird, I'd appreciate if someone could suggest a better
alternative.

>  	 */
>  	bool write_fault_to_shadow_pgtable;
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 657c2eda357c..e7faebccd733 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -544,7 +544,8 @@ static void nested_vmx_disable_intercept_for_msr(unsigned long *msr_bitmap_l1,
>  	}
>  }
>  
> -static inline void enable_x2apic_msr_intercepts(unsigned long *msr_bitmap) {
> +static inline void enable_x2apic_msr_intercepts(unsigned long *msr_bitmap)
> +{
>  	int msr;
>  
>  	for (msr = 0x800; msr <= 0x8ff; msr += BITS_PER_LONG) {
> @@ -1981,7 +1982,7 @@ static int nested_vmx_handle_enlightened_vmptrld(struct kvm_vcpu *vcpu,
>  	}
>  
>  	/*
> -	 * Clean fields data can't de used on VMLAUNCH and when we switch
> +	 * Clean fields data can't be used on VMLAUNCH and when we switch

This one is even mine! :-)

>  	 * between different L2 guests as KVM keeps a single VMCS12 per L1.
>  	 */
>  	if (from_launch || evmcs_gpa_changed)

-- 
Vitaly

