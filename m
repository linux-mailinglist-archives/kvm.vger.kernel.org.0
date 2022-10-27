Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBBF60F6B5
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 14:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235536AbiJ0MEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 08:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235445AbiJ0MEY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 08:04:24 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A2133A3A;
        Thu, 27 Oct 2022 05:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666872262; x=1698408262;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5ZG8iBlPb7KHoiRb3xbVebjfuSqXPlIcn5PcQI9v1vg=;
  b=Zu9afnpM0oFZcC4YT77XUzjJMc1i+TZh8PuQppMNSZ8qYPgYb+bbvZym
   lpX+ppUtfOeklgRLe32J0PaQBcLiz6b3IlrapEHZiRVWGHm9g0Ne3pYsL
   B9sk9tFRg9MyF45SYbxt7/VL+Z4Gnf2InrZLsc9zEsAmRXKq0NUmkaQh3
   1Zc09FFdVj7KLP2q9CVVd2bZT+p5Ew7uK2WilKEQxXLRCiI/oPtL7DQc7
   rERq7qzacmSnszxRvDiAY764vD/Pqdj+lIffOh7tC3Kjo/Zfd5HTE9EOM
   3DGMjHajpLp026sQJrCtluSRB/vxaydsshD4TLuzfEgT8yMGfcGCL+bAy
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="306933616"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="306933616"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 05:04:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="665655929"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="665655929"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 27 Oct 2022 05:04:12 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 05:04:11 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 27 Oct 2022 05:04:11 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 27 Oct 2022 05:04:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UgelFeg3XcvYpM3O/sr1FsSLTPTASudDhzylPBAo4TRvOHxi0vkP/ndsl9cmWfhx0hqRaBlYXl0hDVAsiJSzIQvOqten9xH3e1ixefNwbDUIQLsuic+leuWGKbgYWmRR++IctR2ScxbmkFtuLfJJftW6FjSkFTnl64N7icyAb6gFIFGifXbaNVI8kjyMropEjJNw616Z3FLvtZ4oXhONLvXj9Zp1BHbWO7XybvRtEzkcRfL1myRbVdjnxqS9D2J5YketIJKo5DrOIYs9f4HCzoJSytM92z8E3MrSKhDcExZiW09oFAR4P4jI1HqA6ltAAasZCmUwnimSXvgpzUy4jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zwtmco2sUtrwPX6nLynTadeeETuD/eQ3MToWi1PciKE=;
 b=RU3xAn95pHnBIdCWXIp5xNdx3YKZ4FmavPpSSbCmT4mP7CFZbYUYxJmYc/WxqAm4LPSGfOULFj5ahpBt3K6azSwKOMhDWjt5pxvwwbuUqBdNHQ+NTiknL5cgC3xv14MpRAMb0T72jU74fh3z/DQ3Uu7Gka37Hr+jlI3KUsxa35jJA+JSpyW8KJgdnLCAk1GCDdK546HELI+TgQswgplO5MJVsf52xtu0xHgUPmNYQjW1kVFLcTAGwrvYVUgvB/XTRb0jidnfX50M1bVC7f3chgNh1zFBea2ly/8M+s1Z7XjoAFjPV5Choe0GJ4Sl3BgwKN0rg1JGfOH7x2l4SM9ojQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 SN7PR11MB6827.namprd11.prod.outlook.com (2603:10b6:806:2a2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Thu, 27 Oct
 2022 12:03:50 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246%6]) with mapi id 15.20.5746.021; Thu, 27 Oct 2022
 12:03:49 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     Vipin Sharma <vipinsh@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "andrew.jones@linux.dev" <andrew.jones@linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 5/5] KVM: selftests: Allowing running
 dirty_log_perf_test on specific CPUs
Thread-Topic: [PATCH v6 5/5] KVM: selftests: Allowing running
 dirty_log_perf_test on specific CPUs
Thread-Index: AQHY5ZKzsJSoXiEDzEiLKUZFIm4C+q4f88hwgADksACAAOmJcA==
Date:   Thu, 27 Oct 2022 12:03:49 +0000
Message-ID: <DS0PR11MB6373E6CA4DDFFD47B64CB719DC339@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20221021211816.1525201-1-vipinsh@google.com>
 <20221021211816.1525201-6-vipinsh@google.com>
 <DS0PR11MB637351B52E5F8752E7DA16A4DC309@DS0PR11MB6373.namprd11.prod.outlook.com>
 <Y1lV0l4uDjXdKpkL@google.com>
