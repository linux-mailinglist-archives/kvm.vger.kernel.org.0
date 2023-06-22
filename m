Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3CA73A7B5
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 19:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbjFVRvX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 13:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbjFVRvT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 13:51:19 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B191E1FE6
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 10:51:17 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4f76a0a19d4so10386693e87.2
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 10:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687456276; x=1690048276;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9RxDEfypLP474dWXJLDSfwdHncLLmi9Gthq1bxnH6Sg=;
        b=RiVWMtP0j99xIRYUNXDURWNefogBeHrukb98HKl2KpQPFeqzG8I5jV1I8RYGUIxgwH
         sBTf6FPI0LAFSEQpvawCbcgioqZrrkhjCenDgar1wInj2SzuwqjwDBLhQxIR2y/WHDOD
         uDQ5+I4pvWVB6lwB5UW3bgC25Cd4/1Dr4pX5ff+Xtzu5kIWnQxozPwnZBupIPOtpEfbi
         AxCY/kmKMitTxzq+qp51TgVcvHwWugs+tFjPpja+shXEeqz4rfRWJr73IzbwST2ryOSo
         yu3gSElU9n8FQ6tnrRY0Gl+RD1sXGK1RjAue2K0BBFP2LCwPwBr1gimeAqkmcjsllPjQ
         725w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687456276; x=1690048276;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9RxDEfypLP474dWXJLDSfwdHncLLmi9Gthq1bxnH6Sg=;
        b=dHGLMolWpsTq3JrAkU2oAkIqIt8Yu2IvoBPCypUMul3/JZK1wyYZ5bac8B35RG/KDp
         +cu2GhRtgawArk9q984dh3I+Y3VMbe4c/h6u/4UYPVSAp2IawxedjVzqH/8mXrTqW96I
         Nz/ypjTP75ovsp0WkYmYWKU/p3e8PiJjANXWUz3TfT73bgVVO4hXXtGE3zZ4i0dJzFUm
         xC9w7+KYuFWriiKg0msr859UIqDCZ+1xyL7ZOcFH9bsd9fKzmcnLJuBny7WfJFG7Zml6
         QvHAJK/KDhIeqYCyHPDQiLqaY3rQKbuhE/gIgv3l+9s/mhKN8nC/NhRcMa7QfSTSkLkn
         KA2Q==
X-Gm-Message-State: AC+VfDw+U6yne/t9stff9ckiMPGqfQ1Zb+MWVd3avwDKoEtPFMfcxm2D
        HHprnhsX1Lgl9/EQMUA5JM4gcQ==
X-Google-Smtp-Source: ACHHUZ4jTKt0S9wGV9j57uZV2AskBM6ykJg1BX+PUA6Y8ggImBM58aMPiFh3pdEHVJWhW5Jzj4GL0w==
X-Received: by 2002:ac2:5bca:0:b0:4f8:67e7:8a1c with SMTP id u10-20020ac25bca000000b004f867e78a1cmr2333897lfn.45.1687456275753;
        Thu, 22 Jun 2023 10:51:15 -0700 (PDT)
Received: from [192.168.157.227] ([91.223.100.47])
        by smtp.gmail.com with ESMTPSA id i14-20020ac2522e000000b004f24db9248dsm1195907lfl.141.2023.06.22.10.51.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jun 2023 10:51:15 -0700 (PDT)
Message-ID: <58c48176-c9b2-0184-a93f-3168f66b7d72@linaro.org>
Date:   Thu, 22 Jun 2023 19:51:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 15/16] accel: Rename 'cpu_state' -> 'cpu'
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Reinoud Zandijk <reinoud@netbsd.org>, qemu-arm@nongnu.org,
        kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Roman Bolshakov <rbolshakov@ddn.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Alexander Graf <agraf@csgraf.de>,
        xen-devel@lists.xenproject.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Cameron Esfahani <dirty@apple.com>
References: <20230622160823.71851-1-philmd@linaro.org>
 <20230622160823.71851-16-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230622160823.71851-16-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/22/23 18:08, Philippe Mathieu-Daudé wrote:
> Most of the codebase uses 'CPUState *cpu' or 'CPUState *cs'.
> While 'cpu_state' is kind of explicit, it makes the code
> harder to review. Simply rename as 'cpu' like the rest.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>

I would have chosen 'cs', since 'cpu' is often used for ArchCPU.  But ok.

Acked-by: Richard Henderson <richard.henderson@linaro.org>


r~
