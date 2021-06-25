Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7613B4271
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 13:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbhFYLZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 07:25:42 -0400
Received: from mga04.intel.com ([192.55.52.120]:1752 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229470AbhFYLZl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 07:25:41 -0400
IronPort-SDR: x8tVQ55SwbdSwPl2aCpLthoXwOyvWQBnMaRy/MxE1B/owIon5sG7+/q8DqRw/8WmC2WCubB01P
 Vrv33MWlcPjg==
X-IronPort-AV: E=McAfee;i="6200,9189,10025"; a="205825523"
X-IronPort-AV: E=Sophos;i="5.83,298,1616482800"; 
   d="scan'208";a="205825523"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 04:23:20 -0700
IronPort-SDR: dPfPo6GYQkxkecwpT1I+fRhs3VVyqD6TTNKZhpm7JmpiNcbRKTHdcA17ZQlfbFeDG0qprXoj3Y
 793jmGben/Gg==
X-IronPort-AV: E=Sophos;i="5.83,298,1616482800"; 
   d="scan'208";a="453786104"
Received: from junyuton-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.170.209])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 04:23:17 -0700
Date:   Fri, 25 Jun 2021 19:23:14 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 05/54] Revert "KVM: x86/mmu: Drop
 kvm_mmu_extended_role.cr4_la57 hack"
Message-ID: <20210625112314.nn6llnk7dtovjg4e@linux.intel.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-6-seanjc@google.com>
 <20210625084644.ort4oojvd27oy4ca@linux.intel.com>
 <09a49caf-6ff5-295b-d1ab-023549f6a23b@redhat.com>
 <20210625092902.o4kqx67zvvbudggh@linux.intel.com>
 <885018ab-206b-35c7-a75a-e4fccb663fc3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <885018ab-206b-35c7-a75a-e4fccb663fc3@redhat.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 25, 2021 at 12:25:46PM +0200, Paolo Bonzini wrote:
> On 25/06/21 11:29, Yu Zhang wrote:
> > Thanks, Paolo.
> > 
> > Do you mean the L1 can modify its paging mode by setting HOST_CR3 as root of
> > a PML5 table in VMCS12 and HOST_CR4 with LA57 flipped in VMCS12, causing the
> > GUEST_CR3/4 being changed in VMCS01, and eventually updating the CR3/4 when
> > L0 is injecting a VM Exit from L2?
> 
> Yes, you can even do that without a "full" vmentry by setting invalid guest
> state in vmcs12. :)

Hah.. Interesting. :) I think this is what load_vmcs12_host_state() does. Anyway,
thanks a lot for the explanation!

Also my reviewed-by for this one.

Rviewed-by: Yu Zhang <yu.c.zhang@linux.intel.com>

B.R.
Yu
 
