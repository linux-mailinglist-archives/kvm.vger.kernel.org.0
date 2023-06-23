Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85E0373A61C
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 18:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbjFVQcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 12:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjFVQcQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 12:32:16 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155AC1BD9;
        Thu, 22 Jun 2023 09:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687451535; x=1718987535;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iP0/anX5cEsrg5k0eU+acU3r2Q4ClUJN8yRVCkyvgZ8=;
  b=LPqR98QPWOdlXU9GbvuQkKGRJalO5V0EOqpUbXtY47UK+lm8dGJju8Dg
   GPmOImwlMlm4YHOjDpiea/VyPzTd+V7l+3XrTzGxew4TDPPGm/2rfzZ9l
   SzN8MMAdebNAWPDg63sTrxquA8LSzIhJZIj3WuI8aY/bHVDXcenhh1LMK
   UC8Vwv37HMLwfDzolHINQHnq7RtZ3a6B4BukXK7YQCDEDE4Vz5kmEAfBP
   Ah2YXZSY+du5Q5XbemepTBYucCHZsmOwuHUkmmpGDsZdtomBrArkSNId3
   spy3BD3M3dna0hqBKU96gpcJjO9V/gPKwDNQJEnaoaG4l3TVURVVa46tW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="345297890"
X-IronPort-AV: E=Sophos;i="6.01,149,1684825200"; 
   d="scan'208";a="345297890"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 09:31:53 -0700
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="749375192"
X-IronPort-AV: E=Sophos;i="6.01,149,1684825200"; 
   d="scan'208";a="749375192"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orsmga001.jf.intel.com with ESMTP; 22 Jun 2023 09:31:51 -0700
Date:   Fri, 23 Jun 2023 08:30:54 +0800
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
Message-ID: <ZJTnvuoVWLhv0H0f@yilunxu-OptiPlex-7050>
References: <20230618000856.1714902-1-mizhang@google.com>
 <20230618000856.1714902-3-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230618000856.1714902-3-mizhang@google.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-06-18 at 00:08:52 +0000, Mingwei Zhang wrote:
> Update the 'gfns' in kvm_mmu_page to 'shadowed_translation'to be consistent
> with the code. The more detailed description of 'shadowed_translation' is
> already inlined in the data structure definition, so no need to duplicate
> the text but simply just update the name.

The definition of this field is changed, but apprently the description
here is for gfns. It leaves some confusion if we just leave them
unchanged.

> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  Documentation/virt/kvm/x86/mmu.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
> index 561efa8ec7d7..149dd3cba48f 100644
> --- a/Documentation/virt/kvm/x86/mmu.rst
> +++ b/Documentation/virt/kvm/x86/mmu.rst
> @@ -221,7 +221,7 @@ Shadow pages contain the following information:
>      at __pa(sp2->spt).  sp2 will point back at sp1 through parent_pte.
>      The spt array forms a DAG structure with the shadow page as a node, and
>      guest pages as leaves.
> -  gfns:
> +  shadowed_translation:
>      An array of 512 guest frame numbers, one for each present pte.  Used to

guest frame numbers -> shadow translation info (gfn + access)

>      perform a reverse map from a pte to a gfn. When role.direct is set, any

Just "perform reverse mapping" is OK?

>      element of this array can be calculated from the gfn field when used, in

May remove the "of gfns"

Thanks,
Yilun

> -- 
> 2.41.0.162.gfafddb0af9-goog
> 
