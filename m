Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6975C2EC724
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 00:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbhAFX5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 18:57:42 -0500
Received: from mga06.intel.com ([134.134.136.31]:1285 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbhAFX5m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 18:57:42 -0500
IronPort-SDR: 66bYN2oTbOl0dFAA7UKuBbZUSMyxB0WmFCACXIcPlJTSLrv85pwu7xQ7wsPRgcpIhmvGce0pr5
 nrgEmulSVJdQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="238899164"
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="238899164"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 15:57:01 -0800
IronPort-SDR: g4FDFOZy7psnmwziEKb6eLjtqYPpBG1kXMORxBAZovBQxBvNWdhnfFHEHlaHcj+5vXyrMIV+JS
 udmQ24gyZbNw==
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="422360791"
Received: from vastrong-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.243])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 15:56:58 -0800
Date:   Thu, 7 Jan 2021 12:56:57 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     <linux-sgx@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <seanjc@google.com>, <jarkko@kernel.org>,
        <luto@kernel.org>, <haitao.huang@intel.com>, <pbonzini@redhat.com>,
        <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
Message-Id: <20210107125657.27ebe6c9cd1e0053ba73f63e@intel.com>
In-Reply-To: <a522e1cf-ccb9-bfbb-c3da-abe51422046e@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
        <381b25a0dc0ed3e4579d50efb3634329132a2c02.1609890536.git.kai.huang@intel.com>
        <6d28e858-a5c0-6ce8-8c0d-2fdfbea3734b@intel.com>
        <20210107111206.c8207e64540a8361c04259b7@intel.com>
        <b3e11134-cd8e-2b51-1363-58898832ba38@intel.com>
        <20210107124037.c37b313b016514c361c7f49e@intel.com>
        <a522e1cf-ccb9-bfbb-c3da-abe51422046e@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 6 Jan 2021 15:43:54 -0800 Dave Hansen wrote:
> On 1/6/21 3:40 PM, Kai Huang wrote:
> > So a better way is to put "Allow SGX virtualization without Launch Control
> > Support" at the beginning of this series? If so, the Kconfig
> > X86_SGX_VIRTUALIZATION needs to be in separate patch at the very beginning.
> > 
> > Does above make sense? 
> 
> I think it's worth trying.  No promises that anyone will like the end
> result, but give it a shot and I'll take a look.

OK I'll try in next version. Thanks.
