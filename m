Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9FA665036
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 01:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235398AbjAKAHC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 19:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234454AbjAKAG7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 19:06:59 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB7B11C02;
        Tue, 10 Jan 2023 16:06:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673395618; x=1704931618;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zXnOowXtLmxmELTI+UnSqrdd/l0oo4wVGyLEPrOMWDE=;
  b=JOJvHBwf6wJ4TeTH5zFIdERNUBGwJ1Xw+NNoOXyAAVVG491Qype80Mwb
   Fg54GOeEymWU7T2H6efHwmxvWHtGTTKo3EN+/tlYOzRa7nMpSXcTmbDCm
   EB3YQgAX7da+ohBsxmyYOS+AMkttiWczBZ89YmW90SDKjJG6bA5e6+Wuz
   4H+Iyf+HuJzQx/YssCrkMCaK/Amsme72LIkyHOec2Zo9j1pIaj6Qgmrda
   b+JXpc9EnDjj6xgUqa9/UV4tKhVf8mkevbQfGd56yhCbJ+EPgFeYPTwed
   KeXHTHXxQOnYDT0xsWW0+ekcwbnJ9GKYzHUc07u9EEdZgoJqhkzkltXDf
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="324527809"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="324527809"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 16:06:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="650539727"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="650539727"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 10 Jan 2023 16:06:51 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 16:06:51 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 10 Jan 2023 16:06:51 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 10 Jan 2023 16:06:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ofL3pGbarRI4YayzpUMLCnemUbOJVrLBcgxViJQXGV0afIP23H/8uMeIqDiDu6zS4pWj7QojoYfnCFUvU3xl2oMh7qYsl8XLlMNIXcE2OaIQNx6Vf8dB/35X2t8tjej97aDNPZqBmf1oiUX21eStzBtyXHtmUB7w1tLhAnx7uj+t5pKcDyIYCIXkkyXxRVchilrFXqNRYYj4pTkKu9HXNv9n1SVWxmJ8IEOSx00rtqKMmh+s4UW9kwUAXmvFCUX0TaIU8uVcyYZ03lknfisCBqt/s6CItVcEP54w1X3DUOCVm63XM8i4JDLnTjAI4nhLlEqBRjASmTGjfVOdQ6reTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zXnOowXtLmxmELTI+UnSqrdd/l0oo4wVGyLEPrOMWDE=;
 b=h7OEUA6GrZZEqbvoVz/aJh6SYBFvW/IDKyjxhRw5ebOTpTcMNpQ0VxZg4Crcg0aiib8XfBOiuXxkg/ztx/UBJNX6mOrdYgwZlOilXJr6QufloN/f5YbSmxg5igV46Yi66kW5ad3H7+BfLorIhBBGumfh8e8L8Ilpg0bnmGPj+063blj+985pQ9/XnUhlnOY4oaESoGu4A5YAw8i07MLYfCzXF+JJ6rDyEnkk0pQKxqXuyILPkhR+/m3xPL/QvLKyjDj5nSFRP00d7CAxlGFMwVHVD9pk8bGjZ+tqkvcZpVQUgSDBU+CXTcHcmCyQ69Lsxb/jhcMtJn5xYJLUlBVBPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 00:06:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 00:06:45 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 13/16] x86/virt/tdx: Configure global KeyID on all
 packages
Thread-Topic: [PATCH v8 13/16] x86/virt/tdx: Configure global KeyID on all
 packages
Thread-Index: AQHZC5gTAr18MF1uBkCdPkCajcg97a6SKw2AgAV2uwCAAG8NAIAAeSeA
Date:   Wed, 11 Jan 2023 00:06:44 +0000
Message-ID: <7cd87be05d6e99f130c808cc33572dc68cab963b.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <383a2fb52a36d1e772bc547c289c5aeb8ea5d9cb.1670566861.git.kai.huang@intel.com>
         <9dca3a1d-eace-07ed-4cd2-09621912314a@intel.com>
         <d5134f59dcffdf5842a811c89dc336486885ea0b.camel@intel.com>
         <0f8acf9b-42a4-c079-7985-c5db4919c310@intel.com>
