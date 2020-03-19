Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0DEC18C096
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 20:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgCSTlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 15:41:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:54830 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726895AbgCSTlo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 15:41:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E7A76AD03;
        Thu, 19 Mar 2020 19:41:42 +0000 (UTC)
Date:   Thu, 19 Mar 2020 20:41:31 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@nextfour.com>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 70/70] x86/sev-es: Add NMI state tracking
Message-ID: <20200319194131.GF611@suse.de>
References: <20200319091407.1481-1-joro@8bytes.org>
 <20200319091407.1481-71-joro@8bytes.org>
 <d5cdbf9a-2f5f-cb2b-9c52-61fd844e3f3b@nextfour.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d5cdbf9a-2f5f-cb2b-9c52-61fd844e3f3b@nextfour.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 19, 2020 at 06:53:29PM +0200, Mika Penttilä wrote:
> > +SYM_CODE_START(sev_es_iret_user)
> 
> 
> What makes kernel jump here? Can't see this referenced from anywhere?

Sorry, it is just a left-over from a previous version of this patch
(which implemented the single-step-over-iret). This label is not used
anymore. The jump to it was in
swapgs_restore_regs_and_return_to_usermode, after checking the
sev_es_in_nmi flag.

Regards,

	Joerg

