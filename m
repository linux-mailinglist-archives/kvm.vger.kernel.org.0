Return-Path: <kvm+bounces-26853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50BF59787C9
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 20:26:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B9B71C22B3C
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 18:26:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B305B12F588;
	Fri, 13 Sep 2024 18:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="W3DYeIeX";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="T4zwoXlQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399C38C11;
	Fri, 13 Sep 2024 18:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726251983; cv=fail; b=gvvfVm7WbLftupDuf6gBOWWnuCpCef/wfl9wv3NFU24sIf2WcqG+WjAtZgDaihQHsMuA15Uu+bpVwNcOMIJF9xJPWdxWjBZQP2hkqHIoo8iMAdvP+CnnU4B+DrIjM29L4CWIbBiTLUojWnYNgYZNKyNDTP64s0cB/eKz++U8V+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726251983; c=relaxed/simple;
	bh=d81zkFYXtB6dax1ZkSesUOYPmpOen+AK+wuNp58yKA0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Y2c8N0kD/Yk8nFMU0aqjCsyrWcS4/JJMgxjiL5STWNhmCUwQ3o2vvGNuqN1OWajmhBs6lhCJOnGHOtxHz9eU1Lf/lzoexb6oaM0Sa76ihwFcAimjRL9tZc7r1dKnChvmyPydhsLX2zgSsHrGICgaPgRZx/h1wCUoOvRnJoOV2cg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=W3DYeIeX; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=T4zwoXlQ; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48D7xa7B023507;
	Fri, 13 Sep 2024 11:25:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=SDnKRkUEDSB6l
	56L5mh6IrBL4rdpyR9Yo5Kg5AQuQys=; b=W3DYeIeXkevG4Eqo1lBJFU2V/shJe
	rGNZLh9XVG3+C//xoAEQzu2lXj+TNI1GGECDWT7Gz/92cfX6N2OGj5rCJsvpyucO
	AbJBGy59R7jJFipGT02DWxx/iSH0mRIlL/1YFol2jk9dNmc0dUrpS/z1vTOhDRJT
	jkYzJM0Grnsu/T96m3lfoFWrfaU2e1LAY6GNQ2GVA9m1JCdp8zgJ23wHqQi7NGtM
	i1vzWx3/HzeGrMf4wapl6B0YCA0zpQyFXv7eaXQZ0Q+aPs51BS+w8/Se+mS/CKhm
	7xsVA4B/nT9LiGceAikj8mkKCW5pR733zyn60bKy8lzU5ph+x6ygpzIUQ==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazlp17010003.outbound.protection.outlook.com [40.93.20.3])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 41mhg999wp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 11:25:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eKc1ImvWM0Tg9Iefh2YzfqpVEQncohkpA9ET/SAmDew83o05z3flJusZAc9kjHBXusaYoNswwVHaNk2rEO8d6mkBiQXj29xeu320ZiLWjqPeDrc0z29hNHskR5FfcdqGDia1kS6vX6MXPcB77WEtICvoxSvxS2XCyyMyNRoDIBrfBeqZeLNyfsWm+otGzdGv2R2WiydHcv5oVeMFbBetNo2a1kXN3bG+GcKod1noqrHaMzNUdm7T6ENyhgHNBS9sB2ypWPrFZFBfujVIkjgXGsPtMRRV1EKVxWQHJ5rgGpQgSMHwJ9RdqZ7peKu6PwsSrT2cfhcYZ1FcEDEMF/6X2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SDnKRkUEDSB6l56L5mh6IrBL4rdpyR9Yo5Kg5AQuQys=;
 b=Rpo8X5Nd8JbGte0gQt4FbX2VENIYQ0tSaKE9MYCYZubNuDUZ8/DLIFKnAEoP+Z3rW78aW8fEbRboCQi5GWYqXeNU52RNuCs8TxaeYmdrHaKH1wEqjafftMndx3rLbO+XGT/FzcHURg5zCeORahmTKtCqCDo+jPLsw9g/pbuTxBI35TnrF+JwfvUMCoNEVk1BKCf9OZwuDsb8egwbbicYLOEuJ7oZdiSI0WLGOx/spX1eoDHtksblmHK1mqtBh3Iouw98aB7+1EWtaXGRRbCZQlUkWuAG2tkRKkuVqLvXlbZSjAvfkPGMb0EMfCU4Vm5MfsO3DSJM36DCfZm/+ews3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SDnKRkUEDSB6l56L5mh6IrBL4rdpyR9Yo5Kg5AQuQys=;
 b=T4zwoXlQz3WvhG7cfCs8P8UuTn8kUN4LueY1PYb5tI0AgYf+5FKVw4slXixr9bs6c60jXMvZR3tcyxswIe+RFF6G4XlejIrVfQe9URdVf5lOMu+s8DDKYvT5AJ4hCjvAkvh4NIS0Ksqo52Ew+D7PF9y4izFri6/VKn1UZX47lq6nbTDvno4cOjZCKF4sH5Y0p9S9oAwznNKUAHr7tIjpI6fjkYbXCLbVDj3fPkrwJ56sPZ/uBPwhG++ZFdkNFThYSNAKBGBfFi6BnfxR8PQ4bUhEbeskYW7plewW0Gwo5JmojhnL8lg5T/EKNjG3G1gjsEDu/sgVOJDn9L9dbByjAg==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by DM6PR02MB6745.namprd02.prod.outlook.com
 (2603:10b6:5:210::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.21; Fri, 13 Sep
 2024 18:25:54 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.7918.020; Fri, 13 Sep 2024
 18:25:53 +0000
From: Jon Kohler <jon@nutanix.com>
To: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Kai Huang <kai.huang@intel.com>, Sandipan Das <sandipan.das@amd.com>,
        linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Jon Kohler <jon@nutanix.com>,
        Chao Gao <chao.gao@intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>
Subject: [PATCH v2] x86/bhi: use TSX abort for mitigation on RTM systems
Date: Fri, 13 Sep 2024 11:42:37 -0700
Message-ID: <20240913184241.1528972-1-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0106.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::21) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|DM6PR02MB6745:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b4c71bb-131c-4a72-2800-08dcd42180a4
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|52116014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OVgH/lnr5U/O1zzkaWV1xFO0QTc2tYKg1y92H42LL0P45JDHsgmrE/6mqQ3I?=
 =?us-ascii?Q?OYtf68POuQr+JKSC3w9/lqOqcGdG5cGBBX8Y2lzynQ+nz8WapcbSAXBxrPO3?=
 =?us-ascii?Q?rK7IWOgZPv5EqfMQkKhiAmW9drD5snrmL6AEqHoS4B9E1CrQxr7Kzj/EDtH4?=
 =?us-ascii?Q?R8HRyb1uw/WBzA10VtGDZ8jGcw5W37+TdE06WqbK8dlxceGXwcOheYJL0y/7?=
 =?us-ascii?Q?vZvYQVGRLtw9/NHOotSawW34XYQeal+oy4upb24fbnoCkMlYYJP36hs4SMNW?=
 =?us-ascii?Q?ZgkTKJJR3mB7J9YcYdVzaLnfVxGepmSfOHCc85kA/toOogF3+PYWL3uKDmbi?=
 =?us-ascii?Q?xhFsng7FtAMcC0WzIAX0A6EP7MuRvwEXLtAZphlbX1kT6fZNIsslbJ/hRqIA?=
 =?us-ascii?Q?RMDqZYbrLFFb8xSVf9OddzArndttyuL5XO01sKexs7bP+a3EAnnvpOmB0a1R?=
 =?us-ascii?Q?5oeUlzExOp9YVbJj6x2hgeqyPhVTHKwYEYnRaL3C/90PRRp+i73tmW/jiLhY?=
 =?us-ascii?Q?9sWskpNYN7lKXK3/Z9QxMkPIgMf1ioDDnwOaCQTJ4erNxDq4f2u2hB+0Rzup?=
 =?us-ascii?Q?YXmaD6a+YE1Xd/OKo0pKpmY4sU9U/luJXfImIvvpyGOrTK3mR025BH6N6+j5?=
 =?us-ascii?Q?pG5kCb8daSFwY96PoiD8Nl5SZI42clbyc0fIFL5+Yy84AywwFtTif+TxhAK3?=
 =?us-ascii?Q?YuC8UhQ3oDOYl2rproIBmH183c1wA2K8belFAalWAzb/faYsQ0afHfBjuQz6?=
 =?us-ascii?Q?oxSJfU8oru13jYWoRNwgxK1FgtR9hxveYzNtQlF9X0m4ZAbLXEARHA5RCwLs?=
 =?us-ascii?Q?scbVOUUPH5nUEG5jQcdvIvOtt2rI4BBE22bN0mB5XraYJQr6opIXtihv4VWE?=
 =?us-ascii?Q?jt/EFSJpkcsyExOdAkJ1N5BNDIO83hcpEFOcEj36HD5iXT6tWqSFoay8ebFp?=
 =?us-ascii?Q?u5fBQQX93TTCZe/azE6Zwpyb/uyUINPBjLvRrcpD3Mw8EC+/rDphDjJK2Dud?=
 =?us-ascii?Q?z03j7QKWsZ28wvytyzDlqRsgb4kGm7t7ahAIhQ3ElOaV/0JmRVTwl0ocbQrq?=
 =?us-ascii?Q?czvMYX9bOOd2gnsxC9SP3vxWPE1BnztVF2gpcLjX05nnAS5x2IjLASejZmT8?=
 =?us-ascii?Q?BugoSytK91pQ8S3afxWqBvYV8KJ+x0BpHPY4Wwo5wOYiU3sQs12CvMpTg9nj?=
 =?us-ascii?Q?gJw0+qcvH54condJnFQjodOGS907fYeEcJF1jggqxyfvLNUeZVmPmGoL6fw2?=
 =?us-ascii?Q?kndopJ7dKTETb7Ujdeg1L1RtZWwdZDWmO4iKhhzc2Ud5tKB29GBXzTaEhTe3?=
 =?us-ascii?Q?ogoxC6nuOWrDSpSudOWftryYWnYp/ohNh7dhN3aLcfxNElbuTA4KYj1mbrc6?=
 =?us-ascii?Q?CiCM3tdafQjafQ0MMvMJSPiwX8ByGHMrhNuYSJA6WdM1D9ou3bsaGxkp5Foc?=
 =?us-ascii?Q?HMq+aJhs+tc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(52116014)(38350700014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?boRinuFId6A2lslyFmuWLdNe8RpqJhedgkjT0aVi3TdwmgcntjSq0K58tKnm?=
 =?us-ascii?Q?KNisv+pRSSacvvMk28qhRZNrCpH2nhuvamSg/+3Zw75vyQGaJPaTqHHEJNFq?=
 =?us-ascii?Q?LuCQOsXfdaWc5+ZtwHqYK95E0qR9VHbXnX5VauUpMPUX3a0IgN+xhxjFsIqg?=
 =?us-ascii?Q?tf1EeY+ELfsqCxtW2JnZFNJWrdEWGmPOFM0rHbeM0U6321MZSDdzoOXdL5Xp?=
 =?us-ascii?Q?zrWgbbqGMYeo8D6GG+iJGqY29BtqA9lCap8bV1iQgRuT2t2BUZBOM0snilpC?=
 =?us-ascii?Q?BNCKrF+zzUSHgvhU9RVyNipMv/RwyrS4MSujs3SxgExLjP0Wq9c7GzQ8aj4T?=
 =?us-ascii?Q?BV3Spb4ihSZzlgWNgKNdrfMBGIfdQSHIwuZNasDZQtzvNt2G3PZMUcSYITkc?=
 =?us-ascii?Q?bxP2Gi8mVna4heEnSFsj625OKLlUm9/ulR5zhTX8DU7wFQDR1F+No9zpHjPQ?=
 =?us-ascii?Q?oPUTKkH++F2E0QFcn7oeix9fL7vfsr0NiRUsw90jen6NhosA96xKfBfqjxLc?=
 =?us-ascii?Q?/0611SYxxaggINQ5C9rJnZZpisxpa41xKAKmKV8F20HqieRemJcr+iWpAKID?=
 =?us-ascii?Q?PWBQsha2VVOluS4/C1FaTgLKwOFO8siMYLPdTon9vfAtlsdeiPNNn/VBHHlt?=
 =?us-ascii?Q?BhKYlXqr3XTSJybhj/AjUZNT5BVIeRApZzThBsglV925WJTX3RMsfcbZR2KD?=
 =?us-ascii?Q?oQr6ZIer3VQ47YpyU08e5D73Ef08PBasOJsuUGWxd263DvYkqzjb9aaYdTBk?=
 =?us-ascii?Q?dyzwpX2ff/UFaHaung/KlcS89Bugu4WWcVAVAfZc9b6x6M50zV9eOurx7RK4?=
 =?us-ascii?Q?wp3cS81Mkm96xt027H9TmdP6QWjbcLO1TNMTjq2cT/DvHPd0FTPVjxkneQiz?=
 =?us-ascii?Q?4xR+HdNG6QzZSJbyXSwfW5GbIftq9XOyAK/H0j8i1uPoZi2HGwxPmTqdXH7n?=
 =?us-ascii?Q?SIUDPXhmxBE6pPTIYYoeQeWMewqD6CrJY6pciCWfMGRdOAp/FWBnc/ploy8O?=
 =?us-ascii?Q?6Brm+Ic3GFkiq2pfOTtJjRYnxkCpv6bNqB5OlsfSwhWbN5UjAP3Xa7iEJdcg?=
 =?us-ascii?Q?D1dZaSi47+LkQHtmkgKD/AN7Nm0zVgrGLAeo37jFUyoP+AFV4q864qLwHr3t?=
 =?us-ascii?Q?0hr+zVYP0yC6qDQi0lXM5FC4ckF+vslCQDaUHYSs9gjI1ayzQgyx+5piDboP?=
 =?us-ascii?Q?p2rzrWjWoum3gPXMn9bnOStfLAWe13Yn/KRpCfD02XMv1V9FlI0MupQSLlwD?=
 =?us-ascii?Q?nHxOTjBZhoVAjEDA2p5v6yza4fQXafZ8td3fNVcZ1z8WTJq57suLkZCpZdj+?=
 =?us-ascii?Q?ClyllI1hXCN4W/e8ttR7JqIgkqwnTUosIniCQ8UHyw9DXWELHiUJNgtNmd9h?=
 =?us-ascii?Q?z8SSWmCIlVOq1ivwQeq1ezusCTZxcN5AJ0Qosivm16SqcjZQKTUMB1/5oIyP?=
 =?us-ascii?Q?QDhr3LK4jUcQRNgfonRfkbyksfQSGkQD3iDQixMlyBKj/sGdzuHOTO0mMkcs?=
 =?us-ascii?Q?P2C0nWzYhhI1LBHyNwM/732EzIquXxtyQY/8CgD7QHsEfSR2MW1hs5xL6xfh?=
 =?us-ascii?Q?HaJ+eepQJL2h/5hLu6prrGmeZHV7PiV7inICayfh+Y5dQGtbFbImiOZipgbb?=
 =?us-ascii?Q?aA=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b4c71bb-131c-4a72-2800-08dcd42180a4
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 18:25:53.8116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B1xVOtaGjBo0DpNmo/zSF0A8a11mn3RZUIXcZY62Z8G2Y2Bs9jmEiS8MyvSLNux79vPhd9h0xXGRuxdsx6CmeA73PPS3gXPp8nd+6Q7Zodo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6745
X-Authority-Analysis: v=2.4 cv=HI2RFZtv c=1 sm=1 tr=0 ts=66e483b6 cx=c_pps a=0ZLAD3l0a2tGCwaiWSoSeQ==:117 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=EaEq8P2WXUwA:10 a=0034W8JfsZAA:10 a=0kUYKlekyDsA:10 a=QyXUC8HyAAAA:8 a=64Cc0HZtAAAA:8
 a=6Lx_NvqxSl1EumgHasIA:9 a=iJeLTDR2-uQA:10 a=y5rEMOVZ_0gA:10 a=14NRyaPF5x3gF6G45PvQ:22
X-Proofpoint-ORIG-GUID: X-co0t2Lznu-S40w-Do_Bj8liSAMiAzy
X-Proofpoint-GUID: X-co0t2Lznu-S40w-Do_Bj8liSAMiAzy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_11,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Reason: safe

Introduce ability to mitigate BHI via TSX aborts on systems that
support RTM feature. The assembly for this mitigation was provided by
Intel [1], noted as "Listing 3", which starts and immediately aborts a
TSX transaction and causes the processor to clear the BHB.

Vulnerable systems that do not support RTM or have TSX disabled will
still use the clear_bhb_loop mitigation by default.

Furthermore, on hardware that supports BHI_DIS_S/X86_FEATURE_BHI_CTRL,
do not use hardware mitigation when using BHI_MITIGATION_VMEXIT_ONLY,
as this causes the value of MSR_IA32_SPEC_CTRL to change, inflicting
measurable KVM overhead.

Example:
In a typical eIBRS enabled system, such as Intel SPR, the SPEC_CTRL may
be commonly set to val == 1 to reflect eIBRS enablement; however,
SPEC_CTRL_BHI_DIS_S causes val == 1025. If the guests that KVM is
virtualizing do not also set the guest side value == 1025, KVM will
constantly have to wrmsr toggle the guest vs host value on both entry
and exit, delaying both.

In fact, if the VMM (such as qemu) does not expose BHI_CTRL + the guest
kernel does not understand BHI_CTRL, or the VMM does expose it + the
guest understands BHI_CTRL *but* the guest does not reboot to
reinitialize SPEC_CTRL, the guest val will never equal 1025, making
this overhead both painful and unavoidable.

Testing:
On an Intel SPR 6442Y, using KVM unit tests tscdeadline_immed shows a
~17-18% speedup vs the existing default.

[1] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/branch-history-injection.html

Signed-off-by: Jon Kohler <jon@nutanix.com>
Cc: Chao Gao <chao.gao@intel.com>
Cc: Daniel Sneddon <daniel.sneddon@linux.intel.com>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/entry/entry_64.S            | 24 ++++++++++++++++++++++++
 arch/x86/include/asm/cpufeatures.h   |  2 ++
 arch/x86/include/asm/nospec-branch.h |  8 ++++++--
 arch/x86/kernel/cpu/bugs.c           | 26 +++++++++++++++++++++-----
 4 files changed, 53 insertions(+), 7 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 1b5be07f8669..64e83caec40b 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1552,3 +1552,27 @@ SYM_FUNC_START(clear_bhb_loop)
 SYM_FUNC_END(clear_bhb_loop)
 EXPORT_SYMBOL_GPL(clear_bhb_loop)
 STACK_FRAME_NON_STANDARD(clear_bhb_loop)
+
+/*
+ * Aborting a TSX transactional region by invoking TSX abort also clears
+ * the BHB. This software sequence is an alternative to clear_bhb_loop,
+ * but it only works on processors that support Intel TSX. The TSX
+ * sequence is effective on all current processors with Intel TSX support
+ * that do not enumerate BHI_NO and should not be needed on parts that do
+ * enumerate BHI_NO. This sequence would be effective on all current
+ * processors with Intel TSX support whether or not XBEGIN is configured
+ * to always abort, such as when the IA32_TSX_CTRL (0x122) RTM_DISABLE
+ * control is set.
+ */
+SYM_FUNC_START(clear_bhb_tsx_abort)
+	push	%rbp
+	mov	%rsp, %rbp
+	xbegin label
+	xabort $0
+	lfence
+label:
+	pop	%rbp
+	RET
+SYM_FUNC_END(clear_bhb_tsx_abort)
+EXPORT_SYMBOL_GPL(clear_bhb_tsx_abort)
+STACK_FRAME_NON_STANDARD(clear_bhb_tsx_abort)
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index dd4682857c12..c6aa2d758389 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -473,6 +473,8 @@
 #define X86_FEATURE_CLEAR_BHB_HW	(21*32+ 3) /* BHI_DIS_S HW control enabled */
 #define X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT (21*32+ 4) /* Clear branch history at vmexit using SW loop */
 #define X86_FEATURE_FAST_CPPC		(21*32 + 5) /* AMD Fast CPPC */
+#define X86_FEATURE_CLEAR_BHB_TSX	(21*32 + 6) /* "" Clear branch history at syscall entry using TSX abort */
+#define X86_FEATURE_CLEAR_BHB_TSX_ON_VMEXIT (21*32 + 7) /* "" Clear branch history at vmexit using TSX abort */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index ff5f1ecc7d1e..915a767b9053 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -328,11 +328,14 @@
 
 #ifdef CONFIG_X86_64
 .macro CLEAR_BRANCH_HISTORY
-	ALTERNATIVE "", "call clear_bhb_loop", X86_FEATURE_CLEAR_BHB_LOOP
+	ALTERNATIVE_2 "", "call clear_bhb_loop", X86_FEATURE_CLEAR_BHB_LOOP, \
+			  "call clear_bhb_tsx_abort", X86_FEATURE_CLEAR_BHB_TSX
 .endm
 
 .macro CLEAR_BRANCH_HISTORY_VMEXIT
-	ALTERNATIVE "", "call clear_bhb_loop", X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT
+	ALTERNATIVE_2 "", "call clear_bhb_loop", X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT, \
+			  "call clear_bhb_tsx_abort", X86_FEATURE_CLEAR_BHB_TSX_ON_VMEXIT
+
 .endm
 #else
 #define CLEAR_BRANCH_HISTORY
@@ -383,6 +386,7 @@ extern void entry_ibpb(void);
 
 #ifdef CONFIG_X86_64
 extern void clear_bhb_loop(void);
+extern void clear_bhb_tsx_abort(void);
 #endif
 
 extern void (*x86_return_thunk)(void);
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 45675da354f3..9ece1cea51bf 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1662,8 +1662,16 @@ static void __init bhi_select_mitigation(void)
 			return;
 	}
 