In-Reply-To: <Y1lV0l4uDjXdKpkL@google.com>
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
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|SN7PR11MB6827:EE_
x-ms-office365-filtering-correlation-id: 79bec9ed-8ff3-451d-fcef-08dab8134f37
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yQ3uqv+GtYOsnyX0RRVuuQv9bj/r30Po02tbCYfxn1J3miTLrGdHkYpLZyGHUyHQqnEONA2XleAFCsPCioexaHPSi6tRLWCAVeP+aflqCoCIUr/Js/oZEdZ0j/P3JJPLOrsMWuWBxMppDLL6vh0ovbWI9+O7Um6AZW7vwBBOHahI7DICtVq79Uf921mbjnITgMMzXveZPsMe7m1noiwKnsfv20D40Owz+Z5PZvqUTkXEVQRTMZhAe6RuyxkqIh0mxuRZWtdVxMJyQh2tJDMo422ZeMKtzZZWz2Q5WVgabFxC0EdgQqwgQNhwW+Kj5XfMrcjpaNsl3EfEkbk7l7B1510azVvuf7pe/DvbTBnolq8Q5Pm+ZGP+V5ivNI7eTLiBCrImd5y+G0VNeT2UjJIc89y4D3o7Mp8NjyJuMpeHkuAgr64gykPCUfv44ms9hegxO3Hvg11Hq0Jusx14u4MhjJsEC0dHSSThIVsgBEkOtrbSq60JmIqpKuQaepgCRsKMQ0e885UJLgbGguKcu3gb0IvVOPj/v2XWIhGhRcc4IYKDMdDPN9GnnAxlNMJLuVZLDF1YhfTXBDRPE/t4VD2WgXx4hMBk6F7G0y/rTmsUb0+L/9eassUbjiaZIOFPkRWluA0J/33M4eJuQDde5RGGv1076u6bLXwbDykPFXa/gC9y+0FfOTmG9QoVhGjtgg/Dz7GpajO+nJHHOKZULi3NONl88Y7+gOPBnvgrER+KE/pwjCyieDbL375SZuCIJAE8iD4F8fMXa0rSdhcPihfnbKGY7/a0Xbe1uYJUbRRkozU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(376002)(39860400002)(366004)(451199015)(55016003)(9686003)(186003)(52536014)(66446008)(8936002)(7696005)(41300700001)(38070700005)(2906002)(4326008)(8676002)(6506007)(76116006)(66946007)(66476007)(82960400001)(86362001)(53546011)(30864003)(5660300002)(83380400001)(33656002)(26005)(122000001)(478600001)(66556008)(38100700002)(316002)(71200400001)(64756008)(6916009)(54906003)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vX3x/ffxP5UArI4Ln/UlsSIo8ozttoSaDoFH2cr+H4wENPVNz7hU17QFvY3U?=
 =?us-ascii?Q?XGYaAs8lqwch+Nltv4Q/MyIP8boxgjd6Whyj3vahUmoKonS7CkZshEdYJR0P?=
 =?us-ascii?Q?ee4S3DfbrkygHb89Dn2KIyp5xUZ41csoMNSU2Zmh2gNHbeAyj0aLNlnb2gFm?=
 =?us-ascii?Q?KAeV/VjULHs2ZVpB5M/sMviINqMpObtWpgUNuswPoUAg1hkHdKR/sLO0mh5E?=
 =?us-ascii?Q?rm7wqs15vhhcNC4tuqa7L3hLJFc4+CnZNyBFHKYpkB+wsyqlv1scUrWQD+wA?=
 =?us-ascii?Q?3vS4fZvx86bCZdq85SL7VWICe62xBZuHRUrbZrqOmmrsjY5dPmQbm5rA1cp9?=
 =?us-ascii?Q?5K8TeYarYaVkg7lotm0XcAe5zxR+lR6P1mwyIaibWH/Czwn8T7f1VdlvruWV?=
 =?us-ascii?Q?FioO3Um3U6tPrTsMcmQIbkJ07Dv2450lkVBXwDUVD4B4lCCKOidUN2BtiFpu?=
 =?us-ascii?Q?J4MBBm78uOHs0lZMTcAju5stsm8etNZjW8g+0rS91mTX6p2p5LoAH9tBE8oc?=
 =?us-ascii?Q?wvhFE56KxnRBKRR2i/0ZlZqeI79cJ8suuvyG0DLIUTsFr/ep5MbLe+m+c2Z4?=
 =?us-ascii?Q?4X4KBRyEWc2Axu2u7jwZNYDghUuQnEB7xpBlK1KN8Z7IP8dpc7Rz7HOIfXMv?=
 =?us-ascii?Q?LxM0HlRKm50a8KLWoO73LmzN6g/pY6dGmM8PHh/he0cEetl9muDJ98SWKIYh?=
 =?us-ascii?Q?X011DnCGbosBPuput1BrJo+7ktAK3max7L/YZQq08IadZlwNnSOG0vgn8ZfA?=
 =?us-ascii?Q?UPjn1GQsZJgiBOz7K/qfYZASNOdo6vfwIGehbIi2wDzEmxh0beaHIc08m6gR?=
 =?us-ascii?Q?9IpcHMjFy6k2VUnADZXMiJ3ah+45eeTt2f5SEYeatB5cTvcLfGj1hmccAUH1?=
 =?us-ascii?Q?YYOe/QXEMBMq3NzjSZaLA0VerBngzYxpzKUqolVxeHYXbeVohGkL+jCue1aJ?=
 =?us-ascii?Q?enAhR0L35UZay8uZFUCFofWP2/i4C6OvOlSXjihzUaCTOIqDfSsEcyjBLvXm?=
 =?us-ascii?Q?GTNjJADOxU1P5NsuI+ZtM9pbYIGuq5+tdOgaDeWCaFoRxUZsUn5qT7gOPoVP?=
 =?us-ascii?Q?rprfBcWfzSu/vg0E59RoOiz/dzlDBQHyBS7AyxeHjqGwMCPCkfDGIc3tgEW6?=
 =?us-ascii?Q?QNBphPd0VaQKNsMOgJbei+4HU01LHZksTnhMIr5vCPX2gZVyVMW2pyY7Kj/H?=
 =?us-ascii?Q?bWgS/xpr0MZT60idv/zhoCNnGOjPCTFzm+9K19JE9ZX5dvLKoKsArshnRXkw?=
 =?us-ascii?Q?1uZSgG//kodOC33/2oeMzaUtP3m+rvAX+5GSatSKRcVypYuDMdfwMY+e1JLw?=
 =?us-ascii?Q?ikKMWaGEHxBLY6C6+gqX0Mvg84hOOoikDSFxJOwZxQ7UHoG93o8g5dmF3aIF?=
 =?us-ascii?Q?bDihrzgA+z/eZa32byhhv613As5IX2Cs6joLC0FC1aa8LAg3vZMBkG/m0dtG?=
 =?us-ascii?Q?cjfQmziPzd9DQwnHpwXhmNC9D2qNgGkNKjMuZjAod3jrNYdQeIO92feMMpEh?=
 =?us-ascii?Q?aF3FmUf0TynFStgk7ztua9rs0QVr+022ybsizJ3F8AtKDFOUL2Htrff+9eAd?=
 =?us-ascii?Q?EZhddReROxoHo3R4/80al1ZOYooYCBFAVxoq0wiU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79bec9ed-8ff3-451d-fcef-08dab8134f37
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 12:03:49.8680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OIXh9wGkrjD6RxRQrgmsUN9ZFfbk3hq5Wupu7EobJkere2mQO5kInsI3kzpcKdQ60qZT3syZlLy7j9RSut6baQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6827
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wednesday, October 26, 2022 11:44 PM, Sean Christopherson wrote:
> > I think it would be better to do the thread pinning at the time when
> > the thread is created by providing a pthread_attr_t attr, e.g. :
> >
> > pthread_attr_t attr;
> >
> > CPU_SET(vcpu->pcpu, &cpu_set);
> > pthread_attr_setaffinity_np(&attr, sizeof(cpu_set_t), &cpu_set);
> > pthread_create(thread, attr,...);
> >
> > Also, pinning a vCPU thread to a pCPU is a general operation which
> > other users would need. I think we could make it more general and put
> > it to kvm_util.
>=20
> We could, but it taking advantage of the pinning functionality would requ=
ire
> plumbing a command line option for every test,=20

