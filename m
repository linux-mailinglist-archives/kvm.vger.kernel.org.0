Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368776D8AD5
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 01:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbjDEXB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 19:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjDEXBZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 19:01:25 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB5A359D
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 16:01:24 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54c08e501d2so10426647b3.11
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 16:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680735683;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oSOXwYdMVY3lPaPTD4bJ8oGfLuU+kB31nzMhgxcQZj8=;
        b=NduADr29YhzX1EMld8eR55a9vztF2X9JaXf+DxIygrrIywLkD1klZ6khzDdH/A8XjN
         AATc8hrwkn+umxkYODcoz+/XFIF8gCYMxDe/p1Y3dVyh67SuAf66TxfqitZ8Q4xfBpgX
         5YBJ8AodEil0yaPOZZyAcwwQUN4CfxtIwda2kHOIjYWTVye9C8QiPg79iGQFwm2czLkt
         X7Pfdun0fvtKM9VXP9h9MGz9SRhvaH5+z1BT5yKk6xnfl5qjU3d5CpkNYtg1gCt18Ilo
         XJK4JO48CD5hVzWbjq8JAi7hnhVwVkr9kxLXKA3Ho9zcsv0X8h1dy0LyZ9Ndavuh133n
         uhTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680735683;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oSOXwYdMVY3lPaPTD4bJ8oGfLuU+kB31nzMhgxcQZj8=;
        b=PIyg2WjCvsyf44rlGqwXjsYBO2gSkHR3IGDpuadv7/FTYz+OGxS4yyJZ3REFtdKnHG
         xBtzdGZrnb+eGEhMc42TmaAer0gJs5zO3w+Vasx07OdlzMTkhT0Ou8tgxoaryh21sWNE
         8NyCvE61DKSqyGdsO+RD9d5zCxPWm7cF2bEHwaPZjb/AvP85Vgkh79/oQSm8Zlh9t7sQ
         PBEjuqw0fKjf6IUSessxCVvzAbOAbeRR/13ej1TIHQY5b3oxINefvH8ADWXHe63TlzGs
         Fk/w08mu3KfIaUoWb9Rk+LDXWygAPsv6rYShulNE5oddBRYxTpILDEXe7cM+Bz/WRcx4
         gzyA==
X-Gm-Message-State: AAQBX9c34IsxvPrgr3MgPPHBa4nMhrIRti9eiv53xk9H+kjoXupP4z1K
        V/iIr/hIQuBf5FE6QMAJNqRUdeB74qQ=
X-Google-Smtp-Source: AKy350ZR/ogu3NjqQ6qZFP4bJN9WudlLf/zqGzgk63Mio5JNwaOy3gHdWVVuB3rc8mqV5TQXFJ//zrfQQJQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:320d:0:b0:b45:e545:7c50 with SMTP id
 y13-20020a25320d000000b00b45e5457c50mr773755yby.0.1680735683292; Wed, 05 Apr
 2023 16:01:23 -0700 (PDT)
Date:   Wed,  5 Apr 2023 16:00:50 -0700
In-Reply-To: <20230307005547.607353-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20230307005547.607353-1-dmatlack@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <168073541667.619487.5616966651660201314.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/2] x86: Fixes for rdpid test
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org
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

On Mon, 06 Mar 2023 16:55:45 -0800, David Matlack wrote:
> Fix 2 small issues with the rdpid test that is a part of x86/tsc.c.
> Notably, the test is not currently running since qemu is not configured
> to advertise RDPID support and fixing that uncovers a bug in the test
> when compiling with Clang.
> 
> David Matlack (2):
>   x86: Run the tsc test with -cpu max
>   x86: Mark RDPID asm volatile to avoid dropping instructions
> 
> [...]

Applied to kvm-x86 next, thanks!  Paolo's "Queued, thanks" showed up, but I
don't see these in upstream.

[1/2] x86: Run the tsc test with -cpu max
      https://github.com/kvm-x86/kvm-unit-tests/commit/572fb7097fa7
[2/2] x86: Mark RDPID asm volatile to avoid dropping instructions
      https://github.com/kvm-x86/kvm-unit-tests/commit/a467f7679c7f

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next
