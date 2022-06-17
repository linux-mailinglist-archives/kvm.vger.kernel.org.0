Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6E554F8B9
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 15:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382258AbiFQN6Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 09:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382527AbiFQN6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 09:58:13 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D324037028
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 06:58:10 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id e25so2018865wrc.13
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 06:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=pSKuz9BJS/Qwel4yBJUKsJP++c1z8gtIosTtEbMtN5I=;
        b=Nkib7oMmCnLiHqUdMqxjpQ8LJgaJhkMeRRj16nq3osMcqcOENZPc5s7JoYezdOZfbz
         h0J2dODBA8n6UfVVa/V4JgDoGaNBQSBtGuzzeP1wdu0BZLy8jWSvJ58I5guxfpCWT6qT
         /IuDf/a/7Sr5Wklc6XKgv5HS8EW8op1bltj4nlahlUy5/YR4BKq56cNE4OlXucDB+be0
         6IimMnuG+oqsTdHf/9d037m3xAHi1zk/UgzKjVO+oaaNL5MSKTfJBkW1UtPqb61XJ9sN
         V8mV8TABBeJn5FpMqZGoat073qoz2u8v7QCGVJxM14UKfWGWfHGBAc0kDK8VQ0kQ6PEF
         S6Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=pSKuz9BJS/Qwel4yBJUKsJP++c1z8gtIosTtEbMtN5I=;
        b=i1aC5pUiW4te1tCY8o8AQzuXrxTL1HqNEXfOaKhNhaPNgJ/bma/ey4K9y+29qLKbC6
         HSkrGia7KKQfz+hb0YdOdofCfG5zR4vaMGenclmdkNM/Toh1SnTebGyJcsdhejnrnyn2
         mNziF15iSZgUviVz0eLv9yD/ugVAhNEsrToDM0fz7bboqDBXMtloLynFqE0hZX9VUs5i
         WQPPBMWpVE7NiuLvrPzuFkPK4E7wXbhxdSoieMLkduEiHlnOvTGJaIpri49Q8YqutSr7
         3fpEg6DWODI890g35uGCKn6A9525KiLIbh04ComouWRYYAKPhFGx/NvmN7Za8cemnHNZ
         9bjg==
X-Gm-Message-State: AJIora9EwoL5tStrnoJk2h8dYrEVX/HPxFBvMaagb8zsrz5jXCXXIQNM
        fzIC6B4TDEE7C7eQhsIbQMujhjwcfscRk9sj6fQ=
X-Google-Smtp-Source: AGRyM1u8uC3qAnkEb4sE+njImP16K59XFmnqh9kUDK2yYguQ/PMTk9GHp7IAy3yZREgGDKQ7RBcxsjgvZGEowpbRpVg=
X-Received: by 2002:a05:6000:a13:b0:21a:3d94:c7aa with SMTP id
 co19-20020a0560000a1300b0021a3d94c7aamr4197582wrb.12.1655474289242; Fri, 17
 Jun 2022 06:58:09 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6000:156b:0:0:0:0 with HTTP; Fri, 17 Jun 2022 06:58:08
 -0700 (PDT)
Reply-To: davidnelson7702626@gmail.com
From:   dedi mark <dedi788877@gmail.com>
Date:   Fri, 17 Jun 2022 14:58:08 +0100
Message-ID: <CAF3O_y2ck6CkA2t1BAEQCKBEseSEv8RepWL3KQFgLzfvw3oWzg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
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

Hello friend, I want to send money to you to enable me invest in your
country get back to me if you are interested.
