Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388446ACCD7
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 19:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjCFSma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 13:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjCFSm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 13:42:29 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAD365075
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 10:42:27 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-536bbe5f888so200810957b3.8
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 10:42:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678128146;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ngEGOQ5LH5Ca87/RzyGzlZeBinyJ/MngnZ8MYK7ebfA=;
        b=OkT4Bj9Z0TehomdKv19DYXF35jcxaz6UKe9zC/6aAKXVfCe/IsKqN7paabT+Ug9qKg
         zxtbbvQ18j1OIA/hGzpOboQ8nrgaWyMHudXYhyFGFky0Kk+3B1T/Z32HHqnVWmCpPou/
         YiiGegPoI65A293D9hI70EDBfbLxv8J6IZADCiEyrNCC2E/PTWpUmQuCCWetGNOyQt5Z
         xpGxeNWEe0iLSwy2+xaiO5qi/R+JJZg1WIYWlTWnCSBHTQdi73hk+tIfLDsKYvvc+GYh
         yWs1ok3/XLu/v3bvdjodgikz/Wdzh0Rc6fAhLaPiuBrBEvvHys94++syqIdBfK976igf
         Wc4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678128146;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ngEGOQ5LH5Ca87/RzyGzlZeBinyJ/MngnZ8MYK7ebfA=;
        b=4S8+Q9BVVPq1Yw36Jjt4BLqhFq7S8qujaIisrY0d/OyTDaIl+UV2nlChQlNkHUk8qG
         qEhFc9BBs4bPk5dQK7pOq/KfBaDRg7+Ei2nlit70Z+gY2ErGyQxFVsxZTiREK8vz3i6D
         AwFWguhChJKSQGArg7G3WiEKGXOR2YJL1CJVl1GE4F1RCl98OeKTAY1/JFXaNHy0NdaI
         x/S1AnIE8AidPhbLibJBxhYnSdtgck2feowq6KkdBvYsmjHudp4ZnNQgvHO85RyCmOzs
         ZJlSwaiu6wChSn1nEp+NnwrWPEBxMdOVnX0zrvpyOR80i1wutn3iq7nd4pNXgcyqEJPN
         r/Mw==
X-Gm-Message-State: AO0yUKWrCYuO97Z4j380Svh/pyTgxodz4bS/BKxJz3nTUOc1/2w1wfV1
        uj2pkYqeAvb6RUoK6C2jHQuTvJb7JVZ2756QnXDN+DdRwfeRSj5GcZY=
X-Google-Smtp-Source: AK7set8M00ZKGa/Z6gExCxHwgZnLO9Ec15wOR2BKAuJ7UZnHwr8H2R46yNYEtvxgXLd0/fKqQyxPpIlndMTCwGkWl/g=
X-Received: by 2002:a81:4422:0:b0:534:eef8:caa9 with SMTP id
 r34-20020a814422000000b00534eef8caa9mr7040273ywa.8.1678128145947; Mon, 06 Mar
 2023 10:42:25 -0800 (PST)
MIME-Version: 1.0
References: <20230204014547.583711-1-vipinsh@google.com>
In-Reply-To: <20230204014547.583711-1-vipinsh@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Mon, 6 Mar 2023 10:41:50 -0800
Message-ID: <CAHVum0dHKAxqm3zk7zCdmY=BTFZYyOS-nGqH4WbYcuoVXDqjWw@mail.gmail.com>
Subject: Re: [Patch v2 0/4] Common KVM exit reason test assertions and exit
 reason sync
To:     seanjc@google.com, pbonzini@redhat.com, maz@kernel.org,
        james.morse@arm.com, suzuki.poulose@arm.com,
        oliver.upton@linux.dev, yuzenghui@huawei.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
Cc:     dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 3, 2023 at 5:45=E2=80=AFPM Vipin Sharma <vipinsh@google.com> wr=
ote:
>
> Hi,
>
> This patch seris is extracted from
> https://lore.kernel.org/lkml/20221212183720.4062037-1-vipinsh@google.com/
> series.
>
> Specifically, patch 12 is taken out from there and now expanded in to
> this series.
>
> This patch series contains following changes:
>
> Patch 1 & 2:
>   Make a macro to clean up all KVM exit reason test assertion.
>
>   There are few places where explicit run->exit_reason are used but they
>   cannot be replaced with current macro.
>
>   I used following command KVM selftests directory and changed each
>   occurrence:
>     grep "run->exit_reason" -nir ./
>
> Patch 3:
>   This is from Sean Christopherson. Adding a macro to generate KVM
>   exit strings.
>
> Patch 4:
>   Sync KVM_EXIT_* reasons to sefltests. Many reasons are not present in
>   selftest code.
>
> v2:
> - Improve test assert message.
> - Add macro to generate KVM_EXIT_* reason strings.
> - Update selftests KVM_EXIT_ reasons to latest version.
>
> v1: https://lore.kernel.org/lkml/20221212183720.4062037-13-vipinsh@google=
.com/

Any update/feedback on this series?
