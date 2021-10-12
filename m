Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD8F42AAD6
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 19:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbhJLReL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 13:34:11 -0400
Received: from mail.skyhub.de ([5.9.137.197]:47064 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229495AbhJLReL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 13:34:11 -0400
Received: from zn.tnic (p200300ec2f19420044c1262ed1e42b8c.dip0.t-ipconnect.de [IPv6:2003:ec:2f19:4200:44c1:262e:d1e4:2b8c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6B0EF1EC047E;
        Tue, 12 Oct 2021 19:32:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1634059928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=qdAfGM7dg0L+IttARcHhODz9Kt1lSwaIYIr7sfkL9KM=;
        b=l+tp5/EZ+vMNJ7pgMbA4jLnz/cYiiOa0GH0MxF0wRDFyO7oKcy0EN1gepxG+C3I/eAnP5r
        LDYmmj/DwWygsZVS5FA+hwp9/aArAPLncY9hMOQynl/LlYpOTzHWXnB0NSZvqtAnD2whlO
        kcjjCYs5zpYWYgYMW1ee2i20qg9UJto=
Date:   Tue, 12 Oct 2021 19:32:06 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [patch 24/31] x86/fpu: Move fpregs_restore_userregs() to core
Message-ID: <YWXGlsJsmn7jFeFL@zn.tnic>
References: <20211011215813.558681373@linutronix.de>
 <20211011223611.727493295@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211011223611.727493295@linutronix.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 12, 2021 at 02:00:34AM +0200, Thomas Gleixner wrote:
> Only used core internaly.

"Only used internally in the FPU core."

or so.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
