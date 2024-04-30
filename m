Return-Path: <kvm+bounces-16252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AC878B7FD4
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 20:39:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9AFAC1C228EC
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 18:39:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAD6519DF4C;
	Tue, 30 Apr 2024 18:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ffiVkPz+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ep2WLv5D"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF4717F363;
	Tue, 30 Apr 2024 18:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714502309; cv=fail; b=BZrajDSl869AY58VG21OaEGeznFALcxnqkUFbzIjtcDJGr848myledg4Xh44rFYPSEZWbkdDoNVLiAXwoPrPGTSvBuzzNKjm34P3wi5wYBlTq74gbxaXscGDWgRRCcbVVoJwiz0bM6Ja57Vr/FuP8PfNoLIkADl3O9dKsoRhW48=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714502309; c=relaxed/simple;
	bh=gKnLz346lLastvUCDmG6V9AtUq8MXiRM7Btvw9X0rnA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QcSpjXCRd46Yww4uw8EQ8lw+KKjKmDH5CHRZC2cvHBaXUzxJOdAMB9tZGVtu45yjwKwYiR0XNMmRx0F6dGVcCFDyvA7XoNwP1UfAueAHuO4tF8N8BAGyTBg6vVa7lhxY9pWrTXhlKnZqrSs9FUr0axMX9CKifHCWdmx0aJ97KtY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ffiVkPz+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ep2WLv5D; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43UHINnB026804;
	Tue, 30 Apr 2024 18:38:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=9Sv9yijDN1XGvCdbf64quJQL8t5uud17ed9RXYTLfTc=;
 b=ffiVkPz+Nak5l7NEX0NNXMyj4WtwZt/YvQJygfb7LKG9tT938h8oAQ0wso43oE19a5Z6
 EOAgn4HJEZTGpXwE66TsyCovzmxvDfzWUHtzpIM8OdZm0xtmHsIIvo4RLS7KJTsqT97d
 aIsoqjBbIBgTgTKTijI6dTbA3jREhdDqpKxPY10XkpTTzyoBfFJArEu65v0fEz3Eqvy7
 d0q918V0dgzh8MHyTx11U6K1UbYQiuTr9YhSRdlVuA/QsrIoEtNiyyo733GYAw1NtXwa
 UMRIJ3FudHFi5kg2RGEbQEPxNC4j01Qv0yeC4a4iViZdPUcxCxss2aBLRRcEnk3G2Qxl 3w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrr54dukd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 18:38:02 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43UIHWWI005127;
	Tue, 30 Apr 2024 18:38:01 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqt7vk8q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 18:38:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WYn7IaYgXBBA/UbXcUA4EsQW1oSxYdoLxMiytukji0qoY0Ifk2itouom+qJKEPmqfOidyIVA4udpAYxK4jqSKPYQi9Hs+ZrQ+FORUwO82j+eoNX7LGeMmlKam2ZFyG/S6hBhff+lyLaCXqMF70t79tEAw28hF77Oz7Lz2f0sT+BgQ+FCTYNof0RmSBcPZTB18Dc/aZHNwA9m3yVIC9qNIBvBa9JT3TE7WfoXzW9B5nNDQX+IN3uK/bj1fP9Bpj/MN5I1hxOI5nIAGStad4zDuPXFNwyCtK2E2CHsMmz2sjk+joMCxTmUYLPSkZHIYolB4njYD9EUXEhh/xxYDWdaNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Sv9yijDN1XGvCdbf64quJQL8t5uud17ed9RXYTLfTc=;
 b=g+fC8vrQTFfzAsoTknvVkIao8oxYhP898yVKP69aB8vFZREUX6jcTejV/pF9qYHFTjjYydnnlZQigElQiNHiIiXmT6FL3Yzrl9XkT5oP0OWMVM+VKqB71dEsI+XJmm0tl8EZDQUi/c1FpED5YDciPXjr09f8tQ6LdTMj4ep3Yb/nvpXIof1RV2SJ+1UZiYQee2ELKUxN1Cc2dUtHwr6XvL3ZswAOZF2RmcEixB8QbCuzEi0TWV8yfboTb9HPr3o37xRybkhptIURyRH5tIwE0DYSCMQNvGYBdQUS40mf4JHKRIhAivOSxTPonclavztyf2uPUwjxJ+WnjYpViKcnDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Sv9yijDN1XGvCdbf64quJQL8t5uud17ed9RXYTLfTc=;
 b=Ep2WLv5DL/tAs/a+GRGxBhdGbtg9LpvHgjkTV6rrD9KVD9wPM5ZjcWcnP4Cw/m+hKIBhzbbBHie2SWN5YH1Yd4USn52h8F0GEtk1LdVBhTrVM3CtJ/DJbfzSro3bX3x8CzA75tU6m7LWd1lzfcyZOK/eu1GiBTl9VVeEk+FyaSU=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SN7PR10MB6308.namprd10.prod.outlook.com (2603:10b6:806:270::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Tue, 30 Apr
 2024 18:37:58 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8%7]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 18:37:58 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
        arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
        harisokn@amazon.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH 9/9] cpuidle/poll_state: limit POLL_IDLE_RELAX_COUNT on arm64
