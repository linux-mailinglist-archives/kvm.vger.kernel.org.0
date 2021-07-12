Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588F03C5EF4
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 17:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235388AbhGLPUQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 11:20:16 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:64228 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235398AbhGLPUM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Jul 2021 11:20:12 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16CFBJNC006019;
        Mon, 12 Jul 2021 15:17:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=+FvTbHhPCZvQAFaPwtHPTcMykAm42qKD1LWWwLkrXHY=;
 b=WaKmyCpStozsJ9YLKt71SYhvR17HhPGp4y7MQQ6XI0L+Xd3ffIAvAijPjFI3tdN++K3K
 ksmKgpgbJpVe5w3e6Wglz+Ng4M0vX8cPcDNkuw15lgoUFuG4QHKXCC/55RQQyPqckgUh
 Y1081KjXjEtkghw0Q0nrDNScrkGvKoDVjrXLXh5ayvCCpKyHpVBlqyWUjiUN+TGtbzfe
 sv+buu65INFJhCbx/caQjBp+9KwoSzYeSo5sbE3fihkCLn/1VNOjoCfegRjFNtqB+4Bp
 Q/ioEgPbSQoi9SN3BC5U/lhpgOMPzbbbxbdNpevBpTcH0q0z5kFGqlfJs6Po/kRLck2G lA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39r9hchee4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Jul 2021 15:17:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16CFEdop148790;
        Mon, 12 Jul 2021 15:17:14 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by aserp3020.oracle.com with ESMTP id 39q3c7ky27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Jul 2021 15:17:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QKx1SBxd8GbqWhxGU7copLS5A5Wus7+SLiH71zMWleVeJzcPhKq/QxW296VjEmV/zBTBjdOz1FxbXlulxQDbOoNWZOw7YPNUmGlu7bmtMka99MiigXQUtW7Ew/SOwCjLZNUwiMfkEGhnS6ZsVTDm7Iy0VKNevHMSHGx7ejFgnT9NtqGHCTEnM2ciCJPt4aCKwzs1MRoc4IU1Lv9SK5PSy2Gi4yvvaoWuAMOhmFSdacaVUWeJAxqvLmi0go3tmDHd8dkaVAokErR7BW80TWW4xDKnR+q+pgsIDnMqciD+zzcNC8UNFhXjy+fDPDpUWtuyG5e8YuvcolH0U7rYcUMdmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+FvTbHhPCZvQAFaPwtHPTcMykAm42qKD1LWWwLkrXHY=;
 b=Hn/q6WtXK+0aNIYFqk3xOWtjkwJkALBGc6WvXpi6+rHYywK1uRq8fav6Dxlzm84tolhjj3PGgTg2VGeuhXCj4bqSkdyBR1fnRIDnAVVFhcOf6t7jFEkM9mc8TGrzMzmWOCfMP3gxGALcSO7rp12+6dEIiQS5fNac3jcKu1UVIrAck5sTmNOlTvqJ+LPkuzZubnMBzqIyS+jgjL6Dqmw4+wjFyKMJkHxKuvl3V2ddPHli8dEKrZpM9/DiB8UQYHn6gfunz3eXYzSBe5GKBmizwqFWE8BKDDR++FtPZimQa4kX3a172j2IXKJKHehlPN7gcmC2JHco9DAGmw3qiRZtxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+FvTbHhPCZvQAFaPwtHPTcMykAm42qKD1LWWwLkrXHY=;
 b=ec6nVRdHUtLdgWUbqC3OsBFhq2qOEFMREsrWw4fCqwHADR/VHYXDaP9Nu/dKWHynXmwUkFROEyE9UzRtgzDVsvrsZiBZMi898gXed6CO01oZeFLZqwjn130Wo/QRri2d0AnWEO7B5ihQ614QQcoWDuo61HVnBWYQkTzISm4464w=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4391.namprd10.prod.outlook.com (2603:10b6:610:7d::11)
 by CH0PR10MB5257.namprd10.prod.outlook.com (2603:10b6:610:df::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Mon, 12 Jul
 2021 15:17:11 +0000
Received: from CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::b895:ab48:fa35:3f15]) by CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::b895:ab48:fa35:3f15%4]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:17:11 +0000
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
        alexandru.elisei@arm.com, james.morse@arm.com,
        suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc:     konrad.wilk@oracle.com, alexandre.chartre@oracle.com
