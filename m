Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5B410B671
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 20:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfK0TJ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 14:09:28 -0500
Received: from mga12.intel.com ([192.55.52.136]:16887 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbfK0TJ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 14:09:28 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 11:09:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,250,1571727600"; 
   d="scan'208";a="211780318"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 27 Nov 2019 11:09:22 -0800
Date:   Wed, 27 Nov 2019 11:09:22 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC PATCH 00/28] kvm: mmu: Rework the x86 TDP direct mapped case
Message-ID: <20191127190922.GH22227@linux.intel.com>
References: <20190926231824.149014-1-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 26, 2019 at 04:17:56PM -0700, Ben Gardon wrote:
> The goal of this  RFC is to demonstrate and gather feedback on the
> iterator pattern, the memory savings it enables for the "direct case"
> and the changes to the synchronization model. Though they are interwoven
> in this series, I will separate the iterator from the synchronization
> changes in a future series. I recognize that some feature work will be
> needed to make this patch set ready for merging. That work is detailed
> at the end of this cover letter.

How difficult would it be to send the synchronization changes as a separate
series in the not-too-distant future?  At a brief glance, those changes
appear to be tiny relative to the direct iterator changes.  From a stability
perspective, it would be nice if the locking changes can get upstreamed and
tested in the wild for a few kernel versions before the iterator code is
introduced.
