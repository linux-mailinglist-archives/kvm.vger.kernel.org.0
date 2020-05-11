Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0FF1CDBCC
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 15:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730242AbgEKNua (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 09:50:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23422 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729680AbgEKNua (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 May 2020 09:50:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589205028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dYIcn+3D286vkydQaVSkgnA5hSu+m3hsQi8qZsqHYj8=;
        b=g5mZaB0H8NtwhPwOEZf7PlBHsboJYDI3cwOeL3fqXw/s7TGANQRQB8cGTdA2lVXuvQ85/G
        gMlOb1s1nQ0Y7xOFQkRAXrNAZWqDhxLzX53OJg5gGnmnTlYhPrQneXGTvNvcym+r70ERXZ
        vm1KC2CcUTDWt8fzeiPXVuSqMaln9f4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-Iip6uTAoPm2U9PCkSFWJBA-1; Mon, 11 May 2020 09:50:26 -0400
X-MC-Unique: Iip6uTAoPm2U9PCkSFWJBA-1
Received: by mail-wr1-f70.google.com with SMTP id 90so5216365wrg.23
        for <kvm@vger.kernel.org>; Mon, 11 May 2020 06:50:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dYIcn+3D286vkydQaVSkgnA5hSu+m3hsQi8qZsqHYj8=;
        b=fgwkb2oUQQNYcDdbhrch1c90Hzsdqi80q0SINLcDTcb+atTFItThT89jyxHj8emxlq
         XsYfpVDGTZUB0MwdzYVg4CIhqTiz1HWWaWiZFVC7hdYCQuXM/4OG663TBI+QA1972MMb
         Zv3i+g6DMmixxST5TmA/jNMrBFnxNUjvsWFIhKfuaROfM+dWCE+tywhrmEw8fvs9OklH
         TK3dnLDv2axOsw/MEPmBNdhqEVi6GEf5ugWSqvB7+T6gtRJ0UO3D/eb0vCmkxmMFxB56
         frhN44OdJxLY2JRYDBONXmL5YIYBdekdYojITRKLZUhD5x1QJEBC4rqrULg8Uo0bpvYB
         waJw==
X-Gm-Message-State: AGi0PuYdNXPb+6CFXKpt7Hxb+VxvO8Xo7EY4UYQTZnqtcwdkgMNfF+xc
        w5rWIhvnZ/0bhAU2DgEL9aAiQ2AAnl9E+92xxCUJWvmlynRs4g4giHXkHoMhJ++dJ935J3NzZDA
        TEmeT0D5EphVQ
X-Received: by 2002:a1c:7213:: with SMTP id n19mr6013792wmc.88.1589205025671;
        Mon, 11 May 2020 06:50:25 -0700 (PDT)
X-Google-Smtp-Source: APiQypISo3KIFEJ7LYAXA24Bc5EMlbCgV7DLtmc2WcZnpfaF2Wz6YDCNkPryNeTkCD/TXK9yqXQ6gA==
X-Received: by 2002:a1c:7213:: with SMTP id n19mr6013774wmc.88.1589205025409;
        Mon, 11 May 2020 06:50:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4c95:a679:8cf7:9fb6? ([2001:b07:6468:f312:4c95:a679:8cf7:9fb6])
        by smtp.gmail.com with ESMTPSA id k5sm16690003wrx.16.2020.05.11.06.50.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 06:50:24 -0700 (PDT)
Subject: Re: [PATCH] kvm/x86 : Remove redundant pic_in_kernel
To:     =?UTF-8?B?5b2t5rWpKFJpY2hhcmQp?= <richard.peng@oppo.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <HKAPR02MB42914E8F73424BCF815DAC6CE0A10@HKAPR02MB4291.apcprd02.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <65b8f660-1d78-10f5-fe61-54de94cd5017@redhat.com>
Date:   Mon, 11 May 2020 15:50:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <HKAPR02MB42914E8F73424BCF815DAC6CE0A10@HKAPR02MB4291.apcprd02.prod.outlook.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/05/20 13:21, ÅíºÆ(Richard) wrote:
> pic_in_kernel() and irqchip_kernel() have the same implementation.
> 
> Signed-off-by: Peng Hao <richard.peng@oppo.com>

Thanks for the patch, this is interesting!  And there is also
ioapic_in_kernel.  However, the three functions are used in different
cases, for example ioapic_in_kernel before accessing kvm->arch.vioapic.
 So the right thing to do would be to keep the functions, but change
them to just return irqchip_kernel(kvm).

Paolo

> ---
>  arch/x86/kvm/irq.h | 9 ---------
>  arch/x86/kvm/x86.c | 6 +++---
>  2 files changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
> index f173ab6..3ad07ca 100644
> --- a/arch/x86/kvm/irq.h
> +++ b/arch/x86/kvm/irq.h
> @@ -66,15 +66,6 @@ void kvm_pic_destroy(struct kvm *kvm);
>  int kvm_pic_read_irq(struct kvm *kvm);
>  void kvm_pic_update_irq(struct kvm_pic *s);
> 
> -static inline int pic_in_kernel(struct kvm *kvm)
> -{
> -int mode = kvm->arch.irqchip_mode;
> -
> -/* Matches smp_wmb() when setting irqchip_mode */
> -smp_rmb();
> -return mode == KVM_IRQCHIP_KERNEL;
> -}
> -
>  static inline int irqchip_split(struct kvm *kvm)
>  {
>  int mode = kvm->arch.irqchip_mode;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d786c7d..559053f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3710,7 +3710,7 @@ static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
>   * With in-kernel LAPIC, we only use this to inject EXTINT, so
>   * fail for in-kernel 8259.
>   */
> -if (pic_in_kernel(vcpu->kvm))
> +if (irqchip_kernel(vcpu->kvm))
>  return -ENXIO;
> 
>  if (vcpu->arch.pending_external_vector != -1)
> @@ -7622,7 +7622,7 @@ static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
>  static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu)
>  {
>  return vcpu->run->request_interrupt_window &&
> -likely(!pic_in_kernel(vcpu->kvm));
> +likely(!irqchip_kernel(vcpu->kvm));
>  }
> 
>  static void post_kvm_run_save(struct kvm_vcpu *vcpu)
> @@ -7634,7 +7634,7 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
>  kvm_run->cr8 = kvm_get_cr8(vcpu);
>  kvm_run->apic_base = kvm_get_apic_base(vcpu);
>  kvm_run->ready_for_interrupt_injection =
> -pic_in_kernel(vcpu->kvm) ||
> +irqchip_kernel(vcpu->kvm) ||
>  kvm_vcpu_ready_for_interrupt_injection(vcpu);
>  }
> 
> --
> 2.7.4

