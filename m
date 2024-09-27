Return-Path: <kvm+bounces-27600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09630987C67
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 03:23:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C02B6283B61
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 01:23:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43AE24964E;
	Fri, 27 Sep 2024 01:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CnzfDRu+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zO+zJZ4B"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF09984D13;
	Fri, 27 Sep 2024 01:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727400179; cv=fail; b=p30Zfbhbivqw7whPRl6tP44U4pGKFU3ChBed+9GSaib+3AMdKpqy533DaMUfJ6kKOCq+Ovaz1Q2Du60Ktqhf/BwK/Lx4J6PBUfM0KRZHJQeG+F30i0D3iIljnD3nhho+/Mv4eq8hKk+vKK7KpO5/8R78b3eXeyFN6GFFfuuykV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727400179; c=relaxed/simple;
	bh=e7fihnFUPiGGSXMOs2YtFMM9+1KapEOCqU/I0vGkYvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FxpvJUCRzxIQRXCx1wXBilOpKMyvHRg70+EbpNu4q6eAxHEC7j3y/82uoWQa+Ajs16HiO8y5K2wGQ2m3oScoqT4OKRAnHZu5HjblFL+EY9KlaaR/hDGtvncYJR+v5ioKhC+Mbbtv9dTP7nbfGgB9gcO93CHfmTNMx95PouuMhdo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CnzfDRu+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zO+zJZ4B; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48R0tmAa027861;
	Fri, 27 Sep 2024 01:22:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=T2WV2d8E66mXBaEVIEIETBwIqZPPsFb7v48xcUMsV+Q=; b=
	CnzfDRu+nmgx7WkvTRji6DCsViliqv4eHruLaiTwWbW6ohYkWfIH0WeHZtjRDZm/
	CGT9SmfVYUeDl90P4AH997mfsGOTvdHKH5CMIE+NcWXCt8ZVgdVxcltTuD6Fpvbs
	90Byf7R1LedykRPz3kZ17AIEi5Je2rSg+s0VGb/uZsNubH2d4Pu6kI1xSIUIb4tR
	bk756N8BWbzyc/MAh2M60TGvoS/PSOC7FUz0eJ9aiZreo1m3XH546XzZFcSpxLER
	Lf3XSAfBhwy2AR9VvHIujE5sMWlsToduwF49Kw+Sor3+8a5hQ7CZm/RxLcCoJnfS
	qStIdMQfUWClt8Yz8VEXaA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41sp1apfqb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Sep 2024 01:22:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48R1CiuY031228;
	Fri, 27 Sep 2024 01:22:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41tkc9frg1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Sep 2024 01:22:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lnjw3MOrQ9w1qNYcXFF3dxAlxcYLwqf7s0ndyDRqHRSIS0T2dwGeQ5ltquBo0laE1U3wIUbt0lr630+CkvGDg2tKo6nYB9EVvRkD8fvuDdOBMt7mkDhVXDrw7qqGgyCUG0oZp1vIG0UJkGMUtFlPmB4zBTa2OK29wo+kYLNv30o6J7ia++2RDX6+YkeM45u8cDQqC79kpNUC7uclNpWwOVpJT+b+I6VSxcAdKYiEXnYakC4F7YM/wiopMySxtW0RdZapbi3R1lLJCS2M0+W7izZIkZFrdDaHSKw2yWHRqpiXe8++Xl5VSCHNSMbRPeveJBg7rxFyHFpkefHDT3XvLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T2WV2d8E66mXBaEVIEIETBwIqZPPsFb7v48xcUMsV+Q=;
 b=X+vvLX/FpcbSotFhGTzucRvNwdXq32YRXCRsnJizeZpWROh+tVf42dcZwRYDdR3TssvDnyS+6bT3/fAaPrmIK7/uLTv+EoS2D8CYWZ9fsYOWXfH1HnQYmVxMMnzDNuXwtPbu4VM6jCLdyvxw/ds39Ss3Coem2/nAKaeEMLLKjNtptAiGsoAIGaljqpPOkDk5QoEm01Lf+6mgI7eyu86XpBoHh0kyfgdO0ImT4HRrS3W1FFL83sWRv1/EkAqhgS2qIJDh4LKgdQkQKsrcnCUeAdPjxhmSxaycqNa7LxDUUzNIhUrD6ZJJouBAxEL8Spv1FiJXtT0ZiaPo1M5fU4PhvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T2WV2d8E66mXBaEVIEIETBwIqZPPsFb7v48xcUMsV+Q=;
 b=zO+zJZ4B87+ZtuVGROB2pTakbla4HzbxasGgUXJZC4BuwozVSj89JCgW0tmW8vq+Dii/qs0FU4Mgq6/TjSzdxa1D9stCKVkr+A1175/U2k1v2t/rNlbzL9X9uhnVAEFvl8aE0TRkhm7Ej53ZStqugJJZXFx7TsZ8AnMbJMvKlXw=
