Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC51B727394
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 02:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbjFHAIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 20:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjFHAIN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 20:08:13 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B65F1B0;
        Wed,  7 Jun 2023 17:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686182892; x=1717718892;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=orX0Bu/L96/XDgQUIv0Q1F83ZzFs+xjOVyvBhEpOjwY=;
  b=V6Yl7iAckbHsgp1h/0Rzemh1VaM17WSq5mqqOndN5aDNUhehM1WNwQ64
   FWqjwM8ftiJHgW0bu8BWGJ2q6ANJf9GzOd5tMbLBFwQ0NGUnGwgp8k1F6
   HM7bQKjP2GjbHjqM+d63WnThd1hESjEskkC4SYh1FHcwKhNihKld0o/mm
   h2Dpa7Y1VEv7WBn7eZmiGxzgyfOGi7UW1kg9JxGr70uBoCIs0ivn7scFG
   J37k23fUqn91KTWoie8ln/UV24KJ9xytgRuaugdMDs0heKXDO+3jzvygI
   ibVjwz0lVMXdUZZGaOiyubofPzWCAa2iQQCI2ZchqG41WCnUU7NOYM6OG
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="385482269"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="385482269"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 17:08:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="854106686"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="854106686"
Received: from zhanzhiw-mobl2.ger.corp.intel.com (HELO box.shutemov.name) ([10.249.42.209])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 17:08:06 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 6EB6D10F0E0; Thu,  8 Jun 2023 03:08:03 +0300 (+03)
Date:   Thu, 8 Jun 2023 03:08:03 +0300
From:   kirill.shutemov@linux.intel.com
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, dave.hansen@intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v11 03/20] x86/virt/tdx: Make INTEL_TDX_HOST depend on
 X86_X2APIC
Message-ID: <20230608000803.x74u5fuylyw2pxjc@box.shutemov.name>
References: <cover.1685887183.git.kai.huang@intel.com>
 <cee2f2664aac3c5314896c6d14cba50f2617c0e5.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cee2f2664aac3c5314896c6d14cba50f2617c0e5.1685887183.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 02:27:16AM +1200, Kai Huang wrote:
> TDX capable platforms are locked to X2APIC mode and cannot fall back to
> the legacy xAPIC mode when TDX is enabled by the BIOS.  TDX host support
> requires x2APIC.  Make INTEL_TDX_HOST depend on X86_X2APIC.
> 
> Link: https://lore.kernel.org/lkml/ba80b303-31bf-d44a-b05d-5c0f83038798@intel.com/
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
