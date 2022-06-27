Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8D1355C2EA
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbiF0HWn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 03:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbiF0HWl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 03:22:41 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E245592;
        Mon, 27 Jun 2022 00:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656314560; x=1687850560;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zlYFSnr7c+yfUBUrUPN8JnG7ih3xZYc3klwqQ7OutHk=;
  b=FyvUDsXzjFrerTe7Q1VJlstSXEVNqwnidNaTegyHWPi/o2KLmpZvLld/
   ivM7DNVl63CxP2BSIHp6vvtVVIXgEDB9hD2c135gmS5G1D04IWHoiChk4
   gJ+HiCusrFx/ws2idcg6klSfZiavQ99iOefR6WOFsIWFuxjYEuFCjzH68
   xVmgng9htiP+oPWSv/ResqmfZURYL30bkwNAIsMLXQ+YFV7LVxkI508hH
   DYpDQecWGQNRwefqM5uLzmRnXr8owuG8TWvnyWUG71Pp4NgYjQHmnzuRc
   4H05zg3LZ9iY/TA3LG9jqfQcoFK+QQE9qrUzZVv/RFjoWtAOlzmou750b
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10390"; a="306854994"
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="306854994"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 00:22:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="646308783"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 27 Jun 2022 00:22:40 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 27 Jun 2022 00:22:39 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 27 Jun 2022 00:22:39 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 27 Jun 2022 00:22:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m2jR0a8LCSkrO/2vpvDYKnVGeS8wCE707Wqwuc4AA4IObgpHR7kEDAgsDp++VwZggGoLE85S3gscsTu7/Ooq+0+JWwGZfs8BmkTcrdAI6OexRYDg3CJO1BsrBlUwMp6OuLt9FJNuigIVmV9zLv+33fLjWv8ak+sCLFi0uSvRHxcnOjp7yv+2yzzgU4hOU8ElkrFmoCfyM4pe8y64ScnfS9TKEVcO2DmPzHBCDmVr229Z008Ei9haaTy7cKZA1Hrht4z4B1TL0ixioj19Xjlu/1hp8XTU08jlS7ibiPFQ4bj153LigLz43c4gyDDmYgyDxOvVSCB2trYBKjjCfAjU8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zlYFSnr7c+yfUBUrUPN8JnG7ih3xZYc3klwqQ7OutHk=;
 b=Cv1ULzpc7LE+V1z4TLkBmOaxulLRYhQVlc3mKo5nYXPU1h9LwlKmsTP8Sh8SlqQDbyuMm0GWeA5EPmOHihi9uZbF2AneRsobxuj/BILQSrNlcUOA/8X3LBB8tkp9d0TWF5yMamY930/e9xPmTAt6xTIVL6MRBxQZ4YUZqGh4n5icAluDhiYa3Ns0hM7dh4taWHqdjxzknTxiRLN8RsAaS38nVtEfALQrga0Ea2AioHq7vGrBuvI0C10GLvXvAVADlNVTUQKal7b1dX4BNfShcs0xhGWFMvYgW+jMkJevvHxXv2WAIY8+Zg5NnibbvNaTJrYupll6UWOVXocPZm/zTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB3857.namprd11.prod.outlook.com (2603:10b6:405:79::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Mon, 27 Jun
 2022 07:22:38 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 07:22:38 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Robin Murphy <robin.murphy@arm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>
Subject: RE: [PATCH v3 2/2] vfio: Use device_iommu_capable()
Thread-Topic: [PATCH v3 2/2] vfio: Use device_iommu_capable()
Thread-Index: AQHYh/Q6kiM0O597HUWrTYTD7PqzBK1i3VRQ
Date:   Mon, 27 Jun 2022 07:22:38 +0000
Message-ID: <BN9PR11MB52761EBA5C0A3886A6AFB3A48CB99@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <194a12d3434d7b38f84fa96503c7664451c8c395.1656092606.git.robin.murphy@arm.com>
 <4ea5eb64246f1ee188d1a61c3e93b37756932eb7.1656092606.git.robin.murphy@arm.com>
In-Reply-To: <4ea5eb64246f1ee188d1a61c3e93b37756932eb7.1656092606.git.robin.murphy@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9320c1bf-1003-43f0-dd03-08da580dd0bc
x-ms-traffictypediagnostic: BN6PR11MB3857:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1gBLu5l83LDarOlw/ZYGL+G2NXYzUOHKjVBT0WYpvb+aTzx1N/fF7+E94W2N9yP+s8N4xINnfhffSwoIFOGYwIr7n6j74bNO80iMuPDGDcka+KK2W+kCa6D1Xz1HPIGP9G9AUPTlAW4rX5g60iwgcnf4IVy2T8wMgeXrkZR9kfNOpqHdpLk4dr2FVftb3WfRC589pa2JAls1hWY/6clIoaMbIlnz3Lgd8TXxeWOWvnP3TpMfpX/8jm7AM6sO/ZXdBNiDkatXfgst+rv1Wtdx/u6DhYADEiikEyhY50DqYWQUlJkgKBiS4zG2gV8CquGXLDrzRoNzZlPh1kMqtlhE8Z4CXUiNrViSNmuwCLZI7uE/JiXYY0C5uuk+WFqvRDxV/2RiSKH2scMylhjnFGR2nQMVZe5QnovwOezUgjnm8anBK9gPAo5aJfVoJENww/wOCu8UWhi0wavj1oEgF1YtPBbdrBPG5YCs12BG/cKdOVc8FD5NwNMAW7fBs0NSeFTfRX7Ec4x6H5z6kk7r3Xkdv6U7Ia7ZTuWKx7C0OcYEDD42KK5UG0D9OlqInkv31rhAgeQMDVKUZ0y96P4AD/dgOO+XZC/ggCo8dLrxJtHCL7PNslHIY6cF1qPGugbMWV109+GVvE2hWAIHZ1i05SBnBFpmQkLuEpCs08ak2rwcqeKSUPwHx5OuCRIAbmCPd/SZM3y3V/qndho4efbta9i6gkiNqOFEogBEBePKRFVScLvQJlw/EkrEZIdpH1flghR/6ImEATf7dY0RTzBFTLtg0jQmOT+v4GV+hprCG8/6a+M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(136003)(39860400002)(346002)(396003)(38100700002)(122000001)(186003)(55016003)(8936002)(316002)(5660300002)(54906003)(110136005)(26005)(9686003)(66946007)(82960400001)(86362001)(64756008)(66446008)(38070700005)(52536014)(66556008)(66476007)(478600001)(71200400001)(8676002)(4326008)(41300700001)(2906002)(76116006)(7696005)(33656002)(558084003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xHnfhR29ubi9jl7a10KM/Fy7NlnMIxYsylXQN/eLDD7yeuRMHuqqHv1FhWyS?=
 =?us-ascii?Q?C77qBzAusqdiitAfTmvLNa/AryA0fGGXVTXtt/Ygb8xBNafuo0+QkYP++Z0s?=
 =?us-ascii?Q?POA/RFLxW+bwv/c5OWRUxliYek9hD1kNiGphR40lwVt8BXh0FP+Fqc5AWl2M?=
 =?us-ascii?Q?qLqCn1yoiiqgqGTT3tKtx9sdwWZ4H8brnR+8P0od02oHhWAH9mwkVLcidZba?=
 =?us-ascii?Q?xswMr+BdTNfRwkEdxk/H1+yRgTC259/uQwhnyqDQxn+Oux45m7MwrSj4i0da?=
 =?us-ascii?Q?C+5Jz4vv3DmejBasHTGSKCg/e+T3Dcjhxc6HSkyYU2b8wUyoLADStI7TB6ko?=
 =?us-ascii?Q?44itLkwCIvCNAkhMVpT3PIamczCt9KrEgSYsTxYp7vnBd7QHyJwGLt2FFcW1?=
 =?us-ascii?Q?7SB4vtjdlNHeMcijIz6L1dYhayfIshs4QC89MiN6oh3xMqFcBknrs5vzJPpw?=
 =?us-ascii?Q?WV9VpfDWIFo5geaeQIyKOXT8AtPalgqdD9OSGrK7lL/uPH4UnLr4Tsm4AiJq?=
 =?us-ascii?Q?aKxrENX5YqmkagxQS5sAvx86wyHZ22fojxx94wf+rBpHh7xHq6ahk8IhFkng?=
 =?us-ascii?Q?9TAt0p1Bff3Mqg7TgDHDKwMYEVd1RILsMCFZ8YPd94Za/WJJHrLx8DSJv1/6?=
 =?us-ascii?Q?kiQtU87zF//K6/9SDjLd1wT7Qrk9h+oMtsdZ6Rxd6WdTxda3kvdc7cy20lL5?=
 =?us-ascii?Q?lg8SKceXAzf/wEM5Hs44NMfWbICi1o7X2pRXdcl41iTWRhLLfhdBRUaQisaZ?=
 =?us-ascii?Q?PAfHsCiRRLSB5svW1XUVDqi+o994L2F+kFicayg4YImVa5koKoMYkJWougck?=
 =?us-ascii?Q?/jkwvDCjwKQKmNCwwULigu7sayFmmruk8yLYQRLZXZq/0qLBMZd3oWd/fQLK?=
 =?us-ascii?Q?REmG5hlTMcVdRy9Bt/gFtsXg+MXtXYGh+i8xZx/kdit2rpNOWLhEUBGnOxPB?=
 =?us-ascii?Q?UxjyM/ASIykFfCixt7D6wU+d46Fu6OQlQvjerBv8a6D4QsGpp9kIrqHsL8zO?=
 =?us-ascii?Q?VoGQ1+2kX0uCv2oqGrhYBV39cpn3lZ/nDigPo53gRRKRFikNFCJ3Q4UqhlZL?=
 =?us-ascii?Q?WF5BmxcLdDDOEBXFl51Jtsbt9KmzqBbbS7+FP3KquZPiuAKu5rG8F/G0RcNB?=
 =?us-ascii?Q?3yiipRhDFVR6F4Lig4Tr2TdFH1Jp05SO10n7tdiMEahCWMGN3NpAd9kIuyH9?=
 =?us-ascii?Q?+Jg7m7RK/OBIhFi9GxyKVygb3bwADBR69VWHu7tOaktJziEaHXoTvHTyeOB1?=
 =?us-ascii?Q?qx3Ja4FJBZKVQrINnbddi+75gNASr+4kpeKbxkM+ma3l6ORf2VWaW2s4XHsJ?=
 =?us-ascii?Q?CMjWUoo8ekyO2lGVmb5h+uuGMFqEvCDb43Ys0GJ3DIe87GBz/CUpW2zv1OgX?=
 =?us-ascii?Q?0jGYDFXfvZuqH/6i5DYHLqX0le34lASpDn9p2W5XmzajfvAjTZ3y/1NfT6u4?=
 =?us-ascii?Q?+W2l6tNQcLM4pW0wIHVn4qHHQCaKfxIh0fogC3nvAPr7buo3T7RDUXXEyqj4?=
 =?us-ascii?Q?yqaTekaFoiF2ld3uV9MDRkyPqg1hwG8whsZW2EybGGjDluG1Y58PJWUt3Q1O?=
 =?us-ascii?Q?8OmFl7bRqF++W5zpEInKoRxIZy1aYh2mVz7dOTuk?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9320c1bf-1003-43f0-dd03-08da580dd0bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2022 07:22:38.5891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DQrAN9IoAQ4OxSF7ThMHozyrCdLtztemdmBIeLcCET3FEsKqbSIQiiJ+YptiPUO15D6aNH52syg97f+9C2pptw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3857
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Robin Murphy
> Sent: Saturday, June 25, 2022 2:00 AM
>=20
> Use the new interface to check the capabilities for our device
> specifically.
>=20
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
