Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4ED31FAEF0
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 13:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbgFPLNy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 07:13:54 -0400
Received: from mga06.intel.com ([134.134.136.31]:43900 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgFPLNx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 07:13:53 -0400
IronPort-SDR: OJYcytXZ1XDRbqFHvnxRch7lnw7qKv0eqgPr8FW+UrDbGNqr8r7Nge5ktgyEgv1cH8ZJAFubJR
 dd3BDiwzUoFA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2020 04:13:53 -0700
IronPort-SDR: OmabjAXZPXQO7YbrSiauNfAJ3KXOMmcWQ5PWxq6aY9w1ckrJBOuHNTQt8Asd24uFwntSltFyng
 pj4YiZ0wt6+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,518,1583222400"; 
   d="scan'208";a="449767624"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.173.53]) ([10.249.173.53])
  by orsmga005.jf.intel.com with ESMTP; 16 Jun 2020 04:13:51 -0700
Reply-To: like.xu@intel.com
Subject: Re: [kvm-unit-tests PATCH] x86/pmu: Fix compilation on 32-bit hosts
To:     Thomas Huth <thuth@redhat.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org
Cc:     like.xu@linux.intel.com, vkuznets@redhat.com
References: <20200616105940.2907-1-thuth@redhat.com>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <b7a62302-1d6f-c007-0358-dd9f85a698ca@intel.com>
Date:   Tue, 16 Jun 2020 19:13:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200616105940.2907-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/6/16 18:59, Thomas Huth wrote:
> When building for 32-bit hosts, the compiler currently complains:
>
>   x86/pmu.c: In function 'check_gp_counters_write_width':
>   x86/pmu.c:490:30: error: left shift count >= width of type
>
> Use the correct suffix to avoid this problem.
>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
Thanks, I admit I did not test it on a 32-bit host.
> ---
>   x86/pmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 57a2b23..91a6fb4 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -487,7 +487,7 @@ static void do_unsupported_width_counter_write(void *index)
>   static void  check_gp_counters_write_width(void)
>   {
>   	u64 val_64 = 0xffffff0123456789ull;
> -	u64 val_32 = val_64 & ((1ul << 32) - 1);
> +	u64 val_32 = val_64 & ((1ull << 32) - 1);
>   	u64 val_max_width = val_64 & ((1ul << eax.split.bit_width) - 1);
>   	int i;
>   

