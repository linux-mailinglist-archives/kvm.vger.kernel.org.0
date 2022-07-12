Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290FB572949
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 00:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbiGLW1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 18:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbiGLW1V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 18:27:21 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93AEB23EC
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 15:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657664840; x=1689200840;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=yh2cM9e0V8TmchkEozlXwftQLG030kPsULbAQou6uK4=;
  b=Yb3sJ6rS7iBprp81Z9yqL5J8/SsdzLTVpzQT48lxivZf9fP3cq6SHAxu
   N+fLtgIGYbE3sca0ht+PO143bpSHh5bONR0/LszA8FagHo0rjl5Vl/MY1
   U+7mQMx0LWVBLzoQ+kFgf78yV2pmoZ+IJx9sJgGixXF40HSo0544FNcTW
   XFDZMUePdUuwpROb2KY9CK6CX+kmOdXzwc4OorJ4KcyO/58I+VJHeXEKQ
   Jp1dYACcYNdnvPUxfy7Ty7U0iWMIOQIz92zgRicfzrnSxNYYLAoLkHC8O
   rv8haQmh9k2AGvxU2trttDVGZbJAXwc2Q7n3ITCoe4PqQRqHR4Jj30ws3
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="286187187"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="286187187"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 15:27:20 -0700
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="545599593"
Received: from ssamal-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.34.210])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 15:27:19 -0700
Message-ID: <94dda3255545bb5dbb5f76a81d5189d382c1d187.camel@intel.com>
Subject: Re: [PATCH] KVM, x86/mmu: Fix the comment around
 kvm_tdp_mmu_zap_leafs()
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, bgardon@google.com
Date:   Wed, 13 Jul 2022 10:27:17 +1200
In-Reply-To: <Ys2zrXTDiWkeIwGm@google.com>
References: <20220712030835.286052-1-kai.huang@intel.com>
         <Ys2zrXTDiWkeIwGm@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-07-12 at 17:47 +0000, Sean Christopherson wrote:
> On Tue, Jul 12, 2022, Kai Huang wrote:
> > Now kvm_tdp_mmu_zap_leafs() only zaps leaf SPTEs but not any non-root
> > pages within that GFN range anymore, so the comment isn't right.
> >=20
> > Fixes: f47e5bbbc92f ("KVM: x86/mmu: Zap only TDP MMU leafs in zap range=
 and mmu_notifier unmap")
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index f3a430d64975..7692e6273462 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -969,10 +969,9 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, str=
uct kvm_mmu_page *root,
> >  }
> > =20
> >  /*
> > - * Tears down the mappings for the range of gfns, [start, end), and fr=
ees the
> > - * non-root pages mapping GFNs strictly within that range. Returns tru=
e if
> > - * SPTEs have been cleared and a TLB flush is needed before releasing =
the
> > - * MMU lock.
> > + * Zap leafs SPTEs for the range of gfns, [start, end) for all roots. =
Returns
> > + * true if SPTEs have been cleared and a TLB flush is needed before re=
leasing
> > + * the MMU lock.
>=20
> What about shifting the comment from tdp_mmu_zap_leafs() instead of dupli=
cating it?
> tdp_mmu_zap_leafs() is static and kvm_tdp_mmu_zap_leafs() is the sole cal=
ler.  And
> opportunistically tweak the blurb about SPTEs being cleared to (a) say "z=
apped"
> instead of "cleared" because "cleared" will be wrong if/when KVM sets SUP=
PRESS_VE,
> and (b) to clarify that a flush is needed if and only if a SPTE has been =
zapped
> since MMU lock was last acquired.
>=20
> E.g.
>=20
> /*
>  * If can_yield is true, will release the MMU lock and reschedule if the
>  * scheduler needs the CPU or there is contention on the MMU lock. If thi=
s
>  * function cannot yield, it will not release the MMU lock or reschedule =
and
>  * the caller must ensure it does not supply too large a GFN range, or th=
e
>  * operation can cause a soft lockup.
>  */
> static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
> 			      gfn_t start, gfn_t end, bool can_yield, bool flush)
>=20
> /*
>  * Zap leafs SPTEs for the range of gfns, [start, end), for all roots.  R=
eturns
>  * true if a TLB flush is needed before releasing the MMU lock, i.e. if o=
ne or
>  * more SPTEs were zapped since the MMU lock was last acquired.
>  */
> bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t=
 end,
> 			   bool can_yield, bool flush)

Yes looks better.  Will send out  a new patch soon.  Thanks.

--=20
Thanks,
-Kai


