Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE542602D50
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 15:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbiJRNrM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 09:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiJRNrK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 09:47:10 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E57CD5F6
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 06:47:09 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id n12so23523712wrp.10
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 06:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X10zFHk+gUIqg0hoNlnRehZH3QTQ8G8IZ5CuTIEOKRU=;
        b=Jo0YpKBq6S17OGidEUkOtG6CIDckvoTjyeiOf3FJFuqJhcB1MjFa9POa9b+n0qc4rF
         CBZDlWM2SxNudvn9J3lODCzlOgOS43+tEOnSOFXvGhtz7Yb4NoWOfJZAZy9ftaSAe6Dw
         lKt0Vza1kvDD/U+Y/FFj9sftC3yJQpgovOyPKR2hJ2MmBnr9u3CrKbFkIkvwoDlfXDnp
         WsWtwSrjNDjvLnIragodfcAiEZvciSP9UoEoNuxhMsGaI2BS+x6SOG1IOrGgr20C5Xd2
         92XMCC1gzXED3dYyYvvOgqB3olBBa1czOZXGzYydGzXXw+K/41oJnaS9XNfAhfgRWngP
         jKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X10zFHk+gUIqg0hoNlnRehZH3QTQ8G8IZ5CuTIEOKRU=;
        b=KyZPgM25MwVeWXk2z7XCEo8T24Sz6UiVtWMb+c9hxS6YUwHAgi7AdvO3TPpKoPEIXK
         BQGqD0RK8xG5aE5hGF/FS5jrkS0r4tgSma55Cb/q6tPrDX/Y6dX7/pSiOxpiHVfAMARo
         LreinetsZAiS44869iL+lSTfPIovAnTj7qLOW2ueD0cAJ6gi7DHiIPJkCACTgf49/hTC
         dUS+xXbQ+WsFehs/agCHhtM+BvNdxm+1PpWBh9KckfXW9lIrXUfhf5jCG7GoSu7u5nG9
         VUmUz0yj3kNXf8e+IzZN/4VwqDZv7QqevLa+wOOxHN7Ka31pDs86tetnWAlOq5jmYuLF
         URaA==
X-Gm-Message-State: ACrzQf31i8NWBvM1As4fG9feAbt6SfIqRPlgtuzXxeTJYZgiKITY/wWn
        tnuzMmS2wKMYY8W1iUJ6VxDJtQ==
X-Google-Smtp-Source: AMsMyM7g3KcQodof7aZl4G/4Hay96DX13W05O52I0GTomWaZMDcoMucMWfCtAn2SPEvunfMdGk9SCA==
X-Received: by 2002:a05:6000:168f:b0:232:bd06:d5c4 with SMTP id y15-20020a056000168f00b00232bd06d5c4mr1947910wrd.122.1666100827986;
        Tue, 18 Oct 2022 06:47:07 -0700 (PDT)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id c10-20020a05600c0a4a00b003c6cdbface4sm13980107wmq.11.2022.10.18.06.47.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Oct 2022 06:47:07 -0700 (PDT)
Message-ID: <dada7b09-b853-342a-1d07-9f1e636941c3@linaro.org>
Date:   Tue, 18 Oct 2022 15:47:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v4 11/25] KVM: arm64: Rename 'host_kvm' to 'host_mmu'
Content-Language: en-US
To:     Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev
Cc:     Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-12-will@kernel.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221017115209.2099-12-will@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/10/22 13:51, Will Deacon wrote:
> In preparation for introducing VM and vCPU state at EL2, rename the
> existing 'struct host_kvm' and its singleton 'host_kvm' instance to
> 'host_mmu' so as to avoid confusion between the structure tracking the
> host stage-2 MMU state and the host instance of a 'struct kvm' for a
> protected guest.
> 
> Tested-by: Vincent Donnefort <vdonnefort@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  6 +--
>   arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 46 +++++++++----------
>   2 files changed, 26 insertions(+), 26 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
