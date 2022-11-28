Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB9FE63A281
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 09:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiK1ILQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 03:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiK1ILO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 03:11:14 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E36167E3
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 00:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669623072; x=1701159072;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=u2Zz7QLeCynPYnRV5bx/L+zaJjUSd6o93/iNOsmSKd8=;
  b=mrimEWYQdgSPEf1sPmWW1snjt0DRk3+VMEAkiOjdfaMbqqyjuJYDsytC
   DC+vEZQ4EHBcF6Y7RI+s+DoXC1dNzZLXydVCkbhpAjUzDIUCg3kx1qnQ0
   slEs85eSflTm76yocrDPuJjdtsrVWp4vGc1rQcialRYcHlvHueZWZucAM
   wrkLl2A7NMyK2nNjPegyzERj0Pd2/enEv+l9ROkkqVdaRBeF34L2nKO+5
   M6+DAC66Et8DFFyBoN+k5fBE55+lG/9uhSVWod+sgh6HI9Zv0QQzIdebR
   /Yey8WTNq4/sYHGu1jIfFrsE3NH/zTOASnL1OmyX73+Gf9IqYZqtMU8pw
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="376914231"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="376914231"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 00:11:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="972166428"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="972166428"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 28 Nov 2022 00:11:10 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 00:11:10 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 00:11:10 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 00:11:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oWjO1qRUre83GczmUsxgKNBc+BdwOqEnKYrGiFvdJxY1r0whqj3EvGjblk+BbBZO06BmeYLmBTxHnfnMzQhej8cHSM2jjKX3N8Cpv/LqOCKNoLRjIdP6F79y/eQj7/To/IEG4IOM9MmTN5T++7ooyWgCpdR5s2OynmyQwIZpez1PGUeDW+8khaBAPhwv9uewDBS1dFd5UpOypVVO7z14c2itRiHzX8e5pg5qt8FBi9t65/IErLfGYutf7gLIDuhRH0Art7GQLynkn+AVfDzgOhgjnI3EqBdFpzaaJ93KTzlJq4QC9kld4+sclfPGIyhk/wvNS0lcK9MKoEPzg3oiKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u2Zz7QLeCynPYnRV5bx/L+zaJjUSd6o93/iNOsmSKd8=;
 b=ESo2yE6lkIrhS0aKuWt9q3KqWqro2kvY7lD5/gY+0K+6JY24MrDjzFeElf9n9GPT7jllxsx7e3X4NxSTSMt0U0aDC0+9il6dSCnZpKNfG5M6XNIgnmxhffGjM0jUf5UXOtenxBrlqfAataD3Z2TbWTffCjzd2K87mO9vZc6WM4kl/DoyLEo4QeRPBN134a+i0/f8bPThNPHzrT7XqLvxwu+fKuYJpQqi46QX4MJyHIlXMiZXlHAuWdGa1hZMXNk8XTPdD7OELVZ68zYKCbkZP1nzmGHP0zFNfoRtFGIdGxwzAyQ1TTRH+FhxSMPIAG8DV/upGmCoMtZJ3r4Kq1e4mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB4578.namprd11.prod.outlook.com (2603:10b6:5:2a7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 08:11:09 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde%9]) with mapi id 15.20.5857.021; Mon, 28 Nov 2022
 08:11:08 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC v2 04/11] vfio: Wrap group codes to be helpers for
 __vfio_register_dev() and unregister
Thread-Topic: [RFC v2 04/11] vfio: Wrap group codes to be helpers for
 __vfio_register_dev() and unregister
