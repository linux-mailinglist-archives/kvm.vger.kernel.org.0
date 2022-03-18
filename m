Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E24E4DDFD5
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 18:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239615AbiCRR3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 13:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238339AbiCRR3C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 13:29:02 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2071.outbound.protection.outlook.com [40.107.236.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00BE1D7624
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 10:27:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lLwl5KQHlhT4oxCUgp3vF0DRuWocQh2b7syvED9p82LP8E581XoGDkxzIL3O0ShYXuP+uJrOJEjqCoLA2KEINBQRTskrdI4WWmFK2h5hBrXp9TfznuYoN1xQITaRfw9NZ9CZ3AoYFHFtTQnbYXw8OjSr1Gm1Izjx3A9zd8raqihjf5NmsfrtI+egbHkp8mU0fqkOo3wHkRhIJOWc0TYz9qDVG8GHxVKjzVBtNijR2ShSdyjDdiyQe81GdDQTOlxzyUaqCjbfL78UdxpNzM+vE+taCpK9EwOpQVVN/JZfA+yGfR83kyZ3bESTOv9DmsDI641JncSz/AXQcvFvNUI9qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ff1jcLN8eoo0cLGkkAO+7f9D1d4vu5pPmFhklu2yBg=;
 b=ELmuGyZZ4owTQEPPPHkm7yk9mLbc+3f7rorv7TeJznIYmFxRP8z6eHkDzvFTxrW6ExnddYNgbcb2F/1QVkCy5tudDsoMkJVrLw1AI814gIbZlA15Xn2BechVlKdBSwigVWRcZR2gmc/5aBFBBCw4pY0SSjBYHK/Hpu5JkqqI20BgZwqw9n8/WWwQz+k2TiFradzhkLa8EmlvZ4eldqd9mExToB1ym9450DeQZzLF4XaytO8R2vOZZMDzreLpysIHxXT3om+U5PuLMHzt3jGGcwjtFaDmtIiwkFzXM/A4ZifoFxHJXBIqLT0LPcJ6HSlplFYhuhyZOiaeduJcjRYo4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ff1jcLN8eoo0cLGkkAO+7f9D1d4vu5pPmFhklu2yBg=;
 b=RmejLTKk61Q3TqNb2nc35Vf+xgRFeq1JBNZDXT77O6zSiVpdPKwXZ29SvmOpAXSbFREas8/PXtM/shC59IB4x1SV3DF/IEUGz8RVQm9EqAfrqVCSTuc6CwXcwFcwH7bu27vfkGUsxEhEWwYKcX/Bxl4VB7gK3YtMxsXOgjgC71c3SVbCk1a3/bhlFmJBUje9dW+J7x0bdqDjIBDb7i7vOU94KS4aMvlxKMiJVGN9wsde5hWmhZsrRj75t3VcFcVyLA6FCXs3fgNQKwmU+OCj4gQ7WsOGDhAlQ71Wa2RHnkI5YTOWn3VYVexhTLQ0KmPxusdma5eb2AOojZZKnEZS/A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3630.namprd12.prod.outlook.com (2603:10b6:208:cc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Fri, 18 Mar
 2022 17:27:39 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%5]) with mapi id 15.20.5081.018; Fri, 18 Mar 2022
 17:27:39 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH RFC 01/12] interval-tree: Add a utility to iterate over spans in an interval tree
