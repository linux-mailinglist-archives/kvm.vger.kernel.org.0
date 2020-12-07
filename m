Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9922D1744
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 18:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbgLGRNi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 12:13:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:54440 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726377AbgLGRNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 12:13:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5D9EBACBA;
        Mon,  7 Dec 2020 17:12:56 +0000 (UTC)
Date:   Mon, 7 Dec 2020 18:12:51 +0100
From:   Borislav Petkov <bp@suse.de>
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     tglx@linutronix.de, mingo@kernel.org, luto@kernel.org,
        x86@kernel.org, len.brown@intel.com, dave.hansen@intel.com,
        jing2.liu@intel.com, ravi.v.shankar@intel.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 01/22] x86/fpu/xstate: Modify area init helper
 prototypes to access all the possible areas
Message-ID: <20201207171251.GB16640@zn.tnic>
References: <20201119233257.2939-1-chang.seok.bae@intel.com>
 <20201119233257.2939-2-chang.seok.bae@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201119233257.2939-2-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 19, 2020 at 03:32:36PM -0800, Chang S. Bae wrote:
> The xstate infrastructure is not flexible to support dynamic areas in
> task->fpu.

task->fpu?

Do you mean the fpu member in struct thread_struct ?

> Change the fpstate_init() prototype to access task->fpu directly. It
> treats a null pointer as indicating init_fpstate, as this initial data
> does not belong to any task.

What for? Commit messages should state *why* you're doing a change - not
*what* you're doing. *What* I can more or less see, *why* is harder.

/me goes and looks forward into the patchset...

Are you going to need it for stuff like

	fpu ? fpu->state_mask : get_init_fpstate_mask()

?

If so, why don't you write *why* you're doing those changes here?


> For the compacted format, fpstate_init_xstate() now accepts the state
> component bitmap to configure XCOMP_BV.

I can see that. But why?

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
