Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E59744AB7
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 19:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjGAR0d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 13:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjGAR0c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 13:26:32 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD1E1FF2
        for <kvm@vger.kernel.org>; Sat,  1 Jul 2023 10:26:31 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 98e67ed59e1d1-2633b669f5fso1507004a91.2
        for <kvm@vger.kernel.org>; Sat, 01 Jul 2023 10:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688232390; x=1690824390;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I2GLg82bC4DT4VgdLZZTbXyA5DPKO0f1lWzZlEz65MQ=;
        b=ZZq0gRnEiKTpBsHJilCiRaXAL3eEL03K3uP5FDU2+27uwK/mnE9fw/Ft04JROLL/cj
         HGi1L2qDjrzMwYoWLNWEygr87d+JYGS25gVlrXqqZYYzd8wFxYJ5a3YklWm6RKzgt7wJ
         WwxzqSJFkDXpZyoshxEdI7nBRkdROzl1NAIlirX4HKq2r6e16DnU6XW+tAAo92mHXNv4
         BsYDGvyKSPI8gWeUqkdCST8TAYwDkglYke4z9RB3N2hOSfc72n/cMZgXXsQcEcYYeTjW
         aXolzN9guNu26xrq8UTjImdYybSTPlTdkNqhon1HicJ8FWEOg3KAo7L8tp7Q4pKoeX36
         9J/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688232390; x=1690824390;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I2GLg82bC4DT4VgdLZZTbXyA5DPKO0f1lWzZlEz65MQ=;
        b=fa59FEOQimUQVqQy1uuToH/J7TVHR7VxH8CUp8ZFgXsEbxZvunEzsqjXVWzlaRq3ys
         jO9wXS+hmUJKS+tZlA4WzfMVAA6c9gE9YFPmYBkTSVEF446XW/C54rHW49WonIePnWgL
         jzVfLkT1kcgzo26MeOqB7+5ziT6I0jK42bpbhTP50I/89mjWVfIqLeOoAUpUU/2WshNe
         oNFBDW3hBFKU2x+ZKsKPlOPL/JJR9falB660lUpvR+0LudTFvFzq/hhtnsn1RADjw7e6
         0N5NFaZHzAJBd2lIxizL+pn7273CMnYLKq1WNvWg9ZwRGP54sanulUyptebyXXFGohDz
         LV8A==
X-Gm-Message-State: ABy/qLYlG/DMiGik9lYYm2KG/KQ4vu6OYeBMzyQFB9cwQlSOFvQZHU7J
        QyR+z0I0ustmaC68bCWJJ7zmR745mTI=
X-Google-Smtp-Source: APBJJlHohm7Zwgmvt+LHn3PbVRcXR3RTbq8oGUMZf+ucizlylFLpheNHVFAe+cgMzF+DVD/vs7yJsw==
X-Received: by 2002:a17:90a:1a44:b0:263:abea:94d1 with SMTP id 4-20020a17090a1a4400b00263abea94d1mr819699pjl.44.1688232390169;
        Sat, 01 Jul 2023 10:26:30 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id e22-20020a63e016000000b00528db73ed70sm12433179pgh.3.2023.07.01.10.26.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Jul 2023 10:26:29 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [kvm-unit-tests PATCH] arm64: timer: ignore ISTATUS with disabled
 timer
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20230628-1a712a9e7c4710acaa744f52@orel>
Date:   Sat, 1 Jul 2023 10:26:18 -0700
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <BC525FC4-B2DE-4FA4-B4E4-FF4206F5D59F@gmail.com>
References: <20230615003832.161134-1-namit@vmware.com>
 <20230628-1a712a9e7c4710acaa744f52@orel>
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



> On Jun 28, 2023, at 4:40 AM, Andrew Jones <andrew.jones@linux.dev> wrote:
> 
> On Wed, Jun 14, 2023 at 05:38:32PM -0700, Nadav Amit wrote:
>> From: Nadav Amit <nadav.amit@gmail.com>
>> 
>> According to ARM specifications for the vtimer (CNTV_CTL_EL0): "When the
>> value of the ENABLE bit is 0, the ISTATUS field is UNKNOWN."
>> 
>> Currently the test, however, does check that ISTATUS is cleared when the
>> ENABLE bit is zero. Remove this check as the value is unknown.
> 
> Hmm, does it? timer_pending() is
> 
> /* Check that the timer condition is met. */
> static bool timer_pending(struct timer_info *info)
> {
>        return (info->read_ctl() & ARCH_TIMER_CTL_ENABLE) &&
>                (info->read_ctl() & ARCH_TIMER_CTL_ISTATUS);
> }
> 
> which I would expect to short-circuit when ENABLE is zero.

Yes, my bad. Drop it.

I had a different unrelated interrupt before that turned on the ENABLE.
This just mask an additional failure.

Obviously we can reset the ENABLE before each test, but I presume it is
fair to say that in general if a certain test fails, subsequent failures
are prone to be false-positives.


