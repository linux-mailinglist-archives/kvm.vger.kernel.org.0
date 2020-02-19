Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23AA616484E
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 16:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgBSPSQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 10:18:16 -0500
Received: from mga04.intel.com ([192.55.52.120]:22682 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726691AbgBSPSP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 10:18:15 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 07:18:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,459,1574150400"; 
   d="scan'208";a="235919620"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 19 Feb 2020 07:18:14 -0800
Date:   Wed, 19 Feb 2020 07:18:14 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Peter Xu <peterx@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>
Subject: Re: [PATCH v6 21/22] KVM: x86/mmu: Use ranged-based TLB flush for
 dirty log memslot flush
Message-ID: <20200219151814.GC15888@linux.intel.com>
References: <20200218210736.16432-1-sean.j.christopherson@intel.com>
 <20200218210736.16432-22-sean.j.christopherson@intel.com>
 <fdb72ab9-18d4-5719-2863-78cde4e97fae@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdb72ab9-18d4-5719-2863-78cde4e97fae@cogentembedded.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 19, 2020 at 12:22:58PM +0300, Sergei Shtylyov wrote:
> Hello!
> 
> On 19.02.2020 0:07, Sean Christopherson wrote:
> 
> >Use the with_address() variant to when performing a TLB flush for a
>                                  ^^ is it really needed here?

Doh, thanks.  The subject also has a typo, it should be "range-based", not
"ranged-based".

> >specific memslot via kvm_arch_flush_remote_tlbs_memslot(), i.e. when
> >flushing after clearing dirty bits during KVM_{GET,CLEAR}_DIRTY_LOG.
> >This aligns all dirty log memslot-specific TLB flushes to use the
> >with_address() variant and paves the way for consolidating the relevant
> >code.
> >
> >Note, moving to the with_address() variant only affects functionality
> >when running as a HyperV guest.
> >
> >Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> >Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> [...]
> 
> MBR, Sergei
