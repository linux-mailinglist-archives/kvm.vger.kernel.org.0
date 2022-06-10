Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 805F65459A0
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 03:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238771AbiFJBkb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 21:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbiFJBka (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 21:40:30 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECED1663CF
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 18:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654825225; x=1686361225;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Yw/r7HwN1jVjxWJ69XtmQXEGuwVekvEPs2AWrElAlWI=;
  b=NP92gcomiuA1vN0Y/L9AYzcDSw7uda4BpKp1jLhh8mCymDsKuInznr+B
   BiVTZyaqeNGfc3+4Awo+NLLT+wTU9u4k9hKeyWnWstyrWDC/XWqmAr8oU
   BB7tKgMvSOkWCvrXvtPNn/bIXfRkaKVrrL+wPLu3L1TDz8ELmR79A9qUq
   LrieZmA37r+wXoZlCuXEQEllRSYLVZYEIPFncWotw5rGXDuYs02pSZnHf
   8SFeq/e1NyNaIb2hM0cC+3U/6M4o+jGZnhafpvzJe03AaAgLEEnVFMVCm
   rg+fwlUS1keAr3DHXP5eu1Go4sLzpg+UVrRGJS6rZYpNb/5aP9Xv0rHgJ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="276249811"
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="276249811"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 18:40:25 -0700
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="637852184"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.255.29.27]) ([10.255.29.27])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 18:40:24 -0700
Message-ID: <409d14a2-5357-3640-1603-82aa51455c68@intel.com>
Date:   Fri, 10 Jun 2022 09:40:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [kvm-unit-tests PATCH 2/3] x86: Skip running test when pmu is
 disabled
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>
References: <20220609083916.36658-1-weijiang.yang@intel.com>
 <20220609083916.36658-3-weijiang.yang@intel.com>
 <2bd56b9f-cf27-f4a3-321f-1b1b11172bc0@gmail.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <2bd56b9f-cf27-f4a3-321f-1b1b11172bc0@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/10/2022 7:57 AM, Like Xu wrote:
> On 9/6/2022 4:39 pm, Yang Weijiang wrote:
>> +    perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
>
> Nit, check the PDCM bit before accessing this MSR.
Thanks, I'll add the check.
