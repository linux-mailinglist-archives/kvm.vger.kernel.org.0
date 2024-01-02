Return-Path: <kvm+bounces-5455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87E0F8220ED
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 19:22:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D870BB20C50
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 18:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77EA9156D6;
	Tue,  2 Jan 2024 18:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=epfl.ch header.i=@epfl.ch header.b="ee2HMHqU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp5.epfl.ch (smtp5.epfl.ch [128.178.224.8])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA919156CF
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 18:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epfl.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=epfl.ch
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=epfl.ch;
      s=epfl; t=1704219645;
      h=From:To:CC:Subject:Date:Message-ID:Content-Type:Content-Transfer-Encoding:MIME-Version;
      bh=OxtTIrg5sFHL5xvYcVHYx8t2sKhgAwzylRU+Ady+knc=;
      b=ee2HMHqUu2BZN40qf+QrMkxELyCiOyy+irZl2wJvdKRsvC65DGeTx+yMI+St4adkc
        pqsOAWfZs7nPQvLph9bi+IZPIeqv25fXdwyDBATukc7tpOCYLcVSE85GU+CI6mPfJ
        IoRyr06rfGSnRBYb+EUOHUOvwzsrQqJ03SSFHap50=
Received: (qmail 8300 invoked by uid 107); 2 Jan 2024 18:20:45 -0000
Received: from ax-snat-224-159.epfl.ch (HELO EWA02.intranet.epfl.ch) (192.168.224.159) (TLS, AES256-GCM-SHA384 cipher)
  by mail.epfl.ch (AngelmatoPhylax SMTP proxy) with ESMTPS; Tue, 02 Jan 2024 19:20:45 +0100
X-EPFL-Auth: 1dlILVvV7pW+JdVjtDJD/usgNvmVW7+e0MSs1YvdFj3bFi0DLM8=
Received: from ewa07.intranet.epfl.ch (128.178.224.178) by
 EWA02.intranet.epfl.ch (128.178.224.159) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 2 Jan 2024 19:20:45 +0100
Received: from ewa07.intranet.epfl.ch ([fe80::f470:9b62:7382:7f3a]) by
 ewa07.intranet.epfl.ch ([fe80::f470:9b62:7382:7f3a%4]) with mapi id
 15.01.2507.034; Tue, 2 Jan 2024 19:20:45 +0100
From: Tao Lyu <tao.lyu@epfl.ch>
To: Sean Christopherson <seanjc@google.com>
CC: Dongli Zhang <dongli.zhang@oracle.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: Re: obtain the timestamp counter of physical/host machine inside the
 VMs.
Thread-Topic: obtain the timestamp counter of physical/host machine inside the
 VMs.
Thread-Index: AQHaPTorOSL38nKVnU6vZUzEPKmx8LDGTLnhgABxPICAABTdYg==
Date: Tue, 2 Jan 2024 18:20:45 +0000
Message-ID: <b54287c7f2a8414dbe8497c0c97e1b90@epfl.ch>
References: <CAJGDS+Ez+NpVtaO5_NTdiwrnTTGFbevz+aDUyLMZk6ufie701Q@mail.gmail.com>
 <20240101220601.2828996-1-tao.lyu@epfl.ch>
 <f1535a39-4f3b-bae8-950e-9a0e5df46681@oracle.com>
 <a31d33cb6eb14ddda272b9d291c5ae00@epfl.ch>,<ZZRNly2jIIVyC5F6@google.com>
In-Reply-To: <ZZRNly2jIIVyC5F6@google.com>
Accept-Language: en-US, fr-CH
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

>>=20
>> Hi=A0Dongli,
>>=20
>> > On 1/1/24 14:06, Tao Lyu wrote:
>> >> Hello Arnabjyoti, Sean, and everyone,
>> >>=20
>> >> I'm having a similiar but slightly differnt issue about the rdtsc in =
KVM.
>> >>=20
>> >> I want to obtain the timestamp counter of physical/host machine insid=
e the VMs.
>> >>=20
>> >> Acccording to the previous threads, I know I need to disable the offs=
etting, VM exit, and scaling.
>> >> I specify the correspoding parameters in the qemu arguments.
>> >> The booting command is listed below:
>> >>=20
>> >> qemu-system-x86_64 -m 10240 -smp 4 -chardev socket,id=3DSOCKSYZ,serve=
r=3Don,nowait,host=3Dlocalhost,port=3D3258 -mon chardev=3DSOCKSYZ,mode=3Dco=
ntrol -display none -serial stdio -device virtio-rng-pci -enable-kvm -cpu h=
ost,migratable=3Doff,tsc=3Don,rdtscp=3Don,vmx-tsc-offset=3Doff,vmx-rdtsc-ex=
it=3Doff,tsc-scale=3Doff,tsc-adjust=3Doff,vmx-rdtscp-exit=3Doff=A0  -netdev=
 bridge,id=3Dhn40 -device virtio-net,netdev=3Dhn40,mac=3De6:c8:ff:09:76:38 =
