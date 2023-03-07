Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7DD6ADBA6
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 11:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjCGKTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 05:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjCGKTc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 05:19:32 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2DF51CB7
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 02:19:30 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id q31-20020a17090a17a200b0023750b69614so11399814pja.5
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 02:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678184370;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2EunEBKVYoEoq69imBRqQomGfF0cWJoxl6o7vJ+JiVg=;
        b=iIt35839w9hi+gjscpzfHl0+EpOmOwZApkQJroIn43m393llrJnFFqrTWorIP15irt
         QNGy89ZqBjd/2BV3L8yr3VxZj/DJPhlCH/GW8JGhQkMA9YlvJ3k1GPLaSJhIEC9b/sAK
         1OrpJiTwZAd8Xa/xXjd1V8JMcC8OLRqdSEFCGQ/aY2o2i/0ld7QuyWwuPqT3i8nmUYr/
         7H9aHxP7JFM9Z420T8cJrN/b4526yia4lB7sLLhc9I6FdvhRK3qgw4ZjSZicuCFd16x9
         +jlpBez4oe7HuB/9sOhhatDtMFudXpVKzimsW1HCUtFVluiLv9gk1wJHfgW/QwtG0RKW
         oaiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678184370;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2EunEBKVYoEoq69imBRqQomGfF0cWJoxl6o7vJ+JiVg=;
        b=far0klJ9SShRTc45uUFyKDw6Cd8LMGW/eH1llJ4/mc5THqIhYcOM0HibYniCtnXU8w
         KreDDbe8paTKinXDhnHZqG3NUup39rQIx9BI6m11X8wYkIGz4CnslOIl6AXboU6zIYdN
         EcmjPkrTgx0LBGPehDQb1wOu7mSHeOjzPZtE54Vtv1Gm5tIJPEz7BOQ88cGKjECxQmaw
         1jWh2NM5l82o8B4irN0dxCFhmzXTlyE71H2D9lNq0YOUbgTOgRhaYtadUbUcZCpCo9Yc
         Ewn7VtB3BJq7qA+kpd+g2CUhmDd8UQVPnsRJEdYsvqyZfAFKBx0RwHZMHUV0AvNEZ9V0
         /hDg==
X-Gm-Message-State: AO0yUKWMd85ZkHYbCLf/k7kHzB2zE6963SQ7NUlScY+Zl7p3GemMrp7n
        388T7JnC4IWilBOT9B/FoeGEDIeojnLphgK6cIY=
X-Google-Smtp-Source: AK7set81b0bhXF5NW4xmCWkeSpVuOV4VLVO7r8Hl1QLGEXmr6Ut6TsV0QZ3PcF9G3pZAweFxEW9eiyS7JFhB/puZNgs=
X-Received: by 2002:a17:90a:8e83:b0:237:1fe0:b151 with SMTP id
 f3-20020a17090a8e8300b002371fe0b151mr4875658pjo.8.1678184370094; Tue, 07 Mar
 2023 02:19:30 -0800 (PST)
MIME-Version: 1.0
Reply-To: vandekujohmaria@outlook.com
Sender: zoungranababa594@gmail.com
Received: by 2002:a05:6a10:82ef:b0:438:12e0:4342 with HTTP; Tue, 7 Mar 2023
 02:19:29 -0800 (PST)
From:   Gerhardus Maria <vandekujohmaria@gmail.com>
Date:   Tue, 7 Mar 2023 10:19:29 +0000
X-Google-Sender-Auth: hOgdOLSsHZt6soA9x6j58N-FHCQ
Message-ID: <CA+powCVH8euiVB4F7nDq_she7EYxo1UjzH6kZsVtd_0a_EQoWQ@mail.gmail.com>
Subject: Good day
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Dear

How are you doing?I'm van der kuil Johannes gerhardus Maria. I am a
lawyer from the Netherlands who reside in Belgium and I am working on
the donation file of my client, Mr. Bartos Pierre Nationality of
Belgium.  I would like to know if you will accept my
client's donation Mr. Bartos Pierre?

Waiting to hear from you soon
