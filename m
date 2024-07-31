Return-Path: <kvm+bounces-22764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 11475943115
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:39:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 323A31C21B59
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 13:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0E981B29CF;
	Wed, 31 Jul 2024 13:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kbpOX+YI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tBXPnCIk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026031B0125;
	Wed, 31 Jul 2024 13:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722433163; cv=fail; b=ez5an5MSENte6fhi3t/Lg2p0m9u6l8Fuoepn1RzUM6t3L2FvPdxTcYlO4yA5L7oBj+Wy1rE3mc56n6MWDI/z7nRdeEVg1Wio61TIeYCaO7Jj5xhTq9UEUaSIbZC0HYKPytrqveFv+U7NmHA9yFzhTijAjaSnzJMKHE9eP4f3lj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722433163; c=relaxed/simple;
	bh=74s98Q4ciaH0JcbkWNXWQswMhu89A+WHQXhKiCqtoJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=k5T2+rcaxZLURUCcctoFLLRrXhvWWtvdhFillkkGAwX9fCCIk2Fj434Nr4xCnZTHK4k7cor7o746JjPnD6kBVJJkX6pJn9rr5fNoDJ2a5xNcppXgtthXWEzNstsEWXJBStaJR6iZUvYg6jKEXfLocE8p0sGQWdssJxKG9SH8vBo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kbpOX+YI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tBXPnCIk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46V7tTZn006803;
	Wed, 31 Jul 2024 13:36:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	date:from:to:cc:subject:message-id:references:content-type
	:in-reply-to:mime-version; s=corp-2023-11-20; bh=cWr/zyl+BnCqBA6
	Fp4aQg/FbZv8KT5SxcAkDLDvpcio=; b=kbpOX+YI9CAUUATZ7gc3ncBT8YeFEvM
	IaZVgg7eQ73WGDTacWg3O/VE9FZBmtjSg2wWzvS0cmMwmMnmB8ZZIOorr2MH3tT2
	cUpyTQrd2ddaoaurAbdzIoNNxshTew2zjQr751nQbNj9ecO3FBqjLW8nvltR5sZq
	zldO9r4PYi3e7q7FSLb5xdPlXXUqq52iMpnr3v3Mc65UCPiUz7CnvceUZD9wsr2m
	gyp64y8lvoTzVzbkfl9HD7BlAgyGFIwHAT4NoV15ld6gNXyWymSwPki3xuU1csq2
	BRZeCiW+VPuct6SHzwmXiQlNkt+0kaBbZ9f8rkctC/nAbdx+nOL6eNg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40mqp1ydyf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jul 2024 13:36:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46VCHnUh037670;
	Wed, 31 Jul 2024 13:36:43 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40nvnxqx1f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jul 2024 13:36:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ymfNSW11H7U1atpUdit2l92tiGcowEkNPniSYNrTrpLU6ieCY7HozgtyPtF68owM1L9+kbkhafc3qUh5CRb7lud6a1I1uhzhQSd0luU9uU/F7A/3Jq43PXIzQAqKg18+szmuhEaQqbItUrN9JFZAPwuQNH0LSZUVgV+LqP8bZ+ZQpxaFn5gONo/mpD0DEcg9BeBhNg0KPoP0L0DMS3ZbALKgc5MudrtBbxnoT/k/ve46E59MjPuRNXDvElR+QTG/F0VJEnXHV06WZr42rqrxSE0XXukFcLFuexehaBLyP4AGdlX2yP4OdzqqNsKCukry9jJQBkYfi40CQAmNtrl67g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cWr/zyl+BnCqBA6Fp4aQg/FbZv8KT5SxcAkDLDvpcio=;
 b=kQwrmQqG5P1fG4/s/A+wlHyxfQNB5JGwWAVlzPIPy3LzLZHNQLx3Psv3qlJ/DE1wAZJRxtSZFmSFugyeUv5joKfwZbdE1mMIWkAELo9a/J9lUzILT584Sa2HWvQB2NN1ZsGmPgcbseXe/B6lYe2QhYqd1sZJg/JW37/yZYwoLkKqkArGGrhkk97+40CcTUnnUVofqW9RO8AoOjsJYTa6tzj10qiljkNUpU9opAW8mcQpoLDvQlE/9vPNY8k8kIw3JUv6iIXLtZKT2VGPKspZRBDN/xx0K4PFAHRy/nFFtDwtvfEu4zBmChjBX0HiTIfUq3oQGf72Gk5XiCTK0KFFDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cWr/zyl+BnCqBA6Fp4aQg/FbZv8KT5SxcAkDLDvpcio=;
 b=tBXPnCIkXM6plA8k/3RdRTG1NhE5mrWxBVdk3fE73oNNNnmgnFHIlZxUGJky0iqK13rM4snYz2sHi+Awhm781182RCPIyucrh5Uta498RbWYdGEHTp6Sbxa/rd16x/RXB/0fwoFL1sS6d0Gb8PN6f7AXk6dr/7nN37MpCb0285c=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by PH8PR10MB6479.namprd10.prod.outlook.com (2603:10b6:510:22d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.21; Wed, 31 Jul
 2024 13:36:38 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90%6]) with mapi id 15.20.7828.021; Wed, 31 Jul 2024
 13:36:38 +0000
