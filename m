Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A2271F7DC
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 03:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbjFBB0h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 21:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233582AbjFBB03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 21:26:29 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928C419A
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 18:26:18 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53f6f7d1881so1402199a12.3
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 18:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685669178; x=1688261178;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RMULYAX6jlRxKBA4EdMrxCDOSKLKbTtkmmBDz0lDKHY=;
        b=CK60n0LUvN97yzrR2W9PMatwTT6vzQDpPswIRBWCpAPi7KN+G5yk9ZWbBUqsRn67xc
         UetW3hs6LOEYhZqGzJzJ1srcE5D0p/ICqohrsxUMdtMYpQTH4lVXPq+VoWMr0umQqF7E
         kYjGUCsaJ6KrJDgbn+WtKynwihorLYw1kcJaxbGJgj+gUw+BuYzrs48aQY6gmXERZv77
         83KFPYLW5neVSF0gi2nHS80uBZC3e9HUS5pfVxmM4Sy8fUjmX6NOcNxmL2xHR8WKkunC
         flJ9h5wga8hdSZbD81GbcAOazEHFHmF40hSSIeAS36lgj3neR79hPZ4euNq/QRYJucpu
         RhQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685669178; x=1688261178;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RMULYAX6jlRxKBA4EdMrxCDOSKLKbTtkmmBDz0lDKHY=;
        b=C7YkIMDT0Z5lrQf307oDNnn1/Ztp22XAaxG7P5+WWHU2G8OQsXc4i5AtnB66Y26zSd
         o+28+j2uTnF98PUsiGevCKtdNRX1TDl826Ex4OCCxx3VlDYWqXoiNAegJvQB/SaJgBPl
         /64iDXzD58FcSohQklHQGP3AIefLMmbN+uDGyhDEfUpejJT18BpAIU2wDERHQ8S6JqSD
         WRYHfFPIoazZrsdIWhc6YK5hpSubAYu8SPqTzt3KBOvyfUyc/FTU0OqefXrw/4CoxlVo
         xFlcQ0HY91yI6+qR52aJKr8WZifDigEreUmVSrxO36x0wixPUQr4/Meap8wY+9jhlY7A
         XP9g==
X-Gm-Message-State: AC+VfDxTVNbdnxBQGMIYGnjbrH52YhSD/SHJAWfzrBPjf3WZqHaFtoWi
        SbRLfWhQF0W6QvewlAsdf4zBMrRUnj0=
X-Google-Smtp-Source: ACHHUZ5vohpOJq5EzOE3Z5FhNP7pdI6aENNskBMIbHlaXmQ3v58mYRI75S+7NRDAZLPscmyoF5H0L7bjieQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:2cca:0:b0:53f:1637:305d with SMTP id
 s193-20020a632cca000000b0053f1637305dmr2175343pgs.8.1685669178068; Thu, 01
 Jun 2023 18:26:18 -0700 (PDT)
Date:   Thu,  1 Jun 2023 18:25:49 -0700
In-Reply-To: <20230413231914.1482782-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230413231914.1482782-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <168513424744.2796078.17034484182694789865.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: VMX: UMIP emulation related cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Hoo <robert.hu@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 Apr 2023 16:19:12 -0700, Sean Christopherson wrote:
> Two cleanups for UMIP related code, identified by Robert.  These are
> *almost* purely cosmetic, I don't expect any functional impact on real
> world setups.
> 
> Sean Christopherson (2):
>   KVM: VMX: Treat UMIP as emulated if and only if the host doesn't have
>     UMIP
>   KVM: VMX: Use proper accessor to read guest CR4 in handle_desc()
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/2] KVM: VMX: Treat UMIP as emulated if and only if the host doesn't have UMIP
      https://github.com/kvm-x86/linux/commit/3243b93c16d9
[2/2] KVM: VMX: Use proper accessor to read guest CR4 in handle_desc()
      https://github.com/kvm-x86/linux/commit/023cfa6fc200

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
