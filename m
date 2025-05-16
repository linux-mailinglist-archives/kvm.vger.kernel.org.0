Return-Path: <kvm+bounces-46829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30307ABA017
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 17:41:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E4541727A9
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 15:40:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A517D1C5D46;
	Fri, 16 May 2025 15:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LUwr/4+Y";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Lci3kHIV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61F71B4F09;
	Fri, 16 May 2025 15:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747409996; cv=fail; b=d2p2fXubuUB4TVHb3vNuJJfFU1/JmTbVhgnVGDtz87OweiEEFAMGANq0mpCvAAHBM5bUAGzxd5y1pC3QUsmIfgzeGfkkbrjqXAan/fMaaXu5XYXu5p01GrB+i2SatJxrT6jr+E3WRM/IlhvtoVh3MphVgAihq4zOHuO9EwXdwwk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747409996; c=relaxed/simple;
	bh=/wrIrNplj0BvfgWh/gdgWU5/YLwtOKPJaErkHiYwAhA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=H+HaH6u91tXxl8lIM18exxA8VZDf1oeLQLW76NUe8m+iJqdUDUnjVXW32fa56lJdjRVKNojQO9v4VmeNkZER4fG2g6eZP3x3CngWTDHYZsiCWiguGZ0yLbsdP1VgC+KhsGG/cV37QXQbcAV/YnYMn8wHPQagNumeHdty8QhSr50=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LUwr/4+Y; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Lci3kHIV; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54GF0hxV020301;
	Fri, 16 May 2025 15:39:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2CY+ZCJkSj77oKkC0A
	gTsb9SPLdFuaYk8lLmC4ODvN4=; b=LUwr/4+YW4ajJwWMhC6bPzUE8QGlQ7auPY
	fW/EIoCSDDuBmYIsWqel5gBkefWEYQ3WKeJ3dvwVt2TnKJcmhkzMTYPAL5m77ge6
	H9OGKnjZ3boeF7XqzNNEKaQo1fIiQ92vLKleRTE11LfQ3TvzjBHn82tsKGjy0hjr
	0eMIpxntazTP//x6nMJqSiRgmAYbuLy/mrq7cLWC0TeILpJWZzqHXVBXTpBCDDY0
	fXRH37GzVLHzuAb6G8+6oyIR6vhYwqHSMy+85QNuGCJXiRRngZ8jONzABmS0j8+b
	u6KX0FkK0AtZGvzHikRSTKC9mtxK7eEXGE9iAjvlz9ISeT8E4zXQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46nre01nja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 May 2025 15:39:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54GEsrNp026127;
	Fri, 16 May 2025 15:39:31 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46mbtard1w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 May 2025 15:39:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y0py5ZuDZrblErc11kZ6086U6wIlZKbETi+fx7DxJwX4rO8hrMtSi1OZerO5JL7pC1MJAVmXXvPPyv22bUn5csaJtYsAPUqvGbCeSS69XWiDjmBUS1IFisAdqmCS4vulKkwl+PYNO7F9lMvw3IT5x/bpVwNBDIcLM7pg/lpDcYZX/Z9YxR63xy6G+afIIXTggXpmsHDLWZW2IOswBojdpCpDg5ZHQkL2wgWh7rsxnfWbs1qNB/b0BcM1l+vvaGY5if2WEq9wi3zzxVmOTFZxSCdV+oo1lt92Yxeq40mjbVadT32Z2qUiC6gydBywQW8BEgUUCUcSyNP0A+mgbcRuyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2CY+ZCJkSj77oKkC0AgTsb9SPLdFuaYk8lLmC4ODvN4=;
 b=mkjeHZVcC7+DEyHJY8d4wBrDod5QSgWnIy56vJDZeOz8mjsp1Fgbm+Y/1XT8Djpct25GzE/JBFKrCKSBSa+ZAbfnXnSwj7ZyIRxNjeL1motB1QaLhLojyjlK0BTwBqEvzqHpVzswgMQiMmXLcPtKcM99W/JAkQBvsc3zQVEn5Y6hAQRbRUziKvbCagZP4u+WoHuVYjcQUA6OvPLYW+TYbLRbeQWvPmjShAz1XRMKVA/nDsmdK5kcuqmo9DQrbU6/DNCX1d7OnA1GsqaJqKChRmEzKMC1xW2oT1cz0IkOICqHzUZJQXm2VvbT69yIzxoQjhRliUmKQhxTaSQESsjFUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2CY+ZCJkSj77oKkC0AgTsb9SPLdFuaYk8lLmC4ODvN4=;
 b=Lci3kHIV4BRk0D5AaQ0NrMu2F3JGF2yp6rQ0D/pyIx24ggl4gPM9Jj/thRoEv/fb1VMabDrhESQpdoxnE+mlGj0FAJ78pm9YqyhDuKv8RDTS6KOKJEjxbNBRFDpbmP+mT+N5+CCLp65kHxF5lB9UnBqMP9sdAUZVb7fGssDVVj4=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB8173.namprd10.prod.outlook.com (2603:10b6:8:1f9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Fri, 16 May
 2025 15:39:23 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%6]) with mapi id 15.20.8722.027; Fri, 16 May 2025
 15:39:22 +0000
