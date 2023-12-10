Return-Path: <kvm+bounces-3998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E742580B9CF
	for <lists+kvm@lfdr.de>; Sun, 10 Dec 2023 09:15:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4996B280D97
	for <lists+kvm@lfdr.de>; Sun, 10 Dec 2023 08:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C2026FAE;
	Sun, 10 Dec 2023 08:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="QHGF6j0P"
X-Original-To: kvm@vger.kernel.org
Received: from AUS01-SY4-obe.outbound.protection.outlook.com (mail-sy4aus01olkn2156.outbound.protection.outlook.com [40.92.62.156])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F8AC6;
	Sun, 10 Dec 2023 00:15:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=REW2+iW1lTE75brGn8JouBVk/ZYBBezUKtXsXdoXh7HHSl7bbOMfSps7F61q+LPk/sA8xzWjYMykBJn9g9wzXwJ1r0U+YUzq5hcZvdexSeNOKH1o0GeTwLCFOCv1JakuIqvWlYyiHPYp6ujvHVUFT/PQYUDZXoe2ee8xqVkLOS2cxef3raMt3Pl4mnRa2fHK10l1qQbejFrL07vb2e+I1Lf6xtJGNK0xMdGdtRpzrLiqY6Hqly4PG4GayNdDchwTH3vDcw9h5EZcn47muq2WGaJ6RldbE8qCHxtkLzLH4i5xLba+nLhg+AZxkpbUT4T63WcejrDxKpJno2CJnQVNzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pxF+R4s6Cw2cH1iWqjVrs90ajnNFMMq5vaqUa7oXs9o=;
 b=UyiEV0Kbb3VTdQCVKXufdYwaGT2C6WjSVey/l4LsceGpsUTT2H9xTd9qDFZP49OIW/Pp4zI7Lu3bksS6wzkNBRgWGS3TkkMSd6LKCYceWYhypwJSH6qOf1nCn+g2bjmi1PGo/Yd0+4h2ZbLiEyOrSegVRKhwOnNjya0gT1zvsZxIFKy3vEuyWIYWvDVQvESP9cbPMUGhuIyHEclXrMbM+odId313zym2HWHpblqN+GAptfjPd2qkFblNEaUoy9XcWCyfBMiTBATWjOZYr/wC+Ysbjsy+mHgiH/64LBcNY+LuI4BHKqS+xQYqnnNmMiIR9LKLciimQ0oz0L4yUp021g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pxF+R4s6Cw2cH1iWqjVrs90ajnNFMMq5vaqUa7oXs9o=;
 b=QHGF6j0PJzjvlRgm0+Ia6OdgsHGKpmuB9GAfHxO6C2wXpeEQ7ZdNkJHybBkYPPSDtu9J8Uw7EAepOuJ+RbXAaeHWQPMB+KocJbszJ9EIPgVVoNZHOtxGNEBurpPhQNUXw2Uvi3EWM/muru1e2X3jh5vlkkY8xQB0zaV9LKFQeF5ujFzNsdPFZ/MuylNZJZpmo6QF/BJe9Gct0XsrxBqm2EcGUyjCg1Gxf5g/7njttglVq3isTl7vU19VsbjflSz8l2MbWJInIc8FRSHuq9ZvyAx1EPXgMZyoYhAY/pRHhIK8LsDPx9XB2PGlGQZ8prBgru1owTe6rAFHkaCCxXKo2g==
