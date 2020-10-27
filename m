Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7884129CBDA
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 23:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1832228AbgJ0WPF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 18:15:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:62018 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1832219AbgJ0WPF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 18:15:05 -0400
IronPort-SDR: QOYR9hkv+xw2ATH4Oepb6wOY+wKBe0JibeTxhSRoGZcqG46VMlr2FUBM4JzNo1Q/RP2sHAkDAV
 OSzjrp4vyGGQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9787"; a="185920653"
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="185920653"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 15:15:05 -0700
IronPort-SDR: wsGb9gILJno1HDi1cWzUQ5Sv0yBFkqIAb+7VeUJvdCuvQAP7d/otE23wTOKw3XgsHXYGPgkdi0
 CgssQapcXgLQ==
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="424545510"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 15:15:05 -0700
Date:   Tue, 27 Oct 2020 15:15:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: x86/mmu: Use hugepage GFN mask to compute GFN
 offset mask
Message-ID: <20201027221500.GA2011@linux.intel.com>
References: <20201027214300.1342-1-sean.j.christopherson@intel.com>
 <20201027214300.1342-4-sean.j.christopherson@intel.com>
 <CANgfPd-cOrEnEbtPkRHgW3yVZQJtpbzr77+nj5+Hq6W2TJys-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd-cOrEnEbtPkRHgW3yVZQJtpbzr77+nj5+Hq6W2TJys-g@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 27, 2020 at 03:09:11PM -0700, Ben Gardon wrote:
> On Tue, Oct 27, 2020 at 2:43 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Use the logical NOT of KVM_HPAGE_GFN_MASK() to compute the GFN offset
> > mask instead of open coding the equivalent in a variety of locations.
> 
> I don't see a "no functional change expected" note on this patch as
> was on the previous one, but I don't think this represents any
> functional change.

Ah, yeah, I meant to call out in the cover letter than nothing in this series
generates a functional difference, e.g. objdump of kvm/kvm-intel is identical
from start to finish.
