Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB9B7B76DB
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 05:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbjJDD1o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 23:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjJDD1n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 23:27:43 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94D0A7;
        Tue,  3 Oct 2023 20:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696390059; x=1727926059;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XRzc40yKm8KEkXCsgor32yVzEZ5IsO0oazi7M7ukS0Y=;
  b=LR8H/OfurWuYvo9dBLe8CcgL/14OO1qa+77ZyhPEmZKLM/YhZAG9riU5
   n3sGSbXvn9vLtdziOYv7Bn6DV5v3I0Cxh/U8tOFDoweIpyu3Pd1AAw09C
   ylrFaLpoVCeP9O35Swls7a4iktxd14YjuAZA/V1G6hz+Q+hyM/ma29aym
   etssJT5i9yRTysOa8DiCwiA5/nJpxc7ZEsRqdlXM5z8jjAhOm3V+BlvXG
   PwkQ8Rl+LBcmN5enJiLPcZEKDqJuGoJAKK4ze6O2QrEhBauIEzP/Ai4dY
   BOUEDQeikSui/NqPtzj0d2ZTsX2USoIy/o/JmgzUUdhjOXHR5lvZk+vS5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10852"; a="373383521"
X-IronPort-AV: E=Sophos;i="6.03,199,1694761200"; 
   d="scan'208";a="373383521"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 20:27:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10852"; a="894762988"
X-IronPort-AV: E=Sophos;i="6.03,199,1694761200"; 
   d="scan'208";a="894762988"
Received: from ddiaz-mobl4.amr.corp.intel.com (HELO [10.209.57.36]) ([10.209.57.36])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 20:26:12 -0700
Message-ID: <dfdba4e2-371c-db18-6989-541f802a0783@intel.com>
Date:   Tue, 3 Oct 2023 20:27:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] x86: KVM: Add feature flag for AMD's
 FsGsKernelGsBaseNonSerializing
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20231004002038.907778-1-jmattson@google.com>
 <01009a2a-929e-ce16-6f44-1d314e6bcba5@intel.com>
 <CALMp9eR+Qudg++J_dmY_SGbM_kr=GQcRRcjuUxtm9rfaC_qeXQ@mail.gmail.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <CALMp9eR+Qudg++J_dmY_SGbM_kr=GQcRRcjuUxtm9rfaC_qeXQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/3/23 19:44, Jim Mattson wrote:
> I'm a little surprised at the pushback, TBH. Are you implying that
> there is some advantage to *not* passing this bit through?

I'm not really trying to push back.  I'm honestly just curious.  Linux
obviously doesn't cat about the bit.  So is this for some future Linux
or some other OS?