I think we could make this "pinning" be optional (no need to force everyone
to use it).

> or alternatively adding partial
> command line parsing with a "hidden" global struct to kvm_selftest_init()=
,
> though handling error checking for a truly generic case would be a mess. =
 Either
> way, extending pinning to other tests would require non-trivial effort, a=
nd can be
> done on top of this series.
>=20
> That said, it's also trival to extract the pinning helpers to common code=
, and I
> can't think of any reason not to do that straightaway.
>=20
> Vipin, any objection to squashing the below diff with patch 5?
>=20
> >  e.g. adding it to the helper function that I'm trying to create
>=20
> If we go this route in the future, we'd need to add a worker trampoline a=
s the
> pinning needs to happen in the worker task itself to guarantee that the p=
inning
> takes effect before the worker does anything useful.  That should be very
> doable.

The alternative way is the one I shared before, using this:

/* Thread created with attribute ATTR will be limited to run only on
   the processors represented in CPUSET.  */
extern int pthread_attr_setaffinity_np (pthread_attr_t *__attr,
                                 size_t __cpusetsize,
                                 const cpu_set_t *__cpuset)

Basically, the thread is created on the pCPU as user specified.
I think this is better than "creating the thread on an arbitrary pCPU
and then pinning it to the user specified pCPU in the thread's start routin=
e".

