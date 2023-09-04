Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069E0791042
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 05:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237827AbjIDDGd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Sep 2023 23:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjIDDGd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Sep 2023 23:06:33 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23F510A
        for <kvm@vger.kernel.org>; Sun,  3 Sep 2023 20:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693796789; x=1725332789;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vH7o/1tq3tgf/YCilGFCFBZoneN81arvdrs1XNPvbZU=;
  b=fTFxNy/DRAbzZ8b+IeFjRNFuhWV2/F7IA7b5iIjEnWtKFC0QtY8qv8aN
   8ZjD36EdBKw7f/AsOf8xw27hmUJvqXFGsUMxjbINWEll2lWgghEmthlNj
   7Xj9atHHcIFrPB/d5i5Uqgs25CAMRf7fKHOyueMIqMBr3tYiaKb7o4+W1
   zVZbtXNIApLwBXrxPNDDktpp54+5yvuuzDMjs+fe832HTYLuiKxW/vs4j
   PN9vhWiuwtS4slXP016/+uCjrlxw+CISAXgRwBwWXV2qBMmFAYkJ+LSqX
   KhAc5hXMiGNsKpoLuxHqqi2h1/tf5xf4mJiMKYfySR1nR+LGjlYhRm7VP
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="375403781"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="375403781"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2023 20:06:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="810748476"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="810748476"
Received: from linux.bj.intel.com ([10.238.157.71])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2023 20:06:27 -0700
Date:   Mon, 4 Sep 2023 11:03:50 +0800
From:   Tao Su <tao1.su@linux.intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        guang.zeng@intel.com, yi1.lai@intel.com
Subject: Re: [PATCH 1/2] x86/apic: Introduce X2APIC_ICR_UNUSED_12 for x2APIC
 mode
Message-ID: <ZPVJFqGn0JG9x0Nu@linux.bj.intel.com>
References: <20230904013555.725413-1-tao1.su@linux.intel.com>
 <20230904013555.725413-2-tao1.su@linux.intel.com>
 <ZPVH2HlIt1K3c0Bz@chao-email>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPVH2HlIt1K3c0Bz@chao-email>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 04, 2023 at 10:58:32AM +0800, Chao Gao wrote:
> On Mon, Sep 04, 2023 at 09:35:54AM +0800, Tao Su wrote:
> >According to SDM, bit12 of ICR is no longer BUSY bit but UNUSED bit in
> >x2APIC mode, which is the only difference of lower ICR between xAPIC and
> >x2APIC mode. To avoid ambiguity, introduce X2APIC_ICR_UNUSED_12 for
> >x2APIC mode.
> >
> >Signed-off-by: Tao Su <tao1.su@linux.intel.com>
> 
> Please use scripts/get_maintainer.pl to help create the Cc/To lists.
> I believe x86 maintainers should be copied for this patch.

Ok, I will cc x86 maintainers if keep this patch in the next version.

Thanks,
Tao

> 
> >---
> > arch/x86/include/asm/apicdef.h | 1 +
> > 1 file changed, 1 insertion(+)
> >
> >diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
> >index 4b125e5b3187..ea2725738b81 100644
> >--- a/arch/x86/include/asm/apicdef.h
> >+++ b/arch/x86/include/asm/apicdef.h
> >@@ -78,6 +78,7 @@
> > #define		APIC_INT_LEVELTRIG	0x08000
> > #define		APIC_INT_ASSERT		0x04000
> > #define		APIC_ICR_BUSY		0x01000
> >+#define		X2APIC_ICR_UNUSED_12	0x01000
> > #define		APIC_DEST_LOGICAL	0x00800
> > #define		APIC_DEST_PHYSICAL	0x00000
> > #define		APIC_DM_FIXED		0x00000
> >-- 
> >2.34.1
> >
