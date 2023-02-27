Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA426A35BE
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 01:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjB0AB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 19:01:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjB0AB0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 19:01:26 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731D8EB57
        for <kvm@vger.kernel.org>; Sun, 26 Feb 2023 16:01:25 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id o15so16615227edr.13
        for <kvm@vger.kernel.org>; Sun, 26 Feb 2023 16:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UmEeOwX40JSo+c5SpZ774Zu3uqNMYvCVvH9aKus7QRM=;
        b=UzHsCCzJpN9kd0J8uN4Bl0SKZdD9q6qIin+mf+nQ/8Xmxctsu9JuSXG4rA2YXWJrdA
         9etEXhtHx/wqI1qddWZIbSqwdOKDsewkNJf2g3c6P9aql/erK1gGXRPHV+09ht8kvsBb
         JA4ssnmdpkTLo9YAwBW2N4Pc2gbRheuaUywH1QP8X4D7CPogS0N4Qln+zhu2gRy4+eBp
         b6QKD6qLFR/0exN1/Nc5+vRbuThZ11NzWt9U2mjFswT6+ZBOvo1jGlLG0U7NH523kUVC
         U5n/fyyoeqZcojxoUxjriNVJG8bb6MzjQUlU9KEOYbL3OWtQMj2e+ltACLRoqA1fnzhn
         8ubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UmEeOwX40JSo+c5SpZ774Zu3uqNMYvCVvH9aKus7QRM=;
        b=pzv4c0kMexFYbysIl8KUipEehEMB1IDoGW8SxkdJE6ZgejSRS2gpDKjkZnjrWymw2P
         VfhziY6dpzSmm5dRMZQAsx9tpY5LhtZkHXy2NHI3uCTeT2d5JBESJ8viPVhAY1lxr2b3
         Ad9OizjuRfeHWmedh6NZet935SvBYWsyEs9MUklSVhgzcb9Y0W+aAaMeoXuCLrVd6Cmg
         lkANCgNQPZAmOua7BZcAIyW7x5orYSvCH3U+JHRGqXnnYz7tOxhfb84lJNLNr97c5bpO
         8sxEP0KsQJjc3uRCZHtM6PjtymAjzeL6pqcyPc8K1EySWZeNqhz3X8XCPBEGbTNxFzuX
         9k4g==
X-Gm-Message-State: AO0yUKULRT6HMMtbu/fWw1Epz7piZYx8915MIUvDYUKaEcn7x9S3XsBF
        e+IFUxJxVIbrKRAvZ+aHvd1sHhbfykBvs0FAVVY=
X-Google-Smtp-Source: AK7set/N2zjFdCFiUNSaxBDiAC/vp84sVxYoDG5LVvzXy+qbL5C95j+E0wzL7zIleoWbgjwBL3cAUwNfWMTbpNkPTtI=
X-Received: by 2002:a17:906:d9c9:b0:877:ef6d:8e59 with SMTP id
 qk9-20020a170906d9c900b00877ef6d8e59mr14765807ejb.8.1677456083892; Sun, 26
 Feb 2023 16:01:23 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:906:5342:b0:8fa:d0d8:a89f with HTTP; Sun, 26 Feb 2023
 16:01:23 -0800 (PST)
Reply-To: sgtkaylam28@gmail.com
From:   sgtkayla manthey <faustinanagono@gmail.com>
Date:   Mon, 27 Feb 2023 00:01:23 +0000
Message-ID: <CALXzmeJT7K9ZE+jKz-zEcZU2Skwk_p9LtxGX-DNidVeQe+Kf=Q@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=20
Ahoj,
Pros=C3=ADm, dostali ste m=C3=B4j predch=C3=A1dzaj=C3=BAci list? odp=C3=AD=
=C5=A1te mi
