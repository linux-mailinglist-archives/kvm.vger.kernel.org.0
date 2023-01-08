Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E056614B3
	for <lists+kvm@lfdr.de>; Sun,  8 Jan 2023 12:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbjAHLRh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 06:17:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjAHLRf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 06:17:35 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70192B4A4
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 03:17:34 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id e10so4060288pgc.9
        for <kvm@vger.kernel.org>; Sun, 08 Jan 2023 03:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HcpM41K3Tg/Gq2Sy2fOw39ukTQf5X/VzmfsS+yU67xU=;
        b=ZzXQv6XRMoQ6eD5WWCHNCvUkGxrKDlA1PMiHG4OLm6fAwA2J4b1qweV54tAnr6mni9
         voS1ve42p8lKI65b76g/zv0dKbu0TtCuJTScGHg7bYTIBqIvnZV1FbCDiT4jvuLCQf/8
         3RnNh4V5mnwPc2I8kJs6kDCHGXUEf8taj/HWJRLPeEs11MVB+TTlpNuPKC/RG9xltx87
         kBA1e4qb3igexQHUaDmLP0Pdxga2PXC9ZLa3diAbElGbRa/OOQPaFkeFx06egWQejV3H
         aDkq8NQ/VLVqZJKkzruZ0x/ZlJkvwiVkaGOgNjnvLJBW3+ZgmmqexFxeiWbwUBSuove6
         9fEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HcpM41K3Tg/Gq2Sy2fOw39ukTQf5X/VzmfsS+yU67xU=;
        b=DLOxMSJy6wvh8dqrfA+WmrwfDJHjsR9cUqA0zHYvJP87cQtsn5/K9zBN333L3qlmHd
         JkHFbE0hCXrtRGomGPfabuaDULQz1fG+PFFN6GT8ckOFiZS7uwysDggrT/sFCvy0YU/P
         GhPf2vyiTBlN8VvqWV3orQWibeYiSvg0JE4lAyqKxtwlmpJ3DRDBR2NfUiGyiYIycvcU
         8SsMeiAa/tlDe41qspIjhv+9yaDYpRnX3udMM8jov33ic5xMi2sPUV2GA9yeKAmzeYCA
         HjZtWXrql8YstQqRcZXferNQlJLxgjZ1t9G1IUvpx++XmINvmcoGn7BhXWuZ+/H9MtsL
         7d9A==
X-Gm-Message-State: AFqh2kpAZs7CEp0HAWmG6OTLWW74JRQl6li/VXuvyMuRfUwZqMFYJS62
        u6smEVfnpac2o2fjvgQCgv10wQE2Eft/zKpXWVs=
X-Google-Smtp-Source: AMrXdXtPFOKeaVx08dsD8t71hlGjYQjbV2ikV7BQCSmV7tFzDRqsPISGPJbBQRon8UIq7iKN7c+9coGf+vmx3E4yaH0=
X-Received: by 2002:a65:58ce:0:b0:486:a74a:e4cf with SMTP id
 e14-20020a6558ce000000b00486a74ae4cfmr4461753pgu.324.1673176654011; Sun, 08
 Jan 2023 03:17:34 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7022:48f:b0:4c:e0ab:70aa with HTTP; Sun, 8 Jan 2023
 03:17:33 -0800 (PST)
Reply-To: muhammadabdulrahma999@gmail.com
From:   muhammad <salehmohamedsalemalnabit@gmail.com>
Date:   Sun, 8 Jan 2023 03:17:33 -0800
Message-ID: <CA+CCqN10W9tAH2VsuJJmkiP+cg1OQ87uiE4Fvvd9ferHLJEsdg@mail.gmail.com>
Subject: Re:Re:Inquiry about your products.!!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.5 required=5.0 tests=BAYES_50,DEAR_SOMETHING,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:541 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5560]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [salehmohamedsalemalnabit[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [muhammadabdulrahma999[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  2.0 DEAR_SOMETHING BODY: Contains 'Dear (something)'
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Sir/Madam,

An open Tender for the supply of your company products to (Doha,
Qatar). Urgently furnish us in full details about the standard of your
product. We will appreciate it more if you give us with Details:
Specification and Catalogs or Price list via Email.To avoid making a
wrong choice of products before placing an order for it.

Terms of payment:An upfront payment of 80% (T/T) will be made to your
account for production,While 20% will be paid before shipment.

Thanks and Regards
