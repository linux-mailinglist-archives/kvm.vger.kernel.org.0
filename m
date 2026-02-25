Return-Path: <kvm+bounces-71883-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yGuYLhtYn2kCagQAu9opvQ
	(envelope-from <kvm+bounces-71883-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 21:14:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FB0A19D188
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 21:14:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CDCBB3086A4D
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 20:13:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D41A312806;
	Wed, 25 Feb 2026 20:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.com header.i=@fortanix.com header.b="x/not5Wf"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11020087.outbound.protection.outlook.com [52.101.61.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B15C2C21F2;
	Wed, 25 Feb 2026 20:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772050416; cv=fail; b=c5dL4c/MZMYGHzbB9iF8/rTl9XTEegEYIVsc4GE62a86R3nFvmZ39RFg0jwAyHaC2OkbUkA8HAZrH9Nv/E2z5IxPiU9BbdQjcgZonmWCTDeVJxAmptwXfXdOzHERB37BPMPjF1MNpPmvkSYvZJPTM/r7I/itYJQ4+Dpxul9txMg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772050416; c=relaxed/simple;
	bh=E9HoleqSYxalM+ePibkP2ngoaONsSdq1+DUOFWuWQuc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=C2OfbFz45Ey8d/GRUb62K1H9C7i40rd4KM02PzOw1NcksqTXjtmGqtSKJNy8k1fflhJzJABGwqOeD8Tfvd9jCDjYSiEX/YuWq41yeh4kJ0/pXd5ygh/4z/USZrtsLxxtPOjCbYyw5jMtzivs1T1BCOTlADi0ZpGfmUcsKvhAEaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fortanix.com; spf=pass smtp.mailfrom=fortanix.com; dkim=pass (1024-bit key) header.d=fortanix.com header.i=@fortanix.com header.b=x/not5Wf; arc=fail smtp.client-ip=52.101.61.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fortanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fortanix.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WaNWXQL6CmdpfbKiM4mWcHIm30XgYCtFwu1MQqSxquepHBSo1mCc05q1MfDpP84pybiFAP5va98ArheXNdXurMCFAahdswLe1zp8tgqMzTPfCJY+xvqiO5AeONfDmAgLqYUREk5tq/TmJ6pICE7NAPtHx3hoFo/jm8c05KPdwrQP/v7/5CLTU7DZY7FGokNTDnAG363MKLdLw6Hc3w8xWoGeNroxNQFO1SoFJGq010ZLS4l/8EjZmltgs7t6exkqWJlONuctTfCKXJI8z80nSTr5IIYX4ZPm4dLJi5uL+PRTZALdVYv9eEy/xQCB0JRe5ECJHgdXiZc2rNVKrqLrjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cAYhrWqTiyrD7af4sPRQHYmBgYY+jflL3dRvzAPH7Lo=;
 b=TRUEUM287LE/32q1kclVfDnf4kZq+vBTyP6DaOIPtr00o8eUoBLaQfGm7tvgUi4OAZaQq/YwoOqkUMb+8Fo3ggmpCscvqBIl9MayVaYFTYCPJJaFwiHkj29pp9RwOMEJHhiMHcOC4DIR6zLIlKI53kmDjDbukN2MPwk7Dn3VF88NDQOdk19SoJFnPe+eVhMhs4flVhq4ZfyakkYOg3h1HqRnMdsOG2A86l3QV+oncTps3rx0upJhWt0+pPwcS0yiL+aXdWzvFQ+JH/6gAfhXJ5vxZeMpf6zcqvSwJlOyFlzyMzSTs7DWIiU53gsOqsirL2MqrDXK2BsheClIZddE8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fortanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAYhrWqTiyrD7af4sPRQHYmBgYY+jflL3dRvzAPH7Lo=;
 b=x/not5Wf3vOlJGRwkE8a3AlzzsT7eNL6iEkZcpMs3E3krlJSXDed9etx5waDPHY71HX0qdRnscEE1l4QSiTRQnPGhCTsb+RrO+vueWv0c9SakhQXz5mR+U3v3+I/YLi6VPWHFkHxbzEuJi4/mqS7h5rpHjbV4phktoWitfpIidE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fortanix.com;
Received: from PH0PR11MB5626.namprd11.prod.outlook.com (2603:10b6:510:ee::15)
 by DM4PR11MB6239.namprd11.prod.outlook.com (2603:10b6:8:a7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.19; Wed, 25 Feb
 2026 20:13:30 +0000
Received: from PH0PR11MB5626.namprd11.prod.outlook.com
 ([fe80::64f2:5af6:ec99:cb80]) by PH0PR11MB5626.namprd11.prod.outlook.com
 ([fe80::64f2:5af6:ec99:cb80%4]) with mapi id 15.20.9654.007; Wed, 25 Feb 2026
 20:13:30 +0000
Message-ID: <928a31e1-bb6f-44d4-b1de-654d6968fd55@fortanix.com>
Date: Wed, 25 Feb 2026 12:13:54 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: SEV: Track SNP launch state and disallow invalid
 userspace interactions
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev
References: <d98692e2-d96b-4c36-8089-4bc1e5cc3d57@fortanix.com>
 <aZ9V_O5SGGKa-Vdn@google.com>
Content-Language: en-US
From: Jethro Beekman <jethro@fortanix.com>
In-Reply-To: <aZ9V_O5SGGKa-Vdn@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN0PR10CA0030.namprd10.prod.outlook.com
 (2603:10b6:408:143::9) To PH0PR11MB5626.namprd11.prod.outlook.com
 (2603:10b6:510:ee::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5626:EE_|DM4PR11MB6239:EE_
X-MS-Office365-Filtering-Correlation-Id: b7b0fb2c-4d4d-4691-7a05-08de74aa57f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|10070799003|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	y1aZxHosqdAlCPwZtZ+GH6V2OOzY8TRdhpFjyCOXHXt7NEvT0Ka3i9SIAJLKudoMGR2rvyR8m//G7DKUPrf7eAKKrb+2WgOyL4oX6rZWR0OOwXgYct4t6cFrdoLJxQGW7nXnr3QCbcYVVrn/hUfMNGcZjyT5GdDV8bREfIsm9WZsm/89Ds0sYhR8ZHotHzyGFynDvW5+3ffgc7hNx5LKXT3mD81flmHUacWX6gjSpNNiJImXXy2x5/mz23Tn/+JEG0Xie7i/Nr3pvkNHMhUFiSkrcReD32qUxW6WI/nbrSEUigYPMbhLb1+97UC2xHm2LrbKllhFBguQaIJ/NxlvKFrVSI6uPsId+O6rvnhz0kZL+glEUMnhXDZaiLXAbf5c0E2nVZjLTtyPfMBmimYLFu5a4GtTWhu8cXRPXFWS0CBLGWamzd/iME85Y5Uhdc1dPnJw8BHdrli8DWfDcC1HvKfZCBXmD8kWU7N/me1RZvuZq/uyj8i0vLLnx9qiEpzYVPGbCrLL3vO40fIjqDcX4H1ObB+iFW5tIkx2qAg50Zb5NXN8PNbiU1qPcnM5ZPrJGkkBuw0PxKlQ6QuAn2FXJHNTmSQVm0dozdYHgaxL+7iEEKgJipuGnxzOHgERDftDDcYl6ManET9kGote+BXNLFKq7fsUQQoxxnyc+iMmM6xZ8axIp1+NYjg9aNfBdTj1ICrzvaz97TVcJV+avK/QjV00Y29yRKVx3WnTMdc4HNg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5626.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(10070799003)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bVhuVTMwWHdMaEVvRFVZbU1YVnJLWCtyeWVreXl0T2RWM29EekphMHhET3I3?=
 =?utf-8?B?Vzl3Vmx6OU9pYW14QllpU1F1dU54Y1ZXQjNlYUoyKzZJWGN1YnZ0aGt4MHFn?=
 =?utf-8?B?UzJpdEFHeDlXcERJN2tPcWpCckdQYk9hV1ozVENPZGJ5WUE0aEE5V3J6UUpK?=
 =?utf-8?B?UG5YR0VnMjV2UkJuMDBHdnExMmxTVTc2Vm1nbUlubnRsdXh2aVpyUURrUzVZ?=
 =?utf-8?B?SjI1dHdSR3crTnJoUFVWNXNhSjlWR0U3Nm5ONU84MlVmMEJ1OGtINy9wZXJr?=
 =?utf-8?B?ZFBQS0lmSlFmay8yREZYcnRVcVUydVc4ZFZrbWZzbzVtQXhEUGxGUVdPY3dZ?=
 =?utf-8?B?d0hBWmluMHlpVGI1ZTNUWHNQMWdjUGQ5SkFHMTR2WURsbHZGU1NKak05cjRZ?=
 =?utf-8?B?VUNnRHdpcUlJMlIzNElHME4reDNucVd4TVlaYzFuaGx5a2REOURGb1gzN01W?=
 =?utf-8?B?bWdjaFJ0MkdnSVVtK0ZyeWxvSXlMVGlaUzhieVpWdVBXVE9WQ0hKL2RuZU5J?=
 =?utf-8?B?MjRzTlN0eUc5SmVpOGhKOG5peFNVS2ZtL0w5WnJ2SjBZbnhsdldXZjQvU1Jh?=
 =?utf-8?B?RFJJQklKWGpDdUFLbnorSnRjNFZPMFprU1JyV0ZuVFZQdmU0OGVBSGhLZnBh?=
 =?utf-8?B?SDMvUlFoUjIyRXBQZXNwR3FRQTE5VmRQY3NVS25FaCsyaXZFOUlOR1MrcEtX?=
 =?utf-8?B?OWNodVg1VkY1MkE3RmpxbzZ0ektnN3pZV2VUc044NFNWSDA4RXduNi9DQzVY?=
 =?utf-8?B?TmthT2FDZUNiblhKNDEvS1lyVHNySUpXMWNrK2tJY3Z0ZzBXMTFQWXZaWnVz?=
 =?utf-8?B?cVZFK2xZNjJMN05CbVc4YndxVlVMa0FYeCt2d3M0N2REcVpFRXBNcnBDQlE0?=
 =?utf-8?B?cXM2MVNlTS9LdG5Ec1lSanpLb1l2eUhXQktyR2N6ZVUya1c3YjNpWVQ4U0hC?=
 =?utf-8?B?S0NNdkxoMVRZZG9YV3hWT09mSHE2Um1VTjViZ3ZzV1FoTVMrMmZ4RHFKWGsw?=
 =?utf-8?B?ajBVZXRNTFgyVmtNenUzdlU0eThQQkU5RC84OVRwWkV5YkpVNGNhMjFDZ1di?=
 =?utf-8?B?SUVkTjg0VHJMbFJEemExZEdJRjByMGltdlh5a2JZKzVjSWRxS05ROE5uMXVm?=
 =?utf-8?B?aXF4SFBNY1NpSnZRbWhLN0U1czdaMEF3R0IwV1JCRzBpZDdxMWJlZGs1SFNn?=
 =?utf-8?B?ZmVPQm1waS9uZzFlWGtzOWw1ZXZORUFrYnQ1dmVoQ0pac0pzZHY3ME1sZkJE?=
 =?utf-8?B?cmdWb3dGQ0RpVVhRSmloTU5aYWdpeTZvbFprdCtURmNDcUNmM1hYU29Xd0Nl?=
 =?utf-8?B?elBIR1MvcC93ZjNaTEVPVEVkcWUrYWRJYmN1OUcxTml2UlgzdmI4NDhBZkdV?=
 =?utf-8?B?bS94Zm9KL29YZTFFcWFoTXhmZXFXVDJ3Qm8vRFhtRElKa2xEd0Uzek9JZ3A4?=
 =?utf-8?B?WUlJWFNiZ1lGdSs0cU9reURNemFodWZObVc2WStDbk9QcmVtRXlvTXlVa3lD?=
 =?utf-8?B?UEVHYm5ndW1pcCtSenFOUVJsLzlSdGZWS0cwbW1Db21lMVh6TDI0bWNERjVG?=
 =?utf-8?B?SHYreGRWZkdoZEtMSnVyaENtOVZnNEFrdW1lVUZMSk5xVFdKdGQyNWlPdG4w?=
 =?utf-8?B?V3I2MkxNbThFVzkrL2lkcTlqK3UvMWNJUTVmYm5BYkVZWVJna04wWFdWTDNJ?=
 =?utf-8?B?dUZsUXF4WVc4SGpUbWFvNXhKdm1xWWxWZkh6aHNNRS9VVThWQVJLd2V2OEFW?=
 =?utf-8?B?Vm9JVGNEMVdTWDdGdnlaT21hc0xWQ0dlSDJTQzFsSjFZSmY1bmNjQ1o3SmVH?=
 =?utf-8?B?LytuaDJTM3ZNUksxT1hTRkgxQVI4cy9lWndlZE1ndnA5bjUyU3NDeEZQZEpp?=
 =?utf-8?B?amFXTVRZMi90Y1NwdW00STVmY2o2TDBycjZ2NjhWbFJISThPTWFZNFdkTVpr?=
 =?utf-8?B?QU5BdlRHVmtQUkpJc2xMNFA2Ry83RjRzYVdHYlZwVGNxQkRRSmZwcDBOOVFs?=
 =?utf-8?B?TUI1WGpsNHEvZGJmekw1SXJEY2tETE44WVFxZFg1T2NaZUh5cjdqNEVla2h4?=
 =?utf-8?B?akJ3WnJaMVNyYVBoMjlEWWs5eHdPelVLOEtzRmV4S3R5bGplUzVScTFhWmh5?=
 =?utf-8?B?ZUJLUjRBT05Cd0szSjZiczdZc2pmdVJkRldoUUg3Qy9za1lnTnhOb21uZlhu?=
 =?utf-8?B?VTlsRWVkcGRmbHVsK3MvV2E0SS92ZWIwZ1hvelJ1VU4wb0NqdDdCa2s0d0hp?=
 =?utf-8?B?b3JBYnp6anhvZVpxZU1VdjhuMkJLSUlvYlVCdzZ4V1JITzJUZVhqYU03eDFE?=
 =?utf-8?B?eGQ0d2picHcrN3ZmT2dEOFBrYU1lM2pXY3BGQVovUHBXRER5NGxrb0YyUUR6?=
 =?utf-8?Q?4X2zmMgXxtyeG8YQ=3D?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7b0fb2c-4d4d-4691-7a05-08de74aa57f9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5626.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 20:13:30.4117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: akHDd8+gTIw0wYZ3oNmcTCRJuwyBeXrahiPXrA72ZB9WNStEITZDPJSTNMkW78c8Ft/rB0mbiB2Tr3+Pj/hVXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6239
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[fortanix.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[fortanix.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71883-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[fortanix.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jethro@fortanix.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,fortanix.com:mid,fortanix.com:dkim]
X-Rspamd-Queue-Id: 1FB0A19D188
X-Rspamd-Action: no action

On 2026-02-25 12:05, Sean Christopherson wrote:
> On Mon, Jan 19, 2026, Jethro Beekman wrote:
>> Calling any of the SNP_LAUNCH_ ioctls after SNP_LAUNCH_FINISH results in=
 a
>> kernel page fault due to RMP violation. Track SNP launch state and exit =
early.
>=20
> What exactly trips the RMP #PF?  A backtrace would be especially helpful =
for
> posterity.

Here's a backtrace for calling ioctl(KVM_SEV_SNP_LAUNCH_FINISH) twice. Note=
 this is with a modified version of QEMU.

BUG: unable to handle page fault for address: ff1276cbfdf36000
#PF: supervisor write access in kernel mode
#PF: error_code(0x80000003) - RMP violation
PGD 5a31801067 P4D 5a31802067 PUD 40ccfb5063 PMD 40e5954063 PTE 80000040fdf=
36163
SEV-SNP: PFN 0x40fdf36, RMP entry: [0x6010fffffffff001 - 0x000000000000001f=
]
Oops: Oops: 0003 [#1] SMP NOPTI
CPU: 33 UID: 0 PID: 996180 Comm: qemu-system-x86 Tainted: G           OE   =
    6.18.0-8-generic #8-Ubuntu PREEMPT(voluntary)=20
Tainted: [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODULE
Hardware name: Dell Inc. PowerEdge R7625/0H1TJT, BIOS 1.5.8 07/21/2023
RIP: 0010:sev_es_sync_vmsa+0x54/0x4c0 [kvm_amd]
Code: 89 f8 48 8d b2 00 04 00 00 48 89 e5 41 56 41 54 53 48 83 ec 30 48 8b =
9f 18 1c 00 00 48 8b 8a 00 04 00 00 4c 8b 07 48 8d 7b 08 <48> 89 0b 48 89 d=
9 48 8b 92 e0 06 00 00 48 83 e7 f8 48 29 f9 48 89
RSP: 0018:ff42462db15fb8b8 EFLAGS: 00010286
RAX: ff1276d253008000 RBX: ff1276cbfdf36000 RCX: 0000ffff00930000
RDX: ff1276cb899e6000 RSI: ff1276cb899e6400 RDI: ff1276cbfdf36008
RBP: ff42462db15fb900 R08: ff1276cbfb1f2000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ff1276cbfb1f2000
R13: 00007fffffffdc10 R14: ff1276cbfb1f3188 R15: ff42462db15fba70
FS:  00007ffff6846f40(0000) GS:ff1276cacfaf0000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ff1276cbfdf36000 CR3: 0000004628e03004 CR4: 0000000000f71ef0
PKRU: 55555554
Call Trace:
 <TASK>
 snp_launch_update_vmsa+0x19d/0x290 [kvm_amd]
 snp_launch_finish+0xb6/0x380 [kvm_amd]
 sev_mem_enc_ioctl+0x14e/0x720 [kvm_amd]
 kvm_arch_vm_ioctl+0x837/0xcf0 [kvm]
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? hook_file_ioctl+0x10/0x20
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __x64_sys_ioctl+0xbd/0x100
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? kvm_vm_ioctl+0x3fd/0xcc0 [kvm]
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __x64_sys_ioctl+0xbd/0x100
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? arch_exit_to_user_mode_prepare.isra.0+0xd/0xe0
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? rseq_get_rseq_cs.isra.0+0x16/0x240
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? kvm_vm_ioctl+0x3fd/0xcc0 [kvm]
 ? srso_alias_return_thunk+0x5/0xfbef5
 kvm_vm_ioctl+0x3fd/0xcc0 [kvm]
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? arch_exit_to_user_mode_prepare.isra.0+0xc5/0xe0
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? do_syscall_64+0xb9/0x10f0
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __rseq_handle_notify_resume+0xbb/0x1c0
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? hook_file_ioctl+0x10/0x20
 ? srso_alias_return_thunk+0x5/0xfbef5
 __x64_sys_ioctl+0xa3/0x100
 ? arch_exit_to_user_mode_prepare.isra.0+0xc5/0xe0
 x64_sys_call+0xfe0/0x2350
 do_syscall_64+0x81/0x10f0
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? arch_exit_to_user_mode_prepare.isra.0+0xd/0x100
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? irqentry_exit_to_user_mode+0x2d/0x1d0
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? irqentry_exit+0x43/0x50
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? exc_page_fault+0x90/0x1b0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7ffff673287d
Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45 10 c7 45 b0 10 00 00 00 =
48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 f=
f ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
RSP: 002b:00007fffffffda80 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000c008aeba RCX: 00007ffff673287d
RDX: 00007fffffffdc10 RSI: 00000000c008aeba RDI: 0000000000000008
RBP: 00007fffffffdad0 R08: 0000000000811000 R09: 00005555562737f0
R10: 00005555576631b0 R11: 0000000000000246 R12: 00007fffffffdc10
R13: 0000555557695f80 R14: 0000000000001000 R15: 00007fff73c75000
 </TASK>
Modules linked in: kvm_amd nf_conntrack_netlink veth ecdsa_generic vfio_pci=
 vfio_pci_core vfio_iommu_type1 vfio iommufd amd_atl intel_rapl_msr intel_r=
apl_common amd64_edac edac_mce_amd xfrm_user xfrm_algo xt_set ip_set bondin=
g cfg80211 nft_chain_nat xt_MASQUERADE nf_nat binfmt_misc xt_addrtype xt_co=
nntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nft_compat nf_tables xfs=
 nls_iso8859_1 ipmi_ssif platform_profile dell_wmi video spd5118 sparse_key=
map kvm irqbypass dell_smbios dax_hmem dcdbas cxl_acpi rapl cxl_port dell_w=
mi_descriptor wmi_bmof mgag200 i2c_algo_bit acpi_power_meter cxl_core i2c_p=
iix4 einj ipmi_si acpi_ipmi k10temp ccp i2c_smbus ipmi_devintf mlx5_fwctl j=
oydev input_leds fwctl ipmi_msghandler mac_hid nfsd auth_rpcgss nfs_acl loc=
kd grace sch_fq_codel sunrpc br_netfilter bridge stp llc overlay efi_pstore=
 dm_multipath nfnetlink dmi_sysfs ip_tables x_tables autofs4 btrfs blake2b_=
generic raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor as=
ync_tx xor raid6_pq raid1 linear mlx5_ib
 ib_uverbs macsec ib_core raid0 hid_generic usbhid hid mlx5_core nvme mlxfw=
 nvme_core psample polyval_clmulni ghash_clmulni_intel nvme_keyring tls ahc=
i nvme_auth megaraid_sas libahci pci_hyperv_intf hkdf wmi aesni_intel [last=
 unloaded: kvm_amd(OE)]
CR2: ff1276cbfdf36000
---[ end trace 0000000000000000 ]---
pstore: backend (erst) writing error (-22)
RIP: 0010:sev_es_sync_vmsa+0x54/0x4c0 [kvm_amd]
Code: 89 f8 48 8d b2 00 04 00 00 48 89 e5 41 56 41 54 53 48 83 ec 30 48 8b =
9f 18 1c 00 00 48 8b 8a 00 04 00 00 4c 8b 07 48 8d 7b 08 <48> 89 0b 48 89 d=
9 48 8b 92 e0 06 00 00 48 83 e7 f8 48 29 f9 48 89
RSP: 0018:ff42462db15fb8b8 EFLAGS: 00010286
RAX: ff1276d253008000 RBX: ff1276cbfdf36000 RCX: 0000ffff00930000
RDX: ff1276cb899e6000 RSI: ff1276cb899e6400 RDI: ff1276cbfdf36008
RBP: ff42462db15fb900 R08: ff1276cbfb1f2000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ff1276cbfb1f2000
R13: 00007fffffffdc10 R14: ff1276cbfb1f3188 R15: ff42462db15fba70
FS:  00007ffff6846f40(0000) GS:ff1276cacfaf0000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ff1276cbfdf36000 CR3: 0000004628e03004 CR4: 0000000000f71ef0
PKRU: 55555554
note: qemu-system-x86[996180] exited with irqs disabled

--
Jethro Beekman | CTO | Fortanix

