Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087B91B64E0
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 21:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgDWT6c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 15:58:32 -0400
Received: from mga18.intel.com ([134.134.136.126]:35340 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbgDWT6c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 15:58:32 -0400
IronPort-SDR: qCbgURd+SVEA0sJQcTxaeoHO83tek0GEO6eC9IHLLqdSZvkeFyi9EROnwVu05dpoHycqlHPW4M
 GxCuOpTStREg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 12:58:31 -0700
IronPort-SDR: 61y+Tqkj45fICIepaEaNB/FU7yJ5pDT+LGDxH4t5zv6XlgtPqoka3ikmi1lhSda6U2q2w+ITvk
 zkg2Onc7LRPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,309,1583222400"; 
   d="scan'208";a="259539857"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 23 Apr 2020 12:58:31 -0700
Date:   Thu, 23 Apr 2020 12:58:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Makarand Sonare <makarandsonare@google.com>
Cc:     kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [kvm PATCH] KVM: nVMX - enable VMX preemption timer migration
Message-ID: <20200423195831.GR17824@linux.intel.com>
References: <20200422205030.84476-1-makarandsonare@google.com>
 <20200423153359.GB17824@linux.intel.com>
 <CA+qz5spBA0HiXbvtZ-7bvfvf20HbfVaV0UrXF=NOGMA1ptuTHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+qz5spBA0HiXbvtZ-7bvfvf20HbfVaV0UrXF=NOGMA1ptuTHg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please read through Thomas' diatribe^W comments on top-posting and HTML
email[*].  I appreciate that it can be frustrating to configure and get
used to, especially in a corporate environment, but it really does help
get your code upstreamed.

https://people.kernel.org/tglx/notes-about-netiquette

On Thu, Apr 23, 2020 at 11:48:34AM -0700, Makarand Sonare wrote:
> Thanks for the feedback!
> *>>Any plans to enhance the vmx_set_nested_state_test.c to verify this
> works as intended?*
> I am working on writing the test as part of state_test.c as that test
> already has the nested state save/restore logic.
> 
> *>>Build tested only, but {get,put}_user() compiles just fine, as
> requested.*
> The impacted functions are using copy_to_user/copy_from_user already so I
> used the same for consistency.

That's because they're copying complex structures that don't fit in a
single memory access.

> I will send a v3 PATCH after incorporating rest of the feedback.

In the future, please give folks a chance to digest and respond before
spinning another version, especially when there is disagreement over which
direction to take.  E.g. the above {get,put}_user() thing is easy to sort
out with a few back-and-forth mails.  Sending v3 prematurely (and v2 for
that matter) means that closing that discussion requires tracking down the
new version and providing the necessary context.  Which, as an aside, is
why trimming mails and bottom-posting is helpful as it allows the scope of
the conversation to be narrowed to the remaining opens.
