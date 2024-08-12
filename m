Return-Path: <kvm+bounces-23891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7A4E94F9AD
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:37:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBC101C220C6
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B45C1990DA;
	Mon, 12 Aug 2024 22:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mJnf8eei";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aoTZHIpz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6511197A9F;
	Mon, 12 Aug 2024 22:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502227; cv=fail; b=tZIOliznPvoVkiII32QwtiUSyV+sagtCt66VTC/INg/RFFabT4w+1aEUwarAkjqsItKo+eRoqamBrtcZVwWuhHjSf7br7leWE/JrngXxfKrArL4YhmLeFmo2fYmKFbmG1jUm4PGIR2rgdOf/MUAyIIj6S173/++dckcxRRqJt0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502227; c=relaxed/simple;
	bh=hOHmouDMu0lSCINm+IgaEGVHoAbOHMQAKseO07LMqd8=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=Ni822I1GZw7JHtjfbsWLoCMNxiXIRK7KxNl24WTzkwKGRkwbZrEAcWim0GZvpGa0hmzak6zUu7wXOj7F9G/ZFCHXcvDxazoOd/Td9v81rQ813aBzAwuMFemHWUFRNpEQ+BZm1CA9QAPXabPhJddvWd2P5NhQ5vOuti9Xuswr1V0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mJnf8eei; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aoTZHIpz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47CL7Ko9030997;
	Mon, 12 Aug 2024 22:36:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	references:from:to:cc:subject:in-reply-to:date:message-id
	:content-type:mime-version; s=corp-2023-11-20; bh=M/3T6lWQfyWOOZ
	7tx2ePCAE3/qjOxrE45+Hk2Ay9y6E=; b=mJnf8eeinw3mmF2V1sryhIwkQosD9Q
	5igynKm4gIDrK3mZ2pfjjCqMZ78JOIE9DvLxM0PgO3RopjHjSnYGKqG0bzgTf6vY
	y+sWZQeqfOh9cFSsDTu7nrBDXfalLJgEYLF98dSUFCcuquCPh18GAT1pQWgOiB26
	KQqpfOUI6kgcxRh05PDl4Ib4db5Y4bM3wQ0gL0mAYYEFNWS43EpZHiG2r/QL42KC
	r91kow9v8QXEB0OK9kI6fsVwNx8Q4kjESn8GuSsm2z09cAtXii2GmuUXRoqPeDB2
	seMPscUiztSXr1W6QzfsZSl7YmKVKf5OWBNM1eJYbqw1RSl4KO/DALPw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wxmcvmxu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Aug 2024 22:36:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47CKKBOl017686;
	Mon, 12 Aug 2024 22:36:31 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2173.outbound.protection.outlook.com [104.47.73.173])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40wxn8n0n0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Aug 2024 22:36:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p6EA51s3vz8SEdaFNGoMRbHPSPR2FdLOlGmedqpLw7HD82RTSAiwmZ5GVvb5R40hjqbGGC1xoNZmIwJEfpyH+wAjTY0eAcYzB9PvrRhGXP7ioWMXt4fJU7KJ9sc/vuTNzjb8TMYSVeO87ripN3+pIukYNbd+P4P31Kay41DTVGswR1H6IBGh9Ut8rCB0nDQjXa3HPRaFzX/MjOmUPy5TsH/ea0IXCqmSAZ2UiXb9JN8AVnb6GArqaRRE5/HFZxncV7R+DNbB0K6Eichlavi+Dxh3P88GAMl6xCQV2DoGiUwHLUxq1o+ZdZ912vgnWtMiQ1j2qz2ZWEDg1aEyH63n0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M/3T6lWQfyWOOZ7tx2ePCAE3/qjOxrE45+Hk2Ay9y6E=;
 b=LX8Y+0sdCLR5+3SN+Ighczzrhpw9AgxgNlTuWg3Veqpd+BnutBSfBLA6dbYA+7Corh9R0EyYjhWdp0tZaonymlfoI/iK6qfyc0lyjQY73KjejZsaMYfC5Q5jSLWtnGWdm+mTfxAcfZsO/ij0kZ0X6l28JfBMo2t3UHo17CESOGN5hnRtZBwuW1Tk4F/jGi+bQa/Sj7Sovi76arePmIfVA78PEL10vILk1vZiEpn7ivhNRrlnw8Rbi4NiOaPD/rFFKWueLOI3KesbLGgF8AYTGwfhC9ZIx0RvMcd9nfDXrFy65mOll23CNhdWIQlAVdBiqN66NPJOM9lfnj9HogVdyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M/3T6lWQfyWOOZ7tx2ePCAE3/qjOxrE45+Hk2Ay9y6E=;
 b=aoTZHIpzy6VQOY8Krkln0j43FtVamMeaX2zTPEGtj2b7MjrfXUgJqzGfzCrzL6MyONbthxaJi8QW6eE8s/DnG6y0u8kcrDb7FsgWx0M/qyJ8zPDKXQ1rkuGccKCru4usFwn7J0eVBTDBdtZQ54w+VRy6/5haw8Di1O7UlWZ7BRA=
