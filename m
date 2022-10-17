Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E7B601945
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 22:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiJQUVk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 16:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJQUVg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 16:21:36 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF200B45
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 13:21:35 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id bu30so20208787wrb.8
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 13:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k1u7aI7TsPzNC+sKs2nWIQ3B+Ftqwdw3M08sxDU40RM=;
        b=mvB1DFbaK7Qr98ZPCdxWcASPRWpnvlGxob0ycSb/6OzuZonFwRIrDzic0Q+mH4zulM
         bJ4s9GnjeBvCWDu2peHJ2OdzHPTIydfRjh+8hLvdgPORLTPeXdcXktYWb9XknM4rVdvt
         lH9mbjtNIEl8fpS14E4gmql+3rf0t6uySujhzyVMjuXXjE0rEQ1qxfVjX69TLgwsHV6b
         OkseUyXGdPSYwR2fa6INaKYpYyfDG6SZa2+502cVUQ8KU9XL48qeCCLIm1phD/xtmRrB
         uyTVqTRTuJjzO7q1D6ZIxuqYqIqw3lUQxO/50FPMtJuvqC/+2rbLD/nSisNdFb5WE+zX
         WRhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k1u7aI7TsPzNC+sKs2nWIQ3B+Ftqwdw3M08sxDU40RM=;
        b=z3Akd/0sZKYMGARbFtdY4MTfSIxK9akwTE3jdoqcHyE98tzXeeYESmSFcE4xGHbSpL
         hcKhwHsmc8LXEmATHN3Owa1YOrvIPeAd7XsXEdSub7xhQo+FbEQSiryX/IdWAoyaI4SD
         hbpyKblGMWtmZzCIYdDj+mjrzF0H9Bos/c7TYCNiq8JKD3BcnSi/lb3QSgvd0kvcmc5D
         xi8sTZM8qQTh9GZblv1qWxL8J8eDJF5WftrqfjEnKMU0Jrty68Tzt/plLoT/0x7DY8MF
         UaECfEZx+RiN3PNnlZSzUa8F0PW0e35iyQBZ1HtX42stjAPNeLHdbJqFmFWXukUOSxLM
         uOKg==
X-Gm-Message-State: ACrzQf0TMci+LuQaSOJWikGIpaDCiBQS2xGEx13/se6lC3Lgm+vK9BGK
        9fo9K7EJGto3RmJUS6aP5bbjUQ==
X-Google-Smtp-Source: AMsMyM67JkDwfaiIa163HL55bcN1xTzRwHfEZw3muA4DCl2oo61eArjO8BOIKzu1KCsaG8cY6U0Wvw==
X-Received: by 2002:a5d:59af:0:b0:22e:32be:60f1 with SMTP id p15-20020a5d59af000000b0022e32be60f1mr6918356wrr.81.1666038094296;
        Mon, 17 Oct 2022 13:21:34 -0700 (PDT)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id u14-20020a05600c19ce00b003b477532e66sm198597wmq.2.2022.10.17.13.21.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 13:21:33 -0700 (PDT)
Message-ID: <82faa705-c887-8c1c-2ab3-8ee33f5ba756@linaro.org>
Date:   Mon, 17 Oct 2022 22:21:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v4 05/25] KVM: arm64: Unify identifiers used to
 distinguish host and hypervisor
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
 <20221017115209.2099-6-will@kernel.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221017115209.2099-6-will@kernel.org>
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
> The 'pkvm_component_id' enum type provides constants to refer to the
> host and the hypervisor, yet this information is duplicated by the
> 'pkvm_hyp_id' constant.
> 
> Remove the definition of 'pkvm_hyp_id' and move the 'pkvm_component_id'
> type definition to 'mem_protect.h' so that it can be used outside of
> the memory protection code, for example when initialising the owner for
> hypervisor-owned pages.
> 
> Tested-by: Vincent Donnefort <vdonnefort@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 6 +++++-
>   arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 8 --------
>   arch/arm64/kvm/hyp/nvhe/setup.c               | 2 +-
>   3 files changed, 6 insertions(+), 10 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
