Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0221B5875A2
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 04:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235781AbiHBCvI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 22:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbiHBCvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 22:51:06 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261CD17E31
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 19:51:06 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-32269d60830so127738037b3.2
        for <kvm@vger.kernel.org>; Mon, 01 Aug 2022 19:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=IniFjyVHQ6lWflzIsICmJ5JUtVB9MkE1WWkHF07cmBg=;
        b=P9YY8uMybYjbcSn33EGLwaWPGYNqd5+TB4SyBunASL1+iiOyWEl0asr2mbBGvnMkP9
         TuBiThXirS0gGhoCQ1+mCQbens0y0ChElUfCtkPfr4w2i76pfPMZAUdCfHnUZup5Enls
         rbv18IgcddfvKjUSJN2nY8hydQ/J4LWxNADGjXXkB3dUVnUV9WmKHc7WZB9f9DyvntWb
         gZXLmErTUI0VoiQi6FhApbUvdC0sauRw1I+oZJFeQJIdCQam5LWtommWYNUE2ntATwEJ
         EjqPHLV8ZFArGdV78QGjt7psumxS/yc/N9BE1mem0twJZUPvH+ZOBZlQe3p11KXTSJuU
         iv7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=IniFjyVHQ6lWflzIsICmJ5JUtVB9MkE1WWkHF07cmBg=;
        b=WyC6PfVBSQnui3bhGs9NFo37xP++oDZHLMNVPrPn/PZXxcCeG6sjVdt2aiA/1fUEQd
         xRTGEeuBMWGI6H6sN1HEibJiR7Y2zWz0w6YlXu8rGFaTEaztxISz+zxyMqv6TntI784P
         6B89TcBMkreJt2E8QqnEfGf8Q4TqPKgZ60czJskF09UI2oZKdL4uYe0iAUjoaxD7Zm9Z
         3jfYW3T2Xa/M92oKosnIADMgjby0NGiv6dRFzokdB1KyU6e/ZEtyft6lTHnbgbMrInGz
         mN4uL3DeC25UucdZgp4TM53lgfQyBlr5qgHkzEb3xJp0dGuIYJVXhNFhEZAsJwpBwgCG
         fFDg==
X-Gm-Message-State: ACgBeo2lPGaRHqk0gIc4LEMkU8X3IAudAhcsVTpM3Gl5Yk7jX9pw0z2R
        cU2Gk5XZSUrHF48+XzFJBrROffQNnH0ZBzG6ohM=
X-Google-Smtp-Source: AA6agR7KAWziftQFAMaQ3HheLbcgYNFfOD0sPObkGtKtXveI66YrwebL/uX7hatGbi/vtBFCXyQPIP40pNo0Kw2wZfM=
X-Received: by 2002:a81:b142:0:b0:31f:ba7c:5b56 with SMTP id
 p63-20020a81b142000000b0031fba7c5b56mr15943741ywh.390.1659408665364; Mon, 01
 Aug 2022 19:51:05 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6900:ac9:0:0:0:0 with HTTP; Mon, 1 Aug 2022 19:51:05
 -0700 (PDT)
Reply-To: usdepartmenttreasury63@gmail.com
From:   "U.S DEPARTMENT TREASURY" <boiatoaka@gmail.com>
Date:   Tue, 2 Aug 2022 02:51:05 +0000
Message-ID: <CADjH9Kh2tFQddOMrrjOt2mNVFeyN+GTcMRmg+A6NhcswmxLhgg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-- 
Hello,

You have an important message get back to me for more information.

Mr. Marcus Hamlin
Deputy U.S. Department of the Treasury
