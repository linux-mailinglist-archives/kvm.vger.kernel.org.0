Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCCC1AC867
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 17:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502986AbgDPPH4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 11:07:56 -0400
Received: from mga07.intel.com ([134.134.136.100]:63742 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441872AbgDPPHw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 11:07:52 -0400
IronPort-SDR: CRhiPWPlSDDWiEGWg66HjxGlQNN/Ma26T12do60+1eiLeXlQVDjQxMtUcIMw3AiSKtZ9Z3SkXi
 8EtfiGGhvjAA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 08:07:50 -0700
IronPort-SDR: o5iUjlKVYAkiSQVPwxHxIkIYdjmBCXuTBBpdTwXmAecBBvW1C+zOu8iK1KaQu3UOTksj0n79i9
 Gz3Rqojkq5Bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,391,1580803200"; 
   d="scan'208";a="278018877"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 16 Apr 2020 08:07:49 -0700
Date:   Thu, 16 Apr 2020 08:07:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v2 00/10] KVM: VMX: Unionize vcpu_vmx.exit_reason
Message-ID: <20200416150749.GA12170@linux.intel.com>
References: <20200415175519.14230-1-sean.j.christopherson@intel.com>
 <a77ca940-afe4-a94a-2698-6cda0f95ba5c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a77ca940-afe4-a94a-2698-6cda0f95ba5c@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 16, 2020 at 03:44:06PM +0200, Paolo Bonzini wrote:
> On 15/04/20 19:55, Sean Christopherson wrote:
> For now I committed only patches 1-9, just to limit the conflicts with
> the other series.  I would like to understand how you think the
> conflicts should be fixed with the union.

Pushed a branch.  Basically, take the union code and then make sure there
aren't any vmcs_read32(VM_EXIT_INTR_INFO) or vmcs_readl(EXIT_QUALIFICATION)
calls outside of the caching accessors or dump_vmcs().

  https://github.com/sean-jc/linux for_paolo_merge_union_cache 
