Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDFF560F3D
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 04:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbiF3CiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 22:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbiF3Chp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 22:37:45 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C658121825
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 19:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656556663; x=1688092663;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zC0s4O4hP8fuSx2jSo8hS7bgzu+CrRUD17GCGKjzxuQ=;
  b=ngUPvsrPEJ0NhN7QjwYHI2NuEqCHNTrIDgL2gl7U3MgG0oSrBbmKHEy8
   Oi9qTnJbCBW9tbdGAvjm686aEuLdkvRLY3TTMOauG7L7ECZ5jCkbPm/UE
   Fm0S4uYVfnEyMU2pjFQJ2QaHe1mfVMVpOoLAMLfMaXjTB/V2UtkWdhrS3
   eRn3uJTrJYjyInlLS/uF8iXhGdN9Mh3KsTxrG/cONk9M0HsVXbVoRWaEt
   at2yKnabiiYinFvLKzkyH4tlJcpCC1saOLbDCDe8Q+HrtBKBahyk99HjC
   YEZYM/HhRjrOfbBk+vhRxfldVbh1GuEAq/1pxlTz9IUSCsndBqHU0WiTj
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10393"; a="282955449"
X-IronPort-AV: E=Sophos;i="5.92,232,1650956400"; 
   d="scan'208";a="282955449"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 19:37:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,232,1650956400"; 
   d="scan'208";a="837384650"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga006.fm.intel.com with ESMTP; 29 Jun 2022 19:37:43 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 29 Jun 2022 19:37:42 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 29 Jun 2022 19:37:42 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 29 Jun 2022 19:37:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OPCSt32mQfXAhUC9rQJeW9uQkzhKDOsdVJBPIuJlK0TQSz24/i1+pndgGTeiQXAIXwPOBkm5c1YRPAPqY35X4qOsLWvyM5u21I8pSxB0joClbQhV7s98jaHjah8N/NnxTIJhTdt+fbp+criCSTdbWj4KnqjvJKepi0rqmYxBAnAbcOWGQJOjZ2M2YT7gGTSccWaE5lOmDMDsy+LgmAkbV4oacvI6+K7HgsYdoFLdoy845gVG84KvvnFpSmIbGxZwHdrrqxIS9OxPE2LMbkmI7q8FoZ8VlelF1ZxNEDyW+LZDRBbxKQlrvVOzMsMjB75BIjEFHaJLWj+WiBy0ETew0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zC0s4O4hP8fuSx2jSo8hS7bgzu+CrRUD17GCGKjzxuQ=;
 b=g3kKW4GsBA1S8reF1FWlQWG1E4HZ4+hXrAuwX/l1aaATBEJzOkaxA3Z8C1ILpsQI9vsEMBi7MQfix1p7xLs/uYgH0Jb/VBuXjb9AAic4rL8Ab5ePI13qgbQPlwge9TbNfSIEHllK6WWfSGIoCNap+mFPvlT7QUBg+6MV4WqkLsQSMpWoP72/8Fv4BJZMvGg9vyt0wCdeTlHaLKShOVoCc7XF5LozCjQnnwTfi1llPQS46Xo+hhHOccNfsuarN6p5QRIDJDjddxIRzpax4ZXy0eZExe5LMWclbi4I4Jkptkm6VG5gEIT6+My+TgK90pIb/ciCP8+QXSpOuHNXRTviLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY4PR1101MB2230.namprd11.prod.outlook.com
 (2603:10b6:910:1c::20) by BL0PR11MB3425.namprd11.prod.outlook.com
 (2603:10b6:208:73::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Thu, 30 Jun
 2022 02:37:39 +0000
Received: from CY4PR1101MB2230.namprd11.prod.outlook.com
 ([fe80::cdf:bbe5:be46:dc87]) by CY4PR1101MB2230.namprd11.prod.outlook.com
 ([fe80::cdf:bbe5:be46:dc87%12]) with mapi id 15.20.5373.018; Thu, 30 Jun 2022
 02:37:39 +0000
From:   "Yang, Lixiao" <lixiao.yang@intel.com>
To:     Jim Mattson <jmattson@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "nadav.amit@gmail.com" <nadav.amit@gmail.com>
Subject: RE: [kvm-unit-tests PATCH] x86: VMX: Fix the VMX-preemption timer
 expiration test
Thread-Topic: [kvm-unit-tests PATCH] x86: VMX: Fix the VMX-preemption timer
 expiration test
Thread-Index: AQHYi2P/9nLAFchrR0m9a/fDjMC/Uq1nMhog
Date:   Thu, 30 Jun 2022 02:37:39 +0000
Message-ID: <CY4PR1101MB22304D870D366B8483E6C9FCEABA9@CY4PR1101MB2230.namprd11.prod.outlook.com>
References: <20220629025634.666085-1-jmattson@google.com>
In-Reply-To: <20220629025634.666085-1-jmattson@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b23eaf34-71ac-41b8-e633-08da5a41802e
x-ms-traffictypediagnostic: BL0PR11MB3425:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lupDqy4Sv+jBfhlt5uvu6xljm1c4ez0mjbKF1V2Bz76rNy8+0SsxPCaX6UuguAVpgDxcbD9HWPfb0GLp1M/R7ui7lqeIX04ZzfCQbrbc0F5htKzNtrZ4KVtHhGqrp8xVESSHbvfrhduvTEkaByx87XpRsXWVYQ6CFOoVgbInUSB1hECojXNmg28sgAChT0C9q7/7D3vzkKxQWEz0swTXqgOuPq8nCd8LMjGt1VkECS9lKB4RZxXG5lm5rAGbaTH1+8YVIqosX64y6JeUWiiTZsH0MMPPnnokjmaCOcl2Hyy6vpIVDU82nyJRNzSSdKuNEL8u6ty0VIyvzSKOy5hXqDQu/t6lRWYmIgU4odhdstZeI+Nct/b2y66xbQEzXNLIAmJrFD7ipLKm1vl4UtcE4idtlcOjWuFQDWDokMHVTj5tu8G/mD0EWi7jav7LRMZBkEID9TawWjTIBPr5rrQQ1B4wUWHAYukjP8M6HJr0HFKDXWM3C3L2Bj6rDyDqyN51ARaFPypvF8iLjdFv6DLwaW1+0DxwcNp5N6AqWjH0zAMtUF+kZTdmeQgdsabSW7xzaCXtEUyTP9U0453WJYa+VkzZHKb8vxCJi6XUkt7Exyx8HQPgbTJ4zkiYQjl/QvZjlqKcyWtY9YyhW1CsGD7gCc5rWC+4ZL0rux/VqTQQ8EO/nxQnD2pYhY3npqHnS1lM9cmiqrSEwRK8LPNuao5ZLIzpXMA2SXod+Z2DUMYFGor72tqYcr+jJjTNOfNMr/IudjXd9V6ddrVlHfCE2OO4wT+dEP/FwoV7ft7v4sjIaPre9U2Sg+/Ea4NU6LC5nhOp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2230.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(136003)(39860400002)(366004)(396003)(66446008)(9686003)(52536014)(2906002)(71200400001)(66556008)(478600001)(26005)(41300700001)(4326008)(64756008)(86362001)(6506007)(66476007)(186003)(33656002)(76116006)(8936002)(53546011)(5660300002)(66946007)(7696005)(38070700005)(8676002)(122000001)(6916009)(82960400001)(83380400001)(316002)(54906003)(38100700002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VGtIU2J6b1dVZFBtUkl6QjRCUXpDV1pWSnpIbHJ6NDFwL1lqa3diR2M4QmQ2?=
 =?utf-8?B?WDQwKzczV2ttUW1SK1lISzdmN1NNam9qQVArRGZKb0JrVllpWWxBVStoWll4?=
 =?utf-8?B?NUZ4TWZ5V2tUdmlHMy9QNk1ENDdQOXMzbXFhMHNlK3M2aE9rSllwblh3anV4?=
 =?utf-8?B?R2JLNWkwUXlZZWh1Y3BhVlFwMFhRb2JwRVpFejJ1OHZkWmpZUiswQldyeHlD?=
 =?utf-8?B?REFjWFVyV2RlRVBGaFFJRllDd2xGMWN0T3VjaEx4NnNrbHg4RkJPUDl3ZSs5?=
 =?utf-8?B?ZkE5QmpuaE9YeFcwQ1hWU0tnVHp4YUtQb1ZPd252MEtWSGxLcitUaWQ2S0Jt?=
 =?utf-8?B?RGsxMGkwNEgwZUt4SzhDZ20xa3NkMWFhcGtTeGJFT2hBYy9sWE5WcDd0VXdH?=
 =?utf-8?B?VmN3cmF4T3V0SHc5SHRWeCtseisrYllNdnJheG1iSjFsc2hCQXMrcWFQRTZx?=
 =?utf-8?B?QlZzc1UyeEUvZk5oZ2Rtdkd4c1dmbWh6eFBCZ1M3RXNWWU53d0RxWlNYd1JF?=
 =?utf-8?B?ajdIdkF2MEhqallkTC9RcFpCQlc1VTRnd3AxcUpKak93RWtXQ3VCRlQ3djJM?=
 =?utf-8?B?MCtlTmVFekp3ZEhzZXdjMG1sUUQ3RnFjWlpOakZoOGdaRTc1YzZoaHkwTWhE?=
 =?utf-8?B?dEdJczR1WDVyVkROdXRJU1BOTzM1Z2prV3VzVS9mcmJpQVJwMDZRNW9HSWV1?=
 =?utf-8?B?dzV5eFU5OUlNcVo1MWhRWW1GUk5hR2VCcnh5cUdKeGg0NDJhVUNYNEtIUzcv?=
 =?utf-8?B?RzlKeDYzbTVTU2ZaUEZrelRYNks4b1JpcGVZd2VQOGNPYVVIWTFHRFN5MEtC?=
 =?utf-8?B?RndEaG1lVVhJL2RGa0Zzc3ZRMGs4SXliOFcwbTBJS05zK0REVjNhREJPK3ZS?=
 =?utf-8?B?czdBbGZ4dVlZbHhLSjhRSVZUV2dEMDg1dXNETTRTV2tVL01BSEloYlJzNGE4?=
 =?utf-8?B?TXhLS045WjgzMjdISVVoME8vQXd5d0ZUNjBOSGRjSmlnTUlRUjRpYW9KZUo0?=
 =?utf-8?B?MHpUSS8xdFRtcUkzVUI0eUdpT21Hc0daa2RDSG9DZGNEYmtVVU15V0xHVHpw?=
 =?utf-8?B?ZllCWG1vaFg1eC9YUW9ISGNNOCs4L25pT2I5RGE4dDFOa2FtZDcydEJucTg5?=
 =?utf-8?B?dkk4SFNwUDcxM25rK0pYM0ZaZTdJb2J4L2JnZ3lDQ3FFK1krSkIvS3R5N2Zj?=
 =?utf-8?B?TGhPVHJzd3NUNUwrMlg3TTVhbGk0M3VIZlZEV2czMmhWdm1qM0FGUEpLT2Yr?=
 =?utf-8?B?d29iZWJlZTViaVJmRHltTTJWaGM0Mk5KVlVUeU5YR29NVFZNbDVBMjJoR21k?=
 =?utf-8?B?WVhEdWJDT1JwTDNPbnRaWkt3TFlLQStMdWlXL0tqM0M5akRIb2pyenZoQ3R6?=
 =?utf-8?B?L0QxYUkxTkMwUFJGQWM0VU13SDdFcmpaSzRWRU5Mc0VERjUyRTM0M1BkdXZT?=
 =?utf-8?B?anRESlBFZjh5bjVPMHdRbmFsM0FGV1hDWEIxUW5iUlg3RXY4ZmRLcElUazFR?=
 =?utf-8?B?bFBCU2dzTFR6Y1NHR2h5UW1XSXQyTmdQdjBrc1BtUHF3RHIrK3pvYTVxbU9Q?=
 =?utf-8?B?bEVWUHpocXBoU09ZYVpPVzNNRDE2T0w4VDl3ZU9UL0ViMGg3b1RFVkJCL2dt?=
 =?utf-8?B?Z21tdkZ6dnNwa2Y0MThSWnZLdEQydktUQUhRTUh2MndZWWw4b2ZsL01uQUFr?=
 =?utf-8?B?NUhlUGFadEF6d2FFalJFK2hYRUJPN0RmeUI0c0I4dnF2eXByY2JpMXpncVRq?=
 =?utf-8?B?SlZDZVdGUm1JYmYzczBReHJNMnNCd09OVGs4ZzhMTUpBTkNUemF2N2JqcWlv?=
 =?utf-8?B?L3BRcGZkbkluTEt4L1R2Z2FEOGtDTld1eUE4Nno4cnR5eGlPUC9FUWo5K2Zl?=
 =?utf-8?B?TStYeVc3enF1TDBYMGNSMXVIenFEZE5YS3lnQnQ0RXJFNkw1Qm1KaSs3Zkw4?=
 =?utf-8?B?a2dPZjhmbUVpbjZIMkM0T3JHL24vQTU3aVB2WGYyRWlVQ2JJUkI0T0ptS2Zw?=
 =?utf-8?B?Q1E1RzR6ZjFlYSsydStsWEt0M1UrSWFmVTRlK2liUHJETXB3RldYWCtSdWs0?=
 =?utf-8?B?SkhvdzByY3lvbEJiY2pYZnNVV1pRWjlCa0dKK3BiOXA5blJ2cEFDNk5oRkJi?=
 =?utf-8?Q?8OXuBFHTZ0TN14/LV1Z35pBOH?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2230.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b23eaf34-71ac-41b8-e633-08da5a41802e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2022 02:37:39.5965
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: deDN7Ba6ytZw9RUnIERwAOJSzbhpQpzrdUZMFFFULKdrKZLtp65o4KfmW4gEBc2vwbpkkIROCs2bnoZbQ4W5KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3425
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VGhpcyBwYXRjaCBjYW4gZml4IHRoZSBidWcuIEkgdHJpZWQga3ZtLXVuaXQtdGVzdHMgdm14IHdp
dGggeW91ciBwYXRjaCB0ZW4gdGltZXMgb24gSWNlIGxha2UgYW5kIENvb3BlciBsYWtlIGFuZCB0
aGUgZmFpbHVyZSBkaWRuJ3QgaGFwcGVuLiBUaGFua3MgSmltIQ0KLS0tLS1PcmlnaW5hbCBNZXNz
YWdlLS0tLS0NCkZyb206IEppbSBNYXR0c29uIDxqbWF0dHNvbkBnb29nbGUuY29tPiANClNlbnQ6
IFdlZG5lc2RheSwgSnVuZSAyOSwgMjAyMiAxMDo1NyBBTQ0KVG86IGt2bUB2Z2VyLmtlcm5lbC5v
cmc7IHBib256aW5pQHJlZGhhdC5jb207IFlhbmcsIExpeGlhbyA8bGl4aWFvLnlhbmdAaW50ZWwu
Y29tPjsgbmFkYXYuYW1pdEBnbWFpbC5jb20NCkNjOiBKaW0gTWF0dHNvbiA8am1hdHRzb25AZ29v
Z2xlLmNvbT4NClN1YmplY3Q6IFtrdm0tdW5pdC10ZXN0cyBQQVRDSF0geDg2OiBWTVg6IEZpeCB0
aGUgVk1YLXByZWVtcHRpb24gdGltZXIgZXhwaXJhdGlvbiB0ZXN0DQoNCldoZW4gdGhlIFZNWC1w
cmVlbXB0aW9uIHRpbWVyIGZpcmVzIGJldHdlZW4gdGhlIHRlc3QgZm9yDQoidm14X2dldF90ZXN0
X3N0YWdlKCkgPT0gMCIgYW5kIHRoZSBzdWJzZXF1ZW50IHJkdHNjIGluc3RydWN0aW9uLCB0aGUg
ZmluYWwgVk0tZW50cnkgdG8gZmluaXNoIHRoZSBndWVzdCB3aWxsIGluYWR2ZXJ0ZW50bHkgdXBk
YXRlIHZteF9wcmVlbXB0aW9uX3RpbWVyX2V4cGlyeV9maW5pc2guDQoNCk1vdmUgdGhlIGNvZGUg
dG8gZmluaXNoIHRoZSBndWVzdCB1bnRpbCBhZnRlciB0aGUgY2FsY3VsYXRpb25zIGludm9sdmlu
ZyB2bXhfcHJlZW1wdGlvbl90aW1lcl9leHBpcnlfZmluaXNoIGFyZSBkb25lLCBzbyB0aGF0IGl0
IGRvZXNuJ3QgbWF0dGVyIGlmIHZteF9wcmVlbXB0aW9uX3RpbWVyX2V4cGlyeV9maW5pc2ggaXMg
Y2xvYmJlcmVkLg0KDQpTaWduZWQtb2ZmLWJ5OiBKaW0gTWF0dHNvbiA8am1hdHRzb25AZ29vZ2xl
LmNvbT4NCkZpeGVzOiBiNDlhMWE2ZDRlMjMgKCJ4ODY6IFZNWDogQWRkIGEgVk1YLXByZWVtcHRp
b24gdGltZXIgZXhwaXJhdGlvbiB0ZXN0IikNCi0tLQ0KIHg4Ni92bXhfdGVzdHMuYyB8IDggKysr
Ky0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0K
DQpkaWZmIC0tZ2l0IGEveDg2L3ZteF90ZXN0cy5jIGIveDg2L3ZteF90ZXN0cy5jIGluZGV4IDRk
NTgxZTcwODVlYS4uOGExMzkzNjY4ZDkzIDEwMDY0NA0KLS0tIGEveDg2L3ZteF90ZXN0cy5jDQor
KysgYi94ODYvdm14X3Rlc3RzLmMNCkBAIC05MTk0LDE2ICs5MTk0LDE2IEBAIHN0YXRpYyB2b2lk
IHZteF9wcmVlbXB0aW9uX3RpbWVyX2V4cGlyeV90ZXN0KHZvaWQpDQogCXJlYXNvbiA9ICh1MzIp
dm1jc19yZWFkKEVYSV9SRUFTT04pOw0KIAlURVNUX0FTU0VSVChyZWFzb24gPT0gVk1YX1BSRUVN
UFQpOw0KIA0KLQl2bWNzX2NsZWFyX2JpdHMoUElOX0NPTlRST0xTLCBQSU5fUFJFRU1QVCk7DQot
CXZteF9zZXRfdGVzdF9zdGFnZSgxKTsNCi0JZW50ZXJfZ3Vlc3QoKTsNCi0NCiAJdHNjX2RlYWRs
aW5lID0gKCh2bXhfcHJlZW1wdGlvbl90aW1lcl9leHBpcnlfc3RhcnQgPj4gbWlzYy5wdF9iaXQp
IDw8DQogCQkJbWlzYy5wdF9iaXQpICsgKHByZWVtcHRpb25fdGltZXJfdmFsdWUgPDwgbWlzYy5w
dF9iaXQpOw0KIA0KIAlyZXBvcnQodm14X3ByZWVtcHRpb25fdGltZXJfZXhwaXJ5X2ZpbmlzaCA8
IHRzY19kZWFkbGluZSwNCiAJICAgICAgICJMYXN0IHN0b3JlZCBndWVzdCBUU0MgKCVsdSkgPCBU
U0MgZGVhZGxpbmUgKCVsdSkiLA0KIAkgICAgICAgdm14X3ByZWVtcHRpb25fdGltZXJfZXhwaXJ5
X2ZpbmlzaCwgdHNjX2RlYWRsaW5lKTsNCisNCisJdm1jc19jbGVhcl9iaXRzKFBJTl9DT05UUk9M
UywgUElOX1BSRUVNUFQpOw0KKwl2bXhfc2V0X3Rlc3Rfc3RhZ2UoMSk7DQorCWVudGVyX2d1ZXN0
KCk7DQogfQ0KIA0KIHN0YXRpYyB2b2lkIHZteF9kYl90ZXN0X2d1ZXN0KHZvaWQpDQotLQ0KMi4z
Ny4wLnJjMC4xNjEuZzEwZjM3YmVkOTAtZ29vZw0KDQo=
