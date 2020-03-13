Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 431E4184367
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 10:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgCMJMZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 05:12:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:45946 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgCMJMZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 05:12:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 63F64AD39;
        Fri, 13 Mar 2020 09:12:23 +0000 (UTC)
Date:   Fri, 13 Mar 2020 10:12:21 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Joerg Roedel <joro@8bytes.org>, X86 ML <x86@kernel.org>,
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
        Linux Virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 38/62] x86/sev-es: Handle instruction fetches from
 user-space
Message-ID: <20200313091221.GA16378@suse.de>
References: <20200211135256.24617-1-joro@8bytes.org>
 <20200211135256.24617-39-joro@8bytes.org>
 <CALCETrVRmg88xY0s4a2CONXQ3fgvCKXpW2eYJRJGhqQLneoGqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVRmg88xY0s4a2CONXQ3fgvCKXpW2eYJRJGhqQLneoGqQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 12, 2020 at 01:42:48PM -0800, Andy Lutomirski wrote:
> I realize that this is a somewhat arbitrary point in the series to
> complain about this, but: the kernel already has infrastructure to
> decode and fix up an instruction-based exception.  See
> fixup_umip_exception().  Please refactor code so that you can share
> the same infrastructure rather than creating an entirely new thing.

Okay, but 'infrastructure' is a bold word for the call path down
fixup_umip_exception(). It uses the in-kernel instruction decoder, which
I already use in my patch-set. But I agree that some code in this
patch-set is duplicated and already present in the instruction decoder,
and that fixup_umip_exception() has more robust instruction decoding.

I factor the instruction decoding part out and make is usable for the
#VC handler too and remove the code that is already present in the
instruction decoder.

Regards,

	Joerg

