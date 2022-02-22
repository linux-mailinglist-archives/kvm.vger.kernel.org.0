Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFAC94BF231
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 07:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiBVGpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 01:45:00 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiBVGo7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 01:44:59 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CD1111189
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 22:44:34 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2d66f95f1d1so162437677b3.0
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 22:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=oeXnfgK9BOKBTMDptF2I1vpIGSBc56TF64IaWy5xIn0=;
        b=HsW8s1+N2ZpLpjvjRjF+XG8nLT1rcg5vSz2bjS/Z5BNqD7hHg81BLos8bT//+mL3Dh
         JUyxityJ1GrsnaoDXlIJxB9VHkVBOIz4WMCea9tWwB+0fGD5OYq5Gg/kjv819zf8+dem
         NPC5rYxgQUb4Rc8FoZC6F42fNu4O+NDCg7PUbCgfLGumlcz6lJFnuYkpoHjUEEJCPo3x
         F3HWnGJGOpPrnx+Ypa24ZrsZtMmJnFnZnddLL4OyyoRLIHjMdyWJ7ooH7xdWtKuxRSCE
         RvZ1jHVsCMQ2PcKz2lU04qOntv5ELx8N9aWh9f+nWOUOuFcpw9jarq/7lchdjkxzPItz
         xwlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=oeXnfgK9BOKBTMDptF2I1vpIGSBc56TF64IaWy5xIn0=;
        b=5E/1ZIQbgssHa1KCsWjT7rAf31HhVuigaqK0r5ODrALMF9c3uEo0//J4J6i8BlSPEu
         H2gAY2B/QMXprWAzfyo6xPAecggFLL6BneQtidAWuMj8+FvHHNn5iiziShXds13ckAKM
         Bx7TFVFsTnDTLuzTcoOkum3MQT6xlLgwUC6gv2tT5Ml9yiDU9vpnlZh+Z+Aq+E7Xq5Tv
         byOlk7um0jcCWFo5Ii5hpiHyzpmwSegSMJShLwz8ZszbaCF0DHgZn5IHp5qHzUv7DoIV
         Kdkf+pCilPgB7bypi1+G1HpxoeZdl+9rn3u1rBENA9eD4oAKDqGkJNGmPnmPnCj7IryT
         zrOw==
X-Gm-Message-State: AOAM530ebE3fYWcuzsBW/vtctnYdqd+ZYkTr/+i4KJnSnY2TLo1GACri
        ylIB74Ataajq89JQMzzpHIOBKjrAjCYyJ+aYYP8=
X-Google-Smtp-Source: ABdhPJymrJiFjtzEPK4dus+1liQlkKoHhqZ1kdSbQOzgHFBvJbLYVWWXfnzatdkP/f9KgCEu/fePtUVI9qkWrZTn1PE=
X-Received: by 2002:a81:e0b:0:b0:2ca:287c:6be1 with SMTP id
 11-20020a810e0b000000b002ca287c6be1mr22538189ywo.134.1645512273770; Mon, 21
 Feb 2022 22:44:33 -0800 (PST)
MIME-Version: 1.0
Sender: vmrjude906@gmail.com
Received: by 2002:a05:7010:9810:b0:210:8a2e:596d with HTTP; Mon, 21 Feb 2022
 22:44:33 -0800 (PST)
From:   "Mrs.Joan Chen" <mrs.joan71chen@gmail.com>
Date:   Tue, 22 Feb 2022 06:44:33 +0000
X-Google-Sender-Auth: G7bpALhvEFrPzpOmGVU5rrlqzpo
Message-ID: <CAHKUWg_ejWNOUfYW_fJm-ssSr-+9hu97-COhC6znnzNhuUtRww@mail.gmail.com>
Subject: Dear Child of God
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.9 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,HK_SCAM,LOTS_OF_MONEY,
        MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY,URG_BIZ
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1133 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5002]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrs.joan71chen[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [vmrjude906[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 HK_SCAM No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.6 URG_BIZ Contains urgent matter
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  3.5 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Child of God,

Calvary Greetings in the name of the LORD Almighty and Our LORD JESUS
CHRIST the giver of every good thing. Good day and compliments of the
seasons, i know this letter will definitely come to you as a huge
surprise, but I implore you to take the time to go through it
carefully as the decision you make will go off a long way to determine
my future and continued existence. I am Mrs.Joan Chen aging widow of
57 years old suffering from long time illness.I have some funds I
inherited from my late husband, the sum of (21 Million Dollars) and I
needed a very honest and God fearing who can withdraw this money then
use the funds for Charity works. I WISH TO GIVE THIS FUNDS TO YOU FOR
CHARITY WORKS. I found your email address from the internet after
honest prayers to the LORD to bring me a helper and i decided to
contact you if you may be willing and interested to handle these trust
funds in good faith before anything happens to me.

I accept this decision because I do not have any child who will
inherit this money after I die. I want your urgent reply to me so that
I will give you the deposit receipt which the SECURITY COMPANY issued
to me as next of kin for immediate transfer of the money to your
account in your country, to start the good work of God, I want you to
use the 20/percent of the total amount to help yourself in doing the
project. I am desperately in keen need of assistance and I have
summoned up courage to contact you for this task, you must not fail me
and the millions of the poor people in our todays WORLD. This is no
stolen money and there are no dangers involved,100% RISK FREE with
full legal proof. Please if you would be able to use the funds for the
Charity works kindly let me know immediately.I will appreciate your
utmost confidentiality and trust in this matter to accomplish my heart
desire, as I don't want anything that will jeopardize my last wish.
Please
kindly respond quickly for further details.

Hoping to receive your response as soon as possible.

Your urgently responses is needed

Thanks and Remain blessed
Mrs.Joan Chen
