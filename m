Return-Path: <kvm+bounces-71331-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SP++DT+jlmk7iQIAu9opvQ
	(envelope-from <kvm+bounces-71331-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 06:44:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E05215C2A7
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 06:44:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6D5EB304D272
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:43:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E5732C0F6D;
	Thu, 19 Feb 2026 05:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Y2X8kkl2"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010000.outbound.protection.outlook.com [52.101.85.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971742848AF
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 05:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771479826; cv=fail; b=aOVpVqEW5D38V5XNtkSXA5pU9a3sbEeQYHEjpdzjLbxg7kiAXJVutJY3Ru/NS+8x4qO6Z/HC982ESFot3WI8h2h8czEvVmFhpgnSB4g0qn/pCxui0QR1D8rBqd/6uJq9APZqi4cBPi/h84Np1pvSFUxjkylhC1RQgomIIv76Yls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771479826; c=relaxed/simple;
	bh=6nguDP6yLd4Yn7cPgBqVumEmUmHPrgDhitJrqFJUeoE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EYLpl9HsGTK1tilc99kjNdRX3zdubcn2GFlLa56EB3b9JxirocWPBh/G6YBIlYhgympIeyeLu7oDuRIFYY4lfg0f1Xm8RIBJn+DoxHgutjZoRHED4zgmYGR5tpXNA9DoRJoa3vlH5kz3bH1L0Q54Tp8Shud3O+dc7/7HuGTvIog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Y2X8kkl2; arc=fail smtp.client-ip=52.101.85.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lsqh6jDo8HbpV1qpnElYxuQYDvkhmg0JZhC63T54fEXvof4SdZNr+dpUAJudYKrDy3M6VZ5dN5DEarwephK4QLumv1ot6/eVLxxuvf6x3FVUeJUkT/dlgvjx+iA/W8ydXiv2m0rkc2HQuFBNIRjZLQdb/9qzf/hygH/kDsRNt1DFkS5qDdbR6PR+TPELzR06WdPBIjKObnlANwcN9zeY77JzfItNaZVAfXYhNo7PdIhWHVVh5VjBe2sY7fTAyxDyrXi0RiuFyI8vfmeC43W0aVg2QhlTzQns+LZEPlBxrjX6nBjLOIsiWBVJQs0gv0pV+QJTxslcJbCeRbuOG1VXMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Col43SzJeNwKuNZ6EMFerTnHD5qjf0AvUpZrXsGDfmk=;
 b=C+sTw3A6KbW+7+14EEMxMyHTZablvWmC6gFSM5AJEO79igZ3XCtOHfHxm7v0fs1ieW9Gn0XaenJVs8bOx5wZ7E3Ydf4mziyImBRk8/ON/uZ+nYrrHU49Vh+BnwLHXy157mXlrkfWk9zUzk8iQrt1SG2fONlyHOUGfqj7TU2Xu/el3hoDDN/6u4uD2fpzGL9BAHUnxdHV8Swi4YGT3OiRCGUAaoqGkzMuVls7AUFuxG75A/MLjeFThR5UKs+5v+7H1iSaYY+TyPJ9B/oJ+NHB3S07qIyanHIH9dZtwfeQwCBS952MaEQTvrcv/1CkMz+QUfz3qOVrF27nrGYHCkwoog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Col43SzJeNwKuNZ6EMFerTnHD5qjf0AvUpZrXsGDfmk=;
 b=Y2X8kkl2oGKOsRRyw7SbX1gwYqYWNdtbu1pVkfAyZEjf9EI3Ke8kFyCNfWIc/N2ugmVQ6jah9nbMIm+6OHatnq64+aXzFm1d806w6u3J62f2afmMSbJlNCoweFuJaOEJBo4L7CFzogpSER7cDkJsnaKwSv9vrBPDQKqI5TlHObc=
Received: from BY5PR03CA0005.namprd03.prod.outlook.com (2603:10b6:a03:1e0::15)
 by LV2PR12MB5919.namprd12.prod.outlook.com (2603:10b6:408:173::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Thu, 19 Feb
 2026 05:43:41 +0000
Received: from SJ1PEPF00001CDE.namprd05.prod.outlook.com
 (2603:10b6:a03:1e0:cafe::81) by BY5PR03CA0005.outlook.office365.com
 (2603:10b6:a03:1e0::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.14 via Frontend Transport; Thu,
 19 Feb 2026 05:43:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CDE.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Thu, 19 Feb 2026 05:43:40 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 18 Feb
 2026 23:43:37 -0600
From: Manali Shukla <manali.shukla@amd.com>
To: <qemu-devel@nongnu.org>
CC: Cornelia Huck <cohuck@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
	<kvm@vger.kernel.org>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Marcelo Tosatti" <mtosatti@redhat.com>, "Michael S . Tsirkin"
	<mst@redhat.com>, "Paolo Bonzini" <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Richard Henderson <richard.henderson@linaro.org>, Naveen
 N Rao <naveen@kernel.org>, Nikunj Dadhaniya <nikunj@amd.com>,
	<manali.shukla@amd.com>
Subject: [PATCH v1 6/8] i386/kvm: Add KVM_GET/SET_LAPIC2 support for extended APIC state
Date: Thu, 19 Feb 2026 05:42:05 +0000
Message-ID: <20260219054207.471303-7-manali.shukla@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260219054207.471303-1-manali.shukla@amd.com>
References: <20260219054207.471303-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDE:EE_|LV2PR12MB5919:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c3e571d-c970-4073-7456-08de6f79d63b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cmhgCUAEQ+PC8dRl9AhloeFmjPegeGYFWjljE6d/+saNCQ/bLzTf9MrV143c?=
 =?us-ascii?Q?m6Gz8/gMx6dAfFL1gAw6It7S3/1g16S4ia5xoxmOq+lWCu0C2fwqZwTodnb5?=
 =?us-ascii?Q?Ip6xHDyyoSyMO5CnrrR2R3Av1tI4g1PGNwEb416d6qLzc1A2xkqJmUO+6gTO?=
 =?us-ascii?Q?E22xEjWKbQTVvXJOoyl6M0nwX2IPqVu+7QIJwW8s2jLwaT34oee7BS4KPwij?=
 =?us-ascii?Q?7i2wLHmebMei6AZs4cVioGMEY4XyfGPex7Fv80Z+M7MOQrGXXMZdFX+hK/RR?=
 =?us-ascii?Q?AXGsfOSAnYpBndTkZOwF465PzTogIA5LSaoplHwQiRbrjMen0d8HsezWYK9F?=
 =?us-ascii?Q?wW96oTAfBNvYSkliWYcEJ3NW3/W0wLGQqpW1RAbAXAxWWo/B6Q+fXskAgQXw?=
 =?us-ascii?Q?PMdLrxPREI81S+htYJZPXtRgIq5L07Fc/jTS9Rh7khFb3KC72i70MTe3US+O?=
 =?us-ascii?Q?vaHqEZkknedzzujuWDezfnLPBw+MUEK9D7kCiy30bov3nddLxESbRU5qMH0J?=
 =?us-ascii?Q?B6ZcNdMS01gyjRRjjFTh+aqpnYwfekNUPiIZhaZRhLhpJB/5N6Lj6gw3VyoX?=
 =?us-ascii?Q?aO4zX6MW9XcratB4i2Vub+e84lg2d0Xr3jcJ623inrY9YSYl/c+EeE3YAIPk?=
 =?us-ascii?Q?zy/OvPXrNOPPviqUeanWJHeZju0+mY/DNhutDFKMolvreWEbtsXl8GVCg256?=
 =?us-ascii?Q?7O+w+ZRuvuNn9lBTytwIsR0429ixzminlumBk9D9ZZXTHUsIhQElEfAV5TF7?=
 =?us-ascii?Q?cZQamsxpzHsTqbsquEAfmQflziR1oSRq9eMupA0CYB3/YhFLQ7XM0vhJOAKZ?=
 =?us-ascii?Q?NXXbbi0QJOSPjzEJ/JVq1+ZP4XzapPQQCKNZTGW0AIEvQRBccYSZI4iYKTME?=
 =?us-ascii?Q?fPBVfNb2JVtlfCMRXPnlWW2yhSxeWcitM4Il6pB/u2lhSoCC009eRoAHpLVP?=
 =?us-ascii?Q?uPt2r20fdGHJJb432OthNPw4CS0pKgj11OuanrFFEGxtOBfwwpK7cVaj4Gxb?=
 =?us-ascii?Q?k6drJtUQYbr9ZijiRJi99UEb9NY/qBFciS9pXSXf9jrYiUA3rAcpMbQxUZfW?=
 =?us-ascii?Q?7X3IkNCm8Qg5mpphGYQHphSJy9GfoqoPtQr5vHZ4JLyOsQc/eO9cXFqwweG4?=
 =?us-ascii?Q?pzsfpvAzHx3+5SeQWHd6/ENwmVzsv0fYRHlGIlOVuDL8qvW1g4zqigRMIZ+n?=
 =?us-ascii?Q?RHeKVhezGCKkVYB8khT1bC/sg3hMa6L3frLO3NJhLdeBsCF//jXrLCS0IqzU?=
 =?us-ascii?Q?IKP1wDAt58B8W+YIh8gZigJlTH3q23sc1vp0HWIGO2F91wxLF2ltL4kzezgL?=
 =?us-ascii?Q?qlYN3hX04A1YaezC4ExeC5lx3ozVALuSIAGOlwnyDRH1oKnCkrF9sntLtag0?=
 =?us-ascii?Q?k0c4QeSnGQYJ3wtiRN7W7rNVxpgRvtNHqVWzeHNbHpwBa+5QVvNdsItyxC3Y?=
 =?us-ascii?Q?nt/wOIb49oEZotpBUtvzfE5VCVQJurWG97wJdDNGte9DuLbK8a0Rla70YhE+?=
 =?us-ascii?Q?3kQ90QaJQSBykfuhzCOTv7VkHU///XFdwD+HB7GLY3nCCjN+uKS/YQ7SP9/m?=
 =?us-ascii?Q?YuJTtNPAs4RbtDE2Rfa06d23z9IKSDbZZ68WYoJwlOBC3TjKXrC9IsZ0SCDn?=
 =?us-ascii?Q?dJ/Uqhkia9e8anAfhfMkt+6CY1u5EUmTFg14JL7Cu+3f6A26FCFT/GMHN0YL?=
 =?us-ascii?Q?6hn0Ig=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	oi7nEDHQF4eDvrtz6FUzZLWhhI1aDEonPtbzoPNHizUU+RCq+r6HYITRxeQiqeQWAGNf5nMZ5qwiLqeIXoixWZ8Bx8CfJeHTDqIQEf7MSO7A79iNIlj40SvMlzubwcB97hMr7LyHKJip/nIi4KyV0FJDoLd/iC7CfI0rVZauRp7IjSXEmiQUHTLObVbbEZ8Yhg3NluBYJKTMkOONsl5s4Ac6zXurLT1dwCXggXioqqWpe0yIJdGIRXcj7EeBRuybxNNAemuGe05ABU5n7uTAZd1sydz0U3sdtFQlQDw04RYc5vC2SeYSk5EuvvWIawCcmrXyykP4p5Ac4jexu1Vt4GloRB32Kakyb+jWStUSz97CxTuABPEBWPlXQUriQBDqK14BdHzB824A/c5bNZIJvJysXZwit1c2je5z1bH+HOd/7u5hEHMtbFkK/J1H63iE
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2026 05:43:40.8115
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c3e571d-c970-4073-7456-08de6f79d63b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5919
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,habkost.net,vger.kernel.org,gmail.com,google.com,linaro.org,kernel.org,amd.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71331-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[manali.shukla@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,amd.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 8E05215C2A7
X-Rspamd-Action: no action

Add support for KVM_GET_LAPIC2 and KVM_SET_LAPIC2 ioctls to synchronize
extended APIC register state between QEMU and KVM.  The extended ioctls
operate on a 4KB APIC page (struct kvm_lapic_state2) instead of the
legacy 1KB. (struct kvm_lapic_state).

Use the extended ioctls when KVM_CAP_LAPIC2 is enabled (has_lapic2),
otherwise fall back to the legacy KVM_GET/SET_LAPIC ioctls to maintain
compatibility with older KVM versions or when extended APIC is not
negotiated.

When extended APIC is enabled (has_extapic) for AMD processors,
synchronize the extended registers:
  - APIC_EFEAT (offset 0x400): Extended Features register
  - APIC_ECTRL (offset 0x410): Extended Control register
  - APIC_EILVTn (offset 0x500+): Extended interrupt LVT entries
Currently on 4 extended interrupt LVT entries are supported but future
processors may support more.

Add kvm_apic_put2() and kvm_get_apic2() is added to mirror kvm_apic_put()
and kvm_get_apic() for the extended ioctl path. Route kvm_apic_post_load()
, kvm_apic_reset(), kvm_arch_get_registers() through the appropriate
put/get function based on has_lapic2.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 hw/i386/kvm/apic.c    | 55 ++++++++++++++++++++++++++++++++++++++++---
 target/i386/kvm/kvm.c | 24 ++++++++++++++++++-
 2 files changed, 75 insertions(+), 4 deletions(-)

diff --git a/hw/i386/kvm/apic.c b/hw/i386/kvm/apic.c
index 7bec7909e9..f91af66116 100644
--- a/hw/i386/kvm/apic.c
+++ b/hw/i386/kvm/apic.c
@@ -33,7 +33,11 @@ static void kvm_put_apic_state(APICCommonState *s, void *regs)
 {
     int i;
 
-    memset(regs, 0, KVM_APIC_REG_SIZE);
+    if (kvm_has_lapic2()) {
+        memset(regs, 0, KVM_APIC_EXT_REG_SIZE);
+    } else {
+        memset(regs, 0, KVM_APIC_REG_SIZE);
+    }
 
     if (kvm_has_x2apic_api() && s->apicbase & MSR_IA32_APICBASE_EXTD) {
         kvm_apic_set_reg(regs, 0x2, s->initial_apic_id);
@@ -58,6 +62,13 @@ static void kvm_put_apic_state(APICCommonState *s, void *regs)
     kvm_apic_set_reg(regs, 0x38, s->initial_count);
     kvm_apic_set_reg(regs, 0x3e, s->divide_conf);
 
+    if (kvm_has_extapic()) {
+        kvm_apic_set_reg(regs, 0x40, s->efeat);
+        kvm_apic_set_reg(regs, 0x41, s->ectrl);
+        for (i = 0; i < s->nr_extlvt; i++) {
+            kvm_apic_set_reg(regs, 0x50 + i, s->extlvt[i]);
+        }
+    }
 }
 
 void kvm_get_apic_state(APICCommonState *s, void *kapic)
@@ -91,6 +102,15 @@ void kvm_get_apic_state(APICCommonState *s, void *kapic)
     v = (s->divide_conf & 3) | ((s->divide_conf >> 1) & 4);
     s->count_shift = (v + 1) & 7;
 
+    if (kvm_has_extapic()) {
+        s->efeat = kvm_apic_get_reg(kapic, 0x40);
+        s->ectrl = kvm_apic_get_reg(kapic, 0x41);
+
+       for (i = 0; i < s->nr_extlvt; i++) {
+            s->extlvt[i] = kvm_apic_get_reg(kapic, 0x50 + i);
+        }
+    }
+
     s->initial_count_load_time = qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL);
     apic_next_timer(s, s->initial_count_load_time);
 }
@@ -156,6 +176,27 @@ void kvm_uninitialize_extlvt(X86CPU *cpu)
     }
 }
 
+static void kvm_apic_put2(CPUState *cs, run_on_cpu_data data)
+{
+    APICCommonState *s = data.host_ptr;
+    struct kvm_lapic_state2 kapic2;
+    int ret;
+
+    if (is_tdx_vm()) {
+        return;
+    }
+
+    kvm_put_apicbase(s->cpu, s->apicbase);
+    kvm_put_apic_state(s, &kapic2);
+
+    ret = kvm_vcpu_ioctl(CPU(s->cpu), KVM_SET_LAPIC2, &kapic2);
+    if (ret < 0) {
+        fprintf(stderr, "KVM_SET_LAPIC2 failed EXT: %s\n",
+               strerror(-ret));
+        abort();
+    }
+}
+
 static void kvm_apic_put(CPUState *cs, run_on_cpu_data data)
 {
     APICCommonState *s = data.host_ptr;
@@ -178,7 +219,11 @@ static void kvm_apic_put(CPUState *cs, run_on_cpu_data data)
 
 static void kvm_apic_post_load(APICCommonState *s)
 {
-    run_on_cpu(CPU(s->cpu), kvm_apic_put, RUN_ON_CPU_HOST_PTR(s));
+    if (kvm_has_lapic2()) {
+        run_on_cpu(CPU(s->cpu), kvm_apic_put2, RUN_ON_CPU_HOST_PTR(s));
+    } else {
+        run_on_cpu(CPU(s->cpu), kvm_apic_put, RUN_ON_CPU_HOST_PTR(s));
+    }
 }
 
 static void do_inject_external_nmi(CPUState *cpu, run_on_cpu_data data)
@@ -247,7 +292,11 @@ static void kvm_apic_reset(APICCommonState *s)
     /* Not used by KVM, which uses the CPU mp_state instead.  */
     s->wait_for_sipi = 0;
 
-    run_on_cpu(CPU(s->cpu), kvm_apic_put, RUN_ON_CPU_HOST_PTR(s));
+    if (kvm_has_lapic2()) {
+        run_on_cpu(CPU(s->cpu), kvm_apic_put2, RUN_ON_CPU_HOST_PTR(s));
+    } else {
+        run_on_cpu(CPU(s->cpu), kvm_apic_put, RUN_ON_CPU_HOST_PTR(s));
+    }
 }
 
 static void kvm_apic_realize(DeviceState *dev, Error **errp)
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index c9f4cb6430..ad7a4c3c5c 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5069,6 +5069,28 @@ static int kvm_get_mp_state(X86CPU *cpu)
     return 0;
 }
 
+static int kvm_get_apic2(X86CPU *cpu)
+{
+    APICCommonState *apic;
+    struct kvm_lapic_state2 kapic2;
+    int ret;
+
+    apic = APIC_COMMON(cpu->apic_state);
+
+    if (!apic || !kvm_irqchip_in_kernel()) {
+        return 0;
+    }
+
+    ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_LAPIC2, &kapic2);
+
+    if (ret < 0) {
+        return ret;
+    }
+
+    kvm_get_apic_state(apic, &kapic2);
+    return 0;
+}
+
 static int kvm_get_apic(X86CPU *cpu)
 {
     APICCommonState *apic;
@@ -5476,7 +5498,7 @@ int kvm_arch_get_registers(CPUState *cs, Error **errp)
         error_setg_errno(errp, -ret, "Failed to get MSRs");
         goto out;
     }
-    ret = kvm_get_apic(cpu);
+    ret = has_lapic2 ? kvm_get_apic2(cpu) : kvm_get_apic(cpu);
     if (ret < 0) {
         error_setg_errno(errp, -ret, "Failed to get APIC");
         goto out;
-- 
2.43.0


