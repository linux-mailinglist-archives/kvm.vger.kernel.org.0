Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC4C311C907
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 10:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbfLLJU5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 04:20:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34874 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728198AbfLLJU4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 04:20:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576142455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c1G9apC9II0161yXPFzDEH3wx0KxsMSJnaDldD2g76U=;
        b=gMy3AKwCghfE3aUJrw2z5uhna1ZymTVPwl6b26ihnnptuTKZ56FtAWi7VszeUAunzPXI9K
        rUdf4lgCJVXvblKPep79H7B3bi3S/17UDEP+2DpZhc8Hw0yL5jYrxm0bJXOtZkhaiWW+KP
        v52ngb0R7oYTr3NraK4Ps+wmjCxhz34=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-x3HxLzmgMa-8fpO5P5Nhtg-1; Thu, 12 Dec 2019 04:20:52 -0500
X-MC-Unique: x3HxLzmgMa-8fpO5P5Nhtg-1
Received: by mail-wr1-f72.google.com with SMTP id c6so781884wrm.18
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 01:20:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=c1G9apC9II0161yXPFzDEH3wx0KxsMSJnaDldD2g76U=;
        b=FAUk2vHeus9fW42ZZzkGJ/b8GjMOGU2z9sPkWxGbeRapkQG3osZPL2RjOqq34TcqTz
         fZRf0Kaxym3is+p2YjjBoiYp+6LIAbtccdF830TnAhzwbvLKphbuXnwgAthBuBS1mQPd
         8xzI5P9P6gHe3/KYwbHjY77woPc2k1+RcnnTBYy5k4Dv62fXqEO/HmMyFYjMZCuJaj+v
         +MMc7xgFg8IMIa+DoF/wHVWKRIeTRjk12Wp6QpnyoD9+DFrgEAAI36Wcd1djM1PNKjr/
         gglNKFdEPfqlY/p3NXleQkpHkpyqqVz30NlHpecLx5MZQgFsJrdQHa3xkBHcXlny1Ba7
         bspQ==
X-Gm-Message-State: APjAAAUyeeT9uJegdNBxWfcP6WhxrzvTaWElXj8xEBkeBfIQe8vDCIbn
        pIVkoLqHrfLK05Ow688hZ2hXV5lAJCnGF89cSjIQMyokjLsIwAeTAifXe7P84WTjaqmtiNlsTZD
        cMmd9BtNTlofV
X-Received: by 2002:a7b:c450:: with SMTP id l16mr5375156wmi.31.1576142451443;
        Thu, 12 Dec 2019 01:20:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqzt6ESc3tpdS7ka1TyUc68OXq/63koGWEkD7s+pabgFOqIR52EHIlGmtMmuPt9Dg3JuZhn+JA==
X-Received: by 2002:a7b:c450:: with SMTP id l16mr5375132wmi.31.1576142451251;
        Thu, 12 Dec 2019 01:20:51 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id t1sm5594411wma.43.2019.12.12.01.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 01:20:50 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH v2 4/4] KVM: hyperv: Fix some typos in vcpu unimpl info
In-Reply-To: <1576138718-32728-5-git-send-email-linmiaohe@huawei.com>
References: <1576138718-32728-1-git-send-email-linmiaohe@huawei.com> <1576138718-32728-5-git-send-email-linmiaohe@huawei.com>
Date:   Thu, 12 Dec 2019 10:20:51 +0100
Message-ID: <87h825c32k.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> From: Miaohe Lin <linmiaohe@huawei.com>
>
> Fix some typos in vcpu unimpl info and a writing error in the comment.
>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/hyperv.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index c7d4640b7b1c..b255b9e865e5 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1059,7 +1059,7 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
>  			return 1;
>  		break;
>  	default:
> -		vcpu_unimpl(vcpu, "Hyper-V uhandled wrmsr: 0x%x data 0x%llx\n",
> +		vcpu_unimpl(vcpu, "Hyper-V unhandled wrmsr: 0x%x data 0x%llx\n",
>  			    msr, data);
>  		return 1;
>  	}
> @@ -1122,7 +1122,7 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
>  			return 1;
>  
>  		/*
> -		 * Clear apic_assist portion of f(struct hv_vp_assist_page
> +		 * Clear apic_assist portion of struct hv_vp_assist_page
>  		 * only, there can be valuable data in the rest which needs
>  		 * to be preserved e.g. on migration.
>  		 */
> @@ -1179,7 +1179,7 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
>  			return 1;
>  		break;
>  	default:
> -		vcpu_unimpl(vcpu, "Hyper-V uhandled wrmsr: 0x%x data 0x%llx\n",
> +		vcpu_unimpl(vcpu, "Hyper-V unhandled wrmsr: 0x%x data 0x%llx\n",
>  			    msr, data);
>  		return 1;
>  	}

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Thanks!

-- 
Vitaly

