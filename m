Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE1F2F22F2
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 23:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389544AbhAKWj0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 17:39:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:57356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727019AbhAKWjZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 17:39:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B207B22288;
        Mon, 11 Jan 2021 22:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610404725;
        bh=0lwuzx6//6aWaeU/bHiIYY0N6Mk6I3xVSjTVmPofC00=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=o0LWWgA6IhXv79v5uKIpX/wKBsn2OHYLJzfD5gPUs+ODAG42mImSMrSddnlAVoLWY
         B3oNcimJbSOIvz6IiHSdaseGT2MV9FLBuaCJ+4+IMocOsQRtQPsWdVUOqBVd2H9/da
         J+lrAT46QqKdhFg2pNVse9izRaTT3dTw5l78/TkCcEzXaY8MuUjJCt6iflKFWMYBg5
         0gZj0NvNMlAJu6lUzvo4nyP09X8Ko/7V2eqwojAn2HQ8J8RY7g7VZPcH8UhZt0wwet
         Aiaz4t+K/euP0+7lqgdM8POWK/LFBU6d6oupfUTnzdaVaRefgDUGG7icoMEh1mBnqx
         aaelhsSsgu0EA==
Message-ID: <31681b840aac59a8d8dcb05f2356d25cf09e1f11.camel@kernel.org>
Subject: Re: [RFC PATCH 01/23] x86/sgx: Split out adding EPC page to free
 list to separate helper
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Date:   Tue, 12 Jan 2021 00:38:40 +0200
In-Reply-To: <3d50c2614ff8a46b44062a398fd8644bcda92132.1609890536.git.kai.huang@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
         <3d50c2614ff8a46b44062a398fd8644bcda92132.1609890536.git.kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (by Flathub.org) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-01-06 at 14:55 +1300, Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> SGX virtualization requires to allocate "raw" EPC and use it as virtual
> EPC for SGX guest.  Unlike EPC used by SGX driver, virtual EPC doesn't
> track how EPC pages are used in VM, e.g. (de)construction of enclaves,
> so it cannot guarantee EREMOVE success, e.g. it doesn't have a priori
> knowledge of which pages are SECS with non-zero child counts.
> 
> Split sgx_free_page() into two parts so that the "add to free list"
> part can be used by virtual EPC without having to modify the EREMOVE
> logic in sgx_free_page().
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>

I have a better idea with the same outcome for KVM.

https://lore.kernel.org/linux-sgx/20210111223610.62261-1-jarkko@kernel.org/T/#t

/Jarkko

