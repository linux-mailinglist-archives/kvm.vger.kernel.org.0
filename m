Return-Path: <kvm+bounces-66602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 83108CD81BA
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 06:11:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5921330B96CC
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97C822F6930;
	Tue, 23 Dec 2025 05:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="TqfP5UVX";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="yND1Yir4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568DB3093A7;
	Tue, 23 Dec 2025 05:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766466316; cv=fail; b=SraoMbzNIEdOQVBuIcuXwksHkKopjoOnXKgMWIMxbv1HdTuNafHju8Z0URxDr3Vqxbna+M7LZbG/FfH82ILhNnnprJpTA+8anOVNfSmxgAlfxLOzzn5hQmF93we6FoYCXgxCuShMJ33ZeO89ZcxQI+ddtVe6Ahyu+5x7RPbbaP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766466316; c=relaxed/simple;
	bh=a/zC3qr3V4bDI+D+xBOhQeh386P29x8YXNI4pRRUmy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kMS7Q1cNGLsvDEz6lvXdtzwm3f7ykZjRSHVSlJefPOxopBqkEd+2s8rZ14r51ynIvFbRNvgLDgRIXd49xS6Yk9D0/4kU+hdLJ74wDtASoI/hLdtcbKK8TZjaEnNaZtaVQFmRS4vQpQNg2EmhPQJD4hvWFNY6wPAA8lAgsx1VaOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=TqfP5UVX; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=yND1Yir4; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMHLI6s2280199;
	Mon, 22 Dec 2025 21:04:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=dyfJDTXWUl270fKJpOG2/s6afn00K3NpxHPb14jFv
	Pw=; b=TqfP5UVX0L+tIUsMctwsGod07uCWm2gVecHLwA/LV2tK12Ni5mJtxSQtm
	aTGamuU3xJcYiqBF0juZqtmHzGOT/Avul+9AxnWH43ycjTEuwj5lsl00yzc77r1T
	eU6Vb2c2qpnVNaRg4Azn+ROEAIPOpFqDLiIww3T250f2cW1FehTF1EGZbLTFXo4G
	xyv4y5rOSzniPyOs9bxx0FS4U60C2iLDwr7xBVuC4Y9RQ7dkTEF9/G5FU3eD/KeU
	ZueByt7x0Rc9ycvzS/MSmelSWykAedsCy3ympyOlEyTLzC/ddnOELWWp89mJksyd
	vllpDSsuZdQ845Bd2wQuCBev2jBFg==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11020139.outbound.protection.outlook.com [52.101.61.139])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4b5v7yvuvt-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 21:04:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TTn9t/sT/EqIeV0gPBGKLWJ/AlHyJgFV1XuEeXDjp6r1rrUFGvVZXXN92xoXbCjS37HnmvDPCpcZuMQ437ad8UAORvNnFvtaM+9LLsaRkMc3ef0w+65NSdbWu8eKVCXng+FsGRgwTrx59yXTLdcZScaPq9kbPx1EXznNue7u41iFD+e8F6HUTFho04YIPw7/dHaTr7OuPLq9u31Mvi2zsLC0F5/TXJnSIdwB8lNSDs6eJsEobAcvNgOaDIAx06pIqkTv3REafzDetI+xLzeQjxX3RJQTIhgqduaLVW0j2vdwZgqNpYXZiS+T9097K/HF0MbOOhbQ1qloL3uQWLRI6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dyfJDTXWUl270fKJpOG2/s6afn00K3NpxHPb14jFvPw=;
 b=vFuqwL9N0JxLzo465r/3BlAm71OM283s6Bb+Po96j3ZwNLaLfZxPIHAgsfXKEdHm1ss/Jbx/J5UtvI23bmiFYPfXpSs401reqcusO8l7mIsJQZkNYQibhZRjtrzABD8Ku+QeAU6O+nZxOzf9wKHw1LKFk/vHdIVw0i4IzQ+xDmI/PgT+i3f9C+Sfs9d6agPWka2WwRcfH8uM88EXxcxnUsVSDkq4JxCIdL5OfKLLZ8ihqE1avQRtixlB1FcHTYVuddf5plJ8n3/XPM5BdIyTh+0wNgXsOoITuoSjwE4CJvijjWdBoYrSU7PgzCGaNFBtsXMlrYbHcmJuJNodGmPgHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dyfJDTXWUl270fKJpOG2/s6afn00K3NpxHPb14jFvPw=;
 b=yND1Yir4YZ4wcUNA7hfv9SFQazw0eIach7Hjpi1JOLEd6oK5/oR/Hvbbzd0HhRhyQrryv00x0DIe50XcVVvTwpic65dRS1g3vtf4yavZv6KxzhYZ8INYZ7o/lo9Hkgrv1kjmO/cgiptUSxibNOK4MUeg2izzLVlDwMyPJWRvsD24Qv1Oc25JQdTgXYwOhArD+5mQrC7WJwltJaeyBSYVN4jTs79s6+Hx9N9vn3pewgLEUbZ5RUBO6V9Tuh1aBn+aX7I9AUSvlP60RePXWYjua+LFEcvvsXqsy8Bbm0tzBliwG7YBGfPXmeAY9UvuxyiwLLbDmfhM7qYkX7JIp9dibQ==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SA1PR02MB8560.namprd02.prod.outlook.com
 (2603:10b6:806:1fb::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 05:04:36 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 05:04:36 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: ken@codelabs.ch, Alexander.Grest@microsoft.com, chao.gao@intel.com,
        madvenka@linux.microsoft.com, mic@digikod.net, nsaenz@amazon.es,
        tao1.su@linux.intel.com, xiaoyao.li@intel.com, zhao1.liu@intel.com,
        Jon Kohler <jon@nutanix.com>
Subject: [PATCH 7/8] KVM: VMX: allow MBEC with EVMCS
Date: Mon, 22 Dec 2025 22:48:00 -0700
Message-ID: <20251223054806.1611168-8-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251223054806.1611168-1-jon@nutanix.com>
References: <20251223054806.1611168-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::19) To LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV0PR02MB11133:EE_|SA1PR02MB8560:EE_
X-MS-Office365-Filtering-Correlation-Id: f6b7d928-fd52-404e-8a83-08de41e0c4d4
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|52116014|1800799024|376014|7416014|366016|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?qpTpaxJKrte+BeB/fybCszMtg02Ojng+KCArJ6N9D8WCQhab4QK4CYR4x/AG?=
 =?us-ascii?Q?cgRaRYit7dovjN1U79Oo6q2eibpkKdAvfKFgRgFe2Ug9L6HSqkjOpjmAfec8?=
 =?us-ascii?Q?ct7vFowgEAAPLy6ygRa3H79vYjidl9MDmwx3tmoDWghQDLBQMRWb0htMPbta?=
 =?us-ascii?Q?0LDwg0pOELox63IsT5B5zF6XOgCBAvbUlL0Qwgb/UWJ6I9C1pxAnBZmtgqG8?=
 =?us-ascii?Q?D7INbkUFREnRKcMxhNdIlzM+BIrNE2/+GligISydMunqo821WbDGIc9rdZk/?=
 =?us-ascii?Q?5WOR/NbhNFxGB3me9mN7KS2e6anNxlZ3kV83vsIO6kVCfTIzi0iPfUEHNziF?=
 =?us-ascii?Q?+aj2jC1qtKae/kiW9+9Kpq7R9vxDN3FjY+YWF1btJa/rd+2anlEIYugfhOAm?=
 =?us-ascii?Q?h9nWpu7yuEy+JdAyoG6LYzsEr2jQOrsBq6UcfBwCFK5OA+sQf7Hbh/pqpGtX?=
 =?us-ascii?Q?c7jXB+WePR/hdbcGiK+h+kDhJ/xi6gxqcFPbJZEjdp+Qgg4MU/BURT6e2fUd?=
 =?us-ascii?Q?pv3Gt3jZ7X+Aaf9ApJpppccMDDZKx5KEds+qeRY5nt1+hvdw3gLRF8x9YJ1y?=
 =?us-ascii?Q?iLmIzigzByVhniDVOi/B+wdVkACY7KyQEVlf1loA6++g3E5iFjESTWd28C4l?=
 =?us-ascii?Q?L6QtH7GVSXeUG0k5G6oXoFTw5ntoex66RL45g7dPsPeiwnSCerRWOUxNOlHP?=
 =?us-ascii?Q?SMjgocskF7bqd4UImGWznjcpb/nKox0+tC/YawaGmX9dPL+EBh7UwfwDUrAW?=
 =?us-ascii?Q?ctl0nIxfnwswyKI+CAKiIPtFCGUhUTNntnm7ZyWPx7zqGrbvtl52hV0/PtrZ?=
 =?us-ascii?Q?lXGIlKBrNP3NfE4DsYVeJdf0nZ1nd17qOlNj2x6jBZ8l4I4k74DnIf/MzRyL?=
 =?us-ascii?Q?W/RkG8E7BiqrLYvwg2WvsQVTyuloOolQKUGZoZgMmVFWZyWkRl4t5+qmskIz?=
 =?us-ascii?Q?NKhn+MoHG5w9ulTqsfJcmYzDimEh+4pWwVeNI4VfVMS1D2fMiEhc4ANAA3F0?=
 =?us-ascii?Q?eo9xIA3C9yzBsDFBHYdqpfr3tJMN6ckWa/fpCVPtErDzef5hs7E1tsidZaWI?=
 =?us-ascii?Q?IUGWVJUeCIaMQDgM1zU+j0a35oIALCL/f56GNhoelqlwu5IAlY3fKvYmPISu?=
 =?us-ascii?Q?P7TaexxW3xDmJWXgZGIxY1Amiasq+ZAwp1DIx3PNA4Zo2St126foOCfEkTb8?=
 =?us-ascii?Q?NQtTmyvtottNUyK9ENJiPG/9XbKrksM7FZYZ/SyfypSsDpiVA5IeRaHlmh8p?=
 =?us-ascii?Q?pPLy5+rsSPitnGDRh+qf1Ef1pASI20nyXf8dsYsjBlyQFlD0pubONLhKSLE0?=
 =?us-ascii?Q?nqWPPn6jRdW/E8k4CcaMLIt/7K2W2ZiKfp5it37RNHh3Gyoq+/t1u5x9pM39?=
 =?us-ascii?Q?BtR9DwPNEMvc/RI1bnOHi2YfL+Ku9RUbJVxaBn304GJfjZSfethtOIMUWlsB?=
 =?us-ascii?Q?l8kRw6bMtKkosP39IPoCCCIDT9yK4lbT2nTX8nqzBgTHnbPlGpKHTrHfiTMG?=
 =?us-ascii?Q?OPEl67HMkSwTx9QMT2f5CWPwe+5ZLh7EkAw+Jbx+yOu4ytnKh00HdKtE+g?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(7416014)(366016)(921020)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?7JYQsRSeHZs8eES3UYNNTIMl9YItY7tWqfWvZc4/Y4VXF+hb0DAnyoJBEkGq?=
 =?us-ascii?Q?GaWPxVo+HPlwUdXSkMO18/cjCvykhTbHirW6n5oktTEQR3sBF9+Yx4V6/UpM?=
 =?us-ascii?Q?L+emKTl1rvquAB8mrgLZgyJeHljUmmrF582oDKpM35N13rxyhJMgr7KJoFFP?=
 =?us-ascii?Q?W+Mb6A+frAWQAPf/fHLtoWpQUctYsUErwa7CEhECWP3VhZlVCQR1XywXhs28?=
 =?us-ascii?Q?i4e1Ot9QpPhB1Q+UvPVvondBTqRvTuXdYi+Z8o75AJt3bDMNJPc8zJj2iTbC?=
 =?us-ascii?Q?E3urI5fxPvF5jF2TwQjtDJPhPWkSTCWGlM+rQVQvdF7GpRWosA3Jy6Kp8XPZ?=
 =?us-ascii?Q?hM2mZtXRMorngEzymnrmzOpi6rfoIaGoKRjO3v68n3wII6MxjMlG5OUhQyn7?=
 =?us-ascii?Q?J5jO7J8S/1sjTtiUcKUTx8v6DVOmuCL/CKBdsb308BeSPgK7jbmxLWUZQ/Hz?=
 =?us-ascii?Q?LS3B5NNwMK78wVWsARYhgE3P0Y2/gwe3JUpj6otMtieoMiCVccCMo2yC4JJp?=
 =?us-ascii?Q?TNZubPGxuIrBJ1+Dkdk8VDHXPXHCA8l3O76ADdEmnqAeMW3QIfe+AeVcKjHJ?=
 =?us-ascii?Q?C6T2DBhUEEuYvo2E53Zm8Cl57slKVFBQaSWj85MMdTkEQMch9smDR4Crkphb?=
 =?us-ascii?Q?GhRiw4/njVVhTN1/EOh1JXpQeOR84Zqy9Z4XBVaeH5igI3NYyx9kwXuT5Cr1?=
 =?us-ascii?Q?n30+jZneklIvDKEA2fcprqaESHw2qWrzteCOsIMekxLKVMJMoURoEPUQrGFJ?=
 =?us-ascii?Q?FB1JKhT1uuu8OKr7eTEzkr6mYZG0rr+rfNKXE9zkEY7X+0stzD1OJHlkWEHf?=
 =?us-ascii?Q?7yECgpQBgdPAykjLiQBf5xckkdWy9cdrvA0NjC5Phxgs/ufI8fR6nCM1kV2U?=
 =?us-ascii?Q?wtyUwHIRr5tOpwPL7zdyiekrS6/rvp4eJsTPrsQhPXy8egATON/N6ZTnE1ge?=
 =?us-ascii?Q?5Hzqx1qH7bigkWbA/tsE1nfIAww+zEnJj17WPn8hYsr4anjibW1Rd6LCH0jJ?=
 =?us-ascii?Q?BVDqapIRyBtgeXdCL3baFe1s0AP3t+3J1LxOrHsi3W3w/lwPkGvsXyF69yev?=
 =?us-ascii?Q?NG6MVHC1uCxRkWK9kTmKkUTf/K+MHcNeJepjLK7MuQ0ZxtgUiCDbZsSqSBCd?=
 =?us-ascii?Q?+6xGZM+caF6Ppa5Kno3v/YfM8VP7kEGvhHwkJOYnURev3abrGDzgpa1SQyzl?=
 =?us-ascii?Q?FHENr7DT4xCJih4AiFHr8KSYg4PBF1YeVH6yNHXg7P2nC92+TuLpLTNXfFKY?=
 =?us-ascii?Q?JfaVC6gNMSwz1QVQJWQ3oWyrULcAe8tSDi0o9BemSLXkra+V7Bv4AUxVb//x?=
 =?us-ascii?Q?ci4NuseZDYidvZMIbjSyRZkXDjr8pRaNTjx8xcP7o5TkuvOBlEXO8syvXzAz?=
 =?us-ascii?Q?wSAwxIPhZwoa+Pk2wGZvnIPxRAA0dBkADM7LedwKzJfSOqfZQxkZqtggS4Cu?=
 =?us-ascii?Q?RRGB+b5F7PnBWQQxyRUpgERyWUIFmCiZBNN9HLClGWcqpRG3lI3hZ3yJ0Il2?=
 =?us-ascii?Q?mgjR+IqKHWBEZzySlcjJHXCnQVU/t6hnpiFn4C2dhFKcaH88+vNPELv03vKo?=
 =?us-ascii?Q?6A2j67ABVrDDRbWYM2YGcQmLPXCJ1GnoIBhCg2//7nFkJLxApJ0AFHJJBHNs?=
 =?us-ascii?Q?p0Giy5caXf3nmTkB5ntlrDa6K/u6oAQ/YqEbNMNECkySZPoxhATieQn+UYar?=
 =?us-ascii?Q?U60W+ik2rpWVxxD1iVGIFqxbAD/uVrKqqeApHHLRTZ6p2rJZKiXxl0rW2MFs?=
 =?us-ascii?Q?HfIPgjWV+fxeCa5eYfxPTCr/lVfCJU0=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6b7d928-fd52-404e-8a83-08de41e0c4d4
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 05:04:36.5425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RtVb6hHrTh3GWquPMcUwQ8I+woMOIucHaq5Cynp0w25w2VLPCvs4wtq48X9zl9/kmSdnry8LAE8/2spojKuuYfifZrCT1IcS1/rnkJBcMBw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8560
X-Proofpoint-ORIG-GUID: ZWvMIu8fY6cgS3g-5E2fJfrvPrKhQZ2c
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDA0MCBTYWx0ZWRfX2ahSN9iGh1DH
 i1PliphEw3J6a24jckHKxbtWKA4/s0Wl2ONxFYfJCPOUexwA4DuMp+FaIbiefvYDgH9QSbA+B5r
 P0KxTqz3eaPrkyo5+1x+KSjowsK7hOitM5EswsaPO+Zw+gRLYpQZdbrsa/YJJsokTzuUemNZdD6
 aLfn54Mi40UGXGvOfbJSygUVsxg/SFvELZNmK4ymRqUpgG/RSL9wp0UiNMl1oIBABN5qxeZx9xx
 AyPRx6JmJPuFwJMOc1LD056Pcj9ZwH4DeNq0lwYjyclrt9YndYH17AxiHFeD7t8sDUCbXd2lPgj
 lwGbNYP23IxMXPdIBL/Nu4JoFBjvnjbb9T9Db9+mQ2nXXcLRdNPz/FyH6s9L6NlOb+RHWFPPfKd
 Aid1YU4R9LVeowdio3LhTHufaqFbyxPnsTYMFyWm0Zuy0gJzy1HDTOxImjUsqJ0pFIFcvv2PLJl
 +h/iURIRDNm4B30Y66Q==