Thread-Index: AQHZAAAYn9KVe3yEqEGHdAFDzI1Iv65UAUpg
Date:   Mon, 28 Nov 2022 08:11:08 +0000
Message-ID: <BN9PR11MB5276F0D7F1CE2C5AAB629F218C139@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-5-yi.l.liu@intel.com>
In-Reply-To: <20221124122702.26507-5-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM6PR11MB4578:EE_
x-ms-office365-filtering-correlation-id: 76a3dc8e-9f31-456f-2853-08dad1181adc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3W4zc4n5EiqlyopNU11cJ2rgpaF3vkLk41mZ9C93sRJYf5GclRCNEMlOM2SInd71YvDT1lNcL2GRMGfgjGi3m7SNN0QEPGSCNkI2ta64tYPGHMtQUuBNZa1NzvdR4h/YivuwPnKyyAsz/4Om4aN0uLbVXbPqM/BRGz/Ic+u+pT/jjlkYK7e6P7K31906I/shmF96NCJB1OhzwK3nYHmggMmNNZHnFi45JKo+attBfiVSBaHWi0zFqS9sL6Qme2Tb7wAnhRRq6DRnFhR/f6kZjcly9ZAufcOWPMnDFaVKxNED1y5Pyl0+44aKEPXYR96zuhS6gryQB7MLh35fGnIq3jQQU8iWkQCd8DVD5ER9eNKDL4Cl69duczznLs7sUs0DszOo/tLl+ri/JawWy9WFFS8vK2qIqb9r/1yxko8oWiWOsIjsU1I5dhOhlg+WkW4h1LIsRaJBkkb9Cwi/aY/9uuXMUTW7ehPZU8utU7lk18OoWcJRTkmxVdC7QxX9C0V0eG4F5zVp9kVp5/BbxwHrVuB09fVJ5asQa7E/JnHijNhNx9GXTt9bNhJB3x7GnF7GtCtEEbBGIvHero+3OCsyGbaMn7A8IZw+xxR1fmDU3avw24D01Hg7U1JF71T9fyFu8mPjV0TC141SJcNziSzsw1sYypmQLR9n/ZlRlrfJTJaVICGPUlHbmNVC0tV9/rllFSw2v23MbSbDMScU/kji4w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199015)(26005)(38070700005)(33656002)(86362001)(66946007)(55016003)(9686003)(53546011)(478600001)(4326008)(66476007)(41300700001)(66556008)(76116006)(64756008)(8936002)(52536014)(66446008)(8676002)(71200400001)(316002)(110136005)(122000001)(54906003)(82960400001)(38100700002)(4744005)(5660300002)(2906002)(6506007)(7696005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?m65GVY+dFY5GvJDUDPkw9XAvIGbmcJJFiqvCnHMm1iAEmKvUsS43Hqi/cJkm?=
 =?us-ascii?Q?YbBxGpGdSJSKnSc5uo5eLNjU59VmEaPasLrI59NXu+XDjOIbCGpCzVWlkIEC?=
 =?us-ascii?Q?dbfj2HWGEHiltyS8Owk24VhCVs/HlyRaO4NL4PY2+2xDCDG7K5TpdjTABYph?=
 =?us-ascii?Q?bY3/y/lbDhN3KbtNJBHh1mkLzs8K3ePKVt6n5C1pbcbwRTCrLWhWM8JBRuUM?=
 =?us-ascii?Q?VrQgZDKvftH8lrTw0tBDpz4+/UIFPZKghGLPdA/jxJagMsI9AxTYb6kRbg3Y?=
 =?us-ascii?Q?0SF+a2lZEOhIT+s/BJVinHZnSenpGF2DhoO4l2IECZ2V8OsbkSpS7ur09Q9N?=
 =?us-ascii?Q?jMKmIHKx1Uw2qTJEUQyPFRSUuvIEq9tJKaohjo5B0okEK8W69sSHyiVblSt+?=
 =?us-ascii?Q?R93L5LWUNk15tj9FiSYyZOMNlsHE7vJeqxS2fOBL0hiDDDKnrYdgoq1bn54T?=
 =?us-ascii?Q?Ga80cbAy55G66rhzRjsgmcUyUo1CvhpsxbBeumm8Bd0VbjOUoanYFiP6OZFg?=
 =?us-ascii?Q?lyhBXhnSi7gtewxWJKjS7C8gjrVVOz4k5xLXXgomfphY1qtcZk/RegaLnrxs?=
 =?us-ascii?Q?6UBFu9j30Hl+EExPViz9Pf1TGMyVkz0eSCxvzuTJkjhqNfbpTJKHhhy/OM63?=
 =?us-ascii?Q?xoSrCxaEc1mDIdc7OE1PLcsIzyknwkjrQfGUa/UArBDpCJaQXnwbFlH4C1Kp?=
 =?us-ascii?Q?9PiHvz5DbRnG/cD54iVpHFRCOZuMwmkbdsC9pfFOTMyO5YQS6W20AHSEQbGV?=
 =?us-ascii?Q?aUHlgSKn9feL6JC0Pjh+b9DVEd3UTwT/jBNYAHOR6o0ZIzGSVFy65WbEDd6k?=
 =?us-ascii?Q?HTkk3saAV2yusYkfRG1T4uSBBgwMBUlejopbU6bP1ZAyldFk7MMGRJFsdFBi?=
 =?us-ascii?Q?IvIjv1Fk9JnGR1WEceiGlZBtxqFj22kPY4lvwpfbY4CQcN0vJgUv3MqaouA4?=
 =?us-ascii?Q?M9ylLEYD8L7xipAcTOPfO++UtjfqY2yyuzmx6akzWMdv6WjgfzfppVCtUF5Q?=
 =?us-ascii?Q?tJ5sToRtZwrKCK/9bkZJ6Dv9AqFPUVkLiV4fMNq7BBwzZ9vInbIB2PCOhcfX?=
 =?us-ascii?Q?EGIS9iT69LK6rNdLC1TJU2IxUj+oWX0TWYoV5YVOAafEJGyY1HOsdl04PZwC?=
 =?us-ascii?Q?HdOTWHgePhOi7hzE6VrY/+jAZrBANs6jma4dHzat8yzLV1GfiSQyP+oye8mA?=
 =?us-ascii?Q?T2DoZ1cPOkM8XoLsFZDVMBZJHu5mA09u9ODRW0eG38lrf0l55700GhWpSDlG?=
 =?us-ascii?Q?shtNIWZ4q5kdH6o3pFhnfs7VwN1j5rDv1cCKgPxZ7US7PNUOZ0IjfU/yqa/I?=
 =?us-ascii?Q?ys0eVriwmleGMZgOczwhOZkemzqJ6hVsYOdg85Al/QKMsLbpqungcDQS2T1I?=
 =?us-ascii?Q?Xroj/w5YNbMsCYIGCKLJKjop1KgspInE6bfUBe/OC/nYwFAnnN8ix9O7A85H?=
 =?us-ascii?Q?eDkh/KttCMA4SA72XU+vkvtG4HZNDAd1+qn//WQpSJo/ly0EDM7T+BoCtOko?=
 =?us-ascii?Q?UDB9Uhin6DUiVAERF/e6c7hZ13rxwJDWJS6SbosjJ5giQJO/uS+4I1gOBmrT?=
 =?us-ascii?Q?nzGP5pAKir7XJHknJSJEguHsTHE6LnG5TYyKQFzp?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76a3dc8e-9f31-456f-2853-08dad1181adc
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 08:11:08.6246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YpQT1VT2bg0lK0RQ/oQOTID9prJsfCVg6uUpruv1B0jynDf+jr2gAdYfT3qp84jVf+LKJrz9mfnvfpv1Eda/Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4578
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, November 24, 2022 8:27 PM

Subject:

"vfio: Create wrappers for group register/unregister"

>=20
> This avoids to decode group fields in the common functions used by

"avoids decoding"

> vfio_device registration, and prepares for further moving vfio group
> specific code into separate file.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
