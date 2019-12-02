Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 448A910F004
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 20:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbfLBTcX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 14:32:23 -0500
Received: from mga06.intel.com ([134.134.136.31]:61123 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728039AbfLBTcX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 14:32:23 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Dec 2019 11:32:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,270,1571727600"; 
   d="scan'208";a="204687691"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 02 Dec 2019 11:32:22 -0800
Date:   Mon, 2 Dec 2019 11:32:22 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 02/15] KVM: Add kvm/vcpu argument to
 mark_dirty_page_in_slot
Message-ID: <20191202193222.GI4063@linux.intel.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-3-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191129213505.18472-3-peterx@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 29, 2019 at 04:34:52PM -0500, Peter Xu wrote:

Why?

> From: "Cao, Lei" <Lei.Cao@stratus.com>
> 
> Signed-off-by: Cao, Lei <Lei.Cao@stratus.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index fac0760c870e..8f8940cc4b84 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -145,7 +145,10 @@ static void hardware_disable_all(void);
>  
>  static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
>  
> -static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t gfn);
> +static void mark_page_dirty_in_slot(struct kvm *kvm,
> +				    struct kvm_vcpu *vcpu,
> +				    struct kvm_memory_slot *memslot,
> +				    gfn_t gfn);

Why both?  Passing @vcpu gets you @kvm.
