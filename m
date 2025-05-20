Return-Path: <kvm+bounces-47154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CF3CABE01E
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 18:11:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 93D48189AB1F
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 16:11:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59EC7270553;
	Tue, 20 May 2025 16:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Le6dZ6Js";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KyK+/yo+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8034726A1CC;
	Tue, 20 May 2025 16:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747757424; cv=fail; b=NB32NbONrWPE/BaqNtCRDUl6G1G7duNu9nb9aPGA5Q/Oi3qydeJyJZv+NIgiU0N3EeEPzBPphDSrLiwyUaUGY9C4uXWqFwCzbntIa+MENU10bUdMcnjEYRtO7oYwBQdoSDy77OWUN3FeMurYdRXS87LeCK1Yn/puQJEJ7l6Z6dA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747757424; c=relaxed/simple;
	bh=fcWwcirw3yNY0nqIyhMhbQIT5MtabZGQEpTJN6OxwGc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XSAAQ/UjzYayLRnxd46s5iEtohCVwtZk3Y/MOh4oSgpUtC7EcRmFotT/LPDAOXPrpP7noj6IjgfsqFFX6V51jqWDPTMstQkuCCrXqqme1SNm4XuNko7bNYSS7eruDUOsOZQ9sEbZz2x0YyROLYO/VeyD/A3nNVJJc7VSMFfQagM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Le6dZ6Js; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KyK+/yo+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54KFN2m7007978;
	Tue, 20 May 2025 16:10:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=gOlmqV5MZ19T/lfmAe
	P+i0Ixh9JFXSTFonxlcvHvaBY=; b=Le6dZ6Js5yL+do0Xaq5U0v+WSEzBIZ1t9k
	j6jmy2BdbBRr8gIVRIwI1wpIz5NIIoA3mKIR62cX6g0v3gzKegvEVO+N1mnBsUbS
	hClSBiFT1MQDdEoNOUvrenjlh+trI+sdSRt+NKh6surcJQtqPdIUb5SGl+DCOdII
	Bfx+2nDTPKSNkXXFVsYlgpstZwkkB6SwPf6MzdTI+cw/jDRwqvziqsis0GNfPyJn
	JRjGHbMLfY9D/OwmDjhSnnfAIXDx21UlgXSIaydbUYZbc4/RYX7Beu+LY07Pflf8
	3gXjATu3Hi297OzSbrxuAqmSntGj0nkpf36b+N05ip1qISy2pgmg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46rvahg3fq-32
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 16:10:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54KFJWFj000848;
	Tue, 20 May 2025 15:57:31 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazlp17012015.outbound.protection.outlook.com [40.93.14.15])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46pgw881kk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 15:57:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dMXDAVLhzuYxtTvOlpMrdPqsNciQSvhmaR1INAa2v3maeYjzCKlUXh9ss807wR9yu9Ji6+epvJ33DGf9Cjj3rj5rvjZ1wt1w3xgTKvG4keNlZwTJBeHgr8QI8rkXgW2ToPkg0o+/Zj9IAa8Dlqs92hQYpN4SXQN6r+8cKuGTCfbCVnupnAnh++QEOmd+UWfocoqwanDBOBQpoCoO8QdHkbOcEX+rs1RpTprrd0Kqe/NDe/mtDTUNU38MWwv6ASN082DewAAQP2qUZrUEEEmWc+e06xkp3Km9VFAFEwO7T/rKy1LTippExbFIKO1wfP71xgo7cyP/sxSjNIj4QsFe0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gOlmqV5MZ19T/lfmAeP+i0Ixh9JFXSTFonxlcvHvaBY=;
 b=G9KwwmAC+X96TmY64a0ynapBGzJmaMWWTBkK7WH1pJ7SYv41ZObAtEepLn/hFswghRnzI7eRxTU/ftIRMRYQ14ldYdrIzpN6EXhg+nT8RtqFlL5vdfNHs/Dz4MCoqJF6MiJ7d6ev7gRTFDpx7O14B3mBsS8gR9feYYtI9xnEMRyAry0ecy6P/oXqhiWj9n/P1Ieuq6ZsemI3xTUZLEVC6GHbbSLtRNYkWPsal+gEyvRNL4M7DIcz1G68+UBpV9BPbzsCBPNB29FuL512C8XHF2BPFt5ZVR/HSkIfOH5ktijiWeF1wWmfW72L8DGDqzA/Jvp+sCPNzZtUOJRK4Bb0Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gOlmqV5MZ19T/lfmAeP+i0Ixh9JFXSTFonxlcvHvaBY=;
 b=KyK+/yo+WHpUb7smdSrCDAQGNd4ruEFGaGAgWPuWgVxEXX/5rZrHO+vLAtBZAJETGBtSG5bn2vphfRzcjJxB0LoiTP4HCAB9Sag32CQf0HhFl7NWc7+Zb++PoouzvcYTbXX4JPsXZpWy90eFv8HBtSrLTV52E9y0MPw1iNQd2dc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA4PR10MB8471.namprd10.prod.outlook.com (2603:10b6:208:55e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Tue, 20 May
 2025 15:57:28 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 15:57:28 +0000
Date: Tue, 20 May 2025 16:57:26 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Houghton <jthoughton@google.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>,
        Yang Shi <yang@os.amperecomputing.com>,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY
Message-ID: <e061d09b-f4bf-4fb3-bb16-bd85fc33b644@lucifer.local>
References: <20250519145657.178365-1-lorenzo.stoakes@oracle.com>
 <20250520171009.49b2bd1b@p-imbrenda>
 <cb0894b6-3c41-4850-a077-2d18f5547d2e@lucifer.local>
 <20250520175428.24ec47b7@p-imbrenda>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250520175428.24ec47b7@p-imbrenda>
X-ClientProxiedBy: LO2P123CA0017.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::29) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA4PR10MB8471:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e3d561b-4e64-4b61-40f0-08dd97b70592
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nDKYgxOUmIiJF0UorA4XIl2dAPjP/Tp0ZMZCDUmKAh6YcO6YKKDNQnq7WOXP?=
 =?us-ascii?Q?gj1v5tve7zujwCcogi6W5VT4XBiaHa2lK28vlQXjdFisq2kg27Dw37fL9K3x?=
 =?us-ascii?Q?bmgf83HgyLObfp9eA0WokDMdPiDm2Pmd73/0Us4NQMJomCs+ksGHzcEd+PdO?=
 =?us-ascii?Q?zAY7sye2Jaw51WtUgfsielVz/qTfp5dCWLLp7dn2mNVJLrZZm99z+snBhsuj?=
 =?us-ascii?Q?vQyHP5xGKi3RaY6V/UEoutA1NW6kyjqyNeQy/5tYHzbwUo0CC3vUzmocbvdo?=
 =?us-ascii?Q?0BGUot06GSUGvejAVRVPOd6M9xkkiH44sVJPCOvVys9FL3WkHJzNLlm4vgrB?=
 =?us-ascii?Q?8GS+tBJvLKT0ytUB/yNzQeF65kFb+6/6eyvTCVWk/yq4zsDqC6W2EBreLPxX?=
 =?us-ascii?Q?wOB7BMMmRZOuza7QR+hYxqvYGcD7jYD1mImQMUERb+nsaWMxciM5IvJakIPZ?=
 =?us-ascii?Q?PHiDAODcXoiPiqm55K21GrFoXBXClLZjg0tZU2oXglxHSobB7tEowvRREplc?=
 =?us-ascii?Q?irz/eIbyeiK5sOqxj5ZY563ojk/iC3O4NlX29T3S4GITtCtxJmxDPF4LsOGn?=
 =?us-ascii?Q?PabtlcBSYM2Y4HWcMjtKxT5H1KTifEuj5qMfyQp/ha/kUPnRqkykxBtFHDdw?=
 =?us-ascii?Q?1lCjirgfUhA5q5SRtLlTu6IYbME77zNYnN0dUlUkkmnHruK8HDGcWTSEZBck?=
 =?us-ascii?Q?FPJ/UHmHUFEsV7R2IeWP354ShblJunbU0F1QCduN/3R9BkWGFklix4H9RCUP?=
 =?us-ascii?Q?ysmbn+kRO1kw8REAQtUz7a5g6a1WWId+e1dFZdPVvsXItjBvGtmySBYTvgcA?=
 =?us-ascii?Q?UbuU0RXhTsOvzjF59XSB/p3Ztcut79MWu1YEWMoAPt+Syf2X/wIUO2790esU?=
 =?us-ascii?Q?xhCn810GRY9iljA8rUmtBEH8ELUgCrjnaVzNxKvRC10MnWxPFEWRcTApLpjs?=
 =?us-ascii?Q?3iKoNXRgqa+bemcwkFh+mq6Vwj/Qk3ZHVclRnT/4tcR8u5XWV6q5Pvladq0J?=
 =?us-ascii?Q?usTWJw7KhjPF+qccaKCYxt9B2cD00no2/+4t+YDsN+I+cxkxL1HhtKB+Ao/N?=
 =?us-ascii?Q?Tny2bpFWL8K8ymM7ynDqb/XQIIv0K9f9sjkKxLMSRuXMYoCk0USm8JkO3Vq8?=
 =?us-ascii?Q?RBU4fri3MBDoQZ4c8+D6LOFFI3PnkPX3CSkQmAwZxmOy9bsg6Kw6zAcHh4sc?=
 =?us-ascii?Q?lIPPl6gjJHlYBCKYTC4tzkC9yDKSSxS2Lhy9vG482qpeRKta1vPOenP0kOJz?=
 =?us-ascii?Q?cfgURvj+JeQ1g7sPMYr0n5+e9mVaMohODzp9uer2Uxpko+79qL7Skyb3bl+G?=
 =?us-ascii?Q?wwJg3uWn5aDFmdhDUYXXFMeQK2/cCP8ua2or6jFWAQPik56dpl3v+VFfheyL?=
 =?us-ascii?Q?I+YWWvdCvDW4Cr5DTiQAGwBhkDTU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7Y943EY7OSwXiJ8Hn6/BO+0aq/6OIuZB/5lAvtIOOV6V8B0dMn9+PvCopPrs?=
 =?us-ascii?Q?CP29te8X9wu2KBpuk9wk0ZpZteiHzpMKQS5VFY4OMQfVRXo2uZJ2yStmv/rv?=
 =?us-ascii?Q?DCbmkhN2eyVoYtbta9WcWjyNHEUprOSUjSc0tnoXZfVQGtSBfhSzJeDZUcfW?=
 =?us-ascii?Q?Ny67D1zuogU7yQqD5+JLq50bP3sNGdo9cmdXjduvwnDZZGCqXX4xjqX6Utzr?=
 =?us-ascii?Q?La2/scvU1cKC7qQL6BXe02wYwLvJFm41f37LWUA/ZD8zzcCkDQQ9oFDmvRkc?=
 =?us-ascii?Q?ygz67IfO5Qe2ocJXeoXBOPY+6/ZKGupcRTx/G+jnJSgpKhP4HoIJIzs3rgH7?=
 =?us-ascii?Q?jQbOtOdQzZgoCSjE1ZqNr3BYa5uXHCWcBUE1vF0qaJf3XBLlAE+xV88xesJX?=
 =?us-ascii?Q?gQLGjN0rsPuuPgiwAwvxZeLMYZpuQmRETY950MeKV3pAZuh3bdTFK+5W7kwG?=
 =?us-ascii?Q?GrkCbZf8/0PuKDtfYHl/XP0V6vy0r3cPVhhvng4lvW4H0IwbeY/y1oQAYMs7?=
 =?us-ascii?Q?lMLB1XTLDHWC5lsrf6Yntdxt5NKVURsDWDDPwNbaitOciPt9xvOaME8ENNon?=
 =?us-ascii?Q?3oWpnqG4yDbr+sHv4ieP8tNkYR6O3kdYfVHn255vVhtJYWxHjjN6VKOLCRFE?=
 =?us-ascii?Q?QXBCnEmOR71U418NYrYZMAHkCGziBSevkCiCTgxX5dOpKIFx9Np98EWt+kTk?=
 =?us-ascii?Q?7hGv5FXHfy8l5qpec6tf3ihravQccz+wO92k9r76CJ3xd1licHWsXZUjfwml?=
 =?us-ascii?Q?1ktdoykLRoltqEvZTNQkfo4wjc4CgiipEFyPqtXt/8FbQ2ZIFFO5+W2EVKB4?=
 =?us-ascii?Q?HlzKJ9rsboBTo3IcDYo00MMjSSLRBz78Vv2HZddhIBT9+EtPzL934lQNS2qY?=
 =?us-ascii?Q?1GR2CW/F+uYmabqsfJkhKQKRUZgqWzrui0pfKq4faBD9OLQUAovZRSLu73Pt?=
 =?us-ascii?Q?KqUz6nRJLAZ563puTZyA5+pyhRfx3yJAXBThaNNX1Xwm/qr8JVfe1gLC9WyL?=
 =?us-ascii?Q?I8pX1GqGUY88074VeiSfIv6FqF0ekNFzBU7tZjZWqj1ernoPHTYs+9fm7H8/?=
 =?us-ascii?Q?MhWEMz1X9IJMebcmxN/6xCoQPBw1vl33jXWhmbHsAfL299++bmGlnemXTRpk?=
 =?us-ascii?Q?rqGGKNjtOyTx04FPOPMFszHSJp6ygFGBEuNJfLtMKW5AgKX+QyuKCIEaXrJ4?=
 =?us-ascii?Q?JSI95pURGcvmJNQBiQA5fCbg+UwsdO2FcymJfwNqY3aN8wocWn3rxRJ+4cE6?=
 =?us-ascii?Q?v7ZxdTj9RPrgYqE2XEp1AAYq9XRcVgK0NfbLYAz5k6vp/0fa19H5/+nzihcf?=
 =?us-ascii?Q?uQi3B8kxeKJBkLujDx28IgecY6VzFAKSmOTRgruLsWMY3EW0+kGRNpcjRi8h?=
 =?us-ascii?Q?i+5wMuWlGX+sRIpqzAKZ2vbGYzChAYy+fmYvvEX69UWK1hoOl7ihPhyl8/Ht?=
 =?us-ascii?Q?8cN1a4FNH15HJTzNyfQdfG/+gqyJ7N9Nf6ys0h1uhztkwNh7+ZCSgItyeh4O?=
 =?us-ascii?Q?jVwr1tbXhMZ3luIHMryjm/M3TZF9z5X/BhG5XoYYSt8rUP4lz8pvSe+h0+eT?=
 =?us-ascii?Q?qY1CXwGWgWGDo71oQ4qVKu8+FF/m1ApCdjYIFdMXhy7bp7rRpbnrPSQX8fa0?=
 =?us-ascii?Q?fQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nkLGPk4hKW/xCMf3JXugb3OTN6TUrVnges0VJcDk6cTqhOUnTC+6SV98hU5wI75pJhQvaGbXXDA3v9ZPR3AJ0wvCN9ZAnIlBs2cmKaY5MfPNqdDdiBR7PuQo6xtKvDM2Lr722vZWz/xfEuadE6Q1VF51C9aWK62iJ7hIQMW8fCna3Z+LQyWROFOSoT2Kqx6QEwHka0JToRXmWomn0RTDAzieNMneqixPElNo67tPpK7b+drXcZ1XwmDoPZtMt6T2HSfN/6gjfN8OihC4IiTzYpV5jiy/7FDyIbHUewBoWzTKWVGzfrKW73smfkPnn0fWPuJLGr78c2NhcwOnfdmRN87d9/25cuxq9HYkbofSIr4zjDm9V5pudJBM8LtAlRdOkYP2JpqCtdb74a9dcU9MfRwxTI0rGSYdzhZL9y6ufY5YHbgECCzYE74gUnjWKbJVRAc6CJ65uSqxf2XWw2SYzX4wJNEifUuA5S9uZvhrtV2/O2nQAzwrRAOdrdGe56z3YirpvBnI0oXFWr6lcQQhFwWU17p8wrZ+ux3EPYf8sb3aOmtVoAcvM68xNYww1ecVphVaaLWHWjYKhQ+TNcF6qu7el4Iol5syrOmUmzfXmiE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e3d561b-4e64-4b61-40f0-08dd97b70592
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 15:57:28.5481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZfLI/6SKRxhhVGiWqtTKn0SvsQDorMOxddMlg/OeRcU+4Kyg/KVJQr+NOmSDwoxDluLqSxtVss8HdzNrHyjzcNVXngS8CHkJI0oLasrlVfY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8471
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_06,2025-05-20_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505200130
X-Proofpoint-ORIG-GUID: grTcoMWbI57xZEH-fkrSH8T-gAR4H3yG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDEzMyBTYWx0ZWRfX+9sWs7Z2STE/ 3/ZTPTHUm+qasuO4T7OdLsbQutCnfw4PjArnK54IEYvqZT76/nHB/VQgD8+Z4JwqVfpF00Up0ul Y0370d9V+aEKJbJXf08IaYcXBHHBwQvVcmzBjsuppmhVhUkTK+PGkXRvdxujmCCfF161G9jJ6ZU
 kuIyA6jxBQKr+fL26UbacfvIiZ6GZGPFhje1OrgNpZLk/nTNDminq3CAjT6r66/PHtm/S1xd9Ba NIR7XBAjFW3lVtz0EgI3UAsYxOUpT78GfbrjjTq0FqtM8qWBGAAsAxOWUYpBeZEFMVanfDVg/X/ EgSxn7B9Ltp39aONYBa3RDKnnauOA2A5LFSVAyA51IAn5FXM2T234/1YROd1woyifkY843D7SDQ
 OpHKVioucIoLSDgwJHY+/uHElemORM5LzDuqhE/+i3KkhUTtbHePmzo8BGlg1w0j/ccbwRl6