Date:   Fri, 18 Mar 2022 14:27:26 -0300
Message-Id: <1-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0020.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::33) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e5850a0-9132-4058-0e71-08da0904999a
X-MS-TrafficTypeDiagnostic: MN2PR12MB3630:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB36300D490DAC164A8D4702DAC2139@MN2PR12MB3630.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZlhYNXXqJcp5v0+IE+f6TACfLw5or5LfYW0h5u8Ul1qcj0uGxVv2UTqC47/72lwYv1rvrHg3+NzuqN8lGLvvzZghS4Ah9VIPMWGkzInAUKV6kD6jQf0E22zn+A69KLyBXOUXqZBO8CjBv6TLy3ZqxugYg1l55a53a7SvL3BzFLGAQvYnvP+YbtqX4H2kvfM3B6uAy6JXDqHYVOeCDaWeRAapOba91P0IIyIfploIVon0f6JJGvPBEiAi6Z2jQ+ZCkg5K7U9AdcsAcUqgM/cOk9SUpQEfx/7FPezKzUb8vTC9GcIfnq6lwwwVYCTmgfk+Sbk7a/LLNYnSb8zQpsPOPpW06CUUyEIlI35BkcI86AsJvrFeUE27UlVyRlUCpiw+rIXg3eyTDwxorNIGHasdtQwoKT8Zc8ulv6lNEurwkBMSwoevV/sRXK8NTfZFUq+RV8/5WgXUhFjK4D+C2sDl9o4xaA3fIA2cq4HZclAXeQuf7ZVws1Qlrn+1hENaxZVmwmmiZ2znH8TKI1jvyNb6tvePHyrJYk1lk56KNh5cOVRDjO2C/ZTq7L54qDYkbXqO3qIcwzdDFDJy6kRn148/frECsCWTi3QGnrkHH+VlqcwrNc3r3G5+oP5kupy0zQuXqXtzApGTh9FZD2c5I6eWzQF3S4s8YRVwQnA+Gy7bz+Hf0DkeWQGik/jh2vUR+jH7UpXqX/voUnOi6PVSY6o73w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(508600001)(186003)(6666004)(8676002)(4326008)(8936002)(6486002)(83380400001)(7416002)(66946007)(5660300002)(66476007)(66556008)(6512007)(109986005)(54906003)(2906002)(316002)(38100700002)(6506007)(2616005)(36756003)(86362001)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qIA4mMqPP30tbSWtlBzHe8M3xfTdr39iBTabjbHngzU13gKjf7nsDt6cl/gw?=
 =?us-ascii?Q?BzVPjIstL7GY4XnQknvliImE3qt/EVv00FhgMXlvHpPlTcnBogsfhwgn32WQ?=
 =?us-ascii?Q?OfZUkcNLBn0Nu1iT2u8ZU50R01AUE0ztpJrDIpEVPfuro18J9exdQedJsCXT?=
 =?us-ascii?Q?CSg/uyjysdZTQreddZplu/bhMxozc5vwgjwEcbqTrs6LELcnJ0l/qBCBRDnO?=
 =?us-ascii?Q?Qe0gbG5BPJf4ZWE9c2tf4rrGjxsQ5ei6gI0aiWQMPeH6HEdylhcnkJiQ6UYp?=
 =?us-ascii?Q?4MSeGJnVEjOcWdPQj+FzHRRza8EAp9EMcM5TJIOpE/ZPftsw71xIVy0V2DTF?=
 =?us-ascii?Q?WHGY85l11sr1maZ2N83cF1qI0MbLaajGrzvdH+RNJzvHgRFP6dDnaimR6nHz?=
 =?us-ascii?Q?thPxiCi8IdNITSrehvJVP31K8Pggyvgw7fglxjVEP/57l7mWcobIgBAnvroT?=
 =?us-ascii?Q?MID+NeHGumoXKjNvqhQ1OuDOvaIKBEjeLC38gj0BviHzdGH5rcT4bRXBeAGf?=
 =?us-ascii?Q?UQ2Ofbl5+r2hAxFHfHTFiBjPee/Xd8Hh0/y2sHMG6eb3pSPO+2QydZlF411L?=
 =?us-ascii?Q?J2odkpj1FZDITLNbwylQk9lsgc88m9y80K6NrCKJeq30wbobBJIBIFlS7n/V?=
 =?us-ascii?Q?+lF+gacq77pM2QrgFOPOHOssTvj0tSxEb5dqJPkMNe3/pAXJYxfzniULZFlF?=
 =?us-ascii?Q?FZiwY5zmtcTDPqTnkOT/JnT4fdtT0rM902Iu84Um1fyj0XA9Hn1NEe0fUYyv?=
 =?us-ascii?Q?v45o0rdiSeILObKfOUNO1dZdylecbI6Z8qXWZOedKFKEEpEgL3L8X3TzWrn8?=
 =?us-ascii?Q?s1nHOTrA6o0/khfaAXQAwNuWFBC77G1pHzKZUiQwmpLsYsG6xyV5O//xry0t?=
 =?us-ascii?Q?W/ctc5rhAseSlM6fInBrjsiri9D+j/O0jPbnn57MvoO5mxeWkcXv9DDrVwLP?=
 =?us-ascii?Q?o5j2rAeTdHGJ3e14Mm+BKVKr42GefwyuNPGyVQLrrjqKzT5GrYX2DkNXjYoJ?=
 =?us-ascii?Q?UXz6v+5z5hecv8zHzqlBwblbKhvNG7VZoSyTPcZorqNR9Wedk+LycWYoAUOf?=
 =?us-ascii?Q?J5VGqViD9nXdUqAP0+nRLhZC7Uxc07bfXQVysgTYO+KDkGgrsoW/8aMozw6u?=
 =?us-ascii?Q?P18OGVFtm3G2EAKohjWzbJa3N73RP+ro8JOM5Q9kO+BMLtUUtJOElXybdyTm?=
 =?us-ascii?Q?eLllbp+4yoY4SXGxTizdzy5fvcuHWiV5jV1l0JCLTkOFQS0fzgoX7djEs62e?=
 =?us-ascii?Q?AeZ5wT3nq17QcDfgkzQ6aWf2ugHk/Rgc+V/WK3tUEToFXB17RCBaq5dQl+Bv?=
 =?us-ascii?Q?xdA/w/zuPSCq+E+n37zSxT6GddrlW+bL7rTaEiq8jQOB+rBEMz2LL2JuV2aO?=
 =?us-ascii?Q?uYqgviD7t54Z9BfZPmg6/BTR9olXfcP3XLMM5voNkEgWgWZ0DYtku7TMs8Ce?=
 =?us-ascii?Q?X/ovWiS095pNl3KqCu7+bFbvwyWqtVJR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e5850a0-9132-4058-0e71-08da0904999a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 17:27:38.9594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P4y3CmgBVqt+t2aZcv2+K1tbHeS1pFAJkcSrJoeaMa+1uDBqOqHqkKxeMNba2TpK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3630
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The span iterator travels over the indexes of the interval_tree, not the
nodes, and classifies spans of indexes as either 'used' or 'hole'.

