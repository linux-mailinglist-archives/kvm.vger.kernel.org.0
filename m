Return-Path: <kvm+bounces-42082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 96CFEA726FC
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 00:22:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21819173D4B
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 23:22:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC6461CEAA3;
	Wed, 26 Mar 2025 23:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VX++voy/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ADkKUWC3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291AD1AF0C7;
	Wed, 26 Mar 2025 23:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743031327; cv=fail; b=RgASFW99cG+jmMaCQsiJdFzGkLUKM1+KXAYum2pc8LeomnBjQUO6Qx4OxlXV79ofO3sBNTX3yAlTw0DkiLI5Z2ttr9Qwll6txgtJUfJmu77Wm356AAPiYrobsIz9X5zheKgWSolZVcapJBQUFjv0FZFhW/t31QQLfindQM0d6mg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743031327; c=relaxed/simple;
	bh=jQ30X0Xx/VqqhO/RFiTvTPjcDMZu67n9qbvT4or5Bs0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HcW09NKKjghAHw8whDks1VmS9HUBXUTF2zB6opo4ba3RtEjxaoB7o9d87NyTdWl0gQMmhk+novSpUDXvuBhlARvO1kH6Rdr3m+u1kAS8AGBLrV4t1Yw/0dPuswRkjYGWdShFB68Bz02CeuU7bmTxwdlv/kvzhBzUjNFLElCyJJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VX++voy/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ADkKUWC3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52QK0YOS005081;
	Wed, 26 Mar 2025 23:22:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=dHhsz0CRX+zwKd6xheTA2pkqDphiBrJsPDnPdH4uhiU=; b=
	VX++voy/5qZlyI2hX5C24JBop9ZTSR8LHYhp++bwMnIl/7uyIpXjWTkAOfWxl9mJ
	srIRi3YUd6tPkIU51BHjLtSiEgmOmA6NBc0noB7mDy0lYFjbbMkJaSfLYdwgoHtQ
	qKbyelerOdvc2l7avaZXsO1nmkTHBqSkFEuar3Q9Nv+lnuz8Vc+aINTpFBMyEZma
	/+oP13Nx/NSNqDfVbiXl3hfSfncoWkVGVHSKFE/sc72669vVCgx4iu19vj6ekV0a
	kOLzHy/r5yivfBtFuYK5dyjjUvdq1Jn6PPtq2Z2td84cdsJ9RIgwS+YCQpVmrknM
	ghHx4Uc2/BDBgLON2L9qXQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45hnrsk06p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Mar 2025 23:22:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52QLQFLf023195;
	Wed, 26 Mar 2025 23:21:59 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45jjcfvpxx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Mar 2025 23:21:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l5hVlBCeaoVIhnKTagKOf2YIEIVMUSZGWshddPA+W9nwSBwSOTeYxd5Y0MaqMM82nTT5grlXG2sAIR3bJbD1Xd/pI6KhrW1xXgRtGIl+h85t/+9cvrQBCvt6zrekeG+VTGu0qek+Kfeqegqs4jwiRapAkHyZSi6zPuI0vBUaMLJ/NCDBRkjeu4Ged1/Fn1LwYXUD5YeFFEb8QGQlH5CggoOsrt6hcb7Vo3KdRrKe71sa2iM0ilp6YU4VmIYCTjB0PUgcrPYHYkKCP5zDWKN5w7Zal/EiuAUORSLG11M8HYa0vlm8ACqvKqg7xGN0kFraMOFZc1R8+Y1zQs1Fv31Ipw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dHhsz0CRX+zwKd6xheTA2pkqDphiBrJsPDnPdH4uhiU=;
 b=nhidfHTlQ8Rzsj7kSgNOFyjumA/8R+WCPe8PBbcYVrQSmxlIVy0UmvkHVpGt5KjcTFMo+kUDlJFxTVpL3tsKyPKVDqNOKVTo03tMGIY/Cttd9Fi2sFeoSOZL43LAnD20qJeWkR7qVUKX37IpdSjCPFj8i4dP/wfgZF++JMDZ6q4jfFFJLHqkfe8vmqBKvDaIHKSx6K4UDvrJtwMk/3+eXfosyFoeqWgFkKnPJnEju7eJCABN8N83OEZ0N813hLxBj7GygNj7KURkWDFcbZtfxxdxJuVIOhHXLlDVX8vUdm1k5LXdHZZrS/4CJ8QYpU8mf6t/w2Q5xC3Q/8/k0OAWFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHhsz0CRX+zwKd6xheTA2pkqDphiBrJsPDnPdH4uhiU=;
 b=ADkKUWC3IgkoDKFXonQZtP7WNlZbpMq42OeoF48wNBdVwS5pO2vxF2TBCn0216iYUIDEXp+IndwSSFoR2OaoHu2yiLtWVw4/G9p/NYjWyMR9W2Cd+dwEGIFD1lZBg13HunUedxqlkRr3hPfqzyhVE+AL4+6l8XSKvWQeG8j8Cnk=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by MW5PR10MB5665.namprd10.prod.outlook.com (2603:10b6:303:19a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Wed, 26 Mar
 2025 23:21:57 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8534.043; Wed, 26 Mar 2025
 23:21:57 +0000
Message-ID: <ece8151d-32dc-4154-876a-6699a63cc432@oracle.com>
Date: Wed, 26 Mar 2025 18:21:55 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/10] vhost-scsi: adjust vhost_scsi_get_desc() to log
 vring descriptors
