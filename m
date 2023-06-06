Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9DA723D42
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 11:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237399AbjFFJ02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 05:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237179AbjFFJ0X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 05:26:23 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F5BE51;
        Tue,  6 Jun 2023 02:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686043581; x=1717579581;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=F3qIBZZvEOP1o7XmUo3JpMouW8LuVpAL3sqN4V4ah1s=;
  b=bVYtwmCwyuf0+7hhwtYnjjM6CTCDOiNH78EiQffhWe2jdB7ZOXGBnWJJ
   D22pwjFm42jkKscbD9GNr1JPMKVc6mfUjCFKJ5K+46Jv7p04hFrxJUvbv
   rL6Fn4tgpCg6eMSIgViOaJ6tVV1UicRtQrQhn1V/DfszFKEs++Emyl1q2
   UF4Y33mCpfw/ZJF1Jv/8GfwOPipB7D1YHftxtN4p07/HsdBgnoarIcws2
   T95kXP41P9mSLJUn+7lsIVAuFtRCDVehNsHLeMJxljYkdrBXISK3942DX
   skYZBR7YseRBBhP0ZxdqHeD0ZsjDB9ireqAUD2QmFc7hWel0t4cZflOii
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="355467502"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="355467502"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 02:26:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="742075415"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="742075415"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.170.159]) ([10.249.170.159])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 02:26:19 -0700
Message-ID: <b227532c-72ce-433e-cf2a-3feb2d14a1ae@linux.intel.com>
Date:   Tue, 6 Jun 2023 17:26:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v8 0/6] Linear Address Masking (LAM) KVM Enabling
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, chao.gao@intel.com,
        kai.huang@intel.com, robert.hu@linux.intel.com
References: <20230510060611.12950-1-binbin.wu@linux.intel.com>
 <2692c723-239c-20ad-a735-8b83988f072a@linux.intel.com>
 <ZG+F02XuoSbZvuvv@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZG+F02XuoSbZvuvv@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/25/2023 11:59 PM, Sean Christopherson wrote:
> On Thu, May 25, 2023, Binbin Wu wrote:
>> Gentle ping.
>> Do you have any comments for this patch series?
> Probably, I haven't looked at it yet.  This is on my todo list, but there are
> multiple large series ahead of it.
Updated the patch version to v9 to address the comments from Chao, Kai 
and David in v8.
https://lore.kernel.org/kvm/20230606091842.13123-1-binbin.wu@linux.intel.com/T/#t

