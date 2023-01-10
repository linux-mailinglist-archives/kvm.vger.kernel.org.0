Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0424F6644C6
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 16:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239064AbjAJP2a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 10:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238750AbjAJP1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 10:27:54 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231C232E94;
        Tue, 10 Jan 2023 07:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673364473; x=1704900473;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4Am0Tp9HLuqkqysR0wBqMIuaQhk45x9nTKJpzR92A6w=;
  b=E0He0SMGFTQh4yPYnSxkDl0mQg/sJk1xsDDZy6eSsxu43V1S2vjEiRHl
   RW3xGLn2TufUXyesljr/PneHdrFnOqeZIf/JHDtwBvfrtjkxx19i027gh
   gUZUN6q36gImN9LR9lOhktqKkMb7AwXCrLg5DWrIn9njmV9N5619dnXh+
   5HXYo7TaI1/LH5RYA14qKu3vub7xV8B/OFP4ZfzbWRPaO+5FikDb3clpu
   YmhfJmX8BOTQRNXeYvo0MiwGPmZ9Z7I9UozD683AF/FRjRRS1iiR0H9w2
   GAXHoA/aG3BU6b60BQ/BQjYLc/HBnd+PcPLrV0xxN9Bw9wK3/2PNUCl3j
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="324407492"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="324407492"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 07:17:31 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="781093858"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="781093858"
Received: from svenka7-mobl1.amr.corp.intel.com (HELO [10.209.63.27]) ([10.209.63.27])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 07:17:29 -0800
Message-ID: <8cf4755b-2592-02fb-46a1-8c32be94ebcf@intel.com>
Date:   Tue, 10 Jan 2023 07:17:29 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 11/16] x86/virt/tdx: Designate reserved areas for all
 TDMRs
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
 <27dcd2781a450b3f77a2aec833de6a3669bc0fb8.1670566861.git.kai.huang@intel.com>
 <2d7d2824-7aa7-5f96-d79b-b44ff7fe2ef9@intel.com>
 <b971cd8b4e6ce9e96c6b4c6192adb74cc6722d54.camel@intel.com>
 <5f7891ebecb8dbe71b9e2c67332df716f0b9a8e0.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <5f7891ebecb8dbe71b9e2c67332df716f0b9a8e0.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/10/23 03:01, Huang, Kai wrote:
> On Tue, 2023-01-10 at 01:19 +0000, Huang, Kai wrote:
>>> I think the -E2BIG is also wrong.  It should be ENOSPC.  I'd also add a
>>> pr_warn() there.  Especially with how lazy this whole thing is, I can
>>> start to see how the reserved areas might be exhausted.  Let's be kind
>>> to our future selves and make the error (and the fix) easier to find.
>> Yes agreed.  Will change to -ENOSPC and add pr_warn().
> Btw, in patch ("x86/virt/tdx: Fill out TDMRs to cover all TDX memory regions"),
> when there are too many TDMRs, I suppose I should also return -ENOSPC instead of
> -E2BIG?

Yes.
