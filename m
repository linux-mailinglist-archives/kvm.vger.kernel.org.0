Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237DC3577E5
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 00:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhDGWoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 18:44:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:54289 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhDGWo3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 18:44:29 -0400
IronPort-SDR: RdDDrUc3NVaQzzand2+Dmrlm0xk++cKV05nAfKxKeOy8mEIsQ1LixF6EAC7jjPpqBmy9gXPxoZ
 hClXri22hUkQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9947"; a="213810714"
X-IronPort-AV: E=Sophos;i="5.82,204,1613462400"; 
   d="scan'208";a="213810714"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 15:44:19 -0700
IronPort-SDR: o/HA7QaNy0S9YnUOxIdHHJ51jKs6oUG02IMh2U1axoSxnuNSchd7Qt6tov6LPOhExrxBmE3wOY
 NtJydVSHQm9w==
X-IronPort-AV: E=Sophos;i="5.82,204,1613462400"; 
   d="scan'208";a="441496506"
Received: from tkokeray-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.113.100])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 15:44:16 -0700
Date:   Thu, 8 Apr 2021 10:44:14 +1200
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org,
        pbonzini@redhat.com, bp@alien8.de, jarkko@kernel.org,
        dave.hansen@intel.com, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com
Subject: Re: [PATCH v4 06/11] KVM: VMX: Frame in ENCLS handler for SGX
 virtualization
Message-Id: <20210408104414.29e93147fdd93305846a6ee6@intel.com>
In-Reply-To: <YG4ztLkCZbJ2ffE+@google.com>
References: <cover.1617825858.git.kai.huang@intel.com>
        <4be4b49f63a6c66911683d0f093ca5ef0d3996d5.1617825858.git.kai.huang@intel.com>
        <YG4vWwwhr01vZGp6@google.com>
        <20210408103349.c98c3adc94efa66ca048ce2c@intel.com>
        <YG4ztLkCZbJ2ffE+@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 7 Apr 2021 22:35:32 +0000 Sean Christopherson wrote:
> On Thu, Apr 08, 2021, Kai Huang wrote:
> > On Wed, 7 Apr 2021 22:16:59 +0000 Sean Christopherson wrote:
> > > On Thu, Apr 08, 2021, Kai Huang wrote:
> > > > +int handle_encls(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +	u32 leaf = (u32)vcpu->arch.regs[VCPU_REGS_RAX];
> > > 
> > > Please use kvm_rax_read(), I've been trying to discourage direct access to the
> > > array.  Which is ironic because I'm 100% certain I'm to blame for this. :-)
> > 
> > Sure. But I think still, we should convert it to (u32) explicitly, so:
> > 
> > 	u32 leaf = (u32)kvm_rax_read(vcpu); 
> > 
> > ?
> 
> Ya, agreed, it helps document that it's deliberate.

Do you have any other comments regarding to other patches? If no I can send
another version rather quickly :)
