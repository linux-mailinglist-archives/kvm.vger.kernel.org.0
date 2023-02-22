Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6499269ECFB
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 03:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjBVCiu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 21:38:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBVCir (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 21:38:47 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CB522A2F;
        Tue, 21 Feb 2023 18:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677033527; x=1708569527;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=80pqe+/Y5KZdKDUpKtIOSJ6so1hrC3LQZrJH5osRxt0=;
  b=k+NQHW/DvGLmtm9zt5LI2XNG4GVr+BQEKhy3eanEeTv1srQOBXKIaLJg
   rvhNVI/OOtbHyGqsXARIHFeX5FshYg2HIFpnVX+ixnSnrkGfGvNJeyKaP
   V5w3i+b/RTqlWu26NLkE2f0KcozkD13pZ+NIclSoXo0hGbEvczlgQdE8Y
   VBLrveV0mNF0wp/YWkUlt9zGxLpL7EHaDbP3+AMBkqetyo9sdxdhKwRwH
   GGB6/UYJ77wt9eUgnxWTf2kor7j4ehZQln+EWcIgjELQTCbVqIbHyMH7/
   IJl4zYIGQLiT96DmDwi/Snq/lEZR6jT8CvKFXKvXovWpG0u4rXoWamzqG
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="316541445"
X-IronPort-AV: E=Sophos;i="5.97,317,1669104000"; 
   d="scan'208";a="316541445"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 18:38:46 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="1000829027"
X-IronPort-AV: E=Sophos;i="5.97,317,1669104000"; 
   d="scan'208";a="1000829027"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.94]) ([10.238.10.94])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 18:38:44 -0800
Message-ID: <46eb6fe5-0885-2537-099b-33d8bcfde1d3@linux.intel.com>
Date:   Wed, 22 Feb 2023 10:38:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH] KVM: x86: Remove duplicated calls of
 reverse_cpuid_check()
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
References: <20230221032156.791-1-binbin.wu@linux.intel.com>
 <Y/TpLMRiNwGt2dhY@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Y/TpLMRiNwGt2dhY@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/21/2023 11:54 PM, Sean Christopherson wrote:
> On Tue, Feb 21, 2023, Binbin Wu wrote:
>> Remove duplicated calls of reverse_cpuid_check() in __kvm_cpu_cap_mask()
>> and kvm_cpu_cap_{clear, set, get}().
> I want to keep the checks even though they are redundant.  There is no runtime
> cost, and the intent of the direct calls in the "upper" helpers is as much to
> document their usage constraints (input feature must be a compile-time constant)
> as it is to enforce correctness.

Got it.

