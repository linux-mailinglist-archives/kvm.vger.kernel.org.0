Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8995B1ED32C
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 17:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgFCPS7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 11:18:59 -0400
Received: from 8bytes.org ([81.169.241.247]:45988 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbgFCPS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 11:18:59 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 4B99F28B; Wed,  3 Jun 2020 17:18:58 +0200 (CEST)
Date:   Wed, 3 Jun 2020 17:18:57 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Brian Gerst <brgerst@gmail.com>
Cc:     the arch/x86 maintainers <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
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
        Joerg Roedel <jroedel@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v3 35/75] x86/head/64: Build k/head64.c with
 -fno-stack-protector
Message-ID: <20200603151857.GC23071@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-36-joro@8bytes.org>
 <CAMzpN2gfiBAeCV_1+9ogh42bMMuDW=qdwd7dYp49-=zY3kzBaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMzpN2gfiBAeCV_1+9ogh42bMMuDW=qdwd7dYp49-=zY3kzBaA@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 19, 2020 at 09:58:18AM -0400, Brian Gerst wrote:
> On Tue, Apr 28, 2020 at 11:28 AM Joerg Roedel <joro@8bytes.org> wrote:

> The proper fix would be to initialize MSR_GS_BASE earlier.

That'll mean to initialize it two times during boot, as the first C
function with stack-protection is called before the kernel switches to
its high addresses (early_idt_setup call-path). But okay, I can do that.

On the other side, which value does the stack protector have in the early
boot code?


	Joerg
