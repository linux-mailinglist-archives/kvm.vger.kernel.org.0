Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485225B3D33
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 18:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbiIIQlX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 12:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbiIIQlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 12:41:15 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B8214343E
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 09:41:13 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id p200so3532479yba.1
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 09:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=bgGnDvZe+c8LuII7vL8lyuG/HfKB3YZ9q2O3O8JNa6Y=;
        b=DGcrrQqrVINJyiEP0Wl1JfOTeQHBaNjexSS35VrnO9NKAqhpRDgqmW11Fp8ua/e3fs
         T0fAKYpaARKFY8Mi8E88PIw7iEe11mDmrDTEBdC6EH6EMItLFdPIf00rMQimKY4bicj/
         hMXIWYi6FIkD+kKrdW1n/lJcKIO5Zm+ap2E4dfNm/ajcfuxCq2H8z9HOPyJ9bb8gjpm6
         ZEtggAswTJqd9WVea4GLMuOgKQNkiS5GYKGBSbaA4323FCZjf7g3VBrEhEcMKAXpHFaj
         MBL3X9L/fi6cGsTmub0sbBUAcRZuuZESQF1FW5KcLbGtFnelsoRR0eC8zFOQmiEvlUuy
         gLXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=bgGnDvZe+c8LuII7vL8lyuG/HfKB3YZ9q2O3O8JNa6Y=;
        b=MNvNI/tXfy92l9ivuw/W8ik4XYnMah7uaNRI/J0rdch0IjLEmQVyhq0NVVqj+6Q/Jh
         1RYsjDLrHZbftgx3gStrPMJ/hkcAslsSktWBjCWGwGalZHW8O3fg+/9WnBE+hK8pZ04q
         E3an2/Cre1nEOosG0PCuln3hJJNhfzx51qQXO/zDEEfrLQtHvO3Q+2JWE+ILLotQs30+
         14xwNc4XZZsZWBcminRkyYIgiyM6mXWzmhrZCFiRXQICg28fhQMnSvoQt43/DPkZhop1
         LMS5s7Z85DGS7ThWrHgzp1CYPMrgLgkk8+ZKri5O08b/THJTx9PYxGD5tClXWamJUoAO
         T9Mw==
X-Gm-Message-State: ACgBeo3Ejm/pa3Vt1n165bDYC0wBYgsybvZjhTvL0JE/RoShBTf3eE2L
        vOKBPYG8vFOJCKxBla4GQEFMmki5v2JE2KNrmlU=
X-Google-Smtp-Source: AA6agR5RY/2oQd4lrulLn2+rBTZfgXRkdV7rpoL5+RfvohZSehc3cwvtLvUW+qJcvu50DqJQC2ZMLGbHNaoL0JSkFXM=
X-Received: by 2002:a25:af41:0:b0:6a9:3f9c:b84e with SMTP id
 c1-20020a25af41000000b006a93f9cb84emr12650243ybj.537.1662741672707; Fri, 09
 Sep 2022 09:41:12 -0700 (PDT)
MIME-Version: 1.0
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Fri, 9 Sep 2022 12:41:01 -0400
Message-ID: <CAJSP0QUn5wianZaCu8Ka=eu2uuwtwTnTLD-P9pkb+PxFd=1Mzg@mail.gmail.com>
Subject: Call for Outreachy Dec-Mar internship project ideas
To:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Warner Losh <imp@bsdimp.com>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Frank Chang <frank.chang@sifive.com>,
        Matheus Ferst <matheus.ferst@eldorado.org.br>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear QEMU & KVM community,
The Outreachy open source internship program
(https://www.outreachy.org/) is running again from December-March. If
you have a project idea you'd like to mentor and are a regular
contributor to QEMU or KVM, please reply to this email by September
22nd.

I have CCed active contributors based on git-log(1) but you don't need
to be CCed to become a mentor.

Mentoring an intern is a great way to give back for the support you
received along the way of your open source journey. You'll get
experience with interviewing and running projects. And most of all,
it's fun to work with talented contributors excited about open source!

You must be willing to commit around 5 hours per week during the
application phase and coding period.

Project ideas should be:
- 12 weeks of full-time work for a competent programmer without prior
exposure to the code base.
- Well-defined: scope is clear.
- Self-contained: has few dependencies.
- Uncontroversial: acceptable to the community.
- Incremental: produces deliverables along the way.

Project description template:
 === TITLE ===
 '''Summary:''' Short description of the project

 Detailed description of the project for someone who is not familiar
with the code base.

 '''Links:'''
 * Wiki links to relevant material
 * External links to mailing lists or web sites

 '''Details:'''
 * Skill level: beginner or intermediate or advanced
 * Language: C/Rust/Python
 * Mentors: Email address and IRC nick

Thank you,
Stefan
