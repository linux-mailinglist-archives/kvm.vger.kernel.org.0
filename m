Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E471B4DD6
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 21:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgDVT6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 15:58:47 -0400
Received: from mail-dm6nam11on2109.outbound.protection.outlook.com ([40.107.223.109]:6625
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726614AbgDVT6n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 15:58:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MaBstzPorftb2bgOinzvOEHMqIcGFP0dxKuVjUeY4kaicDPjV6vUsVhPvdknQGXLAEEpnvVvOT7tcGKFkQztNWOvY+nSTN43xzlKQZOH9jGi8YQRQKfVkZAjHsizBgd0RYFAIT7x/2IniwAnveKonQHrOhvZ+rC34fQ/78BN7Txm6krAwwYF4TlKPPBUG923aHmo/Kvad4/9B+wQYrNbqrPjfmwfqLQT4GGatQ9UVBI9wOYbF9elgxBnQVWAaZ2eTiQQCfK9YHvTmnjyED9/Wk4CsqffybfFS7p7maB0lFd/S0STIXjdf8mEBxfi+315AaRTsTyTM+AzrZQV6mjD7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+FJPRWCBME3O7KGGef1+PrqQRgqyoCRq2kHsgRrvy0=;
 b=OViH1NholJnQ6J3g2laPWvVGos64a+PMyzQiuaSXTbF9E+PS8Ef8EOFZU8GajpPDT+t+e3SWVJPBpwhNqUGTvw/Vk8wgQ3HQAcVdE0Ue6qjXPAvG1hRPagNrKIvGjitO4UgamfXxas+rVtBn+0k+8UzCrhdqQy7efPbrToVMyOsX2v0m7kKhwWiwRPOBoiHocUMmEe3rBipE+1siPCI3UUr4FBLa1sBc6tFntR4Hk0+7Mt46rFxyr49hh32mr4eei+M8BXOIZdy3OHE/6NEZriIbB89B2LbkhTa2MWBqdiMfxQCEjjv2AF0tS7PqwGNmzf8RHF7LVZl3xsSXBdemjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+FJPRWCBME3O7KGGef1+PrqQRgqyoCRq2kHsgRrvy0=;
 b=WZ+9TqWh5iLKdfwNDDa0VY9CzqqQu2HCKPx68jWAfDAtoSXZUeXDnj1AmPa1w71ir7yT3nDtdaooIGVQo18+19o3tiQlbU+Uu1JibJYfJ0s3sD928Tuczz2OnFjplUlkD/KEuJSrnbGv9bnc94jJgmsujsXyA+CdEOL1QyTeSbQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
Received: from BN6PR21MB0178.namprd21.prod.outlook.com (2603:10b6:404:94::12)
 by BN6PR21MB0148.namprd21.prod.outlook.com (2603:10b6:404:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.2; Wed, 22 Apr
 2020 19:58:39 +0000
Received: from BN6PR21MB0178.namprd21.prod.outlook.com
 ([fe80::a97c:360c:9ed2:12ec]) by BN6PR21MB0178.namprd21.prod.outlook.com
 ([fe80::a97c:360c:9ed2:12ec%11]) with mapi id 15.20.2958.001; Wed, 22 Apr
 2020 19:58:39 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Cc:     mikelley@microsoft.com
Subject: [PATCH v2 2/4] x86/hyperv: Remove HV_PROCESSOR_POWER_STATE #defines
Date:   Wed, 22 Apr 2020 12:57:35 -0700
Message-Id: <20200422195737.10223-3-mikelley@microsoft.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200422195737.10223-1-mikelley@microsoft.com>
References: <20200422195737.10223-1-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MWHPR19CA0078.namprd19.prod.outlook.com
 (2603:10b6:320:1f::16) To BN6PR21MB0178.namprd21.prod.outlook.com
 (2603:10b6:404:94::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MHKdev.corp.microsoft.com (167.220.2.108) by MWHPR19CA0078.namprd19.prod.outlook.com (2603:10b6:320:1f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Wed, 22 Apr 2020 19:58:37 +0000
X-Mailer: git-send-email 2.18.2
X-Originating-IP: [167.220.2.108]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: faeddb51-14cd-4b52-a020-08d7e6f78cae
X-MS-TrafficTypeDiagnostic: BN6PR21MB0148:|BN6PR21MB0148:|BN6PR21MB0148:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <BN6PR21MB0148B3645572CDBCA6C1085CD7D20@BN6PR21MB0148.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR21MB0178.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(81156014)(4744005)(82960400001)(8936002)(10290500003)(4326008)(26005)(82950400001)(5660300002)(107886003)(956004)(2616005)(478600001)(66556008)(66946007)(66476007)(6486002)(1076003)(86362001)(316002)(8676002)(2906002)(16526019)(186003)(36756003)(52116002)(7696005)(7416002)(921003);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZfpH65vkbUJUkcLcCmnMOJZy1zaniR8HEP+S09WBjvA94vHnbkFmMMsq7nxVN1ra45tS4dr69a2q6qjlkpTfCpFaLQXbXpB1Gx0L561JNWDWEgQ8e3pprnxYRmUrNtLVqIWfNaRZUbjgbzPdoL3flSzeb/onjN3S0xtrvsklXAokvXhgMp5yl6+VnzpEFTPRWBj63OT9dUtmtpXEx74hsV5Ehs/NgvLlNp4NtQFKq3uY6xzEW2ZIsOUxFdP+tBABHkWAQsWND5YQDvzYn7cIVug9lR/jDGMuzljD3phEeT76CTbQrtTsHEClt9pd/aay7ChmL7UBUBks0xkAT+gVe5kT+6NnNlYh2aJgZ+5GZJALt+LrOGZuTMDFZSY0NqBtgR07KGbw+GhajFyQa6arAQIQ7qIcsMUV4au3TzYPV2qISP+iI2UY1AO7I8Y07mH409eb2WajkPx9gBJxfP7QdxRqWV/ZIVbHoaWklEZyIC0=
X-MS-Exchange-AntiSpam-MessageData: lDSC7PleaF76tOUwyXCfrD3cd10HEJLKXkpZuzb3TCPujvHDefvEm1BE8ScbwCKvgvBXBRD0RGuS3YNzIJVInzyJGmb+YObkRODnZTFf1k4Qa2/sbwSBwlrtySTVpDMs4FTv8JQK/jx9YjIRileQqduL5WAXvH0eKgiM3sDcVPUQ31SADCdVWfTVDxjQUcRVfJsipTmabiFIVofB7NXW/2ml2Y4gVLliWCYcLXKQ0XTrgsruSLWs4KUaxHLwHXVj/vAu8qwOGAdzZcaqek0xXOlo9ZjhB5nSwiNwLHR5qviOUOHLrlFwT6c9ZOXEZqtc9Esd7foYXoclF2xEKHr3Y4sfWFDEEcEK9fitWdvq5t0doaXJsKedLq7aBAiZjGpVwgJRWLPJc9IRR64KDj3A/9UOoxiuFGPeTuWgA2hqhP1XFtttjrMH3h4W7AtTeK/ul+84twaEp7r974PHhA10fvriRNlkZq0wh7D+An001Kk/VNOmiQkG6lXRTqwT+1CQIxucG+YcRaZ67XBFoxFDtma6YJe7PaVvxhsubNt/RH9EHWgasLQmjEJ8ALfkQO/3afVW6y7XkWwqyk52/xwUgqDXqjNRIpLb7wLSzrrsyaLiavpoa/dyTR3BT62XHHe2VC2iy2GdfSGRcMWwtt+hs9BzWe3+8Sqit7fYzPGnBOOYoZUeuUcd3Hyn7v0CwDDkGS9cUaRGsBcI0Vttt8RA+KN0tyPpKQLwijbl5+nipkHDQfSlcURkELdKdwfFoBKsRHQhIi2eEfTKOuZn47zfCXxqKK9KYg+zCq0jKzspeWE=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faeddb51-14cd-4b52-a020-08d7e6f78cae
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2020 19:58:39.0178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /6CzrFE0xqg2sz+sepssepYIefG8jsQAhMhjRHokGwHxx9MbT1RNCWMgf05syWATnYtrETg+NWlMZWL9Su/blA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB0148
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The HV_PROCESSOR_POWER_STATE_C<n> #defines date back to year 2010,
but they are not in the TLFS v6.0 document and are not used anywhere
in Linux.  Remove them.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 arch/x86/include/asm/hyperv-tlfs.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 0e4d76920957..2dd1ceb2bcf8 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -390,11 +390,6 @@ struct hv_tsc_emulation_status {
 #define HV_X64_MSR_TSC_REFERENCE_ENABLE		0x00000001
 #define HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT	12
 
-#define HV_PROCESSOR_POWER_STATE_C0		0
-#define HV_PROCESSOR_POWER_STATE_C1		1
-#define HV_PROCESSOR_POWER_STATE_C2		2
-#define HV_PROCESSOR_POWER_STATE_C3		3
-
 #define HV_FLUSH_ALL_PROCESSORS			BIT(0)
 #define HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES	BIT(1)
 #define HV_FLUSH_NON_GLOBAL_MAPPINGS_ONLY	BIT(2)
-- 
2.18.2

