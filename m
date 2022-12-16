Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0418364E90E
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 11:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiLPKDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 05:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiLPKDo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 05:03:44 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45834A056;
        Fri, 16 Dec 2022 02:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671185023; x=1702721023;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iL3v9W9JsUQY9SxcVHN0UWhfZb6jDPXHg3+Oshg1GJM=;
  b=JfPhvIk5wlmQDwv/majiT5crTI5bBFLGduhx1/X3/be4IRuf8n0Oy7SW
   QLdbWBGElA4B7vfzdjc9QmadiAxtYMOlg6lBNqJeT6giMQtm3eB0/D/ct
   E2yQvuuo+milZUQCINpCxAdc3F0bC/JkxsV+t45vd24iWhocEiagSslv3
   4cxpaXYT4QvljZMohAlmmIx5jAC3PdXy84wc6x8rhwfWEzwP+mWFIK/J4
   auhslu31Woy38GdD71KJoCGjBK0rDrNT5incm3tfkDgRXiWmvRZm6JBsX
   cPemSsH9krJco+3LBvKfC2x+XhC/okGZP3LUxeuDUKfSFW19mHQYI0elo
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="316575488"
X-IronPort-AV: E=Sophos;i="5.96,249,1665471600"; 
   d="scan'208";a="316575488"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2022 01:59:30 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="627516636"
X-IronPort-AV: E=Sophos;i="5.96,249,1665471600"; 
   d="scan'208";a="627516636"
Received: from xintongc-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.168.175])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2022 01:59:25 -0800
Date:   Fri, 16 Dec 2022 17:59:22 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH v2 0/4] KVM: nVMX: Fix 2nd exec controls override goofs
Message-ID: <20221216095922.swvqp7olwr2rgpyc@linux.intel.com>
References: <20221213062306.667649-1-seanjc@google.com>
 <20221214030037.4qz6v6fvfx6of32n@linux.intel.com>
 <Y5pn2fYf5eHu8yCb@google.com>
 <20221215112436.2iqizpso5loeficn@linux.intel.com>
 <Y5toZtbdxwgCTlFT@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5toZtbdxwgCTlFT@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> 
> They're definitely not too trivial.  This is just an especially rough time of
> year for reviews, e.g. end of year corporate stuff, merge window, holidays, etc.
> 

Glad to know that. Thanks!

> Part of why I haven't provided reviews is that the patches _aren't_ super trivial,
> e.g. I'm on the fence on whether mmu_is_direct() should take @vcpu or @mmu, and if
> I vote to have it take @mmu, then that'll conflict with mmu_is_nested().  So I end
> up staying silent until I can come back to it with fresh eyes to see if there's a
> better alternative, or if I'm just being nitpicky.
> 
Well, though I would prefer mmu_is_direct(), I appreciate for
being considerate. We can discuss it later. :)

B.R.
Yu
