Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13BE536DC6D
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 17:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240572AbhD1Pvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 11:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240887AbhD1Pvj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 11:51:39 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A18C061573
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 08:50:53 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id k14so13663377wrv.5
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 08:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=tRy6KQAd2aytF7sdp/cJx67ONL5QehPERyNmo11ZKWA=;
        b=uuyp8qweDp2flU/K/24W2c3cBGWF24O7u44mz6KIS/kPm9fX6sNtXd+HI5urh0dHz3
         VsoMJUt11ge1kfVwMmiYeYJLiw4mSdtfMmFhyrjbzr8IhJ6tt2nqkOZh+l/LqgQY3ueG
         d32GVQTOwnvfGIzIf5Rhe3wlfoXJehrLCLkmFGCglKeJiF19HJ05K2nGxgC6qQvvBKKv
         z9tI23hA9jQtr+841P/ueKwjBj/l+csxaBROzbnIC8DfzmFBlX9a7N/J4Ix7DIMl/XPD
         oUBDqW9MCd2cQtOLTaoMJkLChHJT0WXEDiVsTBC5ErhPwZwt+PVXkCy2RWiE23yHDmob
         rbAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=tRy6KQAd2aytF7sdp/cJx67ONL5QehPERyNmo11ZKWA=;
        b=l+RV3OkgjUdDBqVnS/XuWXp69BkunfLPDICUqBcTK6/EyxC41C3fqTVwYtB7806XKq
         9p9mt2NfuW4pE1J81GaBIIHsN6+WcMR54Xexwqoy2CiJgV/N5Hbks2b6FkzKhwXbn4oj
         RiAId0Dk8JEAET1FV/9mr0ktz7k48RhaQHNV8gOMbN98cOhHmjJv6VLW24BTEGFUCkPj
         ZTUpAup6TqFyHKTWyzSmQV0dyGl7jVQ/FXgPM6miT+Ls5ReONrfFyal1KlSDZANQq4CO
         T+pehymDREw/aFkzNOcnUAslxQqWtuyor+hqJmBdlhRqVVzsgU5huvIyXCWe+/pozUGW
         aJ6Q==
X-Gm-Message-State: AOAM5325//RHpNHzwhIWNsoHSrOWNekOVcLZQjX/0kCfyr7yYl6MBgJe
        LKnuniKgiTnq3ABRtaCAHHzzFg==
X-Google-Smtp-Source: ABdhPJx5fpcX8GYyUuPP7jxE5XxhgdA644hng/G8ehJHMs3ZqzR1d35ZOOopcIAqTcOovOeeWVgpdQ==
X-Received: by 2002:adf:dc4f:: with SMTP id m15mr37234198wrj.420.1619625052579;
        Wed, 28 Apr 2021 08:50:52 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id z15sm159848wrv.39.2021.04.28.08.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 08:50:51 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 170071FF7E;
        Wed, 28 Apr 2021 16:50:51 +0100 (BST)
References: <20210428101844.22656-1-alex.bennee@linaro.org>
 <20210428101844.22656-2-alex.bennee@linaro.org>
 <eaed3c63988513fe2849c2d6f22937af@kernel.org> <87fszasjdg.fsf@linaro.org>
 <996210ae-9c63-54ff-1a65-6dbd63da74d2@arm.com>
 <87k0omo4rr.wl-maz@kernel.org>
User-agent: mu4e 1.5.12; emacs 28.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        shashi.mallela@linaro.org, eric.auger@redhat.com,
        qemu-arm@nongnu.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com
Subject: Re: [kvm-unit-tests PATCH v1 1/4] arm64: split its-trigger test
 into KVM and TCG variants
Date:   Wed, 28 Apr 2021 16:37:45 +0100
In-reply-to: <87k0omo4rr.wl-maz@kernel.org>
Message-ID: <87czues90k.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Marc Zyngier <maz@kernel.org> writes:

> On Wed, 28 Apr 2021 15:00:15 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>>=20
>> I interpret that as that an INVALL guarantees that a change is
>> visible, but it the change can become visible even without the
>> INVALL.
>
> Yes. Expecting the LPI to be delivered or not in the absence of an
> invalidate when its configuration has been altered is wrong. The
> architecture doesn't guarantee anything of the sort.

Is the underlying hypervisor allowed to invalidate and reload the
configuration whenever it wants or should it only be driven by the
guests requests?

I did consider a more nuanced variant of the test that allowed for a
delivery pre-inval and a pass for post-inval as long as it had been
delivered one way or another:

--8<---------------cut here---------------start------------->8---
modified   arm/gic.c
@@ -36,6 +36,7 @@ static struct gic *gic;
 static int acked[NR_CPUS], spurious[NR_CPUS];
 static int irq_sender[NR_CPUS], irq_number[NR_CPUS];
 static cpumask_t ready;
+static bool under_tcg;
=20
 static void nr_cpu_check(int nr)
 {
@@ -687,6 +688,7 @@ static void test_its_trigger(void)
 	struct its_collection *col3;
 	struct its_device *dev2, *dev7;
 	cpumask_t mask;
+	bool before, after;
=20
 	if (its_setup1())
 		return;
@@ -734,15 +736,17 @@ static void test_its_trigger(void)
 	/*
 	 * re-enable the LPI but willingly do not call invall
 	 * so the change in config is not taken into account.
-	 * The LPI should not hit
+	 * The LPI should not hit. This does however depend on
+	 * implementation defined behaviour - under QEMU TCG emulation
+	 * it can quite correctly process the event directly.
 	 */
 	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT);
 	stats_reset();
 	cpumask_clear(&mask);
 	its_send_int(dev2, 20);
 	wait_for_interrupts(&mask);
