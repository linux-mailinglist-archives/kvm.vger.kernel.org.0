Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45711624C10
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 21:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbiKJUkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 15:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiKJUkL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 15:40:11 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF3E1E702
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 12:40:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668112810; x=1699648810;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PmOlVX+z+Q7UJHDdag1erbT9hHEjj0VPLyLc29R7tKE=;
  b=WC7cvoYG1qAFM5txbxFZsxFRUUYrBtD1EpaNIdEbbACeosqce1CjyFpy
   QUCQo/YLU6UKQT4/Ks5gV/HXTR7Kygo5FczXBzTC6AGAUaY4/HfpFRiRC
   8vLfCNYDKeqgGVyKvMZ82IYr4IpV5q6nL083fOxIaAsGpIUCPgkd20/sG
   svhoTCIsYisabi2tbs2mFOzR/RxooM8PFuta0q+SUa/mEPltX2NdxoM0L
   yNu7z1xbNENX5vOD6zBlKhW3Hwg3hNWlt+5fWxRlD/PtYbWwBUTJcGEZR
   I90C8o/6IeEIts7ty3LgnjHCDI3kZLW88SgXe8tfDZoAxGJywHZQcayMQ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="373562929"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="373562929"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 12:40:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="588322146"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="588322146"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 10 Nov 2022 12:40:09 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 12:40:09 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 12:40:09 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 10 Nov 2022 12:40:09 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 10 Nov 2022 12:40:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HeHn7Ge0BxYSLEjzFDlHdu0wo4unLcnLbHWSxEMwkutMfMiH68uKW7LSgBjR7dTLi+zqQBvPSx4ucOHUnyWzEixbWj6hwKSxwJ+wv6/tBA3+hZoM0qhEcvvgr+RBXjzC4+zzszfRku2EWQVY+CRelTr3pLkcLCmzxmgSeYNkvaXVWPR7QnIXpIqb5yBLTDkgNlBiRJiTuAFGhOJXYcv3EMlMS1xoYV+iYFcCcdcn/Gb8SJ4s3YwA/swyZcBS+6+lltfSyNUSIXcVhWqBlg9Bg3Mrouds3RyikpWyVhTffONoa6bMUloJDBjxwfs/CXd8DM9hvJjr7Pt8+OYnOxgsqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KvWR6uK5WBgfxYNU9kFQN1T9hl8ffTUcar0ae9ZIMSE=;
 b=gBBUvA/v21Uu1JNn5rVJNIgqtgu6HxowfDwP33qOBE6H3iGLwnDLPdoLpcmcRAbnWuABrj4vgayjmtTvWbD5NB5HS8OYmKGmDOn9Vq9se9YmIhZCqOavkjQ0JWNN8ye8ayOh9VZkkfeOE9nnfeN+HoMl1LxVuW3T3bX+mX6Sj/pdy4lIDT6+O1GrIwAQzT+P00NZbGv+kHMLVK0vcjut3Op3MerWBAOvSN7SQ3acG7hJybJiI1MxSBmuvr9JmcpxIJnHpxGnhpijiVw3Ha501mi96KFH5E2lC5phuFwPovJFcoyq7TtcuheRZxOGygCIfEhl1mrOAs/3RmJsqjrGJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by CY5PR11MB6437.namprd11.prod.outlook.com
 (2603:10b6:930:36::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 20:40:06 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::40a1:5197:e1df:bb6c%11]) with mapi id 15.20.5813.013; Thu, 10 Nov
 2022 20:40:06 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "linux-kernel@vger.kernnel.org" <linux-kernel@vger.kernnel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq() for
 NMI/IRQ reinjection
