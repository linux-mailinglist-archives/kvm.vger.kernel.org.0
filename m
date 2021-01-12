Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A292F241A
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 01:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391752AbhALAZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 19:25:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:25703 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404258AbhALARk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 19:17:40 -0500
IronPort-SDR: d4eeKbSErggpqqX/dyteihgQy7nSPXN5fGB6puobsrpDX2+u3cXz4YBPqR1+4f0RVkDRMNzX1Z
 YWwew6NwpP9A==
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="178108225"
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="178108225"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 16:16:59 -0800
IronPort-SDR: V/rdT/NpX14Em9VdfUh0lvAbfZYGr4tsWdhdV4aVd2g6hdhEYRz1MXLhaVC9DZY9ACUPVA5v5P
 xPmscapQictw==
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="397194345"
Received: from edelafu-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.142.150])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 16:16:55 -0800
Date:   Tue, 12 Jan 2021 13:16:53 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 02/23] x86/sgx: Add enum for SGX_CHILD_PRESENT error
 code
Message-Id: <20210112131653.d8150b795dc64e0add0e809f@intel.com>
In-Reply-To: <X/zgA1F+o4jXYDM/@kernel.org>
References: <cover.1609890536.git.kai.huang@intel.com>
        <2a41e15dfda722dd1e34feeda34ce864cd82361b.1609890536.git.kai.huang@intel.com>
        <X/zgA1F+o4jXYDM/@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Jan 2021 01:32:19 +0200 Jarkko Sakkinen wrote:
> On Wed, Jan 06, 2021 at 02:55:19PM +1300, Kai Huang wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > SGX virtualization requires to allocate "raw" EPC and use it as "virtual
> > EPC" for SGX guest.  Unlike EPC used by SGX driver, virtual EPC doesn't
> > track how EPC pages are used in VM, e.g. (de)construction of enclaves,
> > so it cannot guarantee EREMOVE success, e.g. it doesn't have a priori
> > knowledge of which pages are SECS with non-zero child counts.
> > 
> > Add SGX_CHILD_PRESENT for use by SGX virtualization to assert EREMOVE
> > failures are expected, but only due to SGX_CHILD_PRESENT.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> 
> Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

Thanks Jarkko. 

Dave suggested to change patch subject to explicitly call out hardware error
code:
	Add SGX_CHILD_PRESENT hardware error code

I suppose this also works for you, and I can have your Acked-by after I changed
that in v2?

Thanks,
-Kai