Date: Fri, 16 May 2025 11:39:19 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Houghton <jthoughton@google.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>,
        Yang Shi <yang@os.amperecomputing.com>,
        David Hildenbrand <david@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY
Message-ID: <fka5tjy7m75csanhm5sbagzp64yj7rc2hlklvd2qolesjjalx2@bkx4ul3a6byf>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	James Houghton <jthoughton@google.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>, Yang Shi <yang@os.amperecomputing.com>, 
	David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	Janosch Frank <frankja@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1747338438.git.lorenzo.stoakes@oracle.com>
 <3cbd58e6fb573f9591b43abeec66e6e2f3682f7e.1747338438.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cbd58e6fb573f9591b43abeec66e6e2f3682f7e.1747338438.git.lorenzo.stoakes@oracle.com>
User-Agent: NeoMutt/20240425
X-ClientProxiedBy: YT4PR01CA0417.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10b::21) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB8173:EE_
X-MS-Office365-Filtering-Correlation-Id: 7db15255-e415-49e3-f9c2-08dd948fd4c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QbTdrxEZcslJjGulcnTmoRdl3xllkSJ5AAhJGINT10oRJ5ysNsCUi8ZzZb/j?=
 =?us-ascii?Q?pBLGcqgr/No6He745DNH8/FWSDtK0VmoA0PG/hVLR7NRAOdAVxZplFCTt0M5?=
 =?us-ascii?Q?siIxkq6NUxL8g31AdXuNIbPSaHcekVhejmYoRoJT3K9TnYVtqnMP1/cx2nN8?=
 =?us-ascii?Q?GgzYun0678OzT8uiXIE5NlfSeUt0IfhnOiLBoQUzKp1hm10CTqV7SUpvX8Pp?=
 =?us-ascii?Q?jOLaDyi5fUgtOGo8coq8eXK4KBJ3bsYKFPGXP5wUJFZEgI5V4ozsjI2T9xFr?=
 =?us-ascii?Q?fj+GxFpe37I6Cti2OjB9qs/cDue1EoqvCulUudTLytfn+JkZSTTdr7HtueZM?=
 =?us-ascii?Q?moAOMaBtvlzN+x3++agoJyE3zSnl+NFBX8bg7SxDpL0m4TS6zdwn7pKWwbtu?=
 =?us-ascii?Q?r10nsyJYHA4PrqSHJlF3YbLVxtbeBn+/Eb3kK6+tCf3UYzpNeTxFCFd1xyoz?=
 =?us-ascii?Q?S2UOdgpX1jP2E2MtruWKJgR910ThcVk4qLcit194WHd16rEOkAEc6OAkm4CO?=
 =?us-ascii?Q?kFevceR3OX+VJkGPmEGfn0g7OPnnns1cnQphhV+ncC5CnDpvAs/tSdq3v23k?=
 =?us-ascii?Q?Lvpz3/sw6k2wP8X5NE4v3hDteiLxqqkwrESb+YTKGTNDk0cvMh7gaj9mXEBL?=
 =?us-ascii?Q?U85Qtp3761Py6faTwLvOeF32wJ+GG8GZudbQYIRtG7DCw3zx7ebaIQLtLPSK?=
 =?us-ascii?Q?oB2My0VjA5/rA0FIhAuUh4ueBfIQgkZQWZtultEnRrAdGnhqtJa1W2FXeX8P?=
 =?us-ascii?Q?JTgx42dgBPc2Eoajyv39Kh7wc8xlCkex+EyJy6scneL3u5O3dysMPBVklOyg?=
 =?us-ascii?Q?ZgfMY8noIINoWA4s6Vb9DnLYvN3lRCffT4HS7nGTrEV/8athOE2S9ivgEqAI?=
 =?us-ascii?Q?X0Kfh2YRKdQVTp7MUfn10PcYdh6s9YDF3yqpxBU4YmlEKk5N+9jEEiW8R5tF?=
 =?us-ascii?Q?I6o0qNp+v6LyVBaIY1uPXAKDj3ba62mqREOPweV0PnxxVfOnSfFCOfd8mOHW?=
 =?us-ascii?Q?CXwXfQQnzsWQlM4hAxFnD9docJc99lOfX1qEx5d3l7evz9qZqtGKf3LKgjIB?=
 =?us-ascii?Q?K6t9bhj+sFiH1ModDH+bELXbRPCuR3QAxNbqcDoxGsJ+BuT1f1wplffqlqgP?=
 =?us-ascii?Q?wZ9RD3qtxY3yaQ2x41Kw4k5hSYYnRoQ8HVadS5AaSAXpoPNpwJ7GpmNylndG?=
 =?us-ascii?Q?4vReTkRyybIZ71+8rgSG7OrQhmWQjSnNeQG8GWdAdXk6eYSlTHRM5Dvrk6kK?=
 =?us-ascii?Q?dv5b52P1aLPgN4GI0PTul/Q+wSIubWz8xy++pcFvpZU5kuHq1N+KX9EtV6O0?=
 =?us-ascii?Q?Tsuq/BDsGF+Gwz9u4jCvNSA1im4taX3tcdJb4+2t1697LU3aShDoQVJhG4pt?=
 =?us-ascii?Q?PVC/wWBSxrNePOrnQ0J894Uzu9wpoDMbCAjvS1GDAuwvbmLt+55On4/k4jgn?=
 =?us-ascii?Q?mNIxFQ4wIBA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ChcAC6xPYcnJKZ6CnviNOwi+0xU407dP2A9mQkZemM1/lxKDg2dcVPH8sksO?=
 =?us-ascii?Q?KsWaZGJjqmcQf1FgSzc19NZA6FbpeePIYX8dvOYHFBEEd71wbRLbrYp4VJ3J?=
 =?us-ascii?Q?SsGKPBlyytjCkAQVAikFkya/zWUoAXvskIV9cRxK+RlLOqJ3fv7ZqTQFtMgy?=
 =?us-ascii?Q?KQep4aL2ZkJ+F2lI63rYbKU3rnQA/6kbqqq8ius7lDHCrIRZbLOOQEYD82I2?=
 =?us-ascii?Q?TUZ7BfBq9wCiEjZmz7XyM9omtXTm9ngzOj3r+roXnq1iRMcp4UTcW3CvbO+g?=
 =?us-ascii?Q?gIRklPR8uL/+Qxm7io85drkDMIl3zLEDxjZOZ/h7zctmJen23AUsbm9ZW/kB?=
 =?us-ascii?Q?X62+Z8FCC8fzBPMh2T0NsgnX9hho+iKDAdegj6PDp1gDVOeGr+JGDoeIJ/Az?=
 =?us-ascii?Q?XQgJ5xclulKpLWXTmI01ueGFwv+DBST+Q8Ognrm7C6QRwVlW1fFhV54ogTcJ?=
 =?us-ascii?Q?vXzUvPnM9ehmWKuaWo0nwr7YdjPbMkNC3weOpmeXUjN2YFYZQPCqxBa4x0vz?=
 =?us-ascii?Q?kE4/vLqA61hbml/s6QiPJHhqC0DH28AB0XxkA2Ja3uZq2ekhqkdxlrXZr41C?=
 =?us-ascii?Q?+sxAbHwTvMFdmDjBHI/e8DQMNcwTuJ6g1s6IaS00Y/4cc8ojAWka9Y8wpEzM?=
 =?us-ascii?Q?TUGuEarijYwkVJyp7T4/h7NfO1WAQ8qiBPCSwfmhavTBTpfJdyBXkiDV919w?=
 =?us-ascii?Q?YV9HiDP+grY6HwQINSEAOs84hPbtsQOv1BtrtqRU9NEbngGKywq4yBNU4sDH?=
 =?us-ascii?Q?aTSkXIOgz2nQwWeDM99n19GXYkLXSE6EPSWHBQlLt/9is+97l8cXukLsaLRr?=
 =?us-ascii?Q?8B6QJ7Awov4SSHjacs2gl93pxXX+271yK9iO0II1uyiT5S6nbjs5gfpke8Gx?=
 =?us-ascii?Q?r+AhpnOn3AcDIiJh5xrxUb5gPhhJexsBz6GoyM5aSID3zxORiv0IT2IGz0MN?=
 =?us-ascii?Q?+7if0oEn0DKH8YtZ49SnkH69oLqoGiFkGxLcbQM/S7Za/I+Fq5H1eTIQ7wZy?=
 =?us-ascii?Q?4TdDZLVpKAQ+QihsUVLlVwyV/QtSMMWqL/Yi0bkxTaSL+qu3VR6C56lxm1ok?=
 =?us-ascii?Q?W3cKkpjUzipXASprG69JYQ0sQEgJZ79dzHxrsNlIbqWDGghaCOYEKi98Qpap?=
 =?us-ascii?Q?Kgrbl45AyqUkU1yT8cnlNAZRACJlHtFw0CgTYv7bBDK/tuPz2wZ8DR1LWxmT?=
 =?us-ascii?Q?xjj8OOGOxH1aasQaeR9gcp/P9c6sl3WmiVboDZfANEE3qfrvb5DgljdDn4Fv?=
 =?us-ascii?Q?4u1QAAxPJOA2G70BuyR9vV83b6uWh+SB81J/TRrf/BTMJzyRm3BSqbOsu1oa?=
 =?us-ascii?Q?0Eveq4sg0NPwhhP7r3MCJ8GdKC3Y/cOz/fupBEweXk5y0DC1yhZNJioqH8QA?=
 =?us-ascii?Q?KdnWqzZrHqmibyRtvvWNqnRhMr7+yLKMcg4QtEJMDZbiGNdscbR1/xLCEo0H?=
 =?us-ascii?Q?cpNAmWT6KUhTNeRhvbnDyOEwEih6Yo5nL69SdP1cWIXAy9Tyb6dccSNFu6OC?=
 =?us-ascii?Q?X4GHMnIiEXctt4DRmxHSpDhSH3SAOrXKEC6wqaamSKsDOHPrdgNI0nDI4wXl?=
 =?us-ascii?Q?8RwuVCFsXNiEcuk36LB2xLb0bckE+E/NJBjy6/1b?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mgs+8ZD+VbodeWromJoX7vXouXvRTGQwFDA3O5lXcqtaSR6dA/B0I1pBrNP6UoSKm373bbWyN4qkdCnz9uzJX4GnWzZMMnd+gsiA0BNAEKcucXCqkrS0D0858an68xb2A0yDSzJRg8KlXyDI+RsSFg6w1ifZ+mpuSxdVWqWi8RcVcrnbAlAPv8LKIFMikSoBP/xW0fi6+0pgeD0PDN2iuVSrZZ5jUJvOwTVkMkGxXrZYJ82iYiW5kRZPzTagLwkfwDrOC3Kmcn9Q6Ci1mWvGMkC2kIXqmzh+IZLKEGnQVVVhcyT2Y+/iU6uAO3A/ZVI4s1WoWMHL8iHqGM5MquGTmBhkrKvbv+cAPC3Xo8xV975I4VMp+oXlLSLL7E/l/pbT7oaryY/r5lkVm4Qr59pXe/vzqbHT7MSrQy/lSqK6qWkWrt9syGiMgxqSXzvVggEGmZsNzEMML8vjcJ438JD8PqyhXp0jsbQnnSjWDR3RXTy8c1MqZRe6soKGawIEjVVYWLRJdVg7jqQrvlYfzln4z+A/DFTF3v9bsDsVifexQwkqvTyYcE0Fvd+m/kLE8clTwdxd1oWjZN876Y6LPDoye5P3p1bx7nfVRnEwniNEvhQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7db15255-e415-49e3-f9c2-08dd948fd4c7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 15:39:22.8828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FRhPpa+wY8OetoN+Vkd0xeizM5rCrtwGCfwKvpLQrXQ/ynMHjOD6iTQSUXxvVtzR54DzaqTBXRCiBgH4DrrQGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8173
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-16_05,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505160153
X-Proofpoint-GUID: 4dWwFwenUX9_zc9S0QLnwA0s9smKudjI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE2MDE1MiBTYWx0ZWRfXzNlt4g0oRUyb cVlZLB4Dz7ieK23u0rFT3nHpJp3IVD1dKr/2m/Deo1lngssS65kt3+1nlw3zDZVxMVAZrhc9Ib1 FWO3kjVsk4lCR1js6SWulVSfeYDGofwTGiSychexhDz8rKZI89oCIV56lsK3x+lhx4a7c1idpob
 GMxnMfXoyUqumDYJxhUcTKu7eAz0vCE8f6A+IMVPpu3PdgsKLc1fsRK+K/VOoYb+pdcrL/rjbRD 2pPgsRiYJG8C/zFz3dXKDhGEvd8cYue8LTYwdQ8soAwSLiH2PNLfdDT5DK8TwVj9+CqRXRZ6ixq f6Ezcu21hLF5mZhz6Ylbi35KYif4OVL0CeHha/mP3zm2ufxptiLOQL4WhxYujQBjRaechjrO1AJ
 AfjdfSbXV32JsSCMakj34/5C22da5cAZtOZhMlc4KQ8S2NGGlOU1TVqATxlo8WHVDajm3fNX
