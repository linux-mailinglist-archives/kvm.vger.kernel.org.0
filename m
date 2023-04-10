Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C387E6DC869
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 17:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjDJPYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 11:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjDJPYH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 11:24:07 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2A75271
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 08:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681140246; x=1712676246;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WrAS102teAYispNenL1EPFkZzursF03ffVQfQc+9TBs=;
  b=BYHYMk9lix33pTzh663wIi2YLcN6UUmibWFTbmVWJ9Sun3Vj/YsaXxdT
   m8xpxCNwX8Nu6EJ0Nq/vXTJGSvErwAt1f7IB80VHerJbEzBkp7n/knuX6
   sWWcafESCBDALteonDU8Ffd6M8cLaFdaPeLaHnLrzMIR38rRdBSZxIekk
   l7N4qGnTKddgfuxlAsKMBBwzHptJvhitAM2myVMsjO1znXACXXqfDFSgi
   r+uLLx2UjLLTYhwppoAvQMnral/TxD9tjNH1hbT0KBlGcSPmzmiD/SRX8
   eZnLH/I9sw44VF1Iud7QyWoYRwLtsLPIj9ZGTifb1dBaTBEi64j2Rd0pb
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="343383562"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="343383562"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 08:24:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="720863327"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="720863327"
Received: from kejia-mobl.ccr.corp.intel.com (HELO [10.254.214.83]) ([10.254.214.83])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 08:24:04 -0700
Message-ID: <43c21a3e-7a69-0c7b-5380-28a9083cbfb7@linux.intel.com>
Date:   Mon, 10 Apr 2023 23:24:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v2 0/4] x86: Add test cases for LAM
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20230319082225.14302-1-binbin.wu@linux.intel.com>
 <9896a0bf26e48dab853049f40733df5bb0e287a1.camel@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <9896a0bf26e48dab853049f40733df5bb0e287a1.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/6/2023 7:39 PM, Huang, Kai wrote:
> On Sun, 2023-03-19 at 16:22 +0800, Binbin Wu wrote:
>> Intel Linear-address masking (LAM) [1], modifies the checking that is applied to
>> *64-bit* linear addresses, allowing software to use of the untranslated address
>> bits for metadata.
>>
>> The patch series add test cases for LAM:
>>
> I think you should just merge this series to the patchset which enables LAM
> feature?

These are kvm-unit-tests cases, I forgot to add the prefix when I sent 
the patch set.
I then resent the patch set with the kvm-unit-tests prefix.


>
