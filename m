Return-Path: <kvm+bounces-71066-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oIBHM3tUj2lqQQEAu9opvQ
	(envelope-from <kvm+bounces-71066-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 17:42:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E9F5C138512
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 17:42:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 54D153059B3A
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:38:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 267A63659EB;
	Fri, 13 Feb 2026 16:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0i9dlSYw"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010047.outbound.protection.outlook.com [52.101.201.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DED2DCC05;
	Fri, 13 Feb 2026 16:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771000680; cv=fail; b=mhA8mVgqGm2vBeKbvv45p7urXe6cU7ZB0gjT79cR6bGv+vWqzrNr8fXoz9R82eFXJFwytMqYLMYWbOGJmMUUANII9wX6Qm1g7tVP4mtp/n/dk2Dn4uwaVBQ7IN6ivb5jEE+P3d/D9yHxtFyyHaYHQfK2Xqyl6+8UHHkoOEv4mYQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771000680; c=relaxed/simple;
	bh=e4IluKA8KVOdONfY9ocFWix2sbjl5TRxos8BMX5g/KA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HXdQQjNw6RS4m6nVlUAeFLDvH+dVGIQVxC9oTmPioIsxF2v25YalHuvw2bZvmZnzMpQPIUK9Q/librqxc3dO2GioZfE60bp5Wz32NmWDlW671zDrZ+9fKRIEnWhqt8mSBD52it/lJDAzNrSwDuqiTVCJ+pUXY54DMpfBg1Vz6kA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0i9dlSYw; arc=fail smtp.client-ip=52.101.201.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ecHVJK3mZ+FQtFwlwxlIyFAKgFnchY9snKaam+Q/b62jDvTUXuu43oPUB0MRTa9WQQd2UuioUPXTxhi/nZxx7SlLAaNjwxMaeWjr0AE9sOVN30GiP3PGg2R16LW4RLlQ/53AFYPSAChKy57BxYPchtEj9xXQUj8xdF4tuV3/hlg1+yq9Up6lbDuQLVlmNRFh2Z2c12ynGzUlXvnAB5OPCBgenNqYL9NMgZbaUh6S0BFTGQ/wv99q3nliVz9T7BZNcHWvCWmJ4JmPVXqWCbgIOGo23NoxlGLegG8JECN/QAPYV9t3e6y8tedVxc/n80vDcs2nj/mahfikp9IjDkNlNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2wiFj5kcILcbtUpCnyXJHIN6k3DJjDKxoA+/AobrBww=;
 b=Hw43wGld30NZ08Z5CsN7prjPw4ghidBMPEVk62JLnrR4D37AmA7hfTG1Ms35sTKh8vpVfcE7+jGpvOxOUxrQYMd0uxXZNqmusDrY/NKqUKhhhmkMnsrVCdmeyt9vbB5yb+Q8PNrWj11/ixINU13zzA4TTHxPJTnAa7c9jk0LXNzEehb7y0Xl7GAVX9t5fSWkgWNw7JaBE3yAhUXI/PR9lnBYWcgNkAiaDCZH0BWGbG+gCWX1ntH0x/SmfDhjO3XO40n1LAsJR5UA/xKXOaG3aKpURpw0gCRDZmmB0teNAUXm3WUy3Q6da01VXJwKDS1wTQUCEElY+eZnWowZvYnNSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2wiFj5kcILcbtUpCnyXJHIN6k3DJjDKxoA+/AobrBww=;
 b=0i9dlSYwBFKGTYDgzMT+EDvqjbjX4zyyXoLH+wEHU2/LhohgOB5iHLQQviU90Qn4BxX2zUD5LY/B19eDtbShXCvuX4wjpPPhbPskecjd9yvqAvuTUUwO25j+yDKyrb++dpFqFW+ZmbV0nbD7L+7eOLyPlUYiNGZaB9zjtwU8zL0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by CH3PR12MB9249.namprd12.prod.outlook.com
 (2603:10b6:610:1bc::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.11; Fri, 13 Feb
 2026 16:37:54 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0%3]) with mapi id 15.20.9611.008; Fri, 13 Feb 2026
 16:37:54 +0000
