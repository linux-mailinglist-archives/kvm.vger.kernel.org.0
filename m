Return-Path: <kvm+bounces-57748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A173FB59E0A
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:45:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D553A1C02D09
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:46:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94951301717;
	Tue, 16 Sep 2025 16:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="nADFfkEe";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="yzG9C/XJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7B82F2605
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 16:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758041100; cv=fail; b=TDuNJElr6V/gTmSzvCh4jcNwwM2nPlPAGgjdagBe6ZASnfVS93Tl3dcg0jfH9L16BAbCVzlXUXOgkdg7CFIVeQt484aBB1PVH6rZkPPeJnz36tufVP61jC75he3khJD+VdCfJcqfcH87YEqpH37wsl8vniInqZbI9YdVMu1WBaE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758041100; c=relaxed/simple;
	bh=92Is2Z7xD83mNu6eUOeGc1C4082y2BBqhruxK5MBuWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nMpR2pz7QSNK1H+0mWaC2Cm2eOB6bqIKvKugvvnZqm/EfNN5pI+/PedsRKmNo4xU0Gknp5jba3w3g86q3mWWaDIKftJjTn5pnei9xPbMGA+j46AiTmZYDZsLsjcaDxMkLlOoh5cyo01sSIJ5641Kgbda/m4w742JuKkLdo6BD9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=nADFfkEe; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=yzG9C/XJ; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58GGEKKC3512374;
	Tue, 16 Sep 2025 09:44:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=S2VIduQjeWHkO/dx3t+yFZ6HUK7FBR9c/AyjpdO4k
	/g=; b=nADFfkEe6smdj/UjNTsS0mlnsYfYUOtbNew91sgqNc+WRR/T44/Kd02JK
	HyD5JLnZTOgL8ZXmlG5jsLCs/ty4wF5bCMDlfzxVVDWZ7vUh5Ax4cXazvZCU71IF
	J9zBadbr/8bd++7lmOC15ykTYQUhGNHpkfCrd5AmghaD+GHXCxnG+n+klpQsF6Fj
	ygnAst7qIEbIh3nYGQJ6wY4mdo8gyOh2oYLLh3Q1hsYSU5XQI81bpHx9rEPjGYaB
	aHp7pxy91/5aOE44N1mW5OYUBLZSXYqWYwXazyC/seRgPEDTcofhSra7RMbNE2ky
	M9sJroW8xw5yqh2t8mxYceyGW2ALA==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11022085.outbound.protection.outlook.com [40.107.209.85])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 496hywbjks-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 09:44:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T+cWC8HpDInJfl+9Qq4cZgwablu+9ZiwZlBAPFzLNaiZUrD5dHYZnsbeKstehNClD//wo5wbgaqQAitGWZFixM5rHmgYE9D+AckM7y5IJ4y6C4xed7Y+yzXUHFpQORBdTes2ACE6A0IhUvcYC+LN17zJxfYH3klhLJyenQydSnF8ZqQ6QENDXYDMi59NmOgwtAGjXPODRYq0ZC3QaJcNDq9iJ9e6Qj+Kga0X9lbbDXgWGPEMuZh+JNUbxNeB96S3V1sUyJvr/4gDSYrDxUm9ZnJIx+VgN002zq7itWN6SNU7HLnB6yYxANYHUtIKAXycM22o8N3U9ori8/4mpr6XPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S2VIduQjeWHkO/dx3t+yFZ6HUK7FBR9c/AyjpdO4k/g=;
 b=L4QQpGsLGiN9DVRbN8m3cr/ls9dk6RIpDdevcWikfG3vB5r3B6eSzXMrOqJCf4ccozsKlBLjxU+LCmxnNZZIVNH5TSPGHmcrJiK8fA5wABFrlWR9hLUdOCaETWIhGbc/AcZUOsMDbu/mdF4KlYV2q4WxwDfQl5DenZnywFfcHFSsqGfqKJO/CfBIqb4KsOkDRn5s3tLmfzABoOZQsadKYPnBCm4tJ2cuxOEbj80DUIzcMZ5pm+Cr1qcQvE4QsNW/G6fVQnixjJefx1ieRH2q/g6Mlbr9H9bgpIBAjjL9WB3a87YB5V7tNsH+YEvyDtqfbcfTqe6FbBDZmZpRMVmzIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S2VIduQjeWHkO/dx3t+yFZ6HUK7FBR9c/AyjpdO4k/g=;
 b=yzG9C/XJdZgFhwGAR7w5XUZPnFcDl2UfojrMyN+LoOR3HgFntk9PeS4ucUh9U4oFOAOHX/uDDiXUvslHpOllpGGl+ofY4nLNq9F+yb0fDJYQPnJYyumEHel0wGzWedvRwQXTD4UQHKrVONaa8xZTCYMOD8WOrSccEd/hj8F7Cuyqnez0D7afkFffXWdjZr/Q5+w96dVLwpMKVkZ91y3Xpjb8N2XUP7mut7tDRwIRTGt+d+tEPupqRZV4UdiR3K08Ctob+bGUgq5yNwhfCBkQri1pGoX4hs/KgJ3YN3gQs/JpSLlVMD4bAkieVnWacwZMzr8l7APbJ4QcnjjjpMxQBQ==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by DS0PR02MB9620.namprd02.prod.outlook.com
 (2603:10b6:8:f7::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 16:44:48 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 16:44:48 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 09/17] x86/vmx: switch to new vmx.h EPT capability and memory type defs
