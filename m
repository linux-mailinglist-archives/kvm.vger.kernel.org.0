Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF6CEDE613
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 10:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbfJUIQI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 04:16:08 -0400
Received: from mga07.intel.com ([134.134.136.100]:2946 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbfJUIQI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 04:16:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 01:16:07 -0700
X-IronPort-AV: E=Sophos;i="5.67,322,1566889200"; 
   d="scan'208";a="191037080"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.239.196.130]) ([10.239.196.130])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 21 Oct 2019 01:16:04 -0700
Subject: Re: [PATCH v2 3/4] KVM: x86/vPMU: Reuse perf_event to avoid
 unnecessary pmc_reprogram_counter
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        peterz@infradead.org, Jim Mattson <jmattson@google.com>
Cc:     rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
References: <20191013091533.12971-1-like.xu@linux.intel.com>
 <20191013091533.12971-4-like.xu@linux.intel.com>
 <5020e826-e461-c28a-0b40-6e00aaa28163@redhat.com>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <931ebe53-48c8-669d-72a6-9bd8da78b095@linux.intel.com>
Date:   Mon, 21 Oct 2019 16:16:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <5020e826-e461-c28a-0b40-6e00aaa28163@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On 2019/10/21 16:12, Paolo Bonzini wrote:
> Just a naming tweak:
> 
> On 13/10/19 11:15, Like Xu wrote:
>> +	/* the exact requested config to create perf_event */
>> +	u64 programed_config;
> 
> 	/*
> 	 * eventsel value for general purpose counters, ctrl value for
> 	 * fixed counters.
> 	 */
> 	u64 current_config;
> 
> 

It looks good to me and I'll apply this.
Is there more need for improvement？
