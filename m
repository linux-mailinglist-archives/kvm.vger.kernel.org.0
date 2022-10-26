Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE1A60D945
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 04:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbiJZC2E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 22:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiJZC2A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 22:28:00 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD46BECDA;
        Tue, 25 Oct 2022 19:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666751279; x=1698287279;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6dVrP/j/yzW8552r1u+KHx8IpZeawWVn39fZqnElNiY=;
  b=b0FtZofCyY5JVX7GEU2i97FsdN8laoE1YB9bnwjjIgxHL9PfVRCtUEkR
   0m2yTIvoOOhyOGQ17Zz1he+WfvzukqLqoNlkgdbC9t8vXs7vMFE8gcXOL
   E0XFAQKWh+1Z0MsvmunUxpnfWkiUqbtvBtF81dsKhgCkSbdAUaiyD2h5c
   9OU94Eon3rikA/4tLp/9BYwfUWeROeSRkSqqubPF4mk/a4uUWy0bxZjx3
   BuUM+rnvQea6V7Zy/Bp+7GVwO6a8ln6SURlMjjKjR5jWuv8MKIOYqr3tu
   73x+NVco2l3W6QKX7+tjsuFnEtO3LGJQTOAo/lQvU5yOnxLTb490A+mM5
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="287559141"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="287559141"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 19:27:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="695193306"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="695193306"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 25 Oct 2022 19:27:59 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 25 Oct 2022 19:27:58 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 25 Oct 2022 19:27:58 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 25 Oct 2022 19:27:58 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 25 Oct 2022 19:27:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AFVMr5inASdonUSQnlCQo13hzxUOr1UScBtcCSXa+HAPJLH82CKTtoHV9IGF70xWjsHdlLqMU/k9rchVyU61eSPgYT57SLxYFgr/TOuaa3XGj+XvgyAa/dWu+9D501o0lGYQEy9KRZD8QRF6jI8qHoqvWpluWWAd1R7QbOFIWQ2/PXaIbwlfxyGFfkvZ3tDmz4NDvimxMP3LaDtxsxr8z0VXIJTXef0xdew8LW20nRyM7cCERxWeTJB75r0nsmu/dM/xCJ6z4CLH/Op6eHpG3P4RdkWRyJtdE567ufJ/EAIwdSpnqCSBhYTBrzQRl0J49BCJ7MWGXH/qAPKjFGxMDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jjEgmzoLhH/5Kziwjzu7QHpmbrjYGU9MYwRwgQyTPAk=;
 b=oatvoLxYifjKNdR3cRuasI3pX3gIhSjZHReNnl7xThdmPf0LWOOmzdK/DmGAnAxje+701Hjq612MI2pvrGOsFhd8/YsCiGB4Ig7j56OclvPAtWH631+dKfHKCZc6C1wkfdg8KUpBBpj4vWvI7qCylUspV2dd4WdtrCNGtfrDdO9S/yv5omefSKdeTRdDG/T9ADLM8eRhAWD8H7pqznWbFT6STBlpMWvD7zykY313eRAN+DEXRGLdJ4+C+YVBk3Stu9RJEik9UVEG21Q4vd/6gRx8YuOUGRB5tswIb3nrvF+3Skz7/Ijr1elQeg7PhtFlI8GrEyTyRP3l61Lva+g7kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 CY5PR11MB6115.namprd11.prod.outlook.com (2603:10b6:930:2c::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.21; Wed, 26 Oct 2022 02:27:55 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246%6]) with mapi id 15.20.5746.021; Wed, 26 Oct 2022
 02:27:53 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Vipin Sharma <vipinsh@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>
CC:     "andrew.jones@linux.dev" <andrew.jones@linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 5/5] KVM: selftests: Allowing running
 dirty_log_perf_test on specific CPUs
Thread-Topic: [PATCH v6 5/5] KVM: selftests: Allowing running
 dirty_log_perf_test on specific CPUs
Thread-Index: AQHY5ZKzsJSoXiEDzEiLKUZFIm4C+q4f88hw
Date:   Wed, 26 Oct 2022 02:27:53 +0000
Message-ID: <DS0PR11MB637351B52E5F8752E7DA16A4DC309@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20221021211816.1525201-1-vipinsh@google.com>
 <20221021211816.1525201-6-vipinsh@google.com>
