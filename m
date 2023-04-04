Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB516D5BBC
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 11:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbjDDJV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 05:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbjDDJVz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 05:21:55 -0400
Received: from 5.mo552.mail-out.ovh.net (5.mo552.mail-out.ovh.net [188.165.45.220])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F07619BD
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 02:21:51 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.109.143.128])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id E61502BF98;
        Tue,  4 Apr 2023 09:21:48 +0000 (UTC)
Received: from kaod.org (37.59.142.105) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 4 Apr
 2023 11:21:47 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-105G006f0ba9e0a-fd1e-49ca-89d0-744390275a7a,
                    85507D0075A56E5AD4EA03BF56E5282CC2D8C3A6) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <2b678e7d-488d-0072-2b27-cd54a43a77b2@kaod.org>
Date:   Tue, 4 Apr 2023 11:21:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v19 14/21] tests/avocado: s390x cpu topology core
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, <qemu-s390x@nongnu.org>
CC:     <qemu-devel@nongnu.org>, <borntraeger@de.ibm.com>,
        <pasic@linux.ibm.com>, <richard.henderson@linaro.org>,
        <david@redhat.com>, <thuth@redhat.com>, <cohuck@redhat.com>,
        <mst@redhat.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <ehabkost@redhat.com>, <marcel.apfelbaum@gmail.com>,
        <eblake@redhat.com>, <armbru@redhat.com>, <seiden@linux.ibm.com>,
        <nrb@linux.ibm.com>, <nsg@linux.ibm.com>, <frankja@linux.ibm.com>,
        <berrange@redhat.com>
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
 <20230403162905.17703-15-pmorel@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20230403162905.17703-15-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.105]
X-ClientProxiedBy: DAG7EX1.mxp5.local (172.16.2.61) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: 169117bf-40cd-4a3c-b458-167f6f73052e
X-Ovh-Tracer-Id: 17017977094534368211
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeiledgudegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgihesthejredttdefjeenucfhrhhomhepveorughrihgtucfnvgcuifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeevgeekheeguedvtdfhueeuueetgfdvueffheejjeffkeevjeffudejieefjeekieenucffohhmrghinhepfhgvughorhgrphhrohhjvggtthdrohhrghenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddthedpkedvrdeigedrvdehtddrudejtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoegtlhhgsehkrghougdrohhrgheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepphhmohhrvghlsehlihhnuhigrdhisghmrdgtohhmpdhnshhgsehlihhnuhigrdhisghmrdgtohhmpdhnrhgssehlihhnuhigrdhisghmrdgtohhmpdhsvghiuggvnheslhhinhhugidrihgsmhdrtghomhdprghrmhgsrhhusehrvgguhhgrthdrtghomhdpvggslhgrkhgvsehrvgguhhgrthdrtghomhdpmhgrrhgtvghlrdgrphhfvghlsggruhhmsehgmhgrihhlrdgtohhmpd
 gvhhgrsghkohhsthesrhgvughhrghtrdgtohhmpdhkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhfrhgrnhhkjhgrsehlihhnuhigrdhisghmrdgtohhmpdhpsghonhiiihhnihesrhgvughhrghtrdgtohhmpdgtohhhuhgtkhesrhgvughhrghtrdgtohhmpdhthhhuthhhsehrvgguhhgrthdrtghomhdpuggrvhhiugesrhgvughhrghtrdgtohhmpdhrihgthhgrrhgurdhhvghnuggvrhhsohhnsehlihhnrghrohdrohhrghdpphgrshhitgeslhhinhhugidrihgsmhdrtghomhdpsghorhhnthhrrggvghgvrhesuggvrdhisghmrdgtohhmpdhqvghmuhdquggvvhgvlhesnhhonhhgnhhurdhorhhgpdhqvghmuhdqshefledtgiesnhhonhhgnhhurdhorhhgpdhmshhtsehrvgguhhgrthdrtghomhdpsggvrhhrrghnghgvsehrvgguhhgrthdrtghomhdpoffvtefjohhsthepmhhoheehvddpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-1.9 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/3/23 18:28, Pierre Morel wrote:
> Introduction of the s390x cpu topology core functions and
> basic tests.
> 
> We test the corelation between the command line and
> the QMP results in query-cpus-fast for various CPU topology.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

I gave the tests a run on a z LPAR. Nice job !

I hope we can maintain the avocado framework to the level of
expectations. I find it very useful for such test cases.

Thanks,

C.


