Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756A76E1EC4
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 10:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjDNItv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 04:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjDNItp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 04:49:45 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D678E10DE
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 01:49:44 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id q26so10299924lfe.9
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 01:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681462183; x=1684054183;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EBgMMuS3S+nXOdAGD5zD1EDLkW0bCURYfUeSPB7KubA=;
        b=aL1vc1adQl3W+Dk27Xd5nW+5ersMJ4UtNMYMaDYPkmHDeA3z7MNd6JQVMmNDffh9w1
         EsbLxHHOXOWQg2oym+vEpUQNu8OlpSJ6SXOka043ZSIN6StEgYyry3n8vYLSegv9qO9X
         ik+B6FKk5kWotclN4XrXLSdQgTEG+Zf1ZuR3StxncViHf1/ftpsdr/aeQ8CjJPMQEfjh
         LoFDB6WzlHMXm+ov/P/jpX0i1tOzEkfPGXLdn2m4MUgwdkBD+OI4VGDoDkFJgbvjqsYG
         q7mHeYN9EjwvYNrXJPZSZiTrJkdbLOKLOEKDJbz0J2wgIhS34avPdUOxkJDGFRIjVKI+
         ugdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681462183; x=1684054183;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EBgMMuS3S+nXOdAGD5zD1EDLkW0bCURYfUeSPB7KubA=;
        b=Mioa/FdhmraDAG5SzqOkWJuOBFiV2XeC86CQ2s4VqmJ0Tme/VnY/GEIF4eWZ59hitS
         KAW17vxst8uT43KairV+0feV/HZ+NFg4Suflsd7+2MDVprRHwvX6l5Uzv8zMCKrx6Wlg
         BVxej7hTE/VEBHI9LVqkkUEgO9RKPfMLBZrdlnqyMh5o/Kv8lzgE2PGru3wSRVw5jixO
         Da7PpC7MLCTQlhPsbjGboz3OeVx6Lv/ZhH7/RqxWIOezw8OfDehnUY7AGmNZ6/YFWux5
         0mEfJokrcWhehGULwsb7VV3bkqEFT0tg/AFI0hEKWZ+RoHa7vxxKM3HMkYIBY9Xw0m8g
         sKqA==
X-Gm-Message-State: AAQBX9eeAa5qmrNQngiViCoQk5cP6l1YyIwgIymzRyA3ejah2ibtJ3Dr
        IheKoEhPfInmLFAqqbVzMW9jnBaEIgrJmnHnA3w=
X-Google-Smtp-Source: AKy350YddzyOVR3Wn7HJSubZUSA+B7DdLa+4yFF5kaUlBcfMt9K9eOSWM2sRx3IihGCAB0YugDMWFkVmQ8Qrd0w0ouo=
X-Received: by 2002:a19:5e4c:0:b0:4dc:7e56:9839 with SMTP id
 z12-20020a195e4c000000b004dc7e569839mr4542010lfi.5.1681462183136; Fri, 14 Apr
 2023 01:49:43 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a2e:6a03:0:b0:2a7:9cf6:c181 with HTTP; Fri, 14 Apr 2023
 01:49:42 -0700 (PDT)
Reply-To: mrskumarprince@gmail.com
From:   Aisha Gaddafi <koolboy5528@gmail.com>
Date:   Fri, 14 Apr 2023 08:49:42 +0000
Message-ID: <CA+hg5UOeP-P4X-Yg4MywUkjSnAvjipB-ZH5EyV=PmEJRwNWBRQ@mail.gmail.com>
Subject: Greetings
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I am Ms, Aiisha,,I am currently residing in
one of the African Countries, unfortunately as a refugee..I need your
assistance please.

Best Regard
Mrs.Aisha
