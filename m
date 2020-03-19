Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B04618C088
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 20:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgCSTiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 15:38:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:53414 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727111AbgCSTiR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 15:38:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 38891AFC6;
        Thu, 19 Mar 2020 19:38:15 +0000 (UTC)
Date:   Thu, 19 Mar 2020 20:38:13 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Joerg Roedel <joro@8bytes.org>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 41/70] x86/sev-es: Add Runtime #VC Exception Handler
Message-ID: <20200319193813.GE611@suse.de>
References: <20200319091407.1481-1-joro@8bytes.org>
 <20200319091407.1481-42-joro@8bytes.org>
 <CALCETrW9EYi5dzCKNtKkxM18CC4n5BZxTp1=qQ5qZccwstXjzg@mail.gmail.com>
 <20200319162439.GE5122@8bytes.org>
 <CALCETrW6LOwEfjJz-S7fFJvPqgr9BoCkRG2MA-Pk6K_y_rmGHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrW6LOwEfjJz-S7fFJvPqgr9BoCkRG2MA-Pk6K_y_rmGHg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 19, 2020 at 11:43:20AM -0700, Andy Lutomirski wrote:
> Or future generations could have enough hardware support for debugging
> that #DB doesn't need to be intercepted or can be re-injected
> correctly with the #DB vector.

Yeah, the problem is, the GHCB spec suggests the single-step-over-iret
way to re-enable the NMI window and requires intercepting #DB for it. So
the hypervisor probably still has to intercept it, even when debug
support is added some day. I need to think more about this.

Regards,

	Joerg
