Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941EC2F241F
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 01:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391736AbhALAZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 19:25:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:34474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404135AbhAKXdG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 18:33:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05E6C207A3;
        Mon, 11 Jan 2021 23:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610407945;
        bh=LczhwW+N+iznK3dnwTahPQBroL4IYxoj+IRa6zKVDSM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iVviXlREZf/12tTlp0fpybzFaKm1Uga4Xf97sh1jpQLA3Ug9ZW36DEp2Kvu2EV77h
         rssQrLTIMkPVs6V5j4ezgKF5RMVrPL1vciseFdjnGE5KXEw4z+MOl6qLlokqsjPv2+
         jgJ2qmnqscLrxWQrGNi+ThyT87wDuUM3SeW2y2zQ4JMbtLLQF+LQGssBmlCWQheyWs
         hiofYtyj9qj21Nbun8j8JqXHQ4mOPTz0x08/nanJB4OGXeXH84msPx0PnekDlII0rG
         yGWbCttpR0HUuAkY+X0BkRC77SbRgBJBfmyq+Uq9DKDIf9Oy4TzYnpmoYqT+QRro7u
         ZAvgRa0Tdlk2w==
Date:   Tue, 12 Jan 2021 01:32:19 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 02/23] x86/sgx: Add enum for SGX_CHILD_PRESENT error
 code
Message-ID: <X/zgA1F+o4jXYDM/@kernel.org>
References: <cover.1609890536.git.kai.huang@intel.com>
 <2a41e15dfda722dd1e34feeda34ce864cd82361b.1609890536.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a41e15dfda722dd1e34feeda34ce864cd82361b.1609890536.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 06, 2021 at 02:55:19PM +1300, Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> SGX virtualization requires to allocate "raw" EPC and use it as "virtual
> EPC" for SGX guest.  Unlike EPC used by SGX driver, virtual EPC doesn't
> track how EPC pages are used in VM, e.g. (de)construction of enclaves,
> so it cannot guarantee EREMOVE success, e.g. it doesn't have a priori
> knowledge of which pages are SECS with non-zero child counts.
> 
> Add SGX_CHILD_PRESENT for use by SGX virtualization to assert EREMOVE
> failures are expected, but only due to SGX_CHILD_PRESENT.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko
