Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21172FDD90
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 01:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbhATX67 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 18:58:59 -0500
Received: from mga04.intel.com ([192.55.52.120]:64353 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404055AbhATXX6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 18:23:58 -0500
IronPort-SDR: ifgVO9Ic9E6IqS1mATzLF/aym3n35qrVyMV1ZlhWLXmpz5hSLX8XjlgPOwGgoD19H7DX6eBSyZ
 hnCiPt+mv0UQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="176619738"
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="176619738"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 15:23:14 -0800
IronPort-SDR: t34X6Og3oAmwrF1m/oEYbcdZQdrj4DDZUxEHOTb5bV7EnY5btKb0r1/slD57DyPDNwBPWYBooT
 ubDfab+FGLJw==
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="391720531"
Received: from gapoveda-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.79.186])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 15:23:11 -0800
Date:   Thu, 21 Jan 2021 12:23:08 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v2 01/26] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
Message-Id: <20210121122308.8d920c9d652f58824fe87f3e@intel.com>
In-Reply-To: <YAgY9OfYaGj7og/b@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
        <87385f646120a3b5b34dc20480dbce77b8005acd.1610935432.git.kai.huang@intel.com>
        <YAgY9OfYaGj7og/b@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Jan 2021 13:50:12 +0200 Jarkko Sakkinen wrote:
> On Mon, Jan 18, 2021 at 04:26:49PM +1300, Kai Huang wrote:
> > From: Sean Christopherson <seanjc@google.com>
> > 
> > Add SGX1 and SGX2 feature flags, via CPUID.0x12.0x0.EAX, as scattered
> > features.  As part of virtualizing SGX, KVM will expose the SGX CPUID
> > leafs to its guest, and to do so correctly needs to query hardware and
> > kernel support for SGX1 and SGX2.
> 
> This commit message is missing reasoning behind scattered vs. own word.
> 
> Please just document the reasoning, that's all.

OK. Will do. How about:

"Add SGX1 and SGX2 feature flags, via CPUID.0x12.0x0.EAX, as scattered
features, since adding a new leaf for only two bits would be wasteful."

?

> 
> /Jarkko
