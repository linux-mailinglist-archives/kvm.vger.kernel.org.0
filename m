Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDB9313279
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 13:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbhBHMgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 07:36:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:41854 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232195AbhBHMem (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 07:34:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 179FEB0D1;
        Mon,  8 Feb 2021 12:33:58 +0000 (UTC)
Date:   Mon, 8 Feb 2021 13:33:59 +0100
From:   Borislav Petkov <bp@suse.de>
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     luto@kernel.org, tglx@linutronix.de, mingo@kernel.org,
        x86@kernel.org, len.brown@intel.com, dave.hansen@intel.com,
        jing2.liu@intel.com, ravi.v.shankar@intel.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 10/21] x86/fpu/xstate: Update xstate save function to
 support dynamic xstate
Message-ID: <20210208123359.GG17908@zn.tnic>
References: <20201223155717.19556-1-chang.seok.bae@intel.com>
 <20201223155717.19556-11-chang.seok.bae@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201223155717.19556-11-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 23, 2020 at 07:57:06AM -0800, Chang S. Bae wrote:
> copy_xregs_to_kernel() used to save all user states in a kernel buffer.
> When the dynamic user state is enabled, it becomes conditional which state
> to be saved.
> 
> fpu->state_mask can indicate which state components are reserved to be
> saved in XSAVE buffer. Use it as XSAVE's instruction mask to select states.
> 
> KVM used to save all xstate via copy_xregs_to_kernel(). Update KVM to set a
> valid fpu->state_mask, which will be necessary to correctly handle dynamic
> state buffers.

All this commit message should say is something along the lines of
"extend copy_xregs_to_kernel() to receive a mask argument of which
states to save, in preparation of dynamic states handling."

> No functional change until the kernel supports dynamic user states.

Same comment as before.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
