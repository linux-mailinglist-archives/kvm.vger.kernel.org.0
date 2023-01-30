Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D0E680B1C
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 11:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235620AbjA3KmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 05:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235264AbjA3KmC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 05:42:02 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8395A31E09
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 02:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675075321; x=1706611321;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Sh08rYP3ugNepDnHpAYAgt4wZPaOfhOLnJjGYXpfAnA=;
  b=itBQCd7c1d+1rDKGpGAuXlZpbIFlXhzG0lFZExlj9HS1/BBGj1pCTTAZ
   M+UH+NSSg/gV6sMuopvcWaShIBgg/pHJuK3VgbXSgAwSFptWFpVzzFjx/
   mQMeY6QM4ycp1lEudTVa4Zvf0U1cys2gzi0CZXrct/JikdTXmjwDv/0fT
   XXS5w+w1tHNdNP6N94PcowMY/PY2hojNtpmSzP7RPpXqtG6Xt0FahaGGP
   NzF0O94L1UtL+cY0yTfigiAEcFPPQt7BJt7cIsefn+yepu7T2FUGhzloc
   4KTcnzhLyYKn89jDsqLs1X1EEuLy1TbylBD9oYArAdFiNeQs4J8iKVr1q
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="315486137"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="315486137"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 02:41:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="664051307"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="664051307"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 30 Jan 2023 02:41:58 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 02:41:57 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 02:41:57 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 02:41:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lm9MLNHB3dpCSMEmUl1ekdXny3eM7WbR6DWWMCajk1G8LpxJSqi/+L6lfDjaOxGm0UHZ2y/n9Mcj7ZU+3Pcoj1P1JTx4X9r8nN00abAA7dT+qLDtJnyjj+114hXqh0G4CEat6Q1qIdmzGZp+7+6ifw+bTVX21cUDzbdZGeut9DoT38UtZCHAZ6RHjB0LSnrKussIozGMINrm64df1ZApv/QS26Cee5FU4j0IMWz6sE4e1KAxdjFyltPVNxH11kZpirKK2jm7LhcP8sdIT4RpR6yKMwHAYethB1aVfnKklAsjFA+z3EicaqvcQoN1fDm4Yp8MmHtQZ9OgfQ7078UR1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sh08rYP3ugNepDnHpAYAgt4wZPaOfhOLnJjGYXpfAnA=;
 b=ECT680KFJa+XrQtSbNQDmjalFdoNsH9IXeaQM6EZHK1ZGLRJK7/s80AVTyBz27Le85axiOH8lZvOKyNJwwjTd2Vogx5SqAo/4rN3lCfWbipXjyLSx1JHJ4XV3EwlaWzR+CH8ZwqRtLwOnxVhiv+bjd2G/BYA/5vEm0EVoVSMp62ew/87AOQ9mvWyb1caqUZJv9zK+xILBcif/oClVh7RvAagoBjr9A++TimRLvKHQ8QTLV4eSMQRmp0OEkM6rR8A7Zz8ewMYR72jPdm5XH/GlmH5eT7Js9uTovT2MJZqNMpOmt0KJmlwzSH1KiA5COFeM5leugf14D62Ai52BhIT/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BN9PR11MB5385.namprd11.prod.outlook.com (2603:10b6:408:11a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 10:41:54 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 10:41:54 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 08/13] vfio: Block device access via device fd until
 device is opened
Thread-Topic: [PATCH 08/13] vfio: Block device access via device fd until
 device is opened
Thread-Index: AQHZKnqYE1wy2qbufkqZv2YFZFXODK6lx+MAgBERvRA=
Date:   Mon, 30 Jan 2023 10:41:54 +0000
Message-ID: <DS0PR11MB7529C7B7B718E4DD2DFF814EC3D39@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-9-yi.l.liu@intel.com>
 <17354dc1-82fe-e793-8266-73c47c1baf88@redhat.com>
