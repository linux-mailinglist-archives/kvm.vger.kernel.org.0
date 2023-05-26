Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A50AB712B4F
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 19:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236835AbjEZRBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 13:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbjEZRBe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 13:01:34 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF893D9
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 10:01:32 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-530a1b22514so635600a12.1
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 10:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685120492; x=1687712492;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BGSsRadg8/k5YCYiOUDx3xTCmP75V2hSKqivxNmuHB4=;
        b=aZqsNgc7a1OmO2JI7G8jku+ietUnfouKuJEoAN0tBmNqsAin9JBkSMFYL8S8gDKKHR
         aNwJp8m7f6BCK7xhN7d5Rg56l3clIm8a4vAXJ21vFWq6ntVMWn4JuMkj+seOzlT3z0re
         7TLJud0hRERbNC/6lX1JO+EPpwOIj22VokKAcYMFiNdb2rU1GlRTeeI9637dwFH9A2Hg
         9IPit8NpcZ+qUDmhb3agCo4Ubf9hB8JwiJnK1HorAFoH6JUgTD/M2hGVsJCYo13LCRXV
         xqq3/V0Cy5kQgGl23hEJ87cOuXXvbN7TdvWSEP62qm2L+f1N00ljfH6b5LZh9UeVraRh
         Asww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685120492; x=1687712492;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BGSsRadg8/k5YCYiOUDx3xTCmP75V2hSKqivxNmuHB4=;
        b=JVtLKRNsBTzjWupVC9FxN0i6lL9Kg/iJkOv2wWq6cCo9lHK+wi1Cdb1WSM3DffhLsO
         c7mx1Z+HYo0S9FmTyzPVMStBViL+EeYMRQoW/SPZz1PhAiiI09ytqaraW2dMQvLMOJ/s
         yhM0r+oxReVlmGSiQ7wIQ/CJwtb5kEFKdCDAXNhtwGdtHHASu6RciR2wK3b6psLoPe4C
         KVfFO4lAqjXOeKwaBIiB9YOko0+mXERPGN225Ogd2GhuFoZ1kGhe6nPDrmTWNvzmPT8b
         dvi2RuDmRtccIH9KN8h8WDyJrM9dkbbmb0WogbVPbrduo8c2o9+DAvnbkduQ5Y+iqhOf
         1CHw==
X-Gm-Message-State: AC+VfDyZWlj9SRJO2B4o+8Rky0FujmBmjlnYFfPDdbylwScSKJQVGoS/
        IlOf7qafFEubQFiq2mtF0TZWnDVpbK8=
X-Google-Smtp-Source: ACHHUZ6OQjvHvHGEb6V1v/dWoqRH+hN+hXO0RBWjxtohTutQ74AAidsJ/QXWTOFyJ1SL6/Pncd+hcSIVLGk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:4b48:0:b0:530:638d:cf91 with SMTP id
 k8-20020a634b48000000b00530638dcf91mr25458pgl.4.1685120492215; Fri, 26 May
 2023 10:01:32 -0700 (PDT)
Date:   Fri, 26 May 2023 10:01:30 -0700
In-Reply-To: <CADpTngX9LESCdHVu_2mQkNGena_Ng2CphWNwsRGSMxzDsTjU2A@mail.gmail.com>
Mime-Version: 1.0
References: <CADpTngX9LESCdHVu_2mQkNGena_Ng2CphWNwsRGSMxzDsTjU2A@mail.gmail.com>
Message-ID: <ZHDl6rXQ0UTWdk2O@google.com>
Subject: Re: WARNING trace at kvm_nx_huge_page_recovery_worker on 6.3.4
From:   Sean Christopherson <seanjc@google.com>
To:     Fabio Coatti <fabio.coatti@gmail.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 26, 2023, Fabio Coatti wrote:
> Hi all,
> I'm using vanilla kernels on a gentoo-based laptop and since 6.3.2

What was the last kernel you used that didn't trigger this WARN?

> I'm getting the kernel log  below when using kvm VM on my box.

Are you doing anything "interesting" when the WARN fires, or are you just running
the VM and it random fires?  Either way, can you provide your QEMU command line?

> I know, kernel is tainted but avoiding to load nvidia driver could make
> things complicated on my side; if needed for debug I can try to avoid it.

Nah, don't worry about that at this point.

> Not sure which other infos can be relevant in this context; if you
> need more details just let me know, happy to provide them.
> 
> [Fri May 26 09:16:35 2023] ------------[ cut here ]------------
> [Fri May 26 09:16:35 2023] WARNING: CPU: 5 PID: 4684 at
> kvm_nx_huge_page_recovery_worker+0x38c/0x3d0 [kvm]

Do you have the actual line number for the WARN?  There are a handful of sanity
checks in kvm_recover_nx_huge_pages(), it would be helpful to pinpoint which one
is firing.  My builds generate quite different code, and the code stream doesn't
appear to be useful for reverse engineering the location.
