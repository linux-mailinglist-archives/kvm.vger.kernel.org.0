Return-Path: <kvm+bounces-69574-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +PdFFZOVe2nOGAIAu9opvQ
	(envelope-from <kvm+bounces-69574-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:14:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DF947B2B76
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:14:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9EAFC3023E03
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 17:14:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EB19346E4C;
	Thu, 29 Jan 2026 17:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ms5sj72R";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="whYcRAj0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97DE2C0F7F;
	Thu, 29 Jan 2026 17:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769706873; cv=fail; b=mJliangGnGftH8O5fFmUNI+dK2ODKYpYOVKAyGiX/l2iZQkvW1CjDi+RyQowaDebyPRf5UWAhNeKjB8CzMUh/Jlpf+sRM2JzXEmuhCjI+39sA/xnY1WHz+frTKYQt8UHEp4ZTU4Moo5+iiynldGL7Ta/X/8d1aKmyvJgsVU7IgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769706873; c=relaxed/simple;
	bh=vDuwMNU5tdbxCHaSgPr/NJin2ydcNwfSMZl8JT9Gmss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KJArE7izPI7BkRk2wfNx30QtH56VMdah/2WbmFPMTjke1+Um4rOu7mERMnKutMIkqK7e50E7c3Tp8nGMlQwyb3D1kxJ7ctg444Qdaz25ynsMjOfrqM36gGMUoTlCdtJJLqs0oqICQ5Q7qxUg36r47LpQm5c4ZKb+L7bdk0WPHEI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ms5sj72R; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=whYcRAj0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60TDgFF2676631;
	Thu, 29 Jan 2026 17:14:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=q7gLzxzIebDgK32LKi
	r4K5PcN7qibcoaX6kgKB34Jpo=; b=ms5sj72R4dyyyX4eQWCxDpfkAYhmJ/q7sI
	7BXsBN4eisNxBEK+ObCjVp5sM4ezUNc9tyHeluOw/I557yHBIHt5vyUrv8ytzLdK
	O62bxMYL1m1lGjyy1zNptMCU1o51HxzaZmAWXnnYoAAUyfJB2iiGR3acFq7JVQQw
	3jIDCuMF8lcSsJmNOm8yX9dx4lDEwRFyF5ggbBLNpFU1hUuN/FQkDR4llyoRrJ6t
	6/4v7CATE1ugYbhhDbLIHhzQqR10W/Ind9YED6lK9D4dCLBIdX6A0AW4rMJ8U84t
	7VwCzlHMHeTJr9+ERJ/9sdStIJz6LNtuS+oJ3cSWO53SEC1cID8w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by2vgkr1w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 17:14:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60TG1ftS032705;
	Thu, 29 Jan 2026 17:14:09 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010060.outbound.protection.outlook.com [52.101.46.60])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhck2fj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 17:14:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rIfgnYIRNaHgWO3MjyxapfRQLSqV6JDhBj9TbHuCmnul8kaRadHz8s3PRdWHzyBH7z1suEBysaNEoA0177BYUQw++rJfOjwWFSvIjYbM3Zo9/mwGbZe5egjrJACvm7Bf+l5I7/KoeAsIHVHWbmjvkT+ivuuVfFKspdVuKC2uhp7zW9e+xMEpwqb9oWlTqp8EMeMBWSVCJCLXrEZ0Z4lnAC6cwBJblU3CJoADlgC19l+ZhnPokkmVzougbCYsAqIfLJus1v4Vj8LTQfjrhXdvcz0W2t3wiq2jHktt0etVHwdZoEQH+UcRt7woeT9M/G6OGmb1odOp/R07EFv7KXTeMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q7gLzxzIebDgK32LKir4K5PcN7qibcoaX6kgKB34Jpo=;
 b=Bs6sZMsDrh9zfd7DRgGvVpwKS8rgQ5NZtpDZmxmA1ufAZW8qeBL3wCtBUCyIMFudHmmouRx44yiRkUR4XC0jJY9bf8coOw0gFHNusRsmv4xb+Sv2ApyKWPtM2mOepWoGRjo0U/Jir5Glaa3wT2QO1CODhY5fpQXoTVtEU4EG1lGRxPx64ij40SyjiUNwBKutAdGkmdWY+6QFf/oHiiN80aaE7Rjr/Mahq3Rhop7tAgHKZDe7m9XYUIhN2CqeuYQHoq4sLwBlIE8PVIDmAtu5spvv8zbaEf9lBZw3XOiFxolM09MUPRP4F5Q2vWJcis+UCXij9VnyUlwPsLCd9xZryA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q7gLzxzIebDgK32LKir4K5PcN7qibcoaX6kgKB34Jpo=;
 b=whYcRAj0MWvXCmBibOsT8VGMuRy3nik1mIZVCAQsey9bQ0aednR/gYg3BdLSBncfKfP6wuhcteOmnhkVfmq5Yn24clsLaBlX9IKHiZ17crOizvLYYEprx7vP3H+nZS+S6wmo16FPv6FaxGeTP8U5U8viEJFCV4RdTQHXyv6Czmo=
