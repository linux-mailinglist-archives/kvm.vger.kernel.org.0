Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 498155A4064
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 02:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiH2AiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Aug 2022 20:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiH2AiA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Aug 2022 20:38:00 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A56E30F6D
        for <kvm@vger.kernel.org>; Sun, 28 Aug 2022 17:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661733479; x=1693269479;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=qN8DNh39xBTqzq7wl7DvN9YF3LMQY2ju7nYwuXGChn8=;
  b=Ug4LHwsooojsvTSPa9ZbBBIG4+qv1iD0AQyzA207hRSdqo4heocs8EGw
   rTugvI9fbn89M9kdCisK/82wwHEixTIoQYdJRDjc07vNyMkafk0EKaW+Z
   GOy2+LUMYFcZyd9QIhuQxtXvuIx+NmPDIFm7/++k9cd6m/DfJxUMP3qU6
   4/S5E/6cMZLOozbDPl0Ias5MGtT7K8FOMQVak1qaSxyeO9AKXzTi+3cm5
   bbb7ribJj9b83Tiahei75zGmHX1M1XD4dhZKUDsryPf7+3YFa8Ki3OrNd
   H2jtcMSC1r2nS84hXy517O5bkNz6loPQAeiSr0NXz6UOd4oV2GKB4GVlV
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10453"; a="295558672"
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="295558672"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2022 17:37:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="644243161"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 28 Aug 2022 17:37:58 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 17:37:58 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 28 Aug 2022 17:37:58 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 28 Aug 2022 17:37:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SQ2BmmYtsH2KTZzg8YDfXr8DQrbwxUbV4GLYIaHCMAgn5dMRdR2Oc6B/YzP12Ilu9xo//J7+4UDPzVGaC53S5JtKapy9Q4orjljKTxU3sRogvFgjweqBbfpi5kjNplmkM1ITnjTpeQEnGL9QxDKT/e1o0wtBs8M6Q3dPM/DECo5qoQl1dtU2WYFRcaDIP+murmS7PEzpbz6p65dHyXzeOxPXgMQaxbVczgHOBvrXJigftQDVMxloLvOz/X6y6/2cMtLQtLYHWh0OA2dSXap3Vk1T62XPc3PUPn7Q26DanS0/sZjywgYZAbpofwDvsyRwH+/QKRP70jfbxonTAFsWbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IouVVRPGxmFHXpGVaDB1SdxiHGQ2oc9rtD9C3sUu55w=;
 b=Kth2J5O0DSvqR+1IO3Ckuv7SWJMQcvJ7rkrjc3haK7A3R6R+LYEVIAumR2SPIQEwz0x1LpXW9k3t/l2DUFJKzjl32t3gPwx2ShSG37iApUaKP2/y4TwwLnBdRXFbs+FSMtdc8HDWoTphzVH3h+q3wARRC+XauIwDvyWvLLp9fl6WDCxeyb3U1aBQXPwnTTNmaUr1PbjobfTalQsErcnIZpC+yoX7D+JFh0O8HPk0FP8mXNCTY6qk13iNRbGGLwYiLSsUNAh+U8Uq8KHr/8ZNvq7Ujr5xkdS7x/drgnb9fUlYFczWyM602WqO2VwIgm4B5p7ZqqTxtHPyoCyjOzF/jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB3968.namprd11.prod.outlook.com (2603:10b6:208:151::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 00:37:52 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6%4]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 00:37:52 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: RE: [PATCH 3/8] vfio-pci: Re-indent what was vfio_pci_core_ioctl()
Thread-Topic: [PATCH 3/8] vfio-pci: Re-indent what was vfio_pci_core_ioctl()
Thread-Index: AQHYslOh0JacNVJDzki1EaVIZgMKsq3FGPdAgAABZ6A=
Date:   Mon, 29 Aug 2022 00:37:51 +0000
Message-ID: <BN9PR11MB52764B33EE0B7EBB2C1F6E548C769@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
 <3-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c833e37-13d1-4b73-08ea-08da8956b4cc
