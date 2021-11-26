Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05AF45EC9A
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 12:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241074AbhKZLax (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 06:30:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237381AbhKZL2w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Nov 2021 06:28:52 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D6EC061A31
        for <kvm@vger.kernel.org>; Fri, 26 Nov 2021 02:42:18 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id y13so36896716edd.13
        for <kvm@vger.kernel.org>; Fri, 26 Nov 2021 02:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=onPF4lXpXF+Dn8bEb7/7mVOAXBedsvvB8Ezt0wTGXKc=;
        b=HFFbX/VlmMzUKvAkhM7xRQgGBYDvXZUScoQa88NqQU6PLV8XGX6Rx9CwAkI0cQNf2y
         t5F+I4nBuhTwqNIswkcVdiE/9PcydACzE+Qdsrp/okMZF9ZpBR4vT0V9jEokUCqrBeu3
         04taIm7qYlO+u7jQixr6jhs7BJF1W0mKcwTZm/Bc5wSvPnJoR8QpIRSTOsg7R3t4M6Ol
         kplMRoUvdLtPX1h5Sp4Z21oCit+K6dLB5Yrcr2Ci/JERKv62lab5a2B1DhFK0RQMEkTa
         7et34rxBLyglNJG302hX0WVj+nI8mkOcD4Tpx0dbMW72TIxPNn7hvwVCuif35x0BK+fq
         6jIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=onPF4lXpXF+Dn8bEb7/7mVOAXBedsvvB8Ezt0wTGXKc=;
        b=4CZ43XcMp/QDkh8IuB8+6SfQtJhEhdhL+durb0itkmwodhjWAK0RjGy7J8EKa7g2Hz
         cP6F3aFL/Zgux/3uDC16ZuBgU82lv7sbugaBbBZQ1KCMPmqQNop856BgyNThkUsEODtt
         y0ucbDThzJQGgr5sngbb9XzcBHdjyqu8cLCdMiRtuVBnSY0hsh7AJKVpzS3EGSkWg2eR
         vlR2rXbsE79F68zesbVHR+rgQsn3DuPOkHAr+mfDZFvnPSDjbvqhMlllKyo0ITMX7MGB
         VKNJMBB4QO2QGPM54tgx4K5+25vqbuPxTNegbT0f3qMgN+1YPkzqRO6s1+O2u9XcXK96
         FoLg==
X-Gm-Message-State: AOAM533qXGCFkziEi2PvR0djifjtE4mQlMaw5s3jCR6eDaeavM0A94zI
        Lq6tyjZglLUyT2Y5WeilBpM=
X-Google-Smtp-Source: ABdhPJzmbvzIUCYm4QDTRJ36NhFszX574agfn+UoV+J/pQcPrKORyNn6DMJIMuqbnSXcRTp0WWxk2Q==
X-Received: by 2002:a05:6402:5c2:: with SMTP id n2mr46265739edx.239.1637923337196;
        Fri, 26 Nov 2021 02:42:17 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id sh30sm2791868ejc.117.2021.11.26.02.42.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 02:42:16 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <6e375bd2-d740-a00e-91d9-4b1ab2f82cac@redhat.com>
Date:   Fri, 26 Nov 2021 11:42:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.16, take #2
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Chris January <Chris.January@arm.com>,
        Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, kernel-team@android.com
References: <20211125161902.106749-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211125161902.106749-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/25/21 17:19, Marc Zyngier wrote:
> Paolo,
> 
> Here's the second set of fixes for 5.16. The main items are a fix for
> an unfortunate signed constant extension, leading to an unbootable
> kernel on ARMv8.7 systems. The two other patches are fixes for the
> rare cases where we evaluate PSTATE too early on guest exit.
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit fa55b7dcdc43c1aa1ba12bca9d2dd4318c2a0dbf:
> 
>    Linux 5.16-rc1 (2021-11-14 13:56:52 -0800)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.16-2
> 
> for you to fetch changes up to 1f80d15020d7f130194821feb1432b67648c632d:
> 
>    KVM: arm64: Avoid setting the upper 32 bits of TCR_EL2 and CPTR_EL2 to 1 (2021-11-25 15:51:25 +0000)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 5.16, take #2
> 
> - Fix constant sign extension affecting TCR_EL2 and preventing
>    running on ARMv8.7 models due to spurious bits being set
> 
> - Fix use of helpers using PSTATE early on exit by always sampling
>    it as soon as the exit takes place
> 
> - Move pkvm's 32bit handling into a common helper
> 
> ----------------------------------------------------------------
> Catalin Marinas (1):
>        KVM: arm64: Avoid setting the upper 32 bits of TCR_EL2 and CPTR_EL2 to 1
> 
> Marc Zyngier (2):
>        KVM: arm64: Save PSTATE early on exit
>        KVM: arm64: Move pkvm's special 32bit handling into a generic infrastructure
> 
>   arch/arm64/include/asm/kvm_arm.h           |  4 ++--
>   arch/arm64/kvm/hyp/include/hyp/switch.h    | 14 ++++++++++++++
>   arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  7 ++++++-
>   arch/arm64/kvm/hyp/nvhe/switch.c           |  8 +-------
>   arch/arm64/kvm/hyp/vhe/switch.c            |  4 ++++
>   5 files changed, 27 insertions(+), 10 deletions(-)
> 


Pulled, thanks.

Paolo
