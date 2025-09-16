Return-Path: <kvm+bounces-57745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57099B59E07
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:45:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F413832848D
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:45:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F43B3016EA;
	Tue, 16 Sep 2025 16:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ZH1HEsrJ";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="uvp7Gy6x"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80A2125A0
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 16:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758041098; cv=fail; b=h9DCRlKJCrHubRi7YQdmGStqxHwnBNc9km5ZkCJnHCsL0MqUHACfAmn8pGqhAMzv9pCbglPNMfgoU/KjdU8yUWR22JUBOyZx42hIw2U4pGtFrZsk3bLD0Egj+q3pjb1Xg+Yn1qSp2ftIE5GeDwCvk7oMconmW2+GZruk9r5FxCo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758041098; c=relaxed/simple;
	bh=wdbnmOKHpMJBqmvY7B1u1J/05DNjwmz7oMz1wQ73jL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gpWimh0pjaEdcTfKo3Cn+Ml8Z0lrhIQWgjgd4IaYjRXMG6QTrZUt/MEAQ+6IXVTKH8wt8vpNbct5i4w+swLUKQFe6jV0CI5uvFkBoMfAWDzTOmOqS4UxsmTfGdXch5ODw5Z+eGkvTIme+XduZ+EwOC+wg4d4jHBHD9DSvgMMftI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ZH1HEsrJ; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=uvp7Gy6x; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58GDx7sW1608646;
	Tue, 16 Sep 2025 09:44:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=hhm9Dl1ub39tjbo74MbKbmARrx+09CulI1fvZiO8M
	aY=; b=ZH1HEsrJYsTJv4zbxVnNEnweny0ji7ZcCAuJIBcVOrrwuAQYoJshRFpwg
	JkQHyxO0XTpdWodhpFjfPvgdmK3pjo4c99k6f3KgcHXyozRuOYAst3PAfh7NdNI7
	iX5MYzzNZx0EHtJm9b+UJnr6wC99oYDIMrVjMF6rzC2SicfvTuDo5o0hf6xd7Ixl
	tvu8/PIQfsBren1riZv8kXda9OPDmgIJ/g3HpyNw5CcCK3BP0+5uxmt0RV+0OCs/
	T6htAl8FJOY+Na+wPbHeSqR9ovxD0qbgujS2xnBoOq2HSH95Xs5IV2xm3j6haCGD
	zrySQu9OzAOfR2Xbm9AnAJR97020w==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11022084.outbound.protection.outlook.com [40.107.209.84])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 49798qre8n-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 09:44:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fCMxYA5v2tOx8HZUYI85KbUXrInPBlFAd+XaLRw7owcgraaGYP37mtsBgVZwrM/kGz9dj49YsedRE1Fsq9fK7tIDIAJUjiF9Q4psOI1DoQ4ICgd4rgvFhj9gwlbXgjzjFVVuGw2IXTcmX+M7SRQd3ugCYxo3DwPOh8kqmCi/akirDH+c8mG/CLy8vpod0r0RZInmG5e3tv7Dam03aXd0PeHZWv8bMIilNu3KskNkWwUZDAyqArpaX4PZSCCxbS2omoQd2PdUzHMOCG6sJV+YkeYQ+o+aCFShS7eysFolpKJoeGSZt5Go9cpv0g4qQizSsK+x1Mxdp+NVMFP+4or6WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hhm9Dl1ub39tjbo74MbKbmARrx+09CulI1fvZiO8MaY=;
 b=OCqMsA15+2c3OCPyXzAc/adwLlod5bxa6MiPh79hYWR4KjIe0Vlode9VGF2bSALCTxv1/C59eQh1aUofl+VO9nqJ9DHSoHlFJRGU80XmzGppYbzPrlczQDeqzZBCz7HRMH2vrTzlWsqGMwHvZtXjYdPcfD+WQ6/JHbafBJLRcdfDiURAYWAQGMQLNWDYXNJLlAIJcWN1Wih7/Y0irjopr3K8tG8+aMaopwXxadbfIB77cfkJStSf1caeZElbMfDXRZJeca7n00yQbRV5ac8+slOmgxLSVep01p2DDxRVkx0LV0nNojPg7jhtm0Mr15baDPVpIOmBBNhXm93gM0yJ3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hhm9Dl1ub39tjbo74MbKbmARrx+09CulI1fvZiO8MaY=;
 b=uvp7Gy6xiyZ4bYYYsovZcdRMpOs2gETX74G5iHBu1yH6XQVPQwzgESMSbEoWrLtTmYP/MgrrkEDtQQZA9S8kpSJPAFn1H6H+zwjIyCSuHwLqgyXMPPFSh0aTSQm3o4o7SkU1+VhdtKwtgHH3Awxj/QtpNeUTRRgEhGZc8kkajyxqV/nuvnjrbKqThOGHTb9J9km7Kqkzf+4tQWD/fobKRebTL916Gn5WBLbP4IT9lCma4w8K2nmQ3g5md5eJVIrB7pYsQtfqcZWG/517CCJB1GTZI2edpyf459ULCKVSUmjzYHAOY0wOA2KNrOTVZ7CpS6+HV7ciBZPfpVmoVujy0w==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by DS0PR02MB9620.namprd02.prod.outlook.com
 (2603:10b6:8:f7::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 16:44:45 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 16:44:45 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 06/17] x86/vmx: switch to new vmx.h EPT violation defs
