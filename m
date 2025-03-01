Return-Path: <kvm+bounces-39807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 074A0A4AD17
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 18:22:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0375916F31B
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 17:22:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A5D21E5B68;
	Sat,  1 Mar 2025 17:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Uc7zB2T8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OmJ8ZYyC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C0B1E0DE8;
	Sat,  1 Mar 2025 17:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740849759; cv=fail; b=dI03OD3vTHphMFw2gRbPnLSlLC1Si35Qs5ipVF9CqAmE/Qx6UHb32EEx+eErPjLseRGXo1500PzB12k17k2ftARzLmdqyK2qogjV6cUR9osk23yzHz2M6Xhz8zo7Pythwh0oPNMRSEtAfgkkZBbKs2Rsc+Za0pfEMaQAiCPcTow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740849759; c=relaxed/simple;
	bh=w0HrA0jQQgjicY0vp7EIyOTT6CJCbna5ddrQEFIxSaA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EC/CxeR4re4qNjh/aKAMiN3l15hcUpm3Q+GK66qxBf4G+JhlfKJZZHbM9AUiOcr+IkUwJdPEgE7BpqLtxWrWrkqbea2R8GIQ/ns8EqM0uyoUJ93nsABCWUq2eURbtGG23/l/WkAUzi+NlLcb/GJ0tgkg/RAtFymbI9N3S6hZZps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Uc7zB2T8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OmJ8ZYyC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 521Eev3l027475;
	Sat, 1 Mar 2025 17:21:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=Vb/r4DY+omgcfG8RFz
	RspMgMUjgEHo/UW1Ez/QerdE4=; b=Uc7zB2T8z4q4zHTIfY0kktgnHKWu85BNZ2
	JVfXRIMa2dLUxREOKii1gL7TaD9MOEUw+lmX8/xlAhw5d7soj2nLEwMH4GWtUugL
	cvhblcjVEQlXNqZSh4rHiV1sGC6RemmTURywKsf51jBwzsi8Vt4Q2GJFj+MZoUKF
	ItUaTWbakkZZT89Swh2hPT229h9FSq8dWi96hk1r79av7U8dTdQAgjNlCT+MBa3N
	ZtYSbFw7cRkjZknvCiuynqyWnmNelZ1vSfpe+4VER8xc7cuVy2woQsvkYDgpHa+s
	l035vrxyAp3uU2umn0SJtizRXddnQr2y2fwWSkFDQg4DrClc65dQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u8wghrf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Mar 2025 17:21:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 521E2J2I019864;
	Sat, 1 Mar 2025 17:21:49 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2045.outbound.protection.outlook.com [104.47.55.45])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rp77reg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Mar 2025 17:21:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PdzVYS80/DW5m7iIjpiinSUzMCYJV5ndN/mPgXwDZuJ4PyHaJK2FZ4lluVW3VltApJ1pYN4BjziNEpdxNMnqBJRmN9TXsr7O55OseFOwHa9qiufh9lH+fH06xvFzcP/jKjH/ZdFWCw/O2huFaSsnTzuNROrA1nAgjFoy3/rtTJzJM4yuwZrz8jKfgZtEzFbiuxVJjfoUoAZg4oiQOMoGtmUgKSVU6DrHapSF3cRv7rbTYnFBgFaZsHwyzKJerm/YNa7Vyk2OWUiuyGEN/Td6LcKg1IggcnAaXQyLPoI6BJ4fRsHSXYmrpnL5UwHml8ItfAERDfLnG3zhsbaUAGkbKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vb/r4DY+omgcfG8RFzRspMgMUjgEHo/UW1Ez/QerdE4=;
 b=WVC+t6kyxJlkSRAhFLplJFH1qao6MfLyvrlowG6N+rXpV+5lE1jxDpHhf1Gx4pejBhcttuI4D0x+012cCpNcctWSTstHeQLHNzfuE9ut5f5REJz/EUXG6MvldEeBXIqN7dpIA2HLpdzKcjV95knV/Dt4StM0bXZmbpzAqtvQ3l6M1T75KgolNSDsrE0dWO3zvYWtXkT8SdAcDga+91yLz1gX+uAPssTgY0v4A1T+tbyLNl5EuQHbwy+SEwTiRjT2ILDOuhK/LMzSWaFS7gnllOoYg6ENOET4L4EkvZ9fjYn8L9a3v9e44+wqOhJhm72kZvKDhMMvKMea6RG/o/bnRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vb/r4DY+omgcfG8RFzRspMgMUjgEHo/UW1Ez/QerdE4=;
 b=OmJ8ZYyCcWVB/jp1Dxc19P4lVPcc+G4/AXVcLp9puEktSEwx6Kt89/2vVX80B975K4e6W8yy/rWTZl3dMQi2CNpUOe/KZpw6Giiv3EIBvvLT//waGGMxTP2LTegLriO3zJG0fatjWyUvQIjLN46d+F+NiWjIQwMMKOvPKuPiCnY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB7457.namprd10.prod.outlook.com (2603:10b6:610:159::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.25; Sat, 1 Mar
 2025 17:21:47 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.8489.025; Sat, 1 Mar 2025
 17:21:46 +0000
