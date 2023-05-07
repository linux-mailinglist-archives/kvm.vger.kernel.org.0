Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450776F986F
	for <lists+kvm@lfdr.de>; Sun,  7 May 2023 13:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbjEGL7p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 May 2023 07:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjEGL7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 May 2023 07:59:44 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7963C100;
        Sun,  7 May 2023 04:59:42 -0700 (PDT)
Received: from zn.tnic (p5de8e8ea.dip0.t-ipconnect.de [93.232.232.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 285591EC04DA;
        Sun,  7 May 2023 13:59:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1683460780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=V90JBxldz2a6J8icT88EVrG0cGl5lWlT59Ohw8HkYEM=;
        b=dnFO0t5MmwnFoXKC3H8quu1XtDB62RXIUzNFDx5Htc1N+1H99Ld8ZLnkrM6aLCUXbIcxAn
        qmkjMwFgqg8bqvQ68FWOR53qhI0HIYCjUu4/Ge9ICrThddsp5shEMw+vwkynf6HiKe9l3z
        JA93XQxvZliblUMjxLWDJrMeWhpAAKs=
Date:   Sun, 7 May 2023 13:59:34 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        hpa@zytor.com, peterz@infradead.org, andrew.cooper3@citrix.com,
        seanjc@google.com, pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
Subject: Re: [PATCH v8 01/33] x86/traps: let common_interrupt() handle
 IRQ_MOVE_CLEANUP_VECTOR
Message-ID: <20230507115934.GCZFeSpqnO5pPkAzwB@fat_crate.local>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-2-xin3.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230410081438.1750-2-xin3.li@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 10, 2023 at 01:14:06AM -0700, Xin Li wrote:
> From: "H. Peter Anvin (Intel)" <hpa@zytor.com>
> 
> IRQ_MOVE_CLEANUP_VECTOR is the only one of the system IRQ vectors that
> is *below* FIRST_SYSTEM_VECTOR. It is a slow path, so just push it
> into common_interrupt() just before the spurious interrupt handling.

I'm missing here the "why":

I can go forward into the set and see that you're splitting the handling
based on vector types and there's event classification and the lowest
prio vector is not going to be hardwired to 0x20, yadda yadda...

but some of that should be in the text here so that it is clear why it
is being done.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
