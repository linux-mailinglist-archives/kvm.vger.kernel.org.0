Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32CD2670CC6
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 00:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjAQXIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 18:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjAQXGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 18:06:39 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09F617143
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 13:36:58 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id ss4so71307321ejb.11
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 13:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Cqbeh/9MCyCPOTYxG0AiMgS5KE1anwm0yCSabyxdpvg=;
        b=kqwJoL3cCVOrjf06IzMzAUNkSdKY9dfbnKS7MvZA9isnp5PLadTX8UbmlpH2A8rsv2
         1XjzxCuoec1cNiZG6baCCNTD8qLv52nhMHf0qS63T+CjV3vXji20Nul3v0mT95VabSCt
         bf4u3XajIEj2iG9YwGmSbkGVjfbH4raQljq27K1+49H1agUMaJUQ2ncQfJKmE+bARyU8
         DRgZvgbmSFSvFTb8gaagGlRB7CNXz2jMfI3DlOc0VgYR2u+z7S47AB7vIVimv1CpmIjn
         VUKmTof8acaChtrnPP6Zw659hSwYfUitvo4TGZxagcxzGGTS+dDOjArkCkWDNnn1KRSy
         W42A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cqbeh/9MCyCPOTYxG0AiMgS5KE1anwm0yCSabyxdpvg=;
        b=GIaY/Bfvt8Eue5V4rCL9arYSLm+G+cD+ySyQFZJysKGGN5M4BURFlKpm3ea7wcvjJi
         4LI0SXj7TeTOs0217vdFebmWF68clS8/SJnwbR9TSzGDghR4dxOzdXxI2KshAeNczahc
         cE2j6ypMuF/cromL2wfJbTE8aLDb6R67WKTPx5Mj5rr4+SOB0r435qzd86wnkHp6ru5b
         wlSBZkOn7zWuS7rPQ0YchZjhXsQP18wMU3lPVfq5SnX3OXdfq6zTe//R0Vqzr7UzjRtV
         376SyEoMvAkHpcMb4iKmDEWr50i1CNhezMpK1qNElzICa4aTYhCqFv157CLmMfAiVE9L
         Yj4w==
X-Gm-Message-State: AFqh2koPzBZOj9FJ7M3OmTL/T61bYre2XZwjuJNc9SOD4ppv6vm4rzg9
        qKdaUWetq4UB1w/vs+jqgSAfvyEQBqC7NwCNLcI=
X-Google-Smtp-Source: AMrXdXvXVplqNaFChFboDIV2skA5TB17BSfvkM8yIDQCkt6CGj/7c4v9i+0/NTIs0HKYTmqWViCFmWofPmxq3vR6Hf8=
X-Received: by 2002:a17:906:65cf:b0:84d:2f31:ea04 with SMTP id
 z15-20020a17090665cf00b0084d2f31ea04mr378847ejn.480.1673991353009; Tue, 17
 Jan 2023 13:35:53 -0800 (PST)
MIME-Version: 1.0
From:   Mark Lee <bestdatalist0@gmail.com>
Date:   Wed, 18 Jan 2023 03:05:41 +0530
Message-ID: <CA+p-npv1V=-=a8zTjJMC+JigEEkRZCq9sxCCWWpHG0VtdBKjcA@mail.gmail.com>
Subject: RE: Global Conference Registration Attendees List- 2023
To:     Mark Lee <bestdatalist0@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_FILL_THIS_FORM_SHORT autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I hope you're doing great and staying healthy!

Would you be interested in acquiring HIMSS Global Conference Attendees
Data List-2023?

List Includes: Company Name, First Name, Last Name, Full Name,
ContactJob Title, Verified Email Address, Website URL, Mailing
address, Phone number, Industry and many more=E2=80=A6

Number of Contacts: 40,526
Cost: $ 1,856

if you=E2=80=99re interested please let me know I will assist you with furt=
her details.

Kind Regards,
Mark Lee
Marketing Coordinator
