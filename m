Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C23A160D227
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 18:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbiJYQ7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 12:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbiJYQ7C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 12:59:02 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE86B101E2B
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 09:59:01 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id bk15so22151422wrb.13
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 09:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J0K5FduIrkPmMnSKpCjhTfhH6+1DY4nfr2hITA+MET8=;
        b=mO9MZOyZUSTOfTTD0TkiYyVl9UdCUvQss7JXKpDotjn8CLkEtxxW0bOMqEFU3DX8bc
         D2k+1GiqhRfqpwyzFu+0P+3dU3azlFaz+sCTgUJr8PKecFpouX+FVEEgF/FOW4mThRAb
         wjwKJFbJgEzTqYSq1XMc5uEDqTOe1IUAkx5oBHGdoX4X27mZHRCWZDMQjKixf9IVQzvh
         u39DsIJo942HsAAxOtWCKQ4LalJbyoiVjQHdRQU75+s3wELu4qW2Y6TW1OjluQNDlpx8
         TpUjai6zvzi7twbi+TqGWNLbgHuozzb6APjwUxoqTOlP9jJe38zi2H7zz1zek4air9fW
         ni7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J0K5FduIrkPmMnSKpCjhTfhH6+1DY4nfr2hITA+MET8=;
        b=xqW4UKaYiETpssFvoUAU1nV70PeT6vGYNlUGXhuwsPOOB5pZ4hzEEWz8F/FvuDDszA
         j3+uOejAGDLDZPtuPmYzt9UNpjAQ+0Ofc4Dv0xODZPoyemT87smHQmzeSkDqZqm4U8ss
         vKVHcnCSQJrqtKsrn8o5cDcN1kiz6j/J6OB2BY6ED/KvXjYyJYtQw99TlXdoYZJTQtLO
         XxMP78jvkt8kdxC8FRUiTvW6FA5YsImyHvHo5QDfA9wk96i+kvl13pvZ8YGSmbi93OOV
         gjDx4ckJY2Oy44pfvJPBMn79nlJ0xfAk8IVzp3VyiGIq0vrHSYyFUwdMgMPvbGA9giSX
         rJNA==
X-Gm-Message-State: ACrzQf0Urt4xehq4qbdpz+THPwIz9bo9deWyfQ5YOAHucbC/i7GdBsRZ
        CgPbIDP0An3ObcMEylx4shYStN2mTTwuXffOGyM=
X-Google-Smtp-Source: AMsMyM7TFVcCa4Y1TVOjMekNezoE/KoWx0nrGJhO1XfiK+zGQwb+7qUbsJqJe4VJjRt/pMX0EjlulP9NH5OUG2P35z0=
X-Received: by 2002:a05:6000:1845:b0:22f:bfca:6439 with SMTP id
 c5-20020a056000184500b0022fbfca6439mr26352614wri.298.1666717140161; Tue, 25
 Oct 2022 09:59:00 -0700 (PDT)
MIME-Version: 1.0
Sender: klin.pai112@gmail.com
Received: by 2002:a05:6000:152:0:0:0:0 with HTTP; Tue, 25 Oct 2022 09:58:59
 -0700 (PDT)
From:   Sophia Erick <sdltdkggl3455@gmail.com>
Date:   Tue, 25 Oct 2022 18:58:59 +0200
X-Google-Sender-Auth: zOJA-LqT4P89zfdBKBiVTbLNQNY
Message-ID: <CAL=EmoaOZveam1RG7__8wDp1MS6j1GOmhQoM8BPJjFjGdACFiw@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FROM_LOCAL_NOVOWEL,HK_RANDOM_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_MONEY_PERCENT,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:42d listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.5 FROM_LOCAL_NOVOWEL From: localpart has series of non-vowel
        *      letters
        *  1.0 HK_RANDOM_FROM From username looks random
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [klin.pai112[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [klin.pai112[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  2.8 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

It is my pleasure to communicate with you, I know that this message
will be a surprise to you my name is Mrs. Sophia Erick, I am diagnosed
with ovarian cancer which my doctor have confirmed that I have only
some weeks to live so I have decided you handover the sum of(Eleven
Million Dollars) in my account to you for help of the orphanage homes
and the needy once

Please   kindly reply me here as soon as possible to enable me give
you more information but before handing over my details to you please
assure me that you will only take 30%  of the money and share the rest
to the poor orphanage home and the needy once, thank you am waiting to
hear from you

Mrs Sophia Erick.