Message-ID: <abb049fa-3a3d-4601-9ae3-61eeb7fd8fcf@amd.com>
Date: Fri, 13 Feb 2026 10:37:48 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: Reinette Chatre <reinette.chatre@intel.com>,
 "Moger, Babu" <Babu.Moger@amd.com>, "Luck, Tony" <tony.luck@intel.com>
Cc: "corbet@lwn.net" <corbet@lwn.net>,
 "Dave.Martin@arm.com" <Dave.Martin@arm.com>,
 "james.morse@arm.com" <james.morse@arm.com>,
 "tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
 "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
 "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
 "dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>,
 "rostedt@goodmis.org" <rostedt@goodmis.org>,
 "bsegall@google.com" <bsegall@google.com>, "mgorman@suse.de"
 <mgorman@suse.de>, "vschneid@redhat.com" <vschneid@redhat.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>,
 "pmladek@suse.com" <pmladek@suse.com>,
 "feng.tang@linux.alibaba.com" <feng.tang@linux.alibaba.com>,
 "kees@kernel.org" <kees@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>,
 "fvdl@google.com" <fvdl@google.com>,
 "lirongqing@baidu.com" <lirongqing@baidu.com>,
 "bhelgaas@google.com" <bhelgaas@google.com>,
 "seanjc@google.com" <seanjc@google.com>, "xin@zytor.com" <xin@zytor.com>,
 "Shukla, Manali" <Manali.Shukla@amd.com>,
 "dapeng1.mi@linux.intel.com" <dapeng1.mi@linux.intel.com>,
 "chang.seok.bae@intel.com" <chang.seok.bae@intel.com>,
 "Limonciello, Mario" <Mario.Limonciello@amd.com>,
 "naveen@kernel.org" <naveen@kernel.org>,
 "elena.reshetova@intel.com" <elena.reshetova@intel.com>,
 "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "peternewman@google.com" <peternewman@google.com>,
 "eranian@google.com" <eranian@google.com>,
 "Shenoy, Gautham Ranjal" <gautham.shenoy@amd.com>
References: <cover.1769029977.git.babu.moger@amd.com>
 <17c9c0c252dcfe707dffe5986e7c98cd121f7cef.1769029977.git.babu.moger@amd.com>
 <aXk8hRtv6ATEjW8A@agluck-desk3>
 <5ec19557-6a62-4158-af82-c70bac75226f@amd.com>
 <aXpDdUQHCnQyhcL3@agluck-desk3>
 <IA0PPF9A76BB3A655A28E9695C8AD1CC59F9591A@IA0PPF9A76BB3A6.namprd12.prod.outlook.com>
 <bbe80a9a-70f0-4cd1-bd6a-4a45212aa80b@amd.com>
 <7a4ea07d-88e6-4f0f-a3ce-4fd97388cec4@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <7a4ea07d-88e6-4f0f-a3ce-4fd97388cec4@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0292.namprd03.prod.outlook.com
 (2603:10b6:610:e6::27) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|CH3PR12MB9249:EE_
