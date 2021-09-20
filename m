Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF63411304
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 12:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236418AbhITKk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 06:40:26 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:46792 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236146AbhITKkO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 06:40:14 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KAI2p4028074;
        Mon, 20 Sep 2021 10:37:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=jxlL0lGtv5ZlNrPQbf90760XLEjt/UFew72/NT7P6ZA=;
 b=ujdmjK/3aRQl7ojMwwnSErwE0kxBS+lRRnSteqzqWpeDqIJpN9hA7HfeD6q/K5H54CwV
 TrQ28fYkFePqZPDUtwZj148pt9RnhV5ArjgGqft3l2vF0IPy70aoGk0+R8ajJdErAOv+
 7oMjPnj12rGYDL9utqRRUegk2pop64u7hudANvCp9pdaqugcwZyes0eFPX0nGUEDKMTK
 gcfXtmzL7CIazQeMeYdooYhEiP259CeAUknzJCGZ+Y951BuLRVn9B0/7vjlSAGa7ubas
 akwHFBknaxl5CXY3sZnezVCbpIxBJUNG6k92KegY7v2IduI+zDnpvCBxy9s+IG6k5piP Ig== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=jxlL0lGtv5ZlNrPQbf90760XLEjt/UFew72/NT7P6ZA=;
 b=KGTJSGlU7p483qNxhSaoGccNsfhoVx+Sx5gqRs0OeIlehhVJCSv2unjR/+V1oIqsK6gG
 fsBUiYR7Np3b+68v3kE3YZtytyRz8PzCGPGL8gm8kASBqoQ81ijhjFQyDuRgI9c4yLf6
 A3WNZPGEIq1LKs+Bqspa747ae9v7QojunSEAC90/dpGDlfYjn2qXm4HpYEjuRGfsnUdB
 6QpjiXDW1P3CPMnkGtNf6cs3D4am8ZP82mMYQTVJ8lXz/MI2gUyL79hBbi8xeyUK9UfT
 FUOeC6j1H5byUTHXJeIHjWIBAGkYe811rqgVuNFiezQIA2Buvnv/XmCML7Y20qn00YES uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b65mr9wga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:37:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18KAUjl7173272;
        Mon, 20 Sep 2021 10:37:51 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by aserp3020.oracle.com with ESMTP id 3b57x3urq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:37:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gAwwy4i44J4RA2oM4R+i2OGNvE7dii6ZJvd0GPCJegwtEjGjdXmP5FV5XVrPbbFktzTxmC1HctN6/jGOAJwkLWo/eDvYabBqyV2s4hofq47NxxHImO8dl538x1sItD/rtZfZeGwfOXLDAfyrHQ6c1w7NNJ6xWP3t8lx7GUjmmyG0Elg54i2LY6wdAT38PMv0/CJWDF9MqLdUVjDB3HFCHVzO4wA5x1jr4WcOCimAiD9A4DHEc5Wyd5AF9ypeo65J8LROrgafT1XSoKWtUyQGBpORSelsGtfpcB/ablPxk8mPDNuU0DcBxY19jeefRiZUZ2eX+cCunfKL4tAc3mf42g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=jxlL0lGtv5ZlNrPQbf90760XLEjt/UFew72/NT7P6ZA=;
 b=IEsQbPCpSjMNKVpgtJWY6TSHqFhFxXav0fGfoGbVGgvUrMM/oQQ2yXQKvycVu2ABuY2N+fGpNp6lVOLHQHAeHpvkjZdq0/5hiHmtXbSSskuH8X4GLDILAJr3ARY6XxOEZGec7ooY+hE9E35ZESgXxy11v4rH8/uhfKSFZF2tKRXD4Z1p2GRfQwXooiZq5YwI/49mR/GvJr5Ftw2Mn0P8wSYPxPifLttlLjg04IkCSLQ39CtRPIy/x9ijX2HLwpYKxXhH3CMxRk3wbwVYNb2uZJMXSkZkQl9Mku3NLh0PjuIG2Eshgl2mYxxMk6+ZqsdrWB6MMG53YTv4WbrKvPWS9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jxlL0lGtv5ZlNrPQbf90760XLEjt/UFew72/NT7P6ZA=;
 b=TFEbu3TRrkh7O4yIY5ixUwYS9IFIbY50F9g92AozwyF4RP+rY/snW/DiaAqFftt2jfZ/+tJI4DiIQGgClmPX7dhcx6KbhA5KlZj1LzSR5qcTyPblDV85ezHsCDEY5Wo1y0rv7le/6AC6BKgGYjz+rQuvyqyuD+1LB4PUKg7IbK4=
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21)
 by DM6PR10MB3308.namprd10.prod.outlook.com (2603:10b6:5:1ab::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Mon, 20 Sep
 2021 10:37:49 +0000
Received: from DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::6124:acae:c33e:1708]) by DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::6124:acae:c33e:1708%6]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 10:37:49 +0000
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        David Matlack <dmatlack@google.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH v6 4/4] KVM: x86: SGX must obey the KVM_INTERNAL_ERROR_EMULATION protocol
Date:   Mon, 20 Sep 2021 11:37:37 +0100
Message-Id: <20210920103737.2696756-5-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920103737.2696756-1-david.edmondson@oracle.com>
References: <20210920103737.2696756-1-david.edmondson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0149.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::17) To DM6PR10MB3148.namprd10.prod.outlook.com
 (2603:10b6:5:1a4::21)
