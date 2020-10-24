Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D921297A71
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 05:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759231AbgJXDEW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 23:04:22 -0400
Received: from mga07.intel.com ([134.134.136.100]:1484 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758898AbgJXDEV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Oct 2020 23:04:21 -0400
IronPort-SDR: mjzjCyImNFPXgZPD0tRK1ybm8c+o+bb/Drtv+nwG0qVoveKXTv1YGNuRBRflOFnpc0Y55xXSLb
 YM5QyNfzBYYg==
X-IronPort-AV: E=McAfee;i="6000,8403,9783"; a="231944614"
X-IronPort-AV: E=Sophos;i="5.77,410,1596524400"; 
   d="scan'208";a="231944614"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2020 20:04:14 -0700
IronPort-SDR: EvdwySmndLBMUr2IFj/6/RUEAVwvgUsKNWWwvQOGYP55ZOI2bPkNLLBrMv4AVEy1rbeWfp1xXm
 LGcuP5Pp4tGw==
X-IronPort-AV: E=Sophos;i="5.77,410,1596524400"; 
   d="scan'208";a="317274009"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2020 20:04:12 -0700
Date:   Fri, 23 Oct 2020 20:04:09 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        kvm list <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: kvm: x86-32 fails to link with tdp_mmu
Message-ID: <20201024030409.GD7824@linux.intel.com>
References: <CAEUSe7_bptXLQQt5TkUoVitnFbnAF-KkyqQpcZnYuKgSGuBpPw@mail.gmail.com>
 <20201024021754.GC7824@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201024021754.GC7824@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 23, 2020 at 07:17:54PM -0700, Sean Christopherson wrote:
> On Fri, Oct 23, 2020 at 09:13:21PM -0500, Daniel Díaz wrote:
> > Hello!
> > 
> > We found the following problem building torvalds/master, which
> > recently merged the for-linus tag from the KVM tree, when building
> > with gcc 7.3.0 and glibc 2.27 for x86 32-bits under OpenEmbedded:
> > 
> > |   LD      vmlinux.o
> > |   MODPOST vmlinux.symvers
> > |   MODINFO modules.builtin.modinfo
> > |   GEN     modules.builtin
> > |   LD      .tmp_vmlinux.kallsyms1
> > | arch/x86/kvm/mmu/tdp_mmu.o: In function `__handle_changed_spte':
> > | tdp_mmu.c:(.text+0x78a): undefined reference to `__umoddi3'
> 
> The problem is a % on a 64-bit value.  Patches incoming, there's also a goof
> in similar code that was tweaked last minute to avoid the %.

Just the one patch actually, I misread some cleverness.  Patch still inbound...
