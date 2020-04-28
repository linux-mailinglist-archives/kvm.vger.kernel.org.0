Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A931BBFD3
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 15:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbgD1NjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 09:39:16 -0400
Received: from mga07.intel.com ([134.134.136.100]:52757 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727823AbgD1NjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 09:39:16 -0400
IronPort-SDR: ekGBMTww8ZRmfOlk49gepsTc+L15t84rxS9haT6VPFsBjVb44y9Eto8ekB0vIDJwt1cgU+d8S2
 6v+oSN5/npHA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2020 06:39:15 -0700
IronPort-SDR: xKFpk/LY3rt43qQlURN33PtK48Ij6dtPcHD6+OEkjS5NgVRS7+hp1aeP0K3yC3KsXc5G97+Gcc
 xyaE0EbSTzsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,327,1583222400"; 
   d="scan'208";a="302710365"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Apr 2020 06:39:12 -0700
Date:   Tue, 28 Apr 2020 21:41:07 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 7/9] KVM: X86: Add userspace access interface for CET
 MSRs
Message-ID: <20200428134107.GA23937@local-michael-cet-test>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-8-weijiang.yang@intel.com>
 <08457f11-f0ac-ff4b-80b7-e5380624eca0@redhat.com>
 <20200426152355.GB29493@local-michael-cet-test.sh.intel.com>
 <f6f8cedf-26ce-70b4-2906-02806698d81b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6f8cedf-26ce-70b4-2906-02806698d81b@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 27, 2020 at 04:04:28PM +0200, Paolo Bonzini wrote:
> On 26/04/20 17:23, Yang Weijiang wrote:
> > What's the purpose of the selftest? Is it just for Shadow Stack SSP
> > state transitions in various cases? e.g., L0 SSP<--->L3 SSP,
> > L0 SSP1<--->L0 SSP2?
> 
> No, it checks that the whole state can be extracted and restored from a
> running VM.  For example, it would have caught immediately that the
> current SSP could not be saved and restored.
> 
> > We now have the KVM unit-test for CET functionalities,
> > i.e., Shadow Stack and Indirect Branch Tracking for user-mode, I can put the
> > state test app into the todo list as current patchset is mainly for user-mode
> > protection, the supervisor-mode CET protection is the next step.
> 
> What are the limitations?  Or are you referring to the unit test?
>
I'm referring to the unit test, I enabled basic CET function test to verify
if SHSTK/IBT is supported with current platform and KVM, but didn't cover
what you mentioned above. OK, I put the state
self-test to my todo list. Thank you for the reminder.

> Paolo
