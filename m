Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A53015936F
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 16:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbgBKPnZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 10:43:25 -0500
Received: from 8bytes.org ([81.169.241.247]:53508 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727962AbgBKPnZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 10:43:25 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 520782FB; Tue, 11 Feb 2020 16:43:23 +0100 (CET)
Date:   Tue, 11 Feb 2020 16:43:21 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [RFC PATCH 00/62] Linux as SEV-ES Guest Support
Message-ID: <20200211154321.GB22063@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
 <20200211145008.GT14914@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200211145008.GT14914@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 03:50:08PM +0100, Peter Zijlstra wrote:
 
> Oh gawd; so instead of improving the whole NMI situation, AMD went and
> made it worse still ?!?

Well, depends on how you want to see it. Under SEV-ES an IRET will not
re-open the NMI window, but the guest has to tell the hypervisor
explicitly when it is ready to receive new NMIs via the NMI_COMPLETE
message.  NMIs stay blocked even when an exception happens in the
handler, so this could also be seen as a (slight) improvement.

Regards,

	Joerg
