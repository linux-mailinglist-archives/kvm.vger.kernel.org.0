Return-Path: <kvm+bounces-57751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B904B59E0C
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:46:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8193732851B
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:46:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F73D31E8BF;
	Tue, 16 Sep 2025 16:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="AvsJymcE";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="qpFqIgjc"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3BB27FD6E
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 16:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758041103; cv=fail; b=Fh/a1G1uKNcwV//cy3Ljw+TWNvX/PwKqqQXfN2GLHj3ibbmBrS3T38HhopJ+lnORBrbj2XkEmAqHW15XFhajEFc4wrRUU/FZSiyBYzV13F0YEpYoB5pUEn0L5tDdXFkjPB5/2OjFAqjSgDedcwSMCAz775ZJ1j29nYyWbnLSyQg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758041103; c=relaxed/simple;
	bh=eJPPjqFqMNyXRwI6ZV4XwQt/aLItXw4hdnJjtz9bQjk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qr2P+QaDx3vuPLPDl+jRbOrpfiSynQhBDnhXtkmgt1SE2cc9AhyFfl2Ue+L7aIut05mqqS+whTrZR9J0lhwi1X10KMaQVrp0HNmIc58LGWfRbq5vM3hOdSdbK+pPbL8R9dZC4OLmL6AKl7xO+AnDhreQlfJ2XWj6tpPgu6WDZE0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=AvsJymcE; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=qpFqIgjc; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58GG8wdq3523588;
	Tue, 16 Sep 2025 09:44:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=+s4E3cnoAxwS0DqVLWz4LKsucNAFw6CZnMEvagtSX
	/I=; b=AvsJymcEaUVIQ1cGsqolo+pAjnrtmRrc8S+7ABMo7CXSPtJ7UTeG912r4
	8I44Jut/57VyUZNELAchcOcfwMZfjKlKJuioyA5LSJFC62qrtZpn5gXaNMqeomoT
	23qE5vfPkKrKXPN2KfqZhQ9NL7eoI+HsXacKxJIiYZE1bLZVhpXVb8VDy1S3D6FU
	TOKnfHDhWSraqtAHcKazSarGG0wU7OeU2lYqudZcw4QoKrTx0/g8kLrB/Xb8VtH8
	3rVP0AIaHp+Z/4ijnK6ICQXMPLOc0W2GcK0BIKqo3NDmw4st9smplaaTsjzU/f7S
	nVUdKiXSnsdPVFqQ9qfn0xkxBo76w==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11022113.outbound.protection.outlook.com [40.107.209.113])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 496pwxtsdt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 09:44:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VjGYyD2RAB3gg8uvBvmpecDZL92Wsn3D80gR5IhH0oUsiYvwKN36ypjsgmcWwjTwNZ500vw8oXoZw1YSMLZAzHxIz+OXJ6QlprG/B4RwPHLKnFaR3IK4qlrik3JfHi/jj98vg+IIPF/CsDrxCmdM2lRCkjWDrKnNpOJ1SGFVji7rcpiGIWpYbLmcrTtJ6QlKFVCTl1EyxhmbWNqYlZgt56pLVCZFz4b+BcDwOwDA6jxLebYGzEkjZztLTWauNr+/Pc1lNx7aR827ePk4D5F4jLDvSzV47cewNnwK6fAyOR21lECNaBYPbBQ0j67ihg296batMSKnf/qygKdloStumQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+s4E3cnoAxwS0DqVLWz4LKsucNAFw6CZnMEvagtSX/I=;
 b=NDgCvQCar8C9hFa6MpQIHdbJGpA+mtkSIY1mY8TVS1PJu9392pQbrwqB1Jnj4pZgC6pVxEu4ztf9rdimM2mfZmYomURxRuuhphPEmTHXVIhVS4Si3dwhptT7CqSyKLtGgx3zIEuK5ydvZoVTlYYOQxXKbwLRTucAmir4HTM4hyFtzubQvarCNSmN10fX6ftsXAyawS+o70DVMheDChuVFDMiml4hlxXNN5FEiqigvP11A97lJ7hqFR0Bsk0gsDES2QV0GpqHlzDkiEM3Vgves8CDhKHvx/Fk9Vq8kAnLL82qHlxocA93DlCMhdOVkZdxUYGUD6+VjYLCmFzU7qykhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+s4E3cnoAxwS0DqVLWz4LKsucNAFw6CZnMEvagtSX/I=;
 b=qpFqIgjcmCHD1mkZe9Jr5uR+cfVsGx4ZHdpV/9X8veBc4mWBX6rXIdGIXcPsW4d+QMN3g8J2ZUcKPIg4ep0sHw0w+ceQB8nTOfqxsEblW2EB2KPKhcXOI8HvHmmtSXteZlzWbwDRTTZMay4j84BAriFKBtriXxbt0VBr/Pxv5/JmkJT28bxZt7in+6WpMOLjg2DCvtCTH73V8ITeam1D6d6DcprMmf8QN33XkFN3O7I1yt0n3MvrxTc3Bn2lUdW+3NxnxOBUkbWPSQSrb/GNArrxFudUoek+NSXZTQJ71VtN6QK/JSoILyOlxXHyLbQDoO/Tw8IKQkj2xzakOIUWYA==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by DS0PR02MB9620.namprd02.prod.outlook.com
 (2603:10b6:8:f7::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 16:44:49 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 16:44:49 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 10/17] x86/vmx: switch to new vmx.h primary processor-based VM-execution controls
