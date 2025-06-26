Return-Path: <kvm+bounces-50847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03813AEA28B
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 17:31:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FEEB4A33B9
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 15:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 070F02EBDFA;
	Thu, 26 Jun 2025 15:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j7aNxho+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="c80IkfxM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F17B2EB5CC;
	Thu, 26 Jun 2025 15:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750951892; cv=fail; b=kdLhi+86e0Zki7eaRpQ8IWBoYNh9O8fAa4GBzY5m/tTdgI/T4faKYfqCU+GqtzH8M0iZ75bsfYMb4GGRckKzXqXYCPWgdwsCe5hM5Tubkr9NWpSLXqJPu7XRT/PAMQgyTzoHAZzevaeXTM9Bq6U3EwoBzuHWuaOUF+oC1c2wfBo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750951892; c=relaxed/simple;
	bh=Hl6cAnjVQJjFzaYd3XGSqmtYJEIy6sS2QqRjjgLexQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LQ7nbwBjg9h8dpD1tipwsxTvZ4SPdq6uCQVG4WAq2Xc9b/BfoeS3eyh6/uOtW0dYHWTFBvffZyQumkwdzvBxAmO4i5LMYh5OxRAVnQq+K0v0u7R9XUF+Tyd0jJJkp44m6m4HTCMCa5SpDcz2XLAeqxuulMs0OEQ+Z+cWnltRKKQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=j7aNxho+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=c80IkfxM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55QF76vW014541;
	Thu, 26 Jun 2025 15:31:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=nuvgQbzuQbSTNOeDJe
	u9PPS5IyNuzeE/GL6VyEyD0OQ=; b=j7aNxho+7hOPV3v2V3O2iPwFE2RNH74pCe
	zgIAoW+XPfUtoZUX4S2ba+hAx7SCtVHHbvRohNsfSnZSeYk0hsVZuThp8w3WiWEB
	q2pH6qmAhMIJNmXL56GksVpnMb9i2s9SyCTnBo3lKIcVawquOQRUclXYoIDdS+aj
	moa+8YYTJt4WlhYF9Gm/ZWniY/nF8vhvNY5bny6WApV5bQ/DeCP9xKTeiIT8iM8F
	VgerNmTqW2fdUs5y+N8Blk8n440kQ5gHm4GAX4RiVF812FiOnnki+ralAgQeQOdC
	gCoiegJd8n2DgVubIaF73VPOdoY0GSx79TLbYeJnywWwdGxhRy6g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47egt1gvw7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Jun 2025 15:31:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55QEKBHg003274;
	Thu, 26 Jun 2025 15:31:22 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2055.outbound.protection.outlook.com [40.107.100.55])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ehq6nhxm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Jun 2025 15:31:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SD8KizAw74zcbhO0JilZYMM+N0HmC3RXOPVbLAGK2F6tlvKRQrI7afUFHpsZW0DjX7Hm+BJxgew31yFq2iw3rFUT2RyLzVyPDKzc7okp5N/e85xUatFuyF1SugU8+JgHzkeyJ5bhAiKqjQE+shtCWbSbFZH7A8CQCzglNjvGtHE0KZzTZDdmL36mFyY+zc8j0iEMUkednWhlVlx+vyBP6GvPaBmdldu0FwqMAuFy+xNxNOJH3vNk5wqHsYOAxIOjruWh3u8ez3bFw/8wh0urpF/z3xRa7BLPsCSLmSnMqgH9MuMHWa89ZLRld545yHOATEQUInnATjaXaLhnIckhUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nuvgQbzuQbSTNOeDJeu9PPS5IyNuzeE/GL6VyEyD0OQ=;
 b=k/8lzUUWDjHdb4dN5L5HDQstT9OwSY4pflsGB503By48g6ThPZqqF7MlefGLjxxdlOTRZDjOPIMj+R7b2gwAW9N1tw+LNKUFttq41wskeA3b7Qg8Fi53lekUBMokK/MIZ1xVEFoVqymHgAkyXA4t45/dzIuUahtWdWB2IXOTMbkEeeBalzlBX1NuNZzxg8dzmWjcPf4BfesI9gpSZMgRNs48SXnzZY6ShDTnhWUk4Va0jDlEtCCuoNx3XOes431vuD2sNcSTrhgC2nOyG5Bc8KZ1KZ1bHCCn42LvXdIAfSU7mR5vdu4ROFvIOlf4FWbfW9uIpfrxmrIFVAdM5+is3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nuvgQbzuQbSTNOeDJeu9PPS5IyNuzeE/GL6VyEyD0OQ=;
 b=c80IkfxMEOJ/CPJPBh2nEZgiQ5EFxiC2201tfrfjzIxpN4uu4JorXALFlK/uk6ktkWpu+ZJFVoDvX+3Gu7eze0UYM/SkRgFmhVKDoJR6QtuMEE8r997u6cJ5UAq0+RD4nlXuoSTzVp5PDWn2u65bEvPR8ldgr050E7qIYD94AAg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB4544.namprd10.prod.outlook.com (2603:10b6:a03:2ad::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.29; Thu, 26 Jun
 2025 15:31:19 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8857.026; Thu, 26 Jun 2025
 15:31:18 +0000
Date: Thu, 26 Jun 2025 11:31:02 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Alexandre Chartre <alexandre.chartre@oracle.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        xiaoyao.li@intel.com, x86@kernel.org, boris.ostrovsky@oracle.com,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] kvm/x86: ARCH_CAPABILITIES should not be advertised on
 AMD
