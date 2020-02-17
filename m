Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75A06161899
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 18:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbgBQRNt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 12:13:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40858 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729423AbgBQRNt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 12:13:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581959628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zvr7zosO7XOdlphEaMtlcsDU2QFGlchxOoZ2XJ+sfA0=;
        b=KtqUTwLQ/Pk6yubxrBxCKJyMDo+pk62/5Wf26E3HFtq2zytYPv1KaQB5C5gP0ploRDxE5M
        JXLebzGL4XgjxYBu1v2VjrRuhkgdNSs1nxUZVJ5ZaDSkOmZ998bDncMQ0axQK6aGgozwSK
        5ECAlYS/1M3fbeCREjYXZrLh7JbJJ88=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-X166SwXiNbSqPj3LvfoVgA-1; Mon, 17 Feb 2020 12:13:42 -0500
X-MC-Unique: X166SwXiNbSqPj3LvfoVgA-1
Received: by mail-wr1-f72.google.com with SMTP id m15so9184830wrs.22
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 09:13:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zvr7zosO7XOdlphEaMtlcsDU2QFGlchxOoZ2XJ+sfA0=;
        b=nUALB7SDux7t1MfsVGh2qSGSnNbY5paxCsmQ8VrKT0XZGLLqq7LnZi35PdzB+YAixw
         cgyTIf+PTo3FhhimPmxwxjDJn2ny00N5WQyI3twym/L0cJlXhm+nF0BDnX2CYx9OUHlb
         rJIDklhH2EjSsEi7qseMXhph0vhRKiXie/gzDVwdhzrb9BAMQbohklxuCWNndG6xUBOj
         HpPik1KnCUelhIHoJuGN36/URpMP0jxa3ynZJNdHVVLl3XjMlyXb3lhPT0KR6w1R9yxG
         XqzaRr+gW6WL8QWknBUM3ln2mDfuMLRNkqAY0L/Qv8mGp4UvIC4iz1e6iBth0tsNiV9a
         5iBA==
X-Gm-Message-State: APjAAAUhE5gSO+fRUjr2BnwibHR4ZReXzk3EHb2jqQLsxUrTgcH9Vo8s
        6pQyQiyP50BfQdOszsIwxPI6jjZMdn5dSoHfB5C6atc9fTJu2rcK/41tSQqYeuam1ldI4APM/bR
        dXXr5H/3vCU4O
X-Received: by 2002:a5d:4289:: with SMTP id k9mr23874614wrq.280.1581959621314;
        Mon, 17 Feb 2020 09:13:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqzOSN9Nebz0glINr0cP2RhJRrWjeL0Lcx1XGFRkQ6RFQce1iHmupUMsZFekj+Py6SXpZywzVw==
X-Received: by 2002:a5d:4289:: with SMTP id k9mr23874595wrq.280.1581959621047;
        Mon, 17 Feb 2020 09:13:41 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id z19sm54313wmi.43.2020.02.17.09.13.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 09:13:40 -0800 (PST)
Subject: Re: [PATCH] KVM: apic: remove unused function apic_lvt_vector()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
References: <1581561464-3893-1-git-send-email-linmiaohe@huawei.com>
 <2fb684de-30c1-ed67-600f-08168e64d6c7@oracle.com>
 <87blpx9mfw.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a8d6f864-7014-64cf-da3a-3761385f123b@redhat.com>
Date:   Mon, 17 Feb 2020 18:13:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <87blpx9mfw.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/02/20 18:02, Vitaly Kuznetsov wrote:
> 
> Also, apic_lvt_enabled() is only used once with APIC_LVTT as the second
> argument so I'd suggest we also do:
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index afcd30d44cbb..d85463ff4a6f 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -289,14 +289,14 @@ static inline void kvm_apic_set_x2apic_id(struct kvm_lapic *apic, u32 id)
>         recalculate_apic_map(apic->vcpu->kvm);
>  }
>  
> -static inline int apic_lvt_enabled(struct kvm_lapic *apic, int lvt_type)
> +static inline int apic_lvtt_enabled(struct kvm_lapic *apic)
>  {
> -       return !(kvm_lapic_get_reg(apic, lvt_type) & APIC_LVT_MASKED);
> +       return !(kvm_lapic_get_reg(apic, APIC_LVTT) & APIC_LVT_MASKED);
>  }
>  
> -static inline int apic_lvt_vector(struct kvm_lapic *apic, int lvt_type)
> +static inline int apic_lvtt_vector(struct kvm_lapic *apic)
>  {
> -       return kvm_lapic_get_reg(apic, lvt_type) & APIC_VECTOR_MASK;
> +       return kvm_lapic_get_reg(apic, APIC_LVTT) & APIC_VECTOR_MASK;
>  }
> 
> in addition to the above.
> 
> -- Vitaly

Sounds good.

Paolo