Date: Tue, 16 Sep 2025 10:22:39 -0700
Message-ID: <20250916172247.610021-11-jon@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5fc8f8c5-74de-43f4-d4fd-08ddf54059c7
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ncQvLQljt989Hd8i7qxg3G4FpHudMIFzZ2qdGU8pRVAbBSPM+YT70iRgSrnt?=
 =?us-ascii?Q?onRQVFTk77rUylnDUQ5nwz50r22ZMaV6PEZ63cIVpQtSHki4GW/JIbdvnx8+?=
 =?us-ascii?Q?DGuLCLbEOtDhwT9gN6dws/HKdc3cb7doXtf17TPXBAtTQIonwGqjsJ3BSW7u?=
 =?us-ascii?Q?LLM5G67LC9Ae/4gh6G8W2pNVz921G+YKa1H0Vk9KpUJrM621Gry+YCGc5bE5?=
 =?us-ascii?Q?KDwXRWuirpoUAGE5RKdYzZvUFQ3kPPNnlLCgX7Rg7OSn8pQsmkDpSGXtNF/0?=
 =?us-ascii?Q?HiOCG1OGMHD9y1PuGrGLnFtLAWzcqDi2kFuhCpUlLkuhPgMCS6inozAr5Y0r?=
 =?us-ascii?Q?olF4nAHk5FqFbodS9sJUGn2zruIgbBBHRDlD3g5oeKPg1aR2n9q6vGYPuchW?=
 =?us-ascii?Q?ZVzo1YcRzM9n+CpI9MODsnjll6JXGLeCDtKU1ZyzpbQs6gfHp5HRofqKpqzc?=
 =?us-ascii?Q?gFTy+2pEnJucGWzL1jXh3jZMPwtm2qB6zy1o7UGqwbxWbRTXn8FJ0+srik44?=
 =?us-ascii?Q?jBx0QiRLVPGZZ7nSZqghsB5rEbar+muRCD8d50WKfGEUyjpow2EthF2I6yCE?=
 =?us-ascii?Q?fzNl234/SZyIsb8BVTFjG+5fnoGUlRbx4V8ZMjcgdeZP0t7UoqcqLzfptP01?=
 =?us-ascii?Q?sh15AaoNrbfNL7H2f+k+bRE7pkfQBdndMOkmWsqcPbueeUDm3B2lxw7E6MJ7?=
 =?us-ascii?Q?4kI4fjDZWnpXOMjZ2hH0dlU1moLD2EGyCU9N49qsUj2wr5tWHLg0nj6Y/eMD?=
 =?us-ascii?Q?Rp+H+Yz1iCgZ0hEbZZozMY3mc/WzDlBrtrcJGhcqkvGM6ZEXGRzmv98Aj9uH?=
 =?us-ascii?Q?JEg8MvWhXDKTJCjGizRCdi4bpK9XsriquYKmbGXOaNZJBWRdYQamthvLlrBV?=
 =?us-ascii?Q?dJkzUTj9QQ+ji16RbHBl63FuO0K0yAxTD8HBduBYP7v7FbRUHqFUBawPkwuO?=
 =?us-ascii?Q?hTxUIQeVeBt5z5mztdVGzfMm0FyBMov8yB3VCts4Nx7by2JpHacYIC6zBd0f?=
 =?us-ascii?Q?HLbBlzpBUXXdbKT2x4mQOFbvJNF1CsjEYpReQ54GU2WM84wwiTj7UCHjUFyQ?=
 =?us-ascii?Q?VPHieCrZtPKTEpN58VkZatLu8ZCfYstBh+w7ZgUrgIb4Xh0JB5L57ZAgQAm+?=
 =?us-ascii?Q?tAHMYWAJHbF27lxmvdCa2bVJsZiPChis/eFvTEgCtQj34LCXUqttqtkJeX1Q?=
 =?us-ascii?Q?JCXelhY2ZR1MAkxp/Eznv31+DpMf4cccSB8Sfy/6qERvuyD2NNaV+LiMQfYU?=
 =?us-ascii?Q?7B2wIyyI9oB2gSCGb/UoRzUi+zf/4l0ZyMtMLaRNf66x4U91HKJ7wuMF6YI6?=
 =?us-ascii?Q?eQH70tskysCg/AizBFmgSccmR3r0A4d7UtOcCAiCKllFwDNmKdkN51iISpUo?=
 =?us-ascii?Q?pFaO9atv2Kq+C0QBWxZzszgeyUEesj3CBLlDZ8f2MZ3aRRb8/R59J4oBrMCw?=
 =?us-ascii?Q?x/v4bKn5Nvw9oDB+I3WgWNM8Y98OhSdkmErG8JerBvBQFOOtVQ8FaQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EfjhjYdl/wSNCC3wNJFND/D6gLrctLIv6tWTmLNiNddS1LCZPbyycQ5M2mSw?=
 =?us-ascii?Q?Awp30x4GgIgFzv7BSbpFDI7b8xMuUxQJybjPIYI9B26pt3wDgCfNJcGeXVLh?=
 =?us-ascii?Q?OLGh7LojV1Vg3Rz2vW7jwi+7NXTMnJ362HKkk++TWLhra2MUmDl7VmamaL0n?=
 =?us-ascii?Q?3URn/+Z2SIWVM9hSP29WEHVyqORQLMUnEnNuWQ3AzDTc+R8lb4LrF+9Mrysj?=
 =?us-ascii?Q?wwREocdTLjQSatbN5Ckot/k3wL3MZd7AHHOwqWqWlWU8ZfiFIOTiyI4X/4BM?=
 =?us-ascii?Q?kwhXA+yflqSGAZB4frAgWhBMHSBmjHo2E5+f3eZF6fe9opOSOBX2rD1HK2lj?=
 =?us-ascii?Q?GiXM1woJnWy9FO6AKAwmJwLVMxF09Xja9LGuybsmtWsiiCPtg4Vlf77XTFZF?=
 =?us-ascii?Q?6YZRMjsehUl9405JaAlZDSkejmuHaDYG8KMYjTQsBoEMvZFSYpUzsjJ+56Q4?=
 =?us-ascii?Q?MLSOAjbvLbIKNPVxn4ucanNOLntxNqD9Y4yTFUTFa9sYAtgQKxYP6ZSpe8/1?=
 =?us-ascii?Q?96DbtCkY4kuN3dnDRRkoMf15LM1PaaneWCwgOoEU8hY3vb6tS5rl5EAzqhvY?=
 =?us-ascii?Q?l6DzYvQ6zzBQd7GKEoM6lgc7A7fDYQk7e0ARinMrw+pvPrAqhQQad4SvJvSa?=
 =?us-ascii?Q?QQhJTkzdyPCtTKld0AgC6rW0KpNGIA6RDX/FdVZGC2SkZH/dA6rRQv7wJgxR?=
 =?us-ascii?Q?W7NQVa4esNYQpC2GRI7NvYzfR0o/3nWGlKQ7CGbGeBnzPOHTtrG+SxZfCf33?=
 =?us-ascii?Q?OuZ4md2+zRN2cfVbgePjUHyabF4siA7St0LI8qNhG1CDbgrx4M4Wt3mfJX6D?=
 =?us-ascii?Q?s4jnHRVdCb+Sx+eWy3xIsvoetw/aRRd4/3CQkwSCkUp5rrYF/rR1zs7cm6+M?=
 =?us-ascii?Q?viB377SoOLcVD2KOFnNn1qw286o7Et4OlDgbvgbySRjKGxc208OJAUH/l+0I?=
 =?us-ascii?Q?p58R1+NgWz0D7EorXgfuyLv4Z3rrQMu6JUm7N4/LlrK6TGo4WzcTc+q4JzqP?=
 =?us-ascii?Q?Div+PxCdzq9RfHoSVRtbDTzMkzVT2BlGnXzH4YOP3XldHCfLHqKRgWWDX5nN?=
 =?us-ascii?Q?rbZk0U7PS9B7pfDhmUeJXahQ9vssBbpRfNh3o2Rn/9ytScb7sw/udTyvNebO?=
 =?us-ascii?Q?S1TaaFVT/WOCJU8HzvUJBWFZ7TfmtbY5T36gcw3Hm4BkjNGz17qhq+RTCC9s?=
 =?us-ascii?Q?UJfoSd8bWX38EtH98AK0RjXdIZ6OW9TcmKyJXlGOd6K1VEU9dy3Sp8pNROZ1?=
 =?us-ascii?Q?TCYz8mxmZWdUUEuQq83jYVZ7xo688Jp+apY6pPCAEKZ/t9QEe3Nj/dJrPhvK?=
 =?us-ascii?Q?7cZaUUSbzovLvP9MnxXLyePLSygXRw215babmB+5mZaqk/yGvS4QDPyr44a+?=
 =?us-ascii?Q?k76JdF0ymdGh1HVEfS0pI+8ZAKGhiScodAz84swrHfBgFJJZ9loeTVzMNJH6?=
 =?us-ascii?Q?onfqiKT6VSRY5Ekcpk8/Z7ErT7BncwGavKMwLQSDZ2ufd0EBZ/j3Ezb3+5Yd?=
 =?us-ascii?Q?HBCrlQYaevYggypj5YwP3uCSZDGnItlROeX7XgcAQiudBp/v9mkRnCly+/8V?=
 =?us-ascii?Q?XaFlPvYMweE6SY9+ArexanxnuFW4/CgNm2b6SQTgcNqydBjFAd79hVHSgq+Y?=
 =?us-ascii?Q?sQ=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fc8f8c5-74de-43f4-d4fd-08ddf54059c7
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 16:44:49.2076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kfb2F7eY5JGxEeBm1GNkbKQ9V3a1b49sZUNsWnz9/7PVAsmQjHrWzdv/2kDURRorPA4bvgb3doIt/FovgbKapqKFehkmedjUkkiXStEa6e0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB9620
X-Authority-Analysis: v=2.4 cv=WeUMa1hX c=1 sm=1 tr=0 ts=68c99403 cx=c_pps
 a=PAagVXhlguM9sGT4qHQNdg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8
 a=vznkB1AJNERqbbTUGssA:9
