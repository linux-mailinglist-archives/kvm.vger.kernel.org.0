Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0621C38ADF0
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 14:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbhETMTj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 08:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242308AbhETMTb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 08:19:31 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C71C068DAD;
        Thu, 20 May 2021 04:07:42 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0eb600eb28425bb4f209d1.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:b600:eb28:425b:b4f2:9d1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 975E21EC056A;
        Thu, 20 May 2021 13:07:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1621508860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=6ryephn32BMCPHeqpBpBr6gH97AaCQkIjAqmadwjmII=;
        b=KyJ7VT4raYWbRpi6bTG/AnBdqj2MnxuKg/VHQZJmhYOnYAXcNGO6YJi26H53UVYonmo4Zh
        LejSU+aQWAC48TUZ3VLYjeIO2uYLJpEGekNsvwYTAEvRPYuhYndWGkRLCBDYfQNHwH9wt7
        p6Zfmcq/vQmEM089rd+EQcmnZK/vVTI=
Date:   Thu, 20 May 2021 13:07:34 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joe Richey <joerichey94@gmail.com>
Cc:     trivial@kernel.org, Joe Richey <joerichey@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
Subject: Re: [PATCH 0/6] Don't use BIT() macro in UAPI headers
Message-ID: <YKZC9o8019kH76xS@zn.tnic>
References: <20210520104343.317119-1-joerichey94@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210520104343.317119-1-joerichey94@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021 at 03:43:37AM -0700, Joe Richey wrote:
> This patch series changes all UAPI uses of BIT() to just be open-coded.
> However, there really should be a check for this in checkpatch.pl

Wanna add that check too?

> Currently, the script actually _encourages_ users to use the BIT macro
> even if adding things to UAPI.

How so?

This is with your first patch:

$ ./scripts/checkpatch.pl /tmp/bit.01
total: 0 errors, 0 warnings, 7 lines checked

/tmp/bit.01 has no obvious style problems and is ready for submission.

Also, in your commit messages you refer to patches with patchwork links
- please use the respective upstream commit IDs instead. Grep for
"Fixes:" here:

Documentation/process/submitting-patches.rst

for more info.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
