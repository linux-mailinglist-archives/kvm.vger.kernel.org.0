Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D073B4080
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 11:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbhFYJba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 05:31:30 -0400
Received: from mga18.intel.com ([134.134.136.126]:45141 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230217AbhFYJb3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 05:31:29 -0400
IronPort-SDR: dleT7UTL/dM7xS07NuxzoiRt2oHlrE9bYL3svqXyE8xdDrTxtj4F0f0J2tvXukUK62z9cAiMPa
 jNtI/t4t3gtQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10025"; a="194934721"
X-IronPort-AV: E=Sophos;i="5.83,298,1616482800"; 
   d="scan'208";a="194934721"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 02:29:08 -0700
IronPort-SDR: kUTDCduX01Qi/Pr7H1QfMHw8nhF3ptuEP/84jT1JJGZHNzgDfKJ09QrWcrh3dX7gW3kdWHQjyy
 j4g9oyjw/VAQ==
X-IronPort-AV: E=Sophos;i="5.83,298,1616482800"; 
   d="scan'208";a="453751946"
Received: from junyuton-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.170.209])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 02:29:05 -0700
Date:   Fri, 25 Jun 2021 17:29:02 +0800
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
Message-ID: <20210625092902.o4kqx67zvvbudggh@linux.intel.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-6-seanjc@google.com>
 <20210625084644.ort4oojvd27oy4ca@linux.intel.com>
 <09a49caf-6ff5-295b-d1ab-023549f6a23b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09a49caf-6ff5-295b-d1ab-023549f6a23b@redhat.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 25, 2021 at 10:57:51AM +0200, Paolo Bonzini wrote:
> On 25/06/21 10:47, Yu Zhang wrote:
> > > But if L1 is crafty, it can load a new CR4 on VM-Exit and toggle LA57
> > > without having to bounce through an unpaged section.  L1 can also load a
> > 
> > May I ask how this is done by the guest? Thanks!
> 
> It can set HOST_CR3 and HOST_CR4 to a value that is different from the one
> on vmentry.

Thanks, Paolo.

Do you mean the L1 can modify its paging mode by setting HOST_CR3 as root of
a PML5 table in VMCS12 and HOST_CR4 with LA57 flipped in VMCS12, causing the
GUEST_CR3/4 being changed in VMCS01, and eventually updating the CR3/4 when 
L0 is injecting a VM Exit from L2? 

B.R.
Yu

  

> Paolo
> 
