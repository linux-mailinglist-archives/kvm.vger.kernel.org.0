Return-Path: <kvm+bounces-36698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C562A1FFD0
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 22:32:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A7D518875EB
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 21:32:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5192C1D8A12;
	Mon, 27 Jan 2025 21:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EynJd/os";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TngNXf9G"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CBB1D7E4F
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738013504; cv=fail; b=o68VWUL/Pvx4Tdm3/utNgCT+eKZB48KUG9C3HbW4Dc0sUuFa9uxw8jkdyj/8niDXAFpEyv1Lhtm5qxX/ylPQgEqJfwsndRuoMQlSGPxtK3bNhM1/fC+Yk6nAgy3kKOAx93S/am+HUWsQEfChQwtLyCLj+Go8vlZ7Ecv/FZ+cc5g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738013504; c=relaxed/simple;
	bh=lXlOeau9hHhGWppbHHm1XIRBXbPix5k0ylaDw1uWguc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iR9KlJpUnskYb1J7vIOc+G4qG/Dqm+uQKcpadoNfXOLGqydyCQz93Qqe54/VDID1jtysrqxmWAbCeNFi6znCDZC/6zZ9MZLeaFyC61agWoizek7wIRfbYDffH1p5hVyb08o1pNZax1EAxE0xHXwr7gFxl152B8EIBf+hzqRehUM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EynJd/os; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TngNXf9G; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50RLR2H5015031;
	Mon, 27 Jan 2025 21:31:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=2Jlw+KA+dy0s5soAPwah4SwL5d+bTAa+rRU0oNp+9gQ=; b=
	EynJd/osXgU0/9ZrOpQHdxKVvFTYkRefsaUwYslZlu/K9TaTOFQ2mSebnp8zoJyY
	Zx33MThOwxqENFQPiEjm3VmEY6qjZ1cR7w8yLiK6FHwBSzbaGFXWHdGkYF3z5l4S
	muxaKWq6a9pdTmfyhS7lwJcHqz5KpdPSQHNPik0YQMp3spz2kEV9hZH2uSo66xey
	R8oEtiR8gUr54+tF3UPURx+1bc4EN/w0U7C634vD4rPdY3PA5blecWOwAaqNkjXA
	qvPkF5dOneiyf/UlWxGg+8V1BgF9ZOc5u5N9C9m+sp9AykCI+gYoAOLXIJhJCi9T
	ySr4FCz1pJxDKTvdzIvy+g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44ej2j80cu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 21:31:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50RKBEFY035875;
	Mon, 27 Jan 2025 21:31:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44cpddhxgn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 21:31:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d6f9p/+CHoAQmN/hTh2ei2V1RLX7Is0WIX/cLedwK8v5eZbZD/igKqNxcwxQ3eRnZeiRqAB9RoRtSsALPMruwgm0Ui2dvBe+3dVnFckPbOVwcjQbTQLZZTTRCTAWwSlhQB19HEJ1/hIC7yssv5EzbF91WV+3i4apXhyB53R3akvWL69jip9eQI7XLyE/Gtpi0HrlyykVeWeC8yl8k4vcgCf94UylRRiQDc09yHc5Pe2YimhV5aluQGGRcBA4VGlDSVhrAnvu5/Qgp1xrH1IM+ldaIINiuAIOebuDdDJ7isRQGU2sR+yL093YkAE58fv0pSOYaTFMwz1Xv13Kb6VzOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Jlw+KA+dy0s5soAPwah4SwL5d+bTAa+rRU0oNp+9gQ=;
 b=A2kn3iVWloC3sLtYAgCBlhAx1lCw2gYheeULNPT8HckHVUARXKLDOt4f1Se8b9cpkBO3NiTDC+G04dHiVf046ybxcRkmBQk7UAy0LHYslj5hGB3M523aEquul/H86dkbmxdC/3WLeNe2nlWtNUZeolSXL+lsNPMFhV1lhHdCzG/42QeyD7dlc+x3U2ysGes6/bU5vO670jRd9BU3+IcpBDxnCsioHnIbWs9aGwx36D+isCQ7BTJwNrQSxB7EPEHIK4SLgjClEmcYkKVF3NxWyH6o3R889H0dSQbfYhnMlhU2Q98I+hbJx+Pe9lwZ729ViZAlxDIZMZL7d3xtKFndgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Jlw+KA+dy0s5soAPwah4SwL5d+bTAa+rRU0oNp+9gQ=;
 b=TngNXf9GTRR88/tupGky2JgttPlfywpfyKKzUvhZ97NtvOrjFkWiuspEiGHuiQocXQjd0jVPv+0JZkoGnfH7I24JqFob/lekmC44/FT4bwYS0y93oIZBCwM2JX0s1rBJ9L6HnvOserA8TCJx9J6laldHzt1rFMBDs5Kcg2LhKhI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB4614.namprd10.prod.outlook.com (2603:10b6:510:42::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.23; Mon, 27 Jan
 2025 21:31:27 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8377.021; Mon, 27 Jan 2025
 21:31:26 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v6 2/6] system/physmem: poisoned memory discard on reboot