Date: Tue, 16 Sep 2025 10:22:35 -0700
Message-ID: <20250916172247.610021-7-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250916172247.610021-1-jon@nutanix.com>
References: <20250916172247.610021-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF00013309.namprd07.prod.outlook.com
 (2603:10b6:518:1::18) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|DS0PR02MB9620:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dcd0669-e3af-444d-5662-08ddf5405780
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZEKYoTBJTiWUuxUks1qSYxXBmUP0vwYBA6o8QiAmtstfKim83bXmmMOfar1D?=
 =?us-ascii?Q?NYyvPkc8/SbFqghT3cujY8JNA5ZIeKptPI5iqqcLxr+QuOpIwLa5qvqtzlpc?=
 =?us-ascii?Q?1pWdiqwsXo64L79btIuk1if8ZnvsSbsct2hTNDDX2Bv+CepMF0IlfuXm2lkY?=
 =?us-ascii?Q?DDnSK9wipdGCOKMvEMumIMaMQ/cNmLAEJbvemNeNB/uBrL3u5s/iNGrBQ7Nl?=
 =?us-ascii?Q?5o7tRSMt8qM+/0Ir5l8dR7QlC5aGJsoPNj/jJwf13mJsPYjIzutImnD8l35+?=
 =?us-ascii?Q?NuhZtUS/m3juuLOAgyIzWNXQb3YXTtXHtsAxkKJK7xKkQz242Juy5e3hPYu7?=
 =?us-ascii?Q?vl8sE0bMBGQmGke8Z6KsTBrrnIlxAwO81KfzvaNvl4MAvqSpflxXkz5dl3yf?=
 =?us-ascii?Q?4w8d9PjnSE/4PW4IV2x32UgMpviN63Cr93IKUKhJaNA4/6OgXrUPjnbxzE6G?=
 =?us-ascii?Q?HeKvvFNk08bpG9L4KqzP/lMbh5AU4MAzDdzydb8AdiZxuze4S0maztkF9s5e?=
 =?us-ascii?Q?QMYO5j4jOxvRByGGofaKzn0ex1S118EraQeEHaqsAbg24JXQFQNalMMbgwcR?=
 =?us-ascii?Q?sZRTLv3xrlkfcGWSdN3Q64hbz0KGYq5DjlhgrVfCIwOc4EFPPshU8orQAIjd?=
 =?us-ascii?Q?ZB6AD1i15CmAP9Sym7K14x5+UkFTrLdlejFB3W21johwa7GN588msSTg1TkZ?=
 =?us-ascii?Q?aRxpYL0lTXPuwPd9WpALS3F0mCrtJ1irIyXftPsqkQvFlKJP+sgPoKR23tB6?=
 =?us-ascii?Q?4cSgYtamQKBKY+jBvGckfpPJDG159ls/1PKwE0+PtmatskpZR6C94Lc8vDsG?=
 =?us-ascii?Q?qZNVYIok/GOclWKQx00pKZIG8hLm7JL/3ebv28TGtrXCWjv1BU24P2jt/IcH?=
 =?us-ascii?Q?XObxJaPeLfiOnWiyX+F/EEY/enjV+xPspx3DWHYww9V0Q1zW8GkLZLdOUD06?=
 =?us-ascii?Q?EwBzvzQRP6Oq2SLbE0Xyi2UONIZJP1cgzB1gzoimLcv3az8G4kk7p9PAHJA+?=
 =?us-ascii?Q?n9VAZeHLelxOkZUpRB1TECaAnxtK44Zh6u67XRFSojsWRv/AifC5axDXqDO8?=
 =?us-ascii?Q?zI67qnv7jIXIi5Xp3azzEjPX1VtaMFaROirTKXj1a6JMdGmWCTGAMYreVRzZ?=
 =?us-ascii?Q?yz8+eQAN9NOML+da6k8sH6CYjy2ra4mmDnith0W0HPDbhVadUoNQSju/Ah1r?=
 =?us-ascii?Q?qXm3ci33Rj2ixp4Ehq3VrytocT8H/d3CU/W+jEMJURwsvKt70G9kb0fD3sv8?=
 =?us-ascii?Q?v7aAWuNHM9qgj7v7puly0O8Hpw9Ta6mRsCFCmiH6M8mFgAnRggQrmj1lhnj3?=
 =?us-ascii?Q?iP+9k1Fo54g6Mu8lrZqXiOu/FT1D5uzbztrt2im1rT8DAndkcyTtRoB1osZg?=
 =?us-ascii?Q?iEL0zBxB7IA3PkiLj5aK+G4wzrdKiFLkJdmcTJMRa1L7eUNRVELiqqyg+qEB?=
 =?us-ascii?Q?CDNWhtHRmhsdbZSJ8AB8Lo3ZBM3qox3TWFoOKGRWUnuK0hgL3XCK8w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AtQXOh65IkjnaCfjC09eC7Z59zj5PfPp5+F7opBG0Y2AkRpvt7Z9vyB7VeKW?=
 =?us-ascii?Q?OiBK1MVtIup3GCZmyYH0pfYn1LYtg/6dhQuZhSbfLBzVYEGNRSFRFJYODvyd?=
 =?us-ascii?Q?4VZ4rPuqFlAdW/Dw/WpTYNYajN9it0VCukBt3TK8L4LQTquyw+1Fu6G51c4l?=
 =?us-ascii?Q?lrR2y88NFFLom2hYrEkzwwtWnm2oGWnLZd3zJ20wVxWrkG90dLYJPPxGr/m9?=
 =?us-ascii?Q?JD1iXPRkJGJREHiBOy12MBKtpH3o9yctGutx0dN+7INnMWYUyI6IyxWrADl0?=
 =?us-ascii?Q?9O243m981x1+udoGzJm2C8ogr6atwJOD7k663j2Xbcy8RMtqF65e6LJuzcHd?=
 =?us-ascii?Q?LumBIjFd+12OaiJWCgjdw9FkTFdzGnA8e5XY/vjn0plMY8FOfneQh36BR0MQ?=
 =?us-ascii?Q?PpEDyjdkKtBoZkR3eVaaNdjB3cNNRs3+GWT+aYCyPfrdLRsDx8Q6RIW8+2Yf?=
 =?us-ascii?Q?y7JDV9AEFYMKcJbOhdP4QNsoYBYxF9em0Uf/H6vmEx4losLRUuNvAp/RdwtJ?=
 =?us-ascii?Q?SSlHySE9SXqUzQ/vsU1OQ8ptqRkUVzT6IziFTkf9/pqDYb55Iw9fG1+2J1HB?=
 =?us-ascii?Q?W8QwT0C/3Rwp5cMeqc0egZpCLUUdj4zx+GbvVJK6e+j0r37vvQLBb+BqFzwO?=
 =?us-ascii?Q?sdkwczghDo74g9yeMyn1moyIlqjrxC9WHvUoWUTP1O1jNWZc1A4fNqGm9q8p?=
 =?us-ascii?Q?xu0CjKNnB1ECmdfFqPPidnHb6Hp3ljLFs2vzALCrGD2STJdcLwHm5qhjzJTh?=
 =?us-ascii?Q?hMNZPJ7CtgUQGRPPURNp4AcKmQ6nu7WJBeVwg4n8+Dx4uJ6SW2KLIAgS1+Ec?=
 =?us-ascii?Q?5LMo2XNJKc+enagA1/sb3ODtQXgewz6ysHTIDJD3cTVWDbtm3dpc/86bPRxw?=
 =?us-ascii?Q?jrdh0e3tMJGKxFnzzl+VsGfbi6/tOwYstWlPMcED3JYxOwuvXH8ds9T5JyQL?=
 =?us-ascii?Q?E5P2/AeLTDmanGd7I0OmXUDmTKrTzYYVqwY002By/Y0jJiAxFUB3LXlsx4G4?=
 =?us-ascii?Q?ay0TjZ9t3BVGKvFmeBnwP4wL4s7XHNNPl1Mjs+jiMrXpayFrvNZMNvAMv5iV?=
 =?us-ascii?Q?8DoxuZOcpwwj4AoNeKWzW+fOSkmrJGQ3XlqpWDGXyLlEXp0n00F3AcVatXeh?=
 =?us-ascii?Q?8VYTIw9dnN0nY+OwqkSBC3mFZR2m4r460chnYblbLJc6cJ8t9NFr8SVWhiwj?=
 =?us-ascii?Q?Sna45TyQQAlxfniphz0HUnKfjC+exTajG8Rl0APMBtkQVOdnbRByHqMwB5lr?=
 =?us-ascii?Q?lnmeg4mUWiWa7k1rQTSWApOBBF7FaCxVhd7Vdy3ZBJ6e/2Rp7FPhmoaiHvQn?=
 =?us-ascii?Q?1PkqyWiNBqCb0UTsdS0ZC4kAxRTF6ifAxW6AiX/pTYUG34G+PsQxsMYqKcOv?=
 =?us-ascii?Q?U40wNfh9VqnohEJj8xeqPc0Sz8O2pNs0O2R0++xYcXnX5oCxFUBz5gssURfj?=
 =?us-ascii?Q?MmNsADQ2eJrM8xMOmxjXIm5NFekVvRmraEGozPYboiEVwVTNd/bjQUthTkdr?=
 =?us-ascii?Q?+/2XgzbfdDlfREBaIo2VzrD4JmicoFQD3gjn7WRr5s14KzmG0D33W3wsIU2p?=
 =?us-ascii?Q?Ki1ekmiRm0Cux7ssFDiNfiSt24d+SJDbPvkzkskiWBT+whjZGg/G6v29u2K0?=
 =?us-ascii?Q?oQ=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dcd0669-e3af-444d-5662-08ddf5405780
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 16:44:45.3396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5P7NBmM626p4m7Kxs57lLyITBODQOotikkhWv8ZZaRGIGK25o38O3b0Kqf41QxSxZ0XOvdWfmM2IxJBZyWGCfOSedIEfoiHj/APVYic8BSQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB9620
X-Proofpoint-GUID: inhRmWtj_Ld2QLPYAiL2Mphedc86V9sD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDE1NSBTYWx0ZWRfXziUUgrW3moDG
 e5YkdsXyZGfN8YZJpg2m8P6aqtznQAA3R7tajed31Mh8F1A8SmwPYccL+7wAYdwYCfTbP8AJG9b
 bI1dY2V+MhPLETULx6XVMM/ulcDr4SY7ewP3UYQb8HzGPt6TB6c15ldh09YN4Q9HVke0ELLEtoG
 tvL31GulshuVixii73rLDTMHLFRQD1lM7RPUswraSsfKLHy8ZjDZJt/wjFXpdtVKTNVGzUEhkIX
 59Xdjp0CjOiZjGjjiGLZawucoBogfJBsWy2YtROqe1TsVmnQ8ygrHwnhWrk69vqzKn1V0YZXMo/
 K/ZYpVi0QxRansUcug40xm302qxIVAcQj6qk3L6ku1nKHCZSqWvuQoS6cAkfxk=
