Return-Path: <kvm+bounces-71144-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GHRoFRzsk2ls9wEAu9opvQ
	(envelope-from <kvm+bounces-71144-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 05:18:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 065EB148B29
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 05:18:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 99BF43007886
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 04:18:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C5142773E4;
	Tue, 17 Feb 2026 04:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AP+gJ4ar"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012041.outbound.protection.outlook.com [40.107.200.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1D117ADE0;
	Tue, 17 Feb 2026 04:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771301909; cv=fail; b=TwkCd4tFPfHQpImmbicRfyVSLlC6hC8SBwFLsm3lX6j1qhMYvmnKj2ZUUkZfsl7zL5CCTysAEE6Sm7jlXVDlD7HZpCZlD+8bjOIUsQH/SPvxZCs4OETUdN7pIvGJWBLnqXGXCActw5YMq3n/S9PhXi1y/qmvdatiV4DWLkDUkug=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771301909; c=relaxed/simple;
	bh=om04pcpiHECoI22BfRh/dA9l6NDc532Iyd2sUDAjFYI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YmlVyALNU37gsT7wePxqQITnXykEkv3mbUvoVSlS8H2SH10sqqyKu4HC7XrIatmswRFPAV89Ei/WK2Mjnyg3i7AWoS4VC2G+zF9nL7EO6oAK9MOlmi0Y4RvYiblkdvXtqdgghHWXomzGVoGLlaDJMULpZGujFIWFaqwvzpALzLg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AP+gJ4ar; arc=fail smtp.client-ip=40.107.200.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wqxGYlp9yqIgRsV01LD4X3dRsIRrn+OUpTRd+a7RPexMoKBOpTaC0iDPEDgTA1/ztMqEBfchqAs6iDWvcnFG+e8o/j1qRLFNioR53dyGeWkpnLu7V0PKCnSURhoJmUMyia+9jHeN0Z/3d328GFwhA8Am5ioWugzIsOac0DNmgz99biphkl8p4F3H95fBBhkIsYnK6WX5xzINJ/0A/+saUkPyn4b3ADq3pjJHcj60EEvSucHnm7S45tXL7WAjfsRO3Lt4UK5HbLZYHC1OwwOsNHMuva1L2xdbIllzk4xaqws1CyrGwX5ODB7ltPo2C3cLQhrfuzQuqLBMOhPVxh71tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+gtyAoSgILkrzgFcHLqtFTPnV10o9evZOZcjee4pm4w=;
 b=SlEdYa4NraoGDC1HGE4hk8TZf8MbOv1QJ7G6tck5EF0FCeQgrjI70nPr+wfcq4NYQ4zjs7AOfLsoRMxeK6mp77h8UYUmDI146jJ+y07xhAM6L3eJO2e91QYnbndsYUvZ6SCGSgUABg7MyX4PlOP98wVN6ad99kleSSTyqGbyzo6prkuOWyauSTlo2Fxs0GF1m6bALAbzr+12nymXAF7em0jUhMMBEBKDVEZoeXo7jtEJ7Qx7ueLcyL2B4l5tVjuKXcTtIedqD1IiC+3eOwGmJDleHuu8iFHItf7D9Nf3yzuIvOeFKr4xXpTDjMfzARvTxK5q8AGlMhAyJk8ba2/oXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+gtyAoSgILkrzgFcHLqtFTPnV10o9evZOZcjee4pm4w=;
 b=AP+gJ4arAZgYmBIm7jW09QR1uuGJZklsnTSehxIFQMvN8ZRODJXoI4RYynjKDcDU5f9J0r1nknCrVafaU1pglmIQ/iYytkHrsVIx10Y5WhSflNx2Ch/90pVf89JZSYUbCYPXxgZ9kweN48jqGMaTRF28XfQ7+0FK6poluPOS2bg=
Received: from PH7P221CA0030.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:32a::35)
 by DS0PR12MB6632.namprd12.prod.outlook.com (2603:10b6:8:d0::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.16; Tue, 17 Feb 2026 04:18:21 +0000
Received: from CY4PEPF0000EE39.namprd03.prod.outlook.com
 (2603:10b6:510:32a:cafe::24) by PH7P221CA0030.outlook.office365.com
 (2603:10b6:510:32a::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.16 via Frontend Transport; Tue,
 17 Feb 2026 04:18:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE39.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Tue, 17 Feb 2026 04:18:20 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 16 Feb
 2026 22:18:19 -0600
Received: from amd.com (10.180.168.240) by satlexmb07.amd.com (10.181.42.216)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Mon, 16 Feb 2026 22:18:13 -0600
Date: Tue, 17 Feb 2026 04:18:08 +0000
From: Ankit Soni <Ankit.Soni@amd.com>
To: Samiullah Khawaja <skhawaja@google.com>
CC: David Woodhouse <dwmw2@infradead.org>, Lu Baolu
	<baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon
	<will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy
	<robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>, Alex Williamson
	<alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Saeed Mahameed
	<saeedm@nvidia.com>, Adithya Jayachandran <ajayachandra@nvidia.com>, Parav
 Pandit <parav@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>, William Tu
	<witu@nvidia.com>, Pratyush Yadav <pratyush@kernel.org>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, David Matlack <dmatlack@google.com>, Andrew
 Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Pranjal
 Shrivastava <praan@google.com>, Vipin Sharma <vipinsh@google.com>, YiFei Zhu
	<zhuyifei@google.com>
Subject: Re: [PATCH 13/14] vfio/pci: Preserve the iommufd state of the vfio
 cdev
Message-ID: <idfs4bm5tib5nfe7i6rrm7hxsvhybbidfxtxl4jx3pamkisdon@zaljkqd66cwq>
References: <20260203220948.2176157-1-skhawaja@google.com>
 <20260203220948.2176157-14-skhawaja@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260203220948.2176157-14-skhawaja@google.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE39:EE_|DS0PR12MB6632:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f88a02f-404f-4ac1-edfc-08de6ddb9533
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|82310400026|1800799024|7142099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SFY2c21mY01Zb0haclJ3d1RaL0w1QjFFRG9VdFRRNitCWHZqeWtrM3p3QWlX?=
 =?utf-8?B?YmR0eWl0QlZLZG9hWWx2SnBWU2o1V0JFbnlNd0cyQXF0RkppMnRhM3Fka0o1?=
 =?utf-8?B?TlJrS0N5NmxaeWs3MS9aZVJsWkVIV3JHdUQ0STZDRHZ1Rm9GMjdkRTBBZmVH?=
 =?utf-8?B?bWNFTGk1OTE3ejBuUUJURUVTMVRWcXVtZVBRUWIyRGVCME5hY3V0KzZNWXBG?=
 =?utf-8?B?TGZOWDZYb3ZDZ0dPem0yaUNBeGxuNjc5b3FQTWxTZ3BhWThaeW9HTXA5ZllL?=
 =?utf-8?B?UG15cFVtVkU3MTV1SmZib2RrTk9nRmV6cmFhWTlEVFI4Q2w4WTBUcEpPdWZB?=
 =?utf-8?B?VXlubzA4RHMrUlpLMEtQRG85Ry85ckFzTEhCbUJQZlMxMlpWY05rY1ZEV2Jt?=
 =?utf-8?B?OFJLTlpGdGxSRnNnSU56V0NJUkM5RVA0eWNISFBuSm8rdThDMjNneEw2dmRQ?=
 =?utf-8?B?R1E2d1ZTRFg3NGpFNHMrSDRYTXNxQUM2VTdPQUpxMjdQbXpNanVoVUM1TzYy?=
 =?utf-8?B?S0hqck8vbUZPTDRXeWc4eWxGRVczR3lhKzBucll2SVZyd1l5M2JFNzc2OW1L?=
 =?utf-8?B?aktlM1R1djJLa2NPWTBwSjJNbzVHb3FJbWJWeVNLYnlKUFExUXNBby9aZFRp?=
 =?utf-8?B?aWkzaVVub0YzVi83VGxaZk44RW5pa296K0hLTFZRSHptKzhlL3JJdG9CTGVn?=
 =?utf-8?B?UGdqS0d0dTE0cVVzM1o3UDFOZGdTemRCVTFjYzdEdUJuNnBEQXpZU3l2d2Y2?=
 =?utf-8?B?NFBkeUg3SmFSd2ZLdWJWbkN0eUttZVV1d1Q1TTBkVnRoeVhrUnpJTEx6aHZp?=
 =?utf-8?B?Y1FQSGhSQzZ6NTJLc2dqRDdwS0RONFhTODZvSVJ3Yy9GWkQzZENEU1BjVS81?=
 =?utf-8?B?ZWRENWlRVUU5MEVRQi92cTdKQ2IveThXZU8xeVdYK3YvZ2dZb1hBbXhQd0Vu?=
 =?utf-8?B?WEhBbTNlQVdLZnB4OGo1RVhOajBpcU5jZjZNUzNVbGVvSGduZ0dnaEkxNW5T?=
 =?utf-8?B?Ym9oRmhYTFBVdmo0a1U1TVhNQ3RLT0N1eXIwaXM1bWhpSC9tUEtxRnFzTmMx?=
 =?utf-8?B?aXJPaStjUVo5cUdqdFE5aXUrakQ0dS9BUUZRV3NiTkNzUGozNnd6SE5tSUth?=
 =?utf-8?B?b20yRlNrVUk1RysyUE9DdEJNdklHU3lZbTRTRGw5NmRXYm5QbElpMXhYM3RI?=
 =?utf-8?B?QUhHVUE0MjlnT2c2T2JBZ2FmQU1aTEFaNmxYRWRBTzYzVzJMTkNodnR2cnBn?=
 =?utf-8?B?NVdXUHU0K29hSmpvMlpBOTdBREc3amYwd3B1TlVLb1Q1djNvd3VQZlM3d2ZC?=
 =?utf-8?B?dS9TMk8rNEVkOWZVeloxQVd0U0RxSHNFL1FYMjF5eC81dHpjcW5McER6QUpi?=
 =?utf-8?B?aTVuRWE1a3YrRjNtemtBNmhkSWRIQjllQWs2Zm5OT2FaQ0N5RWhXSVR0cUlx?=
 =?utf-8?B?U09nZDBZVmltRTN2eVUwSnIyRzd3NWg3OFZacExwZHg0MUE0R1E1UER0WU5w?=
 =?utf-8?B?NWhuVHR4cVpYWGc0TkJSelVENWhmbC9ZbUIvWU0vK3c4THV6U2RuVVhuUmZh?=
 =?utf-8?B?VDY3SmRmcmN4YTFtMDlJeWwwa1ArN1gyc1pzUTBlemxBb0JZNjE4emZEcUFv?=
 =?utf-8?B?Wkpyd1g3QXNEN0lBZmIvK0E3bDRuUi9nQUVJR29yOVRrRkwzalR2bm9maERn?=
 =?utf-8?B?SEN6azBWNDMvS2lVN1l5N2lIVzZNcDViVUlvNTFOeDZxbUNhUjZkeHNnRnAw?=
 =?utf-8?B?cTF5RG5HSFJZd285UE85SDRzcEIvVWIvUFhLc29YaGVaaUdqOFdGVnVpL3Bo?=
 =?utf-8?B?NjlQN2Nra2c3ZDRSL1MwM1N0dGY1TkxXWUF6TWdjdW15dGxJa2xmYjJPeGZ6?=
 =?utf-8?B?dE9ObThIZWVxSXFCY0JEQTFaa0NVaW1DaXljZm4vSTVZRG5wdmVPam0vanRl?=
 =?utf-8?B?MlUxWUlFMnNUQW5BejhsSFZxM0UyZy8vaXBGb1RHSFhOMEh2TTI2MWMzZjc4?=
 =?utf-8?B?L1EzMkFvc2FIN2pEbkNLczIzbTFoRUlGOGRqK3pmY3F3V2NLYXd2NEVVRVd4?=
 =?utf-8?B?Q3hzeEJkWHdVM3EzR0VjNHpxOGpOVmpjUUFBN2lEdXlNbHFhSEwyOTEvMGlS?=
 =?utf-8?B?M1crUlhXUHoyaHR6OEtFVVcwNWlqRzBUb3Y1ME1vRFd3SVJoOTBsY2k0V3VF?=
 =?utf-8?B?U0cvQzUyQTVpbE1TNkNxd01WenNyWWFaR0xmSnMrY1dCS010bkRBdC8vZXRs?=
 =?utf-8?B?d0p2WXVyV20rV05wVW1LWFlHRDR3PT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(82310400026)(1800799024)(7142099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2At8iGjJEexnxje3VL6N3gj3Gt48lrAYja3mnsc6RWhM9ZYCsnBRFSGgAxRDnp3CS31MW3IbrAovb8e+tgtFEW9tTrmI7TMUzEwuFFYSXaEqQ3euE7TZ7FaIppJFW36NCegAOcTJV81YIwL3rmRTyyu/GFYWYq9Z5uT9JUfYsJXlHigo6lk4Ordfepf71jIPJ3CL4/CLCdW9/vSd29vE5cnlOmrh134wEfBOs4HqCrxMnDcgH7eof++//iKPORkFXjUJCoME+KmgA50pWh9NlDw+FoNivoR6g/ZYn9Fdcha5GRvZO11wg6PWCtV4dfLdW9Egl2Jwo9FZg8QoFlO1C+l1p6WmdsGkVv2sK8JPTN8/X3yf0kTAQRNfVP+hihUDZDSjwFWbohPSBYAjMPLpYD14qHF6bgMBxCp4MyiyW5VLje5A9a2uGMajqolfOYF3
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2026 04:18:20.1162
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f88a02f-404f-4ac1-edfc-08de6ddb9533
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE39.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6632
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71144-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[26];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,amd.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Ankit.Soni@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 065EB148B29
X-Rspamd-Action: no action

On Tue, Feb 03, 2026 at 10:09:47PM +0000, Samiullah Khawaja wrote:
> If the vfio cdev is attached to an iommufd, preserve the state of the
> attached iommufd also. Basically preserve the iommu state of the device
> and also the attached domain. The token returned by the preservation API
> will be used to restore/rebind to the iommufd state after liveupdate.
> 
> Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
> ---
>  drivers/vfio/pci/vfio_pci_liveupdate.c | 28 +++++++++++++++++++++++++-
>  include/linux/kho/abi/vfio_pci.h       | 10 +++++++++
>  2 files changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
> index c52d6bdb455f..af6fbfb7a65c 100644
> --- a/drivers/vfio/pci/vfio_pci_liveupdate.c
> +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
> @@ -15,6 +15,7 @@
>  #include <linux/liveupdate.h>
>  #include <linux/errno.h>
>  #include <linux/vfio.h>
> +#include <linux/iommufd.h>
>  
>  #include "vfio_pci_priv.h"
>  
> @@ -39,6 +40,7 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
>  	struct vfio_pci_core_device_ser *ser;
>  	struct vfio_pci_core_device *vdev;
>  	struct pci_dev *pdev;
> +	u64 token = 0;
>  
>  	vdev = container_of(device, struct vfio_pci_core_device, vdev);
>  	pdev = vdev->pdev;
> @@ -49,15 +51,32 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
>  	if (vfio_pci_is_intel_display(pdev))
>  		return -EINVAL;
>  
> +#if CONFIG_IOMMU_LIVEUPDATE
> +	/* If iommufd is attached, preserve the underlying domain */
> +	if (device->iommufd_attached) {
> +		int err = iommufd_device_preserve(args->session,
> +						  device->iommufd_device,
> +						  &token);
> +		if (err < 0)
> +			return err;
> +	}
> +#endif
> +
>  	ser = kho_alloc_preserve(sizeof(*ser));
> -	if (IS_ERR(ser))
> +	if (IS_ERR(ser)) {
> +		if (device->iommufd_attached)
> +			iommufd_device_unpreserve(args->session,
> +						  device->iommufd_device, token);
> +

To use iommufd_device_preserve()/iommufd_device_unpreserve(),
looks like the IOMMUFD namespace import is missing here —  MODULE_IMPORT_NS("IOMMUFD");

-Ankit

>  		return PTR_ERR(ser);
> +	}
>  
>  	pci_liveupdate_outgoing_preserve(pdev);
>  
>  	ser->bdf = pci_dev_id(pdev);
>  	ser->domain = pci_domain_nr(pdev->bus);
>  	ser->reset_works = vdev->reset_works;
> +	ser->iommufd_ser.token = token;
>  
>  	args->serialized_data = virt_to_phys(ser);
>  	return 0;
> @@ -66,6 +85,13 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
>  static void vfio_pci_liveupdate_unpreserve(struct liveupdate_file_op_args *args)
>  {
>  	struct vfio_device *device = vfio_device_from_file(args->file);
> +	struct vfio_pci_core_device_ser *ser;
> +
> +	ser = phys_to_virt(args->serialized_data);
> +	if (device->iommufd_attached)
> +		iommufd_device_unpreserve(args->session,
> +					  device->iommufd_device,
> +					  ser->iommufd_ser.token);
>  
>  	pci_liveupdate_outgoing_unpreserve(to_pci_dev(device->dev));
>  	kho_unpreserve_free(phys_to_virt(args->serialized_data));
> diff --git a/include/linux/kho/abi/vfio_pci.h b/include/linux/kho/abi/vfio_pci.h
> index 6c3d3c6dfc09..d01bd58711c2 100644
> --- a/include/linux/kho/abi/vfio_pci.h
> +++ b/include/linux/kho/abi/vfio_pci.h
> @@ -28,6 +28,15 @@
>  
>  #define VFIO_PCI_LUO_FH_COMPATIBLE "vfio-pci-v1"
>  
> +/**
> + * struct vfio_iommufd_ser - Serialized state of the attached iommufd.
> + *
> + * @token: The token of the bound iommufd state.
> + */
> +struct vfio_iommufd_ser {
> +	u32 token;
> +} __packed;
> +
>  /**
>   * struct vfio_pci_core_device_ser - Serialized state of a single VFIO PCI
>   * device.
> @@ -40,6 +49,7 @@ struct vfio_pci_core_device_ser {
>  	u16 bdf;
>  	u16 domain;
>  	u8 reset_works;
> +	struct vfio_iommufd_ser iommufd_ser;
>  } __packed;
>  
>  #endif /* _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H */
> -- 
> 2.53.0.rc2.204.g2597b5adb4-goog
> 

