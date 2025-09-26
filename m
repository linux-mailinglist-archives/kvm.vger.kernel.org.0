Return-Path: <kvm+bounces-58877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32420BA480D
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 17:50:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3113756275E
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 15:50:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 396AE235C17;
	Fri, 26 Sep 2025 15:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UaWDUKyu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF73122424C;
	Fri, 26 Sep 2025 15:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758901781; cv=fail; b=okx0wKKeLwGpyA+OEfsUC/gFuGJFsNLflUnPGOmIeeHsGqgdKXljuVLhu8zxYWubYuiziO8I/p6Z4VosQhc9a3SMjZzieCDJ1tPdPkJ8R6oRczyxChXBT9/Yk9VtNs1lHLsvoAyUzM9fMLM5krjGU77tANYDdLwilrV7WZi3N90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758901781; c=relaxed/simple;
	bh=4vkFHzCojAzqDF8VnlBWmmRT6Ug8J7WJXf6J5GNdYRY=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UXYz/nYB5XmF1h/yotxnviGa6/O0jmCPu9gezsCJHbyjCVEHlPzcLHKbUCCazbfW/t0IXzkDJlZJV+tdAj10JmwhiBoMnLUDG8Kyb4zC/A4PfnmzEe/i9rxJ+acMKHZTTEhP6jVPoiwjqEdmAsCxgTl49dDwKsUyCsHn4dE/wBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UaWDUKyu; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758901780; x=1790437780;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=4vkFHzCojAzqDF8VnlBWmmRT6Ug8J7WJXf6J5GNdYRY=;
  b=UaWDUKyuvSJDScnD9ktmVGkK6oK8i+jO4F737puJ8I1JfMtiRHiBjOxe
   KQdyqKQ0j6OX3FNJuqJw2+ScIfcnxQNheQjqCf5q4271v/a7aeTeALjMj
   DZYKRTml8N1Si0apysDw+8ohBE5WS0Qiy3YJS/CNBBYpbPVrL5CSfR5E+
   2U6uXs3zuVkSY4VcJ7BUor2kDsqIl5cERs34ik/2oxmMMRYtCRYmM/eR6
   8Rlfi1ccZDs2MheCwILh0qsTnKrBSEOCOD7Z/dETGKXiNTuWEMt8tUyGA
   +A8vYNhCfNid3evMtoU9Cw+DsZ0Xt5vfzeDEY5mRt1C0z8GV6V7ZzxS9K
   A==;
X-CSE-ConnectionGUID: ykKMFYwQRJ2gSQ0UFu6sQg==
X-CSE-MsgGUID: qmk4U+RaRHKoGHxKQS2HzQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11565"; a="60937544"
X-IronPort-AV: E=Sophos;i="6.18,295,1751266800"; 
   d="scan'208";a="60937544"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 08:49:39 -0700
