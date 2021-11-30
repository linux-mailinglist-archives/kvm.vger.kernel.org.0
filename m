Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B15462E7F
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 09:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239634AbhK3Iac (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 03:30:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:34962 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234594AbhK3Iaa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 03:30:30 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10183"; a="233670733"
X-IronPort-AV: E=Sophos;i="5.87,275,1631602800"; 
   d="scan'208";a="233670733"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 00:27:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,275,1631602800"; 
   d="scan'208";a="458756576"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 30 Nov 2021 00:27:05 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 30 Nov 2021 00:27:04 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 30 Nov 2021 00:27:04 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 30 Nov 2021 00:27:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kl9JvRYWtEENQIyuIcund9nEL4sLf2A8wYiXCFfe7VvIGAt6T8vvs2mIX4b/srxKNCtVTlFohSqf8RyCPGyKM3sqRrJ1/oL3fUM0BMYax5zaCk7EOl/SqARHgjE1POTNiuK4LskY4Wy5I1MNMS8tgzSc5daI+x9iMuhhUjY5DBnTGm7BFJBux/vmfbaNP4zhAFB/J+K4+3z+YFzWFXBZwQOTGWwgezmXpu4i7ZRha/xdQj34NtOnaC59uZeRDQAomle0d638W44KjgEC6vnl+z9hJ2340x8GV56MZdM9HUnv010P224A0pOf8iebyVEGS3kHcX4HkMt7JLxALiFSBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=34NdyHZMNoyeKCydK1Po8IenF59zo0AeNZ3qvY75YhI=;
 b=lmnX+9Zst2cPCq7OxDfhy2P5dt43kfWUzzTp+EBsHbiVpFshzgxyKgF+2ixl/pd73dkgWuWyD0vn1OG3ihtmKsRs1Jr0kD/U0c3Wacvgavq7lxu0oAwXY4ayeqN1L4Udjccd2/huxXhJPHO2B3ZJbq/v2CyNuxteDQL+L+FNXyuewrQiSuxOzWmHXqsFMj3Nomg+SZthReu4FFZS9Ty/NAmgOkysYgc8JI4sUiqjrRKGWGRbwl5llEhKMZz+i3b8/GV4eYsaA5n1weXIu1nL5bsXu4+e7DeliEnv6dB325hFgSC2nZmL9zm1E9dGo7GMB4cYt2gqJpkGa0xQyum8Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=34NdyHZMNoyeKCydK1Po8IenF59zo0AeNZ3qvY75YhI=;
 b=pHWdbEfRsLHAMkU5m0je+y5Do6JUPqyAj6wQ5Evz1a3Ij7ca7mZISoWzhVT1II9NiWIHXTiZHRiBE0Xa8VsA/k8wMV3AdvieffObps01NLO7hUTo1wnun+PK6hQB52QEfM+wVTJJLef0YM6IHe+nHBb/IAFvzFwEh9TVdOteySU=
Received: from BL1PR11MB5429.namprd11.prod.outlook.com (2603:10b6:208:30b::13)
 by BL0PR11MB3380.namprd11.prod.outlook.com (2603:10b6:208:69::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Tue, 30 Nov
 2021 08:27:02 +0000
Received: from BL1PR11MB5429.namprd11.prod.outlook.com
 ([fe80::7996:88e9:9e4e:3a46]) by BL1PR11MB5429.namprd11.prod.outlook.com
 ([fe80::7996:88e9:9e4e:3a46%5]) with mapi id 15.20.4734.023; Tue, 30 Nov 2021
 08:27:02 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Q. about KVM and CPU hotplug
Thread-Topic: Q. about KVM and CPU hotplug
Thread-Index: Adflvg/SIgoQKcU9QlaunmfcAiKUJg==
Date:   Tue, 30 Nov 2021 08:27:02 +0000
Message-ID: <BL1PR11MB54295ADE4D7A81523EA50B2D8C679@BL1PR11MB5429.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9759637a-46bb-40a0-560e-08d9b3db2fa9
x-ms-traffictypediagnostic: BL0PR11MB3380:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BL0PR11MB33807AE1D582D85728C37E898C679@BL0PR11MB3380.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7BCre1bqea5YFArLsOq5Cx3QADBaGZogCPaOcSDGb4Qvh+b1rXc9VltTXePc3sArvMBS91u2O76ltKveZar/6nnZkOuCPRkyZcP4h6IlRPTMgZDTGIe51brmS9319FHMcOP26hRqhlrYv6LJLk8rQf5yKbDbJHGsy8PRv6OegnlbpodcYDDhh8Eak40+5oQbCIsJ3dUNO2dR2rXMfp+fTZSdFHfylt4HSUX60KhKAgivHvASILmKLw+44+8JbuTh3aLZz0pP1CjYRcJbCx+8otqL275Vmj0zKxOuwAmEPGefkYeu9MOXIPfp4Fc5ZmfYfG2b7lvD40ZBGNpzJEeqFk7RugjEtJc3Fx3LjB51uFrQmdW6OJEHPXvXPXeBgePIZKwuHCQspUmfttu8oRDOjKZ8BbREOtqOMKfD86bmvbx208p7oFtNSCrh2vsjOMaNoJMQvyqAdCorwVAEJdAautUzBmjH3vQB/R6MTzTLnJ+/GhdW3Zc4tRv8CGJd61oddjczEJ8IQzCoZh0UAgU2G2QT8ZdpDsvlD/9GFJV/ogAY5qw7MZgtojcpio8wdnCSWfUfSU047mja5oF2VQuXomFjlqCeenny8x42l/BW+pt1OxIRyNUZgun7/jeODlQr+Tn7sUgLZ7tVNLEyykG+rsQS324zIBYZ/UbevZpIl9HZ65a86v9xFUiMev+IVpnocI5PetXzxBlgATn0tTlywg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5429.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(5660300002)(4326008)(107886003)(82960400001)(186003)(7696005)(33656002)(52536014)(508600001)(64756008)(55016003)(8936002)(38070700005)(66446008)(6506007)(66476007)(66556008)(66946007)(2906002)(54906003)(86362001)(83380400001)(316002)(122000001)(110136005)(9686003)(8676002)(76116006)(26005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Z4gTzkahk1aIfAhqHXflRoNFc3Mt3TL3UokDOeXAoxiEmITnnQIPjRUnu3s0?=
 =?us-ascii?Q?XjlbwVUbvbZYCJYxgvYxan7+QpOrphv0VdkEFt0Zc6qYoB6sFmc48xOWw85u?=
 =?us-ascii?Q?Cb+IpWG56jy2utgsZQR7d1BMnf9J1KCqgD9D/kxALRAjj4wFPPcM/ScGh3Un?=
 =?us-ascii?Q?IGD2Y87Z8P2o0xpQKpt6Lx4C0WBRkXjS220vH96H15gSxLm5EpVjztIMRhny?=
 =?us-ascii?Q?wyd937ACyZogd0jJCgLXS4nCWyGiabkyxdqooaBHIIgJVfkHLGUiLl97Amx3?=
 =?us-ascii?Q?JGO6s0KQ14fe+3BiyanMt4TIupcsDY6/ZS3XPo7g9OkxoUBhsnkvUTUZGaC4?=
 =?us-ascii?Q?lR6nq9WaLI9L5bRKZW+6MJzJ2VKA1eFi8KBVEJ+1XUtserNktVHQ9cAC2avG?=
 =?us-ascii?Q?YO1QgilBooD4s9ePPt7SXacgTgQ9JOJuvQKk33ZAHcHwYpg5MbLSaK9zzJKf?=
 =?us-ascii?Q?dkcCR4CYD9y1vgGluCLlgzO2oICjyhEqDp2m9Y1RTM9gybiubFvU0BSSt16R?=
 =?us-ascii?Q?vdEPdfiSCuPy5yYshiJ8uHxfBLiFnn+X4oN2eSDJABnfbBJyjBaz0GgmLYkJ?=
 =?us-ascii?Q?AWNdrYIdXMj8KFwkjvGnMw4RcnTLW/60CzCHrJel0yYoN8uHzUx3ZL1uTW1F?=
 =?us-ascii?Q?/IEGhA1A/t1Cm/Ybw0x8+TSZcUVHISAhNoc7lnR5wxe8v6flmrxbbXCPrNTy?=
 =?us-ascii?Q?YfPBYTkITs+ZK7gxYRkf9ai4ahPxgOnUARP5cOTlgAOMuYz2HV0lNWWFZa6L?=
 =?us-ascii?Q?8BNYhk/thDR7ykp9i7gCIq1SHtMOwICrjqYb4q3hJhH03WuCdPDDZysmNym7?=
 =?us-ascii?Q?iLk+ZArayue/oBH8kSF+qMWs54tCaCMmvElkFHlm4zg9GN4wJJULN0ANpJRy?=
 =?us-ascii?Q?7v8U+9TyeTDD5BfiUqWSMrGSLeV2i9Y4mbJ/KSfx5C2MkVsULfvxo5k1dX4x?=
 =?us-ascii?Q?uQqC+IVfB4BTJ6JxffucjO4teh5bV84HQZckH9H6UCVkJUxO35MPk85Me2rT?=
 =?us-ascii?Q?hW2ZKJR6CP5EDt5bRRObgX4umpurFF5u6owFV/kznEBQYXQScxgDy1EnvJ/0?=
 =?us-ascii?Q?fhi5b0Ea4tDPS5ee3zLD7XFX8DFgdOIs1A24Zc4A+7IGKnCS/meqMFk162eq?=
 =?us-ascii?Q?8jpjgeCbv4lyrnW8MV9p7GP0eZ70k2uATg+giCq0p9xGjhy0tm1sR3UaYuEt?=
 =?us-ascii?Q?0mQxnFnBGcUHpqU5Wih/DETrR8PfyCGc9PU8yxSR52f1Bw9KOc5o/MfZKLhs?=
 =?us-ascii?Q?fPKRUjHy8FGegAnpXXqrffl1pjIEE4tgu8vkKqu8XUcnOVVPbMJlJdbbRB5R?=
 =?us-ascii?Q?n96Wimwow0MUbpKxoMGVGzlvb1uFk0dJ3lKX53EpUc1ooWyfPmshQXxL6uuB?=
 =?us-ascii?Q?gVBwfDgq4zeFiKxWTqMzW28K3e9VpcY10W2KB6NRhs+E+UGKNtyBUhzaPpWU?=
 =?us-ascii?Q?+fzdjjLDXD3iKji6cGSH4Wi08lJr9V3OGV3PnoePx5UthESMHsCLCmX7Ius0?=
 =?us-ascii?Q?SBOEvHqR6siGpli5+BTA86dmBYXIxNp3HBmSAHgns2+0PvyS74aSXYvyU1aO?=
 =?us-ascii?Q?E3YXnFI7s+NtIclojy+Cg/3OmaW6ADqEgYunrnpzkLBKpIOyJVRQEmclrzTV?=
 =?us-ascii?Q?8PSEvLr4vI/XQcmQxurLrc4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5429.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9759637a-46bb-40a0-560e-08d9b3db2fa9
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2021 08:27:02.6959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uZ0CP+qJZQT+4Fi0TaRJzMuaU+/RjQKLK9ki89TurRRwBqlCMm+bp1sAXM26LwLk1b8gVixMZh6FfF7AFhGzAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3380
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Paolo/Thomas,

I'm curious about the consequence if KVM fails to initialize a=20
hotplugged CPU.

Looking at the code KVM has been added to the CPU hotplug state=20
machine:

	r =3D cpuhp_setup_state_nocalls(CPUHP_AP_KVM_STARTING, "kvm/cpu:starting",
		kvm_starting_cpu, kvm_dying_cpu);

	static int kvm_starting_cpu(unsigned int cpu)
	{
		raw_spin_lock(&kvm_count_lock);
		if (kvm_usage_count)
			hardware_enable_nolock(NULL);
		raw_spin_unlock(&kvm_count_lock);
		return 0;
	}

kvm_starting_cpu() always return success as the callbacks in the=20
STARTING section are not allowed to fail.

However hardware_enable_nolock() may fail for various reasons:

	static void hardware_enable_nolock(void *junk)
	{
		int cpu =3D raw_smp_processor_id();
		int r;

		if (cpumask_test_cpu(cpu, cpus_hardware_enabled))
			return;

		cpumask_set_cpu(cpu, cpus_hardware_enabled);

		r =3D kvm_arch_hardware_enable();

		if (r) {
			cpumask_clear_cpu(cpu, cpus_hardware_enabled);
			atomic_inc(&hardware_enable_failed);
			pr_info("kvm: enabling virtualization on CPU%d failed\n", cpu);
		}
	}

Upon error hardware_enable_failed is incremented. However this variable
is checked only in hardware_enable_all() called when the 1st VM is called.

This implies that KVM may be left in a state where it doesn't know a CPU=20
not ready to host VMX operations.

Then I'm curious what will happen if a vCPU is scheduled to this CPU. Does
KVM indirectly catch it (e.g. vmenter fail) and return a deterministic erro=
r=20
to Qemu at some point or may it lead to undefined behavior? And is there
any method to prevent vCPU thread from being scheduled to the CPU?

We found this open when considering TDX and CPU hotplug.=20

By design the current generation of TDX doesn't support CPU hotplug.=20
Only boot-time CPUs can be initialized for TDX (and must be done en=20
masse in one breath). Attempting to do seamcalls on a hotplugged CPU
simply fails, thus it potentially affects any trusted domain in case its
vCPUs are scheduled to the plugged CPU.=20

There is a puzzle whether we should just document such restriction or=20
need more proactive measure (e.g. to prevent such case happen). Since=20
it's similar to above situation where KVM fails to init on a hotplugged=20
CPU, we'd like to seek your suggestion first.

Thanks
Kevin
