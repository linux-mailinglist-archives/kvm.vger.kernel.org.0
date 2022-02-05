Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C574AA70C
	for <lists+kvm@lfdr.de>; Sat,  5 Feb 2022 07:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351184AbiBEGJs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Feb 2022 01:09:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31589 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237797AbiBEGJq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 5 Feb 2022 01:09:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644041385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9DjdP0NZq7FEwMEfMYlhPQOzj1IUaS2o/1SDmCK+oqQ=;
        b=bCvhemCAnUBYBXUjSY4XrarFaxf+UtDM0NAJAqYazVmbot0HhetJnfUzJeATQZYBt3TTP0
        h8SHkNkNkoQerWUw6fxnad1lU31JelwW/NCmCmMa9cbY9qRXj1zyfF+Xrft5RUiFF+TiHL
        mYHX0zdDf2sTYOBXvHaqULRhN6VnRAw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-318-KMCtjTJFOtmz1sG-36pAaQ-1; Sat, 05 Feb 2022 01:09:42 -0500
X-MC-Unique: KMCtjTJFOtmz1sG-36pAaQ-1
Received: by mail-ed1-f69.google.com with SMTP id i22-20020a0564020f1600b00407b56326a2so4212726eda.18
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 22:09:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9DjdP0NZq7FEwMEfMYlhPQOzj1IUaS2o/1SDmCK+oqQ=;
        b=j/Q05dXGhG5ndKoWY2WAdqWPD6zQBftTxg6pAUh777e6ROXV7PodB5cigSrpuG1+tS
         UC7sXGW8RjTFzcep7Bo87Qf857a1RvVciBiwhZXTvIYacVsePSbjhrWD5VGCa+1rGz3m
         TIx6BKB9Que2LoH5EdLiTNcF3fhsMU46Ofy2kg9D+zUxUtp9D21yI1nGpt3YA1Bk+OXU
         oa5c+BuR8VM/+DKfPELjnx5zmBVYpq8FzrcsmY18OahySw6Wqadq1THbJMqEx42slcY6
         yEpXHq9MEmutyhP3vCP42E/O2dfYQaySIePLYxTUbxQHjNjNvHb66pViNHroUMdafBBQ
         UuDg==
X-Gm-Message-State: AOAM530iz5dOlHrargnAFXV5ByWodwgiKTGUAE4w+GeyOUPj6tdd8n9h
        lF3Eseq+tExD7frkCUjMsn9j6ENNSH61F90M9GfcDFUdaYlU+kBM2utHeYxwFPIGJwnmOJwKOhp
        ueutwxusZMzu/
X-Received: by 2002:a05:6402:90b:: with SMTP id g11mr2688586edz.69.1644041381535;
        Fri, 04 Feb 2022 22:09:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzDdtdx2OjSz5RZOamZ7u7/zDd1EnnB169l8sfvPwQjBB817q7JLa+K+N6Qip6n0byyG51eeA==
X-Received: by 2002:a05:6402:90b:: with SMTP id g11mr2688559edz.69.1644041381267;
        Fri, 04 Feb 2022 22:09:41 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id d6sm1673811eds.25.2022.02.04.22.09.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 22:09:40 -0800 (PST)
Message-ID: <f41961a1-1248-7b6f-c19f-6d25565d93cf@redhat.com>
Date:   Sat, 5 Feb 2022 07:09:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.17, take #2
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     James Morse <james.morse@arm.com>,
        Steven Price <steven.price@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
References: <20220204135120.1000894-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220204135120.1000894-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/22 14:51, Marc Zyngier wrote:
> Paolo,
> 
> Here's a handful of fixes for -rc3, all courtesy of James Morse.
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit 26291c54e111ff6ba87a164d85d4a4e134b7315c:
> 
>    Linux 5.17-rc2 (2022-01-30 15:37:07 +0200)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.17-2
> 
> for you to fetch changes up to 1dd498e5e26ad71e3e9130daf72cfb6a693fee03:
> 
>    KVM: arm64: Workaround Cortex-A510's single-step and PAC trap errata (2022-02-03 09:22:30 +0000)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 5.17, take #2
> 
> - A couple of fixes when handling an exception while a SError has been
>    delivered
> 
> - Workaround for Cortex-A510's single-step[ erratum
> 
> ----------------------------------------------------------------
> James Morse (3):
>        KVM: arm64: Avoid consuming a stale esr value when SError occur
>        KVM: arm64: Stop handle_exit() from handling HVC twice when an SError occurs
>        KVM: arm64: Workaround Cortex-A510's single-step and PAC trap errata
> 
>   Documentation/arm64/silicon-errata.rst  |  2 ++
>   arch/arm64/Kconfig                      | 16 ++++++++++++++++
>   arch/arm64/kernel/cpu_errata.c          |  8 ++++++++
>   arch/arm64/kvm/handle_exit.c            |  8 ++++++++
>   arch/arm64/kvm/hyp/include/hyp/switch.h | 23 +++++++++++++++++++++--
>   arch/arm64/tools/cpucaps                |  5 +++--
>   6 files changed, 58 insertions(+), 4 deletions(-)
> 

Pulled, thanks (and sent already the pull request to Linus).

Paolo

