Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B233374D1E
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 03:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhEFB5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 21:57:42 -0400
Received: from mga03.intel.com ([134.134.136.65]:26000 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229488AbhEFB5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 21:57:40 -0400
IronPort-SDR: LZ7KxEEbXMnVScdvIq3ZDpgqX9tfG6q4yGGzmVzEJX+qqACkRfSC+7ws8Jxj+jkiOHjT91lDQR
 gDEBHLeMkM4w==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="198403961"
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="198403961"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 18:56:43 -0700
IronPort-SDR: DaUOOV52LW22FFn5MVlFXDJn8/Hza/txWljjB2WJ92MRbMjKib4zgsMMw1xYsDVONbyw1Qlng5
 do0F/h/lqP/Q==
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="619333107"
Received: from jhagel-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.164.152])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 18:56:40 -0700
Message-ID: <c96a3fc259726a52bbc18ccc5bb1b06d58216dee.camel@intel.com>
Subject: Re: [PATCH 1/3] KVM: x86/mmu: Fix return value in
 tdp_mmu_map_handle_target_level()
From:   Kai Huang <kai.huang@intel.com>
To:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Date:   Thu, 06 May 2021 13:56:38 +1200
In-Reply-To: <CANgfPd_s1jrAaRRPtC=VUbeL=GfqWPncPx3RVG=+mK3fCiuiKQ@mail.gmail.com>
References: <cover.1620200410.git.kai.huang@intel.com>
         <00875eb37d6b5cc9d19bb19e31db3130ac1d8730.1620200410.git.kai.huang@intel.com>
         <YJLBARcEiD+Sn4UV@google.com>
         <CANgfPd_s1jrAaRRPtC=VUbeL=GfqWPncPx3RVG=+mK3fCiuiKQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-05-05 at 09:04 -0700, Ben Gardon wrote:
> On Wed, May 5, 2021 at 9:00 AM Sean Christopherson <seanjc@google.com> wrote:
> > 
> > On Wed, May 05, 2021, Kai Huang wrote:
> > > Currently tdp_mmu_map_handle_target_level() returns 0, which is
> > > RET_PF_RETRY, when page fault is actually fixed.  This makes
> > > kvm_tdp_mmu_map() also return RET_PF_RETRY in this case, instead of
> > > RET_PF_FIXED.  Fix by initializing ret to RET_PF_FIXED.
> > 
> > Probably worth adding a blurb to call out that the bad return value is benign
> > since kvm_mmu_page_fault() resumes the guest on RET_PF_RETRY or RET_PF_FIXED.
> > And for good measure, a Fixes without stable@.
> > 
> >   Fixes: bb18842e2111 ("kvm: x86/mmu: Add TDP MMU PF handler")
> > 
> > Reviewed-by: Sean Christopherson <seanjc@google.com>
> 
> Haha I was just about to add the same two comments. Besides those,
> this patch looks good to me as well.
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> 
> 

Thanks Sean and Ben. I'll add Sean's suggestion to commit message, and add a Fixes:...


