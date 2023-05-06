Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 870B06F92BE
	for <lists+kvm@lfdr.de>; Sat,  6 May 2023 17:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbjEFPaw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 May 2023 11:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbjEFPav (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 May 2023 11:30:51 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9211C22F48
        for <kvm@vger.kernel.org>; Sat,  6 May 2023 08:30:47 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-643b60855c8so759761b3a.2
        for <kvm@vger.kernel.org>; Sat, 06 May 2023 08:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683387047; x=1685979047;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T+qws/wgSoK2YAGo17nQE3TEg574bNd8VBKKzvzwbeA=;
        b=c8foyOZnGf5LVNamXQmht2pksXTzpCOqQSHTZkn+YfpqUnJ2oe5Ctml+jWi0A97wM9
         gLE67J5SdrTcgKPDirbK773m25/4uagM7gJnnvwrYlsktks8Q2+3BCfgb9GlMqfnOCAd
         Sw/2xT2LKWjVsAYEx5CYoMDdfPUeePMT+yymgFv83xMD5z5hN7NXiynYvlwtkfhEQzNC
         xGsRkLEXyApWKM4nI299rVi3LXcGGSE/BGkXyxVzSM+TyyGV+n0jZhH2dLDWliCEOXtO
         N5WsCelV/yWvD8DVm7P2I3phq4UHjBmqO2vhq/P24y6X6P+jS4/obi0dZVSc74f3V2cB
         E65A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683387047; x=1685979047;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T+qws/wgSoK2YAGo17nQE3TEg574bNd8VBKKzvzwbeA=;
        b=FMvJG1OFQyxFpv1yidz/yUuQ5A2LFqsjjld9Qm4bJtPceeHINHZt4ZXro8USS+rNq9
         H30ZOl8++DdNLCVGVpG/orzmN541CrCB1+F0faWsAE70e3W3fxQiuzFihv53L5l3//OC
         QerQDClj6AQLCToFIW3k6HrCysXeDBzUnw4ehsjNsAUcqYCVA7qIauHGI/FM2YCg2Yht
         zavgnUcNg9xxWjuVMuh9Ov9Y3y9NG4Rg/lsgVBmYwPXYeNQkZ68b/55ImUH1regfUhec
         IRGi0u0V0dhrbLcJBg5oAuzFYCcfkaWqOsQ4x1Y7at5Ej80jSq7ppVAzrR8sqhasyKE3
         1gug==
X-Gm-Message-State: AC+VfDxpNommcEQ0GKOQzsycR193uEq1pVoC/ySHToAGh+MZFZ+akAly
        /GxzISqYGneHWxPgC9c/UvHt2XPDX9sbmQublb8=
X-Google-Smtp-Source: ACHHUZ4MwTIIqMXqaXNh9pB3EDtY0VyqWdMPElbk7PKzviVOU4XVnyM9tj6KCM/VzLTUhtj5DaDOBmxvtVtAuJfdT9w=
X-Received: by 2002:a05:6a00:14c8:b0:63d:2d8c:7fd5 with SMTP id
 w8-20020a056a0014c800b0063d2d8c7fd5mr6994533pfu.12.1683387046979; Sat, 06 May
 2023 08:30:46 -0700 (PDT)
MIME-Version: 1.0
References: <1679555884-32544-1-git-send-email-lirongqing@baidu.com>
 <b8facaa4-7dc3-7f2c-e25b-16503c4bfae7@gmail.com> <CANZk6aTqiOtJiriSUtZ3myod5hcbV8fb7NA8O2YmUo5PrFyTYw@mail.gmail.com>
 <ZFVAd+SRpnEkw5tx@google.com> <CANZk6aTQoYn5g2ELucjg16yTjo13xUeprOMfgJtZVY+psxHTCQ@mail.gmail.com>
 <1ae0812e-bc0a-2de5-44f5-9e8b15dd4ce8@gmail.com>
In-Reply-To: <1ae0812e-bc0a-2de5-44f5-9e8b15dd4ce8@gmail.com>
From:   zhuangel570 <zhuangel570@gmail.com>
Date:   Sat, 6 May 2023 23:30:36 +0800
Message-ID: <CANZk6aSRqBK019nJ5KkrettkYBDeGwFgsas2bdOmnC7u6E=h3A@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't create kvm-nx-lpage-re kthread if not itlb_multihit
To:     Robert Hoo <robert.hoo.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>, lirongqing@baidu.com,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, kvm@vger.kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Got it, I like the solution, thanks!

On Sat, May 6, 2023 at 10:59=E2=80=AFPM Robert Hoo <robert.hoo.linux@gmail.=
com> wrote:
>
> On 5/6/2023 3:12 PM, zhuangel570 wrote:
> > The "never" parameter works for environments without ITLB MULTIHIT issu=
e. But
> > for vulnerable environments, should we prohibit users from turning off
> > software mitigations?
> >
> > As for the nx_huge_page_recovery_thread worker thread, this is a soluti=
on to
> > optimize software mitigation, maybe not needed in all cases.
> > For example, on a vulnerable machine, software mitigations need to be e=
nabled,
> > but worker threads may not be needed when the VM determines that huge p=
ages
> > are not in use (not sure).
>
> Then nx_hugepage is totally not needed:)
> >
> > Do you think it is possible to introduce a new parameter to disable wor=
ker
> > threads?
>
> I suggest no. I would perceive this kthread as ingredient of nx_hugepage
> solution.
>
>


--=20
=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=
=80=94=E2=80=94
   zhuangel570
=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=
=80=94=E2=80=94
