Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDFA2EEEFF
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 10:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbhAHJAr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 04:00:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:11197 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727286AbhAHJAq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 04:00:46 -0500
IronPort-SDR: awTrkyWPiNliTxyG4l6j9lcln72LUiyv1kHDwy8KjPeUk+ggo/4zGmTcguRgkJgGgl/WJxzqdL
 rQHjpOyxVdkQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="164642387"
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="164642387"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 01:00:05 -0800
IronPort-SDR: 78ypFUMbKI5A6TjcTXMrkErNJSQ1WY9D9IEvANbvCktQAAljBYTXtVnEfty/AUZbNbb9XjCGdH
 u/Ubf6A2uysA==
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="362278507"
Received: from sspraker-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.3.60])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 01:00:02 -0800
Date:   Fri, 8 Jan 2021 22:00:00 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, seanjc@google.com,
        jarkko@kernel.org, luto@kernel.org, haitao.huang@intel.com,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
Message-Id: <20210108220000.e321c2cbb1faeac610722274@intel.com>
In-Reply-To: <20210108081314.GC4042@zn.tnic>
References: <cover.1609890536.git.kai.huang@intel.com>
        <381b25a0dc0ed3e4579d50efb3634329132a2c02.1609890536.git.kai.huang@intel.com>
        <20210106221527.GB24607@zn.tnic>
        <20210107120946.ef5bae4961d0be91eff56d6b@intel.com>
        <20210107064125.GB14697@zn.tnic>
        <20210108150018.7a8c2e2fb442c9c68b0aa624@intel.com>
        <a0f75623-b0ce-bf19-4678-0f3e94a3a828@intel.com>
        <20210108200350.7ba93b8cd19978fe27da74af@intel.com>
        <20210108071722.GA4042@zn.tnic>
        <20210108210647.40ecb8233f0387578cb0d45a@intel.com>
        <20210108081314.GC4042@zn.tnic>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 8 Jan 2021 09:13:14 +0100 Borislav Petkov wrote:
> On Fri, Jan 08, 2021 at 09:06:47PM +1300, Kai Huang wrote:
> > No offence, but using synthetic bits is a little bit hack to me,given
> > they are actually hardware feature bits.
> 
> Why?
> 
> Perhaps you need to have a look at Documentation/x86/cpuinfo.rst first.

Will take a look. Thanks.

> 
> > And using synthetic leaf in reverse lookup is against current KVM
> > code.
> 
> You know how the kernel gets improved each day and old limitations are
> not valid anymore?
> 
> > I'll try my own  way in next version, but thank you for the insight! :)
> 
> Feel free but remember to keep it simple. You can use mine too, if you
> want to, as long as you attribute it with a Suggested-by or so.

OK. Thanks. 

> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
