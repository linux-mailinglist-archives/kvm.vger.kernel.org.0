Return-Path: <kvm+bounces-69568-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yCCQJ7yRe2nOGAIAu9opvQ
	(envelope-from <kvm+bounces-69568-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 17:58:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A977B28BF
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 17:58:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 92EFD301DE0D
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 16:54:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC607345CA8;
	Thu, 29 Jan 2026 16:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nQkb5Wr/"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012063.outbound.protection.outlook.com [52.101.53.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC4B342CB1
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 16:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769705645; cv=fail; b=cIQENf1/YfndEdVI/szMUPB2KlXo01Czvigm0VBWqsLNngCgZ4dWZ7eu1yvla4Kb+qmvtLxLSuIxWouhgIS+efdAWauvc5HJ78LdD0ir/go3JttpuLBFkiKJ4TyyAV36Y+4bZxd2yPlyCOv4YMBGrF5/B/K4ezP6xYhcmx4Qy90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769705645; c=relaxed/simple;
	bh=UEN70CixyXq5qLbsLc8dTiUkzw87jFx6GFxv49j1VM0=;
	h=MIME-Version:Content-Type:Date:Message-ID:From:To:CC:Subject:
	 References:In-Reply-To; b=u0x0bUTvz0/6HXQrXGH648K3t1QVcVoNqvqEp05xciynPsL8EnWcto9GDlhKWFxpiZ7GNkpkZTuZkobZSgrUBZDaYQ12VLc1OheLOe2ZBmGH7gy1OY7RLCzsoRIFHph5BJCGEyhTROrQ5svFMOVOSeAxLfZp6bbCNe6SuIp00G8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nQkb5Wr/; arc=fail smtp.client-ip=52.101.53.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eK1VGEwP7f7CgpC8WcfGuDzBzoykCu6z1aBjJ22c13IqmKHuoG/5BGyzjWJPiR2PwxiQ+KY0Mq6gmd4hx9pwjW2cr4168F5v2Ye2cQxPOAQLF/QIjqfxPv1FKQ6HZMVf2lAK1ve1MHXk6mpC9gaeP26YF5ekrk+x40Qda6ZBa44BAUeS1JTyb+cgbntfKL5oyVsQ5CJ6qtBA+3c2mfnxZYdcmqEcYuh7OTaD/L50/k/v5X773FifO06bvgegGlhO/7WQFrat85A9PKALuqAFJe5eaNeH+Tzv2U9UMrBfmzrTT2WkvfGkzNz4z3ZVcRXGw1J5VdvDKTmZDexOWUSkxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+XgX99+iHGVNjjsRuQ5NDSclAHb6pJNJac+tnJwHEJ0=;
 b=hZHIZ91pJkGkkN8BzAq5EtG056YSUF2AStHhaFdexnGzKywzdtXgzKtH83poyJU6OsFfFe5iLAjlUGjSEsGPkYzrrbqY10P82NBXc6rDCJYrxLcmd3sadakZoKlKvi4llB/0jRfUr4NWVs19CiS2PocQJnMJsBK0+432zVcIRGYUhjI17AHFqf0HLNEwUWxQC0eXH6Bu3Ca40370ESS9w3+vGAjpNsw59pIOw0fCErN/+G5mgLmbxdL9T/o0kgi8XhTSL/JuevNbIxtzxZfXkyybGGQm9E0TnHWwSf04NzXYiwHb+oafhQfrj3FNv1bKCc49+1GJhrGrbKpIt7XHWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+XgX99+iHGVNjjsRuQ5NDSclAHb6pJNJac+tnJwHEJ0=;
 b=nQkb5Wr/0bHb6lPYu8xC8aOTDGQYMyZc+R1tmb2Tlmjw7KyJXyOyE6foVnI/Ge07jFBs57lgTpYRW7BCEy/CyomieqzUnm4tCb9FT4Tc9SE9Ge4FXHa0HkPKHJVUgcHBlJV7TkdZov7aJg5RRT9zZpt8pf+SdIa+gOKH5zQrNBk=
Received: from PH8PR05CA0020.namprd05.prod.outlook.com (2603:10b6:510:2cc::27)
 by LV8PR12MB9336.namprd12.prod.outlook.com (2603:10b6:408:208::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.10; Thu, 29 Jan
 2026 16:53:55 +0000
Received: from SN1PEPF000252A3.namprd05.prod.outlook.com
 (2603:10b6:510:2cc:cafe::de) by PH8PR05CA0020.outlook.office365.com
 (2603:10b6:510:2cc::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.5 via Frontend Transport; Thu,
 29 Jan 2026 16:53:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000252A3.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 29 Jan 2026 16:53:55 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 29 Jan
 2026 10:53:47 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jan 2026 17:53:40 +0100
Message-ID: <DG18AARFFER8.3POV7WD7KQKUU@amd.com>
From: Alejandro Vallejo <alejandro.garciavallejo@amd.com>
To: Jim Mattson <jmattson@google.com>
CC: <kvm@vger.kernel.org>, Christopherson <seanjc@google.com>, "Paolo Bonzini"
	<pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: nSVM: Expose SVM DecodeAssists to guest
 hypervisors
X-Mailer: aerc 0.20.1
References: <20260115131739.25362-1-alejandro.garciavallejo@amd.com>
 <CALMp9eRPNGwTKTv9VQ6O5U=KsNz73iF14+=QZvqHx4JbQKCLfQ@mail.gmail.com>
In-Reply-To: <CALMp9eRPNGwTKTv9VQ6O5U=KsNz73iF14+=QZvqHx4JbQKCLfQ@mail.gmail.com>
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A3:EE_|LV8PR12MB9336:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a775760-990b-4171-43ea-08de5f56fd2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?azJ3UlVUcmpnQnA5Zy9OUjYrUnlWeGViRDV5WFNpTlBvRkRkbC9QckppMU1w?=
 =?utf-8?B?c3dyM2cyRzV2ejIvNjFxd3NKNTZOQzhUUy9NWDlmTytPODhsOHhlSGV4VFVY?=
 =?utf-8?B?Q2VkVU1UdytXUHZHK3N3Q2VUOW0rOVdWaTFFQTF6RWRReW5XN05iQXh0dVl1?=
 =?utf-8?B?R01ydGxySjdoSEVzdWxRRXNqTWtVemVrdi8yZmYvZDVlSDE1aVE4eWlIY0lo?=
 =?utf-8?B?RFhsVUVJVUNha2dhZGsyYlhwUWhjeVU4UG15ZzdWV2NsUVMram5Tc2Z3T3Fu?=
 =?utf-8?B?MUtCSUlRNTNkTWwzWElFOXdQc09pcDJMUWZjcUVqeXVjL1VKR3ArN3krWEV0?=
 =?utf-8?B?ZHRiT2kraFhXRmROUnltZ1BSZ0hyNnpRcHpaVFA4TkJsVFhMR1JyT002Z2JQ?=
 =?utf-8?B?MkNnYlRaMTBWa1IrOWNRdHp6dUZkQnRBTldLaG5WQ0h1L1NReXl0aXJFa1hR?=
 =?utf-8?B?V21qR3c3dVE5UnZLNHZBUWoycFdDN0pEVGViMG5rUk5RZi9pRi9NcHQ4K1Bs?=
 =?utf-8?B?YjIyQ0F3VFQ3czZ6VFZadmRsSlF1cVBiSDZiLy96QWxqdnhxdWlFTmtHVW43?=
 =?utf-8?B?WkxML1pLaENsMHcyak9iMGc5REh1UWg5aEx5YkpxZ1hZaXpUMDFsdGxXTWZ4?=
 =?utf-8?B?WE5JTGF2UEsyeDc5cWQrY1k4dmdhZ0lGN3BUWWxPN1BTV1pXRXVhbUhkWDBF?=
 =?utf-8?B?bURvbTZkbXlnZjlFakllWXRaVndkVm5kQ2VIWGdNV3JCdXV1MTZsOURUbFJw?=
 =?utf-8?B?SFpDaTZnSDUrOFAraEVxRmE1b0IzL05WZU8zS3kyaGNWNWRDaVhHbnp4N2pu?=
 =?utf-8?B?ckR0Z1gzL2NaN1ZqV1VpclBUNG1uU08vVUdteUlLd2ZCN2J6Uks2cU95WVoz?=
 =?utf-8?B?cWd0R0pVKzRmNkZFWFhLeGwwQWZpam1GNVN5NTNleTA3ZXZwdm1sVEhrSk1K?=
 =?utf-8?B?eFJlMmdEcUJGN1N4WUVBdjlMbzhhT04xRHZTSW9KcDAzRW1RbERmM2x4eVVN?=
 =?utf-8?B?SXA4MkVYVmhMT0hDL1JDVktFK2dtc3ZKUUNsNHY5VmNFK1BTVHplVWNRTnFn?=
 =?utf-8?B?eExOelZNaHBXVW03bU9rVThTcW0xVE4ySXFrZDg5L0VzQ25EWjZxWmMwS3Vh?=
 =?utf-8?B?V0JxeExOMzI0Uys0dGZWbW14MGd1ZmNPNU9nUGtmNXYyUC9JbXYvaWZOSmxT?=
 =?utf-8?B?VWFJRmJmOUlXZVJKNm9DNVdwSHdvVHZKMFJPZWt2NVdvY0hNS0loYUI5bUlk?=
 =?utf-8?B?b0Izb044SVEvQ25Mak04cTFabEpRUzA2aTBsV3ZwdEFxK2R1OCt6dTY3bTQ2?=
 =?utf-8?B?MHoxWWY4ZHdCTFhHWHhZY3ViNnJNRG0yUXRhbXZnWTdNZEtMc1BJbXlUVENQ?=
 =?utf-8?B?Vy9GWXlBSmR4VFJseng1VmRySFMvQ2NxYnVtN0h6dWNJdFMycFJBL3hHWFp2?=
 =?utf-8?B?dkNDNmcvaEdyaHN1aEtiMytZTnRxRjhWVGdQSUl6ZXhGUDlhS0QzNmxKaGYz?=
 =?utf-8?B?c3RoNTZBcWhucVNDWFowT293M2hhVEROVERXdzBzeTIyTGE2NkdaN0w4dnkx?=
 =?utf-8?B?Y0xtQ3YxOU5UdXNhaFlUc2NHeEV6SklmK1B3TTFrR3RBQTl5L3lERXhuYW5q?=
 =?utf-8?B?UTNlYVpOeExkYXNrcDEwVXNsWERKQVlxYStvUm9ZYVM5S2d2eEFNTHZPUjBX?=
 =?utf-8?B?d2tJOVgrOFUxUFk5WXI5eGN6bUxtQXJ1WWxSdFhUVkxLNUlzTHJWTzBuM1FY?=
 =?utf-8?B?amdISlhwM0M2ZElqaDJYS0xUS1RYbUdVaGVaVmcwbk5odWNBRzgvZFBRL2sv?=
 =?utf-8?B?NVBCcVVCL3RmTGNwaDRRd05kbm5hQ1lqUFg3T2E3WEVsc20zSm80VGtlYVd6?=
 =?utf-8?B?NGU2ZU81TzlBUWhwRkFzMXFRRUt5SXNEZ2xyUTRVdlN1Z0Q0QkRlSEd5YUhW?=
 =?utf-8?B?elJSVlFJa3l6VDdTblNLa1piRTVNZlNQL1h2cFR0NFp0aEpyaFRZSnBnMlYx?=
 =?utf-8?B?MGxFUThUSHN5M2prdncxWnBPMmZDN0xNR3V1MzljMjRhb2FUM0dlNzBEWFJG?=
 =?utf-8?B?NVJMYmhvWXdGNjYwU1p1Wk1OT3JHc29Lam5CS1lZMmVwVVFrQzJOUXllaDEy?=
 =?utf-8?B?MTI3empBbWM3Z3l2TjAyYVhCazlQYmhPVjdCV2xFcTN5bE9oZXNUakxtL0p2?=
 =?utf-8?B?U1ZpdE5aZ2gydWNqWXpsMHJBV21QNWpITFZSdFQ2R21LSVhtZUcxMEh6VXNC?=
 =?utf-8?B?cDgxRzB1OWFieFRhQVJYem1WKzVRPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TKVI56qjYIYqhd8tJdmYDPkxVk3u7PX3fjU18fX0xN24zcyWtbY1DO71EqNgGLfA3qX1dNK5rR/LZPlUD34245KP+PTmunmncZNz9dfaFvP1tOjZLM+toneQOMOt9PWgbk0IQ9yZ47ZtrULyZYdFTZ/zmf6eIcJWdl+qkcqOFGtRwNw2HT7CdgpB1Gj4Q2vnReO1Se9HMdOfFq1cKtAFF/JRYkNW+7G5VbGsHKYBzLMluO/jOkOg8kllr2SDdJhmjjlvdw1NCmiZhUOguVOGhc69HBL5R2le11yT6gryOgOj6sY6ENrOVS0Fpq19GadOhRQyge5XATZpJyipWHd08F0+5E21N+4pK8cU6cCj5mtuTCyVwxMP+IIntwgN1llgkpYC2U5/Qtw54Lo02/pBxTkmH+FUbXPSfedhvuNMWrNao55Cmnl36Hl3Lk9vIwIj
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 16:53:55.1761
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a775760-990b-4171-43ea-08de5f56fd2a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9336
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69568-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alejandro.garciavallejo@amd.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 0A977B28BF
X-Rspamd-Action: no action

Hi,

I've been busy with other matters and didn't have time to push this through=
,
but I very definitely intend to.

On Thu Jan 29, 2026 at 12:15 AM CET, Jim Mattson wrote:
> On Thu, Jan 15, 2026 at 5:26=E2=80=AFAM Alejandro Vallejo
> <alejandro.garciavallejo@amd.com> wrote:
>>
>> Enable exposing DecodeAssists to guests. Performs a copyout of
>> the insn_len and insn_bytes fields of the VMCB when the vCPU has
>> the feature enabled.
>>
>> Signed-off-by: Alejandro Vallejo <alejandro.garciavallejo@amd.com>
>> ---
>> I wrote a little smoke test for kvm-unit-tests too. I'll send it shortly=
 in
>> reply to this email.
>> ---
>>  arch/x86/kvm/cpuid.c      | 1 +
>>  arch/x86/kvm/svm/nested.c | 6 ++++++
>>  arch/x86/kvm/svm/svm.c    | 3 +++
>>  3 files changed, 10 insertions(+)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 88a5426674a10..da9a63c8289e5 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -1181,6 +1181,7 @@ void kvm_set_cpu_caps(void)
>>                 VENDOR_F(FLUSHBYASID),
>>                 VENDOR_F(NRIPS),
>>                 VENDOR_F(TSCRATEMSR),
>> +               VENDOR_F(DECODEASSISTS),
>>                 VENDOR_F(V_VMSAVE_VMLOAD),
>>                 VENDOR_F(LBRV),
>>                 VENDOR_F(PAUSEFILTER),
>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>> index ba0f11c68372b..dc8a8e67a22c2 100644
>> --- a/arch/x86/kvm/svm/nested.c
>> +++ b/arch/x86/kvm/svm/nested.c
>> @@ -1128,6 +1128,12 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>>                 vmcb12->save.ssp        =3D vmcb02->save.ssp;
>>         }
>>
>> +       if (guest_cpu_cap_has(vcpu, X86_FEATURE_DECODEASSISTS)) {
>> +               memcpy(vmcb12->control.insn_bytes, vmcb02->control.insn_=
bytes,
>> +                      ARRAY_SIZE(vmcb12->control.insn_bytes));
>> +               vmcb12->control.insn_len =3D vmcb02->control.insn_len;
>> +       }
>
> This only works if the #VMEXIT is being forwarded from vmcb02. This
> does not work if the #VMEXIT is synthesized by L0 (e.g. via
> nested_svm_inject_npf_exit() or nested_svm_inject_exception_vmexit()
> for #PF).

I very definitely didn't consider that. Subtle. Thanks for bringing it up.

>
>>         vmcb12->control.int_state         =3D vmcb02->control.int_state;
>>         vmcb12->control.exit_code         =3D vmcb02->control.exit_code;
>>         vmcb12->control.exit_code_hi      =3D vmcb02->control.exit_code_=
hi;
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 24d59ccfa40d9..8cf6d7904030e 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -5223,6 +5223,9 @@ static __init void svm_set_cpu_caps(void)
>>                 if (nrips)
>>                         kvm_cpu_cap_set(X86_FEATURE_NRIPS);
>>
>> +               if (boot_cpu_has(X86_FEATURE_DECODEASSISTS))
>> +                       kvm_cpu_cap_set(X86_FEATURE_DECODEASSISTS);
>> +
>>                 if (npt_enabled)
>>                         kvm_cpu_cap_set(X86_FEATURE_NPT);
>>
>>
>> base-commit: 0499add8efd72456514c6218c062911ccc922a99
>
> DECODEASSISTS consists of more than instruction bytes and instruction
> length. There is also EXITINFO1 for MOV CRx, MOV DRx, INTn, and
> INVLPG.

Right, I didn't do anything about those because exit_info_1 is unconditiona=
lly
copied anyway when forwarding from vmcb02 to vmcb12. Of course that doesn't
account for the emulation paths you mentioned before.

> Since L2 typically gets dibs on a #VMEXIT (in
> nested_svm_intercept()), these typically fall into the "forwarded
> #VMEXIT" category. However, these instructions can also be emulated,
> in which case the vmcb12 intercepts are checked and a #VMEXIT may be
> synthesized. In that case, svm_check_intercept() needs to populate
> EXITINFO1 appropriately.

I'm trying to think of ways to test this.

It's really quite subtle. So testing MOVs to/from CR/DR would be...

  1. Take a page L0 always does trap-and-emulate on (IOAPIC? LAPIC? HPET?)
  2. Map it on L2.
  3. Have L1 intercept MOV to/from CR/DR
  4. Have L2 do a MOV to/from CR/DR from/to that region.
  5. Ensure the VMCB at the L1 has exit_info_1 correctly populated.

INVLPG and INTn presumably would always be in the intercept union, so these=
 are
unaffected.

As for #PF and NPT intercepts... I don't _THINK_ they are affected either? =
I
don't see which L1/L2 configs might make the L0 emulator execute an instruc=
tion
on behalf of the L2 and THEN exit to L1 with an exit code of #PF/NPT.

Even considering FEP, that ought to affect L1, and not L2. And even if L2 h=
ad
FEP enabled that would materialise as a forwarded #UD and not something emu=
lated
by L0.

So, unless I'm missing something (which I may very well be, seeing how I mi=
ssed
this already), synthesising exit_info_1 for the MOV to/from CR/DR ought to
suffice. Which is far less annoying than teaching the emulator to fetch mor=
e
data than the current instruction, so I really hope I'm not wrong.

Let me know otherwise, and thanks again for the review.

Cheers,
Alejandro