X-Proofpoint-ORIG-GUID: Fl-knJYFm-imAo8jnFBA6lRYfrWFYGLA
X-Proofpoint-GUID: Fl-knJYFm-imAo8jnFBA6lRYfrWFYGLA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDE1NSBTYWx0ZWRfXw/lAgKqcJkCS
 jeH7223nb3d6+ZQbiG7qrHRY2T2XfBzGHNaTu4n6yG8/IR6tGqzx/5P2k4lNLkU8s2+YJFTlWcY
 bm0OouXcxoGVEzYKzvKXA8dRBIVH2MunNNRFWh7SUFHSqDXmz2VPeN59eNZqc7VpslL+6yZwYF6
 4WSfgzAR4rfmxOnTH+9EohrB3hHAPoUc/QwEVoufOikzbiqJfLXOPQeXQiVGaBZ7EOuwkoIAdfF
 F+6edybkfSjsxlN8nJW2P3ivwZvQlN6W5DAdLftQGI/TWPgyrm/dcFtHHgSi1dM0rOZD8y5sg/d
 gdkHG8o5/Ap0Hr2oVPoOmDHEIf1J2bkSQOeKYUkUwFxiO0XZVI8QHDu0e7ZEMg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

Migrate to new vmx.h's primary processor-based VM-execution controls,
which makes it easier to grok from one code base to another.

Save secondary execution controls bit 31 for the next patch.

No functional change intended.

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 lib/linux/vmx.h |   1 +
 x86/vmx.c       |   2 +-
 x86/vmx.h       |  19 ------
 x86/vmx_tests.c | 157 ++++++++++++++++++++++++++----------------------
 4 files changed, 87 insertions(+), 92 deletions(-)

diff --git a/lib/linux/vmx.h b/lib/linux/vmx.h
index 5973bd86..f3c2aacc 100644
--- a/lib/linux/vmx.h
+++ b/lib/linux/vmx.h
@@ -16,6 +16,7 @@
 #include "libcflat.h"
 #include "trapnr.h"
 #include "util.h"
+#include "vmxfeatures.h"
 
 #define VMCS_CONTROL_BIT(x)	BIT(VMX_FEATURE_##x & 0x1f)
 
diff --git a/x86/vmx.c b/x86/vmx.c
index df9a23c7..c1845cea 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1258,7 +1258,7 @@ int init_vmcs(struct vmcs **vmcs)
 	ctrl_exit = EXI_LOAD_EFER | EXI_HOST_64 | EXI_LOAD_PAT;
 	ctrl_enter = (ENT_LOAD_EFER | ENT_GUEST_64);
 	/* DIsable IO instruction VMEXIT now */
-	ctrl_cpu[0] &= (~(CPU_IO | CPU_IO_BITMAP));
+	ctrl_cpu[0] &= (~(CPU_BASED_UNCOND_IO_EXITING | CPU_BASED_USE_IO_BITMAPS));
 	ctrl_cpu[1] = 0;
 
 	ctrl_pin = (ctrl_pin | ctrl_pin_rev.set) & ctrl_pin_rev.clr;
