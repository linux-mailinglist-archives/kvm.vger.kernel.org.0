Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C4161A3DF
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 23:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiKDWGc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 18:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiKDWGa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 18:06:30 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26401D10A;
        Fri,  4 Nov 2022 15:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667599590; x=1699135590;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fW0Bxr9OnS17BvgprAuZazMwrhTy9Qfa+MwnyV0jt60=;
  b=n4hAvMbyxzAX+HZ9f5EgeAzpeNQ2G2C5NYqieQrd6sSgBKpDZBaCEqUj
   GDEbWiJztuLp2Gj5qimeRplzG4qTv1WfxgiC8xPoKja34A9/L7PKnYVxp
   sgi1TiCf+ktmF2L9BPtCDV3MP7CrbKz4mLwzW2lZeKWJZEDjObAkzxT2p
   xFNLDg0nCgDCoHqRoirutydS3cqhjuDKc4Dw4o7Px4jAEPRZzA1XqZdDf
   jPDZNw6EHvvr+tRwJWwv3yZosrjSN+JVkaZpFUXfg8ET+HlP/7yiXgi2v
   RWIHk4SOM0rtA/tgiFwCIRnv7VHCvxLgIRoSlYTo7lpgpK01hjxIELvMV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="289811519"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="289811519"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 15:06:29 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="635243963"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="635243963"
Received: from anantsin-mobl2.amr.corp.intel.com (HELO [10.209.97.57]) ([10.209.97.57])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 15:06:28 -0700
Message-ID: <b2274949-8fba-24ff-89bf-627f288ace06@intel.com>
Date:   Fri, 4 Nov 2022 15:06:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 0/3] x86/speculation: Support Automatic IBRS
Content-Language: en-US
To:     Kim Phillips <kim.phillips@amd.com>, x86@kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221104213651.141057-1-kim.phillips@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20221104213651.141057-1-kim.phillips@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/4/22 14:36, Kim Phillips wrote:
> The AMD Zen4 core supports a new feature called Automatic IBRS.
> (Indirect Branch Restricted Speculation).
> 
> Enable Automatic IBRS by default if the CPU feature is present.
> It typically provides greater performance over the incumbent
> generic retpolines mitigation.

Could you also share some information on how this differs from EIBRS and
why it needs to exist in parallel to EBIRS?
