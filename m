Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B7D6F6DF0
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 16:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbjEDOqA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 10:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbjEDOp7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 10:45:59 -0400
X-Greylist: delayed 69 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 04 May 2023 07:45:58 PDT
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D17C1FC3
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 07:45:58 -0700 (PDT)
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 344AIeVf002011;
        Thu, 4 May 2023 07:45:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=MTDhkW6ie50jKMfiuAAhbhZSA7FQTpjq6GjEimTqzXM=;
 b=ZH2O0c4uZwQFR7z61OTiRNoE0qOEJFzqU4DErhT3UAwPbq2L4cXtiTeyT724jC2EwaXt
 qLq+MBcrBt/yd0bHIHpiUZYfTW1/WgWiy5JBwjylgluxOZG5y8xKfxBkA9W6gZFn8sw7
 wFtGIdXawqZv+JxU/w0ZnWdVR5m4l/KYbgj15su5QiRKElI1GTkiywI6s3vKhY0eiD5r
 anHMnPme4zvEW1y6duXaJzy75qv/j+eXJ5jOrxvBUvQ96Cl7aIVH8BuXrlK39tJmrTLW
 EwqvU06JwkHrQlQzwjHJ+uW80tUnp007So2l6vCz0RYUp5JteaulOIy44YW/+GZsF66o iw== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2176.outbound.protection.outlook.com [104.47.73.176])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3q92ajje4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 May 2023 07:45:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TCYwTmpTPhlmPdatqPlDNY/aY3FwAEhrLDl8fBzIJDjhrGE2FU9UEBGfEJEmRlEVeKPuzzjHp89yVg6PVRreCxgFarUFnnjAkj0dSKw8Lfd1TTuaCn5+1PEYfNHoiu0Tddaiky+raNSl+uqMlOnS0Xr5zbB1+yPJ6CzG3CICYgOVzHUPVpXClLEnNtbDhscuboZuiGjOeyqoAdBGilyYDngklAM4AA5CZY49fGYB/A5S409mAzIpytIxJcgwnTEdfNdunmHd2bkOK5/AaVDj3Dfg+j2jXY5ceE3gGtUOsuPGD1UrqYQ0OugiHXFFho70wJ78eufFsSXFr+7XTYm5hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MTDhkW6ie50jKMfiuAAhbhZSA7FQTpjq6GjEimTqzXM=;
 b=jpRhPtONFY4sVbUr44mXAaEZpVeRyBoTqe8aXe3iASxmuqgWaJzDQd8MBh3HQTFqo4MOZ4dMDwksW0Ek4mzd3TDlksq6L9+/f+Q+Mg1tpcXpKP4rfasYyIjyFyj1f0UI6vgHwAETEpzbP8Hl2JnVtmtY7DtJSnRIoy/A0nzUZbtUdaOFv+uVAogt/b6EQc1y5leZubC1ner4Gl5GZ4FPOLdki6VGs7ZNXRGWdCungb0TOQMEj2P9zpzJRsUFku5mcetBOy+hx1Lw4KX/G0sfvwpSqHGlLXp5FslO7+3PPxYRXRxB2aSeRMCaJ/kkHUXPfbNHZX7/bzIAZbt+peP5+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MTDhkW6ie50jKMfiuAAhbhZSA7FQTpjq6GjEimTqzXM=;
 b=P0yyDnjDiDYn7u/1aI/D9LG7qK6KNsfP5Axw1gg/MIbDOMkcQVCFfMo2cZR1Frp5tDqhUNE8CcaJ/k9JwJjiSoSC/cjN6e2aIf+4tBlDzU+1SH9nQXaKk6AnL2AlU3e564Hu9qTuIiDZQlYCFzCObJ5wMd8OMDxDGxwocLsH806D2NBB8cA0bxyfsJ54Yeles+bVG0FMc7TJzooXcQHcA04RHcEnlhohRfGr4ZgeGhffmRr6mZU/2Ci6WofhVU8kDTj3wbGe1KZggBPNkUAt6E6DEmaVDw9daNFLp8aaD5154KmSC5apRNmxq4nnx2/smAAsN49oH/UiEVESANt3RA==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by CY8PR02MB9156.namprd02.prod.outlook.com (2603:10b6:930:98::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Thu, 4 May
 2023 14:45:43 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bef3:605f:19ff:568a]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bef3:605f:19ff:568a%2]) with mapi id 15.20.6363.026; Thu, 4 May 2023
 14:45:43 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com,
        aravind.retnakaran@nutanix.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v9 3/3] KVM: arm64: Dirty quota-based throttling of vcpus
