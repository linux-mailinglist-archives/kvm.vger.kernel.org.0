Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D8358D4F8
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 09:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239068AbiHIHzT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 03:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239358AbiHIHzG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 03:55:06 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C9A21815;
        Tue,  9 Aug 2022 00:55:03 -0700 (PDT)
Received: from zn.tnic (p200300ea971b98cb329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:98cb:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 868661EC04CB;
        Tue,  9 Aug 2022 09:54:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1660031698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=sau2Ier9daCmht+ULzaCXrUckUs+d4ukVHmyxV5uCUA=;
        b=Vfc/voL25bbBm8PKYA8PJjcrqSPukr4A2TAXTsGgqGooEWH8M10RHHgBZUU/D8JyUSUOst
        SLG07F4qe1dZ90L9CZBYdJbPUDA3h+ovpXq4kTa7ECE6rTT0vLNReRuZ5Fq5WZDQINYTiX
        yEpAZYG/rf9BOshZy7B5+Eq7APgZR7g=
Date:   Tue, 9 Aug 2022 09:54:58 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Liam Ni <zhiguangni01@gmail.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM:make cpuid_entry2_find more efficient
Message-ID: <YvIS0nvStyUYR7ep@zn.tnic>
References: <20220809055138.101470-1-zhiguangni01@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220809055138.101470-1-zhiguangni01@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 09, 2022 at 01:51:38PM +0800, Liam Ni wrote:
> Compared with the way of obtaining the pointer by
> fetching the value of the array and then fetching the pointer,
> the way of obtaining the pointer by the pointer offset is more efficient.

How did you determine that?

Hint: look at the generated assembler before and after your change and
see if there are any differences.

:-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
