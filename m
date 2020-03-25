Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB39192D5A
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 16:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgCYPuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 11:50:11 -0400
Received: from mga14.intel.com ([192.55.52.115]:38769 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727604AbgCYPuL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 11:50:11 -0400
IronPort-SDR: F/b2LN8wrN8s+2GlYTK1FuYehjuN+sqHI5FRcdFAK8LD/R7fHt43oNhhwVV5KF9YFqp+0D2Cx5
 32iOWYr5lr7g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 08:50:10 -0700
IronPort-SDR: TyZ0wjycj1SNMJgAd3oT+lOxqPJu5isKfnx2cqt0Ldsdyt9UqDXG9RDjpYCsA/ccuFkgB+8Lv8
 m13i4vZQnlTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,304,1580803200"; 
   d="scan'208";a="393667950"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 25 Mar 2020 08:50:10 -0700
Date:   Wed, 25 Mar 2020 08:50:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM list <kvm@vger.kernel.org>
Subject: Re: status of kvm.git
Message-ID: <20200325155009.GF14294@linux.intel.com>
References: <ba6573bd-274e-3629-92f0-77eb5b82ac40@redhat.com>
 <20200325153557.GD14294@linux.intel.com>
 <8cd788f0-a7cf-3dc6-42b0-0e7a2e9d7f27@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8cd788f0-a7cf-3dc6-42b0-0e7a2e9d7f27@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 25, 2020 at 04:47:36PM +0100, Paolo Bonzini wrote:
> On 25/03/20 16:35, Sean Christopherson wrote:
> > On Tue, Mar 24, 2020 at 12:53:11PM +0100, Paolo Bonzini wrote:
> >> For 5.8 I'd rather tone down the cleanups and focus on the new processor
> >> features (especially CET and SPP) and on nested AMD unit tests and bugfixes.
> > 
> > Roger that.  Reviewing the latest CET series is on my todo list.
> > 
> > Regarding SPP, I thought the plan was to wait until VMI landed before
> > taking SPP support?  Has that changed?
> 
> No, the latest VMI series included SPP but the code can go in separately
> since it has its own selftest.

Ah, gotcha.  In that case, I'll prioritize reviewing SPP as well.
