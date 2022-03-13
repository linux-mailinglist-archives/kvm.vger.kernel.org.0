Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D37854D73F4
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 10:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234130AbiCMJZa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 05:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbiCMJZ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 05:25:29 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C18FA22D
        for <kvm@vger.kernel.org>; Sun, 13 Mar 2022 01:24:22 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id i66so7599177wma.5
        for <kvm@vger.kernel.org>; Sun, 13 Mar 2022 01:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=Q/dSPLd14jBsqRkvVImwwZEsLVw2fno/X7Lt85ZSOio=;
        b=hg86shtiyPVezfyn8lXRz7/VycJrlJAry3gbYVD1uQm6Kdb4RxqLj3+kuSMAaWig/A
         3mDpxbM9zsYrPh3WhhZ0fWBYWZQ+fEc7XvOwO49BIrbY3qIloXiEUSQnh6i0lsv+bDBv
         qeTIJjR5I3HgFKauyWQwp0McWD9Ymuu0QQI0U6JilqBNhAxwZC9V3ZHgccZuM6F4SPOj
         aLzGW3Goh8B9RD4BmQGDGeAGm5t9hutv3ZoYiuifFKw2MrILdJg/tS654H+VrBX+Sz1k
         3InIME0eASxW7u7Ms0t0IH81l4yfq9gSiseIcsmvqAQv+8/Vzy/ZFsAp3oLWjXcoPSoV
         0J7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=Q/dSPLd14jBsqRkvVImwwZEsLVw2fno/X7Lt85ZSOio=;
        b=UoFu2TJ8tkf6E8hOlYpjRfGD0+Bpdh16cXLdUpmEi/zcImAvM0p4+jAVFlz5GJnik/
         kXttqEKhlD6b7WyfdyWWxBQGg5uKi3xKlZwBYnyp3eVJmGsfYlRzrQVMTvqacJpoZsre
         HW9hqZcjegGHxs48RRqGHIr4M5C9fuEl00ERB5ynCdDQDzWe1gRkptVFu58i9X6qYWQI
         4Z2/oDQ4fU5au6X8BhjlrQgdPhm1qq1mHSiCyaSvkqcm/2LKH2p7G9n2VeFX0Mnuo6mv
         Yh1jd6Wxu/cv0axv7AXN6ivi7C+TMRCY1CivdP7uXG9iJZT34W9V2ngjC7soHIdiIlSn
         /Ftw==
X-Gm-Message-State: AOAM532bcmwmS8M4+q5G73t7zUxpp30dXi2H8aePXhTQz9XrFLz+lUxI
        6UI15+9dQ30jD5ZNgENA6Kr8mvUreVs+bowktAE=
X-Google-Smtp-Source: ABdhPJycAKdGxqVdTgt4K/ZWBxjEnIsFvkALFgSKFIvcIl05ZGNF3+Mg0ERw0ZVjEFKMwdA3erW4nGSY9PFqTrBktNs=
X-Received: by 2002:a1c:4c13:0:b0:389:a4ab:df7c with SMTP id
 z19-20020a1c4c13000000b00389a4abdf7cmr13223557wmf.14.1647163460342; Sun, 13
 Mar 2022 01:24:20 -0800 (PST)
MIME-Version: 1.0
Sender: mrsgracel326@gmail.com
Received: by 2002:a5d:47cd:0:0:0:0:0 with HTTP; Sun, 13 Mar 2022 01:24:19
 -0800 (PST)
From:   Mrs Cornelia Pascal <mrscorneliap@gmail.com>
Date:   Sun, 13 Mar 2022 01:24:19 -0800
X-Google-Sender-Auth: -zwEGo_VEy_8UdBACQV5YnJXosM
Message-ID: <CAB-7u0DkaDPROX5hC8xtY=Gxfa4QbtiyWfnFVNjbBLOwp=PF5Q@mail.gmail.com>
Subject: Dear Beloved,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.3 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FORM_FRAUD_5,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        HK_NAME_FM_MR_MRS,LOTS_OF_MONEY,MONEY_FORM_SHORT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:334 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrscorneliap[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mrsgracel326[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 HK_NAME_FM_MR_MRS No description available.
        *  0.0 T_FILL_THIS_FORM_SHORT Fill in a short form with personal
        *      information
        *  0.0 MONEY_FORM_SHORT Lots of money if you fill out a short form
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  3.5 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  0.0 FORM_FRAUD_5 Fill a form and many fraud phrases
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Beloved,

I am Mrs. Cornelia Pascal. an aging widow suffering from Cancer
illness  .I have some funds Which I have inherited from my late
husband, the sum of  ($10.9 Million Dollars) And I needed a very
honest and sincere Individual  or co-operate organization that will
use the fund for work of humanity, I found your email address from the
Human resources data base and decided to contact you.

Please if you would be able to use the funds for the work  of humanity
as I have stated here in order to fulfill my late husband  wishes
please, kindly reply me back immediately through my private email
address for more details:  <mrscorneliap@gmail.com>

Thanks.
Regards,
Mrs.Cornelia Pascal
