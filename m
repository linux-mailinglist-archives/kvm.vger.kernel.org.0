Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABB914E5EEC
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 07:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244201AbiCXGsR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 02:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348293AbiCXGsB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 02:48:01 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD1090273
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 23:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648104390; x=1679640390;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Bu1HGDrJWMdUzFyz0LNCWSF6F8PiEgY/ZCEY1E8+H8s=;
  b=jsfRLPp/MBLuPlGVAf4VSGN0xUQNROJoW1UK74C0LWNcp7FYFyGNl3T+
   x9BqrpfLPi5Xa2bPr7g8nJrPw4XqUDN1KyrGhc35zg0yUhWqyIDY6o992
   QbaNTBIx2/qINiTdgfRzg97vF/Z17f5BDAy6mc23bz4FfXAMPlQVnfhVS
   YxflhxPjzDLVTVRzAewQVfHewMtBnnOg8p6YmI58/m2/ozP2lMCvAoJD6
   JSUtGFXDRaeztzm6Z9z0t9oytZ2ZH8Tb6+oLqyFZiqhYhmUEWLt/7FXxg
   +3CTgectB2XKkWYb3nKVkTmQRr9Nv5ZEuLmIDrG7PdiKIYCp1gdnlGJwi
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10295"; a="321495566"
X-IronPort-AV: E=Sophos;i="5.90,206,1643702400"; 
   d="scan'208";a="321495566"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 23:46:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,206,1643702400"; 
   d="scan'208";a="647758024"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga002.fm.intel.com with ESMTP; 23 Mar 2022 23:46:29 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 23 Mar 2022 23:46:29 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 23 Mar 2022 23:46:29 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Wed, 23 Mar 2022 23:46:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mi1xjRqNkYPlH3iTLha4SJ4BB8VJM9tVWBNUK7Bj6TVXAKD2G6s2fHD0LesQD/n5Fn6jSye83x0y+DDOGf/zMFSvdeVKrX+8PLMIyA7lM9i/CTOnG6+qCPZzkPJLGjOOcr6dB1moo6NzUDSAQEllFloXygr7UT/aIpNAJPdq2JJy0DyWSDmx6ZikxDj/M4gFU56YmK1pU/j15evFmnm08IvuQqZmM4mTYrae8pW/rMOvQjPlXJytY6aT3sQ5ziHWQxCh/GtX7+9TAwg77x0wV9FpUg3w2eTENF0lIxeu+L1G6G0Pm/3mZ1t7QxtPyCQ8+MGeoBaN9801YcCwkok6yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bu1HGDrJWMdUzFyz0LNCWSF6F8PiEgY/ZCEY1E8+H8s=;
 b=Y/nUE/nG2oOrZo57NZO8CHrPaDsXw35YrVXfxYuApzhtSI/1kvkqeG4VuhSojjZEFPq9mbpPxaDy9nVxO/F2TUV6w+G+/FFAhq8l+U2ZLXQWnNlMLXcXWlZ44zFZNiIvlYP3q/6cOzCkmoMhG9yCMVJNLKIjSJJrwUCohatdjetG1szp+L4rwjSXgA1FshYojC0oqz9EWFu/Erm7jedj2JHexDVbyllxDfdkOg1jxOB9FDAl1J2q4POtn37Kot8GyxpqsUO2Vz7iMvMgP0XsyZPEburhHVVVUGE28r6g62cAElC71C5TRJuIckZCJ/5nOuiVGfDkXNJ/NUhWsSd//g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW3PR11MB4603.namprd11.prod.outlook.com (2603:10b6:303:5e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.19; Thu, 24 Mar
 2022 06:46:27 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0%4]) with mapi id 15.20.5102.018; Thu, 24 Mar 2022
 06:46:27 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: RE: [PATCH RFC 08/12] iommufd: IOCTLs for the io_pagetable