Subject: [PATCH v2] KVM: arm64: Disabling disabled PMU counters wastes a lot of time
Date:   Mon, 12 Jul 2021 17:17:00 +0200
Message-Id: <20210712151700.654819-1-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0086.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::27) To CH2PR10MB4391.namprd10.prod.outlook.com
 (2603:10b6:610:7d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.nl.oracle.com (2a01:cb15:8010:b100:76dc:8169:72eb:62ac) by AM0PR06CA0086.eurprd06.prod.outlook.com (2603:10a6:208:fa::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Mon, 12 Jul 2021 15:17:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90abe2fd-bdda-4ceb-bad0-08d945481f0c
X-MS-TrafficTypeDiagnostic: CH0PR10MB5257:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH0PR10MB5257D7214FAFA91A85FDCABB9A159@CH0PR10MB5257.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:765;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zz7M7VOngDLz+P8iw6V9kP6KXEk/JUQ+JOfc5yzoBF36kLqtSwRkFrzEzbbD7mZRKL8IXYLTUTBWX+6JqskoqsXNox0dZP/Nw9J/IebvJN/ERFv/8gOhp+DybRQCw3NYBLobonovnG7JgQnuvEEU03TIegS7JJAArJHa00714yWumUFoklmS1T7It6sgwIlPnkKkTVIP/xc6V5m4Y8mr1qflKFBXg/pEAIB3kJL/g3uUiC1Zr3cxQW0q2j+v4lrx6r0Fh0DwLMfch/NS+Btrfu0M/neEonN7I5O6n3HVGkCm6uIs62kFovJoxRCpcjmhJgXeDtRXCl3VrZBYduyeOxGatZn6J8uFtdzDUNjwq1XjD0DkjGy27TZC5yuAkT+cGmjCsjfcQIuyts0s0NRN+4PljpRxCHtJ6RCpqtp78MK9tLSLPQCWVkWjPxthO7piOLTfw6wc6PgjiihaaGg7Oj49Iv823c6kgYDI4DtIU6BlR1Bn0m5q8RonF0wX+rSdrBHrBGv1QqpQp6c45GOCwOlt0etjN1b3SxMaM0303ggeuKszmIwOqVBLjT8PWhjIwOurph64aKKYYAQMZFZQIC3DJ/A9AoGf2+HGu4r2+2tvolSIybdg16Dxe21YrGrvkGKJcyL2VrXoxhE5YC4pLZbdy3sF/H3cUjz90wJMR/sfs7CL7fmnB1U8bWaOGgS1WZauKfZ7ZJMNfVan+aZ3/ZqWk+QE3dqwhCA6aIVysRI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4391.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(39860400002)(396003)(366004)(316002)(36756003)(4326008)(478600001)(186003)(966005)(1076003)(86362001)(2616005)(83380400001)(2906002)(5660300002)(8936002)(8676002)(6666004)(38100700002)(66946007)(7696005)(107886003)(66476007)(66556008)(52116002)(44832011)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5V6naNxaZvq4pcOv5OTqWwWHO8N8exnKYSgZb8tkzP9NyjD+hc+V/F/GsOtR?=
 =?us-ascii?Q?IfIyBEE7HaSjva1PZ6tHv+cBdswx9NSyfBo4z3iLKltFHmKh4gOBglPz9hra?=
 =?us-ascii?Q?fdqTn+3LBm32WXvQ3FhqerUtq/TYT/+zf9Vi7w0rZhOUDsoswBJUy4f0Xox3?=
 =?us-ascii?Q?7516SO8Zrn8cJ8gZPTQaPmwmMDtxO/myGminKKxAAzVKQp20QvMJ9oKhwp63?=
 =?us-ascii?Q?vOU4u5MvGlT9RY2dait8r2q/pjqbTJuBYFVF2p/I4Akyu1fevk5zSklgNP2V?=
 =?us-ascii?Q?CWuW1JIelt9hb00Dt0q4bl5WCTZgi9r0iCFkaQYM8+MGIjFXTNVyLacA7NsB?=
 =?us-ascii?Q?hyey6NSuynwcORM/J3kzxtQW/0RDNfvr8a/pIfZqCAk6GlTDWVc8okaNgP84?=
 =?us-ascii?Q?DsBp5TZDvcxxSWMCWGrrS53QGNcs8PfUBpEsthF3rpLvin/+nyZd/zN8Fz3S?=
 =?us-ascii?Q?4U1G0zcJddVe+l0Gzkmq7qarM+/pgpfE6AJ+2IROvBSngREidN9gKwble2JQ?=
 =?us-ascii?Q?ViqXhRkMfuunsAloKk92YP1GbvsOosAtSzSZH4+r2hC46pOiuHtA7HlJOHKa?=
 =?us-ascii?Q?76ojr0wSqfjQZgTJ2swlmdxmhFBxa1z2gspJHCm7CI1tqX+epESjG+1XMAaD?=
 =?us-ascii?Q?35vooggTLsO2sYtGZACBcxNwAOOkP3BYjCkXd49pvAtreb2JPYDoQFhDYQVV?=
 =?us-ascii?Q?yF3F0t8M9MYeGPqio+dBFDZsZup16bgyoZYBaLslxkzV9fFDxu83+tyLO/X0?=
 =?us-ascii?Q?aoxKqOTqatvtpVm/47rvpX8JBs33GawoifftP8QedizU4J2aaiqWh3tyls2v?=
 =?us-ascii?Q?HHONMM02p2jkj93NG3jLV2kP1WhWVPSf7uRTu/6aAuJd6LqbGJgjjtqbTywZ?=
 =?us-ascii?Q?cZ0t5duoiNjp7wBSPTg7rv6SFM2Jwtf3Yu+2niuOwG3BZnPzLa524v/FenhV?=
 =?us-ascii?Q?MEznUobTkRfo5Ywd8QQcQvlQAgnn1Q+Vy6UWQCxdHve8cH06uccmU0QHWTPV?=
 =?us-ascii?Q?YPLOJ8r9Ez7oeD1PJuEtaRiITlE/JX+ZVadqR2mOJ50YIgd6Pqv1fiXA/zKh?=
 =?us-ascii?Q?wHcGIsIs+sVeu3V7ZtkSwi0aJTR6VwfK3bXySITk1QI5C6+WZ+PO8coY1XEX?=
 =?us-ascii?Q?gMAmznUmgdmjuYfgJkfc/5W62a3w45WGIGEPpgIdb+vMxIpmerEvnDBqLVaj?=
 =?us-ascii?Q?/kbKxT8LqU84mbe4P4qF6WFMRFF7tC7UxGotHIPvWKy7KkAAgiEz65I13kHQ?=
 =?us-ascii?Q?ZBqV+9l2fPl1H8p2aubfQUFEZwXL8L+/1n7f3Y9g7FZu3hi7VoGBol1pEJcX?=
 =?us-ascii?Q?cRXq/LBXECcfBrjyRSG7zXswXQLjZUR7ehQJbo9gslxj+ChUd8q7KYy+RUCi?=
 =?us-ascii?Q?RvzHJpgmZfnlIt7mgGbwddQzwtoR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90abe2fd-bdda-4ceb-bad0-08d945481f0c
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4391.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:17:11.1780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: USVIyMP5QOwtfuclhLSq8Z/1+YyAo4fgsclrFKfJXka6tyZ92tnouwf7sG1UJ79hjk+ABma9DSCeUT0CApdUj1pB7GbmOMHv9Phl7WZrkSo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5257
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10043 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107120119
X-Proofpoint-ORIG-GUID: ZUUahSReeNYYQ0-e7Tgjr1L0u-RBlfDQ
X-Proofpoint-GUID: ZUUahSReeNYYQ0-e7Tgjr1L0u-RBlfDQ
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In a KVM guest on arm64, performance counters interrupts have an
unnecessary overhead which slows down execution when using the "perf
record" command and limits the "perf record" sampling period.

The problem is that when a guest VM disables counters by clearing the
PMCR_EL0.E bit (bit 0), KVM will disable all counters defined in
PMCR_EL0 even if they are not enabled in PMCNTENSET_EL0.

KVM disables a counter by calling into the perf framework, in particular
by calling perf_event_create_kernel_counter() which is a time consuming
operation. So, for example, with a Neoverse N1 CPU core which has 6 event
counters and one cycle counter, KVM will always disable all 7 counters
even if only one is enabled.

This typically happens when using the "perf record" command in a guest
VM: perf will disable all event counters with PMCNTENTSET_EL0 and only
uses the cycle counter. And when using the "perf record" -F option with
a high profiling frequency, the overhead of KVM disabling all counters
instead of one on every counter interrupt becomes very noticeable.

The problem is fixed by having KVM disable only counters which are
enabled in PMCNTENSET_EL0. If a counter is not enabled in PMCNTENSET_EL0
then KVM will not enable it when setting PMCR_EL0.E and it will remain
disabled as long as it is not enabled in PMCNTENSET_EL0. So there is
effectively no need to disable a counter when clearing PMCR_EL0.E if it
is not enabled PMCNTENSET_EL0.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
The patch is based on https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pmu/reset-values

 arch/arm64/kvm/pmu-emul.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index fae4e95b586c..1f317c3dac61 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -563,21 +563,23 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
  */
 void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 {
-	unsigned long mask = kvm_pmu_valid_counter_mask(vcpu);
+	unsigned long mask;
 	int i;
 
 	if (val & ARMV8_PMU_PMCR_E) {
 		kvm_pmu_enable_counter_mask(vcpu,
 		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
 	} else {
-		kvm_pmu_disable_counter_mask(vcpu, mask);
+		kvm_pmu_disable_counter_mask(vcpu,
+		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
 	}
 
 	if (val & ARMV8_PMU_PMCR_C)
 		kvm_pmu_set_counter_value(vcpu, ARMV8_PMU_CYCLE_IDX, 0);
 
 	if (val & ARMV8_PMU_PMCR_P) {
-		mask &= ~BIT(ARMV8_PMU_CYCLE_IDX);
+		mask = kvm_pmu_valid_counter_mask(vcpu)
+			& BIT(ARMV8_PMU_CYCLE_IDX);
 		for_each_set_bit(i, &mask, 32)
 			kvm_pmu_set_counter_value(vcpu, i, 0);
 	}

base-commit: 83f870a663592797c576846db3611e0a1664eda2
-- 
2.27.0

