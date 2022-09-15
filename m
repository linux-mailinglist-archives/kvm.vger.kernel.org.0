Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 659375B9892
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 12:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiIOKMS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 06:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiIOKMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 06:12:16 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450AB83049
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 03:12:15 -0700 (PDT)
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28F4AFSS008387;
        Thu, 15 Sep 2022 03:12:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=39Ppz8D5yUE2kLAAbJqLn+DP2snZCikuOwcRuOeO2W8=;
 b=i4oxhAeDXg7M2dGJkVghyweYtFUke7E7HXgon40FRHrmgazBvora6laB3V7K32+XVd/j
 hkq813YIH01+5qNqb+vmEVVnLL40CD5Y7eq940AO7Hkjhvm47ZbzUsxJ7+R5b29xLF88
 6MWkvmNLeCgGJDVj8zCEXwLVoomI8QGSqD/I+KN7TFw2FXTL01mhrALWMOZgjvX25+cZ
 7cdtamVnXEpAoPITyMOTd9JFzpUzd9Ze9BEK47A9sm1UCOgvKhcXadGDmwFBzBr4aRV0
 BFwuHmQ/nE+bCCMnbeBsDzK/ftNmSLaRg2YzB8Tnn/vIB/Sjw0nDGWgospB+0cgf+5Wa vg== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3jjy0pv8bp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 03:12:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IouGVwfwPPbKkRs9KBSSjlQc8HL8qgUZBXLoiFrTFdh+bbq/Zd9ymI7p3Qq4Lf8WCZEM458nSyY+UV3Ia7G8hX/TufIgr2YKEr+L5e81dEzKC7XfE0OCjuTRBzKfI2UxK5jdJyPp+W4ZL/ID85apKHDoDXSW8xs0jsmlXtck9dh1oJbbx66vRb+1bmDfEsijuAl80xET6XsTwKIm7Ay5Yqeo1YUaqkbrb78EGavv18DdOXckqiJm5OrRnMFiNCHJNTgC+SKhuiar251sSlO2nveVIK6HhApXGTJjQ+B7Fc/xwmVQn8jsNm1ZcjpRmCXOrRgPSflKxzPo03Q9onjyTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=39Ppz8D5yUE2kLAAbJqLn+DP2snZCikuOwcRuOeO2W8=;
 b=AbrfXZrc7pgfRbExCZ3CdOse+MLub2x5XCYI4Jwu3T8cBq/4smf3R7mPFPYbPTQNKqqPijroijHItLMvQhf0ER0E8nB7N6ggNBWLdKNUn0+NXWr6zdTK0bFB0k195v/V4b/s/IoaRTRMGgfowi0MAp3GLFBLaVF5RNJncEG9VOQI+gTH3IVq69VxiNSQ9nWdX+e7c48/JhLhcMxBhwSpLRfnCvXg5lqj2bXlV8GGPiriCPMJqQ2PvUPAoSfQwTc2EgwwQzZlsXVzXMvb+BXYgi2n7kGJxsu59XP/dNccVx5kfQ6PNNf+tD6dq3a+p/3IdeVRab0WbviNbddpC90u/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by SA0PR02MB7370.namprd02.prod.outlook.com (2603:10b6:806:e0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Thu, 15 Sep
 2022 10:12:03 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf%8]) with mapi id 15.20.5632.015; Thu, 15 Sep 2022
 10:12:03 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v6 3/5] KVM: arm64: Dirty quota-based throttling of vcpus
