Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2B8A6A6097
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 21:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjB1UqE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 15:46:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjB1UqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 15:46:02 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0640E34F5C;
        Tue, 28 Feb 2023 12:45:57 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 835F91EC0644;
        Tue, 28 Feb 2023 21:45:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1677617156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=pZ5ujFFiyZvH4VTsQ1GHyk/iP5I/yiecBmFPezox7xg=;
        b=YJEnHU+1zCBdkSMWsdvjUayZRS4AWms5LiIq1O6NdnY5Xc8C+7XSq5S6rMUkKa5vnXlSOd
        RYo6d/IrZu61/PJSKoeWo3IotuGfI3lL+CVekW6cexpBNVaX1GH+s5g7E0cy6nbNQ/TFAo
        TUVLxYBt34h3QaeusD3eycXTNc86Nq4=
Date:   Tue, 28 Feb 2023 21:45:56 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Takahiro Itazuri <itazur@amazon.com>
Cc:     dave.hansen@linux.intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
        x86@kernel.org, zulinx86@gmail.com
Subject: Re: [PATCH 0/2] KVM: x86: Propagate AMD-specific IBRS bits to guests
Message-ID: <Y/5oBKi6vjZe83ac@zn.tnic>
References: <Y/5U3N0XfRaZ2KkX@zn.tnic>
 <20230228194153.46995-1-itazur@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230228194153.46995-1-itazur@amazon.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023 at 07:41:53PM +0000, Takahiro Itazuri wrote:
> It is true that the kernel does not use those bits at all, but any
> codes could be run inside guests.

So you mean we should stick *all* CPUID leafs in there just because
anything can run in guests?

What is the hypervisor then for?

> One of examples is the following spectre/meltdown checker scipt used as
> de facto standard.

Really? Says who?

$ grep -r . /sys/devices/system/cpu/vulnerabilities/

gives you all you need to know.

And if something's missing, then I'm listening.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
