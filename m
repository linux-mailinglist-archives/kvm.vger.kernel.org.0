Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A091AE3C35
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 21:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406901AbfJXTmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 15:42:16 -0400
Received: from mga06.intel.com ([134.134.136.31]:19209 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406601AbfJXTmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 15:42:16 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 12:42:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,225,1569308400"; 
   d="scan'208";a="399877874"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 24 Oct 2019 12:42:15 -0700
Date:   Thu, 24 Oct 2019 12:42:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 14/15] KVM: Terminate memslot walks via used_slots
Message-ID: <20191024194214.GB28043@linux.intel.com>
References: <20191022003537.13013-1-sean.j.christopherson@intel.com>
 <20191022003537.13013-15-sean.j.christopherson@intel.com>
 <642f73ee-9425-0149-f4f4-f56be9ae5713@redhat.com>
 <20191022152827.GC2343@linux.intel.com>
 <625e511f-bd35-3b92-0c6d-550c10fc5827@redhat.com>
 <20191022155220.GD2343@linux.intel.com>
 <5c61c094-ee32-4dcf-b3ae-092eba0159c5@redhat.com>
 <20191024193856.GA28043@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024193856.GA28043@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 24, 2019 at 12:38:56PM -0700, Sean Christopherson wrote:
> On Tue, Oct 22, 2019 at 05:53:27PM +0200, Paolo Bonzini wrote:
> > On 22/10/19 17:52, Sean Christopherson wrote:
> > > 
> > > Anyways, I'm not at all opposed to adding comments, just want to make sure
> > > I'm not forgetting something.  If it's ok with you, I'll comment the code
> > > and/or functions and reply here to refine them without having to respin
> > > the whole series.
> > 
> > Yes, I agree this is better.
> 
> Here's what I ended up with.  I also added kvm_memslot_insert_back() to
> help document the purpose of incrementing used_slots, and renamed
> kvm_shift_memslots_forward()->kvm_memslot_move_backward() and
> kvm_shift_memslots_backward()->kvm_memslot_move_forward() because I was
> having trouble reconciling having the comments focus on the changed
> memslot while the names of the functions reflected what happens to the
> other memslots.

Oh, and I need to respin the series to fix build bugs on MIPS and PPC,
I'll wait to do that until I get a thumbs up on this code.
