Return-Path: <kvm+bounces-30105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 339009B6DEA
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 21:42:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47F001C2087C
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:42:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C841B2144C9;
	Wed, 30 Oct 2024 20:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R+EJ2hsT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IaKyU3vQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E45219CB8
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 20:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730320682; cv=fail; b=NUzkTGPJVKe4oynSo4QvE3YANXTORIV6SLyU63yu8e/x7TaiauOyw4hdQB1oAxRuqiYBj4UY3TnUTz3PZBWegcKtMgCVChYh6WTqtwqBWTWgiGUi/jjC7qgHVP0N/wTBLw5MlITf8FuPcPp4TxCr7Hkk3zK4az4jY6ksmc8tszM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730320682; c=relaxed/simple;
	bh=sjmuyRw/a359vDmLnnTrPzawmDrn4Zcce4sjowkVqtY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Lf+2o8J3gmKWv8+uY4N8RJXixrUq16aKIJh6U8dKM2Kl+LeelIaGr7zgI+ohmZQ57UXYXhfSjrRmNb8pTbR87mRlWGyJh9gRVZpfjvjWj8p8UQY4AVP9kaEn7AjNJGkhtVv8phdc5NXjj7YuIKppzdhelXe2/Oh1WtMVNFfcYx8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R+EJ2hsT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IaKyU3vQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49UJBiDg026917;
	Wed, 30 Oct 2024 20:37:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=CFhRWh83nOeOoEwY038UgKxUvsIhbGxMIeY4Zjxqsxc=; b=
	R+EJ2hsTZo5reLSMqOQxLEVvp0HwIVEp1XV3ikFx/hjKnCytjEV1iNyBMe38U1Zt
	qEhwKJZ0/UZMQQdWb4HZdcPkMqosIbwrNFWimel6gikq8Qwkgv3B6YppElyXLzx7
	bX3eyeECvm0oEgByLdRw9yE4wt1lb24QP05M1O0KCLqf9yFEcwcfyCc+wgxhuj7t
	AEfzIFaAILtGumItMSlChz/rlYQ8uqAeLkP38VDcolyMymP720Iw+V+HHFyBjG1+
	t8gM7S3uVtYbbqx9XRx/KGbyvIv941L9qh/iPU87eP8XG+/9kI23sXTspTGVkM44
	IPayPUgKZi/g1H0BO0XvrA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grc911k5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 20:37:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49UKATAj040315;
	Wed, 30 Oct 2024 20:37:31 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42hnar372p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 20:37:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=anpgfFlUcIzSJJP2BZX6U3YefPb02WSxShbIbPZaxuM3r68ivo1uI0VJx5ZRIITsAhTggwU9GwKecb93TSy05qGJKy3c1JIF3Idy6FCcwdcpHPdhLULB9RJwzl6FmRr4ljCLrZa3F2+wr7tbDtpRKMzrc0pCNJ2xxYf02wR/nqHedEfhBe8vTOcJhYZo3FJqWbYdSxkl9MH2RmVtmORPFuFpFMV4o5+g/vfiKTzD5hRPNZc4P9eFAci+9zJ+zNo7KVl63Hm22T9Wh68HDdEKnHDk+4THaxwUJk3wBbfmrmqGmNAMMCzfP0DuIoDJIlYyuMBUq2zqnBMZcnNsmQUeTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CFhRWh83nOeOoEwY038UgKxUvsIhbGxMIeY4Zjxqsxc=;
 b=GZPP0/qDPtUCCAWyVoOA6MU8tDg5QtUHsUAO15pVipu/HhPbaKytN5J3XfuUU/eCn1DfTJVIAe/4ye4j+xnhO8kCzhCJSeBMiEfvgB3DISqbYBzCwhD3Go3cRFNYwYQpwcDgBKzEvBIXxNuH30rjYApf8VvW1ebcR0OezBPkWHJD+vDgQWpxHRI5MpTrUup1sJNZuEGSx299faAkkHCzgllXUq5ExpMdp87PkiiOHOK3bsm35fAFshVWZmcd/pHhPSeqnECyF2RYr+ugrcc6oAdGn6Lh4J0QEXDjqDe86xHtj4cftf0D+fEM9Hzi0uYKrAt3+Dafx9DjBEyLxT6//Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFhRWh83nOeOoEwY038UgKxUvsIhbGxMIeY4Zjxqsxc=;
 b=IaKyU3vQ7QSxS97BVYnHX4oOAnJ9Q9ygiXZFdHfoP3pxwud5zvse6QOGZWY+TlEKG+u/Z5LC6ORBQ9GXKB7co5HIkLqNd1qlFfS20SlxvGmCDBRxFw2NvyIgSgiRKuUcV45XQB4xMBUkskVAOaFztUfelvb8CUqjPVZqaFndX6I=
