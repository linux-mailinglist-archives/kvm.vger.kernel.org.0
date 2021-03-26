Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5B434A255
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 08:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhCZHF4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 03:05:56 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:58830 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbhCZHFk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 03:05:40 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q6ihpK076398;
        Fri, 26 Mar 2021 07:04:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=Uknmy1GGIhz70q64h5Hpk/xYkf3jsHD5regb2qmRFWk=;
 b=RoVWyQsSWtWWbxHOAATcZuITYrHf7b5gIRs7nUq+gMEUMrJWWwHsFFIiz7aRD+35vdlR
 J5IE3DvphYORDUiF4ZyWjDtOm9NFzk0I0+MDovFmtCosB0vuUqVu1cu7jCbJd79knoKM
 a6bSOsJATfaLqb+iWJLiYezxIERXRCiEncbyMc5mcv0ye/2mbfKF3kkmbD5mx2cAqEHQ
 oIO8J51vqHsBCE1dq2a4tNdesEDDIJW+WWDOi79jMPAbjl1JGFXwySjvevAZIK+n9saj
 eAFroTqoarlaK6HLBmlG6gifcKQhMpt/FQzLalhmIgKo2YiuWXrmQd4n+dTpYSnPp5ug oA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37h13hs0qn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Mar 2021 07:04:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q71ADP067877;
        Fri, 26 Mar 2021 07:04:08 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by userp3030.oracle.com with ESMTP id 37h13xb6th-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Mar 2021 07:04:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DLpEmC6rEtd0hiFwF3ivCWokb1BymVqtBcYmFqXSOlCWoVPiR+lCRxYhhsZWexy1pq45NYp4QEb1dRm5qpV55XZS35lmFzIwXoawz8wz/fkBvDYnRNfLRCNIVGdbmNxTnU1ussL11qq4/enzKoLdLcFEDyy3wqyYRzddoV+ZP040Lh3YK3scgGOLGH2CQzKU9raQLN2DlHhpvqCZimNKH9d7UBaCtOLhxbmtyYb2sSPpERJpZZyERnalTDOLutaBf6GLnuzwVrCCawYjIyhIWvccBL5LspoOsP6IpSb9LuFS6KBZ342hM7mrGIzfwMELisjtjDGSA6FF22drAuTW0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uknmy1GGIhz70q64h5Hpk/xYkf3jsHD5regb2qmRFWk=;
 b=MnkVpjV0ieBqAgWYg4CZmeDseGAFnb0JKpnNiltgg04ma2SM4jvv/u8R6cbHtYninTP6I35mq10oKoI9EPrE3CP0LSsgjgHK/8JHxxNCec+JXp3v6b9HEFJd918F4JT534T+mVvjP9ldieR037lBXRZkJk8i8d/i47gWae6xsx5jQS6UDRsm9X0yzzffKvgcuuwHbAE8MxbypE2K5X9VgEjyBy1u5DfJxjf9LlHIOSYQ21JrnMG952nN87E/10Y2H9llFP/tHKSMrLA3KGyqlvF1hYlOyUCWu721W8J/CjT32SzwFes5jr77demsUzAUIj6q7r03tOE3I5rgtZMXag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uknmy1GGIhz70q64h5Hpk/xYkf3jsHD5regb2qmRFWk=;
 b=Z/6XNgurugESFUzKrI3DGHVFF2Qj3qcAqUH6F+Zl/ucoXsB3UNVPLDf2y23rpe6tgaO+FuwP6dSqbU7fOM9ToUHaJOkxzHc/fE1jcG9gAXs//SCvg+wAtU8WX7JgJQO1G8c2yaj+22oQ90FcrffZBycEi5xeMCjgzXgR8KsFQGg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SJ0PR10MB4541.namprd10.prod.outlook.com (2603:10b6:a03:2db::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Fri, 26 Mar
 2021 07:04:05 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::44f7:1d8f:cc50:48ad]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::44f7:1d8f:cc50:48ad%6]) with mapi id 15.20.3977.030; Fri, 26 Mar 2021
 07:04:05 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     kvm@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] KVM: x86: remove unused declaration of kvm_write_tsc()
