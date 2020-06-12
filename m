Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF501F75E5
	for <lists+kvm@lfdr.de>; Fri, 12 Jun 2020 11:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbgFLJZw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jun 2020 05:25:52 -0400
Received: from 8bytes.org ([81.169.241.247]:47506 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726343AbgFLJZw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jun 2020 05:25:52 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 1052E3AA; Fri, 12 Jun 2020 11:25:50 +0200 (CEST)
Date:   Fri, 12 Jun 2020 11:25:49 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 59/75] x86/sev-es: Handle MONITOR/MONITORX Events
Message-ID: <20200612092549.GB3701@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-60-joro@8bytes.org>
 <20200520063845.GC17090@linux.intel.com>
 <20200611131045.GE11924@8bytes.org>
 <20200611171305.GJ29918@linux.intel.com>
 <eac2d02f-951c-16d4-d4f7-55357e790bcd@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eac2d02f-951c-16d4-d4f7-55357e790bcd@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 11, 2020 at 02:33:12PM -0500, Tom Lendacky wrote:
> I don't think there is any guarantee that MONITOR/MWAIT would work within a
> guest (I'd have to dig some more on that to get a definitive answer, but
> probably not necessary to do). As you say, if KVM emulates it as a NOP,
> there's no sense in exposing the GPA - make it a NOP in the handler. I just
> need to poke some other hypervisor vendors and hear what they have to say.

Okay, makes sense. I made monitor/mwait nops in the patch-set.

Regards,

	Joerg
