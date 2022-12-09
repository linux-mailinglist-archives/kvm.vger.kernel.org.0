Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A95648408
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 15:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiLIOp0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 09:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiLIOpX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 09:45:23 -0500
Received: from 7.mo548.mail-out.ovh.net (7.mo548.mail-out.ovh.net [46.105.33.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EAEDEC6
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 06:45:22 -0800 (PST)
Received: from mxplan5.mail.ovh.net (unknown [10.108.1.10])
        by mo548.mail-out.ovh.net (Postfix) with ESMTPS id EEC1224E00;
        Fri,  9 Dec 2022 14:45:19 +0000 (UTC)
Received: from kaod.org (37.59.142.110) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 9 Dec
 2022 15:45:18 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-110S004a47b3783-5ec0-49c6-a8df-99b9acfa1999,
                    703C8C4CBBC51929D19CEDB14A3E71E172461769) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <d29c06e6-48e2-6cff-0524-297eaab0516b@kaod.org>
Date:   Fri, 9 Dec 2022 15:45:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v13 0/7] s390x: CPU Topology
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, <qemu-s390x@nongnu.org>
CC:     <qemu-devel@nongnu.org>, <borntraeger@de.ibm.com>,
        <pasic@linux.ibm.com>, <richard.henderson@linaro.org>,
        <david@redhat.com>, <thuth@redhat.com>, <cohuck@redhat.com>,
        <mst@redhat.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <ehabkost@redhat.com>, <marcel.apfelbaum@gmail.com>,
        <eblake@redhat.com>, <armbru@redhat.com>, <seiden@linux.ibm.com>,
        <nrb@linux.ibm.com>, <scgl@linux.ibm.com>, <frankja@linux.ibm.com>,
        <berrange@redhat.com>
References: <20221208094432.9732-1-pmorel@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20221208094432.9732-1-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.110]
X-ClientProxiedBy: DAG3EX1.mxp5.local (172.16.2.21) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: d542ce9c-b5fb-4b4b-acf8-35583068984c
X-Ovh-Tracer-Id: 5331980484331015123
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrvddvgdeiiecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfhisehtjeertddtfeejnecuhfhrohhmpeevrogurhhitgcunfgvucfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepuedutdetleegjefhieekgeffkefhleevgfefjeevffejieevgeefhefgtdfgiedtnecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrdduuddtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeotghlgheskhgrohgurdhorhhgqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehpmhhorhgvlheslhhinhhugidrihgsmhdrtghomhdpshgtghhlsehlihhnuhigrdhisghmrdgtohhmpdhnrhgssehlihhnuhigrdhisghmrdgtohhmpdhsvghiuggvnheslhhinhhugidrihgsmhdrtghomhdprghrmhgsrhhusehrvgguhhgrthdrtghomhdpvggslhgrkhgvsehrvgguhhgrthdrtghomhdpmhgrrhgtvghlrdgrphhfvghlsggruhhmsehgmhgrihhlrdgtohhmpdgvhhgrsghkohhsthesrhgvughhrghtrdgtohhmpdhkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpd
 hfrhgrnhhkjhgrsehlihhnuhigrdhisghmrdgtohhmpdhpsghonhiiihhnihesrhgvughhrghtrdgtohhmpdgtohhhuhgtkhesrhgvughhrghtrdgtohhmpdhthhhuthhhsehrvgguhhgrthdrtghomhdpuggrvhhiugesrhgvughhrghtrdgtohhmpdhrihgthhgrrhgurdhhvghnuggvrhhsohhnsehlihhnrghrohdrohhrghdpphgrshhitgeslhhinhhugidrihgsmhdrtghomhdpsghorhhnthhrrggvghgvrhesuggvrdhisghmrdgtohhmpdhqvghmuhdquggvvhgvlhesnhhonhhgnhhurdhorhhgpdhqvghmuhdqshefledtgiesnhhonhhgnhhurdhorhhgpdhmshhtsehrvgguhhgrthdrtghomhdpsggvrhhrrghnghgvsehrvgguhhgrthdrtghomhdpoffvtefjohhsthepmhhoheegkedpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/22 10:44, Pierre Morel wrote:
