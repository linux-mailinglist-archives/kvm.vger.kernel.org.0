Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3281A23FC
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 16:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgDHOXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 10:23:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:54100 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbgDHOXE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 10:23:04 -0400
IronPort-SDR: Q4sVnB1sQy9KaF9tayZOi3WKKRmPcXowFhyF41/+7sVrSdF0qTcx2Hjv1i6mBQi1Ku0puN409R
 BXNye8j/Tm/w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2020 07:23:03 -0700
IronPort-SDR: Gb5W0BceH43BnnIx0UpCQ+0biYB59F70/Vo0XMDBC4kjsoGC5ieJuiRODEtezmcSZtiQ+dFyHR
 +S3krWP8JVXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,358,1580803200"; 
   d="scan'208";a="275457576"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 08 Apr 2020 07:23:03 -0700
Date:   Wed, 8 Apr 2020 07:23:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+d889b59b2bb87d4047a2@syzkaller.appspotmail.com
Subject: Re: [PATCH 0/2] KVM: Fix out-of-bounds memslot access
Message-ID: <20200408142302.GA10686@linux.intel.com>
References: <20200408064059.8957-1-sean.j.christopherson@intel.com>
 <526247ac-4201-8b3d-0f15-d93b12a530b8@de.ibm.com>
 <20200408101004.09b1f56d.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408101004.09b1f56d.cohuck@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 08, 2020 at 10:10:04AM +0200, Cornelia Huck wrote:
> On Wed, 8 Apr 2020 09:24:27 +0200
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
> > On 08.04.20 08:40, Sean Christopherson wrote:
> > > Two fixes for what are effectively the same bug.  The binary search used
> > > for memslot lookup doesn't check the resolved index and can access memory
> > > beyond the end of the memslot array.
> > > 
> > > I split the s390 specific change to a separate patch because it's subtly
> > > different, and to simplify backporting.  The KVM wide fix can be applied
> > > to stable trees as is, but AFAICT the s390 change would need to be paired
> > > with the !used_slots check from commit 774a964ef56 ("KVM: Fix out of range  
> > 
> > I cannot find the commit id 774a964ef56
> > 
> 
> It's 0774a964ef561b7170d8d1b1bfe6f88002b6d219 in my tree.

Argh, I botched the copy.  Thanks for hunting it down!
