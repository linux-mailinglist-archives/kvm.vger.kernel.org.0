Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72A9918DC93
	for <lists+kvm@lfdr.de>; Sat, 21 Mar 2020 01:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbgCUAlj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 20:41:39 -0400
Received: from mga03.intel.com ([134.134.136.65]:63180 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727158AbgCUAli (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 20:41:38 -0400
IronPort-SDR: Y2ye6VjE444HkSZMbpR9mwwMjDx7B5shVzm56Po6XAOybT/nCffHPGiqas/fgn42iCEmGpCwOZ
 cAoqPekV/DLg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 17:41:38 -0700
IronPort-SDR: GtHqOl1CLkUFPLL9+/s66gcXWnZbAOy+zcIkwxIs/Kuqt9JpT1yJkTfJZB8oHPWAlSMXg5meeN
 JyabIa/GvHXg==
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="325031742"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.68])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 17:41:37 -0700
Date:   Fri, 20 Mar 2020 17:41:36 -0700
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
Subject: Re: [PATCH v5 1/9] x86/split_lock: Rework the initialization flow of
 split lock detection
Message-ID: <20200321004136.GA6578@agluck-desk2.amr.corp.intel.com>
References: <20200315050517.127446-1-xiaoyao.li@intel.com>
 <20200315050517.127446-2-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200315050517.127446-2-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 15, 2020 at 01:05:09PM +0800, Xiaoyao Li wrote:
> To solve these issues, introducing a new sld_state, "sld_not_exist", as
> the default value. It will be switched to other value if CORE_CAPABILITIES
> or FMS enumerate split lock detection.

Is a better name for this state "sld_uninitialized?

Otherwise looks good.

Reviewed-by: Tony Luck <tony.luck@intel.com>

-Tony
