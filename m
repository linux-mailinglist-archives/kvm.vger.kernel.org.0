Return-Path: <kvm+bounces-9337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AC0585E8A1
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 21:01:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BC941F297DB
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 20:01:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCBE21468E9;
	Wed, 21 Feb 2024 19:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="LTFs33I1";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="B+pK0exf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6998D86AC6
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 19:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708545196; cv=fail; b=sE92gpnVrNG5aCml4G45eZji7BQ8mebAQPwhQosxLXBziHOcoBqfnhpzBQyOR1VRf/Kk5xitaPEoCPv2JAAmgNGrM/oF3ko/h2WE6q65e5DXRvrt+Fwx4dGuJWkpf/yhFZ5cI2+z6aHcR0RoxYFbzRsQO1xMpvrsRsfpKgWK8gw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708545196; c=relaxed/simple;
	bh=F5kvKAvMlGsJmX1Qan7cUg77gztanuVs8iBZWsTqu/Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=My3tZ/xc+6OegX1oUBQg1aA+Jyj2744vxKqKpbvcCyGbB39IQcUstmaLN84e8bNlDarnB/elhE+jLMuSH8Zxn49i/DX7CCjNpGsw9thIcdUQWEIonvfO7BC5zXuajQcddHwd3ddj3UCos8+1Pt2MYMvAKLpVcdLw5CtZU1P/Qkc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=LTFs33I1; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=B+pK0exf; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41LJdecC020263;
	Wed, 21 Feb 2024 11:52:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	proofpoint20171006; bh=wgC7itBopkgKNKAGevMzBQ5ty6joewVHUVuORP9/V
	6s=; b=LTFs33I17U6KG+4lt/QMgSB2fLEv1W1PSDDs/qSwhNxemLeS9e1WdSjfX
	AvvWuwo3PAuZK9Wn2FBWabcdtcgK7K0GqEJ2wjpLreOg6kLNmLNjM1BRymCzBIkT
	YrlnSdi4xK5yvD4lB+zLQbv16VfHfBD8advIOWwGDd8z5dOkXsbwnvKtYJgVUS8m
	ZnHzzfpiJ0kXviEqNpS5x6QWpRXxILUvndbsk5Ow1GPRfIp4o4kiRc9rDCHaq6tL
	1MDWFT8kO3W68hOfqBlQJfHq6BbUD92zyXkiGHq9d+lYcqn81dpl9fMOtjW+lHRX
	WgG5WFIEGStfSq5QtsB4kw7MSMwDw==
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3wd21wu6sd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Feb 2024 11:52:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxMYQv0k2l8SEDZvAeSQMXKM/U4ltNRb9yQZA4dAmNhkEwv+oa/60sgAqj+l8CUvBYQd14e3NkyoaLlLZZ3hj2U/ha7n47lqNq9VVtF1595M4OC0GyaV8nO2z29QFaK9YW4nV1ElNMg+GBdRO5O/K9Yb7GTSCdPw+nYSdHC4BJNKjGgiBXXZQsbgHksuimcSsTq0CK+5wuvnj+lokOZ7a52LgPDcbVU06H4N+PvWjjFRj7XtVnMMAseESLXfVQmDaI4m7uMFonX0veuKln4trmNWKOEGbTgbxHb00heILlgTLQnz5K23RoMSnjjwBwBFurkS4CO2ojYACiRdKGx49g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wgC7itBopkgKNKAGevMzBQ5ty6joewVHUVuORP9/V6s=;
 b=LCSZHuj1d/9n1Z+weMQylq/D8xwOQCz8hZP3Vg7obl333WuRDG2tcfHyBDskJVWX/bhusboxiRVXdpqJysPLO3nMNg5/L1NkwJX7tXO/+3TP2620emPtmdJi4z0G9m0D1aCoq8EJ6va5wOZZzvR3IvGb6B4VVdh9e5N5w27SmcORb9g8qXe3teDbFDZI8uD0bW/QfXxVMdL1igJCEuH9jzriR19b/EDnr6eh0Pz3Kqf48fAy7PZhUkeUtmIZA7TaujXrxuAm0bo7Zl04UKbGHp8tMsanRwQA547RtLfhKEDAzahy7yJ3bTWhs1OzPviXreNB1FopUwKvJwpXyLt1nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wgC7itBopkgKNKAGevMzBQ5ty6joewVHUVuORP9/V6s=;
 b=B+pK0exfvOpuOMmByvJnL2pIkop8hRxfMBk7+g+bkaBHjFuJBPdNosylIkfv7u2faMGCV0HlX/5CtrJ1xyJpKJo10JQP0n5xxpUEgHFBWchTRYpKSAWIhmMozQNCHSxgp7OIvdGMU+CDdztmQwxpMQN1Y0jVqbfE68yEYXTZyHFWGFSnojRXL7x7jjc9Ud0HqkdAmX6F00BeM+YQx9a7LiX1g04patHxoRcZh4gq2mYH61mujfGAPsjgyq3O+RPYBkQJ3batndB5LM3UfGbwCgZ0ty3eEoG/u5XluDeMNuPTsyWx+LCD4Ymxhd+1OK7m4qPvzhaiadL/KQGqrFdIdg==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by LV8PR02MB10213.namprd02.prod.outlook.com (2603:10b6:408:207::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.21; Wed, 21 Feb
 2024 19:52:56 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::4a9b:daa2:2dff:4a60]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::4a9b:daa2:2dff:4a60%3]) with mapi id 15.20.7292.036; Wed, 21 Feb 2024
 19:52:56 +0000