Received: from PH0PR10MB5893.namprd10.prod.outlook.com (2603:10b6:510:149::11)
 by SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.16; Wed, 30 Oct
 2024 20:37:28 +0000
Received: from PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::79f1:d24f:94ea:2b53]) by PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::79f1:d24f:94ea:2b53%5]) with mapi id 15.20.8114.015; Wed, 30 Oct 2024
 20:37:28 +0000
Message-ID: <78e688af-3196-4406-8cf6-0bf5f6c9c4db@oracle.com>
Date: Wed, 30 Oct 2024 20:37:21 +0000
Subject: Re: [PATCH v6 00/18] IOMMUFD Dirty Tracking
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Kevin Tian <kevin.tian@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Shameer Kolothum <shamiali2008@gmail.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
References: <20231024135109.73787-1-joao.m.martins@oracle.com>
 <CABQgh9HRq8oXgm04XhY2ajvGrg-jJO_KirXvfZxRsn9WiZi7Dg@mail.gmail.com>
 <20241030153619.GG6956@nvidia.com>
 <9a2394ca-fd8d-471b-8131-55f241e9cf26@oracle.com>
 <8401eb12c4a54826ba44e099a0ec67a9@huawei.com>
 <59d76989-3d7f-449d-8339-2edd31270b08@oracle.com>
 <63d5a152dc1143e69d062dd854d4dd7b@huawei.com>
