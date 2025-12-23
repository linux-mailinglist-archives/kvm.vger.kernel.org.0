Return-Path: <kvm+bounces-66579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 94F6ACD80CF
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:25:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D7F523041CF0
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 04:24:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9D852E1C63;
	Tue, 23 Dec 2025 04:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="rMPM+Yp3";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="WzXwVIUR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555BF2E11B0;
	Tue, 23 Dec 2025 04:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766463869; cv=fail; b=F+sLpD+awiLF010Gy1m3PBC53KeA4RcklGfCnrTWygqbxu8oyJHA9d1xYrBhapY8NefGjL3oNeHPNl0S3+OBdaUx3KZMuojYUuX4o8kqU+Jdpcy8P1pcSXGzff26WZnrUM7rUi5e0bquQwRsVmGZf3t5q0GAlfI/xpNK4/xtbVg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766463869; c=relaxed/simple;
	bh=aq9WtsIN1Ci/A83z2sgNvCaXIbiSSM2R6JbHaV0ZVCQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Kuuiv7jDzQJluQJsVl8+KGkEAUR3yhLFYh2o1vhd8hrOPXp4Yl0obdSrDOIHE+3+2F+Bvx8Ys/qaw5xAEhfjRvi3ICezCbZbSz383NVFkM0U2OCsZNDJ8dvGkEo3PVFA5TlZ/IKpWkLIclfS7LssGgD/unIY2qNv4l+LjIAC55g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=rMPM+Yp3; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=WzXwVIUR; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMKYCra3420250;
	Mon, 22 Dec 2025 20:15:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=aq9WtsIN1Ci/A83z2sgNvCaXIbiSSM2R6JbHaV0ZV
	CQ=; b=rMPM+Yp3KEt4hHfrq95k0O/7/5dWVYEUyYY4Jrn/gb+ySRiKF0rTUVr35
	+m33S1sucXR9Qp3rzZXi6f/4RTiRLzX4EcAjawiUbEWuD9/TAWq1PeSlWrsrG0FO
	Wl1yExYQRrg9+LfSITFLbdbe3PkTMNH904/HwIoyoyA30g0wMEI5FKYDESVhMIHm
	nj/SE5BHCGCT5W+ur11+4MalH2jTH8HNbW/R+Vavm67xHClXJ1YczVle5DGev7/M
	XcW5wpyifvc5Xr37vLmjsAHAb/y0DNTfohZyVVzUhr1iYPWtMT+IOM9KIGHpfXTn
	m6B7NRLD0bvRI0N7dmYLVwnPC4NBA==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11022089.outbound.protection.outlook.com [52.101.48.89])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4b5v7yvrf0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 20:15:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vukKcm4+aTFx18WnV+zemNvyMY78dfBBKCI6jyXDH3hV2FfkCZ04za8n3KZij7QZxrNry1/XC/p0GKyqvxiFFbnedezfF3nl72DBunIdsUvfE83zPr9gOfzpAFKGXQYKfS8rk9o02wpplLUqkbIOLPDkKD/lTMfGyTr3/ZDI9ubtO3BY0xGQW3NDRhrvUkXF6zKiC8F7WmSB9GcAO3Ot/8hWcQBPuFr3Svqm2cj8LpoXuTliGXzOMLVejg+5O80Bz8v1+3lC65qQ9WCA8Zq2tu6ullVQ3kCAjTc5VkdxcZT7PZMNxeq7Dw/5qxjW3w11eWC74ZAz5Fydo99qPNabRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aq9WtsIN1Ci/A83z2sgNvCaXIbiSSM2R6JbHaV0ZVCQ=;
 b=NAiXMNUTCU23MGMwULZ/OS8mgAXq1GJ8Rgy0ZNrV8agOjY3GobKJ+5WS4SGHo/mihMD9FYaq/7f4MCF5z40EFFJMqLA/z1m7zm39YWRSamNLTMpYrHsF9p4bosLeMMbNsJhn8tZNtPvIvR6Sas9txXGGlF71FVKTckHhIJQ880q6KgaBKmygN8ZdK1VNjRGNNhPTIoT5P1Ls1d5B/dTMJl23b3FKKyGQiMeloUoTyMPm7r2igvG4B2B15dr4K0IzhObVr++7zh31E45TNtLpuPJ+f/47O6sXWxAdxM7VSICe95qFKrNbnjWUXo4V32ySs/RduAX11zVxEea/x3ut2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aq9WtsIN1Ci/A83z2sgNvCaXIbiSSM2R6JbHaV0ZVCQ=;
 b=WzXwVIURQpEj5APOiciLx5qCpsnM2mKe0Sr17GPGVKuV1E8EuFsCSYeJbgQYST0VzfzgUyazqPFJCOYAL2/qGbml4L6cVvokkqq1SO/btEiGj0Plp2zShllmrgK0v2eaXbgFyh+nb9Ht9kspKgEXuhxOzM/iay3Ffc50gZWd/AO54PAiN0qWctmNVqCjdoAOuObsSaofp+n9APRLC9RLqLwEzSiLJ81HWoyd29FVjo96+nSBh56xmxCvwxbxc+IIn7lKsDI9DsZgfZNEzwaR5ZFGEfikGzlcT6r9b4mpcER/Jv62YhaJ6JoE2H8Klrdsmqms1jUs7HnxERLbHVU+9A==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SA1PR02MB8512.namprd02.prod.outlook.com
 (2603:10b6:806:1fb::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 04:15:33 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 04:15:32 +0000
From: Jon Kohler <jon@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de"
	<tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
	<bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 03/18] KVM: x86: Add module parameter for Intel MBEC
