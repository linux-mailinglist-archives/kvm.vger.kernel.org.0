Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F297046363C
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 15:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236969AbhK3OQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 09:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbhK3OQM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 09:16:12 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08566C061574
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 06:12:53 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id c6-20020a05600c0ac600b0033c3aedd30aso14858700wmr.5
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 06:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=8Xn93JXcXYRTtOD7EOYXIoNbaeFJmOBsAiqitoLCgJk=;
        b=ywuB381uBd+1hkeF830EzjJV9PawMLMyPgGheyiUNoGiytxE9CgXK+tu0Xcv2uisGh
         RTRhw0w36uD0f/XK/ILRhM7WJEcb5SL+qJn5P0DLZLzilOOstZS8Kx7s81HK8HEDhv8/
         Z+Simda2xsu44BdPlX3XXhLBt+cv/SdxOCwNdGgaPrzlDFuomkTZkofVEd0g01KNoI+m
         QjEGkdpVfjkvGaDwfemisa30Z4SMegqTCYo+gqm9AK6A/74rUV0xdkzeNmSKIeG3q2ZJ
         Sxw0XnIj2SK8ZvN/J1W/x41xIlUHWJg9TFajZFfsFIbiEb1Myyr5ZjgZXA0a1ikJDoiN
         XLOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=8Xn93JXcXYRTtOD7EOYXIoNbaeFJmOBsAiqitoLCgJk=;
        b=1zrSv34v87ZLG0DlsBaXxqb1ZL6uG/wKes2lLBrdbKjkFDqbH8WtowNEV3hd6wg/ZE
         SkCfiWUor2djUbI5uyoRYe+6L+5jM42Mk0r8q2vP7dekfk+tuM+ZmNdfvuf38l9gjKlX
         BCJSCLehRzsOdvvPU6+xvCsBjZA/Vrtjw4sjIRYcPwIH4kVjJ7LQjpytWx2YxRI9nygO
         MWxk+AiMueVD1IbSvUmzjwTG2oHjXBL0mIFLfkiERoAVVi3Yzql8/qWHoJh8DSBVEAp/
         eNba9IkoezYDzNSGB8qVK5CHr8pKQWHLS5Y18CrPKyAS4D2gnHM+oETf34a0t712aS1W
         6vbw==
X-Gm-Message-State: AOAM5307PHkjeaBy5bBhRV+KoDH/xy0YGI0ktAKHST7xFVGsgu+NXLFw
        pBdh/Noo2iQHpo/mKPaCn8epuQ==
X-Google-Smtp-Source: ABdhPJzSykfHQLSLPFOrDvCzXmZApy1OjVhVgAuZ/JmM7o9Bb+dUIPemMJrbmTKFbG6uFli3i/0RRg==
X-Received: by 2002:a05:600c:294c:: with SMTP id n12mr5276099wmd.71.1638281571604;
        Tue, 30 Nov 2021 06:12:51 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id x13sm16592862wrr.47.2021.11.30.06.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 06:12:50 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 1E4681FF96;
        Tue, 30 Nov 2021 14:12:50 +0000 (GMT)
References: <20211112114734.3058678-1-alex.bennee@linaro.org>
 <20211112132312.qrgmby55mlenj72p@gator.home> <87wnldfoul.fsf@linaro.org>
 <20211112145442.5ktlpwyolwdsxlnx@gator.home> <877dd4umy6.fsf@linaro.org>
 <20211119183059.jwrhb77jfjbv5rbz@gator.home>
User-agent: mu4e 1.7.5; emacs 28.0.60
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, shashi.mallela@linaro.org,
        qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 0/3] GIC ITS tests
Date:   Tue, 30 Nov 2021 14:11:34 +0000
In-reply-to: <20211119183059.jwrhb77jfjbv5rbz@gator.home>
Message-ID: <87a6hlzq8t.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Andrew Jones <drjones@redhat.com> writes:

> On Fri, Nov 19, 2021 at 04:30:47PM +0000, Alex Benn=C3=A9e wrote:
>>=20
>> Andrew Jones <drjones@redhat.com> writes:
>>=20
>> > On Fri, Nov 12, 2021 at 02:08:01PM +0000, Alex Benn=C3=A9e wrote:
>> >>=20
>> >> Andrew Jones <drjones@redhat.com> writes:
>> >>=20
>> >> > On Fri, Nov 12, 2021 at 11:47:31AM +0000, Alex Benn=C3=A9e wrote:
>> >> >> Hi,
>> >> >>=20
>> >> >> Sorry this has been sitting in my tree so long. The changes are fa=
irly
>> >> >> minor from v2. I no longer split the tests up into TCG and KVM
>> >> >> versions and instead just ensure that ERRATA_FORCE is always set w=
hen
>> >> >> run under TCG.
>> >> >>=20
>> >> >> Alex Benn=C3=A9e (3):
>> >> >>   arm64: remove invalid check from its-trigger test
>> >> >>   arm64: enable its-migration tests for TCG
>> >> >>   arch-run: do not process ERRATA when running under TCG
>> >> >>=20
>> >> >>  scripts/arch-run.bash |  4 +++-
>> >> >>  arm/gic.c             | 16 ++++++----------
>> >> >>  arm/unittests.cfg     |  3 ---
>> >> >>  3 files changed, 9 insertions(+), 14 deletions(-)
>> >> >>=20
>> >> >> --=20
>> >> >> 2.30.2
>> >> >>=20
>> >> >> _______________________________________________
>> >> >> kvmarm mailing list
>> >> >> kvmarm@lists.cs.columbia.edu
>> >> >> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>> >> >
>> >> > Hi Alex,
>> >> >
>> >> > Thanks for this. I've applied to arm/queue, but I see that
>> >> >
>> >> > FAIL: gicv3: its-trigger: inv/invall: dev2/eventid=3D20 pending LPI=
 is received
>> >> >
>> >> > consistently fails for me. Is that expected? Does it work for you?
>> >>=20
>> >> doh - looks like I cocked up the merge conflict...
>> >>=20
>> >> Did it fail for TCG or for KVM (or both)?
>> >
>> > Just TCG, which was why I was wondering if it was expected. I've never=
 run
>> > these tests with TCG before.
>>=20
>> Hmm I think expecting the IRQ at all is broken so I think I should
>> delete the whole pending test.
>
> Feel free to repost. I'll update the patches in arm/queue before my next
> MR.

Actually I think the problem was with a regression in the TCG ITS
support (now fixed in master). So I believe as of v3 everything is
correct (and v4 should be ignored).

Are you happy to apply this series or do you want me to repost it as v5?

>
> Thanks,
> drew


--=20
Alex Benn=C3=A9e
