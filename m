Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FEC652688
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 19:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbiLTSsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 13:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234130AbiLTSsE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 13:48:04 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19AD5244;
        Tue, 20 Dec 2022 10:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671562078; x=1703098078;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ekiWUYI5HUBvdQxJHWfY7vkjtooRNC+QMYpkJ+Wc7bc=;
  b=E5is0Ac5RNCCtwE2TRvFMNQIGoncDNSaCOw7rjdZKE2DMFQsYlafpnxF
   530/iAkHyDmHIgwYBNedfSa46NO6fQyxSm6fIz7XoY+zuLval4PsVn8M3
   CRqg7yadwzAhcFBkSEiABDSj7QVN8Qu5w5LllRCRaIMFExHkBqpc8EInm
   GBURTwLH9t/Og+2IEkzMXtUDbYYifw+TYRzO8dY0ZtM3YVmvBB49CxYZr
   LTRj/dQXheKo0cbtMXjf9eGFAWzbFQC8S1lr6fpW7vLirBeXL1FDt+pVe
   OVcvaas213953yFiowoGZ8VFQ2wrKAm4UyaKA27jswE5iVDp5uDcvN3tH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="381915023"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="381915023"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 10:47:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="651129668"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="651129668"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 20 Dec 2022 10:47:56 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 10:47:56 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 20 Dec 2022 10:47:56 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 20 Dec 2022 10:47:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F6JP7NqI5k6r5qqw6ZeEw67FN/dl9oicffmDv4ckzKhpxRylLsxdRqJ6Gc4r81prv+OOS6DDiIyaBxwTK+aHCBki083ORyQ+90w6e/EFWXG+i8a0GQyV8/a/Md7nDikNGwYlQ8fDsutTBO0+Qvd+HmIdMGBGG/I5RbJqRGsTjzePL32tvgP/QHZi+CpVeOcap9YQg2kchgW0qyMzh+neeUn/Fv+PC0zRjvBthLvYelBkM59ibSm0jAEP5jB4H39bFuowcXG3s+r72JbQtdvmNTm7a4q20f3jCzdoX9q13YQzte7AxlGRnLjTPnY6kf9NWlsxHYkoJ+WEbWSvRugOPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ij44gNc20eB4ZCX4Pym6qWmP8xLTtY1YRk/K4sIUAKQ=;
 b=RqhhU7KtlY/N9d6amZEOQ2vBbQbE1izpVwKdVUn2Ql+qrpVxrV7J13V9fuErjFjPr8rMQ3HBu9pgw6IlPcfno/gMCCnrTJ4bSae7zUAd89FCzizwZjJg4eSV1OIePxc4Djg8SZgIhVskogYnP2g+8B/3Om7aYxc+hjcOpMDdJ5Kc/zn+mMNyYvYGqUCYTjiCejMgIfXVjfwFGqQSmUcvPfGDIyM3D/9ToqHnro6NjZqZrprWRxFXwAuPNHFwt3i/mTs6mYPm/oZrkhbKQ1hFSfvNcrXZVwoSBXiL6xjHXeG6yDsGRVfPdxeG7Pd8ycR60bSmL+xYwZt556G0Dc79cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by SA3PR11MB8076.namprd11.prod.outlook.com
 (2603:10b6:806:2f0::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Tue, 20 Dec
 2022 18:47:53 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::5cbf:a669:456c:e130]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::5cbf:a669:456c:e130%6]) with mapi id 15.20.5924.016; Tue, 20 Dec 2022
 18:47:53 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [RFC PATCH 23/32] x86/fred: update MSR_IA32_FRED_RSP0 during task
 switch
Thread-Topic: [RFC PATCH 23/32] x86/fred: update MSR_IA32_FRED_RSP0 during
 task switch
Thread-Index: AQHZFEEtGjKidcc/l0em/MMw2NP2fa52h/wAgACVoVA=
Date:   Tue, 20 Dec 2022 18:47:53 +0000
Message-ID: <BN6PR1101MB2161407D45208C69D32164F0A8EA9@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <20221220063658.19271-1-xin3.li@intel.com>
 <20221220063658.19271-24-xin3.li@intel.com>
 <Y6GE/Fnl1tuER1fF@hirez.programming.kicks-ass.net>
