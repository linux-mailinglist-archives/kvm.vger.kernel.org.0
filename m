Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC732A3A37
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 03:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbgKCCG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 21:06:29 -0500
Received: from mga18.intel.com ([134.134.136.126]:25958 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgKCCG3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 21:06:29 -0500
IronPort-SDR: 02ZU4rN9rSdTTOih4AkVeqdTXNuto7lVtRiaYSMV8Mjr89Ngj90o53cKyI281plzRFbGBI3LTu
 z1rcEQw8ZyZw==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="156763943"
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="156763943"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 18:06:28 -0800
IronPort-SDR: Kq6lU2fZpcgBUsl0B+DBw7X9k9ezyBKi1z58dYSXci+awnhXrCJemdiKjNZSiihHrdJFghI1C0
 eWMHQSf6vLBQ==
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="353032672"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 18:06:26 -0800
Date:   Mon, 2 Nov 2020 18:06:24 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     thomas.lendacky@amd.com, pbonzini@redhat.com, tj@kernel.org,
        lizefan@huawei.com, joro@8bytes.org, corbet@lwn.net,
        brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com,
        gingell@google.com, rientjes@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch 0/2] KVM: SVM: Cgroup support for SVM SEV ASIDs
Message-ID: <20201103020623.GJ21563@linux.intel.com>
References: <20200922004024.3699923-1-vipinsh@google.com>
 <20200922014836.GA26507@linux.intel.com>
 <20200922211404.GA4141897@google.com>
 <20200924192116.GC9649@linux.intel.com>
 <cb592c59-a50e-5901-71fe-19e43bc9e37e@amd.com>
 <20200925222220.GA977797@google.com>
 <20201002204810.GA3179405@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002204810.GA3179405@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 02, 2020 at 01:48:10PM -0700, Vipin Sharma wrote:
> On Fri, Sep 25, 2020 at 03:22:20PM -0700, Vipin Sharma wrote:
> > I agree with you that the abstract name is better than the concrete
> > name, I also feel that we must provide HW extensions. Here is one
> > approach:
> > 
> > Cgroup name: cpu_encryption, encryption_slots, or memcrypt (open to
> > suggestions)
> > 
> > Control files: slots.{max, current, events}

I don't particularly like the "slots" name, mostly because it could be confused
with KVM's memslots.  Maybe encryption_ids.ids.{max, current, events}?  I don't
love those names either, but "encryption" and "IDs" are the two obvious
commonalities betwee TDX's encryption key IDs and SEV's encryption address
space IDs.
