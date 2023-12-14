Return-Path: <kvm+bounces-4466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CC538812CEB
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 11:30:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 106BDB2137F
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 10:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65CBA3C063;
	Thu, 14 Dec 2023 10:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cCi4m7Mh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B7310F
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 02:30:09 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-40c48d7a7a7so37242185e9.3
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 02:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702549808; x=1703154608; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uOVO+bfnnJKpEsOHryNuWrr2usdamUm/q/5hMMN7t4I=;
        b=cCi4m7MhDRKwmbzE2WnUH9sBMb+6JDrMU1uMh6Jt5C6m4VM5LNP3sbfHAN5LjOFGKY
         TVS/zZXhwGAvNu7JbTIduDg8GuTIR6SuV3gJtq6G3d/TZCQ00hTbMW2ZSbZzWaR2D3MF
         l0AUk5j7krI92119phi1zRXBPGdkjVwqWJ96kbVJEQEm5RaFLIiHbwN2dQBADE0q+dBl
         CsSt4FTvPJRIbk9TUiouEcF+qcQQqKQYYa8O+aa6LDaGJ0v0PEbtTZwz6ij73K2Nw4GS
         juQtIxiRff/DbS6Y1lJPjKl/eFbx45M+gRsCy8M/w2Ai4ygjOImeyPO4TBDgnVLIZK0h
         Ujgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702549808; x=1703154608;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uOVO+bfnnJKpEsOHryNuWrr2usdamUm/q/5hMMN7t4I=;
        b=Xx1RH85u7C0BeFiyJg/bZNIPLnzrUQz0pi8a82fWj1wPtF7cJaUFWBfcosVXC7URac
         d34MzOb9dPyI40hoZ5ocwD8zRN7WrmTlT76qz1xhd81anM8vGfalIP3EKXw0fYkXckIq
         Xch34+sZJEcTspgSizey4GLyJbWKZlV5asnL4jF4j6NoLOT9yjWwA9jWvBsjRUd7qyzZ
         eASJu317gNky4FojOal1VwaITt5TyoWWPta2weyogwWQaSWdsxDyLo4yJ7J0obx8jugK
         knc8VwZWH7bli7fKLlt+uDo1e21E5u4r9vDCUhCl/SgeykVYSz17yWrolWbSsHtYIq6S
         V7YQ==
X-Gm-Message-State: AOJu0YxVut1fE4Jm+T80SoH8tG1V/RyyxrGzfTqwcgyrrtA2G7Rrhe4g
	UEZe6W0NHuDuvK2kAraJwgjo5A==
X-Google-Smtp-Source: AGHT+IGfGsKpkGfYhg49s8Yquwu96sYE4oPzI7EF/ZouNO4OCHspwjlC8bcFEg/vs/gJgAL1beDnrQ==
X-Received: by 2002:a7b:cb95:0:b0:40c:9fa:592f with SMTP id m21-20020a7bcb95000000b0040c09fa592fmr5374387wmi.104.1702549808302;
        Thu, 14 Dec 2023 02:30:08 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id m27-20020a05600c3b1b00b0040b38292253sm26513051wms.30.2023.12.14.02.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 02:30:07 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 838705F7D3;
	Thu, 14 Dec 2023 10:30:07 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Cleber Rosa <crosa@redhat.com>
Cc: Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
  qemu-devel@nongnu.org,  Jiaxun Yang <jiaxun.yang@flygoat.com>,  Radoslaw
 Biernacki <rad@semihalf.com>,  Paul Durrant <paul@xen.org>,  Akihiko Odaki
 <akihiko.odaki@daynix.com>,  Leif Lindholm <quic_llindhol@quicinc.com>,
  Peter Maydell <peter.maydell@linaro.org>,  Paolo Bonzini
 <pbonzini@redhat.com>,  kvm@vger.kernel.org,  qemu-arm@nongnu.org,
  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Beraldo Leal
 <bleal@redhat.com>,  Wainer dos Santos Moschetta <wainersm@redhat.com>,
  Sriram Yagnaraman <sriram.yagnaraman@est.tech>,  David Woodhouse
 <dwmw2@infradead.org>
Subject: Re: [PATCH 04/10] tests/avocado: machine aarch64: standardize
 location and RO/RW access