Date: Wed, 31 Jul 2024 09:36:34 -0400
From: Chuck Lever <chuck.lever@oracle.com>
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
        Jeff Layton <jlayton@kernel.org>, Neil Brown <neilb@suse.de>,
        Olga Kornievskaia <kolga@netapp.com>, Dai Ngo <Dai.Ngo@oracle.com>,
        Tom Talpey <tom@talpey.com>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, linux-mm@kvack.org,
        linux-afs@lists.infradead.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH net-next v12 05/14] mm: page_frag: avoid caller accessing
 'page_frag_cache' directly
Message-ID: <Zqo94stnPVJNvmc+@tissot.1015granger.net>
References: <20240731124505.2903877-1-linyunsheng@huawei.com>
 <20240731124505.2903877-6-linyunsheng@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240731124505.2903877-6-linyunsheng@huawei.com>
X-ClientProxiedBy: CH0PR13CA0022.namprd13.prod.outlook.com
 (2603:10b6:610:b1::27) To BN0PR10MB5128.namprd10.prod.outlook.com
 (2603:10b6:408:117::24)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5128:EE_|PH8PR10MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: 7da7aa07-37fa-45da-7532-08dcb165ce0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hq165QUNFfAQ7j9T+DTYCCipfNidfSqOp4tpCd6K8tQyAkmxtv02iVn7bMiA?=
 =?us-ascii?Q?67u+xSxuyn3CgJDltMXpPUkdRCr0NAq7kcH4u3pQbrAxd/qCAg1Gw7fHdbqM?=
 =?us-ascii?Q?n+E89FU8kTnRqroCCRUE2m61juijVR0XZq9eopCNm6yyFkp27iFiVyCuFGz7?=
 =?us-ascii?Q?HYeBSKFtvmyRMINgEG4fKht98EDslA9/a76tumLM8SIHbqjWC9jnnXELdVU8?=
 =?us-ascii?Q?CyK3QB3fnLpof2KyyUifpRpS+d574veNrW2Hgq2f/Zerl0kb77tK6AupeQ8m?=
 =?us-ascii?Q?ZmeEneGc/zRORE/IUobzGPNDNLnBbjw+b+P7wabzxzx3RYkRVs+hXQataTpn?=
 =?us-ascii?Q?G3cBGK/A1898Ug6m1B8Wiblg0V24q2/WmtK1KURuLYDBxgpd1YRzU/fw9Yya?=
 =?us-ascii?Q?9LStnaLcJwbbHQlTOc1ADis7VO4kN6q+nlBBkYUA/M1tWZDnjwQU6zsNFsfK?=
 =?us-ascii?Q?vahUaDdITBAf5/uyzlnYOkZnONeXTwi0OpIItAHPvo6PtR2OyeHEMZMC2Ad9?=
 =?us-ascii?Q?25pwDPFCP7iYofdjHT0H4zRm9Fnd4pd9j8dueNVuZNpHMbrU5+AmddnHdoXe?=
 =?us-ascii?Q?kxBvwqH2YcJjjmY8Ab0BwaZX3fk1DpZN3m9+nSLBno2G3EUL0yMbA/UgdT6i?=
 =?us-ascii?Q?MyxhEAfmkRQy1GrKFDzkau4RiCDy+L1ABRmYR+LyPWIMr5oxJccsIcsH+POR?=
 =?us-ascii?Q?hfFyUpOVFoRL41sMjMyTXJMp/1iDk+LLXzqxUbg9ry48H3KZlhiQPe8/7uFt?=
 =?us-ascii?Q?GPcGzAgJJTDZGa4a3XcsdAiD51DnaLbTYcbsV5N1RkCskKInLS0PVpnhidEb?=
 =?us-ascii?Q?ccbDWJPs4BkgJrXPr6XglR/8yCMFTiP3WKWusbY83I4pyLaIXxhN3B+5SLkE?=
 =?us-ascii?Q?vZpE87p/Zi77XcbNzOjBvEc6+aARQfPwAe7TqEgCoULJ7PGgjTXIHg0pPbsq?=
 =?us-ascii?Q?WJA8i52VjjaitOMPTTcV5IwM7GKh6trVRnYUeOkwlTmxu9Wl3Fe3sPA1g8Vi?=
 =?us-ascii?Q?luDXjel9pw6AoGIvfurMsHcVOKWSFkrHEvRNdTwCXZbae3LtQyRfH5/uRQE/?=
 =?us-ascii?Q?cTr5gPVtVWXDkH4kynZj2wxzkkm4GkDbDwjNo0XzLG7nYf5owGStHCWPQD2q?=
 =?us-ascii?Q?ig+GXmj49juDIGNVC9CfiqRdq+raT/DyRlzFCn0v2RqhOxXgRl9AsI+v5OPo?=
 =?us-ascii?Q?/uH0/kUuf+D8sTnEiJ6TcF0FhCL1NbYQgO+dq7Pba3UuMF87Thdd+bOGdNRh?=
 =?us-ascii?Q?INSue64sU9Knt7q7sBU/PzlQRNx/XsUvKeNlSpYLHU8f2suMM1ymY049ttjn?=
 =?us-ascii?Q?hrCbDT3YpP3Tbn1n0YrpZBiwZUu6essmE1gVBW2cSLdH8g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QqSaF1QUOc+Y34TRwKCPkfyTztHonluZdKAj83ewZHuI6IjAk9HRochd23na?=
 =?us-ascii?Q?ma/dF+hs/FhZ4JIy/fzM1aMPyjLsi/ISykBnErZEp06NlrN1clSUePobDPFG?=
 =?us-ascii?Q?KVhzs0+HfYo2Y8GYmfrh25EgnWkOYXp1Qt3jbRi/2DneedL/FRZck6CdPKnz?=
 =?us-ascii?Q?/Z2l1+BU9vphvOp4mChin0/BQh/KiIKPMVx5F2dL+y/wZwyYn3rL18Sd225z?=
 =?us-ascii?Q?vVQCPuMIxvPxNcDGM07qYr5qcPzbmHuuPoceKyOzyVo/mSkM8+/R4ABZrVdH?=
 =?us-ascii?Q?nZAS9uvcG56tFfJySo967yuIgKqLFDh2F3Zsp3eERawaKEkbMz4iAALRm94S?=
 =?us-ascii?Q?Ls8OmVbSWFATAPJCSJeJ8PfKSbvoJ9v/Rc/EWH+NITEyawSyeYnfbgksSi1U?=
 =?us-ascii?Q?la1Mp47WrM4R0/PgiHgzO8uPvZ9uw+qjZLASZDAF1zzzmOxSUvYNwhiy1a/T?=
 =?us-ascii?Q?nduZOUpjQN7B74G6p1m6dDNf/P5W2kBWuQYHAiKfRiirMko3JuPsHPiuk8aw?=
 =?us-ascii?Q?PI4A2gUkd+0o4MtGB8YqaFzKadEZds0Zx3z5KN3C3xt96q+gVDwdIMDRCYZQ?=
 =?us-ascii?Q?MPRlRNYqvkBVRu5/AeKJz/3gwmAWiCf/dNjBJeu0CKGLi38ldGc3PwuWfGML?=
 =?us-ascii?Q?SKzX6+v0jQ8Hb4qZe+ouzWgzp9Egja4QYZcHXz2aPZSz+Uwm72xO2vQyCTFr?=
 =?us-ascii?Q?hcARJY7oQcaCQcPIlEytFiEZiMJ9Nhx3OqoLTmLq3VkC7eH6y/asqQeoOYfA?=
 =?us-ascii?Q?gUkhc9mR3pxhD0HfUQ2ha2a2vSJ8qPvQJF4Ai2TSwlqcF/JPWBCFjxm26itn?=
 =?us-ascii?Q?YOx0aBiSbKldbHAff/iCJy+4dCEx0gvzFH9GV0lfTJoqBm1LUMXEtqAY8f9H?=
 =?us-ascii?Q?klz2sYEWDwvQo+VHKI4mtI7rVULApt4UdWWR5VPHfKVzMwe4TwyMK//SGz1f?=
 =?us-ascii?Q?ez5KBtAyW+sjY3EQJJSNnYzuSznau7tyC0zknl9ZK6Gnm7YR/FnxcsG9doEf?=
 =?us-ascii?Q?e1Z1UzPUB+mJ3VXC7fNN9gnOkBM8CVTXVoiprvxEHifsE/OxjaB/6BsPdU6D?=
 =?us-ascii?Q?x5ieOmoqiYfSXEYZzoxC9ro9Rqv3wUpWism2IaRfDt9zfH8tS87sTBK9/Hry?=
 =?us-ascii?Q?k6kIdd5JUTKV9GrAApPtzLA7wWaNC+CH1awyNFoLTSrIfPPWoWMCqFwS7VRL?=
 =?us-ascii?Q?9u8AiI7cp1cmGu4h4AyZkOwft4e9EDqmvJ/v+UzWfmiNlZn/RreEUllNRjFi?=
 =?us-ascii?Q?iAz05WWZ09T52iFFPU1fMQafb9DfHZfdsxB2eW0Q4JZS0e4CWH7bUI1iGyq6?=
 =?us-ascii?Q?XsTcvZwepCBTqL55rm4ArbTBApdDbSZTxnEc2GOrq0xLEZWjfts0WAUdYsb9?=
 =?us-ascii?Q?qaJn+I0PqTdrLvvOfW5qW4V6ieyIXTirG2TCQkm3c/j8IW5R9lTcL+rEkGcE?=
 =?us-ascii?Q?IXHoPuBKBFgyUwqgI9mraFfNgcMDuVYw2BD8CC86nIqjW7uKsh/fEG8Ow6us?=
 =?us-ascii?Q?ilq2xYIt9krUPmGO0PuMHjFLlVBPLG2juZYUrco7JPM1jKQiGAHm5F2nAMUk?=
 =?us-ascii?Q?gTdJ+O+VGMfPzXZcT5OnyAhMatjDZyPc8H8MF3BH?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QYi8eT/FgRs2GsMf+7Ytf64DiY/DdL92SlJJegW9glpqWZB/4wGu0D/TeQO9o9CE0nG9dXN/EQjaLhATCiFasCUgwSa8dBhZb2JrgqkuqKwJwqaM1OShkIikTQ17jCKlWYhjaqyoei+u71drYtXv7nkClv9l4+OuuVb/cFFNB3WMA86y4M0T7W7Kkc/5inb6m2oxKrt1u68HIDP+wPLTDyEDyXB1xNcJu2gZULV5kuVk+QARfQPJX6/7qxm+qAso77IXzJKn7LTMv8IsKsRxA8LaqiLq/bze1W7IAjU017CKhOLJ9QzRWrFHxXGAjD3g/W9DPwrNLdoMTRXthWriX2f+RDyXw2A9Zbllg/WuqnKGsBhtQnWXXlCbzI0L7HMBl8Dh11/WT5lGugqDPKxrtyRgqfGnQhPHiBrJHrZCiJkiWMJ1EA8qz96OHPNXxvlPJrYn5u52+ALrRctpOcKlJzwGlrsJFasfCoa6px4rtCf/aCP0kwYuh5mwWWMGVc++3sjwrNh5EpcrcChfmB/25iH0gyUlKr/ORlNSoMgDJXOGRzj93sikDeK9nD5CoMPTGjU0Em3HHhPEepdciU3PnknsMgTM1xmPt0XBZh6Cyfo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7da7aa07-37fa-45da-7532-08dcb165ce0c
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 13:36:38.8113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iaiYE+5u9c9NdJmXadBSIsvmzXYhu/+1tqcDuQ7sEdy7xbbVKlOc+LklMC2l3VGPaOMvYWc4vmClx/T2dPS/3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6479
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-31_08,2024-07-31_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2407310099
X-Proofpoint-ORIG-GUID: wFnIqlftL79milkJFtwt0yCGkahpdIoH
X-Proofpoint-GUID: wFnIqlftL79milkJFtwt0yCGkahpdIoH

