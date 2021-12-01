Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D97B4653AC
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 18:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238768AbhLARNq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 12:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242165AbhLARNn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 12:13:43 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910E5C061574
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 09:10:22 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id d24so53936675wra.0
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 09:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=/X+/QxH+bVpFbkeVkq7fkm197u4ULafwc+IR32ELh1k=;
        b=go/sAKu7WW/YgsktUC2OW1737aLS+jPp0bC/fb2h5/iwMr+Os3UTniuAczMdvZT6Kb
         2oID0VC8Y9ivdrkQJGNx4MX4jEl1zRSzFYTZnPylIVikppQJ927Ke+ZCfpP9kPLHHS0F
         Cpzb3h9ScWgG7vQot5tgvZecFfNj7046fphQ/9HB/dRpxa6OuZ++nG+0r6m2b1OKbfii
         BuLHL/r3ABllhuL26zxNm5YTUB8en3EkzkYSwSnhAAEzgxUt5x4H6HNxfvifxwEfMnQz
         mp+5vhdsGIk9xmJgbEBKWWsNoyBOTMvGjXlXKSky8Gs0793EnfIdHN2wytXVCemSPSeD
         F6RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=/X+/QxH+bVpFbkeVkq7fkm197u4ULafwc+IR32ELh1k=;
        b=YfimWfS22Schtp2cALZrt4waz273ZOL9re/H52iCNiuJ89xv4ZUs8wAKHUee/ffCfB
         J6D6VMeQWFRP1/3FV1d0AjkItxURQ9ZzI6y653fwQ+k8C3IoYLFrUuwO+FyRC++Va+vC
         vf8lD8bkB8ZvES59+5MMl8kchHWyxKnfp4mczffc9CJtMajLDHSsujuJiV8ANA5JuuzB
         hmoWvliD3fdhNjgnVTVG7vAnu5jN29t97J7v55xZkdPEg33KvQJr+jj9xGSDztRS5Crx
         HMFgNZ834bmYTsWGUeDnqtIQk3A1DEY/0TT7hDN1B4dYN4F5aqTHNz8AUNplFOVzvY2M
         Vr3Q==
X-Gm-Message-State: AOAM53186Dcmlfky7lBTZm3sBez+0FDx3IhDPdSz+sYY+KM+nS5zH4+f
        JcWh5VWFunwjXLvWxYqOaCz73Q==
X-Google-Smtp-Source: ABdhPJw2gK/ra0IeZfBdyCLqQaEhPVT3xRtPOjjBII6XwS3PuoIKwZpcVTOvBz3S4B8LRrF5JuAFUA==
X-Received: by 2002:a5d:6d4c:: with SMTP id k12mr8069364wri.511.1638378621070;
        Wed, 01 Dec 2021 09:10:21 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id k27sm1776152wms.41.2021.12.01.09.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 09:10:20 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 29B4B1FF96;
        Wed,  1 Dec 2021 17:10:19 +0000 (GMT)
References: <20211118184650.661575-1-alex.bennee@linaro.org>
 <20211118184650.661575-5-alex.bennee@linaro.org>
 <20211124164859.4enqimrptr3pfdkp@gator> <87o860xpkr.fsf@linaro.org>
 <20211201164100.57ima4v5ppqojmu7@gator>
User-agent: mu4e 1.7.5; emacs 28.0.60
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, qemu-arm@nongnu.org,
        idan.horowitz@gmail.com, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [kvm-unit-tests PATCH v8 04/10] run_tests.sh: add --config
 option for alt test set
Date:   Wed, 01 Dec 2021 17:07:18 +0000
In-reply-to: <20211201164100.57ima4v5ppqojmu7@gator>
Message-ID: <87k0goxnd0.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Andrew Jones <drjones@redhat.com> writes:

> On Wed, Dec 01, 2021 at 04:20:02PM +0000, Alex Benn=C3=A9e wrote:
>>=20
>> Andrew Jones <drjones@redhat.com> writes:
>>=20
>> > On Thu, Nov 18, 2021 at 06:46:44PM +0000, Alex Benn=C3=A9e wrote:
>> >> The upcoming MTTCG tests don't need to be run for normal KVM unit
>> >> tests so lets add the facility to have a custom set of tests.
>> >
>> > I think an environment variable override would be better than this com=
mand
>> > line override, because then we could also get mkstandalone to work with
>> > the new unittests.cfg files. Or, it may be better to just add them to
>> > the main unittests.cfg with lines like these
>> >
>> > groups =3D nodefault mttcg
>> > accel =3D tcg
>> >
>> > That'll "dirty" the logs with SKIP ... (test marked as manual run only)
>> > for each one, but at least we won't easily forget about running them f=
rom
>> > time to time.
>>=20
>> So what is the meaning of accel here? Is it:
>>=20
>>   - this test only runs on accel FOO
>>=20
>> or
>>=20
>>   - this test defaults to running on accel FOO
>>=20
>> because while the tests are for TCG I want to run them on KVM (so I can
>> validate the test on real HW). If I have accel=3Dtcg then:
>>=20
>>   env ACCEL=3Dkvm QEMU=3D$HOME/lsrc/qemu.git/builds/all/qemu-system-aarc=
h64 ./run_tests.sh -g mttcg
>>   SKIP tlbflush-code::all_other (tcg only, but ACCEL=3Dkvm)
>>   SKIP tlbflush-code::page_other (tcg only, but ACCEL=3Dkvm)
>>   SKIP tlbflush-code::all_self (tcg only, but ACCEL=3Dkvm)
>>   ...
>>=20
>> so I can either drop the accel line and rely on nodefault to ensure it
>> doesn't run normally or make the env ACCEL processing less anal about
>> preventing me running TCG tests under KVM. What do you think?
>
> Just drop the 'accel =3D tcg' line. I only suggested it because I didn't
> know you also wanted to run the MTTCG "specific" tests under KVM. Now,
> that I do, I wonder why we wouldn't run them all the time, i.e. no
> nodefault group? Do the tests not exercise enough hypervisor code to
> be worth the energy used to run them?

I think in most cases if they fail under KVM it wouldn't be due to the
hypervisor being broken but the silicon not meeting it's architectural
specification. I'm fine with them being nodefault for that.

I'm not sure how much the tlbflush code exercises on the host. There is
a WIP tlbflush-data which might make a case for being run more
regularly on KVM.

>
> Thanks,
> drew


--=20
Alex Benn=C3=A9e
