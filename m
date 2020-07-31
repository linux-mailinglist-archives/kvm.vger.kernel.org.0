Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B18234C16
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 22:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgGaUTB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 16:19:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:64834 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbgGaUTA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 16:19:00 -0400
IronPort-SDR: 50ZpE8OUBX0TbR3nvUkFYm3kbvAqFcN423ea9e+ptSWqbXB4qEOwUHW/2OlLAH4zaxD+w6zyTK
 Ussyyr3MZ9lw==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="149680778"
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="149680778"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 13:19:00 -0700
IronPort-SDR: AHScc4we9f3xmnrVWCpGy6chHo2SgIpdsMNe++sadmbTPNfMwOIXtrXLWmsIs4EEqewv1QRi+c
 OYszwsewJKow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="274592037"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga008.fm.intel.com with ESMTP; 31 Jul 2020 13:18:59 -0700
Date:   Fri, 31 Jul 2020 13:18:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: Fix sev_pin_memory() error handling
Message-ID: <20200731201859.GF31451@linux.intel.com>
References: <20200714142351.GA315374@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714142351.GA315374@mwanda>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 05:23:51PM +0300, Dan Carpenter wrote:
> The sev_pin_memory() function was modified to return error pointers
> instead of NULL but there are two problems.  The first problem is that
> if "npages" is zero then it still returns NULL.  Secondly, several of
> the callers were not updated to check for error pointers instead of
> NULL.
> 
> Either one of these issues will lead to an Oops.
> 
> Fixes: a8d908b5873c ("KVM: x86: report sev_pin_memory errors with PTR_ERR")

Explicit Cc: to stable needed for KVM patches.

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
