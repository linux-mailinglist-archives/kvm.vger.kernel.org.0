Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB12E02F8
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 13:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388695AbfJVLeW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 07:34:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49212 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388689AbfJVLeW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 07:34:22 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DCFD93688E
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 11:34:21 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id z24so6055915wmk.8
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 04:34:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hKISof+jZanOjFuAMb7NpTQQo5K+nkz0naeOg86T7Ow=;
        b=EAQUErhbJVgLIsc6uLNVfGOs4vbfJslha6ddMyRzfyPXTxPtCnZpELoZ7dAExpWexG
         Df7HisobsgfGSknVoeRveCNXGUYgRzrVUM+yFaWV9u4dzp0JDcLcd42eeTWFQJVFlQdz
         h8rqGG9bzrYsD/OBbjjV/Uhd/rN9IXbyRwejOZk7V5G62epKDAsjhuNlmzfxrQsnfrE1
         Yj55/24wzBKOB7pqwikhx1/Qeu9Pc1Npo/jO5Wj6Pv8PlXAuBW3B0J8xas8SxcUaarOe
         YsdLCr5LOhtfWTCtZWmqywie4ziIfaqVQEfV68P6uRG+Yv9QxbN9nNyefW841tqdKxx9
         ZnDw==
X-Gm-Message-State: APjAAAXzrWYC+ePnMjhbR2B89/xmOYoOATPNSnLBiULJwSVwCeJ8yQVB
        7cUOriDRyj0Ow8nJrFumP/+vx9iPNDp6xcH4KARioR3tQgzp/XFjhnxwjZ0APrPXYsFLKURjWDT
        JYNeNC4te1mmZ
X-Received: by 2002:a5d:4341:: with SMTP id u1mr3122524wrr.306.1571744059709;
        Tue, 22 Oct 2019 04:34:19 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy0sYBGB7epCnwESA0v66tQGqclr5cgWDSQmRWvyyuLm8Mc9lam9XOd18v3dCyWbw4+tpHmjA==
X-Received: by 2002:a5d:4341:: with SMTP id u1mr3122496wrr.306.1571744059423;
        Tue, 22 Oct 2019 04:34:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c0e4:dcf4:b543:ce19? ([2001:b07:6468:f312:c0e4:dcf4:b543:ce19])
        by smtp.gmail.com with ESMTPSA id x8sm17229628wrr.43.2019.10.22.04.34.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2019 04:34:18 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm fixes for 5.4-rc5
To:     Marc Zyngier <maz@kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
References: <20191020101129.2612-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e639182e-fbd9-c7a1-43b0-5889a0e61930@redhat.com>
Date:   Tue, 22 Oct 2019 13:34:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191020101129.2612-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/10/19 12:11, Marc Zyngier wrote:
> Paolo, Radim,
> 
> Here's the latest (and hopefully last) set of KVM/arm fixes for
> 5.4. 4 patches exclusively covering our PMU emulation, which exhibited
> several different flavours of brokenness.
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit da0c9ea146cbe92b832f1b0f694840ea8eb33cce:
> 
>   Linux 5.4-rc2 (2019-10-06 14:27:30 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.4-2
> 
> for you to fetch changes up to 8c3252c06516eac22c4f8e2506122171abedcc09:
> 
>   KVM: arm64: pmu: Reset sample period on overflow handling (2019-10-20 10:47:07 +0100)
> 
> ----------------------------------------------------------------
> KVM/arm fixes for 5.4, take #2
> 
> Special PMU edition:
> 
> - Fix cycle counter truncation
> - Fix cycle counter overflow limit on pure 64bit system
> - Allow chained events to be actually functional
> - Correct sample period after overflow
> 
> ----------------------------------------------------------------
> Marc Zyngier (4):
>       KVM: arm64: pmu: Fix cycle counter truncation
>       arm64: KVM: Handle PMCR_EL0.LC as RES1 on pure AArch64 systems
>       KVM: arm64: pmu: Set the CHAINED attribute before creating the in-kernel event
>       KVM: arm64: pmu: Reset sample period on overflow handling
> 
>  arch/arm64/kvm/sys_regs.c |  4 ++++
>  virt/kvm/arm/pmu.c        | 48 ++++++++++++++++++++++++++++++++++-------------
>  2 files changed, 39 insertions(+), 13 deletions(-)
> 

Pulled, thanks.

Paolo
