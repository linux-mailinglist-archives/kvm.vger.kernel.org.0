Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87CCD6D59D3
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 09:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbjDDHlO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 03:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233212AbjDDHlM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 03:41:12 -0400
Received: from smtpout1.mo529.mail-out.ovh.net (smtpout1.mo529.mail-out.ovh.net [178.32.125.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE46110EA
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 00:41:10 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.109.138.233])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 1FB0521711;
        Tue,  4 Apr 2023 07:41:09 +0000 (UTC)
Received: from kaod.org (37.59.142.97) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 4 Apr
 2023 09:41:08 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-97G0022fcbf9e4-7470-40b3-9410-4c66e3272b75,
                    85507D0075A56E5AD4EA03BF56E5282CC2D8C3A6) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <227eb09d-e5dc-2662-32b0-0b9ca4e8ef34@kaod.org>
Date:   Tue, 4 Apr 2023 09:41:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v19 06/21] s390x/cpu topology: interception of PTF
 instruction
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
 <20230403162905.17703-7-pmorel@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20230403162905.17703-7-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.97]
X-ClientProxiedBy: DAG1EX1.mxp5.local (172.16.2.1) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: b7aa4e4c-f92b-4df4-9d98-f74575e51847
X-Ovh-Tracer-Id: 15317868234580397011
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeikedguddtjecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfhisehtjeertddtfeejnecuhfhrohhmpeevrogurhhitgcunfgvucfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepuedutdetleegjefhieekgeffkefhleevgfefjeevffejieevgeefhefgtdfgiedtnecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrdeljedpkedvrdeigedrvdehtddrudejtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoegtlhhgsehkrghougdrohhrgheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepphhmohhrvghlsehlihhnuhigrdhisghmrdgtohhmpdhnshhgsehlihhnuhigrdhisghmrdgtohhmpdhnrhgssehlihhnuhigrdhisghmrdgtohhmpdhsvghiuggvnheslhhinhhugidrihgsmhdrtghomhdprghrmhgsrhhusehrvgguhhgrthdrtghomhdpvggslhgrkhgvsehrvgguhhgrthdrtghomhdpmhgrrhgtvghlrdgrphhfvghlsggruhhmsehgmhgrihhlrdgtohhmpdgvhhgrsghkohhsthesrhgvughhrghtrdgtohhmpdhkvhhmsehvgh
 gvrhdrkhgvrhhnvghlrdhorhhgpdhfrhgrnhhkjhgrsehlihhnuhigrdhisghmrdgtohhmpdhpsghonhiiihhnihesrhgvughhrghtrdgtohhmpdgtohhhuhgtkhesrhgvughhrghtrdgtohhmpdhthhhuthhhsehrvgguhhgrthdrtghomhdpuggrvhhiugesrhgvughhrghtrdgtohhmpdhrihgthhgrrhgurdhhvghnuggvrhhsohhnsehlihhnrghrohdrohhrghdpphgrshhitgeslhhinhhugidrihgsmhdrtghomhdpsghorhhnthhrrggvghgvrhesuggvrdhisghmrdgtohhmpdhqvghmuhdquggvvhgvlhesnhhonhhgnhhurdhorhhgpdhqvghmuhdqshefledtgiesnhhonhhgnhhurdhorhhgpdhmshhtsehrvgguhhgrthdrtghomhdpsggvrhhrrghnghgvsehrvgguhhgrthdrtghomhdpoffvtefjohhsthepmhhohedvledpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-1.9 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/3/23 18:28, Pierre Morel wrote:
