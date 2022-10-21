Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAB526081BD
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 00:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiJUWer (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 18:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiJUWen (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 18:34:43 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C188740BD6
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 15:34:40 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id l32so3174638wms.2
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 15:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=u8ZUYzkw582B8ag/E5+DphAy2SP/fG5AqdZthlsgOkg=;
        b=jL2Gd5xVvSPH4itprSkcbvjwhI91WFR+GbCQACpb470ber3HglJQozB5ag4RcVToGu
         wPnTIpEFEe2M7RFLs6dcNmbQQpyF9XykxWtxGmWevrX1p774CgpJDApx0b2s1BUGzcwT
         FMGFFa+SIoDoDQIyEUYncH8OuHcHF1tyXss1rA7xTP5u4c+1vM0j4i6plBx6wA49/6bQ
         5dg5J8y+B9E5MptlY39cKV/O1f6F0pubQws+MZi5qsgx8d92A3pWZvWoWOUJtMrxRswL
         5j01nhNqCCtSARU2m8zude96vB3ZXXwUoAnBE21Lie8GWe5tvKc5Ruw9nyQFzCMxjVVP
         R6CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u8ZUYzkw582B8ag/E5+DphAy2SP/fG5AqdZthlsgOkg=;
        b=WRKFBEv6ehGiZKgsVZ8DYUS4dsvJ9g/Sh0FZnBvG4gtOLB3L4gWNjmCzH0v9CwWF6k
         1PN5C1Hohd3sZe4ULaKzOOlEZUwLOgx/a1+piOaemxMFnDfRfL+AKNkSnK2WnslIz/80
         ip0XQHVRoSxHaItQa/8hvLPU7E5M4eNauPM1uxQluEcyrf349EPoYsoMgN4cOOVXPr6N
         tqFiwj+1gNrv5cuZvQEzn7bjddb25omOIWwvDOjvwiIlDFi3k0u7XmJ6B6W9FhSOU93F
         gR8rpM/RosMgwStkLQYGB7qf03QQdkYyEmuprOyNzktSuUSY33OD77iA1wFINDLUAzRo
         C7gA==
X-Gm-Message-State: ACrzQf0mDZJYHTFBbLIonOiBmp5zDeyZtv9twbihekQUPRItmT/Sz05a
        557zicGTga343TvPofIy+JGq9N/rsGbfbReITwyCzw==
X-Google-Smtp-Source: AMsMyM5aywUekN6Y8xJpyTwBo0Fi998NdSgln/qRnagoV2Uw0QOqYGKf3bo2WxCdC0TacuRFb/YyoJJLunXXYIoxI1Q=
X-Received: by 2002:a7b:c4cb:0:b0:3c6:f83e:cf79 with SMTP id
 g11-20020a7bc4cb000000b003c6f83ecf79mr14767201wmk.112.1666391678766; Fri, 21
 Oct 2022 15:34:38 -0700 (PDT)
MIME-Version: 1.0
References: <20221017162448.257173-1-wei.w.wang@intel.com>
In-Reply-To: <20221017162448.257173-1-wei.w.wang@intel.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Fri, 21 Oct 2022 15:34:02 -0700
Message-ID: <CAHVum0fEVEtC-pLrKO3VJkPy0uqPa5WfeYQrTB=9Hk2Z8jV3fw@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: selftests: name the threads
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Mon, Oct 17, 2022 at 9:25 AM Wei Wang <wei.w.wang@intel.com> wrote:
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index f1cb1627161f..c252c912f1ba 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2021,3 +2021,50 @@ void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
>                 break;
>         }
>  }
> +
> +/*
> + * Create a named thread
> + *
> + * Input Args:
> + *   attr - the attributes for the new thread
> + *   start_routine - the routine to run in the thread context
> + *   arg - the argument passed to start_routine
> + *   name - the name of the thread
> + *
> + * Output Args:
> + *   thread - the thread to be created
> + *
> + * Create a thread with user specified name.
> + */
> +void pthread_create_with_name(pthread_t *thread, const pthread_attr_t *attr,
> +                       void *(*start_routine)(void *), void *arg, char *name)
> +{
> +       int r;
> +
> +       r = pthread_create(thread, attr, start_routine, arg);
> +       TEST_ASSERT(!r, "thread(%s) creation failed, r = %d", name, r);
> +       pthread_setname_np(*thread, name);

Since pthread_setname_np() expects "name" to be 16 chars including \0,
maybe a strnlen(name, 16) check before it will be useful.