On Wed, Jul 31, 2024 at 08:44:55PM +0800, Yunsheng Lin wrote:
> Use appropriate frag_page API instead of caller accessing
> 'page_frag_cache' directly.
> 
> CC: Alexander Duyck <alexander.duyck@gmail.com>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

For the net/sunrpc/svcsock.c hunk:

Acked-by: Chuck Lever <chuck.lever@oracle.com>


> ---
>  drivers/vhost/net.c             |  2 +-
>  include/linux/page_frag_cache.h | 10 ++++++++++
>  mm/page_frag_test.c             |  2 +-
>  net/core/skbuff.c               |  6 +++---
>  net/rxrpc/conn_object.c         |  4 +---
>  net/rxrpc/local_object.c        |  4 +---
>  net/sunrpc/svcsock.c            |  6 ++----
>  7 files changed, 19 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 6691fac01e0d..b2737dc0dc50 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -1325,7 +1325,7 @@ static int vhost_net_open(struct inode *inode, struct file *f)
>  			vqs[VHOST_NET_VQ_RX]);
>  
>  	f->private_data = n;
> -	n->pf_cache.va = NULL;
> +	page_frag_cache_init(&n->pf_cache);
>  
>  	return 0;
>  }
> diff --git a/include/linux/page_frag_cache.h b/include/linux/page_frag_cache.h
> index ef038a07925c..7c9125a9aed3 100644
> --- a/include/linux/page_frag_cache.h
> +++ b/include/linux/page_frag_cache.h
> @@ -7,6 +7,16 @@
>  #include <linux/types.h>
>  #include <linux/mm_types_task.h>
>  
> +static inline void page_frag_cache_init(struct page_frag_cache *nc)
> +{
> +	nc->va = NULL;
> +}
> +
> +static inline bool page_frag_cache_is_pfmemalloc(struct page_frag_cache *nc)
> +{
> +	return !!nc->pfmemalloc;
> +}
> +
>  void page_frag_cache_drain(struct page_frag_cache *nc);
>  void __page_frag_cache_drain(struct page *page, unsigned int count);
>  void *__page_frag_alloc_va_align(struct page_frag_cache *nc,
> diff --git a/mm/page_frag_test.c b/mm/page_frag_test.c
> index 9eaa3ab74b29..6df8d8865afe 100644
> --- a/mm/page_frag_test.c
> +++ b/mm/page_frag_test.c
> @@ -344,7 +344,7 @@ static int __init page_frag_test_init(void)
>  	u64 duration;
>  	int ret;
>  
> -	test_frag.va = NULL;
> +	page_frag_cache_init(&test_frag);
>  	atomic_set(&nthreads, 2);
>  	init_completion(&wait);
>  
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 4b8acd967793..76a473b1072d 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -749,14 +749,14 @@ struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned int len,
>  	if (in_hardirq() || irqs_disabled()) {
>  		nc = this_cpu_ptr(&netdev_alloc_cache);
>  		data = page_frag_alloc_va(nc, len, gfp_mask);
> -		pfmemalloc = nc->pfmemalloc;
> +		pfmemalloc = page_frag_cache_is_pfmemalloc(nc);
>  	} else {
>  		local_bh_disable();
>  		local_lock_nested_bh(&napi_alloc_cache.bh_lock);
>  
>  		nc = this_cpu_ptr(&napi_alloc_cache.page);
>  		data = page_frag_alloc_va(nc, len, gfp_mask);
> -		pfmemalloc = nc->pfmemalloc;
> +		pfmemalloc = page_frag_cache_is_pfmemalloc(nc);
>  
>  		local_unlock_nested_bh(&napi_alloc_cache.bh_lock);
>  		local_bh_enable();
> @@ -846,7 +846,7 @@ struct sk_buff *napi_alloc_skb(struct napi_struct *napi, unsigned int len)
>  		len = SKB_HEAD_ALIGN(len);
>  
>  		data = page_frag_alloc_va(&nc->page, len, gfp_mask);
> -		pfmemalloc = nc->page.pfmemalloc;
> +		pfmemalloc = page_frag_cache_is_pfmemalloc(&nc->page);
>  	}
>  	local_unlock_nested_bh(&napi_alloc_cache.bh_lock);
>  
> diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
> index 1539d315afe7..694c4df7a1a3 100644
> --- a/net/rxrpc/conn_object.c
> +++ b/net/rxrpc/conn_object.c
> @@ -337,9 +337,7 @@ static void rxrpc_clean_up_connection(struct work_struct *work)
>  	 */
>  	rxrpc_purge_queue(&conn->rx_queue);
>  
> -	if (conn->tx_data_alloc.va)
> -		__page_frag_cache_drain(virt_to_page(conn->tx_data_alloc.va),
> -					conn->tx_data_alloc.pagecnt_bias);
> +	page_frag_cache_drain(&conn->tx_data_alloc);
>  	call_rcu(&conn->rcu, rxrpc_rcu_free_connection);
>  }
>  
> diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
> index 504453c688d7..a8cffe47cf01 100644
> --- a/net/rxrpc/local_object.c
> +++ b/net/rxrpc/local_object.c
> @@ -452,9 +452,7 @@ void rxrpc_destroy_local(struct rxrpc_local *local)
>  #endif
>  	rxrpc_purge_queue(&local->rx_queue);
>  	rxrpc_purge_client_connections(local);
> -	if (local->tx_alloc.va)
> -		__page_frag_cache_drain(virt_to_page(local->tx_alloc.va),
> -					local->tx_alloc.pagecnt_bias);
> +	page_frag_cache_drain(&local->tx_alloc);
>  }
>  
>  /*
> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
> index 42d20412c1c3..4b1e87187614 100644
> --- a/net/sunrpc/svcsock.c
> +++ b/net/sunrpc/svcsock.c
> @@ -1609,7 +1609,6 @@ static void svc_tcp_sock_detach(struct svc_xprt *xprt)
>  static void svc_sock_free(struct svc_xprt *xprt)
>  {
>  	struct svc_sock *svsk = container_of(xprt, struct svc_sock, sk_xprt);
> -	struct page_frag_cache *pfc = &svsk->sk_frag_cache;
>  	struct socket *sock = svsk->sk_sock;
>  
>  	trace_svcsock_free(svsk, sock);
> @@ -1619,8 +1618,7 @@ static void svc_sock_free(struct svc_xprt *xprt)
>  		sockfd_put(sock);
>  	else
>  		sock_release(sock);
> -	if (pfc->va)
> -		__page_frag_cache_drain(virt_to_head_page(pfc->va),
> -					pfc->pagecnt_bias);
> +
> +	page_frag_cache_drain(&svsk->sk_frag_cache);
>  	kfree(svsk);
>  }
> -- 
> 2.33.0
> 

-- 
Chuck Lever