Received: from DM8PR10MB5416.namprd10.prod.outlook.com (2603:10b6:8:3f::19) by
 SJ0PR10MB5718.namprd10.prod.outlook.com (2603:10b6:a03:3ed::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.13; Mon, 12 Aug
 2024 22:36:23 +0000
Received: from DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a]) by DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a%4]) with mapi id 15.20.7875.012; Mon, 12 Aug 2024
 22:36:23 +0000
References: <20240726201332.626395-1-ankur.a.arora@oracle.com>
 <20240726201332.626395-2-ankur.a.arora@oracle.com>
 <TY3PR01MB11148449A97A47AF875036994E5BA2@TY3PR01MB11148.jpnprd01.prod.outlook.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "Tomohiro Misono (Fujitsu)" <misono.tomohiro@fujitsu.com>
Cc: 'Ankur Arora' <ankur.a.arora@oracle.com>,
        "linux-pm@vger.kernel.org"
 <linux-pm@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,
        "catalin.marinas@arm.com"
 <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com"
 <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com"
 <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "daniel.lezcano@linaro.org"
 <daniel.lezcano@linaro.org>,
        "peterz@infradead.org"
 <peterz@infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "lenb@kernel.org"
 <lenb@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "harisokn@amazon.com" <harisokn@amazon.com>,
        "mtosatti@redhat.com"
 <mtosatti@redhat.com>,
        "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
        "cl@gentwo.org" <cl@gentwo.org>,
        "joao.m.martins@oracle.com"
 <joao.m.martins@oracle.com>,
        "boris.ostrovsky@oracle.com"
 <boris.ostrovsky@oracle.com>,
        "konrad.wilk@oracle.com"
 <konrad.wilk@oracle.com>
