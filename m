Return-Path: <kvm+bounces-40985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FCB5A601FD
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:10:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D812B3AE817
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 117A61F4186;
	Thu, 13 Mar 2025 20:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="aSP5GGeI";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="pnjCuhb/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D782E336B;
	Thu, 13 Mar 2025 20:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741896635; cv=fail; b=c/mlp/dAbbpRjk+oIBb1iVwgoqQz8rdF09QsDpuZBHcIr1ECSFf5+gT+ptxqIub5DLoYDh7Qs0R8D3H7rMzAjGPvT2/zl1LU+idpbnCv12Xqc+9YRGAwTEvmFJRcPJSMBBVE+Lq0gGEmb86JFFhiCfXcdSH36XZVELDr4G58CcQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741896635; c=relaxed/simple;
	bh=Fp4u/CvcYI2W3s8MtqdXqARNiEWBePNvfwFyzNpBiGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=O19eiKwyhsNq4QAZqkhObwMY2C1O0CM2EodCMC/nkQR7hrpPSVylfe1GOeazTE0EU4qIjhQUTKpuRz5PuXWfER07BJcmBUV469lh03CHbzTqAdInGqTEO68Sxv6MNZYHD3vBcOaLFuVbhZRr+11ifp+Iu2w7JHU4bRWYs1eiVIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=aSP5GGeI; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=pnjCuhb/; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DEHlES011333;
	Thu, 13 Mar 2025 13:10:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=M3+Z30YrtuiAMMt2xeG1miLTlHasb3lYQHtxjfAdR
	XU=; b=aSP5GGeIOlS00MpyHiy2rFfbe6o/idbzAS2ngS+hz90by2+cTNph5Loa9
	tuBqDB+Uu+SC1MikS+7cVCHw8W0tsilpOefoD+/8webZUXLE4tAIqRteEv6/QFv8
	Kv676t3g46ZhmkX/hQlfeLyanc8IipYVvUOezeras6Wq39/aXQT1goSct0BoIu16
	6TBQJ6DorN7EqzgxFKmiuIpHEwRG5ZdihCXi0A9rmWIMSZtZV+R9iQD8wiX1rzlf
	vKp73LEwwYTPRwYJUwhhSBFPHA+mvO1DvDoCGMBv6lD9VmnP7NPEWKyzqAC4eGd1
	/uokuBYnIGV1bUuc2sSGs0wvioU+Q==
