Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED63D564209
	for <lists+kvm@lfdr.de>; Sat,  2 Jul 2022 20:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbiGBSZu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Jul 2022 14:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiGBSZt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Jul 2022 14:25:49 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B44CBE03
        for <kvm@vger.kernel.org>; Sat,  2 Jul 2022 11:25:48 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id q140so5279321pgq.6
        for <kvm@vger.kernel.org>; Sat, 02 Jul 2022 11:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=uhgmRNRVj6kJGXwiKvUM1Q++vmKGdBHtK+RCml8flEE=;
        b=L2VOL5zrMIAfHOwtHFxqAv6Xn0CNpyzI89ATb2gB9bPUjIO4arBpZqfbC9S2NVn0fh
         Z/ZO5xj8947GBBUWLLxTOuGtqlNKpdNbmWnOnIkpyPNid9U0cutmxOJQ221qFy08DJRq
         6BL06+SW/OMbhDnHujzGH6rxRWn3G5vn28/Uqzc/YnxNZU+R/vPLzFoc87dTHXrf/ea6
         c37sG0PilHMDRboD/k/O4micw3Tq6vjQUxraEk8JaJ9kWAabmyYLxoSGpMUNij5lmTDG
         S2fZECC7qoyXNk0mnfg5/CIrvKBQpycSmu8h45L9j3M5ZXX4dyUr0xIfoJkrwISgf4lG
         Hseg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=uhgmRNRVj6kJGXwiKvUM1Q++vmKGdBHtK+RCml8flEE=;
        b=SvLII8v2AMuGmjpiaRaibTJPt4HcMQOZ5H0JMVdmp9vH5FpMOoVv95cwDBgutmbmGw
         fCI/fBU+uZpWT7QWuBiisDXZBDJu4Q+AMNEkVvUCKe8ioY4HCygPPXH0pB9JHVO+7bMe
         FkThGkVM3us7VN8GYoK3DhZ7G8KOGIXWXvaiuLq6p1lbHb2DqytKcYYtzLMwCNvEvoTU
         CIfa8FvcB2NwfVTRsS1qTUZ5oZnGTyOh9fAOcprpl138QgexKIf/dLyIRJEModZmJVqN
         Ef67wfzonTXBdYJrFSqGLCVkqgLc5hjGu0PntBZe8XHKouebEOQsB0/W48pDobi55zN2
         MQfw==
X-Gm-Message-State: AJIora9n4j1zm7d4w3x6qitkJ0pE1vdkck65eNUtwC/2u0SAQGvOabov
        nliE4LqmvlzPLX0Tc6Iq3sGjKqyB3BLYo1giWsY=
X-Google-Smtp-Source: AGRyM1u1EVwPZoEGueJZ8//pfWXtgK8jSMuifjvXQ6Z/erlZ+CjVAA9i00r5N3oLwWBeED19x9wdQEfPXieXT+LqTpE=
X-Received: by 2002:a05:6a00:218c:b0:525:5236:74c with SMTP id
 h12-20020a056a00218c00b005255236074cmr27925586pfi.44.1656786347730; Sat, 02
 Jul 2022 11:25:47 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a20:c90d:b0:85:c752:7095 with HTTP; Sat, 2 Jul 2022
 11:25:47 -0700 (PDT)
Reply-To: felixdouglas212@gmail.com
From:   Douglas Felix <franmerii42@gmail.com>
Date:   Sat, 2 Jul 2022 18:25:47 +0000
Message-ID: <CAOoRhhEoM9XSr40iuODkSbxATUQHZ6bu1dQbDeazawBS+-Fvng@mail.gmail.com>
Subject: Good Day
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
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
A mail was sent to you sometime last week with the expectation of
having a return mail from you but to my surprise you never bothered to replied.
Kindly reply for further explanations.

Respectfully yours,
Barrister Douglas Felix
