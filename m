Return-Path: <kvm+bounces-59576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B9C2BC1CBB
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 16:47:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8E85B4F6F00
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 14:47:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F2902E1F14;
	Tue,  7 Oct 2025 14:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I/D8j+tj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ocLkwm8R"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDF534BA33;
	Tue,  7 Oct 2025 14:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759848429; cv=fail; b=KWs54J7F5srn8cYHshRpHGE3Nj4R1T/jwvpHMgYQzHHbqmhVLWB+n/PN5pb9ivH5MypFRfnPZtCn7eSTjgZWVePGuJs8eoHTQ4Hlk4XKDH2yGDtNC6uQn9lnS9ssDpLRMOo8OIE4pkesz/wTkvNyV7Hg5o8M5gN6tF1sJwvAAa0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759848429; c=relaxed/simple;
	bh=8Kg8qeYmqLJ6oWZy0YqZuanMTpJDxFBBcYrdl/FRj1A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=o4OEGT9EIi7FBblCiXENJ5SlrgjIKMgqOFuRjYkUcO7NqqCgg4FyXvuBqfVhnh3v9ZRHAss/Fd4nOiOS5DERxqJFkcyYri7ZKq9ObDNef9AnfgVzOLxtk7GtwzUGxyT+TE61OdikHJ7fDqXr+K3CeNeGhRzvTheIntjceRtcGmU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=I/D8j+tj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ocLkwm8R; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 597ECFoF001705;
	Tue, 7 Oct 2025 14:47:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=iUzVcy4LabHo6Rij8oRa7EfmP/xbFmj5LyXh0IUVH6M=; b=
	I/D8j+tjt9+MmzP21jc8So8vrowve7BQIVExtJMaO0Ef7SIIIAzw/lRaoVBGjvwS
	ptP1n/hC1qASUb/+5qYGrM5Q6m0b4GbklJ/yDraWva4GZLRKy39whtZ3EEkwq6lU
	H2ZWQoNhwwHHvoTesNWSTvdLoQP/+9gIBvRgn28Nv1Bl5dM671eD2OliNVqklYWQ
	zKZiWOSPp6f3K3zCBGIuIeMv8WRvkqHGMyfdAcxrx7J1GbSacXUmIkyNblj9Mtky
	MazqwZfvNwGtA/X5vdzsURDtciRXUVF5Qt51XJVdFy3BosDiB0HEYkbawJBgzfyS
	D820EU7I9eQRo5w7dG8lCw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49n47u84fw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 14:47:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 597E7ub9035137;
	Tue, 7 Oct 2025 14:47:03 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010016.outbound.protection.outlook.com [52.101.193.16])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49kdp4y603-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 14:47:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tTnSH44RCPADuSk1kV7hC26u7Zw/uhU+wLrsbLLFhTr8Q9KGlTYiwzsqFqnD3vGFroh6xoy2hJABL26qBWw3PD0zW3TrClm5Tmb7oe0f82lQfOUh8Ki09G39xg8ca1KctzQfpEnL+vsihZpYR/wwSYKCjSIAISUtDNqH/rw9WBg34YFTw6joFblXznVazS41HlhqmyG25sYbo/Tc0XoVtOfistqvOGJFiXQMxGwiXwwRuREnLGueNO0sNuJ5Fe0wOCkzHO3npJqge9e6NbOcak1W9OXTRZ9dJtHOznDI2NouLbi/+13PhJZkeXgA5IPvEPm4pA2trR285xMtcdnLcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iUzVcy4LabHo6Rij8oRa7EfmP/xbFmj5LyXh0IUVH6M=;
 b=HBja7cVhLsBef1Ns522TzJsO5MZl2Z07FpJjoJVDRzfC8agR+oPynK0i90yQyYqLyfpZhtc9sj4peQO/IDvIr97iThSHO/BYYK0LT77izI3ZYDCfhQiftDpx2lzGW9U+pWMfFbNtswgdC5jGF+jPn9YFyKVrWK20VrhaBb+YdjXcj7fKP+Hjt22MnxnlixOuD0/xn6ZAiZ/2g7J2ro9CgxFM9PG5QLABNj1z6GxINaB2dakgARJl99ik3wwfKyATarUJeRWstsRLPxQeAqyfLhKJgS/iKRHZ/DARiGPTGRcutYNJXAeL+u67OWp/Y70bNyyuIK/9NCeSZVkUdeNkvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iUzVcy4LabHo6Rij8oRa7EfmP/xbFmj5LyXh0IUVH6M=;
 b=ocLkwm8Rm0PktWazTxVyKfR9Edx2onBygEb2fPRZv0COYd0khu7azSaSYk+u1YRQkeE6VwjGNlE4ZhRwxV3bJw7uCBAR5JnmU9A2kyIOf/iHm5H4zM0pXYsv6utQtJ9K6uel5dnk82GjPTYqMdfJm5AFuIFHSqE1pItH0YzR4JI=
