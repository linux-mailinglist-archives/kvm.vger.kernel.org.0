Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5652B8199
	for <lists+kvm@lfdr.de>; Wed, 18 Nov 2020 17:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgKRQSz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 11:18:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:44042 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbgKRQSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Nov 2020 11:18:54 -0500
IronPort-SDR: EJi7014HSJLlgNtWJJNI+LBrRa6UpQxDMsgWN61pptqOeeNEwfaLG5y61n2PGLy+alKhkoVqST
 tUhfyPyHNe0g==
X-IronPort-AV: E=McAfee;i="6000,8403,9808"; a="167630958"
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="167630958"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 08:18:54 -0800
IronPort-SDR: IVpCU1Ahwp8XRZgwM9P7fzgvSrTOIr7HwjfQC/OZKdFiBIPX30c/XrYrj4IHiiLLic8SHsYAYG
 eQhXiFeJnhBA==
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="476413155"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.255.28.176]) ([10.255.28.176])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 08:18:48 -0800
Subject: Re: [PATCH v2 05/17] KVM: x86/pmu: Reprogram guest PEBS event to
 emulate guest PEBS counter
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>, luwei.kang@intel.com,
        Thomas Gleixner <tglx@linutronix.de>, wei.w.wang@intel.com,
        Tony Luck <tony.luck@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Mark Gross <mgross@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
References: <20201109021254.79755-1-like.xu@linux.intel.com>
 <20201109021254.79755-6-like.xu@linux.intel.com>
 <20201117144100.GK3121406@hirez.programming.kicks-ass.net>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <b467faaf-1594-e389-bff9-3bc29f90d4e5@linux.intel.com>
Date:   Thu, 19 Nov 2020 00:18:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201117144100.GK3121406@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/11/17 22:41, Peter Zijlstra wrote:
> On Mon, Nov 09, 2020 at 10:12:42AM +0800, Like Xu wrote:
>> +			/* Indicate PEBS overflow PMI to guest. */
>> +			__set_bit(62, (unsigned long *)&pmu->global_status);
> 
> GLOBAL_STATUS_BUFFER_OVF_BIT
> 

Thanks, I'll apply it.

If you have more comments on the entire patch set, please let me know.

Thanks,
Like Xu
