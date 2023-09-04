Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC117919DA
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 16:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349698AbjIDOmq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 10:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343739AbjIDOmq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 10:42:46 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3819D1719
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 07:42:33 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id 38308e7fff4ca-2bd6611873aso22836811fa.1
        for <kvm@vger.kernel.org>; Mon, 04 Sep 2023 07:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693838551; x=1694443351; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XWO5GsmQhTprJyOrv/gAo/XXiKxghrMWsE2NJ/Xk/dU=;
        b=BhdavFUUkLBLG2lyJVtawik2pL/xMruDkdmmcheQRteMv56deQ3PBFVxZn3cQ1ENw0
         24YvoLV4P50orDxBG1YLVsg7ZTt5Wot380zHK3m4r8aKZutd2cbc656Eiq3plImgpNpX
         GfDb5fWlKmF/4J1gYNI4dhT3AHhi/3UPBAZSAAyoZVv9YDyuje9BkeAYV+8PAGdpfR6u
         e4a1XYozjXYB01GEeak2vpfTuRNgknU94KNQGjtABTuyLxMtFuLlsS+1DKw3JO1bdk1B
         h//ORyuc5azXlfpD9r2RQ5p2/NUF9HVUrhW7RoawW/tyHT3QokMpAj2GH/5duT7jztW0
         /ejg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693838551; x=1694443351;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XWO5GsmQhTprJyOrv/gAo/XXiKxghrMWsE2NJ/Xk/dU=;
        b=Vi4gSbH/iGO3hFnNczRy/LcKQeyW5XHhgQQQ1QVZ2pqdzQ1aDwo8twdt7YjwDuTpwp
         mKyRk+CZRNsMTQYhGoWdnP7RytSCH+iDeEFwkxPKBlUXmGdezmO8cyiFiQlgGWzf9lTc
         DCpAVQiQAbhyBIZCC+yK0LpoTNILROTJKPLa7iDExWzMYHkE/kQfBOcm346as1xMroZp
         /mTjgugjRWiNpyd0utGC/SO/rwKQJ5FLf8bZBZP9nbUC5p2jpibTq3X1mtCdrLAo4438
         Eo39JKv+tcIWZ1Ohuza6Ue0NubWBUjR/uuJ5mzsisUvYPvnWmh7hPnN5SkdLHz9zWfQ8
         wlEA==
X-Gm-Message-State: AOJu0YwpFFs0oMag1a35aJnnSq3ndOJkD0ndczWmS2FlWgC1NJloRZoB
        gost9+JcsjFODnwdYZMkvpnymdttJCNiCd++lEQ=
X-Google-Smtp-Source: AGHT+IF958SlrrUaXesjXTy1eT4VnUfUXfMcRUeDehW3vX6hcK0uqr8WGlMaGQm4GC9uFoz1yYs6YaOghfkzcrqWBIg=
X-Received: by 2002:a2e:a40b:0:b0:2bc:bb3e:1abe with SMTP id
 p11-20020a2ea40b000000b002bcbb3e1abemr7472150ljn.41.1693838551260; Mon, 04
 Sep 2023 07:42:31 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a2e:918a:0:b0:2bb:9a95:1bad with HTTP; Mon, 4 Sep 2023
 07:42:30 -0700 (PDT)
Reply-To: markwillins999@gmail.com
From:   Mark willins <stellamilojica@gmail.com>
Date:   Mon, 4 Sep 2023 07:42:30 -0700
Message-ID: <CAEoCe3+voKbqkXWpnLkvfYkG321VuRwRJbV0jDePtrnEs_fUMw@mail.gmail.com>
Subject: Re: Greetings!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,


The HSBC Bank is a financial institution in United Kingdom. We
promotes long-term,sustainable and broad-based economic growth in
developing and emerging countries by providing financial support like
loans and investment to large, small and
medium-sized companies (SMEs) as well as fast-growing enterprises
which in turn helps to create secure and permanent jobs and reduce
poverty.

If you need fund to promotes your business, project(Project Funding),
Loan, planning, budgeting and expansion of your business(s) , do not
hesitate to indicate your interest as we are here to serve you better
by granting your request.


Thank you
Mr:Mark Williams
Finance Planning Consultant
HSBC BANK
