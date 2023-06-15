Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED03730C89
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 03:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjFOBSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 21:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjFOBSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 21:18:31 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829D12110
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 18:18:30 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-54f75f85a17so2743839a12.0
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 18:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686791910; x=1689383910;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=V9mSiopEuy5P4cG9C30eUWIPBBZ464c2m9S80vSfcxc=;
        b=iIzq6A5FT1MvvIis4ayxqhkFavNLQHIcTCdQQROArj90mgZJ3sGz01YsKdFQMVfbaX
         riqjuEbisU+QxJnXXsRoZlAuB+A0bEOonu4HOlq9Zh/G1bKwo0FVp/REPjWUgs5eUYDx
         oYCSRbYS9PE8XVFSurqP3x5bu5cyIsCZfVJi/KcatWJRcnXChw3IQ+K2kaMVDKFxSosv
         e2+AhbM9jKyHRGFnPw0mmE9i23aZi+evY4uxFf9Ix2NH6hyJlsxw73zI+8YYR5Ch/CcW
         y/rBZyOtBCn4SlIov267uLKZbyqX6fSWHUWyU9PQw55KFfiKJvun/lx5ZIuwCp06RVm/
         fygA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686791910; x=1689383910;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V9mSiopEuy5P4cG9C30eUWIPBBZ464c2m9S80vSfcxc=;
        b=klZEwLv1MeQBipBeXhpVmyuxIrtpl13UBeUdnJZ3ugwmyBJtJtuXhGAk6DbtsvfSS2
         3oGeqfmhLbtDzjdsreJQed6W+qAwmQbF9C8KGxIH8TjFWiMcwanpwqoGFT8PFBrxUJVd
         JMaMdAShxoTchdMl0+jnziWrcqVgAhXaxu2gusLgqTCL7A3FE68HjE2KIo7pDBPlbSSM
         80kaY7GyG0wWjaGhvBd2TZLIb3efU7/fEkwWtSCtuCpyn80QZ2gbQoIWrjE3Nx3ZzHLE
         Yf+2HA3yXz8rx8eq46lrV0yYngjPm7RqdhlHIeYDN7SlmOUvD8+kPldZ+Ur+Ws4ppZtb
         t5ag==
X-Gm-Message-State: AC+VfDwY7FR1abbz+YHdEzLa5oUy/1xdAdqSQ/mWxW4/3YZU+hfLPAJP
        Bks1TQtDZ0qlhSZ8qeNMsHuYKUPtRxhXmNMYX/weaqTEf0k=
X-Google-Smtp-Source: ACHHUZ7zfNDYntbwHN/v2z4x7VCoAlBUQH3aaDC+2OY1Tx0pQcz/+D/gNdi2hTQG6o1O9vfyM/sLhSm9QDQ8BvooXS8=
X-Received: by 2002:a17:902:dacc:b0:1af:c602:cd52 with SMTP id
 q12-20020a170902dacc00b001afc602cd52mr14587110plx.67.1686791909653; Wed, 14
 Jun 2023 18:18:29 -0700 (PDT)
MIME-Version: 1.0
From:   Kenneth Kienle <deadmagpiesoftware@gmail.com>
Date:   Wed, 14 Jun 2023 20:18:17 -0500
Message-ID: <CAANz26uUqT2--ubVPffWTq2UpSvEySRkdmXq=CBZ-kBB0k-qnQ@mail.gmail.com>
Subject: Expired HTTPS certificate for www.linux-kvm.org
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Good day,

I am writing to inform whoever might be concerned that the HTTPS
certificate for www.linux-kvm.org is expired as of Tue, 13 Jun 2023
12:48:01 GMT.

Thank you for your time,


Mr. Kenneth C. Kienle
