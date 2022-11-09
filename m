Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4CB7622B69
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 13:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiKIMVO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 07:21:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiKIMVN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 07:21:13 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25571E3E
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 04:21:12 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id j12so16929528plj.5
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 04:21:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fbObnRmjFLzcDwNhEwFLaA7JYkgzeFM/bY/YZa9vDN4=;
        b=LbmcTPPG1s0AmdtCagZ2K3ZSI8C6tv3gwhiB6gE1qrPV1oLt7yFcJjPLxKDzdeUD/o
         6n/xE2XVwUAVZX1CtkSARV635Qx4IwtlO0o9S+TkCb2vP2lETOKZqrjxS/+9wfGvm+5+
         PFapCnFrxpH12ZlPHuuMvB20sYUqumlmr6DMg7QGZ8NevEJUnwmaP8euOXp9IJKOakYP
         Bj3eQFEdqFEKJEibNERTj2BDtb2iJRMqgN4HuCzpUWPGQW2NMi9iAhLh8OB0ivx0B3+B
         BURNbHqGNQElgIwE7EnudPmyMSUaGgxQmgaFhNub7ipJY0x5gmuBVqFNAkcyTf7fy56T
         kxYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fbObnRmjFLzcDwNhEwFLaA7JYkgzeFM/bY/YZa9vDN4=;
        b=2CuwXpTzImSpjOT4nxu2wGwlBNvB0lRJTXHj5wM4D/Lh0+FO6qmT2RY142t7l5j2oY
         dGpjS6gi7EwZ9OH7ksq2dxECef194vcXMPhwrxK5NcsyBXQFuH9fq/JKV99GdnuqLddO
         WbyAfKW65K70rmxfmpkvkY2zhid4X3YvltRJDF0DGWVmqX3mvv9OwsBQHEvuYgU5N4DA
         /SwSHKop+AqPShEItIdfF+F9MFWshXOuxNszUCEyjl1wpy+RoSqNhoy8BuaeWNtGb/cn
         SMAVCnCcbMTlbZQLszLgdwI1sODnNpqT5beC8gEnQXxRjGJ3CVoVY7Uix2g9BZc4ATbL
         tnoQ==
X-Gm-Message-State: ACrzQf1LrIZYDul3YOv2HUp7qIgfBi1R7uq06GsiH3nXMox59ikahkYk
        iZqH+BWCvGYksaqP3qmYmKLzBhsELDw7itEHkDA=
X-Google-Smtp-Source: AMsMyM7hF+iyfOnRObKyES9Ul/c9vbO3Z08f3fWxEppUniz/kVIAXJB5dEA5FjCBxecrygJF0CkBk+ZFuKY7ff1LOEM=
X-Received: by 2002:a17:90a:7786:b0:214:2a4a:4a28 with SMTP id
 v6-20020a17090a778600b002142a4a4a28mr41395924pjk.132.1667996471605; Wed, 09
 Nov 2022 04:21:11 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7300:8193:b0:83:e6f3:260f with HTTP; Wed, 9 Nov 2022
 04:21:10 -0800 (PST)
Reply-To: westernuniontg453@gmail.com
From:   POST OFFICE <verawinddymelody01@gmail.com>
Date:   Wed, 9 Nov 2022 12:21:10 +0000
Message-ID: <CABnZ=7SBiULKAmkUgfjw5XbMiEJ2BP+wCXY4BcmX27K6XdH2yg@mail.gmail.com>
Subject: =?UTF-8?B?0JTQvtCx0YDQvtCz0L4g0LTQvdGPINC70Y7QsdCw?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=4.2 required=5.0 tests=BAYES_40,DKIM_SIGNED,
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

