Return-Path: <kvm+bounces-32449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CE509D87EB
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 15:28:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4EAA291074
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 14:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2728F1B3925;
	Mon, 25 Nov 2024 14:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dyAlblfL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ItrXmzZI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477AD1AF0D5
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 14:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732544864; cv=fail; b=LsfdTtd8C2zE62HqA3utSHNJJvgmgYEARw1Kvp6lFsX8DnG2FPicGIUFk0Nog0D+Ih1DI92/SZucnzfqQlPlIo0vVaZ0TMSdBpJiBeUtyAL7SuRaUVCi86DrfaVMMMbGV1YpMhkT88EiYTSfUDmprgNn9QnRVuNl+gxBqSV98gg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732544864; c=relaxed/simple;
	bh=nOoEfpB2IGGp8YvQIcXEUIHcBF9AiD/lYg9oz6SIVBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gjMBFOmv7wQp2HbNJ1wSnMwAe/0FU8uiAFz/VkFy4wHTRXYpXFUDYuQN6rNGx6VkR3sGZMuVP/Ndd4kCai9Sy0lWPEqGLSHgheApRwYfhliRPz+uRKhLjEkZ8GABS8wz7qLITBFyALcE5ITCYCKAjRrSKaVmYM8y+kzBB0rl1Jw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dyAlblfL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ItrXmzZI; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AP6fcpS006728;
	Mon, 25 Nov 2024 14:27:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=tMm7sfsa5tMZm+9vPsMqJy+JU6H3ZOklscSFRUBodPg=; b=
	dyAlblfLsgGCFiIaJjIu+9ai/k1VUQ5bKoBDDxDQch/7JsUebco3RS6ZnimrFy2c
	+d1a4ua8T1eLiPOMflLM4VDnRVdH+pJ0oPQP9JSQTY5sqAMbIZi/VJgrHCRAorYy
	dey426FvkgFHrhjUzkhZ8J5RwOTRDXqKXYwxvTS9pr9/7vX3dxrVQ+fbcSuk1pxv
	+B7lquUJn9ci5E47ysxMplXeYS12lF8fvfs72wlPcAcXulAIRpFO1JOtekNIs/6U
	K3ZcxznLdHgC/JnhN05lzJl8LEClBhWxtUB38sfV0dhm0z9M/A993/txy/SJfZIr
	jQJgCKKb43lAPERCmBmO8A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43384au7aj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 14:27:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4APENbjt023448;
	Mon, 25 Nov 2024 14:27:30 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4335g7k1py-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 14:27:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bf9mBq76uxsPPpDOthxcOOfAvBPLvYnldyFqrs3LhogjbAIj1KAYeBpbc40F6jpnMlr8dU1XHOddhyEUvH0lcErWCXQCnvxavzLOVYcUZCJ0bMPJNMYpi7NJQzWt1BrYGeV+KJns80Z/xjAnoA4kWOrsMr5kTCoUf+mxNsIno4Ef2Q1WQTXY4B/lYp9j1/ANzSV7wXQXt24oXwpNa23bVwBeaEmqQqtF4jRFUL9ruvkjstNiWDJrNvK1Tl4ptjgNW4sVBjaQhZjWhNqUnEIj/FfriIgMfy0ZHcjiM8d7j8gJ7DMJKkUMsDokjzZHcXpraWBA0meubnF/ibiSPxYcSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tMm7sfsa5tMZm+9vPsMqJy+JU6H3ZOklscSFRUBodPg=;
 b=VUy+NV4SeSE1roQiW1ABgO3Jj5QERjZiJnbOALI79bEb2z7S//BezqxjnE8suppIXy80JjBlF121QDGfNvhVeq//bxRITQbKGd+rEhSO6Is55ikd9a9Z0METNdpmwcWncLaPncfURjx2DNstIOPLS9cG6tKFbySJj6Z1F4QsPrLGfNe2O9HXqBsvMYWtzmVS3yHREzRVqd8LhbVVEqsWLO9+URiI36/Wp1gp0Fqt/dIJzPItwSSPQUnG/5tz76bPRUTNevSqoPy9u9z7hwVzAafAqWESGKsxy/VDJ1OKCVVlblKkOLmJc2j+j9bypw9IOdSvgeuMlWeXsU7rR/nwwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tMm7sfsa5tMZm+9vPsMqJy+JU6H3ZOklscSFRUBodPg=;
 b=ItrXmzZIijZXt0eccTSA0AzsnDbpfxhQG9pCu2VFfBFFyGrEMKgYD2PKUihmSVX6oQWEQxKywm5snN/31tVIQEHJ9G95x21wR44U4h5FY7mS2TSom2z9pX0aW4SdUr+UolGGgbIK0C20Pon6QMv18k5uXmaa32Ro98uiQjPxn+o=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA1PR10MB5995.namprd10.prod.outlook.com (2603:10b6:208:3ed::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.21; Mon, 25 Nov
 2024 14:27:28 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8182.018; Mon, 25 Nov 2024
 14:27:28 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v3 5/7] hostmem: Factor out applying settings
