Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE36B7881EC
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 10:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236688AbjHYIRX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 04:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239585AbjHYIRO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 04:17:14 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD261FDB;
        Fri, 25 Aug 2023 01:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692951432; x=1724487432;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cCIFuJmVDMfjq1RSlUXfaOyXnYAe+ffROs7IeRwbFPc=;
  b=hp5/aPgELRuG1HJSfJv5HqJMc/4J1AMe3ghR8LnK93aYUAK17x6QUiEg
   YUm35oOmTX2VpovMLN++PqupHP0uPWWEyp/nQMVgbhxT1wrDthRq5Oz77
   q9r/tp4RAtyN7cM4C/w1xmUVZhtJogF4DS6uDWkq+y5bg8z6FsIMgAQ1S
   UsesqykSckSCOAjcG7OEyc3Zobx5aryb+GJM4x6AipRgw/3JLHHwq2ZnJ
   p7ouJA3ZAYRuemr9Wf9PP6D9ijZST+wCxiMrNeSVTZPOkJ70raFxynNwt
   6ocipluYAGw6Ta0wsNkSB5IzDRcvELnrSfWO9ySZszMWixYVo1RoKNLlb
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="441006967"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="441006967"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 01:17:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="984028611"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="984028611"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 25 Aug 2023 01:17:11 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 25 Aug 2023 01:17:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 25 Aug 2023 01:17:10 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 25 Aug 2023 01:17:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V2zINaiIAoqwJAhmaz9PHSCmXoAkFgFnun8JfE3MeyFHP1Wpf1UyrvAfgEYE9GIMaMvuwaY5kcsPpfBPttaOCEbzaIbtp9EhnOIyH3VdbcCi/Cr8R0BdJ5PGqxTVmz3jZsaJz30WOvWJHkHhEbUyYDvg6oJpKYZGy3NayzuZ7rfzL4uXMjkjsjthqevcWWNoWe7gx9aBUVEf/EkKkWxmGbgJ/cepaejSQ9mHW7GTy6JKO4SDSQoqZE9AaKx7aCVRlC7mIdLUPEZ3x8rjch4ESoq7EKjOR9o9Mca4dceu+lfd8tzMp6D/bfIQa9ihv/TLyvwBTS0g9wN6xSLxMguzXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MKCu7Nyanx3IdSmt8OLmDRMer9NYNvDSThlDFGp7aOo=;
 b=dgrK09oKWcOqdJE8KTy0XyCc7l0a1afY83lAeCqWKKyNHts9ik6Vl+aPd+okNomEQw2SByS0TbNjp1ZKIOqPSsqiW+jrQ6v0qWWh12Va0M8e6gHq1H9SXwQVBQexjZIuvSRcqtLQgXfeqDfx0oYbuoTFynjc7hHizLpKUY13VvYylDHYTKl0+gYprw6zGNvhuaXD837rEUDftU6oT4MZY4wznYmw6rf0pir5tZFj3Dk4SySk9Z0g+7/iFNqG250cveIVeUPg3xgQ+5t0rIkMsNg1LIKCf7DRiM8Zl0oXbZXpERR35HzKcDs9vK0+xDpG/Hif8H7d9G6RbcUPv3mJqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA3PR11MB7528.namprd11.prod.outlook.com (2603:10b6:806:317::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Fri, 25 Aug
 2023 08:17:08 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6699.028; Fri, 25 Aug 2023
 08:17:08 +0000
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
Subject: RE: [PATCH v4 09/10] iommu: Make iommu_queue_iopf() more generic
Thread-Topic: [PATCH v4 09/10] iommu: Make iommu_queue_iopf() more generic
Thread-Index: AQHZ1vydYVSBpw8DUkS1M41ymLRuMK/6p/jw
Date:   Fri, 25 Aug 2023 08:17:08 +0000
Message-ID: <BN9PR11MB52762A33BC9F41AB424915688CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-10-baolu.lu@linux.intel.com>
In-Reply-To: <20230825023026.132919-10-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA3PR11MB7528:EE_
x-ms-office365-filtering-correlation-id: ee849a1f-3c67-4e62-e8a4-08dba543ac9c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vpUFblynU7931c8RLX06yczvho9V2HxRBrhE2HpF1criWWDYmRMOhJt8oykkY8vTLddiCp5Wg8+JdCcP4sATYALH5yLm9f/lx58ad7N6nfof4Xw+doHOXM4DAmvdoiZlq+PUyejka2wI//0AdoIdqX6CWxvsFTAbKb2Zs4W19fhbiinwuFPI+xVBCseQWSj8W+yPNDodtNCRZ2HoHrhGdw+aYaECf0SbLPam1l+yX0i55HYa5WvyKAU5eFwPV3OMpPI/GkZWzeJCuT/wdnMkXsic9tDWE6VMb9dQ2Tp1S0bJaI5yk9i3cR+34hdYc3i6AsCdIX8eO9lsPdslD2kxcShsJvNwzCv6PcteKuuL4IcA3oAmfQWgjCSpqLxgr25gdmjMLkciG+oSZyo0Ftw9+GpJI1odNKAPifZ1f6q/JIkt57nAl9y5vSADnkyoP24u3kURuqk3vBinqO1eUG5bLjjk6HgbajhG328S2H73pfvy35SSzDue63q7oGkLlKYWeppKXqpvvVLFn8VJQq5jn+1kotXTxHR3hJCsyQNj+AOnGc7+NbS7Vj7hUBIRu+D8lehJFo8vTS/RCDL6eHJv+AD1ba9Q2OwOMLzG75h9jKHgt7h1YysrReOzyrQvbc2BHugW173gbwMAdt/UqgpHcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(39860400002)(396003)(136003)(366004)(1800799009)(186009)(451199024)(52536014)(5660300002)(8936002)(4326008)(8676002)(83380400001)(7416002)(33656002)(26005)(55016003)(71200400001)(38100700002)(38070700005)(82960400001)(122000001)(66556008)(66476007)(66946007)(64756008)(66446008)(6506007)(7696005)(54906003)(76116006)(316002)(110136005)(478600001)(41300700001)(2906002)(9686003)(86362001)(41533002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?J8aqXrpn08DZFgdm7RaSLWc9aiFFMlvCCwLJ9suxixr3r9J5je8fWvt5Jk+j?=
 =?us-ascii?Q?DZa77v6/Pie5KoLQ719BC/gKk1aicfjrtqAPQho5zJQ5uVcyrzbWMyOoS9fh?=
 =?us-ascii?Q?oFQJqvmRdDLXVq/GxS2Rf3E/sXAUhrjihzSyBeb8cGRfESMsxLt1svbfUh9O?=
 =?us-ascii?Q?Y3euCY0l3lr6geHvPtjspwQGaidEqofC9gkf56sJv+ehGMW1PwwzOhK+C4MZ?=
 =?us-ascii?Q?+n0ZWblg4qaG5i8kDtStrCjA3VeYE6QIya8JzbJdaomS2NIMhLdQxTMYYdUC?=
 =?us-ascii?Q?YSWPWzyj3UsR6Vucq2lnCjGIjslen2dVhmQV6Hk9FTp4PTockXQqO2uqJ8NZ?=
 =?us-ascii?Q?e0Vq1Sh0BC+Dc1xy4K/ezaAy2tf9y4K9AHYEll32Qtgw+mGbxnh/9IwxJK9R?=
 =?us-ascii?Q?5cBTFtHooUmgAHJo4XULe84kdLaf+PsGsC73l/0h7UXrjiyEApP8W09Dx+dS?=
 =?us-ascii?Q?MdH1S1Tp70TKI/QOw6ejOw7XOKSOiU9OdypRv/MKjsNIgBoStmbQ7S54xsjq?=
 =?us-ascii?Q?UpZtXz8ZzF+ps2HjSBid6tHHAfvrC5ReFTGkFyJ8VQ5aevIKGqy64LhGkIo7?=
 =?us-ascii?Q?8HyF2jWVtvLavne6uE7U1kTH6aPRZ/kh1RY70jPPJk2cx5A7t5Liq9HcWAwU?=
 =?us-ascii?Q?hAENKFtMt16WOfYsGaJx8MRjo7WYbEfdaZVXMb4JrXIHgj94aqS280TJZaRa?=
 =?us-ascii?Q?le/figclQzZBX/KZ2U7N8HqheTMsUjYGEljFpak+sJ2JqcTmtlN2wcow8rFP?=
 =?us-ascii?Q?RUzN093Fv93FF2AmX4h0+JbCOP03gXNo2ExgSPcwEex9QfQcD06hfxYF7VYy?=
 =?us-ascii?Q?Rp0fV9cpRrkXfCt2tb5ydDxMm5Zcx7meCl42njjB4VZ81EGC7HVrTTQd3n1c?=
 =?us-ascii?Q?H4bd+pXzJuoMcp1owYRQACa6Hpw3rnFQ5Pw1WuScpSbjP9rwT2b0wqZ/x3eL?=
 =?us-ascii?Q?e+9JgLkaFj2DlPTQ5nUPnk6OJH8f5al1ae+uNWrXkSROAA8GgEC9FWNOT6bj?=
 =?us-ascii?Q?tDePU4AuOgoCxW30H/7unwL9WHWMYbi7izB1pC5FPBPG352W5Jqum5pmoTFw?=
 =?us-ascii?Q?vJk1dEDHDQEaUCtLpQl6IgaIX4y7ZeAzm9ag+hyA52ZowDu/eCzNHkkjq+oz?=
 =?us-ascii?Q?zRYpA3taCxzcPjLb84EPgQq3idzcuEJNMYNy6N4d/O4bLayGleFT5GDwfERx?=
 =?us-ascii?Q?0cdwlrIQQbzJXAinZ8N6uvwdUAUFyc7SemaysM+yE/qtjTvcnC7MNGHuvui7?=
 =?us-ascii?Q?houBAqCs4TSxVIOUYZWPeXQPGidS0tjtmNXP9xXkUxeLDF4bPeZ3xIZ2h0J/?=
 =?us-ascii?Q?4ovjiC7H7a5+HneSVXbA0IAp7vTqFRiJfSrdBVv7VdF4FlTMJ/n7GzXcf3D/?=
 =?us-ascii?Q?yaK5cm9hA0O+65XjWQmmvp7WRbXzjJ7TH5OctYFhl9i6DFqT2rNers8HheEr?=
 =?us-ascii?Q?jKMVsjwHpzlHUMkG7kiyYMgGEpj+LeVQHZ+BQfc9M0ZBvj/Zcocj8A7zVpgT?=
 =?us-ascii?Q?HIR2vlSGCA243/DJFWwNn1zsM9xbhb743NBU0eJoY33yFvQOMs7xeQmYiJRZ?=
 =?us-ascii?Q?UJ8fKeZTcGbg/97pBHNzUo90QsorsNmVd6Ciktmn?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee849a1f-3c67-4e62-e8a4-08dba543ac9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2023 08:17:08.0287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 03qqc9Z/k8UuiSMTEHi3dMirv9ZwCscqH8TPYyjTOHFPDNKYbKiXuKUEgbHLGCAz7/E61IPtN9GXL907JigH9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7528
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Friday, August 25, 2023 10:30 AM
>=20
> +	if (fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID)
> +		domain =3D iommu_get_domain_for_dev_pasid(dev, fault-
> >prm.pasid, 0);
> +	else
> +		domain =3D iommu_get_domain_for_dev(dev);
> +
> +	if (!domain || !domain->iopf_handler) {
> +		dev_warn_ratelimited(dev,
> +			"iopf from pasid %d received without handler
> installed\n",

"without domain attached or handler installed"

>=20
> +int iommu_sva_handle_iopf(struct iopf_group *group)
> +{
> +	struct iommu_fault_param *fault_param =3D group->dev->iommu-
> >fault_param;
> +
> +	INIT_WORK(&group->work, iopf_handler);
> +	if (!queue_work(fault_param->queue->wq, &group->work))
> +		return -EBUSY;
> +
> +	return 0;
> +}

this function is generic so the name should not tie to 'sva'.

> +
>  /**
>   * iopf_queue_flush_dev - Ensure that all queued faults have been
> processed
>   * @dev: the endpoint whose faults need to be flushed.

Presumably we also need a flush callback per domain given now
the use of workqueue is optional then flush_workqueue() might
not be sufficient.

>=20
> +static void assert_no_pending_iopf(struct device *dev, ioasid_t pasid)
> +{
> +	struct iommu_fault_param *iopf_param =3D dev->iommu-
> >fault_param;
> +	struct iopf_fault *iopf;
> +
> +	if (!iopf_param)
> +		return;
> +
> +	mutex_lock(&iopf_param->lock);
> +	list_for_each_entry(iopf, &iopf_param->partial, list) {
> +		if (WARN_ON(iopf->fault.prm.pasid =3D=3D pasid))
> +			break;
> +	}

partial list is protected by dev_iommu lock.

> +
> +	list_for_each_entry(iopf, &iopf_param->faults, list) {
> +		if (WARN_ON(iopf->fault.prm.pasid =3D=3D pasid))
> +			break;
> +	}
> +	mutex_unlock(&iopf_param->lock);
> +}
> +
>  void iommu_detach_device(struct iommu_domain *domain, struct device
> *dev)
>  {
>  	struct iommu_group *group;
> @@ -1959,6 +1980,7 @@ void iommu_detach_device(struct iommu_domain
> *domain, struct device *dev)
>  	if (!group)
>  		return;
>=20
> +	assert_no_pending_iopf(dev, IOMMU_NO_PASID);
>  	mutex_lock(&group->mutex);
>  	if (WARN_ON(domain !=3D group->domain) ||
>  	    WARN_ON(list_count_nodes(&group->devices) !=3D 1))
> @@ -3269,6 +3291,7 @@ void iommu_detach_device_pasid(struct
> iommu_domain *domain, struct device *dev,
>  {
>  	struct iommu_group *group =3D iommu_group_get(dev);
>=20
> +	assert_no_pending_iopf(dev, pasid);

this doesn't look correct. A sane driver will stop triggering new
page request before calling detach but there are still pending ones
not drained until iopf_queue_flush_dev() called by
ops->remove_dev_pasid().

then this check will cause false warning.

>  	mutex_lock(&group->mutex);
>  	__iommu_remove_group_pasid(group, pasid);
>  	WARN_ON(xa_erase(&group->pasid_array, pasid) !=3D domain);
> --
> 2.34.1

