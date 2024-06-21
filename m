Return-Path: <kvm+bounces-20317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F29769130FE
	for <lists+kvm@lfdr.de>; Sat, 22 Jun 2024 02:00:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E330D1C22035
	for <lists+kvm@lfdr.de>; Sat, 22 Jun 2024 00:00:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6894728F1;
	Sat, 22 Jun 2024 00:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F276jVOS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="e6bYWvFW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E1F195;
	Sat, 22 Jun 2024 00:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719014425; cv=fail; b=YrR6cxASTp5YxId0SH8Hnn2Fbjiiz65tzWLRomm/y8BEoJ4sfKTLpo/SyIU3VVPLDbs8FFrzmKr1fsGlxwKKPkYDLHdLtHU8DOPtSI4fV7fePwot7oatQ9mc33QF5r5n082qIC+FGNUHwuDbW1yog0b9vod1jBgfUHkED2B7qXQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719014425; c=relaxed/simple;
	bh=95lnAi5F9xCnAfKednR1AiJU213BCI8gRV/qBh7EHYc=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=M3c22r5ze5mnWPxjf2S/LQfoxVh97HnBm/HvSXvJFZErJYFX6URNOVoFfbFkH7v7OqAxwpwu9ktgm1TZLZK4lBSkkOll/WDKovknP2b3HDn8SeMU6v2fxulo1MIx7Ix6AVeJXw62C/+je2nZH3iJxDUgq8TGNwCOfcnn/437NO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=F276jVOS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=e6bYWvFW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45LEXQ3F005300;
	Fri, 21 Jun 2024 23:59:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	references:from:to:cc:subject:in-reply-to:date:message-id
	:content-type:mime-version; s=corp-2023-11-20; bh=95lnAi5F9xCnAf
	KednR1AiJU213BCI8gRV/qBh7EHYc=; b=F276jVOSwqoM2lxHDnxlIZl76nz8SV
	liHH7+2km5ypy1VKIUrI3WpjUv+oY3E08vAT1DHoSgL66Ut9k9G5eHCXZkZ40l6X
	XqVtzI3kFoS57TdeU4qHUqDVxchXbimd2Ti0C51FdUSwHaZrq0n9h7IY0wC9e2ox
	mnFIH2krdWTtPq5PGIsqyFLnSVfykv9r2GCk/u0Jxts+KRsiZk6Rp4WFoxFMRYHs
	dAhhPps6bkbC2emKM0X2+CyYwn0KqgtX4XW0MLsTXdajsYp9Tio1q5Fxch7Bp9bY
	wpJIGddDYNPHa+Tz+hGXVoWmJLy0UCnnWw7iJktmaWvvKIVAKE59OLsA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yvrkj2pmm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Jun 2024 23:59:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45LLAitB025148;
	Fri, 21 Jun 2024 23:59:26 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yvrn6qhhs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Jun 2024 23:59:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DMfEvVGw39ttdxAho1H8UKUKy7+TUNbn2OtljLToh2aR6gq4akgpKIsTZ4YLPQmyWyPUIGIBvaQZGq51TxP1XkGJVdZlfrV8CU/T2y/mJCpjxyLbwNJPZRYJ/0FUQtlmaR9K45V/nz9E+0Z+wwtoFqdRxDwAXyO1Mgyp5CTyarKli+a/Fk2pI6dLgQGlA2iYhtP4m28idQFXKs4MnhmsnfA/EwLvKclfvaQ+EgqRmGOo3HE+huhp55X5jOYGm94bfrdko1wk8tRCe4QjfbaHk7lTBI4ULzfSHhEp8Vxy5Q53BuDY0QIvTum9yPBOTaICHY+nFDL1c8UF+lC7LXYUyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=95lnAi5F9xCnAfKednR1AiJU213BCI8gRV/qBh7EHYc=;
 b=c1DddgqEw9VnLrLosRTiQIjsNYpr8tNc9DaeZXSt5XwQS764uUdt7yE23l7qIyMuF/IdT8Z6ILecXqzw2JeNn8auQ1MtkT27bsWDitftfGC4LHwaFl4sTH0SDT+sUFwmtUjlclWmtd+KtXmiIojR7sD2cYh1COxa0LXy7vj6RZScJoNSdUUFO6SKDBchJh+6wew6ffNZF1wpdt901kJxXI7+J0HHHnQTktvZFickyIKx0gsgngqcx6Otil4K+9XhAlPNR+X1fe7pZxs8Imh1KdnjtN1GzEMrZLuHOKPHZaScvj6/1SRWSnS3vJqJ1TuqSUEmfOCMO6j3pqx7Gj2YYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=95lnAi5F9xCnAfKednR1AiJU213BCI8gRV/qBh7EHYc=;
 b=e6bYWvFW6UhPHWuVXeiUmrtpB+bXnF950HACqHIQJsLPPw5kSOj0xnYAVymyPolxvR/5ZXSyUEYCCCC4hxJyNt4oZ8BzmNxrUpqwR9bhpOgfC9nE+RftuQxyDFck/IaIjiUKIm97Xi1azcoAX/79nRCaZyOPJp1k3Wg9FBe0B3U=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA3PR10MB8140.namprd10.prod.outlook.com (2603:10b6:208:502::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Fri, 21 Jun
 2024 23:59:24 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%3]) with mapi id 15.20.7698.020; Fri, 21 Jun 2024
 23:59:24 +0000
