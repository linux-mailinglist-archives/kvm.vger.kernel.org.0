Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B24949E626
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 16:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236698AbiA0Pf4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 10:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbiA0Pfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 10:35:55 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67A4C06173B
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 07:35:54 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o11so3335323pjf.0
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 07:35:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Nh4tt56vGa5btexxdkmwALjwqwsFXKfPSa5S35IL0i0=;
        b=gwnaJG/ZFkBC2Q+3iZ67GlinnDaL85T+zktnDiRxHz5u2F3erwlaj2KrNQ19kciPIp
         HAkX3KPi1pztni3tkc7nmtDPmAJHUj/tx4qdg2lvHyRM1vWhtU7jwOOkebC7cfZZpfS2
         LptKrRrHOnuQ1PK64kAUnHzg23QrgWr4fOfeGH6dUjmOUYlUKHRgF2dRIRF7NA8uQqNH
         3YaDpEw83XvO4VxRyUR+4pMFbmSoeulgSBJ+VwL7hmZtNhAoDdqP0bnnOS6jvrFhh/H4
         Z6kFiWcQE4iThJYjOcvMszzGrpRCF0/q8FAk4pylMUJmpGkrVVttbPcInRqtqNRYSRo1
         bB6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Nh4tt56vGa5btexxdkmwALjwqwsFXKfPSa5S35IL0i0=;
        b=xQvNN8Og5/n1qDcp7+0k1Koehxjb4MvbPfzLFL04yPh3wgd3JZhFghP+vqMfAvfy6q
         LR0cQWB4RplcqWRyZFwmOXN8caeqCWDsJ1+l+RERIcWPWEGRsNcbQ7+RIqq2DOVaALVC
         uuyXfejZJpUHCl9wiLNgRKizl6301X4/pQwNaNny74Ep8wzxl0gwEymwyHVw5xGQgi75
         QsXJ2I6OjXqyUhidFCfp0tdTjreSRi2UHMwQ7Vta9oT4/V5Ux8iHHriWEUMkV1ccWrOl
         Qvjv2prQXxcWYg3Cb8TPKdH/5KBn9jB0/dysWFkPIS+9LDG0PrExnE7HP+23HKjcL8UK
         xiRw==
X-Gm-Message-State: AOAM531TwcOrhJQysxnegb+KIKPrjEDp7S/o9Leu2ODMV3IZo7HSGVn4
        rIrWMZosNCqooY7937lAaPL5YnF5puODTA==
X-Google-Smtp-Source: ABdhPJyJMQkkkrrz5bDuSd0OmZFssqKo0y3S7HL+Ux4EkAOKl13i3q9haJMrZjlsWf++usJnPNaAtw==
X-Received: by 2002:a17:902:758c:: with SMTP id j12mr3759308pll.34.1643297754116;
        Thu, 27 Jan 2022 07:35:54 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t2sm3331964pfg.207.2022.01.27.07.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 07:35:53 -0800 (PST)
Date:   Thu, 27 Jan 2022 15:35:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        yang.zhong@intel.com
Subject: Re: [PATCH 2/3] KVM: x86: add system attribute to retrieve full set
 of supported xsave states
Message-ID: <YfK71pSnmtpnSJQ8@google.com>
References: <20220126152210.3044876-1-pbonzini@redhat.com>
 <20220126152210.3044876-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220126152210.3044876-3-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 26, 2022, Paolo Bonzini wrote:
> +static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)
> +{
> +	if (attr->group)
> +		return -ENXIO;
> +
> +	switch (attr->attr) {
> +	case KVM_X86_XCOMP_GUEST_SUPP:
> +		if (put_user(supported_xcr0, (u64 __user *)attr->addr))

Deja vu[*].

  arch/x86/kvm/x86.c: In function ‘kvm_x86_dev_get_attr’:
  arch/x86/kvm/x86.c:4345:46: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
   4345 |                 if (put_user(supported_xcr0, (u64 __user *)attr->addr))
        |                                              ^
  arch/x86/include/asm/uaccess.h:221:31: note: in definition of macro ‘do_put_user_call’
    221 |         register __typeof__(*(ptr)) __val_pu asm("%"_ASM_AX);           \
        |                               ^~~
  arch/x86/kvm/x86.c:4345:21: note: in expansion of macro ‘put_user’
   4345 |                 if (put_user(supported_xcr0, (u64 __user *)attr->addr))
        |                     ^~~~~~~~
  arch/x86/kvm/x86.c:4345:46: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
   4345 |                 if (put_user(supported_xcr0, (u64 __user *)attr->addr))
        |                                              ^
  arch/x86/include/asm/uaccess.h:223:21: note: in definition of macro ‘do_put_user_call’
    223 |         __ptr_pu = (ptr);                                               \
        |                     ^~~
  arch/x86/kvm/x86.c:4345:21: note: in expansion of macro ‘put_user’
   4345 |                 if (put_user(supported_xcr0, (u64 __user *)attr->addr))
        |                     ^~~~~~~~
  arch/x86/kvm/x86.c:4345:46: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
   4345 |                 if (put_user(supported_xcr0, (u64 __user *)attr->addr))
        |                                              ^
  arch/x86/include/asm/uaccess.h:230:45: note: in definition of macro ‘do_put_user_call’
    230 |                        [size] "i" (sizeof(*(ptr)))                      \
        |                                             ^~~
  arch/x86/kvm/x86.c:4345:21: note: in expansion of macro ‘put_user’
   4345 |                 if (put_user(supported_xcr0, (u64 __user *)attr->addr))

Given that we're collectively 2 for 2 in mishandling {g,s}et_attr(), what about
a prep pacth like so?  Compile tested only...

From: Sean Christopherson <seanjc@google.com>
Date: Thu, 27 Jan 2022 07:31:53 -0800
Subject: [PATCH] KVM: x86: Add a helper to retrieve userspace address from
 kvm_device_attr

Add a helper to handle converting the u64 userspace address embedded in
struct kvm_device_attr into a userspace pointer, it's all too easy to
forget the intermediate "unsigned long" cast as well as the truncation
check.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8033eca6f3a1..67836f7c71f5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4335,14 +4335,28 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	return r;
 }

+static inline void __user *kvm_get_attr_addr(struct kvm_device_attr *attr)
+{
+	void __user *uaddr = (void __user*)(unsigned long)attr->addr;
+
+	if ((u64)(unsigned long)uaddr != attr->addr)
+		return ERR_PTR(-EFAULT);
+	return uaddr;
+}
+
 static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)
 {
+	u64 __user *uaddr = kvm_get_attr_addr(attr);
+
 	if (attr->group)
 		return -ENXIO;

+	if (IS_ERR(uaddr))
+		return PTR_ERR(uaddr);
+
 	switch (attr->attr) {
 	case KVM_X86_XCOMP_GUEST_SUPP:
-		if (put_user(supported_xcr0, (u64 __user *)attr->addr))
+		if (put_user(supported_xcr0, uaddr))
 			return -EFAULT;
 		return 0;
 	default:
@@ -5070,11 +5084,11 @@ static int kvm_arch_tsc_has_attr(struct kvm_vcpu *vcpu,
 static int kvm_arch_tsc_get_attr(struct kvm_vcpu *vcpu,
 				 struct kvm_device_attr *attr)
 {
-	u64 __user *uaddr = (u64 __user *)(unsigned long)attr->addr;
+	u64 __user *uaddr = kvm_get_attr_addr(attr);
 	int r;

-	if ((u64)(unsigned long)uaddr != attr->addr)
-		return -EFAULT;
+	if (IS_ERR(uaddr))
+		return PTR_ERR(uaddr);

 	switch (attr->attr) {
 	case KVM_VCPU_TSC_OFFSET:
@@ -5093,12 +5107,12 @@ static int kvm_arch_tsc_get_attr(struct kvm_vcpu *vcpu,
 static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
 				 struct kvm_device_attr *attr)
 {
-	u64 __user *uaddr = (u64 __user *)(unsigned long)attr->addr;
+	u64 __user *uaddr = kvm_get_attr_addr(attr);
 	struct kvm *kvm = vcpu->kvm;
 	int r;

-	if ((u64)(unsigned long)uaddr != attr->addr)
-		return -EFAULT;
+	if (IS_ERR(uaddr))
+		return PTR_ERR(uaddr);

 	switch (attr->attr) {
 	case KVM_VCPU_TSC_OFFSET: {
--



[*] https://lore.kernel.org/all/20211007231647.3553604-1-seanjc@google.com


> +			return -EFAULT;
> +		return 0;
> +	default:
> +		return -ENXIO;
> +		break;
> +	}
> +}
> +
