Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB28573A6B6
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 18:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjFVQ4q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 12:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbjFVQ41 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 12:56:27 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E82B199D;
        Thu, 22 Jun 2023 09:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687452986; x=1718988986;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hssRzX5rd6kzt5frubTkXHI0xvMg2h4kSa6zQkP2Q/Q=;
  b=VLpzimunIDnctDrWSWML/8pS5x9ZNnCG6vUSatbSQBE6AZ/S7do9TlrS
   GzbhBW5XjjQL5KXvTIygcJMkzXn2451lLYOQveJqt2KNe0qC7SyHb0ogg
   ttFGAtGLGprOPvlkPuyYhKGFriBEVqtDh3WxglddcRThJ0/IT0tbIdg/k
   E1O5bbP4IBqnFEdfAwIAL4SHuVT2lqqsZrgkg5hcZqGNt//ltHYIowi9t
   0jaseyocSLGWrT5Xz5EWXxOXBSAIcO9969f41LxSBFCUw7zNDMHeMotY1
   YlF+YPyHX53KeRZAOGvchbWFlSenZhzSvGQb36+IehCASdaR+CFmYaBuL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="360577772"
X-IronPort-AV: E=Sophos;i="6.01,149,1684825200"; 
   d="scan'208";a="360577772"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 09:56:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="828003081"
X-IronPort-AV: E=Sophos;i="6.01,149,1684825200"; 
   d="scan'208";a="828003081"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmsmga002.fm.intel.com with ESMTP; 22 Jun 2023 09:56:11 -0700
Date:   Fri, 23 Jun 2023 08:55:14 +0800
From:   Xu Yilun <yilun.xu@intel.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 2/6] KVM: Documentation: Update the field name gfns in
 kvm_mmu_page
Message-ID: <ZJTtcuELIfZf1XaV@yilunxu-OptiPlex-7050>
References: <20230618000856.1714902-1-mizhang@google.com>
 <20230618000856.1714902-3-mizhang@google.com>
 <ZJTnvuoVWLhv0H0f@yilunxu-OptiPlex-7050>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJTnvuoVWLhv0H0f@yilunxu-OptiPlex-7050>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-06-23 at 08:30:54 +0800, Xu Yilun wrote:
> On 2023-06-18 at 00:08:52 +0000, Mingwei Zhang wrote:
> > Update the 'gfns' in kvm_mmu_page to 'shadowed_translation'to be consistent
> > with the code. The more detailed description of 'shadowed_translation' is
> > already inlined in the data structure definition, so no need to duplicate
> > the text but simply just update the name.
> 
> The definition of this field is changed, but apprently the description
> here is for gfns. It leaves some confusion if we just leave them
> unchanged.
> 
> > 
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  Documentation/virt/kvm/x86/mmu.rst | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
> > index 561efa8ec7d7..149dd3cba48f 100644
> > --- a/Documentation/virt/kvm/x86/mmu.rst
> > +++ b/Documentation/virt/kvm/x86/mmu.rst
> > @@ -221,7 +221,7 @@ Shadow pages contain the following information:
> >      at __pa(sp2->spt).  sp2 will point back at sp1 through parent_pte.
> >      The spt array forms a DAG structure with the shadow page as a node, and
> >      guest pages as leaves.
> > -  gfns:
> > +  shadowed_translation:
> >      An array of 512 guest frame numbers, one for each present pte.  Used to
> 
> guest frame numbers -> shadow translation info (gfn + access)
> 
> >      perform a reverse map from a pte to a gfn. When role.direct is set, any
> 
> Just "perform reverse mapping" is OK?
> 
> >      element of this array can be calculated from the gfn field when used, in
> 
> May remove the "of gfns"

Sorry, forgot to append the original sentence.

    element of this array can be calculated from the gfn field when used, in
    this case, the array of gfns is not allocated. See role.direct and gfn.
                               ^
May remove the "of gfns"

Thanks,
Yilun

> 
> > -- 
> > 2.41.0.162.gfafddb0af9-goog
> > 
