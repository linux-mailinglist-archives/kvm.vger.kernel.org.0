Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56797695C0E
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 09:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbjBNIGd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 03:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbjBNIGU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 03:06:20 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF96323304;
        Tue, 14 Feb 2023 00:06:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676361970; x=1707897970;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ylHi1d32G3jt170GQarQ5x/nE/uFdLPLA0+t8lHzg5Y=;
  b=Avc56pv0KRTXHMSpnv+L8PJoaJx07Kh/boCV8NplW5aoQnLwe41z1kck
   IQgwnYONHHlMeaLa+KgOTR8VhPioq3Afy0C3aDtcYN/g2u/PEcVN300yV
   fBN51wsrmQTn21iAu9f/ivg9O1e54NNaUhojaH7VNRYXIkifzYYx0iznY
   30foM09vnPKwZSFjDFc5BsPmzn3BJAD6Aqzo/eTfrtwGqSzx+RuZ8R6Ft
   u/pMXZMJuvp6oTXoK7tiVT4HDypuRRYVS5GZihvXt/B4saJk+TJURSOHG
   3KRPdQTUg3hk0v7h/6mLmDPRRVcZrNMSEUEH0y4RlXS3ww0auWILNSNaM
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="311465089"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="311465089"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 00:06:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="701573234"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="701573234"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 14 Feb 2023 00:06:05 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 00:06:04 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 00:06:04 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 00:06:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cEEqAdVDgYz5ezEbjCHlXjME1yPwxweSCbdHpTG73VoTn0ekaeWJrawwW1KQIyU2wV29X602k/cc1EmvYvGFOz75OL+z+S5uFfjoLWopr/mexVaJ9TEIh/m/elTRpz4rF84ZxZ5O747jK+WioJQt0Qi93Fhg860boMnKQuz1MS0nKHD8QBJt4OzI87Zhob74mA/NJwakqNHYMrQTxNXQheS+jtwyZ35T3UG6G/7lzm4YATHRgmvqrtB5tVzYRbrDhlCVcLL16bjuzh27yipKdcW4oqLLdBnqFw2m2FDfPtAiEDf/rtX2icRNcd+f9XqpYdmvVDZCST3qOUylfWFxZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ylHi1d32G3jt170GQarQ5x/nE/uFdLPLA0+t8lHzg5Y=;
 b=MElrwq0HxKg0oxxI/lx8rhm0ShOUED+S5WmcYpI+cnF1e7AjTOEQQzrl3t21ELl/WOyqKiLNo7hm8N5fkXqHDek7fzgwqDw6K414bU7ASBoaisLFDFbcd59h19uLqYGJ/V4BZvkwDYRsqq6Itl5faUloo/D5cRkiiL26QZisZqCzf8kvFFW8npHdE+YodRQHNVNTAzM+mrL/ysfUyn4cDxnJIfpSqfl9+kBjulmUoSKBlkyDGKKb2WohIb1IyKdch36rxgU6F5XCackGyvrJG6OwVGLUj+wc88/w7ImLUX6rWwi+QZV2tC+q02qsshkMVWq5YALPbVkCPFOGkQGMQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB7577.namprd11.prod.outlook.com (2603:10b6:8:142::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 08:05:57 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.6086.026; Tue, 14 Feb 2023
 08:05:56 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH v3 09/15] vfio-iommufd: Add detach_ioas support for
 physical VFIO devices
Thread-Topic: [PATCH v3 09/15] vfio-iommufd: Add detach_ioas support for
 physical VFIO devices
