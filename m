Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5D4017FC21
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 14:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731317AbgCJNS5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 09:18:57 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35619 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729550AbgCJNSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 09:18:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583846332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HqkYLXoOSEJgynDw8N4DHeJMVb4zEyqqzpvFnSWNRd0=;
        b=SNjqlm/wpyBF3S0pF5Aybn9Jd8oMmxa6G3ZUVlXc2Yeg0LeQDeYuq2ZIBIBU5SX0cXc5jv
        6xyfLMwyP8uDX0yBoaSInACP27uZKLhyDyWGBbOH5TlsQh7bsFyKWzNmxIFnqqU4s7CY/X
        2oJgz93bfypHtiAue3NZXr79dz7//jQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-wMMmc9XiO62w7nY3cWl4kg-1; Tue, 10 Mar 2020 09:18:50 -0400
X-MC-Unique: wMMmc9XiO62w7nY3cWl4kg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB0BD13EA;
        Tue, 10 Mar 2020 13:18:49 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AC948F358;
        Tue, 10 Mar 2020 13:18:43 +0000 (UTC)
Date:   Tue, 10 Mar 2020 14:18:40 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, peterx@redhat.com,
        thuth@redhat.com
Subject: Re: [PATCH 0/4] KVM: selftests: Various cleanups and fixes
Message-ID: <20200310131840.wvmgkli6ed3s366q@kamzik.brq.redhat.com>
References: <20200310091556.4701-1-drjones@redhat.com>
 <1b6d5b6a-f323-14d5-f423-d59547637819@de.ibm.com>
 <20200310115814.fxgbfrxn62zge2jp@kamzik.brq.redhat.com>
 <a801a41c-5b7e-9c01-fc24-02d7f57079ca@de.ibm.com>
 <9d33b783-8911-d638-af34-d69eab3520ef@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9d33b783-8911-d638-af34-d69eab3520ef@de.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 10, 2020 at 01:34:54PM +0100, Christian Borntraeger wrote:
> On 10.03.20 13:29, Christian Borntraeger wrote:
> > I get the following with your patches.
>=20
> And those errors have been there before.=20
> I will provide fixups for sync_regs_test.c and reset.c. So you patch se=
t really has value.

Yeah, another thing I intended to say in the cover-letter, but forgot,
was that I hadn't tested on s390x, and that there was a chance
TEST_ASSERT warnings would be found.

Thanks for fixing them!

drew

