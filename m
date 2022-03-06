Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCFAE4CEE19
	for <lists+kvm@lfdr.de>; Sun,  6 Mar 2022 23:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234317AbiCFWMF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Mar 2022 17:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiCFWMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Mar 2022 17:12:03 -0500
X-Greylist: delayed 121 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Mar 2022 14:11:10 PST
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C592612A
        for <kvm@vger.kernel.org>; Sun,  6 Mar 2022 14:11:10 -0800 (PST)
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 226Gw94O024671;
        Sun, 6 Mar 2022 14:09:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=dY+CZmFqo9ZW7nrpzDqKJHMfSDyYwRithYv5S5LgVLI=;
 b=R2SDb9ickgmqhSFi67YrWO0tnmgKsgw8UZojpeP1jJEloJ5TqIa6TvKzzbT+L3/bShQH
 hrBmYwy/t98kd46kxCkWil48NDr0gZJRZyXeq+vQOLc4G3fIl+wZ4BOA/Kj+Ptzm/zlt
 //kpXf+idT9Jsos1ZhfLzPdGaaQ0d0DZs7IxPxCGYSIIDhxubsN07ggrQR1GV2NJpb8w
 uJL+EUJRnCebEFKi9BVVDyPXJHGzoym52fI6HMo7LCa+KYNtlVJDWoY/y8fk7VtYY0MA
 BpimMVyFRcjDBW6eIa4bYji7W5nC3IWZKbDMaBP/l5Qmp52pl/9V/05mlPLMYmKKHWD3 hQ== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3em52x24f2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 06 Mar 2022 14:09:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HzIDv973RIPcsZrbB9gX/L8JIb7yUeZghS6MF8z/sh2TMNqJHc+bEpNBWI3ViKxuVRY5NJTOlOuHfNcZLQ+kkF2WXurm/q0k4/34J+jM0zg2Z0qzHyRntZio3Da8AUNoUI6szmvL6naKer3ytfUYqvxHET48IBNQAj3ICdBD0wFqiYGlo+78bvI4jauR+NzjTYhNUc3EWKMqv6Z9EsghgOAnWH2UNg50bdhVbyEXgPaXBB0NKz5+4P+q53FWwuWwyFHxcgVbuyczjS2ud6alxTVaMfJgCQqsuzqDHTsWNxiNr0V2ytSVey5k2KQte491z7LIAfiqG9QE2JOkcvhDqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dY+CZmFqo9ZW7nrpzDqKJHMfSDyYwRithYv5S5LgVLI=;
 b=nq9suu3Khqx+PX0O+pQ2XujlG1YRcMkcFbbxTPdTHGD0qVnTD4LXh40T9lKAq7Y16TOD8DgnLGqXArKGxszS/ZWhgohS/u7f8pUN0p7gON7BHO7Uz66oTAVypDVzZkxBKZTGmpjjzdRe1tImJMLMS/OiqX6ddVRZs2zEk8vPCKYuoZWhaiWo2I3Ey0LzYnQwVdy9BDyxjEQaoJgy2lSlPnmc8kP7me4BVL0MIKsH15eTq5sCdXzah9qr0qP88D8MtLrJqVwBoyexpcxKntKEb/CMxqwD2nZ6Pul6l1x1jvrovebKWD9pWUcfDsBK6ZDw4mfB5qZadyKEWMsxXcbWPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by BN6PR02MB3234.namprd02.prod.outlook.com (2603:10b6:405:65::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Sun, 6 Mar
 2022 22:09:03 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::88fa:f43f:f4c7:6862]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::88fa:f43f:f4c7:6862%8]) with mapi id 15.20.5038.026; Sun, 6 Mar 2022
 22:09:02 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>
Subject: [PATCH v3 0/3] KVM: Dirty quota-based throttling
Date:   Sun,  6 Mar 2022 22:08:46 +0000
Message-Id: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0155.namprd05.prod.outlook.com
 (2603:10b6:a03:339::10) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f78943ab-5352-44e9-b73c-08d9ffbdec38
