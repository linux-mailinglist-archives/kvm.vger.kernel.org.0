Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1466107E4
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 04:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236065AbiJ1CVz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 22:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235476AbiJ1CVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 22:21:54 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7AA5AA0D;
        Thu, 27 Oct 2022 19:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666923713; x=1698459713;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WFE6Mz2OutfHW6prjAikDiPZ0y8p/1LX2UQxgyOYZxY=;
  b=mSMHhdn4RnmgPXVPnGRthlA4SfoWYirjBhM9xVdHGmjdky2Dvdku3qQM
   koFddIDqw2+EbrKWe5pIbU/IwsoGoxWf4c7q95JI29CXZXbFMFl/tAihe
   6q+UFj6RmbLZ+M1VR756Li2j7Jy08r6rIfnV5QRsMPWNd/O6q85tE8s+q
   2m0N9ATZYANDt6USxUjsUutUW+ltg8wPFdmBa8xBmFmqi8pS+dzrswIr+
   LBHrFch6nO+sKXbg3OtBv7dZu9ie61bOxeEYVgO9pdKXm3l140aGcSS/F
   BwpzPy+2hc5LHAeAd4zxoQcsOEjxlhGTpYPQBRrOIcE3WGP44GRD9JunA
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="288787178"
X-IronPort-AV: E=Sophos;i="5.95,219,1661842800"; 
   d="scan'208";a="288787178"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 19:21:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="737930253"
X-IronPort-AV: E=Sophos;i="5.95,219,1661842800"; 
   d="scan'208";a="737930253"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 27 Oct 2022 19:21:53 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 19:21:52 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 27 Oct 2022 19:21:52 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 27 Oct 2022 19:21:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQTEEnyx1sxp06YlFrUyy9ufOo3L9/z5+WIb5SGAhDhH/gX2emcS44sWz97tIJwHSPxYBbPQfhztOpbpQCdunNc+x6n/4Mrk8kuK4fs5nQzuDjCXTik4rNMYPh3Mz0WUNLAHe/cpY5CVbVgqhmh8ckMH31frzLYS0hs/6co7ZXZm1eCo2DQ654eKoLKiT+YWcTVshYR5mcvli/F4ZDMFtm8twFy1tkecLDAoCGZBPSWOPap5ktvc5xOrSUBPhZgjNV6SSpREVDABUOhr8XXVk9YIBl5pTKiDFWqrZSkYI9ffZ22qp1j8xouuF63hPGlGMTpPKb8ntwRH3cOK9+ozBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WFE6Mz2OutfHW6prjAikDiPZ0y8p/1LX2UQxgyOYZxY=;
 b=cqxT+gUqDPTMcUCN0H27ORJzGYEw5CTQwOYpaua+j21JNkeOSYAfOZbFDoiQWcl0cRkCGLfTuNz+1PlqqGJGutxSOOYakX1jX1Gk4ifPgd05vq9dbGgkG2nB4YyUVpN9nJUir1HmF4mnrHmYNq4UL1d6VVqkY0TzZlgCvu8qQKdQKnq4QjeYOGn2+do9L8NDw133pHl1iuafWOZOa52QTTlk6JxhJQJZhnzcF5rOmCSBZ+n0nPTc4BcA61tdO6ZeLzTqla+1js6adydXO0D6D2Tu+4fX8WII991oHivUH03jz3nlP8Kz9eDeXFSZ6t/FDKwSrI46N8B8jwnYmhX8jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6306.namprd11.prod.outlook.com (2603:10b6:930:22::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Fri, 28 Oct
 2022 02:21:49 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5746.021; Fri, 28 Oct 2022
 02:21:49 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v6 12/21] x86/virt/tdx: Add placeholder to construct TDMRs
 to cover all TDX memory regions
Thread-Topic: [PATCH v6 12/21] x86/virt/tdx: Add placeholder to construct
 TDMRs to cover all TDX memory regions
Thread-Index: AQHY6Y2jpLGj6H1IZ0qLOAaWltkKyK4iXzmAgAC1uwA=
Date:   Fri, 28 Oct 2022 02:21:49 +0000
Message-ID: <83da61dcafc88c9c89f336d7387ecd9aa2857ab7.camel@intel.com>
References: <cover.1666824663.git.kai.huang@intel.com>
         <fe0e1a1133166ca4008840cd1a5959fa70632f07.1666824663.git.kai.huang@intel.com>
         <f6d0b10a-94be-ff33-9742-058469078380@linux.intel.com>
