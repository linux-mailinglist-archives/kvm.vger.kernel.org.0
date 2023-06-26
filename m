Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3C673ED04
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 23:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjFZVoz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 17:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjFZVoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 17:44:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FAEE6F;
        Mon, 26 Jun 2023 14:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=EdgK0IHrzHwFNhFM3Sp8S6TGye1AJP5vyX4MGNNLE8c=; b=vnYPiZvsf3gk3whl4Re7bpeeIs
        jpvevsVauYb3VlJxp9V4mE/NVKN57XH9jjzcYBkndLmQxeFzogqHcP3BZlN2BJsHekICQdg78vmfE
        wqUSbheArEfSqVUUpR6M+FfegOjI/jIantl2IpIFec1f20/luP4UNAOEVFNNdMOGJULNt7HrdfHJh
        sQdZz7hRnwaVkLdzSdFwajRBKerXhGiKCEIcKGV5Y1DOFiB3i7opU3GVc/HPC1mvhwqYusJLJNuTl
        ebhnq3XIO+Gz3+eCL3P0f2xnYo31RYVQpN1okrb7l4a9cWiRt9zGn30AkrvcstTvkL9xpBGdayinu
        jqyeB4pw==;
Received: from [2601:1c2:980:9ec0::2764]
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qDu0y-00B5Z2-0f;
        Mon, 26 Jun 2023 21:44:52 +0000
Message-ID: <a816c65d-1db2-9043-9e4c-bb0d3f318044@infradead.org>
Date:   Mon, 26 Jun 2023 14:44:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v2 3/6] KVM: Documentation: Add the missing description
 for ptep in kvm_mmu_page
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
 <20230626182016.4127366-4-mizhang@google.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20230626182016.4127366-4-mizhang@google.com>
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



On 6/26/23 11:20, Mingwei Zhang wrote:
> Add the missing description for ptep in kvm_mmu_page description. ptep is
> used when TDP MMU is enabled and it shares the storage with parent_ptes.
> Update the doc to help readers to get up-to-date info.
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  Documentation/virt/kvm/x86/mmu.rst | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
> index 4c9044b4dc6c..5cd6cd5e8926 100644
> --- a/Documentation/virt/kvm/x86/mmu.rst
> +++ b/Documentation/virt/kvm/x86/mmu.rst
> @@ -237,6 +237,11 @@ Shadow pages contain the following information:
>      parent_ptes points at this single spte, otherwise, there exists multiple
>      sptes pointing at this page and (parent_ptes & ~0x1) points at a data
>      structure with a list of parent sptes.
> +  ptep:
> +    The reverse mapping for the pte pointing at this page's spt. This field is
> +    used in replace of parent_ptes when TDP MMU is used. In TDP MMU, each

            in replacement of

> +    non-root shadow page will have one parent, while each root shadow page has
> +    no parent. Note that this field is a union with parent_ptes.
>    unsync:
>      If true, then the translations in this page may not match the guest's
>      translation.  This is equivalent to the state of the tlb when a pte is

-- 
~Randy
