Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E4A368843
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 22:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237018AbhDVUz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 16:55:28 -0400
Received: from mail-eopbgr770054.outbound.protection.outlook.com ([40.107.77.54]:11278
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236851AbhDVUz0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 16:55:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jcFECfJX8u29eSIwpyJQCPJY6Zncu2By/HVCqdiorrjBsuAZ/oKf9dYrYmzj4+6decN4VrwiUuWLTBocyN2rLLsyuIkLj9nwLq+wjV5OinQRepkwYVAm+O77CYGsnfM4BfqIiCTgwoKPwASKept9D0Xlxcy48Q/C4xfj6dzBrDHAO0gt4Tbvz51L9ChsRcK6LjLpx4rigSLD5yns5KT1/mAAontgvdNzAn6JdUaKPmP0txB5aonVs8apoOfbxc0QqkBxCmP6Q2huiDliV7E75nXfSd/NQcfEZfEdQDDpqqRsGex7W4wdu4itqjIULofWb8ZHFq6PHhhccMf1jBioXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tCeDn5PWshW/vrJfRIg9rDxwpkgYUZwIlTStmHkw8rs=;
 b=Ghv1KtmDhsimy69UQvjiG1FtbnMDYY2ix4MwDxqF6DjNjcVCx2y0nS1o7fVsA7tismnNdGzq5VYcIxRQARu2C+rEG2O3NnZalVl2BcaWQciyBt5ftjU+1fCOzQ/zI0KJVKV3q0QmvH33AW1SBq24Ufd6mJQqdvA4RjeHeVTySNp9nWcRSEc3KjmqCENK8Z7KU+A1ogst++wHj6S4Jjxw4z3Iwt82DYD7/RjfD0buie4DNhmcq4ujKzhQReFHieb/nrgTeNPgzZ9irdNPKF6wZ0CH6UJ8RMevGKHFrSjbu3tEA1GyaP6/7o+rljpD7R9EPiQcpoRqZ5AOsq+xgwX18w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tCeDn5PWshW/vrJfRIg9rDxwpkgYUZwIlTStmHkw8rs=;
 b=x/OIQ/glhOpMJegdIMtDy93Ew/VYD2u7CuOM7/Vz/7aXBPoXbeNn05lj4+GJgR7YDHsrY0mfRKvXn9WjlJXGEg2CJb3t5rlaVGpEW0TX6Jseq32eNoxJibgyBy58lNiJWi+tpJJFlmzyxX5xArOnw3xDhMja96a8WbokyAyB6/o=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 22 Apr
 2021 20:54:46 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%7]) with mapi id 15.20.4065.021; Thu, 22 Apr 2021
 20:54:46 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH 0/4] Add guest support for SEV live migration.
