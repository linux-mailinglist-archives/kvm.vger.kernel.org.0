Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0585789EB
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 20:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbiGRS5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 14:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233788AbiGRS5Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 14:57:24 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474AD2F3B8
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 11:57:22 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-10c0052da61so26210400fac.12
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 11:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=h0ZslgqQ94UM3iGDYCZGEx8ZwvbYHY5ZrQARiO/Kpbc=;
        b=nZ6PZ+UBSZHm6g0nBxoZ3zVhtfI+yGgoyMw4xOJrmwxXMDoOysZZlBXoBWmY1svRLl
         U7UVqtpIupScRmdZYaUwhpqFr5OruqAhdwNyXDAgjHFZ0Q2y0TPJbg2Y96NqH6p7/Sjt
         GC/4TGIDop5cxVcNt4/4Yx/xkmvcDVqY14ad2VnxkJvVBOmNAfnq6skkm4sZF8SkPp1m
         C9akgwH4o3L9YWaqMvP8I6WE+GA1VVLMtztcVSQRm0xXJWUbVA4tKA0VL1J92l4tiGBs
         BbAx241dmSytvNCA3uDvpgbL5Nldy9s4jRljS2Dn/Ynznu/X8u1lrTYgiGjq0F55dmS9
         g/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=h0ZslgqQ94UM3iGDYCZGEx8ZwvbYHY5ZrQARiO/Kpbc=;
        b=gHuEkE9Xh3iVm86+n0NmPqwcp4L6Bh52QOdviKI+C4ZibVZLHaJERN6u+0XIIafR8A
         dS7BO91bdqgxYKNJUEEQ1sba+PoBja38iVKTFTwpRh0nfYqidB9M+B5JfaiQuJjbk3pH
         IfgOPOWBD+HaUI30Mw5I6xDCGokjBssuppnbIflYmwkyZWLNRUYNZd+F+d4+4MqLp9B3
         yFwiGl6wecn4lWMM2JX08xNWqe8BrdRFO1VLvQ6vX5wbGXgSbkVl/o6mUlJe8WF03DDw
         zcvUw6yy6TzGqbVnqPbvn47Cw7mzCy3WuqZKOECFvhtnqwvHLSAAoiQoJ+elrlgjanF9
         zsKg==
X-Gm-Message-State: AJIora8sRf3ook29ASxj/JhhPht9Lmn0LxvBzWiaq2/0wtZEYk1R20B2
        U11aJsXfSCtDD6LCp2BsAXxAqXjYsCPiOZL+LYM=
X-Google-Smtp-Source: AGRyM1uXvTsFjM8LNxJz5uuMX220/eslec/OqAzLUmdh8uwak8Gy3FlUEpu4inIXOAY/88sZbt0riKnPUsMIppzGDvI=
X-Received: by 2002:a05:6808:1447:b0:339:c893:674c with SMTP id
 x7-20020a056808144700b00339c893674cmr14353983oiv.171.1658170641392; Mon, 18
 Jul 2022 11:57:21 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6850:b093:b0:314:5f48:8afc with HTTP; Mon, 18 Jul 2022
 11:57:20 -0700 (PDT)
Reply-To: lilywilliam989@gmail.com
From:   Lily William <gonwse11@gmail.com>
Date:   Mon, 18 Jul 2022 10:57:20 -0800
Message-ID: <CALtkzusVFBg-YR+YvsG4Y8w75j+t8iRx9+7roG4cNRaFUa8ptw@mail.gmail.com>
Subject: Hi Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2001:4860:4864:20:0:0:0:32 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [lilywilliam989[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [gonwse11[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [gonwse11[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dear,

My name is Dr Lily William from the United States.I am a French and
American nationality (dual) living in the U.S and sometimes in France
for Work Purpose.

I hope you consider my friend request. I will share some of my pics
and more details about myself when I get your response.

Thanks

With love
Lily
