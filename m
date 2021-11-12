Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4EB44EA85
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 16:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235459AbhKLPlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 10:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235493AbhKLPkz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 10:40:55 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68625C06122B
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 07:37:25 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id x19-20020a9d7053000000b0055c8b39420bso14398256otj.1
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 07:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wPHRMT5htMtEJACl+XaTOMMpK0AkaaC+0nFQE2XRWLI=;
        b=GQIYUnG5rIPw8H3X/y+U6+e/IaYBT+/T9AJObLMj/8B0v/AOx9S6koA9bZCnsXECDq
         CvHQQTB1ks5yRJCNY+zifPRz35gMWGfohRsxMOTEIyiEgBWhNtPhR/Mg/yh8shM+Tcjr
         OcVQirkoXLalUyCNOtHQDWcYnn1AqqU3f32eT5hVWYrdPiEcwcXq36PLxLcOEnuIgmey
         EdLSH8vKLnuF+4yQf5Wosvzg3bE3QG9EvfSZ94ixxtaZSi/tAayiFt5LTRxdktG0p8DJ
         wdG91zSBTwOhKWrvEC2Pmn6rn0HcKxXbEl9d89T/T+Xl92Gfpj6H6jyfdVgnDFzdZlSp
         vbnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wPHRMT5htMtEJACl+XaTOMMpK0AkaaC+0nFQE2XRWLI=;
        b=le2IC5rDoW9E2uFbcVPUqtdlRbK5HxaBb8Yt/M+OBUbSS1dOxxlbDKgzFgBnmzbLv2
         ZDvPQkBPio1fdOq3m0V6yMLwnayONCX5JdmN1S6E4JFRYlv50AjS7QPGx0xcIxEdmdyv
         +jHb2ekC1zY9E0uwe9NgL/TI74ojUcU6VICNbKIK9OXrM69L4xGyp0xhLbxFLqzF0rB5
         QGpGmWWcw2GWz6n/DSMIObbl2kORo/mLCGpC+YHSrv6ZL6T+OU3LESNTu7/1ehYrCMQi
         T1KSDldRKLYFmaFrB4WCFxmsBjjXEDslInIZYJx4d2E4Y0//T6+M1G1xEnXkyaVOXQoV
         0r0g==
X-Gm-Message-State: AOAM533gm8rBbMqJqPRWIMCF42OIgFc618N9NZHpSATTM/aSa+ZTF85A
        5q4oOUqddPg+3467+TllrMO0r7qoBZFld9LHmA615oDSKKI=
X-Google-Smtp-Source: ABdhPJwZTw6vFplJ+7otvPYBLaYEktVJXcKulPypk8ZO58xXdVDIDq1vafBT3ygi1frplWjxNsBagZITNYu34YtXzpw=
X-Received: by 2002:a9d:644e:: with SMTP id m14mr13012872otl.29.1636731444552;
 Fri, 12 Nov 2021 07:37:24 -0800 (PST)
MIME-Version: 1.0
References: <20211112133739.103327-1-drjones@redhat.com> <20211112133739.103327-2-drjones@redhat.com>
In-Reply-To: <20211112133739.103327-2-drjones@redhat.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 12 Nov 2021 07:37:13 -0800
Message-ID: <CAA03e5G0C0P13Z_302Wf_q=wJJuQw2Xk5gFyOirUEyNbEh-cuQ@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests 1/2] unittests.cfg: groups should be space separated
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, thuth@redhat.com,
        zxwang42@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 12, 2021 at 5:37 AM Andrew Jones <drjones@redhat.com> wrote:
>
> As specified in the comment blocks at the tops of the unittests.cfg
> files, multiple groups assigned to 'groups' should be space separated.
> Currently any nonword character works for the deliminator, but the
> implementation may change. Stick to the specs.
>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  README.md         | 2 +-
>  arm/unittests.cfg | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/README.md b/README.md
> index b498aafd1a77..6e6a9d0429bc 100644
> --- a/README.md
> +++ b/README.md
> @@ -101,7 +101,7 @@ host. kvm-unit-tests provides two ways to handle tests like those.
>       a) independently, `ARCH-run ARCH/test`
>
>       b) by specifying any other non-nodefault group it is in,
> -        groups = nodefault,mygroup : `./run_tests.sh -g mygroup`
> +        groups = nodefault mygroup : `./run_tests.sh -g mygroup`
>
>       c) by specifying all tests should be run, `./run_tests.sh -a`
>
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index f776b66ef96d..945c2d074719 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -232,7 +232,7 @@ arch = arm64
>  [micro-bench]
>  file = micro-bench.flat
>  smp = 2
> -groups = nodefault,micro-bench
> +groups = nodefault micro-bench
>  accel = kvm
>  arch = arm64
>
> --
> 2.31.1
>

Reviewed-by: Marc Orr <marcorr@google.com>
