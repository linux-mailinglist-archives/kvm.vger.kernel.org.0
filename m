Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22E1F1F673C
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 13:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgFKLyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 07:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726407AbgFKLyD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 07:54:03 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09EAC08C5C1;
        Thu, 11 Jun 2020 04:54:02 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 335B5869; Thu, 11 Jun 2020 13:54:00 +0200 (CEST)
Date:   Thu, 11 Jun 2020 13:53:58 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
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
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 47/75] x86/sev-es: Add Runtime #VC Exception Handler
Message-ID: <20200611115358.GB11924@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-48-joro@8bytes.org>
 <20200523075924.GB27431@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200523075924.GB27431@zn.tnic>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 23, 2020 at 09:59:24AM +0200, Borislav Petkov wrote:
> On Tue, Apr 28, 2020 at 05:16:57PM +0200, Joerg Roedel wrote:
> > +	struct ghcb backup_ghcb;
> 
> I could use some text explaining what those backups are for?

I added another comment above that line to better explain why it is
needed.


	Joerg
