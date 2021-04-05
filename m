Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED780354846
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 23:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241387AbhDEVrB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 17:47:01 -0400
Received: from mga17.intel.com ([192.55.52.151]:64591 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241284AbhDEVrA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 17:47:00 -0400
IronPort-SDR: /dBplj1ylxTHTMmey/ZaKyEIsoNuPpcFUdsLQAdOt7h+BIJhvse0gIuY16yKL12mzG3/uz+a/c
 9cWqiF4SWkzQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9945"; a="173001649"
X-IronPort-AV: E=Sophos;i="5.81,307,1610438400"; 
   d="scan'208";a="173001649"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2021 14:46:39 -0700
IronPort-SDR: YjOMnsFhrCglXG2g//O3Z+n6Da8xWPYYfk3ApwPh2xIvW2W1JbnuogdzuJ8+jxLd7AtSpTlo3d
 /4KF75vNK+kA==
X-IronPort-AV: E=Sophos;i="5.81,307,1610438400"; 
   d="scan'208";a="457568941"
Received: from lddickin-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.112.181])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2021 14:46:36 -0700
Date:   Tue, 6 Apr 2021 09:46:34 +1200
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 05/25] x86/sgx: Introduce virtual EPC for use by KVM
 guests
Message-Id: <20210406094634.9f5e8c9d6bd2b61690c887cf@intel.com>
In-Reply-To: <20210405090151.GA19485@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
        <0c38ced8c8e5a69872db4d6a1c0dabd01e07cad7.1616136308.git.kai.huang@intel.com>
        <20210405090151.GA19485@zn.tnic>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 5 Apr 2021 11:01:51 +0200 Borislav Petkov wrote:
> On Fri, Mar 19, 2021 at 08:22:21PM +1300, Kai Huang wrote:
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 35391e94bd22..007912f67a06 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -1942,6 +1942,18 @@ config X86_SGX
> >  
> >  	  If unsure, say N.
> >  
> > +config X86_SGX_KVM
> > +	bool "Software Guard eXtensions (SGX) Virtualization"
> > +	depends on X86_SGX && KVM_INTEL
> > +	help
> 
> It seems to me this would fit better under "Virtualization" because even
> if I want to enable it, I have to go enable KVM_INTEL first and then
> return back here to turn it on too.
> 
> And under "Virtualization" is where we enable all kinds of aspects which
> belong to it.

Fine to me. Please let me know if you want me to resend patches. Thanks.
