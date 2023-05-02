Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7F16F3D36
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 08:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbjEBGNJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 02:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjEBGNI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 02:13:08 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4314E30F9
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 23:13:07 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-3ef34e948b1so15437941cf.2
        for <kvm@vger.kernel.org>; Mon, 01 May 2023 23:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683007986; x=1685599986;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aVfDmSLkW7PXuk8pNqiEn7Rzbbp46Zoq1QOmeNAa4aQ=;
        b=QzejqXawmyw/SkBTc664qSYrcLi+QAhtGtM7tFx0xzK5RsTUM0bDGdIc3d+XbNhzWr
         1ES3Rw34az//E16jXzlgHGlwXkZtt/TuQKBSipNkdXujtAElK0QCFP89Zs45hlmwqnn7
         3Z8b/b+a3Suoy+80D4ypWu3GOJeijfRgpfINwS+/v63PmJPW2EZERX5AUR7TrxOoibH6
         YMDfEnImpSEIbSIfUrueFm6j2vLey4cCpdf7WKH7WvbZIshiw7MClGImEw/RGfvDNiqY
         MyYacmfFhXn1PTgKOpJvy13Jvc1nvMSOlLO4xCqZwPgOowPckuZLiXjpYeZrO74zaszC
         fSqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683007986; x=1685599986;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aVfDmSLkW7PXuk8pNqiEn7Rzbbp46Zoq1QOmeNAa4aQ=;
        b=GgBsn9v92IQ7BpDFBAbKsto1WPAvidy+TD765AN/eeSIyWCHdVTbb1Y8U5Oi3V161n
         i2tWP5T5AAOOZsVEafL02ls9h6ozwvVv17NplTQGzphD4JAMHxDvvHrKEdKB9vM8yprI
         1Adl81yJ8twpQCQe14pG64k1DLVXoeZJ1ikx5Ylgwj6p3ylhs+scTWXGujNa/Tz+WRvK
         la3vx4UF4XCfjPddh5TTft2fEpwpsFopOoKRiIXeVlAqq3vb8xeiTX//pLg16a8okytA
         oNvT3XH11DZi64Zpk8xQy+we2vgkNTtnEurBTKiklu2XHYEYv2/TEBZ0FXAkagTLfeBW
         +wLA==
X-Gm-Message-State: AC+VfDyceZb6aflN+fpm5Ev1ETXrdAiT8jixnYfd9YjEFbh22CVRxIyv
        5S3uPPtBJXejb0IQxCWcZ0oEN5C1S5OyLNym7ms=
X-Google-Smtp-Source: ACHHUZ7EZICNBCuk2hGwOqAqnXB/4bFUaRtNyH6798gbGwQ+y/Z+JAtUFDYKbt8a9GatHWJ768TsNY6TRjPGMTNIQ1k=
X-Received: by 2002:ac8:7d44:0:b0:3ef:2f9a:c3cc with SMTP id
 h4-20020ac87d44000000b003ef2f9ac3ccmr24543772qtb.1.1683007986382; Mon, 01 May
 2023 23:13:06 -0700 (PDT)
MIME-Version: 1.0
References: <CANZk6aSv5ta3emitOfWKxaB-JvURBVu-sXqFnCz9PKXhqjbV9w@mail.gmail.com>
 <a9f97d08-8a2f-668b-201a-87c152b3d6e0@gmail.com> <ZE/R1/hvbuWmD8mw@google.com>
 <665d7fc9-5245-b63c-af6a-aae6ba9aabce@gmail.com> <CALMp9eQRd+22_Pkv2FkPPdmKuH5TxJcG_q5eaTA_rQgeQn2Xyg@mail.gmail.com>
In-Reply-To: <CALMp9eQRd+22_Pkv2FkPPdmKuH5TxJcG_q5eaTA_rQgeQn2Xyg@mail.gmail.com>
From:   Robert Hoo <robert.hoo.linux@gmail.com>
Date:   Tue, 2 May 2023 14:12:54 +0800
Message-ID: <CA+wubQCYYMo7rfbdwnjqJFAMTONKT45BUgHzY1bR3jvH1=Xq-A@mail.gmail.com>
Subject: Re: Latency issues inside KVM.
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        zhuangel570 <zhuangel570@gmail.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> =E4=BA=8E2023=E5=B9=B45=E6=9C=882=E6=97=
=A5=E5=91=A8=E4=BA=8C 11:17=E5=86=99=E9=81=93=EF=BC=9A
>
> Hobbyists drive the rationale for what kvm supports, not CSPs.

Got it, thanks.
