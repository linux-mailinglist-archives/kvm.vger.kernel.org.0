Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF6E37B47C
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 05:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhELD0F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 23:26:05 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:40840 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbhELD0F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 23:26:05 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14C2XxdX028871;
        Wed, 12 May 2021 02:37:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=e2OgJs9zkD3bdfBUJOGrX6JlstCQGxu71rDiqyS9tWE=;
 b=j51ExzRv9shmTFIMoyKH7MTj36o5mhk/2tCov0MiVFaTTLFR6eX3JBwGHJGy246+roUj
 +VLZdm4/T1GAH8cRWdXbWxcDQXgUei4nXy4SVuPA4IHsrJBY0Gju7YBaCr5HjBEBK5cs
 VFbkRamXqMMkcRnmbHTzt4Xb0wK08fXX+pcEVzT1aqvxN5nEHP1228hCEZl9LukZ35lU
 UmXWB/3c2m8Qt2lY816rPSL9olGWxf2VyGveb6g//L1LBSawO1tPL3Yo3bkhWrfhG2O0
 LxDXld+FcsSqxa9JaDUIAdQEJ9H82IcB3tvXABeEbHmix+ppBJrsjg5itpCDsip6iMh2 JQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38dg5bgrn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 02:37:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14C2YgI3168780;
        Wed, 12 May 2021 02:37:12 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by aserp3020.oracle.com with ESMTP id 38djfadpax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 02:37:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g0EqiXrVlgh47+RKwXoZflKgZQnnDbG9qeKnwWHF80P39P057c5uKe7+XQAaSf9gelEXBY+3U73LYijXrAfH0TQQMj2a96OPiBtX/eTCVe2ADh/TAoFAYtunJglOVr4T5JJ8ZVhBm4NYUxrRrQyZzndP3P+dH+XpQNUz8RWF7ADWn3w55js4HNLFjaatOY9dmKCPygL/SIjcB2ihVTwB/WWg2uFgiirjwp13r0TAxlIHcbHWzuCPTfCP8xEterSimuZIVhRAWGoesR0dYMYZJerPIUOuV3drhA24xMopmI5jR/6QscO4fy7wvtR6tsBMhCtf5vJy1zzx/zCES9EJwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e2OgJs9zkD3bdfBUJOGrX6JlstCQGxu71rDiqyS9tWE=;
 b=aACWvvO5dsQQ9TRLdVhDbYjFWSUVyjRqQE/jeC50dYHAea/HD4DF4/8QxQZxXJWua77qcaaj5M+xAeQtkVd4n5O0KMPwk54jlcyFidz4XuMbSeXGg/FHsJgC+9Cudue6JIpy/Bwpp+Rob9Yq1KHzzer8NtfMjMqYYr8M+i5rruBwuEje8KCTzcyqbeW2kApYWLemEFB3W2bCDg4+6IgB6DWKJbesgdhW6uCh9GWVSD5CSOvwfIXJPtlccL7tOWBLfd3HNJGiBJcuUWn5mbn+AD4PUKemxhjJse8uR4V31NjWeOsQcNUFvZioE/VZmiVVUc30hCsONVeQ2pt/pEopxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e2OgJs9zkD3bdfBUJOGrX6JlstCQGxu71rDiqyS9tWE=;
 b=y+BzEAj/1+fTkhKv/Dqq4oFOiSITBntFwqhPG+pu9OIz+3PZKQuIEdLs7NdXtk01OJ1fnjA+Vu2TX7HDWogV+JHBaQ6qbFdEZJyh4mEV5ZHud6V9k9RfKo0oKLPKgUOCDrxc7NEEywuRi+ZI+GRGz22NKxuzUDIYe3Pq+baO84E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4425.namprd10.prod.outlook.com (2603:10b6:806:11b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 12 May
 2021 02:37:10 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4108.031; Wed, 12 May 2021
 02:37:10 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 0/3] KVM: nVMX: Add more statistics to KVM debugfs