MIME-Version: 1.0
Received: from disaster-area.hh.sledj.net (2001:8b0:bb71:7140:64::1) by LO2P265CA0149.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:9::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Mon, 20 Sep 2021 10:37:47 +0000
Received: from localhost (disaster-area.hh.sledj.net [local])   by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 3c6f215d;      Mon, 20 Sep 2021 10:37:38 +0000 (UTC)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d595265-297a-4376-f831-08d97c22b118
X-MS-TrafficTypeDiagnostic: DM6PR10MB3308:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB33082C9C1561C0257A49082788A09@DM6PR10MB3308.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BkhCpPppMiImLxTgzGnEleVFiiooQF7b7B8m14gBbyEmla4/bk7ET+mTTeCFbdTaiDQjI9n05Hm8b7IlRdVaJEvxLddf4tn6NCx+rJ8T9H6ysHMPeUQW0twb4YGmEs6nBU3yCPf/A8QiUBh+SE3w/cYkv5PpW7DktdgvzE506yYJKciRJ39lyW86Y0wjzF/8EPT94GSYCD5b3ThB4ICu3Iz7icO3Gxfs4g7y8oCVb+XAKA6bhkGBTOUfrrHJY8gJvRvo6PyYgqkpgBWwg5vsQEebbGJOjii3jDy2gb6JetPuj1owRshExzTUc0TkBBbOcmUOWMy3CUJ1jlzwsaeV04QxGzyPdf17/UktubVzL2F7GF/uhU1xwsOIr5FT4tg6TtGHySm4PKWbRZOgCaYwholOzVHYJPaDIggH/JPXG57VLVZZ6eK6ZTQSIFfq550+L+Dws7ouvU4AENxskK5vCJKmaTGY1tXLvm1gQlOfufzEkpeJXoiwieFdnGEKfXhVOfSKMHSh9A7ZQAXAF6uqSp1+ZbYJTlMGKnwNPcO+TCPIznW/Ccx5Z/AspoUcRLOO+Bx2OlYsoVm5CaSktGtcjEz064l4Z6j3cPUw8uVJ9sib8Tim3LQTdgz/ryBvGE7R60qving8b1iVcQklK1qhJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(39860400002)(346002)(376002)(44832011)(36756003)(107886003)(1076003)(8936002)(7416002)(8676002)(83380400001)(186003)(4326008)(52116002)(5660300002)(6916009)(66476007)(66556008)(2906002)(2616005)(316002)(38100700002)(54906003)(86362001)(478600001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i13ZJpmF0vAKyJr/n1w95zN257aePhJG3VcUCPALT+/lLvnV6sMJyzZm1FZm?=
 =?us-ascii?Q?7RPy/trTET6YED+tJ1JHNft/GcRh//ceEpNm/eZVB96YlNrlawur3v1ymudI?=
 =?us-ascii?Q?zbBx4AkCxBzAboj72G8JuO4UP57exgz94NJiNLkOqpb0f/WQQQKWWWVZEpmK?=
 =?us-ascii?Q?mml4J5JTnsW3QJ1Mb8MYJcxJN93eF1GaFlNHL0oHv4ZnszHT6blJ85Hfl5+p?=
 =?us-ascii?Q?c8Kxs4KDkTAIDol3bjdtOSKako4VkbfQtVNDEh8VI1hRi+FbQ0V/OLZUFq0r?=
 =?us-ascii?Q?pTZWstHli/xif/+P3QH7Y7UiLtpySGVSCChsXQ8tFVmb9/XDX3l73ZzD+0eo?=
 =?us-ascii?Q?oOyWxJLPnj1Mjq1gNqR5c9DeTZpgihqm4Lhv/BudX/iGkt0CqenueFhhLvr1?=
 =?us-ascii?Q?GRK3vGLF/4CE82rc6Kb+FBcNHtGYFlOPhJ4cI4M/gSod3FbHc1c+mgfi5CJ/?=
 =?us-ascii?Q?BB0zhSUZ4Vjj1/mCgToiSkzMAiafeSgPmGDnEe0jf7k690m4pR0ZtvA52lQ6?=
 =?us-ascii?Q?PlUXjRKfDoUrHwhbnQLhlfW82WR2Gnlm0MsY5+/ioYqulPHG4z7FaaWAZ/z6?=
 =?us-ascii?Q?yC4rSqaJX+Rk0lfxflqNcUteY9UW3lWaknOCX4IV3xc4+9C5DV6Gfy80Vw+4?=
 =?us-ascii?Q?CG8hZzVPTOFMnTTY8E6MMwMYwGvdZPeJh9Pc1OBHWIHEjqwjeFiz2n7BORcK?=
 =?us-ascii?Q?h046KSBnIRQJvI6UCqOmf0TjUd+A/OOSzh3fwb51+U1xFA7MpayIdRfOllzP?=
 =?us-ascii?Q?sXEjrhMy3hLVPwFUUte19AKjwLbbVaY6XrEqArNKOni92NVKbJ62lET+Zv6T?=
 =?us-ascii?Q?r1EcZ1AhTfoxY/CoYOu8I7TX9GdFzn7lx+3R/07sh+MEUU/HQx5FsvrqgVDE?=
 =?us-ascii?Q?RvvJXywC51fWZpf37jZP1qAprlF2AkAv08eiD7iSz/Vll4q1qDgoSC3aqGte?=
 =?us-ascii?Q?WCRrnarggnUeyKwr1tf22KpiZcULgqiYC0z2FYjs1kvKwuX4jblUDl4XUERl?=
 =?us-ascii?Q?EBcCRBEFQAWsyYjuPf+IMyDF8ugnXp00gr6SGML6szl4B9QM7Dz3pYvuqWti?=
 =?us-ascii?Q?BsJSWUXd2nlH+i7gfvP1FWJOgUBWPNntFBJv0CEYqyY2NSJITX9YDJn4wYRW?=
 =?us-ascii?Q?F5ccoyX6oDTza8nTal6xA7RV9T5S8qDAf8CSZBdRFYTBv8zvC2RFNN03cLiu?=
 =?us-ascii?Q?EIplaTN3NBERqjCn5GP1c3xZofQbFdVwdaZdNLtfm7aewfrbVq+Qmowo7NFT?=
 =?us-ascii?Q?kRKONH/lOnZPoQDp+1eqEtj6M8Ef6p3BTw15R5vVsrB20Hf6LI4dxkgW1jse?=
 =?us-ascii?Q?9OZteLA4C37p7NWrV1W0zIZ5mnD9Q+58HS6vs8pq6o74Sw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d595265-297a-4376-f831-08d97c22b118
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 10:37:49.2261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XlZdSbrwJTSnf7W26Zxelk/mHqZ8XQPFATqgj1RifFEm3Tzn0tr3X5tuo8qS8DYOGuiHXXjEJio5QjLJRYegI2KHNVJFw3jLTn3Ly7cuW3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3308
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10112 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200064
X-Proofpoint-GUID: rAQiC_zffUqcDE8_mw3ATGrEeG_fOHl9
X-Proofpoint-ORIG-GUID: rAQiC_zffUqcDE8_mw3ATGrEeG_fOHl9
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When passing the failing address and size out to user space, SGX must
ensure not to trample on the earlier fields of the emulation_failure
sub-union of struct kvm_run.

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/sgx.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 6693ebdc0770..35e7ec91ae86 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -53,11 +53,9 @@ static int sgx_get_encls_gva(struct kvm_vcpu *vcpu, unsigned long offset,
 static void sgx_handle_emulation_failure(struct kvm_vcpu *vcpu, u64 addr,
 					 unsigned int size)
 {
-	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-	vcpu->run->internal.ndata = 2;
-	vcpu->run->internal.data[0] = addr;
-	vcpu->run->internal.data[1] = size;
+	uint64_t data[2] = { addr, size };
+
+	__kvm_prepare_emulation_failure_exit(vcpu, data, ARRAY_SIZE(data));
 }
 
 static int sgx_read_hva(struct kvm_vcpu *vcpu, unsigned long hva, void *data,
@@ -112,9 +110,7 @@ static int sgx_inject_fault(struct kvm_vcpu *vcpu, gva_t gva, int trapnr)
 	 * but the error code isn't (yet) plumbed through the ENCLS helpers.
 	 */
 	if (trapnr == PF_VECTOR && !boot_cpu_has(X86_FEATURE_SGX2)) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
+		kvm_prepare_emulation_failure_exit(vcpu);
 		return 0;
 	}
 
@@ -155,9 +151,7 @@ static int __handle_encls_ecreate(struct kvm_vcpu *vcpu,
 	sgx_12_0 = kvm_find_cpuid_entry(vcpu, 0x12, 0);
 	sgx_12_1 = kvm_find_cpuid_entry(vcpu, 0x12, 1);
 	if (!sgx_12_0 || !sgx_12_1) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
+		kvm_prepare_emulation_failure_exit(vcpu);
 		return 0;
 	}
 
-- 
2.33.0

