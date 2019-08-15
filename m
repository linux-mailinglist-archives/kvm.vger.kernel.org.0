Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 428218E1CA
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 02:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbfHOATx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 20:19:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:14456 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbfHOATx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 20:19:53 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Aug 2019 17:19:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,387,1559545200"; 
   d="scan'208";a="181722979"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 14 Aug 2019 17:19:52 -0700
Date:   Wed, 14 Aug 2019 17:19:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v4 2/7] x86: kvm: svm: propagate errors from
 skip_emulated_instruction()
Message-ID: <20190815001952.GA24750@linux.intel.com>
References: <20190813135335.25197-1-vkuznets@redhat.com>
 <20190813135335.25197-3-vkuznets@redhat.com>
 <20190813180759.GF13991@linux.intel.com>
 <87d0h89jk3.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d0h89jk3.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 14, 2019 at 11:34:52AM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>
> > x86_emulate_instruction() doesn't set vcpu->run->exit_reason when emulation
> > fails with EMULTYPE_SKIP, i.e. this will exit to userspace with garbage in
> > the exit_reason.
> 
> Oh, nice catch, will take a look!

Don't worry about addressing this.  Paolo has already queued the series,
and I've got a patch set waiting that purges emulation_result entirely
that I'll post once your series hits kvm/queue.
