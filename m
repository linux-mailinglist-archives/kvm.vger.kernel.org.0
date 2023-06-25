Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8E473D347
	for <lists+kvm@lfdr.de>; Sun, 25 Jun 2023 21:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjFYTWb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 15:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjFYTW3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 15:22:29 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7CAB7
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 12:22:28 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1b53e1cd0ffso11561945ad.0
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 12:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687720948; x=1690312948;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T23wHrD6vv0yTBZS/6TP5/IeWklyAPQCYvo/tKPMvz8=;
        b=R+suup7aKAuk1Sdcl69iCPuytMTS4fc5strgidUDEWZebhsw6evA7tXzP/2h7rScR9
         /Q62d4HayRO83gB+XqsZ+WX2siypsGa6v+G7MdzhjPibILSoax/ELpnlSrchUpHdnC+c
         AXspjhsuw7yk7sUTToymf+QA+ULzaaZldyYRQNKCBx6srQCdhbgFqf1LrfVY55Hmamzk
         edMm+m8YcTvumDXwtJ7DeJrPOmEubcdd19MtWC3p2MUNO/Xft/Is+0WWr+7IbI+IaJ1x
         RkGs2NALCEqkJfpB9WsLx/qEEFVjQTGcZu8sAthTSt3mcQAXzYE5GYsPZgxmSx29wW+O
         BOFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687720948; x=1690312948;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T23wHrD6vv0yTBZS/6TP5/IeWklyAPQCYvo/tKPMvz8=;
        b=BfRnBL1GuYQhJvHnNPUqk0jQZJwm0NqO1pVT3ksYTliZVv6CJ7rYFu6vTTzSsXWMXR
         eoE5XCM5a7lkBjqMdGQ0HusvO7E8oU5HiZjIXqxD626WszM12AyxTLGkiPz7qVg/2rD6
         xOxkpAq7ma5P8Cpsed6q/EkWbK2fYm0IMh8CQUV2UMc3CvCk7Qu9Lr2HJZ1npnOX8nPc
         fUch/Uyp5SqrsDhjkw+M7Z+qJcCyBBmfxUnamLQ+DkjV5nsdbEweSTVZr4fWyuK3WEmA
         XXR8Ldv3jMoD1h9f9QSxK6PNoXQZwxVVP1VNmEy8+ux9Fgat6p8qio/3nw9EqEWhzQTy
         4xqA==
X-Gm-Message-State: AC+VfDzbMrZeY070IWaD0X+tJJF2hMb2TFlB4OowOlo9UJ/RMEgIsgEk
        aXq8M4NyaqAqDdBaGLjdYbqR2Ospm8o=
X-Google-Smtp-Source: ACHHUZ7o5CnXU0LWpABDecVTJF5gdRiruxvkNBe2aSrqBTlpM2weAfpO0PHMhj30xNGAgbnnz+LB/A==
X-Received: by 2002:a17:903:18b:b0:1b5:2c0b:22d3 with SMTP id z11-20020a170903018b00b001b52c0b22d3mr3715872plg.14.1687720947675;
        Sun, 25 Jun 2023 12:22:27 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id k13-20020a170902ba8d00b001b69303db54sm2766440pls.91.2023.06.25.12.22.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Jun 2023 12:22:27 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [kvm-unit-tests PATCH 3/6] arm64: enable frame pointer and
 support stack unwinding
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20230623-622ec2c26e09f951f42cce46@orel>
Date:   Sun, 25 Jun 2023 12:22:15 -0700
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Nikos Nikoleris <nikos.nikoleris@arm.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7BD2B564-E0E0-4589-8FB1-E82D5D697D13@gmail.com>
References: <20230617014930.2070-1-namit@vmware.com>
 <20230617014930.2070-4-namit@vmware.com>
 <20230623-622ec2c26e09f951f42cce46@orel>
To:     Andrew Jones <andrew.jones@linux.dev>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jun 24, 2023, at 3:13 AM, Andrew Jones <andrew.jones@linux.dev> =
wrote:
>=20
>> +extern char vector_stub_start, vector_stub_end;
>=20
> These aren't used until the next patch.
>=20
>> +
>> +int backtrace_frame(const void *frame, const void **return_addrs, =
int max_depth) {
>=20
> '{' should be on its own line. I usually try to run the kernel's
> checkpatch since we use the same style (except we're even more =
forgiving
> for long lines).

I usually do use checkpatch. I guess I got sloppy. I will fix these 2 =
issues.

BTW: I used the get_maintainer script to get who to send the patches to =
and it
included the depreciated kvmarm@lists.cs.columbia.edu =
<mailto:kvmarm@lists.cs.columbia.edu> .. Ugh.

