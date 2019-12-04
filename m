Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1288112D7D
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 15:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbfLDOdQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 09:33:16 -0500
Received: from mga03.intel.com ([134.134.136.65]:24233 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbfLDOdP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 09:33:15 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Dec 2019 06:33:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,277,1571727600"; 
   d="scan'208";a="201418921"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 04 Dec 2019 06:33:15 -0800
Date:   Wed, 4 Dec 2019 06:33:14 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191204143314.GA6323@linux.intel.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <20191203191328.GD19877@linux.intel.com>
 <24cf519e-5efa-85a7-9bc0-9be15957eb0a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24cf519e-5efa-85a7-9bc0-9be15957eb0a@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 04, 2019 at 11:14:19AM +0100, Paolo Bonzini wrote:
> On 03/12/19 20:13, Sean Christopherson wrote:
> > The setting of as_id is wrong, both with and without a vCPU.  as_id should
> > come from slot->as_id.
> 
> Which doesn't exist, but is an excellent suggestion nevertheless.

Huh, I explicitly looked at the code to make sure as_id existed before
making this suggestion.  No idea what code I actually pulled up.
