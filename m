Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 189F9192C9C
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 16:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbgCYPc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 11:32:56 -0400
Received: from mga14.intel.com ([192.55.52.115]:37327 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727491AbgCYPc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 11:32:56 -0400
IronPort-SDR: RdDVsOjr5hc+yIpfkOgO1WNzwdIvjhbzdMWBTa5kcdPCpcbLkxSKaQ/7M42lEXYUPSmqksqji+
 lRSknRWV9LEA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 08:32:55 -0700
IronPort-SDR: lwG8YFe/S1M+7otpyY2XcPjdQZi0KulJ5ajLWmFWM6vokbAvzAtZ2u2fGBguyVbVRo/dVz2IGj
 qp6MGcPO9CwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,304,1580803200"; 
   d="scan'208";a="446656572"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 25 Mar 2020 08:32:55 -0700
Date:   Wed, 25 Mar 2020 08:32:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: linux-next: Tree for Mar 25 (arch/x86/kvm/)
Message-ID: <20200325153255.GC14294@linux.intel.com>
References: <20200325195350.7300fee9@canb.auug.org.au>
 <e9286016-66ae-9505-ea52-834527cdae27@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9286016-66ae-9505-ea52-834527cdae27@infradead.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 25, 2020 at 08:30:00AM -0700, Randy Dunlap wrote:
> On 3/25/20 1:53 AM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20200324:
> > 
> 
> 
> on i386 randconfig build:
> and gcc 7.5.0:
> 
> 24 (only showing one of them here) BUILD_BUG() errors in arch/x86/kvm/cpuid.h
> function __cpuid_entry_get_reg(), for the default: case.

I'll take a gander at this.
