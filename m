Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9742176FA96
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 09:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbjHDHAm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 03:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbjHDHAh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 03:00:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720211990
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 00:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691132436; x=1722668436;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/gdWf0195XZgAsMSIJVUQLO2groN3JhmY5O4mmSpQvQ=;
  b=I4q6Su0XyOZnIBD81I2OpUrAvWAwq2/ALZ30XTTASc3lveq2KxJso/Y9
   d738aQ82EfjARDAzeBVysS1q5lLhJNnknlnmEm3r+TQXEagF5c/dr5XQQ
   A+Vw+/xIXjGBG5EGsXsTySXUvOWBG7RHsxhWyIjHuDQ4x6GpfZcay4hcF
   DlE1ggijoU6xYJgjt/9Qu+wLiqOP2hzerxzQ/YTLBXPxsY6K1CQSRYoOS
   aREA6QexEE46tCCogh2elpJl/gPLZY3JPdb0kGLb1AagcMbSuBQQdspRN
   bYNpNaG+jsSzbGE8U0gvA+xumBCzwgt+/35M76W5mdEbrKX6NOcL2xhH9
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="349680370"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="349680370"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2023 00:00:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="733092968"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="733092968"
Received: from linux.bj.intel.com ([10.238.156.127])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2023 00:00:28 -0700
Date:   Fri, 4 Aug 2023 14:58:26 +0800
From:   Tao Su <tao1.su@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, xiaoyao.li@intel.com
Subject: Re: [PATCH] KVM: x86: Advertise AMX-COMPLEX CPUID to userspace
Message-ID: <ZMyhku+ybIXl+f10@linux.bj.intel.com>
References: <20230802022954.193843-1-tao1.su@linux.intel.com>
 <169110477096.1973451.1256801276984611165.b4-ty@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169110477096.1973451.1256801276984611165.b4-ty@google.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 03, 2023 at 05:40:28PM -0700, Sean Christopherson wrote:
> On Wed, 02 Aug 2023 10:29:54 +0800, Tao Su wrote:
> > Latest Intel platform GraniteRapids-D introduces AMX-COMPLEX, which adds
> > two instructions to perform matrix multiplication of two tiles containing
> > complex elements and accumulate the results into a packed single precision
> > tile.
> > 
> > AMX-COMPLEX is enumerated via CPUID.(EAX=7,ECX=1):EDX[bit 8]
> > 
> > [...]
> 
> Applied to kvm-x86 misc, thanks!

Sean, thanks!

> 
> [1/1] KVM: x86: Advertise AMX-COMPLEX CPUID to userspace
>       https://github.com/kvm-x86/linux/commit/99b668545356
> 
> --
> https://github.com/kvm-x86/linux/tree/next
> https://github.com/kvm-x86/linux/tree/fixes
