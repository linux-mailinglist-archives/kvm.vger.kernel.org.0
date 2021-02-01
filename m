Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907E4309FA6
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 01:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhBAASc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 19:18:32 -0500
Received: from mga12.intel.com ([192.55.52.136]:31692 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229474AbhBAASa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 19:18:30 -0500
IronPort-SDR: 9oTPtHX0nBug1sZeVi5mwC58nAkIws/Y831aEG22Okwfx5qiqblTih/e5Qfe1TCJnaNLUsZc6r
 QWmWXEgUfhYw==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="159783799"
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="159783799"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 16:17:48 -0800
IronPort-SDR: nQKZQmx8BhaqgxII/A6CnEVJvdjQ3YXktsem/o22+ucDO16FitrUrhGlVGeZD3FRf1ml2LeKR2
 XqA9jLl45dOA==
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="405400657"
Received: from kpeng-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.130.129])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 16:17:46 -0800
Date:   Mon, 1 Feb 2021 13:17:44 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 14/27] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
Message-Id: <20210201131744.30530bd817ae299df92b8164@intel.com>
In-Reply-To: <YBVyfQQPo18Fyv64@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
        <e807033e3d56ede1177d7a1af34477678bfbfff9.1611634586.git.kai.huang@intel.com>
        <YBVyfQQPo18Fyv64@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 30 Jan 2021 16:51:41 +0200 Jarkko Sakkinen wrote:
> On Tue, Jan 26, 2021 at 10:31:06PM +1300, Kai Huang wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > The bare-metal kernel must intercept ECREATE to be able to impose policies
> > on guests.  When it does this, the bare-metal kernel runs ECREATE against
> > the userspace mapping of the virtualized EPC.
> 
> I guess Andy's earlier comment applies here, i.e. SGX driver?

Sure.

[...]

> > +	}
> > +
> > +	if (encls_faulted(ret)) {
> > +		*trapnr = ENCLS_TRAPNR(ret);
> > +		return -EFAULT;
> > +	}
> 
> Empty line here before return. Applies also to sgx_virt_ecreate().

Yes I can remove, but I am just carious: isn't "having empty line before return"
a good coding-style? Do you have any reference to the guideline?

> 
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(sgx_virt_einit);
> > -- 
> > 2.29.2
> 
> Great work. I think this patch sets is shaping up.
> 
> /Jarkko
> > 
> > 
