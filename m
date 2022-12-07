Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 250406452F0
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 05:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiLGENJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 23:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiLGENH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 23:13:07 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEF656553
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 20:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670386386; x=1701922386;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BlhLrjBueVcwR16VTAkeJ6CTIzaeGrXqOgT91WkQNj4=;
  b=Q1ZbnhW4h+HQjYYn8VYQ0pyHtTp3e7VPYxUE2jqPEhoEf8ikX1zKAfUl
   WSV3CXa3h6UMJs+ejMimcDQL21ohTsFDgBPWMnRN6oGum6KsFcooUpnul
   G+Toz4P/l3tRj9MaPPMUmwNVfIr9OkniL0ZMi8XDi9/HlcMFdHA5NO5JD
   hzunvGozXYJpexrTgeZX2CksN47978I1zvVb6Wzf+5GuAAVgTnfAHPBUo
   BQ+lpQ7MUcakMvPRN6Bwl5Ef1oEWRVDxk+1iowr1uakmLpoR3UazRphdv
   62mc6I1SO/RUCFgFeTsLyGwQjdxKI+bK6c6O7GIUX/Iqjn4cY31wnTss3
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="300219034"
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="300219034"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 20:12:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="735252539"
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="735252539"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Dec 2022 20:12:48 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 6 Dec 2022 20:12:47 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 6 Dec 2022 20:12:47 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 6 Dec 2022 20:12:47 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 6 Dec 2022 20:12:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RxBBhMbmtGvD7fSRMefZUK0ZRJgBX8UdnRwrBpEJPy/fw/p9ojhfECz5BdpLSZwNORgD6S1sXYMgRwq4Bh49xRvjXkotGqE7VLfO0npob9u7q63ATk0mh9l2i2xlAejHRUgFPTkUOwmcpUZiSqYFO6NRmInv4mFOInfd2LEcgdjEy+TQdK8+SBkjx3BQSqebGxx9PVRdpMO8OZXrnrhlVzoV3YY6xa0BT5ZdIqGlIppM9DpuXZN9YZ7jAhUHdL3nRTiKc78kfMcdRoUNZGZWoQDxocK6cRSjwqTGoAk9fRLAKwEoeEt9xfrjG1CHWB25pLwywQQsvle5VKmYVHqwpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BlhLrjBueVcwR16VTAkeJ6CTIzaeGrXqOgT91WkQNj4=;
 b=aYzKfpUzJ/hlAk8oeUVLzqBmwr8jC00a8ryM/gjNY4re2DtYO+lRCnNi3cpdU6wpGVPExD3dZOBylw03T0mz++NMMpgcz16B38FpYA3lcIUI9tmAu9+VGYiIqN6KJlmRNKgUxMbkdjMikHv7GdwpU2XyDaA2IVTbsVqkwD+8iNy9hcQVdd51NqBznOebHpOJZJDagGfl7F336vwKJ0S15ybmY4JSyCdXgLDh1dwVJCvOO3v+jsEiAbVu7MjPOXY6PIKGoTsRBWrQlaOA4qhuIfLJCeEIWOgwoUnpOSvftLJ6YuZaJkZO7X3SAKR4N12ciQWuDCfSNdDtypCB+IZwmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2684.namprd11.prod.outlook.com (2603:10b6:5:c7::18) by
 IA1PR11MB7890.namprd11.prod.outlook.com (2603:10b6:208:3ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 04:12:44 +0000
Received: from DM6PR11MB2684.namprd11.prod.outlook.com
 ([fe80::6fd8:7a37:ba4:58c9]) by DM6PR11MB2684.namprd11.prod.outlook.com
 ([fe80::6fd8:7a37:ba4:58c9%7]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 04:12:44 +0000
From:   "He, Yu" <yu.he@intel.com>
To:     "Yang, Lixiao" <lixiao.yang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>
Subject: RE: [PATCH 00/10] Move group specific code into group.c
Thread-Topic: [PATCH 00/10] Move group specific code into group.c
Thread-Index: AQHZBZUCjeDf/vdV5kaD+SeFYgaWwq5ZfuaAgAEiC4CAAA0QAIAAjemAgAD2HQCABEr6YIABWt+A
Date:   Wed, 7 Dec 2022 04:12:44 +0000
Message-ID: <DM6PR11MB2684B8B46C63981DE8795F07E01A9@DM6PR11MB2684.namprd11.prod.outlook.com>
References: <20221201145535.589687-1-yi.l.liu@intel.com>
 <Y4kRC0SRD9kpKFWS@nvidia.com>
 <86c4f504-a0b2-969c-c2c6-5fd43deb6627@intel.com>
 <Y4oPTjCTlQ/ozjoZ@nvidia.com>
 <20221202161225.3144305f.alex.williamson@redhat.com>
 <fecfc22d-cb9e-cac9-95ff-21df13f257c2@intel.com>
 <CY4PR1101MB223078550837BB1EAE608C17EA1B9@CY4PR1101MB2230.namprd11.prod.outlook.com>
In-Reply-To: <CY4PR1101MB223078550837BB1EAE608C17EA1B9@CY4PR1101MB2230.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2684:EE_|IA1PR11MB7890:EE_
x-ms-office365-filtering-correlation-id: 39fe68cc-98d1-4921-1a93-08dad8094ad1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +dMbJdgqotlU6hAAdhaZODAwSjKWW/oR4OjbKA9r7RFXLvCy/Iq36fOSumvkOCDtenPpr97UgebxHirml1qLKe5HDX/Gq/5vPDD4YkGsh5qO56bec56DyvNydeXFftX9I49XhXYWbawU9NEVze7QHEMrMRGAQ7LO7wbD0uyQjHCR/jvCa+du+wzo4MuuBjmJ5zsjhRK5iRtakdSwJ68h+Df6oK68TeagVjYTb+b1nHxwrABzE+7gloWeBZUSqOlf6x6H0s2lC9yWIYkNg5ft0Hsha/RIuXFz+dAUWsMdIEiKeMV52qUIf9/OuhHvCBa3v2UHQQL+l1jq6E4HrDrJ8bLILEzuYTQKVUa89cCCjLMIFebtcqchdB00vDvR/nWWQ3pPMi3dhj2RQjG3oXXuyhsN1Q7KtJEl13GcQVMlMHkJ2HlosH1QBQ1Sf0m13kIp6y1WZo5rHr4r7uMgnFsQkhBwrA2Nw45ktiCtCYzVy/KUvDDQEq6mgj6DkGbbi8iJB8KD5OBrmBtmddZEeKBRDDF4SLDXS78fPVp+PqjUY/tPHE3PCdH5qdxB+KX7K64tJq7Gd+wJnBOxi4/WUpWl5xV5LrVHOPWN8Dr6sA9YkCmDfC5ZD3kTSXrQxK812jmd9nnAocqMyTklDnzjEH6bbdroj7QAnriQpmUEPIZ6s1rdh2Wi5KNb+jSk31DvpovITnCbXXsQQ2a86MOLVon++Bd7gDqWu/tXfSB0vv8y1h329n8YdrWP6qmS520j9MaWHZvsLjePrATzZuRaWvhUKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2684.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(376002)(366004)(451199015)(110136005)(316002)(55016003)(41300700001)(5660300002)(54906003)(76116006)(478600001)(66946007)(33656002)(8936002)(66476007)(66446008)(8676002)(4326008)(82960400001)(83380400001)(66556008)(64756008)(52536014)(186003)(38100700002)(122000001)(966005)(71200400001)(9686003)(7696005)(53546011)(26005)(86362001)(6506007)(38070700005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WDlLUnF3ck1nMTRMRjFPbFk1QWVnaTR2c2Qxdkx2VG4yUW1mOWE0d09UYjEz?=
 =?utf-8?B?ZUhVTFByeUdZVlZoeFJ1cWg4T2hWUGFzb083YlVybWE2YzBZcWNqOTBaNTls?=
 =?utf-8?B?Q0s2UzVDWEdHdkdpLzV0aFNmM1hqWXh4cmRKRFlXT29JZ3BsSzB5cFBSTEd3?=
 =?utf-8?B?MjIrS0E0QW1YeFZ0V01pYmpZSjZ0VVJmR3JOMUlCT1d3QXYyNGVVajJQa081?=
 =?utf-8?B?eklxUHA2SVQ2K2xTcm9OVS80ajgvTU54OG1zVkFkQ0lMWEtndk9LR3FWV0c0?=
 =?utf-8?B?a1h1RkhXblk1Zlh4NDJyN2pvZEFwVCs0ZExQSkphTjNiYURRaDNLb0wyVzUr?=
 =?utf-8?B?L3VNR1NkYnU1SWNrazEyRFMwNWJ3b1hjRVp4c2dNZ3MwWGdxMXhET2QyWTNn?=
 =?utf-8?B?NEk4MXQ2c2w0R1B2ZEREem5Ya3V6N0t5QTloMEUxNGZPLzN1cUFSbVBkbFRv?=
 =?utf-8?B?ZWs2NGkvR0hQTnpyL3RYVGt0WkRycEJOdHB3V2laL0RDNnlQSDVtdWZWTG9C?=
 =?utf-8?B?MkVwOCtJaXBNU3lKZmRyMnVubWo0UUdRSDNRNXloQThBdE9hZWxKVVQ4OHcw?=
 =?utf-8?B?ZUFZUkZGTHlFSnNUYytNanpjN25tcUxzOXZlMnRvbEhHNDl5L3BmV09xdmRO?=
 =?utf-8?B?MmRKZDJjRjBwU2JMT2w4YUlvdVFXSXdRNUx0bXJSdlpUOENFTENpRitRWGtt?=
 =?utf-8?B?anp3Mjl0QnVtNDhyblQ0bDdZVXF0RkRoZGhzbkJtU2tvVFIzNDVuOXROQ08r?=
 =?utf-8?B?NUV6TGd2LzlRWThNMHdRN2ZrLzdFOTR6QXZNZTVDVnIvS3J0VVdzWXlKaHNV?=
 =?utf-8?B?QkFRREZyazdseTB5K21VWFhpWUZEVkoyc0JRWUZpMHFPWWRRN1BGL1V1SlNs?=
 =?utf-8?B?YU1lVzRKUVExbys0UHJxTFl2NXZsZ2tCZDUwSXlQVER6dXorUGJLODV5UWl5?=
 =?utf-8?B?MWZMQ3AvTEZ0QmdUdFhaY3BLTXZ3ZzU0eWpuR1QwY0pNc0dJaGlGOU1EM0Fk?=
 =?utf-8?B?aURhNXRNb0Eyd2tld0g2UFAxY1p5QzdmRWhpQno4ZFRINmw3V1hNRjFEa1BR?=
 =?utf-8?B?STl3Szhrc0d3NXBTMTVDbEMwaU12YUg1VXRpQUdveE5oanlBM3BEYXcxQUox?=
 =?utf-8?B?eHVMWkFLcUYveDRVbkh2ekNJdnJiREd3VFAvNEplVXFwUTFVanlKYWpRU1RE?=
 =?utf-8?B?dFdYS1pIRGNjQms5N0VhZnQyRWFVV3JsQVo4UVBqM3AybmxEMHZhUDNFSm85?=
 =?utf-8?B?R2RxL2g4SkVTd1NKdHRuRjdGRFg3NmZTQjZiWXh2RFRYUmdxU1k4andwaFlG?=
 =?utf-8?B?OGh6TVFNYUhLQXRRbHpjbXBkWFc0clFCTEMxK3BmeUtFNk1WSUJKT1JndUlh?=
 =?utf-8?B?QVdFMVFFRG1WVHZySHU5TTB1QUs5TmgxUjJFaEZHSi9XMFN2TXB3Q0xpOHcr?=
 =?utf-8?B?anBvdzUyRnAxWkg4dG5sVDhEZ0VYTGxrL3ZIZFZOWklhZTkvNUplNHJCcFBF?=
 =?utf-8?B?bDRyUjFGa0h6YjVFNU1qZks5K2U2V3RIUjhIRlAxSTNYOGRtSFNOZVNEZkV6?=
 =?utf-8?B?SUpJamtnWWxwVXF0Ty9TWDdSYWNUOU96TE9vVlpwTFJSL0ZFeldFdW1FVE5I?=
 =?utf-8?B?VytGSEEzbXQ5OGovOWJ4MmhKSTBhdDl5ejMrdlVDYmU2aE92QnB5QUVoVjAx?=
 =?utf-8?B?UllXcmt0N3FxOWlNbTdvV01rZjhFdnhHV2xNL2w3WDdnSHNVeG9nQ3ZmN2J0?=
 =?utf-8?B?amNMSFF0NHVxeTJudlI2cHVMeGxkOEdXNWR4aGdCbnV6RDhiOG83U0lQdUhh?=
 =?utf-8?B?RTVPb2JyZy9jQzA0a1BoRHRqMG54RVExZkZXY05mdStFRmpNSGJJWHhlaXBT?=
 =?utf-8?B?cEJpRWxwaW4vSk1LNFptWFgvUGNaMFdDRXNWVUVlV0xiZzNxVFUwOFZYYkI5?=
 =?utf-8?B?aDJQNzlmdHU5UkhETlYrNmNhZGpOTVF4MEFURDg5K2l3MjdhRDRtRm53c1c3?=
 =?utf-8?B?ajZQdWRNK3o4RXNFTEc1NkpsakpmcWFhbWtkL2lnV3RDWHQ4NGcwK2NzMDVF?=
 =?utf-8?B?cG82VHRqamRvVWdOU0h0Qk1NbTZDVUlabVQ4YVZreSs3d3VlT01XV2dXZFll?=
 =?utf-8?Q?u+S8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2684.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39fe68cc-98d1-4921-1a93-08dad8094ad1
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2022 04:12:44.7244
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fA4sKz0DuSAFUVVgTQGNWzuoJqsgEYD/ubZChzC9E64J27ffTpALNhrOBUlitRcy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7890
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMjAyMi8xMi82IDE1OjMxLCBZYW5nLCBMaXhpYW8gd3JvdGU6DQo+IE9uIDIwMjIvMTIvMyAy
MTo1MywgWWkgTGl1IHdyb3RlOg0KPj4gT24gMjAyMi8xMi8zIDA3OjEyLCBBbGV4IFdpbGxpYW1z
b24gd3JvdGU6DQo+Pj4gT24gRnJpLCAyIERlYyAyMDIyIDEwOjQ0OjMwIC0wNDAwDQo+Pj4gSmFz
b24gR3VudGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT4gd3JvdGU6DQo+Pj4NCj4+Pj4gT24gRnJpLCBE
ZWMgMDIsIDIwMjIgYXQgMDk6NTc6NDVQTSArMDgwMCwgWWkgTGl1IHdyb3RlOg0KPj4+Pj4gT24g
MjAyMi8xMi8yIDA0OjM5LCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6DQo+Pj4+Pj4gT24gVGh1LCBE
ZWMgMDEsIDIwMjIgYXQgMDY6NTU6MjVBTSAtMDgwMCwgWWkgTGl1IHdyb3RlOg0KPj4+Pj4+PiBX
aXRoIHRoZSBpbnRyb2R1Y3Rpb24gb2YgaW9tbXVmZFsxXSwgVkZJTyBpcyB0b3dhcmRpbmcgdG8g
cHJvdmlkZQ0KPj4+Pj4+PiBkZXZpY2UgY2VudHJpYyB1QVBJIGFmdGVyIGFkYXB0aW5nIHRvIGlv
bW11ZmQuIFdpdGggdGhpcyB0cmVuZCwNCj4+Pj4+Pj4gZXhpc3RpbmcgVkZJTyBncm91cCBpbmZy
YXN0cnVjdHVyZSBpcyBvcHRpb25hbCBvbmNlIFZGSU8gY29udmVydGVkIHRvIGRldmljZSBjZW50
cmljLg0KPj4+Pj4+Pg0KPj4+Pj4+PiBUaGlzIHNlcmllcyBtb3ZlcyB0aGUgZ3JvdXAgc3BlY2lm
aWMgY29kZSBvdXQgb2YgdmZpb19tYWluLmMsDQo+Pj4+Pj4+IHByZXBhcmVzIGZvciBjb21waWxp
bmcgZ3JvdXAgaW5mcmFzdHJ1Y3R1cmUgb3V0IGFmdGVyIGFkZGluZyB2ZmlvDQo+Pj4+Pj4+IGRl
dmljZSBjZGV2WzJdDQo+Pj4+Pj4+DQo+Pj4+Pj4+IENvbXBsZXRlIGNvZGUgaW4gYmVsb3cgYnJh
bmNoOg0KPj4+Pj4+Pg0KPj4+Pj4+PiBodHRwczovL2dpdGh1Yi5jb20veWlsaXUxNzY1L2lvbW11
ZmQvY29tbWl0cy92ZmlvX2dyb3VwX3NwbGl0X3YxDQo+Pj4+Pj4+DQo+Pj4+Pj4+IFRoaXMgaXMg
YmFzZWQgb24gSmFzb24ncyAiQ29ubmVjdCBWRklPIHRvIElPTU1VRkQiWzNdIGFuZCBteQ0KPj4+
Pj4+PiAiTWFrZSBtZGV2IGRyaXZlciBkbWFfdW5tYXAgY2FsbGJhY2sgdG9sZXJhbnQgdG8gdW5t
YXBzIGNvbWUNCj4+Pj4+Pj4gYmVmb3JlIGRldmljZSBvcGVuIls0XQ0KPj4+Pj4+Pg0KPj4+Pj4+
PiBbMV0NCj4+Pj4+Pj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzAtdjUtNDAwMWMyOTk3
YmQwKzMwYy1pb21tdWZkX2pnZ0BudmkNCj4+Pj4+Pj4gZGlhLmNvbS8NCj4+Pj4+Pj4NCj4+Pj4+
Pj4gWzJdDQo+Pj4+Pj4+IGh0dHBzOi8vZ2l0aHViLmNvbS95aWxpdTE3NjUvaW9tbXVmZC90cmVl
L3dpcC92ZmlvX2RldmljZV9jZGV2DQo+Pj4+Pj4+IFszXQ0KPj4+Pj4+PiBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9rdm0vMC12NC00MmNkMmViMGUzZWIrMzM1YS12ZmlvX2lvbW11ZmRfag0KPj4+
Pj4+PiBnZ0BudmlkaWEuY29tLw0KPj4+Pj4+Pg0KPj4+Pj4+PiBbNF0NCj4+Pj4+Pj4gaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcva3ZtLzIwMjIxMTI5MTA1ODMxLjQ2Njk1NC0xLXlpLmwubGl1QGlu
dGUNCj4+Pj4+Pj4gbC5jb20vDQo+Pj4+Pj4NCj4+Pj4+PiBUaGlzIGxvb2tzIGdvb2QgdG8gbWUs
IGFuZCBpdCBhcHBsaWVzIE9LIHRvIG15IGJyYW5jaCBoZXJlOg0KPj4+Pj4+DQo+Pj4+Pj4gaHR0
cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvamdnL2lvbW11ZmQu
Z2l0Lw0KPj4+Pj4+DQo+Pj4+Pj4gQWxleCwgaWYgeW91IGFjayB0aGlzIGluIHRoZSBuZXh0IGZl
dyBkYXlzIEkgY2FuIGluY2x1ZGUgaXQgaW4gdGhlDQo+Pj4+Pj4gaW9tbXVmZCBQUiwgb3RoZXJ3
aXNlIGl0IGNhbiBnbyBpbnRvIHRoZSB2ZmlvIHRyZWUgaW4gSmFudWFyeQ0KPj4+Pj4+DQo+Pj4+
Pj4gUmV2aWV3ZWQtYnk6IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5jb20+DQo+Pj4+Pg0K
Pj4+Pj4gdGhhbmtzLiBidHcuIEkndmUgdXBkYXRlZCBteSBnaXRodWIgdG8gaW5jb3Jwb3JhdGUg
S2V2aW4ncyBuaXQgYW5kDQo+Pj4+PiBhbHNvIHItYiBmcm9tIHlvdSBhbmQgS2V2aW4uDQo+Pj4+
DQo+Pj4+IFBsZWFzZSByZWJhc2UgaXQgb24gdGhlIGFib3ZlIGJyYW5jaCBhbHNvDQo+Pg0KPj4g
VG8gSmFzb246IGRvbmUuIFBsZWFzZSBmZXRjaCBmcm9tIGJlbG93IGJyYW5jaC4NCj4+DQo+PiBo
dHRwczovL2dpdGh1Yi5jb20veWlsaXUxNzY1L2lvbW11ZmQvY29tbWl0cy9mb3ItamFzb24vdmZp
b19ncm91cF9zcGxpDQo+PiB0DQo+DQo+IFRlc3RlZCBOSUMgcGFzc3Rocm91Z2ggb24gSW50ZWwg
cGxhdGZvcm0gd2l0aCBhYm92ZSBicmFuY2ggKENvbW1pdCBpZDogYmY0NDVlNjc0N2I1ODhhNzc0
ZjVlNDVmMmM5ZTBjZGFhMzE0MGQ3YykuDQo+IFJlc3VsdCBsb29rcyBnb29kIGhlbmNlLA0KPiBU
ZXN0ZWQtYnk6IExpeGlhbyBZYW5nIDxsaXhpYW8ueWFuZ0BpbnRlbC5jb20+DQo+DQo+DQo+Pj4g
SXQgbG9va3MgZmluZSB0byBtZSBhc2lkZSBmcm9tIHRoZSBwcmV2aW91cyByZXZpZXcgY29tbWVu
dHMgYW5kIG15Pj4+IG93biBzcGVsbGluZyBuaXQuwqDCoEkgYWxzbyBkb24ndCBzZWUgdGhhdCB0
aGlzIGFkZHMgYW55IGFkZGl0aW9uYWwNCj4+PiBjb25mbGljdHMgdnMgdGhlIGV4aXN0aW5nIGlv
bW11ZmQgaW50ZWdyYXRpb24gZm9yIGFueSBvdXRzdGFuZGluZw0KPj4+IHZmaW8gcGF0Y2hlcyBv
biB0aGUgbGlzdCwgdGhlcmVmb3JlLCB3aGVyZSB0aGVyZSdzIG5vdCBhbHJlYWR5IGEgc2lnbi1v
ZmYgZnJvbSBtZToNCj4+Pg0KPj4+IFJldmlld2VkLWJ5OiBBbGV4IFdpbGxpYW1zb24gPGFsZXgu
d2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPj4NCj4+IFRvIEFsZXg6IHRoYW5rcy4gYWJvdmUgYnJh
bmNoIGlzIGJhc2VkIG9uIEphc29uJ3MgZm9yLW5leHQuIFNvIG1heQ0KPj4gaGF2ZSBvbmUgbWlu
b3IgY29uZmxpY3Qgd2l0aCBiZWxvdyBjb21taXQgaW4geW91ciBuZXh0IGJyYW5jaC4NCj4+DQo+
PiB2ZmlvOiBSZW1vdmUgdmZpb19mcmVlX2RldmljZQ0KPg0KPiBCZXN0IHJlZ2FyZHMsDQo+IExp
eGlhbyBZYW5nDQoNCkdWVC1nIHRlc3QgcGFzc2VkIHdpdGggaHlicmlkIG1vZGUsIEdWVC1kIHRl
c3QgcGFzc2VkIHdpdGggY29tcGF0IG1vZGUuDQpUZXN0ZWQtYnk6IFl1IEhlIDx5dS5oZUBpbnRl
bC5jb20+DQotLQ0KDQpCZXN0IHJlZ2FyZHMsDQpIZSxZdQ0KDQo=
