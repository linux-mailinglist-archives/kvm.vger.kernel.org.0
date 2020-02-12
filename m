Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5631215AC06
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 16:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgBLPgV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 10:36:21 -0500
Received: from 8bytes.org ([81.169.241.247]:54056 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727026AbgBLPgU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 10:36:20 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 56BB03D3; Wed, 12 Feb 2020 16:36:19 +0100 (CET)
Date:   Wed, 12 Feb 2020 16:36:17 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Juergen Gross <JGross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 46/62] x86/sev-es: Handle INVD Events
Message-ID: <20200212153617.GD22063@8bytes.org>
References: <20200211135256.24617-47-joro@8bytes.org>
 <EA510462-A43C-4F7E-BFE8-B212003B3627@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <EA510462-A43C-4F7E-BFE8-B212003B3627@amacapital.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 04:12:19PM -0800, Andy Lutomirski wrote:
> 
> 
> > On Feb 11, 2020, at 5:53 AM, Joerg Roedel <joro@8bytes.org> wrote:
> > 
> > ﻿From: Tom Lendacky <thomas.lendacky@amd.com>
> > 
> > Implement a handler for #VC exceptions caused by INVD instructions.
> 
> Uh, what?  Surely the #VC code can have a catch-all OOPS path for things like this. Linux should never ever do INVD.

Right, its hard to come up with a valid use-case for INVD in the Linux
kernel. I changed the patch to mark INVD as unsupported and print an
error message.

Regards,

	Joerg
