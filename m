Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 711E84EC40D
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 14:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243710AbiC3Mbo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 08:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243117AbiC3MbX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 08:31:23 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FFE593B5
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 05:16:49 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id bg10so41120477ejb.4
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 05:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=ecxhpUIqbH59Y7HRXHIS8qcVFZqCIrqicft9uPtRisc=;
        b=OzpEXZVLrO2sGLmpXvPCtizTIEyrqHLSWodSdm6wEldNy1pPw1U4Q83S9c6VUyYYiK
         UNe6Jget3SwLomQ3lqmzutFsm4t0dJGVDYszRejj+a+2/lTaMDVxFVvK76Inm0FPrfek
         KldUXZ+VQTBCZv5p/g+lHoasW5/l5ma6xHph11ecrDwMNlfj2Hyab3aidp7wtDvv9T8r
         kmChQHxK0vbkauk/VdwyYUf0Lex+5G+60qsMfrl4yf3ziqFf696dnI01NQ677DE6K26L
         93IruqaOyVMkw5cm+cUzGZud5NqRdC5CZ7tpKLyQzwud6L1idWRxyahZaLIaMtO9GSMQ
         MKXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=ecxhpUIqbH59Y7HRXHIS8qcVFZqCIrqicft9uPtRisc=;
        b=fIk9zfzeyc9edpz+59VKSVM0lxOUHJovNbyW/NMrhBKZDRXq1Xs8uAg2IgtVe7ywHr
         MTChbsFKKCjBfRrr0XIRsQ3s7PT5nbS4M32zPxfcjHk+RB6Yrli5mHykOiCghVz+emfE
         ZPXe0o0y+vSEgZIxjWFpO2pr2TdGu90B8vYxLWkCtg1sSWF749QuiZ+BK+LS2ssBr316
         +EiYybCbLa4GpymtV6dR2ud0soTFYCa61Nv+/EagTtkbdSJUxphkikRPhx2hxWuOEQYb
         2WI6M4dhTVZNfQaaCnjlcSueQYbfAlRu+hyMKSlkL9XLYNpDdWYfKxvBg7QBId2kzTu8
         q3sw==
X-Gm-Message-State: AOAM532ULdmY8rkcBCV7PuqM3KTH3P3n4zZhuIqE+dXiP13mBlFpOVWB
        kvlGMPfEwzu1OD/Ebhxa8EvgIYndpmPIp22TTy0=
X-Google-Smtp-Source: ABdhPJwphb8qQohQb44AgD21BlEUXZVZmJx1600kow8zNzjbAafoz+iZwBkWgWK7ZO6xLEPJ+JUs97B24PREd/ZzG08=
X-Received: by 2002:a17:907:2d2a:b0:6df:c027:a3ac with SMTP id
 gs42-20020a1709072d2a00b006dfc027a3acmr38840304ejc.179.1648642607715; Wed, 30
 Mar 2022 05:16:47 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a98:b48b:0:b0:143:8915:1e71 with HTTP; Wed, 30 Mar 2022
 05:16:47 -0700 (PDT)
Reply-To: kathrynh566@gmail.com
From:   Kathryn Hensley <marinavanessa534@gmail.com>
Date:   Wed, 30 Mar 2022 05:16:47 -0700
Message-ID: <CAAPyjrvzSa513wt2CKA+QTvLbmoPuOj4czaDBOvem_4meqSUFg@mail.gmail.com>
Subject: URGENT
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:642 listed in]
        [list.dnswl.org]
        * -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
        *      [score: 0.1066]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [marinavanessa534[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [kathrynh566[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [marinavanessa534[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Greetings,


Hope you are fine .


Please did you got my previous email to you ?


With Respect
Kathryn Hensley
