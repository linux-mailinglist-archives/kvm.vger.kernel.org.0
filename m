Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAD9937B66
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 19:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730170AbfFFRtk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 13:49:40 -0400
Received: from mga07.intel.com ([134.134.136.100]:33781 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727961AbfFFRtk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 13:49:40 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 10:49:39 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga001.jf.intel.com with ESMTP; 06 Jun 2019 10:49:39 -0700
Date:   Thu, 6 Jun 2019 10:49:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] Revert "KVM: nVMX: always use early vmcs check when
 EPT is disabled"
Message-ID: <20190606174939.GF23169@linux.intel.com>
References: <20190520201029.7126-1-sean.j.christopherson@intel.com>
 <20190520201029.7126-3-sean.j.christopherson@intel.com>
 <40c7c3ee-9c49-1df6-c80b-1bc7811ccf69@redhat.com>
 <20190606170837.GC23169@linux.intel.com>
 <eea2b956-2c58-ad2d-7b47-45858c887c03@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eea2b956-2c58-ad2d-7b47-45858c887c03@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 06, 2019 at 07:31:13PM +0200, Paolo Bonzini wrote:
> On 06/06/19 19:08, Sean Christopherson wrote:
> >> This hunk needs to be moved to patch 1, which then becomes much easier
> >> to understand...
> > I kept the revert in a separate patch so that the bug fix could be
> > easily backported to stable branches (commit 2b27924bb1d4 ("KVM: nVMX:
> > always use early vmcs check when EPT is disabled" wasn't tagged for
> > stable).
> > 
> 
> Yeah, I didn't mark it because of the mess involving the vmx.c split
> (basically wait and see if someone report it).  There was quite some
> churn so I am a bit wary to do stable backports where I haven't
> explicitly tested the backport on the oldest affected version.

Do you want me to send a v2 as a single patch?  If so, presumably without
cc'ing stable?