X-Proofpoint-ORIG-GUID: inhRmWtj_Ld2QLPYAiL2Mphedc86V9sD
X-Authority-Analysis: v=2.4 cv=WucrMcfv c=1 sm=1 tr=0 ts=68c993ff cx=c_pps
 a=NQnYyjwfQkqppbiA7sK3Qw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8
 a=JY2zaH1AR5DzDhLUqKoA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

Migrate to new vmx.h's EPT violation defs, which makes it easier
to grok from one code base to another.

Fix a few small formatting issues along the way.

No functional change intended.

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 x86/vmx.h       |  11 -----
 x86/vmx_tests.c | 127 +++++++++++++++++++++++++++++-------------------
 2 files changed, 77 insertions(+), 61 deletions(-)

diff --git a/x86/vmx.h b/x86/vmx.h
index 41346252..9b076b0c 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -618,17 +618,6 @@ enum Intr_type {
 #define EPT_ADDR_MASK		GENMASK_ULL(51, 12)
 #define PAGE_MASK_2M		(~(PAGE_SIZE_2M-1))
 
-#define EPT_VLT_RD		(1ull << 0)
-#define EPT_VLT_WR		(1ull << 1)
-#define EPT_VLT_FETCH		(1ull << 2)
-#define EPT_VLT_PERM_RD		(1ull << 3)
-#define EPT_VLT_PERM_WR		(1ull << 4)
-#define EPT_VLT_PERM_EX		(1ull << 5)
-#define EPT_VLT_PERM_USER_EX	(1ull << 6)
-#define EPT_VLT_PERMS		(EPT_VLT_PERM_RD | EPT_VLT_PERM_WR | \
-				 EPT_VLT_PERM_EX)
-#define EPT_VLT_LADDR_VLD	(1ull << 7)
-#define EPT_VLT_PADDR		(1ull << 8)
 #define EPT_VLT_GUEST_USER	(1ull << 9)
 #define EPT_VLT_GUEST_RW	(1ull << 10)
 #define EPT_VLT_GUEST_EX	(1ull << 11)
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index dbcb6cae..a09b687f 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1443,8 +1443,9 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 			check_ept_ad(pml4, guest_cr3, (unsigned long)data_page1, 0,
 				     have_ad ? EPT_ACCESS_FLAG | EPT_DIRTY_FLAG : 0);
 			clear_ept_ad(pml4, guest_cr3, (unsigned long)data_page1);
