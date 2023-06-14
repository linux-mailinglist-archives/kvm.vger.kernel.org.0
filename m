Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88A4B72FF73
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 15:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244842AbjFNNF7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 09:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244265AbjFNNFu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 09:05:50 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4821BC5;
        Wed, 14 Jun 2023 06:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686747949; x=1718283949;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DeqB79IA/KETjpAblwgPmI6fSjdy8gvyXrHWXSAw0vo=;
  b=Zj32EEjgWqHzZWOl6kyTa/2pYgQx06ijQe73riiv5NeaPHBAb3gWu8v6
   67OE9WPbVU0Yqz1/JNoYYd/FL6PWimLuzDbyy89op5WbDvSJOgt4sF/ly
   7DQQhQyaU70cv0WHSRzH1q5sUKvwmTIDcT9dOP+EzBGt8h8Dr/yK2Xr2C
   bjmFHNR8kZdrWZFoAQyFS6X7+uUme7EtwZUVXuj10/vzKhyQTG5YCQy1N
   jOaqND8DFEWgGrekcOoWRjGOCxd1rt+gqGL40fQmqqY155ANxzAzknVuL
   xFb8tk66V0Ykcjk6ZgF3QLvSrCQCmRymTrAekWBU79dBhA+rRcx+/G8Eo
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="444974140"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="444974140"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 06:05:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="801893721"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="801893721"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Jun 2023 06:05:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 06:05:48 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 06:05:48 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 06:05:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZwkwWnt/L9XNe9fvIv3IJBunEKPFCqU0viL6nYnGTyQafgz6SV5jlfBs4xt0X9f1TEci+3y2tHN5IMof9ZkllrRGKhc4tXvaYp/AFAf2Wgdg718SBQmR8g6tEtrm76Plq8cI9cjkPE8A1n3EYwtcQC/U0VEQMEZso0rztp1UthDoMMqm9zcy+BB9Q80g+92/7qgd86TCerl8RwSdr8fP3ZddS8nPsmyV26B8VfwwY4hrlSkZ55K9uybXFkW+qPI3wu1/995FR4ZYVykkDU2tP7COyOZTy1oV4XDZpzGpREyDUqxhqEuPJ46jwFtmbjyUoK9uh+FKwA4bWTrikBuojA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DeqB79IA/KETjpAblwgPmI6fSjdy8gvyXrHWXSAw0vo=;
 b=CM8XTtpT0T+hsUexa84OWTlk7maefIsAvBEwDejjH+Die0DcJBlUKd0UZDlR1j1Bqg9HwV4cFyf1n7oS6PoMcNE2Y+3rEjwjetHpKkn/jjkXlW+rPTuX6sg0fl6tnxwejtbM7fmuvg6WshJeX6HaU43kubJywGD+k7CDjTUAoXma63YP0YLPHa7T/cxlOa0es938ybcT/K40+yG3vW4FsSl0EOgz5ViHAF9UvhcgV1MCQsVkwdNZgfqbN1oWbuRXSc9zqrd+6NZWmdcDn0MpsMqqFQl2vQadZx8+N/cREsSh0+gU60SxCCQjNkN16EmuGiD3QcXAYzo36f36NhEtkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CYYPR11MB8357.namprd11.prod.outlook.com (2603:10b6:930:c5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 13:05:45 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 13:05:45 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v7 8/9] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Thread-Topic: [PATCH v7 8/9] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Thread-Index: AQHZlUvxjWjQHBtl702niB2RsWbvNK+JHZUAgAEMNoCAAB/9gIAACruA
Date:   Wed, 14 Jun 2023 13:05:45 +0000
Message-ID: <DS0PR11MB75291989A5508781BB471322C35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121515.79374-1-yi.l.liu@intel.com>
 <20230602121515.79374-9-yi.l.liu@intel.com> <ZIi0Bizk9qr1SgJ/@nvidia.com>
 <DS0PR11MB752932BD50E4F73FD7982DB0C35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZImv2bl1COqA/8c1@nvidia.com>
