Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC15F27F6F3
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 03:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbgJABEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 21:04:13 -0400
Received: from mail-bn8nam11on2079.outbound.protection.outlook.com ([40.107.236.79]:63553
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729746AbgIYTEf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 15:04:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XoScSua5iacBY6pKaqsOrN6Cf6o4zmC4d58S504aYvf5QtOZSv0lLssXq0EAJRqDeiymo2GpsaEWUueEoJb1VMU0PiSwiWxb/h9T9IbA9p2moKizqrS77QiD4kwhL2t7kKZFE9lrlLysLIHAULg+UgbCGnzgCcpla8RFWrHmJOOwdJbD668Xr211495KZ96UG9mGTZwfRPI33F+9r0v+veZEQFUWBpzTPjvP7wkjGCeGWmKP1At7aOWL6pYgBY4nvSlKlxKcAqUVZhHBeQum0vqnYpZInPWQ4fApET8WwO0Q+qjmF0EgrP633BSemJWVTx43HduSubCmNcQhxRItCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0KhVtK8IDDsAo2UQC80AAu5NeKvoOdS/VQ6KL5+SDc=;
 b=K2XOV9hOQAf/9P3FGHGA6Dg9FgiZGSv6O9pRPShrahh5N9koszFVf6V/Zd1vtd41livnTl7al5N540o/hG1nEVYLaI6tmZvxHzCpOBth5+ednmKWuTMQiujiCilbs+/wDxQJ7x7hLS5wXZSOy8wg/9docqfv88Zwao9ytBZsW3arDNms0tZuJPwMDsQI22tcYEm/STudRWzHGXNINL7GqKIsNfA3bqgRFF/WcB6n0zpXTJjJ/u7aDoMzC7jkBN7gFXeDJNptocFFP25urfPkOyxPucjLRMKctqpB15rjSQNnSXYN4O972q8kAZ4q/YjwNHTy6irYreWoqzFF1fBuXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0KhVtK8IDDsAo2UQC80AAu5NeKvoOdS/VQ6KL5+SDc=;
 b=XxASVByBKxXzCQDGX5NXSiiVg0gwbLPiI7GPAb2dX82JqZi4SzD3tCI3QCg9Hw/5stl3/PD5YLBbvbP5c31w0zksne0bfL1676csA8XXOtA/z4MOobfB6iJeCSm/1GyQrlkFhYukLfMXiM3wGamWmG4P4+MP6QYqZYguZKepzyE=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4297.namprd12.prod.outlook.com (2603:10b6:5:211::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.22; Fri, 25 Sep 2020 19:04:33 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.024; Fri, 25 Sep 2020
 19:04:32 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v4 2/6] sev/i386: Require in-kernel irqchip support for SEV-ES guests
Date:   Fri, 25 Sep 2020 14:03:36 -0500
Message-Id: <dcbeb6aba051f10b8e6e8a0b90e26101eb3ee526.1601060620.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601060620.git.thomas.lendacky@amd.com>
References: <cover.1601060620.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR21CA0018.namprd21.prod.outlook.com
 (2603:10b6:3:ac::28) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR21CA0018.namprd21.prod.outlook.com (2603:10b6:3:ac::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.2 via Frontend Transport; Fri, 25 Sep 2020 19:04:32 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c872ae2c-f363-4e9f-de0a-08d86185d647
X-MS-TrafficTypeDiagnostic: DM6PR12MB4297:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB429724491F1DE4ADBEB35450EC360@DM6PR12MB4297.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:989;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tiu41ZjytNDZSLY0d3AdTPQIJqY2YEmAGOx3Zbvg4Emj2vtSu2Dcb2HiF9etsLMjCTKzQENJBymoms4Cl44ncGdJCLEHZqB3KkKeLEgO+BwqZMJ6XAZw1kvFk96cdlTsw3ilNa3qpoKm0UHMYUFfcZLbX8drVVy/jgdKl6IZAPfO6hWnON+hIsNOpSn9RUxpCKNPeVe94uZjvdVHWufVbEtPOnB34ZYISgZrutws3hf6YTz4fVI2DA8bubuX+lJ4avie5AitMaiuAuFJtdmtA3EJJayefLsT6c6cV80dm/obErLF8vO+4u3GvyhQMKRQYCsHT0i01IIiFfuowWgnctEcvp/ak/RmQDfVQCG6ZR3wjwXvLopnit2+Ojn6hL1f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(396003)(376002)(39860400002)(26005)(4744005)(7416002)(956004)(186003)(16526019)(54906003)(2616005)(6486002)(66556008)(66946007)(36756003)(8936002)(66476007)(86362001)(316002)(478600001)(7696005)(52116002)(2906002)(5660300002)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 0ZlkXVeG4jtCvXqTYAfInl7rtEoJASUBDS24U44OiEZD3c0GrPbYO7hDH1ncq4CEhrEMlvfy68nauPvkNdDZlUahNA1+iyy5qv1Ykc/fW4YQr+krNkMs+mmNlGocNan/hZb70kdnXK4oL76JJFa6pNfiYQj86vMDt0vb8tztOp2OgBroJwFZeph0KJVKfgwBc07f2OcKTvjOPUoURB8ib1T5Now/c7GO2y52xplwRwUZWcr77lXm54xv7j2aMA6EiOmAIxRW/9RDqbo2/jbgLaVfoUGndiAhRyXW2OH4JwrdALvrjtJEX3EcPWtLku1UlmeHKLu2XFUT45Ew+Hiuy8BuQjlPeoI6oTFz9EsMgffdi2OoON3E8yPU5iCXX+gWlOB8BQURNlJqKz6osJiKvdp4C8UI5ctB2tYp+m6U1Icsb7ERwH70V7qbqKPtE5LxMXA3gPCiz1yFOYmQhm6HQu4a0EcCxcxiLj/PPPkEjajR4k+0nXM1R+6HLBo6TZ3qTfNfEZMhgHLzVHt7Dnm6E46bpNtuZ4QnkBD9KSzVRfYJXAyOWb6LO4v2zxGse/6/+prayHUSpuxnkJzp/Vt3TDq9gayERquDESctqQRQicyedFyOadRZRZ2xNaiGpkt/9aFwK3c0Rq2ofi2tzneRpw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c872ae2c-f363-4e9f-de0a-08d86185d647
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 19:04:32.8722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eLPObFx/O6q9y+htSPc2ukSXxCkSMdSZRNsA2Cf4kTS+rlDSZ8VO+ApsfEDbwKse6XYsRhyZKB4DdkTEFCjOFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4297
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

In prep for AP booting, require the use of in-kernel irqchip support. This
lessens the Qemu support burden required to boot APs.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 target/i386/sev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index af6b88691f..0d4bd3cd75 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -774,6 +774,12 @@ sev_guest_init(const char *id)
     sev->api_minor = status.api_minor;
 
     if (sev_es_enabled()) {
+        if (!kvm_kernel_irqchip_allowed()) {
+            error_report("%s: SEV-ES guests require in-kernel irqchip support",
+                         __func__);
+            goto err;
+        }
+
         if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
             error_report("%s: guest policy requires SEV-ES, but "
                          "host SEV-ES support unavailable",
-- 
2.28.0

