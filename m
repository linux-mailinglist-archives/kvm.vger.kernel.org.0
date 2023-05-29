Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBC2714C34
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 16:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjE2OhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 10:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjE2Ogu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 10:36:50 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46691EA;
        Mon, 29 May 2023 07:36:48 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-2563ca70f64so1805171a91.0;
        Mon, 29 May 2023 07:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685371007; x=1687963007;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3G0tjgLaByKBQEVUEO/ofZvDTdqBJJR2GepbSwtmumE=;
        b=LAjzeJHAA9CM5w69GeU03Cn5J1WovnzG2udh0exv2HAtoBqx3a8F4DMeyE/rvVn1m6
         Obdk1pGH2qKn2ejazQ6Vse6THwSrnfa6XwrlBy6X5nv7ujPxZXeaesNH6dSwrX7yCDQj
         pHo5yGLvkCoC//hNjQSmO4zkq3ZM8a6fHkj2yWNkjqATc4exiHFqkkkN20/WcRANLf3A
         5VO7ubcH2Q5wcXhHIA/d2QLz0TAQrezn6IQHyrH3AZWwFnBIv26LW/A9M7EGlTQFrqRY
         TKvOB9MiRJKoZsDlTmvysmXI5Or6kTElIsDcMp3RQEy8+E5aXSm78mkZ6m3r4dJM0EyL
         CdDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685371007; x=1687963007;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3G0tjgLaByKBQEVUEO/ofZvDTdqBJJR2GepbSwtmumE=;
        b=W/FcKwMuXQ6fOsgG8Xz3Te3IZl77lbPEMRcIxMlFbEpCB2RkrSHdElQnKEe8VrBL9V
         /wiFeu1d1juTSln78jyCXMDHW8h9j7SjKpYPf6KOuIic619VivGx2JsGRdVlMc0TJowh
         FSHa/rZxRbmyaxPnXL1IoOFYgcR74muJ/X945f+3HGNKMVxj3ukj32xRdHHdKH0yKB2m
         TMXfiCcVqOMn6PnrmnYvuEF6g9Kj9+j41kl/BovNGDhNDnoesx+VA1FeQYUzCtxhComz
         vSGVCxe0F9KF7q5On+I+SatSz8DJOxNIoVEeBXg/OH5ZlzPA1M4mR6w8uhVt7W2H3xlM
         v5UA==
X-Gm-Message-State: AC+VfDzpg0x1ZKI3/juMJ5wGCOQUfxHhHswt/XrOkJstXseJtfdI7CuN
        tC2+1HzBtDfA9kV691h0VFo=
X-Google-Smtp-Source: ACHHUZ5VM6y04IN3OksdqB7DbO19L2kV9HAU4PZPtzg4slwt+oNKt06iEkgRR2Jdvfzap/6UREX6+Q==
X-Received: by 2002:a17:90a:2a49:b0:256:4196:f722 with SMTP id d9-20020a17090a2a4900b002564196f722mr9121877pjg.47.1685371007630;
        Mon, 29 May 2023 07:36:47 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t3-20020a17090aba8300b00256833cd9a4sm1743987pjr.54.2023.05.29.07.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 May 2023 07:36:47 -0700 (PDT)
Message-ID: <7f3842a2-879b-2460-229e-745b7122b36a@gmail.com>
Date:   Mon, 29 May 2023 22:36:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [PATCH 5/5] KVM: x86/pmu: Hide guest counter updates from the
 VMRUN instruction
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230310105346.12302-1-likexu@tencent.com>
 <20230310105346.12302-6-likexu@tencent.com> <ZG6AUjci2J9WpT2z@google.com>
 <CALMp9eSe+kx8s5rkypvHWjFr45L_foXiDi1Vdp3R=AmRwA3RAQ@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <CALMp9eSe+kx8s5rkypvHWjFr45L_foXiDi1Vdp3R=AmRwA3RAQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/5/2023 5:30 am, Jim Mattson wrote:
> Note that there's a bug in the original code for this that has
> probably never been fixed: it ignores CMASK and INV in the PerfEvtSel.

Regarding the emulation of CMASK, INV and PIN_CONTROL bits on vPMU,
please forgive me for never having the right expectations (so there will be no
correct emulation), an share more *architecture* descriptions of those hw
behavior, and it would be great to have corresponding selftests as a bug report.