In-Reply-To: <17354dc1-82fe-e793-8266-73c47c1baf88@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|BN9PR11MB5385:EE_
x-ms-office365-filtering-correlation-id: d96af46f-7295-436d-ef1e-08db02ae9a7c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0dF8dBAZBU63Q2EMcieHj5NsLDhLkg4h/zaWxTS9Be8MTAkjOxA1cpBPeLY+wxW+47DHGuZEu3VfaoCFBs/zzIRsKG0nViEgQEuBSlOSDs3YmQmmST93psnCdDKr05wpu3R4D31qkRFmw04cjdF/GPASyX9GSiNz2nvuh2IRIITS6KKHLiwPexiNYX7BqfXD7ofPNJlIZCwN8+g3Dq3BZ5jaj+lzY4Ko3x1bSCsjTHsgvn4QhIP9dIxKTazEypwS3tX6A7uMJS3cVOm+F9mPcbuKVHNyNAIOJ7g8R+EbyzkIPn8zxkQx79YdNcpX6gjuT+DElXhwWdpqbijYLQCzvejGMTJh/qPZejc0tS/NiSWBi1FdS6B2T0MtuAc5vy1yUnuBA1rbod/885MKL6CnTFg4O4mFQvYLW+qdobKgCBxU9WkRzz6RQlhz0zjYnLXSThg9X/YJQJ69UcAuoRKwBzScKo6ueJVVAK62k3n8jw6nsKPdz8HR6NZ8RAdaUJKmaHy1iYUxXfVjD0ca/Jw1lBnyt1QwIbcORW89AbIz7V4Cs4zq0hFrcGtqUThCy+U3umnQa0T+ZyI9FDbFR3JbtY5w6P5Lu9ObnUFm7xO5oUTs9tpaeNlA8LJV3Ez7Fn2LHM5l13+hMdOzNj/hwbc9QSsAKfbNn+IDoqT2zT8Wz1vZ19UD0XBOEfc/JITZrahFJePnKLom7acFxp8WCpL2H8CRp/OISd3YAlozLtFgcQc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(366004)(346002)(396003)(136003)(451199018)(8936002)(41300700001)(86362001)(4744005)(5660300002)(52536014)(38070700005)(7416002)(83380400001)(82960400001)(33656002)(110136005)(55016003)(54906003)(122000001)(316002)(66556008)(66476007)(66946007)(38100700002)(64756008)(66446008)(4326008)(76116006)(8676002)(26005)(9686003)(186003)(6506007)(7696005)(53546011)(71200400001)(478600001)(2906002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q294N3h1QVR4T25jdjFyK0dKZUdUaTBIZ2RSNERERE5jK2R5YU9MRk4yak5O?=
 =?utf-8?B?SXk3aFNHY2ZSMFc4OTQ4dUZQcFZsZGxYRDd4Y2d5V2ZmZVMzMHVVRUlqUVJ2?=
 =?utf-8?B?TlBqYUpaczdhc3VVaXBKdDEwQUU4WGNrV0tsN3hhT2RnUVpmYkV6enYyWUYy?=
 =?utf-8?B?ZW5mVUF2U1ZWQnVYVHVmWFBhV0kyK3VQRUhCaTNxbjB6bHVneS9CL1FnOWdp?=
 =?utf-8?B?RjZIZjM4bm5aZWZsZWswOG5lWXVYODZNaVhwcWNsUUNYaGVGV0U2UGdJYXRw?=
 =?utf-8?B?bG12VXRGd2xBclkzS05TZm5KMSs1UFlCWjVqNlUzYnI0WHlvaHIzRlpzQndY?=
 =?utf-8?B?L3NQNEVzaUFKZktFdk8rUnVmcllYbllRS1FJL2lYaXlFYS9HSnp4aStMVWhL?=
 =?utf-8?B?K01RejA2dlFweHpoRGdIeEd4K1JmWXAvYVhkKzQwL1JvUk5wUmw4OWlRTkUw?=
 =?utf-8?B?SzhkQ1dDNUdYN1BETkdrQlU2Wnp2WVhRRjJtMzZ0WS9PYWRHOHludXFiRXlQ?=
 =?utf-8?B?VDdCVkt0eitaRGVqTitwdXlTOGpGaFk4R0NHdGpsK0JITWpNeGtqWElUYXNT?=
 =?utf-8?B?VzRVNjMxTlZvbWkwdWs3Sjd2UGhxN3dlMU5ZYkF2UzRYOGZmT252a1ZWckhI?=
 =?utf-8?B?ZERFYWYvQ0lpazE5UzhPZ1dDL0tMM2lMVmpSMmwwZS9VQnNEVlZ4K241Tm1w?=
 =?utf-8?B?dFBWYjRRR0JZNzJFRys4RHo2MlJKNkx2WUUraWNuY3pVaGVUbVhBc3gxNEdT?=
 =?utf-8?B?MitzUlIxNHhzTkdjWTdhdk5WdXdkd0hOOHNGWC9FM0ZmamVmVFlYRTFyRGJN?=
 =?utf-8?B?clowMzZxZGxvdktWY0hMTnZiSHNEZmZIRWE5WFYvWDVHVjltMkw1QlFRS0hv?=
 =?utf-8?B?MjhSVWNydmgycEl0YWt2NUtXU2NTejFvTmVQTzBKVXNaTWROdU1Gd3ROM0li?=
 =?utf-8?B?Q3hPSFFKNzNtTVBORS9ldmVLNkhKN05uc0Q5TFJ0Rlp1YnFSMG5uc0JEcG53?=
 =?utf-8?B?TGJHZnZRRHFBU3NWSTZyNUxMQlFSbTNOQlc3ek9JZ2dOTEY5K0FvM1FFbU5z?=
 =?utf-8?B?K1ozSFVYSjgyclRSbXBkbWxZVnJvRTlyS0NtWUYrQURzUHFqVHdIUmNXTjRY?=
 =?utf-8?B?UTRZL0hDM3ZTSysyWHhnVlpsQjZTM1RSSDBxbmRzOFMrMWNocEVvT1VFRUZU?=
 =?utf-8?B?OCtVaDlQcUxiV1lrY2Nya0FUVHR6ajFkdy9Qd3pIdFNPVDhkQzRLMU10NUVX?=
 =?utf-8?B?MmpzWmVTTFV6RitwY1prRG1NSzNOMG1EckRobElIa0tjbHh5WXdKU2ZHakVU?=
 =?utf-8?B?R1ZCTU0rTStuTkRXdlZkbWFncEc0ZFdzTDZJcUdIdFgwdTFSSm9TdEpyVUFT?=
 =?utf-8?B?YnpRSWMzY0NsdlN6T1VkYXJ0NDlqajdWNHdkT1VKMHdRL25pRUtzaGM4WGh5?=
 =?utf-8?B?eVZKb1FsRzhZOGpCTHJINjd2TGVvV0MzK0dLYkVZd1lEelBtZjFJQUJycWNP?=
 =?utf-8?B?dW05MnA1TEhGNGhKYWZBT0hSL2R5Sm1xeEI2NzlYSjRRRkNGVWlqUlUrWE5E?=
 =?utf-8?B?M1pHdXJMUWZ2MENTOTVLL0djR1FyWm1FRU5zUVZ1NllWWFBBRzBkbWpndXF1?=
 =?utf-8?B?YkczNFhvQ0U5aUxEcTlSaXpJMXVvdUNQVWlSU2lMWnZnMEc1aVZWalROYklk?=
 =?utf-8?B?UUxxcllUVGJzbzJYajdSWEs1ODJiU1NNaUtYT3RLSTI2b2JLL2tib0l5U0NV?=
 =?utf-8?B?NS80VzBMY2xXdTBUZ0hvZ1JONzFHSnh4cnBiTyt4MGpyWTV5LzVuRHFpUzRj?=
 =?utf-8?B?L2h1MDZDWE5DbU9mcUZiejFjNnVqMVhDTVFRZTNiUHBRUlI0YW45UlhvZjZ4?=
 =?utf-8?B?bDZWMkluZ2s4K3U1bjcxRzBCalB4eFNuQlNZNWNLNHhlc2M1MGNrNDI3MnMx?=
 =?utf-8?B?d2ROaWNOSi9CSzdIOFBORjJSczdZcndjMVAvZFI0S2lNMDJic0EzZlBWNEFm?=
 =?utf-8?B?U282ZVNMcEdXSGJVRnpzVHdGR1RiRndnSWM2RXl6ZlBDUWZnOWpxRWkvR0Iv?=
 =?utf-8?B?YUtiVkpzMUo4VldRM3lTNnR2RU9PTGtmY3U2NnB6eCt1ZTB5NU1BRmZxQ29K?=
 =?utf-8?Q?hq+hsb4p6oxIhlUykMRrCPZD5?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d96af46f-7295-436d-ef1e-08db02ae9a7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 10:41:54.1876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ebhr5FxOeNvYVsWMx+4oolop4bq7DZKkRvN+wlg03VlPlFFzqtNG/VDuoWski3tMyvgir1A+gCpqxFMtFKJzLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5385
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

PiBGcm9tOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+IFNlbnQ6IFRodXJz
ZGF5LCBKYW51YXJ5IDE5LCAyMDIzIDEwOjAxIFBNDQo+IA0KPiBIaSBZaSwNCj4gDQo+IE9uIDEv
MTcvMjMgMTQ6NDksIFlpIExpdSB3cm90ZToNCj4gPiBBbGxvdyB0aGUgdmZpb19kZXZpY2UgZmls
ZSB0byBiZSBpbiBhIHN0YXRlIHdoZXJlIHRoZSBkZXZpY2UgRkQgaXMNCj4gPiBvcGVuZWQgYnV0
IHRoZSBkZXZpY2UgY2Fubm90IGJlIHVzZWQgYnkgdXNlcnNwYWNlIChpLmUuDQo+IGl0cyAub3Bl
bl9kZXZpY2UoKQ0KPiA+IGhhc24ndCBiZWVuIGNhbGxlZCkuIFRoaXMgaW5iZXR3ZWVuIHN0YXRl
IGlzIG5vdCB1c2VkIHdoZW4gdGhlIGRldmljZQ0KPiA+IEZEIGlzIHNwYXduZWQgZnJvbSB0aGUg
Z3JvdXAgRkQsIGhvd2V2ZXIgd2hlbiB3ZSBjcmVhdGUgdGhlIGRldmljZSBGRA0KPiA+IGRpcmVj
dGx5IGJ5IG9wZW5pbmcgYSBjZGV2IGl0IHdpbGwgYmUgb3BlbmVkIGluIHRoZSBibG9ja2VkIHN0
YXRlLg0KPiBQbGVhc2UgZXhwbGFpbiB3aHkgdGhpcyBpcyBuZWVkZWQgaW4gdGhlIGNvbW1pdCBt
ZXNzYWdlIChhbHRob3VnaCB5b3UNCj4gZXZva2VkIHRoZSByYXRpb25hbGUgaW4gdGhlIGNvdmVy
IGxldHRlcikuDQoNClN1cmUuIA0KDQpSZWdhcmRzLA0KWWkgTGl1DQo=
