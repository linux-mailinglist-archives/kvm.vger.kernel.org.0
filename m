Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8247F686D41
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 18:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbjBARnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 12:43:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbjBARnA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 12:43:00 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3901C7EF4
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 09:42:58 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id m199so23305033ybm.4
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 09:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rJYcYZZzY+M9ZxHHejg1E8aKJPzOl0euqJrFocbUFH8=;
        b=iIf80nLU8eJ3TTcqZRbCLEoUWBCkv34wRmjU+y3ZuetcRNX82nc/RHWUyYfRwrK0iC
         Tm7y1M0H3avUtezwDYJHw00ncCGU/+yzS5GLazNozpF1L0L9xV/Fehr1ooTXz2/uXw4O
         xLuCAceRjd6g4+J1C7vpFly+Bu6q+yMahP7CSoGuwvo8p51Ji3H7KPu2gBjO4WZruzoJ
         gLZM7LJMfleKIU0cLxiRElhF3vpPQOTkk0naUn5AmqzYx4OBtWUmx4rLTGmzncKdCOv7
         PIu55CUtFxzZ8qlHp1C3Ysoye/fODeMRu9xvSSpquVQ8JftdiyvVj+gOCA4sUAzNeXIw
         lvAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rJYcYZZzY+M9ZxHHejg1E8aKJPzOl0euqJrFocbUFH8=;
        b=7N/1iXzOeoLIoEzLJpSYohLlq9yLREyBNBnHp5n3amRL1JpUP6kV6Q598GYG8k7DkE
         JTmzJicHa7oFpmuH7hO1o7dUUm2LqT3H2qhNHp5+qUjXPYFl116Rd42qdLQ4wmgdGWIW
         y55mNTZdFl7GH9ECTL7TGUcKsix7tN6udKTE3MvfvPxvTjGqvGbw3TE3fdbdyEnpW3E0
         Kb8VphISjWPPKZ+AZ1p85KZPhPPyX7iuAyCVPlSZAuktBnwXRJKWZJu3S86H1uXcCnH3
         S1hEask3oCxg/emtQtNG6xNBajtq/6vd1RDK8V236V2Gy61s+i60x5Wd0yaUhP3guHnu
         yEyw==
X-Gm-Message-State: AO0yUKX4pfXD5Tpz4upV575au47Wa0gptcZSpUNY2SRqUEWJ9lkmNSZq
        Kxxmybj2/v5kVSzcgwh3mF73EkbObDat/f0ZCbP3Lw==
X-Google-Smtp-Source: AK7set82FOp9DtIGRw89gONLvOwWzIz4Gt+lBD+BlbVec4y4ugm+6VEAO+bzHVj1GHH0KhNl0ZZtfsGm7jrLMLejvj0=
X-Received: by 2002:a25:dad6:0:b0:80b:ee61:e2d4 with SMTP id
 n205-20020a25dad6000000b0080bee61e2d4mr458698ybf.401.1675273377184; Wed, 01
 Feb 2023 09:42:57 -0800 (PST)
MIME-Version: 1.0
References: <20230201172110.1970980-1-coltonlewis@google.com>
In-Reply-To: <20230201172110.1970980-1-coltonlewis@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Wed, 1 Feb 2023 09:42:21 -0800
Message-ID: <CAHVum0f91JSkYexUMpNfk4STGAVL87y_xEin84K6LON8bieZVg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v4 0/1] arm: Replace MAX_SMP probe loop
To:     Colton Lewis <coltonlewis@google.com>
Cc:     thuth@redhat.com, pbonzini@redhat.com, nrb@linux.ibm.com,
        andrew.jones@linux.dev, imbrenda@linux.ibm.com, marcorr@google.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 1, 2023 at 9:21 AM Colton Lewis <coltonlewis@google.com> wrote:
>
> v4:
>
> Remove last mention of awk and fix spelling mistakes in commit
> message.
>

Please provide each version's change summary with their links from
latest to oldest.

> Colton Lewis (1):
>   arm: Replace MAX_SMP probe loop in favor of reading directly
>
>  scripts/runtime.bash | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
>
> --
> 2.39.1.456.gfc5497dd1b-goog

For single patches you can omit the cover letter (unless there is a
lot of information you want to provide and discuss) and just provide
any non-commit information after the first three dashes '---' line in
the patch.
