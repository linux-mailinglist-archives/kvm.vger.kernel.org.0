Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E1B6CD13E
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 06:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjC2Eqx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 00:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjC2Eqw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 00:46:52 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F90269E
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 21:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680065211; x=1711601211;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aFtJO1sNNcplyFnQKdq5T6zRVv1CuuduZKbCHtFIBLw=;
  b=bYSvafEEqo9G/sA1mdqvi0u/QAQWxZz9VFcMmsgQFx7MINybUyX89QAa
   dttizQKD86SaDGTxhcYL8mxrTbLx1NmD2rlVjSV5jgLgOQnzkWGXJKfbc
   XaZ4bfnHMoXxzdj4J9NachwIK8p0/82gXW2nAd4HnwtpoBONRjbRTwGTP
   /8SWmQ2FTruD1GlWAVJK2h1Yt9mk4Qp7ruBKGcJS8a9xSXo6/+KufdZQU
   OSo240Wt0LOHzs5XDB7Q/f1agYZt5FKPFt4cqZ2QWfcrs0lKXYc2G1TfX
   kHtaABeGmaL7Iin30DClSWk0LoF+PIRxoOiQcN/YCPSzN1GG41tlCgVpW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="403395825"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="403395825"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 21:46:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="748651452"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="748651452"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.254.212.101]) ([10.254.212.101])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 21:46:49 -0700
Message-ID: <05792cbd-7fdb-6bf2-ebaa-9d13a2c4fddd@intel.com>
Date:   Wed, 29 Mar 2023 12:46:46 +0800
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
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZCMCzpAkGV56+ZbS@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/28/2023 11:07 PM, Sean Christopherson wrote:
> On Tue, Mar 28, 2023, Xiaoyao Li wrote:
>> On 3/28/2023 1:02 PM, Sean Christopherson wrote:
>>> Add a define for PRED_CMD_IBPB and use it to replace the open coded '1' in
>>> the nVMX library.
>>
>> What does nVMX mean here?
> 
> Nested VMX.  From KUT's perspective, the testing exists to validate KVM's nested
> VMX implementation.  If it's at all confusing, I'll drop the 'n'  And we've already
> established that KUT can be used on bare metal, even if that's not the primary use
> case.

So vmexit.flat is supposed to be ran in L1 VM?

I'm confused and interested in how KUT is used on bare metal.
