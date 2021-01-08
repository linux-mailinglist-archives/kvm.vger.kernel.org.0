Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C53C2EEB29
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 03:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbhAHCBG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 21:01:06 -0500
Received: from mga03.intel.com ([134.134.136.65]:32730 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbhAHCBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 21:01:06 -0500
IronPort-SDR: ue4iHAPFdj3m8K1igI30hUiPluCw2qqc6UT0mJ9ffcuQMNyXM7mwu3UE3W9NOi6Oukq3zdnaqM
 EcciZ/nV8xbA==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="177626024"
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="177626024"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 18:00:24 -0800
IronPort-SDR: yp0q0nJyozzexDhi3krb63g6yCfKK9B9HugTtW5xLheeReFFR3cc1nhMvNyV5CigUWELyhRUw5
 caZcCVr/0fiw==
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="396160826"
Received: from culloa-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.116.170])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 18:00:21 -0800
Date:   Fri, 8 Jan 2021 15:00:18 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
Message-Id: <20210108150018.7a8c2e2fb442c9c68b0aa624@intel.com>
In-Reply-To: <20210107064125.GB14697@zn.tnic>
References: <cover.1609890536.git.kai.huang@intel.com>
        <381b25a0dc0ed3e4579d50efb3634329132a2c02.1609890536.git.kai.huang@intel.com>
        <20210106221527.GB24607@zn.tnic>
        <20210107120946.ef5bae4961d0be91eff56d6b@intel.com>
        <20210107064125.GB14697@zn.tnic>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 7 Jan 2021 07:41:25 +0100 Borislav Petkov wrote:
> On Thu, Jan 07, 2021 at 12:09:46PM +1300, Kai Huang wrote:
> > There's no urgent request to support them for now (and given basic SGX
> > virtualization is not in upstream), but I don't know whether they need to be
> > supported in the future.
> 
> If that is the case, then wasting a whole leaf for two bits doesn't make
> too much sense. And it looks like the kvm reverse lookup can be taught
> to deal with composing that leaf dynamically when needed instead.

I am not sure changing reverse lookup to handle dynamic would be acceptable. To
me it is ugly, and I don't have a first glance on how to do it. KVM can query
host CPUID when dealing with SGX w/o X86_FEATURE_SGX1/2, but it is not as
straightforward as having X86_FEATURE_SGX1/2.

And as Sean pointed out, SGX1 bit is also needed by both SGX driver and
init_ia32_feat_ctl():

	https://www.spinics.net/lists/kvm/msg231973.html

So having it would make things easier.

And regarding to other bits of this leaf, to me: 1) we cannot rule out
possibility that bit 5 and bit 6 will be supported in the future; 2) I cannot
talk more but we cannot rule out the possibility that there will be other bits
introduced in the future.

Sean, what do you think?

> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
