Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71D76327BC
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 16:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbiKUPVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 10:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbiKUPUl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 10:20:41 -0500
X-Greylist: delayed 8406 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 21 Nov 2022 07:18:34 PST
Received: from 8.mo548.mail-out.ovh.net (8.mo548.mail-out.ovh.net [46.105.45.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB528C67C4
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 07:18:33 -0800 (PST)
Received: from mxplan5.mail.ovh.net (unknown [10.108.1.6])
        by mo548.mail-out.ovh.net (Postfix) with ESMTPS id C440423070;
        Mon, 21 Nov 2022 11:03:13 +0000 (UTC)
Received: from kaod.org (37.59.142.98) by DAG8EX2.mxp5.local (172.16.2.72)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Mon, 21 Nov
 2022 12:03:12 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-98R002374dfbf7-e072-4805-b686-6b2b08b22e5e,
                    DDADA6E0A258960EA2C3EFDC8F36B73C7D77DF4E) smtp.auth=groug@kaod.org
X-OVh-ClientIp: 78.197.208.248
Date:   Mon, 21 Nov 2022 12:03:11 +0100
From:   Greg Kurz <groug@kaod.org>
To:     Dongli Zhang <dongli.zhang@oracle.com>
CC:     <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <qemu-ppc@nongnu.org>,
        <qemu-riscv@nongnu.org>, <qemu-s390x@nongnu.org>,
        <pbonzini@redhat.com>, <peter.maydell@linaro.org>,
        <mtosatti@redhat.com>, <chenhuacai@kernel.org>,
        <philmd@linaro.org>, <aurelien@aurel32.net>,
        <jiaxun.yang@flygoat.com>, <aleksandar.rikalo@syrmia.com>,
        <danielhb413@gmail.com>, <clg@kaod.org>,
        <david@gibson.dropbear.id.au>, <palmer@dabbelt.com>,
        <alistair.francis@wdc.com>, <bin.meng@windriver.com>,
        <pasic@linux.ibm.com>, <borntraeger@linux.ibm.com>,
        <richard.henderson@linaro.org>, <david@redhat.com>,
        <iii@linux.ibm.com>, <thuth@redhat.com>, <joe.jin@oracle.com>,
        <likexu@tencent.com>
Subject: Re: [PATCH 2/3] i386: kvm: disable KVM_CAP_PMU_CAPABILITY if "pmu"
 is disabled
Message-ID: <20221121120311.2731a912@bahia>
In-Reply-To: <20221119122901.2469-3-dongli.zhang@oracle.com>
References: <20221119122901.2469-1-dongli.zhang@oracle.com>
        <20221119122901.2469-3-dongli.zhang@oracle.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.98]
X-ClientProxiedBy: DAG3EX1.mxp5.local (172.16.2.21) To DAG8EX2.mxp5.local
 (172.16.2.72)