-			if (exit_qual == (EPT_VLT_WR | EPT_VLT_LADDR_VLD |
-					EPT_VLT_PADDR))
+			if (exit_qual == (EPT_VIOLATION_ACC_WRITE |
+					  EPT_VIOLATION_GVA_IS_VALID |
+					  EPT_VIOLATION_GVA_TRANSLATED))
 				vmx_inc_test_stage();
 			set_ept_pte(pml4, (unsigned long)data_page1,
 				1, data_page1_pte | (EPT_PRESENT));
@@ -1454,16 +1455,16 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 			check_ept_ad(pml4, guest_cr3, (unsigned long)data_page1, 0,
 				     have_ad ? EPT_ACCESS_FLAG | EPT_DIRTY_FLAG : 0);
 			clear_ept_ad(pml4, guest_cr3, (unsigned long)data_page1);
-			if (exit_qual == (EPT_VLT_RD |
-					  (have_ad ? EPT_VLT_WR : 0) |
-					  EPT_VLT_LADDR_VLD))
+			if (exit_qual == (EPT_VIOLATION_ACC_READ |
+					  (have_ad ? EPT_VIOLATION_ACC_WRITE : 0) |
+					   EPT_VIOLATION_GVA_IS_VALID))
 				vmx_inc_test_stage();
 			set_ept_pte(pml4, guest_pte_addr, 2,
 				data_page1_pte_pte | (EPT_PRESENT));
 			invept(INVEPT_SINGLE, eptp);
 			break;
 		case 5:
