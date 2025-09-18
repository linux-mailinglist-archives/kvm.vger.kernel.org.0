Return-Path: <kvm+bounces-58026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 995AEB85CD2
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 17:55:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B92F61CC3A22
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 15:50:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA668313D63;
	Thu, 18 Sep 2025 15:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="axUZrkFb";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Wvk2kBB6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E1A155A25;
	Thu, 18 Sep 2025 15:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758210538; cv=fail; b=FG198z2m64l/fCNmQHyyfLszDOkbcqffY1MW7PR+HYbfNXJo+iuSQh+cCkPPaeHg6FkYgU15pZ7HVr/Mbk63aPsHjrrCLf1FiYdEWDoJmcR1113WSD8HcVJW4WgAXjWXIs2weIfjG+Qy5CsQFyNiaH6hYpIyGt4r8ww0INrZKi8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758210538; c=relaxed/simple;
	bh=9VtgwqqY0y2rvjiOP/UiGuWYo+FfN4niFYDZ1wDD8vA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=LjaLuLYNaSDeDGkwIps5LQbJBiPcsdhydv85LeBXCTqbl/ygkiZqgdscqSdWJtkuh65rTLjHRLRPbq2Dy0AfcA9bDUDJdtOAq3uV4Ha8weh/THj+ZOzXZnsJ9ZIwqreLDQJEekaJvUnY+ar9cja5omJi7zToI4WL8t6XmVQmzYw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=axUZrkFb; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Wvk2kBB6; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58IARWxP3717699;
	Thu, 18 Sep 2025 08:48:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=UwjyAwt8gkbdl
	8zbvS8yDKn/0ibIlXF5NIw7jnzO9zI=; b=axUZrkFbMH1QDHZLTsF16iH/viX23
	R3ct2b6ulvb1dRpo984LrkKjxYRc4efkUsbsV6sgKyjDh46m3giGg5jbsBTmNuvP
	G3LJ/5Eqo9wlmrc1hs3XsdDzhY6ssBYRDN2ND8PNTz8fU60R48uRfAu2gols+8as
	25nzIEHiOebSFiCKhwnMiL97mF4yEamqTp7RxVRV0Txo6rNcJjlqevsGqDHv8h3m
	EREvx2q3Kk13dd3zYx6GBm/QkV+FZvdut37XPf9+W3Ao6+ltLI3+W9ioq1wDTQUi
	1V/3Vx9Wc5GPDlo3dU9L8FatGiCdMPClWDPKFmAnVxac05sK9sajyTP5g==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11023086.outbound.protection.outlook.com [40.93.201.86])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 498gbm8qur-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 08:48:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mCIiKSEtT+HNUNR0+E38nVgwcmfqC2NUWvPufyrHX43EqqzLaWDBFu0r7KAtB0uZWG74+2eK4oFm4RK8525oo1QGzN6mpendleUt3Jtzpd4Hk83SJhdGnpsZ3dVCw+ewdEkEV4HSOO0HMXa31899Oc1kfomtv4m/k15+FKnCguRuOzhKYXJeBfYZ/Jiy0REhR2enbGZN3qCEYYpv8O88EYWeGHasK+w4j23qu62IbT7GdfP+DoCc4nJdd5UkETr/m3biRFJDgrtflcxvLkcpJW+QSt9Hik2NkQo5bXNwlXGvbrb2PG/Uozk5HT/lxbQ93PhH2f63Drqio7LFoxi/rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UwjyAwt8gkbdl8zbvS8yDKn/0ibIlXF5NIw7jnzO9zI=;
 b=vGzROl2SHXftuFKlxqa3Sl2BXHXVxMHebdvfXaO5OOJtqry93HFH/LRYRSeOb5fHics2LM0V5E8WShlTpSKNYi8DzQQZ0LwrNIW8SNAh4CWavjx5euHF11teu4R5WGAUm6AtM9Dpp0IvYCdvfLzPukHD7W/2BbBbXvdgQtTxFOqguFOIUKUQ5CLF2KeactxMpiAURhZDIoHuQbC2SINf5DNR38W2NKQaG/RGhk/gytDHRYAUx+h/xZ+hNI+sc1wzBFMCXQC5AxcN1VVEkNRMP9zTHlJpHcwInxAnr6j0JHooez23WtsX781Wr/ijYuPeMgCjQFVHlrdNWbI25mHIyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UwjyAwt8gkbdl8zbvS8yDKn/0ibIlXF5NIw7jnzO9zI=;
 b=Wvk2kBB6VDJgkWnWGIqX6TP/TRw2AibArzh2ClW7x9E7czpd7af74jcI2ih6oOdlbCxwm+QgHGKo01Se3DhBSPE0aGQxb+tAXwegv0iB8vao0RPFU2Yp50ZVttk/0044uv77rN+CWBrSCN4EFaxoSwszPA/fdSAvHlW40tICxw7XMnCalbwgFhfz+x7PKz9MAI+2mHmETvrNctVzYwGQhtcTdD27Ze2uaSi99Pc/B2rPf6ztYeKZbcORpdOdisGM7qW+GEXcbfatRluH0ggDjtaHoPCP4fiiwyTnlcK2hrpg/VjZWha+jKC+jf4EWCZznBer5uj1SppA5zdqFTlAcw==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by CH3PR02MB10462.namprd02.prod.outlook.com
 (2603:10b6:610:20c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 15:48:04 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9115.022; Thu, 18 Sep 2025
 15:48:04 +0000
From: Jon Kohler <jon@nutanix.com>
To: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: jon@nutanix.com, Khushit Shah <khushit.shah@nutanix.com>
Subject: [PATCH] KVM: x86: skip userspace IOAPIC EOI exit when Directed EOI is enabled
Date: Thu, 18 Sep 2025 09:25:28 -0700
Message-ID: <20250918162529.640943-1-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH3PEPF0000409E.namprd05.prod.outlook.com
 (2603:10b6:518:1::4e) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|CH3PR02MB10462:EE_
X-MS-Office365-Filtering-Correlation-Id: 233b00da-f756-476c-8873-08ddf6cac16b
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|7416014|1800799024|366016|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SD08i4A4Hu4MwQyLoKyRxo7joD+DbHM53ZAMkja5GXbGrwouldRUnjoNIoSF?=
 =?us-ascii?Q?cJWATk7fx+kF+0v92/9YnM5f0RQQ4oIrgcSj3bGZfoo/YI+QcLAduWs5HGAG?=
 =?us-ascii?Q?lC2rjy8ZsRYfB20B2R35C4c/EIDVifxxQSPOtyLJzqAaPG7HWheTMXGAhyyd?=
 =?us-ascii?Q?E7igM5cDRCX1OhzvWqyWb/WGoREl4Lj84Am4m5+N8/pQrL1jBSJLR4xxT55e?=
 =?us-ascii?Q?vtMiedMlNDCv2XQmUCKH69wWKsljUT6jEFwqqxx/9uxR6tjKml0dKd+Nu1ct?=
 =?us-ascii?Q?N0vaU4WAEu0rMEeY+Ajg+WeFZAOU6tWWfojb2o4Hr8DqtTblswUWWR/tgan9?=
 =?us-ascii?Q?n3GaK9a03hSFFy+nC3QIr3A9BKkUefJFnPouY7lD6r62f+5Jd0ZzxbN/dGXb?=
 =?us-ascii?Q?N2ZRFxUar2D6NPKquRa04u4uaPIRLs3+hYoTwxRAumQiUgmWGk6bkKGR+iKf?=
 =?us-ascii?Q?1Ws7FbxQTswjYZiWvptGs7R+bUF3rlBufBPwdJvUm5rJYQdTPBa8BZDtVU0I?=
 =?us-ascii?Q?YzAlu9bVDU8hTc4ZhC4mVRuKLQlRHb3bXsm11iO814BWLdhsTUSrqUMmNViZ?=
 =?us-ascii?Q?7c56OGAXxsHM/ohrsdYuiVtWABOQPbIPfOoAiICTdd2q4jAujKHFZRzReiK1?=
 =?us-ascii?Q?/hDwedoW+6GF8TJ/iG6DxVGHYMTIWChyALpFpJkMnGYlqGFLDsHPIzrXGx1T?=
 =?us-ascii?Q?OuxNWVLkE6CI8Jj4XxHIfCC8RfdfgUHSI3cEAlvDWF3HFj5I5Y4KyxbSL8TZ?=
 =?us-ascii?Q?HQqLY86cJGnIinqfSHg6F3h7KJSCoAvi6GAnuhxJ49zZ7zkUY38nGNFkYfUQ?=
 =?us-ascii?Q?fshjKabmjUNB11VAWjR5wNDyB0q7sIZNqb3n8+moUfh+JJWzBNAjDPGeTesc?=
 =?us-ascii?Q?KQfpRQV3KdwzEj3zT3Ti7tPHmZlOTb0jx/dTUPtIFn4nwyhVTNKQ7K2rRCo4?=
 =?us-ascii?Q?ujNXtBtkp9bCAYzB7Jh3BAKnC2swYHuXlrgwVTYv7hN+Ay/wTe4Q15F8IDoB?=
 =?us-ascii?Q?73GQOUltgqMcbvE2zqXCRGDm1Cd/LuPUsI/PXwHlWLg4PMvzC4s9T8AEPdqK?=
 =?us-ascii?Q?eGzsZpYgGoCGJ3vxZdocHvV257KwL1Ni+MRHRg/6HGyfAGGqWgsOtx1zWjRF?=
 =?us-ascii?Q?ykCHAu9EbLWOmu0r8GGKU8/WzwZYPEHfym0RPEfJgK0Bc6RanqmNy+/Zq4dw?=
 =?us-ascii?Q?8I0mT53quipetNGbd/Y9K5T4DwfIGrViOrB6Sawhi0ehL539zFXCDH3VAXpq?=
 =?us-ascii?Q?9vfoW+cRy3FW1lPD5orFUK0wa0QQATW0lfFjYsvDW0NHqtCK6vmfvcDVKU9M?=
 =?us-ascii?Q?3qFQ7yPGojwA/A63KjCOdkteO6kH/dwfYYpf5uG1aTDltZL/pqzovyX74ryn?=
 =?us-ascii?Q?n4pYtdJCQWYpEiKJSFQXMFSM+gyqJDCrVXwgowXyVyV13eLJeutZb9ZkX/Bj?=
 =?us-ascii?Q?PboI3ov6oxXAiMH33ClTe7oN+n1yO2LurToGIVyCqHlJxfUeMehC3MlFz0uW?=
 =?us-ascii?Q?F1HZCvRKr1mvzn8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(7416014)(1800799024)(366016)(921020)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tUvOjZm+UfR9g4jxQMW5hbkYYKaciJkjxuaF66BnJRaF4akqFyTDTvJ3jk7S?=
 =?us-ascii?Q?5qohqQE/UpcmnV0P3IJBz+6VADqooFxjiJme8g5VPnOvHEpFiXVt2ChSR3+E?=
 =?us-ascii?Q?JRLBOElQcfytVYlhbY9bZ4TmNelkEcIEDEo0qjJBYuH7xih0ylcVgSX0Ib/B?=
 =?us-ascii?Q?C06U/VpSQrNCnxS3VonDl6OO4PYqrN4YA34RdHPQJ7dOmncD6d4FdX0m/hYf?=
 =?us-ascii?Q?No/RELtLMeiEsye+tk0HMPNgX1+7KQ3ZkQpoMZZ/zHS3xJRZL78Qhw29q/gy?=
 =?us-ascii?Q?zV9wt4FjM74jTVdfMW69W6jvaXZbMT67EWQzmoUxWYR4orAZHG8ikhhsHgox?=
 =?us-ascii?Q?DrLkkbH8k3Jyjpu9Fe3op1NuQNR5Ulxqa0bmFp2olzsUumZsBRClcOH6KctY?=
 =?us-ascii?Q?Qd0fycj8rJtjDEgFjDF+M/qgikBvCPWscEeSQbmHH81qf2vHFSubYYDJtl8G?=
 =?us-ascii?Q?krWU9uiyFpp2ktf7onmWZFLvUE+8fz/P1Oa7ek1Tvvg2B0o2Fs3a4W7i4+xz?=
 =?us-ascii?Q?4ENdVuJjNHm2NkFu83Nq2suSLzZUCW1d/Oc5LKiFphN/KAbbljtyJdcPcT5g?=
 =?us-ascii?Q?8umeqBeskBPsFX5+jexG4IQOZ506l/D2ecMk0c5dtVySVaKgy6lzchkTetKs?=
 =?us-ascii?Q?EN73sl4VpB0QjQ09htjjjBlhEDuG3uRtD4Ud3UVTSUV2K9rWQNwwMgpHfC51?=
 =?us-ascii?Q?LgPrttdTEdXd/5srlKJVEv1NGDobn4Mmew6zqkXX0UVbGrhnT2tP+9I+nlIO?=
 =?us-ascii?Q?AMEdPdx/wfheAdyQJFlSlzKez7EPMle7+q6k8zIwaO31U7Eqy7MBXzDnee+P?=
 =?us-ascii?Q?l6s3k9m9gX836ZNq3V3t3Q0OKxpXCw/OH6KWqxRQzHYVRGKo4TK1phShmji5?=
 =?us-ascii?Q?sUB+S0xCV3zOTsAzNam24rBXhJEQLsNe6fTeRAv+ngH/pY4e8hztrMQgHZPD?=
 =?us-ascii?Q?mBia8xBWq9zxJPoxxqOYYRYvIs0W6IsHiQaWAs/uNGjIN70Iq22c7ewHsdek?=
 =?us-ascii?Q?xDnkyKOlUZC4m3gHoIiblaDTigpiEHhtG4hmN7KXLLVY4oFXHu/ilVzr+Xj1?=
 =?us-ascii?Q?M4C8+snzxHfS1f9tdjTwtrsIx+Sqy0qwSiPWVOBtya+IJnyVB0PaZoPGDOV2?=
 =?us-ascii?Q?7I2ThBmFUAU8lxnn798Gxj2xxdKWVfD0JKj39r/9I2oGLypG8M5pa2Eo61et?=
 =?us-ascii?Q?srnngOpyVEFNH65JTPaAML0PZ/pohYqdyWD47ozKi75q8TRP00ygMiYTGr0L?=
 =?us-ascii?Q?DPcxi9g8aF+1co9AhPpqZzm81ltPmkxuY+K51GmK8Q3sN2af0xRfLWvaSvEI?=
 =?us-ascii?Q?AbxRDcLCQz1/p5ZrKz45wlc0Da5GxZnaIKZXP4tvVeBroo7xZcDc2bbUzXZL?=
 =?us-ascii?Q?8aSJuaH635IDEobmdDQZAA0eqnru9gwKcQUvz4a76+bzOiXQruVef51WMXT9?=
 =?us-ascii?Q?VpP7J7dPDpMRs4QVtMvCrHxOeNA922aYz2/9yMX22FHKLqkHnbEhZOqt1PqN?=
 =?us-ascii?Q?04n5NvFeqy/GvyB9P4i85XfxlfDGDJIKaPJs33ACJOhQZwHooxM/Y6yswl4X?=
 =?us-ascii?Q?aDOwAVQKlpZYd3UTZr28TICLH5YEOlwX16+y938C9n5F5HolHMUR2/bpJD1L?=
 =?us-ascii?Q?cQ=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 233b00da-f756-476c-8873-08ddf6cac16b
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 15:48:04.7139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CVof8Fvqac3Nqr2kOuu8MrjWvNGjLray48L1ykeC/Kg2NMlLrNH7TSyvocxOt52CbSly4/+8Hqj5al/HzpLMk2G5SPHM+wI581Q2392713s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB10462
X-Proofpoint-ORIG-GUID: lE2cveuFWkdkEu2itlG24q3GgGIzGUvD
X-Proofpoint-GUID: lE2cveuFWkdkEu2itlG24q3GgGIzGUvD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE4MDEzOSBTYWx0ZWRfX+RQYX6XKzjdl
 YciPNlM1xLnF6sZVs6M30HLXJEK85iGPVENUbV8Z+C/yAtIrWNoivRczy8lRbI1gakRlg/if9jR
 HCH1t/KDnjrLI6e+2gyRjdmrYKTMbzin7wRw0wIjjnnSeCxmgbBPFbDod9nBgGW/7MS8UrBtKkr
 jFjVPop7Yb7nh4PXy9I/lqPbaPfUXICdyPXh1z3Bzky7JWiJINcO9/vn+pE9p/ICIwOw1Z0eDxm
 fZVOCx4+9KDO7Xd61wYX+vyMRmViiGcLopb1einWfcr+Z7OnyojgBZ/ZONzVcpBTi9J+shSo7qp
 BzX0qOut3tqHELPW+O9r+xR0dhly0FX10x2XwuoSu2oOqF4XWxTw6fG25SucQ8=
X-Authority-Analysis: v=2.4 cv=ObiYDgTY c=1 sm=1 tr=0 ts=68cc29b7 cx=c_pps
 a=abZUFfWgJRaQ0xfFFz1/lg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=VwQbUJbxAAAA:8
 a=64Cc0HZtAAAA:8 a=K5KOoJY4V9ZbvJogtwsA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_01,2025-09-18_02,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

From: Khushit Shah <khushit.shah@nutanix.com>

Problem:
We observed Windows w/ HyperV getting stuck during boot because of
level triggered interrupt storm. This is because KVM currently
does not respect Directed EOI bit set by guest in split-irqchip
mode.

We observed the following ACTUAL sequence on Windows guests with
Directed EOI enabled:
  1. Guest issues an APIC EOI.
  2. The interrupt is injected into L2 and serviced.
  3. Guest issues an IOAPIC EOI.

But, with the current behavior in split-irqchip mode:
  1. Guest issues an APIC EOI.
  2. KVM exits to userspace and QEMU's ioapic_service reasserts the
     interrupt because the line is not yet deasserted.
  3. Steps 1 and 2 keeps looping, and hence no progress is made.
(logs at the bug linked below).

This is because in split-irqchip mode, KVM requests a userspace IOAPIC
EOI exit on every APIC EOI. However, if the guest sets the Directed EOI
bit in the APIC Spurious Interrupt Vector Register (SPIV, bit 12), per
the x2APIC specification, the APIC does not broadcast EOIs to the IOAPIC.
In this case, it is the guest's responsibility to explicitly EOI the
IOAPIC by writing to its EOI register.

kernel-irqchip mode already handles this similarly in
kvm_ioapic_update_eoi_one().

Link: https://lore.kernel.org/kvm/7D497EF1-607D-4D37-98E7-DAF95F099342@nutanix.com/

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 arch/x86/kvm/lapic.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0725d2cae742..a81e71ad5bda 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1473,6 +1473,10 @@ static void kvm_ioapic_send_eoi(struct kvm_lapic *apic, int vector)
 
 	/* Request a KVM exit to inform the userspace IOAPIC. */
 	if (irqchip_split(apic->vcpu->kvm)) {
+		/* EOI the ioapic only if the Directed EOI is disabled. */
+		if (kvm_lapic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI)
+			return;
+
 		apic->vcpu->arch.pending_ioapic_eoi = vector;
 		kvm_make_request(KVM_REQ_IOAPIC_EOI_EXIT, apic->vcpu);
 		return;
-- 
2.43.0