Subject: Re: [PATCH v6 01/10] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
In-reply-to: <TY3PR01MB11148449A97A47AF875036994E5BA2@TY3PR01MB11148.jpnprd01.prod.outlook.com>
Date: Mon, 12 Aug 2024 15:36:20 -0700
Message-ID: <8734n9s717.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0158.namprd04.prod.outlook.com
 (2603:10b6:303:85::13) To DM8PR10MB5416.namprd10.prod.outlook.com
 (2603:10b6:8:3f::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR10MB5416:EE_|SJ0PR10MB5718:EE_
X-MS-Office365-Filtering-Correlation-Id: 01c6e67e-730e-47e4-4862-08dcbb1f3175
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?76EyxXpoUdwyU39cRP+EsKTt3gRWyyw4qTQPsBo0QjmujoVHEJaYC5U/IYCC?=
 =?us-ascii?Q?jWkyOwvurM6FoNazfK4t8XnSkhisFhjjA/WXOTWT3LoFtE819/UrPenIbTbm?=
 =?us-ascii?Q?JnbeWnqPmGo2r98kHhcE/+21GEuTXVrmwspuR/67V1tcvc7k5a3P2suRVYoE?=
 =?us-ascii?Q?QE8qUbSejxkTbR5HgWWwwX36n7njhzCF1NDd0KXSdbZocylJzUCrFHL/Wy2f?=
 =?us-ascii?Q?GXoi005sdr25HmVOJzaGDO3O7/EDFgkvHDnygtB9UddAlCiaUTlRyXNsWErX?=
 =?us-ascii?Q?tVNCvppRIf12nvoCO08oViyCyEtXAndLg5UmGTPZrv09zggjgWFMVZT0TgFR?=
 =?us-ascii?Q?envDnRug5aVajP+8P4vGRsoYtjbHBBnpHSPJvJIhpOcJXuV97vIT5oU+71Qj?=
 =?us-ascii?Q?DKWN5LFFmWU0pzZMS69jTDAItHyalS5l/IM1bGdnlqhUjX12tUCyo1ZML+wt?=
 =?us-ascii?Q?hAiwlEgpmNl+bF0ZxnyZmOuTxGRp9lUkB+Mq4bTDz1igDsnZlVtlyHn+lQKu?=
 =?us-ascii?Q?naQ8wWy1pBDKB1U8wiRc9sXHx5SPF5tCoWAVKrOSpiIDgkciVJgsjruFAJvK?=
 =?us-ascii?Q?6PoTyKXCkMNi7OdTWkbX4B9cECnDdDCmRj64y7MQCN3PS4EmweOZjuce5yqR?=
 =?us-ascii?Q?AyPxEUZlQNvUDqxJKJAIv2Ah4mZpOJuBbqZj7lDGsRKqQEdFQO+bKLKh628C?=
 =?us-ascii?Q?pfWbNSlMrdHiZk+wfKudDRAYfrC0iQ9bsIIw/QleW0oA+G8oeHw96aRSh68B?=
 =?us-ascii?Q?dIa27Y8R7PQofCYW5iimpt+HvXNV2JxZG0Bm/BG5KDVS/AgwA6BOLA/2/BbV?=
 =?us-ascii?Q?pxHphwE23Qr/hPo7kF5nxB/p5DrW/LIxKcP9bQxv3lTTKs+QMxNlRs7P3oyf?=
 =?us-ascii?Q?lHKFexEsVc5MitrKBSa+kBJCoMP2aEbDPiY2bkaAVlpEvepeaXEJ9PpfV5f6?=
 =?us-ascii?Q?NLtSzdviM9aT5kCyjl314OkpXAWu7VdJdJcggJcwzNMbKMQWWYzecA3rdiGk?=
 =?us-ascii?Q?8MOE9EuYqGU78E/LZ6IIGClponUcGRe6QTkjJcujRygV4EtcVB5AFohdzXMb?=
 =?us-ascii?Q?V10Leclc7JwVTmEchsfOL6Ab2i5ePR1JFjHDU/M3i0pfVZLbZ92wV0XoFgyE?=
 =?us-ascii?Q?eEFW/sdbTXmJFLZwI6a6yLKNMvdE0pIIQvVr41p2AnuDnU2c6oMvqCVdImES?=
 =?us-ascii?Q?ILkW1VFgCsB0Y+xRGc4SD6taAdeUtSRy+jYDyIU2eyeTrGkjda3e4uYmaQCb?=
 =?us-ascii?Q?kBIu7a8JwDYZ/P+7bPlC1BN44hEf1Cz7eWHzUAZDFY4UCan9HOeOZXRJgaE9?=
 =?us-ascii?Q?pXoql8yQIsZG80psqqwv8gkgVTlulQ+I7uS/E6SQyYmiSg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR10MB5416.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?anVqjgdbbEsW90AsChOxjPaEAN4eRIVcJiPa+fv5vNzlYznhz/pZA8Rx0pId?=
 =?us-ascii?Q?qnj6cKCi8VV32blPjB6EI8IF0UJvf0u/GSAzMajq6aa7bwGDOaz3tGIc+Phb?=
 =?us-ascii?Q?D2n94gl3lFa0QVVG6vgWFm/tr3t5Ouk1WlWe9OZqvAw4B2PB+Cs5SUtnltyK?=
 =?us-ascii?Q?cCNUSi5PvVE7hTqkvbN89NvAgBwowTQqaHzASTP7qGBgxFFU/mo4QbWg8vop?=
 =?us-ascii?Q?Y14uoMdTLaD1MLmkpV1p6Bx/AlUNmyw9jOtV5Ks6zmNhsTsLsf1f27wNGOAb?=
 =?us-ascii?Q?8PXMzcNWATzV0Ecnz5gOTurW3Vs+kBru0PgpTFlzYfmZtdlgyR6qKfTS7HKF?=
 =?us-ascii?Q?+lst64Zg9E/bYeEGdPVPOKOKvhWQ+eudlIMLtb8ezAE4WF0WG4WUYNhWQZjP?=
 =?us-ascii?Q?c4J7UmqY9MC4hFcXhrxiLH5Ndmc7HDRqokLMv9ftubblqoIKd7XSrzyifH2p?=
 =?us-ascii?Q?/yfbd1LgDUHh3e+NSEgZGk7QBC7FZubts5jOvZIaCE49g+K0OVjOi8JcP+7y?=
 =?us-ascii?Q?w0Ptt+VAKkvaaVRW06mnJbbtuJLE7J9E8mOmdTQzfLIu2k+1NMvO9c5s9e0d?=
 =?us-ascii?Q?4C+KAOGD+Pw3JkVTCuVqzui33cSDciFR4jJ1Q8bsNDqkFAnTeBERhive9+L0?=
 =?us-ascii?Q?Hr0kIi6CrX4gMhWVeLm2fkXhgbXtYO2rWad1izxU2vwLPhwjAnzSO94zHBUH?=
 =?us-ascii?Q?p1bAsm3qbyZbRIfDaJY19f3YurrCloqcJxqj3uSyRlo9SvKLY+KQK0mecsx3?=
 =?us-ascii?Q?IoH3MnO61LOpwd5I/zzTZo6xV8NCDqFW5664+dyE34MH+PqC31naCf0RSpXt?=
 =?us-ascii?Q?66vBsXR8C/IMyugCbT40en89oPF6/n7P3QcI0CVylxDGv+BW51K+nGbtLmvM?=
 =?us-ascii?Q?W8VHBqltnCxQ2t3qnbk5SDjyCoUNFW7UJHNvJfk0r/TPQ1Mrl2DLyq8Op4LY?=
 =?us-ascii?Q?Hge5jRYub6wAX4jnQpzwXb1C4UMuNxpggq+gd5Xs114ekHblLpLCjT7zAwaY?=
 =?us-ascii?Q?/IM/uLj7AE+VR8fzDpkBewdG8ErmUw0tNq3LVt8K+QgYwt3QVihx9AKc0lR1?=
 =?us-ascii?Q?uJpj8xCM6QbAT/mnX4Q8QKcpNqJFU3s8r9aGmqWmwws3kv3QsrGrxokceF+m?=
 =?us-ascii?Q?DO6mJigXWZbquhR5sPniY/Wnz6eI0E14jLbb3cwmzPCXOE1Ytntwfz66fMcg?=
 =?us-ascii?Q?xUoTMy1oB8ElUQYaqw+PpSTeoQ8QoGbvNqMUAjG9yIRcUUN6oZ5r/o82HknA?=
 =?us-ascii?Q?d4aY9InKJw7mnQ0PEw/gOP71n1fC7AMeej8ugoFYiOyP26shJFu5A01aR3XH?=
 =?us-ascii?Q?GAaqOAbG183tBmQLI9JwF3ojgRkieQR513dNvZ9ExDpmo/ANozEicTjso7Xp?=
 =?us-ascii?Q?Ii0eK3mAIqZBceD7hkFq8D1+Cka7xklHFwrVHdeR5w8MooagfmtfE6Zj1Dhd?=
 =?us-ascii?Q?5nNr8xXIb9cHi4dW7aEtJSVYfTKXTdzeQXzKx066N7v73dZrN+xRlGbE0P3k?=
 =?us-ascii?Q?NEN+10ULZ1HC69ucpvcrQlitWSYqzxvEc86Y5G7ABpNM8rUR9OKW35L0wreZ?=
 =?us-ascii?Q?NyjyvWESlA7zTuiV8HXtj0ShmhASrLJ0ADaQCs7P?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4G01CarHd/XszIH6EPRLbQ62G4v5sVpNo8kuLpRPJhk/ZfO6HD3D16WZg2Ud2D4Ie6lBfL4FcBzVGLsoXxVW21SIagInO/1OXplEzM80wR1+NKuaYGCESdVLAwuOXvqsl18+Kq7CxKjMTGfq6e5rUGS2YV3honyUfZFcG9tX9NZTGk7nIAup2yqIaY/JQmrekJYx5Hd4sRsjNr45YVZyapFuCL1+zJTkgY+i5SZE9fVhRACYm2c86/u+IoGMejDgkkVo2c8k550iVSeIlzqq3LRnfcfMv6tLAuK+JZIuN70R/rrJI5UZ4lKH5zu31GQBySPuONk6Xr4dPcLxJO/Z3uiQFCFZOCQOWPeiL+UTOMZgG8wR2o18LSyMLr4B4mhP005OyfCBNiYlD6DplMYzVTRPqGr/tjDfsELC8raRMuAyO2nKXxF6USsKVBBlWnQTBH+383cTA/tggUp1iGcEHEd4JqIIjRlQA/Qn6vfZgkEz3M7BL3agSo+qeCrwCifM07WsYypma0fPtYA/moRjogFwPF7Se/qbof2M+xO5mlGIDXdIIJ98e8QyLsMGkx4Oz68WLCDjGBOGjtWY2lY1RifM7iD3gbQtToxIioiyQuQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01c6e67e-730e-47e4-4862-08dcbb1f3175
X-MS-Exchange-CrossTenant-AuthSource: DM8PR10MB5416.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2024 22:36:22.9359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EAOIpIQDvg25B0xST1ZCsbhWUnZzlzwhZ1LLmOR8zQYH+OfQOa25ccOBq1ZVDnbcmx22FrZRyP/vdbsLZNNiy96fgYvSWWIycGP5pjQd2jQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5718
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_12,2024-08-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408120166
X-Proofpoint-ORIG-GUID: V8hfJ8vKwZjK1SUFscdiv1nsZzziVeGy
X-Proofpoint-GUID: V8hfJ8vKwZjK1SUFscdiv1nsZzziVeGy


Tomohiro Misono (Fujitsu) <misono.tomohiro@fujitsu.com> writes:

>> Subject: [PATCH v6 01/10] cpuidle/poll_state: poll via smp_cond_load_relaxed()
>>
>> From: Mihai Carabas <mihai.carabas@oracle.com>
>>
>> The inner loop in poll_idle() polls up to POLL_IDLE_RELAX_COUNT times,
>> checking to see if the thread has the TIF_NEED_RESCHED bit set. The
>> loop exits once the condition is met, or if the poll time limit has
>> been exceeded.
>>
>> To minimize the number of instructions executed each iteration, the
>> time check is done only infrequently (once every POLL_IDLE_RELAX_COUNT
>> iterations). In addition, each loop iteration executes cpu_relax()
>> which on certain platforms provides a hint to the pipeline that the
>> loop is busy-waiting, thus allowing the processor to reduce power
>> consumption.
>>
>> However, cpu_relax() is defined optimally only on x86. On arm64, for
>> instance, it is implemented as a YIELD which only serves a hint to the
>> CPU that it prioritize a different hardware thread if one is available.
>> arm64, however, does expose a more optimal polling mechanism via
>> smp_cond_load_relaxed() which uses LDXR, WFE to wait until a store
>> to a specified region.
>>
>> So restructure the loop, folding both checks in smp_cond_load_relaxed().
>> Also, move the time check to the head of the loop allowing it to exit
>> straight-away once TIF_NEED_RESCHED is set.
>>
>> Suggested-by: Peter Zijlstra <peterz@infradead.org>
>> Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>> ---
>>  drivers/cpuidle/poll_state.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
>> index 9b6d90a72601..532e4ed19e0f 100644
>> --- a/drivers/cpuidle/poll_state.c
>> +++ b/drivers/cpuidle/poll_state.c
>> @@ -21,21 +21,21 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
>>
>>  	raw_local_irq_enable();
>>  	if (!current_set_polling_and_test()) {
>> -		unsigned int loop_count = 0;
>> +		unsigned int loop_count;
>>  		u64 limit;
>>
>>  		limit = cpuidle_poll_time(drv, dev);
>>
>>  		while (!need_resched()) {
>> -			cpu_relax();
>> -			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
>> -				continue;
>> -
>>  			loop_count = 0;
>>  			if (local_clock_noinstr() - time_start > limit) {
>>  				dev->poll_time_limit = true;
>>  				break;
>>  			}
>> +
>> +			smp_cond_load_relaxed(&current_thread_info()->flags,
>> +					      VAL & _TIF_NEED_RESCHED ||
>> +					      loop_count++ >= POLL_IDLE_RELAX_COUNT);
>>  		}
>>  	}
>>  	raw_local_irq_disable();
>> --
>> 2.43.5
>
> Reviewed-by: Misono Tomohiro <misono.tomohiro@fujitsu.com>

Thanks!

--
ankur