X-MS-Office365-Filtering-Correlation-Id: 89c5490e-c100-4bcf-e114-08de6b1e3c73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NmtvL0REY2daOWhVV3l4emt4REVDOW5abWNCRDhydXJMSlRUeUpzcGtvQWU4?=
 =?utf-8?B?YTE5ZFdBQTlUSFFnTkVyWmJOVTdQOENtOWFzTDEzS3Y2RGE3OTJ4QnZEemNz?=
 =?utf-8?B?TnhONm9Jc25XVDhEZFEyT1EzdVF0QkV1dUFaT0cwMmx0bGQxRElxc3Nrckww?=
 =?utf-8?B?cksySVRQSDBFZjEyclc5ekFNUGVUSEcxUm4rS3lhbzNQYmkvL0RRNHVBYytI?=
 =?utf-8?B?ek5KSnFsQmk3S01sTHJaNWc5bElkVWRaUmU2cXQxaUFGY0I4Z0Znc3dsVi9F?=
 =?utf-8?B?UVFmZVpZcHpVcDBmNWZGejJkM0FLUWZ6ZEdRdUorWHZsRDc5d3JZR3NxaDVB?=
 =?utf-8?B?SGg4MU10NG5KREFyWkV0Y0szSnhBUHAvTW1VbnN3QTVON29HbURtSkFsS0kx?=
 =?utf-8?B?dmtESzNwZ3pBNHdBYnNtVjNmaEdDcG9GaHlHWXZpdDB4cFBKMzh4bFg3VDJV?=
 =?utf-8?B?TEllSVdkM3NjOUpxYUNYbXkxTTNGRWhYYU5BdytXSFpVaWw3RDZJVWVVUFZ5?=
 =?utf-8?B?RHc5eDRtd2E3ekFrMU5RVUxMWHJaYWk5OUFkODZ3eGsxd1JEV1IxUHczS1NP?=
 =?utf-8?B?N3lIeUVwck5FdUN0ekVJbnlPVVB5dlc2VEo3WDZ6eVgyeUJEY0dFSFE1L1dh?=
 =?utf-8?B?L2FPek9LUG94amVCeFFKOUorNG9OK2RjUzRaU1Q1SDkraW43SUtsQmFVL01w?=
 =?utf-8?B?UFlBblJtSjFjNC84eERHdGdkMk9aM1c3Y3RneENzbHMzNmR5N3U1MEJzYnd5?=
 =?utf-8?B?RFdiNjVHdjg2VW9CWitWbGMwaS9ianZTQWVGaGJONVN2cFh6TGliUGFXTzJl?=
 =?utf-8?B?d1VHTERKcVdiMzVtM2pYL0RYdC8ycHNrU0hlbTRncWh0cFUwWGwxaFZ3MmZS?=
 =?utf-8?B?YTlRQzNtczhkOHVabU9EZ3d6RFBhNkZLWWpTVUxqREpackFiSXlYNlFUZWJI?=
 =?utf-8?B?WnJZR1BEUjRPYnJhKzZRQVMyemxFS28wdGxaalFxRlQrQXdva3MxbE1qMTl2?=
 =?utf-8?B?ZHZiUXZod1NFaTFCdkkya1oweURUWWlXeTF2L0xtSStvcUQ5WmdKL2RkUnJp?=
 =?utf-8?B?N3B1Vk0weVZxeEd3N3BXVDFVdFJORnVpTGtVOG16dS9vMEhlVGFhVmN5eFhW?=
 =?utf-8?B?MVpxaDBiY09xT3l4WVNXR2tRT3IvOVRBUkJHY1NOLzlpUk5vcnlXOW5YNmVI?=
 =?utf-8?B?U2lqWjdUTmdRalpjdHBvZS9oa1Fzc2dqd3B4a0V0bUlydXNPR2ZaM2xXN1NQ?=
 =?utf-8?B?SmVJUFBGb2NWL29YOWJna0huV3g2NDdLbXQzYkJndFIvVVhpSlpsQjBRUzJZ?=
 =?utf-8?B?b05kNEFYV0dDdTc0b1ZOOXV1U3ZKQW1pLzkwVXNTU0lTbWVydGM5VFVjZ3hi?=
 =?utf-8?B?b216aEoySmtiUFRoMXcwa0sxaFZ5aUh6R2ZnWXFFOVY1N0xySGhuSG5NVlhx?=
 =?utf-8?B?d1J4cngrU0JVaFFVUnd4QjNpM3RuTEJyNXA5eHpTL1BMMUxlaDlLWkZxY1RU?=
 =?utf-8?B?cUM3Zkt6bnl3MXR5MHdFZ0dyWVpaQ3QraU1MLzJ4cFZHY2NpZWVUeVl2MW1B?=
 =?utf-8?B?WXA2NTZDMWc3THN1NFhiZnRwVDI1SmNqT1pFemw2QmtWWFp0QmkraUJUeW1I?=
 =?utf-8?B?ZHMwdXBOOTNLL2FrajlaV3gzcUs3R0pXZUN0MXJMRGRPczJNbmgwNzRqT1VK?=
 =?utf-8?B?WmNUUVUwemYrcVhGN1hrUWowT2tPNDZBTk9LenFsTmhQYkZhNkd5UVljd1pI?=
 =?utf-8?B?d3hwaENrUVQrVTNWSncwL2ltektwVGVOdnFnT1UxL0tMLzhTS3YwbytzQlQr?=
 =?utf-8?B?MHZhLzFORmFDVGhrNW15QWhEdHg1TkhQUGlROGhlOTZTMWVKTGlzZ1ZjWlJm?=
 =?utf-8?B?Ymp2QlZYWldCemhzTTZ1TExuWVFsSjJzMTUyQWtsOGtJR0pkS3hyVnp2Vjl4?=
 =?utf-8?B?OXN0amRreFBQNjhUSGpOQlJicXRwbEF5N05qaWkyRGhMMUdvckhIZzlDcHAr?=
 =?utf-8?B?UnlZOUh2VG00NUw4clVCbmxGSmJzNHpYVTk0MzduQ1Vva3Y4dXFJRHlwaS8x?=
 =?utf-8?B?bmNUaUoxUnc1VHZSRlhHM2tTQzV5WGNaaGdqVUNTZm4weWtuUlphYnFVUXFX?=
 =?utf-8?Q?aFSk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2Jldmo5N0ZnWEVtdlBrMDVLVW5FczRXZ29UR2lpalplMzE5KzNUek5xM091?=
 =?utf-8?B?bTgySDBYZFl1S3I4bUZLOTBhU1dzTzVlOC92SmpuOVR1c1BkakZtVnhCOXdK?=
 =?utf-8?B?N2VCbFNqZjN3Q3Z2R1dzeHE5aUtTekF2ckEzZFZUS3VnU2lTdU1tSWpLaGZ5?=
 =?utf-8?B?NXNXMlpsb2d2Sjk1TkExL1pxRE14SHg4dC9na3pQTnQxRmJpYUNjWlc0Z1A1?=
 =?utf-8?B?eWtYelFCRXF4UGpFdSs0RDJaeUxGNXdsbGlWZUJxUTYxUVU0YnlQQzhsQUla?=
 =?utf-8?B?dm1ScnRTK2hETVVrZEozZUJsZkUrNFpSeHRUanc2cnhpaHVhL0dRWkRtQVY2?=
 =?utf-8?B?Q0xMTC9nOWNwQUxtdVBpTnJHNWRVL1VmQmg1Nmhma0hWWDdIV2phQUxvcDcz?=
 =?utf-8?B?VExXa1BjRnlmNm5CY0FUN00rYngvejhpelZxWnRGYTNuZGV0NE5oVW0rRGNh?=
 =?utf-8?B?a2gzQVlQQWtKUXhOZmVYSlVPa0hIdFVZTmdMdUdxNlVnOGh0SFNwMU5kUDVr?=
 =?utf-8?B?elIvSmJudThRVnBqSGs5QlcybHpUbjN4eER5d0tRQlptV3k0aDN3M3MxeWM2?=
 =?utf-8?B?VER6KzBMenF0azZnakM5TnQwTFV0T0lrNGpWZXd3d1pHcDhLOEhQM282Wldr?=
 =?utf-8?B?TWpldVA4YlNOUytBZTBhY05WMGgxT29CeG00Yzl0NnEvSk1JWDVWK2RuYTlE?=
 =?utf-8?B?bHpGSFlEU1VoVmN0dFhkanB4QjYybjNlbENmU2JoNTdUU0pUN2JYL09NdTFL?=
 =?utf-8?B?ckRDMEV0aDZyMElyZDdVdTJtYzNGUVlXK0dHZXUxL2NoZ0lBMGhMaTZkdE00?=
 =?utf-8?B?UjFzdk1aVGxlbHNuQ1RPdE00S2lMVGoyL3dDU2xCVjFuOWprNFRSNHhrTjRG?=
 =?utf-8?B?V1AvQktUTGxnbSs4bnU0SlJidTlESjZiOWpISTJUblp1WW9DdWlNTFd4QTc2?=
 =?utf-8?B?OXFHb1l5eTZvSEFZVHdDL0RBNnRqdldUT0QvYXRxN3JxRmYyWkl2VnB6bVBM?=
 =?utf-8?B?MldFekNQR05MeE1iSTVBTWJ2VWhleW0rK3RRZ0NNQm1zOEl5ajFzNHBTcFVL?=
 =?utf-8?B?aUh6MEpndlY0RGgwRmpGcm9SQjRCazgzN0JIYjlXaVI3VElCU3hvYlU5RExG?=
 =?utf-8?B?eEFTTU03eHRDNlR1WkljVXZnQ3lMZVlLQjY0ZUVYcnlUTDlhMTM5R2VPUGdt?=
 =?utf-8?B?N2hVOXdlSnlKcUZ0RUJEaFhSaGdSVzlFbGFrd3hoa2RZK3lzTytYQnlxUm14?=
 =?utf-8?B?TWh2VGsyQk9IUCtwbEtoVGNNSkdHWjcwVVl1QW1MdEwwUUVMZzQrczFPeU4w?=
 =?utf-8?B?TFdyclZlV0NxMkEyT1FqM3RkNG1oaGQwbDJDTmsxNUdidU9tQXc3ck9mNy9B?=
 =?utf-8?B?cFZjdHVheExwbEFZa2E2ZWZwM2JLdWtJUzVkVHViSzVpTFJTVThrd3p2N2hS?=
 =?utf-8?B?YkVQcElQcjZybmVhRXVaeHdRejQ1ZDVOSjJ1WnZyblVGb29jOFJwakpUa0gy?=
 =?utf-8?B?MWljUzVBYkplaWVXdU9ieFozRHFtNVA2TGpPc2lBd2p5eGM5U3VqSFNsakxZ?=
 =?utf-8?B?b1NDUjRjVDRJeHprekNaMi9kVkZwL2lIelQwM2hvWmdDemh5azlMczVScFdM?=
 =?utf-8?B?OW9qdEV6ZnZRZWJGTG9ZQkd6Ny9aT2xzSzI2UGRwMEIrcWd2ZVVUczRqTVlm?=
 =?utf-8?B?UEsweVFxcC8xNHBhaHllT2xtOE4vU0d4NzM2czVTbkgvZXllMDJVOWczNG4x?=
 =?utf-8?B?VkVUblNIWG81dUFoUGFwRis0b3FHU0NjRlFBZ1JHZE44b2RsN01KbVZ4bWNu?=
 =?utf-8?B?Tkl3Smx4TDdHTEN3c0JNS1dDNXp2WlJ2bDdtU3I3TnkwRXFyM0JrWm5sbVBa?=
 =?utf-8?B?MmxQa1ZrcUFBSWdYQ3NjMStyT0dnK1FoZ1VQZFcveXNzVWI4V3hsUC9DRnFT?=
 =?utf-8?B?WVphWmE4Vk5QWjNVOE9xa09uK25DNDBja09QTU1HeTN4MFdQMXJEakN4YjM4?=
 =?utf-8?B?WHJ0TzJDYTBPcUx6ZmxPbWQ3S0dNbmtvei9obEVjKytONjVCOGczQk5FWGFR?=
 =?utf-8?B?WXV4QmdadnMyZXZsNWNZSWwvZCs5QzNCcXRyZFI0SDdwUE1aMlY2TFpVZXF5?=
 =?utf-8?B?Y29YWmNRY05JSklRSTljOU1vUThoM0VhYjZneVJKdnZFOGJ3VXZNeDZQT0lH?=
 =?utf-8?B?NE02L3ZPUFphR0JTZGlyUzg5aGNFVUZqcm9wSDM0dzZvZE53M1dhNHhrWVhR?=
 =?utf-8?B?UE84U0RFZHZubGFPUEpKa2EyVDFMWHZvZTF0SmNWK3RvYUIvMnpBSjRuTGRq?=
 =?utf-8?Q?4PXprV6lV62sOI2HIt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89c5490e-c100-4bcf-e114-08de6b1e3c73
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2026 16:37:54.1944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZOy6JcVPMhoMGMC4zQZl6ytFHFUpEridlc1w2axY3MbiK9gNkzcqPylNRCF2zx8R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9249
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71066-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bmoger@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim]
X-Rspamd-Queue-Id: E9F5C138512
X-Rspamd-Action: no action