In-Reply-To: <Y6GE/Fnl1tuER1fF@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|SA3PR11MB8076:EE_
x-ms-office365-filtering-correlation-id: c464e853-b6fe-498b-b8e6-08dae2bab3d6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mv5wuOscfTrGMOkUpb9tDmabHrRuK33Dbsz5wTjdFFI5KmLuSLxey7YIe+1JgtbXhWFZyeVJ5ZHV0BQJ/wYystnGdl3I08PF/yU8eWlchG70BlMEu2IcQdCFex0qndXbjDxOw5Z7AlxI1NMqzMtGfJPNl5eiUln2og6dbQ3MAK99dCpjOI4w3aWe7gYdIaktDu7M0uCNm/4LylxDU8QYhnovZVDp152H4sfORPlR1teikmk5T4exTQ6y8cf0o7eghKB5ihdasxwsUhTHtTpds/JfT/e0fK3mjb7L0p50QNCSv+RovKW1wdzDIz3RotLfAQ5V1ziFtCKehe/yasCpf9nuAt50Pp+D9hCaT9dglWcmtPxB6Pv3fUGx8IkNvaFEkJBpnLa/A+GMq/anWdOoMff8N3IEkyLhMA/o0C296laYHztwA/B1/e3ReDmT7KHOnMVNgEoxPqhogjgB2aB89vBQB/lAPiKOpMvtAsPI9Kv0gn95Ar4PmHxwPVrpdTb08kWmanOPDf//9PiMq2cL8M9lUzhIyp+KgrsYpXFbQeT0GhOghx0n/Xwm5UeBwxxXCW0bWczdnX/xSdkowxe0mZRoCjNP4qvxUrhYMX9K6CwwaPve2dW8xTBMDBcnsVBaC19eFI0kZ/O2Di4tuQ9oWa37B0+jw+LxODDkfkQGAqalxD7y00uTA8F/8Vc0uEDa0l2UVA7SQsRT9iwAvisLLQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(39860400002)(136003)(396003)(451199015)(4744005)(15650500001)(5660300002)(7416002)(8936002)(2906002)(52536014)(316002)(71200400001)(54906003)(33656002)(478600001)(66946007)(66556008)(66446008)(66476007)(41300700001)(76116006)(64756008)(4326008)(8676002)(9686003)(6916009)(86362001)(38070700005)(83380400001)(6506007)(186003)(55016003)(7696005)(26005)(38100700002)(82960400001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xTrFT44DfcAHyGfB49dqdfKOchsoB0Y82hTyQXrSpGRWbeBo3qRZce0S43tr?=
 =?us-ascii?Q?73HbUB0TmQwCI8n3ZZ/IQC5iNuCOp2SKoTqXkBP9kRTnG1MZ6H7V8PKAgf6F?=
 =?us-ascii?Q?ZEbZCCDWppT/AjLNOT9gw0mi4vL4MvOf2guj4xhigyrEHvjY4ZXZn6U7cvuK?=
 =?us-ascii?Q?/eOMUniqgs7d9pLRah0r2SwsWEB7PJ5ir59VZ7ddcioNk2k33Dn+Ra86Jfsu?=
 =?us-ascii?Q?8c7UnmOIfEAwApWK3pjk4gB6PO2DI1VFM1+HjsKBK+5dASnWsHj0OKpJ7tvi?=
 =?us-ascii?Q?MYxQ5BbSFhX1NJkoPneQoX0xfBXUSEj7coDu+ltBQhcMRy9LrKZtF9I9OaAX?=
 =?us-ascii?Q?aE3cXqdeNBL4qU0MKJBtHk/AmCdkpI2jbfxfwRGbcDFaGtuGA0G2F9vYBdyO?=
 =?us-ascii?Q?OoVaBCJYu1UnjJpA+P4gzwpaRcr2+GQg0QmIP7jy4suz7nqf8AxHrs5c2M8j?=
 =?us-ascii?Q?0mR2qEe710TN/+t7Mv7ePJPLRiZ1lbT5GsmVqXEP24jwIlk8NOPbNnQvpKp6?=
 =?us-ascii?Q?N5GLYzbrF6tBBnhn8MLBhPO4BkxIBAsi2ipknMj/tZdtTIL3AZ7q7k9IyKG0?=
 =?us-ascii?Q?f3Rg5JXC2G1IU6ukkSeWO5ShTTyCvIG/ltI58HosVeCqy3O2GE9q9TpirzWI?=
 =?us-ascii?Q?AOdRNLbRqNsvdmHxbKmShosHJgrBLhQz7SFLZ8pghSe6g/cMNLZT+r+EX+JQ?=
 =?us-ascii?Q?nIppQ2r0PIFW352cYONE2YXV/CuvIeHakRDUZbs5wcXMeOchy8V+AE0XwdAR?=
 =?us-ascii?Q?6qo/fCLbhegadbq25dQrFskmC4MbRx9Gi9O1odEVk/SePo0QIiYD2Bi99AMb?=
 =?us-ascii?Q?3cx8P1YczCQ1WtGSxPK7YjC031GB9TrbLuOiOOI2zL/OSlJuXaM9NtjOyU19?=
 =?us-ascii?Q?C4w9dtzlydVor+m+qbRGV6KTYxZh4b5H9YpJFOYd7StOImSZ4THPvbHilpXd?=
 =?us-ascii?Q?HMKJpJsWonZVXkDWAMcQexwfQvR/wXbEhSpyp24neJjQ9GUrW/aEUaOFVjJ4?=
 =?us-ascii?Q?17ZV0RVmNFSz7S2DeYxrYNxnqE4hZo+uDs/Yfv1cKERZBRo3Dwo6FS2qc2yn?=
 =?us-ascii?Q?5FVB2akNLlh66uT2nnnYSmNJDdqysC0vZk9jAEwUE/kPZrSbK9AwAWREGHZC?=
 =?us-ascii?Q?XAVCC9dXilL8qDBwiccpRvwiGF6DPyFghmX8CkN9o8I6X3+6h83hPoGx/vIK?=
 =?us-ascii?Q?ZDqZmNe1Zj182DR7NxX40QeFKMO1MMT1z7zyW02X5DBLU9p1xGdR2Zx8a38V?=
 =?us-ascii?Q?iAhvHHWJM6tB+uF8MhSDhp5KqRRfKmKvvxnHg2UPclrgweCnttV82/mURy/W?=
 =?us-ascii?Q?UdZ786sSApOlyzN7hJ7vp0NO1mdsc9unkDpCOyW/FTE62GkfRhhExkWwB94E?=
 =?us-ascii?Q?Q54PAeuB3Ie2uchg23bcP4IORH0Rsnibr28GTCD0eaWYJNa6y4P/n2AOe6OX?=
 =?us-ascii?Q?82pERsboMpqxzMnnYRxlcY/hDDClYwo+e//T+IVoRpdoCFgqZyzgCAq44f8l?=
 =?us-ascii?Q?g7VPc2OVuVs4c4c2nl2ShCix5RG0QKyTQxf492beGQHRuSPjiE9YQwfSEXC7?=
 =?us-ascii?Q?z1zFU+ch9WbU0baIxXQpYPNoW/VkN1Lq5qFYYAbe?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c464e853-b6fe-498b-b8e6-08dae2bab3d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2022 18:47:53.4709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VGssN7mjf2znq9ckzp07mbDIBPz0AWXnwLKKzRQQk00GMRbZHhhPF496V1QDudHB/J54oJPg5/SRaHYqxgtWww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8076
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > --- a/arch/x86/include/asm/switch_to.h
> > +++ b/arch/x86/include/asm/switch_to.h
> > @@ -71,9 +71,13 @@ static inline void update_task_stack(struct task_str=
uct
> *task)
> >  	else
> >  		this_cpu_write(cpu_tss_rw.x86_tss.sp1, task->thread.sp0);  #else
> > -	/* Xen PV enters the kernel on the thread stack. */
> > -	if (static_cpu_has(X86_FEATURE_XENPV))
> > +	if (cpu_feature_enabled(X86_FEATURE_FRED)) {
> > +		wrmsrl(MSR_IA32_FRED_RSP0,
> > +		       task_top_of_stack(task) + TOP_OF_KERNEL_STACK_PADDING);
>=20
> Urgh, I'm assuming this is a *fast* MSR ?

You're right, however that is another feature under development AFAIK.

Xin