Date: Tue, 16 Sep 2025 10:22:38 -0700
Message-ID: <20250916172247.610021-10-jon@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: ee5bac64-3825-4716-5f3e-08ddf540592d
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QA9KADhcVoRXcUzIDaxzf7IvsZrAhO1s69MlwqP9dnEYSOPGit8hP38VS/ez?=
 =?us-ascii?Q?Ox/+Q4jbZAo1rSIhAVKLF5BZ1Pm331rR2rEdVT65k5mLxXfcF14E7x1msVdM?=
 =?us-ascii?Q?l+LHbE2FN4h9W5l9jIbSzNHriLSfkZpS6Mcjiuce5YpAgskUgZPpsmKLzvfu?=
 =?us-ascii?Q?nSKWMDKwFpWhQfbv9AjXiPe3SiCvgHf3ERKSAfsJh5jPVjYNjj26Bo1bCvBr?=
 =?us-ascii?Q?31R1M9lWH24kYe754k6akoMx0OTBr4fieXBJbl2Ur1Q0dNmCBTvGb+3c1i0J?=
 =?us-ascii?Q?1ndiLMhTI29FXjEAgnI9HJQd7cwDF3s+CVd62tdDI6OcJFhnbhCgYuihnzGy?=
 =?us-ascii?Q?C/d+H6tllLoM88K7zi+FgjM1p9SwG8gc3gkgIZ4gF/Lh6es68hTqCzTlP3NK?=
 =?us-ascii?Q?v1UfckSyk/DPeJkGVzoYJAp3lMnTHY3d0Dd1RH24hYzcImKxw6RkgAVsvzDz?=
 =?us-ascii?Q?X+WIppUsgQcC4TZySNRH+/hhCw2YRyBJPHw7WzPWKQVsKI7Fb5VNN5xoZUTh?=
 =?us-ascii?Q?KCk4gAK4+iVw5/L7g8vfHzhqwHmM/Oory8lNsaZhWADGECX6923l9pqbc927?=
 =?us-ascii?Q?IFqqLOkyHYRX8wvJY0F9C2NABN0/xF3XIgfKJClk50WiGWHBL1vtkQpVtApw?=
 =?us-ascii?Q?Ne+7xv4HI+yFC8TqTv3NwYWrSca2EdvLYM+Eset9D++EkUFmuGsbIUJxLZ02?=
 =?us-ascii?Q?Av3bZXoDifNHEysJrbbaglbb9o6Z2Hc1sf5pkOLG4+53pSMxcp7O/MPxL2U1?=
 =?us-ascii?Q?v/vzCF2CXNVFDW0+eBc3nzuZJ8r+9IhB85v/0Jir3jKbu9TcsifGub299RY3?=
 =?us-ascii?Q?Av6NyJkZuibmodZ7Zz1t7BSky9H0UFluzacThW6ArM4/gExMpk2Q/QitdoAy?=
 =?us-ascii?Q?uSkVxWkh0YOUMQTD1yJKek+Ut5Ql4HrXpqM7ip0OmvgThJ6Dmst9U9vraBKW?=
 =?us-ascii?Q?CaLyzeusmM8ATYb+PWbZFUJm6PrurmMeiN7oQFPhIgKuAc/P7uYlNbzV3liD?=
 =?us-ascii?Q?MeRIRIBUtyRQWxKhf53LA0AHajf9DK0G4Qf7z8R1cK3EeX4RnDpCZabc9RBH?=
 =?us-ascii?Q?lZRjZFoZmCo3nR9iJiGNB0fSd5oSG992pZwDheimrQyiJU7UIVk5PiIc3Ckm?=
 =?us-ascii?Q?f+HAAuMQt3ZVS2/OKkPIkBlnFJtJQMHfHgJoLYSr43BZxHhg/vWhvLG2pCJ1?=
 =?us-ascii?Q?d59RYbaGI1/O5ScXeMhEILs1D6Ogrg2yof5WMPAZeBlxKTpkRL8agyPxazlG?=
 =?us-ascii?Q?cs4Op3m8GC/1yEMRRtRtmZW9eLwRNhemMeXGD8CMDzKtxX3mPBhnacq5kBSb?=
 =?us-ascii?Q?f454KV/tY928ECazP6FnEhpL5XdeZKEX51La9soiTI6W2SuZdS6JYewXvCVd?=
 =?us-ascii?Q?LdEP/RB2tOT7ysRmDkKCNULG7SGazfA7/NS5iz/iZBD4WLqFV6Pr0H/nBlXk?=
 =?us-ascii?Q?/ohHXXQf/LoMwqmyhhU35iMQPfHJrUdJEcmvhhIgOv2vsonpjzrpMw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VKKS8GxySB80uuUz1ObxxxpGrKAsqhVYazQhZMRh4Oib6WMfJ10iis2iS48/?=
 =?us-ascii?Q?XjZvB3r5kYcBolywPybKPRJzGykuPfieCswyeR64VNArTNJuJVil4Z/fS4a5?=
 =?us-ascii?Q?dhNP50TNKtrzZdysJEWowgxf3ueur9nPVc9bvhqubNIt5p6t80HczHoZmNzj?=
 =?us-ascii?Q?C3uDJE7ITMOza9P/JG6jbPnIP+ZN0Kz1BPrtkVxJ6jPzJ46bRSWNecFkH/b1?=
 =?us-ascii?Q?/6gf/hE9tfT9+mklwibTv3vaHjaBs0sm5pVbBDgiLI+tjH0Bn6k97Fg3xxUd?=
 =?us-ascii?Q?jfoe21kpURpToLlpIBuq2t/KspAjRpRGpxO5Xx9+D7D/OksiXE22faqn/h/5?=
 =?us-ascii?Q?dqDbUqhyUxmBYJGF2NGU3TaFevvBl3diu/EBkxzDj7RCXOu7U3RFF0LVE5n5?=
 =?us-ascii?Q?K8YgR2t0HTfCLZVM6ut+SzURyixP7FhBjCInIMh2rQXlQytddw0EwjnVPyJx?=
 =?us-ascii?Q?6a4IWZKWKdksacVkyFV8ywwLTCe+urhHHOL4uCTu0RRA5yobCi/6VEBgCTFR?=
 =?us-ascii?Q?8CXieDspucxkmulXO4yIYcYjG3cy+rmtchRuglOJiT7XgNFw/I2WYGby0Tah?=
 =?us-ascii?Q?adLyj3E1uH43bPM8r4A9WffNO++AnkHrFgDhzKstZhIrSAaWQJELer+NwGvN?=
 =?us-ascii?Q?W9ZZqz4hDopmxP4yTaPRXYE7vfUiX08UeiA3LucyI+2nY65+k4LiUgeYKAD3?=
 =?us-ascii?Q?AQWbeHavnw5B/arecEWGECbTLbyeaY4FI/e0oB8mN3HtHRiH8qZSMlwpGLwj?=
 =?us-ascii?Q?wS4TlO9yQ5PqoNu8sld94s0fqZqtNTUf/IQmynSgCG13I8b/m46OEnZcXpwZ?=
 =?us-ascii?Q?rezEXeB0bsNwtJbVoP9mp7TBSWo0S/d0i7BGEGqetM0GueclK+VaBIs0w3LZ?=
 =?us-ascii?Q?v/GRH3/SmVqaTAjSOdTqoJCpIntsOLjmYMMYHMzLasRxEndTVTY5MB8AGKgg?=
 =?us-ascii?Q?MzncaJa1nU2HMEehC5FARMi9/n2yQjvYHbHUvabkvDp5ioA4vWLbxEWv0H+h?=
 =?us-ascii?Q?nz51xUmQLndMWRh9CfiC9lSiZRvyiJCABdrEJ17P+CCt1I06P5eNY8XftSNQ?=
 =?us-ascii?Q?UdvBUYW77KQrmK1dZSTdtL4t9oSaREjwMBkwyGxFq4cnqRd8pB+MpDRyIc7X?=
 =?us-ascii?Q?vWtgnqxWUAModEWfOrkdVIvC4xJ63nYi0lJwpgIyF7IHZa0WitVyTnFfNJQt?=
 =?us-ascii?Q?+ZcSYPYnJdKTHHNR1cZIxmxuol8SW5mg5tahjPNBRoKHJ8Xhk2ZyCcJN5wu5?=
 =?us-ascii?Q?d88Wkc5/wqou0vNSaMvSqHPpN/aqcrgHFAxBHTyMSpMOdXzlWIyd7y7ahiHE?=
 =?us-ascii?Q?whKUOGAX28qrIcozERnPTF1wv9GdMuYBLHp0g7TwhOBK8JjzyRwHCi/ToQPr?=
 =?us-ascii?Q?8aFwteXxt5r44QiMJuBqIdIyNm27pHoHBAmHzk9DXshbzY7bP90M4KlBPH+o?=
 =?us-ascii?Q?u/NEsA4Rj6LuUtCbBz1GRzJKy+dmVNA/PDcmKwCnzCMXBVWMo2NbPvJW5GSc?=
 =?us-ascii?Q?dxhkNZ8lQxOTzM7HKmAx0+kzs+iQm7Ogn2R8ANObvbtzoCdUrHAO/T3jKdhJ?=
 =?us-ascii?Q?6amgDBftkSpR8FymPNCB4CKs7N5nANpwI9e0FnAi5NjNLHbDvtDdCvqhkmo0?=
 =?us-ascii?Q?iA=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee5bac64-3825-4716-5f3e-08ddf540592d
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 16:44:48.1036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pSazwUZJro66OsTd+7G53FqlHtz7aX4vzBuDwcsSJn5zRm3GtXl00Llwl7r4BZY/dAYLCy6TjdFwgqSDYRYT8uwRdyxS8guRETBZs/1grk0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB9620
X-Proofpoint-ORIG-GUID: 0poZPPOhR1FVxVw46uOPOCpW0BYd8aSY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDE1NSBTYWx0ZWRfX40P5SEXKre2x
 G/NMYbWm5PwDzdM7sx/9YOarH/6x1947FmhcLQFdeFmqRHIaeGT2hi9FqDIXumY+fIjDcchuYzr
 pf/UwaS4BTfOpou6yWTOzPy/jAvZZWcAjyRB5o5hj3JBNsFivpwRMxmboe0Ys0sAf/GnKhHn5nC
 7f8l3fy7I2igDd6E4GN1rH/wEG9cC9msTrsF4HnHlnSnLpOdXS/3rvRNXAXWBZXk9BnM0g0Dbs3
 kNui9ilpkqfR+49JK7w1MEllXDSfidl+aN0mFzW+IvooxvIEOdox93qFGxVfeY3n/KxxvT6nSCW
 bnX7hT+/F0UwSb0fFfAQjghyqAYdAI7bKA8CGTS2XpSYYtzc2XLtW2jiX6a43Q=