> ---
>   MAINTAINERS                    |   1 +
>   tests/avocado/s390_topology.py | 196 +++++++++++++++++++++++++++++++++
>   2 files changed, 197 insertions(+)
>   create mode 100644 tests/avocado/s390_topology.py
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fe5638e31d..41419840b0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1662,6 +1662,7 @@ F: hw/s390x/cpu-topology.c
>   F: target/s390x/kvm/cpu_topology.c
>   F: docs/devel/s390-cpu-topology.rst
>   F: docs/system/s390x/cpu-topology.rst
> +F: tests/avocado/s390_topology.py
>   
>   X86 Machines
>   ------------
> diff --git a/tests/avocado/s390_topology.py b/tests/avocado/s390_topology.py
> new file mode 100644
> index 0000000000..38e9cc4f16
> --- /dev/null
> +++ b/tests/avocado/s390_topology.py
> @@ -0,0 +1,196 @@
> +# Functional test that boots a Linux kernel and checks the console
> +#
> +# Copyright (c) 2023 IBM Corp.
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
> +from avocado import skip
> +from avocado import skipUnless
> +from avocado import skipIf
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
> +    KERNEL_COMMON_COMMAND_LINE = 'printk.time=0 '
> +
> +    def wait_for_console_pattern(self, success_message, vm=None):
> +        wait_for_console_pattern(self, success_message,
> +                                 failure_message='Kernel panic - not syncing',
> +                                 vm=vm)
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
> +      level one after the other begining with drawer 0, book 0 and socket 0.
> +    - explicitely from the '-device' argument on the QEMU command line
> +    - explicitely by hotplug of a new CPU using QMP or HMP
> +    - it is modified by using QMP 'set-cpu-topology'
> +
> +    The S390x modifier attribute entitlement depends on the machine
> +    polarization, which can be horizontal or vertical.
> +    The polarization is changed on a request from the guest.
> +    """
> +    timeout = 90
> +
> +
> +    def check_topology(self, c, s, b, d, e, t):
> +        res = self.vm.qmp('query-cpus-fast')
> +        line =  res['return']
> +        for x in line:
> +            core = x['props']['core-id']
> +            socket = x['props']['socket-id']
> +            book = x['props']['book-id']
> +            drawer = x['props']['drawer-id']
> +            entitlement = x['entitlement']
> +            dedicated = x['dedicated']
> +            if core == c:
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
> +        kernel_url = ('https://archives.fedoraproject.org/pub/archive'
> +                      '/fedora-secondary/releases/35/Server/s390x/os'
> +                      '/images/kernel.img')
> +        kernel_hash = '0d1aaaf303f07cf0160c8c48e56fe638'
> +        kernel_path = self.fetch_asset(kernel_url, algorithm='md5',
> +                                       asset_hash=kernel_hash)
> +
> +        initrd_url = ('https://archives.fedoraproject.org/pub/archive'
> +                      '/fedora-secondary/releases/35/Server/s390x/os'
> +                      '/images/initrd.img')
> +        initrd_hash = 'a122057d95725ac030e2ec51df46e172'
> +        initrd_path_xz = self.fetch_asset(initrd_url, algorithm='md5',
> +                                          asset_hash=initrd_hash)
> +        initrd_path = os.path.join(self.workdir, 'initrd-raw.img')
> +        archive.lzma_uncompress(initrd_path_xz, initrd_path)
> +
> +        self.vm.set_console()
> +        kernel_command_line = (self.KERNEL_COMMON_COMMAND_LINE +
> +                              'root=/dev/ram '
> +                              'selinux=0 '
> +                              'rdinit=/bin/sh')
> +        self.vm.add_args('-nographic',
> +                         '-enable-kvm',
> +                         '-cpu', 'z14,ctop=on',
> +                         '-m', '512',
> +                         '-name', 'Some Guest Name',
> +                         '-uuid', '30de4fd9-b4d5-409e-86a5-09b387f70bfa',
> +                         '-kernel', kernel_path,
> +                         '-initrd', initrd_path,
> +                         '-append', kernel_command_line)
> +
> +    def test_single(self):
> +        self.kernel_init()
> +        self.vm.launch()
> +        self.wait_for_console_pattern('no job control')
> +        self.check_topology(0, 0, 0, 0, 'medium', False)
> +
> +    def test_default(self):
> +        """
> +        This test checks the implicite topology.
> +
> +        :avocado: tags=arch:s390x
> +        :avocado: tags=machine:s390-ccw-virtio
> +        """
> +        self.kernel_init()
> +        self.vm.add_args('-smp',
> +                         '13,drawers=2,books=2,sockets=3,cores=2,maxcpus=24')
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
> +        :avocado: tags=arch:s390x
> +        :avocado: tags=machine:s390-ccw-virtio
> +        """
> +        self.kernel_init()
> +        self.vm.add_args('-smp',
> +                         '1,drawers=2,books=2,sockets=3,cores=2,maxcpus=24')
> +        self.vm.launch()
> +        self.wait_for_console_pattern('no job control')
> +
> +        self.check_topology(0, 0, 0, 0, 'medium', False)
> +        res = self.vm.qmp('set-cpu-topology',
> +                          {'core-id': 0, 'socket-id': 2, 'entitlement': 'low'})
> +        self.assertEqual(res['return'], {})
> +        self.check_topology(0, 2, 0, 0, 'low', False)
> +
> +    def test_hotplug(self):
> +        """
> +        This test verifies that a CPU defined with '-device' command line
> +        argument finds its right place inside the topology.
> +
> +        :avocado: tags=arch:s390x
> +        :avocado: tags=machine:s390-ccw-virtio
> +        """
> +        self.kernel_init()
> +        self.vm.add_args('-smp',
> +                         '1,drawers=2,books=2,sockets=3,cores=2,maxcpus=24')
> +        self.vm.add_args('-device', 'z14-s390x-cpu,core-id=10')
> +        self.vm.launch()
> +        self.wait_for_console_pattern('no job control')
> +
> +        self.check_topology(10, 2, 1, 0, 'medium', False)
> +
> +    def test_hotplug_full(self):
> +        """
> +        This test verifies that a hotplugged fully defined with '-device'
> +        command line argument finds its right place inside the topology.
> +
> +        :avocado: tags=arch:s390x
> +        :avocado: tags=machine:s390-ccw-virtio
> +        """
> +        self.kernel_init()
> +        self.vm.add_args('-smp',
> +                         '1,drawers=2,books=2,sockets=3,cores=2,maxcpus=24')
> +        self.vm.add_args('-device',
> +                         'z14-s390x-cpu,'
> +                         'core-id=1,socket-id=1,book-id=1,drawer-id=1')
> +        self.vm.launch()
> +        self.wait_for_console_pattern('no job control')
> +        self.check_topology(1, 1, 1, 1, 'medium', False)
> +