-hda XXX -kernel XXX -append "root=3D/dev/sda console=3DttyS0"
>> >>=20
>> >>=20
>> >> But the rdtsc still returns the adjusted tsc.
>> >> The vmxcap script shows the TSC settings as below:
>> >>=A0=A0=20
>> >>=A0=A0 Use TSC offsetting=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 no
>> >>=A0=A0 RDTSC exiting=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 no
>> >>=A0=A0 Enable RDTSCP=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 no
>> >>=A0=A0 TSC scaling=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 yes
>> >>=20
>> >>=20
>> >> I would really appreciate it if anyone can tell me whether and how I =
can get the tsc of physical machine insdie the VM.
>>=20
>> > If the objective is to obtain the same tsc at both VM and host side (t=
hat is, to
>> > avoid any offset or scaling), I can obtain quite close tsc at both VM =
and host
>> > side with the below linux-6.6 change.
>>=20
>> > My env does not use tsc scaling.
>>=20
>> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> > index 41cce50..b102dcd 100644
>> > --- a/arch/x86/kvm/x86.c
>> > +++ b/arch/x86/kvm/x86.c
>> >@@ -2723,7 +2723,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *=
vcpu, u64
>> data)
>> >=A0=A0=A0=A0=A0=A0=A0 bool synchronizing =3D false;
>> >
>> >=A0=A0=A0=A0=A0=A0 raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, fla=
gs);
>> > -=A0=A0=A0=A0=A0=A0 offset =3D kvm_compute_l1_tsc_offset(vcpu, data);
>> > +=A0=A0=A0=A0=A0=A0 offset =3D 0;
>> >=A0=A0=A0=A0=A0=A0=A0 ns =3D get_kvmclock_base_ns();
>> >=A0=A0=A0=A0=A0=A0=A0 elapsed =3D ns - kvm->arch.last_tsc_nsec;
>> >
>> > Dongli Zhang
>>=20
>>=20
>> Hi Dongli,
>>=20
>> Thank you so much for the explanation and for providing a patch.
>> It works for me now.
>
>Yeah, during vCPU creation KVM sets a target guest TSC of '0', i.e. sets t=
he TSC
>offset to "0 - HOST_TSC".=A0 As of commit 828ca89628bf ("KVM: x86: Expose =
TSC offset
>controls to userspace"), userspace can explicitly set an offset of '0' via
>KVM_VCPU_TSC_CTRL+KVM_VCPU_TSC_OFFSET, but AFAIK QEMU doesn't support that=
 API.
>
>All the other methods for setting the TSC offset are indirect, i.e. usersp=
ace
>provides the target TSC and KVM computes the offset.=A0 So even if QEMU pr=
ovides a
way to specify an explicit TSC (or offset), there will be a healthy amount =
of slop.


Hi Sean and Dongli,

Thank you so much for the replies.

Unfortunately, after I adding the following patch to reset the TSC OFFSET f=
orcefully,
I can get the host TSC value from guest.

However, when booting the host kernel, it has the following WARNINGS:


[  113.033750] ------------[ cut here ]------------
[  113.033768] NETDEV WATCHDOG: enxb03af61ad78a (rndis_host): transmit queu=
e 0 timed out
[  113.033802] WARNING: CPU: 42 PID: 0 at net/sched/sch_generic.c:477 dev_w=
atchdog+0x264/0x270
[  113.033829] Modules linked in: nf_conntrack_netlink xfrm_user xfrm_algo =
xt_addrtype br_netfilter dm_thin_pool dm_persistent_data dm_bio_prison dm_b=
ufio socwatch2_15(OE) vtsspp(OE) vhost_net vhost vhost_iotlb tap sep5(OE) s=
ocperf3(OE) xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv=
4 xt_tcpudp ip6table_mangle ip6table_nat iptable_mangle iptable_nat nf_nat =
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables libcrc32c nfnetlink ip=
6table_filter ip6_tables iptable_filter bpfilter bridge stp llc overlay cus=
e pax(OE) ipmi_ssif zram intel_rapl_msr intel_rapl_common i10nm_edac x86_pk=
g_temp_thermal intel_powerclamp coretemp joydev input_leds nls_iso8859_1 kv=
m_intel ast hid_generic drm_vram_helper drm_ttm_helper kvm rndis_host ttm u=
sbhid cdc_ether usbnet hid drm_kms_helper mii crct10dif_pclmul crc32_pclmul=
 ghash_clmulni_intel aesni_intel crypto_simd cryptd cec i2c_algo_bit rapl f=
b_sys_fops syscopyarea intel_cstate sysfillrect i40e sysimgblt isst_if_mbox=
_pci mei_me ioatdma ahci
[  113.034307]  isst_if_mmio i2c_i801 mei intel_pch_thermal isst_if_common =
acpi_ipmi libahci dca i2c_smbus wmi ipmi_si ipmi_devintf ipmi_msghandler nf=
it acpi_pad acpi_power_meter mac_hid sch_fq_codel binfmt_misc ramoops drm r=
eed_solomon efi_pstore sunrpc ip_tables x_tables autofs4
[  113.034473] CPU: 42 PID: 0 Comm: swapper/42 Kdump: loaded Tainted: G    =
       OE     5.15.0+ #4
[  113.034486] Hardware name: Intel Corporation M50CYP2SB1U/M50CYP2SB1U, BI=
OS SE5C620.86B.01.01.0004.2110190142 10/19/2021
[  113.034495] RIP: 0010:dev_watchdog+0x264/0x270
[  113.034511] Code: eb a6 48 8b 5d d0 c6 05 e6 47 0a 01 01 48 89 df e8 91 =
c4 f9 ff 44 89 e1 48 89 de 48 c7 c7 68 c2 a8 a9 48 89 c2 e8 90 3e 16 00 <0f=
> 0b eb 83 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41
[  113.034522] RSP: 0018:ffffa6e88d79ce78 EFLAGS: 00010286
[  113.034541] RAX: 0000000000000000 RBX: ffff959763ddb000 RCX: 00000000000=
0083f
[  113.034551] RDX: 0000000000000000 RSI: 00000000000000f6 RDI: 00000000000=
0083f
[  113.034559] RBP: ffffa6e88d79ceb0 R08: 0000000000000000 R09: ffffa6e88d7=
9cc60
[  113.034565] R10: ffffa6e88d79cc58 R11: ffff96163ff26c28 R12: 00000000000=
00000
[  113.034572] R13: ffff95976488ac80 R14: 0000000000000001 R15: ffff959763d=
db4c0
[  113.034579] FS:  0000000000000000(0000) GS:ffff961541980000(0000) knlGS:=
0000000000000000
[  113.034588] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  113.034595] CR2: 000055c5819e40f8 CR3: 0000004740c0a006 CR4: 00000000007=
72ee0
[  113.034604] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  113.034614] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[  113.034620] PKRU: 55555554
[  113.034629] Call Trace:
[  113.034636]  <IRQ>
[  113.034662]  call_timer_fn+0x29/0x100
[  113.034680]  __run_timers.part.0+0x1cf/0x240
[  113.034757]  run_timer_softirq+0x2a/0x50
[  113.034768]  __do_softirq+0xcb/0x274
[  113.034790]  irq_exit_rcu+0x8c/0xb0
[  113.034807]  sysvec_apic_timer_interrupt+0x7c/0x90
[  113.034823]  </IRQ>
[  113.034828]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[  113.034841] RIP: 0010:cpuidle_enter_state+0xcc/0x360
[  113.034861] Code: 3d c1 f7 26 57 e8 c4 09 74 ff 49 89 c6 0f 1f 44 00 00 =
31 ff e8 35 15 74 ff 80 7d d7 00 0f 85 01 01 00 00 fb 66 0f 1f 44 00 00 <45=
> 85 ff 0f 88 0d 01 00 00 49 63 cf 4c 2b 75 c8 48 8d 04 49 48 89
[  113.034870] RSP: 0018:ffffa6e8809b7e68 EFLAGS: 00000246
[  113.034884] RAX: ffff9615419a8dc0 RBX: 0000000000000002 RCX: 00000000000=
0001f
[  113.034892] RDX: 0000000000000000 RSI: 000000003158cc4a RDI: 00000000000=
00000
[  113.034900] RBP: ffffa6e8809b7ea0 R08: 0000001a5155ea28 R09: 00000000000=
00018
[  113.034909] R10: 000000000006e15c R11: ffffffffa9e4b960 R12: ffffc6e87a9=
91800
[  113.034917] R13: ffffffffa9e4b960 R14: 0000001a5155ea28 R15: 00000000000=
00002
[  113.034942]  cpuidle_enter+0x2e/0x40
[  113.034953]  do_idle+0x1ff/0x2a0
[  113.034966]  cpu_startup_entry+0x20/0x30
[  113.034979]  start_secondary+0x11a/0x150
[  113.034991]  secondary_startup_64_no_verify+0xb0/0xbb
[  113.035008] ---[ end trace f39ffcbabd5dfe2e ]---

