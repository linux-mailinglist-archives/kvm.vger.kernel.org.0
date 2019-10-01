Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E234C4458
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 01:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbfJAXeJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 19:34:09 -0400
Received: from mga18.intel.com ([134.134.136.126]:20256 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727772AbfJAXeJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 19:34:09 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Oct 2019 16:34:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,572,1559545200"; 
   d="scan'208";a="191614228"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 01 Oct 2019 16:34:08 -0700
Date:   Tue, 1 Oct 2019 16:34:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>, vkuznets@redhat.com
Subject: Re: [PATCH kvm-unit-tests 0/8]: x86: vmx: Test INIT processing in
 various CPU VMX states
Message-ID: <20191001233408.GB6151@linux.intel.com>
References: <20190919125211.18152-1-liran.alon@oracle.com>
 <555E2BD4-3277-4261-BD54-D1924FBE9887@gmail.com>
 <5EB947BE-8494-46A7-927F-193822DD85E4@oracle.com>
 <E55E9CA1-34B1-4F9A-AAC3-AD5163A4B2D4@gmail.com>
 <B1A83F5E-3B15-4715-8AC8-D436A448D0CE@oracle.com>
 <86619DAE-C601-4162-9622-E3DE8CB1C295@gmail.com>
 <20191001184034.GC27090@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191001184034.GC27090@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 01, 2019 at 11:40:34AM -0700, Sean Christopherson wrote:
> Anyways, I'll double check that the INIT should indeed be consumed as part
> of the VM-Exit.

Confirmed that the INIT is cleared prior to delivering VM-Exit.
