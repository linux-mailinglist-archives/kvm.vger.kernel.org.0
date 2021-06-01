Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36CD397BE5
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 23:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234766AbhFAVxJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 17:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234656AbhFAVxI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 17:53:08 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B6FC061574
        for <kvm@vger.kernel.org>; Tue,  1 Jun 2021 14:51:25 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id n17-20020a7bc5d10000b0290169edfadac9so2482795wmk.1
        for <kvm@vger.kernel.org>; Tue, 01 Jun 2021 14:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=eEnFmGo+UZqq9usDjM1VKElE9vmoR0P36JtXIWuNBME=;
        b=zLN3ODyt+z+dh7cCItJooplLlyn6/+d455ILyy98nrCpsg2UcVN5IPIShVd2buvODK
         q/Aq9XD97xHJEpMvxZ1oNVZwLgxiFAEk3x+LV7G56ygvllQak9fBw6yas11//76bHLFN
         +vY6O4pHFU6FZdKfUX47qd/46xrAzthLWEwKqDpqyY+hg424pn1aJyiOcmZEzYa6inC6
         bs2tr314Tjm2o1ZTr6g1w/8gI6d7rPtEbYxo8DnvQ6aInpY8VSx0WJE3uiZppucnpv1D
         pQK1S2qT6VDS2dLAJRMXsgBUmzwBf7sq72Ov9CLcKUZl3bYaYY9k45F2GRp0kwIlQgrb
         gC3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=eEnFmGo+UZqq9usDjM1VKElE9vmoR0P36JtXIWuNBME=;
        b=skLKSr+4xmeCgubQ7yLl2hoStnkPRCkidqLR/sXkDAk5jD7lr6Aw8AffZzsfK3R3vd
         Bl9vwC+mSaa66d3Jelzf5MYZK7eRkc2wp7PZYtuj4jcE5tUv0RQUF1HOzhyruveXHhW5
         zfWMKc70lll30ud7fUm3/Do9ryoM50BsXIZXQ5is35W779cPZc0hqzPtJyfPIITAekEg
         7QkulnSLT7McEWNKha7UYLk6jltwe98O4KiHt6H/QEx1la4+JjbDib/LFQgjMP5YVvVN
         /XQ50dX/AQ0KpTDc/j9tucmxTShgCNPV7PpURI10fbgcF1H8dqvk1cc74kGdWV7hRjCu
         Nk+A==
X-Gm-Message-State: AOAM530i1n5FzCPXGHwzsCaXohX8Bc118NYtwpXsTtQcBNIW5U1cm1nL
        1/d6JnfZiiz6siqEup99AUtMnw==
X-Google-Smtp-Source: ABdhPJy+O/9yUXByk5CtPEKI69bRLs831YKZ/VATXi6NUYp3immwAkZ80g7J3CvcHwxl1kHruVDz2w==
X-Received: by 2002:a7b:c4d0:: with SMTP id g16mr1811216wmk.147.1622584284192;
        Tue, 01 Jun 2021 14:51:24 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id z10sm71291wmb.26.2021.06.01.14.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 14:51:23 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 7DD671FF7E;
        Tue,  1 Jun 2021 22:51:22 +0100 (BST)
References: <20210525172628.2088-1-alex.bennee@linaro.org>
 <20210525172628.2088-5-alex.bennee@linaro.org>
 <5fe1c796-c886-e5c6-6e61-e12d0f73a884@redhat.com>
 <87sg21bk7r.fsf@linaro.org> <20210601194648.fdymtxiz6lkxycsx@gator.home>
User-agent: mu4e 1.5.13; emacs 28.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org,
        maz@kernel.org, shashi.mallela@linaro.org, qemu-arm@nongnu.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [kvm-unit-tests PATCH v2 4/4] arm64: split
 its-migrate-unmapped-collection into KVM and TCG variants
Date:   Tue, 01 Jun 2021 22:50:15 +0100
In-reply-to: <20210601194648.fdymtxiz6lkxycsx@gator.home>
Message-ID: <87pmx5b6ed.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Andrew Jones <drjones@redhat.com> writes:

> On Tue, Jun 01, 2021 at 05:49:01PM +0100, Alex Benn=C3=A9e wrote:
>>=20
>> Auger Eric <eric.auger@redhat.com> writes:
>>=20
>> > Hi Alex,
>> >
>> > On 5/25/21 7:26 PM, Alex Benn=C3=A9e wrote:
>> >> When running the test in TCG we are basically running on bare metal so
>> >> don't rely on having a particular kernel errata applied.
>> >>=20
>> >> You might wonder why we handle this with a totally new test name
>> >> instead of adjusting the append to take an extra parameter? Well the
>> >> run_migration shell script uses eval "$@" which unwraps the -append
>> >> leading to any second parameter being split and leaving QEMU very
>> >> confused and the test hanging. This seemed simpler than re-writing all
>> >> the test running logic in something sane ;-)
>> >
>> > there is
>> > lib/s390x/vm.h:bool vm_is_tcg(void)
>> >
>> > but I don't see any particular ID we could use to differentiate both t=
he
>> > KVM and the TCG mode, do you?
>>=20
>> For -cpu max we do:
>>=20
>>         /*
>>          * Reset MIDR so the guest doesn't mistake our 'max' CPU type fo=
r a real
>>          * one and try to apply errata workarounds or use impdef feature=
s we
>>          * don't provide.
>>          * An IMPLEMENTER field of 0 means "reserved for software use";
>>          * ARCHITECTURE must be 0xf indicating "v7 or later, check ID re=
gisters
>>          * to see which features are present";
>>          * the VARIANT, PARTNUM and REVISION fields are all implementati=
on
>>          * defined and we choose to define PARTNUM just in case guest
>>          * code needs to distinguish this QEMU CPU from other software
>>          * implementations, though this shouldn't be needed.
>>          */
>>         t =3D FIELD_DP64(0, MIDR_EL1, IMPLEMENTER, 0);
>>         t =3D FIELD_DP64(t, MIDR_EL1, ARCHITECTURE, 0xf);
>>         t =3D FIELD_DP64(t, MIDR_EL1, PARTNUM, 'Q');
>>         t =3D FIELD_DP64(t, MIDR_EL1, VARIANT, 0);
>>         t =3D FIELD_DP64(t, MIDR_EL1, REVISION, 0);
>>         cpu->midr =3D t;
>>=20
>> However for the default -cpu cortex-a57 we aim to look just like the
>> real thing - only without any annoying micro-architecture bugs ;-)
>>=20
>> >
>> > without a more elegant solution,
>>=20
>> I'll look into the suggestion made by Richard.
>
> Where did Richard make a suggestion? And what is it?

