Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1D25AF9A1
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 04:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiIGCAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 22:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiIGCAa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 22:00:30 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A7E83063
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 19:00:27 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id a129so3355982vsc.0
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 19:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=wsARz19b+rqPn9IK6GAlYftVxiNnl8OSsSaYZNoi6rM=;
        b=Fjf1quEBH87cQ2lo1jAZw8/pXBsxTTFmjB4Du1roRZT2tFwQC1LGAhv7wb9ecLlDbZ
         4WLHqzeKZ39AwmJOoYrHzI3/hI+v1SXBe7g8UEm2x3mQllXU2MH80Ux/HuU927Sitouy
         Z2nhmfmrdHiLM8g0yiZrt9SnygUkclEnJfBSZ0aqRfxF3tkSOyfFd4jAkiINg7vQ4wbr
         qeQz6r2AmY+GGLoam41+4s4qc5hrcE+t5o2rLIo/JO3tEXwslAGOxdW9smgZ2JWx9JMN
         QwMtsW9LKWiHLrEvQaJd02SrlgpqZblqxlErh8Ty1Q7B7G2/200GHLi/c/1oxK/1nGSy
         97XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=wsARz19b+rqPn9IK6GAlYftVxiNnl8OSsSaYZNoi6rM=;
        b=uNxWPZXwell1Q8GWX/IdzY4mg+QsfZPzgmMZxx65sqFgmkl9eLALGgWqZlPUDhicFd
         MYoLoBjy/tVQhcizQdcKCtOlIu4Ai7EQkDBs84WyDl5hqjOfeFQ6u9mAMrsX16tMdU/a
         x1e03RHaEybgnCWHvUTWEZHKL5nB0Ma9UITuCgWyTAWu7MnIcGUHP9qxIftJmA9sYRD+
         /Hf0mHdUohElI1zm1zsbM1jKtdqR+06LRrp0EclUrtXvbfgi5fm2waHX0+nx7OfDoCXt
         3vHjygKrGeatNUmOtkHLUQx0Mk3ec8XRMtM76CWTE/7QFwLDAdtqVwNOWfb5lN+cI9AM
         vtZg==
X-Gm-Message-State: ACgBeo3pGUGQ6JkqPtp7LgB/BtxHGEqOynUKwfLR/5mlzhYxNl8RZVKS
        edsZ6Db5Lzo/eCXi6Z/B0jMXh03JFn+OZoUoblN1eA==
X-Google-Smtp-Source: AA6agR72eSD2FyY1WmLUjqFEq/K1rYb4p3qgCXjKN6DF4JjBjQeIvq0s2+BMqLmG4qdAmVkQp095RHnNT+lmfmMtrks=
X-Received: by 2002:a67:fdd0:0:b0:397:c028:db6a with SMTP id
 l16-20020a67fdd0000000b00397c028db6amr450011vsq.58.1662516026551; Tue, 06 Sep
 2022 19:00:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220902154804.1939819-1-oliver.upton@linux.dev> <20220902154804.1939819-3-oliver.upton@linux.dev>
In-Reply-To: <20220902154804.1939819-3-oliver.upton@linux.dev>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 6 Sep 2022 19:00:10 -0700
Message-ID: <CAAeT=FzjL=iPEO6FeHLTzHX5V4snoVOWVx27oeShHQYRi6HeAQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] KVM: arm64: Remove internal accessor helpers for
 id regs
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 2, 2022 at 8:48 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> The internal accessors are only ever called once. Dump out their
> contents in the caller.
>
> No functional change intended.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
