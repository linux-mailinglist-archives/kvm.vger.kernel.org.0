Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23EB337AD9
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 19:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbfFFRUf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 13:20:35 -0400
Received: from mga04.intel.com ([192.55.52.120]:40558 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726693AbfFFRUf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 13:20:35 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 10:20:34 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga001.jf.intel.com with ESMTP; 06 Jun 2019 10:20:34 -0700
Date:   Thu, 6 Jun 2019 10:20:34 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: introduce is_pae_paging
Message-ID: <20190606172033.GD23169@linux.intel.com>
References: <1559839972-124144-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559839972-124144-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 06, 2019 at 06:52:52PM +0200, Paolo Bonzini wrote:
> Checking for 32-bit PAE is quite common around code that fiddles with
> the PDPTRs.  Add a function to compress all checks into a single
> invocation.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

I considered adding this helper as well, but shied away because I thought
it might lead to incorrect code, e.g. using is_pae_paging() when is_pae()
is needed.  But, looking at the patch, it's definitely cleaner, so:

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
