Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7BAF68BEF6
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 14:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbjBFNzc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 08:55:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjBFNzQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 08:55:16 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467112A175
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 05:53:28 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id j29-20020a05600c1c1d00b003dc52fed235so8862504wms.1
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 05:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RsdX47KrLu9aZuhQEk9NdfiFSEoiJFsCrkPUJVtEShI=;
        b=bFI3c4yrDS57BGk9G6WzkrPYg64U3fwYXmyhfGFP3DEMsYm7qsBvy1WCBaJ9LMqzFE
         hNoirnCOam1hHtJk+fobmCrskmBJx0RempO2C0QSc1+yvJ/wly4V6Ee1wXIt7u+49iZr
         l9qzDapxjUDRUcdYTzeP3PDKILGsO/RhHbXBiFmFR4GoHwPlpIqHPHTl7tpO1D55KZ2r
         pdxobBfbiSfeJBnLVy7MSJFMNyv0z6p4OBGgeadKtg4nqWLfMQk+Z1Ti/stmBD1BUhKM
         PdSaaJoU08n4lRz4Y1X6F/hTCqBnsquVkz0Gs5kYHtfVktmxiveP5Uk28NLChYcWMSXj
         0szw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RsdX47KrLu9aZuhQEk9NdfiFSEoiJFsCrkPUJVtEShI=;
        b=QcdShX9pl0eLp9WgYOyzOCsE0aOLInsIARpRIheSP4ooqwnAJpXgLyy2tywfNOLpiV
         cn9sbh0gb+RlmlSheAtdH6q2jG7gIz0LxVbez1gzhO3qWympMJV/RRE52NMFuyMbxZiL
         HSj7EYs+5XhCMlp6L3M/um0pMVw/nxkiRhREyWmnOFF31yNORX9Ze5DY8bobA1bQo8VO
         KEokTC2dQ0GPolGL9u82RrfhOSjxTa9cL7e0MKUZ5uI/biO411nemvfEy6+Cm2bmPu3s
         xmY9tsA46rvuAshiLmHiPLbNY2WignSuRq2/kpU0xNfew0jzyLJi42WE/PwNt2Q2Y10b
         23lQ==
X-Gm-Message-State: AO0yUKVmkHob7kalw/oGMBL+MknRY/zeO8HUf3/vPGk5gQ8frSTdzz/H
        A9arn7goYw/Lg1P3OVc9R4O2gQ==
X-Google-Smtp-Source: AK7set+GW6CPHMtbg5T7jnEo+q3qaHqZpOQtjGmlqO7qVUpjjWodto9wcUKJUtxXdXpRXQg2izTY2Q==
X-Received: by 2002:a05:600c:54c5:b0:3dc:9ecc:22a with SMTP id iw5-20020a05600c54c500b003dc9ecc022amr19173436wmb.8.1675691578333;
        Mon, 06 Feb 2023 05:52:58 -0800 (PST)
Received: from zen.linaroharston ([185.81.254.11])
        by smtp.gmail.com with ESMTPSA id y6-20020a7bcd86000000b003dc4480df80sm16262136wmj.34.2023.02.06.05.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 05:52:57 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 6C16B1FFB7;
        Mon,  6 Feb 2023 13:52:57 +0000 (GMT)
References: <20221123121712.72817-1-mads@ynddal.dk>
 <af92080f-e708-f593-7ff5-81b7b264d587@linaro.org>
 <C8BC6E24-F98D-428D-80F8-98BDA40C7B15@ynddal.dk>
 <87h6xyjcdh.fsf@linaro.org>
 <4B19094C-63DC-4A81-A008-886504256D5D@ynddal.dk>
User-agent: mu4e 1.9.19; emacs 29.0.60
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Mads Ynddal <mads@ynddal.dk>
Cc:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH] gdbstub: move update guest debug to accel ops
Date:   Mon, 06 Feb 2023 13:52:26 +0000
In-reply-to: <4B19094C-63DC-4A81-A008-886504256D5D@ynddal.dk>
Message-ID: <871qn2rjd2.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Mads Ynddal <mads@ynddal.dk> writes:

>> It will do. You could just call it update_guest_debug as it is an
>> internal static function although I guess that makes grepping a bit of a
>> pain.
>
> I agree. It should preferably be something unique, to ease grep'ing.
>
>> Is something being accidentally linked with linux-user and softmmu?
>
> Good question. I'm not familiar enough with the code base to know.
>
> I experimented with enabling/disabling linux-user when configuring, and i=
t does
> affect whether it compiles or not.
>
> The following seems to fix it, and I can see the same approach is taken o=
ther
> places in cpu.c. Would this be an acceptable solution?
>
> diff --git a/cpu.c b/cpu.c
> index 6effa5acc9..c9e8700691 100644
> --- a/cpu.c
> +++ b/cpu.c
> @@ -386,6 +386,7 @@ void cpu_breakpoint_remove_all(CPUState *cpu, int mas=
k)
>  void cpu_single_step(CPUState *cpu, int enabled)
>  {
>      if (cpu->singlestep_enabled !=3D enabled) {
> +#if !defined(CONFIG_USER_ONLY)
>          const AccelOpsClass *ops =3D cpus_get_accel();
>
>          cpu->singlestep_enabled =3D enabled;
> @@ -393,6 +394,7 @@ void cpu_single_step(CPUState *cpu, int enabled)
>          if (ops->update_guest_debug) {
>              ops->update_guest_debug(cpu, 0);
>          }
> +#endif
>
>          trace_breakpoint_singlestep(cpu->cpu_index, enabled);
>      }

Sorry this dropped of my radar. Yes I think the ifdef will do. Are you
going to post a v2 with all the various updates?

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
