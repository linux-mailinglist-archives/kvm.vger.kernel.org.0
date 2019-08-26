Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A425B9CB7E
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 10:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730535AbfHZIZ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 04:25:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38436 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730536AbfHZIZ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 04:25:57 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 80B744E924
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 08:25:56 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id a17so9335966wrr.10
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 01:25:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=DJP3ebkF5F91gjKUBTSHw4NqzrDzdKKWY5xs8eEW2AU=;
        b=f5vT7J00KpzNhKoTmyr2CYMFFn/mVdqfc2Ger+IU0A9RnejF8Rn7J8vBvuZWxx+2Qm
         DLxdy3SezM2ZiqYpM7igk3WwZ8jtIC+Rj+B53Zvq+GY4Fjizu1aF667fiarRJgmEaYn2
         C38KJUa8c3s6toYK5KoBZzotzjmtstt1FO0GDRC7p+Cn8grRQ8E9TIoxv3LPSEjzJ9iT
         21J8Towjv7N+ghcoH1CbWQCOcKAjAuE68VU6qcNnEUZ9ZMFDNjLEcSt/amDqku6gcDwS
         a12Fjx4Lg42kPyFs7VuUCCfivde49m5yyve/Ly/OTS2cZZlYuy3O1asD8x+EQaN/88bi
         s7eg==
X-Gm-Message-State: APjAAAVPXS/4rYQZGn0GMppzrb33LsdX0bPCKBCA21enL9e4iAWfPj8q
        O7o8Xn4tFJHZzk2+ChvpnEaLZwCBUbHsNT4RHf3oGIJ9znkqylhXLRk2TjIxSiBE3eHUl7iAPKl
        SP3N0IDjNW/zL
X-Received: by 2002:adf:e708:: with SMTP id c8mr21073715wrm.25.1566807954316;
        Mon, 26 Aug 2019 01:25:54 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxVzeHIBdq7rrUDST30gRSNyAKlXw/4uAgCuewaUWQEqmzf4E2R3ytaM88091c6yWUnj1A2aw==
X-Received: by 2002:adf:e708:: with SMTP id c8mr21073693wrm.25.1566807954071;
        Mon, 26 Aug 2019 01:25:54 -0700 (PDT)
Received: from vitty.brq.redhat.com (ip-89-176-161-20.net.upcbroadband.cz. [89.176.161.20])
        by smtp.gmail.com with ESMTPSA id o5sm10227823wrv.20.2019.08.26.01.25.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 01:25:53 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Detect max PA width from cpuid
In-Reply-To: <20190826075728.21646-1-peterx@redhat.com>
References: <20190826075728.21646-1-peterx@redhat.com>
Date:   Mon, 26 Aug 2019 10:25:55 +0200
Message-ID: <874l24nxik.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Xu <peterx@redhat.com> writes:

> The dirty_log_test is failing on some old machines like Xeon E3-1220
> with tripple faults when writting to the tracked memory region:

s,writting,writing,

>
>   Test iterations: 32, interval: 10 (ms)
>   Testing guest mode: PA-bits:52, VA-bits:48, 4K pages
>   guest physical test memory offset: 0x7fbffef000
>   ==== Test Assertion Failure ====
>   dirty_log_test.c:138: false
>   pid=6137 tid=6139 - Success
>      1  0x0000000000401ca1: vcpu_worker at dirty_log_test.c:138
>      2  0x00007f3dd9e392dd: ?? ??:0
>      3  0x00007f3dd9b6a132: ?? ??:0
>   Invalid guest sync status: exit_reason=SHUTDOWN
>

This patch breaks on my AMD machine with

# cpuid -1 -l 0x80000008
CPU:
   Physical Address and Linear Address Size (0x80000008/eax):
      maximum physical address bits         = 0x30 (48)
      maximum linear (virtual) address bits = 0x30 (48)
      maximum guest physical address bits   = 0x0 (0)


Pre-patch:

# ./dirty_log_test 
Test iterations: 32, interval: 10 (ms)
Testing guest mode: PA-bits:52, VA-bits:48, 4K pages
guest physical test memory offset: 0x7fbffef000
Dirtied 139264 pages
Total bits checked: dirty (135251), clear (7991709), track_next (29789)

Post-patch:

# ./dirty_log_test 
Test iterations: 32, interval: 10 (ms)
Testing guest mode: PA-bits:52, VA-bits:48, 4K pages
Supported guest physical address width: 48
guest physical test memory offset: 0xffffbffef000
==== Test Assertion Failure ====
  dirty_log_test.c:141: false
  pid=77983 tid=77985 - Success
     1	0x0000000000401d12: vcpu_worker at dirty_log_test.c:138
     2	0x00007f636374358d: ?? ??:0
     3	0x00007f63636726a2: ?? ??:0
  Invalid guest sync status: exit_reason=SHUTDOWN



> It's because previously we moved the testing memory region from a
> static place (1G) to the top of the system's physical address space,
> meanwhile we stick to 39 bits PA for all the x86_64 machines.  That's
> not true for machines like Xeon E3-1220 where it only supports 36.
>
> Let's unbreak this test by dynamically detect PA width from CPUID
> 0x80000008.  Meanwhile, even allow kvm_get_supported_cpuid_index() to
> fail.  I don't know whether that could be useful because I think
> 0x80000008 should be there for all x86_64 hosts, but I also think it's
> not really helpful to assert in the kvm_get_supported_cpuid_index().
>
> Fixes: b442324b581556e
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Andrew Jones <drjones@redhat.com>
> CC: Radim Krčmář <rkrcmar@redhat.com>
> CC: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c  | 22 +++++++++++++------
>  .../selftests/kvm/lib/x86_64/processor.c      |  3 ---
>  2 files changed, 15 insertions(+), 10 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index ceb52b952637..111592f3a1d7 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -274,18 +274,26 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>  	DEBUG("Testing guest mode: %s\n", vm_guest_mode_string(mode));
>  
>  #ifdef __x86_64__
> -	/*
> -	 * FIXME
> -	 * The x86_64 kvm selftests framework currently only supports a
> -	 * single PML4 which restricts the number of physical address
> -	 * bits we can change to 39.
> -	 */
> -	guest_pa_bits = 39;
> +	{
> +		struct kvm_cpuid_entry2 *entry;
> +
> +		entry = kvm_get_supported_cpuid_entry(0x80000008);
> +		/*
> +		 * Supported PA width can be smaller than 52 even if
> +		 * we're with VM_MODE_P52V48_4K mode.  Fetch it from
> +		 * the host to update the default value (SDM 4.1.4).
> +		 */
> +		if (entry)
> +			guest_pa_bits = entry->eax & 0xff;
> +		else
> +			guest_pa_bits = 32;
> +	}
>  #endif
>  #ifdef __aarch64__
>  	if (guest_pa_bits != 40)
>  		type = KVM_VM_TYPE_ARM_IPA_SIZE(guest_pa_bits);
>  #endif
> +	printf("Supported guest physical address width: %d\n", guest_pa_bits);
>  	max_gfn = (1ul << (guest_pa_bits - guest_page_shift)) - 1;
>  	guest_page_size = (1ul << guest_page_shift);
>  	/*
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 6cb34a0fa200..9de2fd310ac8 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -760,9 +760,6 @@ kvm_get_supported_cpuid_index(uint32_t function, uint32_t index)
>  			break;
>  		}
>  	}
> -
> -	TEST_ASSERT(entry, "Guest CPUID entry not found: (EAX=%x, ECX=%x).",
> -		    function, index);
>  	return entry;
>  }

-- 
Vitaly
