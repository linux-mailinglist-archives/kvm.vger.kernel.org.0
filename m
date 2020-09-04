Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31B625D849
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 14:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbgIDMBl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 08:01:41 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27414 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729297AbgIDMBU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Sep 2020 08:01:20 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-dtkuTlnlPA6EQCey76UJ3w-1; Fri, 04 Sep 2020 08:01:17 -0400
X-MC-Unique: dtkuTlnlPA6EQCey76UJ3w-1
Received: by mail-wr1-f72.google.com with SMTP id b7so2250937wrn.6
        for <kvm@vger.kernel.org>; Fri, 04 Sep 2020 05:01:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Al2z0QnC0ksQGEJoD0RhYiQbJmD54azvTeMvvOw+xd0=;
        b=phcdEt0SfcyjpI6me7sXBbeD6vqZZdPOt5w4Fy2ZskIib66YZ1JIhAdXHibWgqbeGF
         ib7Ixu4P4wU8nqNfduGUdWv3cVnAK0BXI+DXU4LBgG89vkupZG4utbfIw4b9D+swKpyo
         ZS8OSR1K2z8auS2tKX3ljnaE3odz4ziIBv0lhBtB7tLXCGdT3lAL5MvA+CbCcFC8kqvq
         LVmEg32tfZR2CGT31QgdWly2d9ccyo9Wr/R38+z0QcZ+mBoDPdGfqJWzucGJBJ2jgZtA
         KEwWhcDVdxMf7ynBsLGk6K5Z7qe30e3XqRuIhYuZWRPVwiaBxuqP6DU8WcdAulidfLMm
         NYIQ==
X-Gm-Message-State: AOAM531zFBX0DyHz3K5Pd9/8Y9ZVayhkJhM2npGUO6ppA3LRxNO53JQQ
        AavRFvW8ulBxcy6S26Em7w/PbQILqGR/Yv38susfyddXQGFx7mPjBEbGaa0RsbVlANAXc/5aNHv
        bpf69RIFY3VbM
X-Received: by 2002:adf:fb01:: with SMTP id c1mr7043265wrr.119.1599220875208;
        Fri, 04 Sep 2020 05:01:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIXro2W+UzI918zJZ8Jt2As+2AW5s/HHlp9hVGkN24CfzKnxwLXHw1csuVaPHLLwZaqe1O7A==
X-Received: by 2002:adf:fb01:: with SMTP id c1mr7043241wrr.119.1599220874941;
        Fri, 04 Sep 2020 05:01:14 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id n4sm10710789wrp.61.2020.09.04.05.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 05:01:14 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Haiwei Li <lihaiwei.kernel@gmail.com>
Cc:     "hpa\@zytor.com" <hpa@zytor.com>, "bp\@alien8.de" <bp@alien8.de>,
        "mingo\@redhat.com" <mingo@redhat.com>,
        "tglx\@linutronix.de" <tglx@linutronix.de>, joro@8bytes.org,
        "jmattson\@google.com" <jmattson@google.com>,
        "wanpengli\@tencent.com" <wanpengli@tencent.com>,
        sean.j.christopherson@intel.com,
        "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86\@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] KVM: SVM: Add tracepoint for cr_interception
In-Reply-To: <f3031602-db3b-c4fe-b719-d402663b0a2b@gmail.com>
References: <f3031602-db3b-c4fe-b719-d402663b0a2b@gmail.com>
Date:   Fri, 04 Sep 2020 14:01:12 +0200
Message-ID: <87imctoinr.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Haiwei Li <lihaiwei.kernel@gmail.com> writes:

> From: Haiwei Li <lihaiwei@tencent.com>
>
> Add trace_kvm_cr_write and trace_kvm_cr_read for svm.
>
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> ---
>   arch/x86/kvm/svm/svm.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 03dd7bac8034..2c6dea48ba62 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2261,6 +2261,7 @@ static int cr_interception(struct vcpu_svm *svm)

There are two special cases when we go to emulate_on_interception() and
these won't be logged but I don't think this is a must.

>   	if (cr >= 16) { /* mov to cr */
>   		cr -= 16;
>   		val = kvm_register_read(&svm->vcpu, reg);
> +		trace_kvm_cr_write(cr, val);
>   		switch (cr) {
>   		case 0:
>   			if (!check_selective_cr0_intercepted(svm, val))
> @@ -2306,6 +2307,7 @@ static int cr_interception(struct vcpu_svm *svm)
>   			return 1;
>   		}
>   		kvm_register_write(&svm->vcpu, reg, val);
> +		trace_kvm_cr_read(cr, val);

The 'default:' case above does 'return 1;' so we won't get the trace but
I understand you put trace_kvm_cr_read() here so you can log the
returned 'val', #UD should be clearly visible. 

>   	}
>   	return kvm_complete_insn_gp(&svm->vcpu, err);
>   }
> --
> 2.18.4
>

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