[  533.511262] clocksource: timekeeping watchdog on CPU53: hpet read-back d=
elay of 89916ns, attempt 4, marking unstable
[  533.511295] tsc: Marking TSC unstable due to clocksource watchdog
[  533.511336] TSC found unstable after boot, most likely due to broken BIO=
S. Use 'tsc=3Dunstable'.
[  533.511339] sched_clock: Marking unstable (533409196195, 102131418)<-(53=
3549406780, -38078705)
[  533.512368] clocksource: Checking clocksource tsc synchronization from C=
PU 35 to CPUs 0,3,21-22,36,50,54.
[  533.513146] clocksource: Switched to clocksource hpet


And after a while, the guest kernel will have the following  error, and the=
n the network doesn't work anymore.
If I reboot the guest VM, then it will stuck and cannot be rebooted success=
fully.

rcu: INFO: rcu_sched self-detected stall on CPU
[  336.374152] rcu: 	3-...!: (1 GPs behind) idle=3Dbb3/0/0x1 softirq=3D3087=
/3087 fqs=3D0=20
[  336.379018] rcu: rcu_sched kthread timer wakeup didn't happen for 39086 =
jiffies! g3941 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
[  336.386045] rcu: 	Possible timer handling issue on cpu=3D1 timer-softirq=
=3D871
[  336.390353] rcu: rcu_sched kthread starved for 39089 jiffies! g3941 f0x0=
 RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D1
