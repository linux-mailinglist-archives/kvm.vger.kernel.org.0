Return-Path: <kvm+bounces-71332-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ACOLFUijlmk7iQIAu9opvQ
	(envelope-from <kvm+bounces-71332-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 06:44:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AD7A415C2AF
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 06:44:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2CCD73050A07
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:43:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9A8B2C11C6;
	Thu, 19 Feb 2026 05:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QQu0tEYR"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010042.outbound.protection.outlook.com [52.101.46.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA6D29BDB1
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 05:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771479831; cv=fail; b=po3VeLjOVpZ7njM4bGeICdJ+dV8VDE4nY9/MGv26/c06/7tA5ugeYUAy9OI5DO6+dz3b7a7MwHsNJQdA0U9JQc7NilY9JBxpiR5uJCoj6veOg9xyEEIiqDENX6c+beHxUmq9Wf0F5ZdNkLnx/j3JvNZyvLgvhn/PG+tczloeis4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771479831; c=relaxed/simple;
	bh=pGSnAz2g6WBjxJjiJeaL8ZjN90o2e580GaHA0YX4EYQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X6F0vmxjsJvCjeBkncwJwrxtOnrpIU0feB6T0g3puDsmD6Y1BASFCf8fvlnKwnOtXscHa2SC6DfDCnhy6/OgPitH4BHo11fa1SeOdPLGhyLfT8XU29jfDCjnCIZIsK9slI0H/WwOaXKur2ctyD09Rk4wKX/UAPCgtbwVdly7Lzg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QQu0tEYR; arc=fail smtp.client-ip=52.101.46.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bguMqKQsAQA7hxaK8EfK4XWy1/ZwNDVNZ4DQvlXihunRnCOBr3tw0f3Dj+36Ozy6ZaRDpDfcw8XWnbgjeRS/hHP19ijTJVkhmXOsNx9R8fWX/1GO3gs5knz+XfvQwPittW4ObOeJgLntJj49yOK2ihfffZ4fL8wMwFiEa71jhRg9DqEnjAHA8qdRGL9PvKOlECj3udSsKDR8NP4X3LMjqv0QaT63Wl9w49MhHETKKrHtP7AEocWUOXCBeh+vJBN+3Bx9ADpU3N3EDzNaSBjejaXTsLp6y5OnIjIWWIiTmIdAqZW6yCCH2ICQ0alJaFvS5VCpEA7B4SIlEX2WdwbVyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DZEm9e4GVICj+l9f6e0apbmSyYBEM2DqI43+jVavfsA=;
 b=eQwrwkNjsOQeDLcXYoj7fmfnwXidDumb/eZe5GcUWbfjOxxgpPvKq0a1W3vHwUC53pKAyDC1xBWGl34FjUx4JOPWa4BwZ5dAm15Z1hlYzqhX+cK13mSL3iUKvAbecg95YclP55DbEuHM3rJ/Bs/we56z6ZeCpyNsnB7paoSySJ004ung7sJoETNQGDXaXh3EXIWXttLEnVw2Wqb307M9lGV9z2EECer9flz7gQtkNuzg148Rlg6LfhXKA0d9lRsC6h4HPLTlR9QZRnOxmAht8yu7imKNEvwj0dUX9Q3P2scVR1QP33CsTonjtZF4fZyB1fjN6jtD7IVaju0iEuNCCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZEm9e4GVICj+l9f6e0apbmSyYBEM2DqI43+jVavfsA=;
 b=QQu0tEYRt/YzUmEiOcXRpmiZtWksSSmLWsnPMOLV9OSHpSKrTTpbNL7rB00bd+ZI+ByO5NtIqw7iqLJutRn3+HtIam7aceFXtniFQbF6eeYwKQZA4EtGTxiAsoKC7LJ9jMj9Ud8WaTXPGtNz63O2rfvm7d0hKvYVg3vZ12OawfM=
Received: from SJ0PR13CA0110.namprd13.prod.outlook.com (2603:10b6:a03:2c5::25)
 by MN2PR12MB4488.namprd12.prod.outlook.com (2603:10b6:208:24e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.15; Thu, 19 Feb
 2026 05:43:45 +0000
Received: from SJ1PEPF00001CDF.namprd05.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::3d) by SJ0PR13CA0110.outlook.office365.com
 (2603:10b6:a03:2c5::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.15 via Frontend Transport; Thu,
 19 Feb 2026 05:43:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CDF.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Thu, 19 Feb 2026 05:43:44 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 18 Feb
 2026 23:43:40 -0600
From: Manali Shukla <manali.shukla@amd.com>
To: <qemu-devel@nongnu.org>
CC: Cornelia Huck <cohuck@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
	<kvm@vger.kernel.org>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Marcelo Tosatti" <mtosatti@redhat.com>, "Michael S . Tsirkin"
	<mst@redhat.com>, "Paolo Bonzini" <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Richard Henderson <richard.henderson@linaro.org>, Naveen
 N Rao <naveen@kernel.org>, Nikunj Dadhaniya <nikunj@amd.com>,
	<manali.shukla@amd.com>
Subject: [PATCH v1 7/8] apic_common: migrate extended APIC fields
Date: Thu, 19 Feb 2026 05:42:06 +0000
Message-ID: <20260219054207.471303-8-manali.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDF:EE_|MN2PR12MB4488:EE_
X-MS-Office365-Filtering-Correlation-Id: 69dbbe61-126f-4998-f487-08de6f79d8b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CSP0l17PDwrvzqtw/cthxz4nYwtZrdehNyPjiQIEpnPWOD1Blht+FRCLM/8i?=
 =?us-ascii?Q?WXGncdPSREhp2YNxY/0LdrRM4yKPgAtrw6gpW5j03PQXKwt960+rE0PidHdj?=
 =?us-ascii?Q?FCaLDiFjSO/fnt4Qn5GeJ1GnsisdE/pgktPUql1oMw+E+XZYs1i9t8pjapdz?=
 =?us-ascii?Q?SXAubz5tT8L2jXTiLNdQgNoAg9C2Ro+p//7dOPF6bN6oFV76ZLK199Un37N5?=
 =?us-ascii?Q?z8iSOaacXQL8qZKlHLDzi2vl5hwwDD+MANI8B/0Qj+RUIBjrgRo7dQi4QVR7?=
 =?us-ascii?Q?iM6kygQlevLnMqUKbtSMyHzT3olIKzgaXffwBpyHqIBBfOLV2lCUxBKVM05q?=
 =?us-ascii?Q?AiWVI4Avjcc+V/XGAYZOOxk+pP09opZIF6r0EPMcDEhSlb55Rv0TUpA83bWO?=
 =?us-ascii?Q?AazvC/u3R/LCcHRK45YPSzAqIrj/4MWYazsEfjUkfruMFbl/9+MLOxXhk3NX?=
 =?us-ascii?Q?tDqxBgqmK2duS+eJEfjqfwh62p4KvJYiL9vFtDIwlAIPd/odan2AnIPxAoXt?=
 =?us-ascii?Q?bMbh6ZrGovZpeFfn63978vWMjS8mhExosyVzfUD+hbe0zN8ej+iumN9OhPqG?=
 =?us-ascii?Q?+ZUQZxS8Ji90ga642l6yYkgkb8bTgDzmZW+lKNBnB7BcVbBLDsHUiGxpoIqL?=
 =?us-ascii?Q?HuPHmZfX+6HhCcvnCEd7E5a2myXy4LW12Nb7842NgMPFzvfDkwbFkCpwuZnS?=
 =?us-ascii?Q?jVZ2a4wPrll+KMFCbY7hC+jjXFWUzJTEVvjgQE4emTHRIvmmWmYa875hAB8H?=
 =?us-ascii?Q?XvUeJXywCP8qYZhcispW4gbEeCRfLlL3eGdzoqO2kbJBNj6+1LCEOYUreqKI?=
 =?us-ascii?Q?k+6rKowBN03jWcB4jvH4YwWiZ2wEi+rcHSUQq/tzdDDSjHA5QuyBFZPTKIni?=
 =?us-ascii?Q?Gge6JqCkc78rTH6N8QkfQhKdWffiHpuDjshPIYW82dAFBt4Bll1+4DpPGjET?=
 =?us-ascii?Q?92/UV+ChP1iJm0HDQIjiqQuQperS/T+2FBFEWHGmrK0JdFhUF1WOU9Wfm0PU?=
 =?us-ascii?Q?/C5ohKcLtENM8UFNPHNhrkMEKi8SGP+xqRbfdD5sbh+XXJvNmFMfQ9xa1qEx?=
 =?us-ascii?Q?dIF/SGEKGjOvQxeInIr8mxkCWVxRdl/GuyrPp9l399I6/KRt6egxG3NPNbMs?=
 =?us-ascii?Q?LeCmL+J/0tAylclNuYB6nCBAcEQu7hS+GVMRTLK6s4ekjpYUJAj6XS5875zz?=
 =?us-ascii?Q?RKd8kJiL/xCv0+Z+kk6yi1R0DWE6S+hL8PTBCSZWnHCEn+GUnM0K84oJ4VIZ?=
 =?us-ascii?Q?dls3FoCXJ7RiiISr09X8NVCTIAmsBBsorPX/c3f+LvKVcDbq08PjJd7oK07D?=
 =?us-ascii?Q?yZtepPHXhaGrdXFoSZriFtJHM71MLgDByBDjydskQkHsfoPu4vhwIpKYjxiJ?=
 =?us-ascii?Q?0ekSXO3htpshskKYXAa6bxh99HVIWX/8egXyrka8Q4Ja+Dn1b8W8ranXjqzg?=
 =?us-ascii?Q?Jd3BC39neQFDlDw2XaIh5OeT9Lgm/0BvaMdJdVzuVY3Z7/fr60jskL1YHNFc?=
 =?us-ascii?Q?AjxkUKOoKycSBhISH9UYlgQq7hZlxbOQKor4n0sgeeXSIE/Lpr4hF9Z3BNuK?=
 =?us-ascii?Q?Axn8pw2zhUP5IKzEC6v4TePYu9iWu8SPdjfys9lpok7q1jORA1cna6y2Ii/D?=
 =?us-ascii?Q?8DwhQWeTh/8mgJJqaz6ibTLj4aM/kdL7fsglFFj42MYjbD+IGBD2q3gQ34XL?=
 =?us-ascii?Q?0yk6yQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NT5FiaZb/C328VzNmvz74ZP+Tt2tEJw4uIiquLwDRZFCsBgsZfpbzlV57f512DER92Xhy1NkW4LszGtywXWSOcYkDhxBt52+jRMLDx/I7o/GKxHiPcRc9xnM6oujyWx+JwVc/4hCt4ieSJC+KgU3YA59qozsfxNeDGobW+J6xl/J9689TjgB4ReLjdgYwnTHxgfNMRAXQdf+TiZfl0FMlhLHwYHZw2kD3EVuSZUkcaiJGLZ8hYEPvgMG81pIVWz4fj8P/HhzhOIMTMLBEwMKIs5IJ2Ih0YCEuBpFjW6G08SFqkEp9rD8N/1iD+QCxdX9JAXjmnV+c6196yF3d5EuDhu9v4elogvFiYEE9ma/H9hucP4UNIejO9vLGLFxd/drgx8CnTMUJ+Cgpu786aKdS3urHeuUgv7a99WQZJujAVhJ7ExDC62zh9vmHjj+yZij
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2026 05:43:44.9397
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 69dbbe61-126f-4998-f487-08de6f79d8b4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4488
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,habkost.net,vger.kernel.org,gmail.com,google.com,linaro.org,kernel.org,amd.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71332-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: AD7A415C2AF
X-Rspamd-Action: no action

This patch adds extended APIC fields like efeat, ectrl, variable sized
array extlvt to a new subsection of the vmstate of the apic_common
module. Saving and loading of these fields makes migration of the apic
state deterministic when extapic is enabled.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 hw/intc/apic_common.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/hw/intc/apic_common.c b/hw/intc/apic_common.c
index 37a7a7019d..cd4b480c8e 100644
--- a/hw/intc/apic_common.c
+++ b/hw/intc/apic_common.c
@@ -360,6 +360,12 @@ static bool apic_common_sipi_needed(void *opaque)
     return s->wait_for_sipi != 0;
 }
 
+static bool apic_extended_needed(void *opaque)
+{
+    APICCommonState *s = opaque;
+    return s->nr_extlvt > 0;
+}
+
 static const VMStateDescription vmstate_apic_common_sipi = {
     .name = "apic_sipi",
     .version_id = 1,
@@ -372,6 +378,20 @@ static const VMStateDescription vmstate_apic_common_sipi = {
     }
 };
 
+static const VMStateDescription vmstate_apic_extended = {
+    .name = "apic_extended",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = apic_extended_needed,
+    .fields = (const VMStateField[]) {
+        VMSTATE_UINT32(efeat, APICCommonState),
+        VMSTATE_UINT32(ectrl, APICCommonState),
+        VMSTATE_VARRAY_UINT32(extlvt, APICCommonState, nr_extlvt, 0,
+                             vmstate_info_uint32, uint32_t),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 static const VMStateDescription vmstate_apic_common = {
     .name = "apic",
     .version_id = 3,
@@ -404,6 +424,7 @@ static const VMStateDescription vmstate_apic_common = {
     },
     .subsections = (const VMStateDescription * const []) {
         &vmstate_apic_common_sipi,
+        &vmstate_apic_extended,
         NULL
     }
 };
-- 
2.43.0