X-Authority-Analysis: v=2.4 cv=Qupe3Uyd c=1 sm=1 tr=0 ts=682ca95f b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8 a=TAZUD9gdAAAA:8 a=VnNF1IyMAAAA:8 a=vzhER2c_AAAA:8 a=20KFwNOVAAAA:8 a=Em7mLx9_1gFsGKEg3IkA:9 a=CjuIK1q_8ugA:10
 a=f1lSKsbWiCfrRWj5-Iac:22 a=0YTRHmU2iG2pZC6F1fw2:22 cc=ntf awl=host:14695
X-Proofpoint-GUID: grTcoMWbI57xZEH-fkrSH8T-gAR4H3yG

On Tue, May 20, 2025 at 05:54:28PM +0200, Claudio Imbrenda wrote:
> On Tue, 20 May 2025 16:24:10 +0100
> Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > On Tue, May 20, 2025 at 05:10:09PM +0200, Claudio Imbrenda wrote:
> > > On Mon, 19 May 2025 15:56:57 +0100
> > > Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > > The enum type prot_type declared in arch/s390/kvm/gaccess.c declares an
> > > > unfortunate identifier within it - PROT_NONE.
> > > >
> > > > This clashes with the protection bit define from the uapi for mmap()
> > > > declared in include/uapi/asm-generic/mman-common.h, which is indeed what
> > > > those casually reading this code would assume this to refer to.
> > > >
> > > > This means that any changes which subsequently alter headers in any way
> > > > which results in the uapi header being imported here will cause build
> > > > errors.
> > > >
> > > > Resolve the issue by renaming PROT_NONE to PROT_TYPE_DUMMY.
> > > >
> > > > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > > Suggested-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
> > > > Fixes: b3cefd6bf16e ("KVM: s390: Pass initialized arg even if unused")
> > > > Cc: stable@vger.kernel.org
> > > > Reported-by: kernel test robot <lkp@intel.com>
> > > > Closes: https://lore.kernel.org/oe-kbuild-all/202505140943.IgHDa9s7-lkp@intel.com/
> > > > Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> > > > Acked-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
> > > > Acked-by: Yang Shi <yang@os.amperecomputing.com>
> > > > Reviewed-by: David Hildenbrand <david@redhat.com>
> > > > Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > >
> > > if you had put me in CC, you would have gotten this yesterday already:
> > >
> > > Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> >
> > Thanks and apologies for not cc-ing you, clearly my mistake.
> >
> > Though I would suggest your level of grumpiness here is a little over the
> > top under the circumstances :) we maintainers must scale our grumpiness
> > accordingly...
>
> it was not meant to be grumpy, sorry if it came through that way!

