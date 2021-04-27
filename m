Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C5236C4E8
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 13:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237883AbhD0LR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 07:17:56 -0400
Received: from mail-eopbgr750082.outbound.protection.outlook.com ([40.107.75.82]:21193
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238097AbhD0LRh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 07:17:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jLs9sngoJVM4X9Etf7HwtekW8pvLG2jQPhyLrAP6zKbW7BYXGbCK1SX0Tj91TtdYZGlmtdcUV3Ju+pEco5y91ZDcGeud4yuHKp+IPAgpKaPHVc9h/A1BuhwdGNHlI1jvvVCwTcaHpQ+nnBGHvvTtRMQTm9hI0CELj+rc9IHsIRoAbrBHes3UIfs+dDbqtWQyQUuNt/aughPh4FNDzVjaE/6Tc3RhL2QtlmzuvLE7u6583tLavOW/99vym1Rd3CdqFtxlPwiXKtP2/MQccR3yy9Z5P81k9qlJDEU5787aRUE0c2v4OCj138cjhuPFY4vtQo8I3TaiWdYFI//wuU/Mng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JvPH0fI22wBUZMMSlZxQodwdd8QP7uYw63eep1jq+fs=;
 b=aD+5SDDIFJp1ziRZ6MKktcyM21ezEWN5auWCFOYewDri57mp6/0+OOR2UxMjGkuQOmqIpC1HcrRuBKSnbbUhhMuQ/wGI4XaCwiDXkcXmlC6rNGeA667OErVz03/8K4216fOjgSYmMHoNh1o3nnlrZtf2+KMOLos5Lnd3Gzg6APeOVme7wC5+mxnv1tvXZ12K6/A3t0Vze42+YsTKPeACqfwWrxM+KN2jYuz6Uk1ZW/di+TzGItyNWm3oMf9/UKFnGZ0STHSLCga5h9+de8TfXyS8xgVYJ0vDr6J1JDWnZyTQYRXSupmCCryva5/9aY7woYRSIItp2i3f6es5yd9MHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JvPH0fI22wBUZMMSlZxQodwdd8QP7uYw63eep1jq+fs=;
 b=TNptPs6wydXDH2TtXqYj+iYbRGm9P1AvCgdZnlXdX4YmZQG03w5OZFs+1DayX1ANDrAVzSKL1pE7PCb/nBmOZ1KbNEWz37ZSiuA5CU3yydmdGmKmghDty8MGg7qHNKd0oNeRIy/Gw08AYTWmR3bv2OaIxn49kU9oDLs3TbI728E=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4432.namprd12.prod.outlook.com (2603:10b6:806:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Tue, 27 Apr
 2021 11:16:49 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Tue, 27 Apr 2021
 11:16:49 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH 0/3] x86/sev-es: rename file and other cleanup
Date:   Tue, 27 Apr 2021 06:16:33 -0500
Message-Id: <20210427111636.1207-1-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0201CA0054.namprd02.prod.outlook.com
 (2603:10b6:803:20::16) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0201CA0054.namprd02.prod.outlook.com (2603:10b6:803:20::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Tue, 27 Apr 2021 11:16:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 885cc2cf-997a-4ded-8b04-08d9096df395
X-MS-TrafficTypeDiagnostic: SA0PR12MB4432:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4432FAF700438398D9A4EEC3E5419@SA0PR12MB4432.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PYlWMFh8Zaftl/7ofBKmf9qtPHH7qYT4ui57bj+voZExjNJd1+MGrq/M7A968Ykg1VKlYSA4qOHFS3jw8uZKEfBIQkQldm3g+C5rc9jh2vByjEW3kF55nxeZu2NgNzVKbMKVRdtGj8RNfQ8EpBgD41C8etgOV/jbrWVLJwt7qFxR2M9GL+Q+YnZkxibcVC0I/VbWj1VKCundsaHEx+f6e+A7+oF7FT0V6cRLd7619ZJAtoMAWYFHMKguT9aCoa7xL7+DHk2qEZOuP0t/DNai1f6aFOY4n30+UQqHvkc7k0M5qyVWzTd0KiCUSKjKtk7XXXWz8ruyrRlFpsHeVacKONom66DPZ9Ygt6XNkzWToTqRZ7+lhLRbZYf0EVJIr3WupUYlQ7nWaHVtPV6NwIblW5KW33r2kOZ1kmHJQe4jW4UJaBdEn4Yzah6DdsPRgiP2KoaWG0ngNPiy6UOczvI1w0hRN9lCBzubaqYAl7QAh7IJ49/LDT3AY1Q385DAsDCLKbxKRX3pHoWJRRZ+ilghzb9oolj5IGNNyZ8lfcQ14ugkPw7DCJSgC+0RvvtUYsAC7IqyeI4u/YCo0sCl3Tg5zmsReuD/tZVnkkqW3635jq1PxMpJSXULV47sVXhURO1a0ApqmeqC1XVQFqophU9FFb6hqkBq4u+Vxx3Okb6Rg3I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(366004)(376002)(39860400002)(66556008)(66476007)(5660300002)(2616005)(956004)(478600001)(316002)(6916009)(66946007)(6666004)(44832011)(52116002)(86362001)(7696005)(1076003)(36756003)(8676002)(26005)(8936002)(16526019)(4326008)(2906002)(6486002)(83380400001)(186003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5m4N7Nkf/cI0NCv7MYclmYRZUjJic7mPf3BuSn/4I27WDP06TehMlmXbgmSP?=
 =?us-ascii?Q?R8ZMbWgc29CX9RCQ6046QMEPnZEstZb+4JZlWQyjUt69vsxotYJrGJU+NjHe?=
 =?us-ascii?Q?2/OTJCc89g0NE+ZwlNa/O8+boHeABsBMaTe7oF+NBOO00/vnRTGz4eWMshCM?=
 =?us-ascii?Q?zn9ob6GHKZDI9kpBO8jf2kivoJrW1Pwddpj91TaIuJAGP7ZgBn3bPgPH8UuB?=
 =?us-ascii?Q?q42FKRbhWNsvlUz/Sd2ymoe5IJfOfRUMDA+YbiQcMLqe9HUxakFJjCwVfaXt?=
 =?us-ascii?Q?77MacXeHtOOIIYBUqcdGPaP77VOChyJJP7BaBkwG3/7vgA/aU5dzCAvWk7SK?=
 =?us-ascii?Q?J6VvcqoxwSAFidnCoDQytmvX7DOymDBxU1NT7d7F96z22RS3LjxZhpxWN5S/?=
 =?us-ascii?Q?SLclT9Ur46YAmDsJjSODFPWGlOLgLASIvE3z/gxIkFVY5cHiprzp9jwfJHd2?=
 =?us-ascii?Q?9uNcHJ+pxW3z0v1R3ELwd9jMxiBOXKG9pk9ZwFvrYZ6xTnj7DcEtvbH/+w6E?=
 =?us-ascii?Q?BACcTCDV8AQs63JzSpcVASE/qJy2ijFhK5hsmd6PveH9XoB1f7qu1BjhY5Ax?=
 =?us-ascii?Q?PbCg1nxtfrXo9SlPUyAIvAB3/eJxbIj2Hf1oqKkqW2Wv1goJByktJUUkcKKx?=
 =?us-ascii?Q?7BD6QjcRMBB37YUz4XIfHheKfHgqI26fR9k/WMP0NIGtiquIJ7PPlI+Bs2TX?=
 =?us-ascii?Q?1Ocl4DWU9KfHHnBI7aoOc+ebbxem0ln3Ijp0x3FcH+frmpB5thJZif/1zD4m?=
 =?us-ascii?Q?LdFkjNNV/BdnjKOmIo0CK9tDpcCoJa9zYWfTbU55XyWI0vzWErqL9NN9ChZB?=
 =?us-ascii?Q?Iw4PEE2aW0ibYJV1goCX+M8EwTR2nOGdWndmkTf85gFNVn+UfarWWFrAH/Lp?=
 =?us-ascii?Q?TY01PMDkKTzumlKJNC1YNk/Ba5iYLHU86CX3+bqwr24L7c+pCUemo2xDVcxv?=
 =?us-ascii?Q?8UdkwQLQsf8OuLPrCB9VlFQUSuC9LBVwVKInQT+j0An58dojSoCD1NlIW/wO?=
 =?us-ascii?Q?124JKJWvKkHp0mnN+Tb/gmWXejY2vKOIBycy4KqtD4t3zQRuewPesfV2vUza?=
 =?us-ascii?Q?1jj93kCHEs6rkqdsv3GUnqDV9UhQbM5KWu9/xeM32dStmWGftqKJrcp1TtsT?=
 =?us-ascii?Q?dl3bn5GIek9qkSm/H+NUMqshvrFXsI1OmRw4rpoAPRk9O/1EdXEHA6fgPu+6?=
 =?us-ascii?Q?128ZtvmxdoS+L07lJpcrW82uTcS+rHQeIRqHS3EzgZbgho/3Q/5aqhpa3fd4?=
 =?us-ascii?Q?Nd3dSchqGqgGwJxCppcob3paXFmwIMh0DqoaZe3zNLYqpkBkDG+pe4aMZV11?=
 =?us-ascii?Q?Re26NPKgaeYXdhnIvpUA4Hpg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 885cc2cf-997a-4ded-8b04-08d9096df395
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2021 11:16:49.4213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WezU6hkagyeyI7xk3uxfS+/hbVxZ4s2gcFG0il9bVZwn+9eAvFc/SCe4zfZ9of/L8FyqFAIk34fGYBIapbAoDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4432
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is developed based on the feedbacks on SEV-SNP RFCv1.

The SEV-SNP depends on SEV-ES functionality, so rename the sev-es.c
to sev.c so that we can consolidate all the SEV support in one file.

The series applies on top of commit (tip/master)
eb4fae8d3b9e (origin/master, origin/HEAD, master) Merge tag 'v5.12' 

Brijesh Singh (3):
  x86/sev-es: Rename sev-es.{ch} to sev.{ch}
  x86/sev: Move GHCB MSR protocol and NAE definitions in a common header
  x86/msr: Rename MSR_K8_SYSCFG to MSR_AMD64_SYSCFG

 .../virt/kvm/amd-memory-encryption.rst        |  2 +-
 Documentation/x86/amd-memory-encryption.rst   |  6 +-
 arch/x86/boot/compressed/Makefile             |  6 +-
 arch/x86/boot/compressed/{sev-es.c => sev.c}  |  4 +-
 arch/x86/include/asm/msr-index.h              |  6 +-
 arch/x86/include/asm/sev-common.h             | 62 +++++++++++++++++++
 arch/x86/include/asm/{sev-es.h => sev.h}      | 30 ++-------
 arch/x86/kernel/Makefile                      |  6 +-
 arch/x86/kernel/cpu/amd.c                     |  4 +-
 arch/x86/kernel/cpu/mtrr/cleanup.c            |  2 +-
 arch/x86/kernel/cpu/mtrr/generic.c            |  4 +-
 arch/x86/kernel/head64.c                      |  2 +-
 arch/x86/kernel/mmconf-fam10h_64.c            |  2 +-
 arch/x86/kernel/nmi.c                         |  2 +-
 .../kernel/{sev-es-shared.c => sev-shared.c}  | 20 +++---
 arch/x86/kernel/{sev-es.c => sev.c}           |  4 +-
 arch/x86/kvm/svm/svm.c                        |  4 +-
 arch/x86/kvm/svm/svm.h                        | 38 ++----------
 arch/x86/kvm/x86.c                            |  2 +-
 arch/x86/mm/extable.c                         |  2 +-
 arch/x86/mm/mem_encrypt_identity.c            |  6 +-
 arch/x86/pci/amd_bus.c                        |  2 +-
 arch/x86/platform/efi/efi_64.c                |  2 +-
 arch/x86/realmode/init.c                      |  2 +-
 arch/x86/realmode/rm/trampoline_64.S          |  4 +-
 drivers/edac/amd64_edac.c                     |  2 +-
 tools/arch/x86/include/asm/msr-index.h        |  6 +-
 27 files changed, 121 insertions(+), 111 deletions(-)
 rename arch/x86/boot/compressed/{sev-es.c => sev.c} (98%)
 create mode 100644 arch/x86/include/asm/sev-common.h
 rename arch/x86/include/asm/{sev-es.h => sev.h} (70%)
 rename arch/x86/kernel/{sev-es-shared.c => sev-shared.c} (96%)
 rename arch/x86/kernel/{sev-es.c => sev.c} (99%)

-- 
2.17.1

