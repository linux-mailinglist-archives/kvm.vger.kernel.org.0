Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A693516F77
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 14:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240923AbiEBMWG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 08:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiEBMWE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 08:22:04 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F76215FC5
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 05:18:35 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id f38so25730994ybi.3
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 05:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=gT0qunonoqmQDH3Sx35AGkd9jYv/vMqV6NEmgNMh3r8=;
        b=q4/vqlU2EvbjzSUOmZpWYEFZyttn7yJT1xljoWnxy1bBsO7+tJ81oGU5/aEC8cMZiP
         7BAckN0YKCffGuCUI8WOKNXIrpnF/w91mUNwNtDAE7XsMryy9W60JkmhFokaRF4T1fpe
         JkVQdfqEuWwdvYDFVJb7qWCQC8Wqqo8MwLRlQhqj0WT+fY0zwrE49UZfdiyX1qViC805
         VkVHXC2f/ZRf65nz/QwbRiyQEmSzyOnZpjPySieaYNLYb7b1fmLm/v4/n5iGLeYHd7Tb
         0IfVReXN+S/jL7UEj37URKeyCRJimy5pyZ/68lJa9tM7SbpIhU8Tc20ZOgvV5daLB8JN
         dyrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=gT0qunonoqmQDH3Sx35AGkd9jYv/vMqV6NEmgNMh3r8=;
        b=2o5/BJmUbVO9FhWZO/LUL82p4soVkBHee/XzxRKn3/1xhY2RhcK/9fm80LNB4Fvvbp
         vb7v0CTy8AYWKf/uP2J7zRbD0RgEIX90dHZyv6HKquUPNK7475gmey/ny5Sxbg4u51Sh
         +kP8cSX/rIl+k5kF7gRIAnCNOJuggbXFzIN/YEXf77mrvqlkELTZkZtvcSbPAdHsOiNO
         pWHwOGHtVs0qJHcMI5YgDEbDqSQLqV2MU34+2lM5/9Z4/xfmuaw59S1D2A9fqHrj6Ns5
         wbm7sCz0JPYSsgwKAYCMo/DkBb6m3Tu39n0xHHtkkjB1r0wuTJK5r4J8vvXQGLgJQfw9
         JmFA==
X-Gm-Message-State: AOAM532YWELj46Vy0Qiewo1CqHYJnDGP/A1rfDgZw0KkpfkOqPDRLbaL
        egSQefsODTynnEKZt0F+Ywk6s0SNphxkhwSTFwk=
X-Google-Smtp-Source: ABdhPJySTqv288pmyXRuIhy0Nj0uJGcfD3ayHT7yJIoz/JX5502ujcMxk8/JOM2xMi7poBxmyVkQf5Xmb7kovNwwvso=
X-Received: by 2002:a25:fb09:0:b0:648:a549:db25 with SMTP id
 j9-20020a25fb09000000b00648a549db25mr10492684ybe.164.1651493914239; Mon, 02
 May 2022 05:18:34 -0700 (PDT)
MIME-Version: 1.0
Reply-To: nafi177z@hotmail.com
Sender: haman1zakaraya2015@gmail.com
Received: by 2002:a05:7010:45c5:b0:28b:99ed:bd86 with HTTP; Mon, 2 May 2022
 05:18:33 -0700 (PDT)
From:   Ms Nafisa Zongo <msnafisazongo@gmail.com>
Date:   Mon, 2 May 2022 05:18:33 -0700
X-Google-Sender-Auth: GM43hrllrmd_JacfDGHc8t1WwCM
Message-ID: <CALXn+=XNeAJHWpNsGvd=3c=Fdqa7Sr49gSNc7YbQ_85J_5f9kg@mail.gmail.com>
Subject: RE.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b30 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4989]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [msnafisazongo[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [haman1zakaraya2015[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I seek for your partnership in a transaction business which you will
be communicated in details upon response.

Best regards
Ms. Nafisa.