Date: Tue, 30 Apr 2024 11:37:30 -0700
Message-Id: <20240430183730.561960-10-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240430183730.561960-1-ankur.a.arora@oracle.com>
References: <20240430183730.561960-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0200.namprd04.prod.outlook.com
 (2603:10b6:303:86::25) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SN7PR10MB6308:EE_
X-MS-Office365-Filtering-Correlation-Id: 449f83a1-f209-461e-0164-08dc6944a845
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?nfgT+uRheqx12Pcl2T+dhMc+Zg63wyJD/damKEk96ZhH6VW7iJ7ER4d4Z0Uo?=
 =?us-ascii?Q?fRkn5QUsVadpNH01D1eHU3x7EJN1+5uJqE/gPKm21XxgWMA2zwxLW7/9KI1N?=
 =?us-ascii?Q?y/EagbM9JCVND2w4ejQpbW0Pt/W6n1T5qcSaRiKINQUAtDQ399Q5o5nsIIMx?=
 =?us-ascii?Q?Jt525GQLsa4rZkEGdBmVc3LPkz2S4KwGP3JY7dcILymYMmkIdDnEhxFUIhsE?=
 =?us-ascii?Q?J8P21t4V7zaQ8btkuKTNlzxcbJTGjwV4yIu4uXlel5eXlh0k4qR84+unVW3a?=
 =?us-ascii?Q?vVqzhG/X8s9TCCGTXPpXp46WETBk4JwYmVgyUAqU56LfcTO5wvgz5IeIdy7Q?=
 =?us-ascii?Q?Phs4MuCDRJbuyaSMC0hr7Y/y3Grwz3eNwsAlqupkuFSo0SX9hJ/TP7DS+izw?=
 =?us-ascii?Q?GyjbEPtfzYuU+4vM96S457Fgn+TEhka3Szj2+V23/T35d8jD2zdiJDR65yq5?=
 =?us-ascii?Q?+DCv/XCHYgLAvcUmPAzrnHF5L9CRiPFzkTRIeVZM2WF6D98U9HO10MmCu7+P?=
 =?us-ascii?Q?wmSiNmFHf6QyxId2dpyz821EdQiMGrun4noUgL/Pe39zL9TRkETeyz5LgqNw?=
 =?us-ascii?Q?wqUxIEMa8CtGys9kxYOZXyv5UwdUBRJ9ob8VgC8E0VnTQhUdqurrmTDAoK9X?=
 =?us-ascii?Q?bYDGCzXv5KvrcqhOJBvyuZfwOiShn8Sb83vrOYNcb9rQ/AXU3NYugZnHL/Bs?=
 =?us-ascii?Q?OTmlAM7BJrBK4DfNenlvPHYrfSh9Nkpq1CybjuKOPcBjRCbdxeOtpJI5iLk9?=
 =?us-ascii?Q?92MdIEIBT4AhQk2ZaHklGokWtLW1HXAkkcfVDH1P9tbAozQkGEgcz/T8Pt45?=
 =?us-ascii?Q?JRgpv6KcaJDsB3YpYdnQrfRpCyGx9SUQUR0Hj/pwVQ7XIIX6FrSEOVbKRFhU?=
 =?us-ascii?Q?U12iXVMlAZli1xx02uQWTXShiG98RCYsMkUVUqBlmqsXRH4j6cj2f1/0D+ee?=
 =?us-ascii?Q?JLNWzdXVa420p+UeECMKqrEp32oJ5bFumEyLq/3F5FfyK4fZ8HP/bzOR7VH+?=
 =?us-ascii?Q?DaTIRXp2R4V+IC0QvGLRpQ35f9dCBX8MRSdke8JAEjDk519z0VU9nGuV0zR3?=
 =?us-ascii?Q?CpuKRJ4tc9o9CcV5ufnulFa34WGXmQQGVuEnaK8QYGQmds2y2DCvlCIGbWCD?=
 =?us-ascii?Q?5LF3ewTK4M660sDCWo+/Yq3wtKmfSEJ7iSmC+UvtHIPFvVrNUfRw0mlzU4TB?=
 =?us-ascii?Q?xq6R+EJwQDQyT3g2mzqcU2bT8AlIGqL5p+9h/kTTAXdZ4rTnCNo8qYCeyMIn?=
 =?us-ascii?Q?doaZQ7xZVA/zIbp8T6q8kAKZB6Bdvef3M1Lt757kkw=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?oK5tsl+Xm7Dko1Gdgtgn/LXJBOy+/svcQdwRSIDlhtxoXwWbWdPN/8Gd1qkX?=
 =?us-ascii?Q?4luntRuqgg5CkBdyZlywWdyHcVa1FyYi2OShejm1kIE3s6/AGBKHwVARMqqe?=
 =?us-ascii?Q?hHHeq2h00VOOONzFwHQMesDqKehcl+3kWvqBT86LZiLVfd7mrTKNdhYvUa6/?=
 =?us-ascii?Q?jaQ27YOSWeeF9VHS+xwvI5jkiC+QWL3SSE8q0F/223a3xr+h7m8MiBZEed1i?=
 =?us-ascii?Q?fHh52IiUxOq/saAxwLnGNuOb1rvwBssBc7zidzVgevajiI/JqqMFDRF272gc?=
 =?us-ascii?Q?hPd6f5LLSVdAFqi89FIqYANMFFdR//uGOlXSAHPOsLZqTU8rSgMG8OXxXbnq?=
 =?us-ascii?Q?jcXkwe/qnQXYZXJI/SE7a5VC7zWw5Rpl30qI5jVrfKu9OsRzA+HDHTRXyi+A?=
 =?us-ascii?Q?QtaLI/Zj64CWa84N2SiM3eTP9Tafqr7mrXYzsDmWFqSe2DOB0m2iz7GQsQUE?=
 =?us-ascii?Q?W8XIloZ0y3M63w2kl82luY6t/BGth8sFTh+acll1U2UCZMl9XfOZn7h8uvLy?=
 =?us-ascii?Q?vsZ+SQwBE5H6I5ElzMkWxbGWV0kXLcdmFDwsaxn8XdHJxEZ8nz0UmfgXr28w?=
 =?us-ascii?Q?k7kgR1YF1laQh6tbXvARJjW+/rZeTUP8//BCrYCbFDw6c4iQqrawaqv1qZq3?=
 =?us-ascii?Q?ZwaJvHC7cA8vhZauXp7/7Ebsb0Sjfm7c6owL+Bsl/nM9/btBnOggC+nCa6XV?=
 =?us-ascii?Q?oeiReDDPAkA4m5W1VDQFccOFpiNWV5aSPSw2N2V+9RYTvSAZXroZxtHkBz9m?=
 =?us-ascii?Q?dSs+kC+29PWDt6XWX/PXLHDurXqtMRU7E7McyrphMz6aNriGdF1cGuitjAIf?=
 =?us-ascii?Q?QoA3WdQ0O+XZMCPWjyNRiYFTQTsMTNymtxbH+ZazX+R/5n1kTqd0ryr5GwsS?=
 =?us-ascii?Q?swZkbcgx6TAJob5OffjW0uoCXqCMAI90MpokDFWrTKfHBgMkWBmjyT3jgfyC?=
 =?us-ascii?Q?fAdj9JxRYHBD76iJ3PHtTCLL7tZO6CLytfKLXlR1xgq9Fv7AvKGRnmI1yKiT?=
 =?us-ascii?Q?Et4IVw8RDYv80/k+WDvdzNo7o4FzkaNKzt+egtfrvxwUF1xsrsiuSzF5Ru8B?=
 =?us-ascii?Q?nP/L9wkrXhMNAPcYNsrsp3bpQQpY1TKtMmDm4Uoc2xnMYtJcVU4IJ+LknQN0?=
 =?us-ascii?Q?4AKeW2GALOiqm8IjpouOzjaih2He18zlrqmj3TqpSsiYP3eH1KC7/02G861t?=
 =?us-ascii?Q?6Ljcmvay5DUYy2zcIfU8VcNx2YMD4j1GEseo2JiETo4SgmYB1aXKFbfA7wpq?=
 =?us-ascii?Q?2MUuOeZ2cKalo4983G6A9odcqCKaSozD7H4yA2uQ3yvLcVodRMzqf8l+nQsW?=
 =?us-ascii?Q?efkfNs8yrVvEWdqDJPzvaVVxFDEokpYCdAj4p/rOCV8ctMOG+yo3kCq99Dj/?=
 =?us-ascii?Q?G9+34AyfTGjZA0cbXY7wyMXHeNwoir5eLG6BJfnair+RJ00pCaoUyOr87ld1?=
 =?us-ascii?Q?cQkhqvi4BAD3Hj5liI5J4RwpvhEqr0xYeCDDiVCRSNJc8clqzKfIXmmdosb7?=
 =?us-ascii?Q?TNIlLyS8ibu5Lzkylhy7C0I+6nJBD9j8hlCG8awCu8nBZ6r/wjnWjl4usSaO?=
 =?us-ascii?Q?RnV0DK5Oibb5GpqEkgyK2WtpIL91CRxy6p0O2nkpfgl7zBjKVCn0V+hnEo11?=
 =?us-ascii?Q?cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ybDLB/qUohizwdejBIrHc9n4pcvd1R5MOs3QFoFlyLF/WHSZa9wkuqGdkRUvmQPLaGMmPlMZewy3X+UI1JBPOq8ZfAPagmRgqiwzhuxEHTYdlnphPYGTJe0kQMTCRaflrxcaw8BMDgxj06Fi0hNe2JK0omjFuwDfPPH6gRidxb7tmfMGhhhZJdinpL35ezX8sVFd3nsjEGXtzHKAZxq6JLMrmCZU1uUuzw5JHlJjv6GHuyhrCWoe0DbK+sws1xN5Yxsnqa3qZlCqGnxhrxipNyNKdW5sdJpL0m0D5QQkjjNl0JZYN7Zdb+v7ssyFrY2cYOFwhAa/wILzFvEpWf7ese0HMLADfq8tOqkGdqw48tQ9lA+OLSkP1T1W1KTCYC3pGk9Vcxxffo3jueLBz/XJwojq0qJRzo7ITwvPKqHyPE0mMC0vK+wo19mC5LWy75iJfwkRGB4Qa6STyWL+1YjBFpAT5FEBEKKx3qOqzJp9h2sqlQAxGaUsBiZ/9m98UWH1GgNIpIjQkTShJmyxQSL5q0aQi5i90sL/T7UtMs7uWYtc+vGe1eBLuXl8nbEhjHM1XcQziYn8tMNyhMSeC/7NqlW8v1vI6Tn8sT6G9vkejGY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 449f83a1-f209-461e-0164-08dc6944a845
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 18:37:58.2531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O/Uhd4eUf601epdBp+Ib6lzn008ube9W9oAV7pz1Zm0DPryvbeFJcThWxYxTeVoOGw3Sq2DejQ5lbU0h78a1Fg/PcjR6XoOyvW0su/2ZGlw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6308
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-30_11,2024-04-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 phishscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404300134
X-Proofpoint-ORIG-GUID: V1oLAXowiiGx7BQXRAD6b1HlqZHfZhjI
X-Proofpoint-GUID: V1oLAXowiiGx7BQXRAD6b1HlqZHfZhjI

