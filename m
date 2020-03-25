Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E50DB192DF2
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 17:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgCYQOH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 12:14:07 -0400
Received: from mga12.intel.com ([192.55.52.136]:50007 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727174AbgCYQOH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 12:14:07 -0400
IronPort-SDR: b8mTuNUUNP+XzqBeqZMRGIPT+eBg/gudpHhe9KB5USlCzEstht8eiuNexHoIdS+ZdZdrBHG6SO
 n98FS7rkz5KQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 09:14:06 -0700
IronPort-SDR: e2Ug/iZdOJlUCQRIUNttPiRngVaekzIE3L0ixyPw2HDDsCjj2pkvNXD8I7//zXaMmmVQzMAkbI
 cBbKIh4y4fpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,304,1580803200"; 
   d="scan'208";a="270854277"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 25 Mar 2020 09:14:06 -0700
Date:   Wed, 25 Mar 2020 09:14:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: linux-next: Tree for Mar 25 (arch/x86/kvm/)
Message-ID: <20200325161405.GG14294@linux.intel.com>
References: <20200325195350.7300fee9@canb.auug.org.au>
 <e9286016-66ae-9505-ea52-834527cdae27@infradead.org>
 <d9af8094-96c3-3b7f-835c-4e48d157e582@redhat.com>
 <064720eb-2147-1b92-7a62-f89d6380f40a@infradead.org>
 <85430f7e-93e0-3652-0705-9cf6e948a9d8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85430f7e-93e0-3652-0705-9cf6e948a9d8@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 25, 2020 at 05:08:03PM +0100, Paolo Bonzini wrote:
> On 25/03/20 16:57, Randy Dunlap wrote:
> >> Randy, can you test it with your compiler?
> > Nope, no help.  That's the wrong location.
> > Need a patch for this:
> >>> 24 (only showing one of them here) BUILD_BUG() errors in arch/x86/kvm/cpuid.h
> >>> function __cpuid_entry_get_reg(), for the default: case.
> 
> Doh, right.  I think the only solution for that one is to degrade it to
> WARN_ON(1).

I reproduced the error, give me a bit to play with the code to see if the
BUILD_BUG can be preserved.  I'm curious as to why kvm_cpu_cap_mask() is
special, and why it only fails with this config.
