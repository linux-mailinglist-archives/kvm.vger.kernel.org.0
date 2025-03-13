Return-Path: <kvm+bounces-40876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29D7EA5EB1F
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 06:23:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6926117A91B
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 05:23:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 799DE1FA14B;
	Thu, 13 Mar 2025 05:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Umv00b05";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="P2QCm0A0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6701D5CDE
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 05:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741843382; cv=fail; b=pIh2AOHf/KUEPM+Tbp9Ocfod1ilrvea5y0ERdLl1t0GVavH5S1aEBzBoqqpFEGpBh7XxWyJ/Ae7EDJ12Y5NC3iPQGQ2jq3fhNq5KEF/Xrq0gQz6GtAYqbCNSWPEQHCDTyw+y30xL33qL7eoabWaZboNs0ea7lSHJJ8RFTQ1V8es=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741843382; c=relaxed/simple;
	bh=k5ApVM4ZkA12L99n+lq78dmhdC477FzPX/07mt5O1PE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c8gb5TPOwI+3BDkru1NoJaWouwd3kNcY9ZgkgaHv7KBkq0eM8SNigUiXTkq2baJH/jm+E1KarWV6WIpRY8zUcH64KDB4hOJ3sdFqAFM6cWXz5HU/APcU5GIaPaTfWKz+gJ4lbVSes6OA5v04Ytgg86tPF46Ndopt6fEyjqPoXFc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Umv00b05; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=P2QCm0A0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52D3tmwX024188;
	Thu, 13 Mar 2025 05:22:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=osV83JdKhfLPCqrUijMecGqAfiS7Na/MQ3l2kxSqkxQ=; b=
	Umv00b054WXwUc9ZrTJqtnMek9ZwMKIpDtbZypojUFUHrVS22TSLtM9yr6OMObXr
	hqNdFxBdip44uA9ibi2V3IFYPzMJAKNHqN6JgFFrVp8xvktW2MtCFcC7JGo263eg
	+D9G+y4MzjSupAbRGgI0HZkPHSIlo5nbwgK0MEt/66sTVwwX9DM6hM2URqxb+Eqw
	RNKhrTPfJwQgDX5k3IcORnEemHI8CQOEnwQoTzkTthhbaF9bBORY5pHSrdJEb33u
	3j7N7XYIyvoxyKdjr98lVsJQzmq3+acKqzNGEbiKc0THHuJddiJlhGvc+n37nlCZ
	XHfx02ky7gc5s48+9KiqgQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45au4dkf1f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 05:22:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52D3WRUs008738;
	Thu, 13 Mar 2025 05:22:45 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2048.outbound.protection.outlook.com [104.47.55.48])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45atn47gj9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 05:22:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PfyLgqWne8+etoF15Y1PI42De3IkEDdJtUIJMzFRW2a8bhle4ABAulQMFGK6cHO7DdnQ1WeI5nu+0UpxewNvP+ERGL6VYWU9JKZxHXMFJcY7/NXe83XhjxRYugL3Ip9U3BtgdvPLL8FmQmgTOUd/RLa373I9pjECtrRFKGmhGamzdVfQxBqwrX031Mms0ZifcPEBsZUZ1ek0XaTwzi+SsF1MCcD3Mw49vp1Cja+xIjEXBzRAQPu/Q01guHQYqVtEZZWYOo1m9+9FnU5t6MxTB6yK6dYv27TpFrQinKGxHoSiIn2lxK/g7wrCPMdHnlBry4Nlz/gUEbhqsoIfjOuPHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=osV83JdKhfLPCqrUijMecGqAfiS7Na/MQ3l2kxSqkxQ=;
 b=XdhHbiyFH/vnpKhwrRhJPWnL/IL/IVjRpLzw8/iCSeHGgZUz2qVbT6XfWF+XuWwayi/Zg4vuFcxXeOLAK4Bt+9qX63ibMAz56tSwUPXkbZ+ZHF7Rt/97mFTiaCZ2jaa+QHiX/vNs8rsnbJY3THppiymzOEtlkJrvahCUfn075urBHguI4eE8blBhYThUrs+eyC9lheMgvYvaHYso6CyDLOlrhZV6laDbYxw85Twe45M96oHKxX3pMhEo2R9Rmq6qDa45BxC9MowHu40KSORFBPYjt6pOJHBZfbSPeKGIwXShF7nbp3eXolcLzSr0VBvsUtUUqFJQvH5/zetgYUTIIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=osV83JdKhfLPCqrUijMecGqAfiS7Na/MQ3l2kxSqkxQ=;
 b=P2QCm0A0OdLAsAGltMdVQqNnrjE5j1PS99T4ujf6+d2YsIbJizSx0KapEvg8ngJDCEU1fb6OE/+Tp9cNLsjCSd4XUEanyHI1x2qeIfWmMzpXyC/gpVuJLIlkPylVmuvuHreR7aN/lRzWWbLYfqNOQcFZHkvm7dJqb2TG4IHCGV0=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6724.namprd10.prod.outlook.com (2603:10b6:208:43e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Thu, 13 Mar
 2025 05:22:42 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8511.026; Thu, 13 Mar 2025
 05:22:42 +0000
From: Mike Christie <michael.christie@oracle.com>
To: chaitanyak@nvidia.com, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        joao.m.martins@oracle.com, linux-nvme@lists.infradead.org,
        kvm@vger.kernel.org, kwankhede@nvidia.com, alex.williamson@redhat.com,
        mlevitsk@redhat.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 10/11] nvmet: Add addr fam and trtype for mdev pci driver
