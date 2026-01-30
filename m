Return-Path: <kvm+bounces-69755-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IFVgFu5BfWnIRAIAu9opvQ
	(envelope-from <kvm+bounces-69755-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 00:42:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ADB0FBF6AC
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 00:42:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BAB863027946
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 23:42:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3F6D38B7D6;
	Fri, 30 Jan 2026 23:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hzH39Fvf"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012024.outbound.protection.outlook.com [40.107.200.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9931F2B88;
	Fri, 30 Jan 2026 23:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769816526; cv=fail; b=SL3L2LNTUN3lOWTUV9MzuLuh0m1pSisiaQ0zvAo5IdygyEqIzSxByJY6B59UcYJ1pUQhxanLJGnp93TMG8bgaW8OBQvL0vLuizi25/VRKaBehSIh3FlMq9mPY6V39CqMJY57SC2woM8+EK6+/cbwWO1eZ4pXpJXd6ARvH9hYftk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769816526; c=relaxed/simple;
	bh=kjKStme1fO7VEgT+YLJHUtyvlmOWRm9LxzpVS7anc48=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=QMpXB6wFqD/hgxOGDHc1Ukf5z9Ll/itn7nPRO1cUTkJZH5/khYTHnJIshA0p1NdqWHj6CnmWX8YdDWn2mDc6vJ0B8Nxqwuqn5qcrTsev4MDuuO5WSLRMQabrsjCWKfRBoIjE6qKKuDn4YXNYN5ZGCs6n9xViE0r3kYvzTGeyHXs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hzH39Fvf; arc=fail smtp.client-ip=40.107.200.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FRbAeSnNeX5K2vIRpkILalxbTVJHZO4a3i0+JcjJrqJRs6BHHTYD3I0SEM4oxlPl0h4H9MTeRZXMWyXtoFIXfz9nvNOIBgruCNisTEOVRXa7Qr8dqcDjVMppOKRKC+x+IpgkBJbVstw3bJH5Rhx5zIfY9vDkLGbM5LzcWxNGPEMTtfpuUaGunQ8rc01aW3ORUMWXE/etJ8/FPe3JmHZMLAquMM2vrO+Nr5XsySwiNhKxyf+B4+WqN12TeCo3cuGz6480pIF2oGwuLAQarbL6oHBIoY1aSlpPPZL7ddJtlExv+mhrw19LpdpbaTcyxW2wF1kPc0Pok0qWTJ4tqlGQLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hmE8PftbVOjzm8fr1TBJx5JbJg2dOUI1dDz4yBxP7N0=;
 b=IygO2wGszzu/4coe/Qque55bPf/8qvSSWXc7tRwdcTccK6NDh0+Lx4OAIduU2BBmV0WblxtD8UeZMt1L7kJCDytbOFOung6y6DgY/ZK1VHFxiI9/+2U/gAyUcSS6YR/9EJSO5llBGrn1Fb/w/H1w8c8oWVdZGppvxBlk4UeacdoYFVXRa39BuJSsDNxvBTxViN1COuuMsMjQnHUW5lUyHp9ZdETqaDeIjBXyyRuXGQamPC6tZRDiGeRiv95R7hTxKR0adQ+zVqY5yD5Bjyix0LtVvYmF+L1LlW6nVh6Y2N7qiB+oLl1o7e+Hh9JA+78ANCdcu1gGhVs/OvP87x2VXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hmE8PftbVOjzm8fr1TBJx5JbJg2dOUI1dDz4yBxP7N0=;
 b=hzH39FvfSXWn4/c8B3ED+zP1Rffc0+a8QUhT4oIH3EryGDVF3rAEgvJhpBc/oHkn55/ePxlpQBkO9+YO3H5nOXOvki445nvPhLS9K0umhCLXlbyPOwpEzcV9hG+lgnW9xEkokOuMVOKMZOSU5F4uFMaFR6cWKD3IvxVJnJV8tzgnfvJGMouGVCPu2SH2UQA5m6e3wkWB6RDJMlcncsEzH92vyMjTR64X7u/OXrxQFfJHAWXm8zEK81OL+Js1YxQR96XuSaA7Xp/BhQ8GSxxxNbCKM3coz26PVGasCeCdkuGGX4ghJR9J0pk/k+iPPm+f1Tvcsc3s8AmtuKXOH3vazQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY8PR12MB7660.namprd12.prod.outlook.com (2603:10b6:930:84::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 23:42:00 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9564.010; Fri, 30 Jan 2026
 23:42:00 +0000
Date: Fri, 30 Jan 2026 19:41:58 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <20260130234158.GA3424021@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ibB7hFKI83dXt37t"
Content-Disposition: inline
X-ClientProxiedBy: BL1PR13CA0118.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::33) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY8PR12MB7660:EE_
X-MS-Office365-Filtering-Correlation-Id: 945d27e9-90e0-4059-bb88-08de6059296b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Dlswmj7zphtk01lNAkeiTNzlbJ6+Ca2xaxZ5CJ4ge8fYH59hjoCeEUaJMLpv?=
 =?us-ascii?Q?w3m/VYM6KN/IbUrk4C/W6HP42XeWVG6VCD58+HHf417fQp9jYqeoDAWzXkS5?=
 =?us-ascii?Q?NJEtZbRBri1gB84PUpg3+lnZUWf6X04OnBJsNjiOBeVPsLXkTUcURZgZI0OW?=
 =?us-ascii?Q?1RXA90BPLehqJqQVIYD+9bLFxQlOdls3CeovH+3weFK5HUG3AZDMiPLVX5JG?=
 =?us-ascii?Q?GXXQQQvs+/ymFgWXH/BvEuIXVrZgi1BgBCGZRHL8U7x4fkOlBn0lIyC2h0uy?=
 =?us-ascii?Q?RLFt6BVJ4MBEQ/IsSfjPK13UA65y6N5UlMokTVFyS7NBpTebjPpBdtCJsFN5?=
 =?us-ascii?Q?bJxs4CGIR9XOLFAveK4xso1g+43ToWvuk6kT9bdtIIiMbE7XRT2qYCWDxh9+?=
 =?us-ascii?Q?qp347rZ+4JmzKa+Bq0/P/POof4J1FAxgIJPpkKhw6VAxGIpQDWRzVHF62N7I?=
 =?us-ascii?Q?vrlhraUFjhOrZnxk6gzHcTby9ufzhCD2tFxrJnQ0hb/zgK17R5YRHIapAteA?=
 =?us-ascii?Q?hybuEqymlM9rsYjXbsSs/P/7JPDEyW7PnR8jUEXxLdLCDo3ROYnzEGJYk95M?=
 =?us-ascii?Q?a0+SIYTkFTWt1DT+xh15NPrUtsJ44/FFpqWRnSddb+ZfltFDgocvXFY+8fS0?=
 =?us-ascii?Q?+oL9N+O65zKLTYwBmL8NJ1/4kkuz2GqSaNVFrKEcfQ1Zr67QgQmdamkayDGx?=
 =?us-ascii?Q?/AH+Jsugs+Q0rY8vVK5Uo+xZnuvmecU20b/CbbJ1lYAaRbjrdTCnqZykq05R?=
 =?us-ascii?Q?/S5//yDTfY8FZRl7I73dd2BCLAFpB3FLlRWzxRSW3fgL2LVo3fCcrScnbwdu?=
 =?us-ascii?Q?E36Jzpm8rlD2l8M1Ek0DxamqILTqbh09Rz3yp9iuHbDZEUvpV8/e5dCf69+1?=
 =?us-ascii?Q?XF62Ku5cYkI6PVmkfZd4MPpjoQK6IpmAThJs11sYNMxAS0nsDHcBXGJC5Tj7?=
 =?us-ascii?Q?gU9ZboOgBk7rMl8LdEIQ8hi9E5fosq7eLOyzRJUdEWcPGWcJkGc9gt5MWX5b?=
 =?us-ascii?Q?njcATKPVo4vldC8wbA+aTGi8r4KgFl1c/1x0PHrRFVNusd/KY5isMyeb8C7x?=
 =?us-ascii?Q?C7JoxikeamxOXW8RPx6ACXmFgI15FsEvoZqan/HmGbAgH/JTtaacof3UwbHx?=
 =?us-ascii?Q?ivhER/4FF9gNJt89gtRg7CRX+9q8hn+nmcn4YiAgo5KKNDFl7Fw1CqtAq5L0?=
 =?us-ascii?Q?W1piMhcwTfeBCF9qnBX26+eJTmSpnnBssX76zULDmtBcgpDBwy5QMmkEsZoo?=
 =?us-ascii?Q?dcwV4tn0JRpbs/d1mLAwJSrAJUe0cutQ8nJJy4wBrXdXzkoSG1OblyRg7d1w?=
 =?us-ascii?Q?hk/8fBKy93+ocicIrWdBF4PfW/kvpF5tV+YQMLcbjLWM4NTV5jMJNJVOZ2+n?=
 =?us-ascii?Q?a12fZI5hg4MID3R7L8QaMG8VjBiBWr+xYSdOi5YrWPJu6FhlcMu02a16FLX+?=
 =?us-ascii?Q?CJcJZINCgtqM2rvucIduZs8OZFxCmYFK0PTY0eeNBzDCFLrJQsB4M9iaZykN?=
 =?us-ascii?Q?qJ0sMAwlYAFHie0U3jInOZn0bqv1cQhZNohiJd7JafJxTUCCBgy3Gujyb56n?=
 =?us-ascii?Q?6JvlGbNkD78zmG9VW1g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aYC7ibmjoez+LxGy2a7Pt6VO8ISypTGHu7f+J/KoWanJuKkodfVdEzPKEr3v?=
 =?us-ascii?Q?dleR+lAW7o3yUd0OOEYcj1DT0tkw5fF81LTVniVgE4wmEUNQJzYqbUk121xK?=
 =?us-ascii?Q?Pgiw761g5/JywtUfNYV3M0GiFzEHomqAudx2DOI8VQ7LOdKlL7VxaqXASRyd?=
 =?us-ascii?Q?hJDsXETrqYoSx7piLIoMuPVhghGY4AFDmpmUivuiDN253mquK5QvgyjzYxZi?=
 =?us-ascii?Q?uWg7IHftbzy2DMaTqaSXWl91F0UzBIwa5TPXG+FKvJb29OnbKyQOkHMCc1oz?=
 =?us-ascii?Q?fQ+ZhnodBvKjLhovCzfDTbu0igxcl06G6Q4n+gCud/0elTAcepS8KLBduj1n?=
 =?us-ascii?Q?9f8GTO4qaWmYTZoeftgLn9uS/mmQRrg7VJwuDlWXHUg0iPatCPUbPrzXNnpx?=
 =?us-ascii?Q?HoC/fRv09zl0Hiy4eku1wvlfbonU2osdxH49LpgVLdFAWMOtxQ2F42f8+Fqo?=
 =?us-ascii?Q?M04q45M4Gz2zkCJVKiH+5HcS0K6ZTYLHrh1eyqO/9zIvvYo4mbOtA0t9Kpm4?=
 =?us-ascii?Q?C6MfazGxC+wIKxaAt6ERHgNfJH4vG3HCGGyji9qXR1tp3GZ6Gpdj3YhV7w+C?=
 =?us-ascii?Q?I2pcWV+i1aEGHEEv3E8mMav1/ERlU5FQ0uBpgpTtptNYYsgfB3F7AacbG9VV?=
 =?us-ascii?Q?aSm9hwy9nvCr/nOqV7Sl2LD829rBZGaFqSn1OVcpGX4UEVN3EoI13NcFAPPx?=
 =?us-ascii?Q?6upY6KzxFDhurkIo9LTYTO8vqiR8iT2sUxlpDCAYIUTk5Fl9w6epeF5J6zA9?=
 =?us-ascii?Q?fkMTDuEeiN+Fi79EwlR/cVNyR1bNU/6ump/qHnDFVQzbciiRkkv8epPpSvUZ?=
 =?us-ascii?Q?9qZAsyryXDzskJFCAFw92imUuWNluM4UrydkRPAgGo6FvsQdOcJ+o49YvUZx?=
 =?us-ascii?Q?tFcpBwhbCOxTIwjJDmzy8h77ji+01lH3JVrvEGaIKlMPwa3CJNg8A70Eg5cZ?=
 =?us-ascii?Q?jRwa91ny0RIqed/FPu7sQHLOAMHrPniQIWfqbNRXnxL6B7h4MdG+G+KjTG/0?=
 =?us-ascii?Q?YSYJBCoRmAu/4Wu7Cact7ligrsxN1fvPD3iLbac2z7GrZ8qS43/5drvo2dHD?=
 =?us-ascii?Q?mcrGpX9rhPMDmJ/AVxJNa6dWsmgHj5MzKjYY1cZ0vYCrepMpnTzTjLgrdPoy?=
 =?us-ascii?Q?/ifeFsN0g+Xrg+6k51ZTkfwvifgOZWNVnrfHbiaCYyEyZ3uQk+S9UbUs/bZJ?=
 =?us-ascii?Q?5wluy5HW5zbWnND/6bFdK0UPSlsOj/bEHZLO7DJyb5KazNo0wz1cAysIGT7g?=
 =?us-ascii?Q?x0UbSJX2ORf8/fOe7ijZEMv5whEkykZbLUholrTSuL6jarCRRdWCbzqZ0nqZ?=
 =?us-ascii?Q?vqDMVH7cOBlLGHs5ISlv+ttc5tKfkXuNrnQI2znmGSpDPHKKut0GCBmYREAW?=
 =?us-ascii?Q?LHC16aLm+jEOD/j+5bdqgqxBDWB41NciEuVJugjezcZzmQYv1a83752xRFrT?=
 =?us-ascii?Q?PONPcvu1q8Fs8sXr1ehz8/IHiLLjw34VX1bmFKSw67rHF843hs+C9AgSxlbs?=
 =?us-ascii?Q?6enj2jh977pt99N7s003aPQ/Lq7H+roDK9kJ36jKQV/OICKTvAnFG7ugdmNC?=
 =?us-ascii?Q?japgvDWBUgT2ESnsmol6KfQQyf+44OSawpxJIv3mk+lCgwoXHEQ+IAvUk1tn?=
 =?us-ascii?Q?hBRzJ+WYWxsSD9qGUw3wU0zCurKh7oKZRt1yad/MB+KPhqChdZuozBZqHmSG?=
 =?us-ascii?Q?0nHXv2LooawV2VBjgEabwvmOElhpY3UfLldtteLC7Dji9SGo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 945d27e9-90e0-4059-bb88-08de6059296b
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 23:41:59.8934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Inw/O9cAzaEkC2GQVaUf5CXxt+pvxQV2q43vkmttvH33NcEVg1XlUI+zepPQA9P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7660
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.26 / 15.00];
	SIGNED_PGP(-2.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MIME_GOOD(-0.20)[multipart/signed,text/plain];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69755-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+,2:~];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@nvidia.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nvidia.com:mid]
