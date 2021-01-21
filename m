Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0D72FDEAF
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 02:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732498AbhAUBT3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 20:19:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391964AbhAUBKF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 20:10:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4EFF2388A;
        Thu, 21 Jan 2021 01:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611191364;
        bh=TsBJwLSX5vV9/b4Cr5dU5LvIyhJs07AuF7QbD4KCc3Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XTBP4ObYCpPSgJ7h4hFc8g+vv3mq8+ky8J1u0i/EwIqS54LvDy0rueIR2mxleO6ht
         ge/xkdgnmG6mQV8CR9GbiYL5K14ITru/Iw7ne521tML3pDyh0toJWGwJy5KOS7rncZ
         ha7muMO8ziM18q+/0Amgs9EOYJ9tzfhszdmzrmlce+vlZed0BrpHgQXtgnoRj94wAV
         H62J+x9I35CPmvPFy/337eYNOVZGhTLIXuH8z2MVhTxe2KRZijLu2SolWviKdLJGq0
         AdNm5gUiLpJhNeXSDh7iKYR3UgvTwSpzzVQ4h4Uxkc2C+3BBt8qtas2IPVRddrec2X
         WKV0r2Jd59iaA==
Date:   Thu, 21 Jan 2021 03:09:18 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, seanjc@google.com,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v2 12/26] x86/sgx: Add helper to update
 SGX_LEPUBKEYHASHn MSRs
Message-ID: <YAjUPmnUQVG/e/n4@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
 <5116fdc732e8e14b3378c44e3b461a43f330ed0c.1610935432.git.kai.huang@intel.com>
 <YAgcIhkmw0lllD3G@kernel.org>
 <8613b3f1-c4f6-3e5d-4406-9476727666a7@intel.com>
 <20210121123625.c45deeccc690138f2417bd41@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121123625.c45deeccc690138f2417bd41@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 21, 2021 at 12:36:25PM +1300, Kai Huang wrote:
> On Wed, 20 Jan 2021 10:36:09 -0800 Dave Hansen wrote:
> > On 1/20/21 4:03 AM, Jarkko Sakkinen wrote:
> > >> +void sgx_update_lepubkeyhash(u64 *lepubkeyhash)
> > >> +{
> > >> +	int i;
> > >> +
> > >> +	for (i = 0; i < 4; i++)
> > >> +		wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + i, lepubkeyhash[i]);
> > >> +}
> > > Missing kdoc.
> > 
> > I dunno... kdoc is nice, but I'm not sure its verbosity is useful here,
> > even if this function is called from more than one .c file.
> > 
> > I'd be happy with a single-line comment, personally.
> > 
> 
> I actually feel the function name already explains what the function does
> clearly, therefore I don't think even comment is needed. To be honest I
> don't know how to rephrase here. Perhaps:
> 
> /* Update SGX LEPUBKEYHASH MSRs of the platform. */
> 
> ? 

WFM, thanks.

/Jarkko
