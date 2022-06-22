Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8686554E3F
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 17:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358802AbiFVPDi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 11:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358896AbiFVPDa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 11:03:30 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C5432055
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 08:03:27 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id p3-20020a17090a428300b001ec865eb4a2so11876097pjg.3
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 08:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=vhZEVnaGNBjosB86GDUW8b2wHjB/+QU31bPXl36TqFE=;
        b=WAbWEL/oNK/UOovzR6YlHMKcA4dYcC7HgIpBKVf1Z6aLPQMKNkPnyRzXn5TSaGEloV
         TmQy2vr1kA/RAc7OoDtpJdUyYpSrJCLeb/BH0kegC5/LiVrA2gfzMNL8MrgkT7uFR5NE
         2sg1nSYNUGd9l1GQhQJbVP35/qf8AK++lJaYLJ8ao8KjU6cWvUkd/1yI0D3TJ1rBgo7m
         l3ipwPsxTgsmzX2464N8ISPYKa+8bIVvokuqcL59gXmFQ/gTLHnGfbYSW+RRs9uHt8As
         S504s37Wp7N0Dmac+HWTOQcaHD0jht+wf4g4pro9m1sMDyGhqkY9aD3omKDefUZbLwLo
         sSzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=vhZEVnaGNBjosB86GDUW8b2wHjB/+QU31bPXl36TqFE=;
        b=CGYpBdmjvVT6BJ6eFhgHMW6dHBmOP8oH2DoLPnMweT69AQ8RjKMncRxYMBdOtOGbV0
         Tqm3yvKABBsc8A01ou3KS3gxHL5Ezh39LWeTGogZJBcVuDlHTL0AqAp24lV0Vx4G5JNg
         OBsBrJBy8LJKR1+NSisetOGL6urK2MLEApw86WRXvlR5MmL3YM5e5kASbpB6kLKvaH28
         z08tM1yrFJ91R1Q90pR47WHSnb1GCDWWm1GremKNyN1jDIl02+u6drhkTQS6N6tiY+BI
         ZPkuIfSVQVgns++H1O0lmwLca6DVPpTlhN/gKONkOneg8uVghGBputJ7hBmQWG7M51P2
         ROCQ==
X-Gm-Message-State: AJIora/jqEIzFPWMBn+36RRc0touKJnM8i/2oDqzfVTI049o0PmfeGlf
        Lqg67Ot7NuTsnX5sQvd6pCVpQWqzEowlk2h+iwc=
X-Google-Smtp-Source: AGRyM1tTnjEKy1PAqxhIkhgJsM8EDdvdvX9csFM1KASrFrTyHF6cONT/3ZQhMAHd6iGBjCTq+R/HQPUDHcaDjJjyFps=
X-Received: by 2002:a17:902:d481:b0:167:770b:67c with SMTP id
 c1-20020a170902d48100b00167770b067cmr35105233plg.77.1655910206648; Wed, 22
 Jun 2022 08:03:26 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:903:2308:b0:16a:1b3f:f74b with HTTP; Wed, 22 Jun 2022
 08:03:26 -0700 (PDT)
Reply-To: sales0212@asonmedsystemsinc.com
From:   Prasad Ronni <lerwickfinance7@gmail.com>
Date:   Wed, 22 Jun 2022 16:03:26 +0100
Message-ID: <CAFkto5tMg+6s_ExUe9KSdLUYd-5dxWYs2fCGN8FGJofvS5QvsQ@mail.gmail.com>
Subject: Service Needed.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-- 
Hi,

Are you currently open to work as our executive company representative
on contractual basis working remotely? If yes, we will be happy to
share more details. Looking forward to your response.

Regards,
