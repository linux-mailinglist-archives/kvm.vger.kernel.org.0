Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8B970C883
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 21:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235043AbjEVTjd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 15:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235026AbjEVTja (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 15:39:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C991B9
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 12:39:22 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34MJ6Z4q017391;
        Mon, 22 May 2023 19:39:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=P4Xs7QboHw/CQaP/yo4jHq9pDQ53+9Cq43ieDddVmS0=;
 b=PMcwpXrU62ps6UiGLuj6AY24CqQ7oat/1GSR9g/77/LvDsT8TDE+bWffrYzhmEtHYhsg
 QF6p8J8fndqpnjmeY+a0/jRayBabj1QsTuJza528wu8/evFQukB3CsKsg5IqSxUbPUYV
 lTC87iwnZs80ol+jduZfDSd3jr0RHon1A7XQT1q2Z+3DM8FCCz4JbPWfJQ+VxV41AoG2
 TAmS3XyqV6ob5Rf4FR+B43/HfSrA1OxB2n4U+REkyckv0H74bChh/THuIIneUzn93DWh
 sHwmG7ItWI50BoPKJxy6HXgrjncFpCQi8QAe4RluSmZbmalrBUOqu+eyhFOU9podXUzo aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qrdyt18u6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 May 2023 19:39:07 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34MJ7ojI022050;
        Mon, 22 May 2023 19:39:06 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qrdyt18sy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 May 2023 19:39:06 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34M3M6Cp013903;
        Mon, 22 May 2023 19:39:04 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qppdk140m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 May 2023 19:39:03 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34MJcwBf62783836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 May 2023 19:38:58 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24D552004B;
        Mon, 22 May 2023 19:38:58 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A90620040;
        Mon, 22 May 2023 19:38:57 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.42.164])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 22 May 2023 19:38:56 +0000 (GMT)
Message-ID: <6f0f0bb9f9f7aa48cbb6c60629a0a83ef722970a.camel@linux.ibm.com>
Subject: Re: [PATCH v20 14/21] tests/avocado: s390x cpu topology core
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Mon, 22 May 2023 21:38:56 +0200
In-Reply-To: <20230425161456.21031-15-pmorel@linux.ibm.com>
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
         <20230425161456.21031-15-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kfwwFOPyXCY0LnFH_5iwv90OgzyNDEig
X-Proofpoint-GUID: lUiF2TUwsYFr9pWud_x6kdNOTpOn_fUH
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-22_14,2023-05-22_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 impostorscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 mlxlogscore=999 bulkscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305220165
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-04-25 at 18:14 +0200, Pierre Morel wrote:
> Introduction of the s390x cpu topology core functions and
> basic tests.
>=20
> We test the corelation between the command line and
> the QMP results in query-cpus-fast for various CPU topology.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  MAINTAINERS                    |   1 +
>  tests/avocado/s390_topology.py | 208 +++++++++++++++++++++++++++++++++
>  2 files changed, 209 insertions(+)
>  create mode 100644 tests/avocado/s390_topology.py
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fe5638e31d..41419840b0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1662,6 +1662,7 @@ F: hw/s390x/cpu-topology.c
>  F: target/s390x/kvm/cpu_topology.c
>  F: docs/devel/s390-cpu-topology.rst
>  F: docs/system/s390x/cpu-topology.rst
> +F: tests/avocado/s390_topology.py
>=20=20
>  X86 Machines
>  ------------
> diff --git a/tests/avocado/s390_topology.py b/tests/avocado/s390_topology=
.py
> new file mode 100644
> index 0000000000..ce119a095e
> --- /dev/null
> +++ b/tests/avocado/s390_topology.py
> @@ -0,0 +1,208 @@
> +# Functional test that boots a Linux kernel and checks the console
> +#
> +# Copyright IBM Corp. 2023
> +#
> +# Author:
> +#  Pierre Morel <pmorel@linux.ibm.com>
> +#
> +# This work is licensed under the terms of the GNU GPL, version 2 or
> +# later.  See the COPYING file in the top-level directory.
> +
> +import os
> +import shutil
> +import time
> +
> +from avocado_qemu import QemuSystemTest
> +from avocado_qemu import exec_command
> +from avocado_qemu import exec_command_and_wait_for_pattern
> +from avocado_qemu import interrupt_interactive_console_until_pattern
> +from avocado_qemu import wait_for_console_pattern
> +from avocado.utils import process
> +from avocado.utils import archive
> +
> +
> +class LinuxKernelTest(QemuSystemTest):

I'd get rid of this class, unless you plan to use it for more children.

> +    KERNEL_COMMON_COMMAND_LINE =3D 'printk.time=3D0 '
> +
> +    def wait_for_console_pattern(self, success_message, vm=3DNone):

