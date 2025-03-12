Return-Path: <kvm+bounces-40819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F243AA5D756
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 08:33:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32CE817605E
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 07:33:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F52C1EFFA1;
	Wed, 12 Mar 2025 07:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HO3cFVLW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632DD1EFF94
	for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 07:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741764807; cv=fail; b=dZZya8+Sz2pUh+c/4zs4RaTReA9AVzhso3CUGwMwqDnyWx9voaKULUxDAMQ7YjKnX/mh8uyBs9OlsprgF6WiNvVLA7pdf+buadzY+7dekBU2AnrR/xW01alIyzi77r3A6wKLCYdzcncgWMefuS3i42ay85/5MscFS0e8DtbVwpM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741764807; c=relaxed/simple;
	bh=Yn/MsOniU0a/QopR1yrmFHirT8uNCRveJ0qJxsPFmmU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=STlI4QhSqtFxva39BoHy8mE0s8i6oXCE9INIpf1VMRYzRGC07wd+C/iF45Xd2F3/xbfrAtEK6KuCpAZbsR6q+aWavf4uiXp/pZW1KagWq2S07f9vyk416TW7URBQ6FW3lJbEWgncggn47RgnETnB/4UPYFcdRubQ4J/jjkdvoKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HO3cFVLW; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741764806; x=1773300806;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Yn/MsOniU0a/QopR1yrmFHirT8uNCRveJ0qJxsPFmmU=;
  b=HO3cFVLWTcSjkzLmIA4QD2jPSS6iU0a0iccfcpXtbPyIWvPPkEsldWGs
   0ryYpB4XNnZ3vEldsygIfiZkauuHV+HXy1nNmcqsIMSzCc2hWFoqYWEeo
   3CuBsa4X4hCSisC3GNbQ+qaVFSUxLnfgFt/iKLH2ze3du/Y6dSh/cfxCd
   xpoqcl934aux81TxynSTjURhSMiZqdmeJivITKPTKI2drTo8ITSK5gjW7
   7LCv2nDkwEnuWIsZxcZUShKiqpHnd9Hv4v3g4u92l3UPLIecpN0EGQWCU
   ooWp0u0UOH78jErYYd/N87me6EX7CUU5/C9TCEzZg2wA76jM8+NKxEYku
   w==;
X-CSE-ConnectionGUID: LTEKe+WeTzqCRglxURd1ow==
X-CSE-MsgGUID: blLnkdfhS4aTsqAxFWkiFw==
X-IronPort-AV: E=McAfee;i="6700,10204,11370"; a="42867676"
X-IronPort-AV: E=Sophos;i="6.14,241,1736841600"; 
   d="scan'208";a="42867676"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2025 00:33:25 -0700
X-CSE-ConnectionGUID: 4gimo7JxQX20X9iMx6qmTw==
X-CSE-MsgGUID: /m2dlh9pRdS7H+0sqv4rlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,241,1736841600"; 
   d="scan'208";a="125458132"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2025 00:33:25 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 12 Mar 2025 00:33:24 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 12 Mar 2025 00:33:24 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 12 Mar 2025 00:33:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vIJMvhciYjPnkz8on2ciCaEEfO8gsYwidBPaGaxGlvf6HaThYb+bXdLibBmvhzTEruu79FNs4DHCSw9e/Z6oCuRYH80pJe0Igqe0JXeDcnBZXU4El6j7G3iwqH5G9tZ48/qwDOdFrr5m8vHrJfzuAFP8vqgZjjsz6D5Im609nqidDpeYEpwlI9gBqVjNz6AWiTN1ztMubB1JBcxLtQq595f4rikQ8fgZK6u7jQug1mll8zbGccJHvnN7d6uoH8llRbQWJcOTQK/Evz9d+tYNj/O/sm7Dz1VB95w20DLF9HSoTZ0ls9A1HCaEhB/nFjvKwsvF8IQW223EqP+Ix92dpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uGPUwTtjKSQLvdA74qCakA/0SLNDp0PoK0n+89akAnE=;
 b=Tq+1MYlgHGh8QvbEwTWFht0FElrculNEYloKd/dbtAMjBW2QLz2jRivksqiMKifORLXVdTFOBDI+EUgK5zrfFKhqTCPgtfBNaad0rKbmM0uxbkBy5xXNIo+nd/VKYhDJ2rdiAzUNFYliB1yHoKIS5sd8SS9KjO+yITcGX2L0a3e/f6vOp/V0HrsU/nswYZQ8k7Tp323tl1NOe8QJUtuaeTh+zPO1PXU9DkbDE/gy3hpJqNDMlZ/LCISkB02cYovMbxidVNeL9hzNspEg4uw+ig221AgOVOq4Oarfrd41JmBzQHX9H3w1xty+o6T/IAy5in9sRM8oBSknXBsoe9JWhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB7419.namprd11.prod.outlook.com (2603:10b6:806:34d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Wed, 12 Mar
 2025 07:33:07 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%6]) with mapi id 15.20.8511.026; Wed, 12 Mar 2025
 07:33:07 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH] vfio/pci: Handle INTx IRQ_NOTCONNECTED
