Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCAF3109392
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 19:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbfKYSfy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Nov 2019 13:35:54 -0500
Received: from mga12.intel.com ([192.55.52.136]:18500 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfKYSfy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Nov 2019 13:35:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Nov 2019 10:35:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,242,1571727600"; 
   d="scan'208";a="291472327"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 25 Nov 2019 10:35:53 -0800
Date:   Mon, 25 Nov 2019 10:35:53 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        kvm list <kvm@vger.kernel.org>,
        Haozhong Zhang <haozhong.zhang@intel.com>
Subject: Re: [PATCH] kvm: nVMX: Relax guest IA32_FEATURE_CONTROL constraints
Message-ID: <20191125183553.GH12178@linux.intel.com>
References: <20191122234355.174998-1-jmattson@google.com>
 <97EE5F0F-3047-46BC-B569-D407B5800499@oracle.com>
 <CALMp9eTLQrFprNoYtXa2MCiAGnHuf4Rqxxh33cXD936boxMEwg@mail.gmail.com>
 <E5F51322-35EF-4EC1-AF3E-2233C6C37645@oracle.com>
 <CALMp9eQ12F4OuJmvvUKLTXoKhF5UtdYBV22sTqrTffTUfj1WzQ@mail.gmail.com>
 <a0c3620f-ae7a-1473-2018-7c32d51b5120@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0c3620f-ae7a-1473-2018-7c32d51b5120@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 25, 2019 at 07:14:15PM +0100, Paolo Bonzini wrote:
> On 25/11/19 18:45, Jim Mattson wrote:
> > I would call that an opt-out cap, rather than an opt-in cap. That is,
> > we'd like to opt-out from the ABI change. I was going to go ahead and
> > do it, but it looks like Paolo has accepted the change as it is.
> 
> Yes, your experience has proved that guests are not annoyed by the
> discrepancy between VMX_INSIDE_SMX and the actual lack of SMX, so it's
> pointless to complicate the code.

Color me surprised that no guest cares about SMX :-)