Haha no worries, text is a bad medium, I should maybe have inferred a ':P' at
the end of that line ;)

But absolutely my bad for not cc'in I'm normally good with that... and have
moaned at people for not cc'ing me before :P

Anyway thanks to you guys for being helpful with this change in general, hoping
we can land it either in RC7 or if not as a hotpatch for 6.16.

We shall see :)

Cheers, Lorenzo

>
> >
> > >
> > > > ---
> > > > Separated out from [0] as problem found in other patch in series.
> > > >
> > > > [0]: https://lore.kernel.org/all/cover.1747338438.git.lorenzo.stoakes@oracle.com/
> > > >
> > > >  arch/s390/kvm/gaccess.c | 8 ++++----
> > > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> > > > index f6fded15633a..4e5654ad1604 100644
> > > > --- a/arch/s390/kvm/gaccess.c
> > > > +++ b/arch/s390/kvm/gaccess.c
> > > > @@ -318,7 +318,7 @@ enum prot_type {
> > > >  	PROT_TYPE_DAT  = 3,
> > > >  	PROT_TYPE_IEP  = 4,
> > > >  	/* Dummy value for passing an initialized value when code != PGM_PROTECTION */
> > > > -	PROT_NONE,
> > > > +	PROT_TYPE_DUMMY,
> > > >  };
> > > >
> > > >  static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva, u8 ar,
> > > > @@ -334,7 +334,7 @@ static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva,
> > > >  	switch (code) {
> > > >  	case PGM_PROTECTION:
> > > >  		switch (prot) {
> > > > -		case PROT_NONE:
> > > > +		case PROT_TYPE_DUMMY:
> > > >  			/* We should never get here, acts like termination */
> > > >  			WARN_ON_ONCE(1);
> > > >  			break;
> > > > @@ -804,7 +804,7 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
> > > >  			gpa = kvm_s390_real_to_abs(vcpu, ga);
> > > >  			if (!kvm_is_gpa_in_memslot(vcpu->kvm, gpa)) {
> > > >  				rc = PGM_ADDRESSING;
> > > > -				prot = PROT_NONE;
> > > > +				prot = PROT_TYPE_DUMMY;
> > > >  			}
> > > >  		}
> > > >  		if (rc)
> > > > @@ -962,7 +962,7 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
> > > >  		if (rc == PGM_PROTECTION)
> > > >  			prot = PROT_TYPE_KEYC;
> > > >  		else
> > > > -			prot = PROT_NONE;
> > > > +			prot = PROT_TYPE_DUMMY;
> > > >  		rc = trans_exc_ending(vcpu, rc, ga, ar, mode, prot, terminate);
> > > >  	}
> > > >  out_unlock:
> > > > --
> > > > 2.49.0
> > > >
> > >
>

