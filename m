Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6A74112FC
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 12:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbhITKkF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 06:40:05 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:26496 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229961AbhITKkD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 06:40:03 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KA9Yol019643;
        Mon, 20 Sep 2021 10:37:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=vithKDo2VFSl81SD6AdLXlgWjGUhsSBZdC7LdS38OvY=;
 b=gQYDUIQPZaoQeOPOJkfkvrosKBQufBhdwaccuppi6/1e0+io6RzVyZL4B3QPYjfSQX4C
 M0MHIcEFcDqKQakArjiQ7NEY4qfwHbYwmTcqmHuGIGbdQ3Rwg7q3nKzPDI1iJcvt0gm7
 c/EgpsCwRZfBDMtX47Kwz6pzy5+vFtqPfYKgjhbZVBgQ5FlTsrmp4Q6SEjCa/EwN0NGE
 i0PG/rN8HW63a90ahhj1NVLhXn1K0UkgAihbtDWvRtKpzkNQlbvk8slmYwJG/tEwmQO2
 q9y7iJOXeGekLfVR8WCcAZf8vvbAzI/5DjDJ/X62RSrGQSIn0fOpXXtPNg64Qyj0Sac7 Bw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=vithKDo2VFSl81SD6AdLXlgWjGUhsSBZdC7LdS38OvY=;
 b=SEwSQHs42uTWiqu/v2YBMveaBMLQIku47UDygNgWmlEwEfCcm+MJoGSPBtnHFGvm96Jk
 Bey/WmHhHimVkjIv0kgkNCbP867VrfnUG1in29usQsqQKCgHD+4y8fonCGxj2tVgF3uD
 4pGh1lphp0mSWUxzYOejFIT5pimi41ncycFBYaZJpDmZ2WhuMEgccRuYvQTSuYON6R0d
 dXJE51RuEgRZfsPBEu9f5q9jqRSgNpQwLVzYmMaOyRr8okBS2TV7lwdf5LNTtSnmVBBJ
 MMCPCZKVJauBHLg/WCTjzapWggLXYrioEiI+BG7piOlajDaw7NacvVuvkUC0vcl7/5to Ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b66j2huxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:37:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18KAUiv5172928;
        Mon, 20 Sep 2021 10:37:45 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by aserp3020.oracle.com with ESMTP id 3b57x3urmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:37:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lxqJtpj1BcHQKDfKi7OoZqNABE2xCxbGzPjPtyjQhbUDdAnYQmmj6LNd9UoPJgZovFLtL+WgjT4kFjUdEl7q3KAuMh2hL8O4oZYMd+jWBeXR90VXW3zwk2vvQS98PBz73lKu/I8mvUDoUfnLvGZB+hzQyW7jhSyJYhitfi7deMFYuAtl9VOnVc7RcUu2gqcFsAGnj1lomsZ0dpMufNBZhTJ5WSlF4J5APq5b3pIayD4TRZRqSR5x4Uqm5haMAf4ehnTzzg6zNbUpiI9eygP0d91CbhjGhUBLXRoUIllRjZ5CF6lAuHGSFzMjRWtEzajkoL6VjafkbqBA5xt4PdczYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=vithKDo2VFSl81SD6AdLXlgWjGUhsSBZdC7LdS38OvY=;
 b=nsZH6xgqa8inba9eKFhxBshjWX/AtX757zRA2bee5P+TZNaKZ8OT5Z2KA6NDAdJu6aN2ay/bK9ZBd1jJAnZYsnvGAwolWBRnzAUb/fktK9Wrcip1gfXMzMKbMFtqfkRhrIsBTtpRck/L0lrfb5aqvurVgKEtdxWlR4Wsd439fq/i9F/nFrlyJuHJZfMnl5EI5iodFRLSY9r9tXDtrmNwEDyBpZAegM+woK0RAU6B/IeBQ4w+a03zQsC3fGUcyay7SGEmLE8n5nRwZJMSKz2PUFvCgu+4JvFR9WrInbnLfFYmlPLy5pUNcDToChUFk3LUi+I40Ba4Hq/4krPrr69PFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vithKDo2VFSl81SD6AdLXlgWjGUhsSBZdC7LdS38OvY=;
 b=HL9+1HpVUssFVlffNnrNyzzZ4PUtgze1fYjXQ9QHed8zAbSRr/YEgwfol3ZdIR+6WrUJ98KN6i+acMsX4RD8GZOIcD8kBUl0Q52HGlEYFPs/7iTR4JdrlID695hmI/slp1B/tYKex+2WEZiPw3dzkRqvag5b0TVB0jWVcLGo9JA=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21)
 by DM6PR10MB3308.namprd10.prod.outlook.com (2603:10b6:5:1ab::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Mon, 20 Sep
 2021 10:37:43 +0000
Received: from DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::6124:acae:c33e:1708]) by DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::6124:acae:c33e:1708%6]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 10:37:43 +0000
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
Subject: [PATCH v6 0/4] KVM: x86: Convey the exit reason, etc. to user-space on emulation failure
Date:   Mon, 20 Sep 2021 11:37:33 +0100
Message-Id: <20210920103737.2696756-1-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.33.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0036.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::24) To DM6PR10MB3148.namprd10.prod.outlook.com
 (2603:10b6:5:1a4::21)
