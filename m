Return-Path: <kvm+bounces-46290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FF83AB4AF4
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 07:24:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE8007A3BF2
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 05:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E4C01E5734;
	Tue, 13 May 2025 05:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hqn/bRQF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OG95K491"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C153D529;
	Tue, 13 May 2025 05:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747113851; cv=fail; b=LrubjECTzO+SZ48JkEKfJuZJg6Svm+WUBG/9f2uKcvxZR/qIIGq56PmxgjJuKV1fZ1ctlvVupbgEJTTEsa/QBL3INfEHJZ+YnQ92Xa6q6VV5qpmqwwuEJazVqozXt7X3kpZMW20Md2XeQCSVG+3BVaaivzZAspzFAJTss3e9Ft4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747113851; c=relaxed/simple;
	bh=Sj9iLX05WEXyyKnHkckL9xlxVumiTY/mY8LZSqWA3OQ=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=KU2KcUnNcdHdOJ1rJqbFrlN5bVl8s5+Bci0UVktCbJcU7wzhlBQDU+2/rgM4sJ33SD8Rq55gOIX3YMVTKy4pcmH/ONisRhbtKqVT4KiLjfZTGzVHRvRq3DZvhQ/QikH50Hth8JR+brVQJ2sMprbT+XyIfrghfC6cur3NpfbAAeY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hqn/bRQF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OG95K491; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54D1Bucr030151;
	Tue, 13 May 2025 05:23:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=puu9o4wpDa/06oZvjm
	vbvPIIxcMcVflafkrtL+ezBY4=; b=hqn/bRQF9Sc2qu9clvXTkefqFF5O9C/xC4
	buLPSJIMPN8TP1m1GllshPrjTVGWxuDZxU6zJKwfQSLq/iieVYCWa1awuf/W87p0
	jfECU2fGo9Bii73Oz5XSdJvEeQJlgzIwR0ZOAfPDoIklBllBCTrV7mj6a9A2T0d6
	kyQ0LiJredH4AFt9yk8rM1ST/4pFSA43TodL08ZF5DL84CYDobm00RIAmBYdzIcn
	JUDAQC6y3gUHzNZoZgosg0nhFNiZ8hF//bUzJJr+ilzD0HJ/X9ON+0Sw8I+PqdC6
	I9sLQc3hRfr5MhcVjuf64MBC4Zeq1SLsAQWrmE1GgBMTh+dmA2BQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46j1d2bven-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 05:23:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54D31KXg002735;
	Tue, 13 May 2025 05:23:31 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46jwx3v5dy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 05:23:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UYTBPbI5cpbjIc9ZMTh3bsIV5RRjupIuhbZLKZioKgR0L80azjPIe6r9iuv7wydByuAUU8zCZrwbKnE57chXxjfKSAbMknMEuzDAhlY3NDM5d1WCtuO2oZWSUTJOv7xCFC8XWMzgzFqa1uRf79AyTvWfHgnQ8mcDJ/elY3yhm6v9+vvS93WG0SLbFCpZvIs30Zpa462Q1qxFNdXM7h/Mgz+R8s0x9idje9cencr+X2fWh+0ioVNYtQ3tpTDreEz7bTtJxfjy9Ok3NCt5iCEA5kQ04XLJ4WWUCBfKFy/0eDIJBGuXiLlZYs2ltNynUd5KlyQx/wuXR+X/wGM6RIc7xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=puu9o4wpDa/06oZvjmvbvPIIxcMcVflafkrtL+ezBY4=;
 b=T3iaCvH+ab8Pj3FFzoblT+fPFlghKdcchlNo3QxIGdSE8Z1jBED2Bk79HTisEBEFk402GAsKo1pmSdxcknwPXuKO2Gdln7PHLvAQ8g1X1qJZkCQkbmvyw0yoDBwgSV1gDpnpJM8pGUyKiHQphFNg7UuiExUA/0ool0QyaIToWIi7vXjEC0/tfOt7hvaI5aL/PX15zXGDN5cfnRbCceIJ4b6k9EdCJ7WHhog1xVKe0AzaQEbmBZepHSg98ZZVFmmVhSqL8OpxDPLIlX/6z0rR4XvN+kAuZduWVUzodwsX3bAhHduuoj1oHXUZAQBVPMZhtpzRREWxAyvRU6wp1AcXSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=puu9o4wpDa/06oZvjmvbvPIIxcMcVflafkrtL+ezBY4=;
 b=OG95K491ij4zRK1H/pYAjbK2J07+BrB3wuAFjycdqgrgVSljMFhzxt1IFce6iOrmZFz+pjwpuQwqmGaCLSpcuK0l2mXQp+nXopTqVvMmpILrof8urVPDlIue0kcE5UbvYY/QvbVJ8zLUi7Cap24QrSMPOqiubZa1iKtIlsZkQX8=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by MW4PR10MB5884.namprd10.prod.outlook.com (2603:10b6:303:180::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Tue, 13 May
 2025 05:23:28 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%6]) with mapi id 15.20.8678.028; Tue, 13 May 2025
 05:23:28 +0000