x-ms-traffictypediagnostic: MN2PR11MB3968:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: on6vNpcmlnh2yDdEfHRgs2SzndPgavrGU2tzjhbq8/5VIJOP/p07M/wjVOt+TAmCSqgGhsO+sh5/U6t6tDwh1yo6bNjWs2V1l56ai3ewu31TyDgAqaA4of6nBi/fuMoEPOzBQamr7G0sAnHx4yHU4EAw6vbSDRXHWozlCd76UsaJzXmhTwDPCdUHZwsJQNjcYKQlBe+KNnWm1EpCR89h1eVVcD6k8R2yOkbVLnaZkNSUIAhkvt11T/MYey6PcbFqS83GyJzgCNtKOJaXjdsFZWbHtkVE+mdzk/Nk+gXndhR3ZuXU96r2zWg3cHxdcSHyTakvyMf7AnhMT5SwsSKBb8KSkPY2TIiegoJo+Cm7fBYeQIEWm3FP/ru4tKrL2JRH5dbNGPYRqLlKN+t3OmP9Q4lD1ARLzDzs2Hy5SgRDQOcGDlB7P04Yzw6SdfcWZ4UxOS6gCIwwwooNT/iS+HFMzLfGyC0Ou8Zm4tzatiPaUDTdb12c9VhcT2H5AIneAhlAFyTbeJnOYvcoASPwBluyaR5Yky2rorgn2KIE93yC3tMxqGK/EGmwgEsnbRI0MxmPkCe1vDSWjPXdimykN/6RG+hVWR8/EeEqGBNrNg4udzcHqMSI+oady/3FT7zoT0tblnQz4C6AQpHSYKEEEpZpYBUuU5A/o+ckaVj5D165G+bqaTyKigqtd7vzLBPx+fb9/zeaChPyrUxfX2u3fupLD0xROmwVZyZ1v8lhpt0bd9NX1ze/rTs6BHEAbAPrjNL/RHaXTaK82jsKO1hQUnYqbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(376002)(136003)(39860400002)(7696005)(9686003)(82960400001)(86362001)(38070700005)(6506007)(26005)(33656002)(122000001)(186003)(478600001)(41300700001)(71200400001)(55016003)(66446008)(8676002)(66476007)(64756008)(316002)(110136005)(76116006)(66556008)(52536014)(66946007)(5660300002)(8936002)(4744005)(38100700002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7NtYiBjN0c4ZiNc3ilG2EcRSuYL1DGGMpcbfnbdDPkI2eVHghqP+pu3FFOgG?=
 =?us-ascii?Q?yFXQKpW5mjkwjIlSwJtPIXVDsSz5OneLDuA2t6UgQGbtqU61ET7tTyStWMsa?=
 =?us-ascii?Q?27XeWRMsPFE150wnic6YtJeFw4l3nLs/gsXMLyaJ6pk0FdZL/Ix6qrb1crNE?=
 =?us-ascii?Q?I0dCrmSf0bw7Ll37NAsKKAsBe+F5uarWrIXG2T4YJTjFZRZsovKw3XRFuc8n?=
 =?us-ascii?Q?pGsXGZBGskySRNWvbvUkYLtT09o/2tGWOBdKnruWVO+JQiyHzQEoNnFHlGsX?=
 =?us-ascii?Q?WXQjP2upMkWw0uAdCFexQWNnws8G3N1TyC3mEUmfO+5qBXMVezEe22RE6UL3?=
 =?us-ascii?Q?2JOzmoSCPhsh/4Ba3YhRSB86uwJtXDu+cHOHbLQIW8OpSiCx9zq0hwBl8xej?=
 =?us-ascii?Q?kUpJ3Q9w8bnmk9yrTwGR2BDXn5vnKQgbevzZSUOWiMOo4HpbaZZzHgx+s4j1?=
 =?us-ascii?Q?dicpMiazXIp6cMEsXDC/BvhX8DJupfinN38/ILHIDvcTYyyTwBpR1snsQzjm?=
 =?us-ascii?Q?wnHn7illtIB51JHv6BLpH3NGIwzCtFgHnmAynWjuRefKpLDXJUnyZa2J/qs0?=
 =?us-ascii?Q?iM/lVGXte01FmsnGkrzjzypiKMQT/jkJwP+fEFJ99d8KaSa7bEPw26l+Hdo7?=
 =?us-ascii?Q?3UA/0xHHw7yyeQUtlm6dxVa+WRyYz/puOX4RptMRA3Mn3Xe2B2mxK67BnwIE?=
 =?us-ascii?Q?F1QKQT1gITjM1i5EFgApCDS01kMmppCrCObjbDb0F6G24GMcYvhzq9T20xTB?=
 =?us-ascii?Q?DhLl/NUPTADazggXkt4FN9CqsRoYZgtIfUM4hqEHreEYlo9k3f3j7rMOK1q3?=
 =?us-ascii?Q?NtQZim2ThH2N6WRBzPrTO7eJ0upxS+V2yHqhIS3WsZ0GhYVWp9h2U/5FzQis?=
 =?us-ascii?Q?2h5v/lKNx+iCVPggP8eb4emxwbDp4w0i0shCTBTlIz59D6DyqKY4PcKvCMIS?=
 =?us-ascii?Q?MHLQdlc4DpyPPkJWvuLzllLVEOgSYtYSEy5jJKrIKZh/zICAeACDEk3C8lng?=
 =?us-ascii?Q?vEZe2sikah/WKCWyS+GBpE8rOJApgyijTF9k66f5JLkQ/T54fDqwFpqTjU3B?=
 =?us-ascii?Q?iLzTbxzSl6ufvIG37LMF3b20iL6JcUQRtOQBTjeoKewtVgz+EpG3oV7FfkfR?=
 =?us-ascii?Q?IM+ghwqYnIaXIR36Mi/R9EPQKAf6UOW3Rw2wvwFMLe87ZIHkaYrci4HuuLYF?=
 =?us-ascii?Q?WDu2HDhFsz4LsVn8vfo3kBiLLmy3ptD0vK8Ou7MdAfL3gw5wFzuToM2v7eqQ?=
 =?us-ascii?Q?DePsdEJEjnfZY/dwbhjZ2o/a58Y2Ia2rrAGzya0tbPOcfFPE1I6CgTFewMXa?=
 =?us-ascii?Q?lHj0QIVnD1SeiaWPjxQWaD9k8hXRJ38BqPOx2L3OZhesMIYTBMMrJjg86L5r?=
 =?us-ascii?Q?o6sWImkUN7Bcm5u6g4YWf2GRoNvggYqRCJ/MxQkp6SWFJFeiZ6OY/0Em/fTx?=
 =?us-ascii?Q?fmR+wqmwCxxU4te/Lyj9oZblQ5UPymGAKQKE2q4pMIWp3+jSEhyLE54s3Tnx?=
 =?us-ascii?Q?UyJtfci87A7aLX0E65CYMfLxhrbXSus4x4euSB1JUcSKhpY9l5fTBW00BKdX?=
 =?us-ascii?Q?KE8/CvOhm580UE/P59qrCkztyZImXGUxJ+72APlx?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c833e37-13d1-4b73-08ea-08da8956b4cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 00:37:51.8615
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ypWJasdSTgjT0O2WLn+fjJ7L+/HjfH9sxdxePWC+bTNuxr2tnSdtKBv1moKr504RXH7Xv28fFU0R4HUOlwpFUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3968
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin
> Sent: Monday, August 29, 2022 8:33 AM
>=20
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, August 18, 2022 12:07 AM
> >
> > Done mechanically with:
> >
> >  $ git clang-format-14 -i --lines 675:1210 drivers/vfio/pci/vfio_pci_co=
re.c
> >
> > And manually reflow the multi-line comments clang-format doesn't fix.
> >
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>=20
> Signed-off-by: Kevin Tian <kevin.tian@intel.com>

Ah, quick typo. Should be:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
