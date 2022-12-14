Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 206B064CC8A
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 15:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238595AbiLNOn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 09:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238441AbiLNOnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 09:43:24 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD13924979
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 06:43:23 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id o127so21643535yba.5
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 06:43:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PAGV2Q8tueB9u6nAu32uT5tMQP/9mkBrRApmZJ0yLwI=;
        b=SyvL0FaHaurKAry6ffmCFWOZC/bxFmVIKaFWG7nJ7O7YMAc3KDBaVtm4OXV+CyRzRY
         RffyeegjDAYl0K9EvLQfmR5yFoPEIIv6ZpTz4A4aELZ37tTt2Jn5DLU8iPH9agztWcpr
         sWcZtlq/rmGS7NBV3s7aJaSyMd43FauUXHeqR82fwDQjlIX1FLlUOjfR9nQBYAXvCGAn
         CyJ1F9VxFPc3U4983ylZtrBkITaGWirWxWSzmpfK3YmvIjAd9x1EIPsGtHzH4eQ8LhNC
         plX3/9+viGigk/+napPq37MsW1ADpHn3cBLFekBefeq6A9NTmRHnuU6UeDriJUTscJ+w
         uJdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PAGV2Q8tueB9u6nAu32uT5tMQP/9mkBrRApmZJ0yLwI=;
        b=uqJPfXMiQe3Rsqa6gFvWobByPNqwJxV6iwCVCHnkH3hXEH26YqSQ+exeMhle+E9ss1
         ewwmEd+KIo824k2KfDGv27VuhP7OlIhUdnEfusKzM9bgoG2qXjt72ra0LeriEqeIyAXH
         bP2FDXUoHPMGvPN0TBxdbAe9rkXxicNZqXeGQZIrX8HdHm0f1SxtWwgXR1kP1HWiDiXD
         0IX/NLmseRlq+5gDz8CdQTSJ229VYljK89txcUgqxByR8H5uG7pAjMuuC8xthSqDVYzZ
         BtXiinD3FJkCorilolPfStC6wte4cHHTDAcohTNNHc1m6+Mb0VlJbHKGNDF+jiAq51Ub
         0bfg==
X-Gm-Message-State: ANoB5pkK6YWEo40PFPrSmmVCJQ0fH5pgFkz9CU6+vlVseA3ftYH3SnvD
        b3Ng4P5pH9GdikaRUdM+UVJCMOgBNjnSxHDVCwjXFRSXczw=
X-Google-Smtp-Source: AA0mqf7wQOno+Qij6QIPJRmDkJfWvIz1zgkynKxXS1Or5dqZ+k6pLDIpnUXU6TUQSR5KcbXV20sp3y0usjJaHkfyKBU=
X-Received: by 2002:a25:e682:0:b0:6f6:41de:6ef3 with SMTP id
 d124-20020a25e682000000b006f641de6ef3mr52535817ybh.612.1671029002667; Wed, 14
 Dec 2022 06:43:22 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a81:4416:0:0:0:0:0 with HTTP; Wed, 14 Dec 2022 06:43:22
 -0800 (PST)
Reply-To: felixdouglas212@gmail.com
From:   Douglas Felix <mrjoshuakunte23@gmail.com>
Date:   Wed, 14 Dec 2022 14:43:22 +0000
Message-ID: <CAE8KSLz3T6kXsz7i=LnQYQUbCet8RYtVJBio-kKGPKPavauzLA@mail.gmail.com>
Subject: Good Day
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
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
Barrister. Douglas Felix.
