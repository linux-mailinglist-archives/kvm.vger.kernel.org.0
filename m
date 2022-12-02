Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F41ED6407BF
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 14:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbiLBNgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 08:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbiLBNgL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 08:36:11 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B111C5126;
        Fri,  2 Dec 2022 05:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669988170; x=1701524170;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CUCsSwry0AyZSbat2uywJSF1+QktcPCKkbbdFdXSBsI=;
  b=DfY/cQR4rt6tXeYUR6WA+Vx5/7MwZmasmMGpp8y2pXBegpVOqQjABxGN
   wVs0W/HJp0mqsf87+r3gghlRaGRF6eUgxs7Q/xjxdlAnt9UeMUprV7NAi
   0S/ZGPpiWkdW7XS+9mRdtNLE+EQwIiyrxr0j/ES9UGq3TpnVqFWUk40cl
   NJTVKkrQgJMmS+CkqQ7gIZlxCL1/FlPXjuLIXtk5oy/FV258ueCVgk1qE
   Yevix5RQvaGpyFQDMLxyQAda9uKv/GJ0Iwv78XcHAEOkyNj2rxG39LOHA
   DSvuLs1eLmgUkbSGgt60LG70dBhyNTHJDWP5KHhIJ6cMixdqaU0KISI/d
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="303557383"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="303557383"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 05:36:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="733813173"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="733813173"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Dec 2022 05:36:09 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 05:36:08 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 05:36:08 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 05:36:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AHOYRGY5Yru7s14jnS/Djx6Ms+8e0lMZYERQwszs+UrWSOoSE3if0SpaldkVuZVSoDJ6wI6AZ/ye5NztAlRksJ8tq9cVzpmy/OUOay1xMl02BkBoFJzQ+X8jm+CG6CPyoDf0dz9yyDg0/+K0uPj000VrmHl3qDNVzHpaPbIHq98jcbyu+fYEEL28OxyECCUBPrkGW3b7pWRBVxsQFEYrf2lgxs9cKmgI4QTK8LJPP1vHjP+gVIkLF/Y9WnWWhWNBUKAPcIFq1QTpZ5C6cTLeo8AJSU5zpaR3boGM6aChVqDE1GYj5D9Ggim09/7eUemcac86J7PivZyWaCSj+WAcbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CUCsSwry0AyZSbat2uywJSF1+QktcPCKkbbdFdXSBsI=;
 b=fS2TftXYtcbtrqlanEvvVK3IDwnzc9J9HzelntamOG3YzpptGS/uZ9Kc1rPPuYQpybfOxO2R9d7Zw3MZ7wa8/0zMtwNPve7dskJGA/Kc4MIrD7xFZOnEOBoJK6/57bZM1Znl/2VTDZapL+UTmakugX9xR7PnlOeMkDZRLkFihx28eLMR9C5Xfxpe6m5uDB4C0SibcRSbX58hcwcTOFyU+mu8lLG27ygt7db2egOGu9SeVfx0n7nUnZHWZMG1aa9zxw0z4R6mzpts1cppCjwSwafN6YScIKTD2+U9DUBuikjRMIHli10LK4brW53Q3saMXeABwq9t8F+C6gJmFPKVxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB4963.namprd11.prod.outlook.com (2603:10b6:303:91::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 13:36:05 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%9]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 13:36:05 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "paul@xen.org" <paul@xen.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "anup@brainfault.org" <anup@brainfault.org>
CC:     "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "farosas@linux.ibm.com" <farosas@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "Yao, Yuan" <yuan.yao@intel.com>,
        "alexandru.elisei@arm.com" <alexandru.elisei@arm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "atishp@atishpatra.org" <atishp@atishpatra.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v2 40/50] KVM: x86: Do compatibility checks when onlining
 CPU
Thread-Topic: [PATCH v2 40/50] KVM: x86: Do compatibility checks when onlining
 CPU
Thread-Index: AQHZBREUXZvrwOe3yEGmbvrorekRL65am+oA
Date:   Fri, 2 Dec 2022 13:36:05 +0000
Message-ID: <cf755389c21c73e8367d8162cabc83629d3f9a74.camel@intel.com>
References: <20221130230934.1014142-1-seanjc@google.com>
         <20221130230934.1014142-41-seanjc@google.com>