In-Reply-To: <20221021211816.1525201-6-vipinsh@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|CY5PR11MB6115:EE_
x-ms-office365-filtering-correlation-id: 9e847a51-773a-499f-2b2b-08dab6f9afc5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zJOa7VHwXo81RqaaVkSqtw2ruBHIxmcXTulT1ZSRIjX+suBi8G+uuo9xLRqQhUxJYqEqR9/WAkHq/QT7jHu4PRv4GSxmJvGHdOWzAHDdR2EUzuBCVXDKe9g+lqGRwdxktedyLUvk9HzdTf1ISEvDVYBCl5SFcwtQ+/hI9J1yFZf2NawnbJQGA46jl9s3o+joynlKBhv0cwtQkS19gzGRimD3bOPM4H1bQ0pCmX8GohXnbFzfoVuRIMOCWbYHDzyC4VpGzKgWdjrIl+vAOFmhJYJR1XKoq4+QiTu67Y4dBWyVBQZDrwP4RsHvZGVwxfMvMbJVW4rbcO/DC25fQAk4gqSmPbfjdYRWGATILSRjibTaU3OGkjgFTN+whepHaJIZqEEVXZgYcwXdiynHW36yJpNmRJ4/Qwx826e+Mp2Ygi1LwS2gBSZbxwnhbA875l/1qzd5rg5YZMuvDL3cmGJtEac+Af4cXc8abar+bm2xkWKw/ECGBkdwikeI2zs8ck23zwmh8+5ZmMxC0+ufKzDOjKsgFuEakuqnqi4XMZC5P3MraDLK73WfFIlcbPBDy3KR6d2s7wiz8ElKfTqcAwLY42OU+WIQ/aNfaamTh3dwDvFf2fAMVSVb3ucnjWoAzKFYb7bWiUcv0Xv//3cYFmOOBbaUYiVT2MImgRBRTCLr8memfGJSeo0Ty9+2g1HvTpa4/aQP64jW5lhi0446ETcxvR5okNARZsrft76raY20puQknRk++PM5yxx1BVEt5cdpUQ1IBGgfysttRYbkAmCU0M/bJl91SFaB/M4Yyu6uYyYochSBR81gRizQ80/fsdt4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(396003)(346002)(376002)(366004)(451199015)(38070700005)(478600001)(71200400001)(54906003)(2906002)(8676002)(316002)(122000001)(53546011)(66946007)(26005)(110136005)(41300700001)(9686003)(66446008)(66476007)(6506007)(64756008)(4326008)(66556008)(8936002)(52536014)(7696005)(82960400001)(186003)(38100700002)(5660300002)(86362001)(33656002)(76116006)(55016003)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JqiZm0+Vd17G6urFhDfEZEaT+7LizPZ4vN1daRj/q1s++b7L3UT2jQKHhVEk?=
 =?us-ascii?Q?r51M/PQkjtS541l47ONqARjdWQdoxm/bcPRiq4HE19LHn3vhCxqpGkiBW3ai?=
 =?us-ascii?Q?fi41dfKPtyz4LlaaD5FWDcjCE7oqePhB3FS5+01nM2sgJD5d2Tvt4ezlo6Cj?=
 =?us-ascii?Q?17wcW+8br1IGwFShHIMFf4AoRZ8ypbMN/quntvMafKZxQ57SD21jJU22Ed7Q?=
 =?us-ascii?Q?CaNKqD9HRIOwoq5rhOMCioJDj+bLmLKok6r2cqy/PwjvlUqTIokBdRJcjA6q?=
 =?us-ascii?Q?wVNMkPfjcMNEE4Er/nd76oq0r1+kUrDupZvjxafAL32zZeSoHkIQjOe0WhXj?=
 =?us-ascii?Q?OJN+bPLCK52LMAP/NgrzCcDimi6EFNawR93kMtndRe+6IEMa5r9PPbP2Lolc?=
 =?us-ascii?Q?OOUqWII2L8E7t5guVm+2e2bqtn16fsSKV7Qc75fjJrSnMUZyU15VJAZ4R21n?=
 =?us-ascii?Q?ZFisSQQIOrdaD9GkU+SF1TCnBL0hPNaBoDMwPbiC/FmmXitWT3sm0UVxvvDA?=
 =?us-ascii?Q?YfcE6awYXyfav/rB4kOE+6/D0drOxkDMwV5b3HL3gi3uRCqH6RnSXZRqzBx8?=
 =?us-ascii?Q?z61+zqSkW+nnxMjAJuvq/U2wVqKtRkEvkCoUzkvZf+9BsgGI6sqqVtccWseh?=
 =?us-ascii?Q?bMAZdNxciGjHdIFkJtaSrR96CFIBFiT6zWHBgT1lH3nH/iwj2GpQZ6fRNt2T?=
 =?us-ascii?Q?Pd2LbHuya7KcPwgXMVVo9Ubg5yOTBFcs3OGPGhd6lgb0gm/TTSMlk1+u1Rc5?=
 =?us-ascii?Q?gH78buqygN8gQ927eXCmNGd1Moccarazoyr1LgIL9Br2Yi8U3NaSLFP3n962?=
 =?us-ascii?Q?hIvIsLA+caBBSnxfQK3k3YSC3IRa/wHb4nfcU3TdDv4qtlyOE2dQR0KWtEgd?=
 =?us-ascii?Q?K67ri+7m4ghBmMNpQ5rgOoWZQEf4WnDf3rW8Sww6DlHby3Exu8IjUhEf3NNb?=
 =?us-ascii?Q?VxwIB9bw6l/zEfsm+hsaGOdrO6RPYxiDX1TlOBXNK3XC5+kNutCt6HTRwarG?=
 =?us-ascii?Q?y5jHFUdsFkJn65Db9G1d4EjQJ6yBdEuCcU/h5lI0be/CrRCn3lPu3yvvHik7?=
 =?us-ascii?Q?3u2/DDv5GwXC9MwA3XT7qR2y/dmZ3QGzXHtsbZ1PsAvqUJZaR5gncWuep9RY?=
 =?us-ascii?Q?pE0ngQ7dCJaTWwJQlALiqxOEE9hLJkuKoXvQ9VFpGF7UOqe9M3UiD3qT+buD?=
 =?us-ascii?Q?svmdzpkflsFuKgA6wdKwSv/PaBYGS8hjpX8zzalqZIxu31VxnR0rH9cShB25?=
 =?us-ascii?Q?hfFIkocXk+i7H1gpVE+7IXdduRJTH1Q+GnaCn7naG1GHRoljIyQdAWccy1xQ?=
 =?us-ascii?Q?bcJBQtv73A2UhyUPOkTcdlEdMoXEkt6DOUlUDYjAJWVRnE+eDUiXV/h5qnLc?=
 =?us-ascii?Q?LuQCHIlOytXQIKFS2DslKwKjsRBtAwXD2YEar8+uGLp1IUOLulJSwVRR9fES?=
 =?us-ascii?Q?J8ikDmRZkbarsgrlGe1zu1Kn/ai/8YnTMl0arTh5f6rFKjCUUNeJuyfxY9od?=
 =?us-ascii?Q?K1J1X9Jb8BHXv1sL3XkYXkDra7ERP7pdSa7g8XWFCqlaWZ2Sr52Fb219cPZv?=
 =?us-ascii?Q?1wi1ZjHn9mkXM32Kgh6qilCI1gaGSYbyy7vpFVae?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e847a51-773a-499f-2b2b-08dab6f9afc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2022 02:27:53.8236
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 46Cme3ZcsWOUBTEtbN2/poOQ5wnaeObP6efyKVF+mSQx0iEuQKbCyCNP3g4oGFQoSDC/E0A7a+WAAEv0Hqk1tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6115
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Saturday, October 22, 2022 5:18 AM, Vipin Sharma wrote:
> +static void pin_this_task_to_pcpu(uint32_t pcpu) {
> +	cpu_set_t mask;
> +	int r;
> +
> +	CPU_ZERO(&mask);
> +	CPU_SET(pcpu, &mask);
> +	r =3D sched_setaffinity(0, sizeof(mask), &mask);
> +	TEST_ASSERT(!r, "sched_setaffinity() failed for pCPU '%u'.\n", pcpu);
> +}
> +
>  static void *vcpu_thread_main(void *data)  {
> +	struct perf_test_vcpu_args *vcpu_args;
>  	struct vcpu_thread *vcpu =3D data;
>=20
> +	vcpu_args =3D &perf_test_args.vcpu_args[vcpu->vcpu_idx];
> +
> +	if (perf_test_args.pin_vcpus)
> +		pin_this_task_to_pcpu(vcpu_args->pcpu);
> +

I think it would be better to do the thread pinning at the time when the
thread is created by providing a pthread_attr_t attr, e.g. :

pthread_attr_t attr;

CPU_SET(vcpu->pcpu, &cpu_set);
pthread_attr_setaffinity_np(&attr, sizeof(cpu_set_t), &cpu_set);
pthread_create(thread, attr,...);

Also, pinning a vCPU thread to a pCPU is a general operation
which other users would need. I think we could make it more general and
put it to kvm_util, e.g. adding it to the helper function that I'm trying t=
o create

+ * Create a vcpu thread with user provided attribute and the name in
+ * "vcpu-##id" format.
+ */
+void __vcpu_thread_create(struct kvm_vcpu *vcpu, const pthread_attr_t *att=
r,
+		   void *(*start_routine)(void *), uint32_t private_data_size)

(https://lore.kernel.org/kvm/20221024113445.1022147-1-wei.w.wang@intel.com/=
T/#m0ceed820278a9deb199871ee6da7d6ec54d065f4)