> Hi,
> 
> Implementation discussions
> ==========================
> 
> CPU models
> ----------
> 
> Since the S390_FEAT_CONFIGURATION_TOPOLOGY is already in the CPU model
> for old QEMU we could not activate it as usual from KVM but needed
> a KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
> Checking and enabling this capability enables
> S390_FEAT_CONFIGURATION_TOPOLOGY.
> 
> Migration
> ---------
> 
> Once the S390_FEAT_CONFIGURATION_TOPOLOGY is enabled in the source
> host the STFL(11) is provided to the guest.
> Since the feature is already in the CPU model of older QEMU,
> a migration from a new QEMU enabling the topology to an old QEMU
> will keep STFL(11) enabled making the guest get an exception for
> illegal operation as soon as it uses the PTF instruction.
> 
> A VMState keeping track of the S390_FEAT_CONFIGURATION_TOPOLOGY
> allows to forbid the migration in such a case.
> 
> Note that the VMState will be used to hold information on the
> topology once we implement topology change for a running guest.
> 
> Topology
> --------
> 
> Until we introduce bookss and drawers, polarization and dedication
> the topology is kept very simple and is specified uniquely by
> the core_id of the vCPU which is also the vCPU address.
> 
> Testing
> =======
> 
> To use the QEMU patches, you will need Linux V6-rc1 or newer,
> or use the following Linux mainline patches:
> 
> f5ecfee94493 2022-07-20 KVM: s390: resetting the Topology-Change-Report
> 24fe0195bc19 2022-07-20 KVM: s390: guest support for topology function
> 0130337ec45b 2022-07-20 KVM: s390: Cleanup ipte lock access and SIIF fac..
> 
> Currently this code is for KVM only, I have no idea if it is interesting
> to provide a TCG patch. If ever it will be done in another series.
> 
> Documentation
> =============
> 
> To have a better understanding of the S390x CPU Topology and its
> implementation in QEMU you can have a look at the documentation in the
> last patch of this series.
> 
> The admin will want to match the host and the guest topology, taking
> into account that the guest does not recognize multithreading.
> Consequently, two vCPU assigned to threads of the same real CPU should
> preferably be assigned to the same socket of the guest machine.
> 
> Future developments
> ===================
> 
> Two series are actively prepared:
> - Adding drawers, book, polarization and dedication to the vCPU.
> - changing the topology with a running guest

Since we have time before the next QEMU 8.0 release, could you please
send the whole patchset ? Having the full picture would help in taking
decisions for downstream also.

I am still uncertain about the usefulness of S390Topology object because,
as for now, the state can be computed on the fly, the reset can be
handled at the machine level directly under s390_machine_reset() and so
could migration if the machine had a vmstate (not the case today but
quite easy to add). So before merging anything that could be difficult
to maintain and/or backport, I would prefer to see it all !

Thanks,

C.


> 
> Regards,
> Pierre
> 
> Pierre Morel (7):
>    s390x/cpu topology: Creating CPU topology device
>    s390x/cpu topology: reporting the CPU topology to the guest
>    s390x/cpu_topology: resetting the Topology-Change-Report
>    s390x/cpu_topology: CPU topology migration
>    s390x/cpu_topology: interception of PTF instruction
>    s390x/cpu_topology: activating CPU topology
>    docs/s390x: document s390x cpu topology
> 
>   docs/system/s390x/cpu-topology.rst |  87 ++++++++++
>   docs/system/target-s390x.rst       |   1 +
>   include/hw/s390x/cpu-topology.h    |  52 ++++++
>   include/hw/s390x/s390-virtio-ccw.h |   6 +
>   target/s390x/cpu.h                 |  78 +++++++++
>   target/s390x/kvm/kvm_s390x.h       |   1 +
>   hw/s390x/cpu-topology.c            | 261 +++++++++++++++++++++++++++++
>   hw/s390x/s390-virtio-ccw.c         |   7 +
>   target/s390x/cpu-sysemu.c          |  21 +++
>   target/s390x/cpu_models.c          |   1 +
>   target/s390x/kvm/cpu_topology.c    | 186 ++++++++++++++++++++
>   target/s390x/kvm/kvm.c             |  46 ++++-
>   hw/s390x/meson.build               |   1 +
>   target/s390x/kvm/meson.build       |   3 +-
>   14 files changed, 749 insertions(+), 2 deletions(-)
>   create mode 100644 docs/system/s390x/cpu-topology.rst
>   create mode 100644 include/hw/s390x/cpu-topology.h
>   create mode 100644 hw/s390x/cpu-topology.c
>   create mode 100644 target/s390x/kvm/cpu_topology.c
> 

