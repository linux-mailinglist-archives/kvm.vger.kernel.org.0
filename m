Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3371219F543
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 13:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbgDFL5E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 07:57:04 -0400
Received: from mail.skyhub.de ([5.9.137.197]:56768 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727703AbgDFL5E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 07:57:04 -0400
Received: from zn.tnic (p200300EC2F04F600C571FE02886A814C.dip0.t-ipconnect.de [IPv6:2003:ec:2f04:f600:c571:fe02:886a:814c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E7D3D1EC05D6;
        Mon,  6 Apr 2020 13:57:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1586174223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=6mkdJTICOEGUmg5Sf3oUN1anrQ+rTmVREXUkf1ARKJE=;
        b=VpNMhbNpDvCpH+/+qc/IbAFhZgdcKcDPIv/3B+xtociH+gmByxjgr8ZIS1cyqpzEo/hLxo
        BnNbctTh99zUhG3w9BT1hjF7Pwe3F5rqrzQnxfkrH4Ry50KxU+imvuvl55NhxW0Dm9raTc
        3ccjkXu8dg6Ngh1tCvTKYVw8unLL30w=
Date:   Mon, 6 Apr 2020 13:56:59 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
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
Subject: Re: [PATCH 15/70] x86/boot/compressed/64: Always switch to own
 page-table
Message-ID: <20200406115659.GD2520@zn.tnic>
References: <20200319091407.1481-1-joro@8bytes.org>
 <20200319091407.1481-16-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200319091407.1481-16-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 19, 2020 at 10:13:12AM +0100, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> When booted through startup_64 the kernel keeps running on the EFI
> page-table until the KASLR code sets up its own page-table. Without
> KASLR the pre-decompression boot code never switches off the EFI
> page-table. Change that by unconditionally switching to our own
> page-table once the kernel is relocated.
> 
> This makes sure we can make changes to the mapping when necessary, for

Pls use passive voice in your commit message: no "we" or "I", etc, and
describe your changes in imperative mood.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