MIME-Version: 1.0
Received: from disaster-area.hh.sledj.net (2001:8b0:bb71:7140:64::1) by LO2P265CA0036.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:61::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16 via Frontend Transport; Mon, 20 Sep 2021 10:37:40 +0000
Received: from localhost (disaster-area.hh.sledj.net [local])   by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id b10e74fc;      Mon, 20 Sep 2021 10:37:38 +0000 (UTC)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e10daef-d384-427d-ee7c-08d97c22ad4c
X-MS-TrafficTypeDiagnostic: DM6PR10MB3308:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB3308127F1B62569286C6EB7988A09@DM6PR10MB3308.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8TIbTYA0nZiQLHWfRcyfaCCZ8z2czVd0f4ebxcgFX3il9mfkP7P/RN3mKHNt0OzHiPgtT8E9NsiaxJbyxTTIXHTOesHS4gWB6DprvVWVVTIYV/LSHjCbVj+E0CbnZhofLGbwe7Jh9Xt15vhxE91QY89qz7xylG8cmo22IXp3QGk79aJLdpflBJraaUDOSGxgyXwbm/BWtUm3kjzDFXlYT95lEUbX2Y+bKXnRprpUCg7/mX/bYEQzjS+ufYwjFH3AJe5pcBinwJJ7/vEpU0b0HhzJjLMhdViKw5A1x0CFju1Mc+6uYqLnmVCDZlQ1N2SjXQoxrSd7ypsOjCM0/Rt9ccI/bURSeYHvdXFKhZ+IjsU25jnHnQL3MOPF02ZL0YQBTGGAi3JPH7D+uE3Z8pgv2txizUn0O1xuotSyIM6DtkcTy2dZMfsUptAH6k3YlqBLj7yEi8EUCK+HiFgGVgu9q7vgAKkFYvv7OMRG35mN7XhMw4rlepkzw40kWPmUE6d0+jFSL8+jqJ8ovvnE/nUKZlRWz32Irs03olfeEq1SXTo4fP/qgtm52BXxcDkq3Tx0QXZiWv+EgKzllRa8EQ5y5TpUzgYv1MfE07LSo/GkDeTvDKLueIkBsczmIwc3PvXxXl3dFT2A1A/5oRmVUTwHmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(39860400002)(346002)(376002)(44832011)(36756003)(107886003)(1076003)(8936002)(7416002)(8676002)(83380400001)(186003)(4326008)(52116002)(5660300002)(6916009)(66476007)(6666004)(66556008)(2906002)(2616005)(316002)(38100700002)(54906003)(86362001)(478600001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cVkbySU9gCVZTQeqqeW9+wJ++/vwQKt5nFuLqAcq9CESydguvGpfeGmGL2sj?=
 =?us-ascii?Q?NoFlwwL7gq4wJAN7slalO8+/yhLNkIIlJO9nZOJID5dB9o1+Ou7ya4JfbGXP?=
 =?us-ascii?Q?b2qRaYZBmsVTthws6rbxZ2O4kw8awzD1VxhNW6JrfQEiUpx4nuxi3RTzPQh2?=
 =?us-ascii?Q?8GAk0TOYGegU5SWvd54hN357VWWRqNdfGv8M0x/ogLlYzVuqwDyKiAZkmOoW?=
 =?us-ascii?Q?Jt9oDv1BsRELr6d+qg5mdUBko73PTc93sFSjU+XCsf1xbWK4Zn+tFmEgu5Qp?=
 =?us-ascii?Q?nGC6XGiUeu2eg+WVSMkKnGx1fqq9jXI/9v//8K9aWlrIQsXKPYRasMEsYkD2?=
 =?us-ascii?Q?6o8KWd0/CYW3+poaCRt8fyO7qA4u/+MkB9Crr3WkKVOKfQXpWDo7/TX6bMlM?=
 =?us-ascii?Q?lbOI4hR7znuAbIi2KEJ06nCH0bcjDwqII6dckN2pDUjJeGH/di8G8i3X2iHA?=
 =?us-ascii?Q?o4c7m5NV1LioBiAh5ApDBSWyeycrsigrl4TK/yCuNuzpiv6lcC1MmF6X9ATu?=
 =?us-ascii?Q?/nP1sH77mJEgpj3S/u9Wp1d0Kq4LlBUJAx/Hs1KltVn86Wm5xjJFWiU/naPu?=
 =?us-ascii?Q?tMRoDydUVPjmPdfyjO/8aM/naiVv6+7Z1boTKPoEjHZLTeIDlsQnDN8aACiC?=
 =?us-ascii?Q?aUve4e1DCjxX/KlbNW5RYYveIvaqjGNAL+15ZAHdAFvVPh3FOC40RnAHKCz9?=
 =?us-ascii?Q?+ItrWv6BXGYiQSUsddJ08cTMs4kDtEqVl++OprqJsbLovrxorZ1OltKlI/SZ?=
 =?us-ascii?Q?B/afqTUnsKNK1/84y4GnWkHWY9UK/ez8kzqADiyFvguDwtqs7j/+KHVGnIbw?=
 =?us-ascii?Q?70zBo/68ZX+ltG4aXTJ5oH9ECd4o0ICP1vu3UIWKmgyTKRS+MPosCcxBc/M/?=
 =?us-ascii?Q?w9XqVE33XCsACCl2sAJ/SP2hboAqbgLYaCpbyNwW0aRmmzBV2LysGFOPjlvt?=
 =?us-ascii?Q?7aCSdBNSjkwNV3IQ1xSNXVBUSQlMrlAmyZ6r90ICr3T10J9kPyO12cZChp8y?=
 =?us-ascii?Q?9gx/QL4dc+TykTcyrEnxKLoLKr7pHWY9qHCX+bPVvOorgncnCfO4ztsKkzs+?=
 =?us-ascii?Q?s0AJEoGMHGZUFoxI1mz+y7DYKgDLxW1IsEA+yJgt1zPUXqaGDmsxqY8Ewvh8?=
 =?us-ascii?Q?T1NhqU6BpCFYYc/f8+JH1oG/02oXWFzJnY1f4zPduiKmbFzSkQ/DynabbXTN?=
 =?us-ascii?Q?pbqDZOR5M6yuDWPOyJ3QE9ZJCNqPhSxrcEQrCCTYPJNEaG6Tj3T+jSIH6f9C?=
 =?us-ascii?Q?8pRZMc6SbkkK7ld1ABS9kPYXYQ0TKPQNI2f0oZaxqfG718ob032EnCnEndyf?=
 =?us-ascii?Q?COGc/+f1CbTt6NbbKDY7vhyvMoHOtFiWAximqEUuWjbMBg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e10daef-d384-427d-ee7c-08d97c22ad4c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 10:37:42.8927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pzqbb3Z8ZNa5wMCoM2wA8mmPf/uScuLMJk0si7YHMwm8yOo1ymUCLdW4rip1b706FybGVOlnVgCKZTfSZ/q5sOqE5YzgnAyio0Vl8uTcuy4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3308
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10112 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200064
X-Proofpoint-GUID: C1wx8IGX9OK9k0qQKft0DpOk42onTA5W
X-Proofpoint-ORIG-GUID: C1wx8IGX9OK9k0qQKft0DpOk42onTA5W
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To help when debugging failures in the field, if instruction emulation
fails, report the VM exit reason, etc. to userspace in order that it
can be recorded.

The SGX changes here are compiled but untested.

v6:
- More Reviewed-by (Sean).
- Fix "From" (d'oh!).

v5:
- Add some Reviewed-by (Sean).
- Build-time complaint about sizing rather than run-time calculation (Sean).
- Clarify that the format of the auxiliary debug data is undefined (Sean).
- ndata_start -> info_start (Sean).
- sizeof(variable) rather than sizeof(type) (Sean).

v4:
- Update the API for preparing emulation failure report (Sean)
- sgx uses the provided API in all relevant cases (Sean)
- Clarify the intended layout of kvm_run.emulation_failure.

v3:
- Convey any debug data un-flagged after the ABI specified data in
  struct emulation_failure (Sean)
- Obey the ABI protocol in sgx_handle_emulation_failure() (Sean)

v2:
- Improve patch comments (dmatlock)
- Intel should provide the full exit reason (dmatlock)
- Pass a boolean rather than flags (dmatlock)
- Use the helper in kvm_task_switch() and kvm_handle_memory_failure()
  (dmatlock)
- Describe the exit_reason field of the emulation_failure structure
  (dmatlock)

David Edmondson (4):
  KVM: x86: Clarify the kvm_run.emulation_failure structure layout
  KVM: x86: Get exit_reason as part of kvm_x86_ops.get_exit_info
  KVM: x86: On emulation failure, convey the exit reason, etc. to
    userspace
  KVM: x86: SGX must obey the KVM_INTERNAL_ERROR_EMULATION protocol

 arch/x86/include/asm/kvm_host.h | 10 +++--
 arch/x86/kvm/svm/svm.c          |  8 ++--
 arch/x86/kvm/trace.h            |  9 ++--
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/vmx/sgx.c          | 16 +++-----
 arch/x86/kvm/vmx/vmx.c          | 11 +++--
 arch/x86/kvm/x86.c              | 73 ++++++++++++++++++++++++++-------
 include/uapi/linux/kvm.h        | 14 ++++++-
 8 files changed, 99 insertions(+), 44 deletions(-)

-- 
2.33.0

