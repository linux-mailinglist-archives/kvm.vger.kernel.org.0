Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A225372AA6C
	for <lists+kvm@lfdr.de>; Sat, 10 Jun 2023 10:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbjFJI41 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Jun 2023 04:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjFJI41 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Jun 2023 04:56:27 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17EAE30E3
        for <kvm@vger.kernel.org>; Sat, 10 Jun 2023 01:56:26 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-977e7d6945aso456293766b.2
        for <kvm@vger.kernel.org>; Sat, 10 Jun 2023 01:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686387384; x=1688979384;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N3tQa/xAjjFjMbYTIPvabJVdNLC/DkLFMMTZCH3qWNU=;
        b=cQlndPiIK0m0pjNSgBSXJ1+/WcMjuE95XcGGnxhFnm0Hc8PPUn10fcTj2UFDs+y4g1
         H1j9RU9J9k7JPPWjS5DHsh3yv18MWsZcNz46peQmxqYL3flRyYJ2/jCCbzpURX92w5qr
         gfWzhtAlp/c5dikscq4wlHJFULzV+xVrJayonadWAdfNHomsCa3/tnUQYUOvs3FaLY02
         EzCqzRcSL5GhQ7N6ti3w4n+FficowGCen9om9EK6cbvTCV+VDlOzsSUKvdPzyRceISsS
         F4W5V2QSRjODBOAZOGM0bFROFR4NtY1X4GrpUSuSGBeYaRA8gfjvtF+LyZPpSYBPRAmb
         8n3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686387384; x=1688979384;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N3tQa/xAjjFjMbYTIPvabJVdNLC/DkLFMMTZCH3qWNU=;
        b=MJ4y2nQxVcr/a9UAoXKmW6ZlcmvIvcXHJe/YDmJEpsNRgKFyLetjU2V3fqXRGrAZ5s
         A3biMcodo0SMUi9Nh1e8A4tG4vpPF+SeYMGcaaY5BMZk8xrD5CMAsRf27d7EDloR0Yk4
         RikH7Jdz2Ce4eLPscKiWqKiG58fZSXIKJd2ddYm+lC3ghahphmGoxdMPi3NPQ5J1dyzK
         IBu8EUfuDXHhk6B7QNN79YLYDcoNOEqEQfGMIiY6o7/td70NVd/bYQKIMAgNq8JP/dRc
         GbAOLUD3cW83lzd7vrH8VCDJ72s6J0Kqe4INmWRkc/VJqioktY2WwbJA4mkk1PJSRONR
         NpaA==
X-Gm-Message-State: AC+VfDz1NQLTiXD5esDt4ShVUSpRTRFVpQkO3VfWMGtLJw8uLFV2VWHR
        8Y6RTb01INylB4O4uDkQWYuRUd6dltn/FkfMGsg=
X-Google-Smtp-Source: ACHHUZ4wGEbgfg0EoqBxH6tjVK8JRneQxObW/98Nj58BNx7Rg47yOK/iES0dsf+/ILf+sQY3VhJ4+HuD3e8IbE3o9sQ=
X-Received: by 2002:a17:907:9306:b0:974:1e85:6a69 with SMTP id
 bu6-20020a170907930600b009741e856a69mr4235886ejc.16.1686387384127; Sat, 10
 Jun 2023 01:56:24 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:58cb:b0:977:e99c:c95f with HTTP; Sat, 10 Jun 2023
 01:56:23 -0700 (PDT)
Reply-To: elenatudorie987@gmail.com
From:   Elena Tudorie <tucbart@gmail.com>
Date:   Sat, 10 Jun 2023 08:56:23 +0000
Message-ID: <CAEjtnJh-pXLii0pnXTES2=25VoK4Emo8-9TZrtnWKf-jh95kNA@mail.gmail.com>
Subject: Greetings
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I am Ms Elena Tudorie, I have a important  business  to discuss with you,
Thanks for your time and  Attention.
Regards.
Mrs.Elena Tudorie
