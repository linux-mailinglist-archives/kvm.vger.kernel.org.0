Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6DBF277430
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 16:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgIXOj0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 10:39:26 -0400
Received: from mga07.intel.com ([134.134.136.100]:52514 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbgIXOj0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 10:39:26 -0400
IronPort-SDR: lYxwhl60KN6YQKEWJLRVb4subtGPKhodt6KGimpn+y0dX4ffBEBxA893xy6y55t3TniFGn9fJI
 uJggyDxNaLZw==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="225363025"
X-IronPort-AV: E=Sophos;i="5.77,298,1596524400"; 
   d="scan'208";a="225363025"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 07:39:25 -0700
IronPort-SDR: aw/mqSt0VD6UBmHQwsU0wYx6f6DwfujzsoTj23//ldTuw5Nx0Xxgh9c4y3m5b78/1u0mHirB4M
 Sm0/LN52yJcQ==
X-IronPort-AV: E=Sophos;i="5.77,298,1596524400"; 
   d="scan'208";a="486924110"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 07:39:25 -0700
Date:   Thu, 24 Sep 2020 07:39:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Stash 'kvm' in a local variable in
 kvm_mmu_free_roots()
Message-ID: <20200924143922.GA22539@linux.intel.com>
References: <20200923191204.8410-1-sean.j.christopherson@intel.com>
 <875z83e47o.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875z83e47o.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 24, 2020 at 02:42:19PM +0200, Vitaly Kuznetsov wrote:
> What about kvm_mmu_get_page(), make_mmu_pages_available(),
> mmu_alloc_root(), kvm_mmu_sync_roots(), direct_page_fault(),
> kvm_mmu_pte_write() which seem to be using the same ugly pattern? :-)

Heh, good question.  I guess only kvm_mmu_free_roots() managed to cross over
the threshold from "that's ugly" to "this is ridiculous".
