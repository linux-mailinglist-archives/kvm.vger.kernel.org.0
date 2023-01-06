Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD18B660A07
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 00:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjAFXC6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 18:02:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235581AbjAFXCw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 18:02:52 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F98D2609
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 15:02:52 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id n4so3280129plp.1
        for <kvm@vger.kernel.org>; Fri, 06 Jan 2023 15:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Po1qRZ7i9SsgV7/X1uNMeArgBLjCy8nTNZqemVzXFUU=;
        b=pxQxEf1D3ccI6QJH9WQlE6sLgsgBdw1oEJYBmP0VCDupe08Pv8u1aIe6lM3gDGfVLX
         eg/x8bhnb/DN5/xaj5gO4VTQQLHp6xQpQXOonbWJZOD7bfzuHFKa6H0tVVGqpHptYUcr
         7bITKjiwcpqYmr8guV38t2YphkLtHGtNxWPMHs+nO/sw9EoFMPUq9H+K9DJr6Hw84H6i
         iUfqlObQDNn6RvkTA/J0g1hEQ1OlrU+xwCFj4+yxvNsL9dI1igw/ewlS89TUZdjK5CLx
         +fBRCp8b245tPrP0cKWdkyUQhfXpDgWWWI3f1R9idfkYeUhtQ0mah9sIRTIPvAHwgnCy
         YsoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Po1qRZ7i9SsgV7/X1uNMeArgBLjCy8nTNZqemVzXFUU=;
        b=XVp2oeOn05aiC3Fl/yMJV5m5yQm0CMMJfdJBHvN3KRlMVVo11Yzb5CcWDy1zin/zh/
         3OMnjcxWzI9sEG801Q5yJYcWXJWJxZ2mNiJ4JMPlaQq/tja2npr3oyeOuWOZmcFI3zXB
         uR0PjCllba4iz5+PbXiprS/pK7QTbmZUvLZwX1NeDbeUk98cf4tvf5R/EeFPIBFJoyNS
         uluyOk+TBWXt6HxbmtlG6lGBuRM5wwHmWBEFrLBZg3UXxt8axn3NdMhSJDdAnLd4wW8a
         vFoG5qBX+TwHLCSzasNnXSyVRJfrP2sVRULvrRKZPWeb84+3isCmGbmeiIR44yr6H8e1
         fJWQ==
X-Gm-Message-State: AFqh2kq3giHGfUO0YdEJPgETcagvhzj7QaAI+xffuUJcW53l2tXbhC/J
        l2d3CkM3eOno4Oz9Ty6xzDqeDScVsRPV8BCJPS8=
X-Google-Smtp-Source: AMrXdXtA7hz0AEALWOW1Y5Y54nZ2fJnGQcGFKGzWxTcmI5P1x8JOsmojp9zfedJd93fwdV0oOKuFf+e1/k3asqImgNk=
X-Received: by 2002:a17:902:e886:b0:189:90ba:e78f with SMTP id
 w6-20020a170902e88600b0018990bae78fmr3987294plg.29.1673046171112; Fri, 06 Jan
 2023 15:02:51 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:522:f446:b0:4ae:3588:b95e with HTTP; Fri, 6 Jan 2023
 15:02:50 -0800 (PST)
From:   Evergreen Burkina <evergreenburkina250@gmail.com>
Date:   Fri, 6 Jan 2023 23:02:50 +0000
Message-ID: <CABY4TiVDE-zfWR2em1_kDBS7LOe5uPcjiJYmBDej7PjCX26rUg@mail.gmail.com>
Subject: Greeting
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.8 required=5.0 tests=ADVANCE_FEE_3_NEW_FRM_MNY,
        BAYES_80,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FILL_THIS_FORM,FILL_THIS_FORM_LONG,FORM_FRAUD_5,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLY,LOTS_OF_MONEY,
        MONEY_FORM,MONEY_FRAUD_5,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_FILL_THIS_FORM_FRAUD_PHISH,T_FILL_THIS_FORM_LOAN,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:62e listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.9456]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [evergreenburkina250[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [evergreenburkina250[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  1.0 FREEMAIL_REPLY From and body contain different freemails
        *  0.0 FILL_THIS_FORM Fill in a form with personal information
        *  2.0 FILL_THIS_FORM_LONG Fill in a form with personal information
        *  0.0 T_FILL_THIS_FORM_LOAN Answer loan question(s)
        *  0.0 MONEY_FORM Lots of money if you fill out a form
        *  0.0 T_FILL_THIS_FORM_FRAUD_PHISH Answer suspicious question(s)
        *  1.7 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  1.0 ADVANCE_FEE_3_NEW_FRM_MNY Advance Fee fraud form and lots of
        *      money
        *  0.0 MONEY_FRAUD_5 Lots of money and many fraud phrases
        *  0.0 FORM_FRAUD_5 Fill a form and many fraud phrases
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RE: THE UNITED NATIONS AIDS AND AWARENESS SCHEME. SCAMMED VICTIMS
PAYMENT COMPENSATION OF US$2,500,000.00 (REF: CODE: 6363836)

This is to bring to your kind attention that the World Bank in
affiliation with the Office of Foreign Assets Control (OFAC) has
sanctioned the Government of concerned countries to compensate the
scam victims, including those that lost money on unsuccessful
contracts and transactions in Europe, Africa and Asia country. Each of
the victims will be compensated with the sum of $2.5 Million dollars,
to ensure that justice is served.

This is necessitated by numerous reports of scams perpetuated from
some Europe, Africa and Asia countries and all Over the world. There
have been reports that the victims have lost billions of dollars to
the scammers.

However, your details were obtained from one of the scammers who were
recently arrested by the joint security operatives comprising
INTERPOL, FBI and local security. The culprit confessed that there are
other partners in crime, and the security agents are tracking them for
possible arrest. Therefore, you are hereby advised to keep this
information confidential until all the scammers are apprehended.

FORWARD YOUR PAYMENT NUMBER TO THE BANK EMAIL ACCOUNT BELOW

Your Payment Reference No.- 6363836,
Password No: 006786,
Pin Code No: 1787
Your Certificate of Merit Payment No: 05872,
Released Code No: 1134;
Secret Code No: TBKTA28

Re-Confirm;
Your Names: |
Address: |
Cell Phone: |
Fax: |
Amount: |

Your immediate response is needed: United Bank of America
Person to Contact:Mrs RAPHAEL GODWIN the Director of the International
Audit unit ATM Payment Center,
Email: unitedbankof.america@accountant.com
TELEPHONE:+1(518)4148004 WhatsApp Number

Regards.
Mrs ORGIL BAATAR