From: Shivam Kumar <shivam.kumar1@nutanix.com>
To: maz@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev,
        yuzenghui@huawei.com, catalin.marinas@arm.com,
        aravind.retnakaran@nutanix.com, carl.waldspurger@nutanix.com,
        david.vrabel@nutanix.com, david@redhat.com, will@kernel.org
Cc: kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v10 1/3] KVM: Implement dirty quota-based throttling of vcpus
Date: Wed, 21 Feb 2024 19:51:24 +0000
Message-Id: <20240221195125.102479-2-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20240221195125.102479-1-shivam.kumar1@nutanix.com>
References: <20240221195125.102479-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR20CA0013.namprd20.prod.outlook.com
 (2603:10b6:510:23c::27) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|LV8PR02MB10213:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d20bb43-251a-4dab-a5cd-08dc3316b2b2
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	k5wB2gJGMlzCmqB7XvvxPh8OM8VMMpnAmeiPvUMogdNW2F3+e0NbqfUamjxrfX4+EBGEJWM6YJPN1K1bd88bDkACyrOa1s583JwmgL9yz9KcQcHQbVOM9natN/yvMb3SO0pzaJC1yxlL3i0p7yJBL/RsQhspIYKM1e2nGXCFiVAwMcb103a+ciP/qIVeJHeiIYxjaxvKGgcKdKsv5+Gs1gbVKhzvE3aHgROTXYqie+/0C6gPI1M3mfJc/H3ngtD7WkDAh/HyX38wVvujq8ZjlUgCIwdYW66j/ZwwudKRouC1HPQ9sJsQyMewtQUVss9ssaj8i/YaqjS6Nnu6CtHHyoGOalrb684Cgcy9CPShDGsGdtVhOKsZ7z5M8cS2Z+l2SMW+Hcv2Y/9/5JTvQmGKKRQO0ifooiU2XAATKTZHc4iPEqYtFuVx7addd9MUVf5hLigVlCaClwipAME0V8Bqpnba2kloVMfuXeWBSrXe9cI5KG7MsJPZrn5bhXVejBGHwlkzfddix3AjjuIO9WzJvIuA/W7kvFw8WxIMIsqr4GoY5RJbW/umYV4wmch+W9RmLSng17vjG9sAT7+7272grwrdDnXjBjuau3UwdJ6Rbw1fnmBJSKPjH29sKrAjcE8PLBGyzj0v3f/NVbUx/etYyA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38350700005)(921011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?B4304hL1NlfpuoX2dRuEN9E1kspDsUg1keAOyIbUuk/efM9jNNp04fSmBxca?=
 =?us-ascii?Q?JUvCF028YNvV0Al7WVEoGUT6SwsCb+HawD0BN/vUOC8VZqwLBoP1L+H9oesz?=
 =?us-ascii?Q?waGb8b1dcIWrjL1XNTYaLw2SoElubcZ26jTl6FGbSMkfpw8E8+efXhBsTVZY?=
 =?us-ascii?Q?Mh7o0Em2eWn8aXXN+WP/AFTFLYUhyl/LjIOdSrl7weh/WhkeMAmH1PhP53lV?=
 =?us-ascii?Q?WZQm9EJgDEKOq2b/gfYj5BSQ3ILpMBZR26CvQ5y6+XSnAKFLkoSQfSB8U++C?=
 =?us-ascii?Q?I1e27XcbtkTGVmVlNF74Xsx7fyk5Ph86JS3OyGsXDL7K1vax0WNaOH25DKSj?=
 =?us-ascii?Q?20DZHbk6UOJFw/oLJjpXjQiFAJb1gpfOQ/h/VF3z61hidrfPUI8nzk94kduV?=
 =?us-ascii?Q?Ufbi1pNsCTzZhhk5Dcse0U7foOTOVHxTNfRA9z6Deow2na49sfa+6z37JoG+?=
 =?us-ascii?Q?GKkRRlvZ5t3aNW2bpyf8WbnSORy7S43+EvdeAbPTLu4/uG8WH3K/wd9WfVNd?=
 =?us-ascii?Q?Vy85Ne7/D4y/x0WmVCCEGDEbAzZvPxWmNWlc/yXnXGRF5zWNWWm6fS5UXl/q?=
 =?us-ascii?Q?OHlY4O/E2At2t/LX/gigYQfl6VS3KcIsNfBsr+vcp1njnpgIQ/cHEvlnh14v?=
 =?us-ascii?Q?9gEbKCw0xNuGi3jSPLrN+Rtn2QoUM+RSUaaSErPA8AKgBH6qhpg5y1VStkis?=
 =?us-ascii?Q?PJ1fmdznntgZ609zWM6Rl1KrObUOaOfMZNKy3kB/BVJLFcNGbyItquRmBD2r?=
 =?us-ascii?Q?CtBohGHMaJfUXmGSZxW9BCpjrmfphBAiAy3ZhuDp2DbqBpGQP67yDQKe0JW0?=
 =?us-ascii?Q?aeTQQr5K5Fa6S0Vcc2kUN2RNcsBKRJLlGeDSHXUqUhxND8eqwl2gesDMQCed?=
 =?us-ascii?Q?63Ogr56aBnw5Qk98YgqGmrxf9KwG9PUhvv/JnnODg0aAId/0TxJYyPytOA7b?=
 =?us-ascii?Q?dYWipVcGwf+prBc4iNYM0C20kOCeQp7JzppgfLH1HjOTvUcEhTfIL8cXh/KZ?=
 =?us-ascii?Q?OAbctTLiV6UPmfYxjkzKIBuATNU1PuSeRqgCamt9IyOlaI3n/FT4yeIsvXLe?=
 =?us-ascii?Q?xorn1Jv0KVjYFUtiNN9e0tHlhTFy6HrBY8uW221EdlapXYh1j5TFIhP/g6uC?=
 =?us-ascii?Q?6D/LdqL9ymIxIMQluflwDP4dSU5lbJWzp01fku9OCaKQPBMAO1gEJXcDO4aW?=
 =?us-ascii?Q?Sa59siF7Kcl7IWZPhf4eKAEb0JAIhe8fyJ4LxoMyrb9l5z8Bs172kIjq7Y83?=
 =?us-ascii?Q?njrSb0IQF+GqdFx/l3soRIlDbuQXaag7qVQWm37zFm84pxw3eEW4KubCEr8E?=
 =?us-ascii?Q?E37e4SYBqwymdUakI40aurGl5Rb4+RfH/Xwf74NjystPc3I8dyS3J7s9NU9O?=
 =?us-ascii?Q?IrqfTI0hjzanU84xuzB1ixgEykf6gT1QS6lQJjYw/B1ctfQIGpyFI8fOpHfS?=
 =?us-ascii?Q?u+cwldGQRoQCWPRRG/2K72T/sIDxDtXfpEJilCBjpC1inpu5s8f98Hb8M6tu?=
 =?us-ascii?Q?tA6r7a71Euek+l5S0yFTuxLGZslxmUqqO4jLgS3k0XKHNMk4WCylLl86Y3eg?=
 =?us-ascii?Q?ku9l1A8tLc2repyTJy8F52F6ovo72VY5s7AKffJcqbid5I5HhGZvBzP++Db2?=
 =?us-ascii?Q?0A=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d20bb43-251a-4dab-a5cd-08dc3316b2b2
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2024 19:52:56.1105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xjivjzR6xwtTL2x17wZkhpOMHRZDw3sulVpH1qHgc76PCuLF5WNnk4MRGzNV8zYrfaxfN1Td+/hnW7HVPkq44f7ZH1rzNHfOfaPaiRzFBio=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR02MB10213
X-Proofpoint-GUID: DV_S6r4EcsjlBzwnVyasQwLxFJ7PbmbC
X-Proofpoint-ORIG-GUID: DV_S6r4EcsjlBzwnVyasQwLxFJ7PbmbC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-21_07,2024-02-21_02,2023-05-22_02
X-Proofpoint-Spam-Reason: safe

Define dirty_quota_bytes variable to track and throttle memory
dirtying for every vcpu. This variable stores the number of bytes the
vcpu is allowed to dirty. To dirty more, the vcpu needs to request
more quota by exiting to userspace.

Implement update_dirty_quota function which

i) Decreases dirty_quota_bytes by arch-specific page size whenever a
page is dirtied.
ii) Raises a KVM request KVM_REQ_DIRTY_QUOTA_EXIT whenever the dirty
quota is exhausted (i.e. dirty_quota_bytes <= 0).

Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
---
 Documentation/virt/kvm/api.rst | 17 +++++++++++++++++
 include/linux/kvm_host.h       |  9 +++++++++
 include/uapi/linux/kvm.h       |  8 ++++++++
 tools/include/uapi/linux/kvm.h |  1 +
 virt/kvm/Kconfig               |  3 +++
 virt/kvm/kvm_main.c            | 27 +++++++++++++++++++++++++++
 6 files changed, 65 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 3ec0b7a455a0..1858db8b0698 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7031,6 +7031,23 @@ Please note that the kernel is allowed to use the kvm_run structure as the
 primary storage for certain register types. Therefore, the kernel may use the
 values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 
