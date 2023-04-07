Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 862E96DB5CB
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 23:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbjDGVaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 17:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbjDGVaP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 17:30:15 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFB8C155
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 14:30:14 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e199-20020a2550d0000000b00b8db8a4530dso2101882ybb.5
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 14:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680903014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vYPq8AwRA75JijczTkRxvHK/tBvZRTY57s49oX1Ykp8=;
        b=JjSKyK0ghI+n2n6WkYs7pBEEv8CzmM+vM2buKnh+R5NxM7drEiKARST7GbiMEgE314
         l6ZC/Zqj4HzHf5Il2W/nNyTBA4ycRyQmKIK9+qs87IBAE0xhJBbqaATnMjPw8j3y7wlF
         7Lbpm421K4NIqVP3uBBNmehy2TCppOgM0yIzvbYcm15KGrrBRhHu0xyW1Sn4ou7GGE7w
         OqrlvIdJpkXifjBnnAr+h1BHTbJ1CMTzNOaclraIv5vjT1mEV8I2ickin3JdpvbweJ0v
         veZjR6qA9Le6HA7A7Yb/iadrQtgCJfLW4hb5Y0NsgNkWgbpgKGgflRaRPzMAhKyTFAIH
         d4LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680903014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vYPq8AwRA75JijczTkRxvHK/tBvZRTY57s49oX1Ykp8=;
        b=42fDZCn20xJEECi3i714eFO4YgoWYjwuT0hAQKtDltCyqmt+kgLM3S3/jMRjEeuel6
         6V81Xuo5jb96j8YHas5WF0QnBVnwPkj3q460Q0g3Intc+bDBsLvzkufAREb8tHUYPM0z
         geynMdj+LdZ+FqW8RbQYZjVPnj28+sMhlB3q6uEPx3wbQfEKJy9MglB0XqimCccgXjaU
         26oKkRgmtRU8QSPW7jdS8lQdoOhbZAnvLrlFNrdnSLpypTWFvh98SY/dYE3rH2Un6fd+
         gLpZOvSgR5ap6XFRmEQWindA8SGxWDiOx9MPlnHfX7tDnPRaTwCjx8nJVhs3pgM0Fhqu
         jc4A==
X-Gm-Message-State: AAQBX9fkD9QRHcQVLhC+8v1OfLz3Y3XVgA6p0bec8W7PTe8hwUSAX3pR
        M+jJmPQZ53IyX7nGscJUHAqGD1ODC80=
X-Google-Smtp-Source: AKy350bf+tpG54R4vH4SX+ilY39rfLPWmhUntcHYl3m11DWx9xyhqhzc5f9mglEiIxcO+L/1cxDUiRXEe4E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:cad1:0:b0:b78:4788:525b with SMTP id
 a200-20020a25cad1000000b00b784788525bmr2581462ybg.0.1680903014011; Fri, 07
 Apr 2023 14:30:14 -0700 (PDT)
Date:   Fri,  7 Apr 2023 14:30:06 -0700
In-Reply-To: <20230310113349.31799-1-likexu@tencent.com>
Mime-Version: 1.0
References: <20230310113349.31799-1-likexu@tencent.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <168090262913.941979.18246241626899412092.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: x86/pmu/misc: Fix a typo on kvm_pmu_request_counter_reprogam()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Mar 2023 19:33:49 +0800, Like Xu wrote:
> Fix a "reprogam" typo in the kvm_pmu_request_counter_reprogam(), which
> should be fixed earlier to follow the meaning of {pmc_}reprogram_counter().

Applied to kvm-x86 pmu, thanks!

[1/1] KVM: x86/pmu/misc: Fix a typo on kvm_pmu_request_counter_reprogam()
      https://github.com/kvm-x86/linux/commit/4fa5843d81fd

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