Content-Language: en-US
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <63d5a152dc1143e69d062dd854d4dd7b@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PAZP264CA0102.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fb::6) To PH0PR10MB5893.namprd10.prod.outlook.com
 (2603:10b6:510:149::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5893:EE_|SN4PR10MB5622:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a7756cb-3a6f-45cf-846c-08dcf922ab4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Ulp2NmtvblVBLzBxMk1XTk5HYjFWSWM2UFhSVFFsMC9UcGtiZTBLeWVvWGxa?=
 =?utf-8?B?WFY3STl4U2swUDBDMzJyQlpKZnFVQm1pUHArZk5MOFRBVXYxU2NhVGl3Z29p?=
 =?utf-8?B?MlB5SGNwUWF1QmkvaFRnZjU2clVtcUVoWG9WT1YzUWY1QStNdDZNQllObTI3?=
 =?utf-8?B?WFpCeFVJZkthU2NudW5zdlRzZTI1Yjl4b0xFd3lZSlYrTkQ3M0lrL2tPWWl3?=
 =?utf-8?B?UDVpTk9hTEQ4Z0ZXL1k4dGYzaUtPYVhVaW91TjVmU3hqaVpBa1hHSDg5b2kx?=
 =?utf-8?B?c09ycGJrak9OWHkzcHNBbzJBV0dHdUZZZWtDWllrWEJKMjArQ1Z5bERSK3dZ?=
 =?utf-8?B?VS9KcVZnQ3ozYTNYTkxGVEJmalp3NWZhd1ZVOFE2WHNhb0tnTFVCY3RPclls?=
 =?utf-8?B?T1lkQkNzTDlwOEtvZkp1eHhLT3hTR2Evay9XWnhHK1JGUGpEQnpzQ3lPYzVW?=
 =?utf-8?B?K0lwTjRpZll5enFod09RZ3ZhQ2NLeGp0QVpiRFdxKzlYa0NEMFlQUm1GMFBx?=
 =?utf-8?B?TGh1RXFIQjdnNkZ4V3pQMXlHZWVmZldkODZOQVB5aVdoVGpweHJpZjFhZFU4?=
 =?utf-8?B?REV1eUxWQzdycVJ5WXNkb1Q1L2MzQXBUelh5a1JJMXBINVUvSmxXSjNKVlBL?=
 =?utf-8?B?WlQxM3RUbTBMUXpsOU1vL0cveXBMM3FkMUxQNmVhNG5nMFh2c3FYZHlBSzBt?=
 =?utf-8?B?YTYvN0MwdFU3UjB0N2dHZVV1cUVRcGlKUFJKUFJkM3RMMU9KbTBkWk85cTV1?=
 =?utf-8?B?THBJMWlPY2doSkFncFRPVGc0T20vWDdHODRuMzUxT0kvNzJNN0wxUmllSjM5?=
 =?utf-8?B?dklZeTR0NEtDdGNsbWh0Y0tpdWIxNXozNFRSb1FBK2lHWm5mb044RGU3NkRk?=
 =?utf-8?B?MDRvdVJPemluc082dE13eGYvQURtMW4wcFFGeldQdTFuSWtLOFpmSStHSmJL?=
 =?utf-8?B?RmRiRnF3elZ2MmJzZ1phdDFSb3Rxc3BTVlNZUzg5RTR1ZjZKZlVEcTFRdytz?=
 =?utf-8?B?NUtHOUdFTXE1S3RtWGFKU1ArOGJtRldXMUQ5a2s5d21wekYray8wQkIzcTNx?=
 =?utf-8?B?YytRTzNoeTNoQ0pPNEFYeW91cng1YUNkdTlZcEtWYkp5bTdjeWFFZElKQXhq?=
 =?utf-8?B?RjNUUm4zR1EvUUVnRFBaREZSTW1YYjgyMGJoc2pyakZrY3VacS9VZk1NMlpa?=
 =?utf-8?B?NVJ5eks4b0s0QUNPRTY2aHRLV3libDJ1bGYvNzM0MWptOURocTlFSUhFWXdW?=
 =?utf-8?B?YlhCblQ5ZUhDYnlWT3VKU25MZDlRUENRMURzZGlMZ1ZET0VVdFdRM21RRUcr?=
 =?utf-8?B?aWlwU09yd1R2TUNJbnRmZ2RlVjRraFNYR1h3YUplQVN3aGYwVXVHdTM5UGlL?=
 =?utf-8?B?WjU3MHdROE04OXo3QkliNnR5L0RmT25YejlqYVdsaFpDWlp4ZGFrd214bGtQ?=
 =?utf-8?B?YkRpb1lraWlkb3JlY1k5ak44bTFaaFBjTGVacElRT1crUHdXZURSOXFkcEg4?=
 =?utf-8?B?bFhpb0ljZjBDVUZQaWViUVVZcEJRM3g5Z0lLZFNBcFNWK2ZVbzQ1K25GTTV2?=
 =?utf-8?B?TmNPVWU3Vnl2QTBGVHlvRUxCZlB3d3pjNWRQNm8rQlRhblNsb2xlWDg2ODl3?=
 =?utf-8?B?cnNpT1crZmdGQW9Zdk50MnNCRnExOTh2ZFFZREFrNWdaZWw2dmIrU3c0bjkw?=
 =?utf-8?B?Uys5bTJ0R0RmaWpOYmhyUDR2S1VhNnI5MUZyTnFyYVVSTWpXUjExRWtyQlc3?=
 =?utf-8?Q?gjyvwp7btC5oUdYeZ5KaD0UatWFgmuL6tfcZAgD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5893.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KzBLbXAyYkM4Z1NSSVN3c21mWkwvTG0wYUUxajJ2Nm9PcmNUb2MxSFBUVjhJ?=
 =?utf-8?B?MmRqdG1ETVRDeDQxRU15VWZIUCtxM21JYTJZQm04cFVkaUxrdDFucDA4VVNS?=
 =?utf-8?B?bmRWb2FFeWcrRUZCSWt6Uk5tTjRxU3BSK2dsN01QRE1yZlRZQ2ZHcFFzbytE?=
 =?utf-8?B?MFpjUVg3aVFJNmt4OWxFZXFCWjVqeVhMSzg1L0lhM2JjVS96RFVETDlreHNJ?=
 =?utf-8?B?bFNaZGlGZU1qLzFxZ0ZDUEU3MUY1T3RNR3dTM0IzUHJrNkxmRnAwR2NOdDZj?=
 =?utf-8?B?emNEc2I2NEZUbmk0eXJNNlZab0pwVFlzajFxTGNTNGZTT2FsWlFKNk84US9L?=
 =?utf-8?B?REtpWFovSHp3c3A4S2pmZ2tOLzBsZUp6Ym56YTFtV2tjelZac0dJS1hndnh1?=
 =?utf-8?B?b212Ynk4Wkc3UHZkazZTOWRiMnpYRHN5NjBGYTVkTm1zUUNxMm4zYjRCY3BW?=
 =?utf-8?B?M01Mb3IrUlk3QXdYZ3lxVzF5WnlJRStmWkdMdDRUWHhIbGdGenZSTzdmdjAz?=
 =?utf-8?B?eXNDc0NybVErYWt1YUpSZWFVMFJybVg5TzRRNnpPS1czVUZXZUEyZURRYWZn?=
 =?utf-8?B?eUF5K2hXM2N3bitEZ1V2SXBueDhneWdCSjFpbTBVMHlseFRXeDBxZjhrTnBi?=
 =?utf-8?B?WGZ4aW05M3lkMW8ySHBTQ1dqUWdPNXZkMVN1Z2t6dGVvbFZud2ZrMkpObERP?=
 =?utf-8?B?UllVR3A1WEFOMG1kN1IzVUdCMU5hNHRsaytaaWhrbGhDeVhIL3M5dTAxd1J2?=
 =?utf-8?B?NmV2THBLNmRSa1FCUWswbVJlNDdPVXVhTUpjMHlEbDJrSjlXR2xjR3Y1TG1u?=
 =?utf-8?B?dEdKaExuYzlvbDFaYy9pTGpMYXhVU1ZZc2FnNDRFeGs2bHA2VDNNOWc2Skdj?=
 =?utf-8?B?YzdiMGw4MFoySDN3MDY1RkJSUHJMdnZpdWdnVHQ1SHRTM1ROV3F6aC90Zklj?=
 =?utf-8?B?ZFlNR0FObytFckt5d0VydlNJVHNFd3MxeUt2ZVVBSEVseDV6VysxYUl0aVZw?=
 =?utf-8?B?R09MMlV2WGZ4cnNlakNBdU9wbnBnVzVGVnNnMUlKcnY0ajUvakc5SUtYbEFG?=
 =?utf-8?B?d0lOM1JLZFNtUmlSY3RrcW95blA0TG8vaU1qQytRcTB2aHFIR0o2YzV5MHVC?=
 =?utf-8?B?dVhDc0pwZXVnQ0xHaVhYckJJb0xSMXlVMisvWGhXWWxNRE15LzFaZDBPMW91?=
 =?utf-8?B?ZGx4Mk83S1A2cG5OeWptcGZoNWpDcDdKT2NxTTFTQS9PMFIrdUMzZUxYbUUr?=
 =?utf-8?B?ZUtwcWFZYVdycjZhbFdsMGIyWWJrYk1maUxSQm5Hbi80R0lCN25TVy8rWjQ4?=
 =?utf-8?B?WktEcDMybmg0K1pPVzNjTGRMT2lQS1ZCLzc4QW1qejhnNFFFQXVSVDZ0V3FE?=
 =?utf-8?B?MjZmaFBKUUx6VlF6WitUWWpZcVRMV2g5UGxQQkhqSTVmYmFsMVMvSHI0R01i?=
 =?utf-8?B?YjBFU1B1d3V1ckZXNXdxaVdGMkhUUnpPRzdVQitQWlZTWHBhVDJ2aTFJOCtn?=
 =?utf-8?B?UC9nelBkajlHSFZiUVRJWkR0V1JMZE5qcmliWkhkbjh4V0hGNklMUmZxUUw1?=
 =?utf-8?B?bmp2c1dYVFlPR3Baek5Ncit3dktKZEoybDhweE1qTjlmZ3phbk9lOEtIM21i?=
 =?utf-8?B?NEdZQ3lGajY5SlhtcWpIMWwvdnI4ZEc2WTNGcVR1Z3lTYWxVZng4YUQxbnVX?=
 =?utf-8?B?dDBkWVlXQWR4TDNSUHRMMDhJOGU2RmlvR29xV0JqVlpqdWpMNmFoY3ZMR0h5?=
 =?utf-8?B?VTJmNVFtUnBERWxCeHk0M2ozdzlMT2x2N1ZLcVVZaTdWUWJyZ29URFBKWjds?=
 =?utf-8?B?cW5SVkVWMXlvUW5aS0hNVzl1YllQelVaeWtscDhPbEgvVjd0UUovMGtDYkRs?=
 =?utf-8?B?b3ZqbllkUjAra1BuS1lzZ1ZETWhCTzJCNEZJZkF5SHhncHovYi9MVmluQVUr?=
 =?utf-8?B?NUJCdm5XY3JocnJMR0xaU3BMSlUxbWZKQ1djZFp3anJ3aUpRZm56MVErV2hn?=
 =?utf-8?B?Z1lJaTl5RHExUDliUTdiLytiSmV6RU5OYmlGaTJFa3hhb1ptM3ZPcVB2T0hB?=
 =?utf-8?B?cG4ySVhsc25kZjM3ZnhWUWRhQStwNGpUQ3M0d2N4UDJMY2pyUkEzVXZjb1F3?=
 =?utf-8?B?Vlp2UUtGbWJnNWJNQVlMdldIN3pDS1BiQXVwYmdnZUcvQlJ6eDEvOEk4bHZJ?=
 =?utf-8?B?VXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	t1sx71TYo07Rt01ke4rO6VKUAay7Et0tioxoHw8DDn6nYJK/DFwdbx68ZgRhpLzyolVe/xhpQPZN9RsxwN41xNAo3/wD6znNVwbqcM5HC9jLBlOOHG82oQBmVjE4Z0LlXWRbDwUHUkUOZMIMjmrdpqlnp6gfxdQEr+ZmIuGKDZY/iZMafQry/AIsDCM0mq7WLcOYXdU/tdJPUBrVurWSzd8Yw3UzV6ShQnp/BCQ8J7oo5W/Lc//QWio+eT2XR8CvsbedehpCD6vMqdsfIqAPsYskAp1k3NlD2LQrI+H3CFIUYK1bvdKVl29G9aW2lCLnCg1T97xaX5xYFVBeXZ05azYUjROQrBk+xbvNPKUI8OrhhNv+pkPL/JGQr+5CIfPJr58Si0k+lPcHu3evw7qU5C/eUpvTcK9OUcSN1qJgionVvggccosKu9gWyJs5KUaSIN5uRPwAnl2oXPI+2ewtaiqYHcYcbtOnYkJxkJexAzsJQv1DIU4/5iypmgXekmgulxjuPHggUvILBClJc+xzPphWlkHc3p/TEXTe8OMmn9w/n//bpJmQyp3XoABBTrrTVHTXws4ge7mbBCAQmKqlaAJoC5wryIauReUgFDxEzXo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a7756cb-3a6f-45cf-846c-08dcf922ab4f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5893.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2024 20:37:28.1102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E2sUBXP+Uzza+jaYN/fg7nlqBVMww4sDfC//dhGbwuAelldOz3RVOvfMLKDPqy1XGvQbK9SD+JJZcTQwFjysbm3c6EOpu1SzIRT8PH3r2Uc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5622
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-30_14,2024-10-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410300162
X-Proofpoint-GUID: AhZguGK-InB_wKV0IIx_9s0gt1XrmF6X
X-Proofpoint-ORIG-GUID: AhZguGK-InB_wKV0IIx_9s0gt1XrmF6X

On 30/10/2024 18:41, Shameerali Kolothum Thodi wrote:
>> -----Original Message-----
>> From: Joao Martins <joao.m.martins@oracle.com>
>> Sent: Wednesday, October 30, 2024 4:57 PM
>> To: Shameerali Kolothum Thodi
>> <shameerali.kolothum.thodi@huawei.com>; Jason Gunthorpe
>> <jgg@nvidia.com>; Zhangfei Gao <zhangfei.gao@linaro.org>
>> Cc: iommu@lists.linux.dev; Kevin Tian <kevin.tian@intel.com>; Lu Baolu
>> <baolu.lu@linux.intel.com>; Yi Liu <yi.l.liu@intel.com>; Yi Y Sun
>> <yi.y.sun@intel.com>; Nicolin Chen <nicolinc@nvidia.com>; Joerg Roedel
>> <joro@8bytes.org>; Suravee Suthikulpanit
>> <suravee.suthikulpanit@amd.com>; Will Deacon <will@kernel.org>; Robin
>> Murphy <robin.murphy@arm.com>; Zhenzhong Duan
>> <zhenzhong.duan@intel.com>; Alex Williamson
>> <alex.williamson@redhat.com>; kvm@vger.kernel.org; Shameer Kolothum
>> <shamiali2008@gmail.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
>> Subject: Re: [PATCH v6 00/18] IOMMUFD Dirty Tracking
>> On 30/10/2024 15:57, Shameerali Kolothum Thodi wrote:
>>>> On 30/10/2024 15:36, Jason Gunthorpe wrote:
>>>>> On Wed, Oct 30, 2024 at 11:15:02PM +0800, Zhangfei Gao wrote:
>>>> but unexpected set backs unrelated to work delay some of my plans for
>>>> qemu 9.2.
>>>> I expect to resume in few weeks. I can point you to a branch while I don't
>>>> submit (provided soft-freeze is coming)
>>>
>>> Also, I think we need a mechanism for page fault handling in case Guest
>> handles
>>> the stage 1 plus dirty tracking for stage 1 as well.
>>>
>>
>> I have emulation for x86 iommus to dirty tracking, but that is unrelated to
>> L0
>> live migration -- It's more for testing in the lack of recent hardware. Even
>> emulated page fault handling doesn't affect this unless you have to re-
>> map/map
>> new IOVA, which would also be covered in this series I think.
>>
>> Unless you are talking about physical IOPF that qemu may terminate,
>> though we
>> don't have such support in Qemu atm.
> 
> Yeah I was referring to ARM SMMUv3 cases, where we need nested-smmuv3
> support for vfio-pci assignment. Another usecase we have is support SVA in
> Guest,  with hardware capable  of physical IOPF.
> 
> I will take a look at your series above and will see what else is required> to
support ARM. Please CC if you plan to respin or have a latest branch.
> Thanks for your efforts.

Right, the series about works for emulated intel-iommu and I had some patches
for virtio-iommu (which got simpler thanks to Eric's work on aw-bits). amd-iommu
is easily added too (but it needs to work with guest non-passthrough mode first
before we get there). The only thing you need to do in iommu emulation side is
to expose IOMMU_ATTR_MAX_IOVA[0], and it should be all. For guests hw-nesting /
iopf I don't think I see it affected considering the GPA space remains the same
and we still have a parent pagetable to get the stage 2 A/D bits (like non
nested case).

[0]
https://lore.kernel.org/qemu-devel/20230622214845.3980-11-joao.m.martins@oracle.com/

	Joao