smp_cond_load_relaxed(), in its generic polling variant polls on the
loop condition, waiting for it to change, eventually exiting the loop
if the time limit has been exceeded.

To limit the frequency of the time check it is done only once every
POLL_IDLE_RELAX_COUNT iterations.

arm64, however uses an event based mechanism, where instead of polling,
we wait for store to a region.

Limit the POLL_IDLE_RELAX_COUNT to 1 for that case.

Suggested-by: Haris Okanovic <harisokn@amazon.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 drivers/cpuidle/poll_state.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
index 532e4ed19e0f..b69fe7b67cb4 100644
--- a/drivers/cpuidle/poll_state.c
+++ b/drivers/cpuidle/poll_state.c
@@ -8,7 +8,18 @@
 #include <linux/sched/clock.h>
 #include <linux/sched/idle.h>
 
+#ifdef CONFIG_ARM64
+/*
+ * POLL_IDLE_RELAX_COUNT determines how often we check for timeout
+ * while polling for TIF_NEED_RESCHED in thread_info->flags.
+ *
+ * Set this to a low value since arm64, instead of polling, uses a
+ * event based mechanism.
+ */
+#define POLL_IDLE_RELAX_COUNT	1
+#else
 #define POLL_IDLE_RELAX_COUNT	200
+#endif
 
 static int __cpuidle poll_idle(struct cpuidle_device *dev,
 			       struct cpuidle_driver *drv, int index)
-- 
2.39.3