Received: from sj2pr03cu002.outbound.protection.outlook.com (mail-westusazlp17013079.outbound.protection.outlook.com [40.93.1.79])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 45au9ge769-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Mar 2025 13:10:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MJpkVi+oyVE6PulA8jSgwjk1+NjYpjcxl29xi0wg6greBVCQQnOqBBDSTMxpih9NqBhnHEIpZMvld4kbW0apJmy58RrGpc6QEc/SlRkXPY06T0O9fdUDDgzGrJn5fGbwOUt+o+IVVQPIZ4wxhRRxspUeh7MeEkA2ydzBS9B2RGkHk5sVi9TwWFjkPDwgDSfTyJV275dx53ntF63zCfwRPTYKuDvRfkJGbNsw8+PW+4GkiQDNSWQ2RK+41NxguW6PeRydLKm65ZnGOdTUcPBuBLzEB57vhTHHwgb6vm3CMkPgnVDGOIc2T5PjfTsHeURGqEUg9k2lvTNvxQ4QMhegxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M3+Z30YrtuiAMMt2xeG1miLTlHasb3lYQHtxjfAdRXU=;
 b=QFCfZcx3q2Jaud+Qf5/mIKiIV1M9/VaBov7GiX95g6DmDsnEVujTSXj8Erw9Mkpu06hfcg7KFGsB/fWejxkkh6ewsdqHlq3INPnwTepsYKaG8DF1cOglU5b4Ef/A6fGo/DoonK63xRqqpd+VGU/aViH9vSF6M8mRBnXfcUIjP9NakkV5yNIrgobdRtQYkwjKRFFWarhlNoULBWg5unHvY1fi4u3chhCHJVNzB57Gg0nwzGUQVgT/Vsyxc9VK0cN9NzcvXYSFTlzf40JWzCkKJZzt4fYZtVRoKN5G0VBYLyYtaC5LPLw0eSenPGlfKfhPI1VarM6vd3Oaw/N8XDp74Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M3+Z30YrtuiAMMt2xeG1miLTlHasb3lYQHtxjfAdRXU=;
 b=pnjCuhb//XVnJG0GPjC6KI6A8Lu6wY9VMZaG/z9bnU7Vzb50tG3aIzWmR7hTti3T3LmBGnnV3nl8fw/PjSN45bLyCwRK7oSXhxXDD4Wek12PFpLDRLnrELKpYPuA3FdBHpmTon6lUMh5gGWrDeFEfDk6xneYUvhfHYs4r2QHdh/mILq/cnlKgquOxRXl5dcORfq7bwerOmbBWsAQe6g+IoEsRDCXVoznVmtMQncHtaQuH59lNNCbQ/wS3Mz0z65QgUmHcWhZNWZHNhRgADyAA9xhnD/e+BtHf5R7s9Kk3HKMdgdmem5hplYaxugLwqumvX5ZEvauM957mYJJUtJMug==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by PH0PR02MB9384.namprd02.prod.outlook.com
 (2603:10b6:510:280::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.28; Thu, 13 Mar
 2025 20:10:15 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8534.028; Thu, 13 Mar 2025
 20:10:14 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [RFC PATCH 06/18] KVM: VMX: Wire up Intel MBEC enable/disable logic
Date: Thu, 13 Mar 2025 13:36:45 -0700
Message-ID: <20250313203702.575156-7-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250313203702.575156-1-jon@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
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
X-MS-Office365-Filtering-Correlation-Id: 7e8b8e3d-2d4c-4cb0-054a-08dd626b113e
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|376014|7416014|366016|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0OYxtQ4ubT8Fnn1W4k8y2RYu3fefdPl7TGxaIZXhpfNyTGXgjwSyYNKdHqoY?=
 =?us-ascii?Q?IbioI7bm3m+YujBUEan6d7vabykfn2Tk81Lu93J2OtE5/HLAuiF+6KAyiAaw?=
 =?us-ascii?Q?NvDRs8oeGT75/aCllkmu78rsAyKIkXaNo3NERb22ZlqzEjZQk5go7B5/n89Q?=
 =?us-ascii?Q?4h6PYNA9nffcjF/8hHF77jvk/SD2w0v0EQ8LPUyhaIeGQYspDJrg1adbV61d?=
 =?us-ascii?Q?UDvVxRdwjyuuunKLp345IasYdGwcrR1+4K6uz9/SwP3AQA2uySy0RVzAR+Xc?=
 =?us-ascii?Q?ME9horB+6TlFy0lx26Dk05uxUSdGIXnBHC5eSJMOzDIEWEu8vGm5S4NJHeAK?=
 =?us-ascii?Q?dYP2RrOPp/5YNo0dYIfvyfrq6L4ZttMsOHlMSkXSUEd/HK2YHRxXJy4OvHqN?=
 =?us-ascii?Q?MTj304qJ2LW9OkM9LA0K600SZQOC4DWaKV7F4NI3CT21vuj1sPJ6l0pZk6KD?=
 =?us-ascii?Q?NLFb3RvZYa62YUNE1BAdXoqokUDG3zEz6wIxSLZY/db56W2Em4Nwm4j8Q2xm?=
 =?us-ascii?Q?yisluWQyufvobL3th2JR8gCfcR43vE8VnIDbrylO+2WN+RwLK5UobJXpYC6M?=
 =?us-ascii?Q?Rh2G6xFeUkHnei8ywjQ4yzcYQDWJjb8exoBKIHpKIQVQAFLib3CwHZygFhTr?=
 =?us-ascii?Q?nmMzKJozj0eWX0wc5XlpgvpRthQuy0XNCgQi2lysjg4skYmTYrMpKoK9l45K?=
 =?us-ascii?Q?0k0NRidfZ0JmYb84Zkib02HnmFYlBHs2Co5p1HOKNwxC5VxlNQaP+wyuDlfR?=
 =?us-ascii?Q?1k/SgF2WfCTdBA3VKowfBIVbsNZ6WNqtPiEO4VogYGtvxKczsKgQ/YtxJg33?=
 =?us-ascii?Q?6gATzO+olwsmNa2NoI1+oUmJD5tr+Apcgc6ggvW0MVjExCtvXGo0XmENNhFd?=
 =?us-ascii?Q?oTqdOZGnfr9jD23swDVHs/VbDX8brllgp1qlaNJO+EjH7fUwDkwDpBkmBCfn?=
 =?us-ascii?Q?udxsHvYZxLfgJM1M+WHnL6Ta7CnrItNr/PBViuTuVJcgc+QqKRkPc2zVRfAk?=
 =?us-ascii?Q?fqTnioZ8UfEjtP/tgsntDt2wD+kSHSohXoZVcD825DveMmGelt6/Kn85A4Y/?=
 =?us-ascii?Q?N9gOvkB7k+4W2zQcE0iSPxvZHBiluNfYjxkOV0ls8CKQZV+PDdLu8L1VWxuL?=
 =?us-ascii?Q?gbxHXi62MXZlGNCFzjHDUU/+CqdA2jDNTlPPtB1NXgxCNgjqehtzRMG65q8X?=
 =?us-ascii?Q?4N2tXiNoRf4cHGzOd/bJ6PVg0umW8Fb0JTQlMUHAex7qRPgcz8pFfQ5SIfvh?=
 =?us-ascii?Q?AN8eHwM2U3yR7qENMOz3Kx0lRtIqTNP3u296nOdQNYP+ud1jaTImEl9Z7zbY?=
 =?us-ascii?Q?RpRQbxVx8r5q7QQg1OIdfK+g6wKkloy4mG2A+CQ3mUh5NUBdVmdQXwVasdVH?=
 =?us-ascii?Q?iW2ogtw/NNOUg0Es7JkV2j6durXpO20BUYrVRY7iVMO3nsa21YtzHW5CREUy?=
 =?us-ascii?Q?XK4D0J93Od1qCtjSyWcrfD191oHk2ygCYX7aun08aq981r7W5YbhyA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(7416014)(366016)(921020)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?31czrXk68tmhmDa3yN/0JpzupbVgZs8Z4BlWU47l6q+d5Ut+0NE9OhvG/qle?=
 =?us-ascii?Q?sZcttMwjRcOZE7YGylea0SIGM0BoqIqdL7xQM3+pZMmUBQXBS1AENypc5zZt?=
 =?us-ascii?Q?+7rv0LFNnG6ReXxh9ifUTRsPrtNK+snazBcCwyKR2DpqnNoFo8xTqlmen26I?=
 =?us-ascii?Q?HC/6C/DFWJokwSZkw4GAoQGFgk/uyBffx7kU1n+p7ElFaPu4HVmZnWX6PzOi?=
 =?us-ascii?Q?WKC9U04Y2fkNQc1CBkvfkwATCKzVWDN4faWQehYdHNPECoCf37XcPtVo918J?=
 =?us-ascii?Q?MA6sCTGd91xtPtpLDxW/lw1PaX/crn7KgbO8pZo13lyGiptRjtVpih6s4aB/?=
 =?us-ascii?Q?ThvNiUZQbRvkd0dMPXyE12ll3oY82jf8AIALef3G8TEY9737QbJvBbdFeQ80?=
 =?us-ascii?Q?+DkvuC0zNBX+0a1rO+q6/ZLOarB8kRFEgcxqpc3npvtcr9XBw2hPtuRCl6A7?=
 =?us-ascii?Q?P6BpzM/mgyp7MGZIHjs0F0e0Dfc5VF0DSiSM1TPL9Z8pW0bTbWEZoUQPyuVe?=
 =?us-ascii?Q?AS7leuDxJYP0ttsOE62WgEiWSEjKMAzXyNKYrG1Er1otMqX97Px4L/InSXsl?=
 =?us-ascii?Q?tLGZ1I2FZxBaxyxurwTRnOXTtzIFbY1ZO+2/E26z8BNNYCxt0/xq8ez8MUzu?=
 =?us-ascii?Q?JaBzW0aTCVzPD9NWwj2l/7lP5xyFR+SSpoe8J/qnITY/LN4Y10jr+fbDhkx9?=
 =?us-ascii?Q?fEVlOrbaLCCsjitAo5NBDyjs2RsrUPKS2pHnnLScGj5BLGCdevZmLe2/y1UY?=
 =?us-ascii?Q?8wQO6m8dI07IyZG64EmreD4vcjZqfAk0MVpHJHUO+ZeGlfQps6mB2flJOBG4?=
 =?us-ascii?Q?Ix5ugB64cbPNsOwocpYvjVGJl2AsiNLbzXBNu84vJvkq64W4kkpAv13GGA41?=
 =?us-ascii?Q?iVdu5aM8kFc4uc8JX157Bn9yrduMSuncnGBhpJ9612wrBvJuUpUNzmuVpX0Z?=
 =?us-ascii?Q?YV1+Xicu+hTsosqBVWj4SsBVHMwUUblRVRM+/rlZtUevtuowtwprfEIoEBvD?=
 =?us-ascii?Q?v2T/L7qCYO3XKu0N9qT/GFzlPWLrFyzv+QtOKvwZivSWmdFu/+naOrYvqwg0?=
 =?us-ascii?Q?o7GgKISoWHAwJAuwrWobSHsH8buBwatknQkz+PxM1t5qgTfxqvjByc9IrSUR?=
 =?us-ascii?Q?Xl+ery7Hm1l8t6UaOpfK9APWipDRCLdK/5oEe3OWreu7h552uiTjkcmuOlEr?=
 =?us-ascii?Q?fs69UtyrZT8KB8Gt/K1qxLSHf1XBtTgb0YaWnFHaPPqmgsaCzRMtTaLTo0xR?=
 =?us-ascii?Q?xI2ZJ3toMfl9TmCl3bmsOJrTfFGP9B8Tz+Dq++nmOFfq6jXCHms7Amnil2s9?=
 =?us-ascii?Q?zoWA8EeostDHdYdasnx1L/qe8i/7zS65ppHaHJ5xgT0Y4BzyhBctSHv+LRwC?=
 =?us-ascii?Q?ZrhysjxR+Zk7ozKTOR6DGkYdCfFtbwDauyGlks42NUFX3T0O/NxBZSL8hs09?=
 =?us-ascii?Q?OZLSElBylwoxj/fJ5+leEDq5n12w5C4w7jKZ01bAbGJN+CavAq1XF+e5K7+y?=
 =?us-ascii?Q?X8KBCc9Sopoj46oFambQ3g1LyYuquOiCHLXfy5n8cAOYnfFJzedPQzGhgStQ?=
 =?us-ascii?Q?jK9gi77+gn+Ss7C2VdLvTRbF+yG9KmZRHGkGquuJHw0leEzTHXMeb8NmWN0a?=
 =?us-ascii?Q?aA=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e8b8e3d-2d4c-4cb0-054a-08dd626b113e
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 20:10:14.8699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: glMRlxk4xIHKVQmh7LuyZqMxknV1NaueUhrcPvPrus1tKrBY/LQ8bO3mTc2jiZ22BxuVTrrwx+sCZZRbVvCKWXXHlNYzBDlTOz1eed9RjQM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB9384
X-Proofpoint-GUID: muZ9X0FUZK2EP3sVpgzUIQaNKqUJunFJ
X-Proofpoint-ORIG-GUID: muZ9X0FUZK2EP3sVpgzUIQaNKqUJunFJ
X-Authority-Analysis: v=2.4 cv=P8U6hjAu c=1 sm=1 tr=0 ts=67d33ba8 cx=c_pps a=OYTBATO8h6EMnG+Ds1NGug==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Vs1iUdzkB0EA:10
 a=H5OGdu5hBBwA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8 a=gFziy_h00HmqSejUwBQA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_09,2025-03-13_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

Add logic to enable / disable Intel Mode Based Execution Control (MBEC)
based on specific conditions.

MBEC depends on:
- User space exposing secondary execution control bit 22
- Extended Page Tables (EPT)
- The KVM module parameter `enable_pt_guest_exec_control`

If any of these conditions are not met, MBEC will be disabled
accordingly.

Store runtime enablement within `kvm_vcpu_arch.pt_guest_exec_control`.

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 arch/x86/kvm/vmx/vmx.c | 11 +++++++++++
 arch/x86/kvm/vmx/vmx.h |  7 +++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7a98f03ef146..116910159a3f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2694,6 +2694,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			return -EIO;
 
 		vmx_cap->ept = 0;
+		_cpu_based_2nd_exec_control &= ~SECONDARY_EXEC_MODE_BASED_EPT_EXEC;
 		_cpu_based_2nd_exec_control &= ~SECONDARY_EXEC_EPT_VIOLATION_VE;
 	}
 	if (!(_cpu_based_2nd_exec_control & SECONDARY_EXEC_ENABLE_VPID) &&
@@ -4641,11 +4642,15 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 		exec_control &= ~SECONDARY_EXEC_ENABLE_VPID;
 	if (!enable_ept) {
 		exec_control &= ~SECONDARY_EXEC_ENABLE_EPT;
+		exec_control &= ~SECONDARY_EXEC_MODE_BASED_EPT_EXEC;
 		exec_control &= ~SECONDARY_EXEC_EPT_VIOLATION_VE;
 		enable_unrestricted_guest = 0;
 	}
 	if (!enable_unrestricted_guest)
 		exec_control &= ~SECONDARY_EXEC_UNRESTRICTED_GUEST;
+	if (!enable_pt_guest_exec_control)
+		exec_control &= ~SECONDARY_EXEC_MODE_BASED_EPT_EXEC;
+
 	if (kvm_pause_in_guest(vmx->vcpu.kvm))
 		exec_control &= ~SECONDARY_EXEC_PAUSE_LOOP_EXITING;
 	if (!kvm_vcpu_apicv_active(vcpu))
@@ -4770,6 +4775,9 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		if (vmx->ve_info)
 			vmcs_write64(VE_INFORMATION_ADDRESS,
 				     __pa(vmx->ve_info));
+
+		vmx->vcpu.arch.pt_guest_exec_control =
+			enable_pt_guest_exec_control && vmx_has_mbec(vmx);
 	}
 
 	if (cpu_has_tertiary_exec_ctrls())