Date: Mon, 25 Nov 2024 14:27:16 +0000
Message-ID: <20241125142718.3373203-6-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241125142718.3373203-1-william.roche@oracle.com>
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241125142718.3373203-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CY5PR17CA0018.namprd17.prod.outlook.com
 (2603:10b6:930:17::28) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA1PR10MB5995:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b920879-52f0-45d4-91f0-08dd0d5d4a20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nol3CV5FOuL0MM/dXQudAlCt2afV+WN2CUPVEM1mHivm5PX0+8H6UmatY+gF?=
 =?us-ascii?Q?KTakGZPWqmIM/w5zbhPXz1lyhWlgl5G666QPM+xafgYRM0IWjjm6dJo8H9Ru?=
 =?us-ascii?Q?AMdIQYMcw9cQ+N4fZtEFb/wJEY74I+C4KImBmsdf/N5BX7BsPHCiFgh3ClVc?=
 =?us-ascii?Q?4B0dPPlf+pZlW4OYJ8puh8Cwt7kcLCC4OBFEQWb2yHSLUpAsoeHK/QmCjtsx?=
 =?us-ascii?Q?0tUPF0Wwi/qAthPTv9zTWLVJNQ9UUCOHfn19ZVZbt3+4q4Ksixg0iRwDI8Q3?=
 =?us-ascii?Q?/vYK9ohxmfnwVqax1eZePNePvHNXAo7rY1X8IWayQcpzI30bXxgkUD4XTRLK?=
 =?us-ascii?Q?93Fh7wIe0+U/FzEj6xAREwF/JDlxFxDqPWHgiv4Wd62Ut2C3V6S2bwnqXMR7?=
 =?us-ascii?Q?8n3fdvBu9P9CL4HePVufyFEryAHh8fWVyij8KEUoiXC3AdRfKn8rvx7Ukxvm?=
 =?us-ascii?Q?13hrGGrA1yGU1JF5D2EPiSXQ/etkUByEVZdp0E4dZa5JqmVkEB1erZAB3TD7?=
 =?us-ascii?Q?T3C5OyFD7MmpPCwxBjZH1eGae5ZOoAo2pIU+VyNpwjuOBAaZc97lH7QOga8M?=
 =?us-ascii?Q?pmLYtf6hn4kvK9rlSZzeR3c/xDq6P7fCj6oRJ0TkNGDHi5FkEVvL2IniPgKU?=
 =?us-ascii?Q?BChxq7AOZVmp2bwfTWnLBK0JPj/MQH/wtGglNVbl5Rn1VV6EZCZOT8rB2oU/?=
 =?us-ascii?Q?Dq6tZW0ZiG9+U6ORNKtTqn7gaUH10KVdvSiQsY/XWLktbwkq6LzJIlMg8IFx?=
 =?us-ascii?Q?256/IE+zGGYpdzuniA9KLmVx2QDMC6Q4Kobha7M0tVPqi14TCMl98rHA/aIp?=
 =?us-ascii?Q?M4LyeHDUl6DQbtOdfD0We0XjRRr/fWHUG/DYYXfp/8713KeamiDBgawZKBNx?=
 =?us-ascii?Q?vvi7rQ6N2imrHrXcozpv7TIQf1/pVDhxQiIvEWfvhmxGSfJuANZmW3Fh4eEX?=
 =?us-ascii?Q?MIlMQFbOWYtAxrm1u252uGKVV6qekl4iMYVeYDbxgPfqWwCeFHs6VhpFYnKk?=
 =?us-ascii?Q?xaX5otGJyQqflD25xOBtB7BsfdVQ7OrieoVF/w67R+ajVbAmkVcH9ccfB3xa?=
 =?us-ascii?Q?PIyAdBj8ZcMQM2j4QJK1LjU3UuAOEmWetHyjJ0oIp64oliMZI1HcLjC4PhEN?=
 =?us-ascii?Q?gmfi3tVhFXC6QqeErFYR88n8ihcwdR2ZR+iD8TvXM3dZcSd6O/sS6rmNOa+Y?=
 =?us-ascii?Q?aVAD5TYT0WNdZQJl+VpaCvFVgoaQzqg6RM3nVKfCSuQrnBUCH8DqhT4rIQ8l?=
 =?us-ascii?Q?SM03q2oaBWDWDpKP1lkWPg1PNzhMDAqIEIlDljW0Apt1UrKUWd2TYjxJkPC1?=
 =?us-ascii?Q?5MF5Pdnog+t+0hurYjmXLCLBaZs62On0ptmfEqSYVlQ5hQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IO4IS9ecFK9vWFef2QQBg6pODatgIxNHlpmln9JJr6xaGoPwXxlJOj3zSArl?=
 =?us-ascii?Q?EUU3yD8G9naXHpCeSPpj80KvDrmZM+5tCrW2v4aYR5pfwN8uapCNne03ysyL?=
 =?us-ascii?Q?qlPGMybfExEHLFehY7i77sqKO4PuMFUqCq4QzIs+2PShcCv4q5yjPysdNiMe?=
 =?us-ascii?Q?4IkX+iqp49Ri04145r3LufXOLEiYhFIF2aaqtfn1wC686SaY9k255rd6dmyt?=
 =?us-ascii?Q?Y/Nu/Skoc8+sRHIi/iOMpkA7gLkuXumu85TJZpdnkRjayyYekWmWcoqacfWI?=
 =?us-ascii?Q?1ykRjdf80WFcQ3ecf4tF8sapgF1j+j+ob1j1D964XGuNGmlLPT53cqzeIdff?=
 =?us-ascii?Q?jpUIkYHK0/3UX18AAF/J46znUNnpPNPdsznPNlffjXwKZRNUBIZZjrqNxWZa?=
 =?us-ascii?Q?OqbJlp1SQ5rIwQnlWFpcOT4aXAnJ3hIxBRvPJpz+6LuZC71J1FsBUTldn2J5?=
 =?us-ascii?Q?fBI1Rr+p32eH86zmAS2bVTFPTQjIQrau762f+Mqzrd1gDbUYygGWfgsIeAqc?=
 =?us-ascii?Q?Quwl2X+xZNjkjfQR+PKTS7N6BXw9j50PyFxQdljEkWgHqSv8NwbEPNiCYAdo?=
 =?us-ascii?Q?YlRRKmL/1Zq0Kz1SM+zPu06Uih+Bga1w1zVqq6M9L3pNC6YbzM8KuXM/wscm?=
 =?us-ascii?Q?Nb/ZKRjuoheJX5XmzjeJrAIlAYjAVdKpMaKxJ1AtginXOh6fhe2Ki5xSx0Nj?=
 =?us-ascii?Q?gNxWdglstXK5wKk//WNvezDGe21u/jr/XXRgnanBYPuxpSR0mTb90Z+rkP8J?=
 =?us-ascii?Q?ajrG4q4HtakybfObc21P0HstZSHezlPfmqtP+OljrrLK1c7SY+YUXguBT5Uu?=
 =?us-ascii?Q?0OrsLgcaf6mOStBvwrclRQAw1+I/A+rVHWIW/7bgS5xDL4LBQhrLOIxiq3LE?=
 =?us-ascii?Q?iNpqXP6YfRfAP7x2oTsmOf2R07TeNXaUafc/sydK+qv5IC0Ar6R1gwYkeIju?=
 =?us-ascii?Q?93MsbLz86S71fAKyEbKOWFaC3OdaWuoZcugJEwfoGtj1f9v047Pd+2PMjglx?=
 =?us-ascii?Q?MIcSCu/FF+lbUG6NMXo8ns+p00JD2RBlBABRn50sftrMKNbI9+zFJ4EGRkbe?=
 =?us-ascii?Q?IayiIIxq0UeXcSrHvjahPRAqKRqC7Tx70BCj79PHfqYRwvJHod2N9TKaucmN?=
 =?us-ascii?Q?GBAyazoFZq602P7M3idh+djWu/8PkpfLo3PK+alxItP9BMgw/6tPBHHGwTKU?=
 =?us-ascii?Q?wit6cZekycsUEtqy2fWyg/niB2nrNy1CPyYJsrN6e/mc6jnmL6VHfeyNq/X9?=
 =?us-ascii?Q?u9Uf8v4I4S9F9Govned6zLrGYezZyVwIrGcWZ9JeMw6XQj+PJHSbI52mBP/L?=
 =?us-ascii?Q?KM1G9h6RfV8WLHiIi4xvUmYpmMNLTsdijHTxXrNOpAuAI3UpM2c30y7GqJf8?=
 =?us-ascii?Q?U56sCcbZ2Ca28PSKmMYAu3QNI2ldS9R4djYU5Z1wEsFDdne+su1Nau9wsITk?=
 =?us-ascii?Q?1x2MGgKVggwm1gvIBdNDWSZ2L54owsyvbbFstuBGG2txRJNDGw+Kzb6lsTTQ?=
 =?us-ascii?Q?xYGV6BTmWv/9z215g0wvgTwBs8SorsS4em4lb3djYuCDi2dpZTIBrTcxmukQ?=
 =?us-ascii?Q?U+eQq9l+oYaMmLwFPmNrXnbpAKUQLXDIO00eZqL1SYHL7+/s4AY4aB8UU5BM?=
 =?us-ascii?Q?3g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SLrSTZ7f4mpNpJQqlQCtVMXMknqJnXvjry9//6HwSIOTvLpTDzQz+eE7ySBltm5uE+dnY9hUNTu7ao0KQ8SGZM6dZzTBAWoCXaI8oRxROJl6Eb+w1KdePLa2jV4YsQzvyny4ExaMjqZ98L82FaP6PfCRCMVXUsTQMAxqWgclqsW5WUCLe/C9+d78n/jXmouSCGDvo7v8RAUSOzUCj+GNMd9eRl4QEupL30MzcfHaQ89kaPD4F8JjA1z5Avrj589NaLb552BbgT9R1oN+Kh55e8ComQMbsV7Z9BRPUcLNQMGZXcEzx/R7gNhCN7ytWBLJ2oY4fWYLq4+QKOP2I8sBLaOERyiFflO5tmibwE0XHF95CZPxMh41GmpZL5SAOhX3IjnKFTHOYsl78jzN7c8EWKSfYymIe7QjtsNFo3fwcd63yR2ZB7kGlQVxvEaG15Bnt4OjFjMp/xSLxR0QniBTeb0tNsCDORVLDtD1UfoYwJG/R2T5P0zs7U4REqgHQgsi3tHJCjXlpAkZpm4AJ2UegdLxjCHobK1bv7tSU7qaPHy25yaigIVcuPdfIvraYCVsxEn91eDr/qCpUtqe7bMzm/rhXKv8sGRspanUrf0e77c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b920879-52f0-45d4-91f0-08dd0d5d4a20
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2024 14:27:28.4881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e4Blo6kK4eN/AFqATgTjeyHqiAne1hEDFLCTIHZqc3Z0GIuhu4Oh2A+U5KDVG2ivYRz5lnepiYQs1J4x8Y0IGIhPUPjh6zcA9R5ki/B5TAA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-25_09,2024-11-25_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411250122
X-Proofpoint-ORIG-GUID: uVWDEO6C_G4ekZmF_Y69t0MhLgViO8aq
X-Proofpoint-GUID: uVWDEO6C_G4ekZmF_Y69t0MhLgViO8aq

