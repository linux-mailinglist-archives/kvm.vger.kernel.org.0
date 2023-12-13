Return-Path: <kvm+bounces-4391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 07A8E811FB3
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 21:09:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C30D281B55
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 20:09:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63BDF7E54F;
	Wed, 13 Dec 2023 20:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q20k+MmV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2A99C
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 12:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702498131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oaPLT/w+GJhxx6euDyuvXTKoL3tEsYpftnOe2O3RcpI=;
	b=Q20k+MmVOoMixOuONEBKqYT3UtZ0OhyEnHHEUsQAzzDHLT7SOJGqLRpjY/ybIDzH9wr6oF
	LrHsn6FURs9AFYPeJd2LCKpbRFwZoD0g/vypbKFE8HoNuuwnF9QQj9KeUDfQdoLxoet0aQ
	PiAMi2Hh8T2LkRwbM1b9W/a26RMyN9M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-346-tr7boWT0NyC4lFUxfgo2Cw-1; Wed, 13 Dec 2023 15:08:45 -0500
X-MC-Unique: tr7boWT0NyC4lFUxfgo2Cw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D00978910C2;
	Wed, 13 Dec 2023 20:08:44 +0000 (UTC)
Received: from p1.localdomain.some.host.somewhere.org (ovpn-114-21.gru2.redhat.com [10.97.114.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1324C3C25;
	Wed, 13 Dec 2023 20:08:35 +0000 (UTC)
From: Cleber Rosa <crosa@redhat.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>, Eric Auger
 <eric.auger@redhat.com>
Cc: qemu-devel@nongnu.org, Jiaxun Yang <jiaxun.yang@flygoat.com>, Radoslaw
 Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>, Akihiko Odaki
 <akihiko.odaki@daynix.com>, Leif Lindholm <quic_llindhol@quicinc.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org, qemu-arm@nongnu.org, Philippe
 =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Beraldo Leal
 <bleal@redhat.com>, Wainer
 dos Santos Moschetta <wainersm@redhat.com>, Sriram Yagnaraman
 <sriram.yagnaraman@est.tech>, Marcin Juszkiewicz
 <marcin.juszkiewicz@linaro.org>, David Woodhouse <dwmw2@infradead.org>,
 Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 03/10] tests/avocado/intel_iommu.py: increase timeout
In-Reply-To: <8734w8fzbc.fsf@draig.linaro.org>
References: <20231208190911.102879-1-crosa@redhat.com>
 <20231208190911.102879-4-crosa@redhat.com>
 <8734w8fzbc.fsf@draig.linaro.org>
Date: Wed, 13 Dec 2023 15:08:26 -0500
Message-ID: <87sf45vpad.fsf@p1.localdomain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

Alex Benn=C3=A9e <alex.bennee@linaro.org> writes:

> Cleber Rosa <crosa@redhat.com> writes:
>
>> Based on many runs, the average run time for these 4 tests is around
>> 250 seconds, with 320 seconds being the ceiling.  In any way, the
>> default 120 seconds timeout is inappropriate in my experience.
>
> I would rather see these tests updated to fix:
>
>  - Don't use such an old Fedora 31 image

I remember proposing a bump in Fedora version used by default in
avocado_qemu.LinuxTest (which would propagate to tests such as
boot_linux.py and others), but that was not well accepted.  I can
definitely work on such a version bump again.

>  - Avoid updating image packages (when will RH stop serving them?)

IIUC the only reason for updating the packages is to test the network
from the guest, and could/should be done another way.

Eric, could you confirm this?

>  - The "test" is a fairly basic check of dmesg/sysfs output

Maybe the network is also an implicit check here.  Let's see what Eric
has to say.

>
> I think building a buildroot image with the tools pre-installed (with
> perhaps more testing) would be a better use of our limited test time.
>
> FWIW the runtime on my machine is:
>
> =E2=9E=9C  env QEMU_TEST_FLAKY_TESTS=3D1 ./pyvenv/bin/avocado run ./tests=
/avocado/intel_iommu.py
> JOB ID     : 5c582ccf274f3aee279c2208f969a7af8ceb9943
> JOB LOG    : /home/alex/avocado/job-results/job-2023-12-11T16.53-5c582cc/=
job.log
>  (1/4) ./tests/avocado/intel_iommu.py:IntelIOMMU.test_intel_iommu: PASS (=
44.21 s)
>  (2/4) ./tests/avocado/intel_iommu.py:IntelIOMMU.test_intel_iommu_strict:=
 PASS (78.60 s)
>  (3/4) ./tests/avocado/intel_iommu.py:IntelIOMMU.test_intel_iommu_strict_=
cm: PASS (65.57 s)
>  (4/4) ./tests/avocado/intel_iommu.py:IntelIOMMU.test_intel_iommu_pt: PAS=
S (66.63 s)
> RESULTS    : PASS 4 | ERROR 0 | FAIL 0 | SKIP 0 | WARN 0 | INTERRUPT 0 | =
CANCEL 0
> JOB TIME   : 255.43 s
>

Yes, I've also seen similar runtimes in other environments... so it
looks like it depends a lot on the "dnf -y install numactl-devel".  If
that can be removed, the tests would have much more predictable runtimes.


