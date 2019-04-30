Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17BAE101A2
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 23:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbfD3VLb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 17:11:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:36828 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbfD3VLb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 17:11:31 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Apr 2019 14:11:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,414,1549958400"; 
   d="scan'208";a="166391957"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by fmsmga002.fm.intel.com with ESMTP; 30 Apr 2019 14:11:30 -0700
Date:   Tue, 30 Apr 2019 14:11:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: use direct accessors for RIP and RSP
Message-ID: <20190430211130.GF4523@linux.intel.com>
References: <1556654865-45045-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556654865-45045-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 30, 2019 at 10:07:45PM +0200, Paolo Bonzini wrote:
> Use specific inline functions for RIP and RSP instead of
> going through kvm_register_read and kvm_register_write,
> which are quite a mouthful.  kvm_rsp_read and kvm_rsp_write
> did not exist, so add them.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
