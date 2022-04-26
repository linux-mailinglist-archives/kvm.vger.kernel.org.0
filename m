Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7D750EF68
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 05:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243481AbiDZDy3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 23:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiDZDyY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 23:54:24 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA6B127A60
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 20:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650945077; x=1682481077;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=w5ZRq+524BdLl3coWd7Lrqs6N1nFImhM8FE3vVcWB8c=;
  b=j/6WKwajzc5DXv2WCo3wsgt7HmBqXLQAVsLvY5EH8JFwDilRtReD5rcq
   70PCa6acErKTEMvw4Udljtme9A3EJJn+Jqjzcn6aiU/z+UiC9jEvDWxHg
   HHGcNCdChCORv9vLGScu6CJspVTkUrhYXghiqCpET36Gc7lxqGU6nUPPw
   PHNV+g8u3lM+6FovL9okRI7bCnxqozH/cIMorkrkO54pXq/AWrmVyPsdA
   YH3YHumDkkkp6X+kWBLPekVc8w6+wWVAFBP9Nv2asAiRXMoLHMl8T81DC
   I+WHpPJ3sS/CwIeRtcC/0+Us5dqupB9RfASyu86FpB0wOebKXR7QiFVW+
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="252813592"
X-IronPort-AV: E=Sophos;i="5.90,290,1643702400"; 
   d="scan'208";a="252813592"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 20:51:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,290,1643702400"; 
   d="scan'208";a="558072673"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 25 Apr 2022 20:51:16 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 25 Apr 2022 20:51:15 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 25 Apr 2022 20:51:15 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 25 Apr 2022 20:51:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U78dZyH87eQ1jd4tQGY5VG4ihgf3h1yl1HCNpQGXPbYut0/OdWi0HmButarDgRKeSwGe7m6vePMOoYC9KT5/rFTm8CBHZzzBs98I/72eOxKSbAd1I9cFwLtwRb0WdcOAav1QDTpjbaH9Ctvyg0o3ooJMlBR4QUVzNHbBI+mszG9BSo5wyT+wtPxZZ1ZP1/hBVg5w0epzpiHEkSCVIZ13hys5nEcdfNznwSuUoMS8R1csaAx6qs5EM+bDoPiPDvCsjyrmeWIrwbud3mBIER8G+MtTuq7eAxWNwt50KhFcEJkft91+Cdi8djWBQoPR5Mztz/ZzQDMnvflkCLlnNzM2kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zozYDmRoPSeHpWL7DoZ0YHtnj2XzyGxKe9xqdA6Sc8A=;
 b=oJrYYr0u5WcPzSeoyjl201l8567whFXc5jlXs+gFI99X90NqlhlZ2TTOE3NIsmsSn0AzqqE7Wy8yyH7V88dEvO7ddkN6ebrn9HM5HvOG1ZN1cwbVa3ZhlYZzoe9+QH56wbUaTPRMI/Dy6WH20OJwp94zgWcA4znMEdhuORlr+TnBJePjZHz4ORiPBQokoGb0xw5yquYVV7AvzDRHCz2Iukj3+sBDbxJ0PxvK7hmcj088qCpvq506czjuEk9odwa8z35lz9YtKDsaansVyfgqewnPWsNN7SAQoAD6hyIsXu8rf/XKnD8yvLyiFO/TGwtnOyYmxK0IanxfMF8Wpfpseg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY4PR11MB1304.namprd11.prod.outlook.com (2603:10b6:903:2c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.18; Tue, 26 Apr
 2022 03:51:14 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 03:51:14 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Christoph Hellwig" <hch@lst.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Longfang Liu" <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: RE: [PATCH] vfio/pci: Remove vfio_device_get_from_dev()
Thread-Topic: [PATCH] vfio/pci: Remove vfio_device_get_from_dev()
Thread-Index: AQHYWPhnJRkoyk9DOkm7ZLOEthlQrq0BiXvQ
Date:   Tue, 26 Apr 2022 03:51:13 +0000
Message-ID: <BN9PR11MB5276C7829513E8477DE7BBDB8CFB9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-7f2292e6b2ba+44839-vfio_get_from_dev_jgg@nvidia.com>
In-Reply-To: <0-v1-7f2292e6b2ba+44839-vfio_get_from_dev_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61571852-648c-45d8-e811-08da2738027a
x-ms-traffictypediagnostic: CY4PR11MB1304:EE_
x-microsoft-antispam-prvs: <CY4PR11MB1304C7636A4D94B43DB8F1848CFB9@CY4PR11MB1304.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FXKPIHyitOET1Ba4uFaVTiM6YShMtyj6ivF+x3pAh9pqSyp/H8Jda3Qz1U9aXUDSpYVfutwz6LhjAuZ/e+7Nz7cR9Oxn6NlJzRzo4n8LKtnyfNZ7mmd89y8Ah/1ePpqLwTzAloI2ZogrB1ihL4b38kHd4g/+u9Gva0rHKUzj27qoScDjCCZN75ZdKoY1A2QvU4+/jKGmGWuFT6sWCU/127jqyyc2CdOIZ+YhzPbp+G049SslYD+a8RVrh886f+nHZJcxU+3ceJkHZ9lAvbMMRLOZz6JIJ9sDoZ4brJZam/nGdzjc2kkbrgaXzmwAt1K2jM0SOBQxHmgOHUWqezi3SnMQGiPKTT2ngIeFPpPRtykZnG7bc8yyz3l8UlyiKHIIacW3ev6yGsmIVWEDF7VtgelCKk68p7BHe4mvlmGvyLFuKohuGiVriDJgNHCdDpCOKRhW0uFmQKM+nNvgscP3XVx4RXEVYlO3fxN9XIg07p9hUGFoUzxQZ6uokU56DDQRjqfmgrm4iePBXYBEcyze21QU492Y3AA3RC23R1qotcsNcQIuk1IDLtW3WQBTkSxU3mEruMRmq2j4Zo6oVVg9UbF2J2sfKdWG/xOP+CozUijtcVtLeXKCeDqn32tPQHYe+lZENFpLAWoBinkaGWlOxn7pGAvZettPljxeVqlQuIog4Kf4Ia7AHFT8nhBErRYaS+y0EPWWDXemy5+7DZrg4w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(55016003)(38100700002)(83380400001)(8936002)(186003)(82960400001)(122000001)(76116006)(8676002)(64756008)(66946007)(66556008)(66446008)(66476007)(5660300002)(38070700005)(52536014)(316002)(6506007)(33656002)(110136005)(7696005)(9686003)(26005)(71200400001)(508600001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?23HzwdS/IOzQIReBAiFviu25z4Q2JDeNEF3v2rYkRBiHq1EhTVOr0Lkcczei?=
 =?us-ascii?Q?zLKoBH7RZ/29xT61rUr+QBI1Ccd4Pm7YBD9rLezMXfbLtZJ3eEav/qre6JHC?=
 =?us-ascii?Q?uiMxue6st8JNcJW4kDEZemWnj64RC210G0jClcrPdxQBpFhSP2pBcpe3uBhN?=
 =?us-ascii?Q?QVQZ7S/MbPUvTKz+RRi7xYedWUdJvUaAgFW0UaEvNZMDPDjr/4ZB4vYolPKn?=
 =?us-ascii?Q?K0cjvoGV846AtFZKsExJ4ECUQzL+5Wy61wrD85kP7dBTg5aD9TLJ/lgBNxVY?=
 =?us-ascii?Q?F5yupvHj+Er7ajCUsTyf6D+ZmqafwkiMBXt49bp4nQp3GKeNnmqqZJ3qrnpH?=
 =?us-ascii?Q?fhroYylIkq4ClbVU4yyjJ+KFTtDCFGi5yLbfZA42cPaW9wL0xED8o2gdAwmT?=
 =?us-ascii?Q?sYyG/U5lNcVfE9PdIWs/LbSwq91b/WqpPYidFQWexdCAevza6p/1jaIlb9dF?=
 =?us-ascii?Q?mSukwAh2ofOnll5WQeYGcFGQev36bbWLZv1ZQ3kMM55J0tdnCRW8DKL6lJSq?=
 =?us-ascii?Q?qK1dRzhE1PnrNOMHY306wbJsGoEy/5IKR9Me9LPs7aUSEIksYV6bUlJc77ir?=
 =?us-ascii?Q?TIlR/UfkU0K8g2slN2eFHFzVFaxdeH5+kE4N3HbiYZghCD6L5wKk4khPsdLr?=
 =?us-ascii?Q?s6dd+QfcbYMPcyGCwIrY7q3msFITR+RLmCR6C317VJKPAUaTsaAPt3N9w1d1?=
 =?us-ascii?Q?hyHp375FE2Ome5cB12+wT77tmpUnASlayDYqQyM/ubE+foBm+FwMyDHX0V95?=
 =?us-ascii?Q?EDr0FmYfsSjBigWb8kJVt0TNOMfwaGmPH/SqYq9z9AJ7Bs1cXHzGF82Xa7z1?=
 =?us-ascii?Q?yOgC6XV7B9rcNJDxt4KCvJEOil8jaBY0/a3J6wqPSGAJjd1MpQxEhG68KPQG?=
 =?us-ascii?Q?XRahJW4AL29z7R3oPSmlc2DCWxgfwckDNQ1ZKk9Fu5Kpp2DW0QRpNlSWHFXR?=
 =?us-ascii?Q?1a5YWYVNbaF3VTshQiIlvEtn6jepGzv5DOZymMtG07s35gJJ/F6n0MhPF9bX?=
 =?us-ascii?Q?56ez9yObNVXfT4iKV7YvG9LBgpRXo0b59BKKJtDmKlZgdpKWDVSE4ld0LBvT?=
 =?us-ascii?Q?Xg3adO6yLBFqbSVw+ylIl5hwdZPKA8RO7GF3ETuonWvjg58qx2J4nSCIRCMh?=
 =?us-ascii?Q?9VHoc74j09+4xWYZE1XVkaeJpEPJxMCZW/ucMO+3Uw/gztGmcwIfPHWp+AZm?=
 =?us-ascii?Q?U4WCFV/gjWRPSdm05FMZ1JT6AftmluqgSwjc8CgmRez4Ou4KX2oLTjGNNw8r?=
 =?us-ascii?Q?gi86V4VhpUSyP9TgLX1ZHdEc2wN71lptLkJCZqAiJxS373RJBCVkYttVlgi0?=
 =?us-ascii?Q?D9CnQdQERkqRv0WwPMFLP83g0rejD93TEtubNOhFyRbWgy+RyRJMmVOxS0FY?=
 =?us-ascii?Q?FDW9EoivUNoGKTHMkdHXJIvOYtEhq2z+FP93IIVApCtPsg4jnb3t54QBGquS?=
 =?us-ascii?Q?htLzpV7bHB9y7LnD8S9Bxakk91jHnrJNaId0VAv/YrTRh6GvLD6RoXYPHufn?=
 =?us-ascii?Q?lyACxGR23+QLWEPIWPtrXyVngbDwBfT9E6F6cfnPyHRIRR9Va2zbw+QcqSgO?=
 =?us-ascii?Q?DCEe6FF9Hsh9kGmA+LX7UCyFi9PbBQeSMYGKue0Vd6wls3wKr+a0cGYIlvcl?=
 =?us-ascii?Q?b0ucK9/v55uyIO/ik/tR+brhlwmVFnWTgbgl+vMEJVfdy3pYRDZ43cdWic8I?=
 =?us-ascii?Q?9pG6uD2fEqWeg/TO00CMlLyhgD+Mlb6dOBLNZ2WIt2RqCk2cCtgPNeWR4dM/?=
 =?us-ascii?Q?yIbVeVI2Rw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61571852-648c-45d8-e811-08da2738027a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2022 03:51:13.9295
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wBQXqVYwEx+MIPJzzS63CKpY5WEQejnlel1UjPjMvl/w2FfBHOnLUWRMzBkAGDasLBLv/CpKnC0HWJGTkChJzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1304
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, April 26, 2022 7:01 AM
>=20
> The last user of this function is in PCI callbacks that want to convert
> their struct pci_dev to a vfio_device. Instead of searching use the
> vfio_device available trivially through the drvdata.
>=20
> When a callback in the device_driver is called, the caller must hold the
> device_lock() on dev. The purpose of the device_lock is to prevent
> remove() from being called (see __device_release_driver), and allow the
> driver to safely interact with its drvdata without races.
>=20
> The PCI core correctly follows this and holds the device_lock() when
> calling error_detected (see report_error_detected) and
> sriov_configure (see sriov_numvfs_store).

Above is clear for the change in this patch.

>=20
> Further, since the drvdata holds a positive refcount on the vfio_device
> any access of the drvdata, under the driver_lock, from a driver callback
> needs no further protection or refcounting.

but I'm confused by driver_lock here and below. Which driver_lock is
referred to in this context?

>=20
> Thus the remark in the vfio_device_get_from_dev() comment does not apply
> here, VFIO PCI drivers all call vfio_unregister_group_dev() from their
> remove callbacks under the driver lock and cannot race with the remaining
> callers.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Nevertheless, this patch sounds the correct thing to do:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

but with one nit...

[...]
> @@ -1960,8 +1942,7 @@ int vfio_pci_core_sriov_configure(struct pci_dev
> *pdev, int nr_virtfn)
>  		ret =3D pci_enable_sriov(pdev, nr_virtfn);
>  		if (ret)
>  			goto out_del;
> -		ret =3D nr_virtfn;
> -		goto out_put;
> +		return ret;

pci_enable_sriov() returns 0 on success while .sriov_configure()
is expected to return enabled nr_virtfn on success. Above changes
the semantics.
