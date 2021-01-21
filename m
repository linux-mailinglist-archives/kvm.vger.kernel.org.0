Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CA72FDE86
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 02:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732891AbhAUBKu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 20:10:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:44008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728272AbhAUBCG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 20:02:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CF6B23437;
        Thu, 21 Jan 2021 01:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611190884;
        bh=1gZWAcYhuLStfT0U84gO3DtfjvuA92+Un7OrbpYsL9I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jpdRuSTFa/BsMAyCzJanjfgEUM0mvRdRloRI9Zb8l7bVNBuuC5XTCDa1gqZZhrH7I
         oza0dtv2J8JdcGZSgBnVfLni65igapZEuuaWvo8p5YELGajZ7yM2pskhAVRAfwvvbj
         BxPhRXfbD05FX3yNSFh+DqTGY8Eq6kBjRzi03wa/GFgDrFDJtaif06Qp7VAUZ3vJGA
         yseQkuJCGU0+m4uhd4jRdf41Ba5cQdb+G/lfFW7X+LEYfTSd3zVx4r2z2+MSqX7oO8
         V46sIraxqgXcl0QjAZkZ5OaTkjNz0SBCcFP8stp/l8eFPOk/086GqYs5+rtElYjNoK
         6G6XLP7Yuwg8w==
Date:   Thu, 21 Jan 2021 03:01:19 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v2 01/26] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
Message-ID: <YAjSX7KGLjPtS/kK@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
 <87385f646120a3b5b34dc20480dbce77b8005acd.1610935432.git.kai.huang@intel.com>
 <YAgY9OfYaGj7og/b@kernel.org>
 <20210121122308.8d920c9d652f58824fe87f3e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121122308.8d920c9d652f58824fe87f3e@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 21, 2021 at 12:23:08PM +1300, Kai Huang wrote:
> On Wed, 20 Jan 2021 13:50:12 +0200 Jarkko Sakkinen wrote:
> > On Mon, Jan 18, 2021 at 04:26:49PM +1300, Kai Huang wrote:
> > > From: Sean Christopherson <seanjc@google.com>
> > > 
> > > Add SGX1 and SGX2 feature flags, via CPUID.0x12.0x0.EAX, as scattered
> > > features.  As part of virtualizing SGX, KVM will expose the SGX CPUID
> > > leafs to its guest, and to do so correctly needs to query hardware and
> > > kernel support for SGX1 and SGX2.
> > 
> > This commit message is missing reasoning behind scattered vs. own word.
> > 
> > Please just document the reasoning, that's all.
> 
> OK. Will do. How about:
> 
> "Add SGX1 and SGX2 feature flags, via CPUID.0x12.0x0.EAX, as scattered
> features, since adding a new leaf for only two bits would be wasteful."

For *me*, that would be sufficient.

/Jarkko
