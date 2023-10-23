Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 339A27D3CD5
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 18:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjJWQry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 12:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbjJWQrv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 12:47:51 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD65E5;
        Mon, 23 Oct 2023 09:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698079668; x=1729615668;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=k5NUL4mpopozZ11ahoVTd3kwFnCjQG+h6jR8y0XkgV8=;
  b=miqrnXXKpUr0FcBV8La3i1TZHXoIXlLzNhDWjIlboYSZi8JZx+h54hM/
   oJOrQaQTLed4fu7mq+M8NdWOrTTnCUNEeKHaJsMXi7QSK60X2JqU/VIpB
   SmEUXGwjjCAWtIl/RDU9Pmhf38lKxhjmoAlBWpDcsUcFgtcBI7q75YLOS
   nM0+/6fqn5Swil75jH7fxW4SBHaVlRIUAKsMclGwuyOH9P9X5Nb4tFrMd
   kFe+tKT3frn+vN7POe2wZ2xTcSvGp2a+qoBhbFRymuO6YP8dcHdheJoL3
   i8v5emn9O/OpIvG6m5uN/ySIbkUUfPz5p0owT+qj0yX0tFEOGDNa0932+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="389729889"
X-IronPort-AV: E=Sophos;i="6.03,246,1694761200"; 
   d="scan'208";a="389729889"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2023 09:47:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="758184082"
X-IronPort-AV: E=Sophos;i="6.03,246,1694761200"; 
   d="scan'208";a="758184082"
Received: from unknown (HELO windy) ([10.241.244.107])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2023 09:47:39 -0700
Date:   Mon, 23 Oct 2023 09:06:59 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Nikolay Borisov <nik.borisov@suse.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com
Subject: Re: [PATCH 5/6] x86/bugs: Cleanup mds_user_clear
Message-ID: <20231023160659.cfa37wlcqfty43rp@windy>
References: <20231020-delay-verw-v1-0-cff54096326d@linux.intel.com>
 <20231020-delay-verw-v1-5-cff54096326d@linux.intel.com>
 <56c57e1a-bb08-4ac8-9d3b-bdc649640cfb@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <56c57e1a-bb08-4ac8-9d3b-bdc649640cfb@suse.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 11:51:39AM +0300, Nikolay Borisov wrote:
> 
> 
> On 20.10.23 г. 23:45 ч., Pawan Gupta wrote:
> > There are no more users of mds_user_clear static key, remove it.
> > 
> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> 
> This patch can be squashed into the previous one. You've already done the
> bulk of the work to eliminate usage of mds_user_clear there.

Yes, it can be squashed, into previous one. Will do that in next
revision.
