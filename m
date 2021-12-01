Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756E54652AC
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 17:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244031AbhLAQZx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 11:25:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232979AbhLAQZw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 11:25:52 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B758C061574
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 08:22:31 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id r9-20020a7bc089000000b00332f4abf43fso1175870wmh.0
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 08:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=nCd1FlJuwlol8JfHsZBMh4q7Xxo8vRZYsT7cpMErU+8=;
        b=N5AXa0XGds9hExKOmGXWSzY/w/sFfTu/JDlECRTPLk/cyHcysnjhU3XKdLd2DX0qOc
         4Isugx2RyTK5k+uOiuqMyv2ldiYu7e40AOX/mBJbozN8e0uYQbfDZztYGo6WE6WP6VC9
         i/mIa2up1CSuHA+wQMCH7TTVnRul/hlJB1amIww0xQXEL0I086Mk28LxsVJ3JpN5fYLg
         Q9YKiB4B48QezpubJ16Fn5lHpe3GU3/8bwaW2DGb9F130jTB1rU9bRRaiHFyEPVt3SNr
         WGj+5h+KrrXeVEoTv00mCALRdGB81C5Njy1RPiXJOUoZLwMqtBCFRhYrmwdYCB6Oe3TO
         6d2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=nCd1FlJuwlol8JfHsZBMh4q7Xxo8vRZYsT7cpMErU+8=;
        b=VSQvsOqUMbKNgG9zHKiqYMSpuif0YqIoXCZmjTvtq4ZgBysk4Yq3Ggxap9h89Crijt
         gdrQx9R3sshrmtkUGQPXGnPgloLp39Ik4cyZ1HSwFgPEpNkN83HRzZOVAypZCpHbzGTy
         Byy4DMqh6m/75tVVIiLFKQQb7rKRoTQHliMFD4rXBGU4QtuALy+JcsdhPG5LeSHKtNoJ
         ZJ2AYHzvCeYExfT8lrjX8jR2AxRzc6/dT5T+uoam7gNB14ryPPeWyj9dnOh3+YAtjDl5
         yhDMI6DUz1svK/5lCNOq3C2XHYL4YcSZ0NzpmuXsobeh22M4CQ5M5xHYw/0A6q5DDvD9
         EWxg==
X-Gm-Message-State: AOAM532GMRLU5riDR8UrY+x2GNNi3flQsO6CsgPDCpdjFxKrWYTEYUj9
        YQVQ1jVEnWlQBQpVNDuIsOqAjA==
X-Google-Smtp-Source: ABdhPJw5mSovegWUJbSMKuylZDiEDy+t6coLgM37P0uX1r9MXZRrqPpfRE3Oj9J4TZrgo3ietSBFbg==
X-Received: by 2002:a1c:1f53:: with SMTP id f80mr8165968wmf.129.1638375749898;
        Wed, 01 Dec 2021 08:22:29 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id q26sm248744wrc.39.2021.12.01.08.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 08:22:29 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 802AB1FF96;
        Wed,  1 Dec 2021 16:22:28 +0000 (GMT)
References: <20211118184650.661575-1-alex.bennee@linaro.org>
 <20211118184650.661575-5-alex.bennee@linaro.org>
 <20211124164859.4enqimrptr3pfdkp@gator>
User-agent: mu4e 1.7.5; emacs 28.0.60
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, qemu-arm@nongnu.org,
        idan.horowitz@gmail.com, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [kvm-unit-tests PATCH v8 04/10] run_tests.sh: add --config
 option for alt test set
Date:   Wed, 01 Dec 2021 16:20:02 +0000
In-reply-to: <20211124164859.4enqimrptr3pfdkp@gator>
Message-ID: <87o860xpkr.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Andrew Jones <drjones@redhat.com> writes:

> On Thu, Nov 18, 2021 at 06:46:44PM +0000, Alex Benn=C3=A9e wrote:
>> The upcoming MTTCG tests don't need to be run for normal KVM unit
>> tests so lets add the facility to have a custom set of tests.
>
> I think an environment variable override would be better than this command
> line override, because then we could also get mkstandalone to work with
> the new unittests.cfg files. Or, it may be better to just add them to
> the main unittests.cfg with lines like these
>
> groups =3D nodefault mttcg
> accel =3D tcg
>
> That'll "dirty" the logs with SKIP ... (test marked as manual run only)
> for each one, but at least we won't easily forget about running them from
> time to time.

So what is the meaning of accel here? Is it:

  - this test only runs on accel FOO

or

  - this test defaults to running on accel FOO

because while the tests are for TCG I want to run them on KVM (so I can
validate the test on real HW). If I have accel=3Dtcg then:

  env ACCEL=3Dkvm QEMU=3D$HOME/lsrc/qemu.git/builds/all/qemu-system-aarch64=
 ./run_tests.sh -g mttcg
  SKIP tlbflush-code::all_other (tcg only, but ACCEL=3Dkvm)
  SKIP tlbflush-code::page_other (tcg only, but ACCEL=3Dkvm)
  SKIP tlbflush-code::all_self (tcg only, but ACCEL=3Dkvm)
  ...

so I can either drop the accel line and rely on nodefault to ensure it
doesn't run normally or make the env ACCEL processing less anal about
preventing me running TCG tests under KVM. What do you think?

--=20
Alex Benn=C3=A9e
