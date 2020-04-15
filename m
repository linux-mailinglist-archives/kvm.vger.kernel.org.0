Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A2A1AAC50
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 17:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409987AbgDOPxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 11:53:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:55124 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404257AbgDOPxH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 11:53:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C4F54ACA1;
        Wed, 15 Apr 2020 15:53:04 +0000 (UTC)
Date:   Wed, 15 Apr 2020 17:53:02 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Mike Stunes <mstunes@vmware.com>
Cc:     Joerg Roedel <joro@8bytes.org>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 40/70] x86/sev-es: Setup per-cpu GHCBs for the runtime
 handler
Message-ID: <20200415155302.GD21899@suse.de>
References: <20200319091407.1481-1-joro@8bytes.org>
 <20200319091407.1481-41-joro@8bytes.org>
 <A7DF63B4-6589-4386-9302-6B7F8BE0D9BA@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A7DF63B4-6589-4386-9302-6B7F8BE0D9BA@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mike,

On Tue, Apr 14, 2020 at 07:03:44PM +0000, Mike Stunes wrote:
> set_memory_decrypted needs to check the return value. I see it
> consistently return ENOMEM. I've traced that back to split_large_page
> in arch/x86/mm/pat/set_memory.c.

I agree that the return code needs to be checked. But I wonder why this
happens. The split_large_page() function returns -ENOMEM when
alloc_pages() fails. Do you boot the guest with minal RAM assigned?

Regards,

	Joerg
