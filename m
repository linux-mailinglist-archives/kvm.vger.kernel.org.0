Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A299E7447F9
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 10:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjGAIPT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 04:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjGAIPQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 04:15:16 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8E2B9;
        Sat,  1 Jul 2023 01:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688199314; x=1719735314;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VPepX0cnn9B8QTQoODzOJr29GSlmcRGm2Cspi0iNxaA=;
  b=jdpBY+3R6AkDNFGdd7RAXC5c1gaMvnwTPI/lMQbEhCJwsR6ScLQRv1ls
   JBnFoubLJ6KG4hGGAe1mLUlUwSAEPBFcVzC/wUk4SVmj7O4KHRGL7xnU9
   WjHQ5wahUfjbcZQ6Fa++c+WDXOpXCjYp8BFiB+pDYGs6Kdt0s7GkhWztr
   7K7mK13Ppv1HG6HI/Tff4UskePRGu4ZcFZPahzWhuHnckGL5Up0nxlg1v
   FzH5MJqzqZ+DbyxpMa5bmKeFXezpKOAt2KaDy3SMcswmuY7PQpO0/L/Rw
   Axw98KE5sy2rrun7ATBdh5Jp+MFJVRtPCtYEfVfwVGKWyv64Bgq0WsMJH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="362608003"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="362608003"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2023 01:15:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="753225052"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="753225052"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 01 Jul 2023 01:15:12 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sat, 1 Jul 2023 01:15:12 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sat, 1 Jul 2023 01:15:12 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Sat, 1 Jul 2023 01:15:11 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Sat, 1 Jul 2023 01:15:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jl0FN1sSPEDuiff5zqDA4odOpO/PLA11DaSsTGnncypCOlV2lGI/J3Dh/m/bq17kMazokYTI6CxFFb+5q+NGOCcLtgv01n0qwdZfK0YODvNR8z8ex/IkyWCi86ngXJF1nALRQxO4kOWIunzOn8BirJROqI/EgDlAG/0QwlbiQtKooKHBdWCjYm7aj7INAYeFvd7biWHLfkhLGfGTVY30QtGjdecAfwM7OvdSG6KeVGk/YENCKQHxULRK13j+VpM8Mrj/rd36PswfWJkQKnnkYJ7p2S/w0a+ZC9kejje9VhYddkjSJZ964fh6vVgpxMh7GRGCTo+XMs2dvecNnDTzPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VPepX0cnn9B8QTQoODzOJr29GSlmcRGm2Cspi0iNxaA=;
 b=Ncox8Fknzu3gcRJioxi3gxcl8AgUcEWLtWj6aL4MZot7XNdmq+RAb1AcW6x6l7QL30guqXOUPTW8hHL7I/0d63al811VZUTC2uxihbLdLslPciK5lV2Rc78rWDZDJ2lnq3GG8yCEMrmKUKl8Gca7FKS/hJHJVC+g/9KytzRhSV+3/pGUnhUGd0iKbm3p881uKwbbgfsbU1wE/jXEGds74Xt2H/f+ocWlqTf9KtQJBiPUUoa2QeZPcbtvj8Rhs83SbBVI9VIG6UfExAhg7W1VXD434W0CAZP66kOjkO4PbEwB3KF/IUYLh+Zytqi0KQis+PvR0Ifv7NnXlID07CQR1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6553.namprd11.prod.outlook.com (2603:10b6:510:1a7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Sat, 1 Jul
 2023 08:15:07 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Sat, 1 Jul 2023
 08:15:06 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Gao, Chao" <chao.gao@intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZqDWtW8hO2PRC3kCMr0lha9GzWK+eaRwAgAAMPoCAAB1NgIAArPYAgAAey4CAANwJgIAAsqsAgAIrRACAAA0BgIABcnmA
Date:   Sat, 1 Jul 2023 08:15:06 +0000
Message-ID: <abbb1036723185108bb57a7946203fff5f6824eb.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
         <20230627095012.ln47s62pqzdrnb7x@box.shutemov.name>
         <d6a0fb32ebcdeb6c38ebe8e2b03f034f42360c0f.camel@intel.com>
         <20230627121853.ek5zr7sfiezfkfyj@box.shutemov.name>
         <9361abfa9bf22c2a1a4b25e5495bcccc5b8dcd43.camel@intel.com>
         <7b61715ad35d7b9916f55df72378e02e62c5cc4e.camel@intel.com>
         <20230628133541.GF2438817@hirez.programming.kicks-ass.net>
         <03def8b40a7db14f31d2ad67fb1a201e8ae8bce0.camel@intel.com>
         <20230630092232.GB2533791@hirez.programming.kicks-ass.net>
         <716cdf73799a5322cbe34c7f23d582f8a3ecf301.camel@intel.com>
In-Reply-To: <716cdf73799a5322cbe34c7f23d582f8a3ecf301.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.3 (3.48.3-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6553:EE_
x-ms-office365-filtering-correlation-id: fa0752d9-3075-4733-fb1b-08db7a0b479e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uQcoQFrfdOly0g2X/BVNeNo5Sp145WuVhAhNXDrUT2vwoOWawHcy3pMfJJLQu9Gc5C8PplVAFjCJCMtDfvoIR4L/UPelvvkTqcgPk3mRQnjj11vNGBEDduezuvg+jVMFo56UIDTIkjPYZiQErgSwKRL8AoAxTgFdI2KgRWeQnHYTBIVWWwcBBjnAN/UXAA4FqiJ00BkCZyTj3xvrfOGdOxkQi9XezIk8XRs2Pdv0Qgmt8+5g0XQETFoc+6x4RlhmiOQNnmJvnTydTuL9ELw1aa/FFHELfYL5XlpcnBoPoKPXsmmupabKVriLOdFeleKrxPoCniWaR/uNuKeQUZQN5kWWK6zUBfN5c5XSpO82c2c98M659KqTBp7OYUh+5+GoBpWAgX9eYGayvUx3/GdMeeqnkwNQrV118pw1OcUzoQxXOOm4wFvsZ8kQSd95RAyKsA0jVWFdQy2pf2qJeOJnlyquJXc/PCRhmYxXpqiVbev/SWfhg2sNfmYzUlh2VWXcZWEwhQRaIHWrFpP734gauNY5IyNQX4wHw5lUOC1VNHqvVGDfriC+Vc+sYLb22ySHm6M4ehJG+zM2jzdg1y2dT4tfp7fs+px9QZpN7CtsZMUcyeZNNcipSLZGymjIVKi6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(366004)(396003)(136003)(451199021)(41300700001)(6486002)(38100700002)(71200400001)(82960400001)(122000001)(2616005)(83380400001)(6506007)(26005)(186003)(6512007)(38070700005)(54906003)(86362001)(478600001)(316002)(2906002)(36756003)(91956017)(64756008)(66446008)(6916009)(4326008)(66476007)(66556008)(66946007)(76116006)(8676002)(8936002)(7416002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eFBIMmR6enB4N25lcjVjR3VneDZyMXhtRWZsdEtoOFlhUERwTFhCdjhCOElt?=
 =?utf-8?B?R0pnR1VUQVVJa0JaOXVycDhSNHNPTGJEQncvdU1ibTBDdU1wWWx4U3llNWFQ?=
 =?utf-8?B?cnZ1Wm05QXVpMElyc2g3czVoYkNSUlFHU1R6aHdjaUppU0k3REpKY1RrVlV2?=
 =?utf-8?B?MzFjNzNrMitGbUs0MGFKeHg1MkVTSUpRamFMZHVMbnNDZ2ZqUHZvY0diNmJz?=
 =?utf-8?B?N05jTTZ2aXlGTkQybDZRZlB2azQ1Nm04d0dUdDY0OGJwdDNZUFVXY24vbUhP?=
 =?utf-8?B?UTBsMGEwTDBWKzM1cmw2T2VDN25OeHNIRlpabnN0MndoQWI5T042T0VOMHUx?=
 =?utf-8?B?QWdMaGduWjFEaFJ4dFpVZkhsMXpQRy9LQXZHbjlkOFVoMjh1Y2VsazdsQndR?=
 =?utf-8?B?NFlNdExjUDRjMENtN2VIRGs4Unova2JLT21uQVVjN3FORys1M2dlcWNrLzVa?=
 =?utf-8?B?d3VLaVk5dE9WQlNnMldWcjlNeWxXdHVlU0dIeitKdG1ORjNBT1hBcHd1d1hh?=
 =?utf-8?B?ZEcwZm53UjVudmFRcDg4djlta0cwc0VzVndadjlzdlQvZThOeEIxZm9XQ2ts?=
 =?utf-8?B?Zy9WSkhqeUNOOXdFbGdSdktrMnF3akJIb3ZiaGxCamFkem92Z2VrdTRhUFdG?=
 =?utf-8?B?bXU3UTZjejBndmkrUUorcFA5cjJvbG50amxtYUdJQ2IwSnZzSzRYYy92WjE1?=
 =?utf-8?B?dno0RjdmY00zbGdIUU1mMStMSFFqeFFoSDdqd0U5Y1NpRWhmZSt6Z04xeVVV?=
 =?utf-8?B?c2RqKzBJN21zdzRhcEtCdWlNMzZuU1BQUTZHWGVjQkJMTU9HQTRibS9CcFR5?=
 =?utf-8?B?WTFnUUtXM3gyR3dOd0xrVmRPOUZ2TWVFVUFzamVSV0JNd2l1dWZYZmJLdGFz?=
 =?utf-8?B?dlhvSjJLRDJ6MmxaVUdvTTRydjJNa09wbUVkRjNaSkV2ZUZxWHhNR0twcUV4?=
 =?utf-8?B?UFUyRVBDamU4Mms0WlcvcnVqWDhvY3N0eDNYcTZDN05tM3psaGJuUDBybWNX?=
 =?utf-8?B?T0dxWTM0em1wYlQ2SjRwRzN4SWUyUkx6OU1yS3d1ZDBuSEkwMmt4alBzZCs0?=
 =?utf-8?B?REx0R0V0aXFpSUh2RUQ1RG1tVUdMUzNBQ3l5elNNWXVZcnR4NGJka1lVLzFz?=
 =?utf-8?B?R25yVU94UjE2aDZLM0FZc25HWWs2Q1YvKzkrTG02YU5KdHZxb2FMS3Y4SEsr?=
 =?utf-8?B?S256VGNZbUJ5Zlh3U1EzS1VrYlhHenN3a1psREpVV1hoM0FWdnNEQTRQKzRK?=
 =?utf-8?B?aUxubkRyanVocWNiVDJpNjBVdjdjRjRPeHRtSSttVGtrMjhWU09sNEtIb0pr?=
 =?utf-8?B?eDgvV2NFbWhWU3hxSytEYVFGYmNYZ3ZRL01ZK0tTN25weDBxN3ZiOWtKdEJo?=
 =?utf-8?B?V2o0RDJQOVVXWkowRktyUFZ4a0ZydFhwT2JPZE10ZEQ1ZFRaYVJxWE9pQjBJ?=
 =?utf-8?B?MTBjWkgwb01Bc0J3VW5aN2tWeU9iN2NaT21xZHFNeTdVMHQyRjF0MTZOTTlC?=
 =?utf-8?B?dkFWTWE0dE90bi9FL3p5NHRsM1JkK3doUXpsU3BSYUlqckI4a0hNQkRNN1hN?=
 =?utf-8?B?YVFaMkdWZnN3WHZqK1VTaGd6a0ZGUkFnKyt1aFZ6MlgxVkg0aUNhQjcrOURh?=
 =?utf-8?B?cGVQL3Rtc0xBSGJVMTJyUzZ0Si9EYUdZZ2NISkkvWlZDUy9Nb3haWHBMNTlN?=
 =?utf-8?B?VmpQZWV6aE4vZzg3WnhmWlh2dWl2V0RHNzlhYjVJRVliNnU2Z1FNSkdDSGJX?=
 =?utf-8?B?TDF3SGRoOVpCdTVOeHQxVVZuUlQreCt2VEdmMmpNVEVOVWh0cG5Ydm1mWEZY?=
 =?utf-8?B?SGdMeS9EYkVTMXZuY1pJM3RzUnJlTzFpNjFPUWlkNkdSakRaTVd3bEtQdU82?=
 =?utf-8?B?NEVvM1lMbXVjT0dudUNOd3YrbjZUMFBzQXJIUEZsTC9ENTExODhrVFgxTFFl?=
 =?utf-8?B?N1l3Ry8xckRTSmsvU2Npa2ZTNTlRZ2wrMTEvZlpUQ2VWZi9oTnFDTVNoWFNB?=
 =?utf-8?B?VGVyTTgwN2F0akY0bHlBSjZ4aHZiQS9TaDVoWlczOFJrcUZERHRibzFDVUc1?=
 =?utf-8?B?Y1hyNmpSazRUTEgyaW9OQkJGaFZETml2K0h1MWJVOUQvbDJRME9VM3RWNlBh?=
 =?utf-8?Q?qafrpc/kWmsizkf0jGKLleN4d?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <76990F85E794184CBEE28BF072B76020@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa0752d9-3075-4733-fb1b-08db7a0b479e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2023 08:15:06.7309
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8G9SVcSbqAe5U0z5VJBDFTkT/7nlFxUWoYKtEtktIQNb9DE1MfYhlJ//env0eoq9yPAaK3H4uuflCh0fSnSiBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6553
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA2LTMwIGF0IDEwOjA5ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBGcmksIDIwMjMtMDYtMzAgYXQgMTE6MjIgKzAyMDAsIFBldGVyIFppamxzdHJhIHdyb3RlOg0K
PiA+IE9uIFRodSwgSnVuIDI5LCAyMDIzIGF0IDEyOjE1OjEzQU0gKzAwMDAsIEh1YW5nLCBLYWkg
d3JvdGU6DQo+ID4gDQo+ID4gPiA+IAlDYW4gYmUgY2FsbGVkIGxvY2FsbHkgb3IgdGhyb3VnaCBh
biBJUEkgZnVuY3Rpb24gY2FsbC4NCj4gPiA+ID4gDQo+ID4gPiANCj4gPiA+IFRoYW5rcy4gIEFz
IGluIGFub3RoZXIgcmVwbHksIGlmIHVzaW5nIHNwaW5sb2NrIGlzIE9LLCB0aGVuIEkgdGhpbmsg
d2UgY2FuIHNheQ0KPiA+ID4gaXQgd2lsbCBiZSBjYWxsZWQgZWl0aGVyIGxvY2FsbHkgb3IgdGhy
b3VnaCBhbiBJUEkgZnVuY3Rpb24gY2FsbC4gIE90aGVyd2lzZSwgd2UNCj4gPiA+IGRvIHZpYSBh
IG5ldyBzZXBhcmF0ZSBmdW5jdGlvbiB0ZHhfZ2xvYmFsX2luaXQoKSBhbmQgbm8gbG9jayBpcyBu
ZWVkZWQgaW4gdGhhdA0KPiA+ID4gZnVuY3Rpb24uICBUaGUgY2FsbGVyIHNob3VsZCBjYWxsIGl0
IHByb3Blcmx5Lg0KPiA+IA0KPiA+IElQSSBtdXN0IHVzZSByYXdfc3BpbmxvY2tfdC4gSSdtIG9r
IHdpdGggdXNpbmcgcmF3X3NwaW5sb2NrX3QgaWYgdGhlcmUncw0KPiA+IGFjdHVhbCBuZWVkIGZv
ciB0aGF0LCBidXQgdGhlIGNvZGUgYXMgcHJlc2VudGVkIGRpZG4ndCAtLSBpbiBjb21tZW50cyBv
cg0KPiA+IG90aGVyd2lzZSAtLSBtYWtlIGl0IGNsZWFyIHdoeSBpdCB3YXMgYXMgaXQgd2FzLg0K
PiANCj4gVGhlcmUncyBubyBoYXJkIHJlcXVpcmVtZW50IGFzIEkgcmVwbGllZCBpbiBhbm90aGVy
IGVtYWlsLg0KPiANCj4gUHJlc3VtYWJseSB5b3UgcHJlZmVyIHRoZSBvcHRpb24gdG8gaGF2ZSBh
IGRlZGljYXRlZCB0ZHhfZ2xvYmFsX2luaXQoKSBzbyB3ZSBjYW4NCj4gYXZvaWQgdGhlIHJhd19z
cGlubG9ja190Pw0KPiANCg0KSG1tLi4uIGRpZG4ndCBoYXZlIGVub3VnaCBjb2ZmZWUuICBTb3Jy
eSBhZnRlciBtb3JlIHRoaW5raW5nLCBJIHRoaW5rIHdlIG5lZWQgdG8NCmF2b2lkIHRkeF9nbG9i
YWxfaW5pdCgpIGJ1dCBkbyBUREguU1lTLklOSVQgd2l0aGluIHRkeF9jcHVfZW5hYmxlKCkgd2l0
aA0KcmF3X3NwaW5sb2NrX3QuICBUaGUgcmVhc29uIGlzIGFsdGhvdWdoIEtWTSB3aWxsIGJlIHRo
ZSBmaXJzdCBjYWxsZXIgb2YgVERYLA0KdGhlcmUgd2lsbCBiZSBvdGhlciBjYWxsZXIgb2YgVERY
IGluIGxhdGVyIHBoYXNlIChlLmcuLCBJT01NVSBURFggc3VwcG9ydCkgc28gd2UNCm5lZWQgdG8g
Y29uc2lkZXIgcmFjZSBiZXR3ZWVuIHRob3NlIGNhbGxlcnMuDQoNCldpdGggbXVsdGlwbGUgY2Fs
bGVycywgdGhlIHRkeF9nbG9iYWxfaW5pdCgpIGFuZCB0ZHhfY3B1X2VuYWJsZSgpIGZyb20gdGhl
bSBuZWVkDQp0byBiZSBzZXJpYWxpemVkIGFueXdheSwgYW5kIGhhdmluZyB0aGUgYWRkaXRpb25h
bCB0ZHhfZ2xvYmFsX2luaXQoKSB3aWxsIGp1c3QNCm1ha2UgdGhpbmdzIG1vcmUgY29tcGxpY2F0
ZWQgdG8gZG8uDQoNClNvIEkgdGhpbmsgdGhlIHNpbXBsZXN0IHdheSBpcyB0byB1c2UgYSBwZXIt
Y3B1IHZhcmlhYmxlIHRvIHRyYWNrDQpUREguU1lTLkxQLklOSVQgaW4gdGR4X2NwdV9lbmFibGUo
KSBhbmQgb25seSBjYWxsIHRkeF9jcHVfZW5hYmxlKCkgZnJvbSBsb2NhbA0Kd2l0aCBJUlEgZGlz
YWJsZWQgb3IgZnJvbSBJUEkgZnVuY3Rpb24gY2FsbCwgYW5kIHVzZSByYXdfc3BpbmxvY2tfdCBm
b3INClRESC5TWVMuSU5JVCBpbnNpZGUgdGR4X2NwdV9lbmFibGUoKSB0byBtYWtlIHN1cmUgaXQg
b25seSBnZXRzIGNhbGxlZCBvbmNlLg0KDQpJJ2xsIGNsYXJpZnkgdGhpcyBpbiB0aGUgY2hhbmdl
bG9nIGFuZC9vciBjb21tZW50cy4NCg0KQWdhaW4gc29ycnkgZm9yIHRoZSBub2lzZSBhbmQgcGxl
YXNlIGxldCBtZSBrbm93IGZvciBhbnkgY29tbWVudHMuICBUaGFua3MhIA0KDQoNCg==
