Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8407874E74C
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 08:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbjGKG1B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 02:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbjGKG04 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 02:26:56 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8CB10C4;
        Mon, 10 Jul 2023 23:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689056809; x=1720592809;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Zt56k/ylATpiWcmI7Gmuu8RUv+NfirBJziZ1r67mpaI=;
  b=cVYK4rIy0euTP0n1W85Fo/IoztsQpM6Gl3Jwtfp3vuRH0AjO+1/TlaAJ
   eHTFZtztZE9BpIxxz5GKBqWPv73RTIbOH1lSvtxVDLf06urZgzI0S8nBP
   Cxq2ixhvyv2lAzJYuYGfpXzO3mUNg/6OXqDmF5GunzVuI/oaGadbWiDGW
   Sxvfoq4kLp/ictq3Di9mjLxq9aOiifRUR6gDUCmS6B7XbF701NNU1cbGn
   EFCoS47IHNX3zoZTxTZFoxl6zP8i0x0CgcgP4Q3SqxgNaQo4xP5O3EKP4
   fXxlR/ENAxmer52T9u77jYcsteQSx5JiVqiV5/UQXzQmNP7MPOikmmQ4j
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="349342410"
X-IronPort-AV: E=Sophos;i="6.01,196,1684825200"; 
   d="scan'208";a="349342410"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2023 23:26:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="671255776"
X-IronPort-AV: E=Sophos;i="6.01,196,1684825200"; 
   d="scan'208";a="671255776"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 10 Jul 2023 23:26:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 10 Jul 2023 23:26:45 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 10 Jul 2023 23:26:45 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 10 Jul 2023 23:26:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GxnQSeOtPu79OAwkG8VaGuaPPVYrQJChaXyan3a0VfXiKBYpwdnC9eEibYHCRLf8p7IpbECAQFrkg50sqZlxPHYUqXhQmOaVTOtAMVmbKeTzVwnRe/hotHPh6Y+EZ/Rdav+nCylexwAD2h/sn4XaIykymVG6k7Izqo3p87nmiMsRArDoH1yVeBzmUPq93sS4JmHZT+qWI7czYfpgML/g4I+gHRL5GvmPPtz2MzHFB4CtXK1eZE4hE1Sxg5y6MkFkVO+pDUPljjVF2HXB6XoJw/XthtLCVjRP1muamronwMPy6zmoGALjZY9yiMK0DwWGlvyRrAlA7ioTCPBn/z3Wdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nFF3lhjHzp7Vuj75/BSvCX25dPw9/sm89tgEb8BIVso=;
 b=Sv31iB6w9qURWUmuGoTRZo8zNTMU18Uw0f2Qugs2gLLBDGQ4QxoRsm0yNECK66S6bX4/UvJ4zMlNRBa5bFjN+hQMZU9r2DaPlZQU/HURFu8kclC7sdVQz7Ap9142eswWnKXBG5DMC4wgsWN0RITRq3ahEBZKOhOq3XlXIjcvL0nFp81I9zLmrkA5mg5RHfU2hyDCVQs0JuuOd1L4DX/vvFlBBgHY5vRQTDt+JiRrTHObhuq7iI7T8QYuoP56l1qx9gf0oqWj9JNAuuB+Sb2+9XlYG8LayzSGanyZzOJIJxI8X7iZogOVDqLNLOfjRTLJXOPR36hYxJaOCa6xdgK6qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS7PR11MB6200.namprd11.prod.outlook.com (2603:10b6:8:98::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.31; Tue, 11 Jul
 2023 06:26:43 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 06:26:43 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 9/9] iommu: Use fault cookie to store iopf_param
Thread-Topic: [PATCH 9/9] iommu: Use fault cookie to store iopf_param
Thread-Index: AQHZs5ROZ0DTU24O6Ue9hKGIoQNDRq+0GN5A
Date:   Tue, 11 Jul 2023 06:26:43 +0000
Message-ID: <BN9PR11MB5276454AD26C2BDC12CAEDE78C31A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230711010642.19707-1-baolu.lu@linux.intel.com>
 <20230711010642.19707-10-baolu.lu@linux.intel.com>
