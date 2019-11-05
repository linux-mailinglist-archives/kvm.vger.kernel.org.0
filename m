Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D220FEF32C
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 03:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729837AbfKECB4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 21:01:56 -0500
Received: from mga05.intel.com ([192.55.52.43]:31360 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729428AbfKECB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 21:01:56 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Nov 2019 18:01:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,269,1569308400"; 
   d="scan'208";a="195662641"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 04 Nov 2019 18:01:55 -0800
Date:   Mon, 4 Nov 2019 18:01:55 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/4] kvm: nested: Introduce read_and_check_msr_entry()
Message-ID: <20191105020155.GA6392@linux.intel.com>
References: <20191029210555.138393-1-aaronlewis@google.com>
 <20191029210555.138393-2-aaronlewis@google.com>
 <CALMp9eQJGyPAnBiQF=fgLLDh4Jq8MF5N0dZ1wy+Run-nC8oeSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQJGyPAnBiQF=fgLLDh4Jq8MF5N0dZ1wy+Run-nC8oeSw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 04, 2019 at 02:41:10PM -0800, Jim Mattson wrote:
> On Tue, Oct 29, 2019 at 2:06 PM Aaron Lewis <aaronlewis@google.com> wrote:
> >
> > Add the function read_and_check_msr_entry() which just pulls some code
> > out of nested_vmx_store_msr() for now, however, this is in preparation
> > for a change later in this series were we reuse the code in
> > read_and_check_msr_entry().
> >
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > Change-Id: Iaf8787198c06674e8b0555982a962f5bd288e43f
> Drop the Change-Id.

Even better, incoporate checkpatch into your flow, this is one of the few
things that is unequivocally considered an error.
