Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4CA12AE63C
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 03:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732506AbgKKCOJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 21:14:09 -0500
Received: from mga05.intel.com ([192.55.52.43]:11142 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731810AbgKKCOI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 21:14:08 -0500
IronPort-SDR: nHVZEGs2bRPUx5xcWSx+9a/ECaBZtVqIgd2gzyXxTPZL8uUX3bn1LfA7grhJgBvzp1jVebjaig
 l3LwXJINrURw==
X-IronPort-AV: E=McAfee;i="6000,8403,9801"; a="254790992"
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="254790992"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 18:14:08 -0800
IronPort-SDR: cMZtNvtN+8jSY8QwAHBtnpgpwlRODUadsCEbQXv8bBbstUNfw7kQj5BQ6o+50nP4z3C7T8JufN
 XakrnU77TVtg==
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="541589258"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.107]) ([10.238.4.107])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 18:14:04 -0800
Subject: Re: [PATCH v12 01/11] perf/x86: Fix variable types for LBR registers
To:     Andi Kleen <ak@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stephane Eranian <eranian@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, wei.w.wang@intel.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200613080958.132489-1-like.xu@linux.intel.com>
 <20200613080958.132489-2-like.xu@linux.intel.com>
 <20201109063446.GM466880@tassilo.jf.intel.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <f5847034-e720-b8ce-905b-04e2cfb7661b@intel.com>
Date:   Wed, 11 Nov 2020 10:14:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <20201109063446.GM466880@tassilo.jf.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

As you may know, we have got host perf support in Linus' tree
which provides a clear path for enabling guest LBR,

will we merge the remaining LBR KVM patch set?

---

[PATCH RESEND v13 00/10] Guest Last Branch Recording Enabling
https://lore.kernel.org/kvm/20201030035220.102403-1-like.xu@linux.intel.com/

Thanks,
Like Xu

On 2020/11/9 14:34, Andi Kleen wrote:
> Hi,
>
> What's the status of this patchkit? It would be quite useful to me (and
> various other people) to use LBRs in guest. I reviewed it earlier and the
> patches all looked good to me.  But i don't see it in any -next tree.
>
> Reviewed-by: Andi Kleen<ak@linux.intel.com>
>
> Could it please be merged?
>
> Thanks,
>
> -Andi