In-Reply-To: <20221130230934.1014142-41-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB4963:EE_
x-ms-office365-filtering-correlation-id: 0055b87e-6981-41cc-11f4-08dad46a297c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SYmv3ivNPIscQvD7wglIO6JXW0lFszlPa/9TDsrC7R9++sZg7x5RUCiEgaoNPKKgd762mCEoScvj3TTNnN+eeTZqUGbsGiT2QN+WI8PhJVg9YZwPZ0FLRs3Mdl5U6jCF3nruyNfLVa2jrb9Nf3/XEeWeo5y78zRT+48QhDB9MhtRMqxgp1Ms6pLh1J8vNzMKpS16WpXq7zjebu3fykOe80yiIxVWi68um9jUHGv6Pm+6jFonEEuSwodxYDNznzmBaH6DewBBHhhfb8gCuFQ4YA++lwL0rP4U4ZU+1RVLgE77PUp1Mseh2WNoZnrWMVBcwpKogSx5c8yOdzmdBgIdK40sht6kxbmY07vDBFC9AWKlLNHBzrwCEbepCRlC6t/CsDJhRngpXqBJdpwQrEGuOzb4cms2/MAlcmhT3jnlowK6Li0TE1WiyW5SVZvWXq88rT90iUVeTSNGtRpmg82MDMh9na1ffCL8L9F1x2mi7Gh7rHgjsH2bSinXiCxvFc3wmj8LLLtaMrnj0m/tC+ExA6SwvSCet+cfPvedlLqg7v/XSSTXAtf9C2i0UFhGwBFigY7C8t/B97Sfb47D8xqYIWojP4WspwZHx/mzymMoTMPO2hOc9Vg/eTmdPAyZSa29pg617UBDHjlwU4mtjmmLH4TjwDosM6v5n7wXz8FHmrejJ8ric7zbVijUP+BpcHNOemdgB315iAZi9OmiSRFBS3d9g4e7piBE0hc42owwrT4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(396003)(376002)(366004)(346002)(451199015)(82960400001)(6512007)(36756003)(38100700002)(122000001)(38070700005)(921005)(86362001)(316002)(110136005)(54906003)(76116006)(64756008)(66476007)(8676002)(66556008)(91956017)(6486002)(66946007)(478600001)(107886003)(66446008)(186003)(26005)(6506007)(71200400001)(2906002)(4001150100001)(83380400001)(41300700001)(2616005)(4326008)(7406005)(7416002)(5660300002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RUZvZG8xaDFiaWlnTU9lbEFvdCs0ZFdseUZwZm00czRML0xpVGFSL2wvUENO?=
 =?utf-8?B?bWtKZTNveEFkeVN3cmlMMnVhWkE4VnQvV1hqOFZpV0xXUUxScm9WNkRycjNy?=
 =?utf-8?B?MHhtdVFqRWxIYXhST2hMQXFacW93Tnc0SlU5Tks3T211N1VFUFR2dDcrNFAr?=
 =?utf-8?B?QmlHVDJCZzl2VWNSdWV2cDZqZk9xN1A5OWhqOVNCUEsxeFdUYXZEN3VudVo1?=
 =?utf-8?B?eW5EN3dUMXppLy9hMUZCWlNxb0RiN3VKSlpUSkZKQkVKL3JTVDZtaC9GeWJk?=
 =?utf-8?B?VDVpQ28xOFpWdVJFMlEycWtBR0kvZWlzRnRvaVg4d0ZHSjh6Wnpka2lqMXdt?=
 =?utf-8?B?L2JBQitaRS9HZTFzQytuRFFPdysvcitHck9TcE1uTzZDVXVNaDBINVUrbG5P?=
 =?utf-8?B?ZyswN1B3QUFmRWNkQ2Fxd1pWemN5ZDUwb1NWQ2hQbHNkMXZtMml4M3RudjA2?=
 =?utf-8?B?bUlPM0JyZldtOENiT244Ym4yZGY4ZCs3aGZTQ2FKNFh2UU1UQ3lxQTRqQVJ6?=
 =?utf-8?B?bTNWc3dBb09mcUdscUtCbllnNDhSZ0VkRDVZcjM0SU9GZmNvOVQ4M2VhdGQw?=
 =?utf-8?B?UDNsV1RZZDhEb24yVlkrdnVWREMySi94eFNGcFFsYmpIb0o5aW1GL3hwZ09Z?=
 =?utf-8?B?cjhOZTRKRWxGcURLK0RQR3BhK1pVWWNrbVVhZ24zemx0a3NHQ1grVlo0ajBE?=
 =?utf-8?B?SlZaUFhsYklFNTh4WHlqb0NnaytCV1ErSWtNZU9EY3FaT0xYUWxlV0llblBj?=
 =?utf-8?B?UDFySmJIMmxQMlhUQmJ5WE1melZhL0RJUTZWeEpmd3p5VDV0REpxLzAybkFD?=
 =?utf-8?B?MHM2ZVMyRW0xT0htTGhLRjl1RytXNTJia3QzUmdKSW9SZzV0WmU0QUF5L0Qw?=
 =?utf-8?B?SmR1U3VyeXdBRExWb25IR1VWSWxEdk1XS1VMTkpSQzNhUHJaQTd1OEpJaHN6?=
 =?utf-8?B?RmZVRDBZRUJ2dVJ1VDZRVXdveDlUNzcrdWRpdmZFSUFMK1Nka0oyK2NvT2tG?=
 =?utf-8?B?Wk8reDlObTd3eFNBekY4a2NVQW1LMWlIOUJEQlJFSTdvT2JMRHdCSnJzY04x?=
 =?utf-8?B?eVNYaEdZdlpmREErRTNUSmhDZXdFTlhmWWl2NTYyU0NDeWMvQVFaTG00TVNU?=
 =?utf-8?B?ZzRSYkRjbFJOdisvTkdxNHJlZHB1SnZxUkY0ZkwrWE42TURNL1Z4N1R6MHBK?=
 =?utf-8?B?NitKbUQ5UUZZZzNtQmV6MWlQbGx0c2s3dTltWEVnSkpEQmNTK2ZhcTBycjNh?=
 =?utf-8?B?QTRpdTZ2NlJhMmoxS2hnR2c2dXBSRk56NG84T0xOT3krQnpVRm9GYXkwOStm?=
 =?utf-8?B?TzJWSkM5OWd2ZXBkb04weGo4bXVJeUthOXhsVVV2KzlQM214NldUTFgvYkRh?=
 =?utf-8?B?dXU5QzBhQ1J1UVFSOTJuOGE5TjM0WVhMcmptWlBPQTA0c0Zsd0Y3QXRzT3Qz?=
 =?utf-8?B?NWFkRG9wWkNDWVozaUsrUDhMd0RjaVVnZi9vNHM0SFVvOG5CZTlPSXlwQ280?=
 =?utf-8?B?QitKQ0k1Ymp6Qk9LTkJTS1BFZVpBWXFFS2hRMFJBcERNUDhWQzh3YzZKMFdv?=
 =?utf-8?B?aS9sWWFGamVPUUtCeDd5cG1HYW5GYys2UXY4TWFpOFRZRE9YdFNtcDdIeUZr?=
 =?utf-8?B?RHgvQURFTEVHUW80dC9nZnBRZjRFc0xWcDJlOTFoUVJYY2E4T0dOVU9Vc2M5?=
 =?utf-8?B?Z1dRR212VUkwelUzaUtHWHlReTlPMEh6dUcrTDFtc3UwdC9WR0NhWGR2ZXhu?=
 =?utf-8?B?RVVaSHVRMkxOUFJYU1hmRVF6MWRYVlJRdkttdVBYWUt1UGxvMFJzRHhFd1ZQ?=
 =?utf-8?B?eTYvWTdyTzBYNTFCT1JaT3Q4QWlXWTAweVBzUDJuakE4djZWZVZJTlg0OTNT?=
 =?utf-8?B?T0lSQlRKSnhkempEcGtoem5OTGRKQXhGeTZySzdPY2RQVzY4YVMrUDRkMnhx?=
 =?utf-8?B?ZDAwKzZJdWRBcklqT1ZwUjVCaDV4dC81S0E4OXE0ejJzcTNjU0YrYzVEdGI0?=
 =?utf-8?B?ckl5a3R4WlNTbnd1aWx5eldqTHl2WWEzOFozYjJFRWhiVVpCanJHdDlTQklG?=
 =?utf-8?B?Z0JUZVpnTjBabUNsTktxUENYVTdsc2lUYlJoTmVrZjhQd3EyalFiVFhGdmZK?=
 =?utf-8?B?ZjlzbUsyQVplV0ZJWThnRzBRM1ZXVThGZ2xmWk1takliRUFHRWdpUmpybnY5?=
 =?utf-8?B?TFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A08AE9BD82A808478F3C97D41B08AE69@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0055b87e-6981-41cc-11f4-08dad46a297c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 13:36:05.3496
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l5jNqFHUKVDxPCOpy3Ep/SJzk8ew+lNQ8Pe6NMX3hAzsOxhAtWcESJX8yqReLxmGGQCVBZuFjOY+ZwsXTeRDbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4963
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTMwIGF0IDIzOjA5ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL3g4
Ni5jDQo+IEBAIC0xMTk2Nyw2ICsxMTk2NywxMSBAQCBpbnQga3ZtX2FyY2hfaGFyZHdhcmVfZW5h
YmxlKHZvaWQpDQo+IMKgCWJvb2wgc3RhYmxlLCBiYWNrd2FyZHNfdHNjID0gZmFsc2U7DQo+IMKg
DQo+IMKgCWt2bV91c2VyX3JldHVybl9tc3JfY3B1X29ubGluZSgpOw0KPiArDQo+ICsJcmV0ID0g
a3ZtX3g4Nl9jaGVja19wcm9jZXNzb3JfY29tcGF0aWJpbGl0eSgpOw0KPiArCWlmIChyZXQpDQo+
ICsJCXJldHVybiByZXQ7DQo+ICsNCj4gwqAJcmV0ID0gc3RhdGljX2NhbGwoa3ZtX3g4Nl9oYXJk
d2FyZV9lbmFibGUpKCk7DQo+IMKgCWlmIChyZXQgIT0gMCkNCj4gwqAJCXJldHVybiByZXQ7DQoN
ClRoaW5raW5nIG1vcmUsIEFGQUlDVCwga3ZtX3g4Nl92ZW5kb3JfaW5pdCgpIHNvIGZhciBzdGls
bCBkb2VzIHRoZSBjb21wYXRpYmlsaXR5DQpjaGVjayBvbiBhbGwgb25saW5lIGNwdXMuICBTaW5j
ZSBub3cga3ZtX2FyY2hfaGFyZHdhcmVfZW5hYmxlKCkgYWxzbyBkb2VzIHRoZQ0KY29tcGF0aWJp
bGl0eSBjaGVjaywgSUlVQyB0aGUgY29tcGF0aWJpbGl0eSBjaGVjayB3aWxsIGJlIGRvbmUgdHdp
Y2UgLS0gb25lIGluDQprdm1feDg2X3ZlbmRvcl9pbml0KCkgYW5kIG9uZSBpbiBoYXJkd2FyZV9l
bmFibGVfYWxsKCkgd2hlbiBjcmVhdGluZyB0aGUgZmlyc3QNClZNLg0KDQpEbyB5b3UgdGhpbmsg
aXQncyBzdGlsbCB3b3J0aCB0byBkbyBjb21wYXRpYmlsaXR5IGNoZWNrIGluIHZtX3g4Nl92ZW5k
b3JfaW5pdCgpPw0KDQpUaGUgYmVoYXZpb3VyIGRpZmZlcmVuY2Ugc2hvdWxkIGJlICJLVk0gbW9k
dWxlIGZhaWwgdG8gbG9hZCIgdnMgImZhaWxpbmcgdG8NCmNyZWF0ZSB0aGUgZmlyc3QgVk0iIElJ
VUMuICBJIGRvbid0IGtub3cgd2hldGhlciB0aGUgZm9ybWVyIGlzIGJldHRlciB0aGFuIHRoZQ0K
YmV0dGVyLCBidXQgaXQgc2VlbXMgZHVwbGljYXRlZCBjb21wYXRpYmlsaXR5IGNoZWNraW5nIGlz
bid0IG5lZWRlZD8NCg0KDQo=
