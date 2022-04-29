Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C27CE513FC0
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 02:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353409AbiD2At2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 20:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353278AbiD2AtU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 20:49:20 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9246C8879D
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 17:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651193164; x=1682729164;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IABA/Dtf7lCJ33c0U1v1myXz0SA4As181hNUY35yBuU=;
  b=aW+yd8ulIOKOsuvJM1KG+MA5WshQ/lYP/BD9lGKxiOP4e/eHLtaPtl3F
   yo/EgBR2UfrwtmQ/lb25oVw3/8xEEtKSISkg2mojjg5GL6BEsy44ur35Z
   NSCebCjp9GVbvDcYoEzV776No7YMSQGABWcESylkejaBUt8CkhCzZo5Ck
   9w13cUmoM51EXLk+xerNcAeFcPiDjm418vQIra9/+o66rY/OIXK8YG1Pp
   Y0DwJhImOi6l70r0ikakhy3nWnx1+D2gj8BE9deIFHUV+K1btUcAcmxiO
   UB9wMrEEgjmpgDc77AiCNnQPabmR1BzDLK6BTgaarl/ZurCeP3OYsr6O7
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="264065844"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="264065844"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 17:46:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="683635781"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga004.jf.intel.com with ESMTP; 28 Apr 2022 17:46:03 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 28 Apr 2022 17:46:02 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 28 Apr 2022 17:46:02 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 28 Apr 2022 17:46:02 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 28 Apr 2022 17:46:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h1DP7m7V64SsDKsnbZpQwqGtJkMtwyxA7r51gdxGkaGSCNXNnsWYW53/Y422dyteGDHIbs3TdXzs19eN5WiDxcKUp+3VYkBFosPoq5p0ZfSbrzCjTNIpd0/D+q/Ca2UDQFZQv54+YXvtFp3iuMqA/KMl1hZOS9zXl8cLsOndNt5bGOvFZ/ZF0HjFbDEMq0Q4NSgBuPEJt79xyX58LXDSIzYDdq/32G13Dhjrrh62eYZ9qykb8pmOdlGV6irJmIRm5ukUVgI85XAb81PsmN+mO86U+MxTlPS6eQj1645fCTQafa9tGYNPIkBd4ELsOqc/743E87sI4YTY1b2dXnt8Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IABA/Dtf7lCJ33c0U1v1myXz0SA4As181hNUY35yBuU=;
 b=ldP48w7urYql4n5v4y3OssdzLO9Eot6IsUeu4PpFYT9Mt1MDOrzYs6m0Kuprd1WZAx7YXJeZIAL82QHjc8o1Pa3cr9vkOZb6rt35ZcY1bQIMB/jPbbrBkEGZJwLgbqccoBRT1dL3wkVlDd97NMWrER1SuT5CaRdGDeRjQz3Htk2QWExVHk+/yNkf3wjOmqsuc4VWtSoA2l1uG9NYTTuAodye8htLVd0axS0o2cKNICCac4bAMS6PAyzCYLW2ORdXoePj4hvQU1luIlVVHNGU34qqL5Jpg3S69qVsWJzTL80xQ+8KAA9/SammYW1n68y4FWGzc5PzLAs2yPwlmJDkig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY4PR11MB1432.namprd11.prod.outlook.com (2603:10b6:910:5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Fri, 29 Apr
 2022 00:45:55 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 00:45:54 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     =?utf-8?B?RGFuaWVsIFAuIEJlcnJhbmfDqQ==?= <berrange@redhat.com>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Laine Stump <laine@redhat.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
Subject: RE: [RFC 00/18] vfio: Adopt iommufd
Thread-Topic: [RFC 00/18] vfio: Adopt iommufd
Thread-Index: AQHYT+0D1ejJho1As0eoIzmf/Uaf8qz8i3yAgAPt+QCAAErCAIABIpyQgACM1ICAAkSwEIAAvzwAgAAgTICAAIpQIA==
Date:   Fri, 29 Apr 2022 00:45:54 +0000
Message-ID: <BN9PR11MB5276C0A53554F0117529E9DE8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <20220422160943.6ff4f330.alex.williamson@redhat.com>
 <YmZzhohO81z1PVKS@redhat.com>
 <20220425083748.3465c50f.alex.williamson@redhat.com>
 <BN9PR11MB5276F549912E03553411736D8CFB9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220426102159.5ece8c1f.alex.williamson@redhat.com>
 <BN9PR11MB5276189A2A8EACFBF75B22238CFD9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220428082448.318385ed.alex.williamson@redhat.com>
 <Ymq+x9EgSpWMYnCR@redhat.com>
In-Reply-To: <Ymq+x9EgSpWMYnCR@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d357bf1-5211-4b8f-3e82-08da29799e18
x-ms-traffictypediagnostic: CY4PR11MB1432:EE_
x-microsoft-antispam-prvs: <CY4PR11MB1432F05A13D0DFF6798A83BC8CFC9@CY4PR11MB1432.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Smp1jI4kcxAKcKnl7c7wGjvC3ZQALKi22Il0BwOcTxfwlUkaMxz6bVi4ehol6f8hCjSqqypqF7sT64dicV6DBlxq8fqXqTQru8b1JF14lFLQ3vNAL1JyoXZ4rTC1CZ7F5vev3uS+HTUnPZ6g76r4slXKMecrG8iALJadVC2DN7oyCXCDjw7z149zzEBgqbySZ+OxP+vSoMFVCqunhkYl2i1mSzoAmd2e3ZKse96e3J6PvDxaupn3xZh9hKi4u8FRYkOGBuuxigR5rDvxu6vPC5f1T8nWNtr4ev74MHa9oVbhZD4UI84x1MO7RvWNvbRq0+QmBm2cVNgYAOfGpu7la+7NoJEjlKT4xJqUd46VTRjvSPjIWunicygII/eXir1vU9zFI+BFanwGnitXVvsDnO3hCnYDb0svhqoz6MCdkx4FySCPGP4zzS09I+Ysk8S5JDNjMOaXfaK+GKfOrk5Ur99ZymE4O3OXLsI6X2dYAk18QU3tVsTgfmWkOFQTxWw7kNTsf21okxv8zqVvWuaM5NqGAPvXmefb/A2X3Bk0T2cEIC7qaVAjyj5bhh/JRkWA65D2JNcbk8Zbg2D+2EWdJpCB/0mykWnaHLDYmP2FlbmiLAE899X7FYoJqka/XTa+wCp6dJjEioFH9xCcIKU8OFgv58iS4B5CwwMw1+8L2KJxfnwKDBAZeFlpuTp+MQMuN8xm39ELz5CvwX7Rdj8U/w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7696005)(86362001)(26005)(76116006)(83380400001)(8676002)(66946007)(508600001)(64756008)(4326008)(71200400001)(55016003)(66446008)(38070700005)(38100700002)(316002)(9686003)(110136005)(122000001)(54906003)(82960400001)(2906002)(52536014)(8936002)(5660300002)(7416002)(33656002)(186003)(6506007)(66476007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dXVkSUFoa2huMENkZWQyOVN1aG8wTjZLamkvUWdscFJkRWxYWTFuWkdNR20v?=
 =?utf-8?B?NUVFelIzSU1zeHdWU0tMaFZITEhtV05oQ0E2eVFNdVZaNWdyVUdUbXExa01U?=
 =?utf-8?B?d1VUeXNmdVQ2QTgwWmpQUXRoMHAwMXBOOUtGWW1ueVdIQjBJdkIwc3Y2MUd0?=
 =?utf-8?B?cEY3UzhXTmtBbUZYNFRudWZXVm1ZNGExaDBHNnU1THlwbGE1Ym9jNWJuaWlM?=
 =?utf-8?B?Uzk1TW5mVWVwK0xYV2tEdkxtdzk4ZkpSZHdvQ083MHNBT2hEMVhjUDhMSk1Z?=
 =?utf-8?B?NnBlbkg1dFc5R2ZsNTZwakhia0xkMXFuUldNekk0UWFaWlRYQ2FTWTZZbDhZ?=
 =?utf-8?B?TUx0TlYycmZkVW5wWXZPRlBGMEo0T24rSVRDWk8ySjd4d2JRaW9RcVZ4T0s3?=
 =?utf-8?B?UEdKOFB3Q1BKalpZUXBEQ3N0Um5ScU5tcUptVW5CdkVGWFcveGNxNHplcGVt?=
 =?utf-8?B?dTNTcXhZRUJZVlhpakU4OG1RT3FBSFNIcHlQbGJ3ZFhpdE1JUnVHMWFkWGJR?=
 =?utf-8?B?MHZxRldGN1RrYlV4RlhuMS83SXBMU201Qk04OG5YS2N2N1JINDl5S0hkandt?=
 =?utf-8?B?ZzZWb2NUOUUxRG1TZ1gxMC8xcW1OemlCOFdKekI0aldCckc3NlJmN0VyeVlI?=
 =?utf-8?B?cmFkVGY0NXN1MzlaNkFWVzJaMTRkL1FKcFJtYytQT1FxbDgvY2xlYTdlMjdn?=
 =?utf-8?B?V3NqV2VrMVBYRFJrbk1RSnNNbDVsUmZuR2pCbzRhS1FJM3I5WndQQmxxS0hJ?=
 =?utf-8?B?NUlhYlNpeXRHNnY0QnJzMGk3Uk0va3oyb0IyeC9HeWtNakxWbFprTVFUR2Ny?=
 =?utf-8?B?MzU4dmovVHEvT0dwRFFML3d3ZEFTRjRnRVBacE9OdG4rUXJ5bGwzRDhPbGFV?=
 =?utf-8?B?UVAxNVI2V1RJZitTT1Zib21tWkdHd3NPaVJ4SDBrcDYrLzZCVDZpY3VaZ1dB?=
 =?utf-8?B?bFRHc0ZOSXRhY3pwa2hKLzhFRFI3cHN1eXd0bWRYYTlhQTJxcHRlSWNGNStD?=
 =?utf-8?B?Vi9ubjNsNk1odmQrZnlod2VhcDBac3FINGpwYXFhRkJrN3liMGcvK2hvMlZ1?=
 =?utf-8?B?cThFclJOa3pwZDA5U0V4bU5mbmZoS2ZRcHcxT3pRcGJuMDVGbnhYMEpCcDZH?=
 =?utf-8?B?c0dWcks1L2pJaFVNUE1SOXF3RGtGUXlIeXczNzRvSGMvVnJJalk0WjIwN3Bo?=
 =?utf-8?B?OFF6a3ZDYkpwVVgzOFlHZDcxWm5EZWV6b2NaRHQ1OEtTK0RzQi9CNXBQYWh2?=
 =?utf-8?B?eHVLc0NPcWszb1BQQ2ovS3lWa1lRRGNCZFhOMGJUVDJ4RVVFODlTYmVhSnU3?=
 =?utf-8?B?WjF0SllsYW5rUFpqRHBBTzRKelJlVzRQNjVoY1Q1VjFNSHU3bmdmQ0NFdUNK?=
 =?utf-8?B?dStaYVBHWGtPSEhHdXhqeUZyZ3o2TWMzQ1pwdGJlLzZ3b1lqcWlUS3M4a2dj?=
 =?utf-8?B?OTZaM09CQjh0b0pSbFBwQWhueWhwcUtpeU9rVWVBcW9hK2R6TDNZUGgyVXhS?=
 =?utf-8?B?R3VEclJTQnFQNUFZZWJENFB0VWlHU3UvcWhzQ2Rlc0hWQnJqdm0yN1JYbjVa?=
 =?utf-8?B?VC9jRWdkZk9xTFcyYzZJYk9pVlh5YnU1eE9Ea094TTQvSXc1WTRkUU9RTmd2?=
 =?utf-8?B?L2ljUndIUlR4M2g0M3B1ZitGQjJQaC9SU0NNMVE1cng4SWN1R0hXb0t4VXV4?=
 =?utf-8?B?ZUw0TUREbDM4UW1sSmIreS9jUGVFREx2RjhJMERENjFPSEUwb09wWXlHTEJD?=
 =?utf-8?B?aGxDSEZTb0xlSVl1MjNiYzdGbUdIQ1d0cHBwMytQQ09ScHZoOVR5WmRTOHN2?=
 =?utf-8?B?Tzl4SGRRSTZlT2gzYVBBUE1DNlIxWDJoWmQ1QnZudDNyR3hkeHl5c3YrQnFO?=
 =?utf-8?B?RVR4ZkxHMzFnbWMzZ1JqVkFtL1ZGSUJzeE91TWdZUUhxZmxid3VQa2h1TkVl?=
 =?utf-8?B?RkJxT3gvQkZaOFd2NXN1NVZsU0VFQ3g2MkZMU0Y1QjRqYzNDY0IrUDJpYUJw?=
 =?utf-8?B?TGJPK3hQV3RWbjBrT2U4TGphRi9IZTlaK3FsQ29kb2k0VWdDZ2poUnJjc3N2?=
 =?utf-8?B?djdLc05DZXlRT1pPN1pjWXQ1OVptMXhKZEdxMGdmSEh5SUtEYlB3MEpWOFJG?=
 =?utf-8?B?bXFiaGpiak5wdUJPeDhXdEY3c3BWcndNVDMzYkdGSlo5V0ZkZzNGNDNObnRL?=
 =?utf-8?B?Tkh2eTR0OE05VW1RdHpoNjBCZDVTTDl5V3Y5NXNMQ1d0anVZSUhlRHMyWnlL?=
 =?utf-8?B?ZDVzbHUzZzV5ZVc0M0R3dzJYTkM2M0dhMW84eVlwVk9oeXc0cGs0MXVYNFkz?=
 =?utf-8?B?N3FFelkwMThXdFFkdXQ3bEFGN0VzOUl5OVpuVE1BZFRKd0psQ2NKdz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d357bf1-5211-4b8f-3e82-08da29799e18
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2022 00:45:54.5892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HEHZXfZoYeHe0A6jcI26DtQTeX+GP+ihqkf6oXmS5rY3qRAtXc7VlXO4TG1maZWpmqSJpS/AjDIQvPOTx2ipYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1432
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBEYW5pZWwgUC4gQmVycmFuZ8OpIDxiZXJyYW5nZUByZWRoYXQuY29tPg0KPiBTZW50
OiBGcmlkYXksIEFwcmlsIDI5LCAyMDIyIDEyOjIwIEFNDQo+IA0KPiBPbiBUaHUsIEFwciAyOCwg
MjAyMiBhdCAwODoyNDo0OEFNIC0wNjAwLCBBbGV4IFdpbGxpYW1zb24gd3JvdGU6DQo+ID4gT24g
VGh1LCAyOCBBcHIgMjAyMiAwMzoyMTo0NSArMDAwMA0KPiA+ICJUaWFuLCBLZXZpbiIgPGtldmlu
LnRpYW5AaW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+ID4gPiBGcm9tOiBBbGV4IFdpbGxpYW1z
b24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiA+ID4gPiBTZW50OiBXZWRuZXNkYXks
IEFwcmlsIDI3LCAyMDIyIDEyOjIyIEFNDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gTXkgZXhw
ZWN0YXRpb24gd291bGQgYmUgdGhhdCBsaWJ2aXJ0IHVzZXM6DQo+ID4gPiA+ID4gPg0KPiA+ID4g
PiA+ID4gIC1vYmplY3QgaW9tbXVmZCxpZD1pb21tdWZkMCxmZD1OTk4NCj4gPiA+ID4gPiA+ICAt
ZGV2aWNlIHZmaW8tcGNpLGZkPU1NTSxpb21tdWZkPWlvbW11ZmQwDQo+ID4gPiA+ID4gPg0KPiA+
ID4gPiA+ID4gV2hlcmVhcyBzaW1wbGUgUUVNVSBjb21tYW5kIGxpbmUgd291bGQgYmU6DQo+ID4g
PiA+ID4gPg0KPiA+ID4gPiA+ID4gIC1vYmplY3QgaW9tbXVmZCxpZD1pb21tdWZkMA0KPiA+ID4g
PiA+ID4gIC1kZXZpY2UgdmZpby1wY2ksaW9tbXVmZD1pb21tdWZkMCxob3N0PTAwMDA6MDI6MDAu
MA0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IFRoZSBpb21tdWZkIG9iamVjdCB3b3VsZCBvcGVu
IC9kZXYvaW9tbXVmZCBpdHNlbGYuICBDcmVhdGluZyBhbg0KPiA+ID4gPiA+ID4gaW1wbGljaXQg
aW9tbXVmZCBvYmplY3QgaXMgc29tZW9uZSBwcm9ibGVtYXRpYyBiZWNhdXNlIG9uZSBvZiB0aGUN
Cj4gPiA+ID4gPiA+IHRoaW5ncyBJIGZvcmdvdCB0byBoaWdobGlnaHQgaW4gbXkgcHJldmlvdXMg
ZGVzY3JpcHRpb24gaXMgdGhhdCB0aGUNCj4gPiA+ID4gPiA+IGlvbW11ZmQgb2JqZWN0IGlzIG1l
YW50IHRvIGJlIHNoYXJlZCBhY3Jvc3Mgbm90IG9ubHkgdmFyaW91cyB2ZmlvDQo+ID4gPiA+ID4g
PiBkZXZpY2VzIChwbGF0Zm9ybSwgY2N3LCBhcCwgbnZtZSwgZXRjKSwgYnV0IGFsc28gYWNyb3Nz
IHN1YnN5c3RlbXMsDQo+IGV4Lg0KPiA+ID4gPiA+ID4gdmRwYS4NCj4gPiA+ID4gPg0KPiA+ID4g
PiA+IE91dCBvZiBjdXJpb3NpdHkgLSBpbiBjb25jZXB0IG9uZSBpb21tdWZkIGlzIHN1ZmZpY2ll
bnQgdG8gc3VwcG9ydCBhbGwNCj4gPiA+ID4gPiBpb2FzIHJlcXVpcmVtZW50cyBhY3Jvc3Mgc3Vi
c3lzdGVtcyB3aGlsZSBoYXZpbmcgbXVsdGlwbGUNCj4gaW9tbXVmZCdzDQo+ID4gPiA+ID4gaW5z
dGVhZCBsb3NlIHRoZSBiZW5lZml0IG9mIGNlbnRyYWxpemVkIGFjY291bnRpbmcuIFRoZSBsYXR0
ZXIgd2lsbCBhbHNvDQo+ID4gPiA+ID4gY2F1c2Ugc29tZSB0cm91YmxlIHdoZW4gd2Ugc3RhcnQg
dmlydHVhbGl6aW5nIEVOUUNNRCB3aGljaA0KPiByZXF1aXJlcw0KPiA+ID4gPiA+IFZNLXdpZGUg
UEFTSUQgdmlydHVhbGl6YXRpb24gdGh1cyBmdXJ0aGVyIG5lZWRzIHRvIHNoYXJlIHRoYXQNCj4g
PiA+ID4gPiBpbmZvcm1hdGlvbiBhY3Jvc3MgaW9tbXVmZCdzLiBOb3QgdW5zb2x2YWJsZSBidXQg
cmVhbGx5IG5vIGdhaW4gYnkNCj4gPiA+ID4gPiBhZGRpbmcgc3VjaCBjb21wbGV4aXR5LiBTbyBJ
J20gY3VyaW91cyB3aGV0aGVyIFFlbXUgcHJvdmlkZQ0KPiA+ID4gPiA+IGEgd2F5IHRvIHJlc3Ry
aWN0IHRoYXQgY2VydGFpbiBvYmplY3QgdHlwZSBjYW4gb25seSBoYXZlIG9uZSBpbnN0YW5jZQ0K
PiA+ID4gPiA+IHRvIGRpc2NvdXJhZ2Ugc3VjaCBtdWx0aS1pb21tdWZkIGF0dGVtcHQ/DQo+ID4g
PiA+DQo+ID4gPiA+IEkgZG9uJ3Qgc2VlIGFueSByZWFzb24gZm9yIFFFTVUgdG8gcmVzdHJpY3Qg
aW9tbXVmZCBvYmplY3RzLiAgVGhlDQo+IFFFTVUNCj4gPiA+ID4gcGhpbG9zb3BoeSBzZWVtcyB0
byBiZSB0byBsZXQgdXNlcnMgY3JlYXRlIHdoYXRldmVyIGNvbmZpZ3VyYXRpb24gdGhleQ0KPiA+
ID4gPiB3YW50LiAgRm9yIGxpYnZpcnQgdGhvdWdoLCB0aGUgYXNzdW1wdGlvbiB3b3VsZCBiZSB0
aGF0IGEgc2luZ2xlDQo+ID4gPiA+IGlvbW11ZmQgb2JqZWN0IGNhbiBiZSB1c2VkIGFjcm9zcyBz
dWJzeXN0ZW1zLCBzbyBsaWJ2aXJ0IHdvdWxkIG5ldmVyDQo+ID4gPiA+IGF1dG9tYXRpY2FsbHkg
Y3JlYXRlIG11bHRpcGxlIG9iamVjdHMuDQo+ID4gPg0KPiA+ID4gSSBsaWtlIHRoZSBmbGV4aWJp
bGl0eSB3aGF0IHRoZSBvYmplY3Rpb24gYXBwcm9hY2ggZ2l2ZXMgaW4geW91ciBwcm9wb3NhbC4N
Cj4gPiA+IEJ1dCB3aXRoIHRoZSBzYWlkIGNvbXBsZXhpdHkgaW4gbWluZCAod2l0aCBubyBmb3Jl
c2VlbiBiZW5lZml0KSwgSSB3b25kZXINCj4gPg0KPiA+IFdoYXQncyB0aGUgYWN0dWFsIGNvbXBs
ZXhpdHk/ICBGcm9udC1lbmQvYmFja2VuZCBzcGxpdHMgYXJlIHZlcnkgY29tbW9uDQo+ID4gaW4g
UUVNVS4gIFdlJ3JlIG1ha2luZyB0aGUgb2JqZWN0IGNvbm5lY3Rpb24gdmlhIG5hbWUsIHdoeSBp
cyBpdA0KPiA+IHNpZ25pZmljYW50bHkgbW9yZSBjb21wbGljYXRlZCB0byBhbGxvdyBtdWx0aXBs
ZSBpb21tdWZkIG9iamVjdHM/ICBPbg0KPiA+IHRoZSBjb250cmFyeSwgaXQgc2VlbXMgdG8gbWUg
dGhhdCB3ZSdkIG5lZWQgdG8gZ28gb3V0IG9mIG91ciB3YXkgdG8gYWRkDQo+ID4gY29kZSB0byBi
bG9jayBtdWx0aXBsZSBpb21tdWZkIG9iamVjdHMuDQoNClByb2JhYmx5IGl0J3MganVzdCBhIGh5
cG90aGV0aWNhbCBjb25jZXJuIHdoZW4gSSB0aG91Z2h0IGFib3V0IHRoZSBuZWVkDQpvZiBtYW5h
Z2luZyBjZXJ0YWluIGdsb2JhbCBpbmZvcm1hdGlvbiAoZS5nLiBQQVNJRCB2aXJ0dWFsaXphdGlv
bikgY3Jvc3MNCmlvbW11ZmQncyBkb3duIHRoZSByb2FkLiBXaXRoIHlvdXIgYW5kIERhbmllbCdz
IHJlcGxpZXMgSSB0aGluayB3ZSdsbA0KZmlyc3QgdHJ5IHRvIGZvbGxvdyB0aGUgY29tbW9uIHBy
YWN0aWNlIGluIFFlbXUgZmlyc3QgZ2l2ZW4gdGhlcmUgYXJlDQptb3JlIHBvc2l0aXZlIHJlYXNv
bnMgdG8gZG8gc28gdGhhbiB0aGUgaHlwb3RoZXRpY2FsIGNvbmNlcm4gaXRzZWxmLg0KDQo+ID4N
Cj4gPiA+IHdoZXRoZXIgYW4gYWx0ZXJuYXRpdmUgYXBwcm9hY2ggd2hpY2ggdHJlYXRzIGlvbW11
ZmQgYXMgYSBnbG9iYWwNCj4gPiA+IHByb3BlcnR5IGluc3RlYWQgb2YgYW4gb2JqZWN0IGlzIGFj
Y2VwdGFibGUgaW4gUWVtdSwgaS5lLjoNCj4gPiA+DQo+ID4gPiAtaW9tbXVmZCBvbi9vZmYNCj4g
PiA+IC1kZXZpY2UgdmZpby1wY2ksaW9tbXVmZCxbZmQ9TU1NL2hvc3Q9MDAwMDowMjowMC4wXQ0K
PiA+ID4NCj4gPiA+IEFsbCBkZXZpY2VzIHdpdGggaW9tbXVmZCBzcGVjaWZpZWQgdGhlbiBpbXBs
aWNpdGx5IHNoYXJlIGEgc2luZ2xlIGlvbW11ZmQNCj4gPiA+IG9iamVjdCB3aXRoaW4gUWVtdS4N
Cj4gPg0KPiA+IFFFTVUgcmVxdWlyZXMga2V5LXZhbHVlIHBhaXJzIEFGQUlLLCBzbyB0aGUgYWJv
dmUgZG9lc24ndCB3b3JrLCB0aGVuDQo+ID4gd2UncmUganVzdCBiYWNrIHRvIHRoZSBpb21tdWZk
PW9uL29mZi4NCj4gPg0KPiA+ID4gVGhpcyBzdGlsbCBhbGxvd3MgdmZpbyBkZXZpY2VzIHRvIGJl
IHNwZWNpZmllZCB2aWEgZmQgYnV0IGp1c3QgcmVxdWlyZXMgTGlidmlydA0KPiA+ID4gdG8gZ3Jh
bnQgZmlsZSBwZXJtaXNzaW9uIG9uIC9kZXYvaW9tbXUuIElzIGl0IGEgd29ydGh3aGlsZSB0cmFk
ZW9mZiB0byBiZQ0KPiA+ID4gY29uc2lkZXJlZCBvciBqdXN0IG5vdCBhIHR5cGljYWwgd2F5IGlu
IFFlbXUgcGhpbG9zb3BoeSBlLmcuIGFueSBvYmplY3QNCj4gPiA+IGFzc29jaWF0ZWQgd2l0aCBh
IGRldmljZSBtdXN0IGJlIGV4cGxpY2l0bHkgc3BlY2lmaWVkPw0KPiA+DQo+ID4gQXZvaWRpbmcg
UUVNVSBvcGVuaW5nIGZpbGVzIHdhcyBhIHNpZ25pZmljYW50IGZvY3VzIG9mIG15IGFsdGVybmF0
ZQ0KPiA+IHByb3Bvc2FsLiAgQWxzbyBub3RlIHRoYXQgd2UgbXVzdCBiZSBhYmxlIHRvIHN1cHBv
cnQgaG90cGx1Zywgc28gd2UNCj4gPiBuZWVkIHRvIGJlIGFibGUgdG8gZHluYW1pY2FsbHkgYWRk
IGFuZCByZW1vdmUgdGhlIGlvbW11ZmQgb2JqZWN0LCBJDQo+ID4gZG9uJ3Qgc2VlIHRoYXQgYSBn
bG9iYWwgcHJvcGVydHkgYWxsb3dzIGZvciB0aGF0LiAgSW1wbGljaXQNCj4gPiBhc3NvY2lhdGlv
bnMgb2YgZGV2aWNlcyB0byBzaGFyZWQgcmVzb3VyY2VzIGRvZXNuJ3Qgc2VlbSBwYXJ0aWN1bGFy
bHkNCj4gPiBkZXNpcmFibGUgdG8gbWUuICBUaGFua3MsDQo+IA0KPiBBZGRpbmcgbmV3IGdsb2Jh
bCBwcm9wZXJ0aWVzL29wdGlvbnMgaXMgcmF0aGVyIGFuIGFudGktcGF0dGVybiBmb3IgUUVNVQ0K
PiB0aGVzZSBkYXlzLiBVc2luZyAtb2JqZWN0IGlzIHRoZSByaWdodCBhcHByb2FjaC4gSWYgeW91
IG9ubHkgd2FudCB0bw0KPiBhbGxvdyBmb3Igb25lIG9mIHRoZW0sIGp1c3QgZG9jdW1lbnQgdGhp
cyByZXF1aXJlbWVudC4gV2UndmUgZ290IG90aGVyDQo+IG9iamVjdHMgd2hpY2ggYXJlIHNpbmds
ZXRvbnMgbGlrZSBhbGwgdGhlIGNvbmZpZGVudGlhbCBndWVzdCBjbGFzc2VzDQo+IGZvciBlYWNo
IGFyY2guDQo+IA0KDQpHb29kIHRvIGtub3cgc3VjaCBsYXN0IHJlc29ydC4gQXMgc2FpZCB3ZSds
bCB0cnkgdG8gYXZvaWQgdGhpcyByZXN0cmljdGlvbg0KYW5kIGZvbGxvdyBBbGV4J3MgcHJvcG9z
YWwgdW5sZXNzIHRoZXJlIGFyZSB1bmV4cGVjdGVkbHkgdW5yZWFzb25hYmxlDQpjb21wbGV4aXRp
ZXMgYXJpc2luZyBsYXRlci4NCg0KVGhhbmtzDQpLZXZpbg0K
