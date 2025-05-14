Return-Path: <kvm+bounces-46519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA985AB7194
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 18:36:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0818F8C4B30
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 16:36:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1318327B4FD;
	Wed, 14 May 2025 16:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n/SYoJni";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="icitgrj3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F0D270ED7;
	Wed, 14 May 2025 16:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747240601; cv=fail; b=X8o30rZkGJ6NhJP56N23Gaev5Qs7QIh52KbXu8FgRXGAAXqtnGQ7IROGjSbtwDgl+gsktIhCAG24bsr83a6hCt5N+b3id3nb59n43V2SJ/qQwU4UrFIY6/4yM7+pnIgnCuNPuHXXbBAswDKy3MJaT+WU/XoBkU+Y8RbA0XOw3h0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747240601; c=relaxed/simple;
	bh=YDPPqllyHe8QeRk8EDe66kv12vvTCcht8QFpT7i3lPk=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=WEIOe6il+AUT67XO45L8qgqmhqo/Y/PbX9waiB4Sfp6xWdwh3QByqWVl2Wy/DtX2XbFK5CSyi8hEUrj1Mnc8eB8VQmAORk4dnvQLHDNqIAXxlYof3tMZNnQreuu8GmrR6e4jMU6FqrzDB3gzj+48Dy64Ks0C8yiiwq6IGwFYiQg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=n/SYoJni; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=icitgrj3; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54EDhs6t010755;
	Wed, 14 May 2025 16:36:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=GSXLq56UUbHzo6im
	BhhlPGYJ0bnRgWqHe9aHz3WPEkA=; b=n/SYoJni1onU9d6bBnPZcWMeA6Vsmsxs
	5Vh+ukSYtjKuzHZFRwRwO4au4oJyvKZ175q1DgokgZsm4bUSELEWeOpZ0gHYCBdA
	R87YbMO7EVau4oIG4PSaYQux4tAXWceLk+iv1bB581m8xShr1Az7sqZZGlXONpuB
	rzR2nWXw6UX91r5QJxIkCFAObHLE2h1MllOkdjmEc9mCNjSwQyRJfcnuX7H63Yrp
	m6y8ndkSsaex9xQMJ+xZdGWMFqctUcOT8703uyieS3wqnBDqA9vNvQK2pdRkiWsJ
	EO1Kj1Inm3OzVCo49ytDxJFSnShKPVB2OV06V4w+nn3AeAWe1eUfiQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcdtajs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 16:36:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54EGGKRf026220;
	Wed, 14 May 2025 16:36:14 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazlp17010003.outbound.protection.outlook.com [40.93.1.3])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46mbt87vye-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 16:36:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U/aVtUO3jY17gdjC8zmK3OnmrSGlX1U3qLcTNsTgR5Goqm8SQi0ry54iKzUIAU89qtbWAHv7J4yLQdnwI1qatr7lMiJopKgYA/7t2CrgseXm8GTJpn7C5LgIQbOymXvjWIxzhjqpxjhrx9PYwVXeK5GtY7lfNYQG3mQ4yqodEjbtRGlqwUHNNb6PTbGGISzMWg8uy+zVafcGH2WYT+etDZe0bEKoWtZGLWV68Z/XIwno3ybrz/kNuAiu37Cyk8B01T5K0gwDlFtbhmGqmauf1g1I2kTs60rGgsZqpEmORQrWEkNnIJqMNT+cNJFe3ksIdGnHOaJDpsIFUR6DNvYMow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GSXLq56UUbHzo6imBhhlPGYJ0bnRgWqHe9aHz3WPEkA=;
 b=TEXofa54KpVE9qnakByYBKMTupUuFNrCYy0KD46cgDSFJptTngsQWeHSAZ6bAriPs961Ctq1iTyCKwETmIfeRsFy8Ymp5uJ+oRgjeQqrFO24Uk542+hkMlJhShDSqvjG5qfdd+jdqBpo8MLG4epByF/FsS/ANZiLuT21NlY8mkES2/WzxwKMGcuutnDNZK9PHmV/DBOdrpGmlFFvkVUCIviByr699wtTQPHfOfPc/g374vPQT3GBWk5kllueaRTkXVtRH4RF8ud1P1ysgQ1i/uf0H0KrbFNYGZmMsl4lczL6U5sxy+F+CgTeBLfvTNFarsz/qRYruXQtvxjhqF+h2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GSXLq56UUbHzo6imBhhlPGYJ0bnRgWqHe9aHz3WPEkA=;
 b=icitgrj3W1d/9dCyfshxv5oSM9NxlcLbllvKa17Km6h6swaFfwU636OX8do7akTrrmiH+vcR6u1VnjwLBU3MSg+b+7wh54az46rlFeEqRl7/YnBn+xjWv0ZTdh0bKRR/cOf1o/uylNSqjjZPTY8tyoszRgPMcHH7Sa0Ox2Qkbm8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB7498.namprd10.prod.outlook.com (2603:10b6:610:18e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Wed, 14 May
 2025 16:36:08 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8699.022; Wed, 14 May 2025
 16:36:08 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>,
        linux-mm@kvack.org, Yang Shi <yang@os.amperecomputing.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
Subject: [PATCH] KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY
Date: Wed, 14 May 2025 17:35:30 +0100
Message-ID: <20250514163530.119582-1-lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.49.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0270.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB7498:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c43e045-0427-48a5-c883-08dd93056df4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oDK93S59DPzQXXzgdOKlod53jRC8JrCvdRObMjLsq0Ag7V5HfKV47d0F6wlU?=
 =?us-ascii?Q?qOZMbvqaehx2BSefhAkw6QDu82eAajwgOzwIAVrmvKsZNsaiqfrjzQq5x43j?=
 =?us-ascii?Q?s1xRbonp9iyUsk93BJtqTMhU5h0scTzIWEHVfe1xwjHlMdh0427qhdHRuAsA?=
 =?us-ascii?Q?kU/1Y+RXCTru/arZRcrYw5RYeXuVDhDkxbY2ka/AUaUUOQ1Tsm2LAWBCsMxl?=
 =?us-ascii?Q?pCRvsWhwOTxMuGy0gsJmqxNBXz9TiK4lAEHEXo5OREh7DT4pBzPHUJEvhICc?=
 =?us-ascii?Q?PnGwsnI0FZkk53V45bGaG4xcZ2ZkQ1YGlT72oxWWyXa3gmGXPOFJub6B+4zi?=
 =?us-ascii?Q?r44jsX1vT8FlzPx2xlq5WA+TvmK9vfFgIijn0HTWeFvlw7owXadEe8gv0IPl?=
 =?us-ascii?Q?F/Ei58i1WiT9cKfvtFnqNVU574lVwx/U4V4BM3DtX5379FI61Oqvp1U5gwi1?=
 =?us-ascii?Q?j9W8fDFnED7UxWqA3o9bjFeWg1Lz2c58GEUVO8ZuYuGyjmx5rlFOlymX5rv0?=
 =?us-ascii?Q?HQ6v+gwzPcJiflQPo2qlOzgfCGvUCUjh9UHiAhAyrkGfebcyn0QfR+rqtry1?=
 =?us-ascii?Q?DEcgxPhgW/LGhYgD59t2qU/ot88ilc4CvWqMvTTN3mCgy435ER2O81c8AQ23?=
 =?us-ascii?Q?zoXzESiaJ1ScSpQISPM+ykFNlGU8omjjOrfudrQ9jfrX2CsQbWyLlohuy+Nu?=
 =?us-ascii?Q?WOCGPc1fBRISji/wK7Pp3h4co3mKegvyL5KRo8d0rYF7sCc4sxGU4KOQSH4y?=
 =?us-ascii?Q?+7HOrxkciZv7qOnV3JFA2VJILR7HEukyxw7E31tC4/P9lXOIwBNKzDlsZLsr?=
 =?us-ascii?Q?/Ez2c2JmPdEem//Ojq59QKS7C9/e0X64hla7EHwO+c1gZJfhyb2IGx6UrMlZ?=
 =?us-ascii?Q?tdpfuKkSqcNy2YEmuUFBIV3KSzIynfwU2+Bu5dY5cISJd23Ocqj7DkXtTAV3?=
 =?us-ascii?Q?1CkCzgYQbF6HaaAwAy75VEf8ENQcJBkN4sjugZL5AXX/m/L/oN4TVfp+okEM?=
 =?us-ascii?Q?BRiAF1l53cvjw+GtY7KHZuVUr86xGMp7DDXj59zJY8m/nn3x8YxoQyvwFJd6?=
 =?us-ascii?Q?hJtDSef7dhzO/q75j9rQ8hVA+mmXVEdeGdvRvn8hs+9+rC1Cjv4PTGDruQK1?=
 =?us-ascii?Q?OAhhfjji4wYIpJdGKo4pjXCKQ2Yv3ULPfLlytSE7NhMr+Zw97Kgr79JCQQdv?=
 =?us-ascii?Q?IiToqCm6gQc6gaJqPUlvrsrvf7efttvM0FLY3cr+8jb1U9YpRtFgvT1LYQ1n?=
 =?us-ascii?Q?uP1EdmNl3H9e7b5r8JoB0NdL+J1eRYKpiFBW0MyzRwcfA5YVW8yuxtNFciaW?=
 =?us-ascii?Q?ZdLrPndkKxesvqqHX1hIoPU6GRRoyKUDqqj6zayEf6bvK5jTBKX5hikEmH/X?=
 =?us-ascii?Q?zyg2P9FZtDHqQlJ4wXQbBStJiIjd?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xmGZ5KlZFqxRFg6Y54hXTSzcQQitHybAQQiA/4EriCT78EIzoll/rI9sYv6V?=
 =?us-ascii?Q?PtV7YGQMV5splKUro42GWSqBxfrfVKBEPipda4ixmQr4Uymh0hX/0aihdt8q?=
 =?us-ascii?Q?cyxRhfINHuxp1B5wQvuiOC9u7evSntwLELnId6cbj8+hw6/M1qH4DBxkLMwq?=
 =?us-ascii?Q?UEoUvQOpJVwmq/YbHaoIQyQTMdchYKwPkNnMkVg/q4HaXhFqBPjdU9zHTDA3?=
 =?us-ascii?Q?VUtCFk4/o4wXMa/Cbi6nUCzBg+mJsj/Qd/jLZbDMUt8kU0ftKj6O6nJTcYRg?=
 =?us-ascii?Q?m76e3FguGIwG+gpCb9XdDA0AP1pvfH8C4m/F9uuwctwdPc5P0cuh4o5RgCWj?=
 =?us-ascii?Q?aprqJ7e27wigd5e6f4lUJ3sa+TrFEGTeMDTbU0QVW2ALeOFSAaqC3fQQ3PVh?=
 =?us-ascii?Q?syalg4nbqJ1IqIhM/nszdsgijhcky9SuHR5EvRLoEAFkAViFM+xQxbtuWIAM?=
 =?us-ascii?Q?hQZI7RK/OIlEXcdcTryyybjsgkqzyix3tvtWPT5iwTX/9k+MGT4Tc9QqK6qJ?=
 =?us-ascii?Q?gFLfrkFm79r1amV+JzDmiOBpQjmU7SXU2DhlTopj70PwfyRW3oSOEnXelmk8?=
 =?us-ascii?Q?doFzIKP/6ImvjjmP4wjkEYCNxrVulkKgLnuFJL1VZzDFPE1fGrwgdcdVrnLg?=
 =?us-ascii?Q?myPsyCuctLusIm+PEienXevmzo4DNf4e30NTP7eKzt6ECVG43hr3w+b0XsaZ?=
 =?us-ascii?Q?nnWy6g+YdwJiQmbCpcXphBipuRUVRBXoXiag4DoxLZtUCLbyzWwel8Y/w3ez?=
 =?us-ascii?Q?vawVcBm+p61yjgwFoYWuVYX+8hxBJgtt9hHo9fD5SAExmNt3qdWjeppFjp5F?=
 =?us-ascii?Q?tg1icAG3PMpxMGeZ18AzIMAUaE/rn/YMe+TCGZlFb2ZefUBokeEb4ZYX02Mk?=
 =?us-ascii?Q?H1oZ7JoctZ56l/48OC48bECeMQdYXKSqxuPBRg026S+Pc+PfAFUlDN+0u7z+?=
 =?us-ascii?Q?efIMak8DJfFVjN5m77yQHWH5IhdLv6XgDjDtXGoYrxpdqvwOGxo2qRCiMTUx?=
 =?us-ascii?Q?254A+Ita/ABJeTh8eTuEmx42gl9nmBuFGapjm8ucxp385g62q5m7mHpC7ePz?=
 =?us-ascii?Q?Pe2dKaMWBMvOL/ae/662j3poU1NK672NjjaNIZYpE+q3CI4p6lk3uvXNe4o6?=
 =?us-ascii?Q?ZJQux8vHRP/4s4DM/4zXdLOBQeXNhlgEYSHgkLy0+bSRNe7HqgQy8nYWYcQ4?=
 =?us-ascii?Q?7aYxxpOqf2+ZYHouAKPXomskpz5Ry66B793VWg0LKY5EtiBL6mN6LXgts1FA?=
 =?us-ascii?Q?98uBdyBgkdUn3QeaVnNNUwPwgsjvVkNCW1gFRqswK5CO38rWCjyWD3r1e8fw?=
 =?us-ascii?Q?hMBL9fnS8pr3gwTb2mdIXGXtptDz8Ily597l1JFw+5ub9z+jRSduu1IfhDpW?=
 =?us-ascii?Q?EdDEb2HSJiTRKkf0pIqGQ0M2Q06MRIDuTuQYdVcwqxMQ+/sowHYj28UEll5k?=
 =?us-ascii?Q?FzK6vcdZyX5GOit6SdISwp50nNj54hP46aG2UrXKqopiQVlt4XnJP/DlcDgP?=
 =?us-ascii?Q?W03Qsg+SHabAhxARC30vN8j5iYGaV/YQUnPvNOdLhQe/UAg+P8/7dQieR6R7?=
 =?us-ascii?Q?7SribAzrI3tNKkYLKwZsR6lLVzrMlC54gW/Y0l8xYRlCXP1aNAGKickdOBGj?=
 =?us-ascii?Q?EA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9kIKvfdkNMuHA0zhJdIMvRqfX+uEAEhYbP2UMuzLM+mtqipr2/lmHBTWw5+OAlzDJf3PX4r+JmzN1tTBy48Pq4uEHN6mx9aDwF8RdFLgta5b8PF36b0yvDK1jDNKhIH3PaG/DuxooqYTwBAatT9h+HUjf58DjxevFXRU4uS8K3JGlDQYXXEwxkZBV3FIctkFD8azUHU57xD+F/85sUaDj3Eqz9mTtfeZMx4pvrQn7UWfj6AZK6812wjs9kEDc7oVpvzzugrD9qG2SZbd0xhmMdhU2eTOBzE4npnexFLCXnKDHKEIqrkbRbHsRtNPKAQZyx4xTeDc9WLEl6uGFeBlqikPEcvaubFKSRS7RqqFyrIwkhGJ5EknTKkf/nkUtM1A0g4jAF2a1EzyJwgUTe47jiIMvn8g1pYLimWmaCPDH4K7iQrgAYDFP1lM+D9WSuwQETH6u8nITMnm7uV+A4c/P2puDim2cPY7KmeQ6T6xTQBx38iCnBF/FuiG5A0YDacgrP/BcRWlbshA9KF/XOWohJ4cyP/oue24+eSmTcOlHBNesIf6Y6HR6mR9kUZsaC1ogtYqh5pCoAJqb17swy93LEWcTVRwWyjuRc5athKbLwc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c43e045-0427-48a5-c883-08dd93056df4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 16:36:08.6125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OCF3DQF5D2UMZNjb0SsUdC0w5BGdOhQxduSEUpmsKCRszMaUzTW85fCirJ5kKuaPGu/PA88ZXlwJCjHZ8MbIHeJPgJhO9iQf3Q91ifJ1MIw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7498
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_04,2025-05-14_03,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505140148
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDE0OSBTYWx0ZWRfX7ovnf+WFsKF5 LLRfTY57hDCCMwbDkbvC7jaN8C0Rr1KcyxdtDxKFZ9afRW1Ogbgy4agdd144wVz8BsJHLoo6MQz +ePv7Ms3nuAjli+hTURZzzuSOEizIAyLub2cmuRIXWS6/2gPF5K5B27K9SsWfv4tURUIL2SnnHk
 eOBFDFi4x08sHi5XpHe/dS3z5xpCXRFw8f6M6qiIXoE/0UsJsla4L0cj44ZeXEcOHf1ZUSvttgd AHHbaDx6diJX9ho1a268LKxGlN3yuWcBFdFvnrtYDCAi0SJm3E271dgiMNR71UB2OFgOQd9hypc sEisRbuPG5yDvheDv4chlpbyLPXQd/eZHAShs8UuYnhC5bK1n//+09J15BePBJl5c1/jpWxs+um
 0JF0r5nUN+WYm2QUKQ2QkrN47mzjE4+gcn5Nwktan+aiGBVgOWgUKFzK/F6VA3fC59Y72R7x
X-Authority-Analysis: v=2.4 cv=Y8T4sgeN c=1 sm=1 tr=0 ts=6824c68b b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=TAZUD9gdAAAA:8 a=yPCof4ZbAAAA:8 a=yLvXmp3QQ7QdUHR_PhgA:9 a=f1lSKsbWiCfrRWj5-Iac:22 cc=ntf awl=host:14694
X-Proofpoint-GUID: tlV8o1QiJyQrT-wHeZapQJq0nTHi_4sO
X-Proofpoint-ORIG-GUID: tlV8o1QiJyQrT-wHeZapQJq0nTHi_4sO

The enum type prot_type declared in arch/s390/kvm/gaccess.c declares an
unfortunate identifier within it - PROT_NONE.

This clashes with the protection bit define from the uapi for mmap()
declared in include/uapi/asm-generic/mman-common.h, which is indeed what
those casually reading this code would assume this to refer to.

This means that any changes which subsequently alter headers in any way
which results in the uapi header being imported here will cause build
errors.

Resolve the issue by renaming PROT_NONE to PROT_TYPE_DUMMY.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
Fixes: b3cefd6bf16e ("KVM: s390: Pass initialized arg even if unused")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505140943.IgHDa9s7-lkp@intel.com/
---

Andrew - sorry to be a pain - this needs to land before
https://lore.kernel.org/all/20250508-madvise-nohugepage-noop-without-thp-v1-1-e7ceffb197f3@kuka.com/

I can resend this as a series with it if that makes it easier for you? Let
me know if there's anything I can do to make it easier to get the ordering right here.

Thanks!

 arch/s390/kvm/gaccess.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index f6fded15633a..4e5654ad1604 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -318,7 +318,7 @@ enum prot_type {
 	PROT_TYPE_DAT  = 3,
 	PROT_TYPE_IEP  = 4,
 	/* Dummy value for passing an initialized value when code != PGM_PROTECTION */
-	PROT_NONE,
+	PROT_TYPE_DUMMY,
 };

 static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva, u8 ar,
@@ -334,7 +334,7 @@ static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva,
 	switch (code) {
 	case PGM_PROTECTION:
 		switch (prot) {
-		case PROT_NONE:
+		case PROT_TYPE_DUMMY:
 			/* We should never get here, acts like termination */
 			WARN_ON_ONCE(1);
 			break;
@@ -804,7 +804,7 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 			gpa = kvm_s390_real_to_abs(vcpu, ga);
 			if (!kvm_is_gpa_in_memslot(vcpu->kvm, gpa)) {
 				rc = PGM_ADDRESSING;
-				prot = PROT_NONE;
+				prot = PROT_TYPE_DUMMY;
 			}
 		}
 		if (rc)
@@ -962,7 +962,7 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 		if (rc == PGM_PROTECTION)
 			prot = PROT_TYPE_KEYC;
 		else
-			prot = PROT_NONE;
+			prot = PROT_TYPE_DUMMY;
 		rc = trans_exc_ending(vcpu, rc, ga, ar, mode, prot, terminate);
 	}
 out_unlock:
--
2.49.0

