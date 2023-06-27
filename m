Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D4073FF5F
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 17:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbjF0POG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 11:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjF0POF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 11:14:05 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E95E26B3
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 08:14:04 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-9891c73e0fbso837972066b.1
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 08:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687878842; x=1690470842;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1hLkHKgBAbZUuk0W8oE9AqIRXF820+oX61/uVYQAwns=;
        b=RHSJC9x8UfCPz2FSbqOh2Ao54TcsCXhLbDK36yeB1DEJ4hj8Sl//hI37GaNYUgS+fs
         y4GXgRTnzQOM1uZVi38YmTqIyNo79pOMoci/EMI21MPW3l/lqt4OWFxhD0crUv1+Jlb9
         HAOtsR6oW56BaUJI4kAcsAxbPwP1gziEWSlXXCLlw13fsJZ46+EXCC7yWYT+y9jAT4m2
         e37yJcRCJEf80dlpoCKw2ihRR+G97nQEWmYOKSl3kIWFhrwA65/8u/9cIRWyQlcvD9VH
         FtltpgqEHEOcfVtyLsREChlxiSDkV4CjXzltjoOAxfty5o4YqGw18zEI/gJw6anC6zz4
         g8oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687878842; x=1690470842;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1hLkHKgBAbZUuk0W8oE9AqIRXF820+oX61/uVYQAwns=;
        b=RKm3YfLLDgiau0w9UpKjN9qwKZQ0s0PN/QOKqta6eNhL2y36bNBdjyNwGawLjoQaqC
         CrJPzHzh0mMEOMOcITEdL0OerMOtZAd88mS9jm45HBOER+kKmuoluJwzedlTIR7AV/0T
         UkmJPSYRY+UXfR+cjEi7v38AKPVF4VqgMM1DimXxPqtdc1DMMcIy2r1JglShkz1k1VlT
         b3nUHm8cMm5R0FeiASuVXYLrQoV5+8axfe3VVGeYQqYESVPSpvcJ2EJixJmfUB0dzvk1
         XjrW+7VQRjS18Y6Hn5knXBtnyOL+28N442M4JOwxrlSUtTAEbgz28z6XPGNOn/KodwWH
         vB9w==
X-Gm-Message-State: AC+VfDzeEQX+Udo3xx3KgcchucVYVeuuGwRNZ/qivJ7Qa5oWBLVfak+K
        8+iECToYPpegKldxezD2zMr5GwOxpF45AORG5bg=
X-Google-Smtp-Source: ACHHUZ4N32hEou6vtUW/NAB1itCDeEMec+9QDxvX9fKtvB6/ovOV17I4ogYzFcIiFUizKhcJXoAQ3g==
X-Received: by 2002:a17:907:3f87:b0:977:d660:c5aa with SMTP id hr7-20020a1709073f8700b00977d660c5aamr30961510ejc.31.1687878842634;
        Tue, 27 Jun 2023 08:14:02 -0700 (PDT)
Received: from [192.168.69.115] ([176.187.199.204])
        by smtp.gmail.com with ESMTPSA id ss26-20020a170907039a00b0098e422d6758sm3262608ejb.219.2023.06.27.08.14.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jun 2023 08:14:02 -0700 (PDT)
Message-ID: <dcf96b9e-16c5-b1d5-14a5-276fc0556bee@linaro.org>
Date:   Tue, 27 Jun 2023 17:13:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH v3 00/16] accel: Share CPUState accel context
 (HAX/NVMM/WHPX/HVF)
Content-Language: en-US
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Roman Bolshakov <rbolshakov@ddn.com>, qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Alexander Graf <agraf@csgraf.de>,
        xen-devel@lists.xenproject.org,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        Paul Durrant <paul@xen.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Cameron Esfahani <dirty@apple.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230624174121.11508-1-philmd@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230624174121.11508-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/6/23 19:41, Philippe Mathieu-Daudé wrote:
> This series is part of the single binary effort.
> 
> All accelerator will share their per-vCPU context in
> an opaque 'accel' pointer within the CPUState.
> 
> First handle HAX/NVMM/WHPX/HVF. KVM and TCG will follow
> as two different (bigger) follow-up series.
> 
> Except HVF/intel, all has been (cross-)build tested.
> 
> I plan to send the PR myself.
> 
> Since v2:
> - Addressed rth's review comments
> - Added rth's R-b tag
> 
> Since v1:
> - Addressed rth's review comments
> - Added rth's R-b tag
> - Converted HVF intel (untested)
> - Rebased
> 
> Philippe Mathieu-Daudé (16):
>    MAINTAINERS: Update Roman Bolshakov email address
>    accel: Document generic accelerator headers
>    accel: Remove unused hThread variable on TCG/WHPX
>    accel: Fix a leak on Windows HAX
>    accel: Destroy HAX vCPU threads once done
>    accel: Rename 'hax_vcpu' as 'accel' in CPUState
>    accel: Rename HAX 'struct hax_vcpu_state' -> AccelCPUState
>    accel: Move HAX hThread to accelerator context
>    accel: Remove NVMM unreachable error path
>    accel: Rename NVMM 'struct qemu_vcpu' -> AccelCPUState
>    accel: Inline NVMM get_qemu_vcpu()
>    accel: Remove WHPX unreachable error path
>    accel: Rename WHPX 'struct whpx_vcpu' -> AccelCPUState
>    accel: Inline WHPX get_whpx_vcpu()
>    accel: Rename 'cpu_state' -> 'cs'
>    accel: Rename HVF 'struct hvf_vcpu_state' -> AccelCPUState

Except the MAINTAINERS patch, all the rest is reviewed, so I plan
to send a PR tomorrow (dropping the first patch, nobody complained
about Roman email bouncing for months so we can keep ignoring the
automated emails).
