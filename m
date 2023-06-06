Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1847250A7
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 01:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240343AbjFFXSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 19:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240349AbjFFXRc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 19:17:32 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C44226BB;
        Tue,  6 Jun 2023 16:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686093399; x=1717629399;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SxN9pRtU1g9SpTvvr1CpPJOeO4aTXQG872rXZ1OIIYY=;
  b=an0lM5cgKwkmEE2t1oDB4ePIULXYL+kdfHkdqmmGq0Y0/iWmzQNwA2fb
   VMEm9FGTe1U7EJ5WX8JRU/R7NpiaLVbPsD2U943XouHmw8H68bF8ONluE
   l8sts+1x/HknZgVINbVDkLiyWJWsgYUHMcjkT3PwYSYM00DxAX+WiRp0n
   oYd8A1WmKMxaz4kt6LHtvzDLuhul20Inx3aa7btSBb2Lu3VVIwVoiAjWP
   FTolXPhZdvPYlatt4snEC2TdPoRpkWvamTzftmUPjm0ljWNMbTPt9EYlD
   zLfhylo4fkse7rqauJaHhLYJGfkeUa8kBG2HbR5Rg+KbrmcHlCNV1zi//
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="336448521"
X-IronPort-AV: E=Sophos;i="6.00,222,1681196400"; 
   d="scan'208";a="336448521"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 16:16:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="703374357"
X-IronPort-AV: E=Sophos;i="6.00,222,1681196400"; 
   d="scan'208";a="703374357"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 06 Jun 2023 16:16:35 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 16:16:35 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 16:16:35 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 16:16:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CK4fo8FGuU7CLuAz2i2VU3Zl/b1rGR6BluD3lIoM4oHLhXQvMBSv9EgY9nKB1su+3l3m9QynLkdQfU7AOh09qx4Q8tOGiZ5wRPOrRy+7mP1GR6jUQ+5oTqO2iHsxq/KIO5fAi1bMAUiJodyHx8LaJB5Kw2dmS1PqhmqTZLFdhVbWmb5JVzkZ896RXMrhkORHH/3+fcdXCs/m7GzU6gZ9NzsNejnO3dAxe42zb0jDFx6+NrE3U10mv8/DeTanEZTduhdfNbJXDbzQMcfYYAIoJmdERHB+Rvu8ToF0ikj0/1yQQsUKKMpz/nG6LhIZSVqUy65p5Smz4XR254BDqPP7PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=daz2G2/LxprFQ+X2aTrWW4SIofcKVEl/K960NssAEGw=;
 b=NX3SIjh64p3qlvoL+1YL08c6TJUOYhgoZaO0aXRzojIeT4LmoOefUdTARNFtzI35vtVdEJfvNw1ZAWskNd9gVfPR7c3U5SHrH/k1OOlsXuUROB5RwesZC8esMCj/D6U2iCDr1tj6+MLVeuJF+9lR9VaITRfjfkiTatn35IkFh0k4llDS6GaQoPgQgylnXRotCbnHNXCl+VQk0VzeIdsnevZIl2yINjWau38IcVPLrtXkL21wE86qf8kxUKH1BWGaRfjHoa+bhHSRnNsa1PIjd/q5TQwzSNle7gsKUgXhPTzr1tO1KYCdQ7ZmATjkUpNx/phM/7o5DJ9kf3vQmeTlAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by SJ2PR11MB7714.namprd11.prod.outlook.com (2603:10b6:a03:4fd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 23:16:20 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d38:3229:72d:88a4]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d38:3229:72d:88a4%3]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 23:16:20 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "Kang, Shan" <shan.kang@intel.com>
Subject: RE: [PATCH v8 01/33] x86/traps: let common_interrupt() handle
 IRQ_MOVE_CLEANUP_VECTOR
Thread-Topic: [PATCH v8 01/33] x86/traps: let common_interrupt() handle
 IRQ_MOVE_CLEANUP_VECTOR
Thread-Index: AQHZa4g62amPAW2/oE6/VfNOqnc7za9542QAgALl3wCAAACfgIABxIeAgAAzroA=
Date:   Tue, 6 Jun 2023 23:16:20 +0000
Message-ID: <SA1PR11MB673401D5E5027DADBC422ACFA852A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-2-xin3.li@intel.com> <87leh08e1h.ffs@tglx>
 <87edmp6doh.ffs@tglx> <70ef07f1-e3b7-7c4e-01ac-11f159a87a6b@zytor.com>
 <877csgl5eo.ffs@tglx>