>=20
>=20
> >=20
> >=20
> > In file included from s390x/sync_regs_test.c:21:
> > s390x/sync_regs_test.c: In function =E2=80=98compare_sregs=E2=80=99:
> > s390x/sync_regs_test.c:41:7: warning: format =E2=80=98%llx=E2=80=99 e=
xpects argument of type =E2=80=98long long unsigned int=E2=80=99, but arg=
ument 6 has type =E2=80=98__u32=E2=80=99 {aka =E2=80=98unsigned int=E2=80=
=99} [-Wformat=3D]
> >    41 |       "Register " #reg \
> >       |       ^~~~~~~~~~~
> >    42 |       " values did not match: 0x%llx, 0x%llx\n", \
> >    43 |       left->reg, right->reg)
> >       |       ~~~~~~~~~~~~~~~~~~~~~~
> >    44 |=20
> >       |       =20
> >    45 | static void compare_regs(struct kvm_regs *left, struct kvm_sy=
nc_regs *right)
> >       | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~~
> >    46 | {
> >       | ~     =20
> >    47 |  int i;
> >       |  ~~~~~~
> >    48 |=20
> >       |       =20
> >    49 |  for (i =3D 0; i < 16; i++)
> >       |  ~~~~~~~~~~~~~~~~~~~~~~~~
> >    50 |   REG_COMPARE(gprs[i]);
> >       |   ~~~~~~~~~~~~~~~~~~~~~
> >    51 | }
> >       | ~     =20
> >    52 |=20
> >       |       =20
> >    53 | static void compare_sregs(struct kvm_sregs *left, struct kvm_=
sync_regs *right)
> >       | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~~~~
> >    54 | {
> >       | ~     =20
> >    55 |  int i;
> >       |  ~~~~~~
> >    56 |=20
> >       |       =20
> >    57 |  for (i =3D 0; i < 16; i++)
> >       |  ~~~~~~~~~~~~~~~~~~~~~~~~
> >    58 |   REG_COMPARE(acrs[i]);
> >       |   ~~~~~~~~~~~~~~~~~~~
> >       |                   |
> >       |                   __u32 {aka unsigned int}
> > include/test_util.h:46:43: note: in definition of macro =E2=80=98TEST=
_ASSERT=E2=80=99
> >    46 |  test_assert((e), #e, __FILE__, __LINE__, fmt, ##__VA_ARGS__)
> >       |                                           ^~~
> > s390x/sync_regs_test.c:58:3: note: in expansion of macro =E2=80=98REG=
_COMPARE=E2=80=99
> >    58 |   REG_COMPARE(acrs[i]);
> >       |   ^~~~~~~~~~~
> > s390x/sync_regs_test.c:41:7: warning: format =E2=80=98%llx=E2=80=99 e=
xpects argument of type =E2=80=98long long unsigned int=E2=80=99, but arg=
ument 7 has type =E2=80=98__u32=E2=80=99 {aka =E2=80=98unsigned int=E2=80=
=99} [-Wformat=3D]
> >    41 |       "Register " #reg \
> >       |       ^~~~~~~~~~~
> >    42 |       " values did not match: 0x%llx, 0x%llx\n", \
> >    43 |       left->reg, right->reg)
> >       |                  ~~~~~~~~~~~
> >    44 |=20
> >       |       =20
> >    45 | static void compare_regs(struct kvm_regs *left, struct kvm_sy=
nc_regs *right)
> >       | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~~
> >    46 | {
> >       | ~     =20
> >    47 |  int i;
> >       |  ~~~~~~
> >    48 |=20
> >       |       =20
> >    49 |  for (i =3D 0; i < 16; i++)
> >       |  ~~~~~~~~~~~~~~~~~~~~~~~~
> >    50 |   REG_COMPARE(gprs[i]);
> >       |   ~~~~~~~~~~~~~~~~~~~~~
> >    51 | }
> >       | ~     =20
> >    52 |=20
> >       |       =20
> >    53 | static void compare_sregs(struct kvm_sregs *left, struct kvm_=
sync_regs *right)
> >       | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~~~~
> >    54 | {
> >       | ~     =20
> >    55 |  int i;
> >       |  ~~~~~~
> >    56 |=20
> >       |       =20
> >    57 |  for (i =3D 0; i < 16; i++)
> >       |  ~~~~~~~~~~~~~~~~~~~~~~~~
> >    58 |   REG_COMPARE(acrs[i]);
> >       |   ~~~~~~~~~~~~~~~~~~~
> >       |                   |
> >       |                   __u32 {aka unsigned int}
> > include/test_util.h:46:43: note: in definition of macro =E2=80=98TEST=
_ASSERT=E2=80=99
> >    46 |  test_assert((e), #e, __FILE__, __LINE__, fmt, ##__VA_ARGS__)
> >       |                                           ^~~
> > s390x/sync_regs_test.c:58:3: note: in expansion of macro =E2=80=98REG=
_COMPARE=E2=80=99
> >    58 |   REG_COMPARE(acrs[i]);
> >       |   ^~~~~~~~~~~
> > s390x/sync_regs_test.c: In function =E2=80=98main=E2=80=99:
> > s390x/sync_regs_test.c:158:7: warning: format =E2=80=98%llx=E2=80=99 =
expects argument of type =E2=80=98long long unsigned int=E2=80=99, but ar=
gument 6 has type =E2=80=98__u32=E2=80=99 {aka =E2=80=98unsigned int=E2=80=
=99} [-Wformat=3D]
> >   158 |       "acr0 sync regs value incorrect 0x%llx.",
> >       |       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >   159 |       run->s.regs.acrs[0]);
> >       |       ~~~~~~~~~~~~~~~~~~~
> >       |                       |
> >       |                       __u32 {aka unsigned int}
> > include/test_util.h:46:43: note: in definition of macro =E2=80=98TEST=
_ASSERT=E2=80=99
> >    46 |  test_assert((e), #e, __FILE__, __LINE__, fmt, ##__VA_ARGS__)
> >       |                                           ^~~
> > s390x/sync_regs_test.c:158:44: note: format string is defined here
> >   158 |       "acr0 sync regs value incorrect 0x%llx.",
> >       |                                         ~~~^
> >       |                                            |
> >       |                                            long long unsigned=
 int
> >       |     =20
> >=20
> >=20
> >=20
> > On 10.03.20 12:58, Andrew Jones wrote:
> >> On Tue, Mar 10, 2020 at 10:45:43AM +0100, Christian Borntraeger wrot=
e:
> >>> On 10.03.20 10:15, Andrew Jones wrote:
> >>>>
> >>>> Andrew Jones (4):
> >>>>   fixup! selftests: KVM: SVM: Add vmcall test
> >>>>   KVM: selftests: Share common API documentation
> >>>>   KVM: selftests: Enable printf format warnings for TEST_ASSERT
> >>>>   KVM: selftests: Use consistent message for test skipping
> >>>
> >>> This looks like a nice cleanup but this does not seem to apply
> >>> cleanly on kvm/master or linus/master. Which tree is this based on?
> >>
> >> This is based on kvm/queue. Sorry, I should have mentioned that in
> >> the cover letter.
> >>
> >> Thanks,
> >> drew
> >>
> >>>
> >>>>
> >>>>  tools/testing/selftests/kvm/.gitignore        |   5 +-
> >>>>  .../selftests/kvm/demand_paging_test.c        |   6 +-
> >>>>  tools/testing/selftests/kvm/dirty_log_test.c  |   3 +-
> >>>>  .../testing/selftests/kvm/include/kvm_util.h  | 100 ++++++++-
> >>>>  .../testing/selftests/kvm/include/test_util.h |   5 +-
> >>>>  .../selftests/kvm/lib/aarch64/processor.c     |  17 --
> >>>>  tools/testing/selftests/kvm/lib/assert.c      |   6 +-
> >>>>  tools/testing/selftests/kvm/lib/kvm_util.c    |  10 +-
> >>>>  .../selftests/kvm/lib/kvm_util_internal.h     |  48 +++++
> >>>>  .../selftests/kvm/lib/s390x/processor.c       |  74 -------
> >>>>  tools/testing/selftests/kvm/lib/test_util.c   |  12 ++
> >>>>  .../selftests/kvm/lib/x86_64/processor.c      | 196 ++++---------=
-----
> >>>>  tools/testing/selftests/kvm/lib/x86_64/svm.c  |   2 +-
> >>>>  tools/testing/selftests/kvm/lib/x86_64/vmx.c  |   2 +-
> >>>>  tools/testing/selftests/kvm/s390x/memop.c     |   2 +-
> >>>>  .../selftests/kvm/s390x/sync_regs_test.c      |   2 +-
> >>>>  .../kvm/x86_64/cr4_cpuid_sync_test.c          |   2 +-
> >>>>  .../testing/selftests/kvm/x86_64/evmcs_test.c |   6 +-
> >>>>  .../selftests/kvm/x86_64/hyperv_cpuid.c       |   8 +-
> >>>>  .../selftests/kvm/x86_64/mmio_warning_test.c  |   4 +-
> >>>>  .../selftests/kvm/x86_64/platform_info_test.c |   3 +-
> >>>>  .../kvm/x86_64/set_memory_region_test.c       |   3 +-
> >>>>  .../testing/selftests/kvm/x86_64/state_test.c |   4 +-
> >>>>  .../selftests/kvm/x86_64/svm_vmcall_test.c    |   3 +-
> >>>>  .../selftests/kvm/x86_64/sync_regs_test.c     |   4 +-
> >>>>  .../selftests/kvm/x86_64/vmx_dirty_log_test.c |   2 +-
> >>>>  .../kvm/x86_64/vmx_set_nested_state_test.c    |   4 +-
> >>>>  .../selftests/kvm/x86_64/xss_msr_test.c       |   2 +-
> >>>>  28 files changed, 243 insertions(+), 292 deletions(-)
> >>>>
> >>>
> >>
> >=20
>=20

