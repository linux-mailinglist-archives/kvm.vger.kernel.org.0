Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5B95BD0D1
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 17:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiISPYm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 11:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiISPYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 11:24:11 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E430339BB0;
        Mon, 19 Sep 2022 08:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663600996; x=1695136996;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jjwwXBCXifPE0EQ06pBt/mptMV58ps8/bfpbrOvOfxI=;
  b=SY//7caeBzdTWdsH+gkvEVVtym2EidUi66tq/tMERwZRqc3LdVXx8FEv
   DeL3ynu9VpJzYmleZPsAuWyI7t0X4EbIQMmXrEbttX4XF2Latr2CPVOWU
   GF6gRCEb/thCxTiss09Tunb3WoMrC35SzclZiZH5FugYj8ywd0NeSItaX
   g+7gbwaHjo4ekV61/K9aEI9NdSYnsXAALIVVQB4VJCdHhY2i6tSA4wnsV
   X3GNpACLWk4tQELLVrQB5kd9OnproadjXsy0F3QgfsiMdh81avCDWj1Zt
   OKxo0s5/AUYvpFgbo7pTY125T7Zr1JRqBhpSRpsCTEHz4FzMsh7eJFYP+
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="298156919"
X-IronPort-AV: E=Sophos;i="5.93,328,1654585200"; 
   d="scan'208";a="298156919"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 08:23:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,328,1654585200"; 
   d="scan'208";a="651716032"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 19 Sep 2022 08:23:08 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 08:23:08 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 08:23:07 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 19 Sep 2022 08:23:07 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 19 Sep 2022 08:23:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dKSJsjR8O5mq3w6Bj7hi2DN+MDmc5HZ+ETLxUeKVBjDErC6cOQS3l94tgimXYKU4qX28MXGd+VFlvX4Fz3+arDaq+W+rg9wy07jAiuV0dc+KMeLEEN692qroLkBLqCw0fzairpj2ujg+7ZPj5kOCqATia0OI7Sm4TXGsvdBIR/lqPAPBb7AdWBtyaJNMMveadNcU3kwwSu4VdL0Sj0ORgaxi5S5oOykS95hmg3RU5cWu5P5VUBX9m70JsygFByKjyBBoQ/9ONrEf8uiQSt4fxs+Cy2p7ZYws4gpCBxkBY0tDaQE5Jj4lqPlgzx3vLeOPuuGjU6uvhJfXz2WCoutneQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jjwwXBCXifPE0EQ06pBt/mptMV58ps8/bfpbrOvOfxI=;
 b=hrJOwfRJXkV8cYG8/Veq1TMedGcn6ytMiYbgUKhF9S1Y1+LkODtGpAUB8+QWRaWdVy4ot1qzCGGGjyq+U1AmfpI6Ws+bV43LjG8/BhAf270r92om7c6tBxMQFhKUHrcGx3NqUZ0OAvrgUXSKWrNpst2S2x+G0rBv9WhPj/ldPIczw7Q8QQO5TXnqbxAZl8e4S3oKfFbDmP1CDYn0wildz8HXGNlECICQuapi3mqaUX94sG0/TuB5m4zc1iy6FvW1du1+7nl/sqzgZ4dMOqBovsogQXlWrthKF/CEtni/YAhVD2ahFeu9mdju8+KBWC+/Vc9JLIe5rezIdFxEvbMGyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 PH0PR11MB5675.namprd11.prod.outlook.com (2603:10b6:510:d4::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.21; Mon, 19 Sep 2022 15:22:58 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::817a:fd68:f270:1ea0]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::817a:fd68:f270:1ea0%7]) with mapi id 15.20.5632.018; Mon, 19 Sep 2022
 15:22:58 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Liang, Kan" <kan.liang@linux.intel.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Liang, Kan" <kan.liang@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>
CC:     "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on
 PT_MODE_HOST_GUEST while host is using PT
Thread-Topic: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on
 PT_MODE_HOST_GUEST while host is using PT
