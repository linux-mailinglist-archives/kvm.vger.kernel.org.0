Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21079691FD3
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 14:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbjBJNg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 08:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbjBJNg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 08:36:57 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7F62B635
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 05:36:56 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id x10so3724087pgx.3
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 05:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=y1hvwz+Dd7g4NTUiEn0Fi9gkNfu1niBnmphBxaTmbeE=;
        b=wbzvFKDJ063GVWDXHGuvjTPH08+tUKtV1IYKid8qgQj5B8h8rLHAKunSCSd4i5UDY8
         d3MNQna9S2K8A6v8ihzLuYz03ABNA6IUo9moq50Actb81PtNW5K5/4dGqmJeiqku5k5R
         XbMT/poux916s6Meu73bQYgvQzCgxiW9QzMi5DAjEmXNH+cAUlG+QEBDNyULZ3Z+8LYa
         MZcuuZ4r1oTiXNqe7DfBJ2d3+uf/LtPUj4lcFzABtChoJAPdq8oAEfkF+0opytbgJPk0
         9RCeDOoQNNcUW5PKYoM/h8t1vHksk9XX3miuV+W06OLsUB2PPboO+dryAUgTmvAJVqF9
         eckQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y1hvwz+Dd7g4NTUiEn0Fi9gkNfu1niBnmphBxaTmbeE=;
        b=AxfnuDCk16uob0krLfNdS5xisg+7V4qcd7bpDWhTIR3xSUm/KnXNBrp2Trzt6btzeP
         O2Idueg9H5GhpA/wiKpXHZqJf5kIht6WCsdz+43uaAR9QenGVnFEMpuCtankIap+wCBL
         xmDAauXmZYYkGNv9jLI7PFOR1PhHA9ts0OwsoHgCuDaXbFQXGL/fzx5BWmv7fVPM9hFc
         sZefGwvWP4TCQtjass76tQ2YEZ9VIFV3MhtP6G9esxl2PquTwuidN8tD38cLBuhHxBuH
         oSjI5P6DhKYQHskJaBodqT0K8lBooM74gAiDsVbwiNblV246Dsv+RGlmPb/gY41tGLCJ
         Dt1w==
X-Gm-Message-State: AO0yUKXSC1BTeNCUxusrHAtL/xITg2OW/CjJYubpxPpr0UYq+COpWIUF
        KFuY+QJGutuhieKX61mkbSAvl5p/jz2m0SWYjesQ5A==
X-Google-Smtp-Source: AK7set91fxjLP0Z6IdnoqL6bdxVfHUXDwSG+BpftJFg+3ONvnQi2pDNnqQ7w7zYDKuWrH0qoX1HJ2RmknADhNEZ/n5g=
X-Received: by 2002:a62:53c6:0:b0:58d:a84a:190b with SMTP id
 h189-20020a6253c6000000b0058da84a190bmr3326129pfb.48.1676036215644; Fri, 10
 Feb 2023 05:36:55 -0800 (PST)
MIME-Version: 1.0
References: <20230209233426.37811-1-quintela@redhat.com>
In-Reply-To: <20230209233426.37811-1-quintela@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 10 Feb 2023 13:36:44 +0000
Message-ID: <CAFEAcA-qSWck=ga4XBGvGXJohtGrSPO6t6+U4KqRvJdN8hrAug@mail.gmail.com>
Subject: Re: [PULL 00/17] Migration 20230209 patches
To:     Juan Quintela <quintela@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Feb 2023 at 23:35, Juan Quintela <quintela@redhat.com> wrote:
>
> The following changes since commit 417296c8d8588f782018d01a317f88957e9786d6:
>
>   tests/qtest/netdev-socket: Raise connection timeout to 60 seconds (2023-02-09 11:23:53 +0000)
>
> are available in the Git repository at:
>
>   https://gitlab.com/juan.quintela/qemu.git tags/migration-20230209-pull-request
>
> for you to fetch changes up to 858191aebda251a4d1e3bc77b238096673241cdd:
>
>   migration: Postpone postcopy preempt channel to be after main (2023-02-09 21:26:02 +0100)
>
> ----------------------------------------------------------------
> Migration Pull request
>
> Hi
>
> This are all the reviewed patches for migration:
> - AVX512 support for xbzrle (Ling Xu)
> - /dev/userfaultd support (Peter Xu)
> - Improve ordering of channels (Peter Xu)
> - multifd cleanups (Li Zhang)
> - Remove spurious files from last merge (me)
>   Rebase makes that to you
> - Fix mixup between state_pending_{exact,estimate} (me)
> - Cache RAM size during migration (me)
> - cleanup several functions (me)
>
> Please apply.
>
> ----------------------------------------------------------------

Fails to build the user-mode emulators:
https://gitlab.com/qemu-project/qemu/-/jobs/3749435025

In file included from ../authz/base.c:24:
../authz/trace.h:1:10: fatal error: trace/trace-authz.h: No such file
or directory
1 | #include "trace/trace-authz.h"

https://gitlab.com/qemu-project/qemu/-/jobs/3749435094
In file included from ../authz/simple.c:23:
../authz/trace.h:1:10: fatal error: trace/trace-authz.h: No such file
or directory
1 | #include "trace/trace-authz.h"


https://gitlab.com/qemu-project/qemu/-/jobs/3749434963
In file included from ../authz/listfile.c:23:
../authz/trace.h:1:10: fatal error: trace/trace-authz.h: No such file
or directory
1 | #include "trace/trace-authz.h"

etc

thanks
-- PMM
