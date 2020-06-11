Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A75D1F68CA
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 15:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgFKNG6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 09:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728249AbgFKNGg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 09:06:36 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888E5C03E96F;
        Thu, 11 Jun 2020 06:06:36 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 8E68E869; Thu, 11 Jun 2020 15:06:34 +0200 (CEST)
Date:   Thu, 11 Jun 2020 15:06:33 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
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
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 54/75] x86/sev-es: Handle DR7 read/write events
Message-ID: <20200611130633.GD11924@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-55-joro@8bytes.org>
 <20200525105935.GH25636@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525105935.GH25636@zn.tnic>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 25, 2020 at 12:59:35PM +0200, Borislav Petkov wrote:
> On Tue, Apr 28, 2020 at 05:17:04PM +0200, Joerg Roedel wrote:
> > +	if (data)
> > +		data->dr7 = val;
> 
> Are we still returning ES_OK if !data?

Yes, it just means we ignore DR7 writes when they happen early before
runtime_data is allocated. Since the DR7 value never makes it to the
hardware register anyway, it doesn't matter.


	Joerg