X-CSE-ConnectionGUID: 9VbnHTpPSbGKcfd6QOn5Pw==
X-CSE-MsgGUID: 1dVXZTlvTkOLJ65KSyY+JA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,295,1751266800"; 
   d="scan'208";a="178029755"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 08:49:39 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 08:49:38 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 26 Sep 2025 08:49:38 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.24) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 08:49:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UYg5excFH97ZazQeKhL8k8F+BvsyDpqT4AcTgugtcF95jMwowRDJYra5VvbMimNQP9oraMPLtzhlQ48fjwSW4iEA3BIEvmvIMNBvXuA8S/2KXZPJei75jl8JRLy/sDyHKfU9kT+ZkmslvnOFnGtTUb6u4OkD+t6nudghUoYWtySY8CE79+ujqRe8ijGEnVoGQHOGSsf+qDpfJevfFSaVjmj4YMXcNyECcsuKtWCJeDG72oh9COavzF9mQnq8nraZWYbj/6yI3xv8wtnsAHdrSW4Yvi7E8jvYi7nI46Q1Al1CQWWMIC40mYKd3JDPIHlXe2yFcw1v+trDGkWhb/+alg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4vkFHzCojAzqDF8VnlBWmmRT6Ug8J7WJXf6J5GNdYRY=;
 b=L/dycJDPAO6RssDUZooCwrU/2BA3oUfhib7gnwJ++TFY/lrxV4Qw3S3yR8iughXEN1p0voZMbRGwNvhziknQ9PSF/2FhxGuncbG28uP1H7FECF1WE0Z8WIj4w8zv5SOJuD6yyXxmPuExsNdZrMf0F7gNgwugWoPV7EiXZzdp5JBfualpoTIA6QeEWcXuxjpZWuMTjBXtzD2Jq3OmpyQoYeMvwJCQdJh60Z10oTB3M1cb/xfY+jUuVvAo0h6D7xqjDirpWoClUM5tpm0JfcjrVrGY6lUixiO7mv4PnSg5NppdCa5QchsapJ0M0xMGBcKBuzghQl2bBhlHMhu83NTXBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6697.namprd11.prod.outlook.com (2603:10b6:510:1ab::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Fri, 26 Sep
 2025 15:49:34 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 15:49:34 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Hansen,
 Dave" <dave.hansen@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH v3 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Thread-Topic: [PATCH v3 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Thread-Index: AQHcKPM47wNFJAdMMkCLNWN+W5B0ObSloAqAgAAISoA=
Date: Fri, 26 Sep 2025 15:49:34 +0000
Message-ID: <e7edbc74046335294a69aae75e46ea925fa0d1b2.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-13-rick.p.edgecombe@intel.com>
	 <112cc926-30aa-4f8d-a3a6-aa2262b96916@intel.com>
In-Reply-To: <112cc926-30aa-4f8d-a3a6-aa2262b96916@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6697:EE_
x-ms-office365-filtering-correlation-id: 3dcfb840-5bcf-4ac9-0f90-08ddfd144a54
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?bEF3T1pZZExSUVlGOVNML21HRDg3UlAvTld3TzdBRmtPMEZBTjMvNDd5cXk2?=
 =?utf-8?B?WXpoQmEzMUNqTEEzZXB3RE9mNUpvUCtEMUg0akxPVFJ2NEMrRzFBNjRvVjFy?=
 =?utf-8?B?VDk2TGx4V0pBdDdiWFZ3VW5TS3R6cEh0eU84S0lhaXV3elZVZnQwT1NPY0Mv?=
 =?utf-8?B?RW1SR0FQZkozMWlPbmljR0dBNngwSUFlZ2haVjQ2SjdoZ1hXY0YyZzZUUUJk?=
 =?utf-8?B?STErNWJkSDIrMmZ2SExhckRZR09TSXM1Q0x1SCtuTlk1MmlWbDkzS2hJR1dS?=
 =?utf-8?B?Q1ltWmZ6aXdKMmFFbzV2elVxQ0R1WTN2bUIySTd2aUhzQ1hMbjVpVVdGQ3J5?=
 =?utf-8?B?dFh2cXlVY0pvVW90ZHVMZ1BOQmtySWY1MHRYRmJaOEJNUHFJMU90aTVscHNV?=
 =?utf-8?B?UVI3dWE5aEdTWDcwcEVNN3owaHlYS1RmSGhmNk9EVVFyU0xNekxUcm40cUJs?=
 =?utf-8?B?cVJvc0JYRXBPZmhtT3FBdGtmRHNyWTRwM2dOMFRsSUc4Q2huUE5PdFplb0cr?=
 =?utf-8?B?TXN2NWJsNjJWSDJ6eVAza2VFRDUvZncveGpUeXcxZjFNa3N5ckpRUU83WHdL?=
 =?utf-8?B?a2VRS1dFaFZ4Z2JpZVRlSGZiK21JZFZqbXdQR2NnODd6c2Z3MnB4S1BrR3ds?=
 =?utf-8?B?cWlaMklhZ1F5WHZEa1dVTi9CbXFuSGhPeGcxL2daeUh2ODJqbDlUZ2tyNWhh?=
 =?utf-8?B?N2V2bVlmSllTWUJmZUNEWENEUzNaaE1RTm1xM3RtZS84RlZVVldvaS8vRDdx?=
 =?utf-8?B?eG50RXhFNlA4VzdyREI0QXNKU0J6aHhYVmtJSnY4UThoTDhiYmxNQ0swbHU4?=
 =?utf-8?B?S3RnQU4vYXFzcmlrbmZsNWxGd1lXei9kT3cyTXlOd1BtWVErZy96aUxzN1RY?=
 =?utf-8?B?SHhFdXczdnhlUGF1N05MWVNHMFdkWWlmdFdXOVkrc01SU3N3dmoyTnJYZE9V?=
 =?utf-8?B?Q25hd2RwaW4vek1kNGVxYnltdWJtcHltN0o5MWJiWWx6NTFLYXBNT3FvSTVr?=
 =?utf-8?B?NDlYb0JMN0E0L2NlRi9xUndOakRCNkRlTmxzQzd0RHV4Y2hrYUJZOHdCWUJs?=
 =?utf-8?B?SzN6STBWQnY0WUplWWtnUVh3RWt6ZXdCVFhrOXhjKzRaSDVyakRnNE5jakdD?=
 =?utf-8?B?aEwrMnI0aGpUUUZqN0paVmxQbTBTQjRESzhDbFVyZkJuMUlpRmQ0M21IazM0?=
 =?utf-8?B?SnlUN0R6Q2t5b01CenZpQndyL080VXdGTWNoSktQc09CRDJUZzR1L0NoS1JN?=
 =?utf-8?B?cDBpcEJURDd4Nm0yU1ZVdkRLdGZVa2tUdzVIN0Flc3hkdENNK1d0MmdsOWd1?=
 =?utf-8?B?Y1B4b085VktYeEZlaVRUWnNKMUhzdUQwVUFaSUNOVm1iN0xYTUZudTljOVpJ?=
 =?utf-8?B?Yml3VGhxZ3o2K3ZWaDJSUGlQc1lTRithY2hlaFNaNC9SemFrNDRjZldES0xn?=
 =?utf-8?B?bmQ4OWdhV3VpdlpqRCtEYzY2OE5HTW1xK25WYlhZZzdaZHFvbk9ORFdNNWVx?=
 =?utf-8?B?NjN2dFBBamlqUkZqVUpyY1MyQWx4K25pUHhVYVBkRW1xYW44Q21PSkI0Q1pB?=
 =?utf-8?B?ak95VjA3aDlIaWFLeVN1dThCZDlxQ3VTMzJjQ0x2dWYzRzdGQ0pXa0R2OGt3?=
 =?utf-8?B?ekJiUE1Ra0hJK3p2K0N5b0xqNFR5bGg0bEU2dCthQ1p4b0JIL3VSMG9nMEN1?=
 =?utf-8?B?WGVnZzNKL01GM2hQT0w4R1lhYmNtcHZsNmd2SzNHU214N0srbjQydTcwbmlw?=
 =?utf-8?B?cmdsYVFmS3BlbnNYblpMajN6Z0tjODhJNVlIc3hrRjU5Z29TbE9oVG5jUWNX?=
 =?utf-8?B?K3cxL29pcFF0K0U3cU1wVEZ1RUpDRWxoQnlLd2hjdUFrc1JuaHI1L2V1WmRE?=
 =?utf-8?B?K2NQd1dsMmhlSmhER0RxakkrYmVCT2hjN28xdEZoV0p6dVJoeXlLSjlpOVNI?=
 =?utf-8?B?SXJFR0x1cFYwMmRHNDU2VHVOZ09pSXF4V2lrN3N3MHQ5ZnVRUlM4N3dFcHhY?=
 =?utf-8?B?Z1g3ZzN3c3hKdUhMeDEzanptRmZIbk95NThaazhRK3RFdEhGNnVKSHFpcGZo?=
 =?utf-8?B?SGFOcTU5YTBUN2pkb01mMEtPNXdxd0pJOXBFQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cGtITWhxd3F0UEVJKzRMZ3oyelZ6SjRuOVRoYnBjcUZDYS96MzVWSTFJWWJx?=
 =?utf-8?B?UnlZNmUyYkplb2NpQS91bno0YXN0WGFkR0l3ai9tVXN3TXFiZmdCRnBrWkYv?=
 =?utf-8?B?bzdkVE1QSWJnUkdyNmVielExelhTVFFqb2htdzRNdk9vekk4NCtBRUtRajVi?=
 =?utf-8?B?RGkxaWdhYlZJdnJONjFYOUxkMHZ3SHUzaW1LMGJ0b0pzdC8ydVY2T3p0a0pu?=
 =?utf-8?B?TXNIL3N6RUJOeXZZelJVZDV0bUVYbjg0Nld6TkJoeG1FbTZzSEZPY3JQYUFI?=
 =?utf-8?B?Ny9BN0NBa1F3eFRWVmtocVREaUkvb3c4eUpPcE1XM1JrZnJvU2h1VVBsRzZx?=
 =?utf-8?B?ZkxaRnlWNXpvSFp1MXZwSmV1YVc0SldwSXhJVENSamQrY0x3b2tJWFQvZGt4?=
 =?utf-8?B?aHFMQXVJMDBZR0lubnd2cU9DbE5zQTdrRm8rU2sxZnAvTGNEeUozZDhTY0to?=
 =?utf-8?B?SlB5Nk1zdWljVWhNb1BTRlk5c1IvQW1RUndyd2JtMW9pdldZdGN4TXo2dVBF?=
 =?utf-8?B?Mnd6YTVlbytGSExVa3Rtb0pJNW42M1lWdVhBTjhmUENmRUJ4WFBwM1Y0OG1p?=
 =?utf-8?B?Mm0zUUc0MCtRektSSnZmNWJYcDAwQWNGbzd5NEVkVEpTT0M2SEo4Z094VDBL?=
 =?utf-8?B?M0xDcmt4R1JQVTF4OVFVbm5GM1JBUE82akhyakpQRHhER0xrY0k3Z1JScjhy?=
 =?utf-8?B?aTRkdjMzaEV3K2tzeG1pRC85eU12K1hEY21zVGVZY3hZWVUyZFpNaWI4SWdk?=
 =?utf-8?B?dTdQT3FJODBGYks0RlMzTVEwVjhza0lVbVhyYWIybWNqeVZ2OEdXcG04Z3Az?=
 =?utf-8?B?dVdXVjRYU2FjRWkyZ0FQRG5MQk9GbXNWUjFqNUNUNU1pWGZpRmI2dVdQMUFn?=
 =?utf-8?B?NytqZjNZR0xlV0hnNTY2WVJRZ1B2c3VUR3RKVit1Vm9NMm45dm5WR0NuN1lW?=
 =?utf-8?B?aVR6eFMyNkc0NDl2bVh1Qm5qdmlpTXpBTmhaSkJIZE02V3N4d0dZZW5acnNs?=
 =?utf-8?B?d1hpUlo3QXBaYkVnVTZGSXlNdnRoYnBRSzJsMFJZMmVqTWVoTzJ2cnhFRG8v?=
 =?utf-8?B?MmE1RXZxQlR1V1RFSDZ1R0FGR3FuVlpwcTB6TkxxU2IwczNlL0p3cGhMZFhw?=
 =?utf-8?B?cTZETThVN1hPdFliaHRieWhhU3dYbzFacC94TGdvejFjdVdHTmd4K1loVGRy?=
 =?utf-8?B?alQzMnQwcFVWRTFXVVdNT1hRa2hCV3g1L2I1K1NrQXNuYXpqMDRscHFWVFN4?=
 =?utf-8?B?ZGYwMkp2aVBpRHU5OE81NVpyMm83MlpxMzB2a2d5OVE3RHE3RkRyL3dVcFl3?=
 =?utf-8?B?UGlwOWdHdjRIa1NIRDg1VmF4T2RJOEs3ajAzSFJLb1RoWDFFZU1OVjJGSzND?=
 =?utf-8?B?VkMrRVEvdmd3dUxJZEgwWk1ZalF4ZXRhTGtUZE94TTZWRTJiZjQ1RVd4MTMx?=
 =?utf-8?B?Z0xxZ0hjQkZtbjE4K2dnTURiZ0ozNVF2SW9JWW1YWWxSVEg5S01iWWJKYlQ1?=
 =?utf-8?B?UURXTVJ4TVk0N09OYWU2RGhCOXlpakVqaitGOHoyTStiQkpPVjVsNE5jcE9K?=
 =?utf-8?B?L3BuMmhuTEo1OGxMQVRpdUNkbEttZ0dIZmY5YkY2NjBYZXAxQXVyY1ZFMUhL?=
 =?utf-8?B?bWNFUis4clVLMk1STmxBQVNheUE5RStMM1pjWE1yb0IvcmhVWXU5SUJwbnla?=
 =?utf-8?B?bitxVW54ejBDZGd5SC9BN1hIZXV5YWZOOEtuUk50cWEzU01HYzFSYysrdkY1?=
 =?utf-8?B?NnJENUZCY2ZMQUQ1ZjBJekdJOHFXYWpjVlRrUGVtVmpSblNiK293dUVNQXIy?=
 =?utf-8?B?Z2x6Nnh5OTNBRW9rSVlUSDNacnJjUjZadXJTdFoyMkFNMlg5RVIxZFNta1F1?=
 =?utf-8?B?RjVTalVFWmxIUjd5am5YWkZxYUE0c2czZ1RwOGdWRDl1RlRyYmdYcGJ5WXdF?=
 =?utf-8?B?bXFTQm5EZFNMZnN1S1JYQ1Y3cHBQMFMrKzY0RUpOWlpDbUE2YjBWbFlPSHhi?=
 =?utf-8?B?S2NmdmxORi9KYUpIZ29lZWJZZlIyRHU4bTFRek5pYlJrcDQ4dE4vZ0dOd01W?=
 =?utf-8?B?TE9FcDdqc3hGTkVoKzNaeDRkeUdOL2h1emQ1WFE3cTlaWEY3elgvS0pYS0Nu?=
 =?utf-8?B?NU1SWXozbmt3cUxNaHdGeTJkMlNEeXM1bHdXZHAremV4R054eGF0cHE5Q3lP?=
 =?utf-8?Q?pgrINu8QAS5yEPoWW/oGWeU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <356DB550F889164986A7DD02F8765BD8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dcfb840-5bcf-4ac9-0f90-08ddfd144a54
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2025 15:49:34.4214
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZQNvrmBmTU0gJbEtCHl66FEj3hO52+z4doFia2Si4mb4A6mf9qBskdGu2tjvO1O5+lrW6v6nSuT3pgbIQAcuhPtExm1FWfeXtiDxh4XKnL0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6697
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA5LTI2IGF0IDA4OjE5IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gOS8xOC8yNSAxNjoyMiwgUmljayBFZGdlY29tYmUgd3JvdGU6DQo+ID4gKy8qDQo+ID4gKyAq
IFNpbXBsZSBzdHJ1Y3R1cmUgZm9yIHByZS1hbGxvY2F0aW5nIER5bmFtaWMNCj4gPiArICogUEFN
VCBwYWdlcyBvdXRzaWRlIG9mIGxvY2tzLg0KPiA+ICsgKi8NCj4gPiArc3RydWN0IHRkeF9wcmVh
bGxvYyB7DQo+ID4gKwlzdHJ1Y3QgbGlzdF9oZWFkIHBhZ2VfbGlzdDsNCj4gPiArCWludCBjbnQ7
DQo+ID4gK307DQo+IA0KPiBUaGlzIGlzIGNvbXBhY3QgYW5kIGFsbC4gQnV0IGl0J3MgcmVhbGx5
IGp1c3QgYW4gb3Blbi1jb2RlZCwNCj4gc2ltcGxpZmllZCB2ZXJzaW9uIG9mIHdoYXQgbWVtcG9v
bF90IHBsdXMgbWVtcG9vbF9pbml0X3BhZ2VfcG9vbCgpDQo+IHdvdWxkIGRvLg0KPiANCj4gQ291
bGQgeW91IHRha2UgYSBsb29rIGF0IHRoYXQgYW5kIGRvdWJsZSBjaGVjayB0aGF0IGl0J3Mgbm90
IGEgZ29vZA0KPiBmaXQgaGVyZSwgcGxlYXNlPw0KDQpZZXMhIEkgc2VhcmNoZWQgYW5kIHdhcyBz
dXJwcmlzZWQgdGhlcmUgd2Fzbid0IHNvbWV0aGluZyBsaWtlIHRoaXMuIEkNCndpbGwgZ2l2ZSB0
aGlzIG9uZSBhIHRyeS4NCg==

