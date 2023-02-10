Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFE4691969
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 08:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbjBJHzw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 02:55:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbjBJHzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 02:55:50 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CA47AE20
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 23:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676015750; x=1707551750;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O0veKo0n3qHNLp49ikymSS3Pq+h62cPf94Dgvn+U2Zs=;
  b=DsKLeiH/MHHB5ja7LxT/YU3E7JlaS1dg/tACANm+7wIp2mAVQKEXJlOx
   yn4VG/857PkzcN8NfCBumlroloGfLoYxJ1kK98RQ6o1YgIUXxH+y53c4q
   U/k87Ktga5veQ1I1of0eICRM7h7pdJi4pm94EpSPenEmqAvqui061eW92
   Mbhp2pBiZvAMqwiU20eiCOEQGnE/G7Zl5PrO82Y/Dym2zU2s1i9rWNzR1
   MV/ITtnSbq00Kk8hO+D4zEPEA3N3Zi+ZraC4tV77mnWcr+YxCyz1/k0fH
   Yo6E4tw6locX3kBhQaeRdyihN+wZzOGAEKqy7OCcVgxUhPJdzvMpTHox6
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="331666373"
X-IronPort-AV: E=Sophos;i="5.97,286,1669104000"; 
   d="scan'208";a="331666373"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 23:55:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="791876859"
X-IronPort-AV: E=Sophos;i="5.97,286,1669104000"; 
   d="scan'208";a="791876859"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga004.jf.intel.com with ESMTP; 09 Feb 2023 23:55:46 -0800
Message-ID: <565f9b25ffbe4aef08dd8511ea66b0cb3f1d932d.camel@linux.intel.com>
Subject: Re: [PATCH v4 3/9] KVM: x86: MMU: Commets update
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, isaku.yamahata@intel.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Date:   Fri, 10 Feb 2023 15:55:45 +0800
In-Reply-To: <Y+XrStGM5J/hGX6r@gao-cwp>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
         <20230209024022.3371768-4-robert.hu@linux.intel.com>
         <Y+XrStGM5J/hGX6r@gao-cwp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-02-10 at 14:59 +0800, Chao Gao wrote:
> On Thu, Feb 09, 2023 at 10:40:16AM +0800, Robert Hoo wrote:
> > kvm_mmu_ensure_valid_pgd() is stale. Update the comments according
> > to
> > latest code.
> > 
> > No function changes.
> > 
> > P.S. Sean firstly noticed this in
> 
> Reported-by:?

OK. Sean agree?
> 
> Should not this be post separately? This patch has nothing to do with
> LAM.

It's too trivial to post separately, I think, just comments updates.
And it on the code path of LAM KVM enabling, therefore I observed and
update passingly; although no code change happens.
> 
> > https://lore.kernel.org/kvm/Yg%2FguAXFLJBmDflh@google.com/.
> > 
> > Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> > ---
> > arch/x86/kvm/mmu/mmu.c | 6 +++++-
> > 1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 1d61dfe37c77..9a780445a88e 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4497,8 +4497,12 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu,
> > gpa_t new_pgd)
> > 	struct kvm_mmu *mmu = vcpu->arch.mmu;
> > 	union kvm_mmu_page_role new_role = mmu->root_role;
> > 
> > +	/*
> > +	 * If no root is found in cache, current active root.hpa will
> > be (set)
> > +	 * INVALID_PAGE, a new root will be set up during
> > vcpu_enter_guest()
> > +	 * --> kvm_mmu_reload().
> > +	 */
> > 	if (!fast_pgd_switch(vcpu->kvm, mmu, new_pgd, new_role)) {
> > -		/* kvm_mmu_ensure_valid_pgd will set up a new root.  */
> > 		return;
> > 	}
> > 
> > -- 
> > 2.31.1
> > 