X-Rspamd-Queue-Id: ADB0FBF6AC
X-Rspamd-Action: no action

--ibB7hFKI83dXt37t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

One sykzaller-ish fix from code merged this cycle.

Thanks,
Jason


The following changes since commit 63804fed149a6750ffd28610c5c1c98cce6bd377:

  Linux 6.19-rc7 (2026-01-25 14:11:24 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to 2724138b2f7f6299812b3404e23b124304834759:

  iommufd: Initialize batch->kind in batch_clear() (2026-01-28 12:49:17 -0400)

----------------------------------------------------------------
iommufd 6.19 second rc pull request

One fix for a harmless KMSAN splat.

----------------------------------------------------------------
Deepanshu Kartikey (1):
      iommufd: Initialize batch->kind in batch_clear()

 drivers/iommu/iommufd/pages.c | 1 +
 1 file changed, 1 insertion(+)

--ibB7hFKI83dXt37t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCaX1BwQAKCRCFwuHvBreF
YTK9AQCUV91wfUZ9CUxMI9PI+ye43GJAoK+PxhKHPfr36/d64AD/VALO/lluKARy
SByOOAHAzU6jwM+hoIt1VL4yJNPwXgI=
=UIb1
-----END PGP SIGNATURE-----

--ibB7hFKI83dXt37t--