'used' spans are fully covered by nodes in the tree and 'hole' spans have
no node intersecting the span.

This is done greedily such that spans are maximally sized and every
iteration step switches between used/hole.

As an example a trivial allocator can be written as:

	for (interval_tree_span_iter_first(&span, itree, 0, ULONG_MAX);
	     !interval_tree_span_iter_done(&span);
	     interval_tree_span_iter_next(&span))
		if (span.is_hole &&
		    span.last_hole - span.start_hole >= allocation_size - 1)
			return span.start_hole;

With all the tricky boundary conditions handled by the library code.

The following iommufd patches have several algorithms for two of its
overlapping node interval trees that are significantly simplified with
this kind of iteration primitive. As it seems generally useful, put it
into lib/.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/interval_tree.h | 41 +++++++++++++++
 lib/interval_tree.c           | 98 +++++++++++++++++++++++++++++++++++
 2 files changed, 139 insertions(+)

diff --git a/include/linux/interval_tree.h b/include/linux/interval_tree.h
index 288c26f50732d7..3817af0fa54028 100644
--- a/include/linux/interval_tree.h
+++ b/include/linux/interval_tree.h
@@ -27,4 +27,45 @@ extern struct interval_tree_node *
 interval_tree_iter_next(struct interval_tree_node *node,
 			unsigned long start, unsigned long last);
 
+/*
+ * This iterator travels over spans in an interval tree. It does not return
+ * nodes but classifies each span as either a hole, where no nodes intersect, or
+ * a used, which is fully covered by nodes. Each iteration step toggles between
+ * hole and used until the entire range is covered. The returned spans always
+ * fully cover the requested range.
+ *
+ * The iterator is greedy, it always returns the largest hole or used possible,
+ * consolidating all consecutive nodes.
+ *
+ * Only is_hole, start_hole/used and last_hole/used are part of the external
+ * interface.
+ */
+struct interval_tree_span_iter {
+	struct interval_tree_node *nodes[2];
+	unsigned long first_index;
+	unsigned long last_index;
+	union {
+		unsigned long start_hole;
+		unsigned long start_used;
+	};
+	union {
+		unsigned long last_hole;
+		unsigned long last_used;
+	};
+	/* 0 == used, 1 == is_hole, -1 == done iteration */
+	int is_hole;
+};
+
+void interval_tree_span_iter_first(struct interval_tree_span_iter *state,
+				   struct rb_root_cached *itree,
+				   unsigned long first_index,
+				   unsigned long last_index);
+void interval_tree_span_iter_next(struct interval_tree_span_iter *state);
+
+static inline bool
+interval_tree_span_iter_done(struct interval_tree_span_iter *state)
+{
+	return state->is_hole == -1;
+}
+
 #endif	/* _LINUX_INTERVAL_TREE_H */
