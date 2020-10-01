Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50EA42804D9
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 19:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732417AbgJARNW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 13:13:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57418 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732274AbgJARMy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 13:12:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601572372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Q48s+E8C9lSChaL/yuUg/5Ydceh1b0ieJ90+S0XJwo=;
        b=DR8scT3f7+L1kuLgkiC5eD5q8arTvGDv6AcFSqYt5rNzZxS7H+dhQjIeLBM0fD03EvMeib
        90sOWkz54wZzYFDinHsJQUl1r4OqdgcF+WFzlJO1yoLxnUdZExL/WQXPps0I4gfgAXstXx
        rZobxax6SSh/InmHlTAqZ+0BUAOQ5D8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-FcUuZ57xNbW6Bdpr_8GXFQ-1; Thu, 01 Oct 2020 13:12:50 -0400
X-MC-Unique: FcUuZ57xNbW6Bdpr_8GXFQ-1
Received: by mail-wm1-f72.google.com with SMTP id b14so1110373wmj.3
        for <kvm@vger.kernel.org>; Thu, 01 Oct 2020 10:12:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4Q48s+E8C9lSChaL/yuUg/5Ydceh1b0ieJ90+S0XJwo=;
        b=JIjxmhg/KnQ5FzYobUF3dOf5gMPYSyw58HD2s7vTdauDiSiTLT74Hbsrxt8CAsB/6Y
         kDGwy2o9lAjAW/51I2iI+DApMV/Kyeq7u2xYrN2An+y/4annCA52GTSLkZTq+BvqAFsA
         ve9+49kzbCJKJlfOXk9cjIJril7VlLWJ2sH12UlcQa9L7/fr3V/srqNqhUQIHSvc05Hq
         UNdczloJSXiBl0u45WKFD7m9uUhfFEKKNWk/UAYiH90dbDGQcX/G+wyBKc+w850SNqJS
         tZhxazLPsJZzApys1UBZDfgeWexwMYl6uwEi3Nmt4clY801X/OyC4A54oz380kmg3i1f
         p2RA==
X-Gm-Message-State: AOAM5314Pl6/5UrnGDBB3pNbTptGtx25ZgmI9WopeJkFQ2YQQCZ+3acu
        f1fIs9Nju1YsoMyzeNH4wE6Gs+KOxiFsbypSg27WOKBhXZ9+pLtZ+oBircjleAwr9Vi4HSrDn5r
        bFdFQstb7VWbS
X-Received: by 2002:a1c:7d4d:: with SMTP id y74mr1016224wmc.73.1601572369002;
        Thu, 01 Oct 2020 10:12:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxtodc1hikTbWs4R8Nux8w9l8oy6iJC0tR6gfLkYYGjpq1vOllDPJuHr0GiIJDhGl+ITejFog==
X-Received: by 2002:a1c:7d4d:: with SMTP id y74mr1016209wmc.73.1601572368770;
        Thu, 01 Oct 2020 10:12:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:86de:492a:fae3:16f2? ([2001:b07:6468:f312:86de:492a:fae3:16f2])
        by smtp.gmail.com with ESMTPSA id u12sm10084752wrt.81.2020.10.01.10.12.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2020 10:12:48 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: Add one-off test to verify setting
 LA57 fails when it's unsupported
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org
References: <20200930043436.29270-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5bfad3fd-6362-8795-f9e5-7cbafeecffab@redhat.com>
Date:   Thu, 1 Oct 2020 19:12:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200930043436.29270-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/09/20 06:34, Sean Christopherson wrote:
> Add an i386-only test to check that setting CR4.LA57 fails when 5-level
> paging is not exposed to the guest.  Old versions of KVM don't intercept
> LA57 by default on VMX, which means a clever guest could set LA57
> without it being detected by KVM.
> 
> This test is i386-only because toggling CR4.LA57 in long mode is
> illegal, i.e. won't verify the desired KVM behavior.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  x86/Makefile.i386 |  2 +-
>  x86/la57.c        | 13 +++++++++++++
>  x86/unittests.cfg |  4 ++++
>  3 files changed, 18 insertions(+), 1 deletion(-)
>  create mode 100644 x86/la57.c
> 
> diff --git a/x86/Makefile.i386 b/x86/Makefile.i386
> index be9d6bc..c04e5aa 100644
> --- a/x86/Makefile.i386
> +++ b/x86/Makefile.i386
> @@ -6,6 +6,6 @@ COMMON_CFLAGS += -mno-sse -mno-sse2
>  cflatobjs += lib/x86/setjmp32.o
>  
>  tests = $(TEST_DIR)/taskswitch.flat $(TEST_DIR)/taskswitch2.flat \
> -	$(TEST_DIR)/cmpxchg8b.flat
> +	$(TEST_DIR)/cmpxchg8b.flat $(TEST_DIR)/la57.flat
>  
>  include $(SRCDIR)/$(TEST_DIR)/Makefile.common
> diff --git a/x86/la57.c b/x86/la57.c
> new file mode 100644
> index 0000000..b537bb2
> --- /dev/null
> +++ b/x86/la57.c
> @@ -0,0 +1,13 @@
> +#include "libcflat.h"
> +#include "processor.h"
> +#include "desc.h"
> +
> +int main(int ac, char **av)
> +{
> +	int vector = write_cr4_checking(read_cr4() | X86_CR4_LA57);
> +	int expected = this_cpu_has(X86_FEATURE_LA57) ? 0 : 13;
> +
> +	report(vector == expected, "%s when CR4.LA57 %ssupported",
> +	       expected ? "#GP" : "No fault", expected ? "un" : "");
> +	return report_summary();
> +}
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 3a79151..6eb8e19 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -245,6 +245,10 @@ arch = x86_64
>  file = umip.flat
>  extra_params = -cpu qemu64,+umip
>  
> +[la57]
> +file = la57.flat
> +arch = i386
> +
>  [vmx]
>  file = vmx.flat
>  extra_params = -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vmx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test"
> 

Applied, thanks.

Paolo