Date:   Tue, 11 May 2021 21:47:56 -0400
Message-Id: <20210512014759.55556-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BY5PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::26) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BY5PR03CA0016.namprd03.prod.outlook.com (2603:10b6:a03:1e0::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Wed, 12 May 2021 02:37:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08c9dec8-62f3-4aae-6552-08d914eed771
X-MS-TrafficTypeDiagnostic: SA2PR10MB4425:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4425BB03574F1EDD307DCBD181529@SA2PR10MB4425.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XG9L1sbBSS2An126nBGzdNXuHvAbczb4Fj+pPPJdnwR3Np84SXIEhxfL+mqKMr3kLLAPUxVM4FrsJvCAVootItheIFvP8DdfPmOmpEfQI51vocFKhSwLZUDtmF0EfUkzF33hD2SB04b3agPUAAGuhfzQR84FtkeOEx/t4RAq7Ce5YuPOumZekPZSdGnFQE/HOHuHJHGDkbnVmCGYCyI3m4wjczIas0Y+OYYViop/R6cTD7PHjyoi7HiVm/M+d0D3bhge038UTie5bunfAP1CAsucmBqQy8ZdbZOOWCtHq5y115PSfWE9kdAko+Icv1kOWsJ0/DAaAb8se4q3Bt+O4nt5+Iafa+4Vi3hc5aPZaii6j3IBuWWTXWKVqslbViODbHjASKsfdhP0m/gUSSqvilQU3YX3pkAwS94vaAkE5b4pE7RA0QoXZFO6jlzmAh01XEFWPmKO8CFlEsYde3OAkP5b/fsYAiz1226wNHGT+a1KF5E04JH2x+wlmlKhZGQyvuqBxQC+zr3RPm3sonRVraFuMAlnVU7CN0tLcMol7uttljY07YANFDaZdGcwxZCf72ZY8q4A8bgRRPG3+Gr1XHrWHbNbr75HCIzst9MP3OBQqw2xpYjVF3vu9BFbleLxQ9ecH/GgD6IT6LbbcWeSoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(366004)(396003)(376002)(66946007)(8936002)(66556008)(478600001)(6486002)(2906002)(1076003)(36756003)(5660300002)(4744005)(83380400001)(186003)(16526019)(66476007)(316002)(86362001)(6666004)(52116002)(38100700002)(8676002)(26005)(4326008)(38350700002)(6916009)(2616005)(44832011)(7696005)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?eSB6PsYAY/25ZIlu+iSOgxaXgOgUWPWCYQw4COBhjFkN6L4FuKax2vF4jLo2?=
 =?us-ascii?Q?45XMRJG5HbPX0z8CW60Ym0YgrDVbJz/Lwr8AjmXhRhTyu5Vkty6PAR8JKUz1?=
 =?us-ascii?Q?k006RnlT+DJ8TQEhhyA3fY80dk93xrVl3djZvOxiKvRgrrJDiWOaY4CpUenF?=
 =?us-ascii?Q?RIge11UrAQs/CnfeOwGOoI4x/pNomlaWf2GMaPmwxJnYTbna5MlHxEF61H48?=
 =?us-ascii?Q?CtkExCdt0Ln2U1PFjyXh7sLduai6SMI/Aocln023WLm8Ye/JaCMHFaDYTuia?=
 =?us-ascii?Q?iJb1dzthFbaxO4NFJRwFXTA8d66+jSU7MrYksTZDwJA1yTy8xR9fy9/PrxPh?=
 =?us-ascii?Q?5pG/Fnwzl4n0DgKlh0DQF5csUTh1FcDxYZqKUl3n3IpgANbHGWwKzMRtpWjD?=
 =?us-ascii?Q?oxH6/dywb8z3qGh+2JBNjsN/r6XufUklLVJXEfx1I6+6SEfl3BgfaNvUkAkO?=
 =?us-ascii?Q?4tCS1ndhVvNYQ8fxfUi8AAfd3qlv9nlhwcrmSQ7w31kj2cWG4jwcJTxopa+s?=
 =?us-ascii?Q?CVltXfxNaagBEoC5/DzLqlSn5WRTLD7NBZYsY9XCZTuRapyhirKKAE48Jz1o?=
 =?us-ascii?Q?3PNo+yZQDuWAP2YnQfYvvtIIW+QlCcEuMN3nRv2t4ZPW7NsdhyIGMeYR0hko?=
 =?us-ascii?Q?QsWru29GcHh3U8ZsY/Ijo5+aFwdJbTgibWOk6qPQ4RPHmw7U1MoPgHgDhZ7M?=
 =?us-ascii?Q?LUYuouraaXqBIbucybELbUt+gudiAyonZfrdsnkLZ+F8TNjE1DMVj8hRj7bS?=
 =?us-ascii?Q?+dQunYIrLbLh8tmj3MBs9ApmTkyE6frP7yYtLw1kSVIsJEu9M4rQCrb0hyP8?=
 =?us-ascii?Q?/rBYFAviryF44MOPtqBc3eQwFYwkyes39U/Os9DNPDRQB2f9TfhJajwKRfgy?=
 =?us-ascii?Q?bnTZduYDY/q3rYZh978WH0/JWtAKRUVp5fkPQsZVIvs8lVFk60EPBwPOxh/e?=
 =?us-ascii?Q?/FHefyy6IAoyjCvGA+nSRNfSAop7draDeiQPfXIEHaXCXo/ZWCA5eS0MFWM/?=
 =?us-ascii?Q?qj8yKkMdoeTui7fZx9yfiNs4YSmE66tPAHjb04i2+S5a32Dye0O3JvnfP8Ai?=
 =?us-ascii?Q?ybdNJTMYAXo7ImF+Gwk/dpDaXMGTAP5KTj2752eJDiCCUj8sRAy5M/OBbM1p?=
 =?us-ascii?Q?IWqAdBo2DK6O/N0JqprWhbhfD+GOW2RD5CLJwb11CFi4zVXPTGHffg52qPnH?=
 =?us-ascii?Q?y7aIuDCj7m+c/4hKaHp8eHVDi5gfMDDNe7Prji1/zPC1JsvTRI/4B4shf1MD?=
 =?us-ascii?Q?kxLmW95tMJTky/jf4A12NBu3Qiewa8Sc80997UofOKP7WxR7anDsV2FD62Rn?=
 =?us-ascii?Q?sgTypr43/z4Td9Qi7cRy1EHq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08c9dec8-62f3-4aae-6552-08d914eed771
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 02:37:10.1629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QUZReBoFmZV0VPBig1Y7NVNgj8BGcA2XyPLXhwEzxO+tndIFi0QD16rsrnKT0fW/g017phAF0PAjD9uaHN5ivUWxyfjB19TuS6gxXaz32xk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4425
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9981 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=773
 adultscore=0 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120018
X-Proofpoint-GUID: 0WtNSddFNVaYI3KA_96f_Oi6IbWaRzOI
X-Proofpoint-ORIG-GUID: 0WtNSddFNVaYI3KA_96f_Oi6IbWaRzOI
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9981 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 mlxlogscore=962 mlxscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120018
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch# 1: Renames 'nested_run' statistic and increments it from a more
	  fine-grained location.
Patch# 2: Adds a new statistic to show if a VCPU is running a nested guest.
Patch# 3: Adds a new statistic to show number of VCPUs created in a given VM.


[PATCH 1/3] KVM: nVMX: Move 'nested_run' counter to
[PATCH 2/3] KVM: nVMX: Add a new VCPU statistic to show if VCPU is
[PATCH 3/3] KVM: x86: Add a new VM statistic to show number of VCPUs

 arch/x86/include/asm/kvm_host.h |  4 +++-
 arch/x86/kvm/debugfs.c          | 11 +++++++++++
 arch/x86/kvm/kvm_cache_regs.h   |  4 ++++
 arch/x86/kvm/svm/nested.c       |  2 --
 arch/x86/kvm/vmx/nested.c       |  2 --
 arch/x86/kvm/x86.c              |  4 +++-
 virt/kvm/kvm_main.c             |  2 ++
 7 files changed, 23 insertions(+), 6 deletions(-)

Krish Sadhukhan (3):
      KVM: nVMX: Move 'nested_run' counter to enter_guest_mode()
      KVM: nVMX: Add a new VCPU statistic to show if VCPU is running nested guest
      KVM: x86: Add a new VM statistic to show number of VCPUs created in a given VM