X-Ovh-Tracer-GUID: 23266189-71d4-438d-a62b-bfc5ce6d4539
X-Ovh-Tracer-Id: 6553018936605383147
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvgedrheeigddvvdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvvefukfgjfhfogggtgfhisehtjeertdertddvnecuhfhrohhmpefirhgvghcumfhurhiiuceoghhrohhugheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeegkeejtdevgeekieelffdvtedvvdegtdduudeigffhhffgvdfhgeejteekheefkeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddrleeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeoghhrohhugheskhgrohgurdhorhhgqedpnhgspghrtghpthhtohepuddprhgtphhtthhopeguohhnghhlihdriihhrghnghesohhrrggtlhgvrdgtohhmpdhthhhuthhhsehrvgguhhgrthdrtghomhdpihhiiheslhhinhhugidrihgsmhdrtghomhdpuggrvhhiugesrhgvughhrghtrdgtohhmpdhrihgthhgrrhgurdhhvghnuggvrhhsohhnsehlihhnrghrohdrohhrghdpsghorhhnthhrrggvghgvrheslhhinhhugidrihgsmhdrtghomhdpphgrshhitgeslhhinhhugidrihgsmhdrtghomhdpsghinhdrmhgvnhhgseifihhnughrihhvvghrrdgtohhmpdgrlhhishhtrghirhdrfhhrrg
 hntghishesfigutgdrtghomhdpphgrlhhmvghrsegurggssggvlhhtrdgtohhmpdgurghvihgusehgihgsshhonhdrughrohhpsggvrghrrdhiugdrrghupdgurghnihgvlhhhsgegudefsehgmhgrihhlrdgtohhmpdhjohgvrdhjihhnsehorhgrtghlvgdrtghomhdprghlvghkshgrnhgurghrrdhrihhkrghlohesshihrhhmihgrrdgtohhmpdgruhhrvghlihgvnhesrghurhgvlhefvddrnhgvthdpphhhihhlmhgusehlihhnrghrohdrohhrghdptghhvghnhhhurggtrghisehkvghrnhgvlhdrohhrghdpmhhtohhsrghtthhisehrvgguhhgrthdrtghomhdpphgvthgvrhdrmhgrhiguvghllheslhhinhgrrhhordhorhhgpdhpsghonhiiihhnihesrhgvughhrghtrdgtohhmpdhqvghmuhdqshefledtgiesnhhonhhgnhhurdhorhhgpdhqvghmuhdqrhhishgtvhesnhhonhhgnhhurdhorhhgpdhqvghmuhdqphhptgesnhhonhhgnhhurdhorhhgpdhqvghmuhdqrghrmhesnhhonhhgnhhurdhorhhgpdhqvghmuhdquggvvhgvlhesnhhonhhgnhhurdhorhhgpdhkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmpdhlihhkvgiguhesthgvnhgtvghnthdrtghomhdptghlgheskhgrohgurdhorhhgpdfovfetjfhoshhtpehmohehgeekpdhmohguvgepshhmthhpohhuth
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 19 Nov 2022 04:29:00 -0800
Dongli Zhang <dongli.zhang@oracle.com> wrote:

> The "perf stat" at the VM side still works even we set "-cpu host,-pmu" in
> the QEMU command line. That is, neither "-cpu host,-pmu" nor "-cpu EPYC"
> could disable the pmu virtualization in an AMD environment.
> 
> We still see below at VM kernel side ...
> 
> [    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
> 
> ... although we expect something like below.
> 
> [    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
> [    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled
> 
> This is because the AMD pmu (v1) does not rely on cpuid to decide if the
> pmu virtualization is supported.
> 
> We disable KVM_CAP_PMU_CAPABILITY if the 'pmu' is disabled in the vcpu
> properties.
> 
> Cc: Joe Jin <joe.jin@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>  target/i386/kvm/kvm.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 8fec0bc5b5..0b1226ff7f 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -137,6 +137,8 @@ static int has_triple_fault_event;
>  
>  static bool has_msr_mcg_ext_ctl;
>  
> +static int has_pmu_cap;
> +
>  static struct kvm_cpuid2 *cpuid_cache;
>  static struct kvm_cpuid2 *hv_cpuid_cache;
>  static struct kvm_msr_list *kvm_feature_msrs;
> @@ -1725,6 +1727,19 @@ static void kvm_init_nested_state(CPUX86State *env)
>  
>  void kvm_arch_pre_create_vcpu(CPUState *cs)
>  {
> +    X86CPU *cpu = X86_CPU(cs);
> +    int ret;
> +
> +    if (has_pmu_cap && !cpu->enable_pmu) {
> +        ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
> +                                KVM_PMU_CAP_DISABLE);

It doesn't seem conceptually correct to configure VM level stuff out of
a vCPU property, which could theoretically be different for each vCPU,
even if this isn't the case with the current code base.

Maybe consider controlling PMU with a machine property and this
could be done in kvm_arch_init() like other VM level stuff ?

> +        if (ret < 0) {
> +            error_report("kvm: Failed to disable pmu cap: %s",
> +                         strerror(-ret));
> +        }
> +
> +        has_pmu_cap = 0;
> +    }
>  }
>  
>  int kvm_arch_init_vcpu(CPUState *cs)
> @@ -2517,6 +2532,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>          }
>      }
>  
> +    has_pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
> +
>      ret = kvm_get_supported_msrs(s);
>      if (ret < 0) {
>          return ret;