>=20
> I do like the idea of extending __vcpu_thread_create(), but we can do tha=
t once
> __vcpu_thread_create() lands to avoid further delaying this series.

Sounds good. I can move some of those to vcpu_thread_create() once it's rea=
dy later.

>  struct perf_test_args {
> @@ -43,8 +41,12 @@ struct perf_test_args {
>  	bool nested;
>  	/* True if all vCPUs are pinned to pCPUs */
>  	bool pin_vcpus;
> +	/* The vCPU=3D>pCPU pinning map. Only valid if pin_vcpus is true. */
> +	uint32_t vcpu_to_pcpu[KVM_MAX_VCPUS];

How about putting the pcpu id to "struct kvm_vcpu"? (please see below code
posed to shows how that works). This is helpful when we later make this mor=
e generic,
as kvm_vcpu is used by everyone.

Probably we also don't need "bool pin_vcpus". We could initialize
pcpu_id to -1 to indicate that the vcpu doesn't need pinning (this is also =
what I meant=20
above optional for other users).

Put the whole changes together (tested and worked fine), FYI:

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tool=
s/testing/selftests/kvm/access_tracking_perf_test.c
index b30500cc197e..2829c98078d0 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -304,7 +304,7 @@ static void run_test(enum vm_guest_mode mode, void *arg=
)
        int nr_vcpus =3D params->nr_vcpus;

        vm =3D perf_test_create_vm(mode, nr_vcpus, params->vcpu_memory_byte=
s, 1,
-                                params->backing_src, !overlap_memory_acces=
s);
+                                params->backing_src, !overlap_memory_acces=
s, NULL);

        perf_test_start_vcpu_threads(nr_vcpus, vcpu_thread_main);

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testi=
ng/selftests/kvm/demand_paging_test.c
index dcdb6964b1dc..e19c3ce32c62 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -286,7 +286,7 @@ static void run_test(enum vm_guest_mode mode, void *arg=
)
        int r, i;

        vm =3D perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1=
,
-                                p->src_type, p->partition_vcpu_memory_acce=
ss);
+                                p->src_type, p->partition_vcpu_memory_acce=
ss, NULL);

        demand_paging_size =3D get_backing_src_pagesz(p->src_type);

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/test=
ing/selftests/kvm/dirty_log_perf_test.c
index 35504b36b126..cbe7de28e094 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -132,6 +132,7 @@ struct test_params {
        bool partition_vcpu_memory_access;
        enum vm_mem_backing_src_type backing_src;
        int slots;
+       char *pcpu_list;
 };

 static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable=
)
@@ -223,7 +224,8 @@ static void run_test(enum vm_guest_mode mode, void *arg=
)

        vm =3D perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
                                 p->slots, p->backing_src,
-                                p->partition_vcpu_memory_access);
+                                p->partition_vcpu_memory_access,
+                                p->pcpu_list);

        perf_test_set_wr_fract(vm, p->wr_fract);

