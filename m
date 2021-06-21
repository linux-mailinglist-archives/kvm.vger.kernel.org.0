Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E363AF77A
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 23:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbhFUVg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 17:36:29 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:62798 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229790AbhFUVg2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Jun 2021 17:36:28 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15LLVO2o017999;
        Mon, 21 Jun 2021 21:33:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=JBPRrxvW1Ywz1QXdWU9rQRLIFa1QWF8ftsXkYBETr/o=;
 b=VPUBl5rzEha+nNOZp2IFfJyYcKaKTzBry3WHoMhM40XkNvj745Pc+/hOEtTqOLkEvpW6
 LyNnIJ6NJYmUprO1oRE9ThojlMHXuT6VAGI75PLIFd1C3x9/yV+MZXOR+MrayOpt4viU
 VzYbVe5ABBF4Vb8zxSijxewAFNtm2+SoSBJ2dnCOK6uQAooYPVH04aUjCgX+b6VUK35q
 deHrlibU3aALcC72JUTP7mFQ72qMpIvZ70AbShUklKguz4gZxaQ/SGv1z3aHc28CB/Bd
 m8oB/lBFoA+xk6CBrWCENkjoQ6GmhlpPtG5rRPaj4umLudQeGtiQoYMDP1H778fsy7eR Hg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39aqqvshge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Jun 2021 21:33:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15LLFn8x134200;
        Mon, 21 Jun 2021 21:33:25 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by userp3020.oracle.com with ESMTP id 399tbrkaj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Jun 2021 21:33:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DOR6Aw1MPMQtoWNBFGHJ8WP5YXFnfES+8JnjRlvgAX7sxH1I31W8geMVaVSEYdB7Jf4DdUMpLM7mQD9lvApjeSmedW3Fc/W3f3LzPWato1tlmRahVJ4HD+n6TW48ZHbfXVQf+eE3W9WqkcLOZYIjyhu8Xq8IGgzxRzeVocv6eBn0J17CQM94bRMgAHTViutkd8d4jOP9uJOAYLFJWn9SmGjB5/IFynt/HA0WVXa7tGdFMQToo46YeGemxINiH4lPBzWErR8UisvXd6AXSArdFnYfhx7cU8gqzHcToUpEngOIGP+gJ5GoTWSBNMQEsCm1hmj2O9cmG6rZFGJGT9QOZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JBPRrxvW1Ywz1QXdWU9rQRLIFa1QWF8ftsXkYBETr/o=;
 b=RJhzLXmOmeJ/tG12OpYl3lsYSVdDNE1zCU3Kt7tkxalfZ3krXyx+snTdiQLmp5S1bF8m1IIhqVy9w1peYHN6beTd4TbtT5+/PzIgDGQKgeNy5KMFQLLEEg5mgK1uQudUK6ankWQOWBIp7LZHYIyOAKOIdvkqqoPwwDmzrJuZA2owIuYxn8inMORdRbrzxbipFrshhEDgHoVsl1VWG1PnOWq0f6cda3sZpRC5pR28h0GOA19v8um0cqzMR2vf7ZBv0/QRwdycOzxz//md6JwcqKHv73JEK8O+0/NvW7qfJFsmTKYKXw5Xxe1oMCHzFOV5dXPvgSUpPVqZiF0oTY5atA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JBPRrxvW1Ywz1QXdWU9rQRLIFa1QWF8ftsXkYBETr/o=;
 b=mUmWZOEaenb5G5qwaJC2KnY5jWeiSnt3kho+ts0ZAhqiJiMH6hFgNJTL88ioQYXyzlPXEdKYqq8MgmqeEnjOoZEGAoCmt7uDcfD07F5iNv4ZOnVh/hUxXjDJL77nybZxnQod7pLLgFThwRBfEw7zBwrR/CWxtBHvvKmqNXrjqQc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB3453.namprd10.prod.outlook.com (2603:10b6:805:db::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.22; Mon, 21 Jun
 2021 21:33:23 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4242.023; Mon, 21 Jun 2021
 21:33:23 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH] KVM: nVMX: nSVM: Show guest mode in kvm_{entry,exit} tracepoints
