Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976F56A8D1D
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 00:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjCBXgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 18:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjCBXgr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 18:36:47 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD89746081
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 15:36:46 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 130so482443pgg.3
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 15:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677800206;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BgxI8luKvKPpK2hUBn1yPNdvu8ZuZS5lD3jYTE9pqDU=;
        b=MRu3mAJXVNBjC/mrTnDTyncz5NotvXg+P24eA9GL1c3GXRYetRZ0BAQuQMY4lkipXX
         4Fa6yRNs3Y9atgghwfHB3g7U8pztqQtz+BD8g9ULCRr8PCJvXmpjOBkUjEl9bflMWxRp
         BsBYvtd8zl0mOEpPmabyPxdrf98z3dh7hqnJqoqt1IjOrezh7wtV5Nb5XOGkNIi3Ah+9
         pq0C2cJk+io622q9wVjPUnCFTkfd8g2Sfp/PwQxc0rV+BWV+nd8aMmjXVtz5GKrKSANL
         N97maXQ6/Z8r6XO+SOQlx0Khy8rtzT0xEubi/w1dV4ZfipFdVSFTKU74kMs1F/Xz5+HF
         /ZsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677800206;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BgxI8luKvKPpK2hUBn1yPNdvu8ZuZS5lD3jYTE9pqDU=;
        b=JhmtE0hvDu87SGyk9U0n8uZZTgmamr+zj2GJ9ekdxn/wHE/xtnt1o9V4vVaA6YHte1
         qOw3sbT29SAaoxkPwVT1+eu+J8CAXM/uvWJikmrI5YVGDqYPbhk2t2DN1yV5SorIjWh4
         bJxFxEnFsUqKJzJUoUIidgaDF7JxCQB1kbI32RnSnk8Ce9kDclAEk3TakWctBtzPvmYL
         q1ZkvTmkbs1LwugSyJ5MeR+BBdlsYT1jAeJcE7GdCE3GUAAIvS6QSMUav7DDxYD00xpP
         RWW6YEok35OOffE6wIuYiwhcWbZ9cNY7yV0LxVnnr0YjqEs134k3IfZa/DypHpNaz8Jn
         ekqw==
X-Gm-Message-State: AO0yUKV7MX0YWjNG67/strxqDvYXXzLFhIFjNWsJVdwHLKlFgu4tV3Ry
        d/gJm+7TPGfC5BG/nd48o1xldVx+PB4RcYwyaD4=
X-Google-Smtp-Source: AK7set92ZXGcCs/JLfvCTK51XIkI9bxrWOqBnKMAw+w1roIdv4jiOPWppJ7hJgBsHvmH1+aI46XL9vNiAQfFCeg1SDI=
X-Received: by 2002:a63:ee12:0:b0:503:7be0:ea51 with SMTP id
 e18-20020a63ee12000000b005037be0ea51mr3802560pgi.9.1677800206122; Thu, 02 Mar
 2023 15:36:46 -0800 (PST)
MIME-Version: 1.0
Sender: a.ragnvar50@gmail.com
Received: by 2002:ac4:d7c8:0:b0:5ea:afd9:251c with HTTP; Thu, 2 Mar 2023
 15:36:45 -0800 (PST)
From:   Stepan CHERNOVETSKY <s.chernovetskyi@gmail.com>
Date:   Fri, 3 Mar 2023 00:36:45 +0100
X-Google-Sender-Auth: _rx7Jt22NUd-eaGPsEkf5KvrXvE
Message-ID: <CADmpa4GX0TE3f98LLrjH0Y74x7A4r2Mx2kEd5=Tnuc8Wu_E9TA@mail.gmail.com>
Subject: INVESTMENT PROPOSAL;.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.5 required=5.0 tests=ADVANCE_FEE_5_NEW,BAYES_50,
        DEAR_SOMETHING,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:52f listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5347]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [a.ragnvar50[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [a.ragnvar50[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  2.0 DEAR_SOMETHING BODY: Contains 'Dear (something)'
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  1.1 ADVANCE_FEE_5_NEW Appears to be advance fee fraud (Nigerian
        *      419)
        *  3.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Sir/Madam,

Please do not be embarrassed for contacting you through this medium; I
got your contact from Google people search and then decided to contact
you. My goal is to establish a viable business relationship with you
there in your country.

I am  Stepan L, CHERNOVETSKYI. from Kyiv (Ukraine); I was a
businessman, Investor and Founder of Chernovetskyi Investment Group
(CIG) in Kyiv before Russia=E2=80=99s Invasion of my country. My business h=
as
been destroyed by the Russian military troops and there are no
meaningful economic activities going on in my country.

I am looking for your help and assistance to buy properties and other
investment projects, I consider it necessary to diversify my
investment project in your country, due to the invasion of Russia to
my country, Ukraine and to safeguard the future of my family.

Please, I would like to discuss with you the possibility of how we can
work together as business partners and invest in your country through
your assistance, if you can help me.

Please, if you are interested in partnering with me, please respond
urgently for more information.

Yours Sincerely,
Stepan L, CHERNOVETSKYI.
Chairman and founder of Chernovetskyi Investment Group (CIG)