@@ -401,13 +403,13 @@ static void help(char *name)
 int main(int argc, char *argv[])
 {
        int max_vcpus =3D kvm_check_cap(KVM_CAP_MAX_VCPUS);
-       const char *pcpu_list =3D NULL;
        struct test_params p =3D {
                .iterations =3D TEST_HOST_LOOP_N,
                .wr_fract =3D 1,
                .partition_vcpu_memory_access =3D true,
                .backing_src =3D DEFAULT_VM_MEM_SRC,
                .slots =3D 1,
+               .pcpu_list =3D NULL,
        };
        int opt;
@@ -424,7 +426,7 @@ int main(int argc, char *argv[])
                        guest_percpu_mem_size =3D parse_size(optarg);
                        break;
                case 'c':
-                       pcpu_list =3D optarg;
+                       p.pcpu_list =3D optarg;
                        break;
                case 'e':
                        /* 'e' is for evil. */
@@ -471,9 +473,6 @@ int main(int argc, char *argv[])
                }
        }

-       if (pcpu_list)
-               perf_test_setup_pinning(pcpu_list, nr_vcpus);
-
        TEST_ASSERT(p.iterations >=3D 2, "The test should have at least two=
 iterations");

        pr_info("Test iterations: %"PRIu64"\n", p.iterations);
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing=
/selftests/kvm/include/kvm_util.h
index c9286811a4cb..d403b374bae5 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -7,7 +7,11 @@
 #ifndef SELFTEST_KVM_UTIL_H
 #define SELFTEST_KVM_UTIL_H

+#include <pthread.h>
+
 #include "kvm_util_base.h"
 #include "ucall_common.h"

+void kvm_parse_vcpu_pinning(struct kvm_vcpu **vcpu, int nr_vcpus, const ch=
ar *pcpus_string);
+
 #endif /* SELFTEST_KVM_UTIL_H */
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/te=
sting/selftests/kvm/include/kvm_util_base.h
index e42a09cd24a0..79867a478a81 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -47,6 +47,7 @@ struct userspace_mem_region {
 struct kvm_vcpu {
        struct list_head list;
        uint32_t id;
+       int pcpu_id;
        int fd;
        struct kvm_vm *vm;
        struct kvm_run *run;
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/t=
esting/selftests/kvm/include/perf_test_util.h
index ccfe3b9dc6bd..81428022bdb5 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -52,7 +52,8 @@ extern struct perf_test_args perf_test_args;
 struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
                                   uint64_t vcpu_memory_bytes, int slots,
                                   enum vm_mem_backing_src_type backing_src=
,
-                                  bool partition_vcpu_memory_access);
+                                  bool partition_vcpu_memory_access,
+                                  char *pcpu_list);
 void perf_test_destroy_vm(struct kvm_vm *vm);

 void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/sel=
ftests/kvm/lib/kvm_util.c
index f1cb1627161f..8acee6d4ccbe 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1114,6 +1114,7 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uin=
t32_t vcpu_id)

        vcpu->vm =3D vm;
        vcpu->id =3D vcpu_id;
+       vcpu->pcpu_id =3D -1;
        vcpu->fd =3D __vm_ioctl(vm, KVM_CREATE_VCPU, (void *)(unsigned long=
)vcpu_id);
        TEST_ASSERT(vcpu->fd >=3D 0, KVM_IOCTL_ERROR(KVM_CREATE_VCPU, vcpu-=
>fd));

@@ -2021,3 +2022,58 @@ void __vm_get_stat(struct kvm_vm *vm, const char *st=
at_name, uint64_t *data,
                break;
        }
 }