diff --git a/x86/vmx.h b/x86/vmx.h
index 4d13ad91..a83d08b8 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -436,25 +436,6 @@ enum Ctrl_pin {
 };
 
 enum Ctrl0 {
-	CPU_INTR_WINDOW		= 1ul << 2,
-	CPU_USE_TSC_OFFSET	= 1ul << 3,
-	CPU_HLT			= 1ul << 7,
-	CPU_INVLPG		= 1ul << 9,
-	CPU_MWAIT		= 1ul << 10,
-	CPU_RDPMC		= 1ul << 11,
-	CPU_RDTSC		= 1ul << 12,
-	CPU_CR3_LOAD		= 1ul << 15,
-	CPU_CR3_STORE		= 1ul << 16,
-	CPU_CR8_LOAD		= 1ul << 19,
-	CPU_CR8_STORE		= 1ul << 20,
-	CPU_TPR_SHADOW		= 1ul << 21,
-	CPU_NMI_WINDOW		= 1ul << 22,
-	CPU_IO			= 1ul << 24,
-	CPU_IO_BITMAP		= 1ul << 25,
-	CPU_MTF			= 1ul << 27,
-	CPU_MSR_BITMAP		= 1ul << 28,
-	CPU_MONITOR		= 1ul << 29,
-	CPU_PAUSE		= 1ul << 30,
 	CPU_SECONDARY		= 1ul << 31,
 };
 
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 5ca4b79b..55d151a4 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -266,7 +266,7 @@ static void msr_bmp_init(void)
 
 	msr_bitmap = alloc_page();
 	ctrl_cpu0 = vmcs_read(CPU_EXEC_CTRL0);
-	ctrl_cpu0 |= CPU_MSR_BITMAP;
+	ctrl_cpu0 |= CPU_BASED_USE_MSR_BITMAPS;
 	vmcs_write(CPU_EXEC_CTRL0, ctrl_cpu0);
 	vmcs_write(MSR_BITMAP, (u64)msr_bitmap);
 }
