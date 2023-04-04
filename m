Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4D16D5C14
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 11:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbjDDJiq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 05:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234280AbjDDJin (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 05:38:43 -0400
Received: from 1.mo552.mail-out.ovh.net (1.mo552.mail-out.ovh.net [178.32.96.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F337319BC
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 02:38:27 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.109.143.103])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 5CEC62BFCA;
        Tue,  4 Apr 2023 09:22:29 +0000 (UTC)
Received: from kaod.org (37.59.142.103) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 4 Apr
 2023 11:22:28 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-103G0054cd988ad-d4e0-4a68-815e-4da39195e32a,
                    85507D0075A56E5AD4EA03BF56E5282CC2D8C3A6) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <0a5daba1-16df-cd01-f0fb-c6b9cccb04d3@kaod.org>
Date:   Tue, 4 Apr 2023 11:22:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v19 15/21] tests/avocado: s390x cpu topology polarisation
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
 <20230403162905.17703-16-pmorel@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20230403162905.17703-16-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.103]
X-ClientProxiedBy: DAG7EX2.mxp5.local (172.16.2.62) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: 00c44b89-e119-4cc6-a75b-6aa42af93303
X-Ovh-Tracer-Id: 17029517567254367187
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeiledgudegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgihesthejredttdefjeenucfhrhhomhepveorughrihgtucfnvgcuifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeetgeetfffgvefhgfdviefgtdevffettedvueelueejieetveejveeiueelhefhfeenucffohhmrghinheplhhoghdrihhnfhhonecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrddutdefpdekvddrieegrddvhedtrddujedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeotghlgheskhgrohgurdhorhhgqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehpmhhorhgvlheslhhinhhugidrihgsmhdrtghomhdpnhhsgheslhhinhhugidrihgsmhdrtghomhdpnhhrsgeslhhinhhugidrihgsmhdrtghomhdpshgvihguvghnsehlihhnuhigrdhisghmrdgtohhmpdgrrhhmsghruhesrhgvughhrghtrdgtohhmpdgvsghlrghkvgesrhgvughhrghtrdgtohhmpdhmrghrtggvlhdrrghpfhgvlhgsrghumhesghhmrghilhdrtghomhdpvghhrggskhhoshhtse
 hrvgguhhgrthdrtghomhdpkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpfhhrrghnkhhjrgeslhhinhhugidrihgsmhdrtghomhdpphgsohhniihinhhisehrvgguhhgrthdrtghomhdptghohhhutghksehrvgguhhgrthdrtghomhdpthhhuhhthhesrhgvughhrghtrdgtohhmpdgurghvihgusehrvgguhhgrthdrtghomhdprhhitghhrghrugdrhhgvnhguvghrshhonheslhhinhgrrhhordhorhhgpdhprghsihgtsehlihhnuhigrdhisghmrdgtohhmpdgsohhrnhhtrhgrvghgvghrseguvgdrihgsmhdrtghomhdpqhgvmhhuqdguvghvvghlsehnohhnghhnuhdrohhrghdpqhgvmhhuqdhsfeeltdigsehnohhnghhnuhdrohhrghdpmhhsthesrhgvughhrghtrdgtohhmpdgsvghrrhgrnhhgvgesrhgvughhrghtrdgtohhmpdfovfetjfhoshhtpehmohehhedvpdhmohguvgepshhmthhpohhuth
X-Spam-Status: No, score=-1.9 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/3/23 18:28, Pierre Morel wrote:
> Polarization is changed on a request from the guest.
> Let's verify the polarization is accordingly set by QEMU.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   tests/avocado/s390_topology.py | 38 +++++++++++++++++++++++++++++++++-
>   1 file changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/avocado/s390_topology.py b/tests/avocado/s390_topology.py
> index 38e9cc4f16..a4bbbc2cb6 100644
> --- a/tests/avocado/s390_topology.py
> +++ b/tests/avocado/s390_topology.py
> @@ -107,6 +107,15 @@ def kernel_init(self):
>                            '-initrd', initrd_path,
>                            '-append', kernel_command_line)
>   
> +    def system_init(self):
> +        self.log.info("System init")
> +        exec_command(self, 'mount proc -t proc /proc')
> +        time.sleep(0.2)
> +        exec_command(self, 'mount sys -t sysfs /sys')
> +        time.sleep(0.2)
> +        exec_command_and_wait_for_pattern(self,
> +                '/bin/cat /sys/devices/system/cpu/dispatching', '0')
> +
>       def test_single(self):
>           self.kernel_init()
>           self.vm.launch()
> @@ -116,7 +125,6 @@ def test_single(self):
>       def test_default(self):
>           """
>           This test checks the implicite topology.
> -

unwanted change I guess ?


>           :avocado: tags=arch:s390x
>           :avocado: tags=machine:s390-ccw-virtio
>           """
> @@ -194,3 +202,31 @@ def test_hotplug_full(self):
>           self.wait_for_console_pattern('no job control')
>           self.check_topology(1, 1, 1, 1, 'medium', False)
>   
> +    def test_polarisation(self):
> +        """
> +        This test verifies that QEMU modifies the entitlement change after
> +        several guest polarization change requests.
> +
> +        :avocado: tags=arch:s390x
> +        :avocado: tags=machine:s390-ccw-virtio
> +        """
> +        self.kernel_init()
> +        self.vm.launch()
> +        self.wait_for_console_pattern('no job control')
> +
> +        self.system_init()
> +        self.check_topology(0, 0, 0, 0, 'medium', False)
> +
> +        exec_command(self, 'echo 1 > /sys/devices/system/cpu/dispatching')
> +        time.sleep(0.2)
> +        exec_command_and_wait_for_pattern(self,
> +                '/bin/cat /sys/devices/system/cpu/dispatching', '1')
> +
> +        self.check_topology(0, 0, 0, 0, 'medium', False)
> +
> +        exec_command(self, 'echo 0 > /sys/devices/system/cpu/dispatching')
> +        time.sleep(0.2)
> +        exec_command_and_wait_for_pattern(self,
> +                '/bin/cat /sys/devices/system/cpu/dispatching', '0')
> +
> +        self.check_topology(0, 0, 0, 0, 'medium', False)