Hi Reinette,

On 2/10/2026 10:17 AM, Reinette Chatre wrote:
> Hi Babu,
> 
> On 1/28/26 9:44 AM, Moger, Babu wrote:
>>
>>
>> On 1/28/2026 11:41 AM, Moger, Babu wrote:
>>>> On Wed, Jan 28, 2026 at 10:01:39AM -0600, Moger, Babu wrote:
>>>>> On 1/27/2026 4:30 PM, Luck, Tony wrote:
>>>> Babu,
>>>>
>>>> I've read a bit more of the code now and I think I understand more.
>>>>
>>>> Some useful additions to your explanation.
>>>>
>>>> 1) Only one CTRL group can be marked as PLZA
>>>
>>> Yes. Correct.
> 
> Why limit it to one CTRL_MON group and why not support it for MON groups?

There can be only one PLZA configuration in a system. The values in the 
MSR_IA32_PQR_PLZA_ASSOC register (RMID, RMID_EN, CLOSID, CLOSID_EN) must 
be identical across all logical processors. The only field that may 
differ is PLZA_EN.

I was initially unsure which RMID should be used when PLZA is enabled on 
MON groups.

After re-evaluating, enabling PLZA on MON groups is still feasible:

1. Only one group in the system can have PLZA enabled.
2. If PLZA is enabled on CTRL_MON group then we cannot enable PLZA on 
MON group.
3. If PLZA is enabled on the CTRL_MON group, then the CLOSID and RMID of 
the CTRL_MON group can be written.
4. If PLZA is enabled on a MON group, then the CLOSID of the CTRL_MON 
group can be used, while the RMID of the MON group can be written.