Thread-Topic: [PATCH] vfio/pci: Handle INTx IRQ_NOTCONNECTED
Thread-Index: AQHbktpaKTeXfZpdi0WvEC3tjklTZLNvF9Hg
Date: Wed, 12 Mar 2025 07:33:07 +0000
Message-ID: <BN9PR11MB527667354779ED90426B44E68CD02@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20250311230623.1264283-1-alex.williamson@redhat.com>
In-Reply-To: <20250311230623.1264283-1-alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB7419:EE_
x-ms-office365-filtering-correlation-id: 0bdd0927-dfba-4792-0d09-08dd61382224
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?2uYa/HMNga/GHpcA+1UPPpI1kKuqaxBprcq8l3waUi4Vfl2SjV5vjXLt0s1x?=
 =?us-ascii?Q?TrfYc+qK3OigKFlQ9x4UFBFB7/lwtYPyEDGuEAngAnWbYFN9C/kNPM5S3OWN?=
 =?us-ascii?Q?hnziON0F8CfDT3nVRuRYoVw/3maGbC0dnzYSvlrNrn7JkKY7UZN/NC6OO5ke?=
 =?us-ascii?Q?w9NOzH3MNntUEHkBe7+aiT8JBIWA++PtSWLuPBTe3Hv+yD9zLDcHOxYJD0/A?=
 =?us-ascii?Q?XfC62dREj7dq/ouvKP+fyAMbceJhvB17GAZv5Q1fYxVHCow0ECAKKLzJs2SZ?=
 =?us-ascii?Q?HF43W0CYf9bmV3qCA4lImWTrJBVHRhZVUSy4xbXhmckvzy0MDaC5Mtm/G09Z?=
 =?us-ascii?Q?NYxhxlUCKVUsOD8InVRbI1hyMkVz71xHOwEWd+lYKUYsxS/D4XGIygeso59x?=
 =?us-ascii?Q?EI3xpMoKx/MK29x7p9Uit1QhHqM0P1/9+lfY7wQjhwT38gDwe6meI/6g4XIx?=
 =?us-ascii?Q?brZ5vjN5eUr+QC/7FBhOAZ9T6RyhC7GPcG3laft1cPtQy7oCgkeCFw3q23iD?=
 =?us-ascii?Q?elrd7ezrTq6b3dNb2iAZCzOFLLn/VPIvlaycnNvIKXWo9KVDb8Ll1JsJ0jV1?=
 =?us-ascii?Q?HNAPNXb1YZIhfxYYTuWxA4EdsLn3vOhdzHVkMOKp59AqlpUOSWSKH2mzRWh7?=
 =?us-ascii?Q?8Cln+EZKl0PMIuZbFy5ec2VCCNY3DaX6FsBHDOE5+nRrENsRqDY1p4g/aAdM?=
 =?us-ascii?Q?LTB8PA3wB39ZnjdId4Ve/VKtY/Gpe1is2yILWdvtr7LM3F4CYjY6X8orMK5Q?=
 =?us-ascii?Q?1ofSf09+uMEE9fqfiOu4HvNqa0TkE17ZVV+sBDWVxM4l6J48F3rqmR3clux6?=
 =?us-ascii?Q?qCKCwY9lm5aXg6voVkLFhCrWtgYArUKeM1jDaCVRy+3zuRxC4mZO4RVFbGZ6?=
 =?us-ascii?Q?9isVKktLMb623cdDIy9qVoDVbNHxU8kzWtx0plBHWWKSAmubVr/nOD4LElAM?=
 =?us-ascii?Q?aw59iHJ5RYCBfoe6BxHuaOohpjHnhf/NjZ4CPbvQ/6Sa9lIPxWor6sudA3Fe?=
 =?us-ascii?Q?lnWeM37K4wpAokYQE3ASQriZBNhTPaIYGpd6/zFKTJh3xI9XayCtFaqs6hqG?=
 =?us-ascii?Q?Ki0rFJC5j4h3Ths056FCXd9yoxZUAiQLJVx7qCEOkOfpLvRnE5gtCtHXmMvQ?=
 =?us-ascii?Q?PrK5wgOP2tM8VL6jSY57kQ9aAeY8jQNicj5xYhhdsHduwVrWgfQQfLWInvJ/?=
 =?us-ascii?Q?JsTlLpC1aaXedonzKXjIsBje60G9fiNogcs0IcpxeJo6L23ozxM4VTE60Php?=
 =?us-ascii?Q?RxWRJq8a/rPbM1Q3g8h4GtnblAkaNwa2pQ5pRKVNTtdHKzzbLBkSFdqyzNmj?=
 =?us-ascii?Q?4FYGBkUprG8GFEe6mGX9RHkwxAsejLDBTUO3PNOvol/1KKFz7qvjxzMJqH1p?=
 =?us-ascii?Q?pWiYIWNQw4k09F6U8KT7n99sA9eI8kU0bSQuOtyYXgu61V8UCyjpxsibdNsJ?=
 =?us-ascii?Q?6ZM6NDurT/ITU9QHIB3SG55/j72StzFN?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OLMt2ujoL/mII4UMVsUH20vFcGJW1feONvsNkC7vXQYz97bcF53BZUsovy6r?=
 =?us-ascii?Q?hYV7LlUwXpXr0phcfDveL2EbKDmtCC0oAHgIyXuIJKFSXfDy5myxYBSFs+B4?=
 =?us-ascii?Q?RgEliqsFGOe8deaFowVwliwCIL32aAbJpWWTPZM3q+BxO+8/zDiMEAX+qtp3?=
 =?us-ascii?Q?VjigoKL1IA7GsdBqNYBH3ulefCKyc91L3VAekeQfVpZYrdgOnNOh5rkFFy84?=
 =?us-ascii?Q?HnAEaW0TrCIyLDo7PqaXkgYdeanxq8MKe08w10o+c5ySgMn/UWILQCB0d6i6?=
 =?us-ascii?Q?U6dOGH8lKMM/14H0khOCNBT8ea6fq0fQmcdqPu0ha+4PGFjkmGb6wnzq9lEZ?=
 =?us-ascii?Q?Ip4sAcM01NIC+Vc7HsyWF+OK6C3wT4QHKoizdb/GqxivCEi3phfmlDNMVuu4?=
 =?us-ascii?Q?lLCFOYkLcZ/tM5d9n1ZVMQfaCHa9hJEWP1yfzwMlhLXDshOMECfWdDsy2mH8?=
 =?us-ascii?Q?mRmIFqIDG9sOXQdYrV9by7uakcqkp3z7RMYpJu7vLXpb0nCcyp/+pkTMyfRb?=
 =?us-ascii?Q?MlyGUqjSV7YAPwLbqd/P/KMJ/FCi0UW4HspEVE/OcTEzi1MpiGQw4pGTZvtl?=
 =?us-ascii?Q?OxAGytRRvZ79zKEGBtO0lh8GQykpvyljqDp35VcgwOQNwDpwa/C3VvZEV4g1?=
 =?us-ascii?Q?UCUR7R8FXhElNTOl25VK4nsMkVZ9Qxl06DHuznY+N2kRO/PXiPsSWhOqspf2?=
 =?us-ascii?Q?n68f4byR0V0alZBr77Fb5QSaje0HZrby/Ah2+pMqEK9RsaAjRZfAlWMpU80G?=
 =?us-ascii?Q?/iBEQGoRuL/whlPfOvsSQZbAt0TR0RCKZhE5NcNja1URMdLEx3v87P+svmoF?=
 =?us-ascii?Q?qNknpK0fX6Zzy58tfVTuED4m31AHZRehCs+wnQh5ohZq61CL3tKRHnL+wA1d?=
 =?us-ascii?Q?O943z92VvUBsTUx2BOOKluhV57iduOiySLaMV5Lv6cC44LLaTuCfeKpOi0kq?=
 =?us-ascii?Q?0eVuPzOFoH41hc7IzLpdsHcm/BLtGt76EpcCGurHc1Eyb1Dth0Hu4URSN6DO?=
 =?us-ascii?Q?/zUtSHxaWKuBLAepscidGpTpVydOSGq9LT6ZISifQDaZ7zdaMnP3OqFaxWAL?=
 =?us-ascii?Q?Zct/VcWlaWqbJ2CPqINuytDiGWQWP1jz1HXxrns80ihMOserfZ58Fem/Djko?=
 =?us-ascii?Q?A+kLJtS5dIgoD6KWvWttgrs3FLgz0XTMV6VOzhjZeOg+x+1ryIZCp/3xcKcy?=
 =?us-ascii?Q?ozI8iCbMfKB3WpeiHfM4U6XDiz8YwdJ1C3SW0U210D31UowR4xvUdTf/NHCM?=
 =?us-ascii?Q?zTWGi4zemMzszCRReKivJrGt+naKlPWd4WqbaaFH+nPFOrcLhkKsiS2lM1mx?=
 =?us-ascii?Q?lSxIK+apEOb6eP3ldmXQx3TuFSdm9mL/3YB4jSAc1K1QluGzN0qnCl2tl/iI?=
 =?us-ascii?Q?qvroFEy/5dowTRebkiNaPmiNXpkluOWyyLf+5o5a9mp/XFfCLCa7nGYsRm0U?=
 =?us-ascii?Q?eFtHG8GEwaDKTGn0tGPbRcDbtcck7L0uc///1MQ04OLU/rOcbKnnHRRNi19y?=
 =?us-ascii?Q?5p2TkKdiWrIjaulOEuJx97f9JGrvVVPCj5Hid7V8w/I0/7XFlF4aLYDOpKuO?=
 =?us-ascii?Q?gMuWdNcZnrfo8YO89s4iOj8JbijNwSUrmKfZ+gVA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bdd0927-dfba-4792-0d09-08dd61382224
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2025 07:33:07.4714
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4TdUSJsa5zA73E1gB+hStXd26yKITXaYz3eDMQAL0uY/QgAdPdfMh8c+nfrJKl05IwpY/fnrvwaqDEo3eW+bNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7419
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, March 12, 2025 7:06 AM
>=20
> Some systems report INTx as not routed by setting pdev->irq to
> IRQ_NOTCONNECTED, resulting in a -ENOTCONN error when trying to
> setup eventfd signaling.  Include this in the set of conditions
> for which the PIN register is virtualized to zero.
>=20
> Additionally consolidate vfio_pci_get_irq_count() to use this
> virtualized value in reporting INTx support via ioctl and sanity
> checking ioctl paths since pdev->irq is re-used when the device
> is in MSI mode.
>=20
> The combination of these results in both the config space of the
> device and the ioctl interface behaving as if the device does not
> support INTx.
>=20
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

