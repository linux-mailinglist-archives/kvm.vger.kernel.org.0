Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64B9E1532DC
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 15:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgBEO3e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 09:29:34 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56769 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726046AbgBEO3e (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 09:29:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580912973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VqJmWuecyrzET8whJwBuHfcZJEAlaI0Vpv3y64xtnOY=;
        b=O1JHN+SKGVs2MkMMicXFeRJrDEK9EYCjTWvWa6y6xv80mQtnTnPYg/btBIOoRtBlrViOJI
        77I3ao7c8A+eYfDW6KbH7N1T8jPmIhxggj7NEBYHAW6j9QaV49MJgeK91hg81ERLmB0sqt
        YwWhDLwv4RzEOG6gx2+L5jOp+WwINU4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-MD5-sDOOMt6CjTBrS3vMVw-1; Wed, 05 Feb 2020 09:29:31 -0500
X-MC-Unique: MD5-sDOOMt6CjTBrS3vMVw-1
Received: by mail-wr1-f71.google.com with SMTP id x15so1256042wrl.15
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 06:29:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=VqJmWuecyrzET8whJwBuHfcZJEAlaI0Vpv3y64xtnOY=;
        b=jCCeSirfgDFo44ornal5NIe5tBIJHGRIozLqTpWtOlaq1FMoTte84jzv1EpajfCMsV
         eu/KXw3xpO6BlTck6U0ecHAaNUYYlbcNwjvbyX61Kw+1clQtTcSSgq2XXEk0IzQw/mEX
         aoTw29UxNhgXCh/QPixuj4wA55FroyAY6hB26DxVtpIt5UZDzIIZ7yc/zIqgTy8e6vOd
         OfULS27w6i7qxvLdN8qISNuGdT6NWYFJ5YoEWAkey0KPADv/DK6X5E8hxzJmFcy+gI7c
         4cS49KDfv+ieLjkJsvlljIPQxghXa8EEks06SZt2R+obivdrg1nHucTdDLZCbTk9PWZO
         9kRA==
X-Gm-Message-State: APjAAAXr/qCfEvge0jhkXEZWyWsoJIN0vRBlw+WfJWAYtaFX6ECxBlPT
        xSlvh1B2NPZ5SjV7AxFzCuJ5+viv2BPQ3Lxo2bklZeib7gj2V3ybSF0ctLMfFk0yDtVLg3HFJ93
        RaTjAqBYKfzX1
X-Received: by 2002:a05:600c:214f:: with SMTP id v15mr6250055wml.110.1580912970305;
        Wed, 05 Feb 2020 06:29:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqzkAdCD6Hpk/WS1zobus6iOZcw6x/75ou93FWiX8AkkLRXKfhDj79MljiGfxCPzfi8BFi5Tqw==
X-Received: by 2002:a05:600c:214f:: with SMTP id v15mr6250029wml.110.1580912970043;
        Wed, 05 Feb 2020 06:29:30 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id v8sm33615wrw.2.2020.02.05.06.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 06:29:29 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 01/26] KVM: x86: Remove superfluous brackets from case statement
In-Reply-To: <20200129234640.8147-2-sean.j.christopherson@intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com> <20200129234640.8147-2-sean.j.christopherson@intel.com>
Date:   Wed, 05 Feb 2020 15:29:28 +0100
Message-ID: <87mu9xkszb.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Remove unnecessary brackets from a case statement that unintentionally
> encapsulates unrelated case statements in the same switch statement.
> While technically legal and functionally correct syntax, the brackets
> are visually confusing and potentially dangerous, e.g. the last of the
> encapsulated case statements has an undocumented fall-through that isn't
> flagged by compilers due the encapsulation.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/x86.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7e3f1d937224..24597526b5de 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5260,7 +5260,7 @@ static void kvm_init_msr_list(void)
>  				 !intel_pt_validate_hw_cap(PT_CAP_single_range_output)))
>  				continue;
>  			break;
> -		case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B: {
> +		case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
>  			if (!kvm_x86_ops->pt_supported() ||
>  				msrs_to_save_all[i] - MSR_IA32_RTIT_ADDR0_A >=
>  				intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2)
> @@ -5275,7 +5275,7 @@ static void kvm_init_msr_list(void)
>  			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
>  			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
>  				continue;
> -		}
> +			break;
>  		default:
>  			break;
>  		}

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