In-Reply-To: <f6d0b10a-94be-ff33-9742-058469078380@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6306:EE_
x-ms-office365-filtering-correlation-id: b19b4e82-b1fb-4eae-892d-08dab88b2b83
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: py+jASXrOfq8nMTQpb3soSKtcwfoQ8tMI59QS+mZaRE234CVJkinpa8IU0hJRdr05uotRGOmbjBrrfuSYkbvZGbSb7xedOdYEiMnA+2FcSW4t+C1dPIhWpzAzIKv4q2Iz0M/E8HcWiX2D1ByOUYuU9CBoOdXhB3P3bi8iDqJgbffmu0hCk0Rkn/PknLjJJ9S6YgtmEbZRCIWSvjQH5RHmAZcGqoy0UrMeyJ6zClxwGRS39NefRKDRQ7OXhsfRn2yhFW6X4wWPHhGY68EU2/tavPMcJklhqDIcBhF0rFrv4z5XolUMtM6TpibKfoi4s6fiKUDM1t4o7w74tjhxKpPP9d3MTIAvLVVoWfQuA80ssTxjp+IaRIt/2kkQ69BiXxbY16onJpTQt+jUd1dcvPsOQ7ujyW/dRFotEvuhDgm9vxCrwB4zHg2oAhB/gdNmri9MtF01R+e7MM+yatpwq5L7OVe/eqVKtC67582yPtoBU1qlkpjPmsCUjqXmG8olJjDOeeSBTwF4ADzscjf+TSBGgDQo/TFAGHGUHeB5wILujEMsiy2hC7yil293lGQUQ3kTVb4AyBkmcjfPmPCCVdx+j96pNqs3znxi3fZw6W2PJc9yw5IAP0Ad68f9OaKA4q19zvu2GNn20pmfFUWB2tCFNzxsObTY5IlN0kErWvahER4YXCsqWwpIatVjxmPRCllTrv7YSCirz81chETdOD4xb3gjYWB9KlZKLlsz2CUxC6viH9RA8bAd9cqtW+zXzc+eOcC1QZfxHficFt5m9Q2AA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(346002)(39860400002)(366004)(451199015)(82960400001)(36756003)(38100700002)(91956017)(76116006)(66446008)(66946007)(38070700005)(110136005)(66556008)(316002)(54906003)(66476007)(8676002)(64756008)(4326008)(122000001)(7416002)(6486002)(26005)(478600001)(41300700001)(86362001)(6506007)(6512007)(4001150100001)(2616005)(5660300002)(2906002)(186003)(8936002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U3JCc2w4TjBNRWlTTEszSUZ3MkdpS1NCdWlpUlpOMnlXenRaeDdINXJaUTI1?=
 =?utf-8?B?a3pPLytTdWhxd1dIM2VvR1lIWEhrSFJQeE0veEFRd05CbnNQcnlVOUVLOGFz?=
 =?utf-8?B?NXdoSDZKNkxvZjNrb08rek00ZGdEZEZLb01rTEhtSGFNWFZzY0RMZDhTWGVP?=
 =?utf-8?B?Skh1VFAyeGNhbUFiWVNiNys2bGtlTGVwdUwwMnBkK01KTDRSLzhBai9seENs?=
 =?utf-8?B?UklUUTFOVWIwR1NSUGswdjZJZXI1QXJwUHFHMmd3djNJN1ByWHo2RWEvWmlT?=
 =?utf-8?B?cnc0QzdiVko1eE1BSktFRmU1a3grYWdRbDU0MVJML2plUGdRL1BoVnhRTXNI?=
 =?utf-8?B?ZUNmMnljaGZSVnp0ZHA1NXA3L29OV0lhSmNUTnYzdDBwdnJPUkdhbFB2dURU?=
 =?utf-8?B?WWd1VE00emdIUjVUSTNhc0RkL2RPUlZNU0lIS0FIK3VnYytrR0JodE05bGlz?=
 =?utf-8?B?Tnh2MHREMzljYzl1K2FyYlYxenlkaVJjR09XUjhURVF6Y0pCeFFyV3RoQVdN?=
 =?utf-8?B?eDVmQnpxZG1QZWNicENvUnhqWkN0U28zeFkwUldIemt6eFBTUStFSURFbEs0?=
 =?utf-8?B?UCt1NkRHK0l4WG9ZZnFsaE93ZmttMHJRdHBoTXhWeTl0N0VtTHp6VkdPM0N0?=
 =?utf-8?B?dE5xSG9yN1lxZ1c1cmYvb2ZyZjBjVG9YWmt4MDRyR3NPMlFDN3A4bVlqQVpl?=
 =?utf-8?B?WGMvaWtaR0R4NzdHNWFscXZGQ21WS3RnUVZRTXZFeEN5TG1hc2h5YzRuNUlq?=
 =?utf-8?B?VjUrZ2wvT2J5WnJhTnY1MG5PcG5pSGpmaFpWd2RKYWxxbTNHZ1czSjZGdFhy?=
 =?utf-8?B?eVd1ckpma2lTWFpINW5DR0RzOXVkaWxRN0pRSFlLbHI4QSthdnR2WEVORjIw?=
 =?utf-8?B?S1d0Mzhmc0hLdnZYTzBXb0F4bDY4b3A4U29SZi9nMTFrWUFhWmNzZENSTzAy?=
 =?utf-8?B?d2F4YWo4c0U5TkNwaXBYeGllbnd4aEpwVXBNNTRzS1NWTlFERlN4OCtSY0hC?=
 =?utf-8?B?aTc2eFBReld2ZDBEOER5MFZDSnJ5MVcwMTgxNGU3UjdIU0EzL1FQMnF1MTh1?=
 =?utf-8?B?bXJlVW5abm5ONTROVSs3K1VjazhjOGJEdnR0L0pzRHpRNDVFRTdWQUc1QWNJ?=
 =?utf-8?B?b3ZBUEJaK3padW8yV01qV3RqbktTWDdkNUkxTm1WT1VVRElOTE1XYnp6TWVV?=
 =?utf-8?B?ZllJTEVnS1lsa3ltWDVJdnNibUZUaklSeCt4VWhtSkxydHVCM1VLYi9ZcjJv?=
 =?utf-8?B?UlhXc1gwaXJDTUU2Ni95TjY0MVkxc1NtM2RqbW1kM0FhUXVISGVOVzFzcHAy?=
 =?utf-8?B?b1dWODFPczgwSjNoQ0ZLSDdVRU9kb0Q4aFoyalNMWnZybUc2N0FtQ05GMXla?=
 =?utf-8?B?YWlpb3lHN2c5KzI2Mit6R1ZRdjJCODY1dUtoMEh4WFBVSDhrdEVNaWFRb1Zq?=
 =?utf-8?B?R1duZUlRRUVNczFxNkorSGRDRjhBMWdrVWZSS1Y1aFBQamp2WnBLN0I2a0NX?=
 =?utf-8?B?ZVZ0dXNqaHk3cE9wa0VZZk4yaWxCR0RpL21TV1p0R0VhbW9IZ21DVnl2eXY1?=
 =?utf-8?B?YnRqK0lGY2pxQk1CRXU4MmNCSWhyT3UxYmZrZmo2RXNEOC8vamZjQUR0dEJj?=
 =?utf-8?B?YjVYMzZsYVVObjlDZWEzbjJDRytaamFoN3EwYzI2Znd0YTByMkJkK0drM2M3?=
 =?utf-8?B?WGxXc1dmMVU3aW1iTkJtd1VuOGlrNk5UZmgrd1R1VFNhSkVYVnoyRWhkUnFN?=
 =?utf-8?B?RkZkQVBEWEwzMzdteTk0dmRISG5VNU5SQlkxL2tIZytJdTlwTExCempJaGZU?=
 =?utf-8?B?UmhwWUMrOVh3MXdZMUdtS2VjRUMyMjE2NW9LRjUycEdtYXJoVlNvV0lTZGR4?=
 =?utf-8?B?UGxpTUdUeEREUFZJTnE5cjlzekVLVnhXMy9jczgyUEc4dDc5aVJFcTY5VW9n?=
 =?utf-8?B?OWRCZXdpNDhBR2lESHVvaytBTVc0RDduVi95R2U4S1VxSC9DeThzcW1RL3Aw?=
 =?utf-8?B?T2NBZXVkN1BDSWtXcmxONGFwSENLVDdoVEJRTXd2RFNaejE5cXZoQURNdXIw?=
 =?utf-8?B?RFVYTldZRG5CV3RZVC9waXN2SGUxMWluTk02SzQxSmZBQnhXellQQ0JQcFln?=
 =?utf-8?B?WHBJMXVqdXFVeE5uTHFUVGg0WUVMRzJLS0FZR1g3MDFhWFROUnRoTGtBcFQ1?=
 =?utf-8?B?d0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8646A47E4C2D7242B082C90140F7300A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b19b4e82-b1fb-4eae-892d-08dab88b2b83
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 02:21:49.5727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C4ZmCZPZfwYGXwnkSf0sJvvRE8tJlY9FOWdpNA4aT5f/7Du1tbN0NI3+PEzEC3D8ynIZe4Q/FZ7+CglXNFCknQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6306
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIyLTEwLTI3IGF0IDA4OjMxIC0wNzAwLCBBbmRpIEtsZWVuIHdyb3RlOg0KPiA+
ICsvKiBDYWxjdWxhdGUgdGhlIGFjdHVhbCBURE1SX0lORk8gc2l6ZSAqLw0KPiA+ICtzdGF0aWMg
aW5saW5lIGludCBjYWxfdGRtcl9zaXplKHZvaWQpDQo+ID4gK3sNCj4gPiArCWludCB0ZG1yX3N6
Ow0KPiA+ICsNCj4gPiArCS8qDQo+ID4gKwkgKiBUaGUgYWN0dWFsIHNpemUgb2YgVERNUl9JTkZP
IGRlcGVuZHMgb24gdGhlIG1heGltdW0gbnVtYmVyDQo+ID4gKwkgKiBvZiByZXNlcnZlZCBhcmVh
cy4NCj4gPiArCSAqLw0KPiA+ICsJdGRtcl9zeiA9IHNpemVvZihzdHJ1Y3QgdGRtcl9pbmZvKTsN
Cj4gPiArCXRkbXJfc3ogKz0gc2l6ZW9mKHN0cnVjdCB0ZG1yX3Jlc2VydmVkX2FyZWEpICoNCj4g
PiArCQkgICB0ZHhfc3lzaW5mby5tYXhfcmVzZXJ2ZWRfcGVyX3RkbXI7DQo+IA0KPiANCj4gd291
bGQgc2VlbSBzYWZlciB0byBoYXZlIGEgb3ZlcmZsb3cgY2hlY2sgaGVyZS4NCj4gDQo+IA0KDQpI
b3cgYWJvdXQgYmVsb3c/DQoNCi0tLSBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KKysr
IGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQpAQCAtNjE0LDYgKzYxNCwxNCBAQCBzdGF0
aWMgaW5saW5lIGludCBjYWxfdGRtcl9zaXplKHZvaWQpDQogICAgICAgIHRkbXJfc3ogKz0gc2l6
ZW9mKHN0cnVjdCB0ZG1yX3Jlc2VydmVkX2FyZWEpICoNCiAgICAgICAgICAgICAgICAgICB0ZHhf
c3lzaW5mby5tYXhfcmVzZXJ2ZWRfcGVyX3RkbXI7DQogDQorICAgICAgIC8qDQorICAgICAgICAq
IERvIHNpbXBsZSBjaGVjayBhZ2FpbnN0IG92ZXJmbG93LCBhbmQgcmV0dXJuIDAgKGludmFsaWQp
DQorICAgICAgICAqIFRETVJfSU5GTyBzaXplIGlmIGl0IGhhcHBlbmVkLiAgQWxzbyBXQVJOKCkg
YXMgaXQgc2hvdWxkDQorICAgICAgICAqIHNob3VsZCBuZXZlciBoYXBwZW4gaW4gcmVhbGl0eS4N
CisgICAgICAgICovDQorICAgICAgIGlmIChXQVJOX09OX09OQ0UodGRtcl9zeiA8IDApKQ0KKyAg
ICAgICAgICAgICAgIHJldHVybiAwOw0KKw0KICAgICAgICAvKg0KICAgICAgICAgKiBURFggcmVx
dWlyZXMgZWFjaCBURE1SX0lORk8gdG8gYmUgNTEyLWJ5dGUgYWxpZ25lZC4gIEFsd2F5cw0KICAg
ICAgICAgKiByb3VuZCB1cCBURE1SX0lORk8gc2l6ZSB0byB0aGUgNTEyLWJ5dGUgYm91bmRhcnku
DQpAQCAtNjIzLDE5ICs2MzEsMjcgQEAgc3RhdGljIGlubGluZSBpbnQgY2FsX3RkbXJfc2l6ZSh2
b2lkKQ0KIA0KIHN0YXRpYyBzdHJ1Y3QgdGRtcl9pbmZvICphbGxvY190ZG1yX2FycmF5KGludCAq
YXJyYXlfc3opDQogew0KKyAgICAgICBpbnQgc3o7DQorDQogICAgICAgIC8qDQogICAgICAgICAq
IFREWCByZXF1aXJlcyBlYWNoIFRETVJfSU5GTyB0byBiZSA1MTItYnl0ZSBhbGlnbmVkLg0KICAg
ICAgICAgKiBVc2UgYWxsb2NfcGFnZXNfZXhhY3QoKSB0byBhbGxvY2F0ZSBhbGwgVERNUnMgYXQg
b25jZS4NCiAgICAgICAgICogRWFjaCBURE1SX0lORk8gd2lsbCBzdGlsbCBiZSA1MTItYnl0ZSBh
bGlnbmVkIHNpbmNlDQogICAgICAgICAqIGNhbF90ZG1yX3NpemUoKSBhbHdheXMgcmV0dXJuIDUx
Mi1ieXRlIGFsaWduZWQgc2l6ZS4NCiAgICAgICAgICovDQotICAgICAgICphcnJheV9zeiA9IGNh
bF90ZG1yX3NpemUoKSAqIHRkeF9zeXNpbmZvLm1heF90ZG1yczsNCisgICAgICAgc3ogPSBjYWxf
dGRtcl9zaXplKCkgKiB0ZHhfc3lzaW5mby5tYXhfdGRtcnM7DQorDQorICAgICAgIC8qIE92ZXJm
bG93ICovDQorICAgICAgIGlmICghc3ogfHwgV0FSTl9PTl9PTkNFKHN6IDwgMCkpDQorICAgICAg
ICAgICAgICAgcmV0dXJuIE5VTEw7DQorDQorICAgICAgICphcnJheV9zeiA9IHN6Ow0KIA0KICAg
ICAgICAvKg0KICAgICAgICAgKiBaZXJvIHRoZSBidWZmZXIgc28gJ3N0cnVjdCB0ZG1yX2luZm86
OnNpemUnIGNhbiBiZQ0KICAgICAgICAgKiB1c2VkIHRvIGRldGVybWluZSB3aGV0aGVyIGEgVERN
UiBpcyB2YWxpZC4NCiAgICAgICAgICovDQotICAgICAgIHJldHVybiBhbGxvY19wYWdlc19leGFj
dCgqYXJyYXlfc3osIEdGUF9LRVJORUwgfCBfX0dGUF9aRVJPKTsNCisgICAgICAgcmV0dXJuIGFs
bG9jX3BhZ2VzX2V4YWN0KHN6LCBHRlBfS0VSTkVMIHwgX19HRlBfWkVSTyk7DQogfQ0KDQoNCkJ0
dywgc2hvdWxkIEkgdXNlIGFsbG9jX2NvbnRpZ19wYWdlcygpIGluc3RlYWQgb2YgYWxsb2NfcGFn
ZXNfZXhhY3QoKSBhcyBJSVVDDQp0aGUgbGF0dGVyIHNob3VsZCBmYWlsIGlmIHRoZSBzaXplIGlz
IGxhcmdlciB0aGFuIDRNQj8gIEluIHJlYWxpdHksIHRoZSBlbnRpcmUNCmFycmF5IG9ubHkgdGFr
ZXMgZG96ZW5zIG9mIEtCcywgdGhvdWdoLg0K