-			if (exit_qual & EPT_VLT_RD)
+			if (exit_qual & EPT_VIOLATION_ACC_READ)
 				vmx_inc_test_stage();
 			TEST_ASSERT(get_ept_pte(pml4, (unsigned long)pci_physaddr,
 						1, &memaddr_pte));
@@ -1471,7 +1472,7 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 			invept(INVEPT_SINGLE, eptp);
 			break;
 		case 6:
-			if (exit_qual & EPT_VLT_WR)
+			if (exit_qual & EPT_VIOLATION_ACC_WRITE)
 				vmx_inc_test_stage();
 			TEST_ASSERT(get_ept_pte(pml4, (unsigned long)pci_physaddr,
 						1, &memaddr_pte));
@@ -2283,14 +2284,14 @@ do {									\
 		       (expected & flag) ? "" : "un");			\
 } while (0)
 
-	DIAGNOSE(EPT_VLT_RD);
-	DIAGNOSE(EPT_VLT_WR);
-	DIAGNOSE(EPT_VLT_FETCH);
-	DIAGNOSE(EPT_VLT_PERM_RD);
-	DIAGNOSE(EPT_VLT_PERM_WR);
-	DIAGNOSE(EPT_VLT_PERM_EX);
-	DIAGNOSE(EPT_VLT_LADDR_VLD);
-	DIAGNOSE(EPT_VLT_PADDR);
+	DIAGNOSE(EPT_VIOLATION_ACC_READ);
+	DIAGNOSE(EPT_VIOLATION_ACC_WRITE);
+	DIAGNOSE(EPT_VIOLATION_ACC_INSTR);
+	DIAGNOSE(EPT_VIOLATION_PROT_READ);
+	DIAGNOSE(EPT_VIOLATION_PROT_WRITE);
+	DIAGNOSE(EPT_VIOLATION_PROT_EXEC);
+	DIAGNOSE(EPT_VIOLATION_GVA_IS_VALID);
+	DIAGNOSE(EPT_VIOLATION_GVA_TRANSLATED);
 
 #undef DIAGNOSE
 }
@@ -2357,7 +2358,7 @@ static void do_ept_violation(bool leaf, enum ept_access_op op,
 
 	/* Mask undefined bits (which may later be defined in certain cases). */
 	qual &= ~(EPT_VLT_GUEST_USER | EPT_VLT_GUEST_RW | EPT_VLT_GUEST_EX |
-		 EPT_VLT_PERM_USER_EX);
+		  EPT_VIOLATION_EXEC_FOR_RING3_LIN);
 
 	diagnose_ept_violation_qual(expected_qual, qual);
 	TEST_EXPECT_EQ(expected_qual, qual);
