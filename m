Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60A5C18DCB4
	for <lists+kvm@lfdr.de>; Sat, 21 Mar 2020 01:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbgCUAq3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 20:46:29 -0400
Received: from mga05.intel.com ([192.55.52.43]:9941 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbgCUAq2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 20:46:28 -0400
IronPort-SDR: ASTzE7QNsTxccBIJC45PSIz3bdTouUYXWnFVUGxtcvn+zbf9/kLvcr94NVPjR/zNa2CQuYPtsE
 o22eL8hJhnfw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 17:46:28 -0700
IronPort-SDR: S0Og/w9m6MsE+KseulJPHk/GLuG58AyB3YRvqleTG1Tg6Xso7QFNKORcKprz7PozDAxNrAPfjg
 AZGfqVOFKUZA==
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="356576827"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.68])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 17:46:28 -0700
Date:   Fri, 20 Mar 2020 17:46:27 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v5 3/9] x86/split_lock: Re-define the kernel param option
 for split_lock_detect
Message-ID: <20200321004627.GC6578@agluck-desk2.amr.corp.intel.com>
References: <20200315050517.127446-1-xiaoyao.li@intel.com>
 <20200315050517.127446-4-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200315050517.127446-4-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 15, 2020 at 01:05:11PM +0800, Xiaoyao Li wrote:
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -4666,7 +4666,10 @@
>  			instructions that access data across cache line
>  			boundaries will result in an alignment check exception.
>  
> -			off	- not enabled
> +			disable	- disabled, neither kernel nor kvm can use it.

Are command line arguments "ABI"?  The "=off" variant isn't upstream yet,
but it is in TIP.  I'm ok with this change, but perhaps this patch (or at
least this part of this patch) needs to catch up with the older one within
the 5.7 merge window (or sometime before v5.7).

Reviewed-by: Tony Luck <tony.luck@intel.com>
