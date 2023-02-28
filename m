Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE776A5F94
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 20:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjB1TYS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 14:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjB1TYR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 14:24:17 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C8F10414;
        Tue, 28 Feb 2023 11:24:14 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2A2581EC04DA;
        Tue, 28 Feb 2023 20:24:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1677612253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=3e2jFjFO6uuOxcRiEa2QLEqVS5Md3+E8RYyRPBrAfgA=;
        b=Lp0ZcwOMWtiby9LHbV7E9gozLJNeWSKFDYsNBda9rIEDIX42+SY8wJYiKF8NJm47bgySZN
        BorxD/Gg+5epfyI4Y7u1ClPK0FaE9k8Q0uIPKomhLkes3gZT+RdXkNoSBJ42zn8rlzZRlU
        gzhUShQ871eN26GtyTl8OgBpK9BCtzU=
Date:   Tue, 28 Feb 2023 20:24:12 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Takahiro Itazuri <itazur@amazon.com>
Cc:     dave.hansen@linux.intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
        x86@kernel.org, zulinx86@gmail.com
Subject: Re: [PATCH 0/2] KVM: x86: Propagate AMD-specific IBRS bits to guests
Message-ID: <Y/5U3N0XfRaZ2KkX@zn.tnic>
References: <Y/0jRXzbcbxTjqSS@zn.tnic>
 <20230228181345.40837-1-itazur@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230228181345.40837-1-itazur@amazon.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023 at 06:13:45PM +0000, Takahiro Itazuri wrote:
> VMMs trust to some extent that KVM_GET_SUPPORTED_CPUID returns cpuid
> information consistent with hardware, although they should not for some
> leaves (like CPU topoligy). IMHO, propagating these bits without VMM
> actions would be helpful since guests come to know IBRS related
> information of processors by default and applies mitigations properly
> based on that information.

I'd prefer if VMMs did supply whatever they prefer to the guests
instead. None of those bits are used in the kernel for mitigations, as
you've realized.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
