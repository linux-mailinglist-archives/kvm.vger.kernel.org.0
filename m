Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83BBBCE35D
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 15:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbfJGNZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 09:25:14 -0400
Received: from mga17.intel.com ([192.55.52.151]:55469 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727324AbfJGNZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 09:25:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 06:25:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,268,1566889200"; 
   d="scan'208";a="206409797"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga001.fm.intel.com with ESMTP; 07 Oct 2019 06:25:13 -0700
Received: from [10.251.30.58] (kliang2-mobl.ccr.corp.intel.com [10.251.30.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 9C5EF5803E4;
        Mon,  7 Oct 2019 06:25:11 -0700 (PDT)
Subject: Re: [PATCH 1/3] perf/core: Provide a kernel-internal interface to
 recalibrate event period
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <like.xu@linux.intel.com>, kvm@vger.kernel.org,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, peterz@infradead.org,
        Jim Mattson <jmattson@google.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
References: <20190930072257.43352-1-like.xu@linux.intel.com>
 <20190930072257.43352-2-like.xu@linux.intel.com>
 <6439df1c-df4a-9820-edb2-0ff41b581d37@redhat.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Message-ID: <e2b00b05-a95a-3d03-7238-267c642a1fa0@linux.intel.com>
Date:   Mon, 7 Oct 2019 09:25:10 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <6439df1c-df4a-9820-edb2-0ff41b581d37@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/7/2019 8:01 AM, Paolo Bonzini wrote:
> On 30/09/19 09:22, Like Xu wrote:
>> -static int perf_event_period(struct perf_event *event, u64 __user *arg)
>> +static int _perf_event_period(struct perf_event *event, u64 value)
> 
> __perf_event_period or perf_event_period_locked would be more consistent
> with other code in Linux.
> 

But that will be not consistent with current perf code. For example, 
_perf_event_enable(), _perf_event_disable(), _perf_event_reset() and 
_perf_event_refresh().
Currently, The function name without '_' prefix is the one exported and 
with lock. The function name with '_' prefix is the main body.

If we have to use the "_locked" or "__", I think we'd better change the 
name for other functions as well.

Thanks,
Kan