Sorry - I had a brain fart, I was of course referring to your
ERRATA_FORCE suggestion.

>
> Thanks,
> drew
>
>>=20
>> > Reviewed-by: Eric Auger <eric.auger@redhat.com>
>> >
>> > Thanks
>> >
>> > Eric
>> >
>> >
>> >>=20
>> >> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> >> Cc: Shashi Mallela <shashi.mallela@linaro.org>
>> >> ---
>> >>  arm/gic.c         |  8 +++++++-
>> >>  arm/unittests.cfg | 10 +++++++++-
>> >>  2 files changed, 16 insertions(+), 2 deletions(-)
>> >>=20
>> >> diff --git a/arm/gic.c b/arm/gic.c
>> >> index bef061a..0fce2a4 100644
>> >> --- a/arm/gic.c
>> >> +++ b/arm/gic.c
>> >> @@ -36,6 +36,7 @@ static struct gic *gic;
>> >>  static int acked[NR_CPUS], spurious[NR_CPUS];
>> >>  static int irq_sender[NR_CPUS], irq_number[NR_CPUS];
>> >>  static cpumask_t ready;
>> >> +static bool under_tcg;
>> >>=20=20
>> >>  static void nr_cpu_check(int nr)
>> >>  {
>> >> @@ -834,7 +835,7 @@ static void test_migrate_unmapped_collection(void)
>> >>  		goto do_migrate;
>> >>  	}
>> >>=20=20
>> >> -	if (!errata(ERRATA_UNMAPPED_COLLECTIONS)) {
>> >> +	if (!errata(ERRATA_UNMAPPED_COLLECTIONS) && !under_tcg) {
>> >>  		report_skip("Skipping test, as this test hangs without the fix. "
>> >>  			    "Set %s=3Dy to enable.", ERRATA_UNMAPPED_COLLECTIONS);
>> >>  		test_skipped =3D true;
>> >> @@ -1005,6 +1006,11 @@ int main(int argc, char **argv)
>> >>  		report_prefix_push(argv[1]);
>> >>  		test_migrate_unmapped_collection();
>> >>  		report_prefix_pop();
>> >> +	} else if (!strcmp(argv[1], "its-migrate-unmapped-collection-tcg"))=
 {
>> >> +		under_tcg =3D true;
>> >> +		report_prefix_push(argv[1]);
>> >> +		test_migrate_unmapped_collection();
>> >> +		report_prefix_pop();
>> >>  	} else if (strcmp(argv[1], "its-introspection") =3D=3D 0) {
>> >>  		report_prefix_push(argv[1]);
>> >>  		test_its_introspection();
>> >> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
>> >> index 1a39428..adc1bbf 100644
>> >> --- a/arm/unittests.cfg
>> >> +++ b/arm/unittests.cfg
>> >> @@ -205,7 +205,7 @@ extra_params =3D -machine gic-version=3D3 -append=
 'its-pending-migration'
>> >>  groups =3D its migration
>> >>  arch =3D arm64
>> >>=20=20
>> >> -[its-migrate-unmapped-collection]
>> >> +[its-migrate-unmapped-collection-kvm]
>> >>  file =3D gic.flat
>> >>  smp =3D $MAX_SMP
>> >>  accel =3D kvm
>> >> @@ -213,6 +213,14 @@ extra_params =3D -machine gic-version=3D3 -appen=
d 'its-migrate-unmapped-collection'
>> >>  groups =3D its migration
>> >>  arch =3D arm64
>> >>=20=20
>> >> +[its-migrate-unmapped-collection-tcg]
>> >> +file =3D gic.flat
>> >> +smp =3D $MAX_SMP
>> >> +accel =3D tcg
>> >> +extra_params =3D -machine gic-version=3D3 -append 'its-migrate-unmap=
ped-collection-tcg'
>> >> +groups =3D its migration
>> >> +arch =3D arm64
>> >> +
>> >>  # Test PSCI emulation
>> >>  [psci]
>> >>  file =3D psci.flat
>> >>=20
>>=20
>>=20
>> --=20
>> Alex Benn=C3=A9e
>> _______________________________________________
>> kvmarm mailing list
>> kvmarm@lists.cs.columbia.edu
>> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm


--=20
Alex Benn=C3=A9e
