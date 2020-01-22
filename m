Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B35C145092
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 10:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729946AbgAVJrm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 04:47:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40719 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730667AbgAVJre (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 04:47:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579686453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8ZWQytKe+Nrv18x1TGeK1echwJbunum5JCWbmDqOWpU=;
        b=aY+MgOLq6WjwzVJNSJBlKI7BUZawMhtRgV7pOfR0dB+VI8r282n2D6nCYL5Ywl3cKGnvFb
        AEfAFGWhSxlrvLs6Jf/KDwY1xnU21lCcMJ4MkWvzRsj/YoZIeWM9Lv6KnKX0skAjOOa+ks
        EAEmLDe6xdj/bWVxqMGU2EO2c5ZzmTw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-nSH_mAo7OVi28ePd-FWXBg-1; Wed, 22 Jan 2020 04:47:31 -0500
X-MC-Unique: nSH_mAo7OVi28ePd-FWXBg-1
Received: by mail-wm1-f69.google.com with SMTP id b133so284746wmb.2
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2020 01:47:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=8ZWQytKe+Nrv18x1TGeK1echwJbunum5JCWbmDqOWpU=;
        b=ZRNLsSofGpvC91OunbWFicHoLB3zQV0ovefiW41Yg2SgBOtNzWPIhd6nd8P1QBTxxg
         +T598NsTDxC25AMOD8oX6f4Fz2MlQXu7CnYWGFklg/m+g1tYHW+Hj7tpBYWLTzXslvY5
         TeUkAlDzsOfZiL8teNL6+b5/Oq0tXPK57IdJUmuPxf7tB20Ai5+gkt6YQESH2pByCWPX
         p1N0v2fYpe9pZLz61qAlD9M9Y7Y76IJ1r//l226IbFTE1IG5q3W+yCA2RLJ0DWy2IZAz
         X+SLs8/yLt8T/6+YYppADm0eafcPvnOR7YHgetNRSI2Nx4x/JZjLOzNHyp268AwEfbcN
         qujQ==
X-Gm-Message-State: APjAAAX2ZtCmYCu+3LvvEmEOFnPsAkmOUpUMfz4JYdeiJLDUJOJ+C7U9
        RUGrHKBxm6dOluoEI5h5huyv0nhVS3aRIv7QDpAj7q63E/xQ5En5j0j1Jx1zEJhSu8FVxAggOMC
        n59fcoaFqQnyf
X-Received: by 2002:a5d:6144:: with SMTP id y4mr9957001wrt.367.1579686450564;
        Wed, 22 Jan 2020 01:47:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqxHsmIdjnLbiCnRSA2R0yh874Z4YYndqKS0L914Rmdlb4Y42Yr5Jws35ypmLWm9J3TVULIPxg==
X-Received: by 2002:a5d:6144:: with SMTP id y4mr9956974wrt.367.1579686450243;
        Wed, 22 Jan 2020 01:47:30 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id c17sm56451592wrr.87.2020.01.22.01.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 01:47:29 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86: VMX: Check preconditions for RDTSC test
In-Reply-To: <20200122073959.192050-1-oupton@google.com>
References: <20200122073959.192050-1-oupton@google.com>
Date:   Wed, 22 Jan 2020 10:47:28 +0100
Message-ID: <87wo9jstzj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Oliver Upton <oupton@google.com> writes:

> The RDTSC VM-exit test requires the 'use TSC offsetting' processor-based
> VM-execution control be allowed on the host. Check this precondition
> before running the test rather than asserting it later on to avoid
> erroneous failures on a host without TSC offsetting.
>
> Cc: Aaron Lewis <aaronlewis@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  x86/vmx_tests.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 3b150323b325..de9a931216e2 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -9161,9 +9161,6 @@ static void vmx_vmcs_shadow_test(void)
>   */
>  static void reset_guest_tsc_to_zero(void)
>  {
> -	TEST_ASSERT_MSG(ctrl_cpu_rev[0].clr & CPU_USE_TSC_OFFSET,
> -			"Expected support for 'use TSC offsetting'");
> -
>  	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_USE_TSC_OFFSET);
>  	vmcs_write(TSC_OFFSET, -rdtsc());
>  }
> @@ -9210,6 +9207,11 @@ static void rdtsc_vmexit_diff_test(void)
>  	int fail = 0;
>  	int i;
>  
> +	if (!(ctrl_cpu_rev[0].clr & CPU_USE_TSC_OFFSET)) {
> +		printf("CPU doesn't support the 'use TSC offsetting' processor-based VM-execution control.\n");
> +		return;
> +	}
> +

Can we use test_skip() instead, something like

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index dd32b3aef08b..bfecf36d37ef 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -9166,6 +9166,9 @@ static void rdtsc_vmexit_diff_test(void)
        int fail = 0;
        int i;
 
+       if (!(ctrl_cpu_rev[0].clr & CPU_USE_TSC_OFFSET))
+               test_skip("CPU doesn't support the 'use TSC offsetting' processor-based VM-execution control.\n");
+
        test_set_guest(rdtsc_vmexit_diff_test_guest);
 
        reset_guest_tsc_to_zero();

?

>  	test_set_guest(rdtsc_vmexit_diff_test_guest);
>  
>  	reset_guest_tsc_to_zero();

-- 
Vitaly

