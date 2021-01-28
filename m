Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC01306B31
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 03:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhA1Cqq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 21:46:46 -0500
Received: from mail-bgr052100131063.outbound.protection.outlook.com ([52.100.131.63]:23182
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229595AbhA1Cqo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 21:46:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UWdzJUEBuhE8Z9GoGLyzUHyN8YFFxd8XpczaUE2hAyJWiALAT+NggjezBnPNaIJzAElQqxA7d/nHlBdnByqjxSDeKsOmfadT2MWBq/+IAY6geIQrivsam4vTOisGhp5976rRxUeRU8WYLOjDcW31AA2vmTiPlyv9yM9qMpKZ9ruYFFEky8Ai5OWwEZJsfXWlGhE6mqLLBJ/0ZYHSjsGLrewnWYoE1pGrWa/gJrqk00SgQsxie1kSmJaawkmayZfsvScyV4Tl62X8ry+OyIXQEkEa9JopXQkxzWS2wswT4LunjszKKxuD9Xt66U1Nv6OSxlH2bNC0Nat2CMBwnuVmLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ah+2WTeHV3cgZV+NQieR0mV66QREvWaoPTLB0UQhZ8s=;
 b=daIslSvkxGOC7dzHnv8l8b4KC4XCYjudnVoBKWtYtLesdlCa4OBPq0W8Iw4Hb/mXqoiWwIF+PSyZNCUus19xqUAsuK0/S0gdE7+Rg1IPklyKBe1GEGqz6djNyICWzmUeDab5TM08IjleJeHy/KGm/Y8Ul4xs+Cq5CTazIEMSvRsbHA+fylXCHEVEHR15HIW4HzlSUU7iWu4V3LpOItJWLUNPkkJ/t+vy6xyNidFNP0OEegQcxu0ogBCiujQFgcme4qJie0LMc88rsPbgvCb/MwhIr8pJ6IYS7z1BlSz4nkGXtah2vv2ChlfRRqsscaCfSPS+MHTsitQxJfKdUELe/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ah+2WTeHV3cgZV+NQieR0mV66QREvWaoPTLB0UQhZ8s=;
 b=ZC/h47ZOZ+F7UaoHxFkJZ6sguBOcIEr3ZUV82C9YBM/mfNPFWXaa+gjm26OSsLgwREx3xFjnFZSdtTx9AWkZp5TJx0HKK6MYkjiL61t+sqtdBmYhsaFaNWdTtQawKA3PsD3IGbRh8TATO5iGAU4Pe0jv7zWOJ6BdXnBeCegvN/Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB3702.namprd12.prod.outlook.com (2603:10b6:610:27::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Thu, 28 Jan
 2021 02:45:54 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::81f6:605c:f345:b99f]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::81f6:605c:f345:b99f%3]) with mapi id 15.20.3784.019; Thu, 28 Jan 2021
 02:45:54 +0000