X-Authority-Analysis: v=2.4 cv=BOuzrEQG c=1 sm=1 tr=0 ts=68c99401 cx=c_pps
 a=eu4xXFuXQ3Ojp8lTxhUiOw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8
 a=S5tkz1ZVFAcnwdvYPYMA:9
X-Proofpoint-GUID: 0poZPPOhR1FVxVw46uOPOCpW0BYd8aSY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

Migrate to new vmx.h's EPT definitions for capability and memory type,
which makes it easier to grok from one code base to another.

Pickup new lib/x86/msr.h definitions for memory types, from:
e7e80b6 ("x86/cpu: KVM: Add common defines for architectural memory types (PAT, MTRRs, etc.)")

No functional change intended.

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 lib/x86/msr.h   | 14 ++++++++++++++
 x86/vmx.c       | 18 +++++++++---------
 x86/vmx.h       | 33 ++++++++++-----------------------
 x86/vmx_tests.c | 14 +++++++-------
 4 files changed, 40 insertions(+), 39 deletions(-)

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index cc4cb855..06a3b34a 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -31,6 +31,20 @@
 #define EFER_LMSLE		(1<<_EFER_LMSLE)
 #define EFER_FFXSR		(1<<_EFER_FFXSR)
 
+/*
+ * Architectural memory types that are common to MTRRs, PAT, VMX MSRs, etc.
+ * Most MSRs support/allow only a subset of memory types, but the values
+ * themselves are common across all relevant MSRs.
+ */
+#define X86_MEMTYPE_UC		0ull	/* Uncacheable, a.k.a. Strong Uncacheable */
+#define X86_MEMTYPE_WC		1ull	/* Write Combining */
+/* RESERVED			2 */
+/* RESERVED			3 */
+#define X86_MEMTYPE_WT		4ull	/* Write Through */
+#define X86_MEMTYPE_WP		5ull	/* Write Protected */
+#define X86_MEMTYPE_WB		6ull	/* Write Back */
+#define X86_MEMTYPE_UC_MINUS	7ull	/* Weak Uncacheabled (PAT only) */
+
 /* Intel MSRs. Some also available on other CPUs */
 #define MSR_IA32_SPEC_CTRL		0x00000048
 #define SPEC_CTRL_IBRS			BIT(0)
