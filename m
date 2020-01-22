Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A63BF1453EE
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 12:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgAVLj0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 06:39:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48842 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726094AbgAVLj0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 06:39:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579693164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2IqhsgyS2xu++Il+D8BmmBt2+Z6MzR/t1TREupEBm5E=;
        b=Tc6fY+BSaPlJnTTeW9rt0VRkmZtoP9C21Zmt2o7dT4nYQwIKQ2Agye2psnHsLFRB5Os9b5
        sohR36qxyWjxT04ZdwyuXtAtTqLi11z5ONdUPX3zujDqxsT1cWYzWhl2kEfJ3Jcp1gRBi/
        PlwMi2qXBEtV8wLy9VeJw8ImcBmiblo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-RRseyOljMtePqcUzlNS4SA-1; Wed, 22 Jan 2020 06:39:22 -0500
X-MC-Unique: RRseyOljMtePqcUzlNS4SA-1
Received: by mail-wm1-f72.google.com with SMTP id 18so1920632wmp.0
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2020 03:39:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=2IqhsgyS2xu++Il+D8BmmBt2+Z6MzR/t1TREupEBm5E=;
        b=QdnmQ/gj018JfYNi5eHHn79JseEmYEkw8LojM7LCq5lkS2jVl+KhCe09HLb2l/SVUM
         jtXjxXdbUHx+lPR8mEh4j1rqRwoPgiwgTrpHnnLvfvnxOR9tyP82SB7RGXxbP2Lgk1Xo
         Dz4xYrEGNzbJZG6y2jCCSI9isHXlSMUZXjHByt9ACqj9uHWEKNLaDh4f9aIXGiwEJhji
         NMoBw+G4d59pytlLKLJJANWpLpO9ILM7NJZCcRykDU+0Q05+KDvGkBVhe/DN7OXZkpFP
         7jpg0lfSUPHSNam4C1aoid1VWei+XXWW7+wHop6j/hSbde01fGjQwbEHP/wfWPsnZw3R
         W+Ug==
X-Gm-Message-State: APjAAAUR7QE4sOCQ1Szgkx/qrQREc05qaJzB3zeLOnOCycuS1NqyQXSw
        z860GswuUSGeCnPNPD8z1oWHNSbcPC85ysfAzRhxWAP/5WBM7W6gI+kuLkJ2LTFDwMDb+zflROb
        p3H/jcTQcfiHY
X-Received: by 2002:adf:ef49:: with SMTP id c9mr11349078wrp.292.1579693161322;
        Wed, 22 Jan 2020 03:39:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqynbkPPNttjl6YChuItg+Zna6yPdTLKCINbf8Ff2vSv3PMxLiv0DUBGxgTwyX+QG8Ls6VEsig==
X-Received: by 2002:adf:ef49:: with SMTP id c9mr11349054wrp.292.1579693161038;
        Wed, 22 Jan 2020 03:39:21 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id g7sm56477530wrq.21.2020.01.22.03.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 03:39:20 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [kvm-unit-tests PATCH v2] x86: VMX: Check precondition for RDTSC test
In-Reply-To: <20200122100356.240412-1-oupton@google.com>
References: <20200122100356.240412-1-oupton@google.com>
Date:   Wed, 22 Jan 2020 12:39:19 +0100
Message-ID: <87r1zrsot4.fsf@vitty.brq.redhat.com>
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
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  x86/vmx_tests.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 3b150323b325..b31c360c5f3c 100644
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
> @@ -9210,6 +9207,9 @@ static void rdtsc_vmexit_diff_test(void)
>  	int fail = 0;
>  	int i;
>  
> +	if (!(ctrl_cpu_rev[0].clr & CPU_USE_TSC_OFFSET))
> +		test_skip("CPU doesn't support the 'use TSC offsetting' processor-based VM-execution control.\n");
> +
>  	test_set_guest(rdtsc_vmexit_diff_test_guest);
>  
>  	reset_guest_tsc_to_zero();

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