Thread-Topic: [PATCH RFC 08/12] iommufd: IOCTLs for the io_pagetable
Thread-Index: AQHYOu2GUDY5OA7cJEqND2xJuT5HJqzNXYEAgAAGtoCAAAhqAIAACEAAgACosnA=
Date:   Thu, 24 Mar 2022 06:46:27 +0000
Message-ID: <BN9PR11MB52765BB2D7AE4F985B987F908C199@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <8-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <20220323131038.3b5cb95b.alex.williamson@redhat.com>
 <20220323193439.GS11336@nvidia.com>
 <20220323140446.097fd8cc.alex.williamson@redhat.com>
 <20220323203418.GT11336@nvidia.com>
In-Reply-To: <20220323203418.GT11336@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae65d68e-02ba-45fb-4051-08da0d620547
x-ms-traffictypediagnostic: MW3PR11MB4603:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MW3PR11MB460326FFFC5683B6C52A99248C199@MW3PR11MB4603.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1Uw8DTHEk+GbsT2po8jJwiZm+/cCt8gJUO/7KunHUu4V+ryAULdeJ8Cxp/e76J6OurUaDg9F1ZEh/QC8TVRpSOeQ8M03JV2L3I9hzSyE+pw/yhhwe1nnupdjOpo6j9fhwu5q+7M9Zgh/5L0bh3WluWVFfaRVUadwB+IXTspWpVSPWjGslBZgS3p0k44h54h7CPQlq+2scTOh1Bl9Gtu09DKRR28IptXe7N5AFzaqo9zxGmakmf+PD9ozQw8uIIHBX6cr+HQ4ucQqqlMtn/ED6VJH047NchwKEFBpbaILdqKe1Z7rLVXiQtctKGwAoVvlAzOpGG7Fy7wNfRhOfWGWgJ4THY8K3h7kNvUScx/cc8wGliefceZ6l7M/cGwtAEHhUpnAts3aKbCbN7Ibq/nnTotspkEkPPhOTk6gOXM0gZmP+QuN4X6vZ4kgFGkx3Gx7bS3ZoFu2OG51JyRAkcNlVSHv5iNMQqJkshG/xfBiiueg3se0hXHMNkMfiMj3GkPbxCUAWQREC8Cu5ME0kUWU/1//LqElgBcixK6MLHX1/ouenuOrJTWtDsDclPRNM0D+Tc/RG6wcBAh9lans/H9bmzcn95Q5JC5uXkC87PY+t34DyakWhmwFUSX/sm8Hf06d51Mk3NYY1b69zXlLtwJYMEUgMpUrNmdCx3XV/QAkzu8chrWYDoDs5GrIXdxnCDkEK1ZSpWV57EMLMBX85w5ZNQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(2906002)(83380400001)(8936002)(52536014)(76116006)(8676002)(66556008)(64756008)(66476007)(66946007)(66446008)(55016003)(26005)(186003)(7696005)(508600001)(6506007)(33656002)(9686003)(71200400001)(82960400001)(38070700005)(122000001)(86362001)(316002)(7416002)(54906003)(110136005)(5660300002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WHZ3ZTZWUDh5Y2UwWWRLWU5weDJFU1RQbmVJelpoc284a3BmLytjRmtLUXZH?=
 =?utf-8?B?RXlTVkRXWnVVbTh2d08rVVdhelB2SjZEb1dNWlZhZXc2TFdUOUFiVXM3eXlz?=
 =?utf-8?B?Y2ZlMCtnL3NkTUJ4dks1ZGhNSnM0VENVd1gvejJ1TXlCY3dpK2dDS01Rb2Fu?=
 =?utf-8?B?S1VKOUlaSkxsbG1UbC9ocUhGalNLaG1nMlpLU2FhSUpmdXp6QUFjS3ZqMjRt?=
 =?utf-8?B?SER1SGsvNnYyMUozbXkyNE9sRWhmei9VUEZNTmVDNlNFSHlxT0l6NkZiWWU2?=
 =?utf-8?B?RjBLWGQ3QjNTUVVFUUtsdGgyZzFXQ1FRWVJyN0R6dmp2QTQ0RytCZE9DQWFC?=
 =?utf-8?B?U0tQaGtwU1ArVzM5QWRSaHY4QmpiWFFEM2FOMkh1d0ltL3ROWWdrN2FGQTN5?=
 =?utf-8?B?c2JWWU9ETkd3U3pGQ20zSDluTmwyMk1SemVGL1oxdzVjejk5TFdCejBvT0cz?=
 =?utf-8?B?MlJGZ1Q5Y1prcnZwMEpvWGtmOUNXTHlnWThndy9PbFpKQm5LNW0xekZnYnZi?=
 =?utf-8?B?YjFTK3pnUEF5eXZhVjdNVVB3NFkveUhma0pHWWFSaHVIKzBPNm5Ha29Gek1S?=
 =?utf-8?B?VGYyaHZ3ZEZ1a3NGOG1adzh3NUo2eUg1S0RPOU1rYXJ4N3Fxa0dBT2Q5aVB5?=
 =?utf-8?B?MFNWQUp4S1dEbks3Q0R0WVhnZG00TFdqZ2pPR05pVlVDeDhkUTIrSmR5RXpi?=
 =?utf-8?B?UDJtYnMrZ0E4R1Z5K0dqTUJFMTg0bjhEYzVzNUFDUzNVL3A2N1J0anlYcWph?=
 =?utf-8?B?MGQ3eDM2eDUvTXFMaEdCZGdMR3F0SjNQWkh2djA4SUw5aUtOTkhYbnp2Q0JI?=
 =?utf-8?B?T1loRG93SkxJQlJwbDBlcmF0cE4yY2NLNTBvUVVXZG53ckNpTS8vQ2ovVGRC?=
 =?utf-8?B?T1NKR0tVcmlhZk5OcW5yUVFaa2ZHWjJUVlpPZVQxU2czTzhKc0tNSXZLSUo3?=
 =?utf-8?B?THA4QWQ2bGZRNFhiSjFxenVOK1h5bXlBSmVCSTBSbzdlNGpkTlViaHl6VE9s?=
 =?utf-8?B?OUljam5jbG5EdmFYQWhwU3A1RVplb016UnVOVzFXQzVKc200bnU0U2tTaE1I?=
 =?utf-8?B?eUl1aGlUL1VxTnUrNG96QzE2aTFYamNPdlNsd2V2V2JDMjV2d3lRdVZJVi9X?=
 =?utf-8?B?RHdDM0JHRzUrbExlQ2ZwekFzSU9RSXhoZXVjV2RqOFh4ZVBYREMzQUZtWTRC?=
 =?utf-8?B?R0t1U2E0QVJzY25vOStKNk1XR1BXeHM0dFhtRldiUjlxbllQd1VjRktiS3h2?=
 =?utf-8?B?VnRuM0Vhb2F5blNIWEhhaDZUaThYV1pZZUpQVFZTOEFUSE42NlhZazdXL2Jk?=
 =?utf-8?B?cTdQSmhucGhCaU41bzg0RVZyVzVsZXF4dnRDMHpKNDd1ajRtYmJyWUpQODI2?=
 =?utf-8?B?aVJ3SlJlNDNaTkFrZVVGSDJ3b0dtL1gxOS9vVnVEalpTdW9JNVFUQ09wZGlU?=
 =?utf-8?B?TFFkOU1RekNnMW80bHVFaDhmZzhFaERQdHZsTXJYZDhVQ2NUK0kwRHpKTlgr?=
 =?utf-8?B?ZnM5cytqMGtWVDRsOFFlL3pwQzVLS3loY0Y1V0NIZHhtVTQ1MTdBQytBblFV?=
 =?utf-8?B?MXpSUjhwMVkrZnI1K2dwSHlMVnFiSklGL2NNQ1k2RDJheGt1WmV6SjNBcWJx?=
 =?utf-8?B?TVRTeUdKNWVMZW1lbUY3NEd0YlFoQUlBSktYZlQ3RDhFWE5LeFROWkFBTjJ3?=
 =?utf-8?B?VDA0bmNHZWdZVDhyTUxjeGllRDhkWWhqOGxHbjBNMm1zNldydU1iaTMwWmR5?=
 =?utf-8?B?OS8ySFZpMXNIeVA4VnQyN0tMY05pdXdMMEFhcnRmeFFkYmVldmlaWXY0TzdD?=
 =?utf-8?B?OXlhUFNrazlKczFaTzdGQ1g4TmVuZk5zSWVzL1NXL2JUN0hRNE45eFlZVUZN?=
 =?utf-8?B?QXRPdVF3dGJVTzNlRmNuVlZaRGhoSjh1cmZUZmRXTktkQmpCY0J4eEkyaEpt?=
 =?utf-8?Q?ChTx9BsikBj2gAJz1vqf1lwbNpQI0yHN?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae65d68e-02ba-45fb-4051-08da0d620547
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2022 06:46:27.1608
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gWq19bltblss6HVNfJC8u3Ptb66WKRP2obK34FcW/SBQyto7NvAxVhgJqrn8/QLOawpL18uRXg5MUFMNd9iwBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4603
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBUaHVyc2Rh
eSwgTWFyY2ggMjQsIDIwMjIgNDozNCBBTQ0KPiANCj4gT24gV2VkLCBNYXIgMjMsIDIwMjIgYXQg
MDI6MDQ6NDZQTSAtMDYwMCwgQWxleCBXaWxsaWFtc29uIHdyb3RlOg0KPiA+IE9uIFdlZCwgMjMg
TWFyIDIwMjIgMTY6MzQ6MzkgLTAzMDANCj4gPiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEu
Y29tPiB3cm90ZToNCj4gPg0KPiA+ID4gT24gV2VkLCBNYXIgMjMsIDIwMjIgYXQgMDE6MTA6MzhQ
TSAtMDYwMCwgQWxleCBXaWxsaWFtc29uIHdyb3RlOg0KPiA+ID4gPiBPbiBGcmksIDE4IE1hciAy
MDIyIDE0OjI3OjMzIC0wMzAwDQo+ID4gPiA+IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5j
b20+IHdyb3RlOg0KPiA+ID4gPg0KPiA+ID4gPiA+ICtzdGF0aWMgaW50IGNvbnZfaW9tbXVfcHJv
dCh1MzIgbWFwX2ZsYWdzKQ0KPiA+ID4gPiA+ICt7DQo+ID4gPiA+ID4gKwlpbnQgaW9tbXVfcHJv
dDsNCj4gPiA+ID4gPiArDQo+ID4gPiA+ID4gKwkvKg0KPiA+ID4gPiA+ICsJICogV2UgcHJvdmlk
ZSBubyBtYW51YWwgY2FjaGUgY29oZXJlbmN5IGlvY3RscyB0byB1c2Vyc3BhY2UNCj4gYW5kIG1v
c3QNCj4gPiA+ID4gPiArCSAqIGFyY2hpdGVjdHVyZXMgbWFrZSB0aGUgQ1BVIG9wcyBmb3IgY2Fj
aGUgZmx1c2hpbmcNCj4gcHJpdmlsZWdlZC4NCj4gPiA+ID4gPiArCSAqIFRoZXJlZm9yZSB3ZSBy
ZXF1aXJlIHRoZSB1bmRlcmx5aW5nIElPTU1VIHRvIHN1cHBvcnQNCj4gQ1BVIGNvaGVyZW50DQo+
ID4gPiA+ID4gKwkgKiBvcGVyYXRpb24uDQo+ID4gPiA+ID4gKwkgKi8NCj4gPiA+ID4gPiArCWlv
bW11X3Byb3QgPSBJT01NVV9DQUNIRTsNCj4gPiA+ID4NCj4gPiA+ID4gV2hlcmUgaXMgdGhpcyBy
ZXF1aXJlbWVudCBlbmZvcmNlZD8gIEFJVUkgd2UnZCBuZWVkIHRvIHRlc3QNCj4gPiA+ID4gSU9N
TVVfQ0FQX0NBQ0hFX0NPSEVSRU5DWSBzb21ld2hlcmUgc2luY2UgZnVuY3Rpb25zIGxpa2UNCj4g
PiA+ID4gaW50ZWxfaW9tbXVfbWFwKCkgc2ltcGx5IGRyb3AgdGhlIGZsYWcgd2hlbiBub3Qgc3Vw
cG9ydGVkIGJ5IEhXLg0KPiA+ID4NCj4gPiA+IFlvdSBhcmUgcmlnaHQsIHRoZSBjb3JyZWN0IHRo
aW5nIHRvIGRvIGlzIHRvIGZhaWwgZGV2aWNlDQo+ID4gPiBiaW5kaW5nL2F0dGFjaCBlbnRpcmVs
eSBpZiBJT01NVV9DQVBfQ0FDSEVfQ09IRVJFTkNZIGlzIG5vdCB0aGVyZSwNCj4gPiA+IGhvd2V2
ZXIgd2UgY2FuJ3QgZG8gdGhhdCBiZWNhdXNlIEludGVsIGFidXNlcyB0aGUgbWVhbmluZyBvZg0K
PiA+ID4gSU9NTVVfQ0FQX0NBQ0hFX0NPSEVSRU5DWSB0byBtZWFuIHRoZWlyIHNwZWNpYWwgbm8t
c25vb3ANCj4gYmVoYXZpb3IgaXMNCj4gPiA+IHN1cHBvcnRlZC4NCj4gPiA+DQo+ID4gPiBJIHdh
bnQgSW50ZWwgdG8gc3BsaXQgb3V0IHRoZWlyIHNwZWNpYWwgbm8tc25vb3AgZnJvbSBJT01NVV9D
QUNIRSBhbmQNCj4gPiA+IElPTU1VX0NBUF9DQUNIRV9DT0hFUkVOQ1kgc28gdGhlc2UgdGhpbmdz
IGhhdmUgYSBjb25zaXNlbnQNCj4gbWVhbmluZyBpbg0KPiA+ID4gYWxsIGlvbW11IGRyaXZlcnMu
IE9uY2UgdGhpcyBpcyBkb25lIHZmaW8gYW5kIGlvbW11ZmQgc2hvdWxkIGJvdGgNCj4gPiA+IGFs
d2F5cyBzZXQgSU9NTVVfQ0FDSEUgYW5kIHJlZnVzZSB0byB3b3JrIHdpdGhvdXQNCj4gPiA+IElP
TU1VX0NBUF9DQUNIRV9DT0hFUkVOQ1kuICh1bmxlc3Mgc29tZW9uZSBrbm93cyBvZg0KPiBhbiAh
SU9NTVVfQ0FDSEUNCj4gPiA+IGFyY2ggdGhhdCBkb2VzIGluIGZhY3Qgd29yayB0b2RheSB3aXRo
IHZmaW8sIHNvbWVob3csIGJ1dCBJIGRvbid0Li4pDQo+ID4NCj4gPiBJSVJDLCB0aGUgRE1BUiBv
biBJbnRlbCBDUFVzIGRlZGljYXRlZCB0byBJR0Qgd2FzIHdoZXJlIHdlJ2Qgb2Z0ZW4gc2VlDQo+
ID4gbGFjayBvZiBzbm9vcC1jb250cm9sIHN1cHBvcnQsIGNhdXNpbmcgdXMgdG8gaGF2ZSBtaXhl
ZCBjb2hlcmVudCBhbmQNCj4gPiBub24tY29oZXJlbnQgZG9tYWlucy4gIEkgZG9uJ3QgcmVjYWxs
IGlmIHlvdSBnbyBiYWNrIGZhciBlbm91Z2ggaW4gVlQtZA0KPiA+IGhpc3RvcnkgaWYgdGhlIHBy
aW1hcnkgSU9NTVUgbWlnaHQgaGF2ZSBsYWNrZWQgdGhpcyBzdXBwb3J0LiAgU28gSQ0KPiA+IHRo
aW5rIHRoZXJlIGFyZSBzeXN0ZW1zIHdlIGNhcmUgYWJvdXQgd2l0aCBJT01NVXMgdGhhdCBjYW4n
dCBlbmZvcmNlDQo+ID4gRE1BIGNvaGVyZW5jeS4NCj4gPg0KPiA+IEFzIGl0IGlzIHRvZGF5LCBp
ZiB0aGUgSU9NTVUgcmVwb3J0cyBJT01NVV9DQVBfQ0FDSEVfQ09IRVJFTkNZIGFuZA0KPiBhbGwN
Cj4gPiBtYXBwaW5ncyBtYWtlIHVzZSBvZiBJT01NVV9DQUNIRSwgdGhlbiBhbGwgRE1BIGlzIGNv
aGVyZW50LiAgQXJlIHlvdQ0KPiA+IHN1Z2dlc3RpbmcgSU9NTVVfQ0FQX0NBQ0hFX0NPSEVSRU5D
WSBzaG91bGQgaW5kaWNhdGUgdGhhdCBhbGwNCj4gbWFwcGluZ3MNCj4gPiBhcmUgY29oZXJlbnQg
cmVnYXJkbGVzcyBvZiBtYXBwaW5nIHByb3RlY3Rpb24gZmxhZ3M/ICBXaGF0J3MgdGhlIHBvaW50
DQo+ID4gb2YgSU9NTVVfQ0FDSEUgYXQgdGhhdCBwb2ludD8NCj4gDQo+IElPTU1VX0NBUF9DQUNI
RV9DT0hFUkVOQ1kgc2hvdWxkIHJldHVybiB0byB3aGF0IGl0IHdhcyBiZWZvcmUgSW50ZWwncw0K
PiBjaGFuZ2UuDQoNCk9uZSBuaXQgKGFzIEkgZXhwbGFpbmVkIGluIHByZXZpb3VzIHYxIGRpc2N1
c3Npb24pLiBJdCBpcyBub3QgdGhhdCBJbnRlbA0KYWJ1c2VzIHRoaXMgY2FwYWJpbGl0eSBhcyBp
dCB3YXMgZmlyc3RseSBpbnRyb2R1Y2VkIGZvciBJbnRlbCdzIGZvcmNlIA0Kc25vb3AgcmVxdWly
ZW1lbnQuIEl0IGlzIGp1c3QgdGhhdCB3aGVuIGxhdGVyIGl0cyBtZWFuaW5nIHdhcyBjaGFuZ2Vk
DQp0byBtYXRjaCB3aGF0IHlvdSBkZXNjcmliZWQgYmVsb3cgdGhlIG9yaWdpbmFsIHVzZSBvZiBJ
bnRlbCB3YXMgbm90DQpjYXVnaHQgYW5kIGZpeGVkIHByb3Blcmx5LiDwn5iKDQoNCj4gDQo+IEl0
IG9ubHkgbWVhbnMgbm9ybWFsIERNQXMgaXNzdWVkIGluIGEgbm9ybWFsIHdheSBhcmUgY29oZXJl
bnQgd2l0aCB0aGUNCj4gQ1BVIGFuZCBkbyBub3QgcmVxdWlyZSBzcGVjaWFsIGNhY2hlIGZsdXNo
aW5nIGluc3RydWN0aW9ucy4gaWUgRE1BDQo+IGlzc3VlZCBieSBhIGtlcm5lbCBkcml2ZXIgdXNp
bmcgdGhlIERNQSBBUEkuDQo+IA0KPiBJdCBkb2VzIG5vdCBtZWFuIHRoYXQgbm9uLWNvaGVyZW5j
ZSBETUEgZG9lcyBub3QgZXhpc3QsIG9yIHRoYXQNCj4gcGxhdGZvcm0gb3IgZGV2aWNlIHNwZWNp
ZmljIHdheXMgdG8gdHJpZ2dlciBub24tY29oZXJlbmNlIGFyZSBibG9ja2VkLg0KPiANCj4gU3Rh
dGVkIGFub3RoZXIgd2F5LCBhbnkgcGxhdGZvcm0gdGhhdCB3aXJlcyBkZXZfaXNfZG1hX2NvaGVy
ZW50KCkgdG8NCj4gdHJ1ZSwgbGlrZSBhbGwgeDg2IGRvZXMsIG11c3Qgc3VwcG9ydCBJT01NVV9D
QUNIRSBhbmQgcmVwb3J0DQo+IElPTU1VX0NBUF9DQUNIRV9DT0hFUkVOQ1kgZm9yIGV2ZXJ5IGlv
bW11X2RvbWFpbiB0aGUgcGxhdGZvcm0NCj4gc3VwcG9ydHMuIFRoZSBwbGF0Zm9ybSBvYnZpb3Vz
bHkgZGVjbGFyZXMgaXQgc3VwcG9ydCB0aGlzIGluIG9yZGVyIHRvDQo+IHN1cHBvcnQgdGhlIGlu
LWtlcm5lbCBETUEgQVBJLg0KDQpUaGlzIGlzIGEgZ29vZCBleHBsYW5hdGlvbiBvZiBJT01NVV9D
QUNIRS4gRnJvbSB0aGF0IGludGVsLWlvbW11DQpkcml2ZXIgc2hvdWxkIGFsd2F5cyByZXBvcnQg
dGhpcyBjYXBhYmlsaXR5IGFuZCBkbyBub3RoaW5nIHdpdGgNCklPTU1VX0NBQ0hFIHNpbmNlIGl0
J3MgYWxyZWFkeSBndWFyYW50ZWVkIGJ5IHRoZSBhcmNoLiBBY3R1YWxseQ0KdGhpcyBpcyBleGFj
dGx5IHdoYXQgQU1EIGlvbW11IGRyaXZlciBkb2VzIHRvZGF5Lg0KDQpUaGVuIHdlJ2xsIGludHJv
ZHVjZSBhIG5ldyBjYXAvcHJvdCBpbiBwYXJ0aWN1bGFyIGZvciBlbmZvcmNpbmcgc25vb3ANCmFz
IHlvdSBzdWdnZXN0ZWQgYmVsb3cuDQoNCj4gDQo+IFRodXMsIGEgbmV3IGNhcCBpbmRpY2F0aW5n
IHRoYXQgJ2FsbCBkbWEgaXMgY29oZXJlbnQnIG9yICduby1zbm9vcA0KPiBibG9ja2luZycgc2hv
dWxkIGJlIGNyZWF0ZWQgdG8gY292ZXIgSW50ZWwncyBzcGVjaWFsIG5lZWQuIEZyb20gd2hhdCBJ
DQo+IGtub3cgaXQgaXMgb25seSBpbXBsZW1lbnRlZCBpbiB0aGUgSW50ZWwgZHJpdmVyIGFuZCBh
cHBhcmVudGx5IG9ubHkNCj4gZm9yIHNvbWUgSU9NTVVzIGNvbm5lY3RlZCB0byBJR0QuDQo+IA0K
PiA+ID4gWWVzLCBpdCB3YXMgbWlzc2VkIGluIHRoZSBub3RlcyBmb3IgdmZpbyBjb21wYXQgdGhh
dCBJbnRlbCBuby1zbm9vcCBpcw0KPiA+ID4gbm90IHdvcmtpbmcgY3VycmVudGx5LCBJIGZpeGVk
IGl0Lg0KPiA+DQo+ID4gUmlnaHQsIEkgc2VlIGl0IGluIHRoZSBjb21tZW50cyByZWxhdGl2ZSB0
byBleHRlbnNpb25zLCBidXQgbWlzc2VkIGluDQo+ID4gdGhlIGNvbW1pdCBsb2cuICBUaGFua3Ms
DQo+IA0KPiBPaCBnb29kLCBJIHJlbWVtYmVyZWQgaXQgd2FzIHNvbWVwbGFjZS4uDQo+IA0KDQpU
aGFua3MNCktldmluDQo=
