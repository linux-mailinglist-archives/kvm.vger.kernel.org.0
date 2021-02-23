Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F683231E5
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 21:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbhBWUKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 15:10:39 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51706 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234170AbhBWUJK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 15:09:10 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NK5aov172602;
        Tue, 23 Feb 2021 20:08:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=K+cmskWO4KMrstqQI6PxoqOUASU42S4XbV+9Yen6tHk=;
 b=IpSwoGQ4PJVvyjQ9sQqhMqlYfEpQKqe2PUh4dF+eTT9xnyVJl7KVzjFQdKv+YtwfUDSl
 g06EKeSBo1BRLxrz5mfKbI5n/bhLCqovsnsStwK2pZSfd1Aytff9pqyOGUyE6FGPei2f
 gWr+/78iuNjN52VaCoHRAFE/+0yU5fnJOaYJ3sATOGb8db3TrWXWNZwaMlOe2sUKqqcc
 jTtBlv1M4ANM0PPns7xz1cGveEPX7aRUqKH+05omxXYnrBySL9ayW5mz/TYHwvE5SI6x
 Z34rHow+h2WPvXullOOO5+m+0JklmdWkfqWyYo9FIeusxwFXFRTiZqmLzekwvNzT3C8Z qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36tsur0qtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:08:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NK6Vd9106920;
        Tue, 23 Feb 2021 20:08:18 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by userp3030.oracle.com with ESMTP id 36ucbxyc3h-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:08:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PzDmudYvxzeKaS5p4XcGC3fqojZjsnu0p+3tHrnl9hYoYq4KfzHc1TDNwQCqOGlJ3dcITPICGMHcwdxeWguiFd3OipAP/3yxXj10kyDPhIYWI3unHaAUUt77cW/tZeaqc4F7zmc55E+eXCyUwM5fQkH7vWnQim1e+qySx5eE1wPy5RYEWmHzy/Mfpv3P2GPqkrIZjhg75rLqbC/pIuZjfqPWEiZh5BbKhLXpWQbL9B3VN36mS/JfrjZcYXLHu2+2SrjI/NuHS+0lH3aTCjf7jQO8flOFHUvlCmfhkIwR8RB4k6//WSm3hnIabjEidElpvW2QloWUt7u/U18whYc+uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K+cmskWO4KMrstqQI6PxoqOUASU42S4XbV+9Yen6tHk=;
 b=SdDPDpg3wc2bIMM1QM46qIZpyPHABxbycNwEk3+xkDjOntQ8tqFnedI7NGNXGWescyT2Om+nD7CwoSIrb6qMM+PnuiIENyQcGy2btAQQjJEWrwrCHNvtY75amAGqMXH5cDZq4lRs+WnR3KRAV2+JfaNtzPxyOk+L8Lpo1Lkjg+xRvwNs+mZ6pb3hX6jrECnfodnP1XvI5oy3Khl7oDNp7WHQUN2mOzzRESRniqfsJ54m3eJURsYKJ8h+rz4d76gKcxXt3floCo5ld8ZYwUfxcX8n3+7Z+4UcJf0J22Ido/egIzjDatvOWIYYwQP87IbI6/P8a9kgdBfrAt9Bxw36gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K+cmskWO4KMrstqQI6PxoqOUASU42S4XbV+9Yen6tHk=;
 b=V64+O7vSBkdQcrNUL8z82j3BY53RRMdtf6SkwNd7wzIyl9tyiu853qBiUbchhirdXRr9B8WRNKwjfKHRmKOmrlOql1VK9qHLYiFPoxbq9k1b3DgxtQrBIvi1XXe6jVYXOd7Whl+Qc6irQBw0JGsXrUlFmQno8RzpqbQqSqUg+VA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Tue, 23 Feb
 2021 20:08:16 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 20:08:16 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 2/4 v3] KVM: X86: Add a utility function to read current RIP
