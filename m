Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E1727BB4E
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 05:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbgI2DL5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 23:11:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:48732 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727043AbgI2DL5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Sep 2020 23:11:57 -0400
IronPort-SDR: g8hP7SdxDldRjKLgUvujYiIVhcUvBNSFY8/b0b2kOPPFC4vblc/lFWhTr9CTamkA+ohUxVJtsB
 Qf76x2Nd9VIg==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="180260780"
X-IronPort-AV: E=Sophos;i="5.77,316,1596524400"; 
   d="scan'208";a="180260780"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 20:11:57 -0700
IronPort-SDR: sIfP4keHuj9/R/OZ/fKJU67lrVD8Jhsc3D5vPClwGqtkFCxWZ2gm6J8DcZMUe2SmGg3RxtME/g
 TLAwcfg89LAQ==
X-IronPort-AV: E=Sophos;i="5.77,316,1596524400"; 
   d="scan'208";a="513691733"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 20:11:57 -0700
Date:   Mon, 28 Sep 2020 20:11:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 3/4 v2] KVM: nSVM: Test non-MBZ reserved bits in CR3 in
 long mode
Message-ID: <20200929031154.GC31514@linux.intel.com>
References: <20200928072043.9359-1-krish.sadhukhan@oracle.com>
 <20200928072043.9359-4-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928072043.9359-4-krish.sadhukhan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 28, 2020 at 07:20:42AM +0000, Krish Sadhukhan wrote:
> According to section "CR3" in APM vol. 2, the non-MBZ reserved bits in CR3
> need to be set by software as follows:
> 
> 	"Reserved Bits. Reserved fields should be cleared to 0 by software
> 	when writing CR3."

Nothing in the shortlog or changelog actually states what this patch does.
"Test non-MBZ reserved bits in CR3 in long mode" is rather ambiguous, and
IIUC, the changelog is straight up misleading.

Based on the discussion from v1, I _think_ this test verifies that KVM does
_not_ fail nested VMRUN if non-MBZ bits are set, correct?

If so, then something like:

  KVM: nSVM: Verify non-MBZ CR3 reserved bits can be set in long mode

with further explanation in the changelog would be very helpful.