Thread-Topic: [RFC PATCH 03/18] KVM: x86: Add module parameter for Intel MBEC
Thread-Index: AQHblFPo9Ax1PZfsL0GVCsZrrlSLcrPPqPiAgACI54CBYCr8AA==
Date: Tue, 23 Dec 2025 04:15:32 +0000
Message-ID: <302DF79E-0B9B-450E-BB4F-DA88FDCD635F@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250313203702.575156-4-jon@nutanix.com> <aCI5B7Mz8mgP-V2o@google.com>
 <9B4F1C6D-05C1-4CFF-ABCA-3314E695894E@nutanix.com>
In-Reply-To: <9B4F1C6D-05C1-4CFF-ABCA-3314E695894E@nutanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3864.300.41.1.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|SA1PR02MB8512:EE_
x-ms-office365-filtering-correlation-id: a0643fc9-5806-4657-22af-08de41d9ea36
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?SXNzOWxqYkFSZVJOY3IrcGsyWHFEcE1nQ0pLNHRaRmpsdWZ0S0JldWtYNDhB?=
 =?utf-8?B?R2g5R29ZcmpYQVpBa3FyN3JlSmdiZXp4YkVIaG8xc291b3VadllBcjJKbzl5?=
 =?utf-8?B?ZnI3dVhLbTNzMldTamcxaTRPNHEwOERqMG9WUTN0N1k4VjVBQURaN01PemFo?=
 =?utf-8?B?cDlwODF4SEgxc0QwaHpnUGZ3SHVhUkYwN21IN0FkTlF6QXU4ZzJGNjhYdXFz?=
 =?utf-8?B?aUZkejIra1NLSDQvWnNGYlFDbEZMVUpNSGpHR294ZXhwVjJUUEl0d2V3RVkr?=
 =?utf-8?B?VzJ0OVhrQTlEZlIvdWF0V1VSZEFRY3BLUXM4MzRVU3JkTDA1YUxwaHBVQTZ3?=
 =?utf-8?B?Z2RIU1QxRGN4R2tYYVVqTU9IU2VzR2RzS2FXRmlJbldHSFBxREtXTGI4dExC?=
 =?utf-8?B?bW8xdThDMVMxU2JxR0dZazExRW5iMG9WNGFsL3dqR0dSOEtjRlBLaElRWDJs?=
 =?utf-8?B?TXVodGtsVUsrU2tBMkxqaVhBMHM3eWpWemdydmVBMGtFSmtIM0xBd1c5Zmp6?=
 =?utf-8?B?OUl1NGZoK3AzR3NNRkhmOFpERWlQUUZMcHRmS0xiRkhyQllrOEVWYVZDQldS?=
 =?utf-8?B?K3BLK3BNQldsd05XV0JxRkxIb2VXQy9uYmR0ck8xNlpWVlBMeGZqVWpocjQz?=
 =?utf-8?B?Z21FbzFBMlVMSEZGcjVKRlVrVGhJMUFYN2NyRFVMZlVoTGJQZmtmSm9RQmts?=
 =?utf-8?B?TE12ck9xS0tWQksveGJBa2Q0aEdHTFNUTnlsQndPTEVqeVZDRTFlY3BkWFJC?=
 =?utf-8?B?V2xTTG5abHBUam1NNmNpdU5ZM291TXlnTndkQ293TW9xcU5xMnhpNlQxZzV4?=
 =?utf-8?B?Y1ZPeXRydk1OY0pJMFFkUXpLV1EzMVR3N1dlZldNZW96ZS9DWEUzVk1FR1FD?=
 =?utf-8?B?L2xJejk3UmIyc2tjdy94U25kRGRsZnRhK3JpNzhvTEVKUmZWYndkenZVS09x?=
 =?utf-8?B?L2dZY2tOdnNtZlV0T0h4L2M3SVRxVUl3QkRMcyswUUIwblpCMkUvTHZZNzdM?=
 =?utf-8?B?bFF4S3crbVV6SUFGdHk2SG9tNnBLYnEwNmtKRXFHTlE5bHd4ZzZqV0pKVXZW?=
 =?utf-8?B?eEVaOW5Tc0wrS2MwSU1PZmphb2FVK3I3RllIS3NKVE9YakFOQVJmV3U1eDM0?=
 =?utf-8?B?TUN6MjhPWlRBSEZXTlQyRFpZUERMeC9zQWhBYU4ycEhLSDhrbVdUSlNFT2Fs?=
 =?utf-8?B?OVhESUxwOWZLYjN6ZXdmcUhIY1BjZ3lLTTA0UWsxWFhsRkk4NS9raEpUTWYr?=
 =?utf-8?B?ZmplSllLVmJUbzdZVHgrV1V1b29mR3RNVG1LNGQvUWxQQXBQL1ZoeXNZNm9n?=
 =?utf-8?B?MXlETmFqYitDUlk4WnBGZ0ovOCtXS3lPS1N4Kzg1ajJBRWRMU3lYUlNha1pZ?=
 =?utf-8?B?NHUwQnc3eHdFSDlGWkFmRDJyZ09yV05Id0tHWnZ5MGNZN0p4dnNsU2N4aDJX?=
 =?utf-8?B?cmlpU0tUVURBRUduT3pqczRrR1dGeHJxTnVpZnE4LytwdVAwSllML1ZCYUlU?=
 =?utf-8?B?R2VUSE5QVWFnTzBlZ1NVVnNGc3IvamVoZHB1SDF4RE5aNnJEY3duUG9jMFEz?=
 =?utf-8?B?TDBXTGxNUk11eHcvaHRsUUwrTzByclhTSXR3dUlma1VPMVBCa293dUcrKzdU?=
 =?utf-8?B?bFMyQlAvdVRwdmQyd3NpQ3kzK0pweTdLdElqa0Q2anVicDh1RFhsWnJlTjY4?=
 =?utf-8?B?SlBjdHlGU3ZzendoZjJPMC9tTWk4c2tQQ1dxN0FrL08ranJCRjM1LzNGRGIz?=
 =?utf-8?B?MGhvUmtoU3JMZ0IxYWUvRS9EOW4yaXRsRkdISG1VRmZJbTk2eCszUmFZMFQ0?=
 =?utf-8?B?U1l4SHcweGJWMi9qMlhTZW5Wb21Xdi90UnBxRFQzYWlvQ0hLYkkrTDlMRllS?=
 =?utf-8?B?Mm92ZnRuVkpBZFhxWDN4Zks4cmhrS1ljcFFReDZzdzhjb2I5ZndoRXBmbkhS?=
 =?utf-8?B?ZG11RGFGSmtzU29lZ0NNMGpUZmpTZUZMMmFzMzl1alJvdXJLSUdBNWs3NUN6?=
 =?utf-8?B?S1lSSUhhTHYzaDBaQlA5NmMrWkpKZm00b3dzUFo4alZKeitpSmlIS2pKdFl5?=
 =?utf-8?Q?wJvE2v?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(10070799003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SUVqK2h2U05YbEVEbCtDbWlmcG0rcEo1OXo3OFJJVkNWTFY5dnNVOHhDZlpD?=
 =?utf-8?B?M25EdmVDcHpFY2MwM1p6Zm9PSTEvd1FHNmttMFk2QkYzbm1YVlZOY2RIMDd5?=
 =?utf-8?B?UUsrWDhvYkcybDlvMWtSMFdrOXpGMTdNdjhrRWxsUUhTQ3dydHJQWjFmSzh6?=
 =?utf-8?B?M2VaUFVTNDVuRGNkV2ZDUkppU3gzMVl3QWpBeTdCMHhUQUdaeVNNYmdhWmlr?=
 =?utf-8?B?U01TRVdndlJZTWpZVFlBNUlVbzFwaDZvK3pBZzNGRVFJdXR6aGwyNCtkVzRF?=
 =?utf-8?B?QXgvYk9zRVp1SFFzdUkxVHdaWTBsZXJwK0hEd2tuVUZKd0MrMnVjLy9QM3dp?=
 =?utf-8?B?Szh4Y1JobUxlOWJtQStKZEJZNEdRK1F6NWVWY0F6dWsveFg2dnpRYTVIYlY0?=
 =?utf-8?B?OThvQThtQ2lrZ0hhRDB2cGZmbXdZOHVEQXRwN2srdXUyWVg4QkRZeDcvMk5a?=
 =?utf-8?B?dzExblB5Qk41LzA1VzdodWQ1OUMrNXM3TkxuRzBkN0VmSEpDbURlSWNaZURV?=
 =?utf-8?B?Nmx0ODdxbUp1VjNWNHc4aDVBVklhMVFDVE5hVjNRYTdycGhrUXNkLzAyZW1n?=
 =?utf-8?B?VEE2UFQydHlJdnNUaTdpa3JWQlBFcXBGelVjSERpTnNaYmpLR280ck5kNHNJ?=
 =?utf-8?B?aW9EQmxaTmtuUWJtSWdHb2k1TTdOekE2NFZSdlNQZkpsZXVuUzhkOURkbmlU?=
 =?utf-8?B?K3RMUVh0WThlNVlmTVU2b1ozWTM1d0Y3dHNCck9YNmEzK3ZsWHdpSklkaTFn?=
 =?utf-8?B?amQwYkdWTE5sV0Y5UG50azRHK1hnTTRtbG1iNDNCQXcvS2lQVkllODBCR0x5?=
 =?utf-8?B?dkRRbnlGcWRDTEdac0liOFlwb1VVRXJuRVh6clpvLy93QjdRekJxcDV6RCs3?=
 =?utf-8?B?WEl1bXJLbFhLU1ZjeE5hOHprM256TlZ0Q0dMUi9ZQTVXcENDM2lZRlJGZnNT?=
 =?utf-8?B?SjdpWGpoQzYyYUpIN2Y0S3FtemZjUTVxLzdhYmc0bldNQ2w5dmF4YzhxQXJw?=
 =?utf-8?B?Z0FlNDZPYytpamViWXlMVkJ6VXdEZlJQdXlFVkpqMitDUFFTNmxua0F0bTlt?=
 =?utf-8?B?aTRPdTRDbXhqWmhtSXByQTZpSFhIMlUyaGJaVlNVSmJDeEZuZmZpb3VOb2xE?=
 =?utf-8?B?VWZMYUxidGtYVFA4QXBmakxJcjhZeU9BcnlZVmxPNC9sOW91cU4yNllYdVVr?=
 =?utf-8?B?MkdsQ2NndE00b0RLRHNRa0F3Sm54MFN6elNoODFLSXJLdy9zQ050NEdxV2sv?=
 =?utf-8?B?a1hhMzlYaVhsQ2lCVnEvam1kTFp0WUdOcnM4M0hObFhwVlE5SkFIVEpIZjBT?=
 =?utf-8?B?WFg3Wk9VRUhJZ05oNEIyMmNxdHI5NUVLbWRDQzdUdEVlb1JwMmszTjl5OWQv?=
 =?utf-8?B?TU9IaCtydys3NnpHQzVaUW9mNzE3bGtRVGVMR2FxNTNocjkzL0lhUU4rQnJ6?=
 =?utf-8?B?R1plMVU5VE5WYnU1elRrWkQwMGZjV0lqU2lmL0grbEFZdjFvczJuWTNORHZn?=
 =?utf-8?B?V3JHNTZaa21xWDFTSFU4OE5HLzQrdzFvSGY0K2JBTVkxRklvMmxLcFhUTVYx?=
 =?utf-8?B?WGp1cmJWZzJ2b3JCbDdUd2F2QmZKNENkN1dDNjEzbXNNVlVUcjFlVUs5REpE?=
 =?utf-8?B?cGJpNnlZeDFzMGZZeGtlbDdPV0tCU0FhYnRodkk0STlvNXBFcnRtT2xqcFhU?=
 =?utf-8?B?cUE2akR4MTh4aGxndGcyQVlvNGw0MGFuejlTWHZwTWtlc3dBQzgzZFJrVjUv?=
 =?utf-8?B?UnJCRlowUGx3WXQvaVZSZlhncmM2VnVXQjhiSEtES1N1RHZFbWhXUHBFek1L?=
 =?utf-8?B?TlZydHVwRjZURW9wTitiREpQcE1PeE0wekllcGM1K1F6RHhLNjNpZ3Nlb2FD?=
 =?utf-8?B?RWdiS0FzczNkME5JaE5yYXZuVjVFNnZuclNBZy9acXRQS25oME10UzNSaElH?=
 =?utf-8?B?c0NCR1h0SEROeDJZYTFKZ2tIamJkdUM5bXNNVFFVZTBVQ0FLdzkyNnpydkpp?=
 =?utf-8?B?N0s2UHRQTzZvWmljbWs2VEcrZDRubjlOb1U1MFh3ck1ZTkdYS2NVOFk2N0Mv?=
 =?utf-8?B?aHlua25BNlowU1JhVHJuWnJnaHBHMFpZQ05YVGVWa1dYMVAxTE44cmxaTVE1?=
 =?utf-8?B?Ti9tcG1WM3BCbzUxUTdQV3gyWmhzeTZiSEQ2cDlwUU9ocDd0U0VhRXk0TjBt?=
 =?utf-8?B?TlpKTGMwbnNZcytGdnhaS2VtcW00ZTF0d3ltUzZNVVpIc3I2MzVJZWJ1dldh?=
 =?utf-8?B?dWZSUS9NeW1rUWZMRVEzbjhDQUN5aG5td3dOTHFNcEZmOWRKQUFJU1ZEdGN2?=
 =?utf-8?B?a1gxNjZsMjZnallTY2NGWkZYOWQrVTNNbVNibXFsT3BpZlhSczhWSjg3dVBB?=
 =?utf-8?Q?8fds2HRnGgbe6Biv/TP11ShJZTD7/kGDf239tIcYx6OCT?=
x-ms-exchange-antispam-messagedata-1: tEjemCQsnQlx6yiUp47xm7rCWxJZd1XecS0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9A970697671D23459D65E5668BF6B02C@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0643fc9-5806-4657-22af-08de41d9ea36
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2025 04:15:32.5723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yx2QgLaDDhj0KNkGKGeS4osYikdaeXgT0q/z1ZxvUngINQAOXeqGM1/8cLND65wsvHWYY0SDwB7YXLM78CM0IqAugee+B8y6XJZWtZIhWwI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8512
X-Proofpoint-ORIG-GUID: p4eu50t7JB_r7G07ayEi5Qe3ZIBJaZv5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDAzMyBTYWx0ZWRfXzoOcvEOeoQQJ
 7s2/HskGKP/FSikCtdvTFR0A43daq+rf+ARLeHOocScINdSgOPC3ZOXWDqV6LR+ynQklYm270B+
 BhGdwtGckOwTLmhON6qK3imxKfHO3cVbqbVkauRz7Vcvo6ph/LsyqGq6cb0gy1PPcWyDRkLdatD
 x32VcynOSGLPJg5VHNRNezCqHEd7rkypsu7ZQebTcss+b2sJ+1q22Zs6ZTCMzMm/JtaLOPyzVQg
 CJKpZ3HJrweCWXZaMEhTirUH0UyO9ZOztYnXXeD0DxEh0ZaO4phEuM8wgRgtEr+E2vA3nS5w1/P
 m8MjnkQhAVtTQPxPAVZ2CyfuooN+SOnzvyoOOjJNmonCn0In5h90+e/rrhkCQ5vff12VzdY05Lz
 0NlDxzpO7B9CMWqwy/htLHRRnCZvKM3tfYlyjlIrBKRxj7C3tP6675tnWrkSTIHzQrdo4mXP+6s
 kX1C6bzeqqEI7If1oag==
X-Authority-Analysis: v=2.4 cv=S8TUAYsP c=1 sm=1 tr=0 ts=694a1767 cx=c_pps
 a=88cenwDluC1K+zw7ozncdA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=64Cc0HZtAAAA:8 a=1XWaLZrsAAAA:8 a=NiTRgTjgQHUwpdtC6iYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: p4eu50t7JB_r7G07ayEi5Qe3ZIBJaZv5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDEyLCAyMDI1LCBhdCAxMDoxOOKAr1BNLCBKb24gS29obGVyIDxqb25AbnV0
YW5peC5jb20+IHdyb3RlOg0KPiANCj4+IE9uIE1heSAxMiwgMjAyNSwgYXQgMjowOOKAr1BNLCBT
ZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+PiANCj4+IE9u
IFRodSwgTWFyIDEzLCAyMDI1LCBKb24gS29obGVyIHdyb3RlOg0KPj4+IEFkZCAnZW5hYmxlX3B0
X2d1ZXN0X2V4ZWNfY29udHJvbCcgbW9kdWxlIHBhcmFtZXRlciB0byB4ODYgY29kZSwgd2l0aA0K
Pj4+IGRlZmF1bHQgdmFsdWUgZmFsc2UuDQo+PiANCj4+IC4uLg0KPj4gDQo+Pj4gK2Jvb2wgX19y
ZWFkX21vc3RseSBlbmFibGVfcHRfZ3Vlc3RfZXhlY19jb250cm9sOw0KPj4+ICtFWFBPUlRfU1lN
Qk9MX0dQTChlbmFibGVfcHRfZ3Vlc3RfZXhlY19jb250cm9sKTsNCj4+PiArbW9kdWxlX3BhcmFt
KGVuYWJsZV9wdF9ndWVzdF9leGVjX2NvbnRyb2wsIGJvb2wsIDA0NDQpOw0KPj4gDQo+PiBUaGUg
ZGVmYXVsdCB2YWx1ZSBvZiBhIHBhcmFtZXRlciBkb2Vzbid0IHByZXZlbnQgdXNlcnNwYWNlIGZy
b20gZW5hYmxlZCB0aGUgcGFyYW0uDQo+PiBJLmUuIHRoZSBpbnN0YW50IHRoaXMgcGF0Y2ggbGFu
ZHMsIHVzZXJzcGFjZSBjYW4gZW5hYmxlIGVuYWJsZV9wdF9ndWVzdF9leGVjX2NvbnRyb2wsDQo+
PiB3aGljaCBtZWFucyBNQkVDIG5lZWRzIHRvIGJlIDEwMCUgZnVuY3Rpb25hbCBiZWZvcmUgdGhp
cyBjYW4gYmUgZXhwb3NlZCB0byB1c2Vyc3BhY2UuDQo+PiANCj4+IFRoZSByaWdodCB3YXkgdG8g
ZG8gdGhpcyBpcyB0byBzaW1wbHkgb21pdCB0aGUgbW9kdWxlIHBhcmFtIHVudGlsIEtWTSBpcyBy
ZWFkeSB0bw0KPj4gbGV0IHVzZXJzcGFjZSBlbmFibGUgdGhlIGZlYXR1cmUuDQo+PiANCj4+IEFs
bCB0aGF0IHNhaWQsIEkgZG9uJ3Qgc2VlIGFueSByZWFzb24gdG8gYWRkIGEgbW9kdWxlIHBhcmFt
IGZvciB0aGlzLiAgKktWTSogaXNuJ3QNCj4+IHVzaW5nIE1CRUMsIHRoZSBndWVzdCBpcyB1c2lu
ZyBNQkVDLiAgQW5kIHVubGVzcyBob3N0IHVzZXJzcGFjZSBpcyBiZWluZyBleHRyZW1lbHkNCj4+
IGNhcmVsZXNzIHdpdGggVk1YIE1TUnMsIGV4cG9zaW5nIE1CRUMgdG8gdGhlIGd1ZXN0IHdpbGwg
cmVxdWlyZSBhZGRpdGlvbmFsIFZNTQ0KPj4gZW5hYmxpbmcgYW5kL29yIHVzZXIgb3B0LWluLg0K
Pj4gDQo+PiBLVk0gcHJvdmlkZXMgbW9kdWxlIHBhcmFtcyB0byBjb250cm9sIGZlYXR1cmVzIHRo
YXQgS1ZNIGlzIHVzaW5nLCBnZW5lcmFsbHkgd2hlbg0KPj4gdGhlcmUgaXMgbm8gc2FuZSBhbHRl
cm5hdGl2ZSB0byB0ZWxsIEtWTSBub3QgdG8gdXNlIGEgcGFydGljdWxhciBmZWF0dXJlLCBpLmUu
DQo+PiB3aGVuIHRoZXJlIGlzIHdheSBmb3IgdGhlIHVzZXIgdG8gZGlzYWJsZSBhIGZlYXR1cmUg
Zm9yIHRlc3RpbmcvZGVidWcgcHVycG9zZXMuDQo+PiANCj4+IEZ1cnRoZXJtb3JlLCBob3cgdGhp
cyBzZXJpZXMga2V5cyBvZmYgdGhlIG1vZHVsZSBwYXJhbSB0aHJvdWdob3V0IEtWTSBpcyBjb21w
bGV0ZWx5DQo+PiB3cm9uZy4gIFRoZSAqb25seSogaW5wdXQgdGhhdCB1bHRpbWF0ZWx5IG1hdHRl
cnMgaXMgdGhlIGNvbnRyb2wgYml0IGluIHZtY3MxMi4NCj4+IFdoZXRoZXIgb3Igbm90IEtWTSBh
bGxvd3MgdGhhdCBiaXQgdG8gYmUgc2V0IGNvdWxkIGJlIGNvbnRyb2xsZWQgYnkgYSBtb2R1bGUg
cGFyYW0sDQo+PiBidXQgS1ZNIHNob3VsZG4ndCBiZSBsb29raW5nIGF0IHRoZSBtb2R1bGUgcGFy
YW0gb3V0c2lkZSBvZiB0aGF0IHBhcnRpY3VsYXIgY2hlY2suDQo+PiANCj4+IFRMO0RSOiBhZHZl
cnRpc2luZyBhbmQgZW5hYmxpbmcgTUJFQyBzaG91bGQgY29tZSBhbG9uZyB3aGVuIEtWTSBhbGxv
d3MgdGhlIGJpdCB0bw0KPj4gICAgICBiZSBzZXQgaW4gdm1jczEyLg0KPiANCj4gR290Y2hhLCBh
bmQgSSB0aGluayB0aGlzIGZhY3QgYWxvbmUgd2lsbCBkcml2ZSBhIG5pY2UgYml0IG9mIGNsZWFu
dXAgdGhydQ0KPiB0aGUgZW50aXJlIHNlcmllcy4gV2lsbCBtb3AgaXQgdXANCg0KQWNrL2RvbmUg
LSBhbGwgb2YgdGhpcyBpcyBjbGVhbmVkIHVwIGluIGZhdm9yIG9mIHRoZSBuZXN0ZWQuYyBiYXNl
ZCBlbmFibGVtZW50DQoNCg==