Date:   Mon, 21 Jun 2021 16:43:45 -0400
Message-Id: <20210621204345.124480-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210621204345.124480-1-krish.sadhukhan@oracle.com>
References: <20210621204345.124480-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: SN7PR04CA0186.namprd04.prod.outlook.com
 (2603:10b6:806:126::11) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SN7PR04CA0186.namprd04.prod.outlook.com (2603:10b6:806:126::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21 via Frontend Transport; Mon, 21 Jun 2021 21:33:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf682aac-7a78-40a6-12d1-08d934fc3232
X-MS-TrafficTypeDiagnostic: SN6PR10MB3453:
X-Microsoft-Antispam-PRVS: <SN6PR10MB3453EE800DF8B1C54009F2BB810A9@SN6PR10MB3453.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fkRCdv+wd6pTmyrv5z9lDX+wyzQ+s5qn70U4t6XB+senvkYWtpzdPuXJLpX8nBPiV7mHx0Thav22XfFn1+uzYpMp6yVW3k3BCjYOsra0cW0GrVBZJOCw/cmaTKFy7lL0G6rrnkGMNy4zdmJURzQMdt5hlKouBx5dz5XPEsMLq+fbKNA4vdlr2kCkmDm3srjxf1WvLcQmwhl/uHGQNgegh0t9MYuOl/YyIGTOfzCg190ykjUk4fpOl7Aa0DnBuGIB72P9Gz0ibS/g384MuHzqYxU73YhUxMpP38mmUcmVQ2+gQck/P5a2KM3bTuZ53YT+GQt2TtiH9QILxVgJQ9OH+UpTYmVVO+SQQaGKjELi7zpAloBTrcYKAyUPun2CJAbYsTTO1WIsRPu8cjrua89iivUi7+i1wx0lvRi66/qRWRekoHccXb7k3IMU3h90Nj6jk29u/nxpjMe00zh/rgW/XGmyQaVZNo3jVoarhM41tC9jPJsIFkMypCtTxzHb/RYRdh8vbJMhlz6VT19GYz1sY02YCoYmi3qatj+5TfH7njARgrw8G184OtxNVmQd+y3PjtfRW+Xqc/U+XO+CGPhjW61NcOLUKhoULMgrXzpfcrs18l0nzG3bCujYLZWWww9vNT13Ddoyn4tS6fi6lKIv2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(396003)(366004)(136003)(376002)(2906002)(86362001)(6486002)(16526019)(8676002)(478600001)(6666004)(5660300002)(66556008)(52116002)(26005)(7696005)(38100700002)(186003)(66946007)(38350700002)(66476007)(2616005)(4326008)(8936002)(36756003)(1076003)(6916009)(316002)(956004)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ktR+rwefF7K5ezN2kOgMNob9180aGdua8NvAotP/4/snSKM3BTxTRyqVW0GO?=
 =?us-ascii?Q?gApGx5j2oz3gTFsv+gQajfi1yGdawwES2FiOSScRDBJPjOVZphPYnSjcWCb2?=
 =?us-ascii?Q?xsbPWgqqz0iaUXTKJOsXcjRCwcbz6C6dahRfUu99mgwn4FIxYl2YUNcz03LZ?=
 =?us-ascii?Q?KlJQWvOjNg/kIgHn6rzduZ6IYKo08CbRfvR0jX4s4XXsnWzAG8muP+ulNMKz?=
 =?us-ascii?Q?NGOyLx4WzGH0/LfXC6KNb6ciZjoJ2+A9McJWwAA0ZuV3IBQswvewzfYv5Rag?=
 =?us-ascii?Q?39mWxr/e37zse/nsekmJOcmkPEB7CUdgYdxSEMDeUOY4TX1QgMJ9k+HMl88N?=
 =?us-ascii?Q?AfgbHeo9JPnVZ5iCnCXS8Oe8Cyw1zeorxblbgm8W9t1E2jSnJjrx1VAoDGUR?=
 =?us-ascii?Q?3dzg8BFjUvU3/+TKzZwUrAnUIXoO2CGNngxZjXAn4f8faWrPUfm24ryggB2B?=
 =?us-ascii?Q?WYqNKED1NDoKPaus8BrQ3vwQ1oshndHVv3IzW2HoZGpWdv5pYFqIddi5y1gh?=
 =?us-ascii?Q?CwGCy27JZs2B6/GGL5uPxsY7iUero0PHZg11p87OUyPV5+itPmE4LCxTwzKA?=
 =?us-ascii?Q?lNgJed2NtESD0+htHOK92k26CjzKzvK9XC+mTRiFcBZfKItA2ykFliUbd7A1?=
 =?us-ascii?Q?bW2x0Or0RVugG857gAYpWNYLL01TPE+zq+ddOFoxcN0EKpLzEyNcARRbI6Fg?=
 =?us-ascii?Q?ub72AyJnTN3oMZOxVScaliIshudTpy6RdB0F3D1EgK/12bEIqiq0x4mQfinE?=
 =?us-ascii?Q?FnIoznNJZKH1Ywv/p618el4+x8C+bqJ7GykRmw8ukYCjRztdME7QQu6hK32P?=
 =?us-ascii?Q?K4kQbh1oN5T8P4QJz8dy3TMNWCXbnUeMLqtqLA6JdYolF+oVaDWWo7Bkr7o6?=
 =?us-ascii?Q?oZ3bNdYnLS8DYrQ3ROjD2Czht7wUINmAW77jXOu2bX7L3GR9htwANjPaMT/u?=
 =?us-ascii?Q?kPMWs5X8KzjtxFNp0wA1AFgaEpuOJw+vwA1w/g78g+v0iFDGSQn29+l97375?=
 =?us-ascii?Q?L6q0NaHgEgKC1jUAMZJcxDSdMg0PEtd6hjO/wfcLrONb14CIbgBZPG3lOdp0?=
 =?us-ascii?Q?k2NtS5MXb4/c3x4yuGqm+ODqJlqkG29SmrREMbLcIH5t9ial+jiO5iLnWuLG?=
 =?us-ascii?Q?ydqsPueQk6MpDGhIBmJedYdW4bIknwXpZIsm1D7b4w9W+PPTJDrX/Z3br14l?=
 =?us-ascii?Q?/q+M07W2x+YAwfUtyrM8jm2nt4xd+y+m5Qux5XCyPRNvSDcF20hsUQJcc34B?=
 =?us-ascii?Q?8DDdxU9undgzC7Gt1prtWu7is3VlTR1PuUpYbqYkPoAF//mZOsiUCxy1U32z?=
 =?us-ascii?Q?WQLY/DKZrsljdbq0CoZJdiM3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf682aac-7a78-40a6-12d1-08d934fc3232
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2021 21:33:22.9720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qlte/KWM3wobDH0HXOewnPt0BMUfM53RBNX56KqbVeUOkCo0a6xmPV/Ygq3FDNKrWZQ+wqJt868d7yI1TA7Uki5g0IEJazIcD7FruCiwjpk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3453
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10022 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106210125
X-Proofpoint-ORIG-GUID: Co2exjkBwkSlw2ZJdoSO4mO2HQT8NY9P
X-Proofpoint-GUID: Co2exjkBwkSlw2ZJdoSO4mO2HQT8NY9P
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From debugging point of view, KVM entry and exit tracepoints are important
in that they indicate when a guest starts and exits. When L1 runs L2, there
is no way we can determine from KVM tracing when L1 starts/exits and when
L2 starts/exits as there is no marker in place today in those tracepoints.
Debugging becomes even more difficult when more than one L2 run in an L1 and
there is no way of determining which L2 from which L1 made the entries/exits.
Therefore, showing guest mode in the entry and exit tracepoints
will make debugging much easier. If an L1 runs multiple L2s, though we can
not identify the specific L2 from the entry and exit tracepoints, we still
will be able to determine whether it was L1 or an L2 that made the
entries and the exits. With this patch KVM entry and exit tracepoints will
show "guest_mode = 0" if it is a guest and "guest_mode = 1" if it is a
nested guest.

Signed-off-by: Krish Sdhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/trace.h | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index b484141ea15b..44dba26c6be2 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -21,14 +21,17 @@ TRACE_EVENT(kvm_entry,
 	TP_STRUCT__entry(
 		__field(	unsigned int,	vcpu_id		)
 		__field(	unsigned long,	rip		)
+		__field(        bool,           guest_mode      )
 	),
 
 	TP_fast_assign(
 		__entry->vcpu_id        = vcpu->vcpu_id;
 		__entry->rip		= kvm_rip_read(vcpu);
+		__entry->guest_mode     = is_guest_mode(vcpu);
 	),
 
-	TP_printk("vcpu %u, rip 0x%lx", __entry->vcpu_id, __entry->rip)
+	TP_printk("vcpu %u, rip 0x%lx, guest_mode %d", __entry->vcpu_id,
+		  __entry->rip, __entry->guest_mode)
 );
 
 /*
@@ -285,6 +288,7 @@ TRACE_EVENT(name,							     \
 		__field(	u32,	        intr_info	)	     \
 		__field(	u32,	        error_code	)	     \
 		__field(	unsigned int,	vcpu_id         )	     \
+		__field(        bool,           guest_mode      )            \
 	),								     \
 									     \
 	TP_fast_assign(							     \
@@ -295,15 +299,17 @@ TRACE_EVENT(name,							     \
 		static_call(kvm_x86_get_exit_info)(vcpu, &__entry->info1,    \
 					  &__entry->info2,		     \
 					  &__entry->intr_info,		     \
-					  &__entry->error_code);	     \
+					  &__entry->error_code);     	     \
+		__entry->guest_mode      = is_guest_mode(vcpu);		     \
 	),								     \
 									     \
 	TP_printk("vcpu %u reason %s%s%s rip 0x%lx info1 0x%016llx "	     \
-		  "info2 0x%016llx intr_info 0x%08x error_code 0x%08x",	     \
-		  __entry->vcpu_id,					     \
+		  "info2 0x%016llx intr_info 0x%08x error_code 0x%08x "	     \
+		  "guest_mode = %d", __entry->vcpu_id,          	     \
 		  kvm_print_exit_reason(__entry->exit_reason, __entry->isa), \
 		  __entry->guest_rip, __entry->info1, __entry->info2,	     \
-		  __entry->intr_info, __entry->error_code)		     \
+		  __entry->intr_info, __entry->error_code,                   \
+		  __entry->guest_mode)               			     \
 )
 
 /*
-- 
2.27.0

