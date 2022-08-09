Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7E458E318
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 00:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiHIWSM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 18:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiHIWR4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 18:17:56 -0400
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2152B558EF
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 15:17:06 -0700 (PDT)
Received: by mail-vk1-xa30.google.com with SMTP id t64so568342vkb.12
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 15:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=ej3T27wdcOl5hgxFKEEvscpLUDARFbq7IX1O4+1Fbq8=;
        b=psEmfLT8btghhTn5Cun7t291puhq2S8WCbdeNX4uZQegh/c76OBWepxbpcUL6iiob0
         o2O9+lXJOcVhQLvQwcIuXncH1Gst1vdJVo0bZM6WThtkOtvwxEXQEQR1QwKyoJjiOaGw
         3mMSd4CbZT+QUywLCLkirbWmGSU6KzsLapFpjCvHjotD55Gfw+8sAUi5x4CWB6pb/YhQ
         WWo04er77zTBgyXy0FtSHnslCRhNRyiJBKpxVUnzqi1kXXaK4OWno8HvcnaOAP70ZnSZ
         xpaQAo//VWrEdUfUqE5e7NUA1eC2R1fh3uFgmEiAZY5ZWjQhmeSHqFaiTZ07t0a58mTy
         JGJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=ej3T27wdcOl5hgxFKEEvscpLUDARFbq7IX1O4+1Fbq8=;
        b=CMfebvUeG2EnJc+Ky7yNzWyCrWn2joeUKlHi/fQGzwENEmjA7CARMAKC++84KLtf/v
         0LADLR19ELTLV94JJu1ZposzYkX8RrEwUGKRzMrA6Kf0mtMVP8Y0rUyoqjXteaozzBC5
         4Lf+siU86AU6Q3nVktR+5Tio8pq2SUWEYvBSUMhexsqFuFmSsrgzU2lFPfqYIgUxFUUL
         CceV+Ayu38E0R07TVr9uw9HzdmkOgiHJygUpprsjHaq+ggT7QC0CxfvmhUmnspgtGjc4
         WLzy/B1+GtY56dFr3R8Z4tS8xWjdR2xuZGxSEOCHF4fy7Fs5uu9IWE8aWOG1+mcox98m
         DQEA==
X-Gm-Message-State: ACgBeo3ecxK2ch6RO1nLS8T5MYHWGVWk/7i1SeP1VMZCwfbd0KwCxpU6
        +o2LfaJLy/9nTZHOeUpQ2PnPUfq1YDNjSQDIdvI=
X-Google-Smtp-Source: AA6agR4VsmoMT/UnnM/BRgO5fOnynDR5005m5KryS+pw1hC5hotsJ7J3mm8oWOpWOJPB2AilWdlsigalqt8F75WxVjg=
X-Received: by 2002:a1f:c117:0:b0:377:855a:4e9f with SMTP id
 r23-20020a1fc117000000b00377855a4e9fmr10551798vkf.16.1660083425046; Tue, 09
 Aug 2022 15:17:05 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab0:437:0:0:0:0:0 with HTTP; Tue, 9 Aug 2022 15:17:04 -0700 (PDT)
Reply-To: wijh555@gmail.com
From:   "Prof. Chin Guang" <confianzayrentabilidad@gmail.com>
Date:   Tue, 9 Aug 2022 15:17:04 -0700
Message-ID: <CANrrfX4VqnS3c_iaQYzF-f8HUMAKN5e5r4L_rDGLrZDJkndEyA@mail.gmail.com>
Subject: Good Day,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-- 
Hello,
We the Board Directors believe you are in good health, doing great and
with the hope that this mail will meet you in good condition, We are
privileged and delighted to reach you via email" And we are urgently
waiting to hear from you. and again your number is not connecting.

Sincerely,
Prof. Chin Guang