Thread-Index: AQHYuGCfKwYxaXR4306din/WULaC4K3Fff5wgBjymACAABFugIAA/X4AgABj1pCAAMFbAIAABJpggAAZlICAAKvIEIAAwJ6AgAPziBCAANgwAIAABnZQ
Date:   Mon, 19 Sep 2022 15:22:58 +0000
Message-ID: <DS0PR11MB6373ACD91938CE70EBADA831DC4D9@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20220825085625.867763-1-xiaoyao.li@intel.com>
 <CY5PR11MB6365897E8E6D0B590A298FA0DC769@CY5PR11MB6365.namprd11.prod.outlook.com>
 <815586ac-1eaa-5e38-1e08-492c29d0729d@intel.com>
 <CY5PR11MB63659EBEAEA0E64812E96111DC469@CY5PR11MB6365.namprd11.prod.outlook.com>
 <f7cfb391-c38b-84d2-b2fe-5e289d82862c@linux.intel.com>
 <CY5PR11MB6365676799EBF86B3931D336DC499@CY5PR11MB6365.namprd11.prod.outlook.com>
 <ef391316-cde5-3cda-ff0d-980e8ecc9aef@linux.intel.com>
 <CY5PR11MB636535BE57F8CC07B1B2770DDC499@CY5PR11MB6365.namprd11.prod.outlook.com>
 <4c6a5663-778e-a509-638c-92cfd5315274@linux.intel.com>
 <CY5PR11MB6365EE3B1C4BCED02A1E40D8DC489@CY5PR11MB6365.namprd11.prod.outlook.com>
 <da8fe1d8-8cce-7378-18e8-41fd7009ff8d@linux.intel.com>
 <DS0PR11MB63739F4DA17F30B3162837B9DC4D9@DS0PR11MB6373.namprd11.prod.outlook.com>
 <b3d3fd4c-b191-c4e4-ac95-c46f944c65d6@linux.intel.com>
