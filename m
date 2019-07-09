Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE5AF62EAF
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 05:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbfGIDSk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 23:18:40 -0400
Received: from mga06.intel.com ([134.134.136.31]:27127 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbfGIDSj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jul 2019 23:18:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 20:18:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,469,1557212400"; 
   d="scan'208";a="156048700"
Received: from unknown (HELO [10.239.13.7]) ([10.239.13.7])
  by orsmga007.jf.intel.com with ESMTP; 08 Jul 2019 20:18:37 -0700
Message-ID: <5D2408D7.3000002@intel.com>
Date:   Tue, 09 Jul 2019 11:24:07 +0800
From:   Wei Wang <wei.w.wang@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.7.0
MIME-Version: 1.0
To:     Peter Zijlstra <peterz@infradead.org>
CC:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, ak@linux.intel.com, kan.liang@intel.com,
        mingo@redhat.com, rkrcmar@redhat.com, like.xu@intel.com,
        jannh@google.com, arei.gonglei@huawei.com, jmattson@google.com
Subject: Re: [PATCH v7 12/12] KVM/VMX/vPMU: support to report GLOBAL_STATUS_LBRS_FROZEN
References: <1562548999-37095-1-git-send-email-wei.w.wang@intel.com> <1562548999-37095-13-git-send-email-wei.w.wang@intel.com> <20190708150909.GP3402@hirez.programming.kicks-ass.net>
In-Reply-To: <20190708150909.GP3402@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/08/2019 11:09 PM, Peter Zijlstra wrote:
> On Mon, Jul 08, 2019 at 09:23:19AM +0800, Wei Wang wrote:
>> This patch enables the LBR related features in Arch v4 in advance,
>> though the current vPMU only has v2 support. Other arch v4 related
>> support will be enabled later in another series.
>>
>> Arch v4 supports streamlined Freeze_LBR_on_PMI. According to the SDM,
>> the LBR_FRZ bit is set to global status when debugctl.freeze_lbr_on_pmi
>> has been set and a PMI is generated. The CTR_FRZ bit is set when
>> debugctl.freeze_perfmon_on_pmi is set and a PMI is generated.
> (that's still a misnomer; it is: freeze_perfmon_on_overflow)

OK. (but that was directly copied from the sdm 18.2.4.1)


> Why?
>
> Who uses that v4 crud?

I saw the native perf driver has been updated to v4.
After the vPMU gets updated to v4, the guest perf would use that.

If you prefer to hold on this patch until vPMU v4 support,
we could do that as well.


> It's broken. It looses events between overflow
> and PMI.

Do you mean it's a v4 hardware issue?

Best,
Wei