Date: Mon, 27 Jan 2025 21:31:03 +0000
Message-ID: <20250127213107.3454680-3-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250127213107.3454680-1-william.roche@oracle.com>
References: <20250127213107.3454680-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0285.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::20) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB4614:EE_
X-MS-Office365-Filtering-Correlation-Id: c080f76c-0a11-4ddb-8551-08dd3f19f49b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?E39DhOBJSxtmnePCyA6cEO2GyqVFO5fBmCiKaY/v4y2DkIuLA1jq3B9JGB22?=
 =?us-ascii?Q?yGACLZ45Rb1QigUEABkGX0iV83ttrur4dQ6oF6Sm8XxzeQVq+6dQR5X15xor?=
 =?us-ascii?Q?fRSoltknt+WQT0oWGTiwvcc9OuXBmxzIFAcxDo9d51GitNMFDV+UWEdzzVSw?=
 =?us-ascii?Q?xaqVdIT1YILtl+SXk3BvzWZywL5LLq0ROcBGvHpn0oe7AvQ+yXyuicLP3r83?=
 =?us-ascii?Q?XvCJgowaJU0ZbLLKsFeYmO66OA4z/p2lpTnVAZ5XtnHWneQfyL7UduJ51lkG?=
 =?us-ascii?Q?NCM/bLcGzRN0zJJi/wt+/mO3uw3RsjUCZ1w9twOjGArZIomfn/vJE4h2VRzE?=
 =?us-ascii?Q?asWjqWKRCZouuaWDuPusUpT3qpK02zWXfG0l0ZcZs1CGf6utyVvcQPUNoOMN?=
 =?us-ascii?Q?rY775jPgbsOnieQGO/6V78rBIdDaWTOECJUDnDs03vd6coqoOfQuDl0PNY9i?=
 =?us-ascii?Q?tx9+HgANTLdOPw1kQjnB3KP5iMmipCNbZhYHCvOHUXDX3oS6zfBGQBJyEv7m?=
 =?us-ascii?Q?LH6TmpperOrvm+v3WOwsH/CE888NgYffJbzrHXJsV171ojitEr1AtE9FNq8N?=
 =?us-ascii?Q?o+nSY2Bwj4CzET97kUXxlePYyJMW7wMrhmUq/fl4SezCJp4vHKbcEyS0B7Ze?=
 =?us-ascii?Q?YScwktyoATawFvNECKNoH7zeza3Ekush3by4zRcL+oRfUwTVhNSRHjn8mmwu?=
 =?us-ascii?Q?1ZnQMv3yQG7OUeJVyl6yGlrdOZw61Uw0mhinjjlLe0O4iFWCE8/vbvY/M0hF?=
 =?us-ascii?Q?220YpdbVY1cbcWu7Lct7CeKs2ccuOyvE4jBZJ0h4HtJ678ERgDJ/zvYrhUCF?=
 =?us-ascii?Q?8PWGzxNvJ8EBF4kZn/RJ51MUkhyqOLLGH578fp6DKP2zxUbaTp6HCFneRjq9?=
 =?us-ascii?Q?z2QvBRdHHisJM52AuuYAlkTLIVApR6OVii1FxPaOr5PZuBSVs+P0iSMXWZSV?=
 =?us-ascii?Q?OkOEkg5C7UPJ+Sj0wxz6DmbIUSm1o/vVEDdupoYeJ3t8Ase5VcqS5cG0pQZf?=
 =?us-ascii?Q?JegnJAeAhs3Gudz2hRNhbkgKpdMQM0K/Jejr0zxkTvDJ2rH6t+sh/6ZbhzMW?=
 =?us-ascii?Q?5bNtryZUsVJNMMWRC9SimXW6b/qS75ISwHIy9Hs7Px6hTQk8ZQ02Fgh78wDC?=
 =?us-ascii?Q?dPCFqpKjJ+wLynMeMl8K8t2TdNa6CpbyL0kJBVPBh8uJxtMPrvPG1lC1BKGz?=
 =?us-ascii?Q?OEioESXCuYhDGBLQTQA9v+wVkIea9U7VwOGqkzRwWSMfK8yySKJ4u0a+ChB2?=
 =?us-ascii?Q?wmPQ88MC6XDfX8zLSsYAMwzftoASpQVfEhqEwTWDvVMWCXj1KCh7fbioXRw5?=
 =?us-ascii?Q?pqENY9NO9wLBe/2wFWQLgy/e9zxn/r2rB7FMUXZYMA+MubL4JRO2CM2JpXzA?=
 =?us-ascii?Q?wlGWguen0YIgPtaTSQyiEDIW8Tq3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yej6SeUx/OVbAZMG93CkOgM4FBQ7tejlM//FSs5k8QLswokV9hdNZlcctwPM?=
 =?us-ascii?Q?lvJxV0gVErHFS4oXjHn6tW1opQCWIsWuT0WIMRtTCGzI6SU4E3WT19cMWmks?=
 =?us-ascii?Q?AJoh/HT6sIUy4NA7R1bZOtfFIXOTltOzwT829paHWJXKhPQETLddP1GdgsDY?=
 =?us-ascii?Q?ZQPiiEPNsNAImGW6PhlR0l9ZrWmqqu7EyaE6Nw3JZoUJT7Lp6udeY9wghHA+?=
 =?us-ascii?Q?TEezPq7dWqBu45ciT9m3AfNuAekm8DuyCRoCpWqNidjbajtmwGKnBZ6fkOhf?=
 =?us-ascii?Q?jTY5LyMDj8XyUeDaKIDHvH2gsJPkC45u477cZjale/CTnnWhsS01q1sY/cUK?=
 =?us-ascii?Q?uwwpIm6cfscxuIA0BlxBkbRTrtw8Dn0TQid7vVjSKsQCd+pibhWcf0XgZboX?=
 =?us-ascii?Q?tgqz3cDCJMV7CD8zZKtz42sGeq6gf51a/OuZX6ERTWPAUkEGLhdz7Lsfesi0?=
 =?us-ascii?Q?bfs9qZ00r8WgFZ2IbFW+axC0+neTOwFESbK/FkpmroaJhVpQxTIuszk4MOA9?=
 =?us-ascii?Q?w0THvZ+sdCoXSt6vx5GUprBUiT7AQOpdD/PGF6wS+Jn0QQhjfTt/hENgiGRg?=
 =?us-ascii?Q?xI3tQSjekVpaHmoF9U9pX2MJltWQrV2fnD7+tyXxgliON4vwiduf1U+BpKnU?=
 =?us-ascii?Q?3+KQwq//rvPRCeG3z4YO8/smq3iuaKO/8yc3zBQCE6DhsPx+e6jmOP/QllUE?=
 =?us-ascii?Q?jYRRpN0cKS1VCtw8mEOiG/0NmSm4np37vH7pJpC9PIya8V7P4zE9vSnL6Zro?=
 =?us-ascii?Q?0GcbdLA3sHL5jssIELVfeBTM3ULx0gBvJHjNJa2jytFGTanz2Ut45PXEOW9D?=
 =?us-ascii?Q?wJb1lbaNIqFo+gLuSu/PnACYeJo8CfJwQiISxqB/Eog6PF454HY5nSHWO3HE?=
 =?us-ascii?Q?0bdm1IrkFRaH+HkVGC3OqhiFgTATrfH2Ic2AQpOGmZO7baFfeqct60Xi8zHc?=
 =?us-ascii?Q?YfieEiVcEQXt9DFm4yW0y0afVPnLP8VMRSAA4s5ajuIgF3Cv7K5MUbAsqIvN?=
 =?us-ascii?Q?zrWasodqfs7Xn7RI4JliNWDKq0KiiogFhsT8TGEqSTNENH2fAcmFFA+rF4Uj?=
 =?us-ascii?Q?n6lKxtKLAm/qgQ13HZSJIB9KJnRRRX3xx7o8V8lQSdY1OJH9SwU41jSX04DD?=
 =?us-ascii?Q?Xue+cSw6kKffw0bIDw2KI453ScRj6jdJbDOq3ofVMi0GNiKeXrx3GyanzZhD?=
 =?us-ascii?Q?4XZZu94ENI62HL90TWbfOFYppfG844zrnx/sg1lh0esqxk18Tc/czQolLv/k?=
 =?us-ascii?Q?yo0uQWmXSyJsnHnP5xXIK5bVOH3AvMlku6fWsydhvD1uuqTV9RFkimSaF5j7?=
 =?us-ascii?Q?d11VKXEZiuq4AoiJHMwMD4LZyz5FYvcBDAXoLaeGBco93L9bCRGt0XqQRWbO?=
 =?us-ascii?Q?CFgc2YvD8WfxmtGIPVAkHFid7c9Sq3N9CY5P5iP6OFlsFkiMsYTGr4yey3ev?=
 =?us-ascii?Q?Z3/k7Xp7o5eO0pewjsjDrBDCPhkAprXETopAqXkrQ4kI/EjLMqjUrahPft5m?=
 =?us-ascii?Q?eTZOpIl9QTZOwzD0rsIH3HkP4N57mmelC3B4BZb8L6W8rrws6ZD50ckS2gjI?=
 =?us-ascii?Q?U67vxFGTYW/idmliBvk3mFZxQc/XzdP9F12pzdzQjXC4KKpVFDURK4JBPNP3?=
 =?us-ascii?Q?0Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	51SSAv+IebtHsb9UjhUjkSByrB22UJonRZP0jq212y7Yq2aFsdl7ZMj9aYNzOqZCUalK9RPdaWCNNipfvqZtdlABs2tzf6CAC+3q4+JnV93ZL9UoG1rUk2j55uNuXF4SesMVen4pIoFNXb0miraU3Z6PNtrk9hcUKjOAsf27rCVpaMGH+/XbObXL4PDVY4Xh4ViA16H1OLqTpyQOn6XKVMq44+1ls4WFTx0w6qdCMtVMH8yDH9xXtoXiE4tJ1HeiJQmW2qnyb476VBhPy+yZAwdsioVkPJOxa4+cfcokS1SG2mYNM4R9ZP/EwZN51CJSMxNL2is7LfO2WenP1VM6IbmnfyTSFUgR3W7uoulV9ihXqRRN4CWG3hGH1Zm2W3lvZcyYIxk4o4qt6jPdr6Vhw/vaH3qol0HJ0s1B1F09mlaD9Y6o8fB3ACkU6sSlcTV/MvoeqgQgBa1tkRdMVRVVSTgXffkuxpqOz4FPg6u7FtcACBb6Xz6JCSevxQTxwYAxnAk1ZFGah5jIguJR0XTIU8FQLK9WHEGw05GDignjbYSqEzPMh5EOMlfQHQMTK4pusVySNLJ/lgOUVE+BveQltVgEI87Ta0fPHKKi1IPhtlc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c080f76c-0a11-4ddb-8551-08dd3f19f49b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2025 21:31:26.9316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aQfTZIwPJn3arTSnA4EbNNSYeTk/FovP6ACN3uASJSoQb0fcizKkeqR0/6IhXAQ4TdEiED6Z7lbzbMOFh4fWJS+2oCQy6OxcazeRx/NqRO0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4614
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-27_10,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 phishscore=0 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501270169
X-Proofpoint-GUID: Nz9IXIjq9FuGQIXdpvaIDZ_Bkgiw10AF
X-Proofpoint-ORIG-GUID: Nz9IXIjq9FuGQIXdpvaIDZ_Bkgiw10AF

