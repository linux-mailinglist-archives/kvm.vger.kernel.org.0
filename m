Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3503D38B3DA
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 17:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbhETQAy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 12:00:54 -0400
Received: from mail.skyhub.de ([5.9.137.197]:54400 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233174AbhETQAx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 12:00:53 -0400
Received: from zn.tnic (p200300ec2f0eb60047444127d595167e.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:b600:4744:4127:d595:167e])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 970C71EC0118;
        Thu, 20 May 2021 17:59:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1621526370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=TApz0SONcc6mJu+tb28RFBQNnxMaCpZ52cwrHXaEb7I=;
        b=iqtCazNj7lxxoPRgut0keBQ60XMPS02co2AGdXT3+tyVTlFDfHNMcMq1lh/2BWafL1nCug
        RlbHLUZfgddLbgqeB9AoiglxH6mvHMlgGA1xuvupOuLFORwR1fXvafkVF/5RwIpVzq71rK
        bY5aKGMKh8FuLkZ0NymuaowFCBd/xec=
Date:   Thu, 20 May 2021 17:59:25 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joseph Richey <joerichey94@gmail.com>
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
Message-ID: <YKaHUudJx2FJ2sO/@zn.tnic>
References: <20210520104343.317119-1-joerichey94@gmail.com>
 <YKZC9o8019kH76xS@zn.tnic>
 <CAAXkRocqFZgC-pWLc3V+VQLAVRvLXk+wTOhp+F4_WGRByjxhDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAXkRocqFZgC-pWLc3V+VQLAVRvLXk+wTOhp+F4_WGRByjxhDQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021 at 04:50:11AM -0700, Joseph Richey wrote:
> Running checkpatch.pl with --strict gives:

Yah, people must *remember* to use --strict.

> It should probably just recommend the _BITUL macro.

Right.

> Ahhhhh, I figured there was a more standard way. Will fix.

Yeah, Fixes: is very useful, as we've come to realize.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