Received: from BLAPR10MB5041.namprd10.prod.outlook.com (2603:10b6:208:30e::6)
 by CO1PR10MB4420.namprd10.prod.outlook.com (2603:10b6:303:97::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 14:46:56 +0000
Received: from BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4]) by BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4%4]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 14:46:55 +0000
Message-ID: <96398096-ef62-4873-bf60-5b54026c5760@oracle.com>
Date: Tue, 7 Oct 2025 10:46:52 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio: fix VFIO_IOMMU_UNMAP_DMA when end of range would
 overflow u64
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Alex Mastro <amastro@fb.com>,
        Alex Williamson
 <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20251005-fix-unmap-v1-1-6687732ed44e@fb.com>
 <20251006121618.GA3365647@ziepe.ca>
 <aOPuU0O6PlOjd/Xs@devgpu015.cco6.facebook.com>
 <20251006225039.GA3441843@ziepe.ca>
 <aORhMMOU5p3j69ld@devgpu015.cco6.facebook.com>
 <68e18f2c-79ad-45ec-99b9-99ff68ba5438@oracle.com>
 <20251007114808.GB3441843@ziepe.ca>
Content-Language: en-US
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <20251007114808.GB3441843@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0031.namprd07.prod.outlook.com
 (2603:10b6:510:e::6) To BLAPR10MB5041.namprd10.prod.outlook.com
 (2603:10b6:208:30e::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5041:EE_|CO1PR10MB4420:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a0ce1e8-f45c-4de9-392c-08de05b05c64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RXFaOHVWdTVrMlJONnBSVjV4ZWJDdHRLUmViSWNNR0gvbk1tTmNvWFQ4N0tC?=
 =?utf-8?B?c3REZ3hMREZqL1krMnduaGxVOWZyblhKaVNpdGlyelZvdi9VU3E3YXJ4MzY0?=
 =?utf-8?B?S210WTJMeFRjR2htamk2dmQ2SFFqTDJrYmRQaFF2cXA5cTBORnkrM0paNWNH?=
 =?utf-8?B?c2JzbzdGY2MxQlAwQ3krV3pzRjNYUUFwTUcwM1RRa2luVUdpcUNOTVhWb0wv?=
 =?utf-8?B?VEt4bGRkU3A3bWc0QzhhSCtuckJ2QVRPcjBhcGFiNmFjaEdyTjc1VFVRd21u?=
 =?utf-8?B?amhpOTUzNit4OCsrdTBxZ2t6VVpWeWpySWtuZXl1cjFuaHNLd2lHRnpEMDNi?=
 =?utf-8?B?YnpraG8zaWJabmlRdFFpS2tvNjRuU3JuZ2Y4dXB2SWNmUXZ6bElZOUc2Uk53?=
 =?utf-8?B?T2tFTzllMUtTQ1VxcUN5NVAvUU9hN0kxWTduWTJvWHFWUjhrRWMyaDliSUlM?=
 =?utf-8?B?Y1p3Tjk2ZEVsdWVTdUVjaFgwVHNuZXRrS1dZSTVpNXdiOXNoQUtScGRGTEd6?=
 =?utf-8?B?UmNrZXBlTWw1N0g3N1pPUzBGSGFPY00xcVFQMG1KdWxZY2ZWckMzNFV3QStz?=
 =?utf-8?B?cGpmTU1XSlE4Qm5tOHdVYWtmanV0NWtsZFhoQlNJVVNZNkNmZ0FtK2Frb1pR?=
 =?utf-8?B?REcrOW93YkJxVk9sNWdlbk9kNk9DQjBoMmlkb1B4cy9pSms0UFFwWWpZWkVT?=
 =?utf-8?B?MSszcWhTOWdLNElyUENZUUs2ZFBQaWdZUVhQM3N4M1B6T0FFWXh0NW1sSEhu?=
 =?utf-8?B?MHlURFZ1bGdOeHFxczZYd05nbHo5NTNRM1RkYkltem1ISFgxMDJqRnVyalZF?=
 =?utf-8?B?WmE3YmRQZWYySVNzS3pvQTlCVXkyY3U3alAvNHhPSjJBYnE5T3JoYit0cjZs?=
 =?utf-8?B?eE1mcGhwUVdxaTU3REJqUExtbGx6cXM3MDlZNFZNdStCbVk3c1pFVGlseVZB?=
 =?utf-8?B?T0txSVpWVm5mQUI3RTFwVk1obzZtbWcwTlp6RkhURUVpRU9RMFhTZUxiamcx?=
 =?utf-8?B?ZlIrZnBjSDJYV3lnVkI3aU56Y1BOTlZScG1GbXZrZmlpUk42cFVTUmlnVHUx?=
 =?utf-8?B?bXVTWTdUZ1ltTUxteFM4SEZZS3c2ZjJQbC9PU2t2TWs5RFZyV2ZvamxjTGlk?=
 =?utf-8?B?VTRJS0x5bEhtYWNuVTRnTVpXcUF3Si82QmpKZ0hKWUJMeFZDZnNWOHdzZ0pV?=
 =?utf-8?B?b0xBdytCRk5lUHN0cDdzOGtVTDVWdmd4blNiU0RSdmlLeFhyZGd0bjREREFn?=
 =?utf-8?B?eXdIc3d3K2xhTXYxeHdqNmt1TlhhRjNpRGtUY1JaTnhySG11L0RReklsK1J0?=
 =?utf-8?B?Q0xxM0k0UWFNZkdiMVdPMzMzU2h6Mi83NG1WT0JqbzhxcGJMWDQrTnYwekZt?=
 =?utf-8?B?YWRRL1F0eXh0amY4Q1BKVmhBeW8yRHdZYllPNDdmcVJHZnFpVHdLbWdHVElr?=
 =?utf-8?B?QTRtVUNHMjBoVXhxMTFlVlB4OStidjVuMkRpaEZWYXJBQ3AxQ0tHRzdhblFy?=
 =?utf-8?B?R2MxUlllTExnQ3kwTnJTc1JHZHBuM2t1M2hPTkdKaXp3ODBrWXZ0bzdPMUk4?=
 =?utf-8?B?VnByUzNud0xoL08wdytRR2dJUFlmU1BFYkdIQlhWWGhRLzZVWG9pSTE4N0Fv?=
 =?utf-8?B?OXVuVEtCalJzRnV1SGhUblE4SU1kT1V1SnpkejYvU0JvakUwdTczeW9BZnBO?=
 =?utf-8?B?ZGlFanQ0bnNGR3o1WjJSVjBpK2g4QVJGV3AxMzQxbVRsYTExU0lyelptUHhi?=
 =?utf-8?B?dU9EL0FyU3hBdmo1Z0ZZaGM2TGRSVzhodHdiMDF4dytZcmI5UHo4emVlYTlJ?=
 =?utf-8?B?VjhoYTZTN2pBOEtOVTVnckhRZ2R2TmhwYkEyRmMwZ1Z2ME9qL2FROFdoYStz?=
 =?utf-8?B?dUlORm5NSDRXSzV2dzN2b2ZaaVV0ZkJZM3l3ajhOaWhWVUpWS2NXN2Z6TlZa?=
 =?utf-8?B?OTVjeWpCSFhIRm9BZ2tabXZONmlENElsZ0wzbVo4N083YzhpZnJCL3E0NFBX?=
 =?utf-8?B?a2hka0FqZ2JBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5041.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V2hqek5Mcno2US9Dek16Z1htZUJRcWRFVDJkc2NBK3VHdjdVb3J1UkNLbCtG?=
 =?utf-8?B?MExjbkpZaXBhcEZoN295UW45aDBPbUtXNUtuZzU3S1NHQVkzMC82R0ZrTlZO?=
 =?utf-8?B?bGplNkNTbDYxSTJRdXdxMmtlbTVzRk0vV21PSzgrdVdIbWdIam1uSDRZNnZK?=
 =?utf-8?B?NkdGUFBFQmVOcE9GYjFLSEU3VFhvNmdwblFOejhXMi9tWXF6dVpBSFFCdlpl?=
 =?utf-8?B?ZGY1a2dGMlZ1dGVFVHdVd3N3eDJPQ2NDVnJNb1RnTThabFo5NkY3NWFGVy9R?=
 =?utf-8?B?TDNYVEx0c21iSTM3Y1pXWnZuakhqbE11QzZoYmpJemM2QWdCZkJ2NVZCaStN?=
 =?utf-8?B?Zmo3UEF1YTVNRzJhQm51c1pwaHczNlNMZHByQ0hMRUN0Y3NFc0JZMDN3VDJv?=
 =?utf-8?B?a2FrSzJEbTZ3dUhaL1NYckkrUE9qbCtadDlvdk1QangvTGpzV1JJUTk5aW14?=
 =?utf-8?B?Y09yMC8rbi9Jei9HV0J5b1VHUFpCS0h3L3g3MDNPU29UeEFoMjZsOUxZaWVl?=
 =?utf-8?B?RFBaRzlBSnZ3VnJqS0lCWHo0REhmK2FSZFBPVVhMbzhXWVgxSExTWXR3Y2p6?=
 =?utf-8?B?b0svdFc0Sk5qRUduVGVoaUcvTEZDeFpUR2hGUDJuYWlMUU85a0pBTmM5Rjdm?=
 =?utf-8?B?S2lldm9IeGVGc2QzSTM3Sk5seHdzVXpBY01TSzhGd0VYaUVtcmNqTHZSZTJB?=
 =?utf-8?B?SCtpTXRycmE3Y1kvR09KTWdpaDlRc2F3N1o4aGVWa3J1WkpXNU9QR0lqRkVR?=
 =?utf-8?B?R2p0LzZ1TDJjM21uNitzcmE5VFYxZURWYmk4dzl6NnRSWmwrckZLWkU2U3lJ?=
 =?utf-8?B?bktKSTNIN3F3R3RTQ0NXZWNraUR4RFZoU2ZxUnQ1ZUZ3Vkc4M0E1cmt0Ym9m?=
 =?utf-8?B?dG9UYmhxZS9la1A4RkpOS0k2OU1GQ3R0Tkt0TzhvT2g5Rk1rak5Ib3RFNlVp?=
 =?utf-8?B?U0VrMHhxb2p2SmlsbXZZN2JLVXh1aGEyUGZWY1FDZnJkS0Z0SCtmKzBDdEhP?=
 =?utf-8?B?NGtwNllwc2pvSXF5MEFCaHpZTVNFRkpMbU9Pd0FiUElCSjBDL3Z4ZmpLWXMv?=
 =?utf-8?B?aDR1UCtHUCtPR2g1a1JuVWw0N1grYVIra1dKR0xzS3dTZTlJTUNRZ0dxeldP?=
 =?utf-8?B?ZHVFc1FZR2t5Rm5jRkNhRXdhbHNXcGRJYXg3TVliSmtsbmZRSHJtRDFGMUxF?=
 =?utf-8?B?TVZNOE5JTWw1VWdQWnhWVU1xRFdRZGNZbEZQbEYvNngycklmTWg5cE8wRCtX?=
 =?utf-8?B?M0lIbjdSZTl1c1pHVTdOejV6bnVQbFFWdEtWLzF3YTRjRTNNRFlialR2NFl0?=
 =?utf-8?B?UDdxWlR2V0Y3RXNaUHk3Z0JDNlBjMWlXNzN0YW04MytGSEZ4b3pDTm1pZzlo?=
 =?utf-8?B?YVVXemtSU1JKU0YwZ1dBMWlqc0hlcHNrUytrNzUxYi9TTnV3NVZpZmpOdkRC?=
 =?utf-8?B?NUpvN21pdnYvZ2xHTlF0VDh5RXBTT3dCQkNjeWhTbHNHZjkyNHpUMG5SOVF1?=
 =?utf-8?B?QUZuVHg1d3pNZm43RFJjWWd1dk1qU2VabGdNOXpVdzhUeUtJMXI4aTZCVEpR?=
 =?utf-8?B?NGkwTXhYZDZSYTRIK0tHVU9IRjBVdWNhUmdXa2VYaHhxdHUwSW1Id0lsWFhB?=
 =?utf-8?B?d2RvT1Z2UVJYWFNpTXM1RmZRTkhGTFhXUHpkTFNTSkdZRU01WWZ2c0xnN1ps?=
 =?utf-8?B?VEJpeUl2WTdyQ3owam1nZjZwOHZtZyt6TEhIc0xiRWJrd3dYRVpJdTVNSlRV?=
 =?utf-8?B?VUFsYXJZUjZlcERqeHptclYrYXNxY1lOMHdaa0hCSldtSGhsbGFVTVlRbDJ4?=
 =?utf-8?B?cXBWbkVGTURRbzdqdXQ3TXRQVkpvejJGeEI0OTYrL1hNaWp4VUZBNHlVeFlu?=
 =?utf-8?B?S2RUT3p3MmRsQnlpL1BTUlJKcmw1TXk4QzdFWUUwZkw0V29UV0FNSEtpeDRv?=
 =?utf-8?B?eUkrMmVlekE5M1dyY1FmV1RoOWhIbmllSUJhM3N6UG1xckRieWdHK28wTWRa?=
 =?utf-8?B?OGFmUWZwclhKZHdQVFE2VVBoMlUvanNxWEVjNXdoNy9jMERZODk5RVlacnB0?=
 =?utf-8?B?YWlZbWZKQnRTaVNnbW1KYkVjUzcyZEJVK0ZkT2I3VEhLQlROR2Zib2ZnZjF6?=
 =?utf-8?B?djRoeEZxbFNzYlpkNFNMdHdVMnFYdk5sMS9QUG84NXFmNzZLUjB0UFYyZkFy?=
 =?utf-8?Q?9lPms7md27zW4RTw8uvMpNo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JhHGVlWf0VSuzOrtd1Q1heWbekCe2z1b5VhAvdYbS7f20lqMuatlYQgzbAhysw5XUZ5MMjR0n3fNlM80JPd1Z9dfqnEk2cuCZ7a5l7u+do4FunDagUof7zP9kB/C9M5WLTjnfAZMHk8B13twsIiMAbB4sxOiETUhJr30gvLPxJRA+PX+3YfMz+lQX84UD8KTc+YS3lqMVW8Y3ef8ZYkXH4Y6SIMGJmnKtIb18sq4EGdPIQWjcJBqkOBeRblOpKMvd1ezKBREjplDo45ykkeBQRR56T+3CLFEjNQ+3ore5FapYppeSS3NL9wV1iuz3proiurY/nRU7nBU1nR/WXrdc3XnDN1S+UMvs/xD+N4t/O+Oi042v4GtW8eKaYHBCqyLMwDuodhwq06kL3raWZB+jrJmHYPSZHaw44571T1qnbW3ADeF1Fo4o4nT34KJ6+iCUz4iX+JnfsYDDhuy2hkD3os2sEt2tmgdlv7Aqqv3et0JxATh5a0r6+aiRtZNrB+SGZEgDl/GjTJTT5RkTcTFhUXmiaKIAULH0mJuiqvU7AcjJIPm3emT+FfL8rYSj/RJK6n2HOHi2/TCTy7VhD1d0tDV/QT3T1byyp4PNkcyIA8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a0ce1e8-f45c-4de9-392c-08de05b05c64
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5041.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 14:46:55.7560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bu0f0qqMOIf/xSM+3GxRr17dp671Nr/kuy6LkfqIRctSuwNVeIg8nFM3t8ki+m1c6mzsaKTyWkHnlGLJxzMFBbWi09jp7tnnWvyahE5LQms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4420
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-07_01,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2510070117
X-Proofpoint-ORIG-GUID: wOJO3s9KO7mTn45vuBoHPw0AhykfMdaP
X-Proofpoint-GUID: wOJO3s9KO7mTn45vuBoHPw0AhykfMdaP
X-Authority-Analysis: v=2.4 cv=Qr5THFyd c=1 sm=1 tr=0 ts=68e527e8 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=hD8lW_uMcabd4xOpsLEA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12092
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA3MDExMSBTYWx0ZWRfXyEpP9Ye3YhtL
 NvhdaFRk3UfLszQNPRJCSSMX7doK3fZKn8vjoBp4jiHXD5qVc5SMGQ90/q7ImhixbBhOlp8Y4oh
 ex4aG92wO1mun7RgpgYkcg1aSpqfuQ4pqvK36X169ZAACKSok6z+xEroxwPF3snhtCpCZj5YLGj
 6oMpA9TOAL0TThncpI573r0tTqQPi/XFF4Ctjpkv212UCHAkYB9YmZ0zIA5s48TGFr9QVWSLMLy
 muwpg8yQfCZeGgi9xqgx6BHfZZi4i+vpWrwg4SQrCYXvxORb9RHRRzpfa/u5F7bMXja980b3mtG
 2Dml89g+OHX8arDjjBeaqFDHA7dQ7KiYVqu8J1U7zW+sSgdu26hCJNxSIYKgoXvRBgj1nLGEPf5
 DttLMjPGf3bejBu4S9/0L0VC+gHBOu7pNyRM/RNpwHNE7X3Rai0=



On 10/7/25 7:48 AM, Jason Gunthorpe wrote:
> On Mon, Oct 06, 2025 at 09:23:56PM -0400, Alejandro Jimenez wrote:
> 
>> I mentioned this issue on the cover letter for:
>> https://lore.kernel.org/qemu-devel/20250919213515.917111-1-alejandro.j.jimenez@oracle.com/
> 
> Use iommufd for this kind of work?
> 

ACK, need to test with iommufd as well.

>> I mentioned in the notes for the patch above why I chose a slightly more
>> complex method than the '- 1' approach, since there is a chance that
>> iova+size could also go beyond the end of the address space and actually
>> wrap around.
> 
> At the uapi boundary it should check that size != 0 and
> !check_add_overflow(iova+size). It is much easier to understand if the
> input from userspace is validated immediately at userspace.
> 
> Then the rest of the code safely computes the last with 'iova+size-1'
> and does range logic based on last not end.
> 

Makes sense, just thought adding overflow detection/resiliency in the 
rest of the code is not that complex and provides an additional safety.

Thank you,
Alejandro

> Jason