In-Reply-To: <20230711010642.19707-10-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS7PR11MB6200:EE_
x-ms-office365-filtering-correlation-id: 49c137f8-374e-42c0-cfc4-08db81d7cb41
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G2a2fXoRABPtuBBKBBlzRUtceziQPi7l9J39k8kexeZRt9tF+8U1r2K2Gp2aNXHPcIiOYQaEc0v1P488HyQrvDXEvUk3dj85/rrQfnBw/j23IMg7B+ACtBgGAi/yyt0EB5k5vOsx5cu9FFEEPO27dc7411dxd6vn6eJMZjBV8tnlNTlCRzf9R9xZeWZu+PRKicfS4E6SoN1TeBUiITtM+LEfnNlKOdZ3YccLxePrLU05oIA5dVDudCCYve2+aL3NeSXyEhtvQs9yjrvhM/ocvFcu+2X4OxqDfwcfUzBTtjjWuxgMyF9mrlZJ40QFMP5TbjeA3ek/HFlboKpMLF7wk9vPHQeZzW4O3ith92h/Ac5MbGrtmCnwasc35YBUOAZN9zJiYxjvSQqK/kJfYhNMP+2lk1Nyq9t9QLput5V+GY70n3jxIJ9nfUoYalJtHThNiWVRAbsNA3TR7KxuuK7yi+fB7JTSuLoy9u9on0hVpTluvYGBZ9MSVJCPbSPTRnvuoJeiw9NMyQ2fU6X0jUodrQXB8hnbP9GU1P1XEomu4OlvAGuyUJ25aaMRThQ3np1xloQ9ckZkeG4Q+RCG7JXC6fuLPu6J6A3u6N0Ax7v5mMxGfZp+v6ATHyPSbDx7EE1P
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(376002)(39860400002)(346002)(366004)(451199021)(38070700005)(33656002)(86362001)(55016003)(38100700002)(82960400001)(122000001)(478600001)(110136005)(71200400001)(41300700001)(54906003)(7696005)(8676002)(8936002)(5660300002)(52536014)(7416002)(2906002)(316002)(4326008)(66556008)(64756008)(66446008)(66946007)(76116006)(66476007)(4744005)(26005)(6506007)(9686003)(186003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3GRyLW8ybsIeeOPXZFSsyCZdO+hsEs7gOTCEed+V11EOtaK83dlw1OEWPqtd?=
 =?us-ascii?Q?0kwRVDIazLWfPeR3Q7PNxPXy3JxPEB3Cb38dj59uMf/YWt4vdRwc2EBBmCl7?=
 =?us-ascii?Q?UFyPjnb9REBpaTJtG0BHdZo3oDIMXI/7iZhwfMX1l1Xn+OEXkbo3FtQsYBiq?=
 =?us-ascii?Q?gErf8VawHR9qBzSa8+CQoGAgfEz5ngq5KfHG94j3e/ysJ1TpLp31BWt0490G?=
 =?us-ascii?Q?Y2WWkROLsAhU8H7oK3JJkUifG5PEj+0IkFP6Q8rF/Enkq1k/JHnVC3ZKZVSg?=
 =?us-ascii?Q?XRcHcqmr6DIWathBEm0nU7NYid6btQSknmRx+x+ypVI/clpW/myiTkCTv39c?=
 =?us-ascii?Q?V0dvMH58Y4aaxx+ZOZFrM3V+on2jzRS0Af5iEibmDHVnRlek5Qq6xIplMEMw?=
 =?us-ascii?Q?GkPuC52JI+AEdM55NJMLfWnvEX0nqD6xjL7lTL6iarEAEJj1vmJTKlj1r/4s?=
 =?us-ascii?Q?3LI5vg24F5Ly7Mi6O0wXsNG0tS1CmSyn61+mvUZxC0yRpcFXkZI2vSxNp2rT?=
 =?us-ascii?Q?DPYfk7jqJU4j2UxwnYA4cYDIDso/VBN1n98eUkZjNy5kCNayCryCkeHzo6ic?=
 =?us-ascii?Q?NmyxRQaCsa0P570xV6L8bGN5U3Z2p5J29JsIP3SHvQPbxzyiKGNzqOLKr5wr?=
 =?us-ascii?Q?qH0PddTn3+HZw862xdTfwYcBOdKbFHW7TgdEBcmqWaiq+yZLdZPtf+s3svmA?=
 =?us-ascii?Q?JSQK0m7db3j2VfQXs1ZzwPAufNQwITYzpLJibR0JfqhSG+OCk4ccoqDxWfUy?=
 =?us-ascii?Q?Gg77bdmMRo+x/F8EOVgS0ThksVK6Z1JU3/CMVbezwlO2pkBaCwqN7X++DbuZ?=
 =?us-ascii?Q?2v2kF/KyXxD0zrCAgyyIGDOhxMtoTZA7cYETij2t2QkF/e6IViWgvKAfoxMG?=
 =?us-ascii?Q?YtJN+4tly0PZJlevVd4+WWidd6/k6aW3D1ygcgFDONiEWUpREs4RsDIdtfUE?=
 =?us-ascii?Q?/CS6J9ceO0uBnnarKG166awMOszmd1u5WR9Q8QAxVPYRV1XygQ9I3qHA7PAx?=
 =?us-ascii?Q?f2LFTPk3gGik4TLCgHJIVYL8Jmz8nNFb7dNgROmn6JEbH6y6LnhWOYEPD2dO?=
 =?us-ascii?Q?N8XkmxHJnolnK+3HGYefhVQj1iSLR1FCCwIp8jRf7VBzlUVpMm+vswHz8ts6?=
 =?us-ascii?Q?W62BHEUZ8vOl/CB/2vh7ZaLIJVJJ+uKrsXIRi0KJdBUvb/jiJ9QMA1lH5Lmq?=
 =?us-ascii?Q?4qUqBCKJiffAVMiZGrnwae58cW/LUzcBVt0P84NPIJesqwLM6T1nRHcSvT5T?=
 =?us-ascii?Q?7TpMRdZ339K4B95RTN/4zokBZY4RnLfJjq6k4luvcHjYVovIEq6QRWnVlH2I?=
 =?us-ascii?Q?OclFRyM9a6rxWJ5gVttNLlSS0cWNQ0WAI8+J06rZsP1TC52yywpyWVDxbj/V?=
 =?us-ascii?Q?nXAuAeh5fcDIHEfP9T6qevPrng9T3nFbBircnpvc+6hgd2T3ced34WTEaD/6?=
 =?us-ascii?Q?VrebD2leKXTfc3xgHCmRixTr6PFYkrRMPp2QZ4JYcJApb/dExlW7covIrbBX?=
 =?us-ascii?Q?eXHwqVPNCSHvXJ77qnV+GwuVSwhlfMqJYX7Q+3NNxOtUBfnBemAT2KanfliT?=
 =?us-ascii?Q?byX2gZCJHLKPMPUi3JV1R7ybM9xI7lBSrqG1MHcm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49c137f8-374e-42c0-cfc4-08db81d7cb41
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2023 06:26:43.0603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pci49cI5oAHEGAqKAtQ8+dGrRniEfygCPgAvSAdCLLF0w/EULGnzqwZTVPDJhiMbuOh4iiodFeDbU1JnFEcPwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6200
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Tuesday, July 11, 2023 9:07 AM
>=20
> Remove the static iopf_param pointer from struct iommu_fault_param to
> save memory.

why is there memory saving? you replace a single pointer with a xarray now.=
..

> @@ -303,16 +303,27 @@ int iopf_queue_add_device(struct iopf_queue
> *queue, struct device *dev)
>=20
>  	mutex_lock(&queue->lock);
>  	mutex_lock(&param->lock);
> -	if (!param->iopf_param) {
> -		list_add(&iopf_param->queue_list, &queue->devices);
> -		param->iopf_param =3D iopf_param;
> -		ret =3D 0;
> +	curr =3D iommu_set_device_fault_cookie(dev, 0, iopf_param);
> +	if (IS_ERR(curr)) {
> +		ret =3D PTR_ERR(curr);
> +		goto err_free;
>  	}

So although the new xarray is called a per-pasid storage, here only
slot#0 is used for sva which includes a list containing partial req's
for many pasid's. It doesn't sound clean...