In-Reply-To: <87le9xvmto.fsf@p1.localdomain> (Cleber Rosa's message of "Wed,
	13 Dec 2023 16:01:39 -0500")
References: <20231208190911.102879-1-crosa@redhat.com>
	<20231208190911.102879-5-crosa@redhat.com>
	<2972842d-e4bf-49eb-9d72-01b8049f18bf@linaro.org>
	<87le9xvmto.fsf@p1.localdomain>
User-Agent: mu4e 1.11.26; emacs 29.1
Date: Thu, 14 Dec 2023 10:30:07 +0000
Message-ID: <87r0jp84b4.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Cleber Rosa <crosa@redhat.com> writes:

> Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org> writes:
>
>> W dniu 8.12.2023 o=C2=A020:09, Cleber Rosa pisze:
>>> The tests under machine_aarch64_virt.py do not need read-write access
>>> to the ISOs.  The ones under machine_aarch64_sbsaref.py, on the other
>>> hand, will need read-write access, so let's give each test an unique
>>> file.
>>>=20
>>> And while at it, let's use a single code style and hash for the ISO
>>> url.
>>>=20
>>> Signed-off-by: Cleber Rosa<crosa@redhat.com>
>>
>> It is ISO file, so sbsa-ref tests should be fine with readonly as well.
>>
>> Nothing gets installed so nothing is written. We only test does boot wor=
ks.
>
> That was my original expectation too.  But, with nothing but the
> following change:
>
> diff --git a/tests/avocado/machine_aarch64_sbsaref.py b/tests/avocado/mac=
hine_aarch64_sbsaref.py
> index 528c7d2934..436da4b156 100644
> --- a/tests/avocado/machine_aarch64_sbsaref.py
> +++ b/tests/avocado/machine_aarch64_sbsaref.py
> @@ -129,7 +129,7 @@ def boot_alpine_linux(self, cpu):
>              "-cpu",
>              cpu,
>              "-drive",
> -            f"file=3D{iso_path},format=3Draw",
> +            f"file=3D{iso_path},readonly=3Don,format=3Draw",

               f"file=3D{iso_path},readonly=3Don,media=3Dcdrom,format=3Draw=
",

works (although possible the readonly is redundant in this case).

>              "-device",
>              "virtio-rng-pci,rng=3Drng0",
>              "-object",
>
> We get:
>
> 15:55:10 DEBUG| VM launch command: './qemu-system-aarch64 -display none -=
vga none -chardev socket,id=3Dmon,fd=3D15 -mon chardev=3Dmon,mode=3Dcontrol=
 -machine sbsa-ref -
> chardev socket,id=3Dconsole,fd=3D20 -serial chardev:console -cpu cortex-a=
57 -drive if=3Dpflash,file=3D/home/cleber/avocado/job-results/job-2023-12-1=
3T15.55-28ef2b5/test
> -results/tmp_dirx8p5xzt4/1-tests_avocado_machine_aarch64_sbsaref.py_Aarch=
64SbsarefMachine.test_sbsaref_alpine_linux_cortex_a57/SBSA_FLASH0.fd,format=
=3Draw -drive=20
> if=3Dpflash,file=3D/home/cleber/avocado/job-results/job-2023-12-13T15.55-=
28ef2b5/test-results/tmp_dirx8p5xzt4/1-tests_avocado_machine_aarch64_sbsare=
f.py_Aarch64Sbsa
> refMachine.test_sbsaref_alpine_linux_cortex_a57/SBSA_FLASH1.fd,format=3Dr=
aw -smp 1 -machine sbsa-ref -cpu cortex-a57 -drive file=3D/home/cleber/avoc=
ado/data/cache/b
> y_location/0154b7cd3a4f5e135299060c8cabbeec10b70b6d/alpine-standard-3.17.=
2-aarch64.iso,readonly=3Don,format=3Draw -device virtio-rng-pci,rng=3Drng0 =
-object rng-random
> ,id=3Drng0,filename=3D/dev/urandom'
>
> Followed by:
>
> 15:55:10 DEBUG| Failed to establish session:
>   | Traceback (most recent call last):
>   |   File "/home/cleber/src/qemu/python/qemu/qmp/protocol.py", line 425,=
 in _session_guard
>   |     await coro
>   |   File "/home/cleber/src/qemu/python/qemu/qmp/qmp_client.py", line 25=
3, in _establish_session
>   |     await self._negotiate()
>   |   File "/home/cleber/src/qemu/python/qemu/qmp/qmp_client.py", line 30=
5, in _negotiate
>   |     reply =3D await self._recv()
>   |             ^^^^^^^^^^^^^^^^^^
>   |   File "/home/cleber/src/qemu/python/qemu/qmp/protocol.py", line 1009=
, in _recv
>   |     message =3D await self._do_recv()
>   |               ^^^^^^^^^^^^^^^^^^^^^
>   |   File "/home/cleber/src/qemu/python/qemu/qmp/qmp_client.py", line 40=
2, in _do_recv
>   |     msg_bytes =3D await self._readline()
>   |                 ^^^^^^^^^^^^^^^^^^^^^^
>   |   File "/home/cleber/src/qemu/python/qemu/qmp/protocol.py", line 977,=
 in _readline
>   |     raise EOFError
>   | EOFError
>
> With qemu-system-arch producing on stdout:
>
>    qemu-system-aarch64: Block node is read-only
>
> Any ideas on the reason or cause?
>
> Thanks,
> - Cleber.

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

