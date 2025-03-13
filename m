Return-Path: <kvm+bounces-40991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 077E0A60217
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:12:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D896A7A49FC
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:11:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8B241F76B3;
	Thu, 13 Mar 2025 20:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="nUD8ACRB";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="LdH8AyEn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF931F4735;
	Thu, 13 Mar 2025 20:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741896640; cv=fail; b=pcv5InUvRKFP52GbzAmLw+tOrUuzRcNJ8SH+MFWGtKcMtiqo3QPNRVZB+HSvM+PYcRSq07wKIO52mwx0MuCsb+D0l6MWu7Zb87k+opfCXSVi4ds0sDgf0Mg0n5CxF9M7KGHFvAGiOiZOiAWqhXkmGXzbg70/V0QH5sFoikrq7Vk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741896640; c=relaxed/simple;
	bh=br9h7Lsa74nlQ+yoS7wu0BIveLoOgXJNFuzjarVqyxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JnOi1RSs64yXYDzG6MZ2fQT1sIqV6JQBPMLJGuifdpn0PJCxGYO/G/Rs2Yo3OYlaf2rmfGqYnuHcHnc7lOIILo6PGma5kPPevhZcYzhvWZqSx83SRMNh39yXtl2gtxx1VadoTkzltkFM9KUtoXXga/nDgqi0kTunIMp85T4mJ6E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=nUD8ACRB; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=LdH8AyEn; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DCn4sn027623;
	Thu, 13 Mar 2025 13:10:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=06sECWbceFd0AbmzFjp+twG31za2335D1bhHE3gMf
	Dk=; b=nUD8ACRBnmfpN3vqBU0Mk0RKTMN29lj69lytB3ymcZ4MLNQe+cusRrcOi
	5smETxNfZ3X0TDoNw8MtYwNEmH+zk/c0bp6s1xiJGDO/tCXm0or9tRcwuuJwvKcH
	M7gY1gmVAj619L7wEXw6Nyt7vjqAm09S/UgAFOJRxgYTdj0/e9ND7JMtZ4OYAY/A
	1zqNobwSIyQuAPuvkXiyn0Kc0ty6bpq45C/esP+btBsckVlBgP08FamA4XlrRaAB
	lx+gDUzS9MwjDvrEIc25gOiyzfgFWrC/SXOvGsOKyOvlklo6sNyCUpj02FbRprK/
	ds2QIjNxYMzY68DylBN11oMMVuqvA==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azlp17011030.outbound.protection.outlook.com [40.93.12.30])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 45au9ep6t2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Mar 2025 13:10:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R26W1gBd8ECivGQMQmeEiY4xaRLkMj+eOE7feqC3td1BGWUf/0x6jYn/offfp6QXIRLl3QO3ZLQAJ/Hejg7519sAI6Q/v12ig4ewMShKkoGazP7YlKFo7DY/65dHt4f6O3TgNjN88JzdqETenJzqubcL+LUtC6gpe7rocx+1N1H2vbapskDRtv3jFnUOS3hXnoqYLenNSpEsK8h8B7elzKExZe3DkwC+H0IIgrYX8dWsMgkjkVIVD/JWhkaz9F+qi+RHdddIecjck86JQZmWsATleVOIWjtat/Cf0ndpT6IHw6OIQkBipTqWxYukCKR7pTiBWuIcEo87VZ96mzUXLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=06sECWbceFd0AbmzFjp+twG31za2335D1bhHE3gMfDk=;
 b=l5ODm+1dnWFo8S5c7Ztb9UWt8EOWHnlZsWzyoWllXW9lZkY9PuId49HlSnuy7SKVZCmmYr8iQucBI2BL4z7yRhYcv/5O+DTIGCCabVsWS6FOPDS8XhuZvAzO5o2h/2Gkf7PKUZl7BPDQ744Y/UVjhGHQCrV6zVGJmDu0LX98t84gNh5bIyvnrcEvZKciNW1U/aVhKDQrxOuPKsZT2ipC/OrucaCZA1tejrWDl5wt9MZWXXIKEjKyZdfuv+/wH2YdE/goVENrRBzOi0PqkzW0JnccERQARCBEQXt4HjImVrLO5RsVH7NcEBXl/50iZ/yJ+NqBLEVk+6GJliwlohIaNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06sECWbceFd0AbmzFjp+twG31za2335D1bhHE3gMfDk=;
 b=LdH8AyEnitGJJLvstVvHM3RHbOiC3TpAH2hrXGssqkAhD7fCnZf2aEM3ysqHWirDrTNQHX5mjpPc9FK67OefTOMbtlHslPa5mPAUZ/F9/UhydWrYKokaYobVhD/ywPRbx9CXcS/mYRkGZ9SdhCpy9JldjZFKFvokTo/ngdgp8fuJ2Jq3Fgqf84oXsyi5kJ3Hz/fyF1QXMXm/wVm4PwggSmH2B+tr+KrdLclsJ7qGt+V0n0viDVe/wnUIHpVmxOklObH+XfgZttl/MqFnjaKh+tUqzCBU+8jbrm7f4TueOH5iixm/XFHSqm10A5JA/VxuI4uTwh/FVGN8DzEvKyhlqg==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by PH0PR02MB9384.namprd02.prod.outlook.com
 (2603:10b6:510:280::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.28; Thu, 13 Mar
 2025 20:10:09 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8534.028; Thu, 13 Mar 2025
 20:10:09 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Jon Kohler <jon@nutanix.com>
Subject: [RFC PATCH 04/18] KVM: VMX: add cpu_has_vmx_mbec helper
Date: Thu, 13 Mar 2025 13:36:43 -0700
Message-ID: <20250313203702.575156-5-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250313203702.575156-1-jon@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH8PR02CA0007.namprd02.prod.outlook.com
 (2603:10b6:510:2d0::18) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|PH0PR02MB9384:EE_
X-MS-Office365-Filtering-Correlation-Id: 336f724c-0016-400e-8f3b-08dd626b0ddc
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|376014|7416014|366016|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NnZKblFWRjJxQ3hpci9GYy83SUc1cTRYbXVNZ0NhUEZ1T2pqcDNMcVc1S0Z0?=
 =?utf-8?B?dDg5Z2hGNkRNanFGOXp0RFFld0lFSHVBMGI3SVZqa3hBdHh6U1pqTStQa1Zz?=
 =?utf-8?B?dC9Ed2N3OE9oYTVBbFpKYkNSVjZ5d1NGN3ZtWEF2cFRuVjdldHIyVUlZRWF2?=
 =?utf-8?B?SHVMdFRuY3N3NlFhMEVtNUVPbG1MeUdWc092akVtaEhuWEV6MTRoVkI4SGMw?=
 =?utf-8?B?eVFiNU1makFnMFNmSjZ3WDlXWkRVeE1QQzRYWlI2S3YvTzh3ZFJrbnN4UjBk?=
 =?utf-8?B?NjJZclRGZ3ltUXFJYURGZ2ViVXBwclZObjg2NGF2ci9zWnpqd2M2MTRVNlhn?=
 =?utf-8?B?MkxoK25kZ2o5K0ljVys3ZlZrTlhyelJJanJnZFVZK0hnWUlORXFtcVBLM0Ru?=
 =?utf-8?B?UVR1bXlpOWxWUEN4S2ZYK1R6SGh2SDJrU3ZWYXZjZk82Y3kzMEllcWE3STd3?=
 =?utf-8?B?N0hFR1Z1dk5VM1hkNWc5blgxZlB5Wk42czQ0QUNzSW8xZTl6UXlMeS93WDVl?=
 =?utf-8?B?U1hHRlF2eUJhZC9HOStpY2R0QmJLTzZwOEFWOTl2UUR5eS9vSTFDSnY3VjVk?=
 =?utf-8?B?OFk3WnFSNlhLQUhPdDB5dmZobjlkRWVpeXJxZ3drQlpnNjRlK1hzTTZVZGxU?=
 =?utf-8?B?WWh6N0FTdDB4RDlSM296cVBhdXVFQ3oweWhVWHRYdUphVlZkdEVpT25tRE5K?=
 =?utf-8?B?V3JRMTl5TlBXSVhFNTN0cFFJWldpVWRmUVo3Y0lUR2orMk9zSWRSNDdjS0tD?=
 =?utf-8?B?QXphcWlEblpyTllWTUQvUk1veURxUVU2c0EzMlFqNkFTRVVBRXFvSEwwN0V5?=
 =?utf-8?B?OEo0QXdBWGpWcGFjRGRyRTJHeGZ1NU9ZZXc2ZXBCWkIvZDBMaGJWckdVYTJq?=
 =?utf-8?B?T0NpQytzTWFUcWs5c1l0WjhrL0t0eWdvZ2V3OXE1czAvVTE1T3hNRmVINXlj?=
 =?utf-8?B?NTFVSDRLZWxhd0JMNVgweEtReVBha1NheGNURlVNcnRvdkFQVzJtb1c3ZFM2?=
 =?utf-8?B?OVJvSFRKcEpmNnNRRzNLc3ZtODRjdmovY0lEZ3hob1RYSCtXZ3FySkhaWXc3?=
 =?utf-8?B?VUwrQ3pmbU8xZGF6Yit2OUZFbVdFMVdqSUhnL01Wdzc5Y1hMblB0QmVBenc0?=
 =?utf-8?B?aFVhQU9vS2x4MStDellCRklmcXgwNCtkb1FEMzd4YzdnZ1FjWm50Qm1XZEZ6?=
 =?utf-8?B?VVVqLzJZTm5HRkUwMXhnUkFuYm94Z0wvbnUzUzJtN01FSUtlay9KMFVwMDhT?=
 =?utf-8?B?UnFNaS9acU01Tk1nazAxbkVFaWRuY1I3Y0lndzJOTXJUanJUNDNtdTRDbWN2?=
 =?utf-8?B?VmI3NVlvdEJybmdGRkg1TE9CZ2NNUWMvZWhycnF4MUJGNmpTWDQrczNBUTlt?=
 =?utf-8?B?OXZDNkFNVTVINi9TNEF6Y0lzeHpWejdYQThhbW1KY052cm4xS3FtQ1pDVzhG?=
 =?utf-8?B?bUloL3RlNnJwd1NvSmE3WmEvSzFtK3VQb29wV0czbkt3ZEVhOXFJMDlhQzQ5?=
 =?utf-8?B?UWtWaVZzUmlhUVhER3I2ZkFCTmc2YWpmbUFvU2tDMzU2TG0xY1dFbEsxZWFs?=
 =?utf-8?B?MXRIM0swYlZpOUFaZXB1S0NQcFh3UWlzdW9HdERON3pHUHZPN0dUQndza3hG?=
 =?utf-8?B?bXp1Y3djL0tkYXVHaEJqK3phRFpqUHZRUjJ1WmRmZ05UcnFqVDNEZmFuc3Ny?=
 =?utf-8?B?cExRaDYxZnhqUFlaQ2wza09La3JWOU9seVFkcXZjbXpvejlIdmJNTHJHc0Rj?=
 =?utf-8?B?UXduT3NieXhHZlNGNkJjU3RhK3E0cDZmOStMQTZJREgxakZjcjZUT1RpV3lX?=
 =?utf-8?B?bGNSbGVTNzZ6WmNNQXF4bzJha083TXZ4YTJ4VUs0RTNOY01Nb2h2QVQybUVK?=
 =?utf-8?B?SnhWeXYvdmFMdUx1TFR4a3NKbUlTRTFySjRlZEhPczk0MjJIM1hsYWcxMVho?=
 =?utf-8?B?Nmt2cnloMXQrUlpUQVo2SjZscDR2bllIaGZoakUzVStQbEU2ZGVoS1JERDZP?=
 =?utf-8?B?UnlSVUNEeXBRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(7416014)(366016)(921020)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aFNya1lDWG9yazdCTzFEZEpicFN6d24wOUV0Mnk0TjBBZEdCa1VxNlhtdmJ5?=
 =?utf-8?B?aUhZbSt4bW8wS1dLcWRKY3ZDUmc5UDFobHEzQ2RqaUloSVVJakNHK0xFbEhW?=
 =?utf-8?B?akFiVnE1b2tCcVlxN3BnOTlvQnRqVzZpM1dmZmJTZzhialdkRTE5ZTJyK2RN?=
 =?utf-8?B?WXZoME9kWFY4NzdDRUMrNUtlam5RblBqN2UwOHJ0Y3IvRlA4UUJtcTVFa2xm?=
 =?utf-8?B?amtSSlZ0ak1XbW4za2Q5Q0hRL0VucXg5OGpwUUxZU2p5Wm5JVUZDZ0pUT2x1?=
 =?utf-8?B?SlhvYlBPbHpGZVJjRll0cDRaK1FBOTIxSlBlSHpmaXlZL2JOTlpBU1YzdCtk?=
 =?utf-8?B?dEYyUEJNQ0NPRFFuYmhqaGZkZFFOc2lKYlp4eFVmWFVKWHpZQ3ZyazcxYWRH?=
 =?utf-8?B?enJqSXNJUVIvanJtV01GOXJxcHQ5VUliSXRsT01kMVVQL2V6TmdTZHBRVVFW?=
 =?utf-8?B?UDl3YTVrc0U3SEtHcDdobDhsVERYMSt1cnhKTkJQaXV3em1laUxWOEI5VGR6?=
 =?utf-8?B?eW5YTVhRNFdHeWpqMGNNRWZhZHFhMitpM00wQllFNy93TW1tL2d0dVBMYjZG?=
 =?utf-8?B?dkIyOWkwYVRpRFlqdWJrUUNLWHpDQnNhNnF1RHQzcm42bVpuTjFmS1drRnZO?=
 =?utf-8?B?TE5FOTUzYUdrM3N1SENXY0krVFBoOU9BMFpxSkpxKytHeGsyVXo2TjhxVDZG?=
 =?utf-8?B?MWxqM1dyOUFJeEM4MStuMjVaWStnTkpaYWVZQ2tTeTJLRDk0ZFZXclBZU0JT?=
 =?utf-8?B?TmgwT1lLUE1rTnpkNnVFRWpVUFg5Y01oUGFhN3VvNlBZQitmekJSU3Fob1Vj?=
 =?utf-8?B?TjRYV01Kd2NRcis3Zm85OHBQVGRYOU95YWk5Zm9sazUyOHRxUkFGdmZUeUlE?=
 =?utf-8?B?M0IxUW9leGdZc2ZJdjEwc3hhVmFDa2NEUi81SFlvMzFtRDlFRzJRbkxpdkdw?=
 =?utf-8?B?TzVDM3ZkT2pRRDB5RjJvbzJjbnFsZEYvODZxa3lOSmlCdjVDUXR2eGkwOUsx?=
 =?utf-8?B?SExXUm4wMDZITHE3cEFoa2h2M2ZBYlVjbjh5aksvMWRkTXVSWDlNVUFkL3ZV?=
 =?utf-8?B?VTBGSHNscDY3TUgwTC93STBoK1poTDBWaVdVM09RUEwvdmYzSVkwdDRvVU5t?=
 =?utf-8?B?ZkNSRlltVUNOTDBBOFJlRDNCK2JDelU2ZERyVzJFK1dPOWV5bVIwazlZWEI2?=
 =?utf-8?B?VDhZV3k0cWxtM0RNZG9OL2NXbUUzb1E1dkFHOWx5aU14TktWUVl4ay9nTUdD?=
 =?utf-8?B?bVhtcDQ4Wkg4ME9rV3VvcEdKc0h2SUt3QVRnZlhSemFpQjNJNDg3dU1pdThl?=
 =?utf-8?B?S1lSRnA5MFQ2Z0VUb3dGWUYzYVBYdm40cFo0L3R2S3l1bnRWT0Q4c0pqQzFa?=
 =?utf-8?B?aHpoczhDQ0MrTmlNUkNvV09Sa2s5a2hkSVBDaGpvUUFGUG5wQnIxK3RMS1Nu?=
 =?utf-8?B?MFJaRGNmNUg1bXNwR3dKSzNnaDVxNk1IMStCRGUvb3J1VUwzSjM1dWh0amFT?=
 =?utf-8?B?WTJuUTZFbCtoU2FMSk1OeTR2dy9NSGUyU2JXNWN2a3ZxM1NFRWdYWTduZmZl?=
 =?utf-8?B?OEl1aExtd0l5TDI2ejJlTzAxUVNXNFR6MWhaTTFORzh1aS9EYU5XZUNNYnJy?=
 =?utf-8?B?d0pRNDJET2M2TEE5ZTl4WmpTLzdpYUxsa3VDbk02WkVtb2JyUXBTY2ZRZk9x?=
 =?utf-8?B?RzdXREJjZUgwOVllc3JhQ1EwM1c5SXlIc1RsWlk0NjNGZGRZUFhIMWNZRkVk?=
 =?utf-8?B?Y2k4eUhnS2wyVUZNRS9mUm4zekVIZ1lNUGpHSjNzVENhTWFaMjRSYmtzYWtU?=
 =?utf-8?B?bXBBYXNRL0tEa3VIS3N6bGlSaEk2R2N4ZjZrTy9jTHZQTGZlZ2JWbXU1b3py?=
 =?utf-8?B?dGx5MWxKbXdmdDdyZHluWlJZRnFLN0IrK1lKbytGMEhGUXoyQmpRSmptUnhE?=
 =?utf-8?B?L3EwREpIc2JwMXdQTWZnL0FPKzVmTzNHUklTZXhUd0x3QkhVWmVFUVorSkdG?=
 =?utf-8?B?Zzl4MHJWQ3JNck9KMDNuQS91STF0OUZnRHNnOE5CbXA1cFl0TzF2SzQ1SUIy?=
 =?utf-8?B?MXVrWUtnMFo1Y0hvNHFOWHlscCsxVFJ1WlU0UnN5bWtpc3ZNMmpMdDNVNVRo?=
 =?utf-8?B?WVc1amticGgwS01RcDVsMVRZbnRRMWFXQnhiRDZadmcwdU9jYk9oVlRiWU5O?=
 =?utf-8?B?dWc9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 336f724c-0016-400e-8f3b-08dd626b0ddc
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 20:10:09.1902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B+HGIkyCnRTC+vV5E79DIJtXQNy+e/P1ltktanK3+/9VHmtSu29Ikx3JiNi5gL10n0DR+T5Fv1qtDsZvsu4djbO6hMy6m+buayW1OWRRu8k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB9384
X-Authority-Analysis: v=2.4 cv=NL3V+16g c=1 sm=1 tr=0 ts=67d33ba3 cx=c_pps a=f1nyBA1UpxJqkn7M4uMBEg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Vs1iUdzkB0EA:10 a=H5OGdu5hBBwA:10 a=0kUYKlekyDsA:10 a=edGIuiaXAAAA:8 a=64Cc0HZtAAAA:8 a=PjzdzBBxZVh0jiqMALQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=4kyDAASA-Eebq_PzFVE6:22
X-Proofpoint-GUID: nIHDYxJnQqJ9Y38Hz76N2rWcrH4-Ea3w
X-Proofpoint-ORIG-GUID: nIHDYxJnQqJ9Y38Hz76N2rWcrH4-Ea3w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_09,2025-03-13_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

From: Mickaël Salaün <mic@digikod.net>

Add 'cpu_has_vmx_mbec' helper to determine whether the cpu based VMCS
from hardware has Intel Mode Based Execution Control exposed, which is
secondary execution control bit 22.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Co-developed-by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 arch/x86/kvm/vmx/capabilities.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index cb6588238f46..f83592272920 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -253,6 +253,12 @@ static inline bool cpu_has_vmx_xsaves(void)
 		SECONDARY_EXEC_ENABLE_XSAVES;
 }
 
+static inline bool cpu_has_vmx_mbec(void)
+{
+	return vmcs_config.cpu_based_2nd_exec_ctrl &
+		SECONDARY_EXEC_MODE_BASED_EPT_EXEC;
+}
+
 static inline bool cpu_has_vmx_waitpkg(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
-- 
2.43.0


