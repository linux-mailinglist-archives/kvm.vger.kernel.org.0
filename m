Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEDE42A91E
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 18:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhJLQMs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 12:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhJLQMs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 12:12:48 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7E3C061570;
        Tue, 12 Oct 2021 09:10:46 -0700 (PDT)
Received: from zn.tnic (p200300ec2f10490028d5993bc3208260.dip0.t-ipconnect.de [IPv6:2003:ec:2f10:4900:28d5:993b:c320:8260])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5136F1EC0295;
        Tue, 12 Oct 2021 18:10:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1634055043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=DNpWlp9cazwgZuawvK7MDl1O23EgF6cRF1YqSN00KKc=;
        b=qkJNQ5IwdiPuJoYqSZw/I5IEtEE157rRVJtE/o/pMdBJwi+EFEdthh7+XDrdJouZFB2mmQ
        BSTQ6Hl4cumr/kRkYkb9hFz0sRWR7oCMmFuBVqRtst5FsjgNFKU/b5rIB6aJ3vNbw7iikg
        0dpP5Hoh9sXIrV9fgQLSwiGfuxmppXk=
Date:   Tue, 12 Oct 2021 18:10:40 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [patch 09/31] x86/fpu: Do not inherit FPU context for
 CLONE_THREAD
Message-ID: <YWWzgO9Vn6XlNsLP@zn.tnic>
References: <20211011215813.558681373@linutronix.de>
 <20211011223610.828296394@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211011223610.828296394@linutronix.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 12, 2021 at 02:00:11AM +0200, Thomas Gleixner wrote:
> CLONE_THREAD does not have the guarantee of a true fork to inherit all
> state. Especially the FPU state is meaningless for CLONE_THREAD.
> 
> Just wipe out the minimal required state so restore on return to user space
> let's the thread start with a clean FPU.

This sentence reads weird, needs massaging.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