From: William Roche <william.roche@oracle.com>

Repair poisoned memory location(s), calling ram_block_discard_range():
punching a hole in the backend file when necessary and regenerating
a usable memory.
If the kernel doesn't support the madvise calls used by this function
and we are dealing with anonymous memory, fall back to remapping the
location(s).

Signed-off-by: William Roche <william.roche@oracle.com>
---
 system/physmem.c | 54 ++++++++++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/system/physmem.c b/system/physmem.c
index 3dd2adde73..3dc10ae27b 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -2167,6 +2167,23 @@ void qemu_ram_free(RAMBlock *block)
 }
 
 #ifndef _WIN32
+/* Simply remap the given VM memory location from start to start+length */
+static int qemu_ram_remap_mmap(RAMBlock *block, uint64_t start, size_t length)
+{
+    int flags, prot;
+    void *area;
+    void *host_startaddr = block->host + start;
+
+    assert(block->fd < 0);
+    flags = MAP_FIXED | MAP_ANONYMOUS;
+    flags |= block->flags & RAM_SHARED ? MAP_SHARED : MAP_PRIVATE;
+    flags |= block->flags & RAM_NORESERVE ? MAP_NORESERVE : 0;
+    prot = PROT_READ;
+    prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
+    area = mmap(host_startaddr, length, prot, flags, -1, 0);
+    return area != host_startaddr ? -errno : 0;
+}
+
 /*
  * qemu_ram_remap - remap a single RAM page
  *
@@ -2184,9 +2201,7 @@ void qemu_ram_remap(ram_addr_t addr)
 {
     RAMBlock *block;
     uint64_t offset;
-    int flags;
-    void *area, *vaddr;
-    int prot;
+    void *vaddr;
     size_t page_size;
 
     RAMBLOCK_FOREACH(block) {
@@ -2201,25 +2216,20 @@ void qemu_ram_remap(ram_addr_t addr)
                 ;
             } else if (xen_enabled()) {
                 abort();
-            } else {
-                flags = MAP_FIXED;
-                flags |= block->flags & RAM_SHARED ?
-                         MAP_SHARED : MAP_PRIVATE;
-                flags |= block->flags & RAM_NORESERVE ? MAP_NORESERVE : 0;
-                prot = PROT_READ;
-                prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
-                if (block->fd >= 0) {
-                    area = mmap(vaddr, page_size, prot, flags, block->fd,
-                                offset + block->fd_offset);
-                } else {
-                    flags |= MAP_ANONYMOUS;
-                    area = mmap(vaddr, page_size, prot, flags, -1, 0);
-                }
-                if (area != vaddr) {
-                    error_report("Could not remap RAM %s:%" PRIx64 "+%" PRIx64
-                                 " +%zx", block->idstr, offset,
-                                 block->fd_offset, page_size);
-                    exit(1);
+                if (ram_block_discard_range(block, offset, page_size) != 0) {
+                    /*
+                     * Fall back to using mmap() only for anonymous mapping,
+                     * as if a backing file is associated we may not be able
+                     * to recover the memory in all cases.
+                     * So don't take the risk of using only mmap and fail now.
+                     */
+                    if (block->fd >= 0 ||
+                        qemu_ram_remap_mmap(block, offset, page_size) != 0) {
+                        error_report("Could not remap RAM %s:%" PRIx64 "+%"
+                                     PRIx64 " +%zx", block->idstr, offset,
+                                     block->fd_offset, page_size);
+                        exit(1);
+                    }
                 }
                 memory_try_enable_merging(vaddr, page_size);
                 qemu_ram_setup_dump(vaddr, page_size);
-- 
2.43.5