diff --git a/x86/vmx.c b/x86/vmx.c
index a3c6c60b..df9a23c7 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1641,15 +1641,15 @@ static void test_vmx_caps(void)
 	       "MSR_IA32_VMX_VMCS_ENUM");
 
 	fixed0 = -1ull;
-	fixed0 &= ~(EPT_CAP_EXEC_ONLY |
-		    EPT_CAP_PWL4 |
-		    EPT_CAP_PWL5 |
-		    EPT_CAP_UC |
-		    EPT_CAP_WB |
-		    EPT_CAP_2M_PAGE |
-		    EPT_CAP_1G_PAGE |
-		    EPT_CAP_INVEPT |
-		    EPT_CAP_AD_FLAG |
+	fixed0 &= ~(VMX_EPT_EXECUTE_ONLY_BIT |
+		    VMX_EPT_PAGE_WALK_4_BIT |
+		    VMX_EPT_PAGE_WALK_5_BIT |
+		    VMX_EPTP_UC_BIT |
+		    VMX_EPTP_WB_BIT |
+		    VMX_EPT_2MB_PAGE_BIT |
+		    VMX_EPT_1GB_PAGE_BIT |
+		    VMX_EPT_INVEPT_BIT |
+		    VMX_EPT_AD_BIT |
 		    EPT_CAP_ADV_EPT_INFO |
 		    EPT_CAP_INVEPT_SINGLE |
 		    EPT_CAP_INVEPT_ALL |
diff --git a/x86/vmx.h b/x86/vmx.h
index 65012e0e..4d13ad91 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -571,27 +571,14 @@ enum Intr_type {
 #define EPTP_RESERV_BITS_MASK	0x1ful
 #define EPTP_RESERV_BITS_SHIFT	0x7ul
 
-#define EPT_MEM_TYPE_UC		0ul
 #define EPT_MEM_TYPE_WC		1ul
 #define EPT_MEM_TYPE_WT		4ul
 #define EPT_MEM_TYPE_WP		5ul
-#define EPT_MEM_TYPE_WB		6ul
 
 #define EPT_LARGE_PAGE		(1ul << 7)
-#define EPT_MEM_TYPE_SHIFT	3ul
-#define EPT_MEM_TYPE_MASK	0x7ul
 #define EPT_IGNORE_PAT		(1ul << 6)
 #define EPT_SUPPRESS_VE		(1ull << 63)
 
-#define EPT_CAP_EXEC_ONLY	(1ull << 0)
-#define EPT_CAP_PWL4		(1ull << 6)
-#define EPT_CAP_PWL5		(1ull << 7)
-#define EPT_CAP_UC		(1ull << 8)
-#define EPT_CAP_WB		(1ull << 14)
-#define EPT_CAP_2M_PAGE		(1ull << 16)
-#define EPT_CAP_1G_PAGE		(1ull << 17)
-#define EPT_CAP_INVEPT		(1ull << 20)
-#define EPT_CAP_AD_FLAG		(1ull << 21)
 #define EPT_CAP_ADV_EPT_INFO	(1ull << 22)
 #define EPT_CAP_INVEPT_SINGLE	(1ull << 25)
 #define EPT_CAP_INVEPT_ALL	(1ull << 26)
@@ -662,12 +649,12 @@ extern union vmx_ept_vpid  ept_vpid;
 
 static inline bool ept_2m_supported(void)
 {
-	return ept_vpid.val & EPT_CAP_2M_PAGE;
+	return ept_vpid.val & VMX_EPT_2MB_PAGE_BIT;
 }
 
 static inline bool ept_1g_supported(void)
 {
-	return ept_vpid.val & EPT_CAP_1G_PAGE;
+	return ept_vpid.val & VMX_EPT_1GB_PAGE_BIT;
 }
 
 static inline bool ept_huge_pages_supported(int level)
@@ -682,31 +669,31 @@ static inline bool ept_huge_pages_supported(int level)
 
 static inline bool ept_execute_only_supported(void)
 {
-	return ept_vpid.val & EPT_CAP_EXEC_ONLY;
+	return ept_vpid.val & VMX_EPT_EXECUTE_ONLY_BIT;
 }
 
 static inline bool ept_ad_bits_supported(void)
 {
-	return ept_vpid.val & EPT_CAP_AD_FLAG;
+	return ept_vpid.val & VMX_EPT_AD_BIT;
 }
 
 static inline bool is_4_level_ept_supported(void)
 {
-	return ept_vpid.val & EPT_CAP_PWL4;
+	return ept_vpid.val & VMX_EPT_PAGE_WALK_4_BIT;
 }
 
 static inline bool is_5_level_ept_supported(void)
 {
-	return ept_vpid.val & EPT_CAP_PWL5;
+	return ept_vpid.val & VMX_EPT_PAGE_WALK_5_BIT;
 }
 
 static inline bool is_ept_memtype_supported(int type)
 {
-	if (type == EPT_MEM_TYPE_UC)
-		return ept_vpid.val & EPT_CAP_UC;
+	if (type == VMX_EPTP_MT_UC)
+		return ept_vpid.val & VMX_EPTP_UC_BIT;
 
-	if (type == EPT_MEM_TYPE_WB)
-		return ept_vpid.val & EPT_CAP_WB;
+	if (type == VMX_EPTP_MT_WB)
+		return ept_vpid.val & VMX_EPTP_WB_BIT;
 
 	return false;
 }
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index f7ea411f..5ca4b79b 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1050,7 +1050,7 @@ static int __setup_ept(u64 hpa, bool enable_ad)
 		printf("\tEPT is not supported\n");
 		return 1;
 	}
-	if (!is_ept_memtype_supported(EPT_MEM_TYPE_WB)) {
+	if (!is_ept_memtype_supported(VMX_EPTP_MT_WB)) {
 		printf("\tWB memtype for EPT walks not supported\n");
 		return 1;
 	}
@@ -1062,7 +1062,7 @@ static int __setup_ept(u64 hpa, bool enable_ad)
 		return 1;
 	}
 
-	eptp = EPT_MEM_TYPE_WB;
+	eptp = VMX_EPTP_MT_WB;
 	eptp |= (3 << EPTP_PG_WALK_LEN_SHIFT);
 	eptp |= hpa;
 	if (enable_ad)
@@ -1385,7 +1385,7 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 				    VMX_EPT_READABLE_MASK |
 				    VMX_EPT_WRITABLE_MASK |
 				    VMX_EPT_EXECUTABLE_MASK |
-				    (2 << EPT_MEM_TYPE_SHIFT));
+				    (2 << VMX_EPT_MT_EPTE_SHIFT));
 			invept(INVEPT_SINGLE, eptp);
 			break;
 		case 3:
@@ -4838,10 +4838,10 @@ static void test_ept_eptp(void)
 	eptp = vmcs_read(EPTP);
 
 	for (i = 0; i < 8; i++) {
-		eptp = (eptp & ~EPT_MEM_TYPE_MASK) | i;
+		eptp = (eptp & ~VMX_EPTP_MT_MASK) | i;
 		vmcs_write(EPTP, eptp);
-		report_prefix_pushf("Enable-EPT enabled; EPT memory type %lu",
-		    eptp & EPT_MEM_TYPE_MASK);
+		report_prefix_pushf("Enable-EPT enabled; EPT memory type %llu",
+				    eptp & VMX_EPTP_MT_MASK);
 		if (is_ept_memtype_supported(i))
 			test_vmx_valid_controls();
 		else
@@ -4849,7 +4849,7 @@ static void test_ept_eptp(void)
 		report_prefix_pop();
 	}
 
-	eptp = (eptp & ~EPT_MEM_TYPE_MASK) | 6ul;
+	eptp = (eptp & ~VMX_EPTP_MT_MASK) | 6ul;
 
 	/*
 	 * Page walk length (bits 5:3).  Note, the value in VMCS.EPTP "is 1
-- 
2.43.0


