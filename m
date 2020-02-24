Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24EE616A909
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 15:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbgBXO7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 09:59:50 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59186 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727498AbgBXO7u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 09:59:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582556388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hhv8Lj1Q/vo713v/O+DLWAY1CyldXIo4jLsHxDawi6E=;
        b=hTYx9GIqs/grkuhpySCyxxlXIuInCaA8rkrNTZXMzsO3t177KZD2007Y3oEaR7LCFIxfPk
        P3wH9JiDg/+iGFw3Yjmi8waytAWrwwU2sCD8OHbvf75j6QZ2VWT3VrfHGiQC/etjR2PWMe
        hd/QzBywzjYODsE+Ju6s/JFTmz517YU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-2SIo3hKFPXOoCc5Q5wo53Q-1; Mon, 24 Feb 2020 09:59:43 -0500
X-MC-Unique: 2SIo3hKFPXOoCc5Q5wo53Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8576102C861;
        Mon, 24 Feb 2020 14:59:41 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BE9F10027AE;
        Mon, 24 Feb 2020 14:59:39 +0000 (UTC)
Date:   Mon, 24 Feb 2020 15:59:36 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        kvm list <kvm@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>, yzt356@gmail.com,
        jmattson@google.com, Paolo Bonzini <pbonzini@redhat.com>,
        namit@vmware.com, sean.j.christopherson@intel.com,
        Basil Eljuse <Basil.Eljuse@arm.com>
Subject: Re: kvm-unit-tests : Kconfigs and extra kernel args for full coverage
Message-ID: <20200224145936.mzpwveaoijjmb5ql@kamzik.brq.redhat.com>
References: <CA+G9fYvx=WzyJqS4fUFLq8qXT8nbFQoFfXZoeL9kP-hvv549EA@mail.gmail.com>
 <c82f4386-702f-a2e9-a4d7-d5ebb1f335d1@arm.com>
 <20200224133818.gtxtrmzo4y4guk4z@kamzik.brq.redhat.com>
 <adf05c0d-6a19-da06-5e41-da63b0d0d8d8@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <adf05c0d-6a19-da06-5e41-da63b0d0d8d8@arm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 24, 2020 at 01:47:44PM +0000, Alexandru Elisei wrote:
> Hi,
>=20
> On 2/24/20 1:38 PM, Andrew Jones wrote:
> > On Mon, Feb 24, 2020 at 01:21:23PM +0000, Alexandru Elisei wrote:
> >> Hi Naresh,
> >>
> >> On 2/24/20 12:53 PM, Naresh Kamboju wrote:
> >>> [Sorry for the spam]
> >>>
> >>> Greeting from Linaro !
> >>> We are running kvm-unit-tests on our CI Continuous Integration and
> >>> testing on x86_64 and arm64 Juno-r2.
> >>> Linux stable branches and Linux mainline and Linux next.
> >>>
> >>> Few tests getting fail and skipped, we are interested in increasing=
 the
> >>> test coverage by adding required kernel config fragments,
> >>> kernel command line arguments and user space tools.
> >>>
> >>> Your help is much appreciated.
> >>>
> >>> Here is the details of the LKFT kvm unit test logs,
> >>>
> >>> [..]
> >> I am going to comment on the arm64 tests. As far as I am aware, you =
don't need any
> >> kernel configs to run the tests.
> >>
> >> From looking at the java log [1], I can point out a few things:
> >>
> >> - The gicv3 tests are failing because Juno has a gicv2 and the kerne=
l refuses to
> >> create a virtual gicv3. It's normal.
> > Yup
> >
> >> - I am not familiar with the PMU test, so I cannot help you with tha=
t.
> > Where is the output from running the PMU test? I didn't see it in the=
 link
> > below.
>=20
> It's toward the end, it just says that 2 tests failed:

If the test runner isn't capturing all the output of the tests somewhere,
then it should. Naresh, is the pmu.log file somewhere?

Thanks,
drew

>=20
> |TESTNAME=3Dpmu TIMEOUT=3D90s ACCEL=3D ./arm/run arm/pmu.flat -smp 1|
> |[31mFAIL[0m pmu (3 tests, 2 unexpected failures)|
> >
> >> - Without the logs, it's hard for me to say why the micro-bench test=
 is failing.
> >> Can you post the logs for that particular run? They are located in
> >> /path/to/kvm-unit-tests/logs/micro-bench.log. My guess is that it ha=
s to do with
> >> the fact that you are using taskset to keep the tests on one CPU. Mi=
cro-bench will
> >> use 2 VCPUs to send 2^28 IPIs which will run on the same physical CP=
U, and sending
> >> and receiving them will be serialized which will incur a *lot* of ov=
erhead. I
> >> tried the same test without taskset, and it worked. With taskset -c =
0, it timed
> >> out like in your log.
> > We've also had "failures" of the micro-bench test when run under avoc=
ado
> > reported. The problem was/is the assert_msg() on line 107 is firing. =
We
> > could probably increase the number of tries or change the assert to a
> > warning. Of course micro-bench isn't a "test" anyway so it can't "fai=
l".
> > Well, not unless one goes through the trouble of preparing expected t=
imes
> > for each measurement for a given host and then compares new results t=
o
> > those expectations. Then it could fail when the results are too large
> > (some threshold must be defined too).
>=20
> That happens to me too on occasions when running under kvmtool. When it=
 does I
> just rerun the test and it passes almost always. But I think that's not=
 the case
> here, since the test times out:
>=20
> |TESTNAME=3Dmicro-bench TIMEOUT=3D90s ACCEL=3Dkvm ./arm/run arm/micro-b=
ench.flat -smp 2|
> |[31mFAIL[0m micro-bench (timeout; duration=3D90s)|
>=20
> I tried it and I got the same message, and the in the log:
>=20
> $ cat logs/micro-bench.log
> timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64 -nodefaults=
 -machine
> virt,gic-version=3Dhost,accel=3Dkvm -cpu host -device virtio-serial-dev=
ice -device
> virtconsole,chardev=3Dctd -chardev testdev,id=3Dctd -device pci-testdev=
 -display none
> -serial stdio -kernel arm/micro-bench.flat -smp 2 # -initrd /tmp/tmp.XX=
OYQIrjIM
> Timer Frequency 40000000 Hz (Output in microseconds)
>=20
> name=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 total ns=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 avg
> ns=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> -----------------------------------------------------------------------=
---------------------
> hvc=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 87727475.0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> 1338.0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> mmio_read_user=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 348083225.0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0
> 5311.0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> mmio_read_vgic=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 125456300.0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0
> 1914.0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> eoi=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 820875.0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> 12.0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> qemu-system-aarch64: terminating on signal 15 from pid 23273 (timeout)
>=20
> Thanks,
> Alex
>=20