Received: from SYBPR01MB6870.ausprd01.prod.outlook.com (2603:10c6:10:13d::10)
 by MEYPR01MB7339.ausprd01.prod.outlook.com (2603:10c6:220:15f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.31; Sun, 10 Dec
 2023 08:15:12 +0000
Received: from SYBPR01MB6870.ausprd01.prod.outlook.com
 ([fe80::be5a:160f:5418:9deb]) by SYBPR01MB6870.ausprd01.prod.outlook.com
 ([fe80::be5a:160f:5418:9deb%5]) with mapi id 15.20.7068.030; Sun, 10 Dec 2023
 08:15:12 +0000
From: Tianyi Liu <i.pear@outlook.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	mark.rutland@arm.com,
	mlevitsk@redhat.com,
	maz@kernel.org,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	namhyung@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	Tianyi Liu <i.pear@outlook.com>
Subject: [PATCH v3 2/5] perf kvm: Introduce guest interfaces for sampling callchains
Date: Sun, 10 Dec 2023 16:14:52 +0800
Message-ID:
 <SYBPR01MB68706FAC3D66758BB4951F5D9D88A@SYBPR01MB6870.ausprd01.prod.outlook.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <SYBPR01MB687069BFC9744585B4EEF8C49D88A@SYBPR01MB6870.ausprd01.prod.outlook.com>
References: <SYBPR01MB687069BFC9744585B4EEF8C49D88A@SYBPR01MB6870.ausprd01.prod.outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [tNQOTVHnuDQwQkpUy9i9+/3gTNGARQA5x7xlGvNEgKG54CKGU5CETA==]
X-ClientProxiedBy: SG2PR03CA0107.apcprd03.prod.outlook.com
 (2603:1096:4:7c::35) To SYBPR01MB6870.ausprd01.prod.outlook.com
 (2603:10c6:10:13d::10)
X-Microsoft-Original-Message-ID: <20231210081452.2312-1-i.pear@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYBPR01MB6870:EE_|MEYPR01MB7339:EE_
X-MS-Office365-Filtering-Correlation-Id: 80c8c0ea-93a6-4a93-9b4c-08dbf95821c3
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	V2lVPkeEVw0TXhPSNndJFgrUfQfWQhe97/3dWJAom8I8E5xwvpRVo0D4oa1wpDtNYLTXvE6LrN2JpZ2K04UUo7cnjLbfZwnhbVv6n4sknlJ9kA2KeT77ZtZaPxjdCYBoQodjqkrR9Y+TSvYe1bHNeA0r9eJSB/u37ZR3RkI/kowuinjWLGm0MjPJ8lMEdb2KvXMW0WPoP5t4WTAYXxWymURvuPa7LDqE3HEu+hXJkNjN5MC/lTVatkDAkooWfuKh2nRsOw/x/LgeTcTyziGKAi18iUuJYOTjMD0KJrwjKcEueimehowQa0z/9k/gMLNZQHqwGT81EoiQMp6KOUZ7IL/RGAmOHaTw5661VM0vRVXxnzp+3b83x8Uy+/DAzzqHvN04TBz3IommzV28DPS655xsfLSxVuW4cMSCdVPBrXDguphsryjDtk/bWYYyJ9Xv5/1QeVjfsq7ietbowNTrsedf0L4i0wuNQ9U/p26wEYlRIxPdNLOaipDsjA9lURH/0nk5hBkPlRiSVfWtgUe1zhwb/17w50KXw0C2wT4cy9ZNJo3wW3TaUNAGGFRJOkMzy2rnutKrxp/24re6daIDsimlqWeFWzwrB6Jcs9v8jMYE+QlS9qhlhBv8zKEP46+G
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9lgUD9GI56U0BB6wy6svR5OakY3jPajmR4UGCWi1PKSBK1khbQ/vfOXE6y8F?=
 =?us-ascii?Q?0St8D0nd1G8SvBPo/g+H6YgVeye6pW80B+lqimWMFq9vyGlMht+qHyia7a7Q?=
 =?us-ascii?Q?CFgEKraosAZBAj2giVCURb9TvFA52CRBeoGxbfCr0OthD3i3i66lWJ49lGf+?=
 =?us-ascii?Q?30GZREkGwW9xRl+Dw0Rr5GVIykKE7bP7ElQoffGEZT3OC4S7xuU94AocAyyN?=
 =?us-ascii?Q?1HFYaCqoup7WbqoeMxepIQGZqXgpA/VBWdbw3xPvUWeNA9BsopXiRTc2yupo?=
 =?us-ascii?Q?rXYvF0o/ULDA2ZhDFEPzyC2SzUw/ou2zyJ1Uhs7NdjnkYf5BT6p3OFkmI6FC?=
 =?us-ascii?Q?sP7r9Kn2hlp1NRBO1+7nWWaYirkeVcEHMHDs09/uuGj2FMzbpSO1OMhNMIie?=
 =?us-ascii?Q?crP4hEBlNRNMs8ZsTa54L8a/iS/N8R0KWYCTpw+G38kBWQkbof4xLKinuZTL?=
 =?us-ascii?Q?14SrisfoB+HBc03PteZd/t3J4EeFoictaZWFruZCeNorXZIqNyP1947AJoaB?=
 =?us-ascii?Q?zWf4pxnX+U9JB/94eWiL2abht+521Us736h3Z+qjPU9c8+5c80JGBIP6HWfq?=
 =?us-ascii?Q?zfi8D0YX0Nqk3RP3pQ8ttPsSbAZh3OA1eGr5ESc0nRzxnHJzcOSMrGAVrmIO?=
 =?us-ascii?Q?8sLX5OMjJSPQBt1FjJlq/wKV4EnrcwKG0Wxvnn0SgCUi5cE20SZsX1rM37+m?=
 =?us-ascii?Q?wjSb/5xdKdg6ERsj/8pFuiw4K71LoEdO2hqQdGnf5qaAd382uEODi58wf1WL?=
 =?us-ascii?Q?g7V2NSh6+wyVi4LcOASjJcf0288FMcyBXaMFcNA/W5JKzII5N/AoKEYRBPwj?=
 =?us-ascii?Q?PPOLKmSgegMK7kh7ovY6pgsiWhfn1NgDtE9DAXVGik80PMFh9F2tIipQKvbF?=
 =?us-ascii?Q?F/X/9EH8UW/ZFG+HoRMqzxfXPY6/WWOU2OK3XijDsCKk66rwvgKG7fG+mvuT?=
 =?us-ascii?Q?zfRt2DMtOW/GaRBcKgcUu8PPZkrLQyQCuylgY9XSKGAqxeqR9xXmd0BJfvM8?=
 =?us-ascii?Q?OJcxXJs9mMXHbpxG1PalBZ3TLyj8SJuzkRb9pq5HTqfl9tR1FWMCCSP1Hdtx?=
 =?us-ascii?Q?mUopb1rkpleE73Lfe73zR3qK9498hNRrfSIUe5P0iYwc+6tBjLbSeexDpwYM?=
 =?us-ascii?Q?9SBAmiVhzvj10A2SG39KZfzZOLTniVhDnIxvp0tnFkk37u+JH/MuxbTjtgHQ?=
 =?us-ascii?Q?3gn/5Td8l7a0biU7WfMkt+6qvBUjPgsIDAS7mePxp5Fl6WPUoRqE0k4MT/NG?=
 =?us-ascii?Q?x7MPDY6+utJlbrK0sqrq?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80c8c0ea-93a6-4a93-9b4c-08dbf95821c3
X-MS-Exchange-CrossTenant-AuthSource: SYBPR01MB6870.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2023 08:15:12.4656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MEYPR01MB7339

This patch introduces two callback interfaces used between perf and KVM:

- get_unwind_info: Return required data for unwinding at once; including
  ip address, frame pointer, whether the guest vCPU is running in 32 or 64
  bits, and possibly the base addresses of the segments.

- read_virt: Read data from a virtual address of the guest vm, used for
  reading the stack frames from the guest.

Signed-off-by: Tianyi Liu <i.pear@outlook.com>
---
 include/linux/perf_event.h | 17 +++++++++++++++++
 kernel/events/core.c       | 10 ++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 5547ba68e6e4..dacc1623dcaa 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -17,6 +17,8 @@
 #include <uapi/linux/perf_event.h>
 #include <uapi/linux/bpf_perf_event.h>
 
+#include <linux/perf_kvm.h>
+
 /*
  * Kernel-internal data types and definitions:
  */
@@ -32,6 +34,9 @@
 struct perf_guest_info_callbacks {
 	unsigned int			(*state)(void);
 	unsigned long			(*get_ip)(void);
+	bool				(*get_unwind_info)(struct perf_kvm_guest_unwind_info *info);
+	bool				(*read_virt)(unsigned long addr, void *dest,
+						     unsigned int len);
 	unsigned int			(*handle_intel_pt_intr)(void);
 };
 
@@ -1500,6 +1505,8 @@ extern struct perf_guest_info_callbacks __rcu *perf_guest_cbs;
 
 DECLARE_STATIC_CALL(__perf_guest_state, *perf_guest_cbs->state);
 DECLARE_STATIC_CALL(__perf_guest_get_ip, *perf_guest_cbs->get_ip);
+DECLARE_STATIC_CALL(__perf_guest_get_unwind_info, *perf_guest_cbs->get_unwind_info);
+DECLARE_STATIC_CALL(__perf_guest_read_virt, *perf_guest_cbs->read_virt);
 DECLARE_STATIC_CALL(__perf_guest_handle_intel_pt_intr, *perf_guest_cbs->handle_intel_pt_intr);
 
 static inline unsigned int perf_guest_state(void)
@@ -1510,6 +1517,14 @@ static inline unsigned long perf_guest_get_ip(void)
 {
 	return static_call(__perf_guest_get_ip)();
 }
+static inline bool perf_guest_get_unwind_info(struct perf_kvm_guest_unwind_info *info)
+{
+	return static_call(__perf_guest_get_unwind_info)(info);
+}
+static inline bool perf_guest_read_virt(unsigned long addr, void *dest, unsigned int length)
+{
+	return static_call(__perf_guest_read_virt)(addr, dest, length);
+}
 static inline unsigned int perf_guest_handle_intel_pt_intr(void)
 {
 	return static_call(__perf_guest_handle_intel_pt_intr)();
@@ -1519,6 +1534,8 @@ extern void perf_unregister_guest_info_callbacks(struct perf_guest_info_callback
 #else
 static inline unsigned int perf_guest_state(void)		 { return 0; }
 static inline unsigned long perf_guest_get_ip(void)		 { return 0; }
+static inline bool perf_guest_get_unwind_info(struct perf_kvm_guest_unwind_info *) { return 0; }
+static inline bool perf_guest_read_virt(unsigned long, void*, unsigned int)	   { return 0; }
 static inline unsigned int perf_guest_handle_intel_pt_intr(void) { return 0; }
 #endif /* CONFIG_GUEST_PERF_EVENTS */
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index b704d83a28b2..4c5e35006217 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6807,6 +6807,8 @@ struct perf_guest_info_callbacks __rcu *perf_guest_cbs;
 
 DEFINE_STATIC_CALL_RET0(__perf_guest_state, *perf_guest_cbs->state);
 DEFINE_STATIC_CALL_RET0(__perf_guest_get_ip, *perf_guest_cbs->get_ip);
+DEFINE_STATIC_CALL_RET0(__perf_guest_get_unwind_info, *perf_guest_cbs->get_unwind_info);
+DEFINE_STATIC_CALL_RET0(__perf_guest_read_virt, *perf_guest_cbs->read_virt);
 DEFINE_STATIC_CALL_RET0(__perf_guest_handle_intel_pt_intr, *perf_guest_cbs->handle_intel_pt_intr);
 
 void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
@@ -6818,6 +6820,12 @@ void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 	static_call_update(__perf_guest_state, cbs->state);
 	static_call_update(__perf_guest_get_ip, cbs->get_ip);
 
+	if (cbs->get_unwind_info)
+		static_call_update(__perf_guest_get_unwind_info, cbs->get_unwind_info);
+
+	if (cbs->read_virt)
+		static_call_update(__perf_guest_read_virt, cbs->read_virt);
+
 	/* Implementing ->handle_intel_pt_intr is optional. */
 	if (cbs->handle_intel_pt_intr)
 		static_call_update(__perf_guest_handle_intel_pt_intr,
@@ -6833,6 +6841,8 @@ void perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 	rcu_assign_pointer(perf_guest_cbs, NULL);
 	static_call_update(__perf_guest_state, (void *)&__static_call_return0);
 	static_call_update(__perf_guest_get_ip, (void *)&__static_call_return0);
+	static_call_update(__perf_guest_get_unwind_info, (void *)&__static_call_return0);
+	static_call_update(__perf_guest_read_virt, (void *)&__static_call_return0);
 	static_call_update(__perf_guest_handle_intel_pt_intr,
 			   (void *)&__static_call_return0);
 	synchronize_rcu();
-- 
2.34.1


