Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26EE5633BA7
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 12:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbiKVLnr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 06:43:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233445AbiKVLnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 06:43:03 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85E065ED;
        Tue, 22 Nov 2022 03:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669117296; x=1700653296;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=M4VaQkgMqvDRKFf/ha7aYwUMBnVyo7+Y1dj5bwfzV1c=;
  b=Vlf9/4mklSWOtSW2lbCfHH8iK31I2RB2C6Xqq4qNlzTi9DZ+djWneyL1
   HHepkmR/In0vffSVLg4Y6OIqBLvwn8wWMfp+Ov9PCpjVpWHjOCZtVXQEd
   VVnJj154qmP9KZGnhkV1Lp4Rt3087WnPyIYt+55o0w2nXkt1rY0ts4783
   HBplJZb8RxWAYjMKVk/CxIywI8YgPV9ZAsc+Zr8glNjOTCyIzJBQ+aqj4
   L/pE5rpHnIaQfdALZBzZI3hIz43xCFzolOqA266VAIE/yF+urEMbPcJLI
   lbtg+4JpjzSPY5k3qUM8cekOfpOW5k/eNElzSBK3DnH0nbGTBh12Wp8Ys
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="311424055"
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="311424055"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 03:41:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="619184163"
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="619184163"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 22 Nov 2022 03:41:33 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 03:40:48 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 22 Nov 2022 03:40:48 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 22 Nov 2022 03:40:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hhRD4hxcztwS3of1VZm4S+4PuoaT40vcLmRskMglkmZQGj1q6y0Gidf+MB6u7ROWsPpo0x1ewzO6/czpQ4GvryfUhkRZlCkCLokt7yD4SatvF4zTra/KaBB2HTRM8Kt6iCT/Of2SistqJP89hR/Z2Thr9mEImM56+yvGz0YqH8NacXdSEsP+lh1DErom5WWrO8EBLivXbhUBVVp6ojRVVaJT9BWEOLtsk9QIluR0qjj8+UNyGIPgMuDs6GmRDVily3/3b1r+thQxUsDk68pdidXJiPh3ZSjz6UdIaW/7g5dZAw/Y+PvqjcVdszjDiUmeajxs+JHOece+LHh5ETi1VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M4VaQkgMqvDRKFf/ha7aYwUMBnVyo7+Y1dj5bwfzV1c=;
 b=kxcRnGP4HsCslpbM9+PCDHkiScgYQbHmkw9sb3rMfxW1ON/Lc5Fs+HIJJ4hFa+hym0TIPpIK1z/5z+d9E9qnZrZ2udE8yyZbLf7M3DV0fdx7nKH/qedzGeVyOnOeCGP9j+xWJV0XWt54sHoc4ge8J/O98CZ2Nnc2zsQcowweKvuM9NsXJboQfOpXZLahYW/WPQAn5OitP5Jrx+H8UKaojxJZU/MGCsDsQLFGZzEx0MoyDkv+0lz5/DaEk63izXrN3/Nv0sZV6IlSKVrpgqI+aDtXzspPsemJMEVRN/oVYX0ZDdpgx+4MJsA4rKzrAnEY+W5twPfNqy0NqMGih9pQKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5384.namprd11.prod.outlook.com (2603:10b6:208:311::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Tue, 22 Nov
 2022 11:40:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 11:40:45 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Topic: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Index: AQHY/T3KCI/2IUKL7kSgXbHXnV3Az65KuuYAgAAZIQA=
Date:   Tue, 22 Nov 2022 11:40:45 +0000
Message-ID: <8181ea2e5f59a69496ec24282173b27a90330e47.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <9b545148275b14a8c7edef1157f8ec44dc8116ee.1668988357.git.kai.huang@intel.com>
         <Y3ygKH0/rdhKwv4m@hirez.programming.kicks-ass.net>
In-Reply-To: <Y3ygKH0/rdhKwv4m@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB5384:EE_
x-ms-office365-filtering-correlation-id: c0429103-ac90-409d-c305-08dacc7e64b7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5C11V0KilzaQk+WnZRRSwH5somSbGC8WSH4tgaJN5bvZ9VoGOQ9xb1ZG9XrhKSzx16TxHiLfh1OCpo93vWEQ2849zredihQ+1sAAtrTqxRW0Ekopzinzv/IlfUjwLH4qUovbft3iauF1Okg9niodueXZ+dmAv0xMEJsUlO4ZXfqiglPtx3T8GeTvy1ZhfVgmXrW2UVHJVq+dj+6589CRAQwGtOFjV1CVfWB12MJYb/0hdpCE22yEJxNtAEAUPXij4VStKt2E0JiC9seyD0XVC5BGZTUTJn2WGa+jbZvdeNgB6h3DgZrAa+sGeGq2/qzg9MAPOA/5Yk82r1kp5rltgzC3Pohxv10rKV/cfmtg9wTpKjPne3kpIvZNQVZ3HGJRreleL4EJz4JBSKXayLPJ03bZPdJfILW9i47EDYAQt02D6bfabYo0AaaLoQQ9Kop0vA9X5RlACCkpRDB48ZnwxSySavCoXA+C0CBTPLDEVoFWgEmm4ijWuc5pr5LTlF78zMgmRnlrD10xFblLGyrLV+xVSYyNLfmQnh4d9mh9eVvG9MzHJAl3KW5pgJnnZ1UKKP3hv5Yn+DFKIa0u6S6RAX+mLAFizoZtWHN59vp7cFEiaxu/VIzLf837A5pwkmmF5x/TE7pApNRX8k7xX1P2RlVwzjKoo1/yhXd/cad0DgFG3mrKoZfe4r65siv9t+ObYwIPt1gvjkx3FRUmZcleaw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(396003)(39860400002)(346002)(451199015)(38100700002)(6506007)(478600001)(6486002)(86362001)(71200400001)(122000001)(83380400001)(82960400001)(316002)(186003)(4001150100001)(36756003)(8936002)(6916009)(2906002)(54906003)(2616005)(76116006)(26005)(91956017)(41300700001)(7416002)(66556008)(38070700005)(64756008)(4326008)(5660300002)(66476007)(6512007)(66446008)(8676002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eGh5cDRxRmRVbkdnTzlLaGpISW8rb2o5emNSUGZnZGl4T0tjLzRGOUlMVHB2?=
 =?utf-8?B?OU1JZmVCVGdWemt6VXRVVkRyaUlxSlIyUG1ibk03VTBXd2xPb0YxTVp1eENT?=
 =?utf-8?B?TzZyL1cwWGNQYVBwckpVb2E4YWlldVhHc2o3TkNzWllBVCtsOElJdmVsdmQ4?=
 =?utf-8?B?U3ljRlpmMm9KWkhuQStZeHUveW8yR20raktBdE4yVm1YQVZLTnJUKzNiUXp1?=
 =?utf-8?B?ZGtPODRkbmkrYy96dEtQRzZkMGN6QWpOMXJpL3liWHRrR0x1aUhxam9wYXFG?=
 =?utf-8?B?M3lsNkN1MitNQXFuUnc3UlZMek5EYURtd05tQkp4RERFS3NTZ002K0RwaUJS?=
 =?utf-8?B?M3gvelkvcU4ycVZaOXdkbjVBSjIyWXIyV043OUFvUDVyZ3pVN3FjTVkwVGdT?=
 =?utf-8?B?VFdkMWJucDlwSkVJRnNTMHJuSFk3QkkzclJtMzVDT3Q2NjZ2Z05xcG5yNU1z?=
 =?utf-8?B?eXZ5MXhRcHhrZVlHK1hYRlFGOFFHbE5tYU5iRlFFNnc5MGIvNjZ0Mkd3aWlE?=
 =?utf-8?B?bk9mNnlRb3ZvM2VsSGZVd2hOd0JaUkcvenZFZUJ6NVc2YTJ2bjkvc3d1ck9z?=
 =?utf-8?B?YnArRmxmUWNCV1RIek5RdWlpcVZ4ZkVxR1dCSCs3Z3Z1aDZQNm9qcW5mb0VE?=
 =?utf-8?B?Y2VPMVovVzYwQUlOSEpNengzU3hRQ0RYMzJ0YTFuS2xldjVtQUdEdkd4dUJ5?=
 =?utf-8?B?cTVuWUt4cDgwdFc0QXlhb1BFMDduVkNFdWlua3JGdGR6RWVkejJwQkFTSmVO?=
 =?utf-8?B?UUdsZjJSM3lNY20wWmtuYTdLaDdzSlJmek4xampUN0NLOGc5a3ByRjI2YWRX?=
 =?utf-8?B?clRFeEt5NzNGWHJaSXVrc0l0NmdySk9mWWd4OWZXSGZzMFRZZ2l2TSsvdzlD?=
 =?utf-8?B?NUJITWZWVzRDRXZCYnJNVW95U0tJdEpEdU1ab0Zka3R0ZjRKeG1DbEtxRzhJ?=
 =?utf-8?B?QnRSZnE2ZWQ3TWJ6Q2FxSldrcEtReWlFTkhWUzFHVExETWhKK0xaUjVWdnI4?=
 =?utf-8?B?MW4ycHB2UVN5cDc3RE5YN3hsTDdJZnlmcGxBN3lrYTZaQlVjWlBlLzhYMVoz?=
 =?utf-8?B?WnR6ektOc3dadmJBSTFFUHowUEwxNWJSYVo0QVRwblRCcm9HQktRVzhBa0x4?=
 =?utf-8?B?WCs1aFFhN2RSV2NpWWxyR1kyRU9JZ2Nla1FCd1R4ek9CTXBYaXg5QnNPZGhj?=
 =?utf-8?B?czlUd3lwMEtySnZLakRIR0poZm9uMkltR1FCeWdHME5hN2NHOUFrWEswWTlJ?=
 =?utf-8?B?ZDVKbmo3d2J6RFduUnA5WU92dFpCY0pCamFLdVFENkM3K3liUDFqenlkUG0y?=
 =?utf-8?B?Y2c4aTFpdWZqVFZWTFp2ZFcvdGJ6aFIyalVrVUlrY21LMEFEZnQ2bmVIZ3J2?=
 =?utf-8?B?Qkl1dHBYUFBsdS9RVmpPOUlKQm94VjA0aFAwMHAxVGVKd2pSQUZyTlBPOWwv?=
 =?utf-8?B?NStNOXZ3NHNlWFZjODBwQ0JEcXFXanFtR051bHg3TmZvVXo4V012OERtQTVF?=
 =?utf-8?B?NVRyNXpRaFpndjJxQ0dCTUNJSDZyOUhWM0FSeVRkdXp1UUN2MEwxaDYyWWI5?=
 =?utf-8?B?ZEtST25jT3pSWXhEMk95cXdvd3Q1QWtFRERZb0dvcUFsQjVWaEtlbnFJZlla?=
 =?utf-8?B?dU5HV2JDVFlNdzFEUGt2dWJVTFZPek82Q0d1SlZQVjE5VmlxOUVNOVBReU1J?=
 =?utf-8?B?ZnRUZUtMQlRTcURJbEtYSDl4SW9nVEhPT1BJdkl4L1pjcUFRQVE5Tkh1NXZ2?=
 =?utf-8?B?ai9DR091TE5CUWZpZmQweEI3V1BFaWsySXcybzRsS1ZBbnJ3c3VYemJHVHEz?=
 =?utf-8?B?Szg3RVZTNWR0MGZxTm9IaEczdDNZeTJ3OVZxaU5PZzJOdlNGT1RwU1AxT2lj?=
 =?utf-8?B?ZUJCQVVTNE5SS0s3ZkxIV0p0S3Zscy83akpLMU1Zc1FWMnJ2QVMwdkRJd3Fs?=
 =?utf-8?B?Z3hWYWxhUFk0L1JyYUZYM3N1R2U3ZDB1RDlnRlhXc2ZzNjBrQ0dkckRtUXov?=
 =?utf-8?B?V0tCSzNKVW02ajlJZFFQL1RjRHpwdWFlSVNBQjYwYW9QeEE4QVFzWThBMGJF?=
 =?utf-8?B?dlYwY2llZ3dUU3RNVmlWdW9TMDFLZy84bFFuajVKbngzM2hXY0xSL1lnbThK?=
 =?utf-8?B?ZkZ0UVlWV21IRnQzckV2ZW5raGNiZDBUTVNNa050bW1GNGw5a3lPSTZKb29X?=
 =?utf-8?B?MGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <310A0F5080923C40B5C50AA8CD68907E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0429103-ac90-409d-c305-08dacc7e64b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2022 11:40:45.3588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0fPI8hq/oxoF5aMCeW7Qtr3tL5K7LBtGOkLRwtPi8KH7aIJyHwJpberNV33epeyDOTVs6cbi/Ri9BDFMagiNsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5384
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIyLTExLTIyIGF0IDExOjEwICswMTAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gTW9uLCBOb3YgMjEsIDIwMjIgYXQgMDE6MjY6MzJQTSArMTMwMCwgS2FpIEh1YW5nIHdy
b3RlOg0KPiANCj4gPiArc3RhdGljIGludCBidWlsZF90ZHhfbWVtb3J5KHZvaWQpDQo+ID4gK3sN
Cj4gPiArCXVuc2lnbmVkIGxvbmcgc3RhcnRfcGZuLCBlbmRfcGZuOw0KPiA+ICsJaW50IGksIG5p
ZCwgcmV0Ow0KPiA+ICsNCj4gPiArCWZvcl9lYWNoX21lbV9wZm5fcmFuZ2UoaSwgTUFYX05VTU5P
REVTLCAmc3RhcnRfcGZuLCAmZW5kX3BmbiwgJm5pZCkgew0KPiA+ICsJCS8qDQo+ID4gKwkJICog
VGhlIGZpcnN0IDFNQiBtYXkgbm90IGJlIHJlcG9ydGVkIGFzIFREWCBjb252ZXJ0aWJsZQ0KPiA+
ICsJCSAqIG1lbW9yeS4gIE1hbnVhbGx5IGV4Y2x1ZGUgdGhlbSBhcyBURFggbWVtb3J5Lg0KPiA+
ICsJCSAqDQo+ID4gKwkJICogVGhpcyBpcyBmaW5lIGFzIHRoZSBmaXJzdCAxTUIgaXMgYWxyZWFk
eSByZXNlcnZlZCBpbg0KPiA+ICsJCSAqIHJlc2VydmVfcmVhbF9tb2RlKCkgYW5kIHdvbid0IGVu
ZCB1cCB0byBaT05FX0RNQSBhcw0KPiA+ICsJCSAqIGZyZWUgcGFnZSBhbnl3YXkuDQo+ID4gKwkJ
ICovDQo+ID4gKwkJc3RhcnRfcGZuID0gbWF4KHN0YXJ0X3BmbiwgKHVuc2lnbmVkIGxvbmcpU1pf
MU0gPj4gUEFHRV9TSElGVCk7DQo+ID4gKwkJaWYgKHN0YXJ0X3BmbiA+PSBlbmRfcGZuKQ0KPiA+
ICsJCQljb250aW51ZTsNCj4gPiArDQo+ID4gKwkJLyogVmVyaWZ5IG1lbW9yeSBpcyB0cnVseSBU
RFggY29udmVydGlibGUgbWVtb3J5ICovDQo+ID4gKwkJaWYgKCFwZm5fcmFuZ2VfY292ZXJlZF9i
eV9jbXIoc3RhcnRfcGZuLCBlbmRfcGZuKSkgew0KPiA+ICsJCQlwcl9pbmZvKCJNZW1vcnkgcmVn
aW9uIFsweCVseCwgMHglbHgpIGlzIG5vdCBURFggY29udmVydGlibGUgbWVtb3JyeS5cbiIsDQo+
ID4gKwkJCQkJc3RhcnRfcGZuIDw8IFBBR0VfU0hJRlQsDQo+ID4gKwkJCQkJZW5kX3BmbiA8PCBQ
QUdFX1NISUZUKTsNCj4gPiArCQkJcmV0dXJuIC1FSU5WQUw7DQo+IA0KPiBHaXZlbiBob3cgdGR4
X2NjX21lbW9yeV9jb21wYXRpYmxlKCkgYmVsb3cgcmVsaWVzIG9uIHRkeF9tZW1saXN0IGJlaW5n
DQo+IGVtcHR5OyB0aGlzIGVycm9yIHBhdGNoIGlzIHdyb25nIGFuZCBzaG91bGQgZ290byBlcnIu
DQoNCk9vcHMuICBUaGFua3MgZm9yIGNhdGNoaW5nLg0KDQpBbHNvIHRoYW5rcyBmb3IgcmV2aWV3
ISAgVG9kYXkgaXMgdG9vIGxhdGUgZm9yIG1lIGFuZCBJJ2xsIGNhdGNoIHVwIHdpdGggb3RoZXJz
DQp0b21vcnJvdy4NCg0KPiANCj4gPiArCQl9DQo+ID4gKw0KPiA+ICsJCS8qDQo+ID4gKwkJICog
QWRkIHRoZSBtZW1vcnkgcmVnaW9ucyBhcyBURFggbWVtb3J5LiAgVGhlIHJlZ2lvbnMgaW4NCj4g
PiArCQkgKiBtZW1ibG9jayBoYXMgYWxyZWFkeSBndWFyYW50ZWVkIHRoZXkgYXJlIGluIGFkZHJl
c3MNCj4gPiArCQkgKiBhc2NlbmRpbmcgb3JkZXIgYW5kIGRvbid0IG92ZXJsYXAuDQo+ID4gKwkJ
ICovDQo+ID4gKwkJcmV0ID0gYWRkX3RkeF9tZW1ibG9jayhzdGFydF9wZm4sIGVuZF9wZm4sIG5p
ZCk7DQo+ID4gKwkJaWYgKHJldCkNCj4gPiArCQkJZ290byBlcnI7DQo+ID4gKwl9DQo+ID4gKw0K
PiA+ICsJcmV0dXJuIDA7DQo+ID4gK2VycjoNCj4gPiArCWZyZWVfdGR4X21lbW9yeSgpOw0KPiA+
ICsJcmV0dXJuIHJldDsNCj4gPiArfQ0KPiANCj4gPiArYm9vbCB0ZHhfY2NfbWVtb3J5X2NvbXBh
dGlibGUodW5zaWduZWQgbG9uZyBzdGFydF9wZm4sIHVuc2lnbmVkIGxvbmcgZW5kX3BmbikNCj4g
PiArew0KPiA+ICsJc3RydWN0IHRkeF9tZW1ibG9jayAqdG1iOw0KPiA+ICsNCj4gPiArCS8qIEVt
cHR5IGxpc3QgbWVhbnMgVERYIGlzbid0IGVuYWJsZWQgc3VjY2Vzc2Z1bGx5ICovDQo+ID4gKwlp
ZiAobGlzdF9lbXB0eSgmdGR4X21lbWxpc3QpKQ0KPiA+ICsJCXJldHVybiB0cnVlOw0KPiA+ICsN
Cj4gPiArCWxpc3RfZm9yX2VhY2hfZW50cnkodG1iLCAmdGR4X21lbWxpc3QsIGxpc3QpIHsNCj4g
PiArCQkvKg0KPiA+ICsJCSAqIFRoZSBuZXcgcmFuZ2UgaXMgVERYIG1lbW9yeSBpZiBpdCBpcyBm
dWxseSBjb3ZlcmVkDQo+ID4gKwkJICogYnkgYW55IFREWCBtZW1vcnkgYmxvY2suDQo+ID4gKwkJ
ICovDQo+ID4gKwkJaWYgKHN0YXJ0X3BmbiA+PSB0bWItPnN0YXJ0X3BmbiAmJiBlbmRfcGZuIDw9
IHRtYi0+ZW5kX3BmbikNCj4gPiArCQkJcmV0dXJuIHRydWU7DQo+ID4gKwl9DQo+ID4gKwlyZXR1
cm4gZmFsc2U7DQo+ID4gK30NCj4gDQoNCg==
