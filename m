Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F45F1EEA7D
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 20:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbgFDSq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 14:46:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:1948 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728124AbgFDSq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 14:46:57 -0400
IronPort-SDR: BsYdEb+Fr5SodmA73rAhjv3XxAnTH2Q1pgrQ56CH4XBz2bYLkpVIsFQCOcu5zHlL3jCL3OZOQ5
 4JFluUlroz8g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 11:46:56 -0700
IronPort-SDR: /gArhaqUypGol+jKBBMBqyblACXVdTLBDM0wJgkV0Fpby3X84m2tHCRTJS6C3ueBLU80taRi+6
 CiKBsSfP991w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,472,1583222400"; 
   d="scan'208";a="258441554"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga007.jf.intel.com with ESMTP; 04 Jun 2020 11:46:56 -0700
Date:   Thu, 4 Jun 2020 11:46:56 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH v3 3/4] kvm: vmx: Add last_cpu to struct vcpu_vmx
Message-ID: <20200604184656.GD30456@linux.intel.com>
References: <20200601222416.71303-1-jmattson@google.com>
 <20200601222416.71303-4-jmattson@google.com>
 <20200602012139.GF21661@linux.intel.com>
 <CALMp9eS3XEVdZ-_pRsevOiKRBSbCr96saicxC+stPfUqsM1u1A@mail.gmail.com>
 <20200603022414.GA24364@linux.intel.com>
 <CALMp9eSth924epmxS8-mMXopGMFfR_JK7Hm8tQXyeqGF3ebxcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eSth924epmxS8-mMXopGMFfR_JK7Hm8tQXyeqGF3ebxcg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 03, 2020 at 01:18:31PM -0700, Jim Mattson wrote:
> On Tue, Jun 2, 2020 at 7:24 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> > As an alternative to storing the last run/attempted CPU, what about moving
> > the "bad VM-Exit" detection into handle_exit_irqoff, or maybe a new hook
> > that is called after IRQs are enabled but before preemption is enabled, e.g.
> > detect_bad_exit or something?  All of the paths in patch 4/4 can easily be
> > moved out of handle_exit.  VMX would require a little bit of refacotring for
> > it's "no handler" check, but that should be minor.
> 
> Given the alternatives, I'm willing to compromise my principles wrt
> emulation_required. :-) I'll send out v4 soon.

What do you dislike about the alternative approach?