X-Proofpoint-ORIG-GUID: 4dWwFwenUX9_zc9S0QLnwA0s9smKudjI
X-Authority-Analysis: v=2.4 cv=O9s5vA9W c=1 sm=1 tr=0 ts=68275c35 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8 a=TAZUD9gdAAAA:8 a=VnNF1IyMAAAA:8 a=vzhER2c_AAAA:8 a=20KFwNOVAAAA:8 a=qOAbiPNdiR3Q5f66-8UA:9 a=CjuIK1q_8ugA:10
 a=f1lSKsbWiCfrRWj5-Iac:22 a=0YTRHmU2iG2pZC6F1fw2:22 cc=ntf awl=host:14694

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250515 16:15]:
> The enum type prot_type declared in arch/s390/kvm/gaccess.c declares an
> unfortunate identifier within it - PROT_NONE.
> 
> This clashes with the protection bit define from the uapi for mmap()
> declared in include/uapi/asm-generic/mman-common.h, which is indeed what
> those casually reading this code would assume this to refer to.
> 
> This means that any changes which subsequently alter headers in any way
> which results in the uapi header being imported here will cause build
> errors.
> 
> Resolve the issue by renaming PROT_NONE to PROT_TYPE_DUMMY.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Suggested-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
> Fixes: b3cefd6bf16e ("KVM: s390: Pass initialized arg even if unused")
> Cc: stable@vger.kernel.org
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202505140943.IgHDa9s7-lkp@intel.com/
> Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Acked-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
> Acked-by: Yang Shi <yang@os.amperecomputing.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>

Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  arch/s390/kvm/gaccess.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index f6fded15633a..4e5654ad1604 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -318,7 +318,7 @@ enum prot_type {
>  	PROT_TYPE_DAT  = 3,
>  	PROT_TYPE_IEP  = 4,
>  	/* Dummy value for passing an initialized value when code != PGM_PROTECTION */
> -	PROT_NONE,
> +	PROT_TYPE_DUMMY,
>  };
>  
>  static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva, u8 ar,
> @@ -334,7 +334,7 @@ static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva,
>  	switch (code) {
>  	case PGM_PROTECTION:
>  		switch (prot) {
> -		case PROT_NONE:
> +		case PROT_TYPE_DUMMY:
>  			/* We should never get here, acts like termination */
>  			WARN_ON_ONCE(1);
>  			break;
> @@ -804,7 +804,7 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>  			gpa = kvm_s390_real_to_abs(vcpu, ga);
>  			if (!kvm_is_gpa_in_memslot(vcpu->kvm, gpa)) {
>  				rc = PGM_ADDRESSING;
> -				prot = PROT_NONE;
> +				prot = PROT_TYPE_DUMMY;
>  			}
>  		}
>  		if (rc)
> @@ -962,7 +962,7 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>  		if (rc == PGM_PROTECTION)
>  			prot = PROT_TYPE_KEYC;
>  		else
> -			prot = PROT_NONE;
> +			prot = PROT_TYPE_DUMMY;
>  		rc = trans_exc_ending(vcpu, rc, ga, ar, mode, prot, terminate);
>  	}
>  out_unlock:
> -- 
> 2.49.0
> 

