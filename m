Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD74660F12
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 14:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbjAGNad (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Jan 2023 08:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjAGNaa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Jan 2023 08:30:30 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A488659F86
        for <kvm@vger.kernel.org>; Sat,  7 Jan 2023 05:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673098229; x=1704634229;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g4ufV2D+znu2h7mnsLI3A4qbyLheLQmYIy4UWAvfkmM=;
  b=Rb8S2SqOlGRpS99XrRtlmUZivHWuNbRuuYmbJLCWo2EZsXCZDnr1c5Ws
   DroD/Tsu3K6Gl2ruopX07Mrq0n8vbxl0shBcZEwmD38qgRARJZSk9w9ND
   6ZILPYYXiOM/P7aLxkSj48izs/6uwNLmtCFRJ3olSjjt95DuZIV0Tv0i0
   kCxbNfRparkpRKA5Gn9DyQCRnASSgvf8RZq0m6uPmL9Z9HI8s90RgAE1B
   9xJHpX+l4Yh7DBAOR/bSrJLoGrb7O7sm5LEMoezn+zMuPQ75jMDDyLZvg
   bkID/8FDvK9jNWatNo+X+2S4C3g2QxOjt+DMKEaMKfdjLlQv0pYVy37sT
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="384938309"
X-IronPort-AV: E=Sophos;i="5.96,308,1665471600"; 
   d="scan'208";a="384938309"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2023 05:30:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="633749321"
X-IronPort-AV: E=Sophos;i="5.96,308,1665471600"; 
   d="scan'208";a="633749321"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga006.jf.intel.com with ESMTP; 07 Jan 2023 05:30:27 -0800
Message-ID: <cbb6c40c1fca5e389c5c3e194c424c28358c0c8e.camel@linux.intel.com>
Subject: Re: [PATCH v3 1/9] KVM: x86: Rename cr4_reserved/rsvd_* variables
 to be more readable
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Binbin Wu <binbin.wu@linux.intel.com>, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Date:   Sat, 07 Jan 2023 21:30:26 +0800
In-Reply-To: <Y7i+OW+8p7Ehlh3C@google.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
         <20221209044557.1496580-2-robert.hu@linux.intel.com>
         <2e395a24-ee7b-e31e-981c-b83e80ac5be1@linux.intel.com>
         <b8f8f8acb6348ad5789fc1df6a6c18b0fa5f91ee.camel@linux.intel.com>
         <Y7i+OW+8p7Ehlh3C@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2023-01-07 at 00:35 +0000, Sean Christopherson wrote:
> On Thu, Dec 29, 2022, Robert Hoo wrote:
> > On Wed, 2022-12-28 at 11:37 +0800, Binbin Wu wrote:
> > > On 12/9/2022 12:45 PM, Robert Hoo wrote:
> > > > kvm_vcpu_arch::cr4_guest_owned_bits and
> > > > kvm_vcpu_arch::cr4_guest_rsvd_bits
> > > > looks confusing. Rename latter to cr4_host_rsvd_bits, because
> > > > it in
> > > > fact decribes the effective host reserved cr4 bits from the
> > > > vcpu's
> > > > perspective.
> > > 
> > > IMO, the current name cr4_guest_rsvd_bits is OK becuase it shows
> > > that these
> > > bits are reserved bits from the pointview of guest.
> > 
> > Actually, it's cr4_guest_owned_bits that from the perspective of
> > guest.
> 
> No, cr4_guest_owned_bits is KVM's view of things.  

That's all right. Perhaps my expression wasn't very accurate. Perhaps I
would have said "cr4_guest_owned_bits stands on guest's points, as it
reads, guest owns these (set) bits". Whereas, "cr4_guest_rsvd_bits"
doesn't literally as the word reads, its set bits doesn't mean "guest
reserved these bits" but the opposite, those set bits are reserved by
host:

set_cr4_guest_host_mask()
{
...
vcpu->arch.cr4_guest_owned_bits = KVM_POSSIBLE_CR4_GUEST_BITS &
				~vcpu->arch.cr4_guest_rsvd_bits;
// cr4_guest_owned_bit = (~host owned bits) &
KVM_POSSIBLE_CR4_GUEST_BITS (the filter)
// cr4_guest_owned_bit and cr4_guest_rsvd_bits are generally opposite
relationship
...

vmcs_writel(CR4_GUEST_HOST_MASK, ~vcpu->arch.cr4_guest_owned_bits);
//the opposite of guest owned bits are effectively written to
CR4_GUEST_HOST_MASK
}

These code are the implementation of SDM 25.6.6 "Guest/Host Masks and
Read Shadows for CR0 and CR4"
"In general, bits set to 1 in a guest/host mask correspond to bits
owned by the host."

> It tracks which bits have
> effectively been passed through to the guest and so need to be read
> out of the
> VMCS after running the vCPU.

Yes, as above, ~cr4_guest_owned_bits is effective final guest/host CR4
mask that's written to VMCS.CR4_GUEST_HOST_MASK.
> 
> > cr4_guest_owned_bits and cr4_guest_rsvd_bits together looks quite
> > confusing.
> 
> I disagree, KVM (and the SDM and the APM) uses "reserved" or "rsvd"
> all over the
> place to indicate reserved bits/values/fields.

I wouldn't object the word "reserved". I was objecting that
"cr4_guest_rsvd_bits" contains guest reserved; it actually contains
"host reserved". ;)
> 
> > > > * cr4_reserved_bits --> cr4_kvm_reserved_bits, which describes
> 
> Hard no.  They aren't just KVM reserved, many of those bits are
> reserved by
> hardware, which is 100% dependent on the host.

That's right. KVM stands on top of HW, then Host, doesn't it? ;)
My interpretation is that, also the theme of this patch, those
xxx_cr4_reserved consts/variables are actually layered relationships.
> 
> > > > CR4_HOST_RESERVED_BITS + !kvm_cap_has() = kvm level cr4
> > > > reserved
> > > > bits.
> > > > 
> > > > * __cr4_reserved_bits() --> __cr4_calc_reserved_bits(), which
> > > > to
> > > > calc
> > > > effective cr4 reserved bits for kvm or vm level, by
> > > > corresponding
> > > > x_cpu_has() input.
> > > > 
> > > > Thus, by these renames, the hierarchical relations of those
> > > > reserved CR4
> > > > bits is more clear.
> 
> Sorry, but I don't like any of the changes in this patch.  At best,
> some of the
> changes are a wash (neither better nor worse), and in that case the
> churn, however
> minor isn't worth it.

That's all right. Regretful I cannot convince you. This patch just
demonstrates my interpretation when I come confused by the code, then
dig into and SDM reading. Anyway it's not LAM necessity, I'll abandon
this patch in next version.