You always use the same args for this function, I'd refactor it into
def wait_until_booted(self):

> +        wait_for_console_pattern(self, success_message,
> +                                 failure_message=3D'Kernel panic - not s=
yncing',
> +                                 vm=3Dvm)
> +
> +
> +class S390CPUTopology(LinuxKernelTest):
> +    """
> +    S390x CPU topology consist of 4 topology layers, from bottom to top,
> +    the cores, sockets, books and drawers and 2 modifiers attributes,
> +    the entitlement and the dedication.
> +    See: docs/system/s390x/cpu-topology.rst.
> +
> +    S390x CPU topology is setup in different ways:
> +    - implicitely from the '-smp' argument by completing each topology
> +      level one after the other begining with drawer 0, book 0 and socke=
t 0.
> +    - explicitely from the '-device' argument on the QEMU command line
> +    - explicitely by hotplug of a new CPU using QMP or HMP
> +    - it is modified by using QMP 'set-cpu-topology'
> +
> +    The S390x modifier attribute entitlement depends on the machine
> +    polarization, which can be horizontal or vertical.
> +    The polarization is changed on a request from the guest.
> +    """
> +    timeout =3D 90
> +
> +
> +    def check_topology(self, c, s, b, d, e, t):
> +        res =3D self.vm.qmp('query-cpus-fast')
> +        line =3D  res['return']
> +        for x in line:

for cpu in cpus

> +            core =3D x['props']['core-id']
> +            socket =3D x['props']['socket-id']
> +            book =3D x['props']['book-id']
> +            drawer =3D x['props']['drawer-id']
> +            entitlement =3D x['entitlement']
> +            dedicated =3D x['dedicated']
> +            if core =3D=3D c:
> +                self.assertEqual(drawer, d)
> +                self.assertEqual(book, b)
> +                self.assertEqual(socket, s)
> +                self.assertEqual(entitlement, e)
> +                self.assertEqual(dedicated, t)
> +
> +    def kernel_init(self):
> +        """
> +        We need a kernel supporting the CPU topology.
> +        We need a minimal root filesystem with a shell.
> +        """
> +        kernel_url =3D ('https://archives.fedoraproject.org/pub/archive'
> +                      '/fedora-secondary/releases/35/Server/s390x/os'
> +                      '/images/kernel.img')
> +        kernel_hash =3D '0d1aaaf303f07cf0160c8c48e56fe638'
> +        kernel_path =3D self.fetch_asset(kernel_url, algorithm=3D'md5',
> +                                       asset_hash=3Dkernel_hash)
> +
> +        initrd_url =3D ('https://archives.fedoraproject.org/pub/archive'
> +                      '/fedora-secondary/releases/35/Server/s390x/os'
> +                      '/images/initrd.img')
> +        initrd_hash =3D 'a122057d95725ac030e2ec51df46e172'
> +        initrd_path_xz =3D self.fetch_asset(initrd_url, algorithm=3D'md5=
',
> +                                          asset_hash=3Dinitrd_hash)
> +        initrd_path =3D os.path.join(self.workdir, 'initrd-raw.img')
> +        archive.lzma_uncompress(initrd_path_xz, initrd_path)
> +
> +        self.vm.set_console()
> +        kernel_command_line =3D (self.KERNEL_COMMON_COMMAND_LINE +
> +                              'root=3D/dev/ram '
> +                              'selinux=3D0 '
> +                              'rdinit=3D/bin/sh')
> +        self.vm.add_args('-nographic',
> +                         '-enable-kvm',
> +                         '-cpu', 'z14,ctop=3Don',
> +                         '-m', '512',
> +                         '-name', 'Some Guest Name',
> +                         '-uuid', '30de4fd9-b4d5-409e-86a5-09b387f70bfa',

What is the meaning of those flags (name & uuid), do you need them?
Where does the value for the uuid come from?

> +                         '-kernel', kernel_path,
> +                         '-initrd', initrd_path,
> +                         '-append', kernel_command_line)
> +
> +    def test_single(self):

Why no comment and avocado tags here?

