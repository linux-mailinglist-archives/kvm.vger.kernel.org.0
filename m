Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35F487B99E0
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 04:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbjJECTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 22:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjJECTe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 22:19:34 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FCBAB;
        Wed,  4 Oct 2023 19:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696472371; x=1728008371;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=g+jqBfDrokoRUTj7gjV3G5ldIebYIJkbWAEVlp5mO3U=;
  b=MNWgdJzjIxSE3cLWZRKclm+/2BaN7JnUqoJuD8fQzd3qs4T3NrCXYtF6
   VIycCme8qB/kpxIraDQo3FVL2Xc1CjoN0SzrChKqRaY60TKGaIEu+LtYU
   DOQMG3qMuz8cMyGbhuxiaH0SVJ/IZFFrOgR4nVdHnddO599J+exSwudr/
   811PaMNqXReakOdYY+ubTqvzkyFWGxgUDylMuurXfZA4jserkrCtWF8aI
   zyKU7AsHtZLThxbu3AAOQ17DhiUiYWyhTafwCizDBEwcoKC2kjgeRhRze
   JR3QyPkI+ldfJLGgHkrnkDfLMlSf7fap90DOaKgHOZV1CnNV6dt9F0l7B
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10853"; a="363657154"
X-IronPort-AV: E=Sophos;i="6.03,201,1694761200"; 
   d="scan'208";a="363657154"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2023 19:19:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10853"; a="781061723"
X-IronPort-AV: E=Sophos;i="6.03,201,1694761200"; 
   d="scan'208";a="781061723"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Oct 2023 19:19:30 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 4 Oct 2023 19:19:29 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Wed, 4 Oct 2023 19:19:29 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 4 Oct 2023 19:19:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CenkabO6QDC5UfWVq3HX+QV14H7rQVCdT3sGyi5Q4T20G8Ioer1uMBnfGXXHOHnHURsIHGWuWHon9b8vQk9FEdZ99jeXnR3jAhCaTPzauaEEzEqpratBp/fl16GRpjNQawUBCk2DheMvW4OGfPHuEYQ8hpxwU/gQKYD297MdzRGHCA19MAhEWrZLOGgcaQgzbrpyzmcH0uFTdNeTvmUb/OziviHCCRjYvvB6NwhqmPsqU/UhMStNjqYEFnuLITjMwddpx2mmDgMxVatz8iGx/psdYvhDujTo/vzZv/KdwK2tADDnzoJCpSKuOg0FC9OADV21re/h75Y1KNnov7LQ4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g+jqBfDrokoRUTj7gjV3G5ldIebYIJkbWAEVlp5mO3U=;
 b=bMCbTrizGVO43yiOJid3BrilBEA2XBEc+ECCyEMHwvO4HklRBs5QJlA4rWIILzrjxWlrJ1kFiIlK/vgTK06G6Zb169iuoivzPaFT6gyTM9Gbck6a8cn7GgYflvH1OOqYQEdtpmOetNzD8QqIgiTshdomEiP0LxrftQSMHOKniuOH0UAtsqzAlpRhKkO2ohs1AipvX2nxzB8FKr8srlotWjPW6B3lvhAvNYo5H5D94NabdE+HWZmvgnJS5MU6boO8XO6ml6Hu3ta88oDH+HEDR1SAMoxDPt1RFLF0gZFsGKQCxItEpek4oKkSSVg+7xM6WNOyDGZnlPsuH6LFS682qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6342.namprd11.prod.outlook.com (2603:10b6:930:3d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.35; Thu, 5 Oct
 2023 02:19:27 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::31a9:b803:fe81:5236]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::31a9:b803:fe81:5236%4]) with mapi id 15.20.6838.033; Thu, 5 Oct 2023
 02:19:27 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC:     "robert.hoo.linux@gmail.com" <robert.hoo.linux@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>
Subject: Re: [PATCH v4 00/12] KVM: x86/mmu: refine memtype related mmu zap
Thread-Topic: [PATCH v4 00/12] KVM: x86/mmu: refine memtype related mmu zap
Thread-Index: AQHZtiLXgL0k8P/jtEq1HizKEtVV2bA66nyAgAAN9QA=
Date:   Thu, 5 Oct 2023 02:19:27 +0000
Message-ID: <f29d86b433c4cbcbae89e57ac7870067357f1973.camel@intel.com>
References: <20230714064656.20147-1-yan.y.zhao@intel.com>
         <169644820856.2740703.143177409737251106.b4-ty@google.com>
