Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB554DC03B
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 08:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbiCQHf1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 03:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbiCQHf1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 03:35:27 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E8DECC69
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 00:34:11 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id v25-20020a05683024b900b005b2463a41faso2958921ots.10
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 00:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=6i1SDPEpXn4Cbdu9WiwVL1qP8Wp3UikhY0bxG2krtHM=;
        b=E1hu+zCC50OiolU4V7Q5ds+0/n9hQngfqGARJfkoxEJPVGb1jix68nRp3KV+xdW1du
         YiKUwU7C2jXRJjwLQc0Vp5T/se7gZuPrrwy4dmemBIRJC2HJ5mbwC2b4kOFf6WjbyCf8
         e7aAZeW6rShjfY1VNiERN0nLpFf8rCEmhfKi/LDlp8LIxGGGYMp20O/9Wa9qy32fDpRt
         CJIpf7/fE3XqdAMYACCQAjvuVuaNQ2FHNh0ovlen++f12bSAvoGgUU8N+lAcFIvOCBK2
         V0qJNIJv8CSdfX2/wvG4kHVgCY1NYUO97vfE/cJfEeSWRnHnvDgQm10BzlyizR0K2UmM
         SNHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=6i1SDPEpXn4Cbdu9WiwVL1qP8Wp3UikhY0bxG2krtHM=;
        b=FMSfJ3/pY3uCFmcKaCsODU7QiscxVSnjl2Vr+tWHD4sQ/X6oerJj/nsJHy3ij59FTI
         9fgSERbytzz9Xk5X/Qm02lTS590M/hK6d+cTksgr6I1PaOQdgBEt65JQxa4+LFWToi+B
         sRz1UPjtQoEnZn8G6FnLGP58tGxaQ2gI1tsL7Uh4Qza7WFryO7PWdCYAP7ySV979Y9f7
         bt39Rz9HJK3a9CPd8Gl5shCrLxoITQQljGg0Y39ZW39t9oNEHVHO0whosohXCaSoNsXQ
         XpNsE3oZF22Y24Z1Oa3nOyDYLHuM3mLRXpCYvM4ldmwWavICPWfbZq31fz07cMM8q2jS
         5SiQ==
X-Gm-Message-State: AOAM532meA2KfcPLLbabSjlgKqK2RAC70+6iT6bdCFXxp8Bp62Z8yjTk
        dJyqVKdZmU0KR/tGDx0tGX4FwvgisLymknDl0g8=
X-Google-Smtp-Source: ABdhPJxk60a6C/m8GIx+xGqVZ6oZ8B/tGel4Bb/G/RmoxRou4j+qcencXzbBi5Kmp8MR5gcaTbu4PbfUOwBtAZHWRvk=
X-Received: by 2002:a9d:853:0:b0:5b2:617e:e982 with SMTP id
 77-20020a9d0853000000b005b2617ee982mr1174641oty.333.1647502450308; Thu, 17
 Mar 2022 00:34:10 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6808:2026:0:0:0:0 with HTTP; Thu, 17 Mar 2022 00:34:09
 -0700 (PDT)
From:   Steven Adams <alliazsegurossa@gmail.com>
Date:   Thu, 17 Mar 2022 08:34:09 +0100
Message-ID: <CACfbCsVwpK__jrDJ_6xAL1R9m7iuBGEeh2xaOeT+frr8iqfYhw@mail.gmail.com>
Subject: US7.3 Million Dollars
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FILL_THIS_FORM,
        FILL_THIS_FORM_LONG,FREEMAIL_FROM,FREEMAIL_REPLY,LOTS_OF_MONEY,
        MONEY_FORM,MONEY_FRAUD_3,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:330 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5001]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [alliazsegurossa[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  1.0 FREEMAIL_REPLY From and body contain different freemails
        *  0.0 FILL_THIS_FORM Fill in a form with personal information
        *  2.0 FILL_THIS_FORM_LONG Fill in a form with personal information
        *  0.0 MONEY_FORM Lots of money if you fill out a form
        *  2.4 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  0.0 MONEY_FRAUD_3 Lots of money and several fraud phrases
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-- 

Your email was found among the list of United Nation compensation funds
which originated from Europe, Asia, and USA.

You are among the beneficiaries who will receive a contractual sum of US7.3
Million Dollars and it has been approved last week. you are required to
contact Agent Paulson Goodman, with your full name, home address and cell
phone number for your fund release process.

*Agent Name: Paulson Goodman  Contact Email: deliverymangoodman@gmail.com
<deliverymangoodman@gmail.com>*

I apologize to you on behalf of world debt reconciliation agencies for
failure to pay your funds in time according to records in the system.

Steven Adams
Member WDRA