Date: Sat, 1 Mar 2025 12:21:28 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Suleiman Souhlal <suleiman@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ssouhlal@freebsd.org
Subject: Re: [PATCH v4 2/2] KVM: x86: Include host suspended time in steal
 time
Message-ID: <Z8NCGFcH9H14VOV-@char.us.oracle.com>
References: <20250221053927.486476-1-suleiman@google.com>
 <20250221053927.486476-3-suleiman@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250221053927.486476-3-suleiman@google.com>
X-ClientProxiedBy: BYAPR01CA0032.prod.exchangelabs.com (2603:10b6:a02:80::45)
 To DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB7457:EE_
X-MS-Office365-Filtering-Correlation-Id: 0376daa9-5dca-419d-5d7d-08dd58e58b5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IxZ8WclweZCBa3s22ugy7A2uYc3Cdzp5xsStrtO2QCX9hQbjuzH4srCoyLuA?=
 =?us-ascii?Q?b4ZZiJatr/OL67UiVu9F/dQeF8eNdBSwEmUE53QMfAL/EUp78tq28AXRFFmG?=
 =?us-ascii?Q?785Nz9c6mjrrDPHBg9tkhEteygLPAqAY924ZDUvwSKBPJ7Jiv7hyp6RXZlXR?=
 =?us-ascii?Q?FCQkOjV7SmEJVW/qVeMn/yIoJCuwznzoXdTuwBEVRZ+2k/dp890N70rHmqF/?=
 =?us-ascii?Q?bn7GxdlCuOw2ulZ1g2TX9nMqqOAqfop08M8qKSGDnXwQasNCXxoERPzhJ5Gt?=
 =?us-ascii?Q?FO33yDK3lcQkRF2iaAYbO8xHm+NudVe/2ZNjJIDXbofM4eGh/k++yFM8kQjA?=
 =?us-ascii?Q?7HE/tZYuCkTmQ0Nh9tLCwuoeZJzD3PAfu/3CKUgQ2SwzmyDpP9Kmaks1wby8?=
 =?us-ascii?Q?vVNOF9PDoJL84I67ftjXOYXiywa/Kz67w32AantV2HDsYZ5EA4z0KK2RaTWP?=
 =?us-ascii?Q?pPDTV5ecN8fMIEgO38E3/jeh+AI5rwj26DDMdhWh3gqkfcAzHwG6vkxiUXCj?=
 =?us-ascii?Q?4stptRL6cylhAShr06L0g9TDkSCgR1jFAW3iD2wcwXXPkm2Yo8GAdif5KXUt?=
 =?us-ascii?Q?pifS2YU/MX3JIhyvJVhpI5eemeiVXdZGU44EmBeuxkIW94DJC/h/N/HTI2x+?=
 =?us-ascii?Q?L2E31pKTkAs1Vq4hqkMM+nTb9jU9ZQd6qseB8XFtrRHcSQhtbx/5BMK6RAeA?=
 =?us-ascii?Q?rfZIhJyOvt7YLC9oa07IoSXUDnVMel8Psy0KcL94SZ213JnVQGL87wQ7UjrX?=
 =?us-ascii?Q?iSZrLAwpOzXSTPWSicaA6nELsXyQmeIg7yM2+LXV0VXzJCnGCV0qYgB4K4NY?=
 =?us-ascii?Q?T5kAh0o7x6gik/BsEzyh3wNwUIKgs1HH8Z/rYP4ZoAzXg5o2tKbfT+n+feH9?=
 =?us-ascii?Q?cZ1B2oSMln5tbyz5supJf/JI13ImxxyB0mDoduw1/E5on8bZGbfunWlBOoqP?=
 =?us-ascii?Q?PPAHfhPwGf20gog2hVUlq7k3Ed2tTpMW+EF7KEYciq9Q3od7c38tBCtPxIi2?=
 =?us-ascii?Q?ZsnUWYs22MRC3J91yUHyva8cbOs2ODzpFou1/4heVREe6OYM+tpTBxkYNhdp?=
 =?us-ascii?Q?gllz+TWbGpV1sWarVbrUcAON/OdYJMBODv3PrhkUlUQyDnsEtW7/KXxLODzS?=
 =?us-ascii?Q?YBEYxfv8340SbNtjHqP3aW7lqBCuOgjDKgXZcfRLhHrI2dCAC8AO3PdIGMt/?=
 =?us-ascii?Q?Me30JbIoF5jlyH4O0Oy6dC+IqYi5ivmHrCbRYqTBq6ZIpCTnIrWyuilDj5aL?=
 =?us-ascii?Q?4emPIhnJEgNS8vQceUxKOP9sMFIRfOkwQUzGWizpxko9J5CPYjZk7Ds/wbZc?=
 =?us-ascii?Q?9h5MjLmQneSD7FyilV/6QLS9naBPk0BztgMeZbrcyYnAvpKwlJDpspKgE6o2?=
 =?us-ascii?Q?1ONb/dA2DeLmFWIMv7O8WAg1XzuH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Rh6uOD+BwioD8SJJK3RtcsEQTToaRLB+JPPOBJbtDm40klc48VDC/58c7JUB?=
 =?us-ascii?Q?GizfR2kRb3hn4katfzM9lgB64slYGYGPAJNz24OodeekTgAgw4tyL11GpQCi?=
 =?us-ascii?Q?fl2MwcJFngU+Bw4UeXLk17ZiEwPNO13oXqKrN1FU8aH/D18p5ptq4sWjGIcV?=
 =?us-ascii?Q?wGkZC4N8H0keng6hS3s0/iA9vjtgXqPVtn/01AMDd+RDxRt57gB2jVX2zPk0?=
 =?us-ascii?Q?HjI42VLZXyZnm1LOQlMhGAoDE2p3otTK/vOoD2uXx3zMPtIQ0jZp3aocju8S?=
 =?us-ascii?Q?+NikhJGfeHbKgWqzaYuoelIsCNqH2Bt0rFd663h5acb2x8bsRQVig70AvJJc?=
 =?us-ascii?Q?wZ7miS+W+ksSnsbT0BTXhAqgr0ZgcHvVGmOoNOxRZYzxU+pKGaABanjwC2u2?=
 =?us-ascii?Q?EfDcyOpF4bFR2KqzWXL5YV6PDVMsMNW074Fa7U9fCDzBN3XdLLGHYNkS+wPm?=
 =?us-ascii?Q?xtwnxUXoY7+Py+89WsqG9fv1sqWHJwTEZ5DehAy0N01KZ021Up37pDX1aDqm?=
 =?us-ascii?Q?+i0IN3Ugy/uL0vMleXelOVoGsMDJo7mNu5UoGWkeSo3eddpoALWPotZGhK67?=
 =?us-ascii?Q?KRZ5WnoCYjZ0avawOMG2UZUaV7qtTundGSLJurGTuwEaJE9a3tBAUBWRSOcH?=
 =?us-ascii?Q?o55QKZwWRfEcq1nIjWKF8IQLOVVsaQm3ApmIQIKH/fq4xTmghYTQqqH1UqVc?=
 =?us-ascii?Q?lW8pBgzjuzyz/pZ2A12uKKvwM3LAmurwFyZD1c6szZxz0KIoVxKctieeum6g?=
 =?us-ascii?Q?M3lj9/CY08y+tqdg0SVlXcRxspfdyWBD2PVDJNnRUEgT4cP4CZN/ojoXGzte?=
 =?us-ascii?Q?K7KsA054BpGJcOA1qExKysB8CBkKQYlMctLC7+gy7LLQsFFs28632T8mNiVg?=
 =?us-ascii?Q?p02g5cpq4FwJIPeZtxvEARWssUCOrjl6tYoPwqc4UPCqFORROv5j0jVN08Zc?=
 =?us-ascii?Q?UZeYFtlolugekyOXUQg0yThL55o/GnrtWDmcf/ZgFyk1kQ2XNRcipeQNo0Vr?=
 =?us-ascii?Q?cnoMOifYVqs9EInaHHMWw1ws0q8lenuIP1QVUYNk2Kf8TA8O1Uypm0LWhH/f?=
 =?us-ascii?Q?tetiR5tUy5R1HmcAhLnsRseqxs7kvhlsdz/Qt7OEUEY78TjIh6Fvts5azxCT?=
 =?us-ascii?Q?xjaZl0uTFiAkZzcuGvtSWVrBE0AplIxZHeamDz8PznyM7OHfYAeCThJIWvdd?=
 =?us-ascii?Q?9NMCRNZ9FjJ8xaCPDOl9rLOQTt9DN8+wv7DoWOpHwTeGvdlgqcYKWo39aybg?=
 =?us-ascii?Q?sQ1WFW00qQnLifcUE+3P7awVDIgQ2VlDCMBCPaqikOpNwScWj8NX4PORd1kR?=
 =?us-ascii?Q?qpW7UlF8Kd96Vdi1bUhS25bNHXuh80+bXW3ENS6tzF3k6EZDIGiSmxi0JXD2?=
 =?us-ascii?Q?5cteK+5cFgwiiJYV1tuiCIR91MC/fV8qr1ZLTwlaGqKkTP+JpeqaicWFnOyd?=
 =?us-ascii?Q?6d/lRDTs0hlILo3mspS8yiUA3RyAIjH7ODv3ebCFgz9v/sFxLeFEVe2F2S5U?=
 =?us-ascii?Q?wPNGXzfnPLo+yrge81ljtETQKupTLL0aLB5S1bHD00sAmWNGru0oCrDNLDGZ?=
 =?us-ascii?Q?827rkKCPcF5MttVFEWh8Ar5H/RCDT8dtvkZKA+1X5E1A1WvRW6+qvzu7eGXW?=
 =?us-ascii?Q?hg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wf17AFCRPN39eu3dlusqOHqMSlXEoQnrDAzOw5FY+f2kQK4HxabhHu/cnk9SRr+aowDpAAvNPMRelBo6QIu2NddDzP/CpgNTdzv4LqQTWHYXuPi2kfr5lCnc+DDqPizUO06rltW+kca+XP8LJEBSYC+rXDS2d8eDWZhogEeFlRkhTCR7fLsZQ9Ph541RLKg1DGVUe6qPpPx1XA+w3I19OXp/HUNIQHpswLqZmh1NVYN7RPFblr768WXFLkyxlgqgiP6TgJWH1Bv3e0keOw/u+4PsZcCepRuTYTPPG6vxSj99ackOL1N8BG/05/BYEv7oyzNpBDfu1JartJ8UihdFilfA5gik+xAOx3gV9rvR3mwtN4JRRnlSqOKlyHY/e0P+sOF6IkHa3bK1azXSpegRI5rMvzAwRqzIWR2mDg1l4lcPTUBgVBaJoBwKYV80uDNuTS6edvtZ8QfhqvGLoObQ1zTPehlaPnwlSSGyvQk2R0bV/xaLYzfLe/7I6NZRUiOFed6vsnlezMGW6edQFc8QQ5DToYcJYqyXWKJX0SHgWGY7RDZAb63zaJFCe/qvxBl/k4arW1I2jhrhy2T+FkcoX0/xTvO03tZzICCanRKkXOA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0376daa9-5dca-419d-5d7d-08dd58e58b5f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2025 17:21:46.8270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aPft/L8ekTcxaHFPTQ4NIeX8VvowlKt+3lpghykB4ByNsbFR51mrP7yf20+mI9Uh2wDitKd+QxpOAcOAhx4lpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7457
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-01_07,2025-02-28_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503010140
X-Proofpoint-ORIG-GUID: qXnDvUTsbGRprOPFLUx_qaO56XS66EdP
X-Proofpoint-GUID: qXnDvUTsbGRprOPFLUx_qaO56XS66EdP

