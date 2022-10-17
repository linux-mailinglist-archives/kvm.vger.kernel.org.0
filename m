Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27BED601947
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 22:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiJQUWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 16:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiJQUWx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 16:22:53 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A7A2EF0B
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 13:22:52 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id y10so9428284wma.0
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 13:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JrKN18W87AYFXD5PlQt7lxgKU8jhcXd6zar4jEw9XRE=;
        b=pYjyMUo9vjde9CwJEWDbvq8/0slw62HtVPwFTM+pDyhN3fHer0ZaXFvrjZfGVO4M/n
         avpoKj5eQelybWgryeuJYx+Bje4Wi4CULhjeXUwOpxW/ZwAgr6qB0aAgFMKJGqLZAS7x
         OrckU5NrYwte9OnfjmhIXtQ213T8Lc2i+oFvMLO0lCdJ6U+2SzCDtk5Dgrt28+vzUM+k
         JTHcaJmhCJymwEY9lv9KIeoZuWzakxlD5Xn4p0EOBHV5EU4XLRCHuVIsMjO0lw1p2x80
         EHKj4ebPnVdJcj0ofuhwYafhSMxExKeTmFcnjFmFnaxF/pbVApFhCIApJ5nDJnLD0AS4
         UiLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JrKN18W87AYFXD5PlQt7lxgKU8jhcXd6zar4jEw9XRE=;
        b=hVtB9P7KPLvoAJTrtmx3hY8WbdF/frulRmvRAs+lawfFx/KsL+WG47cTe3OO0yUypf
         HOsk7expyWptWWfZQj7jcwn8HjkSnLioTqVgIh4m5VgwaUwQHNrgT1X2D+Z6XxlTQncY
         n1X8jixN4uzcDW+n/ijsDM2v3/n1Rmx1CXL/PYuifxpYDJdQlSSIpsLWDdcMR6ruKrFm
         +1borQKPSL2k2ILF/o+QjTGeY8btp4AkLeb1Vd/eI44eqrgDBDGIIZrdrBlYu/s7rGlU
         V/0QP6F1mbmUX7uRcGZLPNaG7CG/TLAg1n4HTrX5r/tN8Nju/uHhgrP3dTbT3ITsSWvy
         BehA==
X-Gm-Message-State: ACrzQf0wrYgPcT34K9W5mR450ZlSs7knGZ5odWzVRL85cxb1r1RT3kyU
        y1Amq9BYAlAP+i842WE+WJunqw==
X-Google-Smtp-Source: AMsMyM4W02jJyaMrj6v6271VbUvwIuV9Pt8lCk+LFTp83BMflcvVqAx4MdjC3dhHrOAeVnRs8Q+TuQ==
X-Received: by 2002:a1c:7c14:0:b0:3b5:1133:d2ed with SMTP id x20-20020a1c7c14000000b003b51133d2edmr8588026wmc.133.1666038170648;
        Mon, 17 Oct 2022 13:22:50 -0700 (PDT)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id s16-20020a5d4250000000b0022e47b57735sm9093029wrr.97.2022.10.17.13.22.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 13:22:50 -0700 (PDT)
Message-ID: <d7ad8c43-95c6-fee9-e216-a3d51591ef69@linaro.org>
Date:   Mon, 17 Oct 2022 22:22:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v4 09/25] KVM: arm64: Include asm/kvm_mmu.h in
 nvhe/mem_protect.h
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
 <20221017115209.2099-10-will@kernel.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221017115209.2099-10-will@kernel.org>
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
> nvhe/mem_protect.h refers to __load_stage2() in the definition of
> __load_host_stage2() but doesn't include the relevant header.
> 
> Include asm/kvm_mmu.h in nvhe/mem_protect.h so that users of the latter
> don't have to do this themselves.
> 
> Tested-by: Vincent Donnefort <vdonnefort@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 1 +
>   1 file changed, 1 insertion(+)
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