From: David Hildenbrand <david@redhat.com>

We want to reuse the functionality when remapping or resizing RAM.

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: William Roche <william.roche@oracle.com>
---
 backends/hostmem.c | 155 ++++++++++++++++++++++++---------------------
 1 file changed, 82 insertions(+), 73 deletions(-)

diff --git a/backends/hostmem.c b/backends/hostmem.c
index 181446626a..bf85d716e5 100644
--- a/backends/hostmem.c
+++ b/backends/hostmem.c
@@ -36,6 +36,87 @@ QEMU_BUILD_BUG_ON(HOST_MEM_POLICY_BIND != MPOL_BIND);
 QEMU_BUILD_BUG_ON(HOST_MEM_POLICY_INTERLEAVE != MPOL_INTERLEAVE);
 #endif
 
+static void host_memory_backend_apply_settings(HostMemoryBackend *backend,
+                                               void *ptr, uint64_t size,
+                                               Error **errp)
+{
+    bool async = !phase_check(PHASE_LATE_BACKENDS_CREATED);
+
+    if (backend->merge) {
+        qemu_madvise(ptr, size, QEMU_MADV_MERGEABLE);
+    }
+    if (!backend->dump) {
+        qemu_madvise(ptr, size, QEMU_MADV_DONTDUMP);
+    }
+#ifdef CONFIG_NUMA
+    unsigned long lastbit = find_last_bit(backend->host_nodes, MAX_NODES);
+    /* lastbit == MAX_NODES means maxnode = 0 */
+    unsigned long maxnode = (lastbit + 1) % (MAX_NODES + 1);
+    /*
+     * Ensure policy won't be ignored in case memory is preallocated
+     * before mbind(). note: MPOL_MF_STRICT is ignored on hugepages so
+     * this doesn't catch hugepage case.
+     */
+    unsigned flags = MPOL_MF_STRICT | MPOL_MF_MOVE;
+    int mode = backend->policy;
+
+    /*
+     * Check for invalid host-nodes and policies and give more verbose
+     * error messages than mbind().
+     */
+    if (maxnode && backend->policy == MPOL_DEFAULT) {
+        error_setg(errp, "host-nodes must be empty for policy default,"
+                   " or you should explicitly specify a policy other"
+                   " than default");
+        return;
+    } else if (maxnode == 0 && backend->policy != MPOL_DEFAULT) {
+        error_setg(errp, "host-nodes must be set for policy %s",
+                   HostMemPolicy_str(backend->policy));
+        return;
+    }
+
+    /*
+     * We can have up to MAX_NODES nodes, but we need to pass maxnode+1
+     * as argument to mbind() due to an old Linux bug (feature?) which
+     * cuts off the last specified node. This means backend->host_nodes
+     * must have MAX_NODES+1 bits available.
+     */
+    assert(sizeof(backend->host_nodes) >=
+           BITS_TO_LONGS(MAX_NODES + 1) * sizeof(unsigned long));
+    assert(maxnode <= MAX_NODES);
+
+#ifdef HAVE_NUMA_HAS_PREFERRED_MANY
+    if (mode == MPOL_PREFERRED && numa_has_preferred_many() > 0) {
+        /*
+         * Replace with MPOL_PREFERRED_MANY otherwise the mbind() below
+         * silently picks the first node.
+         */
+        mode = MPOL_PREFERRED_MANY;
+    }
+#endif
+
+    if (maxnode &&
+        mbind(ptr, size, mode, backend->host_nodes, maxnode + 1, flags)) {
+        if (backend->policy != MPOL_DEFAULT || errno != ENOSYS) {
+            error_setg_errno(errp, errno,
+                             "cannot bind memory to host NUMA nodes");
+            return;
+        }
+    }
+#endif
+    /*
+     * Preallocate memory after the NUMA policy has been instantiated.
+     * This is necessary to guarantee memory is allocated with
+     * specified NUMA policy in place.
+     */
+    if (backend->prealloc &&
+        !qemu_prealloc_mem(memory_region_get_fd(&backend->mr),
+                           ptr, size, backend->prealloc_threads,
+                           backend->prealloc_context, async, errp)) {
+        return;
+    }
+}
+
 char *
 host_memory_backend_get_name(HostMemoryBackend *backend)
 {
@@ -337,7 +418,6 @@ host_memory_backend_memory_complete(UserCreatable *uc, Error **errp)
     void *ptr;
     uint64_t sz;
     size_t pagesize;
-    bool async = !phase_check(PHASE_LATE_BACKENDS_CREATED);
 
     if (!bc->alloc) {
         return;
@@ -357,78 +437,7 @@ host_memory_backend_memory_complete(UserCreatable *uc, Error **errp)
         return;
     }
 
-    if (backend->merge) {
-        qemu_madvise(ptr, sz, QEMU_MADV_MERGEABLE);
-    }
-    if (!backend->dump) {
-        qemu_madvise(ptr, sz, QEMU_MADV_DONTDUMP);
-    }
-#ifdef CONFIG_NUMA
-    unsigned long lastbit = find_last_bit(backend->host_nodes, MAX_NODES);
-    /* lastbit == MAX_NODES means maxnode = 0 */
-    unsigned long maxnode = (lastbit + 1) % (MAX_NODES + 1);
-    /*
-     * Ensure policy won't be ignored in case memory is preallocated
-     * before mbind(). note: MPOL_MF_STRICT is ignored on hugepages so
-     * this doesn't catch hugepage case.
-     */
-    unsigned flags = MPOL_MF_STRICT | MPOL_MF_MOVE;
-    int mode = backend->policy;
-
-    /* check for invalid host-nodes and policies and give more verbose
-     * error messages than mbind(). */
-    if (maxnode && backend->policy == MPOL_DEFAULT) {
-        error_setg(errp, "host-nodes must be empty for policy default,"
-                   " or you should explicitly specify a policy other"
-                   " than default");
-        return;
-    } else if (maxnode == 0 && backend->policy != MPOL_DEFAULT) {
-        error_setg(errp, "host-nodes must be set for policy %s",
-                   HostMemPolicy_str(backend->policy));
-        return;
-    }
-
-    /*
-     * We can have up to MAX_NODES nodes, but we need to pass maxnode+1
-     * as argument to mbind() due to an old Linux bug (feature?) which
-     * cuts off the last specified node. This means backend->host_nodes
-     * must have MAX_NODES+1 bits available.
-     */
-    assert(sizeof(backend->host_nodes) >=
-           BITS_TO_LONGS(MAX_NODES + 1) * sizeof(unsigned long));
-    assert(maxnode <= MAX_NODES);
-
-#ifdef HAVE_NUMA_HAS_PREFERRED_MANY
-    if (mode == MPOL_PREFERRED && numa_has_preferred_many() > 0) {
-        /*
-         * Replace with MPOL_PREFERRED_MANY otherwise the mbind() below
-         * silently picks the first node.
-         */
-        mode = MPOL_PREFERRED_MANY;
-    }
-#endif
-
-    if (maxnode &&
-        mbind(ptr, sz, mode, backend->host_nodes, maxnode + 1, flags)) {
-        if (backend->policy != MPOL_DEFAULT || errno != ENOSYS) {
-            error_setg_errno(errp, errno,
-                             "cannot bind memory to host NUMA nodes");
-            return;
-        }
-    }
-#endif
-    /*
-     * Preallocate memory after the NUMA policy has been instantiated.
-     * This is necessary to guarantee memory is allocated with
-     * specified NUMA policy in place.
-     */
-    if (backend->prealloc && !qemu_prealloc_mem(memory_region_get_fd(&backend->mr),
-                                                ptr, sz,
-                                                backend->prealloc_threads,
-                                                backend->prealloc_context,
-                                                async, errp)) {
-        return;
-    }
+    host_memory_backend_apply_settings(backend, ptr, sz, errp);
 }
 
 static bool
-- 
2.43.5