Date:   Thu, 15 Sep 2022 10:10:50 +0000
Message-Id: <20220915101049.187325-4-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0235.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::30) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|SA0PR02MB7370:EE_
X-MS-Office365-Filtering-Correlation-Id: e8d2f4df-74a1-4eb8-c4ee-08da9702bc06
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wY2njLG2+b8V3rkYhos9yCRdTUJkZGQs0BMbnof/HIBTJjmuvKzD9mpzoKRYopexT62RI9lhPlxyeLUCgazVjCNujpTuQ/1i3i89Qm+PZMzSNUtE4HmWBsPde+VPuM2w6Gnzb67UNEdwkUXxK62UcHZ4unVkDNiW6DdLWWf4IziUAiLv4CDqrdqM2QezGJ4ba4IkpqGy0XdnyisHCzPMJR1cy/f17lczdYh9wa6n+UP/OC2/YP2iL0QKDAL5znuUnaw29jFLuD0fvAO4QBkaTHrM0ivLB4kI6WMY39WS1BQ9LKRA5BmD3lbXOhAVi6/VgJshGZK3u6dL9Xjfirvxiu7WMf2RhSp56NiNAuuC38+zudwOuw8wzzUbpVKhGf+0kXnvoe83ixHHj56wwZgK6FXLwyjGkX0RVkUcOL806YqyBVb5zzikYiSmZCXVqpZXAMNiy4iRy3NUFZ1nDE6CzFt21dOIkShA2Znb83w0+snQBKqijJP0IKL/1WPbRwlpa3vi5TmGjxFEMCEQF3u4IlHNKxtCbG7/7c0Srta9qAITUtCjQsfEV0lnEwILJDyAjCvC93JNiIDRoL8RXy4g5n2R2ux0ZrH7+3uCMM4HhXNqqpf7iFFg8YLuMhDZ+7YGkm5lBsusUEVkrPpwzBxZUZgC3t+3M1Kxiq8QFfeURtu6J6sIZokuRVZ2U6VBykNZ3Sfi9jcm9tSbOhUYkfnN88vfye7PllGMm6JO6UC1+mEGi6Dxi0vQg8Sbp8EsBzMjihvIW/j64fYoR8mS9Sy90ZDyEcjHX52GcwjrVG421x0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199015)(6666004)(52116002)(107886003)(2906002)(38100700002)(41300700001)(66946007)(83380400001)(2616005)(186003)(6486002)(8936002)(6512007)(316002)(66556008)(478600001)(54906003)(6506007)(4326008)(5660300002)(86362001)(66476007)(8676002)(38350700002)(26005)(15650500001)(36756003)(1076003)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AZUDKkU0MTdqod1wTvihQIDo94wRLuczuziMHV4zTZClFb1m0VVqTS+A3bgE?=
 =?us-ascii?Q?yfYZx+HYYKwfv/JBvKSd4qk9uuBDvf70cxXCz4G52SLTFxHgIg1qpuHgh2BS?=
 =?us-ascii?Q?v3hMxwqOYXgPCBwpRemmZb0mjYbBrlYXSFMClyOShEIWdEUdGrDNI/9TIBte?=
 =?us-ascii?Q?sj+l8DuJgFsetsnQL7blIZN7l5O21CcQ/nAe92dMOkAuCEOn9MVFerhOlUA5?=
 =?us-ascii?Q?lHR6qNtfpc6WM48QTZQH3JWY2KwX8kc4yBO3IdB8NxZPr4nPbctmi10WHfoh?=
 =?us-ascii?Q?sINech/GOSEa1As6wx87gLQdasQyYTC0csyollevWA+KJKazH4Q07regOgrx?=
 =?us-ascii?Q?zUJO1+RPqCaARNxP8pMsJlzl8UV6uJGcwiN1fvm6rbpmcclt3yzsF0fEh+Mx?=
 =?us-ascii?Q?9LcXb6cC79GqIz9xCtSVbxLVHPD5Mjc9qX13YDdlB88hunzSBOMc5lQ4Vwrv?=
 =?us-ascii?Q?Lj4Dla4KQaJMc+I/oewUz3pV2p0ZCXkT1aSH95IppNifl0f10/A3YN5kZQCe?=
 =?us-ascii?Q?LmBFu2jOiVgNnI6I6cHUB/PdZiASLC4bAuMIVPCEeZTtVKWF4oJ0WrihiyCi?=
 =?us-ascii?Q?jpd/QsOz/DYMqEb2InANKVL3baNVZ+JhqwYFMJmqjpp8SnPq/8e8fg0BdJsA?=
 =?us-ascii?Q?hmWxmxGR3vt8voGi19S085SngjwWuUkoed1tOaP/4rjFIERpdab8nVjd12qK?=
 =?us-ascii?Q?bD18PTg0wq02+77TTljs+fF1q2CtvBybk8GPmS0jTNRclZkkvAoiwmULCRnH?=
 =?us-ascii?Q?uLkKUK8VzP7J8iX/badSRJdkgCSjDoXbCFV3OmNW1UBWL5EDGlIj/Ml5qKHU?=
 =?us-ascii?Q?VE6108YgED8u8ClS+Vc/ATlnfC0qp4QnM3l8SaBDbIUo89WTbSSPwj3W80P6?=
 =?us-ascii?Q?kh2Gh2eIk1jpEU+6ONJKr3yvYSjmKjr/L13MVtKvQZdlknoENQUlFAAEkSO9?=
 =?us-ascii?Q?R/XtiJSIz/hY7hfbdm7gLHbLx/nHwGlAVbQv3Ou5GSX95bN7PjWj5xaWHtYK?=
 =?us-ascii?Q?sYqfabp5logAlJ4X5YanO/k7bnJ5xcvVFH8p2MRRHIwBrP9bGfNc4Lja140e?=
 =?us-ascii?Q?aDE46UO+F6jR4bM3/KwBYuUroHaFeN7QgQKN8PewpYUd6YuU+PYwpuq6Z3MJ?=
 =?us-ascii?Q?a8HRRgyW1tK8LCMFSTLfRajreKFyy+boowtcrfTwOxFjD6TEVdbnkXH5yxM7?=
 =?us-ascii?Q?smEZpU8Gt/4lTUtgX46VZc4u5KW9CGsEkRASm7pd2J8aW27RtsOAWW+EyafA?=
 =?us-ascii?Q?TL0n8z6E0ST3LT7mrmljJcZReri5auJetbyaGkmAIKdaLghqblefxX5PUqVd?=
 =?us-ascii?Q?B6ULmGttbOTqVNxhKEar/Ys6DwBnW/l35PFDAmC0kOR/+UCvDVKYqNO24WmD?=
 =?us-ascii?Q?LAczDqRt+gzIe6pF+/7hTUv3mFRkT4bNlLH6DW6FPKp152DLGnQOqJPlbS7Q?=
 =?us-ascii?Q?MzKp4CjBHX/XhZALDQqC+6W1DwpeAOOyAEkDUVPAZIFglYxR0pQiw4VKs1lH?=
 =?us-ascii?Q?tTO0ovUwxrhPVEMIRUMBrEooBJi0mGYzBPU6Vr4vf8AA7bmUt9ZEIFLyDbb0?=
 =?us-ascii?Q?umh+gcgX41K38DrBvrrrwSOlCi9qdgq5UDtzBf6cFrt3mGvjyqaokOWX4KGF?=
 =?us-ascii?Q?ew=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8d2f4df-74a1-4eb8-c4ee-08da9702bc06
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 10:12:02.8645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7hQNQYMTsdRMqywb/3qiZwWwh07+SUNF9E1J3cDbLD97LvR0F++Yohw7u7qr8nIDVF2zU0UUTj+m923CdSAgON3g6jFdt4JUBPbiZkMj9rQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR02MB7370
X-Proofpoint-GUID: thf4L5_Q65LvpIpMgoJfwrWStKrYt0P6
X-Proofpoint-ORIG-GUID: thf4L5_Q65LvpIpMgoJfwrWStKrYt0P6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_06,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Exit to userspace whenever the dirty quota is exhausted (i.e. dirty count
equals/exceeds dirty quota) to request more dirty quota.

Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
---
 arch/arm64/kvm/arm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 2ff0ef62abad..ff17d14aa5b0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -747,6 +747,15 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
 			return kvm_vcpu_suspend(vcpu);
+
+		if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
+			struct kvm_run *run = vcpu->run;
+
+			run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
+			run->dirty_quota_exit.count = vcpu->stat.generic.pages_dirtied;
+			run->dirty_quota_exit.quota = vcpu->dirty_quota;
+			return 0;
+		}
 	}
 
 	return 1;
-- 
2.22.3

