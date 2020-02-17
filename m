Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 496D11617A4
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 17:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729425AbgBQQQl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 11:16:41 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43622 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728463AbgBQQQk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Feb 2020 11:16:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581956199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NFyPUeouQuhyDga5QKhl60tvsLU2HEYGyhP5oV1KBMw=;
        b=XxA/tjgUqIlOeC6wKXlZJR0NvZqgj05XHD5oQFdfq268M3iB9RLg9mFnfY8M6VFYxbb5wb
        attYTgVlv4gi3u0+TX6mNzIOkvW3V6DjmFMP/KK4XOkLa52NuOH/bGaL+aUKvQkI5Bc6pK
        d9PBc0f7YhpvQEIW76HIoo/eIIJrx/c=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-1MNrArwhOmaI3xr5RvBiXA-1; Mon, 17 Feb 2020 11:16:37 -0500
X-MC-Unique: 1MNrArwhOmaI3xr5RvBiXA-1
Received: by mail-wm1-f71.google.com with SMTP id t17so6415596wmi.7
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 08:16:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=NFyPUeouQuhyDga5QKhl60tvsLU2HEYGyhP5oV1KBMw=;
        b=mIlNCsMJ/0ZOw0u/3m5lJANCkvQjfl3Svp8hTFlIAO+iOhO+4rHYoMlZGKmQ36niN5
         BTvIwghSaa+GpYkbBRnVImspOX4414EzgCAqpDZ3Alf2yedeWsIdtDP/dZqWfK8euYzO
         zW4j+8Fqsz6IM8z+eDlid3stLuXV4XhKFIehlhTQill8f3qFhXzkCAhTn4MC5jk7F0Z5
         87KXyaWwl0sRzLaGcvla8eJF8apwxZLQrsJGl/KqE9tzGfDVmc38AUEffG8i3QWjcoxq
         IHqVN4gxrHG5eQ6o44bGVNEb+x3RFmpITcG2pMHj04SyqTvWz32JPpWp7xtPwqu6gx/y
         aTHg==
X-Gm-Message-State: APjAAAWa+PzIK9SoGn1ncRMGzmaDlNn8Mo2cHIw34Y+f4nTTfyLZ/OOC
        dBQe2DXR9o9jl5WxA6YQ95Gd33FCOBAAXm1I+M+sVbwA294iR7dP9T+9Se0EOkymuDrH8K+6btP
        84rsFQVZUpF5X
X-Received: by 2002:adf:806c:: with SMTP id 99mr22007633wrk.328.1581956196304;
        Mon, 17 Feb 2020 08:16:36 -0800 (PST)
X-Google-Smtp-Source: APXvYqwRq0gQ7zvGxbVQD6lwCfxtSvMB5tAOlMD0x3vB242pZN7eh2YO0YBMLfDRNd31zyWvwFRRzA==
X-Received: by 2002:adf:806c:: with SMTP id 99mr22007622wrk.328.1581956196116;
        Mon, 17 Feb 2020 08:16:36 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id f207sm1188765wme.9.2020.02.17.08.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 08:16:35 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH] KVM: x86: eliminate some unreachable code
In-Reply-To: <1581562405-30321-1-git-send-email-linmiaohe@huawei.com>
References: <1581562405-30321-1-git-send-email-linmiaohe@huawei.com>
Date:   Mon, 17 Feb 2020 17:16:34 +0100
Message-ID: <87k14l9okd.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> From: Miaohe Lin <linmiaohe@huawei.com>
>
> These code are unreachable, remove them.
>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 1 -
>  arch/x86/kvm/x86.c     | 3 ---
>  2 files changed, 4 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index bb5c33440af8..b6d4eafe01cf 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4505,7 +4505,6 @@ static bool rmode_exception(struct kvm_vcpu *vcpu, int vec)
>  	case GP_VECTOR:
>  	case MF_VECTOR:
>  		return true;
> -	break;
>  	}
>  	return false;
>  }

Unrelated to your change but what I don't in rmode_exception() is the
second "/* fall through */" instead of just 'return true;', it makes it
harder to read.

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fbabb2f06273..a597009aefd7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3081,7 +3081,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		break;
>  	case APIC_BASE_MSR ... APIC_BASE_MSR + 0x3ff:
>  		return kvm_x2apic_msr_read(vcpu, msr_info->index, &msr_info->data);
> -		break;
>  	case MSR_IA32_TSCDEADLINE:
>  		msr_info->data = kvm_get_lapic_tscdeadline_msr(vcpu);
>  		break;
> @@ -3164,7 +3163,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		return kvm_hv_get_msr_common(vcpu,
>  					     msr_info->index, &msr_info->data,
>  					     msr_info->host_initiated);
> -		break;
>  	case MSR_IA32_BBL_CR_CTL3:
>  		/* This legacy MSR exists but isn't fully documented in current
>  		 * silicon.  It is however accessed by winxp in very narrow
> @@ -8471,7 +8469,6 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>  		break;
>  	default:
>  		return -EINTR;
> -		break;
>  	}
>  	return 1;
>  }

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