+
+void kvm_pin_this_task_to_pcpu(uint32_t pcpu)
+{
+       cpu_set_t mask;
+       int r;
+
+       CPU_ZERO(&mask);
+       CPU_SET(pcpu, &mask);
+       r =3D sched_setaffinity(0, sizeof(mask), &mask);
+       TEST_ASSERT(!r, "sched_setaffinity() failed for pCPU '%u'.\n", pcpu=
);
+}
+
+static uint32_t parse_pcpu(const char *cpu_str, const cpu_set_t *allowed_m=
ask)
+{
+       uint32_t pcpu =3D atoi_non_negative(cpu_str);
+
+       TEST_ASSERT(CPU_ISSET(pcpu, allowed_mask),
+                   "Not allowed to run on pCPU '%d', check cgroups?\n", pc=
pu);
+       return pcpu;
+}
+
+void kvm_parse_vcpu_pinning(struct kvm_vcpu **vcpu, int nr_vcpus, const ch=
ar *pcpus_string)
+{
+       cpu_set_t allowed_mask;
+       char *cpu, *cpu_list;
+       char delim[2] =3D ",";
+       int i, r;
+
+       if (!pcpus_string)
+               return;
+
+       cpu_list =3D strdup(pcpus_string);
+       TEST_ASSERT(cpu_list, "strdup() allocation failed.\n");
+
+       r =3D sched_getaffinity(0, sizeof(allowed_mask), &allowed_mask);
+       TEST_ASSERT(!r, "sched_getaffinity() failed");
+
+       cpu =3D strtok(cpu_list, delim);
+
+       /* 1. Get all pcpus for vcpus. */
+       for (i =3D 0; i < nr_vcpus; i++) {
+               TEST_ASSERT(cpu, "pCPU not provided for vCPU '%d'\n", i);
+               vcpu[i]->pcpu_id =3D parse_pcpu(cpu, &allowed_mask);
+               cpu =3D strtok(NULL, delim);
+       }
+
+       /* 2. Check if the main worker needs to be pinned. */
+       if (cpu) {
+               kvm_pin_this_task_to_pcpu(parse_pcpu(cpu, &allowed_mask));
+               cpu =3D strtok(NULL, delim);
+       }
+
+       TEST_ASSERT(!cpu, "pCPU list contains trailing garbage characters '=
%s'", cpu);
+       free(cpu_list);
+}
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testi=
ng/selftests/kvm/lib/perf_test_util.c
index 520d1f896d61..95166c5a77f7 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -112,7 +112,8 @@ void perf_test_setup_vcpus(struct kvm_vm *vm, int nr_vc=
pus,
 struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
                                   uint64_t vcpu_memory_bytes, int slots,
                                   enum vm_mem_backing_src_type backing_src=
,
-                                  bool partition_vcpu_memory_access)
+                                  bool partition_vcpu_memory_access,
+                                  char *pcpu_list)
 {
        struct perf_test_args *pta =3D &perf_test_args;
        struct kvm_vm *vm;
@@ -157,7 +158,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode m=
ode, int nr_vcpus,
         */
        vm =3D __vm_create_with_vcpus(mode, nr_vcpus, slot0_pages + guest_n=
um_pages,
                                    perf_test_guest_code, vcpus);
-
+       kvm_parse_vcpu_pinning(vcpus, nr_vcpus, pcpu_list);
        pta->vm =3D vm;

        /* Put the test region at the top guest physical memory. */
@@ -284,17 +285,29 @@ void perf_test_start_vcpu_threads(int nr_vcpus,
                                  void (*vcpu_fn)(struct perf_test_vcpu_arg=
s *))
 {
        int i;
+       pthread_attr_t attr, *attr_p;
+       cpu_set_t cpuset;

        vcpu_thread_fn =3D vcpu_fn;
        WRITE_ONCE(all_vcpu_threads_running, false);

        for (i =3D 0; i < nr_vcpus; i++) {
                struct vcpu_thread *vcpu =3D &vcpu_threads[i];
+               attr_p =3D NULL;

                vcpu->vcpu_idx =3D i;
                WRITE_ONCE(vcpu->running, false);

-               pthread_create(&vcpu->thread, NULL, vcpu_thread_main, vcpu)=
;
+               if (vcpus[i]->pcpu_id !=3D -1) {
+                       CPU_ZERO(&cpuset);
+                       CPU_SET(vcpus[i]->pcpu_id, &cpuset);
+                       pthread_attr_init(&attr);
+                       pthread_attr_setaffinity_np(&attr,
+                                               sizeof(cpu_set_t), &cpuset)=
;
+                       attr_p =3D &attr;
+               }
+
+               pthread_create(&vcpu->thread, attr_p, vcpu_thread_main, vcp=
u);
        }
        for (i =3D 0; i < nr_vcpus; i++) {
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c=
 b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 9968800ec2ec..5dbe09537b2d 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -99,7 +99,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)

        vm =3D perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1=
,
                                 VM_MEM_SRC_ANONYMOUS,
-                                p->partition_vcpu_memory_access);
+                                p->partition_vcpu_memory_access, NULL);

        pr_info("Finished creating vCPUs\n");

=20
