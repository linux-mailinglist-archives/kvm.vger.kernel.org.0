Return-Path: <kvm+bounces-68284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id ED450D297B7
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 02:01:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 657203081E2C
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 01:00:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F13F3148BF;
	Fri, 16 Jan 2026 01:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YnhMm37z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F52313550;
	Fri, 16 Jan 2026 01:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768525242; cv=fail; b=uC9CtyVQqiYJloeEX8Y2+W3x59wjXi9oBULdqi8d/29A8EZRuZOSj+C750/Y8+aQ/SmFK3OYu/nH6jXqlljGsKTff7NyUhN8R9NOTmzzkQcTi5sEZq90Ov2qv9MGiXRHZUTlPceZ4IpYGg1gx9JEwEsZxCfGytSXJUF+olWNEFg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768525242; c=relaxed/simple;
	bh=R3hm/FtdbfkMaV39v0P7HLgkieH0uwU3xVVJG0OvfTY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pN7LiS3m1LZJP6iJxqv8RQstG2KXjv1kARF801zxmRI49a83/ZDrd92xnryq02KYh+1R2SPDF333H4Ot6JpSpBNPJqW3yaz0xqE7TVwuRdWAq4vF9tizPF4nWjhzLP5tfMXv7Ow6edtv6DqoXIXBMIA2vv2Z1VD2kcWrPMUNtZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YnhMm37z; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768525241; x=1800061241;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=R3hm/FtdbfkMaV39v0P7HLgkieH0uwU3xVVJG0OvfTY=;
  b=YnhMm37zKYZT5LpckKCBbKu4ldX61suE4AmVGK2Ycn/2yby6Y25QzGKT
   gIukPsv3tdHb8UXzFZ25kACGgfzWVAb+U1eYASyDSs7ZoK7IODCa2ivNS
   KQD7yYHtVfY+AADmufQxcNrExQlR69mSV0e5sLicENRDxcf3j80OrYB/Y
   Qi3mXlW+XiuWymoknVs2deYxErszD2zur/5WJ9lO95Tdd6HZJhX+cXcdf
   W4w+aXet96aFjosovXLESGGWlKzpYRQhJe7u8cvD1WTObQdLFXUG3Kcy3
   3bzejCB07Tu13//l6PBq4FRob/HEdSMMG4WL6UDpf85cQZi8fj0WjC3+j
   Q==;
X-CSE-ConnectionGUID: 5rugRg/CSOS8cRPpk7TtXg==
X-CSE-MsgGUID: ju44IC6QTJ2Kyd8Z3CZxCw==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="70007088"
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="70007088"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 17:00:41 -0800
X-CSE-ConnectionGUID: KktwdEBARYCEXqcpIxpvvg==
X-CSE-MsgGUID: 041HSir0T0GMT54pjxuN/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="210134180"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 17:00:41 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 17:00:40 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 15 Jan 2026 17:00:40 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.34) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 17:00:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eE+P6pByThRGe7VKUUpWoa6CSsacLBYtaWkRN0C5GwZc/f2R+JaFdrkunsHAjKiug3kipXDZpfZZ7ydbRbzn1ZIIByYAnpvD5aQsD5bL8+jiam3JebWr+eghsOcOQhKbyzHpnHzlEdtjyeq1uD6I8TDqn7NmLZKBEHAWfSJA8aOQ94ohBIGf2DL8brjepjonDuCxmDQvva8rf1Atf5izGgDwY75o6vqNhqEl2nqnSbEaYB1q0zwZqxPFZKXr/n2YXKaIIptjPkgxPtvtLzSjqgBSFwh+DsYMks3thgxY3SQRebztnGUOYpfUR8nqJFvB1S9zjD2PaNwJ6o5VoSvnHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R3hm/FtdbfkMaV39v0P7HLgkieH0uwU3xVVJG0OvfTY=;
 b=nGE0Gpu5UZXzIAPRfA972ClyGVdI4ydMrs1yeDgr07RiN/yDlojeQg/boIx4mdtb4ZJwiGuuVjChxD8q3zXDNtxUhEsovHwnOH0LJYpOdi/jhMSdQrSNIzBvZQwyhXhdiAvJcjs4TsDh9AZ807xipYnsaHDuWBeaykRAo+wyUQ3A1sYNPk+ycbd6k9vr75bQwuD0maZ8oCn/Z5zB85G5UZByXBlK+2tY6bn6sMdbx6YZnKMOGjBF7NmjyrGBK0Tes6r5CplDSIqVctlIXF0Sef9uG5bJhsJF+yfRYiMYhNjHCoKFQ3q8HEjYXM+LEKHTdRCKhLd1HaIyXXirV1HWKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DS7PR11MB9451.namprd11.prod.outlook.com (2603:10b6:8:261::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Fri, 16 Jan
 2026 01:00:36 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9499.005; Fri, 16 Jan 2026
 01:00:30 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Du, Fan" <fan.du@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"tabba@google.com" <tabba@google.com>, "david@kernel.org" <david@kernel.org>,
	"kas@kernel.org" <kas@kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, "Peng,
 Chao P" <chao.p.peng@intel.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>, "sagis@google.com" <sagis@google.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Miao, Jun" <jun.miao@intel.com>,
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 02/24] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Thread-Topic: [PATCH v3 02/24] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Thread-Index: AQHcfvYqSBTaRjpSZEO/4jcRgCnGbrVUCRMA
Date: Fri, 16 Jan 2026 01:00:29 +0000
Message-ID: <ec1085b898566cc45311342ff7020904e5d19b2f.camel@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
	 <20260106101849.24889-1-yan.y.zhao@intel.com>
