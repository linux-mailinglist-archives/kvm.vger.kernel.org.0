Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBE4958296
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 14:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfF0M12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 08:27:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:46490 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbfF0M12 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 08:27:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jun 2019 05:27:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,423,1557212400"; 
   d="scan'208";a="164321091"
Received: from lxy-dell.sh.intel.com ([10.239.159.145])
  by fmsmga007.fm.intel.com with ESMTP; 27 Jun 2019 05:27:24 -0700
Message-ID: <3c53ec41a1cdf668f3d849c2177fff3098347fbb.camel@intel.com>
Subject: Re: [PATCH v9 11/17] kvm/vmx: Emulate MSR TEST_CTL
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Christopherson Sean J <sean.j.christopherson@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org
Date:   Thu, 27 Jun 2019 20:22:28 +0800
In-Reply-To: <alpine.DEB.2.21.1906271408380.32342@nanos.tec.linutronix.de>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
         <1560897679-228028-12-git-send-email-fenghua.yu@intel.com>
         <b52b0f72-e242-68b1-640c-85759bdce869@linux.intel.com>
         <alpine.DEB.2.21.1906270901120.32342@nanos.tec.linutronix.de>
         <fa53c72c-b1af-7d77-d39c-a9401dc65e27@linux.intel.com>
         <alpine.DEB.2.21.1906271408380.32342@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2019-06-27 at 14:11 +0200, Thomas Gleixner wrote:
> On Thu, 27 Jun 2019, Xiaoyao Li wrote:
> > On 6/27/2019 3:12 PM, Thomas Gleixner wrote:
> > > The real interesting question is whether the #AC on split lock prevents
> > > the
> > > actual bus lock or not. If it does then the above is fine.
> > > 
> > > If not, then it would be trivial for a malicious guest to set the
> > > SPLIT_LOCK_ENABLE bit and "handle" the exception pro forma, return to the
> > > offending instruction and trigger another one. It lowers the rate, but
> > > that
> > > doesn't make it any better.
> > > 
> > > The SDM is as usual too vague to be useful. Please clarify.
> > > 
> > 
> > This feature is to ensure no bus lock (due to split lock) in hardware, that
> > to
> > say, when bit 29 of TEST_CTL is set, there is no bus lock due to split lock
> > can be acquired.
> 
> So enabling this prevents the bus lock, i.e. the exception is raised before
> that happens.
> 
exactly.

> Please add that information to the changelog as well because that's
> important to know and makes me much more comfortable handing the #AC back
> into the guest when it has it enabled.
> 
Will add it in next version.

Thanks.



