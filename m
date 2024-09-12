Return-Path: <kvm+bounces-26717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68822976B73
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 16:04:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B9B6286B88
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 14:04:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77BB51B29D8;
	Thu, 12 Sep 2024 14:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="NSojrDuz";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="NEbkbqiR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5EC1B29C2;
	Thu, 12 Sep 2024 14:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726149814; cv=fail; b=Dvx4L63i3DGP43er39C+nK6FA50P9I8p52GX/XIdPBu+CiPOxTPrp2AX2j81cI2Fzinx7JSlRZ7w72BsHL/aE6yTMSaHNde1Hj6K10UMwedjmeEmcgTgxyG3wXwPpNiB0qY4IU3ZogjAvPv6pAPxsNOpVmqjj+JH6s+a0K4sKhU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726149814; c=relaxed/simple;
	bh=d7Y/Lzb5oQBKoiXbEnDz7nYNgYs1lPX5apJgp69PMOE=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Qh6OVtYxNlQQ5dts5TfHH08uAYtUA/+9HfdBN39YIs57VbF1GR8AgzEY/8/GhXc+sPgVaxooiorN+H78LbZ1x4S4yhGQqVPfSTO+MJ27noj49wFZ035rK5AltVX4XPtRw0bM4lxEVkdF0vlYWKw9wgYcSqkno0fWr82XSE30Go4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=NSojrDuz; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=NEbkbqiR; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48C9Z2Sv021581;
	Thu, 12 Sep 2024 07:03:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=swQkonSsoqKDQ
	tA/mEcezUOYIJF9aoZJFmBuNo/bvtU=; b=NSojrDuzq8vugOA7rpPj7Spz55zUR
	T8zjy9OsN8UOdmOYcloKY5GU0DiyMrc8IyWztC6nh5LJRx5bhc/Flb3oeVR/J3UW
	rGPzj6x1E/s6bUUwsn6oOkQK4MHZNA7+sHV6O6m3R1KJUwF2+AgZnrmwKy9qSqYd
	6DpDJyXSIwNiYQZwdqcn6EcI92BnlgAuEi083AERam9CxV4uYUluaOKeG3z/H0Y+
	EmVQpP7TSIh+IcJ2xzsIGvnrBh5viWCAGeKGiKEQIepyq1WNsQZ5pBGSAGCZNadb
	m1MG3JSbRAlhogQryj/1dNaIwtA5nqkAnVh9VXREBI2GAbDtscpgHk86g==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazlp17011027.outbound.protection.outlook.com [40.93.13.27])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 41gmxhvfs7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Sep 2024 07:03:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cz62c3UtopWh09l0eByECJPwKFxwQIuCq+odI4wyL0pL+ZcU+5BJB4S3KQv3eSwAuvMUt80IxtCAWMIhy7RHVhIqsCSeNCo6G42tbbtaEc7xUCvck0EfVFRcvsBTRO/uvgg+4EcLEQi3F4IvuzMBAFFfsMYXXKZ8YytxLpIqhKdD8rwYyCVlibh1JeZpTQQGSTCE9tyhLmDm22gkyMrCUzjpErYANv66wrkc6u/Hsk1d8LW0CvTsFQwUEKwC0aiovxthzxrjA5d8YCgm2ES1r538HxpHDJ14Gzibv7+rq7GtInN+0Rah4XSyBgy7Hgp9nsSheI5Quopw4vhLdyN3Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=swQkonSsoqKDQtA/mEcezUOYIJF9aoZJFmBuNo/bvtU=;
 b=J1GBs5a1WY/H0KIJOiabdsjxqWMTErUD2fpBd7qFu118c/TCN5xEwPStRTaMMvwn5/rJaV6FmH0nLktxd7g5VSj1/0Atfy/4bhZzLStXyDFHzpugcsz7NDxLHPa4Ld9+WGoR0/LrQUvkXJSB+hMuMDVPzOFuEona6AqilCPWnCFUnmNAMTpqt/wiwC4/36JqrK9EsxKEnzEyPtD1FEnM8HUgjE2SNoeJEhAmHQ6/LYvIzvA8m08uQwSIRxpZPNaaNN2LKxYNYbB0K6zbeG51dYjn6mHKpdwAXVhr/COPf4bB7W5jGZFAckClAxnuk8KA1sapyBiFBHCB2bGp3Re57A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=swQkonSsoqKDQtA/mEcezUOYIJF9aoZJFmBuNo/bvtU=;
 b=NEbkbqiRJ9t5krf5SRNpyVZkQ/zOc+lYrW8/kWSGDfJxACBlBoeiD6g2XyS3tf4zQn4Wi9pPhgvID6FJSqw6ROgrwiHEmj0dIDKs6shrQgWtxNQBq6OgtotQPN6BuZYC49L92HGPUMp/EyyFLYGWEskRufIwOtqYnKtTWyONeFO40zy2cb8uyK1YVLa18qyydvk///Wz1dL22lTOO+/m7z4dlNSqhy8BQBZghGPoR7PTq18wWJcfRcGn1vgOlASFhvo9ov9tUGNa/0VbarQSLaTSJmla3DdzfK0swp/v8AI2tj1cCrVZBWXv6YwZKNA5mZgMuPPusPGQUCX/svwxMQ==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by MWHPR02MB10571.namprd02.prod.outlook.com
 (2603:10b6:303:287::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.17; Thu, 12 Sep
 2024 14:03:21 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.7918.020; Thu, 12 Sep 2024
 14:03:21 +0000
From: Jon Kohler <jon@nutanix.com>
To: Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Tony Krowiak <akrowiak@linux.ibm.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>, Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@nvidia.com>, Rohit Shenoy <rshenoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH] vfio-mdev: reinstate VFIO_MDEV Kconfig
Date: Thu, 12 Sep 2024 07:19:55 -0700
Message-ID: <20240912141956.237734-1-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0203.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::28) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|MWHPR02MB10571:EE_
X-MS-Office365-Filtering-Correlation-Id: 140aadf0-f3f7-4fdc-d05a-08dcd333a908
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|1800799024|7416014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MpB2YdyOCY54WSAt/OnwBjrOS8P0uS9TJzzZJDXvMcm3496rgL+QtEWywot4?=
 =?us-ascii?Q?oADoJnGRzwTAEKuTCChbP/Ky23Jalc5bLT7kXEw2TLeeqZCDiuadvErSC8OT?=
 =?us-ascii?Q?i/P4dsWIhcZkIN/FXlpShB4CnZNkzieIMhuFSiqs3DuEJAw7ZXL13y6ubxYE?=
 =?us-ascii?Q?M80NuzzLA2blPrUWIaBRdqlmJ20jBBChT0RWz0xeiGQy/pwmH+maQm6Z7epu?=
 =?us-ascii?Q?+MSMvxf+sPUTaMBGa5aT/OY+LiU1+YaUFP+vZBp69sPC939ypMrOPbDLWyqO?=
 =?us-ascii?Q?6HU97D5z9c0x2aL346eU5rh79GFkGUukM/DOwozADj/i3tTHPzxvN0OlS2Sr?=
 =?us-ascii?Q?5aC75ofnik5IrnQ4tFKSR49DSh4fMhiHkeMshEPjCN+8bOktgL8BhmBICzfL?=
 =?us-ascii?Q?DmyOPb/AELBWe45l+zjio/iGhHvTPBSuRG/KEyY88e78RapgjOXuiImYXXgc?=
 =?us-ascii?Q?BomavlUaCa0mWDV2+SkO7K1ckgz/yBKDxeAd+rOhiZrGgtm/DI3E4yZH4lw4?=
 =?us-ascii?Q?nAxTaL+Q6ooe5piIikT3KJBQuqjzjbOfuzKcxrDyi/Ej3wDfCwRr2YwQqJN1?=
 =?us-ascii?Q?x9GFbohUVoIhzILcpFm451vqKpOfJh2jjt7mwtx+MvIR0XE+TecfrSss15lK?=
 =?us-ascii?Q?vNblrvO4JVeUZassC0eWqGanJL96bXVAkNmBNI0cvLPlMp2b4V+OoU984DJ8?=
 =?us-ascii?Q?DqTPbD3U6pZKszrJXR7czz9XsQzB/OxL8tDws5AUHWBoHZOqRoyCW150sJtV?=
 =?us-ascii?Q?TPClgeNZwl40LCheuDgxLAhlGtBI1uRlZ5OFV/WqzzGmtlHhJa0gB83xFlpb?=
 =?us-ascii?Q?382Bpl+aKhWOhYSWXD/kdWAXnUNar+1p5oN+k9R2RXRqdiNBCdexNXjrp31v?=
 =?us-ascii?Q?V1PFVT8CpA3QPxJWzxZ2iZU29dg22mqAblnMjX796yws3jv8ZAlUc8neC5Us?=
 =?us-ascii?Q?700uZ5Ymqk7xWb2noVeZdek2fbh0OfgL64Y90AQLLMJQk+E63pWVnHxTqlJR?=
 =?us-ascii?Q?OlVi3VT5QSMZfJqnSu+pj5s5NVTlh5x/57vVhqfXlDQrL2kyJs+FrU6kGqiy?=
 =?us-ascii?Q?m46S1MHQqU7xlfFN6gUavkCI11J/JqIWyIQOst4h9AB2KwFD34OOSHekisHF?=
 =?us-ascii?Q?YGO0yXIo13VyPNPTCUvYVObYtJ9pPOMpvE/1SExCZeuXnU2sP+36YmTVvLM9?=
 =?us-ascii?Q?nOPYsDexKO+bYFMOpz8aGObDhJgGX8hNEhQ63TujyR8/SEXWWaedwJ6yVd67?=
 =?us-ascii?Q?wEh/qquhPzzwKjG2tEKIVBN+Q2VUFcwLaBPIAbNK81qZYVUM6rohPsqhdCzi?=
 =?us-ascii?Q?4vcSSgW/wo1AfacTvK7ldO8Wt+1Nj6+RC79wgPzH/q+HxJbmhXKBpAuBdcOH?=
 =?us-ascii?Q?0GWfAJjgofg2iT8TtdRXp6Zsls6TuRDbrj2Rbx4sXeZycqp4fg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(1800799024)(7416014)(366016)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MLvgT4n4/PAo3Dw4fq6uUBVRhPNtXVze6cQhUjxmorlAH5yyS6vCFtiGHTi2?=
 =?us-ascii?Q?EdpYILA0ZuMW8YTS+MLk/ay5LSKfiY1R6B5R+TZWgPgY+ePTTrjEanrgABW5?=
 =?us-ascii?Q?HCmsgFMgMkXt3Rv3GWDhyQbkwT2kYHiFcVSsIcMEt4g6TzSlWQoqCiihW4Y0?=
 =?us-ascii?Q?XUseZQWcalWs5iImjOg+dBTn8pYp3bYeBxG1Ui2pjJyDEqwTvgzx6C5Xde1W?=
 =?us-ascii?Q?F/7HnIrf3J/1NcnA/7PrifAK9aCJ3S93Ojrx3zvBWES6DxnewYrl1LIiM9pL?=
 =?us-ascii?Q?Q6nIz7McoJgbSwgCsq0HwVLBGNLxzI51rBu/R1GpEHaSfTZ/KQQpwsiIq1Hu?=
 =?us-ascii?Q?hMZWhQJnhZPVAxyff/Y+E8w9WutQumW9UGuuVgYPKSxCEG+YuGnGQa6qrWkm?=
 =?us-ascii?Q?Qvwqiv5ADk7v/DPz3FmOEy0yMHWlCAaM7FxevZOmaDL7jSrkYvzQoA6+5y0k?=
 =?us-ascii?Q?PnVwnEmZ09Skh5XJ4Ld9JilUQFlpgcX+HLgcj7ah5gsd/8Rt7F7wwfmrmuim?=
 =?us-ascii?Q?DIlNbUWB3lDgKmA6+72u+T82UB7d6B7jaKbfiXR53O9d57PQ3MwsxkH3PYMW?=
 =?us-ascii?Q?ThzDOQgmBn2jXgE72sGp2sy+yev0SjTa8KV+bP4ARDKCrRQx60PPDyEv+4LR?=
 =?us-ascii?Q?vvv8cGgbJgGjy5Ba9GsCNQvICTLmFSKDIeCZ5wcpaMPZC0C2UpxKQz2sFFwU?=
 =?us-ascii?Q?TqpIhS3Hzl0JEVmK/MzDmrLyrjlIg5hsTWR++G/php1p9fr9X30HCvrgl9Pa?=
 =?us-ascii?Q?wqqnyoKcI77NDc/H1EWZXyhK4fKhpwStnsPJWUFlLyGbBehw5fF6B+zDbNIx?=
 =?us-ascii?Q?zT9uSZrG3uZuj36oLpdxC1ztMY4bF7Ju40zcvI8Ys+ezHUy55XVhbSp47eaD?=
 =?us-ascii?Q?1kLPa4P01cI2YAEzReFpCwGGG6R6v7NS3koGpvXQXp7Fc/efpDsbL/MX2a/+?=
 =?us-ascii?Q?5mU1HbMI2xrqRCgCreRfymB2DdkbeGkSx+u7f+HFfkXTYffqlibdMHVlXgRm?=
 =?us-ascii?Q?Gb5fimrLB4DzCEtB+c2D9kXxeaKCdqiw8LOUKY9dueebCdIqlE/0EYDdBuRV?=
 =?us-ascii?Q?9+a5fs02PakxjH1daZL/xYLNoVSR5fQp7/5eYT+UgelyCPlMtPI6XLfNg87b?=
 =?us-ascii?Q?HmgHefm97qNUkmUMNKk4Mtsva6r5tiKnRkyFqMKscuEMIYYcLjDTguJXBCPf?=
 =?us-ascii?Q?xxjQgWxM2Ne9EIHkycWP1cCOjxEP2PebdasBgJ9AOgKWgSTlc5Gstbt8dXnn?=
 =?us-ascii?Q?IeWIctaVt0dQ10zCssTHK6jRaHS93e4rcfGlp+n/D/NCsiSvJ01kK93iQJUQ?=
 =?us-ascii?Q?3GLNs0tqicP/JSpEtJ3I1daYkb0SKbaP11MpyXUhC0iA2O5108JHrQDkaF53?=
 =?us-ascii?Q?bl5BY3xvwxmK1qSJGlxZC0zIHGZ8wzedAdkjhU/ZWQv+n4XTTC52Pca+0r2o?=
 =?us-ascii?Q?ghni0LC5LiNGOxz1crp1EPwZga09SmZ2TqDurn0zNwTkYm/Yw/rB/8zq5Jab?=
 =?us-ascii?Q?eEAIUu1+IbnzIxsl8FRx/ZpaPGwqW5R0XTrJ9JuxOb2Wi4fPROSplyieCD88?=
 =?us-ascii?Q?ILVDteFnu8HAWLPu3n0CMxfkrMdiLwaIbwVNVpXKiNTQSS88Uki+MsmSTSdL?=
 =?us-ascii?Q?rQ=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 140aadf0-f3f7-4fdc-d05a-08dcd333a908
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 14:03:21.6422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jnpYzcXbnNdKISfCEEGwEGHs5QOoX4QtgQETidVMRcbxMKOm7YdTEMyHxJ11D5NmiSzBDpA7V5cWzKM5e2zNHYJ2UAHeQ2QgG+pWnV1yd70=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB10571
X-Authority-Analysis: v=2.4 cv=SfSldeRu c=1 sm=1 tr=0 ts=66e2f4ac cx=c_pps a=U0KzkmEawxegXmCr7eTojA==:117 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=EaEq8P2WXUwA:10 a=0034W8JfsZAA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8 a=20KFwNOVAAAA:8
 a=Ikd4Dj_1AAAA:8 a=VnNF1IyMAAAA:8 a=p4TyGKwq3amCRySJVqkA:9 a=14NRyaPF5x3gF6G45PvQ:22
