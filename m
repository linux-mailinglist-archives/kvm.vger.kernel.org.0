Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0306DB6E8
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 01:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjDGXJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 19:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjDGXJt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 19:09:49 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD0FCC25
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 16:09:34 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-517bd9b1589so21406a12.1
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 16:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680908974;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XvSIGGl7kyzrRPKD+1h4YAIP7+IU0OISKySWyKHO+jg=;
        b=iv6gr2hKVqwKYI+iTQN+8od7y6Vm/m73ky9/2diyxBhZPqEorU219WD2XJzyvYDYRT
         EQnhzs/V9uvYpJLy4VBiCLJDPSSyy/mk7kdUnBMVS5pdIZkqIfGf52EThRLsFjAEdEsI
         75R64mVKrvYX9fSs1K2fFq6b2G/rdvEnYm5oV115etWVrXcUd06SIATm2soLvb5zJ2rS
         aLj36ZCRtc9CMFkr4v9c3m54c5MWwJYwceHUVQL+Hc3QAWiaTznLDbwG3uZRQ1o+xHSV
         QewZOhFy9l4j9VEGUvSVoAuQtIMQ9HwTJxUwxMmvV2wdOiXGWIwjq9EvrUIb00tY50Wg
         1WyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680908974;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XvSIGGl7kyzrRPKD+1h4YAIP7+IU0OISKySWyKHO+jg=;
        b=AygpYZmBJB5IFXgnm2zhMMr4xRWNwuEa8Nigi44N0UcMSzs2E8bM4YWbqZOvUPCntK
         LNqkVDhW7CecJawiF4JejHvgjYMH0tyVHhN/uhSuutp1iiJ0WN5oAi1Vv6d1OGyIrKzz
         zX8iONoWjppDZPw89Rw5QplW1MOhOxGTcg4aVxDTgQNig0idhvE+wEca8nKvpHppX76T
         RigozL6mHG5FDbtMiU46u02kCaijyJmCWl8S7FFIKLpMvoNOfQVfW7Xo7EtoX4/PNhRQ
         FoVAmylQ3eQPYA1iuhmG0m68/KRm6UZQNDpfs5rVfY6TcI8uv7RV9qyzwhwuxTesjisB
         B29Q==
X-Gm-Message-State: AAQBX9eQYy27Co2e/xxaKVPMQjFTblvnFJe6DYQO5VDn434h2kjhHNt5
        MCG3j5DSS92HCrJr/5qRH5i15w==
X-Google-Smtp-Source: AKy350Yqp9FrNOy78lp7BrA74JA2K1IJ9euoV6m53eCZnb3f4VQZGuFjTlRtLSsG6RBgf5M2spk2Qw==
X-Received: by 2002:aa7:8bd1:0:b0:62a:9d6f:98dc with SMTP id s17-20020aa78bd1000000b0062a9d6f98dcmr3877311pfd.11.1680908974132;
        Fri, 07 Apr 2023 16:09:34 -0700 (PDT)
Received: from ?IPV6:2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8? ([2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8])
        by smtp.gmail.com with ESMTPSA id f3-20020aa78b03000000b005aa60d8545esm3564626pfd.61.2023.04.07.16.09.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 16:09:33 -0700 (PDT)
Message-ID: <48b9e338-e20e-95f9-c611-3878b24ccec0@linaro.org>
Date:   Fri, 7 Apr 2023 16:09:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 07/14] accel: Rename struct hax_vcpu_state -> struct
 AccelvCPUState
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>
References: <20230405101811.76663-1-philmd@linaro.org>
 <20230405101811.76663-8-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230405101811.76663-8-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/23 03:18, Philippe Mathieu-Daudé wrote:
> +struct AccelvCPUState;

Missing typedef?


r~