Date: Thu, 13 Mar 2025 00:18:11 -0500
Message-ID: <20250313052222.178524-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250313052222.178524-1-michael.christie@oracle.com>
References: <20250313052222.178524-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0084.namprd03.prod.outlook.com
 (2603:10b6:610:cc::29) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6724:EE_
X-MS-Office365-Filtering-Correlation-Id: 69e776cf-90e3-485b-436e-08dd61ef1484
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5bQfOJGUZiTM0L8vDtDIN+mhAQkVicuucTXVPmWpiMyKYNGTZLKQ16nAazD7?=
 =?us-ascii?Q?WWtqll1eDcNWOqmsm21976QvQaCdzRevlsudR/8c7EklCzpP7WHCHgjp6+7r?=
 =?us-ascii?Q?minACNXN3vhrwC5xswx09YX7lnmlvGVJvhm3eg9MmgsAjScpTUjdijno1rjP?=
 =?us-ascii?Q?cBsA5LL1tW8SCfLuCZ2jCYGcxKP1vP/ObCl6HuKTQbFsBSjSWK0EntGLD5Pf?=
 =?us-ascii?Q?mLhydRvkbt2o040JiU0srsQ/jX9vZksV5KnJLXRm8LLwVoNlWKczmfZZlbWq?=
 =?us-ascii?Q?xjjFgenoAK5Az+oIBUe6KU7yzH3CaTNw6YyJYVMbKxw3dXTdi4cRHl7RQyhz?=
 =?us-ascii?Q?Lk02UiuqL/CXfzJdZAOs8pJPxcpO9gag/yaE7Rp3jaaHwXQNBU69G+oLfxBd?=
 =?us-ascii?Q?6JjIe1KzBYTi30gfxD0awFo0eHCRQGjlYMk3no0ht3Lak+VXPv/0vcyZJ6BF?=
 =?us-ascii?Q?jXG0hviUGxyZyeOxgdo9/dG6OHvR6No/ccNK4SWkTWP1hzM5Lqfc4wkB/GBI?=
 =?us-ascii?Q?dsUOoT1TnVtdWzs3ddr9Oia/JErSIPGYnWHyq00qaQOD1jWPkdKrArcDpdbZ?=
 =?us-ascii?Q?akW3VmyqRmUk/N3mbJ3Q0wIqUNfAdg7dd4XeU/ARQWjNJwShzMMDZbhKvesT?=
 =?us-ascii?Q?7MbvtQsXRa+r6zGFgpJG9xB6//pohVpItA9QuhZMZlyg0MLTdv7QrISlYnhm?=
 =?us-ascii?Q?H2nwnMq1nBEGeVBHKrW/dI0NcGlizATY0v4IfgKTqTO7rNxCXxN8ldD2hais?=
 =?us-ascii?Q?Y/FUf/Twu3PfFUMsXv3owVwqRs78bmQhNK/kuLue72O0AEiORv5FvSE8LUTN?=
 =?us-ascii?Q?3MVKLghrhsarb4wNuXXb6PlJTlc7xLZmdQJy0tS0yZsWeM3maXrMoq/GzUil?=
 =?us-ascii?Q?1UWA0nlo+FjuzLf6dQqccqoxzG76kiXaVYW6DVVDyl1OkCSCgEyCgBHm5nhe?=
 =?us-ascii?Q?7NzZC0u36ga5SXH/HIcOkyRrTy/DOQB3JrRR7Ok1huDfqEQ7koI1juT+7Ipr?=
 =?us-ascii?Q?iDz9CGHMj46EIOA6edjr17W5nEknRY64ILQwtx6xvc0AsQZAubT8Qo8VJO7T?=
 =?us-ascii?Q?1pdwh26PJYm5uI8qt9beJ1ef0cQnZGmGjG08HDzRFby8sw40/hTQxvuGnFiP?=
 =?us-ascii?Q?b1f8xfN6P81uHv4FzbPvd+ZNzTdw9I/DNY5YLZqh6xY/WqCIOHKzlFlQY2J3?=
 =?us-ascii?Q?Gt7Z1MKbAdITDUX0W6eSlWq02DfaRkPA/JtwPxKFHiRb1xFDEHnzTFxW5Q4g?=
 =?us-ascii?Q?+i2FXnK6Ph2S0YFaZATuEuPLpZInyQBRz3/g2rGuHh4VRqf1R2Of/HR2n/Ej?=
 =?us-ascii?Q?D0ok5IGfT90KcqGWc7FPuPX+hh5jFqvzi/xfqKeUiEKO+QKW1U+wvxoeL+BH?=
 =?us-ascii?Q?PaV8rGoHu2E6CaawCqMb15Q3rAfBODwPeh9Wq/usCYO8B9ryvDLPHESOIA8f?=
 =?us-ascii?Q?6ShTC0D9CJI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?O1vvtnJ6euwJuomCK4d3nEO/+v7D5cCmLxslbo9CYrDUToDMeD6vdbcL9acO?=
 =?us-ascii?Q?8WXiMTBj3wgvmdSWMVpiHyay6odQKXjDWidYkwJmHw1t51zTknmFOvUaieya?=
 =?us-ascii?Q?XEg5Q8vPsMl/iSNCRiY0xtRSJ4wFO9WKOcXnmoyeRTp1Gz89o4/2QaIkBQGI?=
 =?us-ascii?Q?L5NGtVL5lPW0ZChj6c1lmS/fQKdnlDsMXhwPrzhbvZHNDnHTIOvFno2Sd1WP?=
 =?us-ascii?Q?jXG0IPiD8mBKx6/PqySC1nfszONPyPZpwFm6gLpi62TMyNvOK1IL1/d5rlPv?=
 =?us-ascii?Q?3zLv+qEorZqJ9ZlCLBOfvfaP5SKbWdTwRNwX9tT7dfP/NWmxZjA3PwlG+xSn?=
 =?us-ascii?Q?GV69gujWCD04qWuZQqMRlbChWH71Zfn/FJ4ay3Vp3ElRwvLwcZnBKj3k97uZ?=
 =?us-ascii?Q?no71hK0nhbS/CXHk4RZvpKIuN4auPGKB60yZy4lYeCiqkNO6H1I1bpFFNDXJ?=
 =?us-ascii?Q?kvSWSevgh6yAa5Yg5xzTE6zcqMDU2AEuMtu+V4VNIDRqNTJgx4xUUuwNf+M1?=
 =?us-ascii?Q?V6S+VBEU3dubPq+ljG/SoaisSxg8x45VwVBYJ8D6FuKAWW7g5Oy5zOMIXIUp?=
 =?us-ascii?Q?7sLgnmC6ZWRAtJMIkYkYNyV84tvCxOcIOZFiZm3i1heIDt+Jv+F+pATqfQLp?=
 =?us-ascii?Q?A0j4eClsrl6rbpUCqwaP7SDy3tI5fzSjrQoNPvvguVdgZagGWOJH24q/kk6M?=
 =?us-ascii?Q?3n88LdCJHrYCNRkThL0hLSgXaB6zQty30rtJDxgP8WE7D06tRMGiymfn7sqz?=
 =?us-ascii?Q?YaqYCMeOfAPvIX0WNyNj6kQ0uiGvInSjpvRxsa7JFALzyc6yB5FT8ybrqH5S?=
 =?us-ascii?Q?83Dyic8g6qblYDcs0RtV1871cxZBbRrIDH3dAvObIBmEAdXO+zCA8oKi4wFI?=
 =?us-ascii?Q?69jl++wV4idPUYjqAn8oz6nHSusJGZtCvAikUFZWBTfaPaFhH3s5JZUHDxCc?=
 =?us-ascii?Q?+gBhUjSZqrYbbTyPJMTt9eIaSy6CoIbeJ8+4tcC+N8pPUE2uKjT2q+ntfIwX?=
 =?us-ascii?Q?LeuvZRezrH1wqSeCAxMxu3FR+eQqNEN67aRczdLBZCBZKOWb4mkZ4RLkErCu?=
 =?us-ascii?Q?ZqN+I7gjam70UlMRcWklgKDeUcFPFkwt11sRCUZUs8wTv3TL70myJMeFc/t1?=
 =?us-ascii?Q?SQUkaNc3lLP8SMbnVMH36hnVIsJ+cKze+Ip3I/Y4a1SW6xlEFtmoqJ6aCL2Y?=
 =?us-ascii?Q?CR502z4dFnFtwf333VDkIkzN8cLkavkjzaGyWI9nw3RkWNW0UNq37f1qZdMo?=
 =?us-ascii?Q?0o1XkebcvTms1vYYKrQ+OTlAyCuQEa9ULnUiz5uShLsO7+NEvxwNtKwSC9lg?=
 =?us-ascii?Q?JXKC8wQvicSMePp9VAqIu6Djqbbq9DUX5kS02YBuF/GBd2HuvI8hAiWYxrfT?=
 =?us-ascii?Q?Znl0icptI9ZHRlRqiqXaXv+Sk78PVe4We+WtRn4ES6Jr0Nao6ccnYvhV/RvB?=
 =?us-ascii?Q?6/ibXtLSNZv9VMCjQ6o6iYtZbNzc3YBV53BORKxzKwGs78TpkAWWxHrjUavP?=
 =?us-ascii?Q?ABvrlVE7BI4dqQCpOtMEsWY7U9troXWVZs6uuw4fMJh2QU9S4VbN/zBl7mhN?=
 =?us-ascii?Q?RM0PXdhSjTtk9AFV6CEQzANUNajjcSdmeuV3JazRBmjsHFRhzwgfTKgHxjDJ?=
 =?us-ascii?Q?ww=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Rv4kJFVnPwMP7lC3yxfCZEUfcXN9xj9d+k6jf0u/eWcaFBF4Vq7LQEDnn1YgSb9rT55tWz30Hw+FaXiOqhZmQcH7c6SXjUAx3K1y4kIkXA/1yHUKD3XKh8F9mblJ0fl1G+XapR720GONAh9LSx2wjgDBsSdp5CYb8NwRNPwdsBa07BTiu2xmxrvcr6+mqAiL1w6pTOg02BlOlq9aWEAh5eEMHKjB3+kCiDhF46xMQW2alkCbHb6s7QnS3/E30PdQCZzzUFibKediK2993Skk7U4u7CUbH8OJ69TTIoCk89IE5oHP9HS9JgvTrKrMX3jwr1cp1h90CPKTMkaiqw3z6P1o+9naJMRJK8An5GzIZMtkyEsKS6E2YTnsKsXwAcJQBRe35f/+0DRGXDOFufZpuI+s8Ogbp7+aPpCjVyxLieWiJ5KEgvKdL4lIEJFTE8phGfHLo/Llp+MnFiMw39ePQLcDHr+Qd2xkVZYSnqYaBpL8HWo1kBeglGkhGfaTCAWg5JhYUT8jCPuLC9YSFADYMbenZ5YJar5gUuzVZ6YZV6PvCCl3Bsj4zASDYjBAkSC9X/QMuM6YCS4sLLriOlN5Ngy2i5pkae3ol6D7UZOpRMA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69e776cf-90e3-485b-436e-08dd61ef1484
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 05:22:42.6704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6+3Wt7UDIdSXDqVKn14uVh65NcSVda7Uuww/T9m8Xbwp7z5+9h2O142YrzLViw+8/Lzx6YpXB1FhLaMvL1GlyvkdLsA8k3HGKuZ6Hesh5Ys=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_02,2025-03-11_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503130040
X-Proofpoint-GUID: oyxVwlLKwnDN_mBN9L9Qm2FZataF4K_R
X-Proofpoint-ORIG-GUID: oyxVwlLKwnDN_mBN9L9Qm2FZataF4K_R

