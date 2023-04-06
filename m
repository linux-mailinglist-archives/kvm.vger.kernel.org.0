Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413606D9420
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 12:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236811AbjDFKbo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 06:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236543AbjDFKbh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 06:31:37 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059E77EC3
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 03:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680777095; x=1712313095;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VhpJcjrAA3Q6eEDKGSx+5jIRS80BElfIP2ZtQWa57ZU=;
  b=PVjugNB0Uwu/JFzPucWu8gDY21ExLBSeASBMetXcviiW6zYphvbvsK2x
   sB/vYFKKXBpiA/Mxm+yGtHIowygQDcCnDa0sp2nRL9zqapr53tOEgiElx
   /KSdhZfnE21ZSE3iiTIdgIhhT7Cfs40eNgr9RiR/UqWcjPk6CL7ngqBGj
   hDANWWh3FHgWNsLgAb9mRnhhlIpXElkxkRpmap1SScJegfaMfTu6ddipr
   AvjbS9kqsixbJ03vwCUSby1zBSloh7OcLVycdI9M21TH6yf0P7C2CH+8r
   Bki7dPHe8SweD3GbSR2hAYw2J0kiEl54DYPJIvL3iHFm6ZYHVrjdtoPW4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="345301498"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="345301498"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 03:31:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="680617556"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="680617556"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 06 Apr 2023 03:31:34 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 03:31:34 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 6 Apr 2023 03:31:34 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 6 Apr 2023 03:31:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HN9S4espMBcJ+1CnP3k3dx7znEEittv+8o8atCscIIHCHBoiO+yUrUQF16tBgT6L8jvH5oH8iKor/dl1cutB80Ysn2f4wIQoEUWol9bjWSEunvnCkz/rgam1KjSWEglZ6M69k8OTZpOPo8TnKcxMSF18yYENLDKIyyK+6O7xuA+MiFob0yZ2RF7z0yEaWdrccYkX37kzOEk6fFP/6qmZOksJ4AIVZVlc+xef4ujdUc7h+sfIlhfD3mi4A6YdlwjY9RmN3CIZM7ZMx4N/65KNcaI2g4NMhEygLPU/biP5XWB/oYzCeXiPk7N7N3VLygeJqjM9MQyxfH/nqZv1KJRiqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VhpJcjrAA3Q6eEDKGSx+5jIRS80BElfIP2ZtQWa57ZU=;
 b=NkPLsmtZdpvI7jTX0aOSG+yjElCj5Dbm33pYg+epuQsEgqM50Pa1Ryg6RNHMH5TCuaQw5oJHdizx2sE8pv4nHQLOyk/o7VULccS1A5sp9XcFa6JeoOaoun4tbM4q4ryw159zv3xBTJoem+Nipbn/rIfMdDq3Etx+MdvmZtlO2c9/Hwhtnn1JQuzWTtddAE2CcVsgBKCGjz8mbKCCOZGChqesutE7G0UVk9MfQiXtA5i1KM6iXXmei8INXjDAGwqmZDieGnjtluRewdaFa6+ep8ptbRzmNAztVxrutf9MAr3umSAxVxg/mePH3vJU0Kdzoon6hmutX0yAtZ+7neubaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3717.namprd11.prod.outlook.com (2603:10b6:a03:b0::12)
 by BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.34; Thu, 6 Apr
 2023 10:31:31 +0000
Received: from BYAPR11MB3717.namprd11.prod.outlook.com
 ([fe80::2627:2c61:6a77:eddc]) by BYAPR11MB3717.namprd11.prod.outlook.com
 ([fe80::2627:2c61:6a77:eddc%5]) with mapi id 15.20.6254.037; Thu, 6 Apr 2023
 10:31:31 +0000
From:   "Yao, Yuan" <yuan.yao@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Li, Xin3" <xin3.li@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "H.Peter Anvin" <hpa@zytor.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
Subject: RE: The necessity of injecting a hardware exception reported in VMX
 IDT vectoring information
Thread-Topic: The necessity of injecting a hardware exception reported in VMX
 IDT vectoring information
Thread-Index: AdlnGoO7DMFQx8JhSoqsl2dQLdydDABDU48AAAo299AAAlafAAAGIesg
Date:   Thu, 6 Apr 2023 10:31:30 +0000
Message-ID: <BYAPR11MB371745060FFA8EF9BB324CCC95919@BYAPR11MB3717.namprd11.prod.outlook.com>
References: <SA1PR11MB673463616F7B1318874D11A3A8909@SA1PR11MB6734.namprd11.prod.outlook.com>
 <ZC4hdsFve9hUgWJO@google.com>
 <BYAPR11MB37173810AE3328B5E28A18D795919@BYAPR11MB3717.namprd11.prod.outlook.com>
 <2e57ad5d-d17a-98b7-d4f9-912bdb23c843@redhat.com>