Date:   Tue, 23 Feb 2021 14:19:56 -0500
Message-Id: <20210223191958.24218-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210223191958.24218-1-krish.sadhukhan@oracle.com>
References: <20210223191958.24218-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.200.29]
X-ClientProxiedBy: BY3PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:a03:254::31) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.200.29) by BY3PR05CA0026.namprd05.prod.outlook.com (2603:10b6:a03:254::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.10 via Frontend Transport; Tue, 23 Feb 2021 20:08:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 462dcdef-d778-44e0-80ae-08d8d836c1af
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:
X-Microsoft-Antispam-PRVS: <SN6PR10MB3022FF2CFE76AC579D75E24281809@SN6PR10MB3022.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qjfglLfse/w+RNcIHOdsAP/nbOkA/WWElUPf7eTR+g+2i6wimujZ7+4xwOsAyH78svcYFvSeph27JhSCbfooy68Jk4bT1gLgS2qQKqMMzoX2HWwv7ztED3fYlhzfh9ENxv6rGD8Tkpoay1Ynq+JQ6778DrWtJdOqkpwIMxmAvFiqamp52dFMdZ0HgIcWQWi9ps4FpilgJGdhlLlvn5sEG7QkbdADRJJIofPK8bsLF5u5I8BKcqT6w70lXRHI/zVH6NiyV0tCkxKGzcOtvpCXc964c+0w9LqUU3XercX3galcTW+LCvgcuJGLJv+SwSWepL3JIzByUBnCYRFl2n7hRPwgpHJAPf7zPAPKqXzyaStk9ytgIYpxn3Vn7rGjNFnrplMt4HVIU0/tvsQ7HgigqTsvmY+IX52S4JPJVZ1iMSL7Zj8/Ru6DT7NXK9vdBb+L9TSbcuGvO4hNLfbGABMkncaUaihIPMiEmoPoZo1EoHbGdCYiq9hPv50U0BlP/bPM0SaZvN8UkLwc9G552RqvpA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(366004)(396003)(376002)(136003)(66946007)(26005)(86362001)(7696005)(66476007)(66556008)(52116002)(1076003)(186003)(44832011)(16526019)(36756003)(6666004)(316002)(4744005)(956004)(2616005)(6916009)(5660300002)(6486002)(4326008)(83380400001)(2906002)(478600001)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?chjvBEzeJG5JiIL+D/z9/bIq/feP+skpVdXQqwI/A8mpHB83sIDscZ3oM+qp?=
 =?us-ascii?Q?I5UZMJ+sDJmSRJH4TWCVc7gETl8Y/RdGcn+GAIn+0j7yJqO34AUtk6+YAo7w?=
 =?us-ascii?Q?FTp/khhHMzdIAHzJROF57afUcVMtNd/saQxHr6BUB2MmK8zjyAK3uH71LS33?=
 =?us-ascii?Q?mVkwPIwghz+9hWJtj23kShoPEtSQnRyiH+Rkomm9Q4w1+EfMvOgOqUYN5Qbi?=
 =?us-ascii?Q?1J5AnX/JPZvntHMgZWboxuuthIAvP6SOg/vnr2R9irF7NI0KnfhJjWkEM8oe?=
 =?us-ascii?Q?bNYtFU8pAijeLIOrH41+uMR1k9gyQgnNq0Kfg81s0foXRCsGLINHvkgwx2wD?=
 =?us-ascii?Q?fPpyAD/1MIQly2BC5sxrpUNkw9W1PPluzNhnl9xAXAOibw/TaytEpdMOE05F?=
 =?us-ascii?Q?R4048XlGlNMZ7r2jqwHiC/IKTdGIFPtOQ/X6vFW/wirlOACVLPmhAHPQQlfc?=
 =?us-ascii?Q?gmopP2kFQoq2rWDxfVFmKI4Ybc9AXbTrMIgsgxGeqroKDn3hGwfv0eo3kAAw?=
 =?us-ascii?Q?A2DdhqIwu0twiRU6cDYlwAyd+hTVyaANttUe90nad2ByHdF7Bx8CJX06wZhO?=
 =?us-ascii?Q?kTUSTskcC6GM/WbCLOzmRP5uE8MD3cnz1IJzXJ8FHDsUZA62bE76Yk1edtah?=
 =?us-ascii?Q?gfMd+eWTwSraPt4hM4IwWHNDwJDoowgqZCGlSNpzo6/DVAWxrZSdQg3GvqUt?=
 =?us-ascii?Q?vUHlkILv7JhYTcDy2tA1dzFLMR4w6CbG78YdHeKZWas3mg+vEfCnYIvLHQLU?=
 =?us-ascii?Q?Oq7v6zRVK14uCdJdOU+UMKNgtp+jItArXS4B0wh6jH9OX6UJf834kyWldHxB?=
 =?us-ascii?Q?J8XqyrC4/O5lxPSjG2WZYGCDdKZJGFwpZ51cOESMpL7dLmhbIkjRlO8QzeJr?=
 =?us-ascii?Q?+e9289NTv9PygzNMYlbXQoglgPFDa9HAJPWnbE+EWsMljHoOFkEI00LelUV9?=
 =?us-ascii?Q?oCbP1qrUG6S+nHduIBoSlyVmsJRsgpP3k4OnD6QuxKVtUIH6Pd9AvFhN9+aB?=
 =?us-ascii?Q?4da/Erh36aMkmTVqJYnodbPwBmZQaVyIj6CZnrFrquX49s7OmMUfkTY1C6PD?=
 =?us-ascii?Q?Fu6g/ZgexjB90YDK92VmCGxevEdaLKsk8DNlpsWpgLPnrSGBPM1ihb2cgcqh?=
 =?us-ascii?Q?L4HqRpKG5ayeW1ZCYcPAmVfnqlKKYiyhzo24JQC3N8zzaDLYCMgVZzCN/kIB?=
 =?us-ascii?Q?2fv9UPzLaphN/ell+uKQeqLxu9kfErY+2zbG0dHygAsjfLr3zPlE9Fhn1y4k?=
 =?us-ascii?Q?4hOXfR91uRFlqaqv9n36PBMx18/XHGQhSh+1NiaUJEU51HOSuH3A578S3KNa?=
 =?us-ascii?Q?riyYowUrr3fK3gsu47DtcAv7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 462dcdef-d778-44e0-80ae-08d8d836c1af
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 20:08:16.5071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IcF3anRUl/ssrPEUpmHYUqfgtrsTgfbNd5tlhEPDUz1e7kYRqPA1XP8zkjyP49pnZp28q5kSanpxOmjZ4C5snGDASVVUOzEWFxjoA2eUdKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3022
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230169
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102230169
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some tests may require to know the current RIP to compares tests results. Add
a function to read current RIP. This will be used by a test in this series.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 lib/x86/processor.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 87112bd..5604874 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -489,6 +489,13 @@ static inline unsigned long long rdtsc(void)
 	return r;
 }
 
+static inline u64 read_rip(void)
+{
+	u64 val;
+	asm volatile ("lea (%%rip),%0" : "=r"(val) : : "memory");
+	return val;
+}
+
 /*
  * Per the advice in the SDM, volume 2, the sequence "mfence; lfence"
  * executed immediately before rdtsc ensures that rdtsc will be
-- 
2.27.0

