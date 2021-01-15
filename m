Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C5E2F7C5C
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 14:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730893AbhAONTH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 08:19:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:37970 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732126AbhAONTF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 08:19:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3E7CFAC63;
        Fri, 15 Jan 2021 13:18:08 +0000 (UTC)
Date:   Fri, 15 Jan 2021 14:18:02 +0100
From:   Borislav Petkov <bp@suse.de>
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     luto@kernel.org, tglx@linutronix.de, mingo@kernel.org,
        x86@kernel.org, len.brown@intel.com, dave.hansen@intel.com,
        jing2.liu@intel.com, ravi.v.shankar@intel.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 04/21] x86/fpu/xstate: Modify context switch helpers
 to handle both static and dynamic buffers
Message-ID: <20210115131802.GD11337@zn.tnic>
References: <20201223155717.19556-1-chang.seok.bae@intel.com>
 <20201223155717.19556-5-chang.seok.bae@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201223155717.19556-5-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 23, 2020 at 07:57:00AM -0800, Chang S. Bae wrote:
> In preparation for dynamic xstate buffer expansion, update the xstate
> restore function parameters to equally handle static in-line xstate buffer,
> as well as dynamically allocated xstate buffer.

Ok, I see what you've done: you've slightly changed that same
formulation depending on what the patch is doing. I need to read very
carefully.

What I would've written is:

"Have all functions handling FPU state take a struct fpu * pointer in
preparation for dynamic state buffer support."

Plain and simple.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