Received: from MN2PR10MB4269.namprd10.prod.outlook.com (2603:10b6:208:1d1::8)
 by SN7PR10MB6306.namprd10.prod.outlook.com (2603:10b6:806:272::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.8; Fri, 27 Sep
 2024 01:22:42 +0000
Received: from MN2PR10MB4269.namprd10.prod.outlook.com
 ([fe80::f430:b41f:d4c4:9f9]) by MN2PR10MB4269.namprd10.prod.outlook.com
 ([fe80::f430:b41f:d4c4:9f9%3]) with mapi id 15.20.8026.005; Fri, 27 Sep 2024
 01:22:42 +0000
From: Eric Mackay <eric.mackay@oracle.com>
To: boris.ostrovsky@oracle.com
Cc: eric.mackay@oracle.com, imammedo@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Subject: Re: [PATCH] KVM/x86: Do not clear SIPI while in SMM
Date: Thu, 26 Sep 2024 18:22:39 -0700
Message-ID: <20240927012239.34406-1-eric.mackay@oracle.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <4274f9be-1c3d-4246-abe9-69c4d8ca8964@oracle.com>
References: <4274f9be-1c3d-4246-abe9-69c4d8ca8964@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0203.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::28) To MN2PR10MB4269.namprd10.prod.outlook.com
 (2603:10b6:208:1d1::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4269:EE_|SN7PR10MB6306:EE_
X-MS-Office365-Filtering-Correlation-Id: 3daeec47-dd61-4843-acfb-08dcde92e22d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IBaf4e5qYh/0NH4+DANNXx+vHBmUulOpy6pZT88HVm7M7K4gt2i/3NF1Y/xU?=
 =?us-ascii?Q?Yer/rrTb8pwl2n6pNuPX5AoDhwcVXf+PRsG/Jf57LKyuiCfXJskzvrJieBSp?=
 =?us-ascii?Q?2LDlLAbphXlAK3qZ82P1z4+OHT80Vn1e9PeqnYMyao+YKhzm/k4usN6OEscM?=
 =?us-ascii?Q?JQ2VWfR4jh2NL7QOvoWyeLbgzLXZ3WHdGBDEaL/OEx+l+a2eK7FqZAkgkvNa?=
 =?us-ascii?Q?we0uEBG1JtGuriZl3CJInWxGZ/Rf8sxED9r5Al1neuS/jLC96Uoul+R/ClIk?=
 =?us-ascii?Q?8Efl6vqsH8SIa+I9KmxFSgdAUUcvE6YMO8v+v5LS6WHGVMHnFAtVb+4tgNC5?=
 =?us-ascii?Q?48UwT1SJijcpf+PZ5k3KMGxBV/WjpUEMX7gd1CvVm5ZxWZKvvOkhvhpaXyJf?=
 =?us-ascii?Q?D4h9cqSlWksnRP+0HyjrnhiJwjr5g6QABiu6lRyzDDbRUrL0Wcc/SUU93gNx?=
 =?us-ascii?Q?O/3HTJOVxDft4Ve1dcKNwh9ow7Wwta03fg+n6xng5MhPeQCjSgw8zbkxH+0V?=
 =?us-ascii?Q?kjCVoXxLU91eRt16vEdGWWmLFDQUlh3huEOSI7Uafte7cND4mScZkIfgtuL4?=
 =?us-ascii?Q?21bDwJuR0MdGPxwRqe02iK5qFTQjOZ891dT6sPY1MNGOmxMFoUyktnUJDpud?=
 =?us-ascii?Q?/NfHeenc4McqvB2wk7CdOBZg3EKfk0Ka9JY1q2o59O4pQMwie4ByYBxc/8F9?=
 =?us-ascii?Q?aDXJBAK8c9AxcTbn0UCE6BGQnMnUhtQojVTPKJILLLmHBhWrCcnmLViJmkaG?=
 =?us-ascii?Q?uAMS50KP5tRlpR01LnorwvZXFoLwg09bw4XDHzCzQazKCwUFzGs7r3VYy7eY?=
 =?us-ascii?Q?k6iV7Tk9/1ieKJeuNEeoozFvtQv0M88qR38Rw84s39cWzt0QwMrKW7bgXiH8?=
 =?us-ascii?Q?glC1spTH0k8+TFcDpP5RPxiO1bZ/7/rptAf6P5zG/XbQp4J+t6bkRVYvaDpa?=
 =?us-ascii?Q?8Z2P6NUnVVUH7BidhQqMuU944A6BDZ1NXD6gs4/2W0aN2Uy3s600mj+LBSgP?=
 =?us-ascii?Q?uu3dwvoMcZ0DGgLcmOR5geAkc9D3IgkJHsN36rdTP/bwCEZy/sHZY+9iBPTQ?=
 =?us-ascii?Q?Akf7d9zgw1IC0nimlapNt3kvhg+xMwu5HLiTVkGdrThrop8+2sHpS/5zbWWj?=
 =?us-ascii?Q?mbe0UurlK+EHeTSn0hzmtYaMMdd3CiCQtiwC/ZUuq4mJrRZARjf/CtvcFfiP?=
 =?us-ascii?Q?55SKp+QPDfgNGLvvBihFfVslCTtQW5x4qA0Y8ySI5VhmZ5lgszUjlCs0G0dh?=
 =?us-ascii?Q?TvmsF1pEBNElH+hLaIqCDS4U6pEjOP8MNRrzwU/L9g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4269.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DKQkSIx3DyAVNUm1IjRORgCfkB+I/KE+6R2eT52zzuMZURkBZSMa2bVKX24T?=
 =?us-ascii?Q?jxUuDdcAyQNncw+Ekoe7XCtKaFHY3n+AfjKapqsmynFI5hvDB3ISo4CQ9JZC?=
 =?us-ascii?Q?7t4ILS8RBTtMPabSQ19JBv99JyqpsliSJFWbSnHsWDempFRqSGeN1R9ieLS6?=
 =?us-ascii?Q?cS2nH6On0Dy7iyzxwrPSV/GEZihafNoLj4yqbXWdmiMWl/hbTinPSvMFxgJY?=
 =?us-ascii?Q?k9LHbbZSGQQrc59L6HdniiKYN1BQoVIQG5vQrz6iPmQOj0SkocbYDhcdoUjW?=
 =?us-ascii?Q?yilWb4gKgO9WDH7goKXvPfPn9iMsZ2RV7NQ8vs3FGlehtrYiUlY61SbVrxr6?=
 =?us-ascii?Q?NqiXqiNMqjuadL/b201dTymyugFYN5U6sXJZzUHUVNczr43QzWlq5STjlqEb?=
 =?us-ascii?Q?6kamZzmw5sorG6gkTd4IZ3/GEaQfCc6tXBhvujq+n97tWD9tJc+s1LkLZhMF?=
 =?us-ascii?Q?X43EuQWmGodxmc8v/mtR4UHqK9OcOrdbOSZAXDJ4WlkVGFD2+mhWUf5qvjJC?=
 =?us-ascii?Q?AXgCCZNGwkXZvuZ1RrZpWZzquabtS/J1vde8JNzOArbvmnn0jYxE1PMxrn+X?=
 =?us-ascii?Q?HuKRhjfXa2nBJNKVxip60vzck8BwzbMB1flNxTRj9nv834Jwlj5jqkptzkd7?=
 =?us-ascii?Q?m1c/8OkWmKw1R6rkinT5L5oLC6B87XPcpYhNp/7w5ERpbUfqXY6i+j6b75Ai?=
 =?us-ascii?Q?iZ82d6ipQj/cKZUmnqmDs7+qmys/b+SpHPRlngtb5N/93WwQGRYOQCjVS8Wy?=
 =?us-ascii?Q?ar5r8bvGiwu9fuqI3+arusTLJokW+Q3E7Csm9/yjx7lwMngmhR2s9FSmEGXh?=
 =?us-ascii?Q?w6OHfYPj5Jvd6bsI9YmnzNFWc7wYNmgPIInlMRSykgFAQ3puN8h7z8OVj6E7?=
 =?us-ascii?Q?AnKbLCQrwImsnTtTZML6Y9fAlMhh6m0ryR61s5+dI9qlZMNqCXLSw95LDxZN?=
 =?us-ascii?Q?+1mFF4L7LNr8Z80y2H296vgw1TDM8p5vTj6YU0rnaRKacue10UNRaKpU/rtH?=
 =?us-ascii?Q?co8uGVcV+RwTXeFTtFi62OJrYHxKy2Rrr2H1NfU8MViuiVfLo5Cxt/f2kcfl?=
 =?us-ascii?Q?eZZtPf7mpLBwr4yz0AvIxUzEJaWWanuJhRtf5j21Ww5WC9I7FWsuXFkwe3xc?=
 =?us-ascii?Q?1dX2yBx0UcsgJGbuATFpR0EtaLJQqjUpqwaWk9cRvBsVWrOD00M6ghuFxm9l?=
 =?us-ascii?Q?W0L6iB1pRTXIEZGKC54vqVxZ5djT2M7ZHqdx49YZuhspfW6UkSHLgZ4WRlvt?=
 =?us-ascii?Q?7cvncrvIeO58yWnLeZTcx7X7sDsrHOoQ2a3pA9KRp0ue2AWn4RUQNDZgireE?=
 =?us-ascii?Q?Tjtz3QKKnO0uAG09HHlV5ckJOXl1XziVWImO8B5rp04VqF4Z/b2Cbot2uu+K?=
 =?us-ascii?Q?vZePXsrbYL1uJEw1YGXfewXFKRwg9ziaqyZasPAYnV1QP4WhvCrN45XQHgEn?=
 =?us-ascii?Q?7BctFbDqHYQu061LMtj7LthhKewzuUgZ2rWv+Y2lMzSK6xLj330j74hTw8U/?=
 =?us-ascii?Q?pWhgnG8Gur0FLxwDitOzoJ3QVAKflhOjLWO+1N0BNQW6VAH1ecrE5uqpZ45V?=
 =?us-ascii?Q?nUyuVYnDNs2CEle7Ko6/3XLIeAUHsXbS7OTW2gn+?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kUZvMyCjUKf3byYHzVuw1M2dxZ8wIk1ci8z3vqVLug+2FwAjbGqQQ/jNByBtlLYlQNN8XdkxvQyNQDyo2xlgVjNpk2Qi+rtz7QJFomhqdOjaSX0YvpSQZocD0PVahhDu1Mtj5lZKvXZWJYPxfSUHLZ0Knwbvk/sd4I/Nslh7hBAF5SL9fVftjPqqIH15TbBGWciEcKRisclO0mqLcsr1a9ZHNirk51uFPlxNt79SrFT4dC9bx1CwqMpie2VVih9smGjLoShnPSmw/D9YIQUUBM57N6PXuNKnbIgGFgZ9v2pG+fSiHhxbaOwrHORoAPVXPTqJ0cGZj4fRJrtE1e+LIGdRNCUi2LbRpreCSMcOmD10ntRx68SzuEoEhpZa1w+Zts9EnWv/zPHJH6FxNYONFBfPsmZDnuv/Nk8YcPVLZt8q0CNlArkGMQXWHoq1Z1bRaTDoaAGF9vy7b68JT8jTPxaQPMeF+yNIHhThxlJNmuHUNq8qu4wzVsDn2w1R6480+pScUVxMcfNH+ADpnlzbGU/l+i3LrEpeDZcakovlI8twZ8HJBR3l5nMJoH5oSBRsS66M8n0EOP1r0OX9gzDoWP3XMP6jRigpr6hfl04oVj8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3daeec47-dd61-4843-acfb-08dcde92e22d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4269.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2024 01:22:42.3487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jb0Jb7L0mpc4HBRuWW2jPjtYU8O1E0q57rd2+ZXu0u2BPHUnukVQ8zzKiOdMrNiZEZipCLvGwTZgJQoQb0NaQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6306
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-26_06,2024-09-26_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 adultscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409270007
X-Proofpoint-ORIG-GUID: 58tKbUGhBIqDJ25WLRwFwMhIp_lFcmt5
X-Proofpoint-GUID: 58tKbUGhBIqDJ25WLRwFwMhIp_lFcmt5

> On 9/24/24 5:40 AM, Igor Mammedov wrote:
>> On Fri, 19 Apr 2024 12:17:01 -0400
>> boris.ostrovsky@oracle.com wrote:
>> 
>>> On 4/17/24 9:58 AM, boris.ostrovsky@oracle.com wrote:
>>>>
>>>> I noticed that I was using a few months old qemu bits and now I am
>>>> having trouble reproducing this on latest bits. Let me see if I can get
>>>> this to fail with latest first and then try to trace why the processor
>>>> is in this unexpected state.
>>>
>>> Looks like 012b170173bc "system/qdev-monitor: move drain_call_rcu call
>>> under if (!dev) in qmp_device_add()" is what makes the test to stop failing.
>>>
>>> I need to understand whether lack of failures is a side effect of timing
>>> changes that simply make hotplug fail less likely or if this is an
>>> actual (but seemingly unintentional) fix.
>> 
>> Agreed, we should find out culprit of the problem.
>
>
> I haven't been able to spend much time on this unfortunately, Eric is 
> now starting to look at this again.
>
> One of my theories was that ich9_apm_ctrl_changed() is sending SMIs to 
> vcpus serially while on HW my understanding is that this is done as a 
> broadcast so I thought this could cause a race. I had a quick test with 
> pausing and resuming all vcpus around the loop but that didn't help.
>
>
>> 
>> PS:
>> also if you are using AMD host, there was a regression in OVMF
>> where where vCPU that OSPM was already online-ing, was yanked
>> from under OSMP feet by OVMF (which depending on timing could
>> manifest as lost SIPI).
>> 
>> edk2 commit that should fix it is:
>>      https://github.com/tianocore/edk2/commit/1c19ccd5103b
>> 
>> Switching to Intel host should rule that out at least.
>> (or use fixed edk2-ovmf-20240524-5.el10.noarch package from centos,
>> if you are forced to use AMD host)

I haven't been able to reproduce the issue on an Intel host thus far,
but it may not be an apples-to-apples comparison because my AMD hosts
have a much higher core count.

>
> I just tried with latest bits that include this commit and still was 
> able to reproduce the problem.
>
>
>-boris

The initial hotplug of each CPU appears to complete from the
perspective of OVMF and OSPM. SMBASE relocation succeeds, and the new
CPU reports back from the pen. It seems to be the later INIT-SIPI-SIPI
sequence sent from the guest that doesn't complete.

My working theory has been that some CPU/AP is lagging behind the others
when the BSP is waiting for all the APs to go into SMM, and the BSP just
gives up and moves on. Presumably the INIT-SIPI-SIPI is sent while that
CPU does finally go into SMM, and other CPUs are in normal mode.

I've been able to observe the SMI handler for the problematic CPU will
sometimes start running when no BSP is elected. This means we have a
window of time where the CPU will ignore SIPI, and least 1 CPU is in
normal mode (the BSP) which is capable of sending INIT-SIPI-SIPI from
the guest.