I am thinking this approach should work.

> 
> Limiting it to a single CTRL group seems restrictive in a few ways:
> 1) It requires that the "PLZA" group has a dedicated CLOSID. This reduces the
>     number of use cases that can be supported. Consider, for example, an existing
>     "high priority" resource group and a "low priority" resource group. The user may
>     just want to let the tasks in the "low priority" resource group run as "high priority"
>     when in CPL0. This of course may depend on what resources are allocated, for example
>     cache may need more care, but if, for example, user is only interested in memory
>     bandwidth allocation this seems a reasonable use case?
> 2) Similar to what Tony [1] mentioned this does not enable what the hardware is
>     capable of in terms of number of different control groups/CLOSID that can be
>     assigned to MSR_IA32_PQR_PLZA_ASSOC. Why limit PLZA to one CLOSID?
> 3) The feature seems to support RMID in MSR_IA32_PQR_PLZA_ASSOC similar to
>     MSR_IA32_PQR_ASSOC. With this, it should be possible for user space to, for
>     example, create a resource group that contains tasks of interest and create
>     a monitor group within it that monitors all tasks' bandwidth usage when in CPL0.
>     This will give user space better insight into system behavior and from what I can
>     tell is supported by the feature but not enabled?


Yes, as long as PLZA is enabled on only one group in the entire system

