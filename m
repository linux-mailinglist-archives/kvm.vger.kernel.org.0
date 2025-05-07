Return-Path: <kvm+bounces-45735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B534CAAE575
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 17:52:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9763A1C450A4
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 15:51:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EDA628C840;
	Wed,  7 May 2025 15:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="aHrLl2B1";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="P6kgDUur"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE4A28C5B2;
	Wed,  7 May 2025 15:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746632965; cv=fail; b=llOfJjq2B6dgcchyMLlnraCaItUa/fUAsmf1uVAzFc0kBH2rncy4t8brZj+Yd96/Xg4JNHEfAqUYyBMSgEzrBWhuHGgSeoPszNmLA4p5dUCABQc4jHDNjIXhOY0HloZ11EpAlyRCAKdmWlUo5RVpd8E32ZmN+8yPDOF/oD7juhg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746632965; c=relaxed/simple;
	bh=JIUVTCphaH3ruprexjdFE1wzwGCnSzo+MyhfxcL2OvI=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Xc+OGOvq5ove92gAtUpZXFzSPfFY4ZdYCvnpNGRX4/3pabfrPTJRUxNe4B0MFBpFHpvKOY77Ecp/BdTKiQqANa7dSMRWO+xVFzwdzlSRFUQk7QVI6ACe8FDd0aODG9HL/flQUVS9RV3cSMVQcR+RyZQADe30/HpbQQStuf98Lqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=aHrLl2B1; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=P6kgDUur; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 547BSaLR023544;
	Wed, 7 May 2025 08:49:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=r6LEhtKF6kVoM
	RBVaZCbc67YRAk6pu872RPNqGtrJ14=; b=aHrLl2B1PeTTFKp62JMu1Y3kiM/kn
	VKEaO2l6oNucpSJ62iUshsCU0HFVZGsC66MjfN1RKHEOKMB4KhUUmOcb9uHh6/xe
	y0Gq55HUAS9Pf0NuP1O9XkvMxKPsD9LSa+cQJIqyWxqL1QCr3RPp5ZkkCBUQEfpb
	FlPkVL28TmdHFRnER/3BFyB2H421FZ6r742uIli2C2bd0UiByJIK0ViX33cqqBoi
	dlcIN0lJprzp3CvbjLDX0zSJ3O3JChHVc1OzcYwaaqC9GKtX58zgz4ss1dK89Yfo
	ELed5ojPHJJzGOHWaUUlHf86jqqPZWIbB6ScH/3YTYmdJyg5byWH93XGw==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azlp17011030.outbound.protection.outlook.com [40.93.12.30])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 46djfc9e46-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 May 2025 08:49:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SabGDThZ9JnNPlzQ3Lcu7IRGjicc20Ct2onHefME9J7kYvzYEsJrnHufgEqENxwyJX9ktaLZfQ22DCnvR9P/hqxvYSCACyz7W49AfJvN94+C7HR4Hel7UROQh7aRaFHG428Eyerollfx11EVrJkK3Z6myU0xMHXxy41lFvbsowUpZBztiDjVI4ziGGWhf/hH94hw9ppmdy/PhjhHfpoGNNVOej6dsndMYH/YkabpEsuh+SFql+XmV/LVv+BcrjDwDCZ4GVKi+Pi89aysG2CepWIywqndv8gdEuzJPSWvQfWm2XIZitprzbrwmC+IaAQsMyBOj6IzK9Pm10PGXszEpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r6LEhtKF6kVoMRBVaZCbc67YRAk6pu872RPNqGtrJ14=;
 b=Mx2hst44Fgd4nJqqfYhOQG/u9sIhMvL2cQeQgUSbIdEEKYUmXe3NDHUiOiiELFLnTMuD/Htbv8i3+y6238AOIeZ6CGG0+aOCWjT6lw9F0kuTTJa/z8r4XtifyMUone1PeUrY0i6A569iHKSxuuzO2+LGS76/BlZcax6B1x+2pHEf0ygo8hd36jKZ7Dt5q8kjFBQL/sZBSJbOnhCcPwCmMNTu+qjtGD0YR6TxteLrm9YU26Hf4/+a03NCZoBfpanlyoZTWUqFz2p3IhabviyWbONHKy5cKBHZAeAQ4yPfU6sO5TnS53crLMSusptYFdn9143fONubP/r9hqMh85jg3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r6LEhtKF6kVoMRBVaZCbc67YRAk6pu872RPNqGtrJ14=;
 b=P6kgDUurBkNwn6c88WBvfvLqUL+SZwcMYWv0zOF49Ma0+XBL97NOerfUw/F9Yu0u6VOBNe8GpAcWU8A2bfhQ8BF+z+Lv9jXt90T1R3GkmQzR6pD8gET9eiuXRlebu37oghjPf29oni3DmYoufkqJZUucULRaQXxZ7lZmn4nV5hU6fuOBB37CZx/otZS7FUzvL8OVpT6yPU/oIvXWfpWo6v8TYMsnRPlnh7v+jECiCNsd+nACgcv3+fDy1TxkoiKL8vy9DM7uZvlCDKLm7XwzjIiNC9IMPA2p+HkQMNq3M/3QHNdZzizCEvGN0GKNEd5oGUGeepEhvfeHgxNxaQpUUA==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by CH0PR02MB8289.namprd02.prod.outlook.com
 (2603:10b6:610:fe::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.12; Wed, 7 May
 2025 15:48:57 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8722.020; Wed, 7 May 2025
 15:48:57 +0000
From: Jon Kohler <jon@nutanix.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [PATCH net-next] vhost/net: use xdp_get_frame_len()
Date: Wed,  7 May 2025 09:19:35 -0700
Message-ID: <20250507161936.3271345-1-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P220CA0019.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:345::10) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|CH0PR02MB8289:EE_
X-MS-Office365-Filtering-Correlation-Id: f77ebee0-d92c-4697-c805-08dd8d7eadb0
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|7416014|376014|366016|1800799024|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oB9mFfk1gCLQE4mdhfthfdUGHBiKJH2S/MYL9G9eHnswzqhIBOMgOEY7lR4F?=
 =?us-ascii?Q?1WC+CPnbYZ5dRzcxFQE9CgCkmZ6r3UANCr+ABxb1qUixfOXyyznIj8096r/i?=
 =?us-ascii?Q?dnSmOdj/o8f9stQc2zdXuEMoeGmHddigjlraV5Y6nPeaxPrnmuV9lwAtwicy?=
 =?us-ascii?Q?h9B2bEVSJPwNC+sogLtDNJcGFQIBpagz7DPSQ+ou83CwL+/bu02CCWJYNLZA?=
 =?us-ascii?Q?WXNQZdi/HS69CrriocF04ILaBjZSd/msR4CoFjkjgAkKeXyPUzA+wZraJM5m?=
 =?us-ascii?Q?0ujdU6O3JbHConMhWrTK64nEx1BxSeAZnaDYQpHtoc5XcemsbzuJUu2QgdXL?=
 =?us-ascii?Q?4SWkI55tYo2AtU7ScwSclwo03vC29qN+A+gJFkqkwGnSjoF1raqXhGtT5cW7?=
 =?us-ascii?Q?iKx0SMREIkVBhii6pDOvsFeL5zqQ0shvshgrENDD3pu/n6fr708b9NfGTw79?=
 =?us-ascii?Q?iULdvAL1Gndi/3zasR1Mq1Bz/K6ASaXPv/C7gJCXIQlRkBXcJWhxYOdwHCjy?=
 =?us-ascii?Q?ftylF9tJOFXvWj/zMYt/U+TIITuMOdFWdu8dvXWw7kf+uBD/B85uUcqnDzWz?=
 =?us-ascii?Q?UI36hpuZn4jH9H+WvO+4l30OpK7WoApHm+u33p/v7ar7vF+Ue5Wi34nO7mqD?=
 =?us-ascii?Q?kNau4OKiGchFAeNmKDl8Zg8/AlLBKoVlIvFx2X/53i0ZJq7eLxfO7Tpa3STm?=
 =?us-ascii?Q?MikCGf+5GQVt3zEgsSw09ZnQ8FEwSUzY9RdxzOXk/lI/9RMPPEFUzTYY6WHO?=
 =?us-ascii?Q?/6/o2lLPMO85pyiJqpCBTgeLD7cNpBysMXEtExbpgSwSHcK+ycyBCrjrMI6J?=
 =?us-ascii?Q?wwpXjbgDDWg2dmgxUcNKMn/oTHJqmnuX1u+7o35snf5lJ1WzGktHnpIBwXr1?=
 =?us-ascii?Q?ShA9KvSARyqBM5fIClCeYuvDZre8I1LLiLAOq4Rowe6uzHk9wmcOHz8UKUfV?=
 =?us-ascii?Q?/js5bqyX23gtlPAar3XzO/0bbFMly0/ur5zgMnOU3k3j0HwLHPiOZxxHQ7Ea?=
 =?us-ascii?Q?NYBWhwUYB22IOsH/vPdU2pBNGM8zIE18LKZyKmK15/A2NldMnoPsrwc1GOZr?=
 =?us-ascii?Q?zL1VIIkyU75K/yEp0ldYbF9PVoA0vkrAgG9IDzSY+WTWNIE2eggWrnOu+O0D?=
 =?us-ascii?Q?go/Gm8mOjnfw60PVmFu86s4S0CJwNiMr/2u9Ur8Oovl2t2tRv5d1XB0awMPo?=
 =?us-ascii?Q?gt3HGqLI43K4JPBS6Tfrevbolxvnw4HLqannCVLvVdzrMEWDYHBxGwKcdL0g?=
 =?us-ascii?Q?sEYgq9fbUp2dS8dGwVEZg+9ko3tkaWkihflqgyWCbpFYMwlxb1jcPXYSAfup?=
 =?us-ascii?Q?QqAkVWqlLC+ScneQqifdH7hBOZ/AjHeCv13YDyF9D8/Kmr4tfiFQPTzFOeVI?=
 =?us-ascii?Q?/wPmb84/nv9CfWPmS9V53Disdw/0ZbnQ827tuQx1XosTSBXGimS0Ix7UMbcH?=
 =?us-ascii?Q?McfeAwg6x6+xbgFlGO/uqT4PM+g3LpcsobSc0DTJrD8kxkQFEx+UfU2mjktf?=
 =?us-ascii?Q?TN3tpWxh/La0fMY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(7416014)(376014)(366016)(1800799024)(921020)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JrtZN/isOKL66qJdwUcsceoIr/MCqr2WZjjBI5N6Y9y35kvUHqwUg4PHa1q4?=
 =?us-ascii?Q?DQfL+fcAX4a+rmCcOj/8Zw+Ox6BcuM3BxIN6NafBwyKeHTQK6xZvnvCySRTt?=
 =?us-ascii?Q?nW/yKSs1LY0KkxSGYUw39B9famk0IWabhzCIFj7F44ao2Z5hTCkKk0EpD3O1?=
 =?us-ascii?Q?bvV26coZn7ouiQ+v0f/KA2FRJBJl11oZyEkP+D8s3tTSfZSUqd/7JBQbMRSX?=
 =?us-ascii?Q?U88/NvY+SC1FpDOSJkcZLJpc+/lD6C7+LK4c5YU68e7uMu9k7kTVVlX82cd/?=
 =?us-ascii?Q?1z8PFfDONC/jeRE02bmUVqnJ0hmOoMM+nohMTXECjrGogV4Dx03n9IagX+Jx?=
 =?us-ascii?Q?mln9inUQumK2BnZTNBwkJAl7UkEKPSib1rPCfIwdd0TQ+ZGuM5ZYzeY359fC?=
 =?us-ascii?Q?TqYM19+M99ZHK1EpzjSguM1t0hCoplNnQDx2sIQcoza2sC0EXO2yyE/07h6k?=
 =?us-ascii?Q?r1LuxGpJzi94AvvEngGW+9hW58Ob6RkIR0isEFgOQICp6HVGlUcRp1vJg1Jh?=
 =?us-ascii?Q?UE4T4Yvw7gqe9hgjFO7Y00uJsEpLCNYjn5uQV35/VgCn/eRgwye1ERncJUZY?=
 =?us-ascii?Q?TSt7lp67er33N1Vs32gmdREiwTMsssm65/K0uWj1qHxZAvfGLk2VGyPxNKQa?=
 =?us-ascii?Q?oLI2QwwFmOYnhS8kaxEjNTCxXJ3ynS5+PgKT6WwE8r6YhabHxidSg+B4G72W?=
 =?us-ascii?Q?0LhqMmZ+UDzlecBxxhKz6duo/mp6i+d0PDtzBWr1BmlwJk9jmcOaZJlz7x1Q?=
 =?us-ascii?Q?aMMn7odXiC4ce0vAYq3vchZS6LtQFcA5FAbNzFFbWIwNHgZqKksd7cIOzVln?=
 =?us-ascii?Q?6Y6NGZevxt3LDHVfNX+fu6OlD9QqV7+aLos1YJrnueFyzVc2JFQdHQ4AruxR?=
 =?us-ascii?Q?VSyPt+o+j0dzwArYzfEcpt0np8AS4YGrJ/WeoZAEJBwE3ZFVY98khg7DTn6j?=
 =?us-ascii?Q?+GnXUuSiuXO6AbbJhSoeGXxEpVH3BUFAhjZ/wHEA8sVhSEX3mIdzWSiuJP1t?=
 =?us-ascii?Q?9B2w6qWVSmIrovqSWUqzV5BYK05oenX8upRH35MaDK5ZmK6nkHwp149PxR3V?=
 =?us-ascii?Q?DSbEfowEJenX5t10SMCBFXLkrwPhtA8khqCZ0iUDlFDGDInItd5o71vsCkt2?=
 =?us-ascii?Q?RbIEbPqicrcaxSIoJwJRoQOj2AiyHEIeEQkRGBk9iy01ohI4n252Vd8TruoF?=
 =?us-ascii?Q?dwXirO7yDkyIfTsR9ibEhyivQxUkSisM2VHIQPANJwgJbS5WQTFVM6xiLIaz?=
 =?us-ascii?Q?NgjW34KWiQSc9trt18JZMYGYFq+TLFMz0lIURfI6gRv62vF3haLTW4agkrO7?=
 =?us-ascii?Q?sFQtkICDQ3Qnyh3Iv+fiGMdFIZ939N+MoADamqRExPb901Sw4NEochT74r4V?=
 =?us-ascii?Q?XATGhiGLVM035jW8OOaHMI43rhFUoWQiZA/he3tEPAUUORYu1xEkKFXcEYQg?=
 =?us-ascii?Q?rJHvMTJTA0JCvdhBrGIJ4LPPY5PNjD+5KkgpHg+J8qzsH8STuHvTySZ/C61s?=
 =?us-ascii?Q?DN4FbDbdpXV6P4a3TdolRo476nhSrFwLxtkdvS6km4cjRSIFOuHhOImCW1Rh?=
 =?us-ascii?Q?iXYsaDFjXe4/Fujo6hwEGxxxo9j2OKPF3Qw8dN1cprFcwCeZJkpz+j7QD5Jq?=
 =?us-ascii?Q?gw=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f77ebee0-d92c-4697-c805-08dd8d7eadb0
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2025 15:48:57.8576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rb7Eq9esa4JTYFK0OtKz2T+UnXar2kGuUIMhMb6Ke9b0jDXTXtNTLIoL8LHUjQcqFq1EdUQPtkFtWG6+LflLAM9dNV2+hDrCubLPlVsjDEI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB8289
X-Proofpoint-ORIG-GUID: 0lamqRC4oBNDehEy6NdEnSptOXzocYHO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA3MDE0OCBTYWx0ZWRfXzSXw2uob3+VF RmFbPLkRS98ya9Uwk9eH8t4eIc90poYsIZNQ60R21NDy0yOcIbfenUqSzk3gqs8HlEYsihDFGZf qecj8PZyRjSZjbdPlPmReNn/ShF0TFAoZFfcBy+K+/3ZZR0RDJ0u0/yzG67P3BHTW6F7doDECJp
 xhZGmdKT/l1B+oXwOtwDQB9G6jq+6PS96PDccidCpB45PcN4BCJmWtNLabLnjxUcaz5vUA9YxR5 jIkGUHVUizzfx0Ywdy9wZpi+9MS7hXm+EA7LeD1OGMNS2JwhghBQajl4p5NClfDZYr1dwFOpiK3 Yy/YaYpY2FdruTWxD4Gn0vHgUVYNwexqx8xMup1iYgir6q59gZtQseUD/KJxU+5yk62k2QNA3J1
 d1oUKJghlqkQPfBwA6VRxCneA6U2BfgWLuxCQvhjvqrJoK+APzvelIOQUsT/4DwPSfr767T2
X-Authority-Analysis: v=2.4 cv=Bu6dwZX5 c=1 sm=1 tr=0 ts=681b80ef cx=c_pps a=f1nyBA1UpxJqkn7M4uMBEg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10
 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8 a=6uMPQdlGWM5Its5K_aAA:9
X-Proofpoint-GUID: 0lamqRC4oBNDehEy6NdEnSptOXzocYHO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-07_05,2025-05-06_01,2025-02-21_01
X-Proofpoint-Spam-Reason: safe

Use xdp_get_frame_len helper to ensure xdp frame size is calculated
correctly in both single buffer and multi buffer configurations.

Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 drivers/vhost/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 7cbfc7d718b3..ff2fcb019900 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -199,7 +199,7 @@ static int vhost_net_buf_peek_len(void *ptr)
 	if (tun_is_xdp_frame(ptr)) {
 		struct xdp_frame *xdpf = tun_ptr_to_xdp(ptr);
 
-		return xdpf->len;
+		return xdp_get_frame_len(xdpf);
 	}
 
 	return __skb_array_len_with_tag(ptr);
-- 
2.43.0