Message-ID: <aF1ntuyr8gHleCwA@char.us.oracle.com>
References: <20250626125720.3132623-1-alexandre.chartre@oracle.com>
 <aF1S2EIJWN47zLDG@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aF1S2EIJWN47zLDG@google.com>
X-ClientProxiedBy: BY5PR16CA0009.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB4544:EE_
X-MS-Office365-Filtering-Correlation-Id: 6be95840-3f04-4349-2a3f-08ddb4c67f24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MpqG6td/uMLUMivaT57MyTWsSPbVRj/qi11t+1NE8oIdrH8TdVPP4dupDgiy?=
 =?us-ascii?Q?SN4bvd9BC5sWtiBKiN4zoUB+PVNRSaf7dM4i2gtr72Y6Q0pmYgoP9qly2JSd?=
 =?us-ascii?Q?Qt4fXm0XSGuoFlMWISb9rV/rBVUkcF+jT9Lx+HfFYhUJZpWmSVH5Dtewv5yy?=
 =?us-ascii?Q?PR2gZI8wN3VnPpAMSX1SOmphEKFuQPH7N96kdk8HdHu7PKQzmZEXUur/+u8D?=
 =?us-ascii?Q?eIRiyzHNDBSG3RT209DOXkTjJHR37WwlqldjJLX5TEovPV/oUoi5WIy1MFSk?=
 =?us-ascii?Q?rys3oojaOT18UipYe4YJZG6ORh9/1/iQD+Z92SCqqtdp72lwLyANqCuX9Nr6?=
 =?us-ascii?Q?c7aZlUD/YBbxWSiSLZInuNYuBMVa3NQxJnJNMEdAa+7iBF7EPNvgjyvArZZU?=
 =?us-ascii?Q?ri9SkcwtU+fuvZ84NaOoOsRU2FCY2ygCCtL+yN0rI9GIegdmwosxNRc+bNNz?=
 =?us-ascii?Q?TMn9YEvNK3jZRhcpj9+8cbWCdZmTradUqTeg3wYwqKSAiE1hs9hIhYoRp8vH?=
 =?us-ascii?Q?3nYK126ZsaOnJsp3MiiOBcOS3ji3tfMxZf8WnAcqV7hCPJy2Hyv5C+NS8bJ7?=
 =?us-ascii?Q?OsBpQij2+ecNR1pXbs933nYla3fJL9LwdrNSoam08xEGduuvqxLJTzj9UeoY?=
 =?us-ascii?Q?FLLpK6hp0aUlJGn8SnGvMAMRAjc/4N3mPyz8mec/pnkF5zC/WFsmzeAgJVgL?=
 =?us-ascii?Q?gmbyLBP33lr3f3R6n8EQ52Oa+YJrPOb3lUpVLNnQ7uQVgaxw13MZ6kgKhfqW?=
 =?us-ascii?Q?tn7MktVW/B7hYT5bvbNgRaZXdCB0+nSMw17RFFoEGvInZaLunFHj8aPx7h17?=
 =?us-ascii?Q?r4TiUVyXMz8Pj5LclsaxRN5rqcX6lRtkrhSfjwjC49cDj+h1amMm3bz/q1rn?=
 =?us-ascii?Q?h6KvfcUmdtW+9HPNWlSqS56c7Deal9DEPGJ/wPDGUvYW+UR6PJ1ZUbmZXzmE?=
 =?us-ascii?Q?CrUegYSclx6ihGW9R3qaDcLZjtgSNYjMvbz/tfx36E087O4/eA1HHsF7asX1?=
 =?us-ascii?Q?xE23f5p+jGu2PryYjVTrRIbf0/rF8nqYhMqP3sBOGxR94IpQHwcvU+6vu4Al?=
 =?us-ascii?Q?H81PlsgXS/2T7JEE+iu/kqKPBe1AaFWFq2nietiLfSfwzBVeOLkDq1hKsMng?=
 =?us-ascii?Q?GQ9LG+O9eWuPeNtso0ODsQc+8/AB2ggsGm9UURyxC1qrt3NQgiILikXc0vlS?=
 =?us-ascii?Q?XpsRK2g2tQ8zXx/T331EPmuosSRBw5YtBXOAmFuDUeaEHPSvkZx0bWpP0Bkm?=
 =?us-ascii?Q?gXVVfZqzzbdHxQjaYS63KLxVdQ1NzxYe1B3LWqmMWap/++xWFtR/irtEIT4+?=
 =?us-ascii?Q?HSTYelIX/04UxXNZfT1tJ471pTs9qI2zSPAdYQLQfAaPaf4yxSdr3gPAxCxj?=
 =?us-ascii?Q?LSFiBVwJN4y2uDqFi2VcfQ6NlRBaQaUUdPXCh+zLB8dZN/AVoIJFrU5A6HFj?=
 =?us-ascii?Q?2DrXKjMAf3g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zSvARSeQ+ayJZvIJ//BXx6Bm6JWjVoeglh9n0LG1m3QN9OYmnSIAdFfXNxXZ?=
 =?us-ascii?Q?Bbxu6fkwJeR42/i4E6spfKxwjS45J94Cx/VnNB0ux5gLsqLyQw+aMzyDf2UU?=
 =?us-ascii?Q?SzHANbZ60QGfW1kObd0tV76DF04qCXIgWxuvnfuj3QJzecY0s2fdyY5ToP++?=
 =?us-ascii?Q?zQPs12n5joMuOlCIlwa8u9BTOSy96mBRwn1wuxsqzi5rsOeTvVELFqGzLpPE?=
 =?us-ascii?Q?GnLBO8EYcq/eAlpQ/3ShrwJglfbDPPum1eOGmBA+HYKEG1vdXPiujvUyDqnQ?=
 =?us-ascii?Q?tswA0LzZIQVGXxJLLFni+s+NrwaY/zi4FAI8A7YvpEmzvvSgaw3SMsXhHvof?=
 =?us-ascii?Q?QrooUmRsui4jCLBjrL7aIa1y1WlI4y0akK/cmzkEa8nNeNXAoPkL3zKloqd/?=
 =?us-ascii?Q?BMxH/w4mKY/twD9f/oQy98fhDch5CtfhyqzDX+ehydXqEb7GOyT+3qEstvX4?=
 =?us-ascii?Q?iCk5IMUBKu4rQFSVupwF382GOHQ3nGGqGUqt4378lgnQq59uFExTTQ2I1ShU?=
 =?us-ascii?Q?TgqMyRIqP6iDBEGSDyumNLe8mwGOulj9XkKrEB9OswaZFk7uAxjg71iZug0q?=
 =?us-ascii?Q?UUAc6siFutFNPqJzsaLy0KHEWMvhhJpeMQxQ9cNHQ5vTqiTyWHUR+wt+XG0z?=
 =?us-ascii?Q?JTlE5wN6/FceXp8fn+i2X/qJjM1OOJs6Qqtl6deise3io0LTTxqeTMMn90t7?=
 =?us-ascii?Q?ahYq33f8qxLFYqoegj6fAz6mp+aj4vIupfyCoF2V+9o3XfCJSk7OscMx+Bvl?=
 =?us-ascii?Q?w9obkvD4QCJAjpe9Bz4aXrEht91Bvo/TBX8AEhs4+ZXuSLGi8cBcqvAPickn?=
 =?us-ascii?Q?iBmTUy/VvsydxYsIXU8VeX7fPR9Z7QduuhqLGvHqpXjqH1cm2s+qHo8Q66WP?=
 =?us-ascii?Q?AwQxeUZkKXk+P/bPadohonS4H54NxOyKXqBtxhrhu4WX/lQWO2C8a/XQjN+i?=
 =?us-ascii?Q?ut+DFuUMUSh1YaIPGQvA+DJ4QbIt5bRRtKHd0EhhPIkSKr3rFRkWxoW09pWW?=
 =?us-ascii?Q?RkpvBDjUVOzc6qNPywi4KHsdnpkeJeT5mypy9N7ztE85EMV6iX7IhiIw5Rmt?=
 =?us-ascii?Q?wfyVyy+6ZxTyxceEJ4UHEIEKQ5zJ+8Lv/kovOn4QNGtz13EB50JCVHfFcQ5t?=
 =?us-ascii?Q?NSojBq+5mmHdjKYYDbmmtEL/UkzOfSG2qyJlstTXLg+ItGFu3byGBhiM60nm?=
 =?us-ascii?Q?TfsX/HXxDAbil3UOhu3SsZSrgEdmlZknOjXiqjsV2WMB7V8rtFBd/BiW/9QI?=
 =?us-ascii?Q?UzmGDaCcJm89FxJ33Ya10RdvH4hHlWD60ZSb96xIGKX7MxCNcvuKniBHTXgp?=
 =?us-ascii?Q?A2McRvzrPKcolRwS/BaMM0ToD+lHjY6aS3uA5TvsBajfIiBWLcoW7UXc6SFL?=
 =?us-ascii?Q?mGq0MEiNf+PwA370UzpHVtRzU8Exue8jLhc2xWYsSKpSiItmFysq+O0zKY9h?=
 =?us-ascii?Q?fq/LauffpxmXOCBr+QMUSi7KvZbGPb0Eox+Yw+n9ItaLNA91aMQ72u1jGpVS?=
 =?us-ascii?Q?SYowmCmzh7T03J/rCKzFYTCRTIF4vqGl4FTkyst1AB1lW4bU4hT1zQUrTuN0?=
 =?us-ascii?Q?agI1IL/htYA1kppIv2qUW1VtjnqObErhToK5RIajHS+FaOGSlrcFZvd6H6e1?=
 =?us-ascii?Q?hg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	H3IWgeuekI0uVtRNqpxbai3Qy4HyRXNV6PNp/M25XRnoVrkrsHsy+lFXoXq1hPsOzBew3jtZ0IHMQ8TKSjCluYBZaVmdbpbIo7ejYZMLntlaV6yfRHz1fZcEGXsruxJtLrJ7CjmUAWnf7vS5uP/NQFgFQeuT1x73JcZ9zgU/RzeaapUcOD9aIGRT/ZbOx/Krpcxt4MQlZF7TluQUao5nt/cs6CgutxqjYvTSrjCU8O25DlaRtbm3MIjqBLMDB69ksrXr3hN0Ii4Ow3wMO9hoGHBTgXbmaH78EFSER4VuWM8ujY/VgwQLCnDSrpwpedIOX0qWsU/HJUfNHMKUSuOrM3J2Y6YbSsfw2dP+DbaGd+2Dc8B/nZeIm3kS1eQAye+YTapZ0LGfkpceQHPITwNsc8a17ivQSh736vDRZOnvaoQsJjuTS/uUKL+WjR+52evbEO4Bkmfb+dUQuSLoHJEZt/2+o2w8uMgAleACS3tzQfSgvauWqjicvQCFF4QxDg8uvYAkZbDQ1fX+FO4yjNVr8Zyym4pyV5/HF8kbn/Vtb/yizSkI/ims8bP4+5uQhNLvbjPEaaRRo4bjIOLarQppFoJwNBdwQFeRuFtNvFumRNM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6be95840-3f04-4349-2a3f-08ddb4c67f24
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2025 15:31:18.8962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5ghhxRyJECLQapdgLQctcwQ/orkwj1TvvxIujKuoAW3327lrwnGfUedWIqt5qt3jkxHBXRiBYdl1nWd03EIvvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4544
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-26_06,2025-06-26_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506260131
X-Proofpoint-GUID: FmygWLB5Z4kYRw-ANdkVhGzjF8-zqsqS
X-Proofpoint-ORIG-GUID: FmygWLB5Z4kYRw-ANdkVhGzjF8-zqsqS
X-Authority-Analysis: v=2.4 cv=cpebk04i c=1 sm=1 tr=0 ts=685d67cb cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8 a=MNhXDO69BxA1xnaHtZYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI2MDEzMiBTYWx0ZWRfX55BPG8U2NxYD 6aKrZ2BIeZq6GDFL8ceEeUyIOgVGV7OvCBMqHY+cE9PqiEjG7HXoi517UuszxN440gnrxQOUuje pqDifVDfy9UBdq8G/9/UFZYd7UbdQRgynJa2aJhF8HzGHMuZOVsN/FCeuT9jteGSSeqgHHmWcK6
 yQx3F5ysAMVxFwWO5q0xZ+VGanCNfzsVByRDbILCMlXLBj3O8mPsBdEYdE+7+S2ZJ8ZYAJDi3YM Iy+F9DahTK4prLKDaag+9PscrdUhm4qrb1MplDkCxmPGMzUdrFRp4T3cNhE2IrGxKKtk/ESL4gz 5HmsAMy54Es/FZ5qTSj5g32riHyeNTCzNstu/ZgUfLmnvEnlt7XMH0jbM1nfTv2G0PTBfeWZ1OG
 EID2CebOFDVWIias4bXliLiJq1x1Oh/xgv2WdmkOmTeW/mZ/Szif70m6PLRDJaqzCHMomWJH

