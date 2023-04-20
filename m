Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87ABC6E8AA6
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 08:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbjDTGwN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 02:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233907AbjDTGwK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 02:52:10 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4409E30E9
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 23:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681973527; x=1713509527;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=te09IRInLVK1zFYmsyTeEKa1MZUtRSeRI38I39qgRNg=;
  b=gDpz60eBjyEsHUlSmhw3Zl7514qV5yDoAms0L0Y+Ui137c8WAzIKiYhE
   zLB/QB2jlM2K3JnBaaKT2Q6a3LwHvC0YO20xYwC7ioldaCFk2/0TGtqMX
   wd9EgYWfrNqCidv8vQERgl1OmR5ZEMnZ3o2IyEn7qszQ/W+5UnJh8nxWF
   uqvxTfYx6IzvTBDEFaeHeAurEuchh42z33r2S3VwWKjZmz5ZB+NolNqqQ
   CA2EbA52yci5M/SQwveoU32FsUYPrqPkB3XNpOqI7JLwoEYoGFQ5qhSgj
   +tkBviQoOysNHkAcGP+04R7Qc78ktwpgd1appFC5S6ZWJ6clEQPzcKnyc
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="334474456"
X-IronPort-AV: E=Sophos;i="5.99,211,1677571200"; 
   d="scan'208";a="334474456"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2023 23:52:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="669247879"
X-IronPort-AV: E=Sophos;i="5.99,211,1677571200"; 
   d="scan'208";a="669247879"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 19 Apr 2023 23:52:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 19 Apr 2023 23:52:05 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 19 Apr 2023 23:52:05 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 19 Apr 2023 23:52:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LMBbIs05KIDkJkaJ6CsUkF1ni0bIZZEO9Nn9vkPgIaCfCpXY+w+Gh9QPEyerQbkf3yAgHIOORyCIrT/HgnSqGYJrbG3EighermvzG8BlaYYXkC6lpEh91XaQztedZvO3iR4E6DdQbk5tXfGM4eL666j1BZE4iuYFIHuaBdkpXMQUE7GWCy96kiBh8ptr4dFbj7NYBvwQ0WlU7fFBrX455+8pk8bFnIzRZeGQFQj1LhCD5ibjRisrd8oNQ1WiZ/TigyYAKQ/zopjvoqHqgJACfjZj/NdDzrnHLyCKOaML2P4sUCquSI7WeJRlMvKEX0sFglwOSIspNibZcDQW+aX0Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b+L8h57b5O65fwPxUDIcExaKi7uymiZ8IQB1dJUrY0c=;
 b=GNFpzSCysNZ4pwTNfni8yv5a75VnmvnDcTH1ou5HHzeHPV+l1Gp0bhI97c2gDTYKnWw/4ei3hhsP9E90MOlu3kuK1Yi9GgQAdjgFKZY0ZYLbtNGC5UcPrQxYUGdqKPsBAN4dsO7nSYvpuvTW64iHsDH5N5veVGAYS3Jdd0oAfNQ5NdnmYXjKEFhPVFKlRIAkitThfEOSZgk7VOPz8fyuMiJrLFEZJvzmtV/6ayPEaZOa+M4OxhtwA9JknE+Tf9WXY9Dk2HIZUTNiUcCP+A5TJbWb5PVx2OmQ927hxgOEB7w0Kz5TIxV58TjnJVZNris+er2pK+9dUOtSuTAFcNJs2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA2PR11MB5098.namprd11.prod.outlook.com (2603:10b6:806:11c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Thu, 20 Apr
 2023 06:52:03 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%7]) with mapi id 15.20.6298.045; Thu, 20 Apr 2023
 06:52:02 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RMRR device on non-Intel platform