Thread-Topic: [PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq() for
 NMI/IRQ reinjection
Thread-Index: AQHY9MwiNyyftQUqnECEfv3VPyPgfK44UVAAgAAslsA=
Date:   Thu, 10 Nov 2022 20:40:06 +0000
Message-ID: <BN6PR1101MB2161C2C3910C2912079122D2A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <20221110055347.7463-1-xin3.li@intel.com>
 <20221110055347.7463-6-xin3.li@intel.com> <Y20f8v9ObO+IPwU+@google.com>
In-Reply-To: <Y20f8v9ObO+IPwU+@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|CY5PR11MB6437:EE_
x-ms-office365-filtering-correlation-id: 350146c0-428a-4bf1-67c9-08dac35bc057
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2e5M0rfJqu2CG0fsN8j5LhVsww4UlSvD/Tlg7577x3V08mwhtiEjoT6Z7paH7wF9fAwJPvYVySmmnPV2S3RDTL6q7yr5eH3GDHDB2Gvn5OmXSIGAFtkzE9tXcS/HXvMykqL4TIaiEauWG5icrBNtIYmiIvNPCSiJtVliwqCpc+5Dp9hy7njcTx4RrlSoJ6AEsJLGp7u7gT7q/krp+/GnczwmDue9rRdYjF5x6rB5Poj4r8f3CGi1xT388NZYNoHLGp6JZmuEYfI7hIBu7896isb2OxyVZjE6+vDsbAQnGEDrX5DyKZ+KdesIqWE+lQdPWz6mExXdLh0Q3BaoKS0aAfdukRevn14sm79NhA11pRqiAVx2IJQQe2uH8AWuu1hUYymmBtMn/4Nu2wRIIPBiIHKV01njQ3yRsri009aRAKQqajW1MJaHdlLmIZudRo9vKQJRv24vROyi2eQ8Qwi0GYGDdKKRI7NO7DX5IVr9OR0k77UxkxltiTCdxxfjvzw1/rEfz2VFfDNXj+p5HPQdK5T6A4IoJmU4CKONsXBcuFKCubhJvllLrpCwXc02sjN+oDn1/HV7gTfSmeXSv5GHUbr99SuCokx7/WmJmtZciFsDTS9K5kqQDeDE7Nlq/WWo08kkgVoaJoXj33JJ+da7EmDRR3Jq1OXQ+TOG53QEGm+FV0mmyahMZUckRZaj+lvum1CgbWGqB+oQ1wfdRM6++IXg9PP0FJ8nsDlaLHnZ2Nr+tPcY7svP7qPcZFQ0edXNA8m9EcqAV0bNmSYuwKFZPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(396003)(136003)(376002)(39860400002)(451199015)(55016003)(41300700001)(26005)(122000001)(76116006)(186003)(6506007)(7696005)(5660300002)(52536014)(86362001)(8936002)(7416002)(2906002)(33656002)(38070700005)(478600001)(82960400001)(71200400001)(6916009)(9686003)(8676002)(38100700002)(316002)(4326008)(64756008)(66946007)(66556008)(66446008)(66476007)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oJlAAC1+L2LuSllcYayvgO7AF2mUqi3s7+G0+6CJk3S969wVE+U5f6Us27MC?=
 =?us-ascii?Q?sC1aRExgmbzYRofGjnayqPr1pRjLm2zh1eC6LbZBO3AgZJ474dbNu/LC77Nv?=
 =?us-ascii?Q?qVVAQ3rwsFIo43CSeQPdrchrlE8jZmiETbc1psFwhJAohvnUpeqqMy0UtvPr?=
 =?us-ascii?Q?Gg+TUqRiAP0zaZv0KSBEX4yPIhKt+ME4WGcxxQn1MdsEwhdEpcPGFc49+qeT?=
 =?us-ascii?Q?HY8GMmHiepP9AQ3dgzpdl9CCqRKhkP7ythEHQIv4dSJ968H66tiotXB4XlM2?=
 =?us-ascii?Q?/qSbSpxmNUOKMox1pQlwuJK+TUtNkmaa5MWFGWlW++IikJtsXfRTnIaxR0Y1?=
 =?us-ascii?Q?SdlNxgSj2NftHl7BqauyvzH7O464YUSxrfFzhl2u80LyJX/A5VfpiUXD+fIo?=
 =?us-ascii?Q?Z5hwDjxXsEltCLiMg4Iskc4nDHi7VrB8H8Uz8eMwQ+aHEZYUAvrPf7GJ71y6?=
 =?us-ascii?Q?3/rf3Tlw3MynVZ1qq6FtfadmbQYeVNtj7BFVWwIMAxTlNUp7fOzerNq8zOJQ?=
 =?us-ascii?Q?3eTM2ksng8n2C30EPViQvHZqgbhkt3Ejew/vFtvOYvaC2MzRHbhuieFKMB7v?=
 =?us-ascii?Q?1TYnwyhzy9RyqcHBBFPOeK6ePdE5JVFg1400oFc2hK0R654YCXP6Fhuy3nhJ?=
 =?us-ascii?Q?21R4MixrcnJZmtga50LCbw2HJvNFGqqeDRrsHzbJ/wCFmGHo2w3SCtT2hsY1?=
 =?us-ascii?Q?SY/xUjLnyKBGKZNlbzgDC0XXqtaR0gV6GTyWODIDyAy/ZFBmSMZf153KSg9Q?=
 =?us-ascii?Q?KMjuhU2EpvqAkQ/DhyOwyseSK6K8fDAB2HccoTjNn2TCixfWvwL/Vc08jXZn?=
 =?us-ascii?Q?UKBRqVVD8eJYDgnhWFt4usup7ix1UMVihI9MnDT8YUA3GpvWnnRlUhVIwd/Z?=
 =?us-ascii?Q?G/hdi0LmTLiWTd/5IfoZwVj1734rWUWfHL72dLrX1M4PXhO0lwUGDc3lX3kj?=
 =?us-ascii?Q?BVaQ6wY3xc+o2qZEItEdAkSmYi722LT86UYbmSfseIkt0zLbbwd/PWuIk4d2?=
 =?us-ascii?Q?oj6IKXwAtADpeVLdPUj9uqJqL37seNDCIJbKvwkpoX7BvfYPHYsi2TdpDLI5?=
 =?us-ascii?Q?C32guCJPUm8KckU7uOoaAU8k44yXYm8DF6dHq7fZs1FMdhwo5RTJOxBvswgb?=
 =?us-ascii?Q?J0ltfamJFcNufruCgwZpRnqRkfVP7EAlkaHFcxY1u1/DG972hr4EFhcFnh5w?=
 =?us-ascii?Q?DgNk1G9pwn0cwiUjn1UhOufpNGHu7rlwR/g3U9QW0WYQZN0YDTJdMp6MF+Jd?=
 =?us-ascii?Q?z1hkxQtkR/wTjJs5No4voPMqXgXauasCUuls0IraMZWHaCEYKRNsSH/huExG?=
 =?us-ascii?Q?ZYwQMm8ayhci4aKcch4sF5My7p5Aj2qrw255oC5xP+1HQ5N+fCLMRg5dfcnh?=
 =?us-ascii?Q?fZJrkSQXSPK8r7PsnVART0V1gdapYrOr4lB7ns7wHrgtWSJA3WK3lCQ3FH5M?=
 =?us-ascii?Q?w8cUi5Vvu3QwfFh+lCreZX/9RK96FHggfiISZNJKqOqHhQnnjf2i2vTadO79?=
 =?us-ascii?Q?I4t0LT+phiiUwniJAPZcgx6d7XWFskPphCxnBuEarmUxU53rtk2TW5O4xITQ?=
 =?us-ascii?Q?IRNGlC7Zk0JtbeL3FOA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 350146c0-428a-4bf1-67c9-08dac35bc057
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 20:40:06.2271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pQaCa2T2f6GmwroXd6ygYmRlGlw/r0BKiliqCiY4axvX4ihvX0PqI142XX7eNXbg55NiHfbj9uyzKFXOHpjGHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6437
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > +#if IS_ENABLED(CONFIG_KVM_INTEL)
> > +/*
> > + * KVM VMX reinjects NMI/IRQ on its current stack, it's a sync
>=20
> Please use a verb other than "reinject".  There is no event injection of =
any kind,
> KVM is simply making a function call.  KVM already uses "inject" and "rei=
nject"
> for KVM where KVM is is literally injecting events into the guest.
>=20
> The "kvm_vmx" part is also weird IMO.  The function is in x86's
> traps/exceptions namespace, not the KVM VMX namespace.

right, "kvm_vmx" doesn't look good per your explanation.

>=20
> Maybe exc_raise_nmi_or_irq()?

It's good for me.

>=20
> > + * call thus the values in the pt_regs structure are not used in
> > + * executing NMI/IRQ handlers,
>=20
> Won't this break stack traces to some extent?
>=20

The pt_regs structure, and its IP/CS, is NOT part of the call stack, thus
I don't see a problem. No?

> > +static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu, u32
> > +vector)
> >  {
> > -	bool is_nmi =3D entry =3D=3D (unsigned long)asm_exc_nmi_noist;
> > -
> > -	kvm_before_interrupt(vcpu, is_nmi ? KVM_HANDLING_NMI :
> KVM_HANDLING_IRQ);
> > -	vmx_do_interrupt_nmi_irqoff(entry);
> > +	kvm_before_interrupt(vcpu, vector =3D=3D NMI_VECTOR ?
> > +				   KVM_HANDLING_NMI :
> KVM_HANDLING_IRQ);
> > +	kvm_vmx_reinject_nmi_irq(vector);
>=20
> This is where I strongly object to kvm_vmx_reinject_nmi_irq().  This look=
s like
> KVM is reinjecting the event into the guest, which is all kinds of confus=
ing.
>=20
> >  	kvm_after_interrupt(vcpu);
> >  }
