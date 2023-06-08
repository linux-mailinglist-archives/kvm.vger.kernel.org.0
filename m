Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 717CF728C0F
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 01:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237619AbjFHX4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 19:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjFHX4x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 19:56:53 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8FC2D52;
        Thu,  8 Jun 2023 16:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686268612; x=1717804612;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YtjkQV1FgrLTDwfP13V5T3suE7YQGm9ikTSNjtB6w1w=;
  b=iWMkulKHoBgk++6KFJDn21N0yPjSlxV3Jw7rmlKGuOR41UKlSksMcTMv
   k9mhm6MXkMUecX99X4BRntozo5qKAmN2dB06DQs2Obuw1omz9UeG/NIpY
   fXbI+4X5eBvPcFLidl4PL2z76h/YhfhHp/Parw5HKaqGVWPOXL3ya79aw
   Gh/z5sKc9sGk/BlgYWQ8BX/Y2i5b+kVW0eqiB2hrcwPR9NygREbm1R+xU
   umH/7bak4hiUuCYB1rPsOCqbFsxvFpBEw52kwwhIwCU3+WqFe3SCyNmT5
   +L1VmJYwCWBHcDHzZLvrxa1wOjyTnxFQ+ZA7cLCWwnWF5a+wNEKLppvOX
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="423342725"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="423342725"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 16:56:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="800003452"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="800003452"
Received: from goels-mobl.ger.corp.intel.com (HELO [10.209.86.239]) ([10.209.86.239])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 16:56:50 -0700
Message-ID: <971f158b-f28a-6c1f-c37c-fe67134d737c@intel.com>
Date:   Thu, 8 Jun 2023 16:56:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 20/20] Documentation/x86: Add documentation for TDX
 host support
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, kirill.shutemov@linux.intel.com,
        tony.luck@intel.com, peterz@infradead.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, david@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1685887183.git.kai.huang@intel.com>
 <34853e0f8f38ec2fda66b0ba480d4df63b8aab43.1685887183.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <34853e0f8f38ec2fda66b0ba480d4df63b8aab43.1685887183.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/4/23 07:27, Kai Huang wrote:
> +There is no CPUID or MSR to detect the TDX module.  The kernel detects it
> +by initializing it.

Is this really what you want to say?

If the module is there, SEAMCALL works.  If not, it doesn't.  The module
is assumed to be there when SEAMCALL works.  Right?

Yeah, that first SEAMCALL is probably an initialization call, but feel
like that's beside the point.