In-Reply-To: <0f8acf9b-42a4-c079-7985-c5db4919c310@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB5089:EE_
x-ms-office365-filtering-correlation-id: f9161a43-0710-486e-d699-08daf367b9be
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FmoKDGj9y0ef2aozoDp5v+exv97jUAp3v5zynVfebvm3H202DkTF9iWeyegLLXMuCruvtuupdYVw/nSAE2On94Y13UyYQj44sCZX+R2Snzic8D2YSUY2O0Lb/Pkuk7+QF3igX+MnH21260vAhoI2/ttvOD93lFqufEwAKAeUCJs+ULgEdBgeoP+ZQYP1eZnqc7kaeeMPzMuyTwJSnnkHhXcMftdonLY1IrdqYE0OAWEq4U0LchhM93t7MTZzISoxsDJ2XESkojlBvv93kqrScLRSIa9lS683JMfNbbH2MB1+BS23TjZWiGe/RRP0IAalBCaNNIX/B+L9t+ZnK4b1meW21QB00cSbQc1Wg1T50IjOrZxn/kxOEEJzMbftixZs6X0AzCWeHUXxCRREkPUbTfnWgLqyA4KiHSJMynCTSRzNb53dGsz2fXorLioKpI0w0omgHvEMLsLe1uKW0v0tYvwe6CwOPd1yb7ltO9wP9SbuWXq4b3ZpeDivVt6g7JiN2S04AL2wd+5Pj7mQnqYx7/9vPEMZ2zc93oKqkL8T1uvdFG9TjziPsHHiJ6SDm7eXgT75+1BomWRlVE6PM/tPorXF31HXSqZpB6c7+5cpBpPWPlblnXelk0V+oJdv1AbPeJEfbwrrzmfeI97FkIj40FzqHh0+95UYqQHXo4Ckmtwa6Nsl9Q2EHlzGCz/s/cLvIisuzryKhSjJvIWG4IyArNFjiFTUe4S5o/yJHJITkJakHagKnAmmMe1XiOGvx06LIrjpzxnIo+gS2TSGd9AZaw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(39860400002)(136003)(396003)(451199015)(2906002)(83380400001)(2616005)(7416002)(66446008)(66476007)(66556008)(64756008)(5660300002)(66946007)(53546011)(122000001)(8936002)(26005)(36756003)(186003)(6506007)(6512007)(6486002)(478600001)(82960400001)(76116006)(38100700002)(54906003)(8676002)(110136005)(41300700001)(86362001)(966005)(38070700005)(316002)(4326008)(91956017)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eHdBQUMyRGo2dGc4dU83cEU4bkRzaEIyd3BaSE1OVk9mQjJKTHoraXpLY2JB?=
 =?utf-8?B?SjlPRUdFcjFaVjVzakg5MVJqMzR1Wm45Qm1rQ05wMDZXQXFIcjNNQ05TV0t5?=
 =?utf-8?B?YVhTM1lLb1p5OElwS3c4VDVDRXZqSTVHT3g4WUxxcXlyWEI1NkZ1aGdkUUN0?=
 =?utf-8?B?WXhrWEJLWldFc3EzMXM4OTFQdHpuNCt6WUMrOXhSZFNMNWp4Y2VCaUhuMEFY?=
 =?utf-8?B?UkhtSUVkRHQ3a3NwbzBtTjlNRllMRDlJN29vWHpmeVJJMS9XdmovQy9BcGMx?=
 =?utf-8?B?MWhSQS9XbVNVanUyWjJhOFQrQUtBUTBmU2VMd1JRWlMyczRvUGNxQWFaZ1pL?=
 =?utf-8?B?Zi90WVNzc2x4UUF4VUErU1JVR3lOMkNlb2JiSE5DV01MekVOVmlHaTkrSnJD?=
 =?utf-8?B?Skl0eUVmVG5iL0RNWkNYZVJ4aUdEd2hSellDK1hTR2poN3E3enlOeTJvaXNp?=
 =?utf-8?B?SjRYK2ZWU0RCM3NiSnJ5NDlpZGlWV0N5dzV4SUk0ak0zcXdGakp5YmMwcC9T?=
 =?utf-8?B?WWI0L0RqeXF0ZGJQWmVOTTZ2b1lHM1R5cjREVWhWNU1uaGZnY0lXRzZxTFhQ?=
 =?utf-8?B?T0JnL1lmZmVPdm8rU1dyK3lhME5HRDlva3ZIN3pVN0xkeWhPamxFZm1xS0Uv?=
 =?utf-8?B?YzYyNjJuZmFxRVBvVXVRb09XNDRha1JXYlVmbFA4aWgyak5xQjZXZDE4Y0ZC?=
 =?utf-8?B?TXJhUWpuZzZTSDJvSGhvcmp6Uk5PTmUxMldyTGdpY290aDRBeFgvWU5Bb1dF?=
 =?utf-8?B?WlZnczIzNFY0eGRheHpUTGhqdDNPWGlJZ3QxNW9vdTdSSHNzSWtQeTg1d3RZ?=
 =?utf-8?B?b3hid2VuYWdQaUpjRDhXOWc0bVlvY3hUaHBYakFCUFZNWFlNM1dpRE1GY0gw?=
 =?utf-8?B?NU8wK0dSTk9YSnUzblNHUEpDSVEzM2ppcWJ6a2pKbHBmWURUeFlEM2NLa0lm?=
 =?utf-8?B?N0M2ei84VFYzZnFhMUI0RGhISThtVlpaVFExeVlaeXNtRjJ5TFhzZngzcjJl?=
 =?utf-8?B?UlViMFFVeURGcThEb21uTUd4Z2N3YWtDZVc3V3pRd3BqTEFDMTd6S255Smlz?=
 =?utf-8?B?OUtBWDUzd3E3RHZUR2ZMS21MWmJKcVhvajF1SHN5YjJBMTltWSs2RHMzbzEz?=
 =?utf-8?B?NUtRNnpBVURyY2s3WmFvRzhBZnV6VzB0cW5IN2JZVHFPbnNlczkyOWEzM3Mx?=
 =?utf-8?B?Sm44VFlxcHZONEdUNXo3UGNCYnJmYUxhUlJodmVveDdXR2JjZVZOdnNjdWp3?=
 =?utf-8?B?K09zOUxVTkpUSDNCaEdiZ1VQVmc5WThGVUFiUnlFMGlDenVqTkFHLzJmbDM2?=
 =?utf-8?B?RW5JbEdrM0htT3IwTWZmRlRydEQzb0t4Znh4ZzF2TkljYnBkbElTdmtJNFZS?=
 =?utf-8?B?Q3BzWmxxUHBXRmRucFRqdUZ2RXdnYmxSUXdqWDlDUWhTdmZDeVNWaEl0U0JX?=
 =?utf-8?B?bXdCNFF1ZzVsanBjNUJhSmtYVURyY01PRFlJaWFoYVVzMFVLdkJWYkFYb1Np?=
 =?utf-8?B?ZzdRdVVMYWJtMExTbWR6UXMvWVJFOTY1YVZST21sbXU3SjVLTHVaY1gzTHRE?=
 =?utf-8?B?aDVKUUQyd2pndzdIYjBmV1V3L0RucUUwcWVZMW5wYUp6QmV0SDM3dUtSZnlt?=
 =?utf-8?B?TzBpbVdvM3U3dDNOR2QrVkMwU2FwcTZDUG91VHpkR0VtWW4zRUdzZUNSRm14?=
 =?utf-8?B?cUo3Y2p0dDdRZk1aWTBtNEo5Y3JyRUVzWTQ5WTB3ZmtFeU1sYjk4SGtoZ3kz?=
 =?utf-8?B?bHZkeVZ0cllYKythNFFCWWVoMW50cHZnQnRzRFoya0NjRUhuZEZhdk1TU1hK?=
 =?utf-8?B?eUNqT0RGWmhza3E4L0puOE1SZGdBdnRCVzNvRnNRZlNiT0sxS0s1elQ0eEE4?=
 =?utf-8?B?MmZPWE5NTlNNTzRPbXNCRWJUcGdRelZZZWs0T01KTGVQR1JhME9lOUt6c212?=
 =?utf-8?B?M3p6WUVyZUNBN1k4M3JVSFQwV3BHL2htcGxQcERWUmNCOWZ6aDBKR1VTTy9R?=
 =?utf-8?B?OTBRYjVTUzRyQlhDZHVhWE1sMGtTelFEbW5oOXFnQ0ozZktqa1cwR2JNeFF5?=
 =?utf-8?B?THNXMFgyb2VxTEFGTGYyNXdZUEJkT2hRdE9LTlpKakdxRnF4dm9jVmpkV3Yw?=
 =?utf-8?B?R3NNTVRlbnNISHNEckFSdGhKYmI3eEZzMy9xT2NoV0hFWTFaeENWSzZ0aDJH?=
 =?utf-8?B?M2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <15A60B949E47E540824B6B1353302F6B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9161a43-0710-486e-d699-08daf367b9be
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2023 00:06:44.9194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yF7UeFrRbcUD7LDTMfYytS2V5XomMUT7Aq+cH346Nc1kaN0Ud3ha3myFcqB/CO29HC+BkjaPWwp7DMdf3Tk/7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5089
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