> +        self.kernel_init()
> +        self.vm.launch()
> +        self.wait_for_console_pattern('no job control')
> +        self.check_topology(0, 0, 0, 0, 'medium', False)
> +
> +    def test_default(self):
> +        """
> +        This test checks the implicite topology.

s/implicite/implicit/

> +
> +        :avocado: tags=3Darch:s390x
> +        :avocado: tags=3Dmachine:s390-ccw-virtio
> +        """
> +        self.kernel_init()
> +        self.vm.add_args('-smp',
> +                         '13,drawers=3D2,books=3D2,sockets=3D3,cores=3D2=
,maxcpus=3D24')
> +        self.vm.launch()
> +        self.wait_for_console_pattern('no job control')
> +        self.check_topology(0, 0, 0, 0, 'medium', False)
> +        self.check_topology(1, 0, 0, 0, 'medium', False)
> +        self.check_topology(2, 1, 0, 0, 'medium', False)
> +        self.check_topology(3, 1, 0, 0, 'medium', False)
> +        self.check_topology(4, 2, 0, 0, 'medium', False)
> +        self.check_topology(5, 2, 0, 0, 'medium', False)
> +        self.check_topology(6, 0, 1, 0, 'medium', False)
> +        self.check_topology(7, 0, 1, 0, 'medium', False)
> +        self.check_topology(8, 1, 1, 0, 'medium', False)
> +        self.check_topology(9, 1, 1, 0, 'medium', False)
> +        self.check_topology(10, 2, 1, 0, 'medium', False)
> +        self.check_topology(11, 2, 1, 0, 'medium', False)
> +        self.check_topology(12, 0, 0, 1, 'medium', False)
> +
> +    def test_move(self):
> +        """
> +        This test checks the topology modification by moving a CPU
> +        to another socket: CPU 0 is moved from socket 0 to socket 2.
> +
> +        :avocado: tags=3Darch:s390x
> +        :avocado: tags=3Dmachine:s390-ccw-virtio
> +        """
> +        self.kernel_init()
> +        self.vm.add_args('-smp',
> +                         '1,drawers=3D2,books=3D2,sockets=3D3,cores=3D2,=
maxcpus=3D24')
> +        self.vm.launch()
> +        self.wait_for_console_pattern('no job control')
> +
> +        self.check_topology(0, 0, 0, 0, 'medium', False)
> +        res =3D self.vm.qmp('set-cpu-topology',
> +                          {'core-id': 0, 'socket-id': 2, 'entitlement': =
'low'})
> +        self.assertEqual(res['return'], {})
> +        self.check_topology(0, 2, 0, 0, 'low', False)
> +
> +    def test_hotplug(self):
> +        """
> +        This test verifies that a CPU defined with '-device' command line
> +        argument finds its right place inside the topology.
> +
> +        :avocado: tags=3Darch:s390x
> +        :avocado: tags=3Dmachine:s390-ccw-virtio
> +        """
> +        self.kernel_init()
> +        self.vm.add_args('-smp',
> +                         '1,drawers=3D2,books=3D2,sockets=3D3,cores=3D2,=
maxcpus=3D24')
> +        self.vm.add_args('-device', 'z14-s390x-cpu,core-id=3D10')
> +        self.vm.launch()
> +        self.wait_for_console_pattern('no job control')
> +
> +        self.check_topology(10, 2, 1, 0, 'medium', False)
> +
> +    def test_hotplug_full(self):

I would unite this test with the previous one.
Both test -device with some values missing.

> +        """
> +        This test verifies that a hotplugged fully defined with '-device'
> +        command line argument finds its right place inside the topology.
> +
> +        :avocado: tags=3Darch:s390x
> +        :avocado: tags=3Dmachine:s390-ccw-virtio
> +        """
> +        self.kernel_init()
> +        self.vm.add_args('-smp',
> +                         '1,drawers=3D2,books=3D2,sockets=3D3,cores=3D2,=
maxcpus=3D24')
> +        self.vm.add_args('-device',
> +                         'z14-s390x-cpu,'
> +                         'core-id=3D1,socket-id=3D0,book-id=3D1,drawer-i=
d=3D1,entitlement=3Dlow')
> +        self.vm.add_args('-device',
> +                         'z14-s390x-cpu,'
> +                         'core-id=3D2,socket-id=3D0,book-id=3D1,drawer-i=
d=3D1,entitlement=3Dmedium')
> +        self.vm.add_args('-device',
> +                         'z14-s390x-cpu,'
> +                         'core-id=3D3,socket-id=3D1,book-id=3D1,drawer-i=
d=3D1,entitlement=3Dhigh')
> +        self.vm.add_args('-device',
> +                         'z14-s390x-cpu,'
> +                         'core-id=3D4,socket-id=3D1,book-id=3D1,drawer-i=
d=3D1')
> +        self.vm.add_args('-device',
> +                         'z14-s390x-cpu,'
> +                         'core-id=3D5,socket-id=3D2,book-id=3D1,drawer-i=
d=3D1,dedicated=3Dtrue')
> +        self.vm.launch()
> +        self.wait_for_console_pattern('no job control')
> +        self.check_topology(1, 0, 1, 1, 'low', False)
> +        self.check_topology(2, 0, 1, 1, 'medium', False)
> +        self.check_topology(3, 1, 1, 1, 'high', False)
> +        self.check_topology(4, 1, 1, 1, 'medium', False)
> +        self.check_topology(5, 2, 1, 1, 'high', True)

Looks good all in all.