References: <20240430183730.561960-1-ankur.a.arora@oracle.com>
 <20240430183730.561960-9-ankur.a.arora@oracle.com>
 <20240619121711.jid3enfzak7vykyn@bogus>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-pm@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, pbonzini@redhat.com, wanpengli@tencent.com,
        vkuznets@redhat.com, rafael@kernel.org, daniel.lezcano@linaro.org,
        peterz@infradead.org, arnd@arndb.de, lenb@kernel.org,
        mark.rutland@arm.com, harisokn@amazon.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH 8/9] arm64: support cpuidle-haltpoll
In-reply-to: <20240619121711.jid3enfzak7vykyn@bogus>
Date: Fri, 21 Jun 2024 16:59:22 -0700
Message-ID: <871q4pc0f9.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0192.namprd03.prod.outlook.com
 (2603:10b6:303:b8::17) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA3PR10MB8140:EE_
X-MS-Office365-Filtering-Correlation-Id: 345511ef-905f-4255-6c0d-08dc924e2d20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|376011|366013|7416011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?0xjI+7f3tsEkxesv8UY8CClwCnxOCzkFnVCkpXXK6ORoLn8TKxBCYq0qYnHL?=
 =?us-ascii?Q?rPBDbKgeKlgjN/Jq8yzlDW5QUNgxJ5iXzJRN9bHqam+5d/D7X0eu9loXDFf6?=
 =?us-ascii?Q?W+rEIh9weu7wvJX3dUJEmEC6zUrwnvzCzKTN3D+fbyfyn8nJZoPHbD2IfbhX?=
 =?us-ascii?Q?tCoHEcEFLSOF1t7/sM7XiY1MezdWaljRyH2GsiuAqrj3Rh1YYblqcLStkcj/?=
 =?us-ascii?Q?VaEMB+erWnaMK4neT87OoeNrhqOvH3MCVTMWRQiDLI+EYCFOIbxQX1aKJNEy?=
 =?us-ascii?Q?rYWYcelcWZAGXYW5+abn3hD62lc5m8EuG5la+Ortu8y3cAgcdd0XqAUX0Bbj?=
 =?us-ascii?Q?TD97bGuvKwMDwjEMKjuv4Zl7cqCIt0R3vHoPsk4RtmWSQZUbhhSIl5niu5fo?=
 =?us-ascii?Q?KOZexB7sgfel+RAa7q+KxPW2ompxP+klcwt/e2c/H+nfj1JKIpjgFLcoA3KQ?=
 =?us-ascii?Q?nG5FnVLTq2OB6XRe4Oh8dHkMi8wefDSHF6cM/ahhwOiD7NgbA7WCkk9hCjiy?=
 =?us-ascii?Q?riD2EUZ6vxvkrg1oJwUMOu432xDHbrEkMPjJh1T0i1LtWLTxEiMlcEon1wUL?=
 =?us-ascii?Q?VtTUb/gDWQhSs1Z0ltdY6BdlwWtt5s+hKK5mn8v9OfZBqkRiy0HEq5Q+8Efp?=
 =?us-ascii?Q?OZc2NYxtRJzHTjNNRbBg7tPxUo+1ihe+pwkAxFZEQln+PAMWPzEc2FSuiFOi?=
 =?us-ascii?Q?NBI1me2r9PGBMiC7MfUKWRJUijZ0VhHgqHkTGx3WOf+VI6O9DyCW6sKYBUFc?=
 =?us-ascii?Q?forQWqKmUWUO0hwcIxxESl+ZyR1CtGDuZQdvo7jcR7Wa+1gl1JcuwKp/XGdH?=
 =?us-ascii?Q?VoCYnWtdCDVAheApHQzHY0SlpWRj46Omcq++qnzthjyEOrrjWym+LJAPzX5R?=
 =?us-ascii?Q?kySbNl7ngU2ZIrVZtdjiP0d+GXLQRTdTbuFDZgpfakcAoQhGjAbKGYJMGzcd?=
 =?us-ascii?Q?p2wLw1ja8FQKNK8ELKLdQBNIVtiJdJ005nwcCTqbGRDYva7hqyM+h5Nepp0f?=
 =?us-ascii?Q?kwHGI0NSQBUlvQWTHFW4AJ3utGokjMSxXNvmnjdkyoYNAAI82zYk+c7qj009?=
 =?us-ascii?Q?UZ6Yv9zRp1x5I81HstcpapA9Lv/lo0+sXl0+8QMPs72qrCH6e7skfo1xk2J0?=
 =?us-ascii?Q?2HZl+Xij9i/V4iiUleMhbic1HBsgXeiZgdVRTmYEXHa1pEuBsfX6rd9HaLYK?=
 =?us-ascii?Q?lUcjBu9XtOvblgbhAVIdNO/pDyet7zmSa91n/8RCqFAqHYQSIc76wzxgPHn1?=
 =?us-ascii?Q?7Sez9wlzuvz0ZYzv/iqHDFZuyUJiTnoQOS7E+BRjaO4lzJvynKNGmbQyv3SW?=
 =?us-ascii?Q?9wwjCTKopqLMOwlDGNdRetQP?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(376011)(366013)(7416011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?I1s7ieGIcwAoWxkQ9od+PhHKDc8WxBU3vdAv0k+IZtC6GICrsO883bHVg+4/?=
 =?us-ascii?Q?sR0iDJNaENfOxtisN17/+l+p8jRRwQcQ4gInbruOfCU+gJIdbkJElixdxY2f?=
 =?us-ascii?Q?A9mFjvS6Q2itvco0F9231y+ZbhaO+15EfdJ4DAnwg/tZlZSG3jKDZBiLZbd2?=
 =?us-ascii?Q?70+4tcILdsjA9KGdkSKxNnx64R8dQe4gVieJ1gNUcBexl25KyrH0W56bZruZ?=
 =?us-ascii?Q?OQZFCIXp3ud7zNyEyw+QZT1iGWxIMt4QCCVNrIVVXFU9NFpSOf1hLUo4fOmm?=
 =?us-ascii?Q?FcmyImK93BwI4Lkb9zgdibzGv9Eeq1tKpeLl+2DZkfDheS8BpXz2/ZcELftU?=
 =?us-ascii?Q?Hk2jS78jcH5G5mbdr2mwSJwXhicXTAxYdLbSRbkqr6pPL8mOlEPDspR/tfam?=
 =?us-ascii?Q?ub37cjWRyv+Ln3blAUsPiKDRJxaWo6oKhJRmYV06H5r7Fh+Re537gEDbqyJG?=
 =?us-ascii?Q?3XTvdPIYjDrpepS7FMZY0cS+Xypon9ODTEN1oy6iSh6oJ3PbZ2x1XnmrqXtn?=
 =?us-ascii?Q?Ve68d4XrXwx6UD7mYnNB+YxaZM3QxfOolp9UdgLQrBjDbfK/cWBvQsoBzOmJ?=
 =?us-ascii?Q?Z83oWPJngT8KyzJ3rRX3mymHFtrt9z1ZF26pgfGQK0bdZ8meQe6bSAEmMbgQ?=
 =?us-ascii?Q?unLV4pbtL4cJnTdpxxqd+4zT9FIpRdKdt8jAIS+TzqlnF4JbphRTlJZUeNbY?=
 =?us-ascii?Q?wKlYh7yt3hyuHXzd7n0lBZUStfkY7d+LWjRtKZDQz0qnOeEXagOIJzeu5u5e?=
 =?us-ascii?Q?h3rQ2mBnikA5Wesap74UJe9tLTaHc9rBKMSC70kMhbUt5YJFQJk4OFu+iwnL?=
 =?us-ascii?Q?3P/fZZbEQYlPF2l5G0xTYKAQTTrfEMQWRhhx3nEx5kV3dMds/COB2RyqycVl?=
 =?us-ascii?Q?p+A/a6sp5abhHCrF0w7R7EacUwzRig0RDQF3jr0kab9EqjoCUca0r67rAo8E?=
 =?us-ascii?Q?vx/J2i0hvwNcOOWsywFgHFDRpyyOZbo/K6uQx4YeoydOlI+QO0MOzRXUPGNE?=
 =?us-ascii?Q?M2mXJtwcQ+iDhxe5WXKF0NETEa2LWCGVJQ5BeVJle99CGdxtovr9FgUVR/OY?=
 =?us-ascii?Q?BWFzehUUxwKysbsmPl2e3Reib6GSCbOiMb1JZ9LuK3lspi+IUonIVZMyj4Xy?=
 =?us-ascii?Q?GVdc7vRmOu3t7t1n6beFuXTTKG1ZNengOYteUxBaX1fLbJlTbHyRKdPRR79H?=
 =?us-ascii?Q?Z2jTeFPFJamwDXSbTsPGkJMu4mTPq5RROG2rlNNLcB7t9afsA8cRrdAmdmo4?=
 =?us-ascii?Q?h/2nimTs59jecte0ACzOij6HzFccBtqA4ZZDkXPpdnuagDI793BK/xRuppXD?=
 =?us-ascii?Q?szEojWarT++o/lhI7UHbl3Rz51PoF+vKl8d4Y1aTRuNRarz++WjiiDqaV+bm?=
 =?us-ascii?Q?3sKj7zwhltxEhSFWU1Q9uA3lNea+GOMzpAyHcUwlyRLnl7qhnHMsbi/XZGws?=
 =?us-ascii?Q?NtbkKUhqvtbyM3vh1Qj8Nb9fMiyTPXGwAHx/bdHF0zSF8rtD7Ghi9mIME7WK?=
 =?us-ascii?Q?K+J1hgqBm2+ApUAijhPNlXjXqJsHZF4JiBpRYYrFv+saTAHvQxAOmAnqCnNR?=
 =?us-ascii?Q?78JQ3qdUM15BfjQ3Lup08k4JuZM893X2Ube9jhNkj34DjXDOvaH5kpGwwKLq?=
 =?us-ascii?Q?PA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	QV5K8rK9VpVRGr4chjlg+yqilC/VF8QdFDmtUG0ggEs+oZDwPPmORrhlGg425jHqBxpzrYJ4AK4InrB4iZaVYsw/tHPIUOD0/7yzhaQmiIqoWhM4HrHcWJ+BfCn5lnVZL4jlLOkWr1Qb5irbyV00VswXQGg7PoZUFwwKu/CiTC8WWawvozm+JZuaDwGpeZCLKJN08aXKcpxVySXJJQ3mKf4L4Z5+jVWQ5gNVjr5PNehBkMg7o7/8DY1gmPCcvFIwPi/csVo/FJQPfA+yVN9hXSEmVZi/upVeACdjoLc4OQgFlPYwQ7zzBcWY2cntwL5v4WELVQDomVSVO91zgm3R/gmFMtDoHRMZFk4LpkiFj2HrpfaozBkD6qYROKl+byKa/GwS97X+qeeZ/1U3hgH9WoWOyEnjt45ocLCCyS4McyqIGJ/okl5gr4B+LGSqWf8c5R70gxvTxjj2QiOTc1z8vCyTTYPdPTm9HW0c0tuc2lWhDh29rkxveA1vpfGvfyY+2wwOEsJ63Acz5GQSkkGl9yiCGUI7JTjsA0PKy+0Ui8duvoWMdur5cBgBP/pC7z0cB07cz1ItK2v+YHZnMIabIlcwCubo6iCI/uyNLUCz8tc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 345511ef-905f-4255-6c0d-08dc924e2d20
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 23:59:24.3946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o33ROncsRkzFJ7gMm+/G7GQS9LdZJMIN0CpfEAUF/+GwGcdYn7+HS4tEqtVsYB7UTGiy9XRAynsXphMEEwtrArDCpsqVn0BH0zcv1OyMNQg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8140
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-21_12,2024-06-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2406210175
X-Proofpoint-GUID: NA057Dh_3fzgTqHUIZXbULerbGz-t47M
X-Proofpoint-ORIG-GUID: NA057Dh_3fzgTqHUIZXbULerbGz-t47M


Sudeep Holla <sudeep.holla@arm.com> writes:

> On Tue, Apr 30, 2024 at 11:37:29AM -0700, Ankur Arora wrote:
>> Add architectural support for the cpuidle-haltpoll driver by defining
>> arch_haltpoll_*(). Also select ARCH_HAS_OPTIMIZED_POLL since we have
>> an optimized polling mechanism via smp_cond_load*().
>>
>> Add the configuration option, ARCH_CPUIDLE_HALTPOLL to allow
>> cpuidle-haltpoll to be selected.
>>
>> Note that we limit cpuidle-haltpoll support to when the event-stream is
>> available. This is necessary because polling via smp_cond_load_relaxed()
>> uses WFE to wait for a store which might not happen for an prolonged
>> period of time. So, ensure the event-stream is around to provide a
>> terminating condition.
>>
>
> Currently the event stream is configured 10kHz(1 signal per 100uS IIRC).
> But the information in the cpuidle states for exit latency and residency
> is set to 0(as per drivers/cpuidle/poll_state.c). Will this not cause any
> performance issues ?

No I don't think there's any performance issue.

When the core is waiting in WFE for &thread_info->flags to
change, and set_nr_if_polling() happens, the CPU will come out
of the wait quickly.
So, the exit latency, residency can be reasonably set to 0.

If, however, there is no store to &thread_info->flags, then the event
stream is what would cause us to come out of the WFE and check if
the poll timeout has been exceeded.
In that case, there was no work to be done, so there was nothing
to wake up from.

So, in either circumstance there's no performance loss.

However, when we are polling under the haltpoll governor, this might
mean that we spend more time polling than determined based on the
guest_halt_poll_ns. But, that would only happen in the last polling
iteration.

So, I'd say, at worst no performance loss. But, we would sometimes
poll for longer than necessary before exiting to the host.

--
ankur

