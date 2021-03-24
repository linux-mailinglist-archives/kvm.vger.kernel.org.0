Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4637034857A
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 00:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbhCXXqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 19:46:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:28668 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231776AbhCXXqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 19:46:23 -0400
IronPort-SDR: 0yg8jhW3/RFc/VbixZ+UKiADnCC3pIzA0qitYI9xlCfmcwEKgaicEKdbdeajQsZ11QVyC1PmCd
 ukLXgo4jiMLw==
X-IronPort-AV: E=McAfee;i="6000,8403,9933"; a="187510834"
X-IronPort-AV: E=Sophos;i="5.81,276,1610438400"; 
   d="scan'208";a="187510834"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 16:46:18 -0700
IronPort-SDR: becDvmU/sSYGsrDcxsDl7XVDu+9fsoD3ntXwYljT3NnLts/iltaKLJpB26YfXpxhfweFL75bwR
 0BGShzVGylpg==
X-IronPort-AV: E=Sophos;i="5.81,276,1610438400"; 
   d="scan'208";a="409080256"
Received: from prdubey-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.226])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 16:46:14 -0700
Date:   Thu, 25 Mar 2021 12:46:11 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-Id: <20210325124611.a9dce500b0bcbb1836580719@intel.com>
In-Reply-To: <8e833f7c-ea24-1044-4c69-780a84b47ce1@redhat.com>
References: <YFjoZQwB7e3oQW8l@google.com>
        <20210322191540.GH6481@zn.tnic>
        <YFjx3vixDURClgcb@google.com>
        <20210322210645.GI6481@zn.tnic>
        <20210323110643.f29e214ebe8ec7a4a3d0bc2e@intel.com>
        <20210322223726.GJ6481@zn.tnic>
        <20210323121643.e06403a1bc7819bab7c15d95@intel.com>
        <YFoNCvBYS2lIYjjc@google.com>
        <20210323160604.GB4729@zn.tnic>
        <YFoVmxIFjGpqM6Bk@google.com>
        <20210323163258.GC4729@zn.tnic>
        <b35f66a10ecc07a1eecb829912d5664886ca169b.camel@intel.com>
        <236c0aa9-92f2-97c8-ab11-d55b9a98c931@redhat.com>
        <20210325122343.008120ef70c1a1b16b5657ca@intel.com>
        <8e833f7c-ea24-1044-4c69-780a84b47ce1@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 25 Mar 2021 00:39:01 +0100 Paolo Bonzini wrote:
> On 25/03/21 00:23, Kai Huang wrote:
> > I changed to below (with slight modification on Paolo's):
> > 
> > /* Error message for EREMOVE failure, when kernel is about to leak EPC page */
> > #define EREMOVE_ERROR_MESSAGE \
> >          "EREMOVE returned %d (0x%x) and an EPC page was leaked.  SGX may become unusuable.  " \
> >          "This is likely a kernel bug.  Refer to Documentation/x86/sgx.rst for more information."
> > 
> > I got a checkpatch warning however:
> > 
> > WARNING: It's generally not useful to have the filename in the file
> > #60: FILE: Documentation/x86/sgx.rst:223:
> > +This is likely a kernel bug.  Refer to Documentation/x86/sgx.rst for more
> 
> Yeah, this is more or less a false positive.
> 
> Paolo
> 

Thanks.
