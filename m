Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209781DC563
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 04:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbgEUCvI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 22:51:08 -0400
Received: from mga17.intel.com ([192.55.52.151]:27741 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbgEUCvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 22:51:06 -0400
IronPort-SDR: 12CFGs4OuELc9MMmcD+xZ90nVcF9J19+hl1TxnLeztgh60Xqtcved2DTqG4rOeDDLAkKSWlVMy
 YItIyQs2Z1fQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 19:51:06 -0700
IronPort-SDR: /9xuwggU3Ntq6Su67HPkrlsxC7+WPL0iB8CnkPDHrUzl3LGE7vhHt3/QJBtm4Rwa4o97U0hn5B
 ILEvWFm2CcyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,416,1583222400"; 
   d="scan'208";a="282901933"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga002.jf.intel.com with ESMTP; 20 May 2020 19:51:06 -0700
Date:   Wed, 20 May 2020 19:51:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Makarand Sonare <makarandsonare@google.com>
Cc:     kvm@vger.kernel.org, pshier@google.com, jmattson@google.com
Subject: Re: [PATCH  0/2 v3] Fix VMX preemption timer migration
Message-ID: <20200521025106.GL18102@linux.intel.com>
References: <20200520232228.55084-1-makarandsonare@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520232228.55084-1-makarandsonare@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 20, 2020 at 04:22:26PM -0700, Makarand Sonare wrote:
> Fix VMX preemption timer migration. Add a selftest to ensure post migration
> both L1 and L2 VM observe the VMX preemption timer exit close to the original
> expiration deadline.

For versions > 1, please put a brief blurb in the cover letter (or in the
ignored part of each patch) explaining what changed.  It's also helpful to
give attribution, not so much for the sake of giving credit, but to give
other reviewers context.

Something like:

  v3: Moved timer deadline to kvm_vmx_nested_state_hdr. [Paolo]

  v2: Fixed xyz.

That helps reviewers understand what has changed and what feedback has been
addressed (or to remind them of what feedback they gave :-D), and helps you
avoid getting conflicting feedback.

> Makarand Sonare (1):
>   KVM: selftests: VMX preemption timer migration test
> 
> Peter Shier (1):
>   KVM: nVMX: Fix VMX preemption timer migration
> 
>  Documentation/virt/kvm/api.rst                |   4 +
>  arch/x86/include/uapi/asm/kvm.h               |   3 +
>  arch/x86/kvm/vmx/nested.c                     |  45 +++-
>  arch/x86/kvm/vmx/vmx.h                        |   2 +
>  arch/x86/kvm/x86.c                            |   3 +-
>  include/uapi/linux/kvm.h                      |   1 +
>  tools/arch/x86/include/uapi/asm/kvm.h         |   1 +
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../testing/selftests/kvm/include/kvm_util.h  |   2 +
>  .../selftests/kvm/include/x86_64/processor.h  |  11 +-
>  .../selftests/kvm/include/x86_64/vmx.h        |  27 ++
>  .../kvm/x86_64/vmx_preemption_timer_test.c    | 255 ++++++++++++++++++
>  13 files changed, 344 insertions(+), 12 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
> 
> --
> 2.26.2.761.g0e0b3e54be-goog
> 