In-Reply-To: <b3d3fd4c-b191-c4e4-ac95-c46f944c65d6@linux.intel.com>
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
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|PH0PR11MB5675:EE_
x-ms-office365-filtering-correlation-id: 9b021a1b-3fd6-4d86-7b6a-08da9a52d56d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mecaItZo9kxj4dQohJxrJlyIFACH5Nqg+KBrWPaUeSMzQezlmHOQCiYQe9swSl/awbK6UtWu6ufrPOFzK9YYyzvqseuoelzeeSCpaWs3JmG5QvaZB2Q9hyti0Zeg90KMdmzZc4sXTPG0l9+VLN6pPI2OTqC7BUEs1g59fhiuFauLa/u8wpswSXdpCtrki6O0o5LES0mcMdMylLszEuO5zeqpkUEbGv0ZKDn4Hrd8vMV4iA9eQ5V0zrULAww718xIRIzvUqJs2dl2odJu4fwFQNGJZSnxipTBhU/xkLSzmwUS3iepwM2Oy3UxP9aoJF5WXJUKeGS1TYjgEpVIvbCUuWWZFTle4ENlvJCsbcZOFJK9p/63VN5Y24VZYgkrhE99v2qaKFY5JR7A12z+ptjZCUrmYUn+RPjm87k84gwyV0AuHAJVWE6Rs+rJyr2rvO4+dXz/H3gRemY4KlFtMSh8eRQkh9qmK6ptR+n3IF7y4N+seQipl0l00isdQ+9T3BwwqKPYyEmXn8A1zBDxSmMYYT2pIfhwPkBWSLAGvJO0L3bLBpXNurYVCmV99QOQmGUInE0kSvkC9KE6pbxBTm8Bm2Rn5hEZGDEO8+kihYv9EmDLUNhZIrT4TEJ36ilWLwS04BujyJl9YNf1rXUWR01ddzouxPr7o7OYsr2FY5ajaQP5MROk9fNcPr1w88tNFruQXZmZd+ro+ohch09+jEQfimDd8LWQf2shWK5XpSHDDRcbwG68QSpng5o0206a7+a7X8UPi24kDcLP227UDOP877/6wZ0EUoz2UEYGH2LsZ1c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(396003)(39860400002)(366004)(451199015)(53546011)(9686003)(6506007)(7696005)(478600001)(26005)(122000001)(921005)(38100700002)(82960400001)(8676002)(71200400001)(316002)(33656002)(86362001)(38070700005)(55016003)(83380400001)(186003)(8936002)(2906002)(110136005)(6636002)(52536014)(54906003)(66556008)(66946007)(41300700001)(4326008)(76116006)(66446008)(64756008)(7416002)(66476007)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RGp1bHFmRklUbURwOUl1R1I4KzhTUmdFN05OR3pkazY5Um9SMFA2eHpacmJJ?=
 =?utf-8?B?KzBUMkJTR3RZaDFZalptRGsvdHNpSWZjb3FSZDcxeDRkQXQwSytvbEYvYWVV?=
 =?utf-8?B?cDlneTA2WVp2VXFyL21vUXh1TE5EV1h2Mk9za3RMWWRqbHhSK1B2K1NLVHI4?=
 =?utf-8?B?clZJa0IyMVhtNVdQSXJuc1JNa2R4YWJXdmVxQ1FtYlBkN24zc2lUcE5YRWZX?=
 =?utf-8?B?VGNFcnNMZ04wcWY4bURLMU5lK0EyME83UlFZNjlnUmUycW9sWHpCNE9EWHBH?=
 =?utf-8?B?Q1V2U2N2Y0pOS0IxNm9FdXBRclF3U2swWXREeHIxM1hubHorS3dncjk3SDM2?=
 =?utf-8?B?QU1QMyt2dnQ5NU5OUm1ZM2J5SWxCZzFBa3ZzTUFHY2dBZFB4WDBDbllnNzdn?=
 =?utf-8?B?RlJvWm5FT0VOYjMzSVBibWxqSlNtNms0bTM0Y3JpN21uZVRJbDVkcGM0NTdN?=
 =?utf-8?B?MjdMdlFHNXJBZElWWWxIWnlFZndKdjBUTmNKTHVleHNDd1ZZY3o0czRPWlhS?=
 =?utf-8?B?UjV5ei9Td0R4V0FIT1hDQTU2L25LWE8yVCtjTVE2VWlhN3Zoc2pJcnJDS3E4?=
 =?utf-8?B?cFlob0Z3UXRPVi9GSGNYSWNQY3RRZmxwR1pjYjdxSDdDdWp1dkczNWVta0Rx?=
 =?utf-8?B?YlZBN0Z6eUNnY3lYRCszazYwN3FMK3RacG1WN2tFVVhYL0l1d3ZJQnh3TFMz?=
 =?utf-8?B?bFVPejAyK1hvS1d1ZzhJRmxTdjFETGlybDJUZVdvSTRHaDY3bnY2T0puYlYz?=
 =?utf-8?B?dzdCZmhNbW1CcVFRdU5YMVpRbE9NcUdKVkdBbW1jMmZjQ3hndTVENWRYMHFY?=
 =?utf-8?B?VTFGY1V3QnpSVkNoZklYL1V2R0ZEbWRyMWhkTWJ3dzBPTzlOdVFmV0g2TGcy?=
 =?utf-8?B?SFNua0NUajhOZUFwQ2xHTnVta3RwMEMrN0tYRGRXdXRiMENhZXJ0TVErOGFH?=
 =?utf-8?B?L2lvWkNMc0Z1cFBEOGIxQU9EdGY3djRXcCs2bERYMDNZYWFudkZKOVhNcktl?=
 =?utf-8?B?a1Q1a2FEM0gyMUpsQlRUd0VwNCtwZ0NVa3ZUUElpSWVReGxSUDZxdFVldXFC?=
 =?utf-8?B?V1dHRWc5WWR0QkM0SnNuSHI2YlBidHE0RVdsZ280eGdZOUFKWHBldWF2dTNR?=
 =?utf-8?B?ZTVSS3M0WnFHTlQrb2xLMmh4LzM4SW5WZ2FWRXYzeFZhcVdyR2JuRU5Hc0lw?=
 =?utf-8?B?RmpZYUpEUE5qd242YmdlQXZPYkZncmd2L2Y3dTJiSW1wZmgxZFhoRTdwQ2tn?=
 =?utf-8?B?Nzd4N1BqM2lUMktOOEErQmlVQ3l1a1krV2U5K1VucnhFOUxNZEROd1JqN3hr?=
 =?utf-8?B?MFNUZ0Q0azMzUW9aSThCeTN2YjhVYUIwSk1xWWdIenBIN2JibFRUVmpqWWlR?=
 =?utf-8?B?RTdVNEZJU05PWmcxbk55RUp5YUlzR0U4Z2pUZHo5WmhSbHN5bCtNVnBBMk80?=
 =?utf-8?B?cWZ2bTIrdG5nTCtVNGFXaUdnS2ZOYkVOaS82RVhCL0FkTjZITlRQaTR6STRE?=
 =?utf-8?B?b1JGaHdva0JTK0l4VzBMbnF4eWFyc25QN2FTQTZVWXg1bFJ4R28zUkZXemd5?=
 =?utf-8?B?ZzZnV0YxaVJxY0lZNWZ4a05LZnVoOHNJRllydWdKd0MzVzJWTlR4VVgrdVVI?=
 =?utf-8?B?U3FKcUpoL0p2VStHVWtLWkFMdHhteHlrLzhmdFJNV2ZqLy9IR2tLZEhBbEx4?=
 =?utf-8?B?UTlWQ2w2M2VydWplU2JSRUZkS0tvUmVLbUFrVGJUUXdhdjFHSHhPSVBVcUtR?=
 =?utf-8?B?Wkk3UERTNmUwK0NMWkVIelhrbFFOZ3pIM0tPcjVOVGVMZG9MeHR1UlZkM2x5?=
 =?utf-8?B?R29YNFE5YXFJN3VnZm1IdS9MM3MxWGlsaXZtVUc1TWJCN1Ywcm12cnhkMXhi?=
 =?utf-8?B?c0lRNmVEMHNJZ2FaRU1YcHp5bWVOWG9NUHMyT05SeXJXU1I2ckluOFRrRnlQ?=
 =?utf-8?B?a0hGUWtmSHAxMXVWbUZ6dWRaUUtKMHRnZUVlUlNsMjlXaDFEdDFkMHI0Y2p0?=
 =?utf-8?B?M3AvQnUvanppWUgrL2p1ekRRcU15VVNVd1YyS1J2NTBud3RmSmswZ2p1bjU5?=
 =?utf-8?B?MTdlSmYvTUg4ZWJ4dEp5Ky9zQUtiUjhvQ2srTWtyRGRJQUFxeURxZWNXdnYv?=
 =?utf-8?Q?y2ZwfY6tnBqJFh+bV5w5mN0/I?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b021a1b-3fd6-4d86-7b6a-08da9a52d56d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2022 15:22:58.4595
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PvbyMvgl6rIJR1qVNP1fERjGZIB59hqdm9prEMwmMfoM7MU11pDSJ5TL3QCHjWd0Ie1JOuPBxr4FnP3zzzlLmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5675
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uZGF5LCBTZXB0ZW1iZXIgMTksIDIwMjIgMTA6NDEgUE0sIExpYW5nLCBLYW4gd3JvdGU6
DQo+IEFub3RoZXIgZmFrZSBldmVudD8gV2UgaGF2ZSB0byBzcGVjaWFsbHkgaGFuZGxlIGl0IGlu
IHRoZSBwZXJmIGNvZGUuIEkgZG9uJ3QNCj4gdGhpbmsgaXQncyBhIGNsZWFuIHdheSBmb3IgcGVy
Zi4NCg0KV2UgY2FuIGNoZWNrIHRoZSBwYXRjaCBsYXRlci4gSSB0aGluayBpdCBzaG91bGQgYmUg
Y2xlYW4sIGxpa2UgdGhlIExCUiBzaWRlLg0KDQo+IA0KPiA+IC0gb24gVk1FbnRlcjoNCj4gPiAg
IC0tIHBlcmZfZGlzYWJsZV9ldmVudF9sb2NhbChob3N0X2V2ZW50KTsNCj4gPiAgIC0tIHBlcmZf
ZW5hYmxlX2V2ZW50X2xvY2FsKGd1ZXN0X2V2ZW50KTsNCj4gPiAtIG9uIFZNRXhpdDoNCj4gPiAg
IC0tIHBlcmZfZGlzYWJsZV9ldmVudF9sb2NhbChndWVzdF9ldmVudCk7DQo+ID4gICAtLSBwZXJm
X2VuYWJsZV9ldmVudF9sb2NhbChob3N0X2V2ZW50KTsNCj4gDQo+IFdoeSB3ZSBjYW5ub3QgdXNl
IHRoZSBzYW1lIHdheSBhcyB0aGUgcGVyZiBjb3JlIGRyaXZlciB0byBzd2l0Y2ggdGhlIE1TUnMg
aW4NCj4gdGhlIFZNQ1M/DQoNClRoZSBjdXJyZW50IE1TUiBzd2l0Y2hpbmcgbGlzdCBmcm9tIFZN
Q1MgaXNu4oCZdCBmYXN0LA0Kc2hvdWxkIGJlIHRoZSBsYXN0IHJlc29ydCB3aGVuIHJlYWxseSBu
ZWNlc3NhcnkuDQoNCj4gDQo+IFlvdSBqdXN0IG5lZWQgb25lIGdlbmVyaWMgZnVuY3Rpb24sIHBl
cmZfZ3Vlc3RfZ2V0X21zcnMoKSwgZm9yIGJvdGggUFQgYW5kDQo+IGNvcmUgZHJpdmVyLiBJZiB5
b3UgaGF2ZSB0byBkaXNhYmxlIFBUIGV4cGxpY2l0bHkgYmVmb3JlIFZNQ1MsIEkgdGhpbmsgeW91
IGNhbiBkbw0KPiBpdCBpbiB0aGUgUFQgc3BlY2lmaWMgcGVyZl9ndWVzdF9nZXRfbXNycygpLg0K
DQpUaGUgZGlzYWJsZSBpcyBkb25lIHZpYSAiIENsZWFyIElBMzJfUlRJVF9DVEwiIFZNRXhpdCBj
b250cm9sLg0KSXQgY2FuIGVuc3VyZSBQVCBkaXNhYmxlZCBpbiB0aW1lIG9uIFZNRXhpdCwgc28g
bm8gbmVlZCB0byBnbyB0aHJvdWdoIHBlcmZfZ3Vlc3RfZ2V0X21zcnMuDQoNClRoYW5rcywNCldl
aQ0K
