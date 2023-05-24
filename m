Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0377470FF6C
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 22:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234077AbjEXUsH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 16:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjEXUsG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 16:48:06 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCC112B
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 13:48:05 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id e9e14a558f8ab-33a8f766b64so13345ab.1
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 13:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684961285; x=1687553285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aHURiBNG6Ag4wh5lMaHsjiW4JgSyhJ4YVI31OjuzIzw=;
        b=HQXqhO6+GP2Pxk0RilUgixYa2XS/BzMXgWrI0lbbj5IAj4Qz8T2kbmp1m75S9NG6Xi
         c94SQu6yXfMCyglJIySfV77gnFr5WkY871EHAdMeN36FE9ef79cUkKyBqUJYQCjtQ2Lm
         pE3HTzOBEA+f7sa6z1awlw/EnvuYUQ9/F2KDtDUYtIoKIv7/3b3ZACraoPkT2/jm5rVd
         VGJjd7h6ZtimXWCrP76hftOEDz2HvdWJ8spyXm4pn8C4dN2x/pzg8OVCjXpazzH8fxmP
         p/eHmlmHsYIVPerSMKuOJMvfHInGdDyRnl8Jbh/gzfkaQ13p31Z+9oNCqg+6aO9Vd2CE
         bdEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684961285; x=1687553285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aHURiBNG6Ag4wh5lMaHsjiW4JgSyhJ4YVI31OjuzIzw=;
        b=aIsuey+S3gUGYCCgyHxApmnuwf5JA9Vc4iLVVOznvGm0f4ojVylNmaxhd0NhGtYqH6
         JerIDjopPUqHnrYF5MkJztIp5AlDe6BHodrPt1y7mMZ7ZYWCh82JhmdwUZNU8ai7H+VO
         n8Y6R20hANZ3TMlhkmwT+kPJUDeGRVG+gxZwRJY7lhm9Z4KtBVaH9z57y7AoOVb5m1O+
         Ld18fWooPAYsqFAFqZSAs+BqYG5+A2I/NlKnqdjt5SVgsQzBxFIfyzo/AdLkFsGH80gl
         s1D4RAgpfnLiVjxH0TYeiGnRJ9BFJa8K97lB0OLwdta6D4j3OCSwvXokDJcdmvpE+YjS
         EH2Q==
X-Gm-Message-State: AC+VfDxmWj+AiaHia7RTaBtbSKOL8Y1aALjGNALhcy8+XNQOz/jQR6/u
        QoE7B720CjIybLpfAJLlxgfuODlOYJFkdRBdMF+Z9g==
X-Google-Smtp-Source: ACHHUZ4JmS7eeOCuh0qfTtfA4JXCPJ0a2rGrHVcWlN0P7pwAJqtjPGnbkh5HRimwHWh0okTNQwWNHiUh7K4UnqXwMyc=
X-Received: by 2002:a05:6e02:1bcc:b0:335:12d6:2c7d with SMTP id
 x12-20020a056e021bcc00b0033512d62c7dmr87050ilv.0.1684961284829; Wed, 24 May
 2023 13:48:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230310105346.12302-1-likexu@tencent.com> <20230310105346.12302-6-likexu@tencent.com>
 <ZC99f+AO1tZguu1I@google.com> <509b697f-4e60-94e5-f785-95f7f0a14006@gmail.com>
 <ZDAvDhV/bpPyt3oX@google.com> <34b5dd08-edac-e32f-1884-c8f2b85f7971@gmail.com>
 <59ef9af0-9528-e220-625a-ff16e6971f23@amd.com> <ZG52cgmjgaqY8jvq@google.com>
In-Reply-To: <ZG52cgmjgaqY8jvq@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 24 May 2023 13:47:53 -0700
Message-ID: <CALMp9eR_xYapRm=zJ3OdAzBVFjpzeQWYv9nTs1ZstAsugEwWRQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] KVM: x86/pmu: Hide guest counter updates from the
 VMRUN instruction
To:     Sean Christopherson <seanjc@google.com>
Cc:     Sandipan Das <sandipan.das@amd.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>,
        "Tom Lendacky (AMD)" <thomas.lendacky@amd.com>,
        Ananth Narayan <ananth.narayan@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 24, 2023 at 1:41=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Apr 26, 2023, Sandipan Das wrote:
> > Hi Sean, Like,
> >
> > On 4/19/2023 7:11 PM, Like Xu wrote:
> > >> Heh, it's very much explicable, it's just not desirable, and you and=
 I would argue
> > >> that it's also incorrect.
> > >
> > > This is completely inaccurate from the end guest pmu user's perspecti=
ve.
> > >
> > > I have a toy that looks like virtio-pmu, through which guest users ca=
n get hypervisor performance data.
> > > But the side effect of letting the guest see the VMRUN instruction by=
 default is unacceptable, isn't it ?
> > >
> > >>
> > >> AMD folks, are there plans to document this as an erratum?=C3=AF=C2=
=BF=C2=BD I agree with Like that
> > >> counting VMRUN as a taken branch in guest context is a CPU bug, even=
 if the behavior
> > >> is known/expected.
> > >
> >
> > This behaviour is architectural and an erratum will not be issued. Howe=
ver, for clarity, a future
> > release of the APM will include additional details like the following:
> >
> >   1) From the perspective of performance monitoring counters, VMRUNs ar=
e considered as far control
> >      transfers and VMEXITs as exceptions.
> >
> >   2) When the performance monitoring counters are set up to count event=
s only in certain modes
> >      through the "OsUserMode" and "HostGuestOnly" bits, instructions an=
d events that change the
> >      mode are counted in the target mode. For example, a SYSCALL from C=
PL 3 to CPL 0 with a
> >      counter set to count retired instructions with USR=3D1 and OS=3D0 =
will not cause an increment of
> >      the counter. However, the SYSRET back from CPL 0 to CPL 3 will cau=
se an increment of the
> >      counter and the total count will end up correct. Similarly, when c=
ounting PMCx0C6 (retired
> >      far control transfers, including exceptions and interrupts) with G=
uest=3D1 and Host=3D0, a VMRUN
> >      instruction will cause an increment of the counter. However, the s=
ubsequent VMEXIT that occurs,
> >      since the target is in the host, will not cause an increment of th=
e counter and so the total
> >      count will end up correct.
>
> The count from the guest's perspective does not "end up correct".  Unlike=
 SYSCALL,
> where _userspace_ deliberately and synchronously executes a branch instru=
ction,
> VMEXIT and VMRUN are supposed to be transparent to the guest and can be c=
ompletely
> asynchronous with respect to guest code execution, e.g. if the host is sp=
amming
> IRQs, the guest will see a potentially large number of bogus (from it's p=
erspective)
> branches retired.

The reverse problem occurs when a PMC is configured to count "CPUID
instructions retired." Since KVM intercepts CPUID and emulates it, the
PMC will always read 0, even if the guest executes a tight loop of
CPUID instructions.

The PMU is not virtualizable on AMD CPUs without significant
hypervisor corrections. I have to wonder if it's really worth the
effort.
