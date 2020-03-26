Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C51F4194560
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 18:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgCZRY4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 13:24:56 -0400
Received: from mail.skyhub.de ([5.9.137.197]:56078 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgCZRY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 13:24:56 -0400
Received: from zn.tnic (p200300EC2F0A4900B0CADCDCA21F3A81.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:4900:b0ca:dcdc:a21f:3a81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B202F1EC0CAA;
        Thu, 26 Mar 2020 18:24:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1585243494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=3FMQFv3MaTMVMmx11czdZm9GaX9q+f/jvQkxZWxUG3c=;
        b=Tv9yp6MVMkUwWk911M79xBkZMRiX/m80QKPx1CP7cCGYo+amj8Ux+9hJ7PpFBAhlp5M27P
        r3A1mFtcmAHPJ5qLmoaEH6UG3gPwsQ9403pAnEQD8pfP/5RO23GpbIjJ4M5hPfBzvNmcsn
        DS3PGNeyGb7l3USesCFha1eVkc+yaSI=
Date:   Thu, 26 Mar 2020 18:24:55 +0100
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
Subject: Re: [PATCH 07/70] x86/umip: Factor out instruction decoding
Message-ID: <20200326172455.GG11398@zn.tnic>
References: <20200319091407.1481-1-joro@8bytes.org>
 <20200319091407.1481-8-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200319091407.1481-8-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 19, 2020 at 10:13:04AM +0100, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Factor out the code used to decode an instruction with the correct
> address and operand sizes to a helper function.

As for the previous one: "No functional changes."

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