In-Reply-To: <20260106101849.24889-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DS7PR11MB9451:EE_
x-ms-office365-filtering-correlation-id: faaa01e3-58e1-4654-6826-08de549aa4e4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?NGZmMGFic0FXa0FVN1dPRU5CclNmQm9PYzZ5K0V1cVo0QTJXd04rM0gvTUUy?=
 =?utf-8?B?T0R0MlMzRlhacE9zWUlCcWRDa2lhOHpZdDJHMDlLTDNuRUFvOXFnSytoeTRZ?=
 =?utf-8?B?V3dxZXk1dHRTRHNoWlZZdno1dUZhNDVYajVEQm9kY0F5NGJDVUh2N3IwaWpx?=
 =?utf-8?B?SVpkSUtWb1FnRFlNc1lLd0Q1VXYyNDBKSzZnYXdiZW9yd0cvcnZxZW1KRHJR?=
 =?utf-8?B?MlFNbTFzckEzaUZjZGlLL1RCUW9hR3FaRVF5NERaTWVPVE1VZVY2Y2tqN09i?=
 =?utf-8?B?RkR2SExKaXR0M0JMSTVvQnZ2UVJZNkNyNkU0Mk5ibmxqK0hoOGhFOU5UbWJP?=
 =?utf-8?B?QzFiYWdxaFQ1bktiMDgzaFh4RzNrSlY4UVM1YmZxWmVpWllDc0pOY1VzTVdR?=
 =?utf-8?B?ZDMyZldDM3B6ZEVkWXgxNHlXWnhoZ3dqaFg5aW1mM3pRTmJRdk1FNm9wTFV3?=
 =?utf-8?B?OUZ3UWY0N2l0c1dpTHBXcEYvNHRveTY1NDZUWEtsQjVvRFI0MmsrVHl5NHFh?=
 =?utf-8?B?bXcrbDRsRzB4YmtxTy9Kb2ZYNUlPVWVLdWplL056UXRSN09CQ080RHNNY1M0?=
 =?utf-8?B?cUhKb25FT3hLbkhKQUJ4OHo2SU9SVTk0NkRQbUlGU1dsZ1ZSeXFCNjlTNDNw?=
 =?utf-8?B?dmVJSFBNWnEzY3NObFBON3VwZjhvY0VNVldXdGFWUGk2YjEzYmJIU0lMamFH?=
 =?utf-8?B?am5TQi9CZWpqOCtCY0oyOStUTVI3cUpseHZwQkRYQTFucHp6bVhqTGhybmVS?=
 =?utf-8?B?QUM3OGkvYmhBQThISy9obkZHMlBVVVpmMWJiQTBZbHg1dEtUWUJKbnM1U1kw?=
 =?utf-8?B?NlpiekE0UkNRTUlSd20yUnhRdm9lMGdUZXNxODVnekZJY2tSRk9qWUNPSzhK?=
 =?utf-8?B?TVpPYlRnNVZOUmw3dVh0WnNtUVV1blRhMVZHZXh0UDJPOXNCall6MDNodmpo?=
 =?utf-8?B?UC9IRUgyTjJRTTZoY3dxTUZYalZSTS9KNW84Und6V2dwdkQzYUpjMFlwdGdI?=
 =?utf-8?B?b2hzVm9UWW55UW56YTQ4d29aeEVhVUNBQ0x1Zy9iQ1BseE4xdmpFbUVldEpt?=
 =?utf-8?B?dXJwanlRVDlndDVMQUhpaFdEZlEwRjlXK2N0WUhXNjNoam5QTDhWZ2ljQ3d6?=
 =?utf-8?B?MWZ1aGVyc3dydG1ybEtRWGsyUVV2eEJZOWZDT3Y5WGtFWkZrQit1NWdWR3Qr?=
 =?utf-8?B?VUppSnBmS1lSSEtvNm5ETmJYbzVSSXBOdHNjclI1Z1NDSXNXcjdzUnNRLzNL?=
 =?utf-8?B?dkMxZEhTSUhDcVBmYi9leVkrb2tvRStVclRoWEcrcEw1bnVrV3lkZUVxaUVz?=
 =?utf-8?B?VjZYelhtMDdzNE5VaXEwcEVzRDhYcWtWd1BnQVFra0FSdkNoU0cyamw5VHhH?=
 =?utf-8?B?ZkdsK3M2RFM3aWxTN0JKczdpV04rWXFpUlZ1WG1PZUFWeEVYckd0QVN1aDBx?=
 =?utf-8?B?aEtHNGo0bW1aa2JWZ25ZUVpXbWRkUlc3SmNNQy9PWHVFSUgrTWtYQ29rakxB?=
 =?utf-8?B?MEdmNWc1NnVwb3llUmdldmFrZ1BJOUsvd005elg4ZSs4a2RHM25zck1nem5T?=
 =?utf-8?B?VjlLZVIxTUZVY2lCRzVlTnZGVUorRUJFSjNZa1hnU0NwRm5sVTdET1l4ZGdo?=
 =?utf-8?B?T09qSkVNcVErSWhWbjRkWmtNb21GTlBVMi9DL0g2WkpoUi91M0FBUUEzSmla?=
 =?utf-8?B?MWNxYUxKUDIwN1pnc1l0dmNsUlg3dGN5UzJVSlNuT2ZiMmdabU1rbWRhVG9w?=
 =?utf-8?B?TVBBWFl2WmlaUVRkTHF0WjFNelRXSldnMlgreFhjZEZHTGxkem9PQTlBYUcx?=
 =?utf-8?B?SDJuQ1lmK3FzS1EyS3c5Y0NoRUhQNFBxMENYS1RhVTZMdGNLcElpRG1DRFBD?=
 =?utf-8?B?VHd1TEtad2NwRjdXdGlObkYzOVN5KzhTb1Y3eHN0bndyRDZYNm1BVi8zWHhG?=
 =?utf-8?B?eUYxaVBIdGNMTng1RDFaeHhlUEZJMG52MzBqR3Q0bzBRekhqRkFxeFBWT0Mz?=
 =?utf-8?B?Ry9LMHdxa0tlaWJSNkZuUzdJdWJMZ2NFRUtqditTbDd6azFKT01FTFVTVGRQ?=
 =?utf-8?B?czN4NkxidW1EOGNhdzdHaER6R0hhM0lRcngwS1NaYzMraEduOVM1Q0V1MHhK?=
 =?utf-8?B?WThOTlNsRW5LbGM0bTBpTjBrZUtFWnMyNFRIY2hvaXdlRTBXdWJPTlNIdUNW?=
 =?utf-8?Q?bhzJMS/7qMb7f6D/lGMEy7U=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bEt5d3Q1bTJNQnEwYk9YVDVGcVZwZEZJOFRFUUdSaGRIcW5ZeEdHUWx6RHA4?=
 =?utf-8?B?MkxURndnYkZsNmZnVXZFd1RCeDg0Nkd4N1ZaWGJwY0hDam1NMTd6V0ZMNWJ1?=
 =?utf-8?B?UVFqeHl2b2xMQnZLZFlJbnhGUHJiSXFjc3BVdWlJU3hCVzdVb3RJOEwvNGt2?=
 =?utf-8?B?blE1K1pHNUpZWmhjK0xHQi9aOU9YYm9yK1N1SkhBSUZ0WHhjNVRIVFg0cDFk?=
 =?utf-8?B?SWhTbXNaV3dJNkxjcWk3bkNmekJXdHpiZ05hQ2xtaW11aXVPZEw5Y0E3U3ZY?=
 =?utf-8?B?ZWFyb1k1UzV2SlhQN0hJbnZpV3Z1SjFsZ0tyZ0VSYTd0K0p2K05qWUpaanh5?=
 =?utf-8?B?QVMrYk5CL3NlcjdMcHhxU3UxQVhqTG9iY3hqbVBEdVBJZE94aEtMVHBZV2lk?=
 =?utf-8?B?SkRUZC8wUC9VdWxTSFphYVhiUzAxUDBrbWRxN3liZVpPRk9abkFncFJRRWZG?=
 =?utf-8?B?QVVndUxKY2R3dm5COFI2OCtSOUFhMG1yazV6eFdKbFlaOVlJbFE4QVF2eVlx?=
 =?utf-8?B?ajBzMXZDd3Y3UVo5Umh2UlhHaURPdS9TSHNtaWNXM3Nuc1hsQ1JWMFJLZnlk?=
 =?utf-8?B?Vm54bGJmc0tXcGFsR3gwUU55K050WkM5REtzeFBVVU1EVHNhbkRwbTNxLzY0?=
 =?utf-8?B?NzlTbFVqOFIrVWZ2YVNUbGdwZmpBQVFXaEtTbjEvOWJGQmIyNmo5K1dwYWdV?=
 =?utf-8?B?d3JmWGdyRmpzeW9xVkE2T2tuSEpQcmFxYUFYMFREYjY2b1FtenNMdE9zTUpq?=
 =?utf-8?B?dU9NTVRGQ1RjVDlzM3NBaXBBR0ZMS3A2KzU0bHQybERCQ0ZNK2pnZTNKTzBT?=
 =?utf-8?B?VkNNTWE3WXRISXl4Q3JHWFBmeXFvNGF3RGVzK3MzcHkxdjNqdEVFY2JxK3hJ?=
 =?utf-8?B?eCtSMUlZUWF3L3k1akFLS3UrNzVWbWdIMXhwckNKSUs5SFg2bmpjVm5YWkts?=
 =?utf-8?B?dUwrNllFYUVza09MQTB3VnJaTG1MRFlGTUc2dzhWRkNJaS9McjNUd21tSnVS?=
 =?utf-8?B?aG9LNjlMeGVFamtEVXhWNFpXYWNYUzhCUDNZT1JlVjkraVdUNTUxS01QUUtt?=
 =?utf-8?B?ckMwV2FDVE52elc4cFRIdG5LYzhqRjlUNEZ0MzAyaStYM21VNVREV2tZUGs1?=
 =?utf-8?B?WVN3bFhrZjNTSStDa1JiL2pFN3J5Qm5uRHJRTEJBbXk1L0ZDOG90TytnbXBL?=
 =?utf-8?B?VXp5bGttLzFlTnpmMk9idG1Weml6cU5rc2RTOXduK0NqcnhIaDRqd3psM1NE?=
 =?utf-8?B?RVBBUmV6YndHbCs2YThyUFRVVStIdnl2OTZmYmlpVXJXdVd4dGxnSnhYRHFw?=
 =?utf-8?B?YmpUbGlHa1U5bjVweGhUYmw4S0lvcHBFbGtGZjFuR0txM3ErTzM0UmMvV05Y?=
 =?utf-8?B?YWRIbnQ1Mk1YWVZoRjZzQytSODlYZi91czEzdjlpT2FOK3ZqS1FtT2pualIv?=
 =?utf-8?B?OE5lUVUwVWNIdkR2OGpCYlBqREw0Q0ZPaDZnbEttYm5QZmFiaU5LNmN2NjR1?=
 =?utf-8?B?TzByWHMzNGJLT2ZOZGNkZ01yc2JoUDNuWlZ5SlA3YXRIdHBRQmdCY2xsZWg4?=
 =?utf-8?B?VUg0QkFQZkxvSGdaQ01obGx1aG01Znd2WmdHYk5ybFo3M2dLb3hLTVNSTjNo?=
 =?utf-8?B?S2s1emw4dVVMMk43blllVzJrRTN1NjZ4MDlaT25COTV6WVJDUkthYldYV0ZE?=
 =?utf-8?B?VjdGNFcxNmhwMmVFRGF4S1BUTDhpOHBBZStrbVlVR1UxZCswUm9WYXBtcXlM?=
 =?utf-8?B?SWdQcUtxVE1hMkoxTHA3VlZBSW5ON1k0ZzJHUW95SDFCdElUc2V0MW96MkFE?=
 =?utf-8?B?Z2t4MjJJVTVtZTFmWHVRUUd3Zk0wZkZmMFVxYTdqU1FpQ0Z4Tisyem5oa3lB?=
 =?utf-8?B?NXdLTnJmTndwZ1dCVVk0Tm9hYzBFZ2JDN0lZQVQwYmx3NWZSb3gzM0RnbXAz?=
 =?utf-8?B?Q3hYOGdqdjhCV09DRGI3NXFNYjFZdWpwZXlXTFlhWmtIMnVrL3lzTTZlZEht?=
 =?utf-8?B?RTduMklVTGswaUJVdmswM1VUQTIwczhvS2ZiRm91ZGJBQjlYL290dlNIcDhS?=
 =?utf-8?B?Y3V6bHR5MU1yeExzZk1aMEMxUWFzMUNhWVk2RndtaGpvSjVic1A3TldEc21q?=
 =?utf-8?B?czRaSHRZMHdYY1d4OXFHc3UrSm0vVkpsQUFPRjR5VDhVMmRvejZ5TkN0NDBz?=
 =?utf-8?B?bHgvN090ZlFhdnFUaW1xQW4yUlZmZ0xpQ1dxR0c1OEQ4TDN4NVM4NVRCanVl?=
 =?utf-8?B?dU44Tk8raW8rNDNLbk9GL0hPVlhpWlFRaVFab2lnc3FpaEFvVVdoaTN2aHdK?=
 =?utf-8?B?YnJSSGhncjNhZGoxT09KNGtzTEhZbjE3Yzd6QzMvMnlhbytLYnQ4Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F32C9EE37187554B8987E630EA6BC035@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faaa01e3-58e1-4654-6826-08de549aa4e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2026 01:00:30.1222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x+FPe29mbNlOL/TZgQhVP+e1DtC8KDd4pQC0op/usV+Ncvjw/ywJBPJ05B8MaoDPG0CkJapuWuk9AmwUZ/mYFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB9451
