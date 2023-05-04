Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C1E6F6CF6
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 15:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbjEDNcc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 09:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbjEDNcb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 09:32:31 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D24729B
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 06:32:30 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-24e25e2808fso520962a91.0
        for <kvm@vger.kernel.org>; Thu, 04 May 2023 06:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683207149; x=1685799149;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u5na5uTHgVhtD3JDtgMKai5jrLZrG2qiV+YhUkRGSUM=;
        b=c36O361sGMdjsaCOwiL6Ap+xAYa0jXVhp4sNJ8gimrkGEsmNEpTEYVSxga2ZBJKRxg
         g7hTlWfOpRPrW/PaM93sJQ4FrGsDIAicDEaIfdszoAJ/K60UMq/R4rTI9xYnlf/Z1wvT
         GeICgcGE2AyX6SccaiuM5Bf6Q/kBaI0931bhpvJowD21SBCxrhPXy+Zmc7tUNJ7cHMb2
         H/jVE9sDWsOABJXVzFc1pHYUzKgk1UiRzPkQLaVCAiOi/L9Z2PNvOX9O0AvOGI6IDtEg
         765a5EoYWvyYCSF04s+R6ZLxr21l6quJ7TQh1GbNyl7Y4OzsLhEMl63Bibn1NDAMUMBX
         YtLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683207149; x=1685799149;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u5na5uTHgVhtD3JDtgMKai5jrLZrG2qiV+YhUkRGSUM=;
        b=bfwLKv+SesB8gE1W/5Rrdw9H98xVa/2oyszqvFIkZ/c6xjR0TWcNgElbx9vBpDh3cB
         Xi8LjxzubncPkIGcPvfegCutb+9KAkoUdlvTzyrb9D8QitfljXMgzVQoLO+z3m5jh4zQ
         /JFJfDOEMAEc5yPpV18WS5ikE1nIuyaQw31ofzWeO/X3s7KkS35Sik3wFB1P5jR7ytl0
         aODq4yQTP2fJ4rpJMKpbH6hgXOPHcJRiSHjr/hfFam/8jo9SvuO2g4F94eqzDO66XACg
         ArdLyEM51p+oR5qECgC6bx7h4ELvmMU2BjkO9LTWv7Xw4E0vwW6UisrtVPWwb5/PDPtv
         sZSw==
X-Gm-Message-State: AC+VfDysc0hNgwJwSd04vFIkhvK92mU5biGnbjVgwiFj79qioe3AnkMt
        Zri1lxG1K17FOW0bKU6oyROf6Mm3o6FVqktJ9BC1Cxgf8J0I4A==
X-Google-Smtp-Source: ACHHUZ7usGl0PsuLi/4yhuIGPnj4s+bJ3cCyIteCfrg2YgCao/CwXavjWkMPM4IUm21+4NCYYRJGhn/gtlj+mApYbMA=
X-Received: by 2002:a17:90b:310f:b0:247:3374:bb34 with SMTP id
 gc15-20020a17090b310f00b002473374bb34mr2252957pjb.11.1683207149414; Thu, 04
 May 2023 06:32:29 -0700 (PDT)
MIME-Version: 1.0
References: <CANZk6aSv5ta3emitOfWKxaB-JvURBVu-sXqFnCz9PKXhqjbV9w@mail.gmail.com>
 <a9f97d08-8a2f-668b-201a-87c152b3d6e0@gmail.com>
In-Reply-To: <a9f97d08-8a2f-668b-201a-87c152b3d6e0@gmail.com>
From:   zhuangel570 <zhuangel570@gmail.com>
Date:   Thu, 4 May 2023 21:32:18 +0800
Message-ID: <CANZk6aS=iaQNdMZRMXVerRy2-f2Egit4geYE4ugAFZQMT=yZvg@mail.gmail.com>
Subject: Re: Latency issues inside KVM.
To:     Robert Hoo <robert.hoo.linux@gmail.com>
Cc:     kvm@vger.kernel.org
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

Thanks, Robert, for the information about hardware mitigation, I looked up =
more
information about ITLB Multihit issue, seems the issue not exist after
Kaby Lake.

As you said, maybe we should skip start the kthread where an SW mitigation =
is
not needed, such as hardware mitigation is available.

On Sat, Apr 29, 2023 at 11:28=E2=80=AFAM Robert Hoo <robert.hoo.linux@gmail=
.com> wrote:
>
> On 4/27/2023 8:38 PM, zhuangel570 wrote:
> > Hi
> >
> > We found some latency issue in high-density and high-concurrency scenar=
ios, we
> > are using cloud hypervisor as vmm for lightweight VM, using VIRTIO net =
and
> > block for VM. In our test, we got about 50ms to 100ms+ latency in creat=
ing VM
> > and register irqfd, after trace with funclatency (a tool of bcc-tools,
> > https://github.com/iovisor/bcc), we found the latency introduced by fol=
lowing
> > functions:
> >
> > - irq_bypass_register_consumer introduce more than 60ms per VM.
> >    This function was called when registering irqfd, the function will r=
egister
> >    irqfd as consumer to irqbypass, wait for connecting from irqbypass p=
roducers,
> >    like VFIO or VDPA. In our test, one irqfd register will get about 4m=
s
> >    latency, and 5 devices with total 16 irqfd will introduce more than =
60ms
> >    latency.
> >
> > - kvm_vm_create_worker_thread introduce tail latency more than 100ms.
> >    This function was called when create "kvm-nx-lpage-recovery" kthread=
 when
> >    create a new VM, this patch was introduced to recovery large page to=
 relief
> >    performance loss caused by software mitigation of ITLB_MULTIHIT, see
> >    b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation") and 1aa9b9572b10
> >    ("kvm: x86: mmu: Recovery of shattered NX large pages").
> >
> Yes, this kthread is for NX-HugePage feature and NX-HugePage in turn is t=
o
> SW mitigate itlb-multihit issue.
> However, HW level mitigation has been available for quite a while, you ca=
n
> check "/sys/devices/system/cpu/vulnerabilities/itlb_multihit" for your
> system's mitigation status.
> I believe most recent Intel CPUs have this HW mitigated (check
> MSR_ARCH_CAPABILITIES::IF_PSCHANGE_MC_NO), let alone non-Intel CPUs.
> But, the kvm_vm_create_worker_thread is still created anyway, nonsense I
> think. I previously had a internal patch getting rid of it but didn't get=
 a
> chance to send out.
>
> As more and more old CPUs retires, I think NX-HugePage code will become
> more and more minority code path/situation, and be refactored out
> eventually one day.



--=20
=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=
=80=94=E2=80=94
   zhuangel570
=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=
=80=94=E2=80=94