Thread-Topic: RMRR device on non-Intel platform
Thread-Index: AdlzU1l2SINtdgKASzuG/OHqnI4zdA==
Date:   Thu, 20 Apr 2023 06:52:01 +0000
Message-ID: <BN9PR11MB5276E84229B5BD952D78E9598C639@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA2PR11MB5098:EE_
x-ms-office365-filtering-correlation-id: 8b1a7790-2175-403e-9d36-08db416bbe9e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RC8pqj7GmV2i5dup4xGMHpVQFjUo7jZTSZb/zG8ObUArBU7fxxFsDCy8xT3fh4M5acjCtYWDaBZRwMIx+JxKr82eG+UaYjx4ixldegvhidPqeGYD4tcZA78pZWBrKAHU1jwQo0ksL7cMV7WGNXvr7UJgFnuISUYn2BCMBtf9toCetvNnae2ehP7TJ4Pkuo2niYDpac9EUs+5SJfpP2yRM2no7yZxC03tWY3dCV8Mbo+UN0wYrvaB7VrHYb5QRDOo00bxcGwIR5ExSKn6PzhGrR45TPdMgpSZYyjornicaCD/hPSQj400QueqeKURnXhLRhUC0a0c9I70rq7W5lxh7VqYkDM/IsvDKcW5GLZxjz33sPUxdZsd7ZaKN+38CMKd8lt2L4f2wAersfquKdIEqW4TYTzVrzz3c/eMOLWVZbzK17uvNJt7dzHVMmA8xUPEUTgIaku+NumwMOuFOSJcHLuw+IyhPz1qvd7eWL6nExCR1gYA9q1sS4q38sgG8ePWaEJua+n7UGFTIzKRsbM1fWJCj92y+qaRObsRzas1GG5JF6PLySCaeNPz4fomVFB6vUSWt4GwESfWkK58NC+SgoSprBdLesscwojh4rpAbXZ97LMCNaOxC/7xAivwZXFE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(366004)(39860400002)(136003)(376002)(451199021)(8676002)(8936002)(6916009)(5660300002)(41300700001)(52536014)(66446008)(66556008)(316002)(66946007)(66476007)(64756008)(2906002)(4326008)(76116006)(54906003)(478600001)(86362001)(7696005)(38100700002)(38070700005)(186003)(9686003)(82960400001)(122000001)(6506007)(71200400001)(33656002)(83380400001)(55016003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BrvS4Ge3CzdTXKeOUwR7hEZqQA5SkbSDMmkUBSa/8gfwyhEXJQ5u+IvaVnct?=
 =?us-ascii?Q?gZtjh0HMp46MlyNIQInIuwmIs0bsZZT6OKAeHTi9uujN9WolvoNQSZyGMaUS?=
 =?us-ascii?Q?hPPP38egQRk5Ro1QyLAqoZXx5XmacvHr32XQfhF8tiQdgrAxaGUFyfjuANBx?=
 =?us-ascii?Q?HNCViQGnYePBN8jF9JRPWWKvamtu/XtI1pW61uZE0hNiGJdq8OzAbJeutH4d?=
 =?us-ascii?Q?v2fbG9cm/QLIOUHN0Nf9x910FtEe63f9nKrG3OV+6Ru5+JToQYOu33BNao3S?=
 =?us-ascii?Q?FjiLyHtAmfZNCQDHgYIUD/zgjuxkFf23mVFd0VrUoY57Lp71S0AmFr8LY5Wt?=
 =?us-ascii?Q?YTOqI3XTn4AjhHTqhT3Tx8Y2MBSjXysmjIcmOVf4t4X9pnk+lltfrduVEC6T?=
 =?us-ascii?Q?tsd+eE2rh87p3uN2+X9nkWjquF7CiNnHdtuVFrozTYLiTRKPJqO3YETY9zfg?=
 =?us-ascii?Q?o7HgsbBFoRRjV5r3wWXZWPDKd6mkeZ2wGAiv8cR0IK01HaRkXTncaOJsOH+Q?=
 =?us-ascii?Q?JU+pKYrpIizRDLfv8DX/fMXZxHcmtIBH1rtQGJZxok9O6jNo3CkuKWaqnBEK?=
 =?us-ascii?Q?QzYz6ueIZAZsnuwIVHCtcsmq/FbkyVlTR8NZmcvV/+syoDx9xHkivrla6Dr+?=
 =?us-ascii?Q?1rwnvBuwO+ojA6fI/N/P0w/ruLtwD274J/M9NPR34cQ7DV/pQz1hWYsbGObZ?=
 =?us-ascii?Q?U7phvCxu4WG7g03MvI/EEp77WqeHrTKMns6ViXZiniW3XaOQCnu2WU/EPzkp?=
 =?us-ascii?Q?tIx2MxVnYDbtcaxNgHlP2/Q5LvjnInup57DEBUDsWslYoy5JSo2QJF3klAj7?=
 =?us-ascii?Q?KC72bVN86ge/VkHegccwggPtv4QZB9DoJENKSdhHTpqvr3dSiI6YauC8uQNP?=
 =?us-ascii?Q?QAkYjcUulyl64qV+OgmqzjoK+h/WkUUCUs+Bk5cTkxw1s9Vsi3MrNavjieu0?=
 =?us-ascii?Q?qw6cFSL2c7Qp3TUssHKXzSFfM4Jgq+YsVRhEcMZlk9wZnP9zOUO5M3+RPl/x?=
 =?us-ascii?Q?NKRa7dKpTdU0jbeXzrEcyqzmgO3FoQOzBNbDA3RFf5yvm5XeVOM5ICbDNq9g?=
 =?us-ascii?Q?dmwgH6s1nwmoAH6P+2k2lVQHQMbVBRVksXMA592R8JiMKt2hm3SybZUg2nlc?=
 =?us-ascii?Q?vVOkHyXdTgz+w0hkmzemcRmBle2kH+CNdtLl4Ozh0HYYvqOQhwkUzJ5K5HCZ?=
 =?us-ascii?Q?eoejT073frdQ2mh42VkSBIuUwvT8z7YuuxZnkEaFVAGBLhZnBSafZQyQVniL?=
 =?us-ascii?Q?f+fMsTvx1dBqorbPf0CTTs1VZRIFxa9clc01ASrmhlr9/wVe5O9eK3vPxnIp?=
 =?us-ascii?Q?FagjF2uHYbO9HRpm5iKn5/DeJIrkdZ1cviUpJM76CtnFW1ucbJl+7YY05TIi?=
 =?us-ascii?Q?f0TH+1VQspfQApwKnOwY9ARF+GE4zQJ5kPCJYyklUvU0Qro2/2eQFMyucsVN?=
 =?us-ascii?Q?DQAw0Tf38wW7DTa7chOrgfmK5VmI4/YZcrTEFrqoOSKW5dQ53zgQobUMCIJz?=
 =?us-ascii?Q?oduWzt7DK0D3JBGecygufHBayfsIiC/GJFZp0Px2AbqbszOsisxP3nsz3P+V?=
 =?us-ascii?Q?D3WhLDLiMWw19V/UWNRwEWibc9soxRBCvaDLfwA5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b1a7790-2175-403e-9d36-08db416bbe9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2023 06:52:01.8242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kxnkENEkSs9SePPWj4+/Jmx1w9a/F33Cun5KT55gb7zSeYDziiYWP7ClpfAjloOJD7bZqW6bOFG3CnWl0U7XtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5098
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

Hi, Alex,

Happen to see that we may have inconsistent policy about RMRR devices cross
different vendors.

Previously only Intel supports RMRR. Now both AMD/ARM have similar thing,
AMD IVMD and ARM RMR.

RMRR identity mapping was considered unsafe (except for USB/GPU) for
device assignment:

/*
 * There are a couple cases where we need to restrict the functionality of
 * devices associated with RMRRs.  The first is when evaluating a device fo=
r
 * identity mapping because problems exist when devices are moved in and ou=
t
 * of domains and their respective RMRR information is lost.  This means th=
at
 * a device with associated RMRRs will never be in a "passthrough" domain.
 * The second is use of the device through the IOMMU API.  This interface
 * expects to have full control of the IOVA space for the device.  We canno=
t
 * satisfy both the requirement that RMRR access is maintained and have an
 * unencumbered IOVA space.  We also have no ability to quiesce the device'=
s
 * use of the RMRR space or even inform the IOMMU API user of the restricti=
on.
 * We therefore prevent devices associated with an RMRR from participating =
in
 * the IOMMU API, which eliminates them from device assignment.
 *
 * In both cases, devices which have relaxable RMRRs are not concerned by t=
his
 * restriction. See device_rmrr_is_relaxable comment.
 */
static bool device_is_rmrr_locked(struct device *dev)
{
	if (!device_has_rmrr(dev))
		return false;

	if (device_rmrr_is_relaxable(dev))
		return false;

	return true;
}

Then non-relaxable RMRR device is rejected when doing attach:

static int intel_iommu_attach_device(struct iommu_domain *domain,
                                     struct device *dev)
{
	struct device_domain_info *info =3D dev_iommu_priv_get(dev);
	int ret;

	if (domain->type =3D=3D IOMMU_DOMAIN_UNMANAGED &&
	    device_is_rmrr_locked(dev)) {
		dev_warn(dev, "Device is ineligible for IOMMU domain attach due to platfo=
rm RMRR requirement.  Contact your platform vendor.\n");
		return -EPERM;
	}
	...
}

But I didn't find the same check in AMD/ARM driver at a glance.

Did I overlook some arch difference which makes RMRR device safe in
those platforms or is it a gap to be fixed?

Thanks
Kevin
