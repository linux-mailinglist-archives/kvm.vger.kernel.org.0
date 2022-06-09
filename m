Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2043A54578B
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 00:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345776AbiFIWmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 18:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232459AbiFIWmE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 18:42:04 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9AF163286
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 15:42:02 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id y16so19763148ili.13
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 15:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=/FRQdMUJFk/jNgSEtRr45RURpkqhM+6c+D2uuhvjBdA=;
        b=F1qS4l61NvQIYpWebJAGv78hw7aPsRYLCh3mE58G7/Ec4aOo3LrCtJs0CjLaGUtWJR
         HbHll4Vxu5pJfCti//ZoSU55atT3fGYdUPS7Eop91RNIfNFxyul2ajc6R6ZbwCqhWOA0
         M316HOJEXr02WadyV1yXbRaROpSr3L+X6W23KHeK5wb0uoMKZKMYAH08avnwJnTv7OjO
         ZPdR688JsZGrO7ENGSCIzqPN35AKWfR5jk38dqIutTgTAYLMIlK0ETIKPQJhdazjTY7Z
         W9zYk5UZQOKAsNsvYMGjbR1f29oZE7TNcka9AaDErsTuV4QVC1Ep8mXH7Qms/ElkjOHB
         nCgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=/FRQdMUJFk/jNgSEtRr45RURpkqhM+6c+D2uuhvjBdA=;
        b=b385JxJtZ1Ju2DW0Fg1LIrfwafhym5z6+UBzYTFmSM7KbiIIANdds/n7QCTow4v9W9
         TEpN7I04tEA9OjxT4qNCDgaNSsaREK7m5gL4s+9EvkDyQyrNzcz4BYw0Z/rlb3+FnfwP
         5l5JRxWjH8vqHT7jkemhOeCQo6b8jg8WXhsszUZk9Bq5eX+sNYDwWBRlIyTfVmFSDakX
         x82+6K4yUMuuIczyxLLdq+zBAcIo1KPLCsdVaZOGZcO9fqvbk6seSsvApcZsyhHn6qQA
         torxlGwpFmx6Z9+UhN7yzkYSk8pKO394HZ3+i1Wuq+K1etgE+AHfwrd6Yh0ToJ1RXwZD
         nqvg==
X-Gm-Message-State: AOAM531IgqoGItVbYS3ZcvD8mS3VBjxJGU2x/hHEq4G38QY903/Af3L5
        CmWFBgS+ENKWqmn8wKeyitexDfZG9mLDlzHmYF4=
X-Google-Smtp-Source: ABdhPJzgRr8Pkh3rIo3j118PVjZxW1ewQ3UP9ivmfHw7OBub/6Qeinf8Q12OoIs6jOyTL/Sq3j638J69f/kzX8hlZ3g=
X-Received: by 2002:a05:6e02:4a1:b0:2d3:a778:f0f1 with SMTP id
 e1-20020a056e0204a100b002d3a778f0f1mr23627282ils.212.1654814521989; Thu, 09
 Jun 2022 15:42:01 -0700 (PDT)
MIME-Version: 1.0
Sender: mrs.christiana.and.sons@gmail.com
Received: by 2002:a05:6e04:183:0:0:0:0 with HTTP; Thu, 9 Jun 2022 15:42:01
 -0700 (PDT)
From:   Jackie James <jackiejames614@gmail.com>
Date:   Thu, 9 Jun 2022 10:42:01 -1200
X-Google-Sender-Auth: 9lFhKWeef4HIRwiHUkfOjPxEbQg
Message-ID: <CANV73fB3N8Zat5qWFaMV1au93RFXbq8HLzxTfDh7X1LVUE71Uw@mail.gmail.com>
Subject: Greethings my beloved
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.2 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello my beloved,

  I sent this mail praying it will get to you in a good condition of
health, since I myself are in a very critical health condition in
which I sleep every night without knowing if I may be alive to see the
next day. I bring peace and love to you. It is by the grace of God, I
had no choice than to do what is lawful and right in the sight of God
for eternal life and in the sight of man, for witness of God=E2=80=99s merc=
y
and glory upon my life,I am Mrs,James Jackie.a widow,I am suffering
from a long time brain tumor, It has defiled all forms of medical
treatment, and right now I have about a few months to leave, according
to medical experts.

   The situation has gotten complicated recently with my inability to
hear proper, am communicating with you with the help of the chief
nurse herein the hospital, from all indication my conditions is really
deteriorating and it is quite obvious that, according to my doctors
they have advised me that I may not live too long, Because this
illness has gotten to a very bad stage. I plead that you will not
expose or betray this trust and confidence that I am about to repose
on you for the mutual benefit of the orphans and the less privilege. I
have some funds I inherited from my late husband, the sum of
($11,500,000.00 Dollars).Having known my condition, I decided to
donate this fund to you believing that you will utilize it the way i
am going to instruct herein.

   I need you to assist me and reclaim this money and use it for
Charity works, for orphanages and gives justice and help to the poor,
needy and widows says The Lord." Jeremiah 22:15-16.=E2=80=9C and also build
schools for less privilege that will be named after my late husband if
possible and to promote the word of God and the effort that the house
of God is maintained. I do not want a situation where this money will
be used in an ungodly manner. That's why I'm taking this decision. I'm
not afraid of death, so I know where I'm going. I accept this decision
because I do not have any child who will inherit this money after I
die. Please I want your sincerely and urgent answer to know if you
will be able to execute this project for the glory of God, and I will
give you more information on how the fund will be transferred to your
bank account. May the grace, peace, love and the truth in the Word of
God be with you and all those that you love and care for.
I'm waiting for your immediate reply,
Faithfully.
Mrs,James Jackie.
Writting From the hospital.
May God Bless you.