To: Dongli Zhang <dongli.zhang@oracle.com>, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com, joao.m.martins@oracle.com,
        joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
References: <20250317235546.4546-1-dongli.zhang@oracle.com>
 <20250317235546.4546-6-dongli.zhang@oracle.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20250317235546.4546-6-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR06CA0080.namprd06.prod.outlook.com
 (2603:10b6:5:336::13) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|MW5PR10MB5665:EE_
X-MS-Office365-Filtering-Correlation-Id: f74443f5-10ee-496e-aa65-08dd6cbd008e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?akY5cHc4NUQ3VFNncVgwcUVQRTBtMm82V3NhcGo1aHJIVkFNWmFjRHZobkRD?=
 =?utf-8?B?ZUlVaFdmN2VmdzQ1dVpVekJlSm42enFNRkZENk9PcENVYzZNbjJCQXhTdjZR?=
 =?utf-8?B?OXVGaXdWSDZOczhZZlVIVFN1SjBNdUtnZ2N1RTA2Vzh4YldCdWRaa0YzTys3?=
 =?utf-8?B?dXJHQ056L2RQQnk3dXYzUkJPejR2WDl6amhnT1E4SmhnRkdWbEFwQTh2aUFE?=
 =?utf-8?B?TXk3RFVjNFZhVXczZWswbXZrK3FnREpMTUUra09Dd2lmRHhUNzlRY0MrWVJK?=
 =?utf-8?B?WHNKcVJXeXpKRmFZQlp2UjJkamZWZHBsSkR0TGJHRFpzNXJ6Z21lVU90RVdG?=
 =?utf-8?B?YVlKMjk3ajhVOGRtMmhJTUgvM3dUUkh5T2tFNzhSa1BKQlhvQzI3ZjZieU5p?=
 =?utf-8?B?ellUSEx4ZU9zajhPNUQrcmI5YzJRcHFVNlBBL2dybVZHUjJHWHlrSUVXTUZT?=
 =?utf-8?B?RUhtempXNWtOVXp5eUwwMTU5SjVua1V5UXErZGc0VEp3QndmSDY2UFlXejQv?=
 =?utf-8?B?b2F5UW4zdmdySzJPRzNQNWYyaWZrazk4VkIyelZRN3ZsMm1kK0RnSHFDWGNj?=
 =?utf-8?B?ZEVEc0VSVjA4aHZVbGNYK1RkNTQxbXovNmhRMEdPc3lFT1F6YmdDcFV0QWZD?=
 =?utf-8?B?VmI1UmRjUUR5Ni9UTkoxY3A1V3N0L3MwTkpTZ2tJbzZtanEwNm50V3lEV3dq?=
 =?utf-8?B?TDZTdk40ejRHdHdqMGJnQUhZaVFuUVR4cGFCbm5PNDQreHFZSmtSSmZOdzNz?=
 =?utf-8?B?OGhETEZHalBYWGo3aTFzZGRvajY0SkQ3SmVid2hLRUlFTTJRcXlBZG9OQ1dm?=
 =?utf-8?B?d05FZDFQb25Fb0EwV0cycS9xS2ZHd1JRR1k3QTVQNEl1Q2c3ZHJ4a205VXFC?=
 =?utf-8?B?ZzZHOHQxZVlQMDQ2UDJqU2laQVlrN0dMM0dENHpWRTNmdG1WUmRPYzhBbTRi?=
 =?utf-8?B?cHozdm9RaVNmY0xoaWc3ZEFzb20rNWNxYU1Jb0dTUDFzUGNISHQ4dWlZMk1I?=
 =?utf-8?B?WENCMUtmdm1OV1NTS3M1cnNSRTQzdFJTVXdBOHU5YjJiQi8yZ2p1eU1yRy9o?=
 =?utf-8?B?Y0xMYXRleTdtYjFDQ0JFZkFjTUxJZjJtT2dDYU9BMU5NVlRTT0NNUzVUeDI2?=
 =?utf-8?B?TG5tSFRBSHd2eVd3RmJDRXdNOVhBRmtHbDVnbEQ2eUI3UU5WV3JlNzljNDl1?=
 =?utf-8?B?enNIM3hBU0doS3ArN1kyaE9LZTFvN2JGdGxVWmpXTGt3SzZNQlFxbGdhS05z?=
 =?utf-8?B?UFZScmN3ZDJzTTBQbTc1dnh5T0x4S0JDQlN0MjRCS2c1UjF2NS9KdGlvUVgr?=
 =?utf-8?B?RzZMS3JYenAyejUyQmFUcnFCVmRydUxFSlVhaCtQSVdjdDhESExJdWJtZy9W?=
 =?utf-8?B?OVd0Ny9iaFRmbVdocnVDeldXVHNsMHRFK3VNSjdNT0prMWp5L1dtYXptSVc5?=
 =?utf-8?B?U2I3V1dKVU0wVjArVGxKQk1XeW4wRnVDcUNLOEJONXB0TmFiS0pZeHVodTVO?=
 =?utf-8?B?ajVvK0xBYUtza0RndTZjOTF3bDRRZ3hHdzRyVXRtZVdKMVN4MnQ3RS9WZ01a?=
 =?utf-8?B?OFkzblRTdTZ4dWFmQWRNZGE0UG9WbU9oV0xYUTZQWWxyamNsazF5VVpPd21k?=
 =?utf-8?B?Vy9EUHFEbVRnK1F2aDEzZ0pOR3ZUUXFxRTRWU1FXUUVOYjFaRUlxZElFUVF0?=
 =?utf-8?B?akxRZ1FQWkt1QUIySjVVc0xUTEdKZVBlWUdxUFh1T21UY1BIV0t3OHhRcGM0?=
 =?utf-8?B?T3JlM0xNZVZRZEdoS24zajQxaGM0Z1V3azk4RXhyck04VjNETzJqYTRRZzRY?=
 =?utf-8?B?b2UwczEzSWtYcFBmMTdCR2RsMEpDUW1vczZ6TkNibUlmUW1sT2pob0JpaW80?=
 =?utf-8?Q?sSBeaSnBiv8py?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MzA2ZHE3YU5YQ0FUL05RamZMVTZDUzJXL0w0Q0RWQ29LMm1LbC9BVEUwZzFp?=
 =?utf-8?B?ZjNzQ3NOWFZVMzE0RUsrWjhYdDVpelBqekMzdmZ5bVFldFJYT09ESlM2QUww?=
 =?utf-8?B?cDg5NXFjL3o2MHhBWXRrZjZmTmtMSDNwM3B3VU9qYndOU2FGNG9sUnpiQWlO?=
 =?utf-8?B?ejluQU1rSHgzR2JPdEo5dUwwcWpHUUp4d0Y3ZE81TEZ2djRXbmhTVHY4TzJ2?=
 =?utf-8?B?cUNFSGR2MkxMbEZqaGRQNGlpbCtmTllqWlRwaTNKRExaWGZEMzJMQ3NZRFo0?=
 =?utf-8?B?VElmb3Rzb2VXM1Y2SjNibjVOMnExUHphS09xQy9qdEJGL3Bub0l6amFmQVRY?=
 =?utf-8?B?aVdaKzN5dmpzeFNXeEU4aVNCbFFkWUFpT1hkVHFjWm9qM3FybjVCMklnUXZZ?=
 =?utf-8?B?YW9NRGJoTWZpK05tNDJRWDYxYW9KVE43K0JNbHo1MjNPSzdBRWkxRnVyU2lF?=
 =?utf-8?B?dUhrN3A0NnMvek9Wc3kvd1d1SmtpUFZYSUl3MEhjMHM4RzBpUW5YUEN4Wmxo?=
 =?utf-8?B?NUtDMGlEYjZpL1FjZ3ozS0J3Q1lKTklIam9US3l6UHk4ZEdZdGt1S2RWUStH?=
 =?utf-8?B?cStlMHBncFU2ZGprUVlvUTFtZW1NYmlmbm5wMTMzcDFucXhuVzc2cDRHQWgv?=
 =?utf-8?B?Q2QyVXJZRTQySEh1eThxQ1MzM08ybWdhZUhvUmVuUXIxaHExL3V3WjNoV3k3?=
 =?utf-8?B?bEtNbE5Eb0diaVVrYjdWN2h2dkVHQWhHTldtU2tBdFNXYVpDNDA5aFVNNGRS?=
 =?utf-8?B?Y0FtMERJblVLL0tXTG5qeHNiK2R3RWo1UVhUMElWc1grUmFXdzhkQWxHQ3Ey?=
 =?utf-8?B?Q2E0UWtQQkp5TnZOOG15SjBUUHhmdVUwYWFwK2dQM3NBaWt5eFFOMjF1YlQv?=
 =?utf-8?B?dHZYYWlBV0tycDN3WmZ0QzgzRDFpeUVtcVZYOFNBa2t3Q0ZLRU9NZER5VVJO?=
 =?utf-8?B?eXhrQ3IxbFg4N2prQk0xS09zT0ZRMHBrYU8xSnEzTlZVVkxZWTVZZUpqblFp?=
 =?utf-8?B?aUthOWhPdEVUSDFOWktUa3pYT2JpZDhqczlSR3paRUFMYkV0QUdJSm9VY0xE?=
 =?utf-8?B?L3hBNEswdm0zd1RlVDR3dUVPYkl0U2djWGdKSXg1K3ZqUk4xYlF6Z1lodXVx?=
 =?utf-8?B?ZjVCWjFDU2N0b29zdnNFZitwYjhCbWs3NHRZTmdhVk5SUHZQbXhaQThFYzhU?=
 =?utf-8?B?Wnlya3h4dG9LSlhqTzA4WTNpVlJTaktYRStOUFF5ZzBneUU3b0o0TnF6Rkcx?=
 =?utf-8?B?ZG9oMVYwdnQ2MG9ISzg0bzJxZzFrM21iQXQ3dE1GTXdPSFc0dFRIczNmeFFT?=
 =?utf-8?B?S3VHZ3VJSTBMcnlreHBRV2k1cmViVzMwa3N0MHJUUmxyVXd2dmtGZlhRaCtx?=
 =?utf-8?B?SHRzUjdqZUFzVlVOdDNPeE9uOWtVTGtWb1M4c2tidjJQU3hxeGMrVmdoRzBP?=
 =?utf-8?B?MGRBeUJmbmVpR2RHSkg3VUhTRnJ5d1E5aW9EdGJLOVBpcnJScDBvbUZ2dXlL?=
 =?utf-8?B?VVF4LzB2bW5OOGVtbGNNay9BQW1FbHpsd083UENrQUJOTlY3eXNiSFp6clha?=
 =?utf-8?B?ei9zdEJ5aFI3ZWNodFRuSjMzTnBhUzh1Ymd6NHBVRll3ZjYyU2hOZ0MrdzVR?=
 =?utf-8?B?L0xhV3ozRjNKa0h1MlV2ZXBsTjNXQllxRzJYSGVyblJjRVcyQit2ZUd3TVNo?=
 =?utf-8?B?UnpKcCtzTFNzbVRPaUUzTUxWWTlkVlNZL3lOSVlBU2d1OThBb3Rzc3pRZXQ2?=
 =?utf-8?B?YjdvTE9DNWQzb0N1N08wYmIxQVdKTXVGeGIrRDNNUVRkdzNIbzl5RXVXNzNQ?=
 =?utf-8?B?eEZ0a3ZBT1NmU1cybEhQVmd5MFd0VHpNTkNYWjB2ZC9RREJpcTlsd2JrUVdv?=
 =?utf-8?B?bEV6RklMbW0wS1VrbU8vSUFMVjNhbWhVblRDRFEyNUZJbjNxdHhCNzBFUlRU?=
 =?utf-8?B?UGNkMWRrcWYxKzhnd1p4TVU5ajBINmpmRTREOE1BWFV1S2VwTFFBWjB1UEw2?=
 =?utf-8?B?eUYrVkdIclFEOXVmMlJDdi90QTFKTEFSQy9XOXNhd016bTIzZjAyVGpqVzMv?=
 =?utf-8?B?Z1NqQjVJL0tmaFFIQmVidlpkOTFGaFJwU3hOZHUrWFlrTEVlVzJlWXdqOG9Z?=
 =?utf-8?B?a0dYQ3BmTCtIVG40U3pyZUo3NDIwbmF6YW9DV3lPaEFNb09Gb2ZWQjB5bE5I?=
 =?utf-8?B?MGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	k3j8PSOTgvWVh2hPcdPuMuEBmF4KgrtSE4rmbbNEJCJNzPoRl31Dza8KAQcstsmlm3KGNZvx5bYxVYnqJC+wL+xoP8TOfjipv+BixzdSlrmFDb7wkTQ6EP+23FhcLq0NCIxtT1ZubwoY/zW0mz40eIRNHyDAXGsZMwEDNf/XtLYhElXo8DbUrGLAhWUQmhmfIG6ING5teJFq4CBh9LpOIxigjK1qVO+11MMKdipEIHWCaTjokPjH1phAcnYh1eXLTtzc4QoXC8u5VAI8hNpCnp23oZLwbws0LyhKCebpVL/muBRNlaXVe6GPYdSkIoEXM/VDskd2nrNc3tYSHC0aRHZGLUko/SQb5WyCW2kGtZbgKbwxPfLA6wyhnOBVGge9VWf7HfTeoPNCKo/S7FRr1OodUpsUgHqPON4vBLtua1tRuPqQBysH0c5LY5RbqelJfUik5CGkkxuXvLfKvxBK8bcajRzIwOBaQsVwrN7LxPtZCB9adONX1THkXmO6/XTZyp2sRyGl6hi6CO5Pmd833DwDvrom85zUhYuMk5C4ET8FdzZE/o2rd2iMR1ZXkxiD0gwEWbTeFRN7RI0CIuhFKGoP1itDXiV4l0YNJTqbl2M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f74443f5-10ee-496e-aa65-08dd6cbd008e
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2025 23:21:57.2403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s0jgkyL17U7/b5hOaiTR8e5FpIKhUAgzW3vEor/7VDtPPdLSHtxwmdVDwzOaY8mwjLlcE8AQlTCntqizi8tgoeFBbBGdqxS4UsWJB3AWOhE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5665
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-26_09,2025-03-26_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503260145
X-Proofpoint-GUID: xLkEqWeVGfbtQKEgzEGuNRP9ghMzSfbb
X-Proofpoint-ORIG-GUID: xLkEqWeVGfbtQKEgzEGuNRP9ghMzSfbb

On 3/17/25 6:55 PM, Dongli Zhang wrote:
> Adjust vhost_scsi_get_desc() to facilitate logging of vring descriptors.
> 
> Add new arguments to allow passing the log buffer and length to
> vhost_get_vq_desc().
> 
> In addition, reset 'log_num' since vhost_get_vq_desc() may reset it only
> after certain condition checks.
> 
> Suggested-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>

