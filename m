Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F251323F8D
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 16:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235091AbhBXOL6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 09:11:58 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:37966 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232673AbhBXNcH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 08:32:07 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ODTMUv160548;
        Wed, 24 Feb 2021 13:29:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=iys3HEbXDXRkK+VKVQuM+F8FtraW1Rp6yixwV/lQN4k=;
 b=d1wmejH0Locuner3Kxga+Zmv67k8Oseez1Or0BFaNSYa2r8x3iDCGl53NqSfP6eihq/g
 aG7OdOWraWGhigBlTWU+fMkmT+eCNVGsUlXqXymCjEKumM26dq6HZXL0KgIudYtJCALh
 moxy2+Qu8Vn+h0FAHXf2F0FnOdyJTHGXIVivsUjS39YqA+vYBGIcq5rjWys25DCU1/A1
 k3XnPglvfdWQwsisuTTdOp75qtz4FyGmLWuuZh7EDVg4knFVKg64Ew0sdl7ip8aSN8y4
 RFfZv0JL7ceVPHmFEuZHjdF9iwiBkr5RRUn86pPoBCbZWyWMEhyRi5DXR6dIcvXSYmIB Lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36vr6258dr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 13:29:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ODOabE081658;
        Wed, 24 Feb 2021 13:29:27 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by aserp3020.oracle.com with ESMTP id 36ucb0r5ts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 13:29:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CW108FDxX1Kf3WRRXFUn87qDUqKHHB5AggVXaK72r4HQ+YY8wntHbVXLtUk9OLGF7pky+Hw0znTuFI5mgoJnWzD0Axj7+gQsUPQqXbTsnQiSpB49h4CG1BdN/ow8ovvx92mr7jI5as8Ap65sJ1QQ551xXRWASAru+7RLFSETUsfSpC1yIZM0fQEUVJtKZlvEaShYvyRIG9FYaC0UwztX0PR75z2qSNEe5XrJCblgMOqxkPh6HgFuc7ltH8VvLn1GitjbY0c4eBzGhFMrQkFfXI4M6F0W5OoaHU8uSWXkhF3JCMAJK2eXGMmecD5iu0VMRQJUwA4ZtfBuRBU8R2OTSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iys3HEbXDXRkK+VKVQuM+F8FtraW1Rp6yixwV/lQN4k=;
 b=gKdfc1GP6yvxWWyG9KDiPPeD191QSSLEjihXq4yZWfKWByslYfwpTt07l9LfORwN8o+VB7hwvBK+uiKcHI/3aszQenxxHtsEsEiKz2pcvfXufL/admCl5nIJzAGgTEt5tBBFRMm9G1lEu8DGA8KDi0Y925XrCyvI47Qdr7irjCwmmnyhw0yLKPgNH2QRnhRQY0yVoBS/hBzcfSWWc9hvzWCf1Rr5nHkxVDAtFPi9+wQHvwYSV/JSJTvIoRfTqNDvbtxf8NG6nRWzdmwz4sHr3ATVhWU8mE4wIJACXancab+r1SV6/cnm6nV8zG32U+hXX+UmIczQhECTH9zsZXNy2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iys3HEbXDXRkK+VKVQuM+F8FtraW1Rp6yixwV/lQN4k=;
 b=qGROGt9jouzWTLFlho+2pgL/3KgVNLm0+a6yGrNWm6PwnXSsTKIfjiwEBgKfN/ZjbqJeIxJpVEK3l+kQ/WMnr65C/Jq8cHo/Ih5gS5poQaGRaj8r7h38JNmc+dllXKjMfjQ+t11GQSxt5GkDyRr9k+kkvuvtQgijQ89n0n11D68=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21)
 by DM5PR1001MB2265.namprd10.prod.outlook.com (2603:10b6:4:30::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Wed, 24 Feb
 2021 13:29:26 +0000
Received: from DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934]) by DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934%5]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 13:29:26 +0000
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH v3 0/5] KVM: x86: dump_vmcs: don't assume GUEST_IA32_EFER, show MSR autoloads/autosaves
Date:   Wed, 24 Feb 2021 13:29:14 +0000
Message-Id: <20210224132919.2467444-1-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:8b0:bb71:7140:64::1]
X-ClientProxiedBy: LO2P265CA0155.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::23) To DM6PR10MB3148.namprd10.prod.outlook.com
 (2603:10b6:5:1a4::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from disaster-area.hh.sledj.net (2001:8b0:bb71:7140:64::1) by LO2P265CA0155.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:9::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Wed, 24 Feb 2021 13:29:23 +0000
Received: from localhost (disaster-area.hh.sledj.net [local])   by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 0a7b5d02;      Wed, 24 Feb 2021 13:29:19 +0000 (UTC)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ed5ce97-13aa-4200-34cd-08d8d8c83436
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2265:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2265536FE139D1353C8ECAD8889F9@DM5PR1001MB2265.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +xl2N8wZ7A9gXo8KqeQEGluagqHVxcsZ0t7Yls660GPckvDriQ8cVBc6S5SDzbouPcwCznJG+gkTmW5XdnKqa1cvosAQkDepuVKYN3a7NxsNmaiHfF9zKGGxX1Ka3q59wz6V8MjX9wBs2I4FUvqyAQvwmoviklt/fpRy/GywYDArGPvgDVRfkCTAoZtSNByyZw3wvBaV36kEoH94XU9fLXfZlOf3ru+OhCyn6AdCCVdGUAmqnMYJEhOAJJXmSvAILAHcs2nbSWFk6KSSMEtUa/CcCOjMC9/mYhR7ndSAe6jj7g8GSu6lSLDrpt9rNAOdwEW526weKjAg40Als2SU7XQ79rJh5g9Gs7nBmdvaXAKn8vFF4f8atzme9/QPaYfM/C3cCswSRiDwe13GB/kWbL53EuDU0KvTraVqiuCiyMLxAiv0GfN5F/g/N9YQPm0CaoxagTcYBjReAZlFlx3++Se5SGjKHfDxvGPFd8MQn6zW4l0G856vi+1ZH5mkBvllKsUedN0uiiMBjL7FM+Imhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(39860400002)(396003)(4744005)(86362001)(4326008)(54906003)(66946007)(44832011)(6916009)(2616005)(36756003)(8936002)(7416002)(2906002)(66556008)(52116002)(5660300002)(66476007)(186003)(1076003)(6666004)(8676002)(478600001)(316002)(83380400001)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0pmjoQPFFcYRcp9W7sxTsKpZgW4j0WZqeQeQNqdH8HGeP/GtoDO6L3E1Kwk/?=
 =?us-ascii?Q?wMFo5GcHhP1o0ug8t9nGTtu0vKY2dVei1yuBpW/XFXz+Q3Lt0sHCY2szPWEy?=
 =?us-ascii?Q?uNdncQvIIcSStmzXtOuyKuFvfRyqmavbR21n3kWTTkmRV/4iNIFmsWvivs3v?=
 =?us-ascii?Q?9aoVKWNDC/AkizI9Q5lGDJowhrS9fCOe28BjFVq8XwtuuxoLa5z1H+eMF1yk?=
 =?us-ascii?Q?iKm9D6W1AzGfeqXyk/R6SMdfupzAAnuoJLKBG51qiwfwjZnIXrBbAFLo6VkG?=
 =?us-ascii?Q?N91gGbAvUP551U/RgahTzQzSEqUv0rfM88hRXPucOSqJtOmzlL2JG/IPcoAJ?=
 =?us-ascii?Q?4JRcY55QMc4pkqs3NcFJ6/q0Gv2Tss32YWFR8u7BgudbCqEnN8nJ+RjcGyi3?=
 =?us-ascii?Q?pvgSypY8oH2YSs2bpvRXA36w9R8QLSxn5MqzjyWlWR1wVJNhaayyLrbhO7UG?=
 =?us-ascii?Q?Y26rKe/TlxPm9ep5OSnDYZi/lzOFr8IoNKaF62/gAt7QDvUho1k4MMWF9oum?=
 =?us-ascii?Q?bG3bVRtxo4c6k5Bq3S4dTPiXWsjp8knwRez7BnNOQYJJNS872ySzMBQY3QCz?=
 =?us-ascii?Q?ZDGcAZYRyQ/YMKImQAqWn/nbF+SClyyFmGIWa/OKmzLZf/WH+8uvZjBricpj?=
 =?us-ascii?Q?ATD33x9oz/2EkHb5KtXta6zf/hJLLA5Jwo34rmt66Q8EKMhlGTsDVruRdcef?=
 =?us-ascii?Q?OVi36AfDVj7bz3DRKTQCyCsGQM9xYEo5vG1bH1bEGJLfzp/Dw+PmTReMVs2/?=
 =?us-ascii?Q?n2qga5KcC37QspV46Bq+SJWl2WUJ7l81OZXXHoTzvkOfnmIb6GEDQTYLSYPb?=
 =?us-ascii?Q?APdlWwQZf5sZXoYhQuTbKiIXSk7AV7DCCKkhNqylXRJ7X9murfckxNzejoi7?=
 =?us-ascii?Q?p1G9735gwsePoaU/uiEDBdB2W4uRyqx3vphsSNsQwHBFbSl/co5as9UkbgWK?=
 =?us-ascii?Q?oJJC1vW/hlKN1c9hXhxilewkvqtuT8s8k3Q9r4h1ZNWAVpMq4s/YIJXMQ6vI?=
 =?us-ascii?Q?OI3PsBu6y5fqDIcr3C5fn0E+/ZhngazMaFBMwsoEmosBYl9/Z/wOpmF+YLMm?=
 =?us-ascii?Q?5pzaLCb+hKHaCTEyU6tAAFTZf98/qBeQ+oQhzxD3CB8sosLeuw0gH2CuM/Oi?=
 =?us-ascii?Q?MOzVBTNliq2ui/WIzC7xGizeiyIUG3M/2bFrTNtfW88eIhtuwl30UFZDYf20?=
 =?us-ascii?Q?bl5PbnqDrSINHUwazHx/r+2qRzyNk6PEBUHc76i9VpiRTQgQ15KhddEI6a5X?=
 =?us-ascii?Q?mQXMwWww0p+A/HZArwDQS0s2V193RKte01/VWj0ZG0aouAb5rcoKwf4rUemE?=
 =?us-ascii?Q?8QlY+ard5iOF+/8866Xh8P/jPF9WNLzE6dIH7dXg8/HHrg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ed5ce97-13aa-4200-34cd-08d8d8c83436
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 13:29:26.0058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UUcDlsaF+Ums4X2LKNp5F3q50dRh0lBYVLbjJZnj9gfiwZdJGUxl6M0f3H0Y11CK60UxrbXfY3ab+nbEAKQUPWayHsUhZQkMpI/OY7hU3C8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2265
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=728 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240104
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=975 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2:
- Don't use vcpu->arch.efer when GUEST_IA32_EFER is not available (Paolo).
- Dump the MSR autoload/autosave lists (Paolo).

v3:
- Rebase to master.
- Check only the load controls (Sean).
- Always show the PTPRs from the VMCS if they exist (Jim/Sean).
- Dig EFER out of the MSR autoload list if it's there (Paulo).
- Calculate and show the effective EFER if it is not coming from
  either the VMCS or the MSR autoload list (Sean).

David Edmondson (5):
  KVM: x86: dump_vmcs should not assume GUEST_IA32_EFER is valid
  KVM: x86: dump_vmcs should not conflate EFER and PAT presence in VMCS
  KVM: x86: dump_vmcs should consider only the load controls of EFER/PAT
  KVM: x86: dump_vmcs should show the effective EFER
  KVM: x86: dump_vmcs should include the autoload/autostore MSR lists

 arch/x86/kvm/vmx/vmx.c | 58 +++++++++++++++++++++++++++++-------------
 arch/x86/kvm/vmx/vmx.h |  2 +-
 2 files changed, 42 insertions(+), 18 deletions(-)

-- 
2.30.0