Received: from IA1PR10MB8211.namprd10.prod.outlook.com (2603:10b6:208:463::7)
 by SJ5PPF0BB87A13E.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::78a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Thu, 29 Jan
 2026 17:14:05 +0000
Received: from IA1PR10MB8211.namprd10.prod.outlook.com
 ([fe80::e708:aefa:5383:e1d9]) by IA1PR10MB8211.namprd10.prod.outlook.com
 ([fe80::e708:aefa:5383:e1d9%6]) with mapi id 15.20.9499.005; Thu, 29 Jan 2026
 17:14:05 +0000
Date: Thu, 29 Jan 2026 12:13:43 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org, Kai Huang <kai.huang@intel.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>, Sagi Shahar <sagis@google.com>,
        Binbin Wu <binbin.wu@linux.intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH v5 00/45] TDX: Dynamic PAMT + S-EPT Hugepage
Message-ID: <aXuVR0kq_K1TYwlR@char.us.oracle.com>
References: <20260129011517.3545883-1-seanjc@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
X-ClientProxiedBy: PH7PR10CA0024.namprd10.prod.outlook.com
 (2603:10b6:510:23d::13) To IA1PR10MB8211.namprd10.prod.outlook.com
 (2603:10b6:208:463::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR10MB8211:EE_|SJ5PPF0BB87A13E:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cf5f213-a2c0-4e84-9dcd-08de5f59ce82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2qHhmw0IktnJ73ZjbtlSyOWSKtp3HnC/lFeMU66pgvgjgiXJYl4kDyktdeDe?=
 =?us-ascii?Q?K4syZ1sYtgm0hIV8nsXgGd8lWYzmRl/u4NLuYQiWJZ+wyrSvrwc91xhLYvqK?=
 =?us-ascii?Q?750ZFOWsOBsLQCIrC1GbIUCGsIWU3PjF9wBhEcK/DlINYsuCUi5HQElCbrz/?=
 =?us-ascii?Q?iKECExkUKjAkFzRWFRpk+bdmCBicYxN6XilhRozSNNEq5OPzZ8sd15lSWRaQ?=
 =?us-ascii?Q?a1vF4g4QLxyAdvGE8P+u0MxAZvOxKwhycDHYel9RVbuggwA7WpM0snIqSd71?=
 =?us-ascii?Q?W3DUNahbgRWGNaBMGvENputxbF/7nOzkF4UP4vSxpGLFJ2fR2KB6RkCxF/Mv?=
 =?us-ascii?Q?hBroPQeI72titZfPMV4LlPuRTAHugfBtNxyuyvwTID17g1DWVtotW0MtqKxX?=
 =?us-ascii?Q?dSsRF7wkbsxOMdNArYQ7HKdzXqgnWVQVWPGohsc3pK7/dlT5FdL8ZbVtE1fq?=
 =?us-ascii?Q?aA+AhRrqiD6gNkAXrnoF3QE9CRL/A7o0nnlTOa00N/WXEsd9y69zLvCU5ENe?=
 =?us-ascii?Q?2OQUSTK6VwMGvX3Ms3jQ7NAbK/EE3cN0/GD0wM1pr5YDa4T6vgbjJQLUu3q6?=
 =?us-ascii?Q?HluP65SL2vaUwwbm1ASDeE5YY3tO8I3XmaUOM7drEbraMr4T3MLnJA5ttemO?=
 =?us-ascii?Q?tBoAjnxToXFXA0bE/jE5OCw2JPvr0raUCx9Vfxn6sBXjTBjCVBwgkQ0HEX40?=
 =?us-ascii?Q?Pv9kswXMEG9WegmlGqJzcT1EFfK/1xztRFIrbPa90GquGVoPrmnSUv153caS?=
 =?us-ascii?Q?i1r+0QVn3EBo2dw35C8dzbPPDlimghyNpKshiIAe02J3kRvHa3LfjKnNgjWs?=
 =?us-ascii?Q?PdutstcJqFA0kGUA8UcFThDmiJe5Y3zd+rQvkeHn4H285HQ+7SRnVNR8VoLc?=
 =?us-ascii?Q?AAMpSyW5se6+eQZpgDdKNhEOa42K8ZMQts1TRi75CBVuEcHI7NRqpTx9lNRB?=
 =?us-ascii?Q?VXWn5qsKNAPE2bnjH/EKzG54Vfd9mpYfgg13eBc+rliSslDsUPVo2W89tbli?=
 =?us-ascii?Q?vOy2H7XgzhY8355sZ/49xkYosQOJbRwDddrgf6LsoVeMaVFENojkmdgUYRZM?=
 =?us-ascii?Q?+/06R3YhRV7S10lM2MZP3gVbQwjdEpNKRHO8EltvxbE1WGlTgpDrr2xK2Xqn?=
 =?us-ascii?Q?YPE3soa4USt1kFZM5ifUmPNOkg6B30KoaJxN52jDNHvScbUyfCwpSn+oi7Qd?=
 =?us-ascii?Q?UZiQjq0SVBi+Tut+pnntkiVkRinYKhn8Rd6Yr17lJZIZA1b8G6bVK+ZSnsBl?=
 =?us-ascii?Q?OmJLyzmuT7wyWv8hTdgPD6UGfDYeJO1vTMyt4kbBz83T3XmJq1L61fYvDUoc?=
 =?us-ascii?Q?mQ2wape6Wn5bc9FURVgM6bmcZD2fvdY7yRDtK5r5udwQsaxDA1ZG2GCdGFxh?=
 =?us-ascii?Q?Os9sLm4k4PiSuhQ1WzPaq+cCgnl7QBZSPa0qG3K9ozCyS4MtT3X/WTQ4Ry0r?=
 =?us-ascii?Q?Xi90OThBel8EiARVP9BCE3LzPtoh2MJXcT5YIWsM0jxIXGPXJUTugo7U0yuV?=
 =?us-ascii?Q?+gDV+4XvFKLmBFqpjRu5VxoZyT2medAqJLFasGDNymxj+o7E5ToKFY732E+t?=
 =?us-ascii?Q?v2Y3F3afM+qxwMATe2Dmgh7DDX8YhdfrS6ub3eab?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR10MB8211.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?o41cn9+m9MZIT2DnFCLDXkpn9Yy8A8dWoL/kj5BQxvyYKp3PRxcsQArpMTdx?=
 =?us-ascii?Q?AXLXc5Jd2v/fGNiz/M3t2UKZnVWh+kDdZ5Uem4YDoK2gUSaTcNOb6mfti1hh?=
 =?us-ascii?Q?CcnAxnUmqfjecP1RPou5HwdkQX/zwRekdQrruartQtirwRCaeyrqNFHoyD6x?=
 =?us-ascii?Q?lY3Ua1Gx2or67Y5El7f7iPh7XE/7UcSI15Kxo864pg5uKuktl6youKJV/1vz?=
 =?us-ascii?Q?tuL1dKh7E+3XYjr2hlCKZG9cf4rxVvWGB0MSIsfnOm4sqo+U0Tc/1InSWZCu?=
 =?us-ascii?Q?e04rkktqonU7e0imGrFWCEx+KfFVh7qvqMi41rfBbbtqBE6YoP/PAxN41QXi?=
 =?us-ascii?Q?JXt2aCIGQ13VrvtspwaNMGV7eYxGs8FdLvB4LfB4g5wyS1QEXV8MF4AxckGV?=
 =?us-ascii?Q?TC2AYablEUrOfcGrHZPzHtnPt+fp03WgfOvU1EbHBEaLEGALmZe44BXkmlTD?=
 =?us-ascii?Q?tQ6f/89q7A2glsGeV5oMDDxD/Ml9+cKi/4MqFbQt89y7e4fZv/4UZIIlw0Vi?=
 =?us-ascii?Q?D8QD/709A63TK5teMfT7If8b+uTcOpDbqg0GOslIM/q6fxl1xb1YlAoCmcqv?=
 =?us-ascii?Q?LRA27kESWHVBD2XaCeqvqnsXriCqjxfvCjYhA4Dp2vwucbEExJAFWCfS/2nJ?=
 =?us-ascii?Q?1A+/NW2S9yuGEXhpBspds40zLo8iGBBRT3kdeL4PyZBt0v29EUl494UoxOkM?=
 =?us-ascii?Q?dDuoMrRC3phpejN635z4GkTlnAAdcA5ONfEqd8xGTkBRUzm5VP0yOvbCWtsL?=
 =?us-ascii?Q?HZItnp9obe2unqwrMB1e+QdslMqArc+fOiv5+UO8wSU6BLHLjQGQ7v+k1YLQ?=
 =?us-ascii?Q?aTIYQslI4DCgaoSwVXGc+d1VGJ6+Mw+b9qHUSrFQl3eDxIlhQ68py1uCGxPf?=
 =?us-ascii?Q?ivvY3stA2PrXfbwW+hj72iciYjLFpNLlqARdUcqx0EIvCZTQKECvWeACId44?=
 =?us-ascii?Q?O7r7DKg4GNagilR/pHGXSbIjxg+BwnmyRqF+CN3KBnyvVXOHNO1aiVUcGRlP?=
 =?us-ascii?Q?kzScJvpVvRFSKOtDH7j6QoAKQgobp+krhL90lAvTCKoMu/KCkqjwdSRRjGwD?=
 =?us-ascii?Q?dvpZFQkY4REyVSVNMgS1YC+YxGe92p4WR7aw/GOI4KbZ0wszbe9o3SyICEWg?=
 =?us-ascii?Q?wNwmTWrmlSk9VSmrqW5KTQnKCU4IU+Z1laMrsEwgTT2kYB5X60ewtZIy3z75?=
 =?us-ascii?Q?WGmpB4HbptKTdtUjf+GmMiPraUqlQl2gUHwYchYCgx1DrA0YhJQEJWZYye4t?=
 =?us-ascii?Q?M9oMxQbkn0BbJkdrQzsC4LSsPs2yFdFNrKs+mpL8FvqeCNQ8/SXG/Wtc+8Gd?=
 =?us-ascii?Q?iHQaQA1lcBFENS8GyGlGjgVeSrz65fnqqaiDemisnHhwfV2B3xzM00uRmrZE?=
 =?us-ascii?Q?GBGB67LVhkHJbQGvt509lBt868rojdhBn0c2BQtoJAs+c1rwEkrqKefrSOgN?=
 =?us-ascii?Q?FJsDmqehwgkL3043AKABoNdV2T8sfnJZq2HeivmGuWNIqvizHSv51vsGnBf/?=
 =?us-ascii?Q?WfietYyhP7ChU5xIhq+Gq+mO2CJ/nLBO5pBbPDPw0RuVTAAFCdvXwUOEiZCV?=
 =?us-ascii?Q?kSQPOBVDweOH39IrAkHiyYJbPIskZ95K1ug3iB2MFK4RRVGNkB1mzteTyQkx?=
 =?us-ascii?Q?O6ZQFWlUMSuYTqeS4u4BURE3gFvLaopILkpccpH2aSLI21yzk0SSHqUuK0ZC?=
 =?us-ascii?Q?PMUYc0Cr8PROGRPqbiUv5VA859VwPkk0zrveMZXACQDU/HALaArtVrRhSsxM?=
 =?us-ascii?Q?4RmPG14cKI6zz1pFYeQe5d+2USQgB1o=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0L4ibZvlq61KpsoMZWw7VdJfZeld437YiXbw+QDRMYk7atLbVLkCx9Q9SJ3ENgb5IS/osvvjk8RCeDJWKdtl9Xx/69ELTt7KrM+k12hD/dmHjkh4f5LVFLlJqkmnyooDNhVSa6KxBYMVAlcjdhTX9fLdUOTWFQD7jPkZalbCx59Jb1hYlHnS4AWTy8bjBBMf6dUwhRma+oiLodaT4jZpK8ZjtxCQHEMRcLdvpSl4QzLEDNRHT4IrlnqT0Jyf0hcTfJaM4JcLEpLvrbKbG+SYNs1mImPxDdcwtWIe4KEom8xXFyqbX3w7SzCOW2kMZVWb+sfSu0jg0yFi29wtLJRva6wtHNZejzzHm6du1x9ZmFZfVCdsL0RfC9qqngHV3r1PUjpp3f8dWK8i59JnwY6jFh+Joi2ZphQaQjOsH71b/qw8kTzE8wnqTtMxk3WU00/VZ94aAejWDMrq24+O2DEoQFhoqd2ZuSUs08jqfDMfWBo5N60x2JYDleLEoebYDkFwkUBepdP+SGsLiGEYyOAoB9RgRO47qjIJS+o/glru8BQa65n0iMIZQUXm6uIpkjIRmxKJTBIiyRsTvERjTykd+CIUMKnoyCr4CUfuSI6Wqi4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cf5f213-a2c0-4e84-9dcd-08de5f59ce82
X-MS-Exchange-CrossTenant-AuthSource: IA1PR10MB8211.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 17:14:05.6713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 55315NME4RSsqUgTcKWVtzosCN3OexltbP1UA+yF7wEFchwR9QCWeZXHRkKXskWXukaBeZatrXCVlP41QF6dBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0BB87A13E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_02,2026-01-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601290121
X-Proofpoint-GUID: s6IzCljOVwol7oJuC6SSUlr9RWxbB2it
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI5MDEyMSBTYWx0ZWRfXwF12RnbppTtZ
 J0SDTVxhu8BPf9AWukYyOMH48/l/Bh6kWcCKrH+HZawQkVlbNs/ELI76+TeLdgL+3i0/hIesT2B
 IIg0ztJUyaSO6RjWIScJY2QFyJajzxTNNY1XMai+jeM91/lfojzY7GVMt2F8k63FmHIBxE5QQwr
 BrI9LsdWy2X/e+jvmFskXlLmKIEINhrvFeNV31aWvhE1a0dGd0PE72FUNjtzxGWIoXBI9hQnIKz
 R2E45KlM12ZopBgsVvxHQudJLXRC5icABcvjyw1JVkMImHo0NVeX7Mq3eigHCdewJEy1hTDrjM+
 ejeYlJZ+EJrn20mGIsq9q1WgpLxhfROLCiWOSUnPGBOWNkFXES3Nfx0xZNYPH/pOFlSBRG/Ph6Z
 RfbEdDJOORCBjLf5cSE7CGMR9RRBzWu74ODpfNz+3ZspAgi83+QzGAC30VrVntnposBuxQVHxZj
 59M7ASfFEK53V3N6RGw==
X-Proofpoint-ORIG-GUID: s6IzCljOVwol7oJuC6SSUlr9RWxbB2it
X-Authority-Analysis: v=2.4 cv=a7s9NESF c=1 sm=1 tr=0 ts=697b9562 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=t-KWgYVzO7HJYDEL9H8A:9 a=CjuIK1q_8ugA:10
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[oracle.com,reject];
	R_DKIM_ALLOW(-0.20)[oracle.com:s=corp-2025-04-25,oracle.onmicrosoft.com:s=selector2-oracle-onmicrosoft-com];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69574-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,char.us.oracle.com:mid,oracle.com:dkim,oracle.onmicrosoft.com:dkim];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DKIM_TRACE(0.00)[oracle.com:+,oracle.onmicrosoft.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[konrad.wilk@oracle.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: DF947B2B76
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 05:14:32PM -0800, Sean Christopherson wrote:
> This is a combined series of Dynamic PAMT (from Rick), and S-EPT hugepage
> support (from Yan).  Except for some last minute tweaks to the DPAMT array
> args stuff, a version of this based on a Google-internal kernel has been
> moderately well tested (thanks Vishal!).  But overall it's still firmly RFC
> as I have deliberately NOT addressed others feedback from v4 of DPAMT and v3

What does PAMT stand for? Is there a design document somewhere?

> of S-EPT hugepage (mostly lack of cycles), and there's at least one patch in
> here that shouldn't be merged as-is (the quick-and-dirty switch from struct
> page to raw pfns).
> 
> My immediate goal is to solidify the designs for DPAMT and S-EPT hugepage.
> Given the substantial design changes I am proposing, posting an end-to-end
> RFC seemed like a much better method than trying to communicate my thoughts
> piecemeal.
> 
> As for landing these series, I think the fastest overall approach would be
> to land patches 1-4 asap (tangentially related cleanups and fixes), agree

Should they be split out as non-RFC then?

> on a design (hopefully), and then hand control back to Rick and Yan to polish
> their respective series for merge.
> 
> I also want to land the VMXON series[*] before DPAMT, because there's a nasty
> wart where KVM wires up a DPAMT-specific hook even if DPAMT is disabled,
> because KVM's ordering needs to set the vendor hooks before tdx_sysinfo is
> ready.  Decoupling VMXON from KVM solves that problem, because it lets the
> TDX subsystem parse sysinfo before TDX is loaded.
> 
> Beyond that dependency, I am comfortable landing both DPAMT and S-EPT hugepage
> support without any other prereqs, i.e. without an in-tree way to light up
> the S-EPT hugepage code due to lack of hugepage support in guest_memfd.

Can there be test-cases? Or simple code posted for QEMU which is the
tool that 99% of kernel engineers use?

> Outside of the guest_memfd arch hook for in-place conversion, S-EPT hugepage
> support doesn't have any direction dependencies/conflicts with guest_memfd
> hugepage or in-place conversion support (which is great, because it means we
> didn't totally botch the design!).  E.g. Vishal's been able to test this code
> precisely because it applies relatively cleanly on an internal branch with a
> whole pile of guest_memfd changes.
> 
> Applies on kvm-x86 next (specifically kvm-x86-next-2026.01.23).
> 
> [*] https://lore.kernel.org/all/20251206011054.494190-1-seanjc@google.com
> 
> P.S. I apologize if I clobbered any of the Author attribution or SoBs.  I
>      was moving patches around and synchronizing between an internal tree
>      and this upstream version, so things may have gotten a bit wonky.
> 
> Isaku Yamahata (1):
>   KVM: x86/tdp_mmu: Alloc external_spt page for mirror page table
>     splitting
> 
> Kiryl Shutsemau (12):
>   x86/tdx: Move all TDX error defines into <asm/shared/tdx_errno.h>
>   x86/tdx: Add helpers to check return status codes
>   x86/virt/tdx: Allocate page bitmap for Dynamic PAMT
>   x86/virt/tdx: Allocate reference counters for PAMT memory
>   x86/virt/tdx: Improve PAMT refcounts allocation for sparse memory
>   x86/virt/tdx: Add tdx_alloc/free_control_page() helpers
>   x86/virt/tdx: Optimize tdx_alloc/free_control_page() helpers
>   KVM: TDX: Allocate PAMT memory for TD and vCPU control structures
>   KVM: TDX: Get/put PAMT pages when (un)mapping private memory
>   x86/virt/tdx: Enable Dynamic PAMT
>   Documentation/x86: Add documentation for TDX's Dynamic PAMT
>   x86/virt/tdx: Get/Put DPAMT page pair if and only if mapping size is
>     4KB
> 
> Rick Edgecombe (3):
>   x86/virt/tdx: Simplify tdmr_get_pamt_sz()
>   x86/tdx: Add APIs to support get/put of DPAMT entries from KVM, under
>     spinlock
>   KVM: x86/mmu: Prevent hugepage promotion for mirror roots in fault
>     path
> 
> Sean Christopherson (22):
>   x86/tdx: Use pg_level in TDX APIs, not the TDX-Module's 0-based level
>   KVM: x86/mmu: Update iter->old_spte if cmpxchg64 on mirror SPTE
>     "fails"
>   KVM: TDX: Account all non-transient page allocations for per-TD
>     structures
>   KVM: x86: Make "external SPTE" ops that can fail RET0 static calls
>   KVM: TDX: Drop kvm_x86_ops.link_external_spt(), use
>     .set_external_spte() for all
>   KVM: x86/mmu: Fold set_external_spte_present() into its sole caller
>   KVM: x86/mmu: Plumb the SPTE _pointer_ into the TDP MMU's
>     handle_changed_spte()
>   KVM: x86/mmu: Propagate mirror SPTE removal to S-EPT in
>     handle_changed_spte()
>   KVM: x86: Rework .free_external_spt() into .reclaim_external_sp()
>   KVM: Allow owner of kvm_mmu_memory_cache to provide a custom page
>     allocator
>   KVM: x86/mmu: Allocate/free S-EPT pages using
>     tdx_{alloc,free}_control_page()
>   *** DO NOT MERGE *** x86/virt/tdx: Don't assume guest memory is backed
>     by struct page
>   x86/virt/tdx: Extend "reset page" quirk to support huge pages
>   KVM: x86/mmu: Plumb the old_spte into kvm_x86_ops.set_external_spte()
>   KVM: TDX: Hoist tdx_sept_remove_private_spte() above
>     set_private_spte()
>   KVM: TDX: Handle removal of leaf SPTEs in .set_private_spte()
>   KVM: TDX: Add helper to handle mapping leaf SPTE into S-EPT
>   KVM: TDX: Move S-EPT page demotion TODO to tdx_sept_set_private_spte()
>   KVM: x86/mmu: Add Dynamic PAMT support in TDP MMU for vCPU-induced
>     page split
>   KVM: guest_memfd: Add helpers to get start/end gfns give
>     gmem+slot+pgoff
>   *** DO NOT MERGE *** KVM: guest_memfd: Add pre-zap arch hook for
>     shared<=>private conversion
>   KVM: x86/mmu: Add support for splitting S-EPT hugepages on conversion
> 
> Xiaoyao Li (1):
>   x86/virt/tdx: Add API to demote a 2MB mapping to 512 4KB mappings
> 
> Yan Zhao (6):
>   x86/virt/tdx: Enhance tdh_mem_page_aug() to support huge pages
>   x86/virt/tdx: Enhance tdh_phymem_page_wbinvd_hkid() to invalidate huge
>     pages
>   KVM: TDX: Add core support for splitting/demoting 2MiB S-EPT to 4KiB
>   KVM: x86: Introduce hugepage_set_guest_inhibit()
>   KVM: TDX: Honor the guest's accept level contained in an EPT violation
>   KVM: TDX: Turn on PG_LEVEL_2M
> 
>  Documentation/arch/x86/tdx.rst              |  21 +
>  arch/x86/coco/tdx/tdx.c                     |  10 +-
>  arch/x86/include/asm/kvm-x86-ops.h          |   9 +-
>  arch/x86/include/asm/kvm_host.h             |  36 +-
>  arch/x86/include/asm/shared/tdx.h           |   1 +
>  arch/x86/include/asm/shared/tdx_errno.h     | 104 +++
>  arch/x86/include/asm/tdx.h                  | 127 ++--
>  arch/x86/include/asm/tdx_global_metadata.h  |   1 +
>  arch/x86/kvm/Kconfig                        |   1 +
>  arch/x86/kvm/mmu.h                          |   4 +
>  arch/x86/kvm/mmu/mmu.c                      |  34 +-
>  arch/x86/kvm/mmu/mmu_internal.h             |  11 -
>  arch/x86/kvm/mmu/tdp_mmu.c                  | 315 ++++----
>  arch/x86/kvm/mmu/tdp_mmu.h                  |   2 +
>  arch/x86/kvm/vmx/tdx.c                      | 468 +++++++++---
>  arch/x86/kvm/vmx/tdx.h                      |   5 +-
>  arch/x86/kvm/vmx/tdx_arch.h                 |   3 +
>  arch/x86/kvm/vmx/tdx_errno.h                |  40 -
>  arch/x86/virt/vmx/tdx/tdx.c                 | 762 +++++++++++++++++---
>  arch/x86/virt/vmx/tdx/tdx.h                 |   6 +-
>  arch/x86/virt/vmx/tdx/tdx_global_metadata.c |   7 +
>  include/linux/kvm_host.h                    |   5 +
>  include/linux/kvm_types.h                   |   2 +
>  virt/kvm/Kconfig                            |   4 +
>  virt/kvm/guest_memfd.c                      |  71 +-
>  virt/kvm/kvm_main.c                         |   7 +-
>  26 files changed, 1576 insertions(+), 480 deletions(-)
>  create mode 100644 arch/x86/include/asm/shared/tdx_errno.h
>  delete mode 100644 arch/x86/kvm/vmx/tdx_errno.h
> 
> 
> base-commit: e81f7c908e1664233974b9f20beead78cde6343a
> -- 
> 2.53.0.rc1.217.geba53bf80e-goog
> 
> 

