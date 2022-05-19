Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD8252CACD
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 06:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbiESERM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 00:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbiESERL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 00:17:11 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F343B8BEB
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 21:17:09 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id o16so2887349ilq.8
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 21:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wBpJN+B+mpCMjOyZZ37J/WxRsnBKWwY1W4P9ThvtpoI=;
        b=JGQleZJIQQ604gbY4RMXs6h6h1Tqp2YqmlqQqyuFwLEcPzlP+Ur3g4bL7mZJ+8yEBL
         kZtI4hOR95oDYmzJ9vLR5oEFT7/Xgm37DNafbIAgLlpPEySpjRfWScQqEVEK6dIwzyQ0
         ZQxnrmght+XEP8UgR9lT6NLnXPkfoWpYnysH581FOiOaevYcnTZ1lRLHgCHoe4ml+EsN
         E3Q6S26a37/3V63mTmuD/feVvqKQ3PJTP3QCQLnEkRgDDiNcPjaGBdvUBoqAauyoFz3I
         B79YeCLu7jqemdx6+sv5tlnTBZbZyQtY6s1yixQtYykgpMQOoL/Dkk50d4Z8nZFAPbeB
         rW/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wBpJN+B+mpCMjOyZZ37J/WxRsnBKWwY1W4P9ThvtpoI=;
        b=F0/tqZrcpn6oTd0ZHcnXGo3KyR8uDec3MVRTfxznSBnALF5euKgSdKhiBJtZxWNhZz
         VytamHxJIrkISZZ98cYT4ZU2HpfBUyEq7Zh5h4n3nHe62pTQUcXpWJDYeIwvajEW8uDk
         41t6ysgrwQb4oirYnx3kwREqBl1j9+GcHYOwqROe5Nqq9LpWGgpwXiiUvaD6JEgXM14P
         cl9TyzfFuGTHkZ5K6FxzboCaIRjHD40S2+S8ZAVsOEYTbuk96h8ya7wCLdjXk0WKdP3F
         ei1T0KI2NScw9DammXI0dImNBAjPRWIjSzypRwbUWtZXxqVYCoccYBXrDdPromDRgfjN
         kcsg==
X-Gm-Message-State: AOAM532tEABIj6Yee8e+Q3BbFGVzfPrSgVgggb3ewJ8ZEYy4okFOt77J
        6PgOyKeGgEpE7AqXEjVU1jByYQ==
X-Google-Smtp-Source: ABdhPJwVTPKAjZ6b9y2ovYPQL5OOgnFicWexrxmFnJiV64RB2zPOUbGZ/KIcwBuVx+Z5hyHliZ6g/g==
X-Received: by 2002:a92:d805:0:b0:2d0:ea4f:5dcb with SMTP id y5-20020a92d805000000b002d0ea4f5dcbmr1648257ilm.78.1652933828733;
        Wed, 18 May 2022 21:17:08 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id f23-20020a02b797000000b0032b3a7817afsm372599jam.115.2022.05.18.21.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 21:17:07 -0700 (PDT)
Date:   Thu, 19 May 2022 04:17:04 +0000
From:   Oliver Upton <oupton@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v3 07/13] KVM: selftests: aarch64: Construct
 DEFAULT_MAIR_EL1 using sysreg.h macros
Message-ID: <YoXEwEaxVat7XTl1@google.com>
References: <20220408004120.1969099-1-ricarkol@google.com>
 <20220408004120.1969099-8-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408004120.1969099-8-ricarkol@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 07, 2022 at 05:41:14PM -0700, Ricardo Koller wrote:
> Define macros for memory type indexes and construct DEFAULT_MAIR_EL1
> with macros from asm/sysreg.h.  The index macros can then be used when
> constructing PTEs (instead of using raw numbers).
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/include/aarch64/processor.h | 24 ++++++++++++++-----
>  .../selftests/kvm/lib/aarch64/processor.c     |  2 +-
>  2 files changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 3965a5ac778e..16753a1f28e3 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -38,12 +38,24 @@
>   * NORMAL             4     1111:1111
>   * NORMAL_WT          5     1011:1011
>   */
> -#define DEFAULT_MAIR_EL1 ((0x00ul << (0 * 8)) | \
> -			  (0x04ul << (1 * 8)) | \
> -			  (0x0cul << (2 * 8)) | \
> -			  (0x44ul << (3 * 8)) | \
> -			  (0xfful << (4 * 8)) | \
> -			  (0xbbul << (5 * 8)))
> +
> +/* Linux doesn't use these memory types, so let's define them. */
> +#define MAIR_ATTR_DEVICE_GRE	UL(0x0c)
> +#define MAIR_NORMAL_WT		UL(0xbb)

nit: MAIR_ATTR_NORMAL_WT

Might be annoying if these are actually defined at a later date and
someone tries to refresh the tools/ header copy. A bit more work, but
how about adding these to the real asm/sysreg.h then catching tools/ up
in a subsequent commit?

Modulo the nit, fine with this as is:

Reviewed-by: Oliver Upton <oupton@google.com>