@@ -275,13 +275,13 @@ static void *get_msr_bitmap(void)
 {
 	void *msr_bitmap;
 
-	if (vmcs_read(CPU_EXEC_CTRL0) & CPU_MSR_BITMAP) {
+	if (vmcs_read(CPU_EXEC_CTRL0) & CPU_BASED_USE_MSR_BITMAPS) {
 		msr_bitmap = (void *)vmcs_read(MSR_BITMAP);
 	} else {
 		msr_bitmap = alloc_page();
 		memset(msr_bitmap, 0xff, PAGE_SIZE);
 		vmcs_write(MSR_BITMAP, (u64)msr_bitmap);
-		vmcs_set_bits(CPU_EXEC_CTRL0, CPU_MSR_BITMAP);
+		vmcs_set_bits(CPU_EXEC_CTRL0, CPU_BASED_USE_MSR_BITMAPS);
 	}
 
 	return msr_bitmap;
@@ -643,8 +643,8 @@ static int iobmp_init(struct vmcs *vmcs)
 	io_bitmap_a = alloc_page();
 	io_bitmap_b = alloc_page();
 	ctrl_cpu0 = vmcs_read(CPU_EXEC_CTRL0);
-	ctrl_cpu0 |= CPU_IO_BITMAP;
-	ctrl_cpu0 &= (~CPU_IO);
+	ctrl_cpu0 |= CPU_BASED_USE_IO_BITMAPS;
+	ctrl_cpu0 &= (~CPU_BASED_UNCOND_IO_EXITING);
 	vmcs_write(CPU_EXEC_CTRL0, ctrl_cpu0);
 	vmcs_write(IO_BITMAP_A, (u64)io_bitmap_a);
 	vmcs_write(IO_BITMAP_B, (u64)io_bitmap_b);
@@ -754,7 +754,8 @@ static int iobmp_exit_handler(union exit_reason exit_reason)
 		case 9:
 		case 10:
 			ctrl_cpu0 = vmcs_read(CPU_EXEC_CTRL0);
-			vmcs_write(CPU_EXEC_CTRL0, ctrl_cpu0 & ~CPU_IO);
+			vmcs_write(CPU_EXEC_CTRL0,
+				   ctrl_cpu0 & ~CPU_BASED_UNCOND_IO_EXITING);
 			vmx_inc_test_stage();
 			break;
 		default:
@@ -770,12 +771,14 @@ static int iobmp_exit_handler(union exit_reason exit_reason)
 		switch (vmx_get_test_stage()) {
 		case 9:
 			ctrl_cpu0 = vmcs_read(CPU_EXEC_CTRL0);
-			ctrl_cpu0 |= CPU_IO | CPU_IO_BITMAP;
+			ctrl_cpu0 |= CPU_BASED_UNCOND_IO_EXITING |
+				     CPU_BASED_USE_IO_BITMAPS;
 			vmcs_write(CPU_EXEC_CTRL0, ctrl_cpu0);
 			break;
 		case 10:
 			ctrl_cpu0 = vmcs_read(CPU_EXEC_CTRL0);
-			ctrl_cpu0 = (ctrl_cpu0 & ~CPU_IO_BITMAP) | CPU_IO;
+			ctrl_cpu0 = (ctrl_cpu0 & ~CPU_BASED_USE_IO_BITMAPS) |
+						 CPU_BASED_UNCOND_IO_EXITING;
 			vmcs_write(CPU_EXEC_CTRL0, ctrl_cpu0);
 			break;
 		default:
@@ -886,22 +889,25 @@ struct insn_table {
  */
 static struct insn_table insn_table[] = {
 	// Flags for Primary Processor-Based VM-Execution Controls
-	{"HLT",  CPU_HLT, insn_hlt, INSN_CPU0, 12, 0, 0, 0},
-	{"INVLPG", CPU_INVLPG, insn_invlpg, INSN_CPU0, 14,
+	{"HLT",  CPU_BASED_HLT_EXITING, insn_hlt, INSN_CPU0, 12, 0, 0, 0},
+	{"INVLPG", CPU_BASED_INVLPG_EXITING, insn_invlpg, INSN_CPU0, 14,
 		0x12345678, 0, FIELD_EXIT_QUAL},
-	{"MWAIT", CPU_MWAIT, insn_mwait, INSN_CPU0, 36, 0, 0, 0, this_cpu_has_mwait},
-	{"RDPMC", CPU_RDPMC, insn_rdpmc, INSN_CPU0, 15, 0, 0, 0, this_cpu_has_pmu},
-	{"RDTSC", CPU_RDTSC, insn_rdtsc, INSN_CPU0, 16, 0, 0, 0},
-	{"CR3 load", CPU_CR3_LOAD, insn_cr3_load, INSN_CPU0, 28, 0x3, 0,
-		FIELD_EXIT_QUAL},
-	{"CR3 store", CPU_CR3_STORE, insn_cr3_store, INSN_CPU0, 28, 0x13, 0,
-		FIELD_EXIT_QUAL},
-	{"CR8 load", CPU_CR8_LOAD, insn_cr8_load, INSN_CPU0, 28, 0x8, 0,
-		FIELD_EXIT_QUAL},
-	{"CR8 store", CPU_CR8_STORE, insn_cr8_store, INSN_CPU0, 28, 0x18, 0,
-		FIELD_EXIT_QUAL},
-	{"MONITOR", CPU_MONITOR, insn_monitor, INSN_CPU0, 39, 0, 0, 0, this_cpu_has_mwait},
-	{"PAUSE", CPU_PAUSE, insn_pause, INSN_CPU0, 40, 0, 0, 0},
+	{"MWAIT", CPU_BASED_MWAIT_EXITING, insn_mwait, INSN_CPU0, 36, 0, 0, 0,
+		this_cpu_has_mwait},
+	{"RDPMC", CPU_BASED_RDPMC_EXITING, insn_rdpmc, INSN_CPU0, 15, 0, 0, 0,
+		this_cpu_has_pmu},
+	{"RDTSC", CPU_BASED_RDTSC_EXITING, insn_rdtsc, INSN_CPU0, 16, 0, 0, 0},
+	{"CR3 load", CPU_BASED_CR3_LOAD_EXITING, insn_cr3_load, INSN_CPU0, 28,
+		0x3, 0, FIELD_EXIT_QUAL},
+	{"CR3 store", CPU_BASED_CR3_STORE_EXITING, insn_cr3_store, INSN_CPU0,
+		28, 0x13, 0, FIELD_EXIT_QUAL},
+	{"CR8 load", CPU_BASED_CR8_LOAD_EXITING, insn_cr8_load, INSN_CPU0, 28,
+		0x8, 0,	FIELD_EXIT_QUAL},
+	{"CR8 store", CPU_BASED_CR8_STORE_EXITING, insn_cr8_store, INSN_CPU0,
+		28, 0x18, 0, FIELD_EXIT_QUAL},
+	{"MONITOR", CPU_BASED_MONITOR_TRAP_FLAG, insn_monitor, INSN_CPU0, 39,
+		0, 0, 0, this_cpu_has_mwait},
+	{"PAUSE", CPU_BASED_PAUSE_EXITING, insn_pause, INSN_CPU0, 40, 0, 0, 0},
 	// Flags for Secondary Processor-Based VM-Execution Controls
 	{"WBINVD", CPU_WBINVD, insn_wbinvd, INSN_CPU1, 54, 0, 0, 0},
 	{"DESC_TABLE (SGDT)", CPU_DESC_TABLE, insn_sgdt, INSN_CPU1, 46, 0, 0, 0},
@@ -3814,10 +3820,10 @@ static void test_vmcs_addr_reference(u32 control_bit, enum Encoding field,
  */
 static void test_io_bitmaps(void)
 {
-	test_vmcs_addr_reference(CPU_IO_BITMAP, IO_BITMAP_A,
+	test_vmcs_addr_reference(CPU_BASED_USE_IO_BITMAPS, IO_BITMAP_A,
 				 "I/O bitmap A", "Use I/O bitmaps",
 				 PAGE_SIZE, false, true);
-	test_vmcs_addr_reference(CPU_IO_BITMAP, IO_BITMAP_B,
+	test_vmcs_addr_reference(CPU_BASED_USE_IO_BITMAPS, IO_BITMAP_B,
 				 "I/O bitmap B", "Use I/O bitmaps",
 				 PAGE_SIZE, false, true);
 }
@@ -3830,7 +3836,7 @@ static void test_io_bitmaps(void)
  */
 static void test_msr_bitmap(void)
 {
-	test_vmcs_addr_reference(CPU_MSR_BITMAP, MSR_BITMAP,
+	test_vmcs_addr_reference(CPU_BASED_USE_MSR_BITMAPS, MSR_BITMAP,
 				 "MSR bitmap", "Use MSR bitmaps",
 				 PAGE_SIZE, false, true);
 }
@@ -3851,8 +3857,9 @@ static void test_apic_virt_addr(void)
 	 * what we're trying to achieve and fails vmentry.
 	 */
 	u32 cpu_ctrls0 = vmcs_read(CPU_EXEC_CTRL0);
-	vmcs_write(CPU_EXEC_CTRL0, cpu_ctrls0 | CPU_CR8_LOAD | CPU_CR8_STORE);
-	test_vmcs_addr_reference(CPU_TPR_SHADOW, APIC_VIRT_ADDR,
+	vmcs_write(CPU_EXEC_CTRL0, cpu_ctrls0 | CPU_BASED_CR8_LOAD_EXITING |
+		   CPU_BASED_CR8_STORE_EXITING);
+	test_vmcs_addr_reference(CPU_BASED_TPR_SHADOW, APIC_VIRT_ADDR,
 				 "virtual-APIC address", "Use TPR shadow",
 				 PAGE_SIZE, false, true);
 	vmcs_write(CPU_EXEC_CTRL0, cpu_ctrls0);
@@ -3924,18 +3931,18 @@ static void test_apic_virtual_ctls(void)
 	/*
 	 * First test
 	 */
-	if (!((ctrl_cpu_rev[0].clr & (CPU_SECONDARY | CPU_TPR_SHADOW)) ==
-	    (CPU_SECONDARY | CPU_TPR_SHADOW)))
+	if (!((ctrl_cpu_rev[0].clr & (CPU_SECONDARY | CPU_BASED_TPR_SHADOW)) ==
+	    (CPU_SECONDARY | CPU_BASED_TPR_SHADOW)))
 		return;
 
 	primary |= CPU_SECONDARY;
-	primary &= ~CPU_TPR_SHADOW;
+	primary &= ~CPU_BASED_TPR_SHADOW;
 	vmcs_write(CPU_EXEC_CTRL0, primary);
 
 	while (1) {
 		for (j = 1; j < 8; j++) {
 			secondary &= ~(CPU_VIRT_X2APIC | CPU_APIC_REG_VIRT | CPU_VINTD);
-			if (primary & CPU_TPR_SHADOW) {
+			if (primary & CPU_BASED_TPR_SHADOW) {
 				is_ctrl_valid = true;
 			} else {
 				if (! set_bit_pattern(j, &secondary))
@@ -3958,7 +3965,7 @@ static void test_apic_virtual_ctls(void)
 			break;
 		i++;
 
-		primary |= CPU_TPR_SHADOW;
+		primary |= CPU_BASED_TPR_SHADOW;
 		vmcs_write(CPU_EXEC_CTRL0, primary);
 		strcpy(str, "enabled");
 	}
@@ -4017,7 +4024,8 @@ static void test_virtual_intr_ctls(void)
 	    (ctrl_pin_rev.clr & PIN_EXTINT)))
 		return;
 
-	vmcs_write(CPU_EXEC_CTRL0, primary | CPU_SECONDARY | CPU_TPR_SHADOW);
+	vmcs_write(CPU_EXEC_CTRL0, primary | CPU_SECONDARY |
+		   CPU_BASED_TPR_SHADOW);
 	vmcs_write(CPU_EXEC_CTRL1, secondary & ~CPU_VINTD);
 	vmcs_write(PIN_CONTROLS, pin & ~PIN_EXTINT);
 	report_prefix_pushf("Virtualize interrupt-delivery disabled; external-interrupt exiting disabled");
@@ -4086,7 +4094,8 @@ static void test_posted_intr(void)
 	    (ctrl_exit_rev.clr & EXI_INTA)))
 		return;
 
-	vmcs_write(CPU_EXEC_CTRL0, primary | CPU_SECONDARY | CPU_TPR_SHADOW);
+	vmcs_write(CPU_EXEC_CTRL0, primary | CPU_SECONDARY |
+		   CPU_BASED_TPR_SHADOW);
 
 	/*
 	 * Test virtual-interrupt-delivery and acknowledge-interrupt-on-exit
@@ -4237,7 +4246,7 @@ static void try_tpr_threshold_and_vtpr(unsigned threshold, unsigned vtpr)
 	u32 primary = vmcs_read(CPU_EXEC_CTRL0);
 	u32 secondary = vmcs_read(CPU_EXEC_CTRL1);
 
-	if ((primary & CPU_TPR_SHADOW) &&
+	if ((primary & CPU_BASED_TPR_SHADOW) &&
 	    (!(primary & CPU_SECONDARY) ||
 	     !(secondary & (CPU_VINTD | CPU_VIRT_APIC_ACCESSES))))
 		valid = (threshold & 0xf) <= ((vtpr >> 4) & 0xf);
@@ -4571,7 +4580,7 @@ static void try_tpr_threshold(unsigned threshold)
 	u32 primary = vmcs_read(CPU_EXEC_CTRL0);
 	u32 secondary = vmcs_read(CPU_EXEC_CTRL1);
 
-	if ((primary & CPU_TPR_SHADOW) && !((primary & CPU_SECONDARY) &&
+	if ((primary & CPU_BASED_TPR_SHADOW) && !((primary & CPU_SECONDARY) &&
 	    (secondary & CPU_VINTD)))
 		valid = !(threshold >> 4);
 
@@ -4627,18 +4636,20 @@ static void test_tpr_threshold(void)
 	u64 threshold = vmcs_read(TPR_THRESHOLD);
 	void *virtual_apic_page;
 
-	if (!(ctrl_cpu_rev[0].clr & CPU_TPR_SHADOW))
+	if (!(ctrl_cpu_rev[0].clr & CPU_BASED_TPR_SHADOW))
 		return;
 
 	virtual_apic_page = alloc_page();
 	memset(virtual_apic_page, 0xff, PAGE_SIZE);
 	vmcs_write(APIC_VIRT_ADDR, virt_to_phys(virtual_apic_page));
 
-	vmcs_write(CPU_EXEC_CTRL0, primary & ~(CPU_TPR_SHADOW | CPU_SECONDARY));
+	vmcs_write(CPU_EXEC_CTRL0, primary & ~(CPU_BASED_TPR_SHADOW |
+		   CPU_SECONDARY));
 	report_prefix_pushf("Use TPR shadow disabled, secondary controls disabled");
 	test_tpr_threshold_values();
 	report_prefix_pop();
-	vmcs_write(CPU_EXEC_CTRL0, vmcs_read(CPU_EXEC_CTRL0) | CPU_TPR_SHADOW);
+	vmcs_write(CPU_EXEC_CTRL0, vmcs_read(CPU_EXEC_CTRL0) |
+		   CPU_BASED_TPR_SHADOW);
 	report_prefix_pushf("Use TPR shadow enabled, secondary controls disabled");
 	test_tpr_threshold_values();
 	report_prefix_pop();
@@ -4727,7 +4738,7 @@ static void test_nmi_ctrls(void)
 	cpu_ctrls0 = vmcs_read(CPU_EXEC_CTRL0);
 
 	test_pin_ctrls = pin_ctrls & ~(PIN_NMI | PIN_VIRT_NMI);
-	test_cpu_ctrls0 = cpu_ctrls0 & ~CPU_NMI_WINDOW;
+	test_cpu_ctrls0 = cpu_ctrls0 & ~CPU_BASED_NMI_WINDOW_EXITING;
 
 	vmcs_write(PIN_CONTROLS, test_pin_ctrls);
 	report_prefix_pushf("NMI-exiting disabled, virtual-NMIs disabled");
@@ -4749,13 +4760,14 @@ static void test_nmi_ctrls(void)
 	test_vmx_valid_controls();
 	report_prefix_pop();
 
-	if (!(ctrl_cpu_rev[0].clr & CPU_NMI_WINDOW)) {
+	if (!(ctrl_cpu_rev[0].clr & CPU_BASED_NMI_WINDOW_EXITING)) {
 		report_info("NMI-window exiting is not supported, skipping...");
 		goto done;
 	}
 
 	vmcs_write(PIN_CONTROLS, test_pin_ctrls);
-	vmcs_write(CPU_EXEC_CTRL0, test_cpu_ctrls0 | CPU_NMI_WINDOW);
+	vmcs_write(CPU_EXEC_CTRL0, test_cpu_ctrls0 |
+		   CPU_BASED_NMI_WINDOW_EXITING);
 	report_prefix_pushf("Virtual-NMIs disabled, NMI-window-exiting enabled");
 	test_vmx_invalid_controls();
 	report_prefix_pop();
@@ -4767,7 +4779,8 @@ static void test_nmi_ctrls(void)
 	report_prefix_pop();
 
 	vmcs_write(PIN_CONTROLS, test_pin_ctrls | (PIN_NMI | PIN_VIRT_NMI));
-	vmcs_write(CPU_EXEC_CTRL0, test_cpu_ctrls0 | CPU_NMI_WINDOW);
+	vmcs_write(CPU_EXEC_CTRL0, test_cpu_ctrls0 |
+		   CPU_BASED_NMI_WINDOW_EXITING);
 	report_prefix_pushf("Virtual-NMIs enabled, NMI-window-exiting enabled");
 	test_vmx_valid_controls();
 	report_prefix_pop();
@@ -5121,14 +5134,14 @@ static void enable_mtf(void)
 {
 	u32 ctrl0 = vmcs_read(CPU_EXEC_CTRL0);
 
-	vmcs_write(CPU_EXEC_CTRL0, ctrl0 | CPU_MTF);
+	vmcs_write(CPU_EXEC_CTRL0, ctrl0 | CPU_BASED_MONITOR_TRAP_FLAG);
 }
 
 static void disable_mtf(void)
 {
 	u32 ctrl0 = vmcs_read(CPU_EXEC_CTRL0);
 
-	vmcs_write(CPU_EXEC_CTRL0, ctrl0 & ~CPU_MTF);
+	vmcs_write(CPU_EXEC_CTRL0, ctrl0 & ~CPU_BASED_MONITOR_TRAP_FLAG);
 }
 
 static void enable_tf(void)
@@ -5159,7 +5172,7 @@ static void vmx_mtf_test(void)
 	unsigned long pending_dbg;
 	handler old_gp, old_db;
 
-	if (!(ctrl_cpu_rev[0].clr & CPU_MTF)) {
+	if (!(ctrl_cpu_rev[0].clr & CPU_BASED_MONITOR_TRAP_FLAG)) {
 		report_skip("%s : \"Monitor trap flag\" exec control not supported", __func__);
 		return;
 	}
@@ -5262,7 +5275,7 @@ static void vmx_mtf_pdpte_test(void)
 	if (setup_ept(false))
 		return;
 
-	if (!(ctrl_cpu_rev[0].clr & CPU_MTF)) {
+	if (!(ctrl_cpu_rev[0].clr & CPU_BASED_MONITOR_TRAP_FLAG)) {
 		report_skip("%s : \"Monitor trap flag\" exec control not supported", __func__);
 		return;
 	}
@@ -6185,13 +6198,13 @@ static enum Config_type configure_apic_reg_virt_test(
 	}
 
 	if (apic_reg_virt_config->use_tpr_shadow) {
-		if (!(ctrl_cpu_rev[0].clr & CPU_TPR_SHADOW)) {
+		if (!(ctrl_cpu_rev[0].clr & CPU_BASED_TPR_SHADOW)) {
 			printf("VM-execution control \"use TPR shadow\" NOT supported.\n");
 			return CONFIG_TYPE_UNSUPPORTED;
 		}
-		cpu_exec_ctrl0 |= CPU_TPR_SHADOW;
+		cpu_exec_ctrl0 |= CPU_BASED_TPR_SHADOW;
 	} else {
-		cpu_exec_ctrl0 &= ~CPU_TPR_SHADOW;
+		cpu_exec_ctrl0 &= ~CPU_BASED_TPR_SHADOW;
 	}
 
 	if (apic_reg_virt_config->apic_register_virtualization) {
@@ -6968,9 +6981,9 @@ static enum Config_type configure_virt_x2apic_mode_test(
 	/* x2apic-specific VMCS config */
 	if (virt_x2apic_mode_config->use_msr_bitmaps) {
 		/* virt_x2apic_mode_test() checks for MSR bitmaps support */
-		cpu_exec_ctrl0 |= CPU_MSR_BITMAP;
+		cpu_exec_ctrl0 |= CPU_BASED_USE_MSR_BITMAPS;
 	} else {
-		cpu_exec_ctrl0 &= ~CPU_MSR_BITMAP;
+		cpu_exec_ctrl0 &= ~CPU_BASED_USE_MSR_BITMAPS;
 	}
 
 	if (virt_x2apic_mode_config->virtual_interrupt_delivery) {
@@ -7035,10 +7048,10 @@ static void virt_x2apic_mode_test(void)
 	 *   - "Virtual-APIC address", indicated by "use TPR shadow"
 	 *   - "MSR-bitmap address", indicated by "use MSR bitmaps"
 	 */
-	if (!(ctrl_cpu_rev[0].clr & CPU_TPR_SHADOW)) {
+	if (!(ctrl_cpu_rev[0].clr & CPU_BASED_TPR_SHADOW)) {
 		report_skip("%s : \"Use TPR shadow\" exec control not supported", __func__);
 		return;
-	} else if (!(ctrl_cpu_rev[0].clr & CPU_MSR_BITMAP)) {
+	} else if (!(ctrl_cpu_rev[0].clr & CPU_BASED_USE_MSR_BITMAPS)) {
 		report_skip("%s : \"Use MSR bitmaps\" exec control not supported", __func__);
 		return;
 	}
@@ -8673,7 +8686,7 @@ static void vmx_nmi_window_test(void)
 		return;
 	}
 
-	if (!(ctrl_cpu_rev[0].clr & CPU_NMI_WINDOW)) {
+	if (!(ctrl_cpu_rev[0].clr & CPU_BASED_NMI_WINDOW_EXITING)) {
 		report_skip("%s : \"NMI-window exiting\" exec control not supported", __func__);
 		return;
 	}
@@ -8692,7 +8705,7 @@ static void vmx_nmi_window_test(void)
 	 * RIP will not advance.
 	 */
 	report_prefix_push("active, no blocking");
-	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_NMI_WINDOW);
+	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_BASED_NMI_WINDOW_EXITING);
 	enter_guest();
 	verify_nmi_window_exit(nop_addr);
 	report_prefix_pop();
@@ -8764,7 +8777,7 @@ static void vmx_nmi_window_test(void)
 		report_prefix_pop();
 	}
 
-	vmcs_clear_bits(CPU_EXEC_CTRL0, CPU_NMI_WINDOW);
+	vmcs_clear_bits(CPU_EXEC_CTRL0, CPU_BASED_NMI_WINDOW_EXITING);
 	enter_guest();
 	report_prefix_pop();
 }
@@ -8804,7 +8817,7 @@ static void vmx_intr_window_test(void)
 	unsigned int orig_db_gate_type;
 	void *db_fault_addr = get_idt_addr(&boot_idt[DB_VECTOR]);
 
-	if (!(ctrl_cpu_rev[0].clr & CPU_INTR_WINDOW)) {
+	if (!(ctrl_cpu_rev[0].clr & CPU_BASED_INTR_WINDOW_EXITING)) {
 		report_skip("%s : \"Interrupt-window exiting\" exec control not supported", __func__);
 		return;
 	}
@@ -8830,7 +8843,7 @@ static void vmx_intr_window_test(void)
 	 * point to the vmcall instruction.
 	 */
 	report_prefix_push("active, no blocking, RFLAGS.IF=1");
-	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_INTR_WINDOW);
+	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_BASED_INTR_WINDOW_EXITING);
 	vmcs_write(GUEST_RFLAGS, X86_EFLAGS_FIXED | X86_EFLAGS_IF);
 	enter_guest();
 	verify_intr_window_exit(vmcall_addr);
@@ -8857,11 +8870,11 @@ static void vmx_intr_window_test(void)
 	 * VM-exits. Then, advance past the VMCALL and set the
 	 * "interrupt-window exiting" VM-execution control again.
 	 */
-	vmcs_clear_bits(CPU_EXEC_CTRL0, CPU_INTR_WINDOW);
+	vmcs_clear_bits(CPU_EXEC_CTRL0, CPU_BASED_INTR_WINDOW_EXITING);
 	enter_guest();
 	skip_exit_vmcall();
 	nop_addr = vmcs_read(GUEST_RIP);
-	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_INTR_WINDOW);
+	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_BASED_INTR_WINDOW_EXITING);
 
 	/*
 	 * Ask for "interrupt-window exiting" in a MOV-SS shadow with
@@ -8932,7 +8945,7 @@ static void vmx_intr_window_test(void)
 	}
 
 	boot_idt[DB_VECTOR].type = orig_db_gate_type;
-	vmcs_clear_bits(CPU_EXEC_CTRL0, CPU_INTR_WINDOW);
+	vmcs_clear_bits(CPU_EXEC_CTRL0, CPU_BASED_INTR_WINDOW_EXITING);
 	enter_guest();
 	report_prefix_pop();
 }
@@ -8956,14 +8969,14 @@ static void vmx_store_tsc_test(void)
 	struct vmx_msr_entry msr_entry = { .index = MSR_IA32_TSC };
 	u64 low, high;
 
-	if (!(ctrl_cpu_rev[0].clr & CPU_USE_TSC_OFFSET)) {
+	if (!(ctrl_cpu_rev[0].clr & CPU_BASED_USE_TSC_OFFSETTING)) {
 		report_skip("%s : \"Use TSC offsetting\" exec control not supported", __func__);
 		return;
 	}
 
 	test_set_guest(vmx_store_tsc_test_guest);
 
-	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_USE_TSC_OFFSET);
+	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_BASED_USE_TSC_OFFSETTING);
 	vmcs_write(EXI_MSR_ST_CNT, 1);
 	vmcs_write(EXIT_MSR_ST_ADDR, virt_to_phys(&msr_entry));
 	vmcs_write(TSC_OFFSET, GUEST_TSC_OFFSET);
@@ -9506,7 +9519,7 @@ static void enable_vid(void)
 	vmcs_write(EOI_EXIT_BITMAP2, 0x0);
 	vmcs_write(EOI_EXIT_BITMAP3, 0x0);
 
-	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_SECONDARY | CPU_TPR_SHADOW);
+	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_SECONDARY | CPU_BASED_TPR_SHADOW);
 	vmcs_set_bits(CPU_EXEC_CTRL1, CPU_VINTD | CPU_VIRT_X2APIC);
 }
 
@@ -10388,7 +10401,7 @@ static void vmx_vmcs_shadow_test(void)
 	shadow->hdr.shadow_vmcs = 1;
 	TEST_ASSERT(!vmcs_clear(shadow));
 
-	vmcs_clear_bits(CPU_EXEC_CTRL0, CPU_RDTSC);
+	vmcs_clear_bits(CPU_EXEC_CTRL0, CPU_BASED_RDTSC_EXITING);
 	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_SECONDARY);
 	vmcs_set_bits(CPU_EXEC_CTRL1, CPU_SHADOW_VMCS);
 
@@ -10423,7 +10436,7 @@ static void vmx_vmcs_shadow_test(void)
  */
 static void reset_guest_tsc_to_zero(void)
 {
-	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_USE_TSC_OFFSET);
+	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_BASED_USE_TSC_OFFSETTING);
 	vmcs_write(TSC_OFFSET, -rdtsc());
 }
 
@@ -10446,7 +10459,7 @@ static unsigned long long host_time_to_guest_time(unsigned long long t)
 	TEST_ASSERT(!(ctrl_cpu_rev[0].clr & CPU_SECONDARY) ||
 		    !(vmcs_read(CPU_EXEC_CTRL1) & CPU_USE_TSC_SCALING));
 
-	if (vmcs_read(CPU_EXEC_CTRL0) & CPU_USE_TSC_OFFSET)
+	if (vmcs_read(CPU_EXEC_CTRL0) & CPU_BASED_USE_TSC_OFFSETTING)
 		t += vmcs_read(TSC_OFFSET);
 
 	return t;
@@ -10470,7 +10483,7 @@ static void rdtsc_vmexit_diff_test(void)
 	int fail = 0;
 	int i;
 
-	if (!(ctrl_cpu_rev[0].clr & CPU_USE_TSC_OFFSET))
+	if (!(ctrl_cpu_rev[0].clr & CPU_BASED_USE_TSC_OFFSETTING))
 		test_skip("CPU doesn't support the 'use TSC offsetting' processor-based VM-execution control.\n");
 
 	test_set_guest(rdtsc_vmexit_diff_test_guest);
@@ -10691,9 +10704,9 @@ static void __vmx_pf_exception_test(invalidate_tlb_t inv_fn, void *data,
 
 	/* Intercept INVLPG when to perform TLB invalidation from L1 (this). */
 	if (inv_fn)
-		vmcs_set_bits(CPU_EXEC_CTRL0, CPU_INVLPG);
+		vmcs_set_bits(CPU_EXEC_CTRL0, CPU_BASED_INVLPG_EXITING);
 	else
-		vmcs_clear_bits(CPU_EXEC_CTRL0, CPU_INVLPG);
+		vmcs_clear_bits(CPU_EXEC_CTRL0, CPU_BASED_INVLPG_EXITING);
 
 	enter_guest();
 
-- 
2.43.0