X-OriginatorOrg: intel.com

DQo+IA0KPiBFbmFibGUgdGRoX21lbV9wYWdlX2RlbW90ZSgpIG9ubHkgb24gVERYIG1vZHVsZXMg
dGhhdCBzdXBwb3J0IGZlYXR1cmUNCj4gVERYX0ZFQVRVUkVTMC5FTkhBTkNFX0RFTU9URV9JTlRF
UlJVUFRJQklMSVRZLCB3aGljaCBkb2VzIG5vdCByZXR1cm4gZXJyb3INCj4gVERYX0lOVEVSUlVQ
VEVEX1JFU1RBUlRBQkxFIG9uIGJhc2ljIFREWCAoaS5lLiwgd2l0aG91dCBURCBwYXJ0aXRpb24p
IFsyXS4NCj4gDQo+IFRoaXMgaXMgYmVjYXVzZSBlcnJvciBURFhfSU5URVJSVVBURURfUkVTVEFS
VEFCTEUgaXMgZGlmZmljdWx0IHRvIGhhbmRsZS4NCj4gVGhlIFREWCBtb2R1bGUgcHJvdmlkZXMg
bm8gZ3VhcmFudGVlZCBtYXhpbXVtIHJldHJ5IGNvdW50IHRvIGVuc3VyZSBmb3J3YXJkDQo+IHBy
b2dyZXNzIG9mIHRoZSBkZW1vdGlvbi4gSW50ZXJydXB0IHN0b3JtcyBjb3VsZCB0aGVuIHJlc3Vs
dCBpbiBhIERvUyBpZg0KPiBob3N0IHNpbXBseSByZXRyaWVzIGVuZGxlc3NseSBmb3IgVERYX0lO
VEVSUlVQVEVEX1JFU1RBUlRBQkxFLiBEaXNhYmxpbmcNCj4gaW50ZXJydXB0cyBiZWZvcmUgaW52
b2tpbmcgdGhlIFNFQU1DQUxMIGFsc28gZG9lc24ndCB3b3JrIGJlY2F1c2UgTk1JcyBjYW4NCj4g
YWxzbyB0cmlnZ2VyIFREWF9JTlRFUlJVUFRFRF9SRVNUQVJUQUJMRS4gVGhlcmVmb3JlLCB0aGUg
dHJhZGVvZmYgZm9yIGJhc2ljDQo+IFREWCBpcyB0byBkaXNhYmxlIHRoZSBURFhfSU5URVJSVVBU
RURfUkVTVEFSVEFCTEUgZXJyb3IgZ2l2ZW4gdGhlDQo+IHJlYXNvbmFibGUgZXhlY3V0aW9uIHRp
bWUgZm9yIGRlbW90aW9uLiBbMV0NCj4gDQoNClsuLi5dDQoNCj4gdjM6DQo+IC0gVXNlIGEgdmFy
IG5hbWUgdGhhdCBjbGVhcmx5IHRlbGwgdGhhdCB0aGUgcGFnZSBpcyB1c2VkIGFzIGEgcGFnZSB0
YWJsZQ0KPiAgIHBhZ2UuIChCaW5iaW4pLg0KPiAtIENoZWNrIGlmIFREWCBtb2R1bGUgc3VwcG9y
dHMgZmVhdHVyZSBFTkhBTkNFX0RFTU9URV9JTlRFUlJVUFRJQklMSVRZLg0KPiAgIChLYWkpLg0K
PiANClsuLi5dDQoNCj4gK3U2NCB0ZGhfbWVtX3BhZ2VfZGVtb3RlKHN0cnVjdCB0ZHhfdGQgKnRk
LCB1NjQgZ3BhLCBpbnQgbGV2ZWwsIHN0cnVjdCBwYWdlICpuZXdfc2VwdF9wYWdlLA0KPiArCQkJ
dTY0ICpleHRfZXJyMSwgdTY0ICpleHRfZXJyMikNCj4gK3sNCj4gKwlzdHJ1Y3QgdGR4X21vZHVs
ZV9hcmdzIGFyZ3MgPSB7DQo+ICsJCS5yY3ggPSBncGEgfCBsZXZlbCwNCj4gKwkJLnJkeCA9IHRk
eF90ZHJfcGEodGQpLA0KPiArCQkucjggPSBwYWdlX3RvX3BoeXMobmV3X3NlcHRfcGFnZSksDQo+
ICsJfTsNCj4gKwl1NjQgcmV0Ow0KPiArDQo+ICsJaWYgKCF0ZHhfc3VwcG9ydHNfZGVtb3RlX25v
aW50ZXJydXB0KCZ0ZHhfc3lzaW5mbykpDQo+ICsJCXJldHVybiBURFhfU1dfRVJST1I7DQo+IA0K
DQpGb3IgdGhlIHJlY29yZCwgd2hpbGUgSSByZXBsaWVkIG15IHN1Z2dlc3Rpb24gWypdIHRvIHRo
aXMgcGF0Y2ggaW4gdjIsIGl0DQp3YXMgYmFzaWNhbGx5IGJlY2F1c2UgdGhlIGRpc2N1c3Npb24g
d2FzIGFscmVhZHkgaW4gdGhhdCBwYXRjaCAtLSBJIGRpZG4ndA0KbWVhbiB0byBkbyB0aGlzIGNo
ZWNrIGluc2lkZSB0ZGhfbWVtX3BhZ2VfZGVtb3RlKCksIGJ1dCBkbyB0aGlzIGNoZWNrIGluDQpL
Vk0gcGFnZSBmYXVsdCBwYXRjaCBhbmQgcmV0dXJuIDRLIGFzIG1heGltdW0gbWFwcGluZyBsZXZl
bC4NCg0KVGhlIHByZWNpc2Ugd29yZHMgd2VyZToNCg0KICBTbyBpZiB0aGUgZGVjaXNpb24gaXMg
dG8gbm90IHVzZSAyTSBwYWdlIHdoZW4gVERIX01FTV9QQUdFX0RFTU9URSBjYW4gDQogIHJldHVy
biBURFhfSU5URVJSVVBURURfUkVTVEFSVEFCTEUsIG1heWJlIHdlIGNhbiBqdXN0IGNoZWNrIHRo
aXMgDQogIGVudW1lcmF0aW9uIGluIGZhdWx0IGhhbmRsZXIgYW5kIGFsd2F5cyBtYWtlIG1hcHBp
bmcgbGV2ZWwgYXMgNEs/DQoNCkxvb2tpbmcgYXQgdGhpcyBzZXJpZXMsIHRoaXMgaXMgZXZlbnR1
YWxseSBkb25lIGluIHlvdXIgbGFzdCBwYXRjaC4gIEJ1dCBJDQpkb24ndCBxdWl0ZSB1bmRlcnN0
YW5kIHdoYXQncyB0aGUgYWRkaXRpb25hbCB2YWx1ZSBvZiBkb2luZyBzdWNoIGNoZWNrIGFuZA0K
cmV0dXJuIFREWF9TV19FUlJPUiBpbiB0aGlzIFNFQU1DQUxMIHdyYXBwZXIuDQoNCkN1cnJlbnRs
eSBpbiB0aGlzIHNlcmllcywgaXQgZG9lc24ndCBtYXR0ZXIgd2hldGhlciB0aGlzIHdyYXBwZXIg
cmV0dXJucw0KVERYX1NXX0VSUk9SIG9yIHRoZSByZWFsIFREWF9JTlRFUlJVUFRFRF9SRVNUQVJU
QUJMRSAtLSBLVk0gdGVybWluYXRlcyB0aGUNClREIGFueXdheSAoc2VlIHlvdXIgcGF0Y2ggOCkg
YmVjYXVzZSB0aGlzIGlzIHVuZXhwZWN0ZWQgYXMgY2hlY2tlZCBpbiB5b3VyDQpsYXN0IHBhdGNo
Lg0KDQpJTUhPIHdlIHNob3VsZCBnZXQgcmlkIG9mIHRoaXMgY2hlY2sgaW4gdGhpcyBsb3cgbGV2
ZWwgd3JhcHBlci4NCg0KWypdOg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL2ZiZjA0YjA5
ZjEzYmMyY2UwMDRhYzk3ZWU5YzFmMmM5NjVmNDRmZGYuY2FtZWxAaW50ZWwuY29tLyN0DQo=