X-Authority-Analysis: v=2.4 cv=S8TUAYsP c=1 sm=1 tr=0 ts=694a22e6 cx=c_pps
 a=zLxRk7/rSTrB1jskNZbxBg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=64Cc0HZtAAAA:8 a=0i2ZdGeQOifu-2FwdKEA:9
X-Proofpoint-GUID: ZWvMIu8fY6cgS3g-5E2fJfrvPrKhQZ2c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Extend EVMCS1_SUPPORTED_2NDEXEC to allow MBEC and EVMCS to coexist.
Presenting both EVMCS and MBEC simultaneously causes KVM to filter out
MBEC and not present it as a supported control to the guest, preventing
performance gains from MBEC when Windows HVCI is enabled.

The guest may choose not to use MBEC (e.g., if the admin does not enable
Windows HVCI / Memory Integrity), but if they use traditional nested
virt (Hyper-V, WSL2, etc.), having EVMCS exposed is important for
improving nested guest performance. IOW allowing MBEC and EVMCS to
coexist provides maximum optionality to Windows users without
overcomplicating VM administration.

Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 arch/x86/kvm/vmx/hyperv_evmcs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/vmx/hyperv_evmcs.h b/arch/x86/kvm/vmx/hyperv_evmcs.h
index 6536290f4274..0568f76aafc1 100644
--- a/arch/x86/kvm/vmx/hyperv_evmcs.h
+++ b/arch/x86/kvm/vmx/hyperv_evmcs.h
@@ -87,6 +87,7 @@
 	 SECONDARY_EXEC_PT_CONCEAL_VMX |				\
 	 SECONDARY_EXEC_BUS_LOCK_DETECTION |				\
 	 SECONDARY_EXEC_NOTIFY_VM_EXITING |				\
+	 SECONDARY_EXEC_MODE_BASED_EPT_EXEC |				\
 	 SECONDARY_EXEC_ENCLS_EXITING)
 
 #define EVMCS1_SUPPORTED_3RDEXEC (0ULL)
-- 
2.43.0