From:   Michael Roth <michael.roth@amd.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com.com>
Subject: [PATCH] KVM: x86: fix CPUID entries returned by KVM_GET_CPUID2 ioctl
Date:   Wed, 27 Jan 2021 20:44:51 -0600
Message-Id: <20210128024451.1816770-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.53.104]
X-ClientProxiedBy: BYAPR11CA0107.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::48) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.53.104) by BYAPR11CA0107.namprd11.prod.outlook.com (2603:10b6:a03:f4::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Thu, 28 Jan 2021 02:45:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ddd54df3-9f12-49d7-eb09-08d8c336d4d0
X-MS-TrafficTypeDiagnostic: CH2PR12MB3702:
X-Microsoft-Antispam-PRVS: <CH2PR12MB3702DB5FDA618D34066CE2B695BA9@CH2PR12MB3702.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:800;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +4DP4gAKJPGFZFYAjfiquvlYry8A22u04fL4oHP6lwo6XK4O2NIxRGupNSl+e1DJAYprGOiXmlplt+KSabGAdrjwfXFOKFt/XK2802cqZ/HPdJDHIv3TJucKRAXtHNjjBhLymIhscTQvdbpJ9nWrOfG/A3Rbr4zESdKOb8lfcQBHx0GsjyhIMf/AAa0FZ9EpqKWAzXdC1qpUOaMY01ldUGSpPmBHNJq5NBd69XV+2p/3mML12336PnzMECU8qe1T/B6/G+onQzDESdb+Bf67hzMzK0thai+4A/BznqEDazc+DkSMxcJccNj/Kh5FtoLysyGs773hbfgruv54U6uFviAmNWgxOeLK7zY8oZJKzuEFVdzue//lz+np4rt2d9y3r4EWFYOKahqw4cg21cecG5+MDFZjhPXeiKaV4/QHs8qeZh4P5uj3cqNmotcSGpHyWnUtI9EkBxpT8EA5fqy1MwxE2wSPfbau6Xj5iEmr0XYQV3T3kO3z7oG2JjgTQjNDNgIBGhDIY8fzPc1vGAR5n8PJxsvcT1wk3P9epIEaxuK1Jaj3eUCd0D+4PKECYnMmUWfnNYUEVZIik/nZyeRhFc94FjRVAPBO9zfc+MxPQEjWdUrt2G6mYqnV05TyTimqaqmRgASK0LCYInAk6PeVLSzMgeKxIQP+ZpnIJ2YAPM0YdhENjDT3ZoecoXcS8Q2ktLxUTuIh8NrXo2yYddV5lmLoKgILmDNoq8XiVMmqYpYbJvMpMuWcXTqfF78H228EH5PdbePzK6XRukpAU+e1JtNuIyC7E87eoPLZXn3C7a8Nm/4OB0UDVlewwKzVYS9foZLVJg9uHSN7ePAY/Yrz2tWD0Esm34Id6Dky/nVgUCNr6ZIBoOZA2EK/zjUs1kQ1+/ujFMAGp9EzDpXBWORAcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(376002)(39860400002)(346002)(136003)(366004)(396003)(1076003)(66476007)(956004)(2616005)(66556008)(26005)(6496006)(66946007)(316002)(7416002)(5660300002)(54906003)(52116002)(44832011)(83380400001)(36756003)(186003)(16526019)(86362001)(8936002)(8676002)(6486002)(6916009)(478600001)(2906002)(4326008)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mtRilc6IbyXs/KfESncKTg/YlkZieZoTO/sH6YL0oklxcxc6mTCnXDgrZSBO?=
 =?us-ascii?Q?e4gLVeb6TD+0HYO4A1Q1Hh8s9s3bVkQeUl8GS1PjJpxE++2XyTnthkgmtmAz?=
 =?us-ascii?Q?EiXStHJnLf2HVlJbmffsrR6Wv1gGd363U8QokLNtZlTr72pxscTNE7L3YyaM?=
 =?us-ascii?Q?MfZaFSc+p21BHXPMZDP6zF7Nb/wHuUB9Y8rCvlmHDUjYSdUE+WHVpKZbsg8F?=
 =?us-ascii?Q?rQjAUQaYoSNTlWoAqU1TS9GKY9pvqbYRhVgZW2oM37XI3Bm0xpJC+EYeUVhG?=
 =?us-ascii?Q?c29jXGnZKiiGDFsbT4JUO6jYlP6jMSzD/fzeQGlB7WIrrxJ+9HvBTTiYLSoM?=
 =?us-ascii?Q?1RwKZNAl5agWWbWphnRMkas9N8iF+AtP6DCA3DVPVAsHGf6K14uIeviRUc9J?=
 =?us-ascii?Q?Lls4u84J/+Pz4XE6U1blk82FWWTYYSSrDD/W6syUHc5BjgAnL/QnAVLdxbg4?=
 =?us-ascii?Q?pO0CrzbQVrWcGONXFG9+ANv5nI1YTVCYQm2QJ4PPu04nY+1BqQOLH2rJDuxW?=
 =?us-ascii?Q?Sg+1JlW7Yuik13Gs0mccqzhTjcA19/qHpkxh1/iL0E8fs07dC2vDvA0F2gwA?=
 =?us-ascii?Q?vv6xCogc4K2zPDMbPVVj4uGk66CpOkPWJ0f5z5EERi0OqACK0HlZS8sc5FXc?=
 =?us-ascii?Q?/nqqUJLLK4TgOhwDGtii/vTN4fkwH5RdTJ7TSROnNzjIY6N09YJ/5HrG/dS3?=
 =?us-ascii?Q?u0+7W/q/X7IPIIbKNLszZLIagU/e4NOPsbbFT4HFp3RYtLIqr1gsTJU+hsay?=
 =?us-ascii?Q?UEZ4D8auyGUmmBg7TpXsStR4F+XUS/m++WNm4WXnSHJWzsHbFmNHUwWJAeH2?=
 =?us-ascii?Q?duZuu5w8lyz3g8soVETZRgISLc29yLnI9rwRK0yIhzGwvN2g8ZiEn3xeuSUC?=
 =?us-ascii?Q?nYuE9C6N+dDBfPo+Zr5RVM3ZXUHMwAVLKhIk7EHWvAZUZMXzGPrg0BD2d1IV?=
 =?us-ascii?Q?gp7MwTUDfBovgwkOucnTL6+Xy/SlKZJz0S0907aEfBYeXQm7AABsA9AtMokb?=
 =?us-ascii?Q?mnhB3xRC1O6B872aMQe2GPyAZMAZDr6Zak0qrZsSbFpIte0CJOX4Z6v2KKWJ?=
 =?us-ascii?Q?iyrwGO+C?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddd54df3-9f12-49d7-eb09-08d8c336d4d0
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2021 02:45:54.0779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KPNo7LW3gNxirAYMyk1YzsOgp/bU/2fHY77kNNVS4/sFXuYoknjESBnhzxIJpvLqNkD65ly8WVhXKGcSgsrXXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3702
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Recent commit 255cbecfe0 modified struct kvm_vcpu_arch to make
'cpuid_entries' a pointer to an array of kvm_cpuid_entry2 entries
rather than embedding the array in the struct. KVM_SET_CPUID and
KVM_SET_CPUID2 were updated accordingly, but KVM_GET_CPUID2 was missed.

As a result, KVM_GET_CPUID2 currently returns random fields from struct
kvm_vcpu_arch to userspace rather than the expected CPUID values. Fix
this by treating 'cpuid_entries' as a pointer when copying its
contents to userspace buffer.

Fixes: 255cbecfe0c9 ("KVM: x86: allocate vcpu->arch.cpuid_entries dynamically")
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Michael Roth <michael.roth@amd.com.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 13036cf0b912..38172ca627d3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -321,7 +321,7 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
 	if (cpuid->nent < vcpu->arch.cpuid_nent)
 		goto out;
 	r = -EFAULT;
-	if (copy_to_user(entries, &vcpu->arch.cpuid_entries,
+	if (copy_to_user(entries, vcpu->arch.cpuid_entries,
 			 vcpu->arch.cpuid_nent * sizeof(struct kvm_cpuid_entry2)))
 		goto out;
 	return 0;
-- 
2.25.1