[  336.395881] rcu: 	Unless rcu_sched kthread gets sufficient CPU time, OOM=
 is now expected behavior.
[  336.400375] rcu: RCU grace-period kthread stack dump:
[  336.404091] rcu: Stack dump where RCU GP kthread last ran:
[  566.795685] rcu: INFO: rcu_sched self-detected stall on CPU
[  566.799315] rcu: 	3-...!: (1 ticks this GP) idle=3Dc65/0/0x1 softirq=3D3=
088/3088 fqs=3D1=20
[  566.804170] rcu: rcu_sched kthread timer wakeup didn't happen for 229687=
 jiffies! g3941 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
[  566.811259] rcu: 	Possible timer handling issue on cpu=3D1 timer-softirq=
=3D872
[  566.815579] rcu: rcu_sched kthread starved for 229690 jiffies! g3941 f0x=
0 RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D1
[  566.821190] rcu: 	Unless rcu_sched kthread gets sufficient CPU time, OOM=
 is now expected behavior.
[  566.825813] rcu: RCU grace-period kthread stack dump:
[  566.829513] rcu: Stack dump where RCU GP kthread last ran:


Looks like it leads to kernel misbehavior if we don't adjust the guest TSC =
value.

Our goal is to get the almost synchronized TSC value among KVM VMs one the =
same host.

Now I fix the host CPU frequency. Then the TSC OFFFSET, which can be read u=
nder "/sys/kernel/debug/kvm/qemu-PID/vcpu0/tsc-offset", will always keep co=
nstant.

Every time when I execute the rdtsc inside the guest, I will subtract the o=
ffset to it get the TSC value, which can be close to the host TSC value.

Do you think this makes sense?

Thank you in advance

Best,
Tao