+::
+
+	/*
+	 * Number of bytes the vCPU is allowed to dirty if KVM_CAP_DIRTY_QUOTA is
+	 * enabled. KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if this quota
+	 * is exhausted, i.e. dirty_quota_bytes <= 0.
+	 */
+	long dirty_quota_bytes;
+
+Please note that enforcing the quota is best effort. Dirty quota is reduced by
+arch-specific page size when any guest page is dirtied. Also, the guest may dirty
+multiple pages before KVM can recheck the quota, e.g. when PML is enabled.
+
+::
+  };
+
+
 
 6. Capabilities that can be enabled on vCPUs
 ============================================
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7e7fd25b09b3..994ecc4e5194 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -167,6 +167,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_VM_DEAD			(1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_UNBLOCK			2
 #define KVM_REQ_DIRTY_RING_SOFT_FULL	3
+#define KVM_REQ_DIRTY_QUOTA_EXIT	4
 #define KVM_REQUEST_ARCH_BASE		8
 
 /*
@@ -831,6 +832,7 @@ struct kvm {
 	bool dirty_ring_with_bitmap;
 	bool vm_bugged;
 	bool vm_dead;
+	bool dirty_quota_enabled;
 
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 	struct notifier_block pm_notifier;
@@ -1291,6 +1293,13 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
 bool kvm_vcpu_is_visible_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+void update_dirty_quota(struct kvm *kvm, unsigned long page_size_bytes);
+#else
+static inline void update_dirty_quota(struct kvm *kvm, unsigned long page_size_bytes)
+{
+}
+#endif
 void mark_page_dirty_in_slot(struct kvm *kvm, const struct kvm_memory_slot *memslot, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index c3308536482b..217f19100003 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -210,6 +210,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
+#define KVM_EXIT_DIRTY_QUOTA_EXHAUSTED 40
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -491,6 +492,12 @@ struct kvm_run {
 		struct kvm_sync_regs regs;
 		char padding[SYNC_REGS_SIZE_BYTES];
 	} s;
+	/*
+	 * Number of bytes the vCPU is allowed to dirty if KVM_CAP_DIRTY_QUOTA is
+	 * enabled. KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if this quota
+	 * is exhausted, i.e. dirty_quota_bytes <= 0.
+	 */
+	long dirty_quota_bytes;
 };
 
 /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