In-Reply-To: <169644820856.2740703.143177409737251106.b4-ty@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6342:EE_
x-ms-office365-filtering-correlation-id: 2aa14865-eb83-4e3f-99f7-08dbc5498015
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OtPq1KcyFG6g34ySi2BwuQyjV69YAYqgRCrqUmYOw/LNEzWtHKpQE1YAfghclC3DxJcq0/Dq4diychYPjTzBfWYH+hdfGkaJdxCBopfaaPv+wujfOTd5uFXBaC+J9gnUWXMbNQxSKcPAuwFC7X/udzHLD7DPaVfZuinjSSY+48/YZIzIljXsVbpawFFfEEB7GJvPCWEnjn+KNTqcatPREKkhhkj90Wx/DGQ8TOn5b73G90tXr2Ca0bkQf8f+l1PXNCrLvai7rDMGvvLQ7dnTJB6RjEsRe6BHdRss6Ven72cII31GVJM8SF7aHjzeq4ilEcn6rYFCmWeaIyqB+Ubjm3OqC//pYyD70GYMiuFr6lejhPBS5X1tR9MELEEKbhFmWIH2uMI/aZqqJVLffArSfAbdZvktNHSypn2KSNYfx64jw3aMKuwOTXNHJsdNLZe0fiA21+MoPrYG1n/HgyNZw6fwgABctylWPSDKcSgzn/mQIFtG69/ARA+HajTWelsGodPtQeYn1eGgdNUpsmwIAPofOxzFCSk7tyt2DHghqulQVeSF0UDSJQocpFZzzXSw4srp6xSzsaoQZiXjLZpgj6FasHsC3EPpX9RQaCWLits=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(136003)(376002)(346002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(71200400001)(966005)(6486002)(478600001)(6506007)(2616005)(122000001)(86362001)(38100700002)(38070700005)(82960400001)(41300700001)(2906002)(6512007)(26005)(64756008)(558084003)(54906003)(66556008)(66476007)(66446008)(5660300002)(76116006)(6636002)(316002)(110136005)(91956017)(66946007)(36756003)(8936002)(4326008)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TmFhTUN5eDFuUnNMci9MYmpRS0V2QnI1QnFNV2hBZjlDTElJSWI3Ymwvemhi?=
 =?utf-8?B?RGphN0pFSWZoK3E1MTdyVk1yL0VzNUtERzRVWmptZXkzcGc1V0FVMzdnb2lp?=
 =?utf-8?B?SHBkR3psYmxYSTl5T3lCVEMzQTQraFpHVU5mT0tQcUY4TGlBeUNPaGw2Z2pv?=
 =?utf-8?B?TG5kN3drS21FZ1orQ2c4NjdZRVllQXpPUkFkWWlxeHg4SGwzUzB4YS9MM0kr?=
 =?utf-8?B?OVdTTlVQSlNaa1l4N0JZQTYvanVyOEpicW1Za01UUGpOMkhLNEkzYXVxT1Fu?=
 =?utf-8?B?RDUxcG9wSUFMbzIzdGJRcDh4aFJmYTZuTjNseHBUVWVWcWRRM0VFR044NXhP?=
 =?utf-8?B?SlQxSG9vZ2R3NjR2NEYvTU1VUGtWSFJmZWJYRmV3bnNrRUhHK2NkaHdKM1Bh?=
 =?utf-8?B?cWxsQW1uQ3daOGZmeDVFWkxRTEdHQ3pwL3pIZ2JYL0daWGV0UVpHWTY2dVNB?=
 =?utf-8?B?SXJ6czdGeC94MzhpN01pRG5SbWxEYUZTMFlTaEhUcFRORi9YbU16elZXL3Zw?=
 =?utf-8?B?UnJNSE14M2RtU25FanA2NVFuYkxtYXVzakpIRENVNGxXTkhhZkE0ZjJTUUZG?=
 =?utf-8?B?R0dSNmhmSXRqN2pSa25NZjJxbVkxNU4za2R1YVBlL3hTMmpVTnc5MkVGMHJL?=
 =?utf-8?B?WVJmRE9vendQbHBXQ3J0dGNnT1RERWhkRmZkWVVNU1F4b2lackg4aWpLaEpu?=
 =?utf-8?B?a0ZzNnZ0aUhiakdQVndyTkxjNVRoQ2ZLdENyMDlYdExnZm9oeklVSFMvQXRQ?=
 =?utf-8?B?U1JnZnN1TFV5bnhLR01vbXE0OUxUTnRaMktUWXBBRmJSYWJIbkJ6N0dzY2xO?=
 =?utf-8?B?MHIzMWdRL1VHUnQ2VFNGQmVKR2oyeXY0K0pIZThlOTMvVEZQWUl3UGd1ZHEy?=
 =?utf-8?B?aTN0UUdWQytxUVRIWEt6S1V1dmt2RHgyb2U4ZXh2dVNuRUk3VDExUCtSaXh1?=
 =?utf-8?B?N1VMQUFqRDQvM1FRblRacC95K21DazdQTHFMd0lkakZrQjArSGZZTkZPWFV1?=
 =?utf-8?B?Wlo3Y3pYbUJ2MU9EcSs4Y2drS1VlNndRRkRsYkpZSHFRVFJmajFoRml0YlF2?=
 =?utf-8?B?eWRBKzJEdlIxblRjcmlWeUVrS1pxRHRjRVIrNk95VDFhbS8wRjdFZjd1WXRJ?=
 =?utf-8?B?UWlvRjVZV1N0S2RUZWZaSXdhejRMaWVFamJReHVVdGp6QXhvWEhzRHJNS29T?=
 =?utf-8?B?ZVVTTnJjdlBubE9zUDZkNnQvUU85N0diVk5PaFFKemNvKzBZdzA5THV3WWR1?=
 =?utf-8?B?NDg5N2EvcEtzQlB0TEZDZTdBRkJpbDlFWGc3UHdPOTBSRXFpQ2pDUjRSM2J3?=
 =?utf-8?B?Yml6eDFHYlpwOXZpWGRWRDhrbm82aXl4cGVRbGtMUXV0ODFac0wxSXI4TGxK?=
 =?utf-8?B?Yk01bkNWVUkzNWdxa005eFBCSlFoMDJyVXNOeXhuSHR3OUtKbEw1VHVVM2lo?=
 =?utf-8?B?QUd4OGU3WDZ3OEl1Rnp6NGhNRDZGK1ZJdkxjeTFGbzhJYm5MUDdWd0VhSTA1?=
 =?utf-8?B?WkkzYm9Yd0NzWXVYajI4ZVd1b2ZqNVZSMXlSZ2xTT2tjamVDWG5kaFlTaEth?=
 =?utf-8?B?SG9ma0ZGS2JPVHYwSjh4ZUdqazJJVGpXNXNnVzhzS2g2Yi9rUllXTitjOGRz?=
 =?utf-8?B?YUJjcE05c29SaVVzZERlWW9ZNCtpZytDR0t5WlhDV281VUt1OGpqUWZROG9B?=
 =?utf-8?B?VUNySndtTTFGSnl2cGx4TWtKbFVOb0FIS2RGSWFQdWFWQU1INmVUMncwUnd1?=
 =?utf-8?B?TzhOUGJGZitiTjUrV3lxbjlCL3BSb3pYUTllZUkvaWdRUFlBU0MxSGJtS1c1?=
 =?utf-8?B?aSs2Wk93YTc0bWpVQ3lkbTczYWUzOXQvaSt6YzB4WWpaa01qcXErU29aQ205?=
 =?utf-8?B?ZDltY0Z1eEp0bzFGWk1LWjUzSzFCLy92K3RGazZqZ0lsaVdGRk14Tml6M3o3?=
 =?utf-8?B?dFExSzhhV2hCQXZUMjk5SXdmK3RDNTJ6V0pxNEpnb0YxSW9oWWlWeWU5WVhq?=
 =?utf-8?B?bng2VzVvWGxZMjZDa1gyeCtYSzF5WEtlZGhnQW5BRkI3WmFoUHJzV0ZZaEFL?=
 =?utf-8?B?RkcxaEN1SThKNXFaUm51Z3JFWFBqTzh2aHdUT2tRUDE1cHF2WEFhVDViL0Zv?=
 =?utf-8?B?UVcwR01TUVJ1OHlNYSsvQ1h4dXpldmtSWEZxVlA3LzFPVSs2RTJzL2g0ZWs1?=
 =?utf-8?B?V3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7526162229D2554BA178CA0D91353636@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aa14865-eb83-4e3f-99f7-08dbc5498015
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2023 02:19:27.5074
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9NIJw0axS8dqxfApHU7lb9c3z8oyyorNY95BH2WL62Xg0q4mq9bmoGTDsfN3TBvPHty/yKdPaFwZxeTskWeHPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6342
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTEwLTA0IGF0IDE4OjI5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBbNC81XSBLVk06IHg4Ni9tbXU6IFhhcCBLVk0gVERQIHdoZW4gbm9uY29oZXJlbnQg
RE1BIGFzc2lnbm1lbnQgc3RhcnRzL3N0b3BzDQo+IMKgwqDCoMKgwqAgaHR0cHM6Ly9naXRodWIu
Y29tL2t2bS14ODYvbGludXgvY29tbWl0LzNjNDk1NWMwNGI5NQ0KDQpYYXAgLT4gWmFwPyA6LSkN
Cg0KQXBvbG9naXplIGlmIEkgbWlzc2VkIHNvbWV0aGluZy4NCg==
