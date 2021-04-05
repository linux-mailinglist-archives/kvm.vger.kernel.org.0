Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B496A353DB9
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 12:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237321AbhDEJCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 05:02:13 -0400
Received: from mail.skyhub.de ([5.9.137.197]:39614 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237330AbhDEJCD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 05:02:03 -0400
Received: from zn.tnic (p200300ec2f079d00575c2839e9904d54.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:9d00:575c:2839:e990:4d54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 45B221EC030E;
        Mon,  5 Apr 2021 11:01:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617613315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=kajZw9OmyHqni7NRxO4gYtB1F6ZUB4XbZf7/ZkU4xeI=;
        b=OWinMqBA43aHzWUjS6IY8Vx/L19jIPP8YtKXeTt2p9JrmoiVZ/Rgj+juhzJZGqBw+KfHEx
        DGxCaqS7YyOLW5XeaarHheT7FUSe2nLKRoFJ/MimQf6426HsWWnOLH6JJie2zrQGTvgviU
        DKL+WFtdFWQnwgBg4P2+QL01Y295ovM=
Date:   Mon, 5 Apr 2021 11:01:51 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 05/25] x86/sgx: Introduce virtual EPC for use by KVM
 guests
Message-ID: <20210405090151.GA19485@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
 <0c38ced8c8e5a69872db4d6a1c0dabd01e07cad7.1616136308.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0c38ced8c8e5a69872db4d6a1c0dabd01e07cad7.1616136308.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 19, 2021 at 08:22:21PM +1300, Kai Huang wrote:
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 35391e94bd22..007912f67a06 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1942,6 +1942,18 @@ config X86_SGX
>  
>  	  If unsure, say N.
>  
> +config X86_SGX_KVM
> +	bool "Software Guard eXtensions (SGX) Virtualization"
> +	depends on X86_SGX && KVM_INTEL
> +	help

It seems to me this would fit better under "Virtualization" because even
if I want to enable it, I have to go enable KVM_INTEL first and then
return back here to turn it on too.

And under "Virtualization" is where we enable all kinds of aspects which
belong to it.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