> 
>>>
>>>> 2) It can't be the root/default group
>>>
>>> This is something I added to keep the default group in a un-disturbed,
> 
> Why was this needed?
> 

With the new approach mentioned about we can enable in default group also.

>>>
>>>> 3) It can't have sub monitor groups
> 
> Why not?

Ditto. With the new approach mentioned about we can enable in default 
group also.

> 
>>>> 4) It can't be pseudo-locked
>>>
>>> Yes.
>>>
>>>>
>>>> Would a potential use case involve putting *all* tasks into the PLZA group? That
>>>> would avoid any additional context switch overhead as the PLZA MSR would never
>>>> need to change.
>>>
>>> Yes. That can be one use case.
>>>
>>>>
>>>> If that is the case, maybe for the PLZA group we should allow user to
>>>> do:
>>>>
>>>> # echo '*' > tasks
> 
> Dedicating a resource group to "PLZA" seems restrictive while also adding many
> complications since this designation makes resource group behave differently and
> thus the files need to get extra "treatments" to handle this "PLZA" designation.
> 
> I am wondering if it will not be simpler to introduce just one new file, for example
> "tasks_cpl0" in both CTRL_MON and MON groups. When user space writes a task ID to the
> file it "enables" PLZA for this task and that group's CLOSID and RMID is the associated
> task's "PLZA" CLOSID and RMID. This gives user space the flexibility to use the same
> resource group to manage user space and kernel space allocations while also supporting
> various monitoring use cases. This still supports the "dedicate a resource group to PLZA"
> use case where user space can create a new resource group with certain allocations but the
> "tasks" file will be empty and "tasks_cpl0" contains the tasks needing to run with
> the resource group's allocations when in CPL0.

Yes. We should be able do that. We need both tasks_cpl0 and cpus_cpl0.

We need make sure only one group can configured in the system and not 
allow in other groups when it is already enabled.

Thanks
Babu

> 
> Reinette
> 
> [1] https://lore.kernel.org/lkml/aXpgragcLS2L8ROe@agluck-desk3/
> 