References: <20250218213337.377987-1-ankur.a.arora@oracle.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
        x86@kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
        arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
        harisokn@amazon.com, mtosatti@redhat.com, sudeep.holla@arm.com,
        cl@gentwo.org, maz@kernel.org, misono.tomohiro@fujitsu.com,
        maobibo@loongson.cn, zhenglifeng1@huawei.com,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH v10 00/11] arm64: support poll_idle()
In-reply-to: <20250218213337.377987-1-ankur.a.arora@oracle.com>
Date: Mon, 12 May 2025 22:23:26 -0700
Message-ID: <87wmaljd81.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0229.namprd03.prod.outlook.com
 (2603:10b6:303:b9::24) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|MW4PR10MB5884:EE_
X-MS-Office365-Filtering-Correlation-Id: e0bebb23-3dea-4b18-2335-08dd91de4a9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uf3BOf2s264N4f6UfdjA591cb5Fc11+zW5MH+xM6g/b6RiPvk0wgWOvVl+kU?=
 =?us-ascii?Q?KNzrU+BZTQRuEOtnVgg2Co+RksMYAZFDvcblZ7f9e/Up/6XfK+jUsUXNnBo8?=
 =?us-ascii?Q?0F2zbwf0WbR3EyF9bWfHYCdlTfEvyFo/EsiBTK/oM7Kac+GJTLUo0jg4+lx1?=
 =?us-ascii?Q?gikTQTG/nM0gx2jlp77DrG8Wqlr5bO74WI9SkXmxhfxZ49USbdWFSNJvM33/?=
 =?us-ascii?Q?qbt/mhzH0C8645peqP4KQ8+Z26VT8+7VFJieu9TN31+BV3uv0lE1DRB3gb/F?=
 =?us-ascii?Q?tbuUKz5Yj3dpV8lKdHqQTukX8QLYNkAOjYfgY+WLtauBzMf5XGBBMx0wHO8n?=
 =?us-ascii?Q?VGoDTrNc1XR5GDhsKaV9rSoGsWRpmo3mcqGgSebNE1bZ9XJL7+QZXyBhTzlb?=
 =?us-ascii?Q?s8p3iTC0+pVqdA0hl4Iewy1M0devZNQfQz0eNnyq1ZgasGo0GMtzxAMqSphE?=
 =?us-ascii?Q?x7aTdT3qULgTGxebHz6Pqy4SCc6S3ALca8dJl7p27EuLOsMChEEdYj5DvRU6?=
 =?us-ascii?Q?wa6RosjJoBsweDN1ZGso8IonjlHCHsmWn9CkKgrA8wxg9d5JhMzM5/SL0dun?=
 =?us-ascii?Q?DlZ4G27TWL+19QeFN5+RzB3d5uWP6rZFkZbxlWrT6HfAXiXMXXHRCtORsD0F?=
 =?us-ascii?Q?nK8A0GpVuG6oqJFQjKkwfrvA3fSozERwemGWhu1EMtETqPMm1uLpNHkm5D89?=
 =?us-ascii?Q?TPko3KkEg54pKxumuToVmNm6k5szIc1G4ShneQJHB6u3Y8+IbjnTHqUaZ3yF?=
 =?us-ascii?Q?UqN4GxTkebbOX/JJB/LRxfZ7vjcHJjA3payLP/dU0mL/7oVJm8/k7+I/SZ+I?=
 =?us-ascii?Q?7N5sgce/h29z3o9jfr5YOXtbce125LwDxJyInuxBxZQ0aOcNAQF+XQZo7O0B?=
 =?us-ascii?Q?rDK7xBcJmS1XF3OjzGkZPkdChdK9BdVYnz20NtAUxcOIp6RnGccjRNUvo6RL?=
 =?us-ascii?Q?IaXSbMaNzUMqcCDIa20mvZ/hp8ero/6jji4d2jtXtLiubOnxrBH71N2FZOvm?=
 =?us-ascii?Q?us1FA5QSmZdtdQYXhEoviYwW8vKmR/fRXbT2sJ6V/gHIDzPRWxw7sZbYtcmk?=
 =?us-ascii?Q?r7NwOFbrhnn01zaP/aHMzyB0iw3dG/0wGQLLl8N9xnXizWGpDxaxnHyWy+nA?=
 =?us-ascii?Q?fqDQD4sLcnRIO3dscrFjp+MAtmleShqMDMLqcD5aR2VF6uzjykItU4pSSIsT?=
 =?us-ascii?Q?bD4pwxHlLAIkJQ1vcLjkp/cMu3PWh5ckcf2f3JCifOkWsqEdfbmWPzn4L7re?=
 =?us-ascii?Q?Xf42HRTNtTVd2h2zoWuGnqij0BR5nhYLCHwWe6b8OhWhFMbtjhMRgb9+CTY8?=
 =?us-ascii?Q?5rtjeTYfwGvg/gLXZjQUKC95oiH5Xakg3xH/EdQqCWJ7LVdY09SytR9jCvpD?=
 =?us-ascii?Q?Kw4xeb6hYEStqD8lC8LwclxRNkHsfnc/CN/BhmiV8EAbF2nqGDNfPyenAR6W?=
 =?us-ascii?Q?6bIRQtjEJ0AtxMocjDfiqEtugzsdX1Hx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dmvMyrxDhGyquO/oTcGB9xoOGLwfD3g3/fonl8KqeMs3BsV+D8owHu7VMnUb?=
 =?us-ascii?Q?tXHdl+k4xPvVqT+VrReX0005Plo7wQfgwJ+eNNDwIdEUM/AnPtE2dK6tJx4a?=
 =?us-ascii?Q?JOlEpNZLWNeNOLPSXXX39ZfmHh4BqA/zC3SutEtcfYGmaOGgq/mjbPJbVBGo?=
 =?us-ascii?Q?byZVjGWQ1Hv9TRqnF4KXUuuWzF0d3hiSPpSqGUlTHMiic3VZIL5qwAT/5qi7?=
 =?us-ascii?Q?bIlNx66bZYNHKN7+yhaK3kUChFcZ6uSZqEtZOvOaYqswaYj6KKgQuBiF/p+7?=
 =?us-ascii?Q?y6L1QD92nyR9t7u0GoU9Tj2ASEuhBx6zsMNiC81WzGqajY0NfDFBc48OZUkR?=
 =?us-ascii?Q?LXeoLZPEB1iAz9un4CV+7ybs1R2KWsChfED/6PaB9qFJZHpKl8QwOdb96aSF?=
 =?us-ascii?Q?M1lQqvxrwrHM8gCePgighmJXKsy/fQFPrzkx413gR9e6JvptVr1jQ8ssVw7n?=
 =?us-ascii?Q?YIXsg9jFs3YJV78yEWNpjugHf6+9EIbFLtWgu2+MecxgvV26T+mmG/1FXnDs?=
 =?us-ascii?Q?WzYTel2P85DNCx7Px3qmQqUaEOifuZz24P3aol0zhF1u0cz8ABYkWSFwTpw+?=
 =?us-ascii?Q?fpcolKfeMaH2QlEi2oVnLMyCSQKCsSvXkZB4SGoCLKx2QkiBln2Od45NgKBD?=
 =?us-ascii?Q?HztGZrs/4I2sJjgf3BAO4f5Ois+bi8jekr4ytai3yfX4skjTx/GR5eCyGh7k?=
 =?us-ascii?Q?/DK6yYmdPOV4oe5y/AkaobkpViPi0R4jvtFxdz1pXqw/UcCdlWF1FXRfHliq?=
 =?us-ascii?Q?pOq/GDjAcO9eEFUg+qeSgQnxV+mrhFL4Cm1cwc2mLqft6SEyK2VuUNncMtU6?=
 =?us-ascii?Q?adWvils1O6dN4lL0PlKEKG5Mol6aNL9dXzasIAFHLO/KYQWVpxJBwn4ky/Lm?=
 =?us-ascii?Q?O7bd42+beH6ixszXhUxdphNIrNvb1GxC/p8qW0+YQSGlLG6cNzs+zUco8N3m?=
 =?us-ascii?Q?KQKbPLAMFCVrdRh1Prv6Qg2dP9A4B1SR5G9CDS6OmegOJnbBOQNRdBbXC4cv?=
 =?us-ascii?Q?Wmv0c5naeY+X01Didr7zVfGubjwCxoIIfjZs0sQ+18nbWf7xjbebO85At5nv?=
 =?us-ascii?Q?z4UCUo1pCqo6q5Nvhc3Yz+TUGGaI4AzJIHFu+S9dvc1T6Asa9ersTZqdn2vX?=
 =?us-ascii?Q?gjscm2NSl4MrCLNdg+Oys6oU39UWrw46mWpu9m2kK/Zyjzt4Tiv2OHwd6j89?=
 =?us-ascii?Q?sIq3lmnkCWWc8+ToV/UpeK8r4x0kDDBkKrUBciTFemSWtyPhlcwAHrvdd9jw?=
 =?us-ascii?Q?Py0NVRzB4p4HScL9EWgWfe0vM5APVZqaQAhocpQSi51pY2UyoiM4dKUOQkTp?=
 =?us-ascii?Q?bMSPWAx8G641oHDvSCb7uCo97OL91lOR0cD8yVHpGkzXPvnoGXf9Mm8paxxw?=
 =?us-ascii?Q?IC0XRcJx6QhBbpQzcuuxX6vbE3P35e2viMHihiE8MCokWLM6Ekt/c4k8zqE4?=
 =?us-ascii?Q?NuPRyupOSUACMvYvZofioC0K0E2/XZEzgMkAjS900YzSmq4bkqVNca64XbqP?=
 =?us-ascii?Q?2BAG7Y5rVsoAt5beH+ba+tefEKVum+pfB/frXFoYgtFfzTo9nqVzjb8IiaCy?=
 =?us-ascii?Q?5D9JGOVeQe5tZiVzf/RXT94qjqcBrgn1Mxod0T9+9eD17nMJ4WUPpp982k5v?=
 =?us-ascii?Q?xA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f9ePnLcGoSVlz9Xk1R3lH/Tmt9VazcaYFfA0U67JkEEqHdtZbHAexa+0l4O+B9Q1pCE3uP7B31vdq9lbw+aooL+wvwAmb1eB5YMGqKcYKNSzNA48bhQwBfOvJJxeK6SHdzpoCcy/mV243l/AUSADuqKYpqQz9wdNqN61cFVSjZ3w3SqIhQRPBiuZy4Ht8p4eGagp51sYkB6mqN4xqfHC8GWCkn9Gn3suxHL6D7I9Kn/6XPhXyOB/IzZTyxK69au1MiuFwsSAfqm5TaH7mcBNHtv8wCl8wjxzKNnGBugtB1TyWXIjpHmZaVv3/P7irE0hWYSLAsNqs45EvGfj8yF7lydqctnIlMkZzUyt6OhXfQESRrThST8qYBJIuSLhmbMCOwyhuKkIKFFl5HsQ+b5wDm1b+EewHvg2t+RWV9GbskwbI239t2mMdMymYb+BLPjNZ3amSakxMnmZki75aDFaZdMdcc9cOqk0ITcVmsrC8yzoa0eYlYGiU49Fgi4GFYkqZeFJGf7z6AYhweHIPeJoANaIUxsX864SSSCw1AbXj4KfdWgKV0806msLuTULn6Knd0Hjsmytd/SiDD4fEKLVDL+Y3EsN4ICYvh4zdnvBIM4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0bebb23-3dea-4b18-2335-08dd91de4a9a
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2025 05:23:28.2966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 668qcijXg/VgaM6yYv2lxmo+JotIj6hRXLcmQntiHow+mRuAslm0mL+qKZ8/JNO0NTA4tQEQp+AT5WwSqUXVbMWITvv5rKnclDMGhQPUnoE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5884
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505130048
X-Proofpoint-ORIG-GUID: UJNV9jlQZVdqeLCpkKMeAOfzVKpw8D5z
X-Proofpoint-GUID: UJNV9jlQZVdqeLCpkKMeAOfzVKpw8D5z
X-Authority-Analysis: v=2.4 cv=XNcwSRhE c=1 sm=1 tr=0 ts=6822d754 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=UqCG9HQmAAAA:8 a=vggBfdFIAAAA:8 a=i0EeH86SAAAA:8 a=j_xSIMDgSBEwrIAjW7sA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDA0NyBTYWx0ZWRfXwxkVyFyPGxDx TiIobVAHViL3cVqCWR6xOd2tjZZGKzhFy3wwwbmIfHysPQVlzALxE7tYP2P0o5bpvGh1wguRwW5 JWmQ25RqtiiWJI89mjEuSvo5lb3p99LilWqamnjnD9ci9zgF1j0th2Sh+CD3gqz7zCpgn56Ep11
 iSHeo2vkK6fpqSAyLX+av1R05eIb45NsN1ErMOBnolAHTdniS/PMkDY13hnCUkxZeWHHOqagXDo QkySY7ZjndGnpcKPvQBpoUr4AD6sZ3H0QyNvdyhLyOHJIbIVRy3klWSCLY13EQI/wCEm2WZaeX9 yUnudWJigATNlBQJVGaCQpV2LX/aQ0NJe+Di8VAUbRW8eDRm/pNbL9DWzCQCEcKL9ju4sqfr9Rm
 XQieLCO+HAl4xWHrt4m1rfE/lfdfd1tKU/bzWKGitVwRLRnL46ne9r6nd4CeqVsYcXPoLvDc


