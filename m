Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F097C1BB40
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 18:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730808AbfEMQqc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 12:46:32 -0400
Received: from mga05.intel.com ([192.55.52.43]:43141 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728347AbfEMQqc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 12:46:32 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 May 2019 09:46:23 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga002.jf.intel.com with ESMTP; 13 May 2019 09:46:22 -0700
Date:   Mon, 13 May 2019 09:46:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Alexandre Chartre <alexandre.chartre@oracle.com>,
        pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        jan.setjeeilers@oracle.com, liran.alon@oracle.com,
        jwadams@google.com
Subject: Re: [RFC KVM 19/27] kvm/isolation: initialize the KVM page table
 with core mappings
Message-ID: <20190513164622.GC28561@linux.intel.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <1557758315-12667-20-git-send-email-alexandre.chartre@oracle.com>
 <a9198e28-abe1-b980-597e-2d82273a2c17@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9198e28-abe1-b980-597e-2d82273a2c17@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 13, 2019 at 08:50:19AM -0700, Dave Hansen wrote:
> I seem to remember that the KVM VMENTRY/VMEXIT context is very special.
> Interrupts (and even NMIs?) are disabled.  Would it be feasible to do
> the switching in there so that we never even *get* interrupts in the KVM
> context?

NMIs are enabled on VMX's VM-Exit.  On SVM, NMIs are blocked on exit until
STGI is executed.
