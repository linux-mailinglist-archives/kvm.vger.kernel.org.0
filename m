Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB10830CFA6
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 00:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236247AbhBBXHw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 18:07:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236208AbhBBXHs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 18:07:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D94164F6C;
        Tue,  2 Feb 2021 23:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612307227;
        bh=dysKFZ7U/FT2SX5uzP/xNUVyhxwhkaF/+CxiJS8/apo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ACriGb8/U0s/widrwL+j6zvWmsTsKFbJIef+wNFilQWT5PAXDSLz1SnuZ1+dk/PEs
         doS5+1wqU5GdrGf5rVwdPmP7ELqeIN804UEN/tA5WSVoXOG5PY48kpeFM8K3LUljiD
         uf7e6Ylv8/YDEI8W4WXmvhlNtqjZVqbAMtVycDaQm85deiH23labWuITPzqgMHYIMJ
         i5AL4I7OT5RSDLpBfs8Rn+U6F47a1wR6TJ+UtzaFLyPaz08IuoW0hvi6KrzTDFSjcR
         CquaN7s6xBIxAx9K0xhqMX/A5MhZxlN7s+E1vvJKOLnHd1isNY7KNHb+xbYZpP6Z32
         xZ2UiPeZwq4ew==
Date:   Wed, 3 Feb 2021 01:07:00 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, seanjc@google.com,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <YBnbFDgTb5Dd0wDc@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
 <5076ed2c486ac33bfd87dc0e17047a1673692b53.1611634586.git.kai.huang@intel.com>
 <YBVxF2kAl7VzeRPS@kernel.org>
 <20210201184040.646ea9923c2119c205b3378d@intel.com>
 <dc3bc76e-fd89-011d-513b-fac6c6f5e0f0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc3bc76e-fd89-011d-513b-fac6c6f5e0f0@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 01, 2021 at 07:25:41AM -0800, Dave Hansen wrote:
> On 1/31/21 9:40 PM, Kai Huang wrote:
> >>> -	ret = sgx_drv_init();
> >>> +	/* Success if the native *or* virtual EPC driver initialized cleanly. */
> >>> +	ret = !!sgx_drv_init() & !!sgx_vepc_init();
> >> If would create more dumb code and just add
> >>
> >> ret = sgx_vepc_init()
> >> if (ret)
> >>         goto err_kthread;
> 
> Jarkko, I'm not sure I understand this suggestion.

I refined it in my 2nd response to Kai:

https://lore.kernel.org/linux-sgx/YBmMrqxlTxClg9Eb@kernel.org/

/Jarkko
