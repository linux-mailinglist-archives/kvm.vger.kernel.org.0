Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF6352C58B
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 23:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243174AbiERV1b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 17:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243143AbiERV13 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 17:27:29 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283017DE0F
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 14:27:28 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-d6e29fb3d7so4403978fac.7
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 14:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dnSjsKKcxnDfE//yC0we6Lh0hyyQnX/WnGwLkqIMpUQ=;
        b=hli0QRtj6h1/BX/Vr6DMtMeYBC+FOTnHsfiq/5oevHp01Lmx3t815bMBE2tGdAk6PV
         tpRBZ5z88mQdu3SKA/k/i1Ca/jah+WjJMp1KBGIZsMB96Qaay7UJycznlF2rvEl6XaJB
         uh7kcvaZ+W6QNE+EMe/nKBYcdwSpkzI4rdmDe7qiFYBE85v5UYjF4PuVqMjBSQuomR61
         TgZYEofLa7EXVqtrISpTodaJFfG09WV5udmbEIn3+1SxxXmT0BTAkmT6Kl3yAi/awDZS
         2c/e/NAwx+eVb6a3EkjBi0wBhxL0SAhjLv9IZw3CmWgx5yWLztz++KjLTw+leewi/ph8
         rXxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dnSjsKKcxnDfE//yC0we6Lh0hyyQnX/WnGwLkqIMpUQ=;
        b=k1QwhwwyjR6yZXWWkT2mwpULulquXORhBA80Bj2MH7k7/vvdG5Md2VenZuaJB1A9BM
         fl85Wrmied398U4tHKWNsNOO3Cw1JJVp07MgoG6MpfxKvdp9ysQYC+qaMrdM98dv0GJs
         LPtzyX3h2cYGhl5o1vNH3MZKbVQDps4yAEmcxYNZxnax8c40r3fNw3jZ485lul6k/eTO
         Th6H4q++MT1L3WV8HahnqsyHEwKP2/u1O3TcvUBRjejeJDTohZLqgvs1PExhHiVdBXPC
         FYA8/b8zfm+RVwgwnF8RqDFk0I46dxERwhsDAniffkQ7NPzfmYs3qSUiRofx5A2K66h/
         vtMA==
X-Gm-Message-State: AOAM531E8B1oi0fgE6N8oxlfKedb7GhNOuDHnHc5GRE4VkRY7fzMg/U6
        pZNGBg285EQoH9biz6ZmIUUbIyWlyptLDfZMNW/EzYPny/U=
X-Google-Smtp-Source: ABdhPJwiD8MCFNXduGkpBuiV8b22GP8AFyhkDMMsPis7++kqqkG6tNL79kvd2L2Hqlx90/p+sfJMhVUlgsIQFA+nH84=
X-Received: by 2002:a05:6870:e249:b0:f1:7fba:ce67 with SMTP id
 d9-20020a056870e24900b000f17fbace67mr1277978oac.269.1652909247302; Wed, 18
 May 2022 14:27:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAPUGS=oTTzn+HjXMdSK7jsysCagfipmnj25ofNFKD03rq=3Brw@mail.gmail.com>
 <CALMp9eQbpxHpGXJjYesH=SJu_LiCmCVTXYwV+w7YfdGpfc_Yzw@mail.gmail.com> <CAPUGS=r2BGsCfS5HOourwJG90z_3_-bPqRu2yz7dJye43qqRfA@mail.gmail.com>
In-Reply-To: <CAPUGS=r2BGsCfS5HOourwJG90z_3_-bPqRu2yz7dJye43qqRfA@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 18 May 2022 14:27:16 -0700
Message-ID: <CALMp9eSiXiRevZzPpsjPJSmhwdOS8dq57xWFiUarGqd+tSs4VQ@mail.gmail.com>
Subject: Re: A really weird guest crash, that ONLY happens on KVM, and ONLY on
 6th gen+ Intel Core CPU's
To:     Brian Cowan <brcowan@gmail.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

On Wed, May 18, 2022 at 11:48 AM Brian Cowan <brcowan@gmail.com> wrote:
>
> Guest crash.. Which console? Would the vmcore-dmesg be of use? I used
> "virsh --debug=0 rhel7.6 --console --force-boot" and got nothing on
> the console.

I know next to nothing about virsh, but I think you want:
% virsh console rhel7.6
