Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C06D634F1
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 13:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfGILb0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 07:31:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:32010 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbfGILb0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 07:31:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jul 2019 04:31:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,470,1557212400"; 
   d="scan'208";a="192656226"
Received: from unknown (HELO [10.239.13.7]) ([10.239.13.7])
  by fmsmga002.fm.intel.com with ESMTP; 09 Jul 2019 04:31:23 -0700
Message-ID: <5D247C55.3000700@intel.com>
Date:   Tue, 09 Jul 2019 19:36:53 +0800
From:   Wei Wang <wei.w.wang@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.7.0
MIME-Version: 1.0
To:     Peter Zijlstra <peterz@infradead.org>
CC:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, ak@linux.intel.com, kan.liang@intel.com,
        mingo@redhat.com, rkrcmar@redhat.com, like.xu@intel.com,
        jannh@google.com, arei.gonglei@huawei.com, jmattson@google.com
Subject: Re: [PATCH v7 07/12] perf/x86: no counter allocation support
References: <1562548999-37095-1-git-send-email-wei.w.wang@intel.com> <1562548999-37095-8-git-send-email-wei.w.wang@intel.com> <20190708142947.GM3402@hirez.programming.kicks-ass.net> <5D2402E6.7060104@intel.com> <20190709094305.GT3402@hirez.programming.kicks-ass.net>
In-Reply-To: <20190709094305.GT3402@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/09/2019 05:43 PM, Peter Zijlstra wrote:
> That's almost a year ago; I really can't remember that and you didn't
> put any of that in your Changelog to help me remember.
>
> (also please use: https://lkml.kernel.org/r/$msgid style links)

OK, I'll put this link in the cover letter or commit log for a reminder.

>
>> In the previous version, we added a "no_counter" bit to perf_event_attr, and
>> that will be exposed to user ABI, which seems not good.
>> (https://lkml.org/lkml/2019/2/14/791)
>> So we wrap a new kernel API above to support this.
>>
>> Do you have a different suggestion to do this?
>> (exclude host/guest just clears the enable bit when on VM-exit/entry,
>> still consumes the counter)
> Just add an argument to perf_event_create_kernel_counter() ?

Yes. I didn't find a proper place to add this "no_counter" indicator, so 
added a
wrapper to avoid changing existing callers of 
perf_event_create_kernel_counter.

Best,
Wei