@@ -1155,6 +1162,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_MEMORY_ATTRIBUTES 233
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
+#define KVM_CAP_DIRTY_QUOTA 236
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index c3308536482b..cf880e26f55f 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1155,6 +1155,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_MEMORY_ATTRIBUTES 233
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
+#define KVM_CAP_DIRTY_QUOTA 236
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 184dab4ee871..c4071cb14d15 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -22,6 +22,9 @@ config HAVE_KVM_IRQ_ROUTING
 config HAVE_KVM_DIRTY_RING
        bool
 
+config HAVE_KVM_DIRTY_QUOTA
+       bool
+
 # Only strongly ordered architectures can select this, as it doesn't
 # put any explicit constraint on userspace ordering. They can also
 # select the _ACQ_REL version.
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 10bfc88a69f7..9a1e67187735 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3626,6 +3626,19 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 }
 EXPORT_SYMBOL_GPL(kvm_clear_guest);
 
+void update_dirty_quota(struct kvm *kvm, unsigned long page_size_bytes)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+	if (!vcpu || (vcpu->kvm != kvm) || !READ_ONCE(kvm->dirty_quota_enabled))
+		return;
+
+	vcpu->run->dirty_quota_bytes -= page_size_bytes;
+	if (vcpu->run->dirty_quota_bytes <= 0)
+		kvm_make_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu);
+}
+EXPORT_SYMBOL_GPL(update_dirty_quota);
+
 void mark_page_dirty_in_slot(struct kvm *kvm,
 			     const struct kvm_memory_slot *memslot,
 		 	     gfn_t gfn)
