Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE743924AE
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 04:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233918AbhE0CEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 22:04:43 -0400
Received: from mga04.intel.com ([192.55.52.120]:51611 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232996AbhE0CEm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 22:04:42 -0400
IronPort-SDR: tCDnziiMs5ULJ7p+4nZqZw9MU8AQqrP6MZzq4qSyq83AnQu3RIYiXi16mjT/szwIliuUUZTb25
 8Y1zs7jBxWSg==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="200733927"
X-IronPort-AV: E=Sophos;i="5.82,333,1613462400"; 
   d="scan'208";a="200733927"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 19:03:07 -0700
IronPort-SDR: CHBMu/Mh5QhFnpsCgGrrrAYF3pZexFfHcUY8j7GhESRlKlCyhoOmde+Wzry48wUAasW6awvOn3
 HLzm2Jq7Ykzw==
X-IronPort-AV: E=Sophos;i="5.82,333,1613462400"; 
   d="scan'208";a="414702431"
Received: from jjlarkix-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.182.5])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 19:03:05 -0700
Message-ID: <4f04a166603ee790d918d82ea101f03f17be3b2d.camel@intel.com>
Subject: Re: [PATCH v2 0/3] TDP MMU: several minor fixes or improvements
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Date:   Thu, 27 May 2021 14:03:02 +1200
In-Reply-To: <cover.1620343751.git.kai.huang@intel.com>
References: <cover.1620343751.git.kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-05-07 at 11:33 +1200, Kai Huang wrote:
> v1:
> 
> https://lore.kernel.org/kvm/cover.1620200410.git.kai.huang@intel.com/T/#mcc2e6ea6d9e3caec2bcc9e5f99cbbe2a8dd24145
> 
> v1 -> v2:
>  - Update patch 2, using Sean's suggestion.
>  - Update patch 3, based on Ben's review.
> 
> Kai Huang (3):
>   KVM: x86/mmu: Fix return value in tdp_mmu_map_handle_target_level()
>   KVM: x86/mmu: Fix pf_fixed count in tdp_mmu_map_handle_target_level()
>   KVM: x86/mmu: Fix TDP MMU page table level
> 
>  arch/x86/kvm/mmu/tdp_mmu.c | 16 ++++++++++------
>  arch/x86/kvm/mmu/tdp_mmu.h |  2 +-
>  2 files changed, 11 insertions(+), 7 deletions(-)
> 

Hi Paolo,

Kindly ping.

