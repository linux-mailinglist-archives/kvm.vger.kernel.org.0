Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B353AD396
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 22:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbhFRU2d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 16:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbhFRU23 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 16:28:29 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831A9C061574
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 13:26:18 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id k21-20020a4a2a150000b029024955603642so2753820oof.8
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 13:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kWL2l33mYtauMaQE1s/trtXMtvBBw4+h9fOrmAMfFaY=;
        b=JRWCA/g6sDKrl6Uk59y4B5PmnBBC8gtegunfjfVYoiLYc4jY/xuRPHSZ5E976sfdx5
         dnaLSUUj/W01yikBxtzpPzCNI8LGgvIwJV/bCC2/oicor519Q/stCa6/tOp4IBEZTa2F
         FITHIbJQPHwhjaQtYXtY3gSZDeQNS3tlCuAXkV4S8F6lre2gAVxNgy9M59Fcae2HIl1v
         8WxYR2vyADkMT6PliHUv1pvMOOMwVk54feowKPyBhZjdqAOIlHWJONkjjiE8gVRtGOyb
         BiIpjINgZVZvpXaCD8x2EIIp/btonYCNYdHzZsER68imlHYeZ/Wes1QeOSxsHr+qnSe5
         uStA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kWL2l33mYtauMaQE1s/trtXMtvBBw4+h9fOrmAMfFaY=;
        b=LVuJKjTQcdcg8KgE83TvwEC3Wab1Wf3Ec3EyXNw8thufy/sLOb969XM6W4bGl6Ys12
         nSgzDrs0p3tg7ETE6k4goaDRZUBwU3H3kckt3cflI4D1xUihVXvku2VhNDnh0LS/iAbk
         FgpHdIRNrKsga28H92kJp2EZ+HtcDDL9uV3l/0iSE55b0XdiKGbcEpOMitKSokezH4Wa
         TT5sjVDxcSv3nXGqYyXvWb7nJaWIV5l3CwY91hHtJhWEGM+tjvkRjvJh/HV8MufRZCsr
         UizAjP13ZI1w1sbegkCeryuNKuo7ThzDBjowg8NUdX0vLt/iOpdm13y7psxD+IXD4e4f
         02BQ==
X-Gm-Message-State: AOAM531ZB5AEwYRy13teUMR9coq9fWrg6CQxNF5LY3RMKW5TG0cD2oja
        0H5v3X/r7GvL4X1JW+2gy1staw3b1xzQr//YljZ1OA==
X-Google-Smtp-Source: ABdhPJxv/fld1v4qiAfK9zVyWx77HVWUazBt2xHLNoxo4Ax7bx1t+RHD+j9DBhPVRtZH+kaQSb6sFufgGldQLJRjLUA=
X-Received: by 2002:a4a:4585:: with SMTP id y127mr10534873ooa.82.1624047977644;
 Fri, 18 Jun 2021 13:26:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210618113118.70621-1-laramglazier@gmail.com>
 <ca3ca9a0-f6be-be85-b2a1-5f80dd9dd693@oracle.com> <CANX1H+3LC1FrGaJ+eo-FQnjHr8-VYAQJVW0j5H33x-hBAemGDA@mail.gmail.com>
In-Reply-To: <CANX1H+3LC1FrGaJ+eo-FQnjHr8-VYAQJVW0j5H33x-hBAemGDA@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 18 Jun 2021 13:26:03 -0700
Message-ID: <CALMp9eT+2kCSGb5=N5cc=OeH1uPFuxDtpjLn=av5DA3oTxqm9g@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests] svm: Updated cr4 in test_efer to fix
 report msg
To:     Lara Lazier <laramglazier@gmail.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 18, 2021 at 12:59 PM Lara Lazier <laramglazier@gmail.com> wrote:

> My understanding is as follows:
> The "first" test should succeed with an SVM_EXIT_ERR when EFER.LME and
> CR0.PG are both
> non-zero and CR0.PE is zero (so I believe we do not really care
> whether CR4.PAE is set or not though
> I might be overlooking something here).

You are overlooking the fact that the test will fail if CR4.PAE is
clear. If CR4.PAE is 0 *and* CR0.PE is 0, then you can't be sure which
one triggered the failure.