Date:   Thu, 22 Apr 2021 20:54:36 +0000
Message-Id: <cover.1619124613.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN1PR12CA0086.namprd12.prod.outlook.com
 (2603:10b6:802:21::21) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN1PR12CA0086.namprd12.prod.outlook.com (2603:10b6:802:21::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Thu, 22 Apr 2021 20:54:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 526ff01d-e79b-4e6f-393d-08d905d0dc94
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB27679FF3FC4BFC49E4A30BE38E469@SN6PR12MB2767.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PHZa1gOuz5WzdCXEGLY8GfnxMkyG3qoVDP/5M06DMvc2TIiNdvIpawyEy5nZYD69MLxfb3M4CZ2CYcHd3SGpaUOLQ3Ngb9zZ3qinBMiVPKC5+SbmtNihyCLWnDVLKi0oRmWX5pTlmUC54RHsp1skWBBdiSm9RTloumPOhVy748YIS7VNYpVqrWo8lSYWAQpywOy07gkg2+K09vJfEHBsZ3DOjYYa8HNSjfcwUum2GAQDcYx9L3bZ8+q6jMbaAk9vaqHqG9grb7xXF55kMv+VSRfxHhpBnaRvH/3UyRQBX4RW4ffTTxV9gW2E8PZ/e5Z6gP8aXV0pKRDH0BGcPv2/4lK66+ohmGGCpc+GuTDr2EtRdbpv51Y9WCIY0SR1rORRtI8VsrMwrryk3Kdw0HwolyuyNRKDGS84hAVEP2R1cokAdhOYKd/2InqbyggA49BJMeJVO/qp90m2fHfdCe8y1Oxmru5FPuQtJrtIaNmKY/22UD9SBVzld+7RvHKAoUM0iNn0fsFJL/0CK6E5NqC/v8F81cBiajmCAGPi9JmYLx5IT4AMK4aScljjG6mAkUrp3fhNBOTXk4auC1qO9fQ0UpxQuD2lsW4hP4BziGOwUgBdoyKc38QTjLUz+ViD89yIvcxoufaOdoDmnUItkHgbBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(396003)(376002)(39860400002)(6916009)(86362001)(83380400001)(7696005)(6666004)(7416002)(5660300002)(26005)(66476007)(316002)(36756003)(186003)(956004)(8676002)(4326008)(52116002)(66556008)(38350700002)(66946007)(16526019)(6486002)(38100700002)(478600001)(8936002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UmIvcXUvVTg0OFp0dVphYUcwR2ZGcEV4K01lSTBZT0JGSDZ1REkyYXRka2Er?=
 =?utf-8?B?RnlYZHp0S2szZDBCN1BjYkhqbTlXZStrU0U0S0F6N2wvSm0vN0t0SG1iN0FI?=
 =?utf-8?B?emFWTEJJREVwcDRnOFV4UW13YkxDUmxBZXA3clBXSklVZFhXVHFmR2dCWm45?=
 =?utf-8?B?T1NQZDRPbis2WldJMk5kcURqVWhUMzVCMUpyTVZrcjFrQzZkeFhzOGtHdzg0?=
 =?utf-8?B?ZHJtdUhjcy85ZkowUGV3WWorZnRqYWhhSDhPeWhQUjB2cUZHc2V2VmcxMDZI?=
 =?utf-8?B?aHVJN001QmRXd0N0R1pWZ21zMEJSN25kUjFVbWE1K0ZIQ29YNGp2RndtYTlK?=
 =?utf-8?B?d2ZWT3Z2d29qL0oyek9wR1ljL1NsczNxSjl4YlJsSVp1YjFkQUE2NU1uWE1L?=
 =?utf-8?B?REkvT3BEcHU2cW5FS01Sb3lGMkt3RlBNUnFoTFJxK2FXMFR5MnV1SFBRTkMz?=
 =?utf-8?B?NldSMnZ0ekVKc0FlRUFzQUZNSytUdGVnQjJKamNsWlMrSWwvZDJrWmNwd29x?=
 =?utf-8?B?d1JUTWxYU1crdDh2YmZqamFMOXJKbC8vRWcwVVN3bEFkcVBuWFRlSjF2VW1p?=
 =?utf-8?B?czcvTkJPY2lnWWh6cncyQ0tOUk5Tb0QreWpuQks1akowYTRpbC9ibDl4SnNh?=
 =?utf-8?B?YXlFS3lINHVnWDdiaE9ENFZJeWkwb1E3ZTJoMUZBZC9IVkdUZ0ZoM2QwMnpk?=
 =?utf-8?B?aVVIK0ZFSkJITlByandIbHZGZlNUTzBrMHkrcGRYVHNYWS9uSVNQM0xTdXA3?=
 =?utf-8?B?ZWlEaUZITVhaaUJuYXhBOXhCQXhncmZYei9LVlJ2eUNldUNmelB1MVR5SzdL?=
 =?utf-8?B?Y3hvWXNFbTRLV1NtTitoRFk1dnBlbUhySnoveVM3RTBjRnhNMDNIa2JKd1JI?=
 =?utf-8?B?Tk82S2xzV1VhcGFqMm5neURRQ3ZxT1IwUUx3OXZ1Y1lndnkzZXZsbFFBUEdG?=
 =?utf-8?B?REhuME9Za1RUVlhwd0VZTytibk5nTGQ4akdtYWdNdEs1ZjJwdW0wTlB4eURU?=
 =?utf-8?B?M0RCd01SKy9KV3dTR3VlUnhTa2JOQ1UwN1RKd2Z0bGl0ZVF5UW1QbmVCbzVR?=
 =?utf-8?B?NmorYTdBRU5UOXhUMkcrL2RHOXhNRk5neFFXV2xidGFkcEFoMDZkUUhuL0dv?=
 =?utf-8?B?MWRiUlZndHMvM3lKdXpZcXYwLyt6enh3bDlTcWh4SUppRjVRSnVub3dHODBT?=
 =?utf-8?B?TTMydkh6R1BZODkxY2ZITUtlcFB4MkhFK1haOHBrclFVRjF3WC9jNmxiYk9O?=
 =?utf-8?B?MG45S3dBWUQrZ2NwM0pNdGZybFJtRHZSRzZhVUdDYjJHT2kxSG4wL2UyREJY?=
 =?utf-8?B?SXUzZVk5R2dETzY5QS9QOHN0T21mMW5QT2t6dXNxd2k0NjRNQ25PNnQrWWxt?=
 =?utf-8?B?SFFoWVJjZE5QMlVXQ0tOQXNzZVF2ZnU4aEVjRGhaajlML0xWdkRXajQxaWpk?=
 =?utf-8?B?dWU1a1h2VDlLekpOeFNQanJHRzVJeEhTVjArUktxOWpEMnR2TjZKdFNuekpn?=
 =?utf-8?B?bG9vbk9OYTB3SFV1ejB4ZmhCM1VLaFJMcnVVRXdNSkdlMkZ1NUdRZ21iYS82?=
 =?utf-8?B?Z2VwVzBLbGpxVnNjcVNYYlJqOFFhQi93ZU9UczRadXFidG1GRWZiNTAyKzF5?=
 =?utf-8?B?LzVFTzgxZ1BMY2QveDc1VmxjYVRHMjJrVXdkZnkySHF5OWJGK0lEN0VxRFJs?=
 =?utf-8?B?YlhyQ3E5YU1SR09ob1pYWkpQYnBaZFh0L1U0alNqMGFyN1hicHp1NzJXSXBU?=
 =?utf-8?Q?KOBha+HenPbi8wX6EBwhzG3BQ27EkbPfbOWrzkT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 526ff01d-e79b-4e6f-393d-08d905d0dc94
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 20:54:46.3162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vF1UmE7xRL+i82ecQEEpCqppuT7cNeaWJqaYGxBUxjLkfjm5PzOsYvILkyOlN9mqObJP1dCYphdYxS6qqXCNIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2767
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

The series adds guest support for SEV live migration.

The patch series introduces a new hypercall. The guest OS can use this
hypercall to notify the page encryption status. If the page is encrypted
with guest specific-key then we use SEV command during the migration.
If page is not encrypted then fallback to default.

This section descibes how the SEV live migration feature is negotiated
between the host and guest, the host indicates this feature support via 
KVM_FEATURE_CPUID. The guest firmware (OVMF) detects this feature and
sets a UEFI enviroment variable indicating OVMF support for live
migration, the guest kernel also detects the host support for this
feature via cpuid and in case of an EFI boot verifies if OVMF also
supports this feature by getting the UEFI enviroment variable and if it
set then enables live migration feature on host by writing to a custom
MSR, if not booted under EFI, then it simply enables the feature by
again writing to the custom MSR.

Ashish Kalra (2):
  EFI: Introduce the new AMD Memory Encryption GUID.
  x86/kvm: Add guest support for detecting and enabling SEV Live
    Migration feature.

Brijesh Singh (2):
  KVM: x86: Add AMD SEV specific Hypercall3
  mm: x86: Invoke hypercall when page encryption status is changed

 arch/x86/include/asm/kvm_para.h       |  12 +++
 arch/x86/include/asm/mem_encrypt.h    |   4 +
 arch/x86/include/asm/paravirt.h       |   6 ++
 arch/x86/include/asm/paravirt_types.h |   2 +
 arch/x86/include/asm/set_memory.h     |   2 +
 arch/x86/kernel/kvm.c                 | 106 ++++++++++++++++++++++++++
 arch/x86/kernel/paravirt.c            |   1 +
 arch/x86/mm/mem_encrypt.c             |  72 ++++++++++++++---
 arch/x86/mm/pat/set_memory.c          |   7 ++
 include/linux/efi.h                   |   1 +
 10 files changed, 204 insertions(+), 9 deletions(-)

-- 
2.17.1

