Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27B2FAF202
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 21:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbfIJTp6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 15:45:58 -0400
Received: from mga12.intel.com ([192.55.52.136]:53324 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbfIJTp6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 15:45:58 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 12:45:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,490,1559545200"; 
   d="scan'208";a="189448727"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 10 Sep 2019 12:45:57 -0700
Date:   Tue, 10 Sep 2019 12:45:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Larry Dewey <ldewey@suse.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] [RFC PATCH 03/20] vl: Add "sgx-epc" option to
 expose SGX EPC sections to guest
Message-ID: <20190910194556.GC11151@linux.intel.com>
References: <20190806185649.2476-1-sean.j.christopherson@intel.com>
 <20190806185649.2476-4-sean.j.christopherson@intel.com>
 <0be06fee919426129b2f379609f76bd260fba49c.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0be06fee919426129b2f379609f76bd260fba49c.camel@suse.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 06, 2019 at 09:49:44PM +0000, Larry Dewey wrote:
> I was playing with the new objects, etc, and found if the user
> specifies -sgx-epc, and a memory device, but does not specify -cpu
> host, +sgx, the vm runs without any warnings, while obviously not doing
> anything to the memory. Perhaps some warnings if not everything which
> is required is provided?

Yeah, I waffled on what to do in this scenario.  Ditto for the opposite
scenario of having SGX enabled without EPC.   I agree a warning or error
would be helpful for EPC-without-SGX.  The SGX-without-EPC case at least
makes some sense, e.g. to mimic BIOS not partitioning EPC, and doesn't
waste resources.
