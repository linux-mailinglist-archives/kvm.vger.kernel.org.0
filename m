Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B9D2FE13E
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 05:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbhAUDwp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 20 Jan 2021 22:52:45 -0500
Received: from mga04.intel.com ([192.55.52.120]:1611 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404241AbhATXxy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 18:53:54 -0500
IronPort-SDR: 8+fCMBKhjDMKPzvbuMZ+7KKTlmGGlgOaLoIjSmSGy2viZlE8xJy8IlsHFhK7s7GzAw7LPQMzQi
 MVuXGW+yrszg==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="176621898"
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="176621898"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 15:52:55 -0800
IronPort-SDR: c6nnKoz2l45Ksqb09VS82mSX2WhG/mA/oVNADwSqF6BW27PkfxVS0KQqGTFUqHZA1Qbarevg11
 Q6ML7k8KfGpQ==
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="407066955"
Received: from gapoveda-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.79.186])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 15:52:50 -0800
Date:   Thu, 21 Jan 2021 12:52:48 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de, jmattson@google.com,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        corbet@lwn.net
Subject: Re: [RFC PATCH v2 00/26] KVM SGX virtualization support
Message-Id: <20210121125248.ca25483b4fcc732492149b49@intel.com>
In-Reply-To: <YAjALTpv/aDzOalD@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
        <YAaW5FIkRrLGncT5@kernel.org>
        <0adf45fae5207ed3d788bbb7260425f8da7aff43.camel@intel.com>
        <YAjALTpv/aDzOalD@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Jan 2021 01:43:41 +0200 Jarkko Sakkinen wrote:
> On Wed, Jan 20, 2021 at 01:52:32PM +1300, Kai Huang wrote:
> > On Tue, 2021-01-19 at 10:23 +0200, Jarkko Sakkinen wrote:
> > > Can you send a new version that applies:
> > > 
> > > $ git pw series apply 416463
> > > Applying: x86/cpufeatures: Add SGX1 and SGX2 sub-features
> > > Applying: x86/sgx: Remove a warn from sgx_free_epc_page()
> > > Applying: x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()
> > > Applying: x86/sgx: Add SGX_CHILD_PRESENT hardware error code
> > > Applying: x86/sgx: Introduce virtual EPC for use by KVM guests
> > > Applying: x86/cpu/intel: Allow SGX virtualization without Launch Control support
> > > Applying: x86/sgx: Initialize virtual EPC driver even when SGX driver is disabled
> > > error: sha1 information is lacking or useless (arch/x86/kernel/cpu/sgx/main.c).
> > > error: could not build fake ancestor
> > > hint: Use 'git am --show-current-patch=diff' to see the failed patch
> > > Patch failed at 0007 x86/sgx: Initialize virtual EPC driver even when SGX driver is disabled
> > > When you have resolved this problem, run "git am --continue".
> > > If you prefer to skip this patch, run "git am --skip" instead.
> > > To restore the original branch and stop patching, run "git am --abort".
> > 
> > Could you let me know which branch should I rebase to? It appears your linux-sgx tree
> > next branch?
> 
> I tried my tree first, which was actually out-of-sync, so I rebase it.
> You can find it from MAINTAINERS failed.
> 
> After sending this email I rebased it to tip/x86/sgx, which also failed.
> That tree failed with a merge conflict.

This series is based on v5.11-rc3, as mentioned in cover letter below:

> > > This series is based against upstream v5.11-rc3. You can also get the code from
> > > upstream branch of kvm-sgx repo on github:
> > > 
> > >         https://github.com/intel/kvm-sgx.git upstream
> > > 

