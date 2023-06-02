Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42BD71F7CA
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 03:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbjFBBZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 21:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233459AbjFBBZQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 21:25:16 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00062198
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 18:25:12 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b01d7b3e80so14223405ad.3
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 18:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685669112; x=1688261112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y9ogo0ACLRXvN9mYdk6iIQOzAO0yNB55tAwPeqYZ6uA=;
        b=fXFTlIW2NrYvQfix8ljatUPE1vnGf8igwXZjblSazTj1v7yw+YHbbG0YYLv6qEkHOD
         AtjWpnV1P5frULvo6fEkTw6zDEtAcxUTw/04caL8ezjnLMYZWsqBJcD8NwcFqOauomVB
         ybXs7sGlTvtBqTWWPMmxGfsm3jfZCW57xECjygrjCePaMIjyzPe/QQeBBN3LxQoFM2kY
         IG87Cu13HtaHUTgCfIESH2OFILtui7imzIJs3k4Eao/BGUW8Dx7ooaB7DTkUh38IWxKS
         nKJzxKoUWQapYg3X0aqy11J1MW/13BlNPWTElYoRIY86ZM0pvEKOJ2ceKVInUCLOEZ4w
         4k9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685669112; x=1688261112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y9ogo0ACLRXvN9mYdk6iIQOzAO0yNB55tAwPeqYZ6uA=;
        b=c7a/R/vOmJuARdJu5LuqUwjWpQkz4Qpk8q4JK/Om7+PEZzfzFPvRuR3IbBfRMMnj3r
         AZvOyaL8PHASoiGDhq6FDlxrZtFYPQvXMx53Gmp6ra0m2O6VLQ6+mMI8/HIvqk0Mc4uB
         cuRhs7lDy2g6KE8VluxAIniuBeW0FFkNkO/THjCuyg0PsAJ/R5oI3ff/Y197MrkZSjCO
         kxkjPTyRIY32xQbThbsoh9Yy6TBjgVImlS7+aM37Tc8yUbodBAuAmRSr6M1UYwKIefaa
         fVPv4TQoH5/MiyilOWBKvJAHreNQN+t4muoE+DD4XdKUNO6URge2AMgsKZJOQTpklUZ/
         /PNg==
X-Gm-Message-State: AC+VfDzFG9VmiDgPgU2bkJ07yYrowkdmmmSyMe4lqjDBvErNlrYAwBz5
        oB3VY+LZHO+XQdEsxYI09dbz/NEEAHM=
X-Google-Smtp-Source: ACHHUZ5ON75IRIcN2tIJppeawkiG3e6QBxtwTIPutsCSCn/nqvH5ACl+7kjzQXtu5Tpy04tH/jiZI2DvMao=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c20d:b0:1ac:6a97:5286 with SMTP id
 13-20020a170902c20d00b001ac6a975286mr277309pll.5.1685669112526; Thu, 01 Jun
 2023 18:25:12 -0700 (PDT)
Date:   Thu,  1 Jun 2023 18:23:34 -0700
In-Reply-To: <20230417175322.53249-1-colin.i.king@gmail.com>
Mime-Version: 1.0
References: <20230417175322.53249-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <168512562861.2752648.4897347510489297628.b4-ty@google.com>
Subject: Re: [PATCH][next] KVM: selftests: Fix spelling mistake "miliseconds"
 -> "milliseconds"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org,
        Colin Ian King <colin.i.king@gmail.com>
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 17 Apr 2023 18:53:22 +0100, Colin Ian King wrote:
> There is a spelling mistake in the help for the -p option. Fix it.
> 
> 

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Fix spelling mistake "miliseconds" -> "milliseconds"
      https://github.com/kvm-x86/linux/commit/56f413f2cd37

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