@@ -2419,18 +2420,20 @@ static void ept_access_violation(unsigned long access, enum ept_access_op op,
 				       u64 expected_qual)
 {
 	ept_violation(EPT_PRESENT, access, op,
-		      expected_qual | EPT_VLT_LADDR_VLD | EPT_VLT_PADDR);
+		      expected_qual | EPT_VIOLATION_GVA_IS_VALID |
+		      EPT_VIOLATION_GVA_TRANSLATED);
 }
 
 /*
  * For translations that don't involve a GVA, that is physical address (paddr)
- * accesses, EPT violations don't set the flag EPT_VLT_PADDR.  For a typical
- * guest memory access, the hardware does GVA -> GPA -> HPA.  However, certain
- * translations don't involve GVAs, such as when the hardware does the guest
- * page table walk. For example, in translating GVA_1 -> GPA_1, the guest MMU
- * might try to set an A bit on a guest PTE. If the GPA_2 that the PTE resides
- * on isn't present in the EPT, then the EPT violation will be for GPA_2 and
- * the EPT_VLT_PADDR bit will be clear in the exit qualification.
+ * accesses, EPT violations don't set the flag EPT_VIOLATION_GVA_TRANSLATED.
+ * For a typical guest memory access, the hardware does GVA -> GPA -> HPA.
+ * However, certain translations don't involve GVAs, such as when the hardware
+ * does the guest page table walk. For example, in translating GVA_1 -> GPA_1,
+ * the guest MMU might try to set an A bit on a guest PTE. If the GPA_2 that
+ * the PTE resides on isn't present in the EPT, then the EPT violation will be
+ * for GPA_2 and the EPT_VIOLATION_GVA_TRANSLATED bit will be clear in the exit
+ * qualification.
  *
  * Note that paddr violations can also be triggered by loading PAE page tables
  * with wonky addresses. We don't test that yet.
@@ -2449,7 +2452,7 @@ static void ept_access_violation(unsigned long access, enum ept_access_op op,
  *			Is a violation expected during the paddr access?
  *
  *	@expected_qual	Expected qualification for the EPT violation.
- *			EPT_VLT_PADDR should be clear.
+ *			EPT_VIOLATION_GVA_TRANSLATED should be clear.
  */
 static void ept_access_paddr(unsigned long ept_access, unsigned long pte_ad,
 			     enum ept_access_op op, bool expect_violation,
@@ -2492,7 +2495,7 @@ static void ept_access_paddr(unsigned long ept_access, unsigned long pte_ad,
 
 	if (expect_violation) {
 		do_ept_violation(/*leaf=*/true, op,
-				 expected_qual | EPT_VLT_LADDR_VLD, gpa);
+				 expected_qual | EPT_VIOLATION_GVA_IS_VALID, gpa);
 		ept_untwiddle(gpa, /*level=*/1, orig_epte);
 		do_ept_access_op(op);
 	} else {
@@ -2611,9 +2614,10 @@ static void ept_misconfig_at_level_mkhuge_op(bool mkhuge, int level,
 	/*
 	 * broken:
 	 * According to description of exit qual for EPT violation,
-	 * EPT_VLT_LADDR_VLD indicates if GUEST_LINEAR_ADDRESS is valid.
+	 * EPT_VIOLATION_GVA_IS_VALID indicates if GUEST_LINEAR_ADDRESS is
+	 * valid.
 	 * However, I can't find anything that says GUEST_LINEAR_ADDRESS ought
-	 * to be set for msiconfig.
+	 * to be set for misconfig.
 	 */
 	TEST_EXPECT_EQ(vmcs_read(GUEST_LINEAR_ADDRESS),
 		       (unsigned long) (
@@ -2664,7 +2668,9 @@ static void ept_reserved_bit_at_level_nohuge(int level, int bit)
 
 	/* Making the entry non-present turns reserved bits into ignored. */
 	ept_violation_at_level(level, EPT_PRESENT, 1ul << bit, OP_READ,
-			       EPT_VLT_RD | EPT_VLT_LADDR_VLD | EPT_VLT_PADDR);
+			       EPT_VIOLATION_ACC_READ |
+			       EPT_VIOLATION_GVA_IS_VALID |
+			       EPT_VIOLATION_GVA_TRANSLATED);
 }
 
 static void ept_reserved_bit_at_level_huge(int level, int bit)
@@ -2674,7 +2680,9 @@ static void ept_reserved_bit_at_level_huge(int level, int bit)
 
 	/* Making the entry non-present turns reserved bits into ignored. */
 	ept_violation_at_level(level, EPT_PRESENT, 1ul << bit, OP_READ,
-			       EPT_VLT_RD | EPT_VLT_LADDR_VLD | EPT_VLT_PADDR);
+			       EPT_VIOLATION_ACC_READ |
+			       EPT_VIOLATION_GVA_IS_VALID |
+			       EPT_VIOLATION_GVA_TRANSLATED);
 }
 
 static void ept_reserved_bit_at_level(int level, int bit)
@@ -2684,7 +2692,9 @@ static void ept_reserved_bit_at_level(int level, int bit)
 
 	/* Making the entry non-present turns reserved bits into ignored. */
 	ept_violation_at_level(level, EPT_PRESENT, 1ul << bit, OP_READ,
-			       EPT_VLT_RD | EPT_VLT_LADDR_VLD | EPT_VLT_PADDR);
+			       EPT_VIOLATION_ACC_READ |
+			       EPT_VIOLATION_GVA_IS_VALID |
+			       EPT_VIOLATION_GVA_TRANSLATED);
 }
 
 static void ept_reserved_bit(int bit)
