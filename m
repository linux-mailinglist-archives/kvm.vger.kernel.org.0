Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D85DF190DDD
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 13:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbgCXMnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 08:43:20 -0400
Received: from 8bytes.org ([81.169.241.247]:55442 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727256AbgCXMnU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 08:43:20 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id C8F242E2; Tue, 24 Mar 2020 13:43:18 +0100 (CET)
Date:   Tue, 24 Mar 2020 13:43:17 +0100
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
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH] KVM: SVM: Use __packed shorthard
Message-ID: <20200324124317.GA6287@8bytes.org>
References: <20200319091407.1481-1-joro@8bytes.org>
 <20200319091407.1481-2-joro@8bytes.org>
 <20200323132315.GB4649@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323132315.GB4649@zn.tnic>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 23, 2020 at 02:23:15PM +0100, Borislav Petkov wrote:
> I guess we can do that ontop.
> 
> ---
> From: Borislav Petkov <bp@suse.de>
> Date: Mon, 23 Mar 2020 14:20:08 +0100
> 
> ... to make it more readable.
> 
> No functional changes.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/include/asm/svm.h | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)

Added it to the patch-set, thanks Boris.
