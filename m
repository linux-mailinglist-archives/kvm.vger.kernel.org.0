Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4F52F2418
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 01:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404261AbhALAZo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 11 Jan 2021 19:25:44 -0500
Received: from mga12.intel.com ([192.55.52.136]:62818 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404265AbhALAU3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 19:20:29 -0500
IronPort-SDR: DwR2lQaDFogLqE8ijp8sI3PNfS5jvXGUHNYhsEq5/a5Xvbaoftjtm++xaBIOWjtb66oaL3madS
 JoZSpU57DAoQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="157137541"
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="157137541"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 16:19:48 -0800
IronPort-SDR: aqdBNyn52akoW8rjvnjp++hTANTqiRH7IXlyDIrYsT4y7Jq/9nx53iDsD2wTG0am1aiwYYx1+B
 CDOD6AZ4xOEQ==
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="567336276"
Received: from edelafu-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.142.150])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 16:19:45 -0800
Date:   Tue, 12 Jan 2021 13:19:44 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 01/23] x86/sgx: Split out adding EPC page to free
 list to separate helper
Message-Id: <20210112131944.9d69bb30cf4b94b6f6f25e7b@intel.com>
In-Reply-To: <31681b840aac59a8d8dcb05f2356d25cf09e1f11.camel@kernel.org>
References: <cover.1609890536.git.kai.huang@intel.com>
        <3d50c2614ff8a46b44062a398fd8644bcda92132.1609890536.git.kai.huang@intel.com>
        <31681b840aac59a8d8dcb05f2356d25cf09e1f11.camel@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Jan 2021 00:38:40 +0200 Jarkko Sakkinen wrote:
> On Wed, 2021-01-06 at 14:55 +1300, Kai Huang wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > SGX virtualization requires to allocate "raw" EPC and use it as virtual
> > EPC for SGX guest.  Unlike EPC used by SGX driver, virtual EPC doesn't
> > track how EPC pages are used in VM, e.g. (de)construction of enclaves,
> > so it cannot guarantee EREMOVE success, e.g. it doesn't have a priori
> > knowledge of which pages are SECS with non-zero child counts.
> > 
> > Split sgx_free_page() into two parts so that the "add to free list"
> > part can be used by virtual EPC without having to modify the EREMOVE
> > logic in sgx_free_page().
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> 
> I have a better idea with the same outcome for KVM.
> 
> https://lore.kernel.org/linux-sgx/20210111223610.62261-1-jarkko@kernel.org/T/#t

I agree with your patch this one can be replaced. I'll include your patch in
next version, and once it is upstreamed, it can be removed in my series.

Sean, please let me know if you have objection.