@@ -3656,6 +3669,7 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 	struct kvm_memory_slot *memslot;
 
 	memslot = gfn_to_memslot(kvm, gfn);
+	update_dirty_quota(kvm, PAGE_SIZE);
 	mark_page_dirty_in_slot(kvm, memslot, gfn);
 }
 EXPORT_SYMBOL_GPL(mark_page_dirty);
@@ -3665,6 +3679,7 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn)
 	struct kvm_memory_slot *memslot;
 
 	memslot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+	update_dirty_quota(vcpu->kvm, PAGE_SIZE);
 	mark_page_dirty_in_slot(vcpu->kvm, memslot, gfn);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_mark_page_dirty);
@@ -4877,6 +4892,8 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_GUEST_MEMFD:
 		return !kvm || kvm_arch_has_private_mem(kvm);
 #endif
+	case KVM_CAP_DIRTY_QUOTA:
+		return !!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_QUOTA);
 	default:
 		break;
 	}
@@ -5027,6 +5044,16 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 
 		return r;
 	}
+	case KVM_CAP_DIRTY_QUOTA: {
+		int r = -EINVAL;
+
+		if (IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_QUOTA)) {
+			WRITE_ONCE(kvm->dirty_quota_enabled, cap->args[0]);
+			r = 0;
+		}
+
+		return r;
+	}
 	default:
 		return kvm_vm_ioctl_enable_cap(kvm, cap);
 	}
-- 
2.22.3


