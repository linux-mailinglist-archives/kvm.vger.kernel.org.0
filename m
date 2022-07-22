Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3A257D7E4
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 02:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiGVA6u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 20:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiGVA6t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 20:58:49 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6880395C2D
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 17:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658451528; x=1689987528;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CnAyLKYp9vETdCreizpHA7WXzffVEQaniCNPN9xvLI4=;
  b=M9xLhFleRhJ9FAn1Dnj3GXtiKadK/JfbLs32y8VFxSV0os+LmPLbBff/
   xLDJdMkNrX9Cj1Yt79jch4/BpW41tfib+5+uDyw/25dIiYqjdPh//OQM8
   8qR+TqqqNJqkq1PIyjnKbzLFpFcSMHKHdzGmW1OTiKZGLIrrOhTGquwdf
   1pLOHDhMP3E/+xuwHxVwNcmLD0gm4soEy44a60jdbGWpXJ21YWUjopf5i
   Ao35a+Fau53V4/bjk9SGenCgIVfg1imcm6dRyjwrf/0ARPiNp7cnTaHG+
   SDaGUKRZpQz7Hfr8Svg+OQ8s3TQ+uJ8D6F6VQjVS906XrBWBRF/Mxqoti
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="351205385"
X-IronPort-AV: E=Sophos;i="5.93,184,1654585200"; 
   d="scan'208";a="351205385"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 17:58:48 -0700
X-IronPort-AV: E=Sophos;i="5.93,184,1654585200"; 
   d="scan'208";a="626357998"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.255.30.155]) ([10.255.30.155])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 17:58:46 -0700
Message-ID: <f624e60b-408f-5dba-eae3-daac6bf6b546@intel.com>
Date:   Fri, 22 Jul 2022 08:58:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [kvm-unit-tests PATCH 2/4] x86: Use helpers to fetch supported
 perf capabilities
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
References: <20220711041841.126648-1-weijiang.yang@intel.com>
 <20220711041841.126648-3-weijiang.yang@intel.com>
 <YtnDTQj72uoN2aj6@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <YtnDTQj72uoN2aj6@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/22/2022 5:21 AM, Sean Christopherson wrote:
> On Mon, Jul 11, 2022, Yang Weijiang wrote:
>> -	eax.full = id.a;
>> -	ebx.full = id.b;
>> -	edx.full = id.d;
>> +	eax.full = pmu_arch_info();
>> +	ebx.full = pmu_gp_events();
>> +	edx.full = pmu_fixed_counters();
> Adding helpers for individual fields but then caching the full fields and
> ignoring the helpers is silly.  It doesn't require much more work to get rid of
> the unions entirely (see the pull request I sent to Paolo).

Thank you Sean!

I was not sure if it's suitable to do so, then got this half-done patch :-D.

