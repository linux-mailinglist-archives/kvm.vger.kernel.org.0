Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F50333F71
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 14:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbhCJNkq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 08:40:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:41828 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232975AbhCJNkn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 08:40:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 387C1AD72;
        Wed, 10 Mar 2021 13:40:42 +0000 (UTC)
Date:   Wed, 10 Mar 2021 14:40:38 +0100
From:   Borislav Petkov <bp@suse.de>
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     luto@kernel.org, tglx@linutronix.de, mingo@kernel.org,
        x86@kernel.org, len.brown@intel.com, dave.hansen@intel.com,
        jing2.liu@intel.com, ravi.v.shankar@intel.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 01/22] x86/fpu/xstate: Modify the initialization
 helper to handle both static and dynamic buffers
Message-ID: <20210310134038.GA25403@zn.tnic>
References: <20210221185637.19281-1-chang.seok.bae@intel.com>
 <20210221185637.19281-2-chang.seok.bae@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210221185637.19281-2-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Feb 21, 2021 at 10:56:16AM -0800, Chang S. Bae wrote:
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index 571220ac8bea..d43661d309ab 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -192,8 +192,18 @@ static inline void fpstate_init_fstate(struct fregs_state *fp)
>  	fp->fos = 0xffff0000u;
>  }
>  
> -void fpstate_init(union fpregs_state *state)
> +/*
> + * @fpu: If NULL, use init_fpstate
> + */

A note either for you - if you get to resend a new revision - or for the
committer to fix up this into a proper kernel-doc style:

Documentation/doc-guide/kernel-doc.rst

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
