Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 450B55F8E8
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 15:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfGDNLy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 09:11:54 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:42903 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbfGDNLy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 09:11:54 -0400
Received: by mail-wr1-f51.google.com with SMTP id a10so5497149wrp.9
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2019 06:11:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s5Rsv2p8qyUw0XkzCdc4S0eQyaiqH/E6s2dDnJMrPqY=;
        b=rmrYWaHc1A6AMkDMfj3MMv7ElC3fS7/irh2OZpTFMpNK1rLbCBOCERiGCivZ8K6zIW
         ywPYbksA24p0leNk3TE3/buS6MCzIOlBkjJRV84NPn6nHN4LnFqXSnLfBgD7icgoghEH
         A8m8IRqTluy3H4GozehVmIah4S2Xi4296TLrMSCBmwsEb5KmnFDktWZ9cLmubqkh8PNQ
         9QE+ftnT5pDZfU+Ro+e23O58UvnVH/tNJ31vAqziEYQOIUK8QOzg49D1sUFXvn1GGCfW
         g1s8bVVPCZB8Vt1WB/ujvWK66C1hS1d5ELqTUblpna2CGgDq5bCchoURQ4zrYOVs0L1u
         IWBg==
X-Gm-Message-State: APjAAAUhRci3eP6toNwrh6wmtMASKLIa+f0bHSIUBMgQFmDvfPbZDyjs
        U1rFlpCpBuSxXbKkP3WZZZfltg==
X-Google-Smtp-Source: APXvYqyXBrwZybq+K19nZiX3HIZJO2FfzqXJLr7t6//BeKrJgXfJVPSLIK3Q+1vP4kBJQxWWzjlhig==
X-Received: by 2002:adf:b69a:: with SMTP id j26mr26928777wre.93.1562245911529;
        Thu, 04 Jul 2019 06:11:51 -0700 (PDT)
Received: from [10.201.49.68] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id o126sm4770650wmo.1.2019.07.04.06.11.50
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 06:11:50 -0700 (PDT)
Subject: Re: Pre-required Kconfigs for kvm unit tests
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Andrew Jones <drjones@redhat.com>, kvm list <kvm@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        karl.heubaum@oracle.com, andre.przywara@arm.com, cdall@kernel.org
References: <CA+G9fYtVU2FoQ_cH71edFH-YfyFWZwi4s7tPxMW6aFG0pDEjPA@mail.gmail.com>
 <20190627081650.frxivyrykze5mqdv@kamzik.brq.redhat.com>
 <e10ac8cc-9bf6-b07d-00d9-83d9cc0f4b98@redhat.com>
 <CA+G9fYuuOX7URAPdzR-xEAZBWLsdSLV9-UBrP0L5nAXOK94Baw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3863cbe0-5b7d-6d8e-2467-7cbe2adc22a8@redhat.com>
Date:   Thu, 4 Jul 2019 15:11:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CA+G9fYuuOX7URAPdzR-xEAZBWLsdSLV9-UBrP0L5nAXOK94Baw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/07/19 15:08, Naresh Kamboju wrote:
> Hi Paolo,
> 
> On Thu, 27 Jun 2019 at 14:19, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
> on x86_64,
> 
>> For x86 there's just CONFIG_KVM_INTEL and CONFIG_KVM_AMD.
> 
> As per your suggestions I have to enabled KVM configs.
> Which auto enabled below list of configs.
> With these config changes the number of test pass increased from 23 to 45.
> 
> PASS 45
> FAIL  1
> SKIP 10
> Total 56
> 
> FAILED:
> --------------
> vmware_backdoors

For this to pass, please add module parameter kvm.enable_vmware_backdoor=1.

You should also add kvm.force_emulation_prefix=1.

Without the options you have now chosen, you were probably testing
QEMU's x86 emulation rather than KVM.

Paolo

> pku
> svm
> taskswitch
> taskswitch2
> ept
> vmx_eoi_bitmap_ioapic_scan
> vmx_hlt_with_rvi_test
> vmx_apicv_test
> hyperv_connections
> pmu
> 
> Extra configs enabled:
> -------------------------------
> CONFIG_HAVE_KVM_IRQCHIP=y
> CONFIG_HAVE_KVM_IRQFD=y
> CONFIG_HAVE_KVM_IRQ_ROUTING=y
> CONFIG_HAVE_KVM_EVENTFD=y
> CONFIG_KVM_MMIO=y
> CONFIG_KVM_ASYNC_PF=y
> CONFIG_HAVE_KVM_MSI=y
> CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
> CONFIG_KVM_VFIO=y
> CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
> CONFIG_KVM_COMPAT=y
> CONFIG_HAVE_KVM_IRQ_BYPASS=y
> CONFIG_KVM=y
> CONFIG_KVM_INTEL=y
> CONFIG_KVM_AMD=y
> CONFIG_KVM_MMU_AUDIT=y
> CONFIG_USER_RETURN_NOTIFIER=y
> CONFIG_PREEMPT_NOTIFIERS=y
> CONFIG_IRQ_BYPASS_MANAGER=y
> 
>>
>> Paolo
> 
> Thanks for great help.
> 
> Best regards
> Naresh Kamboju
> 

