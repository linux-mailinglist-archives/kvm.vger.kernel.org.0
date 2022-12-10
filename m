Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C571C6490B8
	for <lists+kvm@lfdr.de>; Sat, 10 Dec 2022 21:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiLJUyZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Dec 2022 15:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiLJUyS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Dec 2022 15:54:18 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03041707A
        for <kvm@vger.kernel.org>; Sat, 10 Dec 2022 12:54:17 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d3so8286545plr.10
        for <kvm@vger.kernel.org>; Sat, 10 Dec 2022 12:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:reply-to:subject:mime-version:from:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ydTSF8dk1e0BckRx2wdzhp8HjupjiQZx7JbBuGi2k8k=;
        b=P45hxTrgFu1MIuSkxRGXywQRDwQuryGNu/zoyWuQKxnO3cWkcTwL/k+9HCGZnWp68S
         r4wSJBuIMn7DPWyccJCbtMEV86KgnQ3obfMh8Yf2ewH5rlYWzCwKeh+PDlSbvlI241Sa
         NgGjg3u1SRcC4lALaOx8PqrnGwJXsCqp9bMxuQIPn9pQY/y5DiWLHC/4BTA66I0DdAkn
         WuqliaptjLzowTcs531FzkW+8gtRmc1MexDZdad4Zy3Nv3jlccuWmCmqCgupMT6s/XyG
         F2NDD0/ZJHjKcSlpaBT2Cjm6MReVKUZ8p2vxi3w1aYJoXTjiItwmMrNc3WvJhag1YG8M
         DOKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:reply-to:subject:mime-version:from:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ydTSF8dk1e0BckRx2wdzhp8HjupjiQZx7JbBuGi2k8k=;
        b=kCzNsl2aMnbrRQPWImBzNjZu8zi4xZgPKjAB4wqhf3nD/Lrp/PtTR+qW/+QB7oL6aR
         i4g2a6tGdRwAtfrut/yiAT7hmEnfJYk7RLt0MeaOqGLNRQ6cdAEfVsOAdVEMVONmMRjB
         mkX1AeRjAIP5qm3gceKBHux1kujzEU2H0k/uN8aLmeEc1D03HFJab0mgL04jCMIhL47q
         lRUrADNy8SysVBFMFhLSUGdPiDXqoceGfJlknKANWFT8zCfAOI/vZ3bHkI8QM6W9OSxk
         DCIhZS9aLQjFOlcZA0FTBrKVqCCLPmV3ZNl/JyzaZK09SkjGytHzdXuTPl1j68WT4awm
         uOog==
X-Gm-Message-State: ANoB5pk7aQWpbg1p3L2UoTyoC9jRYRkboeSiqO91qtLTGZb1C9dYRZV6
        Mydn9PXy/nBx36QOtZYvgo0dEXAJ7pEkCCl/
X-Google-Smtp-Source: AA0mqf5RzDdlfW1uZSpa1K4hBLgySAgVDFWDWMlKl8Zv7FXNGhOYx9KwsFTraY1u7JLb4/DrWudPpg==
X-Received: by 2002:a05:6a20:4c99:b0:aa:45c7:fc94 with SMTP id fq25-20020a056a204c9900b000aa45c7fc94mr12297511pzb.19.1670705657020;
        Sat, 10 Dec 2022 12:54:17 -0800 (PST)
Received: from [127.0.1.1] ([202.184.51.63])
        by smtp.gmail.com with ESMTPSA id z9-20020a17090a7b8900b001fd6066284dsm2864132pjc.6.2022.12.10.12.54.16
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 12:54:16 -0800 (PST)
Message-ID: <6394f1f8.170a0220.c72d1.5880@mx.google.com>
Date:   Sat, 10 Dec 2022 12:54:16 -0800 (PST)
From:   Maria Chevchenko <17jackson5ive@gmail.com>
X-Google-Original-From: Maria Chevchenko <mariachevchenko417@outlook.com>
Content-Type: multipart/alternative; boundary="===============0768710025615054933=="
MIME-Version: 1.0
Subject: Compliment Of The Day,
Reply-To: Maria Chevchenko <mariachevchenko417@outlook.com>
To:     kvm@vger.kernel.org
X-Spam-Status: No, score=1.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--===============0768710025615054933==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Please, i need your help; I have important business/project information that i wish to share with you. And, I want you to handle the investment. 
  Please, reply back for more information about this.
  Thank you.
--===============0768710025615054933==--