-	/* Mitigate in hardware if supported */
-	if (spec_ctrl_bhi_dis())
+	/*
+	 * Mitigate in hardware if appropriate.
+	 * Note: for vmexit only, do not mitigate in hardware to avoid changing
+	 * the value of MSR_IA32_SPEC_CTRL to include SPEC_CTRL_BHI_DIS_S. If a
+	 * guest does not also set their own SPEC_CTRL to include this, KVM has
+	 * to toggle on every vmexit and vmentry if the host value does not
+	 * match the guest value. Instead, depend on software loop mitigation
+	 * only.
+	 */
+	if (bhi_mitigation != BHI_MITIGATION_VMEXIT_ONLY && spec_ctrl_bhi_dis())
 		return;
 
 	if (!IS_ENABLED(CONFIG_X86_64))
@@ -1671,13 +1679,21 @@ static void __init bhi_select_mitigation(void)
 
 	if (bhi_mitigation == BHI_MITIGATION_VMEXIT_ONLY) {
 		pr_info("Spectre BHI mitigation: SW BHB clearing on VM exit only\n");
-		setup_force_cpu_cap(X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT);
+		if (boot_cpu_has(X86_FEATURE_RTM)) {
+			setup_force_cpu_cap(X86_FEATURE_CLEAR_BHB_TSX_ON_VMEXIT);
+		else
+			setup_force_cpu_cap(X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT);
 		return;
 	}
 
 	pr_info("Spectre BHI mitigation: SW BHB clearing on syscall and VM exit\n");
-	setup_force_cpu_cap(X86_FEATURE_CLEAR_BHB_LOOP);
-	setup_force_cpu_cap(X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT);
+	if (boot_cpu_has(X86_FEATURE_RTM)) {
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_BHB_TSX);
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_BHB_TSX_ON_VMEXIT);
+	} else {
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_BHB_LOOP);
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT);
+	}
 }
 
 static void __init spectre_v2_select_mitigation(void)
-- 
2.43.0


