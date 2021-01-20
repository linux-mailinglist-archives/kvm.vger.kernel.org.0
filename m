Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9E12FE150
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 06:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbhAUDvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 22:51:50 -0500
Received: from mga05.intel.com ([192.55.52.43]:2613 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388654AbhATXt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 18:49:26 -0500
IronPort-SDR: Rc1ysZKafz5YsI+c8MpLliL5+YKxUfXkubGPQS5q0h1wd+XIaDoadY2In1BdvIxyyD9OSGm/5H
 Sh2HD+S94AFw==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="264006783"
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="264006783"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 15:48:36 -0800
IronPort-SDR: cBRq6EAOaFq8mFCca9V0wIrx/PMa9vz2vg5KHTsWCgO+aFvXiz7A1MDimMRkV0EI0efW9ZILuI
 bKUIGaIjlHmw==
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="407066390"
Received: from gapoveda-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.79.186])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 15:48:32 -0800
Date:   Thu, 21 Jan 2021 12:48:30 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        <linux-sgx@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <jarkko@kernel.org>, <luto@kernel.org>,
        <haitao.huang@intel.com>, <pbonzini@redhat.com>, <bp@alien8.de>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <jethro@fortanix.com>, <b.thiel@posteo.de>
Subject: Re: [RFC PATCH v2 06/26] x86/cpu/intel: Allow SGX virtualization
 without Launch Control support
Message-Id: <20210121124830.3cb323c5ead91800645c912a@intel.com>
In-Reply-To: <666e0995-cf08-1ed9-20b2-f64d1ce64c20@intel.com>
References: <cover.1610935432.git.kai.huang@intel.com>
        <a6c0b0d2632a6c603e68d9bdc81f564290ff04ad.1610935432.git.kai.huang@intel.com>
        <bc73adaf-fae6-2088-c8d4-6f53057a4eac@intel.com>
        <YAiwhdcOknqTJihk@google.com>
        <666e0995-cf08-1ed9-20b2-f64d1ce64c20@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Jan 2021 15:27:27 -0800 Dave Hansen wrote:
> On 1/20/21 2:36 PM, Sean Christopherson wrote:
> > On Wed, Jan 20, 2021, Dave Hansen wrote:
> >> BTW, CONFIG_X86_SGX_VIRTUALIZATION is a pretty porky name.  Maybe just
> >> CONFIG_X86_SGX_VIRT?
> > Mmm, bacon.  I used the full "virtualization" to avoid any possible confusion
> > with virtual memory.  The existing sgx_get_epc_virt_addr() in particular gave me
> > pause.
> > 
> > I agree it's long and not consistent since other code in this series uses "virt".
> > My thinking was that most shortand versions, e.g. virt_epc, would be used only
> > in contexts that are already fairly obvious to be KVM/virtualization related,
> > whereas the porcine Kconfig would help establish that context.
> 
> Not a big deal either way.  I agree that "virt" can be confusing.
> 
> Considering that:
> 
> +config X86_SGX_VIRTUALIZATION
> +	depends on ... KVM_INTEL

It is already in patch 3: Introduce virtual EPC for use by KVM guests:

+config X86_SGX_VIRTUALIZATION
+	bool "Software Guard eXtensions (SGX) Virtualization"
+	depends on X86_SGX && KVM_INTEL

> 
> Calling it X86_SGX_KVM doesn't seem horrible either.

