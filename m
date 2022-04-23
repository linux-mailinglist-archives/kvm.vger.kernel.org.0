Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAA650C98B
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 13:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbiDWLVl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Apr 2022 07:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiDWLVi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Apr 2022 07:21:38 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB6F1569E8
        for <kvm@vger.kernel.org>; Sat, 23 Apr 2022 04:18:40 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id b95so18870335ybi.1
        for <kvm@vger.kernel.org>; Sat, 23 Apr 2022 04:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=KF9CBFBiCC+kvpalEDedIJ8Haa0pAmY/lXpNc2tlFI8=;
        b=ZvjIDoXlwiWnEm69C+1BlzvnvFls/DeGZe8wKYEGOlonUotcEZ4zGglVpP36MAKYUX
         qG3BQoloPeB9DVF8Cp3Mv55vg/hFf01bzSgHaoiL7OnAAh6NeV24uU/pGMSSMNjNtPvm
         wrr4BvNvPftzmozCokggF2IlTE0uZV/Gu2NKAohzNBzGDM4RLLt18ER5W41PnqKdApRR
         AcSiPwzfqhwNX/IdLnf0AFQ7jbkwvR6MSD/JWggrMgt6fiXBx18C6H8N2q5Gb2pjwPEt
         VCQNdSNnB3wmGD1kd2RlqsxUdtHmhvS0ORNFHlsU+83WoOi5oe1gKYlWgHYFpRTeLQYQ
         tIUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=KF9CBFBiCC+kvpalEDedIJ8Haa0pAmY/lXpNc2tlFI8=;
        b=khF8+TydNjtTCeyi/cXVQXEs70YpocmPI7TbLGPdfy/A1RGQ47CjLtFG9TM0OOk0Qo
         b0ffyr/4vIE1nM7/50arVAzgK8BElYuFXcLlipoqDnyMkKUJjbUvufl9CfOVyUNdoPJH
         nxh/pPxg0gQNj/0EgIHKDWcNpdUtPYRbbm5qbNWlWbjr2EGt6l0yv//NPa8V+zFAkL1J
         a1ubKWtefsM6pehUU5y8PyNTM7a3CvjYjUmU6fwKOzeSB/5ChaWzcZRxT1kLCW9CTrFr
         bVmpQtnkBqjT4hzvDzvK6GmOQnE79iz2ltr1Sye2VC8AaCWpGiCQ0lVwuRUBiggHEx8m
         Dm9A==
X-Gm-Message-State: AOAM5323PXDepYCGYEiLSCIBUTt5pgnaqDzJJQbsW4fXl9o4RIOF53q3
        LFwdnkxYKBqLFmeVJFFb3naRuNpRwLDNyGC+2fw=
X-Google-Smtp-Source: ABdhPJxFsM6I2sBvg/R6lER8KGnFTMKs/RYazcmVn7XgOMeUlc8+hsn1/oIXp9qyKiXU+8755lq+AG1b2mBeJdYI3vY=
X-Received: by 2002:a25:bc2:0:b0:648:3b1b:36cc with SMTP id
 185-20020a250bc2000000b006483b1b36ccmr1044033ybl.445.1650712720299; Sat, 23
 Apr 2022 04:18:40 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7108:71d5:0:0:0:0 with HTTP; Sat, 23 Apr 2022 04:18:40
 -0700 (PDT)
Reply-To: marianadavies68@hotmail.com
From:   Marian Davies <mamadouibro001@gmail.com>
Date:   Sat, 23 Apr 2022 11:18:40 +0000
Message-ID: <CAFk6F=R2ogOLGnzMWxFwJai6FB7cZ28OHmd3KBbQWCRjdwTsgw@mail.gmail.com>
Subject: Hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b42 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4917]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mamadouibro001[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [marianadavies68[at]hotmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mamadouibro001[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-- 
Hello Dear.....Did you got my first message ?
