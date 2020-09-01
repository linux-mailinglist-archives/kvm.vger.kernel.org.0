Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02BCC258F77
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 15:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgIANua (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 09:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728020AbgIANau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 09:30:50 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B247C061245;
        Tue,  1 Sep 2020 06:30:03 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id B2BB7391; Tue,  1 Sep 2020 15:29:52 +0200 (CEST)
Date:   Tue, 1 Sep 2020 15:29:51 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
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
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v6 48/76] x86/entry/64: Add entry code for #VC handler
Message-ID: <20200901132951.GD22385@8bytes.org>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-49-joro@8bytes.org>
 <20200831113002.GH27517@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831113002.GH27517@zn.tnic>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 31, 2020 at 01:30:02PM +0200, Borislav Petkov wrote:
> AFAICT, that STACK_TYPE_UNKNOWN gets set only by the plain
> get_stack_info() function - not by the _noinstr() variant so you'd need
> to check the return value of latter...

You are right, it needs to check the return value of
get_stack_info_noinstr() instead of STACK_TYPE_UNKNOWN. Fixed that now.


Regards,

	Joerg
