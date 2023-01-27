Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB70A67E844
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 15:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjA0O3v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 09:29:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbjA0O3r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 09:29:47 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAFAFF0E
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 06:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674829786; x=1706365786;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BCfx2Jt1OOxVhyMuRudyFc+VqLDRXHbv4TMMWE08Vow=;
  b=Stm/pEAC6JZNFaageHMtRVRt740uYI8CP3CtDWxpBj33r5Zyx6ctSS/A
   u4ZMwfuhfarTT0iVpSnog6vGydQQre/eHElVy0rK5kjoipVpZ7ts2BnxP
   CdGESI8M4qXVLXE7U8WUzjPxo7I39Su5epSeG70g4MuIibFcVWfj3/5Zy
   W2IwcKUoSiaOw+5qtFg7oi7CS1xegNDcQNTtjOCi6viLlfpIeLAOXX74J
   vPniWWj3OQvw5U8dSLM1/u0G6oNUzDuo4P0oqxlRDMuY3xT0RUm0wJgi7
   CIxPP4zqVcqKTffU9Gw1dY9g2UVngxSJfh/BXyyjccYVj0mPv0QD2/xFx
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="389471350"
X-IronPort-AV: E=Sophos;i="5.97,251,1669104000"; 
   d="scan'208";a="389471350"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2023 06:29:46 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="752013269"
X-IronPort-AV: E=Sophos;i="5.97,251,1669104000"; 
   d="scan'208";a="752013269"
Received: from bixuanzh-mobl1.ccr.corp.intel.com (HELO localhost) ([10.249.173.156])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2023 06:29:44 -0800
Date:   Fri, 27 Jan 2023 22:29:56 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com
Subject: Re: A question of KVM selftests' makefile
Message-ID: <20230127142956.7iej2ozhid2ibpfo@linux.intel.com>
References: <20230125085350.xg6u73ozznpum4u5@linux.intel.com>
 <4320fc00-ac70-c0ef-672c-b3bb03496bdf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4320fc00-ac70-c0ef-672c-b3bb03496bdf@redhat.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 25, 2023 at 07:46:47PM +0100, Paolo Bonzini wrote:
> On 1/25/23 09:53, Yu Zhang wrote:
> >   x := $(shell mkdir -p $(sort $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
> >   $(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c
> > -       $(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
> > +       $(CC) $(CFLAGS) $(CPPFLAGS) $(EXTRA_CFLAGS) $(TARGET_ARCH) -c $< -o $@
> 
> Yes, this all looks very good.  Feel free to post it as a patch!
> 
> Paolo
> 

Thank you so much, Paolo & Sean! Just posted the patch!

B.R.
Yu
