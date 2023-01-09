Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D34D661C8B
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 04:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234072AbjAIDHV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 22:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbjAIDHT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 22:07:19 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9682BBC92
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 19:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673233638; x=1704769638;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=725ppb+hOerQAd/SgcDx1p7os8o/zUZvCo+mDubfL6E=;
  b=BV0OTu0F3ARi3rzSodkNzdGCEsathz++W4pRyfHH8tVgckR/qpypmwB9
   pPBNXWVfcHRVcGzitGfNxGPQfZQt9botKb6KPgub8Y9TjtOoEqkx1HyrA
   F76trXtQvaI2Epi3FdLWNEDRFEAbIRvUdeYojWRE6jU4cctDUpOtL/U75
   IECimxlxzCec155as5/+xWVOsbAlyeJ7AV85eRtKQbrrOWTpvK9ifGMB4
   OWKH6GQ9zypmTgs54zdBj2RtIAJnLFpfBiUzPgeedNDfDQ23GQfL2N8Ls
   qWq1nqsUxo42fgL763v8xvn1tHRAgXQyITfpZE1cCKOTv2feNXB37zaOw
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="306303853"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="306303853"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2023 19:07:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="634061220"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="634061220"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga006.jf.intel.com with ESMTP; 08 Jan 2023 19:07:16 -0800
Message-ID: <a9a34895da969d68d5e9f0395c029fac578e8644.camel@linux.intel.com>
Subject: Re: [PATCH v3 1/9] KVM: x86: Rename cr4_reserved/rsvd_* variables
 to be more readable
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Binbin Wu <binbin.wu@linux.intel.com>, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Date:   Mon, 09 Jan 2023 11:07:15 +0800
In-Reply-To: <a858b6c8-e23f-9867-c30f-fbdd2f468798@intel.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
         <20221209044557.1496580-2-robert.hu@linux.intel.com>
         <2e395a24-ee7b-e31e-981c-b83e80ac5be1@linux.intel.com>
         <b8f8f8acb6348ad5789fc1df6a6c18b0fa5f91ee.camel@linux.intel.com>
         <Y7i+OW+8p7Ehlh3C@google.com>
         <cbb6c40c1fca5e389c5c3e194c424c28358c0c8e.camel@linux.intel.com>
         <a858b6c8-e23f-9867-c30f-fbdd2f468798@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2023-01-08 at 22:18 +0800, Xiaoyao Li wrote:
> On 1/7/2023 9:30 PM, Robert Hoo wrote:
> > On Sat, 2023-01-07 at 00:35 +0000, Sean Christopherson wrote:
> > > On Thu, Dec 29, 2022, Robert Hoo wrote:
> > > > On Wed, 2022-12-28 at 11:37 +0800, Binbin Wu wrote:
> > > > > On 12/9/2022 12:45 PM, Robert Hoo wrote:
> > > > > > kvm_vcpu_arch::cr4_guest_owned_bits and
> > > > > > kvm_vcpu_arch::cr4_guest_rsvd_bits
> > > > > > looks confusing. Rename latter to cr4_host_rsvd_bits,
> > > > > > because
> > > > > > it in
> > > > > > fact decribes the effective host reserved cr4 bits from the
> > > > > > vcpu's
> > > > > > perspective.
> > > > > 
> > > > > IMO, the current name cr4_guest_rsvd_bits is OK becuase it
> > > > > shows
> > > > > that these
> > > > > bits are reserved bits from the pointview of guest.
> > > > 
> > > > Actually, it's cr4_guest_owned_bits that from the perspective
> > > > of
> > > > guest.
> > > 
> > > No, cr4_guest_owned_bits is KVM's view of things.
> > 
> > That's all right. Perhaps my expression wasn't very accurate.
> > Perhaps I
> > would have said "cr4_guest_owned_bits stands on guest's points, as
> > it
> > reads, guest owns these (set) bits". Whereas, "cr4_guest_rsvd_bits"
> > doesn't literally as the word reads, its set bits doesn't mean
> > "guest
> > reserved these bits" but the opposite, those set bits are reserved
> > by
> > host:
> > 
> 
> I think you can interpret guest_rsvd_bits as bits reserved *for*
> guest 
> stead of *by* guest
> 
I think you mean reserved-by guest. OK, buy in, as well as Binbin's
interpretation. 



