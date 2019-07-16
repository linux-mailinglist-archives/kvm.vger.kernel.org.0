Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC7C66AC84
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 18:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbfGPQKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 12:10:36 -0400
Received: from mga03.intel.com ([134.134.136.65]:27268 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728510AbfGPQKg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 12:10:36 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 09:10:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,498,1557212400"; 
   d="scan'208";a="158180063"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by orsmga007.jf.intel.com with ESMTP; 16 Jul 2019 09:10:35 -0700
Date:   Tue, 16 Jul 2019 09:10:35 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org,
        brijesh.singh@amd.com, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 2/2] KVM: x86: Rename need_emulation_on_page_fault() to
 handle_no_insn_on_page_fault()
Message-ID: <20190716161035.GB1987@linux.intel.com>
References: <20190715203043.100483-1-liran.alon@oracle.com>
 <20190715203043.100483-3-liran.alon@oracle.com>
 <20190716154855.GA1987@linux.intel.com>
 <ECF661D3-A0F0-4F55-A7E5-CE6E204947D1@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ECF661D3-A0F0-4F55-A7E5-CE6E204947D1@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 16, 2019 at 07:01:30PM +0300, Liran Alon wrote:
> 
> > On 16 Jul 2019, at 18:48, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > 	kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> > 	return false;
> 
> I don’t think we should triple-fault and return “false”. As from a semantic
> perspective, we should return true.

Fair enough, I guess it's no different than the warn-and-continue logic
used in the unreachable VM-Exit handlers.

> But this commit is getting really philosophical :) Maybe let’s hear Paolo’s
> preference first before doing any change.

Hence my recommendation to put the function change in a separate patch :-)
