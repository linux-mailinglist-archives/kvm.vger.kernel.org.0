Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81566B045A
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 21:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730170AbfIKTBc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 15:01:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:52456 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729016AbfIKTBc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 15:01:32 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Sep 2019 12:01:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="268841530"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 11 Sep 2019 12:01:32 -0700
Date:   Wed, 11 Sep 2019 12:01:32 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Bill Wendling <morbo@google.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] x86: debug: use a constraint that doesn't
 allow a memory operand
Message-ID: <20190911190131.GF1045@linux.intel.com>
References: <CAGG=3QUHwHsVtrc3UYhhbkBX5WOp4Am=beFnn7yyxh6ykTe_Fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGG=3QUHwHsVtrc3UYhhbkBX5WOp4Am=beFnn7yyxh6ykTe_Fw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 09, 2019 at 02:00:35PM -0700, Bill Wendling wrote:
> The "lea" instruction cannot load the effective address into a memory
> location. The "g" constraint allows a compiler to use a memory location.
> A compiler that uses a register destination does so only because one is
> available. Use a general register constraint to make sure it always uses
> a register.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
