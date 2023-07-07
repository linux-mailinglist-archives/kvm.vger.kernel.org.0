Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1146D74B95C
	for <lists+kvm@lfdr.de>; Sat,  8 Jul 2023 00:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbjGGWDt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 18:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjGGWDs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 18:03:48 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CC91FEB
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 15:03:47 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2b5c2433134so30475591fa.0
        for <kvm@vger.kernel.org>; Fri, 07 Jul 2023 15:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688767426; x=1691359426;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hVQi/8xXURrbilsiX3mxefWVIRl9F2NNfRgsuZtvioc=;
        b=aHiOGV3r7XHYSZOPnO5/DZcArhL4UOln6jW0+Kv1Pdgy/mTcKR3W8aAgMbNYO8UmoX
         qfw0I7gOO7hQGhQtA9eQ/UHph3+znDVnKN8Tsx+Mu53aPF7zDs2cQmeX7vC7fc3L74uw
         kq/4TAX2cQyTrK4JZVlE1wA5VOXkD+oxXGGSN5Ht619/COpxiAuKXhrxMf3AvTavg9Eu
         IuwoiVVu5Ld2mtieYkLwkY+6jURTIm7iaV84ZdL8w9SGcI3o42Ees7re14lT8MGekjy7
         k9vlU5CBReYbNsNBUO2CTjzT+Le6OQGsH/tf28IMqoKej7GwVSDKynBnSy11ArsIo06t
         L1HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688767426; x=1691359426;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hVQi/8xXURrbilsiX3mxefWVIRl9F2NNfRgsuZtvioc=;
        b=fNXcnuSa0Ht1OVwKmMvaCS2X0HoOmFsqCRevy2ucCwQIWEpOovv8bxWF9CtpKwJjtM
         jjRDXk/6bW4S2JrmolD/oagYmqoeGTjWDIxeSNi+kMBRfOdG6XrleL35qTVlBJuwXuE5
         PbPEfwnDvMp6K0A6TCfbJQbFhopUgotsAM9a+r0KxBkBVKx561VuRJC/Fvasz2unoUUM
         hlv03yG883Kct3McSu5HAnGiCUXICHTCnNAsAOb/N+elyR4QAu72vza8lopnvo5yMU21
         wBN20RMU6wvc1lFW1uB4lLcherUEt93wzJu2G/sjqQuW6TVKbPaGYjlj15cYAgvEJ0M+
         BIRQ==
X-Gm-Message-State: ABy/qLalZRwZXEpBeVxF1UrrUqUZwgeUDWZCSCcr5jO8Jh4qxm8bB1Yx
        tBYoqB/0YMmcbs28/CtNDba1d+xzXQkcC0v/zZI=
X-Google-Smtp-Source: APBJJlFiw08JHw+afY3FVgfXVyR1W/xG8zKpSKHFXX/NUBKly0bFMuZFz8hH7fiqNyfbGvgKFBK/GLh+iJulh20lmMo=
X-Received: by 2002:a2e:8e35:0:b0:2b6:ee7a:f5ae with SMTP id
 r21-20020a2e8e35000000b002b6ee7af5aemr3762656ljk.16.1688767425699; Fri, 07
 Jul 2023 15:03:45 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6022:219c:b0:43:2023:e65c with HTTP; Fri, 7 Jul 2023
 15:03:45 -0700 (PDT)
Reply-To: sgtkaylam28@gmail.com
From:   Sgt Kayla Manthey <kenechukwu202@gmail.com>
Date:   Fri, 7 Jul 2023 22:03:45 +0000
Message-ID: <CANkpFmrUc5OV10AWpGJtYDfQDBcOUbGP5Uac6mW8NwrtBfXpcw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
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

-- 
Greetings,
Please did you receive my previous letter? Write me back
