Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7B838E47
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 17:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbfFGPBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 11:01:40 -0400
Received: from mga07.intel.com ([134.134.136.100]:62528 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728682AbfFGPBk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 11:01:40 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jun 2019 08:01:39 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga003.jf.intel.com with ESMTP; 07 Jun 2019 08:01:39 -0700
Date:   Fri, 7 Jun 2019 08:01:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Eugene Korenevsky <ekorenevsky@gmail.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v5 2/3] kvm: vmx: segment limit check: use access length
Message-ID: <20190607150139.GC9083@linux.intel.com>
References: <20190607060321.GA29109@dnote>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607060321.GA29109@dnote>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 07, 2019 at 09:03:21AM +0300, Eugene Korenevsky wrote:
> There is an imperfection in get_vmx_mem_address(): access length is
> ignored when checking the limit. To fix this, pass access length as a
> function argument. The value of access length is obvious since it is
> used by callers after get_vmx_mem_address() call.
> 
> Signed-off-by: Eugene Korenevsky <ekorenevsky@gmail.com>

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
