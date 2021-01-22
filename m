Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264252FFCFE
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 07:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbhAVGzq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 01:55:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:64491 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725771AbhAVGzq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 01:55:46 -0500
IronPort-SDR: sUCBlFN5stc87+sUnLMwcuoSDsOq4JaBPp/RfE4VVOJYJXWqVLifo6Kr3ae/+EP8cDJjnn6Rmq
 PH89frkblGxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9871"; a="166500354"
X-IronPort-AV: E=Sophos;i="5.79,366,1602572400"; 
   d="scan'208";a="166500354"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2021 22:55:03 -0800
IronPort-SDR: Xcyc0l4VcAZqiW2hm87qJ5sL/Nl02rhyMtci4uFnyAXemmwLOE+3xq/QfoAf2DPmtEKbhoj7/t
 nKFpPrfBQjZw==
X-IronPort-AV: E=Sophos;i="5.79,366,1602572400"; 
   d="scan'208";a="385640374"
Received: from yangzhon-virtual.bj.intel.com (HELO yangzhon-Virtual) ([10.238.144.101])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA256; 21 Jan 2021 22:54:51 -0800
Date:   Fri, 22 Jan 2021 14:43:27 +0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        tony.luck@intel.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kyung.min.park@intel.com, yang.zhong@intel.com
Subject: Re: [PATCH 0/2] Enumerate and expose AVX_VNNI feature
Message-ID: <20210122064327.GA25155@yangzhon-Virtual>
References: <20210105004909.42000-1-yang.zhong@intel.com>
 <eee07399-df81-83ed-d410-18b42d51e26c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eee07399-df81-83ed-d410-18b42d51e26c@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 21, 2021 at 04:02:17PM +0100, Paolo Bonzini wrote:
> On 05/01/21 01:49, Yang Zhong wrote:
> >A processor supports AVX_VNNI instructions if CPUID.(EAX=7,ECX=1):EAX[bit 4]
> >is present.
> >
> >This series includes kernel and kvm patches, kernel patch define this
> >new cpu feature bit and kvm expose this bit to guest. When this bit is
> >enabled on cpu or vcpu, the cpu feature flag is shown as "avx_vnni" in
> >/proc/cpuinfo of host and guest.
> >
> >Detailed information on the instruction and CPUID feature flag can be
> >found in the latest "extensions" manual [1].
> >
> >Reference:
> >[1]. https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html
> >
> >
> >Kyung Min Park (1):
> >   Enumerate AVX Vector Neural Network instructions
> >
> >Yang Zhong (1):
> >   KVM: Expose AVX_VNNI instruction to guset
> >
> >  arch/x86/include/asm/cpufeatures.h | 1 +
> >  arch/x86/kvm/cpuid.c               | 2 +-
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> >
> 
> Queued, thanks.
> 
> Paolo

  Paolo, thanks, i will send the related Qemu patch soon.

  Yang
