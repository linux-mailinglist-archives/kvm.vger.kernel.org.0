Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1474D1FEE
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 19:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349469AbiCHSTi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 13:19:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349466AbiCHSTg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 13:19:36 -0500
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0668D396A7
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 10:18:40 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-2dc242a79beso201053587b3.8
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 10:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=oo2XJmePFb5oDErsPdptJnurLpOrjhyGiTCBcM40kFs=;
        b=h6mLb7fLhGQbMGjslfy5q0yMPi+HWyTn2UpSDt+E/dpy0TSbIoYKpS7rhc1s+bbBxU
         OofcQ1U9S3ZeVq1WjVaZm4fB08X6f3SkGnptvgIqcNC3qN96c9E9ee1rAVpc95ZVqIBM
         /xAyXLukVgnraNVE4ARNiUsv1N3tpjfiZiPAaTvn1sG3l9pVBzZqWGN/RPaMMfFVyt91
         ltmSktHZTHb58uTYqCxlTV5ad25FQkFgV4PkYJUarXy1dyhi/qwsYTzJkWb1VJLk7XVt
         RtCYKnIK6X3xYF3B1ocLge3rh/mlUMIb9/0hS11bfBiempYmtpgynDO0XWW/SJ6wm6nM
         VFnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=oo2XJmePFb5oDErsPdptJnurLpOrjhyGiTCBcM40kFs=;
        b=2Xl9WdcKDnjD0t2tABfwDrlVTb/a+dZqK2j6kf1VHe26Y5pLmPmldHf465zrbRqucb
         OgA21yXIMz1Wj9FHIVAHJfgXvDgtgqjgz5Owk//KKt9osETNTOIYMVKQxXQ+l/OGBa0k
         3agh676OTkqga3uNPjUjJhNByEMbnICMW7RS7NZTYJuyTmCZCx1UnsRqZcVys9WlLg21
         lYs4QfZJENX7NCsnPIi7LHwBpSJkrOqYhsjmvGxJDv/jcmT+W+07qEWlDsUgWzr3ZrJr
         3LUGp3qi/EUyQXaGFBXRibsyzj6mqxuhcAyujU0HiFDFz5MJG8PG7sUeVYyt/K1iLpY9
         +S6A==
X-Gm-Message-State: AOAM533Q196O2nPlLXvJuK2zACLyEwccy/GnyYNCZ/3l2jGwffIsVnOL
        8AA2m0rdPHCq8fGs2kP1zHNFNsAu5P/N4RvNEqk=
X-Google-Smtp-Source: ABdhPJzbyKm5J6tfZJLcRxt7RGEHLFFZFwdXU7+HBOyEK0CrgSTf/jwbcVAkhsKg58KYlG3c4ANypowG2x3LAoY1EH4=
X-Received: by 2002:a81:2341:0:b0:2db:dd3b:cac0 with SMTP id
 j62-20020a812341000000b002dbdd3bcac0mr13862854ywj.51.1646763519277; Tue, 08
 Mar 2022 10:18:39 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7000:b51a:0:0:0:0 with HTTP; Tue, 8 Mar 2022 10:18:39
 -0800 (PST)
Reply-To: blessingbrown.017@gmail.com
From:   Blessing Brown <steveraymond3415@gmail.com>
Date:   Tue, 8 Mar 2022 18:18:39 +0000
Message-ID: <CAEtFjNKCrUyRKnNxy=F4z3jr_dqz1Bjo8ZB-59+7xZjsXLcZ2A@mail.gmail.com>
Subject: Hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I'm Mrs Blessing Brown.I wish to communicate with you.
