Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70A8C17341C
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 10:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgB1JeK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 04:34:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35803 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726673AbgB1JeK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 04:34:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582882449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dJS5edUophByPUq1NZYfyTaIBLl4lfPmtJVzJ7bVJ88=;
        b=Nrttei951d30slxENyUKIp7qlx5pU99fZtYNksJY04awIr6nyJwzP1nBtNygvEZMHQqpZo
        RSaeB7k18DZoxpi165p0DVJ1gKRSsnXrwMgZleM3jRX7nM7aZBpLDXBKSPRNQzrkapc/Dh
        rpIbQo3PXJegQxy99xO1xyyKydJVUK8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-q3zc18MvPESzM0c7eoJo7A-1; Fri, 28 Feb 2020 04:34:07 -0500
X-MC-Unique: q3zc18MvPESzM0c7eoJo7A-1
Received: by mail-wr1-f70.google.com with SMTP id t14so1081251wrs.12
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2020 01:34:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dJS5edUophByPUq1NZYfyTaIBLl4lfPmtJVzJ7bVJ88=;
        b=T+OZ3qRKw+4RQ6S+WtcrwR1Pcsb2iYRoYrgpQUL6VAnWakVSINNmirG0seWGxgFofU
         6Neg5I1JSbiOSyO82EP8hFD6rgEO2HdioSKVFxXFSB18DS1cAHCtBg513r26jyQn/dYp
         zKIjCOFIOIpadEoLdWMWsBqp25PB5Tbff9Ohdch6F8ZYhYXMHP5KjCWd/ZZ4RTtuW/QT
         t7SmkVjI6x2TDL5F/Ch9KPpmxxHY0pUvsTKFvyO1xdUrmgT8COzqGlZ8zP8zCfptsIrT
         InOo4zgcCNChUaRovBrSsoBnnJaPguhzhmKvcHBOw0P2hESGwBmb/M8y2h/H4OtjgH7A
         AeQg==
X-Gm-Message-State: APjAAAU+m2RInUZut7APQvBC3FDUcr0dcb10Q4/nB0F6Jcb5CeZFWr3h
        jbBkrtZD3euL4BEURCEJaqLdsOHIgiXGibLJCXdaSddPWB7MHU2nrK5zYk+EvZfBRdL4S9ynCV0
        qk85QaqBvbVFH
X-Received: by 2002:adf:e50f:: with SMTP id j15mr4021127wrm.356.1582882446555;
        Fri, 28 Feb 2020 01:34:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqyBrOkOWkCFrAUc//lPtO3JxsVbjsm/8NYjxtbD8S+PxeP88y1019tbTcXq/GWJFRSkOP1gtg==
X-Received: by 2002:adf:e50f:: with SMTP id j15mr4021108wrm.356.1582882446322;
        Fri, 28 Feb 2020 01:34:06 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:d0d9:ea10:9775:f33f? ([2001:b07:6468:f312:d0d9:ea10:9775:f33f])
        by smtp.gmail.com with ESMTPSA id a9sm1411012wmm.15.2020.02.28.01.34.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 01:34:05 -0800 (PST)
Subject: Re: [PATCH] KVM: let declaration of kvm_get_running_vcpus match
 implementation
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, arc Zyngier <maz@kernel.org>
References: <20200228084941.9362-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8c3e2a26-c04d-338e-16c6-39bb13c715af@redhat.com>
Date:   Fri, 28 Feb 2020 10:34:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200228084941.9362-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/02/20 09:49, Christian Borntraeger wrote:
> Sparse notices that declaration and implementation do not match:
> arch/s390/kvm/../../../virt/kvm/kvm_main.c:4435:17: warning: incorrect type in return expression (different address spaces)
> arch/s390/kvm/../../../virt/kvm/kvm_main.c:4435:17:    expected struct kvm_vcpu [noderef] <asn:3> **
> arch/s390/kvm/../../../virt/kvm/kvm_main.c:4435:17:    got struct kvm_vcpu *[noderef] <asn:3> *
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  include/linux/kvm_host.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7944ad6ac10b..bcb9b2ac0791 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1344,7 +1344,7 @@ static inline void kvm_vcpu_set_dy_eligible(struct kvm_vcpu *vcpu, bool val)
>  #endif /* CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT */
>  
>  struct kvm_vcpu *kvm_get_running_vcpu(void);
> -struct kvm_vcpu __percpu **kvm_get_running_vcpus(void);
> +struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
>  
>  #ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
>  bool kvm_arch_has_irq_bypass(void);
> 

Queued, thanks.

Paolo

