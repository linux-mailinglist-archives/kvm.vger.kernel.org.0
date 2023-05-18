Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B6770797D
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 07:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjERFUa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 01:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjERFU2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 01:20:28 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D1D2D63
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 22:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684387228; x=1715923228;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=teYBxBtDu07x46I2F16D+BPiClkqroQpTdT+aLNndZg=;
  b=UFgrjiXV+uF+3napKRlYW0BoPBafxO2lYWo1m8Ttm3tKO1tUpeyedndT
   g3rBPITAw2QEcPrlXZVHEq4sotOkob/fZB9FzHQ098J4NR4fFm4FfWy0J
   mB4rcONIOeCA3TgeQpEYuFGJOxcQZxkWO1vFUOPc80ech3zys8Al7B6hM
   yrk2PRlxCNfRlPb04wq7ZV2GEKoMs4QY1MP9ijiTqNhJpXhy7qoykRMAX
   7WuE9J+t48E/zMMt47lvYoWZOTQCAPaO6qAPXGJkSbNxZpOi8JEGvIvwm
   yYX16pl/jvWlkRFay8fO2eiK0RMFXVYFofhBPtnbkYtC5AonfuSUHUXJp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="350802229"
X-IronPort-AV: E=Sophos;i="5.99,284,1677571200"; 
   d="scan'208";a="350802229"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2023 22:20:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="702017863"
X-IronPort-AV: E=Sophos;i="5.99,284,1677571200"; 
   d="scan'208";a="702017863"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.208.101]) ([10.254.208.101])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2023 22:20:07 -0700
Message-ID: <6d79e628-094b-f434-dbed-4229e3632328@linux.intel.com>
Date:   Thu, 18 May 2023 13:20:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 2/2] KVM: x86: Fix some comments
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
References: <20230423101112.13803-1-binbin.wu@linux.intel.com>
 <20230423101112.13803-3-binbin.wu@linux.intel.com>
 <ZGVHBosyCEOrokyJ@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZGVHBosyCEOrokyJ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/18/2023 5:28 AM, Sean Christopherson wrote:
> On Sun, Apr 23, 2023, Binbin Wu wrote:
>> msrs_to_save_all is out-dated after commit 2374b7310b66
>> (KVM: x86/pmu: Use separate array for defining "PMU MSRs to save").
>> Update the comments to msrs_to_save_base.
>>
>> Fix a typo in x86 mmu.rst.
> Please split this into two patches, these are two completely unrelated changes.
> Yes, they're tiny, but the mmu.rst change is more than just a trivial typo, e.g.
> it can't be reasonably reviewed by someone without at least passing knowledge of
> NPT, LA57, etc.

OK, will split it. Thanks.

