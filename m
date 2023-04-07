Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320856DB6C2
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 01:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjDGXDy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 19:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjDGXDx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 19:03:53 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77313CA22
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 16:03:52 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-62e2a2e0229so182562b3a.3
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 16:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680908632;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hZqP/mMtrcpUQSJ0MIEuq6L7i9BJbItpoxQhlUdV2j0=;
        b=OScsKdJq+aKS4EMfnsQDF1A4ZpE9lHLC3dBugCWoYJ+T+zxfKuy7Bcfowv1Z4sMNGt
         5Tvqtj2tiQHF/cjx4hdeKJ6bZl9Y/HxUihnLOA+u6o+0o8KEhFMiBHXApK9qw2CCJXQY
         B/O1pBojgVNojn4tHZwtZ9Gj8964Bhc4vqVPOXtmkWUbZHDB/khpku9T9hNbVRaYpnKf
         6WkmzIgkqbHy5Lu85TuUalah4TTDdXAr+WRzB+W03rr+p/gGfvJi+W66/flHhGLrSK6a
         w5iWxWFxH44qZpC/JwuKPFVtQLmfZeKHX2acjMCobg3Mcp8TCtZQwPxUU3D6tMzl+TdP
         a4Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680908632;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hZqP/mMtrcpUQSJ0MIEuq6L7i9BJbItpoxQhlUdV2j0=;
        b=Cm5Hfqa7e2aLVrp+uu+vIeIauFrddUYW/BPKrPUAtS41vwTavB53QE9y9T951qWfZ5
         800j2I4aSQUtHKFgVWdDJ28tvsK3ODembVZcrQnHg36Vm0zwWgEwRBKEL5EPkOB2fbSd
         CjGAzQLud93hqZHZqx2a2Zhr9ddW97zEz3i33ryMHvi07QenxN5OHSOCc3zKLsz5LzrN
         RYXULxiJs5k4Z4d47QwNyHLzwn5jrj2E+wwZTVSE6rRnkeI1VyXvRqbek0GPS3WbKILf
         acECFD2CVhURiRUrBg/x8m3BjtDxlupAL0+EwOI1REmxWkrwXV8mDKwd+QbWr+wuXzg4
         ZW5Q==
X-Gm-Message-State: AAQBX9cMgGm51AJFliMJ9JGRUbr0vUIG/iOWIXvH+ub7glbB/m0biliU
        qA1Ug4mv7sFbfC/ZOjCNc3Aa6A==
X-Google-Smtp-Source: AKy350an52aELf6hlPTEwYKQg2oGfdoio44PzUivo7lHIUSuO2HA+GtnFtvlc2ICRNAVAvj8q2M6tQ==
X-Received: by 2002:a62:5e41:0:b0:626:2ae6:31f6 with SMTP id s62-20020a625e41000000b006262ae631f6mr3993369pfb.7.1680908631953;
        Fri, 07 Apr 2023 16:03:51 -0700 (PDT)
Received: from ?IPV6:2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8? ([2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8])
        by smtp.gmail.com with ESMTPSA id b13-20020aa7870d000000b0062e26487e7esm3525658pfo.155.2023.04.07.16.03.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 16:03:51 -0700 (PDT)
Message-ID: <f28d2337-37c0-5a93-438f-7ce0ea7fc565@linaro.org>
Date:   Fri, 7 Apr 2023 16:03:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 05/14] accel: Rename 'hax_vcpu' as 'accel' in CPUState
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
 <20230405101811.76663-6-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230405101811.76663-6-philmd@linaro.org>
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
> All accelerators will share a single opaque context
> in CPUState. Start by renaming 'hax_vcpu' as 'accelCPUState'.

Pasto in 'accel' here.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
