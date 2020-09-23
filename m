Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14F5275F76
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgIWSJ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:09:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:39818 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgIWSJ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:09:29 -0400
IronPort-SDR: xpyLsANDwsiMRm8dvOM6TkfLgFAoq1fFhp0nYTqDIu4x8Lhrz4bd8OPRO68C9r7KSVzg3GORQG
 92bGH1ivXktQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="158332283"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="158332283"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:08:04 -0700
IronPort-SDR: QJkMPzOfLNIkiYOMN9rZ2xZnXypTQJCtopq1wGF+R3syPkY/kr7SQEkzK7cu8sqSTlrg2fxY9W
 m8xXgH+H51dA==
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="305478192"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:08:04 -0700
Date:   Wed, 23 Sep 2020 11:08:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: SEV: shorten comments around sev_clflush_pages
Message-ID: <20200923180803.GC32044@linux.intel.com>
References: <20200923173401.1632172-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923173401.1632172-1-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 23, 2020 at 01:34:01PM -0400, Paolo Bonzini wrote:
> Very similar content is present in four comments in sev.c.  Unfortunately
> there are small differences that make it harder to place the comment
> in sev_clflush_pages itself, but at least we can make it more concise.
> 
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