0KjQsNC90L7QstC90LjQuSDQstC70LDRgdC90LjQutGDINC10LvQtdC60YLRgNC+0L3QvdC+0Zcg
0L/QvtGI0YLQuDsNCg0K0JzRltC20L3QsNGA0L7QtNC90LjQuSDQstCw0LvRjtGC0L3QuNC5INGE
0L7QvdC0ICjQnNCS0KQpINCy0LjQv9C70LDRh9GD0ZQg0LrQvtC80L/QtdC90YHQsNGG0ZbRjiDQ
stGB0ZbQvCDQttC10YDRgtCy0LDQvA0K0YjQsNGF0YDQsNC50YHRgtCy0LAg0YLQsCDRgtC40Lws
INGF0YLQviDQvNCw0ZQg0L3QtdC30LDRgtGA0LXQsdGD0LLQsNC90ZYg0LrQvtGI0YLQuCwg0LAg
0LLQsNGI0YMg0LXQu9C10LrRgtGA0L7QvdC90YMNCtCw0LTRgNC10YHRgyDQsdGD0LvQviDQt9C9
0LDQudC00LXQvdC+INCyINGB0L/QuNGB0LrRgyDQvdC10LfQsNGC0YDQtdCx0YPQstCw0L3QuNGF
INGE0L7QvdC00ZbQsi4g0JzQktCkINGD0L/QvtCy0L3QvtCy0LDQttC40LINCtGG0LXQuSDQvtGE
0ZbRgSBXZXN0ZXJuIFVuaW9uINC/0LXRgNC10YDQsNGF0YPQstCw0YLQuCDQstCw0Lwg0LLQsNGI
0YMg0LrQvtC80L/QtdC90YHQsNGG0ZbRjiDQt9CwINC00L7Qv9C+0LzQvtCz0L7Rjg0KV2VzdGVy
biBVbmlvbiBNb25leSBUcmFuc2Zlci4g0JzQuCDQv9GA0L7QstC10LvQuCDRgNC+0LfRgdC70ZbQ
tNGD0LLQsNC90L3RjyDRgtCwINC34oCZ0Y/RgdGD0LLQsNC70LgsDQrRidC+INCy0Lgg0ZQg0LfQ
sNC60L7QvdC90LjQvCDQstC70LDRgdC90LjQutC+0Lwg0YbRjNC+0LPQviDRhNC+0L3QtNGDLg0K
DQrQntC00L3QsNC6INC80Lgg0L/RgNC40LnRiNC70Lgg0LTQviDQstC40YHQvdC+0LLQutGDINC/
0YDQviDQv9C10YDQtdC60LDQtyDQstCw0YjQvtCz0L4g0LLQu9Cw0YHQvdC+0LPQviDQv9C70LDR
gtC10LbRgyDRh9C10YDQtdC3DQrRgdC40YHRgtC10LzRgyBXZXN0ZXJuIFVuaW9uIE1vbmV5IFRy
YW5zZmVyLCA1MDAwINC00L7Qu9Cw0YDRltCyINCh0KjQkCDRidC+0LTQvdGPLCDQtNC+0LrQuA0K
0LfQsNCz0LDQu9GM0L3QsCDRgdGD0LzQsCA4MDAgMDAwLDAwINC00L7Qu9Cw0YDRltCyINCh0KjQ
kCDQvdC1INCx0YPQtNC1INC/0L7QstC90ZbRgdGC0Y4g0L/QtdGA0LXRgNCw0YXQvtCy0LDQvdCw
DQrQstCw0LwuDQoNCtCc0L7QttC70LjQstC+LCDQvNC4INC90LUg0LfQvNC+0LbQtdC80L4g0L3Q
sNC00ZbRgdC70LDRgtC4INGG0LXQuSDQv9C70LDRgtGW0LYg0LvQuNGI0LUg0LfQsCDQtNC+0L/Q
vtC80L7Qs9C+0Y4g0LLQsNGI0L7Rlw0K0LDQtNGA0LXRgdC4INC10LvQtdC60YLRgNC+0L3QvdC+
0Zcg0L/QvtGI0YLQuCwg0YLQvtC80YMg0L3QsNC8INC/0L7RgtGA0ZbQsdC90LAg0LLQsNGI0LAg
0ZbQvdGE0L7RgNC80LDRhtGW0Y8g0L/RgNC+INGC0LUsDQrQutGD0LTQuCDQvNC4INCx0YPQtNC1
0LzQviDQvdCw0LTRgdC40LvQsNGC0Lgg0LLQsNC8INGJ0L7QtNC10L3QvdGWIDUwMDAg0LTQvtC7
0LDRgNGW0LIsINC90LDQv9GA0LjQutC70LDQtDsNCg0K0IbQvCfRjyDQvtC00LXRgNC20YPQstCw
0YfQsDogX19fX19fX19fX19fX19fXw0K0JDQtNGA0LXRgdCwOiBfX19fX19fX19fX19fX19fDQrQ
mtGA0LDRl9C90LA6IF9fX19fX19fX19fX19fX19fXw0K0KDRltC0INC30LDQvdGP0YLRjDogX19f
X19fX19fX19fX19fX19fDQrQotC10LvQtdGE0L7QvdC90LjQuSDQvdC+0LzQtdGAOl9fX19fX19f
X19fX19fX18NCtCU0L7QtNCw0L3QsCDQutC+0L/RltGPINCy0LDRiNC+0LPQviDQv9C+0YHQstGW
0LTRh9C10L3QvdGPINC+0YHQvtCx0Lg6IF9fX19fX19fX19fDQrQktGW0Lo6IF9fX19fX19fX19f
X19fX19fX19fX19fX19fDQoNCtCc0Lgg0YDQvtC30L/QvtGH0L3QtdC80L4g0L/QtdGA0LXQtNCw
0YfRgywg0YnQvtC50L3QviDQvtGC0YDQuNC80LDRlNC80L4g0LLQsNGI0YMg0LLQuNGJ0LXQt9Cw
0LfQvdCw0YfQtdC90YMg0ZbQvdGE0L7RgNC80LDRhtGW0Y4uDQrQmtC+0L3RgtCw0LrRgtC90LAg
0LXQu9C10LrRgtGA0L7QvdC90LAg0LDQtNGA0LXRgdCwOiAod2VzdGVybnVuaW9udGc0NTNAZ21h
aWwuY29tKQ0KDQrQqdC40YDQviDQtNGP0LrRg9GOLA0KDQrQn9Cw0L3RliDQnNCw0YDRgtGW0L3R
gSDQndC10L3QvdGWLCDQtNC40YDQtdC60YLQvtGAIFdlc3Rlcm4gVW5pb24gTW9uZXkgVHJhbnNm
ZXIsDQrQk9C+0LvQvtCy0L3QuNC5INC+0YTRltGBINCb0L7QvNC1INCi0L7Qs9C+Lg0K
