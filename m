Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAFBBE570
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 21:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbfIYTNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 15:13:40 -0400
Received: from mga03.intel.com ([134.134.136.65]:40921 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbfIYTNj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 15:13:39 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 12:13:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,549,1559545200"; 
   d="scan'208";a="214145864"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 25 Sep 2019 12:13:38 -0700
Date:   Wed, 25 Sep 2019 12:13:38 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Orr <marcorr@google.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com, pshier@google.com,
        krish.sadhukhan@oracle.com, pbonzini@redhat.com,
        rkrcmar@redhat.com, dinechin@redhat.com
Subject: Re: [kvm-unit-tests PATCH v7 2/2] x86: nvmx: test max atomic switch
 MSRs
Message-ID: <20190925191338.GL31852@linux.intel.com>
References: <20190925011821.24523-1-marcorr@google.com>
 <20190925011821.24523-2-marcorr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925011821.24523-2-marcorr@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 24, 2019 at 06:18:21PM -0700, Marc Orr wrote:
> Excercise nested VMX's atomic MSR switch code (e.g., VM-entry MSR-load
> list) at the maximum number of MSRs supported, as described in the SDM,
> in the appendix chapter titled "MISCELLANEOUS DATA".
> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Marc Orr <marcorr@google.com>
> ---

Thanks for being patient and fixing all the nits!

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
