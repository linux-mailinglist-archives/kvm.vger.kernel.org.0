Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1326631066D
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 09:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbhBEIQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 03:16:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20861 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231312AbhBEIQL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Feb 2021 03:16:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612512885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P2NuhnhqQ1JjkO4MXCR0Uighr1GLTR5T9+Ahy1PBs6c=;
        b=TwNKiMqtn1eTrMCC/STammX5P0CWja+6DQ0B7yfgUElxHfRmw3PMIooOpZYwXso/bvn1MX
        1Gh7O+qVwxlDd8LDu7Qu91Lk1tYi2AZAYuVGlSBLwM8DqaxYdylW/IJWF6nl9/WgGAF2+9
        WU5hDTQf5Z0T2flDn91Jh+HulOk7N/k=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-qU4A1CbYMFKZ6ARZC5iDKQ-1; Fri, 05 Feb 2021 03:14:43 -0500
X-MC-Unique: qU4A1CbYMFKZ6ARZC5iDKQ-1
Received: by mail-ej1-f70.google.com with SMTP id eb5so6222368ejc.6
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 00:14:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P2NuhnhqQ1JjkO4MXCR0Uighr1GLTR5T9+Ahy1PBs6c=;
        b=FFuTQLanGjkuU5KBDbLcSzOgEePFsJwvGZbg1+z38Thk7nbQsgspVK2uBmJRSrWXHU
         zG1Dj5z/qCqeUeExznHltKIisUfydKsqIBTi223Dluq/CXf5+fzuEZlSoZsKWcyI8UPl
         JiR6vd337AJZioLlca1JsGvNs2N0QlLrD4XpViSkOdiyw4LwGWBKAaW1fcW+e7+5gwKq
         Xt1oDHJWzKJE5tr2ez1Md0vqlroq0OCo9E8I4+N/BUJI54hC2ZFk+IbrtNm5gzpoGu1p
         i1W4AIm9D6wVp2xS4pzSMa3IZc57c9VQ/Alwn9QankwN8Tve3bljRkAmdD0FpcQD3Lnw
         L74w==
X-Gm-Message-State: AOAM530PavTPSQrv8BqoHqsrT/NzixKkRw4DrybUl2ibD/6xigW21hPV
        nRneEhjKqiQHkWQtspbhgGAjuoqpEF4n+t6mTIur3Osa7mVrvbSuv1Bod7eMjQIE4RFTEoQgn6W
        dVSPvW+TrJgc6
X-Received: by 2002:a17:907:2805:: with SMTP id eb5mr2935293ejc.277.1612512881952;
        Fri, 05 Feb 2021 00:14:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJycyv60a64zvcZTMc+eBlM8UaXGVBVLWc2PvchXgOrKiTtkmJD+knbGnTDls90oWMl8nHUnOw==
X-Received: by 2002:a17:907:2805:: with SMTP id eb5mr2935283ejc.277.1612512881739;
        Fri, 05 Feb 2021 00:14:41 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z13sm3682160edc.73.2021.02.05.00.14.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 00:14:40 -0800 (PST)
Subject: Re: [PATCH 1/1 v2] nSVM: Test effect of host RFLAGS.TF on VMRUN
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com
References: <20210204232951.104755-1-krish.sadhukhan@oracle.com>
 <20210204232951.104755-2-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a3cfdf3a-9f6f-76e5-3cb8-2aaf117e798d@redhat.com>
Date:   Fri, 5 Feb 2021 09:14:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210204232951.104755-2-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/02/21 00:29, Krish Sadhukhan wrote:
> 
> +static void host_rflags_prepare(struct svm_test *test)
> +{
> +	default_prepare(test);
> +	handle_exception(DB_VECTOR, host_rflags_db_handler);
> +	set_test_stage(test, 0);
> +	/*
> +	 * We trigger a #UD in order to find out the RIP of VMRUN instruction
> +	 */
> +	wrmsr(MSR_EFER, rdmsr(MSR_EFER) & ~EFER_SVME);
> +	handle_exception(UD_VECTOR, host_rflags_ud_handler);
> +}
> +

I think you'd get the RIP of VMLOAD, not VMRUN.

Maybe something like:

diff --git a/x86/svm.c b/x86/svm.c
index a1808c7..88d8452 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -208,14 +208,14 @@ struct regs get_regs(void)

  struct svm_test *v2_test;

-#define ASM_VMRUN_CMD                           \
+#define ASM_PRE_VMRUN                           \
                  "vmload %%rax\n\t"              \
                  "mov regs+0x80, %%r15\n\t"      \
                  "mov %%r15, 0x170(%%rax)\n\t"   \
                  "mov regs, %%r15\n\t"           \
                  "mov %%r15, 0x1f8(%%rax)\n\t"   \
-                LOAD_GPR_C                      \
-                "vmrun %%rax\n\t"               \
+                LOAD_GPR_C
+#define ASM_POST_VMRUN                          \
                  SAVE_GPR_C                      \
                  "mov 0x170(%%rax), %%r15\n\t"   \
                  "mov %%r15, regs+0x80\n\t"      \
@@ -232,7 +232,9 @@ int svm_vmrun(void)
  	regs.rdi = (ulong)v2_test;

  	asm volatile (
-		ASM_VMRUN_CMD
+		ASM_PRE_VMRUN
+                "vmrun %%rax\n\t"
+		ASM_POST_VMRUN
  		:
  		: "a" (virt_to_phys(vmcb))
  		: "memory", "r15");
@@ -240,6 +242,7 @@ int svm_vmrun(void)
  	return (vmcb->control.exit_code);
  }

+extern unsigned char vmrun_rip;
  static void test_run(struct svm_test *test)
  {
  	u64 vmcb_phys = virt_to_phys(vmcb);
@@ -258,7 +261,9 @@ static void test_run(struct svm_test *test)
  			"sti \n\t"
  			"call *%c[PREPARE_GIF_CLEAR](%[test]) \n \t"
  			"mov %[vmcb_phys], %%rax \n\t"
-			ASM_VMRUN_CMD
+		        ASM_PRE_VMRUN
+                        "vmrun_rip: vmrun %%rax\n\t"
+		        ASM_POST_VMRUN
  			"cli \n\t"
  			"stgi"
  			: // inputs clobbered by the guest:

(untested)

Paolo

