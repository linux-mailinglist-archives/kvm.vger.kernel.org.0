Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F446CF873
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 03:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjC3BFT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 21:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjC3BFS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 21:05:18 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29784EEA
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 18:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680138317; x=1711674317;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=g2VE4e8KWIBB/H66hdUCJz8ljgVvxhiYHbCgqgsMBAY=;
  b=Uoy2lY1K/oIEP9qbeVjvHB2Qnmlu/VoOA2hfTcVQdMjkKtKeoKO3a4ci
   Bquj5bzfmTygxDH1mzGsGvTcA09i0O6rwZkTPPoLYQZkNjGNu4WsgUt5k
   1KzH0DZ+9KFeyOAnNDcbPpKfm8AxSoutoQ+EuSt4WjWNgqP0uDD2jeCml
   0twNG6lDk2X5Z0myWhkKnYk+VUWNNdrugTLBDae/t9yREfddhsQ6dgqTw
   W1UwAy6fCQv4gk+bAY1H47h7t3qCoSWrVQRWHZA8rLdP6nVkGLZ7vCfC/
   u3tIqHuxZ8Ju0OGGqjESp/a15Sg3EiCp/EbF9JYbNp7AIMOOYh/dKwTF5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="329528535"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="329528535"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 18:05:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="795463657"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="795463657"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.254.210.5]) ([10.254.210.5])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 18:05:15 -0700
Message-ID: <49dd4ae8-9b7a-b6ce-ee9b-3ba76b12c06e@intel.com>
Date:   Thu, 30 Mar 2023 09:05:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [kvm-unit-tests PATCH 1/3] x86: Add define for
 MSR_IA32_PRED_CMD's PRED_CMD_IBPB (bit 0)
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20230328050231.3008531-1-seanjc@google.com>
 <20230328050231.3008531-2-seanjc@google.com>
 <620935f7-dd7a-2db6-1ddf-8dae27326f60@intel.com>
 <ZCMCzpAkGV56+ZbS@google.com>
 <05792cbd-7fdb-6bf2-ebaa-9d13a2c4fddd@intel.com>
 <ZCRogsvUYMQV6kca@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZCRogsvUYMQV6kca@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/30/2023 12:36 AM, Sean Christopherson wrote:
> On Wed, Mar 29, 2023, Xiaoyao Li wrote:
>> On 3/28/2023 11:07 PM, Sean Christopherson wrote:
>>> On Tue, Mar 28, 2023, Xiaoyao Li wrote:
>>>> On 3/28/2023 1:02 PM, Sean Christopherson wrote:
>>>>> Add a define for PRED_CMD_IBPB and use it to replace the open coded '1' in
>>>>> the nVMX library.
>>>> What does nVMX mean here?
>>> Nested VMX.  From KUT's perspective, the testing exists to validate KVM's nested
>>> VMX implementation.  If it's at all confusing, I'll drop the 'n'  And we've already
>>> established that KUT can be used on bare metal, even if that's not the primary use
>>> case.
>> So vmexit.flat is supposed to be ran in L1 VM?
> Not all of the tests can be run on bare metal, e.g. I can't imagine the VMware
> backdoor test works either.
> 

Sorry, I think neither I ask clearly nor you got my point.

You said "the testing exists to validate KVM's nested VMX 
implementation". So I want to know what's the expected usage to run 
vmexit.flat.

If for nested, we need to first boot a VM and then inside the VM we run 
the vmexit.flat with QEMU, right?

That's what confuses me. Isn't vmexit.flat supposed to be directly used 
on the host with QEMU? In this case, nothing to do with nested.
