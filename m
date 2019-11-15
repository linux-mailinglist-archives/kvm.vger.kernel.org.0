Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41735FE152
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 16:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfKOPeR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 10:34:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:25964 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727526AbfKOPeR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 10:34:17 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Nov 2019 07:34:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,308,1569308400"; 
   d="scan'208";a="208449702"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 15 Nov 2019 07:34:16 -0800
Date:   Fri, 15 Nov 2019 07:34:16 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 06/16] x86/cpu: Clear VMX feature flag if VMX is not
 fully enabled
Message-ID: <20191115153416.GA6055@linux.intel.com>
References: <20191021234632.32363-1-sean.j.christopherson@intel.com>
 <20191022000836.1907-1-sean.j.christopherson@intel.com>
 <20191025163858.GF6483@zn.tnic>
 <20191114183238.GH24045@linux.intel.com>
 <5aacaba0-76e2-9824-ebd4-fa510bce712d@redhat.com>
 <20191115103434.GH18929@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115103434.GH18929@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 15, 2019 at 11:34:34AM +0100, Borislav Petkov wrote:
> Btw, Sean, are you sending a new version of this ontop of latest
> tip/master or linux-next or so? I'd like to look at the rest of the bits
> in detail.

Sure, I'll rebase and get a new version sent out today.