T24gVHVlLCAyMDIzLTAxLTEwIGF0IDA4OjUzIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMS8xMC8yMyAwMjoxNSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBGcmksIDIwMjMtMDEt
MDYgYXQgMTQ6NDkgLTA4MDAsIERhdmUgSGFuc2VuIHdyb3RlOg0KPiA+ID4gT24gMTIvOC8yMiAy
Mjo1MiwgS2FpIEh1YW5nIHdyb3RlOg0KPiAuLi4NCj4gPiA+ID4gKyAqIE5vdGU6DQo+ID4gPiA+
ICsgKg0KPiA+ID4gPiArICogVGhpcyBmdW5jdGlvbiBuZWl0aGVyIGNoZWNrcyB3aGV0aGVyIHRo
ZXJlJ3MgYXQgbGVhc3Qgb25lIG9ubGluZSBjcHUNCj4gPiA+ID4gKyAqIGZvciBlYWNoIHBhY2th
Z2UsIG5vciBleHBsaWNpdGx5IHByZXZlbnRzIGFueSBjcHUgZnJvbSBnb2luZyBvZmZsaW5lLg0K
PiA+ID4gPiArICogSWYgYW55IHBhY2thZ2UgZG9lc24ndCBoYXZlIGFueSBvbmxpbmUgY3B1IHRo
ZW4gdGhlIFNFQU1DQUxMIHdvbid0IGJlDQo+ID4gPiA+ICsgKiBkb25lIG9uIHRoYXQgcGFja2Fn
ZSBhbmQgdGhlIGxhdGVyIHN0ZXAgb2YgVERYIG1vZHVsZSBpbml0aWFsaXphdGlvbg0KPiA+ID4g
PiArICogd2lsbCBmYWlsLiAgVGhlIGNhbGxlciBuZWVkcyB0byBndWFyYW50ZWUgdGhpcy4NCj4g
PiA+ID4gKyAqLw0KPiA+ID4gDQo+ID4gPiAqRG9lcyogdGhlIGNhbGxlciBndWFyYW50ZWUgaXQ/
DQo+ID4gPiANCj4gPiA+IFlvdSdyZSBiYXNpY2FsbHkgc2F5aW5nLCAidGhpcyBjb2RlIG5lZWRz
ICRGT08gdG8gd29yayIsIGJ1dCB5b3UncmUgbm90DQo+ID4gPiBzYXlpbmcgd2hvICpwcm92aWRl
cyogJEZPTy4NCj4gPiANCj4gPiBJbiBzaG9ydCwgS1ZNIGNhbiBkbyBzb21ldGhpbmcgdG8gZ3Vh
cmFudGVlIGJ1dCB3b24ndCAxMDAlIGd1YXJhbnRlZSB0aGlzLg0KPiA+IA0KPiA+IFNwZWNpZmlj
YWxseSwgS1ZNIHdvbid0IGFjdGl2ZWx5IHRyeSB0byBicmluZyB1cCBjcHUgdG8gZ3VhcmFudGVl
IHRoaXMgaWYNCj4gPiB0aGVyZSdzIGFueSBwYWNrYWdlIGhhcyBubyBvbmxpbmUgY3B1IGF0IGFs
bCAoc2VlIHRoZSBmaXJzdCBsb3JlIGxpbmsgYmVsb3cpLg0KPiA+IEJ1dCBLVk0gY2FuIF9jaGVj
a18gd2hldGhlciB0aGlzIGNvbmRpdGlvbiBoYXMgYmVlbiBtZXQgYmVmb3JlIGNhbGxpbmcNCj4g
PiB0ZHhfaW5pdCgpIGFuZCBzcGVhayBvdXQgaWYgbm90LiAgQXQgdGhlIG1lYW50aW1lLCBpZiB0
aGUgY29uZGl0aW9uIGlzIG1ldCwNCj4gPiByZWZ1c2UgdG8gb2ZmbGluZSB0aGUgbGFzdCBjcHUg
Zm9yIGVhY2ggcGFja2FnZSAob3IgYW55IGNwdSkgZHVyaW5nIG1vZHVsZQ0KPiA+IGluaXRpYWxp
emF0aW9uLg0KPiA+IA0KPiA+IEFuZCBLVk0gbmVlZHMgc2ltaWxhciBoYW5kbGluZyBhbnl3YXku
ICBUaGUgcmVhc29uIGlzIG5vdCBvbmx5IGNvbmZpZ3VyaW5nIHRoZQ0KPiA+IGdsb2JhbCBLZXlJ
RCBoYXMgc3VjaCByZXF1aXJlbWVudCwgY3JlYXRpbmcvZGVzdHJveWluZyBURCAod2hpY2ggaW52
b2x2ZXMNCj4gPiBwcm9ncmFtbWluZy9yZWNsYWltaW5nIG9uZSBURFggS2V5SUQpIGFsc28gcmVx
dWlyZSBhdCBsZWFzdCBvbmUgb25saW5lIGNwdSBmb3INCj4gPiBlYWNoIHBhY2thZ2UuDQo+ID4g
DQo+ID4gVGhlcmUgd2VyZSBkaXNjdXNzaW9ucyBhcm91bmQgdGhpcyBvbiBLVk0gaG93IHRvIGhh
bmRsZS4gIElJVUMgdGhlIHNvbHV0aW9uIGlzDQo+ID4gS1ZNIHdpbGw6DQo+ID4gMSkgZmFpbCB0
byBjcmVhdGUgVEQgaWYgYW55IHBhY2thZ2UgaGFzIG5vIG9ubGluZSBjcHUuDQo+ID4gMikgcmVm
dXNlIHRvIG9mZmxpbmUgdGhlIGxhc3QgY3B1IGZvciBlYWNoIHBhY2thZ2Ugd2hlbiB0aGVyZSdz
IGFueSBfYWN0aXZlXyBURFgNCj4gPiBndWVzdCBydW5uaW5nLg0KPiA+IA0KPiA+IGh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyMjExMDIyMzE5MTEuMzEwNzQzOC0xLXNlYW5qY0Bnb29n
bGUuY29tL1QvI20xZmYzMzg2ODZjZmNiN2JhNjkxY2Q5NjlhY2MxN2IzMmZmMTk0MDczDQo+ID4g
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC9kZTZiNjk3ODFhNmJhMWZlNjU1MzVmNDhkYjI2
NzdlZWYzZWM2YTgzLjE2NjcxMTAyNDAuZ2l0LmlzYWt1LnlhbWFoYXRhQGludGVsLmNvbS8NCj4g
PiANCj4gPiBUaHVzIFREWCBtb2R1bGUgaW5pdGlhbGl6YXRpb24gaW4gS1ZNIGNhbiBiZSBoYW5k
bGVkIGluIHNpbWlsYXIgd2F5Lg0KPiA+IA0KPiA+IEJ0dywgaW4gdjcgKHdoaWNoIGhhcyBwZXIt
bHAgaW5pdCByZXF1aXJlbWVudCBvbiBhbGwgY3B1cyksIHRkeF9pbml0KCkgZG9lcw0KPiA+IGVh
cmx5IGNoZWNrIG9uIHdoZXRoZXIgYWxsIG1hY2hpbmUgYm9vdC10aW1lIHByZXNlbnQgY3B1IGFy
ZSBvbmxpbmUgYW5kIHNpbXBseQ0KPiA+IHJldHVybnMgZXJyb3IgaWYgY29uZGl0aW9uIGlzIG5v
dCBtZXQuICBIZXJlIHRoZSBkaWZmZXJlbmNlIGlzIHdlIGRvbid0IGhhdmUgYW55DQo+ID4gY2hl
Y2sgYnV0IGRlcGVuZCBvbiBTRUFNQ0FMTCB0byBmYWlsLiAgVG8gbWUgdGhlcmUncyBubyBmdW5k
YW1lbnRhbCBkaWZmZXJlbmNlLg0KPiANCj4gU28sIEknbSBnb2luZyB0byBjYWxsIHNoZW5hbmln
YW5zIGhlcmUuDQo+IA0KPiBZb3Ugc2F5Og0KPiANCj4gCVRoZSBjYWxsZXIgbmVlZHMgdG8gZ3Vh
cmFudGVlIHRoaXMuDQo+IA0KPiBUaGVuLCB5b3UgZ28gYW5kIHRlbGwgdXMgaG93IHRoZSAqT05F
KiBjYWxsZXIgb2YgdGhpcyBmdW5jdGlvbiBkb2Vzbid0DQo+IGFjdHVhbGx5IGd1YXJhbnRlZSB0
aGlzLiAgUGx1cywgeW91ICpLTk9XKiB0aGlzLg0KPiANCj4gVGhvc2UgYXJlIHNoZW5hbmlnYW5z
Lg0KDQpBZ3JlZWQuDQoNCj4gDQo+IExldCdzIGRvIHNvbWV0aGluZyBsaWtlIHRoaXMgaW5zdGVh
ZCBvZiBhc2tpbmcgZm9yIHNvbWV0aGluZyBpbXBvc3NpYmxlDQo+IGFuZCBwcmV0ZW5kaW5nIHRo
YXQgdGhlIGNhbGxlcnMgYXJlIGdvaW5nIHRvIHByb3ZpZGUgc29tZSBmYW50YXN5IHNvbHV0aW9u
Lg0KPiANCj4gLyoNCj4gICogQXR0ZW1wdCB0byBjb25maWd1cmUgdGhlIGdsb2JhbCBLZXlJRCBv
biBhbGwgcGh5c2ljYWwgcGFja2FnZXMuDQo+ICAqDQo+ICAqIFRoaXMgcmVxdWlyZXMgcnVubmlu
ZyBjb2RlIG9uIGF0IGxlYXN0IG9uZSBDUFUgaW4gZWFjaCBwYWNrYWdlLiAgSWYgYQ0KPiAgKiBw
YWNrYWdlIGhhcyBubyBvbmxpbmUgQ1BVcywgdGhhdCBjb2RlIHdpbGwgbm90IHJ1biBhbmQgVERY
IG1vZHVsZQ0KPiAgKiBpbml0aWFsaXphdGlvbiAoVERILndoYXRldmVyKSB3aWxsIGZhaWwuDQo+
ICAqDQo+ICAqIFRoaXMgY29kZSB0YWtlcyBubyBhZmZpcm1hdGl2ZSBzdGVwcyB0byBvbmxpbmUg
Q1BVcy4gIENhbGxlcnMgKGFrYS4NCj4gICogS1ZNKSBjYW4gZW5zdXJlIHN1Y2Nlc3MgYnkgZW5z
dXJpbmcgc3VmZmljaWVudCBDUFVzIGFyZSBvbmxpbmUgZm9yDQo+ICAqIHRoaXMgdG8gc3VjY2Vl
ZC4NCj4gICovDQoNClRoYW5rcy4gIFdpbGwgdXBkYXRlIGNoYW5nZWxvZyBhY2NvcmRpbmdseS4N
Cg0KPiANCj4gTm93LCBzaW5jZSB0aGlzIF9pc18gYWxsIGltcGVyZmVjdCwgd2hhdCB3aWxsIG91
ciB1c2VycyBzZWUgaWYgdGhpcw0KPiBob3VzZSBvZiBjYXJkcyBmYWxscyBkb3duPyAgV2lsbCB0
aGV5IGdldCBhIG5pY2UgZXJyb3IgbWVzc2FnZSBsaWtlOg0KPiANCj4gICAgICBURFg6IGZhaWxl
ZCB0byBjb25maWd1cmUgbW9kdWxlLCBubyBvbmxpbmUgQ1BVcyBpbiBwYWNrYWdlIDEyDQo+IA0K
PiBPciwgd2lsbCB0aGV5IHNlZToNCj4gDQo+ICAgICAgVERYOiBIdXJyLCBkdXJyLCBJJ20gY29u
ZnVzZWQgYW5kIHlvdSBzaG91bGQgYmUgdG9vDQo+IA0KPiA/DQoNCkkgYW0gZXhwZWN0aW5nIHRo
ZSBmb3JtZXIuICBJIHdpbGwgd29yayB3aXRoIElzYWt1IHRvIG1ha2Ugc3VyZSBvZiBpdC4NCg==
