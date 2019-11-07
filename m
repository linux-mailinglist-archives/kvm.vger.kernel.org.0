Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB115F2449
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 02:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbfKGBby (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 20:31:54 -0500
Received: from mga06.intel.com ([134.134.136.31]:30274 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727798AbfKGBby (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 20:31:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 17:31:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,276,1569308400"; 
   d="scan'208";a="212905617"
Received: from ranerica-svr.sc.intel.com ([172.25.110.23])
  by fmsmga001.fm.intel.com with ESMTP; 06 Nov 2019 17:31:53 -0800
Date:   Wed, 6 Nov 2019 17:31:36 -0800
From:   Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
To:     "Moger, Babu" <Babu.Moger@amd.com>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "nayna@linux.ibm.com" <nayna@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "bshanks@codeweavers.com" <bshanks@codeweavers.com>
Subject: Re: [PATCH v3 1/2] x86/Kconfig: Rename UMIP config parameter
Message-ID: <20191107013136.GA9028@ranerica-svr.sc.intel.com>
References: <157298900783.17462.2778215498449243912.stgit@naples-babu.amd.com>
 <157298912544.17462.2018334793891409521.stgit@naples-babu.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157298912544.17462.2018334793891409521.stgit@naples-babu.amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 05, 2019 at 09:25:32PM +0000, Moger, Babu wrote:
> AMD 2nd generation EPYC processors support the UMIP (User-Mode
> Instruction Prevention) feature. So, rename X86_INTEL_UMIP to
> generic X86_UMIP and modify the text to cover both Intel and AMD.
> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
>  arch/x86/Kconfig                         |   10 +++++-----
>  arch/x86/include/asm/disabled-features.h |    2 +-
>  arch/x86/include/asm/umip.h              |    4 ++--
>  arch/x86/kernel/Makefile                 |    2 +-
>  4 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index d6e1faa28c58..b7fb285d7c0f 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1880,13 +1880,13 @@ config X86_SMAP
>  
>  	  If unsure, say Y.
>  
> -config X86_INTEL_UMIP
> +config X86_UMIP
>  	def_bool y
> -	depends on CPU_SUP_INTEL
> -	prompt "Intel User Mode Instruction Prevention" if EXPERT
> +	depends on CPU_SUP_INTEL || CPU_SUP_AMD
> +	prompt "User Mode Instruction Prevention" if EXPERT
>  	---help---
> -	  The User Mode Instruction Prevention (UMIP) is a security
> -	  feature in newer Intel processors. If enabled, a general
> +	  User Mode Instruction Prevention (UMIP) is a security
> +	  feature in newer x86 processors. If enabled, a general

Better to say certain x86 processors? Intel and AMD have it but what
about others?

Thanks and BR,
Ricardo