diff --git a/lib/interval_tree.c b/lib/interval_tree.c
index 593ce56ece5050..5dff0da020923f 100644
--- a/lib/interval_tree.c
+++ b/lib/interval_tree.c
@@ -15,3 +15,101 @@ EXPORT_SYMBOL_GPL(interval_tree_insert);
 EXPORT_SYMBOL_GPL(interval_tree_remove);
 EXPORT_SYMBOL_GPL(interval_tree_iter_first);
 EXPORT_SYMBOL_GPL(interval_tree_iter_next);
+
+static void
+interval_tree_span_iter_next_gap(struct interval_tree_span_iter *state)
+{
+	struct interval_tree_node *cur = state->nodes[1];
+
+	/*
+	 * Roll nodes[1] into nodes[0] by advancing nodes[1] to the end of a
+	 * contiguous span of nodes. This makes nodes[0]->last the end of that
+	 * contiguous span of valid indexes that started at the original
+	 * nodes[1]->start. nodes[1] is now the next node and a hole is between
+	 * nodes[0] and [1].
+	 */
+	state->nodes[0] = cur;
+	do {
+		if (cur->last > state->nodes[0]->last)
+			state->nodes[0] = cur;
+		cur = interval_tree_iter_next(cur, state->first_index,
+					      state->last_index);
+	} while (cur && (state->nodes[0]->last >= cur->start ||
+			 state->nodes[0]->last + 1 == cur->start));
+	state->nodes[1] = cur;
+}
+
+void interval_tree_span_iter_first(struct interval_tree_span_iter *iter,
+				   struct rb_root_cached *itree,
+				   unsigned long first_index,
+				   unsigned long last_index)
+{
+	iter->first_index = first_index;
+	iter->last_index = last_index;
+	iter->nodes[0] = NULL;
+	iter->nodes[1] =
+		interval_tree_iter_first(itree, first_index, last_index);
+	if (!iter->nodes[1]) {
+		/* No nodes intersect the span, whole span is hole */
+		iter->start_hole = first_index;
+		iter->last_hole = last_index;
+		iter->is_hole = 1;
+		return;
+	}
+	if (iter->nodes[1]->start > first_index) {
+		/* Leading hole on first iteration */
+		iter->start_hole = first_index;
+		iter->last_hole = iter->nodes[1]->start - 1;
+		iter->is_hole = 1;
+		interval_tree_span_iter_next_gap(iter);
+		return;
+	}
+
+	/* Starting inside a used */
+	iter->start_used = first_index;
+	iter->is_hole = 0;
+	interval_tree_span_iter_next_gap(iter);
+	iter->last_used = iter->nodes[0]->last;
+	if (iter->last_used >= last_index) {
+		iter->last_used = last_index;
+		iter->nodes[0] = NULL;
+		iter->nodes[1] = NULL;
+	}
+}
+EXPORT_SYMBOL_GPL(interval_tree_span_iter_first);
+
+void interval_tree_span_iter_next(struct interval_tree_span_iter *iter)
+{
+	if (!iter->nodes[0] && !iter->nodes[1]) {
+		iter->is_hole = -1;
+		return;
+	}
+
+	if (iter->is_hole) {
+		iter->start_used = iter->last_hole + 1;
+		iter->last_used = iter->nodes[0]->last;
+		if (iter->last_used >= iter->last_index) {
+			iter->last_used = iter->last_index;
+			iter->nodes[0] = NULL;
+			iter->nodes[1] = NULL;
+		}
+		iter->is_hole = 0;
+		return;
+	}
+
+	if (!iter->nodes[1]) {
+		/* Trailing hole */
+		iter->start_hole = iter->nodes[0]->last + 1;
+		iter->last_hole = iter->last_index;
+		iter->nodes[0] = NULL;
+		iter->is_hole = 1;
+		return;
+	}
+
+	/* must have both nodes[0] and [1], interior hole */
+	iter->start_hole = iter->nodes[0]->last + 1;
+	iter->last_hole = iter->nodes[1]->start - 1;
+	iter->is_hole = 1;
+	interval_tree_span_iter_next_gap(iter);
+}
+EXPORT_SYMBOL_GPL(interval_tree_span_iter_next);
-- 
2.35.1

