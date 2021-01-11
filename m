Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA792F241D
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 01:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391744AbhALAZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 19:25:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:34990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404156AbhAKXk2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 18:40:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F4DC22BED;
        Mon, 11 Jan 2021 23:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610408388;
        bh=dNmrDsC5PxO7bdfSFOWNbTzoFbFJ4ZZfac8V0oRay0w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ovIAK6O0yaI6dm9zEn0OrxPSJ2dFXgOlC1k+XOzaiwNMsHogWwomRYKyPb+MhScqI
         upKDpZsxBuyeRzNskDCkX5jVfjQFPtrzIRjleLkBm8jjpFJjerDaZMxxJLrC9GtzZl
         ToUBe1nEb0wbrFrdzgXj7q+PueL8Vku/zkm+3ImOFqr/QVenhAYVPUxZa62k2JBeXE
         DMPbNMmh4+syoKr8mVlBs5ROsGaA2Upy5rhC+2V7BLzSHFfpPpV5dodvlwgbtEF32P
         2H8zEW8vO9M3mvuqYlYspK+97eR2jMzlqL4vWA1eFEvNrprhSs8uoj6utqMgHfFoME
         CMGkWW6PIfeTw==
Date:   Tue, 12 Jan 2021 01:39:42 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <X/zhvoSlx1IL5wb/@kernel.org>
References: <cover.1609890536.git.kai.huang@intel.com>
 <381b25a0dc0ed3e4579d50efb3634329132a2c02.1609890536.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <381b25a0dc0ed3e4579d50efb3634329132a2c02.1609890536.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 06, 2021 at 02:55:21PM +1300, Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Add a feature word to hold SGX features enumerated via CPUID.0x12.0x0,
> along with flags for SGX1 and SGX2. As part of virtualizing SGX, KVM
> needs to expose the SGX CPUID leafs to its guest. SGX1 and SGX2 need to
> be in a dedicated feature word so that they can be queried via KVM's
> reverse CPUID lookup to properly emulate the expected guest behavior.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>  [Kai: Also clear SGX1 and SGX2 bits in clear_sgx_caps().]
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko
