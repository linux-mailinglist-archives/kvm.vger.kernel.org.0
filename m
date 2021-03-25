Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F994348D23
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 10:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhCYJim (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 05:38:42 -0400
Received: from mga17.intel.com ([192.55.52.151]:18947 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230094AbhCYJiT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 05:38:19 -0400
IronPort-SDR: SGauGk6ApO6mi6JkjJt1DZGOTWMx0j2h9H+EyH7SZzO2EU70DO3rEmE3Gn56OMGv98rLnCXTYs
 RUlUKqABn4Ww==
X-IronPort-AV: E=McAfee;i="6000,8403,9933"; a="170870908"
X-IronPort-AV: E=Sophos;i="5.81,277,1610438400"; 
   d="scan'208";a="170870908"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 02:38:18 -0700
IronPort-SDR: tA3Bge5c+pwXbvzz43HtmiT5cWh/fKRQlTCMjbwrkGQ7hfNQM1UqRp8rrT99TOVSqKYZi0DaqP
 EmvueFcSl1kQ==
X-IronPort-AV: E=Sophos;i="5.81,277,1610438400"; 
   d="scan'208";a="443326428"
Received: from phanl-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.4.149])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 02:38:15 -0700
Date:   Thu, 25 Mar 2021 22:38:13 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-Id: <20210325223813.2397c0f3f035fbc2b809d558@intel.com>
In-Reply-To: <20210325084241.GA31322@zn.tnic>
References: <20210323121643.e06403a1bc7819bab7c15d95@intel.com>
        <YFoNCvBYS2lIYjjc@google.com>
        <20210323160604.GB4729@zn.tnic>
        <YFoVmxIFjGpqM6Bk@google.com>
        <20210323163258.GC4729@zn.tnic>
        <b35f66a10ecc07a1eecb829912d5664886ca169b.camel@intel.com>
        <236c0aa9-92f2-97c8-ab11-d55b9a98c931@redhat.com>
        <20210325122343.008120ef70c1a1b16b5657ca@intel.com>
        <8e833f7c-ea24-1044-4c69-780a84b47ce1@redhat.com>
        <20210325124611.a9dce500b0bcbb1836580719@intel.com>
        <20210325084241.GA31322@zn.tnic>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 25 Mar 2021 09:42:41 +0100 Borislav Petkov wrote:
> ... so you could send the final version of this patch as a reply to this
> thread, now that everyone agrees, so that I can continue going through
> the rest.
> 

I have sent it by replying to this patch.

[PATCH v4 03/25] x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()

Btw, with this patch being changed, I think there's a place in patch 5 should
also be changed. I have replied patch 5. Please take a look.

Thanks.
