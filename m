Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C13E6D8ADE
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 01:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjDEXDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 19:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjDEXDY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 19:03:24 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630E05259
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 16:03:23 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id b1-20020a63d301000000b0050726979a86so11019852pgg.4
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 16:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680735803;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J/10j5DTTJ17swI10MwW836fd7EzWKXZNlP0bxV7M74=;
        b=UpEDUABI5cClThj1f37vkJFVORIAkSvhZSa5l29IxH8SZzdeeR0OnxYGssEb042/H+
         ouQOrERewZsnTIQo5bwrpNGIZekNVK/96QekGu4lkwyQMLMsd1/SLJVBODxMWArCAWiI
         KSnQoICLbEjIoL8UCyL5JWO7efyfFp4ACIl8UNW0lhd1CluxQ8avLdDqnTqW5Pgc3YST
         K68mwFDb2wTTHrJsM+fsw2JnqmvwqPSZrhfmfHeatM2t5MiwocTxddVnmvwThpH8o4gP
         zaz83FntTv3SlGE5F4YXpAksHOa+gn8ULXTYRQRQ6d0xpDxt05j3fFc3/alBaJJ4i9ax
         BxYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680735803;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J/10j5DTTJ17swI10MwW836fd7EzWKXZNlP0bxV7M74=;
        b=H0lKMkvbUvSPO9Lh3wEj++JNY2P9kmm7iq2FUHiMnq4UJT51/QlJXeoWtiiDCHHlTz
         1iPmC07rBtwBIv0Lt1Mdw+SW3R6NsQgAmcBXZL8uw7wFDRM/gVpgKmxaXQyh0+Gj3LM5
         if7kKPCZt/dCmagrdaNRHveNUW/gkipJh54lUvumWbWHOL89lcvuOBJR5Ax/4wN1uHvK
         f8xTRs2k+mfjSc4gWtTeC6Fv9jg7veqmAHQKWO/M/x5P6uilsjlEMUQhUChMGqwE/7Dm
         m5P+o8zdBX3iir73XyjddEnvIAa0Oz7406dtM3tAUgilv5g6lHTpdWFbv/gNw5/ovdVC
         ZWfQ==
X-Gm-Message-State: AAQBX9fTU6mQXVnwqIX0JuRyty5yIok9Rb4BeY+atkeADueCVZEvmcCE
        QSq73ZhV7tS946G7TZjmGQhzfEllYk4=
X-Google-Smtp-Source: AKy350ZhJvfmG44phYnKboAxMEX8LIEbHb+qpQppzFTazI7s+zcEhQD4aFKfS85rIsNeobh6QiRwg5ejgI4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:b18e:b0:1a2:13af:7c77 with SMTP id
 s14-20020a170902b18e00b001a213af7c77mr3194814plr.13.1680735802939; Wed, 05
 Apr 2023 16:03:22 -0700 (PDT)
Date:   Wed,  5 Apr 2023 16:01:02 -0700
In-Reply-To: <20230329105710.57968-1-thuth@redhat.com>
Mime-Version: 1.0
References: <20230329105710.57968-1-thuth@redhat.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <168073548636.619631.7910810750401534069.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86/syscall: Add suffix to "sysret" to
 silence an assembler warning
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>
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

On Wed, 29 Mar 2023 12:57:10 +0200, Thomas Huth wrote:
> The assembler in Fedora 37 complains:
> 
>  x86/syscall.c: Assembler messages:
>  x86/syscall.c:93: Warning: no instruction mnemonic suffix given and no
>   register operands; using default for `sysret'
> 
> Add the "l" suffix here to make it silent.
> 
> [...]

Applied to kvm-x86 next, thanks!

[1/1] x86/syscall: Add suffix to "sysret" to silence an assembler warning
      https://github.com/kvm-x86/kvm-unit-tests/commit/3c128d26cd4b

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next
