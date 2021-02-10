Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03962316A2B
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 16:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhBJP2j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 10:28:39 -0500
Received: from 8bytes.org ([81.169.241.247]:55410 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232054AbhBJP2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 10:28:15 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 929CB3C2; Wed, 10 Feb 2021 16:27:32 +0100 (CET)
Date:   Wed, 10 Feb 2021 16:27:31 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:     daniel.kiper@oracle.com, x86@kernel.org,
        Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/7] x86/seves: Support 32-bit boot path and other updates
Message-ID: <20210210152730.GD7302@8bytes.org>
References: <20210210102135.30667-1-joro@8bytes.org>
 <20210210145835.GE358613@fedora>
 <20210210151224.GC7302@8bytes.org>
 <20210210151938.GH358613@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210151938.GH358613@fedora>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021 at 10:19:38AM -0500, Konrad Rzeszutek Wilk wrote:
> I think I am missing something obvious here - but why would you want
> EFI support disabled?

I don't want EFI support disabled, this is just a way to trigger this
boot-path. In real life it is triggered by 32-bit GRUB EFI builds. But I
havn't had one of those for testing, so I used another way to trigger
this path.

Regards,

	Joerg
