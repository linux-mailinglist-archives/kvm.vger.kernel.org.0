Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A139D099B
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 10:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbfJIIZH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 04:25:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46126 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729677AbfJIIZG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 04:25:06 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8DA612A09AA
        for <kvm@vger.kernel.org>; Wed,  9 Oct 2019 08:25:06 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id w10so755980wrl.5
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 01:25:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FGjIyp+V4zvVe8nGelmZ1TCF9IV0uDpPZ4FIyT58LwQ=;
        b=O6VmLZyQEIJUWwrQMgI8nI5SZq4tQrFZc17Lgvw9+QKc5/NhsP8rouZf0iZ8etNCt0
         TSZRvdySQX2jXt8d/OEqXOV6KihzD8o5s2m2Gcu2VMRNri5hkAS6K/0rOVVfcwN2ogmW
         1zS17TdOnyyBa8VY0t32cYRlT9+263dQHwG+OC4sUhH/NUpl6YlbYGdnKZCYu2ucFR45
         ZoJIrDAirQQm3fnLJsTt8rHB7h0hk4K9IouBWbZpyc4agJHcDYSaXWAVyZGVfwSUyBgU
         3wD0BYc8lQLPDk+SQRKrWfH98gt2jLEXaUQTA/a1yXAZTAvW4ElOU2FDLDS//4WgXSY0
         2AWA==
X-Gm-Message-State: APjAAAU9MWzDQm3bpYSx41w4eIjyTmFrMgEAJ6iSnQpVA9AiEzQtvY04
        BWfysSITA52/IZKIEZHU/XIrtQR3Jd3LH4PJ0RgH+yZijjhAQnzSYpAVPFmlY9ksTxXuK9F1qQR
        5FrwvMToYZR5t
X-Received: by 2002:a1c:7d92:: with SMTP id y140mr1738593wmc.151.1570609505001;
        Wed, 09 Oct 2019 01:25:05 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy//6CNNk9hUQud3U2UoX3ktP6Hte2hMVzeCR9fMVrPj3cI2AfYDQdE2xyUu9Pm90qtjWUvFg==
X-Received: by 2002:a1c:7d92:: with SMTP id y140mr1738573wmc.151.1570609504741;
        Wed, 09 Oct 2019 01:25:04 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id b12sm1168930wrt.21.2019.10.09.01.25.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 01:25:04 -0700 (PDT)
Subject: Re: [PATCH v3 06/16] kvm: x86: svm: Add support to
 activate/deactivate posted interrupts
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
References: <1568401242-260374-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1568401242-260374-7-git-send-email-suravee.suthikulpanit@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f3fc86e3-e20f-e84c-237d-d1dbcb5d60a8@redhat.com>
Date:   Wed, 9 Oct 2019 10:25:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1568401242-260374-7-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/09/19 21:00, Suthikulpanit, Suravee wrote:
> +++ b/arch/x86/kvm/x86.c
> @@ -7198,6 +7198,9 @@ void kvm_vcpu_activate_apicv(struct kvm_vcpu *vcpu)
>  	kvm_apic_update_apicv(vcpu);
>  
>  	kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
> +
> +	if (kvm_x86_ops->activate_pi_irte)
> +		kvm_x86_ops->activate_pi_irte(vcpu);
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_activate_apicv);
>  
> @@ -7212,6 +7215,8 @@ void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu)
>  
>  	vcpu->arch.apicv_active = false;
>  	kvm_apic_update_apicv(vcpu);
> +	if (kvm_x86_ops->deactivate_pi_irte)
> +		kvm_x86_ops->deactivate_pi_irte(vcpu);
>  	kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_deactivate_apicv);

This can be done in refresh_apicv_exec_ctrl.

Paolo