In-Reply-To: <877csgl5eo.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|SJ2PR11MB7714:EE_
x-ms-office365-filtering-correlation-id: 7f11f6f1-d6ef-44b6-4592-08db66e4098a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bls1YkrWcFWzo/eZ/AvR1c8s21KtjhHUx+Ceju4XwktBX4quSTEFG5zvKZdB8tG5GsCOyEo8ptcvgnIjId6QqDESwY0uqVHfYM/fIxBbI5TlrZAqrAM7us44Js5jEtU2q5CfVTQxwCdmghIK3WtiNqdfwCYCqihP1wA7slSmVRPSk4giph3ySqY53Lh+U4ca/aGAyUex2TNjLF07iWqYl82fhPmpzayBzcp7haXaaVktusI39rDGz2n5oRbDn5j02Omq95Gxh3FCmeHhH7/10o10nsNuB9mDvDeVLe6+NDApsoIWTWGsCXuuWQcvS/pykLtAl6iWMX2Kwfqws649GMSLy1a5zuZ2y7vpLm4c6nSryf89JX8WHm7nh/koYXhnl2nJ6tZ3Pixu1TLM0PBAsF3W/znArH6vjbIKOnYCFzK60xMKRYah3gjDPc8jYqvNJmxBKged+ay95+0pTbjG5kxbD26qaVmVX7KHT2MQ9YiLg4oLw0CiiRGnPa42J5mSx/T9N2s8N0Cr0ZN/cJwbk7flbrH+9ZaeYgwzXlEkBj2p+H6qdl/VBPJVIfWr2EnmsW27UxI3MCScjYgzvV/WJuaWGk0tSFgYBv1VyV+gwVjPMnI9z9ob4bcA9N34C/6T
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(396003)(366004)(376002)(39860400002)(451199021)(7416002)(8676002)(66476007)(4326008)(66556008)(66446008)(64756008)(76116006)(8936002)(66946007)(5660300002)(55016003)(316002)(41300700001)(52536014)(110136005)(54906003)(478600001)(2906002)(82960400001)(122000001)(38100700002)(6506007)(186003)(9686003)(86362001)(71200400001)(33656002)(7696005)(26005)(38070700005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KgIaXeP96TSwep7frLM6XAqW+r1uVOZU9KH5axQaPTg96V3hlZhbTiSkVt0q?=
 =?us-ascii?Q?w/rpACc9G3V1AneeydXdW3b3QVE/IClBe/6mEvydKzqo9gdEzDiSTuLEPu0y?=
 =?us-ascii?Q?YCW7TaFPQTDE/+4iULmM/eBEBKpX4wizb0A3gZZZRzYa8BzSrztoCQhnI5Q+?=
 =?us-ascii?Q?6F5qVKXMeYL0mqcYYowx/nt3H6MQ8sB47XMB7gFFucV3BGKUPUgjl+CY3w/Q?=
 =?us-ascii?Q?6+zroOb26O4GGAhZlga5mDwpjAHxo/95CRPXdGvcLhrBPWcIOdeJ4kPe4bxC?=
 =?us-ascii?Q?sfcJE6LuBb3IyHbSstUXLmeIYgCSmhwwoAM6Vt5/OthRY45J0KF9U1ecylsp?=
 =?us-ascii?Q?jWc0Py6EqEC66gx/zyorDUIdSx9FhBLRd8Tu9tNlSMDDIdO5piyRSqh8/CBm?=
 =?us-ascii?Q?v+cqcptQidL/WwCEZ0gCH95jOiSy4A0vr/kR5r4gfnznXYQ5Ez7wzV8kPufJ?=
 =?us-ascii?Q?qThtvHT3xHPDVmzwa/8wT/5cyirj+ntBIn5jijPmXhxJrir3UzwDLXMwDY37?=
 =?us-ascii?Q?hF957HvvMKUVhddfrGL1iGPN0PnVKKcb/luY4/ZBwa0WilwETW3R/4DaG3LZ?=
 =?us-ascii?Q?96AR71zgRr+a8PVZdwXI1RzA3+FhWAVIu7VDOa06bp5Be/9qQTCmzjMLG3sX?=
 =?us-ascii?Q?Bje2dL14XcK8fpSPBMUyhekSVD6iNhVg9Czol77nKOJUfwpZ4TSb09MCWLBb?=
 =?us-ascii?Q?qijqRmqfY+eSj2FF6pNu8c97V7eng3Z5ww9NDqQVU7EsxhPNfNlZjJYI6SZc?=
 =?us-ascii?Q?IRbnIq6GhizZCzlCyqOy1DTx43nRjoeaBWj+RGinXV224Oe3dRn42NH+my5k?=
 =?us-ascii?Q?oNATsxTWuJKeINUc911N8Q15mXg9CMK+uLbkPXTnHGv7/VEj2HM1b0ZrC4Yf?=
 =?us-ascii?Q?KM/pyXqgU0KweEq/+TAIQq7t9gCl4j/rk2AN3BQMnA8eH9stJqTv1lkxFMAg?=
 =?us-ascii?Q?Lp14a3lfSvnASGhQ4GL6h8B3E6RErcJ21Yw2jdGgipLpHxzctxykMZjTqTdN?=
 =?us-ascii?Q?byjeD7INq4W1z8zBtPmkdWl1aPr17SWtLZ3N84l+h2Bzo4/+TUqyAAHGWsAY?=
 =?us-ascii?Q?bdKqGbXkU2X9x4jA5YPe9nPGwMtxF5FECgnuCGWfjZ5v71FYNTmoRqhbOqMd?=
 =?us-ascii?Q?htAZzG6X/XcqO/CJXONYP1n7Ak4SpLCPzWeQ6EhfjngaRacgW3VDxiKn1w8Q?=
 =?us-ascii?Q?4/c3R8sR1oalx07qWFEWjSYySWQuaoxnI+4wi6RGx5Kd3aMvBb527znIWVLk?=
 =?us-ascii?Q?3mPVC7Icl4hcHbpa+4HPo3MvwDPZGekaulUQPAuoRGygYBoz3X/ZdU3XisGM?=
 =?us-ascii?Q?5hDQGJ1LsbIFGzceJDNCf9CtczLG6hMXN1YcRyOxsgUCcyaA51PnednvQpZ6?=
 =?us-ascii?Q?LQyg38syO8Zirr3AQ/Q2CkaU9OFRW6JHicRADvyBqdPmgDTC6mGW6gQvR8Gz?=
 =?us-ascii?Q?2z2liT3LE2sXZA71sIqMPR4k63F9M0zpg2BpEVoaTxprrKI4rhpy2zWVqtTp?=
 =?us-ascii?Q?bgE28UdqVQUHDeCBjaKeQaqrNZo3h8iuoS+SbNdk1mYJRbUnDLf7rbIdkDg1?=
 =?us-ascii?Q?s62R7JdmEhgjcOp5kNg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f11f6f1-d6ef-44b6-4592-08db66e4098a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 23:16:20.1488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2IfmmZH0SIYYlosui6aoSlIMsHBUEVAUhBBVcqx6Sr/4Er2XxuXW3WdTNX6MMpv8Vv7nbTJ+3PP+FM/uj+IJCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7714
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> The untested below should do the trick. Wants to be split in several patc=
hes, but
> you get the idea.

I will continue the work from what you posted.  Thanks a lot!

Xin




> ---
> Subject: x86/vector: Get rid of IRQ_MOVE_CLEANUP_VECTOR
> From: Thomas Gleixner <tglx@linutronix.de>
>=20
> No point to waste a vector for cleaning up the leftovers of a moved inter=
rupt.
> Aside of that this must be the lowest priority of all vectors which makes=
 FRED
> systems utilizing vectors 0x10-0x1f more complicated than necessary.
>=20
> Schedule a timer instead.
>=20
> Not-Yet-Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/include/asm/hw_irq.h       |    4 -
>  arch/x86/include/asm/idtentry.h     |    1
>  arch/x86/include/asm/irq_vectors.h  |    7 ---
>  arch/x86/kernel/apic/vector.c       |   83 ++++++++++++++++++++++++++---=
-------
>  arch/x86/kernel/idt.c               |    1
>  arch/x86/platform/uv/uv_irq.c       |    2
>  drivers/iommu/amd/iommu.c           |    2
>  drivers/iommu/hyperv-iommu.c        |    4 -
>  drivers/iommu/intel/irq_remapping.c |    2
>  9 files changed, 68 insertions(+), 38 deletions(-)
>=20
> --- a/arch/x86/include/asm/hw_irq.h
> +++ b/arch/x86/include/asm/hw_irq.h
> @@ -97,10 +97,10 @@ extern struct irq_cfg *irqd_cfg(struct i  extern void
> lock_vector_lock(void);  extern void unlock_vector_lock(void);  #ifdef
> CONFIG_SMP -extern void send_cleanup_vector(struct irq_cfg *);
> +extern void vector_schedule_cleanup(struct irq_cfg *);
>  extern void irq_complete_move(struct irq_cfg *cfg);  #else -static inlin=
e void
> send_cleanup_vector(struct irq_cfg *c) { }
> +static inline void vector_schedule_cleanup(struct irq_cfg *c) { }
>  static inline void irq_complete_move(struct irq_cfg *c) { }  #endif
>=20
> --- a/arch/x86/include/asm/idtentry.h
> +++ b/arch/x86/include/asm/idtentry.h
> @@ -648,7 +648,6 @@ DECLARE_IDTENTRY_SYSVEC(X86_PLATFORM_IPI
>=20
>  #ifdef CONFIG_SMP
>  DECLARE_IDTENTRY(RESCHEDULE_VECTOR,
> 	sysvec_reschedule_ipi);
> -DECLARE_IDTENTRY_SYSVEC(IRQ_MOVE_CLEANUP_VECTOR,
> 	sysvec_irq_move_cleanup);
>  DECLARE_IDTENTRY_SYSVEC(REBOOT_VECTOR,
> 	sysvec_reboot);
>  DECLARE_IDTENTRY_SYSVEC(CALL_FUNCTION_SINGLE_VECTOR,
> 	sysvec_call_function_single);
>  DECLARE_IDTENTRY_SYSVEC(CALL_FUNCTION_VECTOR,
> 	sysvec_call_function);
> --- a/arch/x86/include/asm/irq_vectors.h
> +++ b/arch/x86/include/asm/irq_vectors.h
> @@ -35,13 +35,6 @@
>   */
>  #define FIRST_EXTERNAL_VECTOR		0x20
>=20
> -/*
> - * Reserve the lowest usable vector (and hence lowest priority)  0x20 fo=
r
> - * triggering cleanup after irq migration. 0x21-0x2f will still be used
> - * for device interrupts.
> - */
> -#define IRQ_MOVE_CLEANUP_VECTOR		FIRST_EXTERNAL_VECTOR
> -
>  #define IA32_SYSCALL_VECTOR		0x80
>=20
>  /*
> --- a/arch/x86/kernel/apic/vector.c
> +++ b/arch/x86/kernel/apic/vector.c
> @@ -44,7 +44,18 @@ static cpumask_var_t vector_searchmask;  static struct
> irq_chip lapic_controller;  static struct irq_matrix *vector_matrix;  #if=
def
> CONFIG_SMP -static DEFINE_PER_CPU(struct hlist_head, cleanup_list);
> +
> +static void vector_cleanup_callback(struct timer_list *tmr);
> +
> +struct vector_cleanup {
> +	struct hlist_head	head;
> +	struct timer_list	timer;
> +};
> +
> +static DEFINE_PER_CPU(struct vector_cleanup, vector_cleanup) =3D {
> +	.head	=3D HLIST_HEAD_INIT,
> +	.timer	=3D __TIMER_INITIALIZER(vector_cleanup_callback,
> TIMER_PINNED),
> +};
>  #endif
>=20
>  void lock_vector_lock(void)
> @@ -843,8 +854,12 @@ void lapic_online(void)
>=20
>  void lapic_offline(void)
>  {
> +	struct vector_cleanup *cl =3D this_cpu_ptr(&vector_cleanup);
> +
>  	lock_vector_lock();
>  	irq_matrix_offline(vector_matrix);
> +	WARN_ON_ONCE(try_to_del_timer_sync(&cl->timer) < 0);
> +	WARN_ON_ONCE(!hlist_empty(&cl->head));
>  	unlock_vector_lock();
>  }
>=20
> @@ -934,62 +949,86 @@ static void free_moved_vector(struct api
>  	apicd->move_in_progress =3D 0;
>  }
>=20
> -DEFINE_IDTENTRY_SYSVEC(sysvec_irq_move_cleanup)
> +static void vector_cleanup_callback(struct timer_list *tmr)
>  {
> -	struct hlist_head *clhead =3D this_cpu_ptr(&cleanup_list);
> +	struct vector_cleanup *cl =3D container_of(tmr, typeof(*cl), timer);
>  	struct apic_chip_data *apicd;
>  	struct hlist_node *tmp;
> +	bool rearm =3D false;
>=20
> -	ack_APIC_irq();
>  	/* Prevent vectors vanishing under us */
> -	raw_spin_lock(&vector_lock);
> +	raw_spin_lock_irq(&vector_lock);
>=20
> -	hlist_for_each_entry_safe(apicd, tmp, clhead, clist) {
> +	hlist_for_each_entry_safe(apicd, tmp, &cl->head, clist) {
>  		unsigned int irr, vector =3D apicd->prev_vector;
>=20
>  		/*
>  		 * Paranoia: Check if the vector that needs to be cleaned
> -		 * up is registered at the APICs IRR. If so, then this is
> -		 * not the best time to clean it up. Clean it up in the
> -		 * next attempt by sending another
> IRQ_MOVE_CLEANUP_VECTOR
> -		 * to this CPU. IRQ_MOVE_CLEANUP_VECTOR is the lowest
> -		 * priority external vector, so on return from this
> -		 * interrupt the device interrupt will happen first.
> +		 * up is registered at the APICs IRR. That's clearly a
> +		 * hardware issue if the vector arrived on the old target
> +		 * _after_ interrupts were disabled above. Keep @apicd
> +		 * on the list and schedule the timer again to give the CPU
> +		 * a chance to handle the pending interrupt.
>  		 */
>  		irr =3D apic_read(APIC_IRR + (vector / 32 * 0x10));
>  		if (irr & (1U << (vector % 32))) {
> -			apic->send_IPI_self(IRQ_MOVE_CLEANUP_VECTOR);
> +			pr_warn_once("Moved interrupt pending in old target
> APIC %u\n", apicd->irq);
> +			rearm =3D true;
>  			continue;
>  		}
>  		free_moved_vector(apicd);
>  	}
>=20
> -	raw_spin_unlock(&vector_lock);
> +	/*
> +	 * Must happen under vector_lock to make the timer_pending() check
> +	 * in __vector_schedule_cleanup() race free against the rearm here.
> +	 */
> +	if (rearm)
> +		mod_timer(tmr, jiffies + 1);
> +
> +	raw_spin_unlock_irq(&vector_lock);
>  }
>=20
> -static void __send_cleanup_vector(struct apic_chip_data *apicd)
> +static void __vector_schedule_cleanup(struct apic_chip_data *apicd)
>  {
> -	unsigned int cpu;
> +	unsigned int cpu =3D apicd->prev_cpu;
>=20
>  	raw_spin_lock(&vector_lock);
>  	apicd->move_in_progress =3D 0;
> -	cpu =3D apicd->prev_cpu;
>  	if (cpu_online(cpu)) {
> -		hlist_add_head(&apicd->clist, per_cpu_ptr(&cleanup_list, cpu));
> -		apic->send_IPI(cpu, IRQ_MOVE_CLEANUP_VECTOR);
> +		struct vector_cleanup *cl =3D per_cpu_ptr(&vector_cleanup, cpu);
> +
> +		/*
> +		 * The lockless timer_pending() check is safe here. If it
> +		 * returns true, then the callback will observe this new
> +		 * apic data in the hlist as everything is serialized by
> +		 * vector lock.
> +		 *
> +		 * If it returns false then the timer is either not armed
> +		 * or the other CPU executes the callback, which again
> +		 * would be blocked on vector lock. Rearming it in the
> +		 * latter case makes it fire for nothing.
> +		 *
> +		 * This is also safe against the callback rearming the timer
> +		 * because that's serialized via vector lock too.
> +		 */
> +		if (!timer_pending(&cl->timer)) {
> +			cl->timer.expires =3D jiffies + 1;
> +			add_timer_on(&cl->timer, cpu);
> +		}
>  	} else {
>  		apicd->prev_vector =3D 0;
>  	}
>  	raw_spin_unlock(&vector_lock);
>  }
>=20
> -void send_cleanup_vector(struct irq_cfg *cfg)
> +void vector_schedule_cleanup(struct irq_cfg *cfg)
>  {
>  	struct apic_chip_data *apicd;
>=20
>  	apicd =3D container_of(cfg, struct apic_chip_data, hw_irq_cfg);
>  	if (apicd->move_in_progress)
> -		__send_cleanup_vector(apicd);
> +		__vector_schedule_cleanup(apicd);
>  }
>=20
>  void irq_complete_move(struct irq_cfg *cfg) @@ -1007,7 +1046,7 @@ void
> irq_complete_move(struct irq_cfg *c
>  	 * on the same CPU.
>  	 */
>  	if (apicd->cpu =3D=3D smp_processor_id())
> -		__send_cleanup_vector(apicd);
> +		__vector_schedule_cleanup(apicd);
>  }
>=20
>  /*
> --- a/arch/x86/kernel/idt.c
> +++ b/arch/x86/kernel/idt.c
> @@ -131,7 +131,6 @@ static const __initconst struct idt_data
>  	INTG(RESCHEDULE_VECTOR,
> 	asm_sysvec_reschedule_ipi),
>  	INTG(CALL_FUNCTION_VECTOR,
> 	asm_sysvec_call_function),
>  	INTG(CALL_FUNCTION_SINGLE_VECTOR,
> 	asm_sysvec_call_function_single),
> -	INTG(IRQ_MOVE_CLEANUP_VECTOR,
> 	asm_sysvec_irq_move_cleanup),
>  	INTG(REBOOT_VECTOR,			asm_sysvec_reboot),
>  #endif
>=20
> --- a/arch/x86/platform/uv/uv_irq.c
> +++ b/arch/x86/platform/uv/uv_irq.c
> @@ -58,7 +58,7 @@ uv_set_irq_affinity(struct irq_data *dat
>  	ret =3D parent->chip->irq_set_affinity(parent, mask, force);
>  	if (ret >=3D 0) {
>  		uv_program_mmr(cfg, data->chip_data);
> -		send_cleanup_vector(cfg);
> +		vector_schedule_cleanup(cfg);
>  	}
>=20
>  	return ret;
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -3639,7 +3639,7 @@ static int amd_ir_set_affinity(struct ir
>  	 * at the new destination. So, time to cleanup the previous
>  	 * vector allocation.
>  	 */
> -	send_cleanup_vector(cfg);
> +	vector_schedule_cleanup(cfg);
>=20
>  	return IRQ_SET_MASK_OK_DONE;
>  }
> --- a/drivers/iommu/hyperv-iommu.c
> +++ b/drivers/iommu/hyperv-iommu.c
> @@ -51,7 +51,7 @@ static int hyperv_ir_set_affinity(struct
>  	if (ret < 0 || ret =3D=3D IRQ_SET_MASK_OK_DONE)
>  		return ret;
>=20
> -	send_cleanup_vector(cfg);
> +	vector_schedule_cleanup(cfg);
>=20
>  	return 0;
>  }
> @@ -257,7 +257,7 @@ static int hyperv_root_ir_set_affinity(s
>  	if (ret < 0 || ret =3D=3D IRQ_SET_MASK_OK_DONE)
>  		return ret;
>=20
> -	send_cleanup_vector(cfg);
> +	vector_schedule_cleanup(cfg);
>=20
>  	return 0;
>  }
> --- a/drivers/iommu/intel/irq_remapping.c
> +++ b/drivers/iommu/intel/irq_remapping.c
> @@ -1180,7 +1180,7 @@ intel_ir_set_affinity(struct irq_data *d
>  	 * at the new destination. So, time to cleanup the previous
>  	 * vector allocation.
>  	 */
> -	send_cleanup_vector(cfg);
> +	vector_schedule_cleanup(cfg);
>=20
>  	return IRQ_SET_MASK_OK_DONE;
>  }
