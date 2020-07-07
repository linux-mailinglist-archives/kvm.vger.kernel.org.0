Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9B2216427
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 04:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgGGCwT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 22:52:19 -0400
Received: from mga07.intel.com ([134.134.136.100]:32557 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726915AbgGGCwT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 22:52:19 -0400
IronPort-SDR: Td8kwsKDNqcvyySer+GcRKZ+z1318EsHTs8eM7iXQdFHqVUelUU61faC/28b9vMPxCjl+vgBeE
 luB9PgSOOANg==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="212503036"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="212503036"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 19:52:18 -0700
IronPort-SDR: a8RBZppPu1jANqtiX8SwjiqdFbHckyN1+a1iLVXD7cZEqKi3ZWXTHWItstkNMmYrBk4kDC+pL9
 DXnVJ0WyO8Zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="305502199"
Received: from km-skylake-client-platform.sc.intel.com ([10.3.52.141])
  by fmsmga004.fm.intel.com with ESMTP; 06 Jul 2020 19:52:18 -0700
Message-ID: <89e07361c8f575bc029071a0f7789e19d0431c0b.camel@intel.com>
Subject: Re: [PATCH v2 2/4] x86/cpufeatures: Enumerate TSX suspend load
 address tracking instructions
From:   Kyung Min Park <kyung.min.park@intel.com>
To:     Cathy Zhang <cathy.zhang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, ricardo.neri-calderon@linux.intel.com,
        jpoimboe@redhat.com, gregkh@linuxfoundation.org,
        ak@linux.intel.com, dave.hansen@intel.com, tony.luck@intel.com,
        ravi.v.shankar@intel.com
Date:   Mon, 06 Jul 2020 19:36:27 -0700
In-Reply-To: <1594088183-7187-3-git-send-email-cathy.zhang@intel.com>
References: <1594088183-7187-1-git-send-email-cathy.zhang@intel.com>
         <1594088183-7187-3-git-send-email-cathy.zhang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Cathy,

On Tue, 2020-07-07 at 10:16 +0800, Cathy Zhang wrote:
> Intel TSX suspend load tracking instructions aim to give a way to
> choose which memory accesses do not need to be tracked in the TSX
> read set. Add TSX suspend load tracking CPUID feature flag TSXLDTRK
> for enumeration.
> 
> A processor supports Intel TSX suspend load address tracking if
> CPUID.0x07.0x0:EDX[16] is present. Two instructions XSUSLDTRK,
> XRESLDTRK
> are available when this feature is present.
> 
> The CPU feature flag is shown as "tsxldtrk" in /proc/cpuinfo.
> 
> Detailed information on the instructions and CPUID feature flag
> TSXLDTRK
> can be found in the latest Intel Architecture Instruction Set
> Extensions
> and Future Features Programming Reference and Intel 64 and IA-32
> Architectures Software Developer's Manual.
> 
> Signed-off-by: Kyung Min Park <kyung.min.park@intel.com>
> Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h
> b/arch/x86/include/asm/cpufeatures.h
> index adf45cf..34b66d7 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -366,6 +366,7 @@
>  #define X86_FEATURE_MD_CLEAR		(18*32+10) /* VERW clears CPU
> buffers */
>  #define X86_FEATURE_TSX_FORCE_ABORT	(18*32+13) /* ""
> TSX_FORCE_ABORT */
>  #define X86_FEATURE_SERIALIZE		(18*32+14) /* SERIALIZE
> instruction */
> +#define X86_FEATURE_TSX_LDTRK           (18*32+16) /* TSX Suspend
> Load Address Tracking */

Since you are using the flag name to "TSX_LDTRK", the commit message
needs to be changed accordingly. The commit message is saying
"tsxldtrk", not "tsx_ldtrk".

>  #define X86_FEATURE_PCONFIG		(18*32+18) /* Intel PCONFIG */
>  #define X86_FEATURE_SPEC_CTRL		(18*32+26) /* ""
> Speculation Control (IBRS + IBPB) */
>  #define X86_FEATURE_INTEL_STIBP		(18*32+27) /* "" Single
> Thread Indirect Branch Predictors */

