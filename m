Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06F1218D88A
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 20:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgCTTm7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 15:42:59 -0400
Received: from 8bytes.org ([81.169.241.247]:54608 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbgCTTm6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 15:42:58 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id CD3DA4CA; Fri, 20 Mar 2020 20:42:56 +0100 (CET)
Date:   Fri, 20 Mar 2020 20:42:52 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
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
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [RFC PATCH v2.1] x86/sev-es: Handle NMI State
Message-ID: <20200320194251.GI5122@8bytes.org>
References: <20200319091407.1481-1-joro@8bytes.org>
 <20200319091407.1481-71-joro@8bytes.org>
 <CALCETrUOQneBHjoZkP-7T5PDijb=WOyv7xF7TD0GLR2Aw77vyA@mail.gmail.com>
 <20200320131707.GF5122@8bytes.org>
 <7d1ee9d9-d333-4529-b21b-19758c99e029@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d1ee9d9-d333-4529-b21b-19758c99e029@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 20, 2020 at 07:42:09AM -0700, Dave Hansen wrote:
> FWIW, perf plus the x86 selftests run in a big loop was my best way of
> stressing the NMI path when we mucked with it for PTI.  The selftests
> make sure to hit some of the more rare entry/exit paths.

Yeah, I ran the x86 selftests in an SEV-ES guest on-top of these
patches, that works. But doing this together with 'perf top' is also on
the list of tests to do.

Regards,

	Joerg