X-MS-TrafficTypeDiagnostic: BN6PR02MB3234:EE_
X-Microsoft-Antispam-PRVS: <BN6PR02MB32342823B4E90BA096B04BEBB3079@BN6PR02MB3234.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XGMi3MbfmNPLtJs/OdTmn4hi9FvdG1hIo1Tdtx5xgpZjx49Eu3fFa0VYGtxIqhqhTZL2iB0toJ+lh8HvBCLnwzFi3dCHpokTOQ36NezAb67+N9dlZyqcj1Ea0sh64r+/uFJeKnD3gE4vtZgg2Me98DtEJ1FMqufzPnJAGykbOFGQ9gSws+51Qc7IXaiPbJPVfyeDiUmp4Ugsw5IfAZ9jgge6kj5M36ITUEkZgDZyfOuJ3mEo9B0/oirfkQdnUosHPEboQs5DVgEjnEBC9ah4USpqlPEk68IU+MMWQi3+8KbB6JTaQHO0tW22vKy5w6ahBBCS0uDnq8qdXIm5zp6VlFCaLviqYYJaaIuW4ii1F1iUfrAeHMPQDgGJqDCN8JI0dhe235VJyjbgfNivnk3RTiJ+dI+MIlRojrw9SRExY9h/siC1VaYuTMnnyh9WaK6wJgjqIyHSvGCYGKpOntFRuYp4PvDz/c8UNQnblajeCsJsZHrXvUIn0kDH8F13p2d6itaJPbCqrIvO/dvRL58sITGOFwLPwxW+e4PuRhuA6x0welkY0yVelzsdhIjQ07wHeqSOj5BcfBDsiECjR33KbNJ4TTP8Pno6d442C1BVaWbm3rvZXB0UwUYv0dcfmT9MD4wlynd54YtzlRa+NWdJN/z6pS1eipPCf9aZ8hy0rL6ktk7A7H48wWGSCkaTryeZesupqnK8FkYB86NrmnvEBRGXB65sQLkDsS3zQFkH1Ak=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(2906002)(2616005)(38100700002)(1076003)(316002)(8936002)(4326008)(66556008)(66476007)(66946007)(8676002)(508600001)(186003)(26005)(5660300002)(83380400001)(86362001)(6666004)(6506007)(52116002)(15650500001)(6512007)(6486002)(4744005)(38350700002)(107886003)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jgpij2dGLw5FIvfW6Jr4gw3pAv9qNIEjqfpd7G+JB6FSTYtKSNgYGndldkVm?=
 =?us-ascii?Q?F5a1f8xcbldBvxAJ47tLZmSq2Yzj30wfQupKC251uSDTytoLvKNtWhUTuffJ?=
 =?us-ascii?Q?Sq5JgZpfKOU6DXWJxEwLitNzRT7TAHeX7uYzRoTXde95R7r2TIrDYngWZnOG?=
 =?us-ascii?Q?IjG89yf6Wiswy/n/+ROICKqFlys0O3R+yeFosxF0/TPIe4PAuIhWY9cVdPiE?=
 =?us-ascii?Q?BiZ19oRAb/f2skfRKDycAa42GD4SRXVJBuregjOg8jGQxu3isCFYi5gKE2zE?=
 =?us-ascii?Q?96L2eRKjPcA8N3cb9iMvezv/zgL9IoMEjfRroTV93levvROA9F3YDfhtE0AB?=
 =?us-ascii?Q?XZsi8jQLCuGTfeqb83f/8pB4Suzn178//+UT1y2bJEmPTcuOTV8E8TJul37L?=
 =?us-ascii?Q?Yy/cQfgT4HCk+1MdYVDACh2udzR9A6DuG6D9hiwm+I2NtfIxLPXyfjNmYBOj?=
 =?us-ascii?Q?R1eCKqg5So0cA+DtxzAjj1osPdqsG8SsNdpnNFgwnM6UhYTkLvSfu7eb+HY9?=
 =?us-ascii?Q?jCyVpLpvWoZGkBtjMOv4ew3qWM9jZbMgboarqOV6UTqmrL5nTpplfg1awPYS?=
 =?us-ascii?Q?CCNbFLjQXM0SrKGzmGZxFL9NywDahNVwAzQRbVdATN7nDZ15OpmlmFnG/Wd4?=
 =?us-ascii?Q?yE1PpLS5u43l6PYPkMe7iPGF4YXoAGUCoWOXDKyEGQrcFsy2cjV0Aa+a+da4?=
 =?us-ascii?Q?4HUySZ67HU3upTvgILLr4W4LFJhhuAr6y8puPxEwU/NJFc/Mpp9BMzMKqafc?=
 =?us-ascii?Q?f1V3gcPvOSokeDUhMUx6q6I+fRjYF2jJwQ3uc1E8mQ6x5cnXQif56Nl2lVpy?=
 =?us-ascii?Q?Qc1n2q8EWnjnPt71yPPVrFFENACYSmY3malt+cuoFq5+MBlyV6aZPSM1yaux?=
 =?us-ascii?Q?vwJn+WwNyrLhS+BxiAU1p9Z2DcQw5ttrCxMdr15XPv8z09g1SpJ3nL93v9Z2?=
 =?us-ascii?Q?4L/rEPveIlB83wg/IsGtA1wXJMffi4ca37uTnYUUxz57o7YW7MQMdeaGqm/O?=
 =?us-ascii?Q?uMupR/441+dGUlqrr04tGBR8NDhTaxcFoG1NKqrIxbNUG95UfwYbNtbrSITY?=
 =?us-ascii?Q?K2ylcEVu7f3UQ/h3klAU6EP1GqWKv5yo0/h7Y8bK/QCZEsCxlfzlYlh9bUDu?=
 =?us-ascii?Q?cLjTpHuVNYdgkzFDbfh9lly0MwCG8DKJ74UbvJbpMHcG+MnpvCIWN2/czwGb?=
 =?us-ascii?Q?DNtZMkB5A2cKDJBQ5vpSRFzE6Mmf9NSRKmCoJcnNUO/9JmidxAxYDhtKGPqQ?=
 =?us-ascii?Q?SarfUmQMQPhPweKxb5K4K5YITVv8sTaopVbJ+VAyqIrlINt9+hkS8HL4uGXL?=
 =?us-ascii?Q?PyCcZOarvYyympfcWiMT9baKdhGpwvBsm2xvflQRFo2JktNC/5cFUpnydLhj?=
 =?us-ascii?Q?bxiWCwjOKzWsF/KUVjP8rCg+1FdHCvkq3cFS5OfiC85yTxwy4gp7rm9LnxYT?=
 =?us-ascii?Q?1YHLFuf1y7aPhFwK7i6b6JF+nbY89vGs3ZiOiEuibUchQXjCCfaFT6ARbOjd?=
 =?us-ascii?Q?DqS7FZRdZ/pLAOtDztKnNSGkfOYJgEy6Ew8lXUBbp4YKjEl6/4/SRMwOnap7?=
 =?us-ascii?Q?JeyBo/dksjGmfCROGvv+OXJrUE4wScqBmyLsF4VUq6lh6rilhJnAmScg6lmC?=
 =?us-ascii?Q?4yBSbtSnaIY6uZ/14UrgparVUZFIiq3eRKJgTmRPKYy8ki+7P0OewOEO+f8J?=
 =?us-ascii?Q?bOOt1kwUqg36g3c9XBF9FwN2clo=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f78943ab-5352-44e9-b73c-08d9ffbdec38
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2022 22:09:02.8552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lq/Z2gV94vXJN2xw5gga+itdtGb6+xW9yv/4EWZpypQQz+/I1dCnrTyTm1r8eraNTzXSJALiPrmlEynHUCIjxDu/luKQdjDkKJRevcK+QMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR02MB3234
X-Proofpoint-ORIG-GUID: DCvRPe7MkWns4GE9jFCDitC6xZO4IJrv
X-Proofpoint-GUID: DCvRPe7MkWns4GE9jFCDitC6xZO4IJrv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-06_08,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is v3 of the dirty quota series, with a few changes in the
previous implementation and the following additions:

i) Added blurb for dirty quota in the KVM API documentation.

ii) Added KVM selftests for dirty quota throttling.

Shivam Kumar (3):
  KVM: Implement dirty quota-based throttling of vcpus
  KVM: Documentation: Update kvm_run structure for dirty quota
  KVM: selftests: Add selftests for dirty quota throttling

 Documentation/virt/kvm/api.rst                | 28 ++++++++++++++
 arch/arm64/kvm/arm.c                          |  3 ++
 arch/s390/kvm/kvm-s390.c                      |  3 ++
 arch/x86/kvm/x86.c                            |  4 ++
 include/linux/kvm_host.h                      | 15 ++++++++
 include/linux/kvm_types.h                     |  1 +
 include/uapi/linux/kvm.h                      | 12 ++++++
 tools/testing/selftests/kvm/dirty_log_test.c  | 37 +++++++++++++++++--
 .../selftests/kvm/include/kvm_util_base.h     |  4 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 36 ++++++++++++++++++
 virt/kvm/kvm_main.c                           |  7 +++-
 11 files changed, 145 insertions(+), 5 deletions(-)

-- 
2.22.3

