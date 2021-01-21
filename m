Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB142FDEF8
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 02:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392471AbhAUBnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 20:43:20 -0500
Received: from mga12.intel.com ([192.55.52.136]:57010 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390754AbhAUBhr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 20:37:47 -0500
IronPort-SDR: xqo1JEPTO7yEyDg7DqwCURnhXhOLs9tjWUdxxc1HyqV+UwWAjXNwhMWFWia9GlMwGgOORZkCcn
 +vw3nb+enzHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="158382299"
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="158382299"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 17:27:20 -0800
IronPort-SDR: fWiVD6edd3L5SqsIbylInXxtQRP4YHz3wC83r4V9Ex7EzmCzUR4MSdsB8qwxt2zXnu8uPRjIDX
 rkbzEzm/pgwQ==
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="467276424"
Received: from gapoveda-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.79.186])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 17:27:15 -0800
Date:   Thu, 21 Jan 2021 14:27:13 +1300
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
Message-Id: <20210121142713.7738ed255764766a1e5b9c1a@intel.com>
In-Reply-To: <YAjV47B0+HLAgMVc@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
        <YAaW5FIkRrLGncT5@kernel.org>
        <0adf45fae5207ed3d788bbb7260425f8da7aff43.camel@intel.com>
        <YAjALTpv/aDzOalD@kernel.org>
        <20210121125248.ca25483b4fcc732492149b49@intel.com>
        <YAjV47B0+HLAgMVc@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Jan 2021 03:16:19 +0200 Jarkko Sakkinen wrote:
> On Thu, Jan 21, 2021 at 12:52:48PM +1300, Kai Huang wrote:
> > On Thu, 21 Jan 2021 01:43:41 +0200 Jarkko Sakkinen wrote:
> > > On Wed, Jan 20, 2021 at 01:52:32PM +1300, Kai Huang wrote:
> > > > On Tue, 2021-01-19 at 10:23 +0200, Jarkko Sakkinen wrote:
> > > > > Can you send a new version that applies:
> > > > > 
> > > > > $ git pw series apply 416463
> > > > > Applying: x86/cpufeatures: Add SGX1 and SGX2 sub-features
> > > > > Applying: x86/sgx: Remove a warn from sgx_free_epc_page()
> > > > > Applying: x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()
> > > > > Applying: x86/sgx: Add SGX_CHILD_PRESENT hardware error code
> > > > > Applying: x86/sgx: Introduce virtual EPC for use by KVM guests
> > > > > Applying: x86/cpu/intel: Allow SGX virtualization without Launch Control support
> > > > > Applying: x86/sgx: Initialize virtual EPC driver even when SGX driver is disabled
> > > > > error: sha1 information is lacking or useless (arch/x86/kernel/cpu/sgx/main.c).
> > > > > error: could not build fake ancestor
> > > > > hint: Use 'git am --show-current-patch=diff' to see the failed patch
> > > > > Patch failed at 0007 x86/sgx: Initialize virtual EPC driver even when SGX driver is disabled
> > > > > When you have resolved this problem, run "git am --continue".
> > > > > If you prefer to skip this patch, run "git am --skip" instead.
> > > > > To restore the original branch and stop patching, run "git am --abort".
> > > > 
> > > > Could you let me know which branch should I rebase to? It appears your linux-sgx tree
> > > > next branch?
> > > 
> > > I tried my tree first, which was actually out-of-sync, so I rebase it.
> > > You can find it from MAINTAINERS failed.
> > > 
> > > After sending this email I rebased it to tip/x86/sgx, which also failed.
> > > That tree failed with a merge conflict.
> > 
> > This series is based on v5.11-rc3, as mentioned in cover letter below:
> 
> Please use tip/x86/sgx as base instead.

When I wrote this series, the tip/x86/sgx was still v5.10-rc4. I felt I should
rebase to some newer code, so I chose upstream v5.11-rc3.

I just checked the latest tip/x86/sgx, and it has updated to v5.11-rc3, so
yes I will rebase to it for next version.

> 
> /Jarkko
> > 
