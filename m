Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48E5E15B672
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 02:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbgBMBOg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 20:14:36 -0500
Received: from mail-eopbgr690055.outbound.protection.outlook.com ([40.107.69.55]:14308
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729185AbgBMBOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 20:14:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N6mPqeqcddBagHbkdT6WcaCBtwrqmDpH/FaEmRj59lA2h58Y9/J+nJftaT2iL3thhrL41f2sUgBOiIahU0ytYaWZgOxbzgA/vAARFKt5+ECoOayKXUWskYhzNUkXxdx3e5aRnahcSwMjm47gkQrUznLLwyRhxEEg7hBspmO6oLFYHQIJm+0SpPjBHIy7nhoCJZi0wSbhxRiDfIWV0xasUC4nypoohyEEZi9b+W1dkof2nlpFvE4cxSLpd9nykNQOFDEQbjYIdTDQ9Lm8otJyH+YqjHEjpjB6Uwl0FTaZ9TlkmIGDKlsqTtryDZR/T525ISYXbgYNaXMRD/3Cv+YDPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xUhLNk/HS8C0w/YLxqkrz2cr/0fmX5874CDvWcMk8V8=;
 b=kUxwIC6oa3oM/PCmrCvMLbBW3As5VEgbl7FHsXXo9wAevRHX1klllpAx1l+Zsq8vWpo5MkO3gAC59qn9kiCt2rCz+IwryEBci6EuqCCwfwBpy8C79X9NY9ovsinZ+r9zIZS4Yltut1VV1rQELYiXyWz6Hv0wd4/5dbejm0U0Jpz/RyXBsEzpUQ571AexkfKWApg3LNI9IF8Qk3ZHhErjPlf4AX1xJ+RkJF1h9pgqtcF2+82EAgXAHLWpLIbnEOB+f+mCt73Km1qHv0P82i4zXeDF+ZermlWmh3B/r0ZFj7UQdhsSIoYLgy1AsX8t52kO0ho+0f3n8yvJ68pHMrTCNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xUhLNk/HS8C0w/YLxqkrz2cr/0fmX5874CDvWcMk8V8=;
 b=GyFoSumQRb8qkXg1mzSBFFNLNYQnX4z78YSU8MBRycx1NhzRYODNlzcnslcjAdUzKuwNeJS9wY1U5Z7LgJkgFRjjwPd38ZgBOD7C+CO0aZ1ANM0nvW3xZ/0Ge2W9nlHw56Qt4IM5G1mZdRqqQou0CO2doLFK957kSyNF9OQKJZA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from SN1PR12MB2528.namprd12.prod.outlook.com (52.132.196.33) by
 SN1PR12MB2366.namprd12.prod.outlook.com (52.132.194.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Thu, 13 Feb 2020 01:14:32 +0000
Received: from SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1]) by SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1%7]) with mapi id 15.20.2707.030; Thu, 13 Feb 2020
 01:14:31 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, rientjes@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/12] SEV Live Migration Patchset.
Date:   Thu, 13 Feb 2020 01:14:21 +0000
Message-Id: <cover.1581555616.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR21CA0029.namprd21.prod.outlook.com
 (2603:10b6:3:ed::15) To SN1PR12MB2528.namprd12.prod.outlook.com
 (2603:10b6:802:28::33)
MIME-Version: 1.0
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR21CA0029.namprd21.prod.outlook.com (2603:10b6:3:ed::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.2 via Frontend Transport; Thu, 13 Feb 2020 01:14:30 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: eedf4823-c427-4b74-eed4-08d7b0221460
X-MS-TrafficTypeDiagnostic: SN1PR12MB2366:|SN1PR12MB2366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23662CFB0AFBEB3B7607B73F8E1A0@SN1PR12MB2366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-Forefront-PRVS: 031257FE13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(199004)(189003)(8936002)(5660300002)(66946007)(66476007)(66556008)(7416002)(2906002)(6916009)(6666004)(4326008)(7696005)(52116002)(316002)(36756003)(6486002)(86362001)(956004)(2616005)(81156014)(478600001)(8676002)(81166006)(26005)(16526019)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1PR12MB2366;H:SN1PR12MB2528.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vm5Oekg1PzDWUCfnTR0TIfEjWaJ0leaqTiRUi/Mhj29wKq6nhYUSyeanCwRiiPhgMwrXd+y/a6keh+TRlZmQVopi5nKeawslfLeyc8dXRoTglxPcbLJB2ouMDKHKDhivadEHfW6MB756832L4cTT9+h2L2B4HeHyHFxkKizoDTWfisGNAY63NEYOMc89Q6v+eWoQ3q8dCAKn/ZR+ECM/cxlAjld05JWB4sVuTdBd2pjROGC8SuDM3bHK+nOUZ/SHZDAoZSqwwMaA7DdJqLhFCg0KxreojQUcMN4rimiVq4SEsbpK+VdOph7MXzfAFb3J1oAW3FQV6SLHELCG/cFGoWdxobpvOPwZVQ32VHIxjC+fGiBO+nC2z3/RqZjAKnNQULjXNufLjVzH3yCSMvkPzpQPbw2fTQKThU0hw3wEjGjySIx9VxLlv13V/0PplCcT
X-MS-Exchange-AntiSpam-MessageData: q5JB4ccMyH2CN/rV7N2s9NF/MQrXpw6SQsJ3Ti0oHrb6MUtTU+mY15tEd35PqTk76ymEEtKNwNUnVEY0LDTYjvzXoxmaDfm1fpRikkgQjHsTLeO7px2sd9cbEeWX4LR2sr0aNr5p2IU9UU2kXNvyCg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eedf4823-c427-4b74-eed4-08d7b0221460
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2020 01:14:31.8515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9KTkE11OHu1RrD8JI+CwScZ38w1u4PCbU7xoU5WrSsK1cxHJsSkQ09spjk9cLj2JBkHL2MPcKavWGzDzgV/vDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2366
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

This patchset adds support for SEV Live Migration on KVM/QEMU.

Ashish Kalra (1):
  KVM: x86: Introduce KVM_PAGE_ENC_BITMAP_RESET ioctl

Brijesh Singh (11):
  KVM: SVM: Add KVM_SEV SEND_START command
  KVM: SVM: Add KVM_SEND_UPDATE_DATA command
  KVM: SVM: Add KVM_SEV_SEND_FINISH command
  KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
  KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
  KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
  KVM: x86: Add AMD SEV specific Hypercall3
  KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
  KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
  mm: x86: Invoke hypercall when page encryption status  is changed
  KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl

 .../virt/kvm/amd-memory-encryption.rst        | 120 ++++
 Documentation/virt/kvm/api.txt                |  59 ++
 Documentation/virt/kvm/hypercalls.txt         |  14 +
 arch/x86/include/asm/kvm_host.h               |   7 +
 arch/x86/include/asm/kvm_para.h               |  12 +
 arch/x86/include/asm/paravirt.h               |   6 +
 arch/x86/include/asm/paravirt_types.h         |   2 +
 arch/x86/kernel/paravirt.c                    |   1 +
 arch/x86/kvm/svm.c                            | 662 +++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c                        |   1 +
 arch/x86/kvm/x86.c                            |  36 +
 arch/x86/mm/mem_encrypt.c                     |  57 +-
 arch/x86/mm/pat/set_memory.c                  |   7 +
 include/linux/psp-sev.h                       |   8 +-
 include/uapi/linux/kvm.h                      |  53 ++
 include/uapi/linux/kvm_para.h                 |   1 +
 16 files changed, 1037 insertions(+), 9 deletions(-)

-- 
2.17.1

