Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61AD2741600
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 18:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbjF1QEE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 12:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232109AbjF1QEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 12:04:01 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3A52688
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 09:04:00 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 46e09a7af769-6b5ef64bca6so5505545a34.3
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 09:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687968239; x=1690560239;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PK8CSnpK/Lj4WgPXCAFjMD2+8ZPe0cG8Mxg2WoY+zJk=;
        b=TtgeK2UY9RNl0ZdNQ73vc3mgQaljR183sYaZIlj6wHimVQW9/E3G+aCCWh9XDHXsNF
         sRcVtITLJ3Q6yS0sZvcdBWs4YlVNb2FsMdOBnLYAI3JrGXJN/WHxk1rqH1/HKCLd48SS
         d6eUWoTd4fCdh5ejbIfPFz9wKAT1491Cg9hRw373HixO5ESffD6tqFxpmVAQovwE7N3W
         was92K6mfOXUxEhApbYVah+pMSR2kCnGFpOOrtrKGtpls8jzNZlmI0unyth0yUvUYhXi
         ou8AQ9uyPz5N9Kj9mV8wwo/swbVCJWiOhJh9dHqSAS/mUotryvubet2iTV26mLg19yHv
         49EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687968239; x=1690560239;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PK8CSnpK/Lj4WgPXCAFjMD2+8ZPe0cG8Mxg2WoY+zJk=;
        b=KxYKIxVaW3wF/VASsL4/qAxLXVwkSEbfzzS/M9KeHvUgrVoX1PUpdA1I80ymzyeACn
         xVT9u8MQ7SeH0nzInweoEYJBK1RPEKFQ9rhWCixKHs3K5DhzcIdjPW/vBafNw1PZOxr8
         k0XB+wSJAJ0rmmm9GeJvmRfCg/Jnz2S9Nyy1BvosFrc/lmseMOTmGS/Ioi5Vb3LftKyW
         6qkxcbPuCww1B8S0oJharhjv+PWtRJGOHeFDqbTUFEF2C5ZVZ7oPp+dsNgVTglcYYp6K
         wK/AQO0auLPpBqe9pYeNNv5OynJm0gd0bGEepjRyKPSFhuJcREb/hD/Dx/C90s3lEils
         1UWA==
X-Gm-Message-State: AC+VfDwkCX4viS59VrmamNXxytXLlHssFOFZ9cbf7FqZO/+IkbS+z7z/
        l1VN3Cx5wf4KgbhEvZnyhbq5UbMg9xU03BdzYps=
X-Google-Smtp-Source: ACHHUZ6ZrC/u6qVZUNEXrfNYJPtcJceQRJ3I24jT84FgihySyfSIxq7GrWpB6vcD9dt5KNR1lexgIEJ4ESOtSXxCkZY=
X-Received: by 2002:a05:6870:7384:b0:1b0:6f63:736f with SMTP id
 z4-20020a056870738400b001b06f63736fmr3316631oam.9.1687968237668; Wed, 28 Jun
 2023 09:03:57 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:2d02:b0:767:7ce5:ccbf with HTTP; Wed, 28 Jun 2023
 09:03:57 -0700 (PDT)
Reply-To: infoconsul03@gmail.com
From:   David Mensah <haydenannah264@gmail.com>
Date:   Wed, 28 Jun 2023 09:03:57 -0700
Message-ID: <CAP3XA4pGDLQT=LsU56CauqoC0Fj=Pe9xtF=oYYK7FvuH+xXLUw@mail.gmail.com>
Subject: RES
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-- 
Hello my friend, did you receive my mail?
