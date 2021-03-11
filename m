Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0088336A03
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 03:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbhCKCGK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 21:06:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:11748 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229483AbhCKCFj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 21:05:39 -0500
IronPort-SDR: PQzxYWTbtAXBscr0rfysBe4uRsrZfzcsHs4Uk6UH3YJHuj4RQEka0EGaeliwCl3tJSn14vhrTt
 VRormKLFx2zg==
X-IronPort-AV: E=McAfee;i="6000,8403,9919"; a="188697240"
X-IronPort-AV: E=Sophos;i="5.81,238,1610438400"; 
   d="scan'208";a="188697240"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 18:05:37 -0800
IronPort-SDR: q48dR3kVgGtxcmi9QBxCY9R6f15dk8DY6svngvGn3PyQQE/VcdF1dMSRab+qtGj8dgDMcx1Nv9
 LPn2ICiqJqKw==
X-IronPort-AV: E=Sophos;i="5.81,238,1610438400"; 
   d="scan'208";a="603342257"
Received: from xuhuiliu-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.31.67])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 18:05:32 -0800
Date:   Thu, 11 Mar 2021 15:05:29 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, jethro@fortanix.com,
        b.thiel@posteo.de, jmattson@google.com, joro@8bytes.org,
        vkuznets@redhat.com, wanpengli@tencent.com, corbet@lwn.net
Subject: Re: [PATCH v2 00/25] KVM SGX virtualization support
Message-Id: <20210311150529.4bf07611d074b654297cfd92@intel.com>
In-Reply-To: <20210310132948.GE23521@zn.tnic>
References: <cover.1615250634.git.kai.huang@intel.com>
        <20210309093037.GA699@zn.tnic>
        <76cb4216a7a689883c78b4622c86bd9c3faaa465.camel@intel.com>
        <20210310132948.GE23521@zn.tnic>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 Mar 2021 14:29:48 +0100 Borislav Petkov wrote:
> On Wed, Mar 10, 2021 at 10:27:05PM +1300, Kai Huang wrote:
> > Sorry for the mistake. I will send out another version with that fixed.
> 
> If patch 3 is the only one which needs to change, you can send only that
> one as a reply to the original patch 3 message...
> 
> Thx.

Hi Boris,

Yes it is the only patch needs change. I have send out updated v3 patch 3.

I provided some changelog history to explain and also added Jarkko's Acked-by in
the new patch. Sorry for the trouble.

Hi Sean,

If you see this, could you take another check on whether this series is OK?

Thanks in advance.