This allocates 253 for mdev pci since it might not fit into any
existing value (not sure how to co-exist with pci-epf).

One of the reasons this patchset is a RFC is because I was not sure
if allocating a new number for this was the best. Another approach
is that I could break up pci-epf into a:

1. PCI component - Common PCI and NVMe PCI code.
2. Interface/bus component - Callouts so pci-epf can use the
pci_epf_driver/pci_epf_ops and mdev-pci can use mdev and vfio
callouts.
3. Memory management component - Callouts for using DMA for pci-epf
vs vfio related memory for mdev-pci.

On one hand, by creating a core nvmet pci driver then have subdrivers
we could share NVMF_ADDR_FAMILY_PCI and NVMF_TRTYPE_PCI. However,
it will get messy. There is some PCI code we could share for 1
but 2 and 3 will make sharing difficult becuse of how different the
drivers work (mdev-vfio vs pci-epf layers).

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/target/configfs.c |  1 +
 drivers/nvme/target/nvmet.h    |  5 ++++-
 include/linux/nvme.h           | 14 ++++++++------
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 31c484d51a69..73bab15506c2 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -39,6 +39,7 @@ static struct nvmet_type_name_map nvmet_transport[] = {
 	{ NVMF_TRTYPE_TCP,	"tcp" },
 	{ NVMF_TRTYPE_PCI,	"pci" },
 	{ NVMF_TRTYPE_LOOP,	"loop" },
+	{ NVMF_TRTYPE_MDEV_PCI,	"mdev-pci" },
 };
 
 static const struct nvmet_type_name_map nvmet_addr_family[] = {
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index a16d1c74e3d9..6c825177ee87 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -755,7 +755,10 @@ static inline bool nvmet_is_disc_subsys(struct nvmet_subsys *subsys)
 
 static inline bool nvmet_is_pci_ctrl(struct nvmet_ctrl *ctrl)
 {
-	return ctrl->port->disc_addr.trtype == NVMF_TRTYPE_PCI;
+	struct nvmf_disc_rsp_page_entry *addr = &ctrl->port->disc_addr;
+
+	return addr->trtype == NVMF_TRTYPE_PCI ||
+	       addr->trtype == NVMF_TRTYPE_MDEV_PCI;
 }
 
 #ifdef CONFIG_NVME_TARGET_PASSTHRU
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index a7b8bcef20fb..994f02158078 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -53,12 +53,13 @@ enum nvme_dctype {
 
 /* Address Family codes for Discovery Log Page entry ADRFAM field */
 enum {
-	NVMF_ADDR_FAMILY_PCI	= 0,	/* PCIe */
-	NVMF_ADDR_FAMILY_IP4	= 1,	/* IP4 */
-	NVMF_ADDR_FAMILY_IP6	= 2,	/* IP6 */
-	NVMF_ADDR_FAMILY_IB	= 3,	/* InfiniBand */
-	NVMF_ADDR_FAMILY_FC	= 4,	/* Fibre Channel */
-	NVMF_ADDR_FAMILY_LOOP	= 254,	/* Reserved for host usage */
+	NVMF_ADDR_FAMILY_PCI		= 0,	/* PCIe */
+	NVMF_ADDR_FAMILY_IP4		= 1,	/* IP4 */
+	NVMF_ADDR_FAMILY_IP6		= 2,	/* IP6 */
+	NVMF_ADDR_FAMILY_IB		= 3,	/* InfiniBand */
+	NVMF_ADDR_FAMILY_FC		= 4,	/* Fibre Channel */
+	NVMF_ADDR_FAMILY_MDEV_PCI	= 253,	/* MDEV PCI */
+	NVMF_ADDR_FAMILY_LOOP		= 254,	/* Reserved for host usage */
 	NVMF_ADDR_FAMILY_MAX,
 };
 
@@ -68,6 +69,7 @@ enum {
 	NVMF_TRTYPE_RDMA	= 1,	/* RDMA */
 	NVMF_TRTYPE_FC		= 2,	/* Fibre Channel */
 	NVMF_TRTYPE_TCP		= 3,	/* TCP/IP */
+	NVMF_TRTYPE_MDEV_PCI	= 253,	/* MDEV PCI hack */
 	NVMF_TRTYPE_LOOP	= 254,	/* Reserved for host usage */
 	NVMF_TRTYPE_MAX,
 };
-- 
2.43.0