@@ -2787,9 +2797,9 @@ static void ept_access_test_not_present(void)
 {
 	ept_access_test_setup();
 	/* --- */
-	ept_access_violation(0, OP_READ, EPT_VLT_RD);
-	ept_access_violation(0, OP_WRITE, EPT_VLT_WR);
-	ept_access_violation(0, OP_EXEC, EPT_VLT_FETCH);
+	ept_access_violation(0, OP_READ, EPT_VIOLATION_ACC_READ);
+	ept_access_violation(0, OP_WRITE, EPT_VIOLATION_ACC_WRITE);
+	ept_access_violation(0, OP_EXEC, EPT_VIOLATION_ACC_INSTR);
 }
 
 static void ept_access_test_read_only(void)
@@ -2798,8 +2808,10 @@ static void ept_access_test_read_only(void)
 
 	/* r-- */
 	ept_access_allowed(EPT_RA, OP_READ);
-	ept_access_violation(EPT_RA, OP_WRITE, EPT_VLT_WR | EPT_VLT_PERM_RD);
-	ept_access_violation(EPT_RA, OP_EXEC, EPT_VLT_FETCH | EPT_VLT_PERM_RD);
+	ept_access_violation(EPT_RA, OP_WRITE, EPT_VIOLATION_ACC_WRITE |
+			     EPT_VIOLATION_PROT_READ);
+	ept_access_violation(EPT_RA, OP_EXEC, EPT_VIOLATION_ACC_INSTR |
+			     EPT_VIOLATION_PROT_READ);
 }
 
 static void ept_access_test_write_only(void)
@@ -2816,7 +2828,9 @@ static void ept_access_test_read_write(void)
 	ept_access_allowed(EPT_RA | EPT_WA, OP_READ);
 	ept_access_allowed(EPT_RA | EPT_WA, OP_WRITE);
 	ept_access_violation(EPT_RA | EPT_WA, OP_EXEC,
-			   EPT_VLT_FETCH | EPT_VLT_PERM_RD | EPT_VLT_PERM_WR);
+			     EPT_VIOLATION_ACC_INSTR |
+			     EPT_VIOLATION_PROT_READ |
+			     EPT_VIOLATION_PROT_WRITE);
 }
 
 
@@ -2826,9 +2840,11 @@ static void ept_access_test_execute_only(void)
 	/* --x */
 	if (ept_execute_only_supported()) {
 		ept_access_violation(EPT_EA, OP_READ,
-				     EPT_VLT_RD | EPT_VLT_PERM_EX);
+				     EPT_VIOLATION_ACC_READ |
+				     EPT_VIOLATION_PROT_EXEC);
 		ept_access_violation(EPT_EA, OP_WRITE,
-				     EPT_VLT_WR | EPT_VLT_PERM_EX);
+				     EPT_VIOLATION_ACC_WRITE |
+				     EPT_VIOLATION_PROT_EXEC);
 		ept_access_allowed(EPT_EA, OP_EXEC);
 	} else {
 		ept_access_misconfig(EPT_EA);
@@ -2841,7 +2857,9 @@ static void ept_access_test_read_execute(void)
 	/* r-x */
 	ept_access_allowed(EPT_RA | EPT_EA, OP_READ);
 	ept_access_violation(EPT_RA | EPT_EA, OP_WRITE,
-			   EPT_VLT_WR | EPT_VLT_PERM_RD | EPT_VLT_PERM_EX);
+			     EPT_VIOLATION_ACC_WRITE |
+			     EPT_VIOLATION_PROT_READ |
+			     EPT_VIOLATION_PROT_EXEC);
 	ept_access_allowed(EPT_RA | EPT_EA, OP_EXEC);
 }
 
@@ -2936,14 +2954,17 @@ static void ept_access_test_paddr_not_present_ad_disabled(void)
 	ept_access_test_setup();
 	ept_disable_ad_bits();
 
