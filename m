Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3BC2D1E23
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 00:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgLGXLg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 18:11:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:52790 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgLGXLg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 18:11:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 26500ABE9;
        Mon,  7 Dec 2020 23:10:54 +0000 (UTC)
Date:   Tue, 8 Dec 2020 00:10:49 +0100
From:   Borislav Petkov <bp@suse.de>
To:     "Bae, Chang Seok" <chang.seok.bae@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Brown, Len" <len.brown@intel.com>
Subject: Re: [PATCH v2 01/22] x86/fpu/xstate: Modify area init helper
 prototypes to access all the possible areas
Message-ID: <20201207231049.GE16640@zn.tnic>
References: <20201119233257.2939-1-chang.seok.bae@intel.com>
 <20201119233257.2939-2-chang.seok.bae@intel.com>
 <20201207171251.GB16640@zn.tnic>
 <2c4c4340feaf8542fa41e9f4563ecb2b58eef996.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2c4c4340feaf8542fa41e9f4563ecb2b58eef996.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 07, 2020 at 11:03:27PM +0000, Bae, Chang Seok wrote:
> It was considered to be concise to represent, but it looks to be 
> unreadable.

Not only unreadable but actively confusing - there *is* a "task" pointer
all around the kernel which we use for struct task_struct *.

> (I suspect this point applicable to PATCH2-4 as well.)

Looks like it.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