X-Proofpoint-ORIG-GUID: H-nTBx--hPOqTDHRAnj-jDgWlJopxbnp
X-Proofpoint-GUID: H-nTBx--hPOqTDHRAnj-jDgWlJopxbnp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_03,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Reason: safe

Reinstate Kconfig setup for CONFIG_VFIO_MDEV to help support out of
tree drivers that use VFIO_MDEV library (e.g. Nvidia GPU drivers).

Fixes: 8bf8c5ee1f38 ("vfio-mdev: turn VFIO_MDEV into a selectable symbol")
Signed-off-by: Jon Kohler <jon@nutanix.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Rohit Shenoy <rshenoy@nvidia.com>
Cc: Tarun Gupta <targupta@nvidia.com>
Cc: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/vfio/mdev/Kconfig | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/mdev/Kconfig b/drivers/vfio/mdev/Kconfig
index e5fb84e07965..b5e1eb634e62 100644
--- a/drivers/vfio/mdev/Kconfig
+++ b/drivers/vfio/mdev/Kconfig
@@ -1,4 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 config VFIO_MDEV
-	tristate
+	tristate "Mediated device driver framework"
+	default n
+	help
+	  Provides a framework to virtualize devices.
+	  See Documentation/driver-api/vfio-mediated-device.rst for more details.
+
+	  If you don't know what do here, say N.
\ No newline at end of file
-- 
2.43.0