@@ -8472,6 +8480,9 @@ __init int vmx_hardware_setup(void)
 	if (!cpu_has_vmx_unrestricted_guest() || !enable_ept)
 		enable_unrestricted_guest = 0;
 
+	if (!cpu_has_vmx_mbec() || !enable_ept)
+		enable_pt_guest_exec_control = false;
+
 	if (!cpu_has_vmx_flexpriority())
 		flexpriority_enabled = 0;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index d1e537bf50ea..9f4ae3139a90 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -580,6 +580,7 @@ static inline u8 vmx_get_rvi(void)
 	 SECONDARY_EXEC_ENABLE_VMFUNC |					\
 	 SECONDARY_EXEC_BUS_LOCK_DETECTION |				\
 	 SECONDARY_EXEC_NOTIFY_VM_EXITING |				\
+	 SECONDARY_EXEC_MODE_BASED_EPT_EXEC |				\
 	 SECONDARY_EXEC_ENCLS_EXITING |					\
 	 SECONDARY_EXEC_EPT_VIOLATION_VE)
 
@@ -721,6 +722,12 @@ static inline bool vmx_has_waitpkg(struct vcpu_vmx *vmx)
 		SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
 }
 
+static inline bool vmx_has_mbec(struct vcpu_vmx *vmx)
+{
+	return secondary_exec_controls_get(vmx) &
+		SECONDARY_EXEC_MODE_BASED_EPT_EXEC;
+}
+
 static inline bool vmx_need_pf_intercept(struct kvm_vcpu *vcpu)
 {
 	if (!enable_ept)
-- 
2.43.0