Date:   Thu,  4 May 2023 14:43:31 +0000
Message-Id: <20230504144328.139462-4-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20230504144328.139462-1-shivam.kumar1@nutanix.com>
References: <20230504144328.139462-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0274.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::9) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|CY8PR02MB9156:EE_
X-MS-Office365-Filtering-Correlation-Id: 7905e849-bff9-4a84-df4b-08db4cae3ca7
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dkvVtferotyG61tIAoDwNnUVhbzNmyRn9JB8ftxYF2hfwXPjObMHYBJrYugguC40Aalwl32AKO2XFgFl2Y3vlxfIqgXFavZ/rppS16Ts4ug8R1VjZjF1JJtnAzgs8a3TiEeHjXL6/xMZYEGFSyH9kNVOVLEPGGN77eehHilbGsVfDIv4XpkfnDIVF6ejPB7M0NwbrU6bHXda7tk0KVr0cb6poBxzzSY1HMWzXzXfajakvO51pKJWrKWU51VMzm919sQ2Ljm55Up19SCOOoVofXq7W9S863es9RWu+L+om14tSofGCjgQVELku2J/83YQAqEF0QS/yNT20H+XRwY07CCthQLRw6JsgsHzla8drrbqwIucSy5zsAvrSj/JWt+2DOtzU5U9HTEXklBxvHB3WGR8aFmLn013ud4D4CevNE7dtEi7Sb2kunIlEzDb9uQW+75HFyh1ibgdRhzyEYDNgbv7Mk3wJMCG7ujZKuUN8wART4CMRNC6OHgFaCeaf4EmPjLspa4iXgcXTDFolkvmPZ/sXCKFDvW2y7ZNGS1nOIylzCvkNH9R+xGexgtoXSpWjef/uZB6PRi/TJzEXzyfWQePlIaZ/ykym/Z0ofPFPU935UIzpCaKaTlvD70cbfmy9SnFqzDDSBPGzoEhcfg3zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(376002)(396003)(136003)(39860400002)(451199021)(4326008)(66556008)(66476007)(36756003)(83380400001)(66946007)(1076003)(6512007)(6506007)(26005)(186003)(2906002)(54906003)(478600001)(2616005)(38350700002)(107886003)(8676002)(8936002)(38100700002)(15650500001)(6666004)(86362001)(52116002)(41300700001)(6486002)(5660300002)(316002)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XUk6BTgYUP6GTuAyzyxwkxdg+sYofW3xh3cNsYB/5iGalLpzyB5ozO+lo/JU?=
 =?us-ascii?Q?j+YYZl/hzMnzzx9UPon+C8jImTHdP1SgizFftqbEblXQDdAvmTGH7GS++b1Y?=
 =?us-ascii?Q?mz1lhcDvAuhIP75c47q6DEDTKUo8wZJWB2vLXUIBLQmWik1OnwtiC4hqvhci?=
 =?us-ascii?Q?Fpk0mqIJuz1zfFaV1ATtbHx4Y8Za0htrRvkyxAOp+gySrdRWA3iLhfcfrEr9?=
 =?us-ascii?Q?0XyRNt2ppOvRhXAb385YubPZNa/8HmFOEhM4jv6uu1wx0BcjCqgRDzedY1TK?=
 =?us-ascii?Q?3kwG0lD0FKvG/06xZwOvEM3b9siBWq7iw75vOXxgMaSUQjtWM6iKI4LowhKE?=
 =?us-ascii?Q?5m3yc+iR5zpYKL9qMLPTWuUuHuifNmMQGu08nZ8bkKzfZk/Ezjqw2280ElBO?=
 =?us-ascii?Q?pbwdDbzE6GOZly5MKvu9eUR8aqE7WnO2PWciOKXMVBGQ/QiLSszRmM4HobaD?=
 =?us-ascii?Q?utFFebnFAjKly0qlGx1nNgTAGmE67ekdB+NWMstRLSTbNaHp3aaQtH57BtpO?=
 =?us-ascii?Q?CMwz8bCg30kjsthI6VKiwR4dqfTMCdR1EZYRV7sF/0OjxFvDFNcnNSDd8C2M?=
 =?us-ascii?Q?IhqI8KYtkthkCAW42UnDjeLatwh0lXd0hRqNQvKjDialvguQYMUoz+V+nbM+?=
 =?us-ascii?Q?aKZ58YLJn5PlLQP9SCSyQX+dwYKuvVyn9GFXNxRDg5nhceBbAh0O62eol18+?=
 =?us-ascii?Q?rZqzpZisuOOLQDFhLdGW+bTC7PgL3SbTAyj4jXysnRnDMlwpaZQBrUY6I5Kd?=
 =?us-ascii?Q?o/JC8+0mx7Ol+phSnVK3P6O+x7PJ+2a9SsUCLEHEV5kHckt8O1tA7r5CjE2u?=
 =?us-ascii?Q?HPDYBaIT6NNXQssM/HV4k03K6FeY6gQmzEz2MAQEq0LLj8TQZJ5wxzmEIIKB?=
 =?us-ascii?Q?8+2Es49pLC5yypUR3GguOuhQUIb8HYEeNNJbNZwpFZTB1DW+G0RT2qhLdwWl?=
 =?us-ascii?Q?3pr6Qgkt+iCezm5M9PpgCWDgzzlMb8hvzFQogiY1JuvKNMC4fhTlzgWHsyHi?=
 =?us-ascii?Q?XneQOY5B8t8dXEZELpBbIKzq0uH7jEWsNJEr+zHmjMmtzJewBxgMdFezTgiw?=
 =?us-ascii?Q?Xvx/dNiyFDndcfWS0O3oX6sGRo2rtLGOShCDiuG9c3PPtbGNVXGSOOojQVet?=
 =?us-ascii?Q?A3G30vPRg00pwBWN3GuYFRsKNI8r80H2NLiRTGP7lasYyluDMGbbETjfZBvU?=
 =?us-ascii?Q?kZOemCza80tFNr4/r7Ul5QPuXOgAmIZej15mLX0kZghvZ5IK84knez8rqdA7?=
 =?us-ascii?Q?TEI93qljogi/lqieWDigT+iklwFTjN7T+TMi0s4oXy8QKRymYiIEwjlkKdYH?=
 =?us-ascii?Q?JEimB5PXDSgOahBLxFWnDGPjg6w26Qu46O/WgA1W2JO9xlPXxHJEdL6jRRb2?=
 =?us-ascii?Q?WE2B0uBWykQ2mv9sZdZhs/vcOBCEDTroUn27/rJouX+cJYE90vOzgeCtkojs?=
 =?us-ascii?Q?dYKZA/lWNA8P6ZfyrmKqDf+8nBVX3qWxylrUHRpBTJBWUE0PERi9eGeHvA6e?=
 =?us-ascii?Q?eyodyZIfn7qyqGR3Co8sxzll569SPxbzFUshVln04ugjZWZNWOVa3zunqAI5?=
 =?us-ascii?Q?XiY4oywGUA2s5Q+rHmaIIQlX8E9ja/voeWDlhURoufmsN+tW9kyGJnJ5/vDe?=
 =?us-ascii?Q?QQ=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7905e849-bff9-4a84-df4b-08db4cae3ca7
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 14:45:43.0559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AaC7l6pT3GRKPlKFCPpNmF/r8OK7u0OVS3seb+7tFjSUbe2x4CoYjhnYg+KxzQ3GYpdF0ZcWUGJPWTslSbjRYqrvxnwEv+JMBRtALiCsYLw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR02MB9156
X-Proofpoint-ORIG-GUID: q0z3dLcic0TebLKfBZqHcaG-rK74nxd6
X-Proofpoint-GUID: q0z3dLcic0TebLKfBZqHcaG-rK74nxd6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-04_09,2023-05-04_01,2023-02-09_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Call update_dirty_quota whenever a page is marked dirty with
appropriate arch-specific page size. Process the KVM request
KVM_REQ_DIRTY_QUOTA_EXIT (raised by update_dirty_quota) to exit to
userspace with exit reason KVM_EXIT_DIRTY_QUOTA_EXHAUSTED.

Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
---
 arch/arm64/kvm/Kconfig | 1 +
 arch/arm64/kvm/arm.c   | 5 +++++
 arch/arm64/kvm/mmu.c   | 1 +
 3 files changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index f531da6b362e..06144ad3cfae 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -43,6 +43,7 @@ menuconfig KVM
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
 	select INTERVAL_TREE
+	select HAVE_KVM_DIRTY_QUOTA
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 14391826241c..f0280c1c1c06 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -792,6 +792,11 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 
 		if (kvm_dirty_ring_check_request(vcpu))
 			return 0;
+
+		if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
+			vcpu->run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
+			return 0;
+		}
 	}
 
 	return 1;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 3b9d4d24c361..93c52f7464c9 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1419,6 +1419,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	/* Mark the page dirty only if the fault is handled successfully */
 	if (writable && !ret) {
 		kvm_set_pfn_dirty(pfn);
+		update_dirty_quota(kvm, fault_granule);
 		mark_page_dirty_in_slot(kvm, memslot, gfn);
 	}
 
-- 
2.22.3