-	ept_access_violation_paddr(0, PT_AD_MASK, OP_READ, EPT_VLT_RD);
-	ept_access_violation_paddr(0, PT_AD_MASK, OP_WRITE, EPT_VLT_RD);
-	ept_access_violation_paddr(0, PT_AD_MASK, OP_EXEC, EPT_VLT_RD);
+	ept_access_violation_paddr(0, PT_AD_MASK, OP_READ,
+				   EPT_VIOLATION_ACC_READ);
+	ept_access_violation_paddr(0, PT_AD_MASK, OP_WRITE,
+				   EPT_VIOLATION_ACC_READ);
+	ept_access_violation_paddr(0, PT_AD_MASK, OP_EXEC,
+				   EPT_VIOLATION_ACC_READ);
 }
 
 static void ept_access_test_paddr_not_present_ad_enabled(void)
 {
-	u64 qual = EPT_VLT_RD | EPT_VLT_WR;
+	u64 qual = EPT_VIOLATION_ACC_READ | EPT_VIOLATION_ACC_WRITE;
 
 	ept_access_test_setup();
 	ept_enable_ad_bits_or_skip_test();
@@ -2961,7 +2982,8 @@ static void ept_access_test_paddr_read_only_ad_disabled(void)
 	 * translation of the GPA to host physical address) a read+write
 	 * if the A/D bits have to be set.
 	 */
-	u64 qual = EPT_VLT_WR | EPT_VLT_RD | EPT_VLT_PERM_RD;
+	u64 qual = EPT_VIOLATION_ACC_WRITE | EPT_VIOLATION_ACC_READ |
+		   EPT_VIOLATION_PROT_READ;
 
 	ept_access_test_setup();
 	ept_disable_ad_bits();
@@ -2987,7 +3009,8 @@ static void ept_access_test_paddr_read_only_ad_enabled(void)
 	 * structures are considered writes as far as EPT translation
 	 * is concerned.
 	 */
-	u64 qual = EPT_VLT_WR | EPT_VLT_RD | EPT_VLT_PERM_RD;
+	u64 qual = EPT_VIOLATION_ACC_WRITE | EPT_VIOLATION_ACC_READ |
+		   EPT_VIOLATION_PROT_READ;
 
 	ept_access_test_setup();
 	ept_enable_ad_bits_or_skip_test();
@@ -3029,7 +3052,8 @@ static void ept_access_test_paddr_read_execute_ad_disabled(void)
 	 * translation of the GPA to host physical address) a read+write
 	 * if the A/D bits have to be set.
 	 */
-	u64 qual = EPT_VLT_WR | EPT_VLT_RD | EPT_VLT_PERM_RD | EPT_VLT_PERM_EX;
+	u64 qual = EPT_VIOLATION_ACC_WRITE | EPT_VIOLATION_ACC_READ |
+		   EPT_VIOLATION_PROT_READ | EPT_VIOLATION_PROT_EXEC;
 
 	ept_access_test_setup();
 	ept_disable_ad_bits();
@@ -3055,7 +3079,8 @@ static void ept_access_test_paddr_read_execute_ad_enabled(void)
 	 * structures are considered writes as far as EPT translation
 	 * is concerned.
 	 */
-	u64 qual = EPT_VLT_WR | EPT_VLT_RD | EPT_VLT_PERM_RD | EPT_VLT_PERM_EX;
+	u64 qual = EPT_VIOLATION_ACC_WRITE | EPT_VIOLATION_ACC_READ |
+		   EPT_VIOLATION_PROT_READ | EPT_VIOLATION_PROT_EXEC;
 
 	ept_access_test_setup();
 	ept_enable_ad_bits_or_skip_test();
@@ -3089,8 +3114,10 @@ static void ept_access_test_force_2m_page(void)
 	TEST_ASSERT_EQ(ept_2m_supported(), true);
 	ept_allowed_at_level_mkhuge(true, 2, 0, 0, OP_READ);
 	ept_violation_at_level_mkhuge(true, 2, EPT_PRESENT, EPT_RA, OP_WRITE,
-				      EPT_VLT_WR | EPT_VLT_PERM_RD |
-				      EPT_VLT_LADDR_VLD | EPT_VLT_PADDR);
+				      EPT_VIOLATION_ACC_WRITE |
+				      EPT_VIOLATION_PROT_READ |
+				      EPT_VIOLATION_GVA_IS_VALID |
+				      EPT_VIOLATION_GVA_TRANSLATED);
 	ept_misconfig_at_level_mkhuge(true, 2, EPT_PRESENT, EPT_WA);
 }
 
-- 
2.43.0


