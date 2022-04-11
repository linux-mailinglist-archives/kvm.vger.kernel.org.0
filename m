Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0664FC272
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 18:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348070AbiDKQfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 12:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240375AbiDKQfX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 12:35:23 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE61A3150D
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 09:33:08 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-2ec42eae76bso22182597b3.10
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 09:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=1B6Q/eDwDgxOfcbU/QiQT+UVIvR/upb/mkptx4ZdaPw=;
        b=dks4Fnmx1F77oppy9nSoBZKbA/E3bvi8liNue/MBgCWJiUcAKE04YtZCm6z8Mi8Wcg
         xI7hfxusAcvntyNGh6Jojfhkhp/znIFsFqwEMRLZa2591sYhFoPwOrSIxQvsP2M+Pw1a
         PwYk5RIkXhP5KJ2Qp2MVBvlnRGnR1jotuz2Dn99SBwMm+e3LiqjIq3KrNT1NecNAM4zK
         YcycZhwXo9A14ksT3iLMbq5mq0/7r24n9SoQp7pP9xgcpXiAy8RDYaM8w8FmJWOsS0JH
         lfywnXiYCeL5yM4I91WKZLa5hlhyr7vMyPdifmNdq0voAColXsQtlhXvnzLdVFp8T0Iy
         oiog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=1B6Q/eDwDgxOfcbU/QiQT+UVIvR/upb/mkptx4ZdaPw=;
        b=rRkCcEeMTnYiB2NLIpl64KIh1ksVzeLjMEkxC77k+48mhCUqKKIjfDBY0DodqhfAKi
         6bgfEtyA26BobKrbsUWdxRKg2Q/KED4Yn7kw11U3XTGqYMz+NLCz2Skt/+l1VwlHRR7h
         e3OiOpbZFrAF2i0L2fuvGCx6XhqGWaBuuiyhAvewKpJp1EIlf0/fa6sepZ4MTHEaz5yN
         Cfp/bCi6xqmk9FuP4HufmSGj7SJ/hkxRxuqBKi+Dut12rk9ogh5IKr4PMvmyNyx7JSip
         zZXBaixj7EcCrq7kjkVnN2c40ag6TeP9HkOmhazvI8ZwCEC9hjztEf3+wClBoKbdKJD2
         pcRg==
X-Gm-Message-State: AOAM533/GxVYIN2ESFYXY3aCSMAJwM0/PX3nXo12Pz2EtOH13+kIpDp1
        4s/NNgbID3ejtdpP/3ZlbMYEaoFuX/FWZiuyX6Q=
X-Google-Smtp-Source: ABdhPJy+rd4ong8nDu+d0KBeoWdA1DL09+1UGF/JgbNZGi8Vx7LC+/BGHNPP+6m063I6d/O1UgAv7oeYRivW+qoMehk=
X-Received: by 2002:a81:834e:0:b0:2ec:1a6:72d9 with SMTP id
 t75-20020a81834e000000b002ec01a672d9mr8100261ywf.478.1649694787995; Mon, 11
 Apr 2022 09:33:07 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7000:a90a:0:0:0:0 with HTTP; Mon, 11 Apr 2022 09:33:07
 -0700 (PDT)
Reply-To: rseth00391@gmail.com
From:   Richard Seth <johnmomah16@gmail.com>
Date:   Mon, 11 Apr 2022 16:33:07 +0000
Message-ID: <CADo7566GS6+jkvxLvxZBYqUrUb4q0uw-RyJU_Fj93RvcraxjjQ@mail.gmail.com>
Subject: Richard Seth
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1130 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4973]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [johnmomah16[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [rseth00391[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [johnmomah16[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Good day,

An email was sent sometimes last week with the expectation of having a
mail back from you, but to my surprise you never bothered to
answer.Kindly respond for a complete explanation.

Yours Faithfully,
Richard Seth.