Ankur Arora <ankur.a.arora@oracle.com> writes:

> Hi,
>
> This patchset adds support for polling in idle on arm64 via poll_idle()
> and adds the requisite support to acpi-idle and cpuidle-haltpoll.
>
> v10 is a respin of v9 with the timed wait barrier logic
> (smp_cond_load_relaxed_timewait()) moved out into a separate
> series [0]. (The barrier patches could also do with some eyes.)

Sent a v2 for the barrier series:
  https://lore.kernel.org/lkml/20250502085223.1316925-1-ankur.a.arora@oracle.com/

Ankur

> Why poll in idle?
> ==
>
> The benefit of polling in idle is to reduce the cost (and latency)
> of remote wakeups. When enabled, these can be done just by setting the
> need-resched bit, eliding the IPI, and the cost of handling the
> interrupt on the receiver.
>
> Comparing sched-pipe performance on a guest VM:
>
> # perf stat -r 5 --cpu 4,5 -e task-clock,cycles,instructions \
>    -e sched:sched_wake_idle_without_ipi perf bench sched pipe -l 1000000 --cpu 4
>
> # without polling in idle
>
>  Performance counter stats for 'CPU(s) 4,5' (5 runs):
>
>          25,229.57 msec task-clock                       #    2.000 CPUs utilized               ( +-  7.75% )
>     45,821,250,284      cycles                           #    1.816 GHz                         ( +- 10.07% )
>     26,557,496,665      instructions                     #    0.58  insn per cycle              ( +-  0.21% )
>                  0      sched:sched_wake_idle_without_ipi #    0.000 /sec
>
>             12.615 +- 0.977 seconds time elapsed  ( +-  7.75% )
>
>
> # polling in idle (with haltpoll):
>
>  Performance counter stats for 'CPU(s) 4,5' (5 runs):
>
>          15,131.58 msec task-clock                       #    2.000 CPUs utilized               ( +- 10.00% )
>     34,158,188,839      cycles                           #    2.257 GHz                         ( +-  6.91% )
>     20,824,950,916      instructions                     #    0.61  insn per cycle              ( +-  0.09% )
>          1,983,822      sched:sched_wake_idle_without_ipi #  131.105 K/sec                      ( +-  0.78% )
>
>              7.566 +- 0.756 seconds time elapsed  ( +- 10.00% )
>
> Comparing the two cases, there's a significant drop in both cycles and
> instructions executed. And a signficant drop in the wakeup latency.
>
> Tomohiro Misono and Haris Okanovic also report similar latency
> improvements on Grace and Graviton systems (for v7) [1] [2].
> Haris also tested a modified v9 on top of the split out barrier
> primitives.
>
> Lifeng also reports improved context switch latency on a bare-metal
> machine with acpi-idle [3].
>
>
> Series layout
> ==
>
>  - patches 1-3,
>
>     "cpuidle/poll_state: poll via smp_cond_load_relaxed_timewait()"
>     "cpuidle: rename ARCH_HAS_CPU_RELAX to ARCH_HAS_OPTIMIZED_POLL"
>     "Kconfig: move ARCH_HAS_OPTIMIZED_POLL to arch/Kconfig"
>
>    switch poll_idle() to using the new barrier interface. Also, do some
>    munging of related kconfig options.
>
>  - patches 4-5,
>
>     "arm64: define TIF_POLLING_NRFLAG"
>     "arm64: add support for poll_idle()"
>
>    add arm64 support for the polling flag and enable poll_idle()
>    support.
>
>  - patches 6, 7-11,
>
>     "ACPI: processor_idle: Support polling state for LPI"
>
>     "cpuidle-haltpoll: define arch_haltpoll_want()"
>     "governors/haltpoll: drop kvm_para_available() check"
>     "cpuidle-haltpoll: condition on ARCH_CPUIDLE_HALTPOLL"
>
>     "arm64: idle: export arch_cpu_idle()"
>     "arm64: support cpuidle-haltpoll"
>
>     add support for polling via acpi-idle, and cpuidle-haltpoll.
>
>
> Changelog
> ==
>
> v10: respin of v9
>    - sent out smp_cond_load_relaxed_timeout() separately [0]
>      - Dropped from this series:
>         "asm-generic: add barrier smp_cond_load_relaxed_timeout()"
>         "arm64: barrier: add support for smp_cond_relaxed_timeout()"
>         "arm64/delay: move some constants out to a separate header"
>         "arm64: support WFET in smp_cond_relaxed_timeout()"
>
>    - reworded some commit messages
>
> v9:
>  - reworked the series to address a comment from Catalin Marinas
>    about how v8 was abusing semantics of smp_cond_load_relaxed().
>  - add poll_idle() support in acpi-idle (Lifeng Zheng)
>  - dropped some earlier "Tested-by", "Reviewed-by" due to the
>    above rework.
>
> v8: No logic changes. Largely respin of v7, with changes
> noted below:
>
>  - move selection of ARCH_HAS_OPTIMIZED_POLL on arm64 to its
>    own patch.
>    (patch-9 "arm64: select ARCH_HAS_OPTIMIZED_POLL")
>
>  - address comments simplifying arm64 support (Will Deacon)
>    (patch-11 "arm64: support cpuidle-haltpoll")
>
> v7: No significant logic changes. Mostly a respin of v6.
>
>  - minor cleanup in poll_idle() (Christoph Lameter)
>  - fixes conflicts due to code movement in arch/arm64/kernel/cpuidle.c
>    (Tomohiro Misono)
>
> v6:
>
>  - reordered the patches to keep poll_idle() and ARCH_HAS_OPTIMIZED_POLL
>    changes together (comment from Christoph Lameter)
>  - threshes out the commit messages a bit more (comments from Christoph
>    Lameter, Sudeep Holla)
>  - also rework selection of cpuidle-haltpoll. Now selected based
>    on the architectural selection of ARCH_CPUIDLE_HALTPOLL.
>  - moved back to arch_haltpoll_want() (comment from Joao Martins)
>    Also, arch_haltpoll_want() now takes the force parameter and is
>    now responsible for the complete selection (or not) of haltpoll.
>  - fixes the build breakage on i386
>  - fixes the cpuidle-haltpoll module breakage on arm64 (comment from
>    Tomohiro Misono, Haris Okanovic)
>
> v5:
>  - rework the poll_idle() loop around smp_cond_load_relaxed() (review
>    comment from Tomohiro Misono.)
>  - also rework selection of cpuidle-haltpoll. Now selected based
>    on the architectural selection of ARCH_CPUIDLE_HALTPOLL.
>  - arch_haltpoll_supported() (renamed from arch_haltpoll_want()) on
>    arm64 now depends on the event-stream being enabled.
>  - limit POLL_IDLE_RELAX_COUNT on arm64 (review comment from Haris Okanovic)
>  - ARCH_HAS_CPU_RELAX is now renamed to ARCH_HAS_OPTIMIZED_POLL.
>
> v4 changes from v3:
>  - change 7/8 per Rafael input: drop the parens and use ret for the final check
>  - add 8/8 which renames the guard for building poll_state
>
> v3 changes from v2:
>  - fix 1/7 per Petr Mladek - remove ARCH_HAS_CPU_RELAX from arch/x86/Kconfig
>  - add Ack-by from Rafael Wysocki on 2/7
>
> v2 changes from v1:
>  - added patch 7 where we change cpu_relax with smp_cond_load_relaxed per PeterZ
>    (this improves by 50% at least the CPU cycles consumed in the tests above:
>    10,716,881,137 now vs 14,503,014,257 before)
>  - removed the ifdef from patch 1 per RafaelW
>
>
> Would appreciate any review comments.
>
> Ankur
>
>
> [0] https://lore.kernel.org/lkml/20250203214911.898276-1-ankur.a.arora@oracle.com/
> [1] https://lore.kernel.org/lkml/TY3PR01MB111481E9B0AF263ACC8EA5D4AE5BA2@TY3PR01MB11148.jpnprd01.prod.outlook.com/
> [2] https://lore.kernel.org/lkml/104d0ec31cb45477e27273e089402d4205ee4042.camel@amazon.com/
> [3] https://lore.kernel.org/lkml/f8a1f85b-c4bf-4c38-81bf-728f72a4f2fe@huawei.com/
>
> Ankur Arora (6):
>   cpuidle/poll_state: poll via smp_cond_load_relaxed_timewait()
>   cpuidle: rename ARCH_HAS_CPU_RELAX to ARCH_HAS_OPTIMIZED_POLL
>   arm64: add support for poll_idle()
>   cpuidle-haltpoll: condition on ARCH_CPUIDLE_HALTPOLL
>   arm64: idle: export arch_cpu_idle()
>   arm64: support cpuidle-haltpoll
>
> Joao Martins (4):
>   Kconfig: move ARCH_HAS_OPTIMIZED_POLL to arch/Kconfig
>   arm64: define TIF_POLLING_NRFLAG
>   cpuidle-haltpoll: define arch_haltpoll_want()
>   governors/haltpoll: drop kvm_para_available() check
>
> Lifeng Zheng (1):
>   ACPI: processor_idle: Support polling state for LPI
>
>  arch/Kconfig                              |  3 ++
>  arch/arm64/Kconfig                        |  7 ++++
>  arch/arm64/include/asm/cpuidle_haltpoll.h | 20 +++++++++++
>  arch/arm64/include/asm/thread_info.h      |  2 ++
>  arch/arm64/kernel/idle.c                  |  1 +
>  arch/x86/Kconfig                          |  5 ++-
>  arch/x86/include/asm/cpuidle_haltpoll.h   |  1 +
>  arch/x86/kernel/kvm.c                     | 13 +++++++
>  drivers/acpi/processor_idle.c             | 43 +++++++++++++++++++----
>  drivers/cpuidle/Kconfig                   |  5 ++-
>  drivers/cpuidle/Makefile                  |  2 +-
>  drivers/cpuidle/cpuidle-haltpoll.c        | 12 +------
>  drivers/cpuidle/governors/haltpoll.c      |  6 +---
>  drivers/cpuidle/poll_state.c              | 27 +++++---------
>  drivers/idle/Kconfig                      |  1 +
>  include/linux/cpuidle.h                   |  2 +-
>  include/linux/cpuidle_haltpoll.h          |  5 +++
>  17 files changed, 105 insertions(+), 50 deletions(-)
>  create mode 100644 arch/arm64/include/asm/cpuidle_haltpoll.h


--
ankur

