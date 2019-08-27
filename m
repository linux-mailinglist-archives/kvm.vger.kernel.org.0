Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAFEC9F3FA
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 22:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731298AbfH0UWV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 16:22:21 -0400
Received: from mga14.intel.com ([192.55.52.115]:30408 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbfH0UWV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 16:22:21 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 13:22:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="scan'208";a="355885999"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 27 Aug 2019 13:22:20 -0700
Date:   Tue, 27 Aug 2019 13:22:20 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 08/13] KVM: x86: Move #UD injection for failed
 emulation into emulation code
Message-ID: <20190827202220.GJ27459@linux.intel.com>
References: <20190823010709.24879-1-sean.j.christopherson@intel.com>
 <20190823010709.24879-9-sean.j.christopherson@intel.com>
 <AB4F0E37-1E13-4735-BE9F-6C80D13D016D@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AB4F0E37-1E13-4735-BE9F-6C80D13D016D@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 23, 2019 at 04:48:16PM +0300, Liran Alon wrote:
> 
> 
> > On 23 Aug 2019, at 4:07, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > 
> > Immediately inject a #UD and return EMULATE done if emulation fails when
> > handling an intercepted #UD.  This helps pave the way for removing
> > EMULATE_FAIL altogether.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> I suggest squashing this commit which previous one.

Missed this comment first time around...

I'd like to keep the two patches separate in this case.  Adding the
EMULTYPE_TRAP_UD_FORCED flag is a functional change, whereas this patch
is purely a refactor.