> When the host supports the CPU topology facility, the PTF
> instruction with function code 2 is interpreted by the SIE,
> provided that the userland hypervisor activates the interpretation
> by using the KVM_CAP_S390_CPU_TOPOLOGY KVM extension.
> 
> The PTF instructions with function code 0 and 1 are intercepted
> and must be emulated by the userland hypervisor.
> 
> During RESET all CPU of the configuration are placed in
> horizontal polarity.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   include/hw/s390x/s390-virtio-ccw.h |  6 ++++
>   hw/s390x/cpu-topology.c            | 56 ++++++++++++++++++++++++++++--
>   target/s390x/kvm/kvm.c             | 11 ++++++
>   3 files changed, 71 insertions(+), 2 deletions(-)
> 
> diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
> index ea10a6c6e1..9aa9f48bd0 100644
> --- a/include/hw/s390x/s390-virtio-ccw.h
> +++ b/include/hw/s390x/s390-virtio-ccw.h
> @@ -31,6 +31,12 @@ struct S390CcwMachineState {
>       bool vertical_polarization;
>   };
>   
> +#define S390_PTF_REASON_NONE (0x00 << 8)
> +#define S390_PTF_REASON_DONE (0x01 << 8)
> +#define S390_PTF_REASON_BUSY (0x02 << 8)
> +#define S390_TOPO_FC_MASK 0xffUL
> +void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra);
> +
>   struct S390CcwMachineClass {
>       /*< private >*/
>       MachineClass parent_class;
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index 1d672d4d81..eec6c9a896 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -26,8 +26,6 @@
>    * .smp: keeps track of the machine topology.
>    * .list: queue the topology entries inside which
>    *        we keep the information on the CPU topology.
> - * .polarization: the current subsystem polarization
> - *

Please remove from patch 3 instead.

>    */
>   S390Topology s390_topology = {
>       /* will be initialized after the cpu model is realized */
> @@ -86,6 +84,57 @@ static void s390_topology_init(MachineState *ms)
>       QTAILQ_INSERT_HEAD(&s390_topology.list, entry, next);
>   }
>   
> +/*
> + * s390_handle_ptf:
> + *
> + * @register 1: contains the function code
> + *
> + * Function codes 0 (horizontal) and 1 (vertical) define the CPU
> + * polarization requested by the guest.
> + *
> + * Function code 2 is handling topology changes and is interpreted
> + * by the SIE.
> + */
> +void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra)
> +{
> +    struct S390CcwMachineState *s390ms = S390_CCW_MACHINE(current_machine);
> +    CPUS390XState *env = &cpu->env;
> +    uint64_t reg = env->regs[r1];
> +    int fc = reg & S390_TOPO_FC_MASK;
> +
> +    if (!s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY)) {
> +        s390_program_interrupt(env, PGM_OPERATION, ra);
> +        return;
> +    }
> +
> +    if (env->psw.mask & PSW_MASK_PSTATE) {
> +        s390_program_interrupt(env, PGM_PRIVILEGED, ra);
> +        return;
> +    }
> +
> +    if (reg & ~S390_TOPO_FC_MASK) {
> +        s390_program_interrupt(env, PGM_SPECIFICATION, ra);
> +        return;
> +    }
> +
> +    switch (fc) {
> +    case S390_CPU_POLARIZATION_VERTICAL:
> +    case S390_CPU_POLARIZATION_HORIZONTAL:
> +        if (s390ms->vertical_polarization == !!fc) {
> +            env->regs[r1] |= S390_PTF_REASON_DONE;
> +            setcc(cpu, 2);
> +        } else {
> +            s390ms->vertical_polarization = !!fc;
> +            s390_cpu_topology_set_changed(true);
> +            setcc(cpu, 0);
> +        }
> +        break;
> +    default:
> +        /* Note that fc == 2 is interpreted by the SIE */
> +        s390_program_interrupt(env, PGM_SPECIFICATION, ra);
> +    }
> +}
> +
>   /**
>    * s390_topology_reset:
>    *
> @@ -94,7 +143,10 @@ static void s390_topology_init(MachineState *ms)
>    */
>   void s390_topology_reset(void)
>   {
> +    struct S390CcwMachineState *s390ms = S390_CCW_MACHINE(current_machine);
> +
>       s390_cpu_topology_set_changed(false);
> +    s390ms->vertical_polarization = false;
>   }
>   
>   /**
> diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
> index bc953151ce..fb63be41b7 100644
> --- a/target/s390x/kvm/kvm.c
> +++ b/target/s390x/kvm/kvm.c
> @@ -96,6 +96,7 @@
>   
>   #define PRIV_B9_EQBS                    0x9c
>   #define PRIV_B9_CLP                     0xa0
> +#define PRIV_B9_PTF                     0xa2
>   #define PRIV_B9_PCISTG                  0xd0
>   #define PRIV_B9_PCILG                   0xd2
>   #define PRIV_B9_RPCIT                   0xd3
> @@ -1464,6 +1465,13 @@ static int kvm_mpcifc_service_call(S390CPU *cpu, struct kvm_run *run)
>       }
>   }
>   
> +static void kvm_handle_ptf(S390CPU *cpu, struct kvm_run *run)
> +{
> +    uint8_t r1 = (run->s390_sieic.ipb >> 20) & 0x0f;
> +
> +    s390_handle_ptf(cpu, r1, RA_IGNORED);
> +}
> +
>   static int handle_b9(S390CPU *cpu, struct kvm_run *run, uint8_t ipa1)
>   {
>       int r = 0;
> @@ -1481,6 +1489,9 @@ static int handle_b9(S390CPU *cpu, struct kvm_run *run, uint8_t ipa1)
>       case PRIV_B9_RPCIT:
>           r = kvm_rpcit_service_call(cpu, run);
>           break;
> +    case PRIV_B9_PTF:
> +        kvm_handle_ptf(cpu, run);
> +        break;
>       case PRIV_B9_EQBS:
>           /* just inject exception */
>           r = -1;

