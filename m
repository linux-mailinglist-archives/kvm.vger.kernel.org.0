Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 215417BC086
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 22:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbjJFUl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 16:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbjJFUlY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 16:41:24 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69994C6
        for <kvm@vger.kernel.org>; Fri,  6 Oct 2023 13:41:23 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1c6219307b2so19033275ad.1
        for <kvm@vger.kernel.org>; Fri, 06 Oct 2023 13:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1696624883; x=1697229683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GURnAZx4gtWmv3AO8Lj9TIfuZbs5tNuLiF2FqF49VSs=;
        b=krRBrzE6RdWQLS1Kr2aqyhkC3AsH3Du0XzkaTXACJWr6DDhf0z7dPQuuCAG5qopxdw
         fF7IYr1QE1Cw9KyxgV6lpIAaam8d5YUE/tXUkAXfB2b4gjz1VNiRAVinKFMcuhD81dfI
         FQNnpKUHPCN8BcI3tbSNALRW0jIWUSfMoXODY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696624883; x=1697229683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GURnAZx4gtWmv3AO8Lj9TIfuZbs5tNuLiF2FqF49VSs=;
        b=pwZbE4MJnnkSVTvkjIUcPZfmtjLdeK7Hx9qaYS5Xq4xFOqppkn2TTiASFeZgl/vpaB
         jSD8QSu5frzXCdzAuhTTXUPPBQklZP403cRmL58ezlBRZZn+dxfelwXr+HKgxaCoA038
         /pxX9Z4846xre3zwcxAUiBIP6HtV5zKKncOKjeRObpggRbePbK2wusQ5SNKbhPTX5l/y
         VRyeCi6XNCjiKJiyMOobwaciog2XQQ1+/excbTYpWAwJCNDr4HRbusYx6tZ6AYiYHw2h
         UUiBMtIHhia0Yaen8eG2iDiJImxklPWU+pxdQsFf3AZfb9NT5PbVruhiJZ6ZaIZ6Y4I0
         QDZQ==
X-Gm-Message-State: AOJu0YyXVaA5sBJSIXra+6iIwPzhSIRZc6eixrflUIZBm0tjP/Hd0dtJ
        pMzSlY7M+G5rrlmt2O6erS6ayw==
X-Google-Smtp-Source: AGHT+IGYMji8WWmS2cMJoZ5nClhJOhH5qp5E4dC5W/5rnEY2qlLb77bHw85K9B2xCd+v5N5AN6yVWQ==
X-Received: by 2002:a17:903:25c3:b0:1c5:76b6:d4f7 with SMTP id jc3-20020a17090325c300b001c576b6d4f7mr8158493plb.36.1696624882955;
        Fri, 06 Oct 2023 13:41:22 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id t17-20020a170902e85100b001b9c5e07bc3sm4348373plg.238.2023.10.06.13.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 13:41:20 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Kees Cook <keescook@chromium.org>
Cc:     kvm@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] KVM: Annotate struct kvm_irq_routing_table with __counted_by
Date:   Fri,  6 Oct 2023 13:41:11 -0700
Message-Id: <169662486908.2156024.3248243280882819249.b4-ty@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230922175121.work.660-kees@kernel.org>
References: <20230922175121.work.660-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 22 Sep 2023 10:51:21 -0700, Kees Cook wrote:
> Prepare for the coming implementation by GCC and Clang of the __counted_by
> attribute. Flexible array members annotated with __counted_by can have
> their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
> (for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
> functions).
> 
> As found with Coccinelle[1], add __counted_by for struct kvm_irq_routing_table.
> 
> [...]

Applied to for-next/hardening, thanks!

[1/1] KVM: Annotate struct kvm_irq_routing_table with __counted_by
      https://git.kernel.org/kees/c/bbf75528039a

Take care,

-- 
Kees Cook

