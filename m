Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9D667C86E
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 11:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237116AbjAZKV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 05:21:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236534AbjAZKVk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 05:21:40 -0500
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E94AD19
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 02:21:21 -0800 (PST)
Received: by mail-vk1-xa2b.google.com with SMTP id 22so684868vkn.2
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 02:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ddKdS4x8c4ZSI9PbKdla4xMHlbecpUYnHnf7KqPY/v4=;
        b=QTXITi9RdYJJU4tVDT2koYQ99bqfBUb1IdyvbWh6udyPpM557F+1AF5eZtDG+Rhmfb
         zXytod/ujQyiC9ACxXH3Gd0x+3JtRvDhhOzUPucsd/32l04SEYn4W67yqVC0Bt/0eizL
         gHFF20sKTja/4+XCAuXlogZi5PISS6geetImlFze3Gog+rQMa5qXg04rLbsepr7xHGIi
         JbvpM/QHnqYLhPKZELiOMYn75ACckhZt8GUbiEJFWqDOd58OxlENgOeg7QGIJMEG/Sfn
         rBwLvEOEeATF+qFMeIwYQdlBYg8cf3dHf/+nZN++vPHoWyr7C46I0tv7igitN+kj2HkW
         UVbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ddKdS4x8c4ZSI9PbKdla4xMHlbecpUYnHnf7KqPY/v4=;
        b=3H2hz2y4LF3p/yM97qjWuaW9xqVb2g8XPntc0ciaNsbhI1AOjgoU/FjUbTw6+xl3P1
         gs0Tj/XnosCHcE4s9ANYbhm/8veepOFkXgG24jR7S2dSMAOkAMQyS6GbmNXgPoxB9nIX
         SH+pdKrQAMtKJypGe8xgfmVyj7XnZpEzKw8wOzNEvzS2c+u3BVJE+jWFG+8o+S/xh4hI
         uiG9wVSTUdQa5P/ciPbGCGXXXPg6kBDzFdZr6QF6BXdUMlHxs+4QUKqT2j5AarypItW9
         86nw5SQzkrFOBjzX1M3lXroEVJffHqhNcHTSnVxVyxVdADT5wkJZb5BfKL+MCn1trir3
         fNkg==
X-Gm-Message-State: AFqh2kpi+uwAs7jbd0FoJSlUT4r7SPnhf99syh1DOF0CuxznkMlB8G75
        x+WxCBg2Qk6lwl7o3Moy1UVZnZzu/Kt47KmPiCo=
X-Google-Smtp-Source: AMrXdXvNJDEYQrB1rSVhf6CXZmgqx4hcIVAD6CGApssZp4wQRjmbLoIBgS8SIhZWVy3DGHm0FXiiuWMMEzkUXrCrRfg=
X-Received: by 2002:a1f:c403:0:b0:3dd:f6a9:4b73 with SMTP id
 u3-20020a1fc403000000b003ddf6a94b73mr4374224vkf.12.1674728480250; Thu, 26 Jan
 2023 02:21:20 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:612c:15a4:b0:37f:9ad6:a2dc with HTTP; Thu, 26 Jan 2023
 02:21:19 -0800 (PST)
Reply-To: subik7633@gmail.com
From:   Susan Bikram <sb8766198@gmail.com>
Date:   Thu, 26 Jan 2023 02:21:19 -0800
Message-ID: <CALhHHampgvNXF+A18GqJ+7yfFMwvjupEs87Rm7XFQx9gSkZogQ@mail.gmail.com>
Subject: Please can i have your attention
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear ,

Please can I have your attention and possibly help me for humanity's
sake please. I am writing this message with a heavy heart filled with
sorrows and sadness.
Please if you can respond, i have an issue that i will be most
grateful if you could help me deal with it please.

Susan
