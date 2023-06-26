Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7669373ED1E
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 23:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbjFZVuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 17:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjFZVuC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 17:50:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C3910D5;
        Mon, 26 Jun 2023 14:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=Q/bpZdoiYyoU4Gkjmy8VvNxg9emqxR5ZyFFTQhyTkns=; b=ztKWY99lIx2Z02G7tiqjQFOhP2
        HLlM4ZIC05BSoFGjl/lr/rXZmUKTOF9+brILZX3BKE0rPcLijQQZL8ynE6vCdIg2iMLO0DyBt6Qww
        p+b3hB/qb/8W0YfrC1HBjzjfBGNpjEakY0TcRcWRGoIGfvAv3JGV7mxmx0Ch1AZBr/U+BYoWo4Zlh
        BPC9Jeci7ePlT09ztE0h0usD8xUjEg0c/Lqmm14RW33nz9aMbbKh44gSkBOSmaywqT9WMwToJ7ZX7
        vgU50R/LtZBDZz9KG3tyW7RCb7Eyb/IT4ayaJ68eOwR9hvuLRfTHvGk4cQCQ9Id1lafCXOExn5Obh
        nUhPaVyg==;
Received: from [2601:1c2:980:9ec0::2764]
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qDu5u-00B5ru-0A;
        Mon, 26 Jun 2023 21:49:58 +0000
Message-ID: <ec65c77a-3499-6278-f352-9bbe25a44b96@infradead.org>
Date:   Mon, 26 Jun 2023 14:49:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v2 2/6] KVM: Documentation: Update the field name gfns and
 its description in kvm_mmu_page
Content-Language: en-US
To:     Mingwei Zhang <mizhang@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kai Huang <kai.huang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Xu Yilun <yilun.xu@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
References: <20230626182016.4127366-1-mizhang@google.com>
 <20230626182016.4127366-3-mizhang@google.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20230626182016.4127366-3-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi--

On 6/26/23 11:20, Mingwei Zhang wrote:
> Update the field 'gfns' in kvm_mmu_page to 'shadowed_translation' to be
> consistent with the code. Also update the corresponding 'gfns' in the
> comments. The more detailed description of 'shadowed_translation' is
> already inlined in the data structure definition, so no need to duplicate
> the text but simply just update the names.
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> ---
>  Documentation/virt/kvm/x86/mmu.rst | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
> index 561efa8ec7d7..4c9044b4dc6c 100644
> --- a/Documentation/virt/kvm/x86/mmu.rst
> +++ b/Documentation/virt/kvm/x86/mmu.rst
> @@ -221,11 +221,12 @@ Shadow pages contain the following information:
>      at __pa(sp2->spt).  sp2 will point back at sp1 through parent_pte.
>      The spt array forms a DAG structure with the shadow page as a node, and
>      guest pages as leaves.
> -  gfns:
> -    An array of 512 guest frame numbers, one for each present pte.  Used to
> -    perform a reverse map from a pte to a gfn. When role.direct is set, any
> +  shadowed_translation:
> +    An array of 512 shadow translation entries, one for each present pte. Used
> +    to perform a reverse map from a pte to a gfn. When role.direct is set, any
>      element of this array can be calculated from the gfn field when used, in
> -    this case, the array of gfns is not allocated. See role.direct and gfn.
> +    this case, the array of shadowed_translation is not allocated. See

I cannot parse the before version nor the after version of this sentence (new version):

                                                  When role.direct is set, any
    element of this array can be calculated from the gfn field when used, in
    this case, the array of shadowed_translation is not allocated.


> +    role.direct and gfn.
>    root_count:
>      A counter keeping track of how many hardware registers (guest cr3 or
>      pdptrs) are now pointing at the page.  While this counter is nonzero, the

-- 
~Randy