Thread-Index: AQHZP73T7aAoTX5Lj0CTppUjQva3+67OFsSw
Date:   Tue, 14 Feb 2023 08:05:56 +0000
Message-ID: <BN9PR11MB5276FDB3A6A1BA024BB6BC1F8CA29@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-10-yi.l.liu@intel.com>
In-Reply-To: <20230213151348.56451-10-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB7577:EE_
x-ms-office365-filtering-correlation-id: 13063540-949c-41b3-2ae4-08db0e624d30
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1h3Dh8+tY97+aiuoSwMwZ4ffRhdgz/AE83nCuDfF97Va32D1pS6vyzF5pcyaPe3eRd0RJjazZgDMwIskaZ31DcSkeir/6nB6BG8QMWP6OF/EPDo4vGomjfhRXoUp/h1ZxtfgvQK5CqSaFtwL3d77EsR8/r9+Oj0muGndvW0lDnSzu7jBgxI1ysBiIbgRIwE6GLo8oIaC1T7JHVBh3n7byDkFvX7tlNBeib1VIXusHmupnX2MCaQzsX8VBsOcyPeuMvB5q/notKI66QxIXcfYdpbkcUpxkLPHYjFYPhFRBqvD8M3QscCwYgaNZTY3EilDEKpt2Oa1j1nzvbZtf2GXe/uFZFTQCjBwxa4ESfI/6Uwl81RuUnea8GlcGOv8XoVPR5iMRT7f7kTZvuUgCw20+xSGFlCuKd/mCtXqU8gKJgE8cpA5MVeds9kvGOLVT2Ab2w78EIyMGXixfKn+HvQEV9GvQnDwvBFCaTDqFp/Ajtf0aqo+/FEl2wnl1vLexYkSNEE9HnASRpyhKoJSn120EBHP3dleQz+MACmgDs+gnSOSlCS4NXw81upn3n/yLIENxMf3z5fuqZZpdPaZb/hEDMRapt8HZy8smOpvqdt7SfbxHueAw5Eh2ijBpTS937KSz9PSJgmAbOxCbaOS1aWurW9uamvjARm0S3QRvRoR/+CbRD/xuvy4Bhe7V0FvRo/lLTdDoi8gW5lhikrtb+V+DQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(39860400002)(366004)(136003)(346002)(451199018)(71200400001)(7696005)(2906002)(33656002)(55016003)(558084003)(38070700005)(82960400001)(86362001)(38100700002)(122000001)(478600001)(9686003)(186003)(26005)(6506007)(8936002)(41300700001)(52536014)(110136005)(54906003)(66556008)(66476007)(76116006)(4326008)(8676002)(66946007)(64756008)(66446008)(316002)(7416002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aJBENsu/yTgGqTVnFzePLgoS+iWLOxsxVAmBLLmv5/LTi4IIzSaVEdDpEnuP?=
 =?us-ascii?Q?1QqqlxqmT6OPsX7tWjlMtoCgapHv1U8tuCXJQqjsmRV+aUvZbi3LYJ0WoNDV?=
 =?us-ascii?Q?9MlPTMUaad6Ye1i8O3HP98xD+abXLgShTXyLnv1EaslI3IorflAx+oAPCRzd?=
 =?us-ascii?Q?r/h3SSo1sb1/A6PQywv6xNNiS0ruE2cc2vLeCv0nVrfubB1QJaZQWtyN2aDL?=
 =?us-ascii?Q?c7jC4vMJTEBVuDJo1bSQPO4PdqjP5b4KGwWUIfjE7VC4STYvf0PHkY7jk0h7?=
 =?us-ascii?Q?4Kmq/0Z+SxWrgRVz28kmJ9BIgIWR8CvQHajUSrBEuREEVKKaX4e1SV3E/la2?=
 =?us-ascii?Q?le8DuOPnJdj4+n8Lyj74lsmAhXE4nO+38QH3hrF+TRkc0FfU5IaW2To6IKw5?=
 =?us-ascii?Q?GbyXUnfP+tneL3mPnB7PGedXQzMiA+Tj2FWbTa4RAiX7CL+6KE9d6iOQqQGw?=
 =?us-ascii?Q?RpG2xMv0fD79k6EwqxSaOQyyV+m55J9gjQOxnfrmXeGtGIc0ksRMlNugTFFy?=
 =?us-ascii?Q?Gc6zAm31G+hFgsckgv0FwKbnwKBlAy2/OK61+W7OO+JOa5dBwDvr6OTYZWoR?=
 =?us-ascii?Q?T7G8IsuadknaNuYV5udEnuttUW4dIm/KmmQ/WyngZY7m+IBFGzQEB0JHAOAl?=
 =?us-ascii?Q?Zw4oOhyEzQntTpvkQPpl8rYQLyweMuGhAyOTywiUZjpPMO3tr8dvKZRIU9z4?=
 =?us-ascii?Q?eUiLiynFAOa0QYDV/atzhyQeZCuBM5g9sJQB8CFhmxQqpcg47f8ijUv6QOH0?=
 =?us-ascii?Q?yJWEbkAYGMgIqRcUZABuam1ePhE6d6+zrkzdeD8hH97nTNBqqscRH7Y339fL?=
 =?us-ascii?Q?yzyGDdrNzLdqLwZ5SVsNrFxXR3XvXhwQrGLsbqoKVd/oDxl1bpjsMZAxX+Ci?=
 =?us-ascii?Q?V+/6foOYBrOAC7ES6PV/0TBnAagmGZ3sM6j2bG6DWvKgis1VyejFCSPX0xwj?=
 =?us-ascii?Q?YX39pGgazAaXTaJ7zxpK/k/pzMuVROCrv+cSkYELAoduNUasj1RX+0xDRnqO?=
 =?us-ascii?Q?Esn88A3hlyOYzG7P0kWYrmsSCZ0E1IjM8wKlpdWeYlMKfmD+9O8G/9Ale6zs?=
 =?us-ascii?Q?eP9Oy5WZFakWWjhij3lTxz4FZr/5230txLeyDp7uqcofbYnIkXdyC+H7YbWW?=
 =?us-ascii?Q?PPM7tKuuDFUv9H+nFG+IRwvLPStjYptVUZ9k1ZgqE6CmCA6ZhCbH9tKcCLKo?=
 =?us-ascii?Q?wD+QRZAwzmGbmKKQ/tArtWeeHZQxRq5DfPzHEWir+1SSwBKtvZfkX7BbML9x?=
 =?us-ascii?Q?BdJiW5SK3xpfb42Q1CyfIAOQc4DLPu6yYwWQtHlgcMUIoS5cLFvMCAadpGvB?=
 =?us-ascii?Q?JYW6qvIqW3F7Cpi+8wXr2WhvR/kf3v4hTYoK/q6HPgLGB8M7FmaEfv/o6IfX?=
 =?us-ascii?Q?NwgHKcsYLWCNzx2sr+Wii7nuBxIQuonldOC2Gpk9qiEriobbJkkM14smagMt?=
 =?us-ascii?Q?F0/QA/YhfIFAXPry9D2NJ7xFUGPBVGe/p9jVX8OJPRfUaIcWAxqmxGCs6m1t?=
 =?us-ascii?Q?MTI7v02tPIgZK4gI3xjxEZAN3UlkpXXifmPfp2DpEu4QhHldGkm2aDuk2C12?=
 =?us-ascii?Q?arMC+jgvpfId7YVIFzlu/W3ese1Cb2y/pmmiD1Nt?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13063540-949c-41b3-2ae4-08db0e624d30
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 08:05:56.7487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G+Hf+L6p5+iEiIct12Tac8lf+mntDAdTcRHHFnSaXvBVllr5P6mrFqcAi4WKsTnvN+rUSzqNwMGVHPVttNQZUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7577
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
> Sent: Monday, February 13, 2023 11:14 PM
>=20
> this prepares for adding DETACH ioctl for physical VFIO devices.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