In-Reply-To: <ZImv2bl1COqA/8c1@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CYYPR11MB8357:EE_
x-ms-office365-filtering-correlation-id: 24ed508c-fc20-42eb-449f-08db6cd810b8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8JFw7BEwhWO5wzRfnopcNup5Xuedi/QKOCE4iFm8//YJ012dOZvOO/nd4nSQ93nGY5bHlfLMRbDUt98zpEnDP0bDOyJjNFRrtmMxV8DpzJWDiZgpdf06UQVwModZH9fbNwgH7DiT2v4YsgL+wjbg2vI/Mhcj18pDUmQA185kAixNc3cgV0gBuPEFzm5zheHC0CKudBlXVoGe+wDzSTZfB60TnYTdHfaWuej+z5p2OsR71kvB+is5xDkkl2JWroYQ4omrrm5avVnLyIf8irS2Uo8EFHegppJHTq5Ro63qUN6byu2Mdfcf7KT8L5GV/dpcfZfn30OQuwkdu7RclMX6oURI1IJizOAxD8siM6lHuSBHbfKSK2qoDK2RgEE1gkoSrR4SXzbMXb+O0+c/3GWk5jgYY91R6UN46MAj2m5qjvQNDdPf7lY7VCIqopobZmGSeTP1tgpVtZxn2OeyeqDonBZuoRQr6OmkhsmMxc/5zEC6aEK9eU2EPv8fBpuDLv7j/OOlBfs1XArseGjWHVplW2zGnYVhrdxNF3eBYmNO2M2x+g34x9aZ67QH8Hz4h57gFGfhBJwckcH0Lny5TOWx/3neUJnps/+POp4LWOtf0EeVcDeNzZVyD9vP2KUEhFJ4Hgr7Ee8QtLIl3faXDeUQ6Eiybl8l+IoWBRqDZgV2h1o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(396003)(366004)(346002)(376002)(451199021)(8936002)(8676002)(2906002)(38100700002)(82960400001)(5660300002)(76116006)(66446008)(66476007)(66556008)(66946007)(33656002)(64756008)(316002)(122000001)(4326008)(6916009)(52536014)(83380400001)(54906003)(41300700001)(478600001)(186003)(9686003)(6506007)(26005)(71200400001)(7416002)(55016003)(7696005)(38070700005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WlYvRytTTFFnM0lWaUtmRitlK1NmL0NMZzlOdVhaakpJRDdpVC9KSmhndTlr?=
 =?utf-8?B?VUZpcHc0NFZTZzRnTVBUREJtdWtFUVB5SCs2dVhyTS9OTTV1OXowSGlKVXph?=
 =?utf-8?B?cHN1b3ZCRWVIQzFyN2ppd0djTVg3VWJRMm1wWkREZ2VTMnowMkdpL2VuOEtT?=
 =?utf-8?B?aFlWTTJXdW40bkdkMDJLZ3ljT1ZYQnJQOTJ4WkQ5TG5RTkFCZXJTM004ZVNZ?=
 =?utf-8?B?QlpuYXVlY1hRR05MM1pEelF0TlFCQ2JQRUlzUDZMbEkvNWw3YWs0Y3ZkQ3ht?=
 =?utf-8?B?c0hteVpOclAxK1FjbDJ4ZUdlWlVhS2QwMCt3ejFTNDRtemJtN1hzWGFHWUhC?=
 =?utf-8?B?M0tTNHZ4NXdjQlEraE9MdEFrTzVoa3RPa1BOOXYycmpxTm1SYkN6R3gyaEpC?=
 =?utf-8?B?MGFNOXc5KzJMZ3NYOWN3THdXdGJFb2tid0VwK1E2QlhobVAvdTE5WDFEYUVY?=
 =?utf-8?B?aW9Ld1BMSFBnMjJKU1BpY2E1UUlJMGxHMjhYWGdtSE9RdVU1b2t0ZnBNMEto?=
 =?utf-8?B?UHdVS3J6cmQyMDVDcWdNVUozRnEydW9UZUYyVE1LdzVLdFI5TWoyZENoWURP?=
 =?utf-8?B?T2ZmemJodFdLaEp2SFBsa3cyaDZPL3RrS2p2cXppSzFwMFFhK0tWZjcyaTBn?=
 =?utf-8?B?YjVZdXp3eW4rcmhjekxuTVBIWlVNR0YyYjB0VWFOcHN5QkwyUlpCUmtQcEY0?=
 =?utf-8?B?M0E0dHBMa2twa1BQVEt4Y1c2Q2FhOVVKYnFYa2Z5QjJ4b2IzSGJZU1J0ejdV?=
 =?utf-8?B?VnpSNm1BV3lmM05zdWNyeTdBOU13WlI2bUZwT3VGT3NveTRMYTYxcG1TRGlG?=
 =?utf-8?B?MkpMajh6ZnNSb0JpYW42b2thd0tIVlY3QlR4YUd5WVV5UmpBYnNYTkswMEtB?=
 =?utf-8?B?TGV0cFV0L1VxbmVCcXBYc2FKMS9rd1VSL0hJaE91bUhkRlRyTjNyR2U0Q1dv?=
 =?utf-8?B?MWgrT21HL1ZEM25OSG5VRzErZjJucDYwamx1dHIyMkZNdS9IOWMzcXRJUmlQ?=
 =?utf-8?B?aGpVUUo2OUkxOUlzQVc4ZmZuS25ibThoMkUvS3lqcUVHazUwb0tvZjBObWVE?=
 =?utf-8?B?emdXd3Q5VlgvbWtwZC9KMWtOUUsrQWpQTFp5UVhVV1lINXZjQkdsRkgyQU5J?=
 =?utf-8?B?ZEl5TWY0RkZnR01manBnWFVjdmMrQU9sSHlCN2kvMnhpODBnYlVNQ0lvZFp1?=
 =?utf-8?B?WHF3TEtYK1FpbHZxNlVuYkFUUWV6ejgrSVdrZTljN21TSngvN1RmdnN6MFpa?=
 =?utf-8?B?cnhHaTZtZlBHczByUTZ5a2g1Ym1WcWZveUtRaFVsRFpyQUFVdElxcDZ6S2VC?=
 =?utf-8?B?NG1lSHlTdjN4eGxxMmRXeXpWaldQRTZxMnBpY3dQRENPamlWVk41VmkwcVFQ?=
 =?utf-8?B?U0tvOEFla2xQRVVBQVBtdWRia2xULy9rZXlqS21aOGl2cURyVHI1TWczdVBB?=
 =?utf-8?B?Myt2d3Z4Z0Nqa1h4dWRUNW80WjNQeEtwYm5hdTlZZFRTblNrVU9hZVk5djR0?=
 =?utf-8?B?OVN0SWF6NHZtNVJpSHBYN1ppKzdRRnZjQ1owbHhmOEZYZkQ3L3ZrWEg1bzcv?=
 =?utf-8?B?WXM1azlnODR5cFJUV2tJdkd6QWpFeHFwQ3JoWndKblZHMHdUTWEwcGQzbmJN?=
 =?utf-8?B?TDhWL3N2djV2bllQYkVUUGVEWHJ4UWhobE00dWdRaGlJa2JDNkI2TjF4b3h1?=
 =?utf-8?B?WGU2bFZXa2doYnVCbU1FcUs4RUc3Vlc0SnNBRzRaNnI1VVA4YUMzVWdINkJu?=
 =?utf-8?B?a1BjdEZOUW1CK0pLVG5BRnU3R1VqV1pRWXF6YUs5ME1wVUpnbDJxRG9Oa0FZ?=
 =?utf-8?B?eTg3djFYQ0lSNmdZTGk0T3h4YnVXOUhwTlp0S216UWNNaTdnVStKSmRjZ050?=
 =?utf-8?B?QWtSNzFmTjlkNGNYTE0xUnpacFhZbzFEK05OM3RDZmhUd0krTXdiQm5WWEQr?=
 =?utf-8?B?NEVEVFhWUUlnNWRpOS9uSFNvdWp3R0M2YXV3cU9ESEVmVmdraEx4KzNYUGxo?=
 =?utf-8?B?U1lpSTJkRG5xWERrOFBabWxHc1V1ZWF5Wk5ZRWVDd0pLTVo3THhsL0NFWmc0?=
 =?utf-8?B?UlRXeFN0eXFRdnN5OThtM1cvczZ1ZVp1TE9NKytGOVphRG1yc0FSMk9YK2Fr?=
 =?utf-8?Q?bLBGqugmAtifkLXe7ab1DK5jA?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24ed508c-fc20-42eb-449f-08db6cd810b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 13:05:45.2070
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bjjvpQlXzjI8s7L8+kzIT39W1HbnKflpvS0Jj3aa3M/5aQKIqEPHIffwxMIGQ5fI7vlF3GTNlyWI9Dd/bs2XkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8357
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

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBXZWRuZXNk
YXksIEp1bmUgMTQsIDIwMjMgODoxNyBQTQ0KPiANCj4gT24gV2VkLCBKdW4gMTQsIDIwMjMgYXQg
MTA6MzU6MTBBTSArMDAwMCwgTGl1LCBZaSBMIHdyb3RlOg0KPiANCj4gPiA+IC0JaWYgKGZpbGwt
PmN1ciA9PSBmaWxsLT5tYXgpDQo+ID4gPiAtCQlyZXR1cm4gLUVBR0FJTjsgLyogU29tZXRoaW5n
IGNoYW5nZWQsIHRyeSBhZ2FpbiAqLw0KPiA+ID4gKwlpZiAoZmlsbC0+ZGV2aWNlc19lbmQgPj0g
ZmlsbC0+ZGV2aWNlcykNCj4gPiA+ICsJCXJldHVybiAtRU5PU1BDOw0KPiA+DQo+ID4gVGhpcyBz
aG91bGQgYmUgZmlsbC0+ZGV2aWNlc19lbmQgPD0gZmlsbC0+ZGV2aWNlcy4NCj4gDQo+IFllcA0K
PiANCj4gPiBFdmVuIGl0J3MgY29ycmVjdGVkLiBUaGUNCj4gPiBuZXcgY29kZSBkb2VzIG5vdCBy
ZXR1cm4gLUVBR0FJTi4NCj4gDQo+IFJpZ2h0LCB0aGVyZSBpcyBubyBFQUdBSU4uIElmIHRoZSBj
YWxsZXIgZGlkbid0IHByb3ZpZGUgZW5vdWdoIHNwYWNlDQo+IHRoZSBwcmV2aW91cyB2ZXJzaW9u
IHJldHVybmVkIEVOT1NQQzoNCj4gDQo+ID4gPiAtCWlmIChoZHIuYXJnc3ogPCBzaXplb2YoaGRy
KSArIChmaWxsLm1heCAqIHNpemVvZigqZGV2aWNlcykpKSB7DQo+ID4gPiAtCQlyZXQgPSAtRU5P
U1BDOw0KPiA+ID4gLQkJaGRyLmNvdW50ID0gZmlsbC5tYXg7DQo+ID4gPiAtCQlnb3RvIHJlc2V0
X2luZm9fZXhpdDsNCj4gPiA+IC0JfQ0KPiANCj4gLUVBR0FJTiBiYXNpY2FsbHkgbWVhbnMgdGhl
IGtlcm5lbCBpbnRlcm5hbGx5IG1hbGZ1bmN0aW9uZWQgLSBlZyBpdA0KPiBhbGxvY2F0ZWQgdG9v
IGxpdHRsZSBzcGFjZSBmb3IgdGhlIGFjdHVhbCBzaXplIG9mIGRldmljZXMuIFRoYXQgaXMgbm8N
Cj4gbG9uZ2VyIHBvc3NpYmxlIGluIHRoaXMgdmVyc2lvbiBzbyBpdCBzaG91bGQgbmV2ZXIgcmV0
dXJuIC1FQUdBSU4uDQoNCkkgc3RpbGwgaGF2ZSBvbmUgZG91YnQuIFBlciBteSB1bmRlcnN0YW5k
aW5nLCB0aGlzIGlzIHRvIGhhbmRsZSBuZXdseQ0KcGx1Z2dlZCBkZXZpY2VzIGR1cmluZyB0aGUg
aW5mbyByZXBvcnRpbmcgcGF0aC4gSSBkb27igJl0IHRoaW5rIGhvbGRpbmcNCmRldl9zZXQgbG9j
ayBjYW4gcHJldmVudCBpdC4gYnV0IG1heWJlIC1FTk9TUEMgaXMgZW5vdWdoLiBAQWxleCwNCndo
YXQgYWJvdXQgeW91ciBvcGluaW9uPw0KDQo+ID4gQW5kIGlmIHJldHVybiAtRU5PU1BDLCB0aGUg
ZXhwZWN0ZWQNCj4gPiBzaXplIHNob3VsZCBiZSByZXR1cm5lZC4gQnV0IEkgZGlkbid0IHNlZSBp
dC4gQXMgdGhlIGh1bmsgYmVsb3dbMV0gaXMgcmVtb3ZlZCwNCj4gPiBzZWVtcyBubyB3YXkgdG8g
a25vdyBob3cgbWFueSBtZW1vcnkgaXQgcmVxdWlyZXMuDQo+IA0KPiBZZXMsIEkgbWlzc2VkIHRo
YXQsIGl0IHNob3VsZCBrZWVwIGNvdW50aW5nDQo+IA0KPiBMaWtlIHRoaXMgdGhlbg0KPiANCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmZpby9wY2kvdmZpb19wY2lfY29yZS5jIGIvZHJpdmVycy92
ZmlvL3BjaS92ZmlvX3BjaV9jb3JlLmMNCj4gaW5kZXggYjBlYWRhZmNiY2Y1MDIuLjA1YzA2NDg5
NmE3YTk0IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpX2NvcmUuYw0K
PiArKysgYi9kcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpX2NvcmUuYw0KPiBAQCAtNzc1LDE5ICs3
NzUsMjUgQEAgc3RhdGljIGludCB2ZmlvX3BjaV9jb3VudF9kZXZzKHN0cnVjdCBwY2lfZGV2ICpw
ZGV2LCB2b2lkDQo+ICpkYXRhKQ0KPiAgfQ0KPiANCj4gIHN0cnVjdCB2ZmlvX3BjaV9maWxsX2lu
Zm8gew0KPiAtCWludCBtYXg7DQo+IC0JaW50IGN1cjsNCj4gLQlzdHJ1Y3QgdmZpb19wY2lfZGVw
ZW5kZW50X2RldmljZSAqZGV2aWNlczsNCj4gKwlzdHJ1Y3QgdmZpb19wY2lfZGVwZW5kZW50X2Rl
dmljZSBfX3VzZXIgKmRldmljZXM7DQo+ICsJc3RydWN0IHZmaW9fcGNpX2RlcGVuZGVudF9kZXZp
Y2UgX191c2VyICpkZXZpY2VzX2VuZDsNCj4gIAlzdHJ1Y3QgdmZpb19kZXZpY2UgKnZkZXY7DQo+
ICsJdTMyIGNvdW50Ow0KPiAgCXUzMiBmbGFnczsNCj4gIH07DQo+IA0KPiAgc3RhdGljIGludCB2
ZmlvX3BjaV9maWxsX2RldnMoc3RydWN0IHBjaV9kZXYgKnBkZXYsIHZvaWQgKmRhdGEpDQo+ICB7
DQo+ICsJc3RydWN0IHZmaW9fcGNpX2RlcGVuZGVudF9kZXZpY2UgaW5mbyA9IHsNCj4gKwkJLnNl
Z21lbnQgPSBwY2lfZG9tYWluX25yKHBkZXYtPmJ1cyksDQo+ICsJCS5idXMgPSBwZGV2LT5idXMt
Pm51bWJlciwNCj4gKwkJLmRldmZuID0gcGRldi0+ZGV2Zm4sDQo+ICsJfTsNCj4gIAlzdHJ1Y3Qg
dmZpb19wY2lfZmlsbF9pbmZvICpmaWxsID0gZGF0YTsNCj4gDQo+IC0JaWYgKGZpbGwtPmN1ciA9
PSBmaWxsLT5tYXgpDQo+IC0JCXJldHVybiAtRUFHQUlOOyAvKiBTb21ldGhpbmcgY2hhbmdlZCwg
dHJ5IGFnYWluICovDQo+ICsJZmlsbC5jb3VudCsrOw0KPiArCWlmIChmaWxsLT5kZXZpY2VzID49
IGZpbGwtPmRldmljZXNfZW5kKQ0KPiArCQlyZXR1cm4gMDsNCj4gDQo+ICAJaWYgKGZpbGwtPmZs
YWdzICYgVkZJT19QQ0lfSE9UX1JFU0VUX0ZMQUdfREVWX0lEKSB7DQo+ICAJCXN0cnVjdCBpb21t
dWZkX2N0eCAqaW9tbXVmZCA9IHZmaW9faW9tbXVmZF9kZXZpY2VfaWN0eChmaWxsLT52ZGV2KTsN
Cj4gQEAgLTgwMCwxMiArODA2LDEyIEBAIHN0YXRpYyBpbnQgdmZpb19wY2lfZmlsbF9kZXZzKHN0
cnVjdCBwY2lfZGV2ICpwZGV2LCB2b2lkICpkYXRhKQ0KPiAgCQkgKi8NCj4gIAkJdmRldiA9IHZm
aW9fZmluZF9kZXZpY2VfaW5fZGV2c2V0KGRldl9zZXQsICZwZGV2LT5kZXYpOw0KPiAgCQlpZiAo
IXZkZXYpDQo+IC0JCQlmaWxsLT5kZXZpY2VzW2ZpbGwtPmN1cl0uZGV2aWQgPSBWRklPX1BDSV9E
RVZJRF9OT1RfT1dORUQ7DQo+ICsJCQlpbmZvLmRldmlkID0gVkZJT19QQ0lfREVWSURfTk9UX09X
TkVEOw0KPiAgCQllbHNlDQo+IC0JCQlmaWxsLT5kZXZpY2VzW2ZpbGwtPmN1cl0uZGV2aWQgPQ0K
PiAtCQkJCXZmaW9faW9tbXVmZF9kZXZpY2VfaG90X3Jlc2V0X2RldmlkKHZkZXYsIGlvbW11ZmQp
Ow0KPiArCQkJaW5mby5kZXZpZCA9IHZmaW9faW9tbXVmZF9kZXZpY2VfaG90X3Jlc2V0X2Rldmlk
KA0KPiArCQkJCXZkZXYsIGlvbW11ZmQpOw0KPiAgCQkvKiBJZiBkZXZpZCBpcyBWRklPX1BDSV9E
RVZJRF9OT1RfT1dORUQsIGNsZWFyIG93bmVkIGZsYWcuICovDQo+IC0JCWlmIChmaWxsLT5kZXZp
Y2VzW2ZpbGwtPmN1cl0uZGV2aWQgPT0gVkZJT19QQ0lfREVWSURfTk9UX09XTkVEKQ0KPiArCQlp
ZiAoaW5mby5kZXZpZCA9PSBWRklPX1BDSV9ERVZJRF9OT1RfT1dORUQpDQo+ICAJCQlmaWxsLT5m
bGFncyAmPSB+VkZJT19QQ0lfSE9UX1JFU0VUX0ZMQUdfREVWX0lEX09XTkVEOw0KPiAgCX0gZWxz
ZSB7DQo+ICAJCXN0cnVjdCBpb21tdV9ncm91cCAqaW9tbXVfZ3JvdXA7DQo+IEBAIC04MTQsMTMg
KzgyMCwxMyBAQCBzdGF0aWMgaW50IHZmaW9fcGNpX2ZpbGxfZGV2cyhzdHJ1Y3QgcGNpX2RldiAq
cGRldiwgdm9pZCAqZGF0YSkNCj4gIAkJaWYgKCFpb21tdV9ncm91cCkNCj4gIAkJCXJldHVybiAt
RVBFUk07IC8qIENhbm5vdCByZXNldCBub24taXNvbGF0ZWQgZGV2aWNlcyAqLw0KPiANCj4gLQkJ
ZmlsbC0+ZGV2aWNlc1tmaWxsLT5jdXJdLmdyb3VwX2lkID0gaW9tbXVfZ3JvdXBfaWQoaW9tbXVf
Z3JvdXApOw0KPiArCQlpbmZvLmdyb3VwX2lkID0gaW9tbXVfZ3JvdXBfaWQoaW9tbXVfZ3JvdXAp
Ow0KPiAgCQlpb21tdV9ncm91cF9wdXQoaW9tbXVfZ3JvdXApOw0KPiAgCX0NCj4gLQlmaWxsLT5k
ZXZpY2VzW2ZpbGwtPmN1cl0uc2VnbWVudCA9IHBjaV9kb21haW5fbnIocGRldi0+YnVzKTsNCj4g
LQlmaWxsLT5kZXZpY2VzW2ZpbGwtPmN1cl0uYnVzID0gcGRldi0+YnVzLT5udW1iZXI7DQo+IC0J
ZmlsbC0+ZGV2aWNlc1tmaWxsLT5jdXJdLmRldmZuID0gcGRldi0+ZGV2Zm47DQo+IC0JZmlsbC0+
Y3VyKys7DQo+ICsNCj4gKwlpZiAoY29weV90b191c2VyKGZpbGwtPmRldmljZXMsICZpbmZvLCBz
aXplb2YoaW5mbykpKQ0KPiArCQlyZXR1cm4gLUVGQVVMVDsNCj4gKwlmaWxsLT5kZXZpY2VzKys7
DQo+ICAJcmV0dXJuIDA7DQo+ICB9DQo+IA0KPiBAQCAtMTIxMiw4ICsxMjE4LDcgQEAgc3RhdGlj
IGludCB2ZmlvX3BjaV9pb2N0bF9nZXRfcGNpX2hvdF9yZXNldF9pbmZvKA0KPiAgCXVuc2lnbmVk
IGxvbmcgbWluc3ogPQ0KPiAgCQlvZmZzZXRvZmVuZChzdHJ1Y3QgdmZpb19wY2lfaG90X3Jlc2V0
X2luZm8sIGNvdW50KTsNCj4gIAlzdHJ1Y3QgdmZpb19wY2lfaG90X3Jlc2V0X2luZm8gaGRyOw0K
PiAtCXN0cnVjdCB2ZmlvX3BjaV9maWxsX2luZm8gZmlsbCA9IHsgMCB9Ow0KPiAtCXN0cnVjdCB2
ZmlvX3BjaV9kZXBlbmRlbnRfZGV2aWNlICpkZXZpY2VzID0gTlVMTDsNCj4gKwlzdHJ1Y3QgdmZp
b19wY2lfZmlsbF9pbmZvIGZpbGwgPSB7fTsNCj4gIAlib29sIHNsb3QgPSBmYWxzZTsNCj4gIAlp
bnQgcmV0ID0gMDsNCj4gDQo+IEBAIC0xMjMxLDI5ICsxMjM2LDkgQEAgc3RhdGljIGludCB2Zmlv
X3BjaV9pb2N0bF9nZXRfcGNpX2hvdF9yZXNldF9pbmZvKA0KPiAgCWVsc2UgaWYgKHBjaV9wcm9i
ZV9yZXNldF9idXModmRldi0+cGRldi0+YnVzKSkNCj4gIAkJcmV0dXJuIC1FTk9ERVY7DQo+IA0K
PiAtCS8qIEhvdyBtYW55IGRldmljZXMgYXJlIGFmZmVjdGVkPyAqLw0KPiAtCXJldCA9IHZmaW9f
cGNpX2Zvcl9lYWNoX3Nsb3Rfb3JfYnVzKHZkZXYtPnBkZXYsIHZmaW9fcGNpX2NvdW50X2RldnMs
DQo+IC0JCQkJCSAgICAmZmlsbC5tYXgsIHNsb3QpOw0KPiAtCWlmIChyZXQpDQo+IC0JCXJldHVy
biByZXQ7DQo+IC0NCj4gLQlXQVJOX09OKCFmaWxsLm1heCk7IC8qIFNob3VsZCBhbHdheXMgYmUg
YXQgbGVhc3Qgb25lICovDQo+IC0NCj4gLQkvKg0KPiAtCSAqIElmIHRoZXJlJ3MgZW5vdWdoIHNw
YWNlLCBmaWxsIGl0IG5vdywgb3RoZXJ3aXNlIHJldHVybiAtRU5PU1BDIGFuZA0KPiAtCSAqIHRo
ZSBudW1iZXIgb2YgZGV2aWNlcyBhZmZlY3RlZC4NCj4gLQkgKi8NCj4gLQlpZiAoaGRyLmFyZ3N6
IDwgc2l6ZW9mKGhkcikgKyAoZmlsbC5tYXggKiBzaXplb2YoKmRldmljZXMpKSkgew0KPiAtCQly
ZXQgPSAtRU5PU1BDOw0KPiAtCQloZHIuY291bnQgPSBmaWxsLm1heDsNCj4gLQkJZ290byByZXNl
dF9pbmZvX2V4aXQ7DQo+IC0JfQ0KPiAtDQo+IC0JZGV2aWNlcyA9IGtjYWxsb2MoZmlsbC5tYXgs
IHNpemVvZigqZGV2aWNlcyksIEdGUF9LRVJORUwpOw0KPiAtCWlmICghZGV2aWNlcykNCj4gLQkJ
cmV0dXJuIC1FTk9NRU07DQo+IC0NCj4gLQlmaWxsLmRldmljZXMgPSBkZXZpY2VzOw0KPiArCWZp
bGwuZGV2aWNlcyA9IGFyZy0+ZGV2aWNlczsNCj4gKwlmaWxsLmRldmljZXNfZW5kID0gYXJnLT5k
ZXZpY2VzICsNCj4gKwkJCSAgIChoZHIuYXJnc3ogLSBzaXplb2YoaGRyKSkgLyBzaXplb2YoYXJn
LT5kZXZpY2VzWzBdKTsNCj4gIAlmaWxsLnZkZXYgPSAmdmRldi0+dmRldjsNCj4gDQo+ICAJaWYg
KHZmaW9fZGV2aWNlX2NkZXZfb3BlbmVkKCZ2ZGV2LT52ZGV2KSkNCj4gQEAgLTEyNjQsMjkgKzEy
NDksMTcgQEAgc3RhdGljIGludCB2ZmlvX3BjaV9pb2N0bF9nZXRfcGNpX2hvdF9yZXNldF9pbmZv
KA0KPiAgCXJldCA9IHZmaW9fcGNpX2Zvcl9lYWNoX3Nsb3Rfb3JfYnVzKHZkZXYtPnBkZXYsIHZm
aW9fcGNpX2ZpbGxfZGV2cywNCj4gIAkJCQkJICAgICZmaWxsLCBzbG90KTsNCj4gIAltdXRleF91
bmxvY2soJnZkZXYtPnZkZXYuZGV2X3NldC0+bG9jayk7DQo+ICsJaWYgKHJldCkNCj4gKwkJcmV0
dXJuIHJldDsNCj4gDQo+IC0JLyoNCj4gLQkgKiBJZiBhIGRldmljZSB3YXMgcmVtb3ZlZCBiZXR3
ZWVuIGNvdW50aW5nIGFuZCBmaWxsaW5nLCB3ZSBtYXkgY29tZSB1cA0KPiAtCSAqIHNob3J0IG9m
IGZpbGwubWF4LiAgSWYgYSBkZXZpY2Ugd2FzIGFkZGVkLCB3ZSdsbCBoYXZlIGEgcmV0dXJuIG9m
DQo+IC0JICogLUVBR0FJTiBhYm92ZS4NCj4gLQkgKi8NCj4gLQlpZiAoIXJldCkgew0KPiAtCQlo
ZHIuY291bnQgPSBmaWxsLmN1cjsNCj4gLQkJaGRyLmZsYWdzID0gZmlsbC5mbGFnczsNCj4gLQl9
DQo+IC0NCj4gLXJlc2V0X2luZm9fZXhpdDoNCj4gKwloZHIuY291bnQgPSBmaWxsLmNvdW50Ow0K
PiArCWhkci5mbGFncyA9IGZpbGwuZmxhZ3M7DQo+ICAJaWYgKGNvcHlfdG9fdXNlcihhcmcsICZo
ZHIsIG1pbnN6KSkNCj4gLQkJcmV0ID0gLUVGQVVMVDsNCj4gKwkJcmV0dXJuIC1FRkFVTFQ7DQo+
IA0KPiAtCWlmICghcmV0KSB7DQo+IC0JCWlmIChjb3B5X3RvX3VzZXIoJmFyZy0+ZGV2aWNlcywg
ZGV2aWNlcywNCj4gLQkJCQkgaGRyLmNvdW50ICogc2l6ZW9mKCpkZXZpY2VzKSkpDQo+IC0JCQly
ZXQgPSAtRUZBVUxUOw0KPiAtCX0NCj4gLQ0KPiAtCWtmcmVlKGRldmljZXMpOw0KPiAtCXJldHVy
biByZXQ7DQo+ICsJaWYgKGZpbGwuY291bnQgIT0gZmlsbC5kZXZpY2VzIC0gYXJnLT5kZXZpY2Vz
KQ0KDQpTaG91bGQgYmUgImlmIChmaWxsLmNvdW50ICE9IChmaWxsLmRldmljZXMgLSBhcmctPmRl
dmljZXMpIC8gc2l6ZW9mKGFyZy0+ZGV2aWNlc1swXSkpIiDwn5iKDQoNClJlZ2FyZHMsDQpZaSBM
aXUNCg0KPiArCQlyZXR1cm4gLUVOT1NQQzsNCj4gKwlyZXR1cm4gMDsNCj4gIH0NCj4gDQo+ICBz
dGF0aWMgaW50DQo=
