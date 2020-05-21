Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8770F1DCE43
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 15:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbgEUNhD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 09:37:03 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26659 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729465AbgEUNhC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 May 2020 09:37:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590068220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k9apolne3MOvgFYAOik7xpjgAh+OTAjNzLgbnviUZnk=;
        b=D39cLReki9z/lPFnIOTH/9YXyOlIqMexZ38ExowrOJGlJvWpT4NsKiGE7TgVcspcvGg6c4
        NXgdWS3ZO2DCng9ua47K+91bBLixHD/1r23Eg0O1d4IUAPXCxvFksn1Vev7uQaYlKyvH5+
        w3tcUNmk5AOe09/tkJAVOBH1Q+C4dFI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-unuczGuKMuukdM8bup4ibw-1; Thu, 21 May 2020 09:36:58 -0400
X-MC-Unique: unuczGuKMuukdM8bup4ibw-1
Received: by mail-wr1-f71.google.com with SMTP id e14so2917548wrv.11
        for <kvm@vger.kernel.org>; Thu, 21 May 2020 06:36:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k9apolne3MOvgFYAOik7xpjgAh+OTAjNzLgbnviUZnk=;
        b=NCYo0THdMpqMZttQGPisBxvUFoAbYScac90kVH3cWedrKqB0sDQA9Jb0S2e+lF0L2W
         TSqFHlJ1IjSsUqV9F6Xxr7vAtKE56vr0xe6MLXR4XRBcVpO5LCaAOmY2N6u24k8t/aNC
         VtqEYvBIic9/u+SQBtHGRHgtkjfu0pfdDjKHaECG2H5doUnfSA1MN/jkCx5maJnG8/fX
         PcrIaKzPsEEoa1lH0+FUd1/7h4qo3T/jig0tKj46UqkwkB9V0Q2mNX+Dqn/11jRuEcAm
         9raJ5n1Cg3CF7M1vxkwCcFEBvHHIkPqrKrhUdZoC2zQ+1xvqHqzT/Y64OlZO9UDntUml
         +lWw==
X-Gm-Message-State: AOAM531G4h1/g8gkXXClf6C16+el9Y9eG+zkr0+3fhmbHaeNxy783ply
        bJxMXEPzcQJRiGCH0krgwgUjjPyX4pl1lo2Dvxcj8seL8VEoQ4fBtnOjsjfG6eaNiLReDMMcQWQ
        OHy01ZiA6TKwc
X-Received: by 2002:a1c:3bc5:: with SMTP id i188mr8856754wma.90.1590068217485;
        Thu, 21 May 2020 06:36:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz0Qvv+LB4xFaLKN/vr1LCs4+uEau6Ef45+r3Usb72/IQMTIglg+pNLXlzEd0xvftHufcmXZQ==
X-Received: by 2002:a1c:3bc5:: with SMTP id i188mr8856739wma.90.1590068217245;
        Thu, 21 May 2020 06:36:57 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.94.134])
        by smtp.gmail.com with ESMTPSA id r9sm7484013wra.52.2020.05.21.06.36.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 06:36:56 -0700 (PDT)
Subject: Re: [PATCH v3] kvm/x86 : Remove redundant function implement
To:     =?UTF-8?B?5b2t5rWpKFJpY2hhcmQp?= <richard.peng@oppo.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <HKAPR02MB4291D5926EA10B8BFE9EA0D3E0B70@HKAPR02MB4291.apcprd02.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5f2a3d25-adbf-26c2-4c2e-43d1a7abab97@redhat.com>
Date:   Thu, 21 May 2020 15:36:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <HKAPR02MB4291D5926EA10B8BFE9EA0D3E0B70@HKAPR02MB4291.apcprd02.prod.outlook.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/05/20 07:57, 彭浩(Richard) wrote:
> pic_in_kernel(),ioapic_in_kernel() and irqchip_kernel() have the
> same implementation.
> 
> Signed-off-by: Peng Hao <richard.peng@oppo.com>
> ---
>  arch/x86/kvm/ioapic.h  |  8 ++------
>  arch/x86/kvm/irq.h     | 14 ++++----------
>  arch/x86/kvm/lapic.c   |  1 +
>  arch/x86/kvm/mmu/mmu.c |  1 +
>  arch/x86/kvm/x86.c     |  1 +
>  5 files changed, 9 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
> index 2fb2e3c..7a3c53b 100644
> --- a/arch/x86/kvm/ioapic.h
> +++ b/arch/x86/kvm/ioapic.h
> @@ -5,7 +5,7 @@
>  #include <linux/kvm_host.h>
> 
>  #include <kvm/iodev.h>
> -
> +#include "irq.h"
>  struct kvm;
>  struct kvm_vcpu;
> 
> @@ -108,11 +108,7 @@ do {\
> 
>  static inline int ioapic_in_kernel(struct kvm *kvm)
>  {
> -int mode = kvm->arch.irqchip_mode;
> -
> -/* Matches smp_wmb() when setting irqchip_mode */
> -smp_rmb();
> -return mode == KVM_IRQCHIP_KERNEL;
> +return irqchip_kernel(kvm);
>  }
> 
>  void kvm_rtc_eoi_tracking_restore_one(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
> index f173ab6..e133c1a 100644
> --- a/arch/x86/kvm/irq.h
> +++ b/arch/x86/kvm/irq.h
> @@ -16,7 +16,6 @@
>  #include <linux/spinlock.h>
> 
>  #include <kvm/iodev.h>
> -#include "ioapic.h"
>  #include "lapic.h"
> 
>  #define PIC_NUM_PINS 16
> @@ -66,15 +65,6 @@ void kvm_pic_destroy(struct kvm *kvm);
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
> @@ -93,6 +83,10 @@ static inline int irqchip_kernel(struct kvm *kvm)
>  return mode == KVM_IRQCHIP_KERNEL;
>  }
> 
> +static inline int pic_in_kernel(struct kvm *kvm)
> +{
> +return irqchip_kernel(kvm);
> +}
>  static inline int irqchip_in_kernel(struct kvm *kvm)
>  {
>  int mode = kvm->arch.irqchip_mode;
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 9af25c9..de4d046 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -36,6 +36,7 @@
>  #include <linux/jump_label.h>
>  #include "kvm_cache_regs.h"
>  #include "irq.h"
> +#include "ioapic.h"
>  #include "trace.h"
>  #include "x86.h"
>  #include "cpuid.h"
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 8071952..6133f69 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -16,6 +16,7 @@
>   */
> 
>  #include "irq.h"
> +#include "ioapic.h"
>  #include "mmu.h"
>  #include "x86.h"
>  #include "kvm_cache_regs.h"
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d786c7d..c8b62ac 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -18,6 +18,7 @@
> 
>  #include <linux/kvm_host.h>
>  #include "irq.h"
> +#include "ioapic.h"
>  #include "mmu.h"
>  #include "i8254.h"
>  #include "tss.h"
> --
> 2.7.4
> 
> ________________________________
> OPPO
> 
> 本电子邮件及其附件含有OPPO公司的保密信息，仅限于邮件指明的收件人使用（包含个人及群组）。禁止任何人在未经授权的情况下以任何形式使用。如果您错收了本邮件，请立即以电子邮件通知发件人并删除本邮件及其附件。
> 
> This e-mail and its attachments contain confidential information from OPPO, which is intended only for the person or entity whose address is listed above. Any use of the information contained herein in any way (including, but not limited to, total or partial disclosure, reproduction, or dissemination) by persons other than the intended recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender by phone or email immediately and delete it!
> 

Queued, thanks.

Paolo

