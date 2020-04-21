Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1D11B2127
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 10:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgDUILx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 04:11:53 -0400
Received: from mga04.intel.com ([192.55.52.120]:43881 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbgDUILw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 04:11:52 -0400
IronPort-SDR: WO4rKBY3M6PZUmzFDM9MMJjl2sm1R+ts5CGrkzXHY96+zWBsHsWIR24VImCy8YkMJ3TVHNHx4h
 TpSS422mCqsQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 01:11:52 -0700
IronPort-SDR: ixj8cJC6iVxpphbvx58ZvD8piP3yswAmL2PZ1MnJhmBv0/+E5BR36AM0FW2MydEmmDTsVSOPiL
 6kaKKZESdsBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,409,1580803200"; 
   d="scan'208";a="456017509"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 21 Apr 2020 01:11:52 -0700
Date:   Tue, 21 Apr 2020 01:11:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v2 00/10] KVM: VMX: Unionize vcpu_vmx.exit_reason
Message-ID: <20200421081151.GG11134@linux.intel.com>
References: <20200415175519.14230-1-sean.j.christopherson@intel.com>
 <a77ca940-afe4-a94a-2698-6cda0f95ba5c@redhat.com>
 <20200416150749.GA12170@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416150749.GA12170@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 16, 2020 at 08:07:49AM -0700, Sean Christopherson wrote:
> On Thu, Apr 16, 2020 at 03:44:06PM +0200, Paolo Bonzini wrote:
> > On 15/04/20 19:55, Sean Christopherson wrote:
> > For now I committed only patches 1-9, just to limit the conflicts with
> > the other series.  I would like to understand how you think the
> > conflicts should be fixed with the union.
> 
> Pushed a branch.  Basically, take the union code and then make sure there
> aren't any vmcs_read32(VM_EXIT_INTR_INFO) or vmcs_readl(EXIT_QUALIFICATION)
> calls outside of the caching accessors or dump_vmcs().
> 
>   https://github.com/sean-jc/linux for_paolo_merge_union_cache 

Sent v3, seemed easier than having you decipher my merge resolution and
then fix more conflicts with kvm/queue.
