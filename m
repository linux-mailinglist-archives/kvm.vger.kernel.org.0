Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B39036DB7BC
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 02:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjDHAUL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 20:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjDHAUJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 20:20:09 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0929A12842
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 17:20:08 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id nh20-20020a17090b365400b0024496d637e1so5451689pjb.5
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 17:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680913207;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h0AMQUjCxtldpfHAeD1rg9lCTkc7fsJtYxu4TaQAE2g=;
        b=Urec4esb1Mrf0yQ6Bwuaz6MOVesVE0SrmAKkK8nBgotE1BD6HoknBf0HfOXwxf08Et
         utBi6IJR1MmBKVlVfvnfd6lD31f/+l86esbWIn40yIbndhN1a5hGZxokuR7K80zBE84d
         Ych9lXXb2tG2cinp2j/iEhWKbxD7ebc96KYL8oebjodf5/Izp7XZJ1Pg0gKh//YT6Tco
         k3BKS5oWV5Uv4k23CcpGlRxWYgISlhCf5X/J/KRb6EN1vyM1/UXQKw1AqnMnBMlvOUt0
         Ktf+zl2Lbkcn0R5+0Zp4cfqPMFRmHxZPDS29EtxfEQZQGBTbwh/68AXqHqygts5vyeKm
         pUuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680913207;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h0AMQUjCxtldpfHAeD1rg9lCTkc7fsJtYxu4TaQAE2g=;
        b=G1Bv088fMosmGYhkmMfoKgUx0gIPjNYcyxcuLedlFsQTsivbVsKAmz+dYnLUb6B94G
         r1HZL0kxfaAdoV3iWvc39dgaY/zK6NF6fyEZh2hj0Vc59mFx+WX2TH9fMYkbDxIG5l3H
         DbMzC49zJf/dpyf8HjUegBfEydLt2nlOWfsmBYWESWRqvOObVaDqRNlWa8idZb1qRs98
         PUClabqU4eFe4z0Mg7p+h4TSx+d/EDu1QNhZnBDeYHutcVXQYAG+Grajid5pVdmKFE4X
         ug2lCZNFyJYQCat7WucTNbgLr/5bN4x0vD74gpYuX/4Rv4K9BixZn09Nl/2hOnLj8q3M
         EaHQ==
X-Gm-Message-State: AAQBX9cK2+MTDvyZMro9VQySJMs3mY2RZgbdlrKovPbYJ4wsd1paP0K4
        6xtOs3WH2GAaW1m2R5jwSLSHBg==
X-Google-Smtp-Source: AKy350ZCJRdXihePI0z7v+4mK45Od1zcrSdgXUXdoP6lajYBNurBO22Pra5e2rpRuWoPilSoA5FAqA==
X-Received: by 2002:a17:90b:1d8e:b0:246:681c:71fd with SMTP id pf14-20020a17090b1d8e00b00246681c71fdmr2186338pjb.6.1680913207517;
        Fri, 07 Apr 2023 17:20:07 -0700 (PDT)
Received: from ?IPV6:2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8? ([2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8])
        by smtp.gmail.com with ESMTPSA id d15-20020a17090ad98f00b0023d2fb0c3a2sm5198039pjv.46.2023.04.07.17.20.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 17:20:07 -0700 (PDT)
Message-ID: <268fe6ac-b117-9725-46d2-763e5a5b0c72@linaro.org>
Date:   Fri, 7 Apr 2023 17:20:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 2/2] accel/stubs: Build HAX/KVM/XEN stubs once
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org
References: <20230405161356.98004-1-philmd@linaro.org>
 <20230405161356.98004-3-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230405161356.98004-3-philmd@linaro.org>
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

On 4/5/23 09:13, Philippe Mathieu-Daudé wrote:
> +softmmu_ss.add_all(when: ['CONFIG_SOFTMMU'], if_true: sysemu_stubs_ss)

This when is redundant.
You can drop sysemu_stubs_ss and add each stub file directly to softmmu_ss.


r~
