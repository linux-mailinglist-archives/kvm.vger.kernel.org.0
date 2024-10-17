Return-Path: <kvm+bounces-29116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BD559A2DE6
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 21:35:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5D07283544
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 19:35:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92625227B82;
	Thu, 17 Oct 2024 19:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LAhgoegm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VfjdYFy4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884621E00A7;
	Thu, 17 Oct 2024 19:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729193733; cv=fail; b=mWEtV4oPu1qKtrfCBtMHl/D6ge7x4MiMGgLBBhkUxxgzgJ9zkXEYS0SPXbxRXpV9GU2RDg3Rlo2Z+aSG+ehWF2D9h0yzQr3/CnmQbUEk/uiy/xiwRkdIT93jDCW9jkYIHRLM/deBuGMhAH1aFbWFqGxtBfRpzPxfKAXt4gNtz0w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729193733; c=relaxed/simple;
	bh=RPFn4J2gVdhqY9nF9gEKRrMSUbTLWmuN6D+nLCRmAfQ=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=Rd1iJo2FOcEGck7lJrFN1JeVVdwcMbx/iHkg3OcZ1p0CvkC9vrokTPqgKzA/cPMDLQWwpXhVzlB5285OSUTbXoqFqJLKLFScblEBLBPL/01npc60nEGSPV1tlOUxfA/4EF6E6qTf/Lt18o44Zco21h9pSfGlC62bppSRaUFpPa0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LAhgoegm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VfjdYFy4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49HFBnhj019227;
	Thu, 17 Oct 2024 19:34:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=RPFn4J2gVdhqY9nF9g
	EKRrMSUbTLWmuN6D+nLCRmAfQ=; b=LAhgoegm7SkC+QPvWhuYpG4H1omgFd+HDR
	n7RgWBKudOSMoS54jI9hbCigbcpxAZgQ/NaUFdP02k+p76RgPv/XfiqEILbKTXk3
	SRXeh7hX9SYjZDt2r8N+jL1DhBmPBfFfnChKnFBH6hWuHCUXvPgYGoiCZXG66OAo
	6Q2Jn0BjgqaEfz5V7+aGqyfzFJb1Zup/ethXm+hd4L7Zwshp+R6AyfI2DlB9edT7
	gwq0ny3g/x7qkIOst/Q8ryCTJ9PbzeBf7P/J8NbOXbIenTGoMR6z17QxH6uwTyh7
	16myXKaN4xPFz2e8BEbfaYM1OH2RbpBRjTypQ7Cf26Jl4unscKTw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427h5cqnn0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Oct 2024 19:34:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49HJC2qe014817;
	Thu, 17 Oct 2024 19:34:33 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2040.outbound.protection.outlook.com [104.47.55.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fjapbr7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Oct 2024 19:34:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j/bB0SYkW7n3XlN28+W0/5BUAuoBSfLuyL/g327fxwQQx0b2XDEHRmX5QeI//onOQwY22sZWIdA3FqsMp4yDrzixpfty0slibjxUuGIepE06oABVjqKsPvF9cfUBTXg75ZBsT962TFxq0ncfDeCl9XX2F7cLmSxVbZy/es5eR2dUuTW0AlfSJvBXgUUU1N2dzE8WdR4V8jDLl9fuQE4gj2N0fRCYYG6s5Yil6Cllruxa6qS6Jq47iUSyAfc54L4nDYsoxc8iXl9Z/NH2EBRolFszh9qo+QJpmm/2nb9yfoYABDHP4yjZHb1EqypAxnTM0aFiDYoaXbulcPdSCiXg/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RPFn4J2gVdhqY9nF9gEKRrMSUbTLWmuN6D+nLCRmAfQ=;
 b=eeMtLz+pHH8nvKSXel2Dk5i7sx4uN69Tg79RRbicRZZZpkZSS78EUWlsoQ7rPQtKPNIdDRL5xbspGr1E4X7wq/GrFh5+ZQCE6H1paltFigD8nWBpaWfKDHPVRaq6CJ1aIGbkV02Jz/dYj4X7JsT7x/ZGe6KYhh9w+535T2vpYcnfGTq1uNm0YNXqkrsLSF3AgK1B93/a4KetN5Fy5Q8IpFtlmUNZI7idl7fbio4ahHouSl+ynsNwjiLi1GoYVeaezYOq8MTYqVPkMJeZNt+B/83WoDjFX6KwW+YWXJ750h5SVVaSZoeP2Y29iL0lJ+5ZwBHhFCL+3ISOakHBxSWjDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPFn4J2gVdhqY9nF9gEKRrMSUbTLWmuN6D+nLCRmAfQ=;
 b=VfjdYFy4EwjFymVeLhsg4d/LrjvKZa3fQPxB0rF7aI37vbIexibnE2SisLn4uYApBL87thXGQoSFFTwP0uIjC1Zlt4anl4fO6/ciky4DB1YB74auTR5pGBrykNk3355WfL1kDPN73BTkxeimvEtn4mzL6KK7K6uIBeFXE0+HH3Y=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DS0PR10MB7126.namprd10.prod.outlook.com (2603:10b6:8:dc::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.18; Thu, 17 Oct 2024 19:34:30 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.8069.019; Thu, 17 Oct 2024
 19:34:30 +0000
References: <20240925232425.2763385-2-ankur.a.arora@oracle.com>
 <Zw5aPAuVi5sxdN5-@arm.com>
 <086081ed-e2a8-508d-863c-21f2ff7c5490@gentwo.org>
 <Zw6dZ7HxvcHJaDgm@arm.com>
 <1e56e83e-83b3-d4fd-67a8-0bc89f3e3d20@gentwo.org>
 <Zw6o_OyhzYd6hfjZ@arm.com> <87jze9rq15.fsf@oracle.com>
 <95ba9d4a-b90c-c8e8-57f7-31d82722f39e@gentwo.org>
 <Zw-Nb-o76JeHw30G@arm.com>
 <53bf468b-1616-3915-f5bc-aa29130b672d@gentwo.org>
 <ZxFUJ05EYumCUUY3@arm.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>,
        Ankur Arora
 <ankur.a.arora@oracle.com>, linux-pm@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        wanpengli@tencent.com, vkuznets@redhat.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
        lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
        mtosatti@redhat.com, sudeep.holla@arm.com, misono.tomohiro@fujitsu.com,
        maobibo@loongson.cn, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v8 01/11] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
In-reply-to: <ZxFUJ05EYumCUUY3@arm.com>
Date: Thu, 17 Oct 2024 12:34:29 -0700
Message-ID: <87r08eo75m.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0117.namprd04.prod.outlook.com
 (2603:10b6:303:83::32) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DS0PR10MB7126:EE_
X-MS-Office365-Filtering-Correlation-Id: 7aba2c36-18d3-46c2-30b6-08dceee2b85e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sGBkh6Ep3bJVRVMIlkMKBpF3hfz1NhnxilH4PEAg/ulWVH/uSsGaeUb19mdD?=
 =?us-ascii?Q?NTulkI7vzllxYTTBRagNmlTxM4wOPazltybLMXrRCBgEu6RgU19dJ9m/rAgz?=
 =?us-ascii?Q?lNYn/10PIPVnSvCX10Y7zHU0LGAW9aVUFQ792b86h9LDybzBm5ts7ViKRjEI?=
 =?us-ascii?Q?ioyadC/6R+kdaLY9eHjgcNKLB+mgHX4Q6tzTgrWVWCpQmeYIIuA6PpScTlfw?=
 =?us-ascii?Q?y3YZb29r2lC3yAES9uv4RTn8kMibcA9iysdyR2cP4Vk8WjR+g6U9LMXqqHCK?=
 =?us-ascii?Q?m4EgQz51B1i+Tf1EwApSejm9OT3qquInBMeUVUUO2YJmYB9kE6QqcTLjKvlN?=
 =?us-ascii?Q?pCttFM9cphewcluV0YMKd65tOwPTYDvBKnqKbmmtuoSxNSoCOq/HeMjAU+Km?=
 =?us-ascii?Q?45nYpEklcU1NcknJGCbw66/MEzID216SH7T7cQfpk45t63J3UuckMDD4MF6e?=
 =?us-ascii?Q?Klhiqfh1cpsYS/3K9Ok7llrRwNFQFxyUF6QgkrAEg/jLbiSxlPnqI5OZ287x?=
 =?us-ascii?Q?WdElCUWQUoHMHnQV8+mF2LsvDWOAUXOml++SeT3UOhgC5QYqOLQjROTfYGM/?=
 =?us-ascii?Q?Bnx8QdEumkOwtsJfMFCClTzJRKB/ImRb0KXJeQz+O791iuAwzJGz9nU3odo4?=
 =?us-ascii?Q?TqzfQETZRC37QZ5Sfncp1WMRMP25cQbT3x4Cl/PlqO8Z9r7FwiXCA4e4ZEcF?=
 =?us-ascii?Q?/9eDbXDYFN4PFrZVcKiPesEkliqGzRgQa/ZnitZb9l3RBz0JoDdiETbvR2QD?=
 =?us-ascii?Q?fE3Kx+MRSV/odIHJacFurf8Lep7NrbIVjzWMJOw1RnqEuHiXikUHLqu19aIi?=
 =?us-ascii?Q?20tOmQcFd4IbpztuYy5qYhO9pgqyqAhTnfRa/OEyiXFsYCnV4meoEkIqbj/e?=
 =?us-ascii?Q?rT850tePTwMgqg3bLrhtlNPd0bxpUaA5yDHUv+qOYbU/AG66c8QJZ8N6Te5Q?=
 =?us-ascii?Q?AK3caOzUwZ+SYi5ogSM7j94S4V6ZpsX6uhFWvORPED+Ks0kFZyoeRfZ0s17j?=
 =?us-ascii?Q?qz6aJgvS/EQNH+JQAAwNeed1F45TzPazV3e37vm701pTR6Ztd+SX/Kt5bBhN?=
 =?us-ascii?Q?frUx055voCG+Kdy+hnQ8nrkT+KM36BdnBiXMdiCKWMcunHAvnlASbEHSUFro?=
 =?us-ascii?Q?Ekkj51xn/d44krUFbl5+hzxd5wx721Ue2eYArx6oLtL2ATRfuoydD+iWuO5a?=
 =?us-ascii?Q?9GWYkBwGAiPoSyDM/OpqK++4Hxhxq9tNtIQ5Xs3PMNzDsK8R7MVVXjFJ4fKv?=
 =?us-ascii?Q?qFK+zzHlFVXUUGqeQKyADDGkpVVzz8jHq/yLPVDT2P05VBX+4ZclpItWvqqJ?=
 =?us-ascii?Q?Z8GvvrHryODSj24c3VyJMDk/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6GVC79yJHzj8sY8T0a4/as+lSFzBAf+2i/cZu/JP0To7/N0Jf/eVMcVu7sqk?=
 =?us-ascii?Q?0n6MiX+VbrjL3/WQfbbX3euLnZlZoSs0H8Ljlgo/c/TCe5a2V/icOnvxFn0W?=
 =?us-ascii?Q?vYE690Au++L74O+cVWdz8q/VPN1bBCVpXziQphHKGsjRjxVDbduQnvEV5Wfp?=
 =?us-ascii?Q?olHTR08hM7W5uex9wpPkgrVMb0LyeV4nKLDFYynD820I9PqtdjCzXmfUhPFC?=
 =?us-ascii?Q?ISND3QzfgRcQTTtX7L7n/UuIYMOA2VaX8GLQHfwuKUavbVclKMG7heym+0zj?=
 =?us-ascii?Q?0N56mnlgyrBkNjIVV/ycLveNXJqGPci/L17aeiTjAR8RzyB9N+kyRiGVMQE1?=
 =?us-ascii?Q?giTUlq1MSbZ4jyaWj53AeHVPMlbC0SOaKWlMy4knTY42RV8rvn+ej21Cf+dW?=
 =?us-ascii?Q?tR7vlUxOP8a3rC+KxbeptaJ9tP6Mi0vnAewljKmAEYJJMxmLN/9kUPebdATe?=
 =?us-ascii?Q?EazK9oIOJgeTyRAG1FuNYKav4kK98THpLcR9Tz+ofeZc+FDBBgRLlgc91SWE?=
 =?us-ascii?Q?wKvuqxfaR357K35MPLMdBtttyBxCTdJKleBYawQEyepLKyCnsJZsLfGTGKS1?=
 =?us-ascii?Q?hu879kSLSFwRiXiK4Dq6geCr+HyejpmDgInB8pWnzg4YK08zLl6rqpAAXYRo?=
 =?us-ascii?Q?4BizuH/O0dX4RX04uBM2+RwMBtwa0tgB4h6jAr9WrDmuwzG1nCLSKOei/o8I?=
 =?us-ascii?Q?zrMn11HZKyTOFSkrWwhu7cVciYXt8LTc6+iZR0IEI4pzHsQkhtVlxdgfhtMj?=
 =?us-ascii?Q?ypK6GvbUy9wJUpNEOdDxGoLggjSGpkTqmQ4pc3xWgj6wbsqzGSXYoWszVH+m?=
 =?us-ascii?Q?Em7P/PcZBAnpmtPATAJZrECX8/bJT8Meux3+qx9xlwMqMngYW8M41tgZgBRg?=
 =?us-ascii?Q?TJ3Y474igadnoZkicSb6qq4moJmQFnd2t2fE3hCgpxvdw/jvPcMuMXX2vtpI?=
 =?us-ascii?Q?Kaex2gTMK1GoCChUPlbnnzGadrf/ZcmXuOjgFN18a0NurLNzrSoD7Sxw8J9m?=
 =?us-ascii?Q?ASHpbpILouCG5VuDMb2tBXeTkGPvS/QvEchfGi1pInfJ4HDIE5UbhJD3CLv2?=
 =?us-ascii?Q?YRgq/IaUuoD70lzW3QezErhndezen/ivi+IyyCjJDdlKpnypxOK5V6yShjJ5?=
 =?us-ascii?Q?bgfAmIZsnUs6ZmRGu/dnaatTohcFd8wiNxHD/qyX24Gd4ZHzap7h8XN6nv3Z?=
 =?us-ascii?Q?vKIKFKUmJ2DUK1+mqqdSoNp90ogDDx49tj+3szp8YuQUKPj8HA7cdNNlekZZ?=
 =?us-ascii?Q?NcG1C/VWI57H8RfblbCiWqHnDYtmtN+CxhLw+Jlxm2nQnL2V1LXeWvpPen82?=
 =?us-ascii?Q?SaZRkj8tr7xz7ae3Sm3UpxOzDzxvFcFPDC3UPLngv0P5GxGoqflWY712s/yv?=
 =?us-ascii?Q?OdwtkndhJYNG4bllGP4eJoWcdm8MvX+tRgcG1P1eoBQDV+Low0WIxieEBYB6?=
 =?us-ascii?Q?BExrMKtxPF/xrtgPpc3XqZlhl1lc4YHTTJX3YZHcsGBPERjUr0oMXBqiY/Bz?=
 =?us-ascii?Q?+INaTj9O5PNFGAfQeOZhzyzQM+ALCDdIfxefaafuKckteoZBWgR1kY1rqwAD?=
 =?us-ascii?Q?8IxJ/lG/fXS5YwQxxqFcYd44GwoRR74aHWihmI3C?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	laT1LfWislH0LVMzsgciF7NFtD+nV8Oh4Kch18bTJgDvFnDzoAfvv+yDu4g6vONHAZ7DvnYrydWXh/txo82D+S1TOQCyZhcjnsESdDPsdCCVhtnOv+NkGDJF8hJvXxWiiiMEkkjZsEJPfMVmLFryh4vNXCeDFL3LeY5C8tn79NzqjZMZxfMqj9VVIRKdHkA3VsplmLsnVQK0TnHgvxVQdBGM5/heA/fFNLtE2rVLZCKNqXYPgGeFliz8HeYUCDpj187RLE3mcbGHASaum7TzdqAQaLoY5kvipoQLUV9V4N/WnTw4mYpHUzrFqtJGnswYf95DbFy0fgLkFZQ8SLr8pLFL5EuEKbk8B9nKAbdB+Y2CGAUX2qxTIS1r/BICuOK2WXgN8VHXLAVQ1+wrDksYwKfyT0O4o6ahO6cS1g7HHIMnXm0m3Vm9Ti1K7SrDarphTnLuS4cVGFjMZNgOvtG1pi9NaShcQ4h1Moajh/0tV76K9+jKsDei2aZBSIhQL7KinYOU3u54OFLscmKG9RhE9KBR4B34rA3A4A7K6bhZwEGMOBZDC8Wx/R3sDO/ea1DEYHmppkKBQX6hER6LsDy6mUieUdiqgofMLXmHDyafpco=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aba2c36-18d3-46c2-30b6-08dceee2b85e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2024 19:34:30.4860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6eF89LWIfcPOno+xjUQ89f06y5yvZXpUBGkmjy0JZ1TnS9yT55qdfUisy83Qo7L968dA/0QOOkPbyZ/EKf5oUxVFtvPVvJv61LOawqJ1SNM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7126
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-17_22,2024-10-17_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=737 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410170131
X-Proofpoint-ORIG-GUID: v5h63TPFuabqAIjgh-0I5-NetN8AQBtL
X-Proofpoint-GUID: v5h63TPFuabqAIjgh-0I5-NetN8AQBtL


Catalin Marinas <catalin.marinas@arm.com> writes:

> On Thu, Oct 17, 2024 at 09:56:13AM -0700, Christoph Lameter (Ampere) wrote:
>> On Wed, 16 Oct 2024, Catalin Marinas wrote:
>> > The behaviour above is slightly different from the current poll_idle()
>> > implementation. The above is more like poll every timeout period rather
>> > than continuously poll until either the need_resched() condition is true
>> > _or_ the timeout expired. From Ankur's email, an IPI may not happen so
>> > we don't have any guarantee that WFET will wake up before the timeout.
>> > The only way for WFE/WFET to wake up on need_resched() is to use LDXR to
>> > arm the exclusive monitor. That's what smp_cond_load_relaxed() does.
>>
>> Sorry no. The IPI will cause the WFE to continue immediately and not wait
>> till the end of the timeout period.
>
> *If* there is an IPI. The scheduler is not really my area but some
> functions like wake_up_idle_cpu() seem to elide the IPI if
> TIF_NR_POLLING is set.
>
> But even if we had an IPI, it still feels like abusing the semantics of
> smp_cond_load_relaxed() when relying on it to increment a variable in
> the condition check as a result of some unrelated wake-up event. This
> API is meant to wait for a condition on a single variable. It cannot
> wait on multiple variables and especially not one it updates itself
> (even if it happens to work on arm64 under certain conditions).

Yeah that makes sense. smp_cond_load_relaxed() uses two separate
side-effects to make sure things work: the event-stream and the
increment in the conditional.

I do want to thresh out smp_cond_load_timeout() a bit more but let
me reply to your other mail for that.

> My strong preference would be to revive the smp_cond_load_timeout()
> proposal from Ankur earlier in the year.

Ack that.

--
ankur