On Fri, Feb 21, 2025 at 02:39:27PM +0900, Suleiman Souhlal wrote:
> When the host resumes from a suspend, the guest thinks any task
> that was running during the suspend ran for a long time, even though
> the effective run time was much shorter, which can end up having
> negative effects with scheduling.
> 
> To mitigate this issue, the time that the host was suspended is included
> in steal time, which lets the guest can subtract the duration from the

s/can//
> tasks' runtime.
> 
> In order to implement this behavior, once the suspend notifier fires,
> vCPUs trying to run block until the resume notifier finishes. This is

s/run/run will/
> because the freezing of userspace tasks happens between these two points,
Full stop at the end of that                                              ^
> which means that vCPUs could otherwise run and get their suspend steal
> time misaccounted, particularly if a vCPU would run after resume before
> the resume notifier.

s/notifier/notifier fires/

> Incidentally, doing this also addresses a potential race with the
> suspend notifier setting PVCLOCK_GUEST_STOPPED, which could then get
> cleared before the suspend actually happened.
> 
> One potential caveat is that in the case of a suspend happening during
> a VM migration, the suspend time might not be accounted.

s/accounted/accounted for./
> A workaround would be for the VMM to ensure that the guest is entered
> with KVM_RUN after resuming from suspend.

So ..does that mean there is a QEMU patch as well?
> 
> Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> ---
>  Documentation/virt/kvm/x86/msr.rst | 10 ++++--
>  arch/x86/include/asm/kvm_host.h    |  6 ++++
>  arch/x86/kvm/x86.c                 | 51 ++++++++++++++++++++++++++++++
>  3 files changed, 65 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/x86/msr.rst b/Documentation/virt/kvm/x86/msr.rst
> index 3aecf2a70e7b43..48f2a8ca519548 100644
> --- a/Documentation/virt/kvm/x86/msr.rst
> +++ b/Documentation/virt/kvm/x86/msr.rst
> @@ -294,8 +294,14 @@ data:
>  
>  	steal:
>  		the amount of time in which this vCPU did not run, in
> -		nanoseconds. Time during which the vcpu is idle, will not be
> -		reported as steal time.
> +		nanoseconds. This includes the time during which the host is
> +		suspended. Time during which the vcpu is idle, might not be
> +		reported as steal time. The case where the host suspends
> +		during a VM migration might not be accounted if VCPUs aren't
> +		entered post-resume, because KVM does not currently support
> +		suspend/resuming the associated metadata. A workaround would
> +		be for the VMM to ensure that the guest is entered with
> +		KVM_RUN after resuming from suspend.
>  
>  	preempted:
>  		indicate the vCPU who owns this struct is running or
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 452dd0204609af..007656ceac9a71 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -124,6 +124,7 @@
>  #define KVM_REQ_HV_TLB_FLUSH \
>  	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE	KVM_ARCH_REQ(34)
> +#define KVM_REQ_WAIT_FOR_RESUME		KVM_ARCH_REQ(35)
>  
>  #define CR0_RESERVED_BITS                                               \
>  	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
> @@ -916,8 +917,13 @@ struct kvm_vcpu_arch {
>  
>  	struct {
>  		u8 preempted;
> +		bool host_suspended;
>  		u64 msr_val;
>  		u64 last_steal;
> +		u64 last_suspend;
> +		u64 suspend_ns;
> +		u64 last_suspend_ns;
> +		wait_queue_head_t resume_waitq;
>  		struct gfn_to_hva_cache cache;
>  	} st;
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 06464ec0d1c8d2..f34edcf77cca0a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3717,6 +3717,8 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
>  	steal += current->sched_info.run_delay -
>  		vcpu->arch.st.last_steal;
>  	vcpu->arch.st.last_steal = current->sched_info.run_delay;
> +	steal += vcpu->arch.st.suspend_ns - vcpu->arch.st.last_suspend_ns;
> +	vcpu->arch.st.last_suspend_ns = vcpu->arch.st.suspend_ns;
>  	unsafe_put_user(steal, &st->steal, out);
>  
>  	version += 1;
> @@ -6930,6 +6932,19 @@ long kvm_arch_vm_compat_ioctl(struct file *filp, unsigned int ioctl,
>  }
>  #endif
>  
> +static void wait_for_resume(struct kvm_vcpu *vcpu)
> +{
> +	wait_event_interruptible(vcpu->arch.st.resume_waitq,
> +	    vcpu->arch.st.host_suspended == 0);
> +
> +	/*
> +	 * This might happen if we blocked here before the freezing of tasks
> +	 * and we get woken up by the freezer.
> +	 */
> +	if (vcpu->arch.st.host_suspended)
> +		kvm_make_request(KVM_REQ_WAIT_FOR_RESUME, vcpu);
> +}
> +
>  #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
>  static int kvm_arch_suspend_notifier(struct kvm *kvm)
>  {
> @@ -6939,6 +6954,19 @@ static int kvm_arch_suspend_notifier(struct kvm *kvm)
>  
>  	mutex_lock(&kvm->lock);
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		vcpu->arch.st.last_suspend = ktime_get_boottime_ns();
> +		/*
> +		 * Tasks get thawed before the resume notifier has been called
> +		 * so we need to block vCPUs until the resume notifier has run.
> +		 * Otherwise, suspend steal time might get applied too late,
> +		 * and get accounted to the wrong guest task.
> +		 * This also ensures that the guest paused bit set below
> +		 * doesn't get checked and cleared before the host actually
> +		 * suspends.
> +		 */
> +		vcpu->arch.st.host_suspended = 1;
> +		kvm_make_request(KVM_REQ_WAIT_FOR_RESUME, vcpu);
> +
>  		if (!vcpu->arch.pv_time.active)
>  			continue;
>  
> @@ -6954,12 +6982,32 @@ static int kvm_arch_suspend_notifier(struct kvm *kvm)
>  	return ret ? NOTIFY_BAD : NOTIFY_DONE;
>  }
>  
> +static int kvm_arch_resume_notifier(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i;
> +
> +	mutex_lock(&kvm->lock);
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		vcpu->arch.st.host_suspended = 0;
> +		vcpu->arch.st.suspend_ns += ktime_get_boottime_ns() -
> +		    vcpu->arch.st.last_suspend;
> +		wake_up_interruptible(&vcpu->arch.st.resume_waitq);
> +	}
> +	mutex_unlock(&kvm->lock);
> +
> +	return NOTIFY_DONE;
> +}
> +
>  int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state)
>  {
>  	switch (state) {
>  	case PM_HIBERNATION_PREPARE:
>  	case PM_SUSPEND_PREPARE:
>  		return kvm_arch_suspend_notifier(kvm);
> +	case PM_POST_HIBERNATION:
> +	case PM_POST_SUSPEND:
> +		return kvm_arch_resume_notifier(kvm);
>  	}
>  
>  	return NOTIFY_DONE;
> @@ -10813,6 +10861,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  			r = 1;
>  			goto out;
>  		}
> +		if (kvm_check_request(KVM_REQ_WAIT_FOR_RESUME, vcpu))
> +			wait_for_resume(vcpu);
>  		if (kvm_check_request(KVM_REQ_STEAL_UPDATE, vcpu))
>  			record_steal_time(vcpu);
>  		if (kvm_check_request(KVM_REQ_PMU, vcpu))
> @@ -12341,6 +12391,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	if (r)
>  		goto free_guest_fpu;
>  
> +	init_waitqueue_head(&vcpu->arch.st.resume_waitq);
>  	kvm_xen_init_vcpu(vcpu);
>  	vcpu_load(vcpu);
>  	kvm_vcpu_after_set_cpuid(vcpu);
> -- 
> 2.48.1.601.g30ceb7b040-goog
> 
> 