-	report(check_acked(&mask, -1, -1),
-			"dev2/eventid=3D20 still does not trigger any LPI");
+	before =3D check_acked(&mask, -1, -1);
+	report_xfail(under_tcg, before, "dev2/eventid=3D20 still may not trigger =
any LPI");
=20
 	/* Now call the invall and check the LPI hits */
 	stats_reset();
@@ -750,8 +754,8 @@ static void test_its_trigger(void)
 	cpumask_set_cpu(3, &mask);
 	its_send_invall(col3);
 	wait_for_interrupts(&mask);
-	report(check_acked(&mask, 0, 8195),
-			"dev2/eventid=3D20 pending LPI is received");
+	after =3D check_acked(&mask, 0, 8195);
+	report(before !=3D after, "dev2/eventid=3D20 pending LPI is received");
=20
 	stats_reset();
 	cpumask_clear(&mask);
@@ -759,7 +763,7 @@ static void test_its_trigger(void)
 	its_send_int(dev2, 20);
 	wait_for_interrupts(&mask);
 	report(check_acked(&mask, 0, 8195),
-			"dev2/eventid=3D20 now triggers an LPI");
+	       "dev2/eventid=3D20 now triggers an LPI");
=20
 	report_prefix_pop();
=20
@@ -981,6 +985,9 @@ int main(int argc, char **argv)
 	if (argc < 2)
 		report_abort("no test specified");
=20
+	if (argc =3D=3D 3 && strcmp(argv[2], "tcg") =3D=3D 0)
+		under_tcg =3D true;
+
 	if (strcmp(argv[1], "ipi") =3D=3D 0) {
 		report_prefix_push(argv[1]);
 		nr_cpu_check(2);
--8<---------------cut here---------------end--------------->8---

But that gets confused (that may be something for Sashi to look at):

  ITS: MAPD devid=3D2 size =3D 0x8 itt=3D0x40440000 valid=3D1
  ITS: MAPD devid=3D7 size =3D 0x8 itt=3D0x40450000 valid=3D1
  MAPC col_id=3D3 target_addr =3D 0x30000 valid=3D1
  MAPC col_id=3D2 target_addr =3D 0x20000 valid=3D1
  INVALL col_id=3D2
  INVALL col_id=3D3
  MAPTI dev_id=3D2 event_id=3D20 -> phys_id=3D8195, col_id=3D3
  MAPTI dev_id=3D7 event_id=3D255 -> phys_id=3D8196, col_id=3D2
  INT dev_id=3D2 event_id=3D20
  PASS: gicv3: its-trigger: int: dev=3D2, eventid=3D20  -> lpi=3D 8195, col=
=3D3
  INT dev_id=3D7 event_id=3D255
  PASS: gicv3: its-trigger: int: dev=3D7, eventid=3D255 -> lpi=3D 8196, col=
=3D2
  INV dev_id=3D2 event_id=3D20
  INT dev_id=3D2 event_id=3D20
  PASS: gicv3: its-trigger: inv/invall: dev2/eventid=3D20 does not trigger =
any LPI
  INT dev_id=3D2 event_id=3D20
  INFO: gicv3: its-trigger: inv/invall: interrupts timed-out (5s)
  INFO: gicv3: its-trigger: inv/invall: cpu3 received wrong irq 8195
  INFO: gicv3: its-trigger: inv/invall: ACKS: missing=3D0 extra=3D0 unexpec=
ted=3D1
  XFAIL: gicv3: its-trigger: inv/invall: dev2/eventid=3D20 still may not tr=
igger any LPI
  INVALL col_id=3D3
  INFO: gicv3: its-trigger: inv/invall: interrupts timed-out (5s)
  INFO: gicv3: its-trigger: inv/invall: ACKS: missing=3D1 extra=3D0 unexpec=
ted=3D0
  FAIL: gicv3: its-trigger: inv/invall: dev2/eventid=3D20 pending LPI is re=
ceived
  INT dev_id=3D2 event_id=3D20
  PASS: gicv3: its-trigger: inv/invall: dev2/eventid=3D20 now triggers an L=
PI
  ITS: MAPD devid=3D2 size =3D 0x8 itt=3D0x40440000 valid=3D0
  INT dev_id=3D2 event_id=3D20
  PASS: gicv3: its-trigger: mapd valid=3Dfalse: no LPI after device unmap
  SUMMARY: 7 tests, 1 unexpected failures, 1 expected failures

>> The test relies on the fact that changes to the LPI tables are not
>> visible *under KVM* until the INVALL command, but that's not
>> necessarily the case on real hardware. To match the spec, I think
>> the test "dev2/eventid=3D20 still does not trigger any LPI" should be
>> removed and the stats reset should take place before the
>> configuration for LPI 8195 is set to the default.
>
> If that's what the test expects (I haven't tried to investigate), it
> should be dropped completely, rather than trying to sidestep it for
> TCG.

All three parts of that section?

	report(check_acked(&mask, -1, -1),
			"dev2/eventid=3D20 still does not trigger any LPI");
	report(check_acked(&mask, 0, 8195),
			"dev2/eventid=3D20 pending LPI is received");
	report(check_acked(&mask, 0, 8195),
			"dev2/eventid=3D20 now triggers an LPI");


--=20
Alex Benn=C3=A9e
