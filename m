Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04A9429E8C
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 09:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbhJLH0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 03:26:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:22548 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232500AbhJLH0m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 03:26:42 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10134"; a="227351934"
X-IronPort-AV: E=Sophos;i="5.85,367,1624345200"; 
   d="scan'208";a="227351934"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 00:24:41 -0700
X-IronPort-AV: E=Sophos;i="5.85,367,1624345200"; 
   d="scan'208";a="490831842"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.29.110]) ([10.255.29.110])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 00:24:39 -0700
Subject: Re: [patch 28/31] x86/sev: Include fpu/xcr.h
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20211011215813.558681373@linutronix.de>
 <20211011223611.964445769@linutronix.de>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <2e0ab426-acd4-0c8b-6f80-8ce4d2bcf29d@intel.com>
Date:   Tue, 12 Oct 2021 15:24:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211011223611.964445769@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/2021 8:00 AM, Thomas Gleixner wrote:
> Include the header which only provides the XRC accessors. That's all what
                                               ^
                                             typo, should be XCR

> is needed here.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>   arch/x86/kernel/sev.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -23,7 +23,7 @@
>   #include <asm/stacktrace.h>
>   #include <asm/sev.h>
>   #include <asm/insn-eval.h>
> -#include <asm/fpu/internal.h>
> +#include <asm/fpu/xcr.h>
>   #include <asm/processor.h>
>   #include <asm/realmode.h>
>   #include <asm/traps.h>
> 