In-Reply-To: <2e57ad5d-d17a-98b7-d4f9-912bdb23c843@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3717:EE_|BL1PR11MB5525:EE_
x-ms-office365-filtering-correlation-id: f3172ec0-d227-4f2e-e5b6-08db368a1628
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gNfhSrotvm6j5sJWF1Gxgw21jGkGvGCWRy49uFYvTQ451mWxACIA/HXwjdg8T0z4qd4UOiXKV27LoNpo/8VMwR4eZigUIdw5mUvGJggbDTuAqBNNURLRBMnPgJ9pdao22HsDywel0bmSJSZBajSYn5y5J7iq0zwLlXASW3gIW5Y2INUgNoPyAI6ElnMm6zUF0AhgSIBrEbOO3gtH8OCdIr3S+RMuVl+vkj+NkdZdaXa64OuoIVdLM3deGVF6sqtXdiksIKjkWt1cmb58Y+s7WmrcqbfDnTFj0JTAOoahqWDhMJFpQQr+ddvSRvsgJ0ANPrYZxWx4mykWSNFGCoGjIPVAy7lg0wmeI2YygWPmLwQol3x8SgDMJM+GHLTYGk26sRGd558v4qsqwfvamBUCOQ/G6jJZ7nhOrJjrplt7X7xzBzkTzyh3A1LQiqwWhV7TGCDefDTPQyxvau6gOWErVhGeXgSrL6RFaKapEihxoSnMUlr6WI7UlUCa4UGBq3oqEHfsQA/wazjL8I3+tdtVYrtnVRNGbg6mfRVu3SMxwTyfh6p5DvBqrNP/pIb29+41Vfn+f+W0CoXMYtxKaa65AgDa0osGNS6FnL3TIkr+khtfzsgSWdQsBg7xMFPIPivt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3717.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(136003)(366004)(39860400002)(396003)(451199021)(54906003)(33656002)(86362001)(55016003)(478600001)(8936002)(71200400001)(7696005)(110136005)(6636002)(122000001)(82960400001)(41300700001)(52536014)(76116006)(64756008)(38100700002)(8676002)(66946007)(66556008)(66476007)(83380400001)(186003)(66446008)(316002)(4326008)(26005)(6506007)(9686003)(107886003)(4744005)(5660300002)(38070700005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OThUMnJiTnFsZzR1TzVnRi9KbHJnQy9reVZOU3MzYlMzbUtHSEZyTGF5Y29P?=
 =?utf-8?B?SDd2NzdCN2VxWE5qNFFQaWJkTllPRGVJNDJIRGtOOTNDelI2NVJkTXNZcmc3?=
 =?utf-8?B?bEthaVRXTG5VMEUvL2Q5STEwYVZQRHJudm1zWk1xaGhsNU9uam5mQm1zdlRR?=
 =?utf-8?B?dWREQVVPVzhJbXVoV2dKK04rNjFTbWoyOHFFVjRPRzR2NGI5SVhqak5HVHVu?=
 =?utf-8?B?emVoR3FSdjM0YVd3RCtuVmFwbllVWUZ4Wm03WFJRbUdKNnVmLzZUcjVST2Vl?=
 =?utf-8?B?VUswRWM1SDNjR2g2Vm9QazFTdzA4Y2NIanlsTXNhR2E3bnQ1UHdpMHdmTFY4?=
 =?utf-8?B?OXNjbk8zMm9mZjlnMnp1aEppMnVXcFRtSVVxUms5eXVRRzJNYTVCamh5Wmgx?=
 =?utf-8?B?RzVIOGlFbXZ3Y0E0NDdsVURIQlJuTHFiYnRzNVp0QWM4b1V1dDRieTUzZmtL?=
 =?utf-8?B?Um9LUHpWVzJPYUdFUlVmaFFjUitWTFpNckEvL1RhRUxLSGsvSUFpLzJKaHd6?=
 =?utf-8?B?aVhBRGhFRVJKWXRlaDVQTGFiV2NoZm9oUGZWZ2ljWCtpRU5HeEIxYnh4TUtE?=
 =?utf-8?B?RXhLUHg2Z0xLSFlFSlBHS0k4VGxHdnRoWmp6d3RGWFNmdkZXQ1pXS0t1TC84?=
 =?utf-8?B?Sm1PTVRYSU83djlneDlJRHR2SFRmSTBKZkhRS0lpSnBlSWpTTTRKNFZoZ2ZZ?=
 =?utf-8?B?Q3NPaUJZbHU3WUlLcWRxWU1CUFZCQmE1YWE5TFFGVmpmWXpiU0pUWks3R3V6?=
 =?utf-8?B?amUyY3B4WGkyUDVhRm51a3FvcUVKY1gwQkJvdmNrUXhOUmZvVkQwT1RqamEz?=
 =?utf-8?B?SDMyU1VKRlEwVC9jUDRmeStyeEFQd2VvS2dYQVgyOGhta2xpMDZhbEFVNE96?=
 =?utf-8?B?alNtWXh3bWRsKzFtM3Q4bDRGNVpsK2ZucnQ4SHppQWxIZkhDUTRZQnFheTFv?=
 =?utf-8?B?OEw1SyswZ3YrRkppWGtPMEwzMnhTVmFJNERGY1JrZVRTMHJ1Tk00M2dsa2Fm?=
 =?utf-8?B?eEFLNm91T2JoZCtRSmdZQ0dlNnVTakp4QzZiTm5iZ0J0eUZ3TitPSXA5LzNt?=
 =?utf-8?B?bVNMMVlyYTZHMEVEUmV0RE5Yb0VHTXdOYkIvZVZwQzZtWDI1MFVqVnB4dXhV?=
 =?utf-8?B?T2lxRDhEelVGRmlUYkZtYXhYODhlSjdobnB3bytNekZzanl1Y3VFdXd3bFdN?=
 =?utf-8?B?emNZcE01NG8xWDhFT0phOTQxM3czaEsyYTdwTzhRVVQ4S3d6UTV6Y0IrN3dp?=
 =?utf-8?B?eEtpaURXMitKNnV4UHpFcEFvSmdQcGk5NXo5VG85NDVnZythRWYzOUNFUWV5?=
 =?utf-8?B?RENyWTI3cndKSWRzZE9sd3lCSVlsL0k0cEJyeWxrSms3RjAyekk5ak9VcDRn?=
 =?utf-8?B?MjNEZE9sd01GUnhLVkVoMXFqVVFaYWJjaFM0TFFRVnByWGgweG1YbnpEay9h?=
 =?utf-8?B?YUgrK1o4WjAvbnpnS2VWYkhvczZDWTdXd3l6c0JOOEl1RGJMOTRQdGk4U205?=
 =?utf-8?B?bjMrWDZLTDI4MTVaMU94UkRtMElwKy8wbW1taWNCRFo5czd5RXpSM0wvQ1ZY?=
 =?utf-8?B?bUZxUnE2Ujl0RElaaVhDeTRoUzRKaDFZbklCb016d2ZGYlNrTnZIRGNmaHkx?=
 =?utf-8?B?cW9sUWE5aTQ0TWFsUUxSWXV5M1M3aDFOL2VZNElaUUJsS3ZwemEzYWJ5d0pK?=
 =?utf-8?B?Mm9JOGEyTERObXVNU3R3eERqUkdObE52a1dDMFU0TmJ5QlF2RElvQ3hMYyth?=
 =?utf-8?B?Y1FTdnpYTVI5ejMyNUtTUE15cTE4Ym9YL3FVYnUwY2s5dFcyem9BV1lRS0JF?=
 =?utf-8?B?R0lQRnNyOU5MYU04QXVQZmQwbE9oa2w2cWlHSk5LNXRpUDlSZXJiVnB0b2VH?=
 =?utf-8?B?YS9nSk9tNElGbW5EWUtSaXZySTh6ZXlQcm5JUzhVaGNZQTdHazRjT1hsb2l1?=
 =?utf-8?B?OTc5ZWFTTGp1NTZFQ0hnY2prdFk0RVBCR0N6YUUreDF3VUUwSzVBbG55YS9n?=
 =?utf-8?B?OTVTV0ZSWkwwUzRPenREYUphQ0RmK252VFJYT1dWMHg5dERSZS9Kd0FnbXBZ?=
 =?utf-8?B?VmRZZGZ6aXd6SCt0ZmlCRUtGNEdKc2NuRmlMQ2w4Nk03OVBVUEpoc1ZCczR4?=
 =?utf-8?Q?aVv4w03o60mD7J0WOTfc4w26k?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3717.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3172ec0-d227-4f2e-e5b6-08db368a1628
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2023 10:31:30.7662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fK7YSVmTtQfbpfrxq1E9Sgg+jqvNVl45GHUav2aYZ2kNc+KnICA1CccUDboPs2yGWT4GivGdg+90Mf7zb/IwZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5525
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogUGFvbG8gQm9uemluaSA8cGJvbnpp
bmlAcmVkaGF0LmNvbT4NCj5TZW50OiBUaHVyc2RheSwgQXByaWwgMDYsIDIwMjMgMTU6MzMNCj5U
bzogWWFvLCBZdWFuIDx5dWFuLnlhb0BpbnRlbC5jb20+OyBDaHJpc3RvcGhlcnNvbiwsIFNlYW4g
PHNlYW5qY0Bnb29nbGUuY29tPjsgTGksIFhpbjMgPHhpbjMubGlAaW50ZWwuY29tPg0KPkNjOiBr
dm1Admdlci5rZXJuZWwub3JnOyBMaSwgWGlhb3lhbyA8eGlhb3lhby5saUBpbnRlbC5jb20+OyBE
b25nLCBFZGRpZSA8ZWRkaWUuZG9uZ0BpbnRlbC5jb20+OyBUaWFuLCBLZXZpbg0KPjxrZXZpbi50
aWFuQGludGVsLmNvbT47IE5ha2FqaW1hLCBKdW4gPGp1bi5uYWthamltYUBpbnRlbC5jb20+OyBI
LlBldGVyIEFudmluIDxocGFAenl0b3IuY29tPjsgTWFsbGljaywgQXNpdCBLDQo+PGFzaXQuay5t
YWxsaWNrQGludGVsLmNvbT4NCj5TdWJqZWN0OiBSZTogVGhlIG5lY2Vzc2l0eSBvZiBpbmplY3Rp
bmcgYSBoYXJkd2FyZSBleGNlcHRpb24gcmVwb3J0ZWQgaW4gVk1YIElEVCB2ZWN0b3JpbmcgaW5m
b3JtYXRpb24NCj4NCj5PbiA0LzYvMjMgMDg6MzcsIFlhbywgWXVhbiB3cm90ZToNCj4+IEl0J3Mg
ZGVmaW5pdGVseSBicm9rZW4gZm9yIG5lc3RlZCBjYXNlIGlmIHRoZSBleGNlcHRpb24gSXMgaW5q
ZWN0ZWQNCj4+IGJ5IEwxIGluIHRoZSBmaXJzdCBwbGFjZSwgYnV0IGlmIGl0J3MgaW5qZWN0ZWQg
YWZ0ZXIgaW50ZXJjZXB0aW9uIChieQ0KPj4gTDEpIGZvciBzYW1lIGV4Y2VwdGlvbiwgYW5kIGl0
J3MgdHJhcCwgaXQgY2FuIGJlIHJlZ2VuZXJhdGVkIGJ5DQo+ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgXl5eXg0KPg0KPmlmIGl0J3MgYSBmYXVsdA0KDQpZZXMsIG15IHR5cG8s
IEkgd2FzIHRoaW5raW5nIGZhdWx0IGJ1dCB3cm90ZSB0cmFwIC4uLg0KDQo+DQo+PiByZS1leGVj
dXRlIHRoZSBMMiBjb2RlLg0KPg0KPllvdSBjYW5ub3Qga25vdyB3aHkgTDEgaW5qZWN0ZWQgYW4g
ZXhjZXB0aW9uLiAgRm9yIGV4YW1wbGUgTDEgY291bGQgaGF2ZQ0KPmluamVjdGVkIGEgTUNFIGp1
c3QgdG8gdGVzdCB0aGUgY29kZSBpbiBMMS4NCj4NCj5UaGlzIGlzIGEgc2NhcnkgY2hhbmdlLCBp
biBhIHNjYXJ5IGFyZWEgb2YgY29kZSwgd2l0aCB1bmNsZWFyIGJlbmVmaXRzLg0KPkl0J3MgZ29p
bmcgdG8gYmUgaGFyZCB0byBjb252aW5jZSBwZW9wbGUuIDopDQoNClllcyBJIHVuZGVyc3Rvb2Qs
IHRoYW5rcyBQYW9sby4NCg0KPg0KPlBhb2xvDQoNCg==