On Thu, Jun 26, 2025 at 07:02:00AM -0700, Sean Christopherson wrote:
> +Jim
> 
> For the scope, "KVM: x86:"
> 
> On Thu, Jun 26, 2025, Alexandre Chartre wrote:
> > KVM emulates the ARCH_CAPABILITIES on x86 for both vmx and svm.
> > However the IA32_ARCH_CAPABILITIES MSR is an Intel-specific MSR
> > so it makes no sense to emulate it on AMD.
> > 
> > The AMD documentation specifies that this MSR is not defined on
> > the AMD architecture. So emulating this MSR on AMD can even cause
> > issues (like Windows BSOD) as the guest OS might not expect this
> > MSR to exist on such architecture.
> > 
> > Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
> > ---
> > 
> > A similar patch was submitted some years ago but it looks like it felt
> > through the cracks:
> > https://lore.kernel.org/kvm/20190307093143.77182-1-xiaoyao.li@linux.intel.com/
> 
> It didn't fall through the cracks, we deliberately elected to emulate the MSR in
> common code so that KVM's advertised CPUID support would match KVM's emulation.
> 
>   On Thu, 2019-03-07 at 19:15 +0100, Paolo Bonzini wrote:
>   > On 07/03/19 18:37, Sean Christopherson wrote:
>   > > On Thu, Mar 07, 2019 at 05:31:43PM +0800, Xiaoyao Li wrote:
>   > > > At present, we report F(ARCH_CAPABILITIES) for x86 arch(both vmx and svm)
>   > > > unconditionally, but we only emulate this MSR in vmx. It will cause #GP
>   > > > while guest kernel rdmsr(MSR_IA32_ARCH_CAPABILITIES) in an AMD host.
>   > > > 
>   > > > Since MSR IA32_ARCH_CAPABILITIES is an intel-specific MSR, it makes no
>   > > > sense to emulate it in svm. Thus this patch chooses to only emulate it
>   > > > for vmx, and moves the related handling to vmx related files.
>   > > 
>   > > What about emulating the MSR on an AMD host for testing purpsoes?  It
>   > > might be a useful way for someone without Intel hardware to test spectre
>   > > related flows.
>   > > 
>   > > In other words, an alternative to restricting emulation of the MSR to
>   > > Intel CPUS would be to move MSR_IA32_ARCH_CAPABILITIES handling into
>   > > kvm_{get,set}_msr_common().  Guest access to MSR_IA32_ARCH_CAPABILITIES
>   > > is gated by X86_FEATURE_ARCH_CAPABILITIES in the guest's CPUID, e.g.
>   > > RDMSR will naturally #GP fault if userspace passes through the host's
>   > > CPUID on a non-Intel system.
>   > 
>   > This is also better because it wouldn't change the guest ABI for AMD
>   > processors.  Dropping CPUID flags is generally not a good idea.
>   > 
>   > Paolo
> 
> I don't necessarily disagree about emulating ARCH_CAPABILITIES being pointless,
> but Paolo's point about not changing ABI for existing setups still stands.  This
> has been KVM's behavior for 6 years (since commit 0cf9135b773b ("KVM: x86: Emulate
> MSR_IA32_ARCH_CAPABILITIES on AMD hosts"); 7 years, if we go back to when KVM
> enumerated support without emulating the MSR (commit 1eaafe91a0df ("kvm: x86:
> IA32_ARCH_CAPABILITIES is always supported").
> 
> And it's not like KVM is forcing userspace to enumerate support for
> ARCH_CAPABILITIES, e.g. QEMU's named AMD configs don't enumerate support.  So
> while I completely agree KVM's behavior is odd and annoying for userspace to deal
> with, this is probably something that should be addressed in userspace.

If you do -cpu host we tack this on all the time.

Or you saying we should have QEMU disable this for AMD CPUs all the time?

Which in effect is the same thing as doing this patch.. but just moving
it to QEMU, kvm-tool, Google Cloud user-space thingie, AWS cloud thingie.

That is a lot more complexity than doing it in the kernel.

> 
> > I am resurecting this change because some recent Windows updates (like OS Build
> > 26100.4351) crashes on AMD KVM guests (BSOD with Stop code: UNSUPPORTED PROCESSOR)
> > just because the ARCH_CAPABILITIES is available.
> > 
> > ---
> >  arch/x86/kvm/svm/svm.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index ab9b947dbf4f..600d2029156e 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -5469,6 +5469,9 @@ static __init void svm_set_cpu_caps(void)
> >  
> >  	/* Don't advertise Bus Lock Detect to guest if SVM support is absent */
> >  	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
> > +
> > +	/* Don't advertise ARCH_CAPABILITIES on AMD */
> > +	kvm_cpu_cap_clear(X86_FEATURE_ARCH_CAPABILITIES);
> 
> Strictly speaking, I think we'd want to update svm_has_emulated_msr() as well.
> 
> >  }
> >  
> >  static __init int svm_hardware_setup(void)
> > -- 
> > 2.43.5
> > 
> 