Date:   Fri, 26 Mar 2021 00:03:34 -0700
Message-Id: <20210326070334.12310-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [138.3.200.16]
X-ClientProxiedBy: CH2PR12CA0027.namprd12.prod.outlook.com
 (2603:10b6:610:57::37) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (138.3.200.16) by CH2PR12CA0027.namprd12.prod.outlook.com (2603:10b6:610:57::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26 via Frontend Transport; Fri, 26 Mar 2021 07:04:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25c34928-6628-4550-5af4-08d8f02557ae
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4541:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB45418BA8334F4526CB1E074FF0619@SJ0PR10MB4541.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:132;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j4qolgCGVy8Ywn19Nv1I6KHCnA0XF7EXhXsVKcEBfUB26+2AeJi3cXN2rLk0iXp8LSv3b/VYnZRExQ2TGBf4Nn/uqDydwPe+aDOWBSdMFxYjU83lk/eytaV/gFRkc+ywSsDWn9wOpmGU7ZXE8TQD0aZsBLYeYBrcicd7G3Aj9tZIiQh46V2bQjQBIxspHgJsfsbehuvXFlPXRdx0vYQhoCHQGLuyBz1TiDqwmAOVJ5gub+5BTD/WpaukuEP/ofzzCpLCdxLkNj65sH2AmUEsxNbhHgRkdCRcx976akcvyl5otT1fq/2zt4LtPngVQcj8T62ZuBFGu7Thaa7hpeT7B6hbrI3agbEIjb3q3O4JbQuSNsDebbFUI7pOmV6srrb/9b3xSPEAOUQs2uStTPBuOotmRotLPkZI4KGfRnCrk4S84/iBuYqSwRrRbtTB0bxsDaICDv/8Od5+EQ9vOsv9XSAH3haXeFcMgJJIRmjay+WQ4z1FsBvalJS+WhXG4cVCv9sqGLF4ESC8GP9LS7m2LrSYfAwW8XPyb/URjMBMp5eG0lPHFG2alw3oa2lFYUv2sx2p0aJUPrLIrmrjUZxYaSKis693Iv1CkRe2xXoQPIilnYBz5TrJlc7bBpoFuw4SVNVtZJE1dPbkBNMjfhS+AyiPtA1Bgpzrd7goubn0v47x4S+YzO6sewrAZ/SJcdMv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(366004)(376002)(136003)(6512007)(66556008)(66476007)(8676002)(2906002)(86362001)(7416002)(83380400001)(4744005)(26005)(8936002)(66946007)(52116002)(69590400012)(5660300002)(6506007)(956004)(16526019)(478600001)(38100700001)(6486002)(1076003)(6666004)(4326008)(44832011)(36756003)(316002)(2616005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JV6RYTtPmkNLF5XoSp9dmCzjgt7unbq1g6i0a8LYteRcD3viahqmMiDtU5GR?=
 =?us-ascii?Q?TMXW+8SyOx8WNGOVomUtBT8uyElC5g6ZnuosCJHTSVlkcAbEWphqkgBBIp0v?=
 =?us-ascii?Q?bSgUFWLywZs4qFCNHHgIE0y3V4ECg7L4PmWt+A0JjdAtOe2o8aVU+uZWVKdw?=
 =?us-ascii?Q?yk9sQHPO80gwQgKTGEKd7X0B9iQIno2X9mH7Puepwp4fe0nsBAjrmaBKKCOy?=
 =?us-ascii?Q?jLtvVcoHoOlwuT1ZS+nwXb/VRC+yDJ9oGSNYKnjV0GeNr40eGq0SNMi2EQV/?=
 =?us-ascii?Q?D9MRSM+ztN6Tb42zfzMln4P9k3V4eph3KM0zismTVwi2bHqXDzdy1AxUizJb?=
 =?us-ascii?Q?GYHjRzRXrq+Q2AYQROZr/VF8rHyHEH5MqfQ/Votle/2ou2ESubtyp0/Jj7zP?=
 =?us-ascii?Q?Em46v23Tt8BdrDzJ3B9G6SySLJmMLUgASCfUOvG2gPXXYP9nM44DQ7X89OZP?=
 =?us-ascii?Q?bf6KThcGWFTiwlqedB2PM/iEGH3VETdMRlbk42pFipgLMRuXwEPy8GYhRm8y?=
 =?us-ascii?Q?7wBJAyDgMKHlLxj9oTlLD1InkO7strqG9Mn9UZcIFtfN7/p7rKqW1WQTmSgr?=
 =?us-ascii?Q?/qk7wiSQwIVGNUnCQRXjArNUZPXu+ha5qr+TpnR+QDrOFXwWNDrv+F/MOaD1?=
 =?us-ascii?Q?02+FRFUgIGzCQ2cIK7Q6B/n5FJaP5IrVjQbdylYfHcwDghEq4iDncvtYZKES?=
 =?us-ascii?Q?eYyH2BQIkpsqRNnburDBhh6EgLrJgfEHRHfq03hSavF9exXcFeubhF0n4ERa?=
 =?us-ascii?Q?1M9rCmM/sK6FTao0PwXzd+xR2ADQDPO0D57Vdd/hq0x6WDW1Fdg+BBtprPI5?=
 =?us-ascii?Q?j4poynjokl/7xq3Vt4Fk7/ZxnPMOxP/hUR8Suud2zokalvApW+xDo3WrJyJ2?=
 =?us-ascii?Q?xnD83OHPbaKVXOkYhxguV0UvJG4KhUhm101elISA/Q3O4LV8fqbimbeyiR2F?=
 =?us-ascii?Q?CMf09wBPdL46ATDUpBtiw0HSvP1UoTnmwLzVmAICElxt6RqWNsInObDbDtDX?=
 =?us-ascii?Q?5aiuM0RufyGW0jARpfiN4ZdVvVTkCrWhBSXRKkFM5/AVHjY4THZJe0VlDAgi?=
 =?us-ascii?Q?/2x4Sa9gr9fazldJGTGn0ne5FIQaUnbENHgvPYx1sePFsiVl1YKFgYjuSMZm?=
 =?us-ascii?Q?6xts4Fb2rwkQkEVv8+8qYq8GaidVgc760KzqMtrMFqYLyOSftbJHudmGmq0J?=
 =?us-ascii?Q?OIrc0mn4UwH+ziOpgzqLaBP16XiqhHciv1I8lId/2zgEXKs3k+q8fRhiuJd8?=
 =?us-ascii?Q?/frwd0hkiHjuTFQ1WmdrPkv7tx+Gcj/aIzffSRVB/bsc8hoHpc6XeIjpPH63?=
 =?us-ascii?Q?Mv3358uZXh9UEyDYVGM65ZJM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25c34928-6628-4550-5af4-08d8f02557ae
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 07:04:05.0344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WRjYgr+PCTdoVvrSXw0GLlmXgzhptd0wtQIKhQww+DZW2+mGZq2zIB6JOzsw5uAipNNVqif20k52Otx7LTBpgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4541
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260048
X-Proofpoint-GUID: UYyGnH-fHR_0IQOTgEN6HWyewcHC9Kfo
X-Proofpoint-ORIG-GUID: UYyGnH-fHR_0IQOTgEN6HWyewcHC9Kfo
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 spamscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1011 adultscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260047
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kvm_write_tsc() was not used since commit 0c899c25d754 ("KVM: x86: do
not attempt TSC synchronization on guest writes"). Remove its unused
declaration.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 arch/x86/kvm/x86.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 39eb04887141..9035e34aa156 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -250,7 +250,6 @@ static inline bool kvm_vcpu_latch_init(struct kvm_vcpu *vcpu)
 void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock, int sec_hi_ofs);
 void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
 
-void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr);
 u64 get_kvmclock_ns(struct kvm *kvm);
 
 int kvm_read_guest_virt(struct kvm_vcpu *vcpu,
-- 
2.17.1

