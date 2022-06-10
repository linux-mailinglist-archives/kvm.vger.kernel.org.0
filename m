Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956AA5459A9
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 03:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237672AbiFJBrV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 21:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiFJBrU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 21:47:20 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665C61CC5CA
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 18:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654825639; x=1686361639;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=guOrS0eGOckA50Tvu3IvHzIQ19fVfb3VmVw4uOPSoiY=;
  b=R2bGZW6O2qAgeugo9S2SqJ46o8G/bsiJKURKYAcF1FVGOwYdYaadm/+E
   cexvKBtQCEJEiH0rXzAmqatxkcD2e9yAR8kd7hpbL45VMCbZ5KekcCsjE
   5q501bdynPi56DiFDGwUF0Qg0SN/KufzydZKb+vTmkpHVK1BpPW4kWE6i
   AVdLriWMAaDCr/9MJqRxvGIiX7SBvx6yFM8LAyVWoxlletTOnt6Lu4l/q
   J37fOd2tdVGJlvyuZBO6T1156YJBl65RqgkfbBdT8sfVuoP3d2ZeGHM3C
   9/W+0NOl3+HMjGTi3c4Wl1pPmag+dUxOmBhggTrAuFOcvmamBEpiruTz9
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="339234678"
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="339234678"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 18:47:18 -0700
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="637855172"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.255.29.27]) ([10.255.29.27])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 18:47:16 -0700
Message-ID: <987d8a3d-19ef-094d-5c0e-007133362c30@intel.com>
Date:   Fri, 10 Jun 2022 09:47:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Skip perf related tests when pmu
 is disabled
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>
References: <20220609083916.36658-1-weijiang.yang@intel.com>
 <20220609083916.36658-4-weijiang.yang@intel.com>
 <587f8bc5-76fc-6cd7-d3d7-3a712c3f1274@gmail.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <587f8bc5-76fc-6cd7-d3d7-3a712c3f1274@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/10/2022 8:14 AM, Like Xu wrote:
> On 9/6/2022 4:39 pm, Yang Weijiang wrote:
>> executing rdpmc leads to #GP,
>
> RDPMC still works on processors that do not support architectural 
> performance monitoring.
>
> The #GP will violate ISA, and try to treat it as NOP (plus EAX=EDX=0) 
> if !enable_pmu.

After a quick check in SDM, I cannot find wordings supporting your above 
comments, can you

point me to it?

Another concern is, when !enable_pmu, should we make RDPMC "work" with 
returning EAX=EDX=0?

Or just simply inject #GP to VM in this case?

