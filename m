Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 757431233F6
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 18:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfLQRzJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 12:55:09 -0500
Received: from mga14.intel.com ([192.55.52.115]:47079 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726722AbfLQRzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 12:55:09 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 09:55:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,326,1571727600"; 
   d="scan'208";a="227576274"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 17 Dec 2019 09:55:08 -0800
Date:   Tue, 17 Dec 2019 09:55:08 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v3 00/15] KVM: Dynamically size memslot arrays
Message-ID: <20191217175507.GA8052@linux.intel.com>
References: <20191024230744.14543-1-sean.j.christopherson@intel.com>
 <20191203221433.GK19877@linux.intel.com>
 <20191213200151.GF31552@linux.intel.com>
 <ca928a38-4bc0-88cd-dc70-62aec8695c77@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca928a38-4bc0-88cd-dc70-62aec8695c77@de.ibm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 16, 2019 at 09:25:24AM +0100, Christian Borntraeger wrote:
> 
> On 13.12.19 21:01, Sean Christopherson wrote:
> > Applies cleanly on the current kvm/queue and nothing caught fire in
> > testing (though I only re-tested the series as a whole).
> 
> Do you have the latest version somewhere on a branch? The version on the
> list no longer applies cleanly.

Ah, I only tested with my sparse x86-only tree.  The result with three-way
merging, i.e. 'git am -3', looks correct at a glance.

Regardless, I need to spin a new version to handle a conflict with an
unrelated in-flight memslots bug fix, I'll get that sent out today.
