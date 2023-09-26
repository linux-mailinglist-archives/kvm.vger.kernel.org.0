Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E06D7AF6F5
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 01:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbjIZXuk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 19:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbjIZXsj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 19:48:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD98A268C;
        Tue, 26 Sep 2023 16:10:01 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38QLTNHl025098;
        Tue, 26 Sep 2023 23:09:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=ARR1f+uwMAS5xPF6bkJfTjbl45MBhgqNmwLL2RZGtqs=;
 b=VhwAWkLPBQt8ZQbgXzxXxf+k9ZHkrmpAehnco4swS426+qjB4itZAqJ6X+MjnRhoVrEB
 9y7iozVkx+xqcOj9QoNjJSS4GCbacztiE1CiwHEiOjf+Oii2l1wInz+tPQoaseYsvSkN
 Kk27/LJbxlw5u2kRVM9ojCCcc8IfZugfkny+I0BlMnHDgkn6q8FLg4kCpJ/9XYVyAUVp
 FpQWD9v7iHsaCTKApxuhoa2WhLg90TyTy5B0uaDZkznM58W0Z3RpV/BSB+7FrbttTZTC
 XBJKoU7t7cRYZaB/tLaXmuuSiUdyaidyaC5O/jJY0u8cQIixhBrK+WSu1txA9W2Q+PBK kw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9r2dg6cs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Sep 2023 23:09:25 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38QM939L030602;
        Tue, 26 Sep 2023 23:09:24 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pf6rvdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Sep 2023 23:09:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k+yINcc3AJHPtLR7oZwc/a7HIH7rX4FAH3I21+zc1bKxthNw1pKwUOXixJMhCAE34lGkLXN7z1rhVe8lI7aYkpwUVGbna9/hMssthWUHWpGguKZ1VgV4GBJ5YTN7kXK2aveG6N5NuzjGoZvKPw1padmZEVMSTwm/YNCof9Fy4nbRjHRe+YZs8nGY2JSaCdFeLqToKije5uaA33jpnyQNC78ARDMPMe7k+/OAb0/g0RpJ5X2ncfQ1o2+/eiGNopQLXkyK/Nwe241JG8H4Us1PE47RM8pFHAyYsPZFU0vCtcmbwc1RFM512q9aVSOCkaphjMFQlH88b4+qmOXRw4i2eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ARR1f+uwMAS5xPF6bkJfTjbl45MBhgqNmwLL2RZGtqs=;
 b=MTrZPT6sXqEDgRTpYhQhKW2vWrB8EvKO8VhuAM/JhKCiq5Ghe+qsz685PJy+PXNj+BlEevuMXgQHdKj0Nyi22pduk8dU1kdaPeMsmajTQwTTbElfcrlAI1LcXSK32DhAt9YbYhXKFrogx/Ep6dbRugvGe0GLUv0CA5/IvUuFYhpitjF3OfKO53/CXIxaqjwtdCc3rqXtgk8U+s74gL7WbpelI/ExsQbod6/WwrtdOjK0WTIzBD/IA5Bh++mG7rrUDzW99jRHPcbvHkuAckdND7OuCjL+PUVbDZXBceR++LpPC/kfXW1noqsv3XWaoUo3ZwgBWauBaMAJ3wvaG87+Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARR1f+uwMAS5xPF6bkJfTjbl45MBhgqNmwLL2RZGtqs=;
 b=WPE8SRg68bMxBvWpwE0RI7hMHeHVjpm5PZfpJ++PnHBeCG9Y3l88PG4S/H8pdSm2gekpxGMnnhlhN9ewk0q3oAbU+KAD06vqzIR/78cM7RrZgSPV6eoX9Htpd0Li7Q7UfYfnOGLqG1YoGE2qJOvmlkh4h97yqLpZ+RymWJxp2CY=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DS7PR10MB5069.namprd10.prod.outlook.com (2603:10b6:5:3a8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Tue, 26 Sep
 2023 23:09:22 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::7e3d:f3b3:7964:87c3]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::7e3d:f3b3:7964:87c3%7]) with mapi id 15.20.6813.027; Tue, 26 Sep 2023
 23:09:22 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     kvm@vger.kernel.org, x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, joe.jin@oracle.com
Subject: [PATCH RFC 1/1] KVM: x86: add param to update master clock periodically
Date:   Tue, 26 Sep 2023 16:06:49 -0700
Message-Id: <20230926230649.67852-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0056.namprd08.prod.outlook.com
 (2603:10b6:a03:117::33) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|DS7PR10MB5069:EE_
X-MS-Office365-Filtering-Correlation-Id: b243f7c6-67be-448d-963c-08dbbee59ebb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oPzvg2N6Ssw9OpOby321aLW/onGjKSxLPsSxMuzEotS7jeWAA90BbB6d1xTOxAwoBSLo27kwk9+zlj/suUpe+MA5MWmmJwkJQ4vUJmtYzGKRgR4vbe5AUjdxNcWiMigdYGY6Os7bKVgmCSWqAAVeJd1FVFfXypfPR+BAQYkRsPBH7E1odbLVghmv1tN+Rc5+JZCHsJn+WFi9usiyKrGB1L7XEZL/6zfUghF51WQ8dGY7AMpgtdG4/YxPLYZA2o4pulL8AOhYM6+VgQL17FZ6GSFckWfWWmGxnweNN30jYaeO26zJrd9tb62W4sgPTdJ+ccvOjUx2aZOLnzPy6aGWJke+3WERkDWjaBc6Fuh8jZ+v4cBN3bQTXMFDI7vdyTqrLfxflhvsOv1xWMzGIDNvOGW/hAKMBMjwhY2ZttfXce2XN1ndpM8F90jojIOFOqyag5BoTubaei+J+ZBAIa97HK5zu1H48B/3yW5GKfcrWyS/eMAatFCBJfgKcYsdCYoJ4+2pgRJgGG0cTKRcB5xzVzyYH1fbf7kOD4JaP8cWDgc14jzfMlw0TLwre2/mLH9q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(376002)(346002)(136003)(366004)(230922051799003)(1800799009)(451199024)(186009)(36756003)(38100700002)(86362001)(4326008)(2616005)(15650500001)(2906002)(6486002)(66556008)(5660300002)(6506007)(41300700001)(66946007)(66476007)(44832011)(6666004)(316002)(6512007)(8676002)(478600001)(66899024)(107886003)(83380400001)(26005)(8936002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mJ2Q/z0wXAKK+uNcJZMWsJaXhlpA8bWMThd6APfoBE/HcJAjo+co+9kQoG7Q?=
 =?us-ascii?Q?2RNKrLCzfJ5VFgSS5v3oNPb2XnNbIpadRv7YnCjsHHtBxJgh//joGfUherbv?=
 =?us-ascii?Q?Knd3UTfUrgjcMxCteLcP8yEiBlyGyWPW7/ASUr5WyNm1/XT39cLfLSUpNIbl?=
 =?us-ascii?Q?TQn5pD0aQdEtJDopYHZEEyR2NNZoQvAeITXBz3qVT/JQIqj/oRSV3l9z3wuM?=
 =?us-ascii?Q?Y4TxjooH/G19VWjYJ5JLSvPDuYNrGQntf3BBXXevK0eNQcA40fLfEIh223IJ?=
 =?us-ascii?Q?pzi5L47zNQsp9KeIvcYUrHgYB51DndQ5gnzCRT7F4AOa08jItaAJaBx6dU3T?=
 =?us-ascii?Q?rcTlPbLOI0aAuGEUjAdtRSMmHSgr6xpUD8rupfoyHHgUjeSQgsrsA6WkkbKj?=
 =?us-ascii?Q?PLrJYd3+xt3EL48j0t2LYh7rg6O+zBSHTvGfWenz+B55nkG7diXLPsQOwep/?=
 =?us-ascii?Q?B7C4cRB1k4/i0zJwv6/cGjQ37eumxfO+lUEqks0RfTl1T0Rjthm8olsw/nxO?=
 =?us-ascii?Q?Gx+tVwMDklxnLL+fkdxAq6M6S2wI+WaKCM5nnSI3ospIHdVsEyqoo9kyDOBY?=
 =?us-ascii?Q?YQvcuN5Y5s+c7l/qsiA1YMV67sIy6JZPxhzO/8xh5APdKOt8QIgTU1i64ujz?=
 =?us-ascii?Q?ujrqPq9oj6pOYIOLedzzGSp8nU+JldFJ5pOpx/6F1K1C0t3kuMZtqApvvgPd?=
 =?us-ascii?Q?HIH9ZJs+fdbC6CKa4Hc4LE63OzviVQtPJBqV8ZO6kUqSgLUzcrHAPKHZqGD9?=
 =?us-ascii?Q?/5p9DtXdj7UMcAehN9e0gz/FGxfbzK/1RJL+/KPdIIajAKsDz3S2C+CQC785?=
 =?us-ascii?Q?IjkrZRVXQkIURGZdS3mnVxgXgulpJJIZqDRopiE/f1HEB33upQj81/ZfleMd?=
 =?us-ascii?Q?kfIKpfnb6XDUwi1mjAhC/oXAhj4x/qaA/EhIBra/cDzuNyQBZX4CRlhYj2vK?=
 =?us-ascii?Q?SplAf8EVdTDt2Lwo0txFZEfxwyUIX28yU+GD+a3zVffscndtuVErKneBHg0y?=
 =?us-ascii?Q?QMkQXf9HO3/MOkXX0qtXFv682nMXphPj3hwCTgYygKJeJhkXIt8LG5d2Nj8B?=
 =?us-ascii?Q?VMgiT+EtbHDmBFNFLO85nEpxlI6ekgF3zIZutCZOV8gECEwzc6fhmP/N+efj?=
 =?us-ascii?Q?GdaBKeC4c8qfV+Rt49cU1hZg4V7wlR5PR/QE22bNxBRsIMI0MXlAzvPGbsuu?=
 =?us-ascii?Q?AXIimA5z/aq8r36iOewFOy2/tLnfCnl0tIgGnrpiHfsYZ4+nHrjt7tjLY2YL?=
 =?us-ascii?Q?LM4SvKrrTK5bNTZFIBlm3Kpo07l6dpqgJ0zarazKVySL8X5frXfJNj3wq5b7?=
 =?us-ascii?Q?VWClhlfAaW4eS2Db6EWhPcV+AXfNMJL5y4GhF8xOIAvgbsBZanPmHGr2wrW4?=
 =?us-ascii?Q?KOyyXebgmL+RTOfcFkv/wdNyPfAJM9qy4V5WOO6Yy1S1oBIImbY3IQn0q0V1?=
 =?us-ascii?Q?e/bVZMatBmF0932OjUmMH8bETtb76GR7KtvmqnK4ludjVR6O9nG/uetQy1kU?=
 =?us-ascii?Q?vMYlz5xQypGAeOewVl3xSRrkcj9BBVz3NH0lW0NxkOLh4FMQYc6eLMFyb1AH?=
 =?us-ascii?Q?0WlZXM1S/wK8ftdYv7AI+rC7O1gcMgFb5XgVYoou?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?jQ7RaJacfl+xBoLIWr2ZxB3rjlRd2GO/KLrOCqYW2CqKRBuUBT6drICTcm3C?=
 =?us-ascii?Q?zbUeBX1GfsSNoDiXMzX8Bjl/FS80eMfgomt1xSGbYbAlkyQc1B/74P3xN9/P?=
 =?us-ascii?Q?R8sWQIucHSyJcKRZzfVGGXCtNl/BRZgCAQeISh257x8cYj+WPdlMQkvNaHqJ?=
 =?us-ascii?Q?B/d9dHtNF5w8k2iTEEP0bZ34WbeQJ6S3OgvLvleiAAYldRXE6aN8br2cJ4kc?=
 =?us-ascii?Q?6xJO/3KS6j3K0G1iEQwN4A+C0yJCijnMxfnxr7TGno414GtXTMfz7lS/xyaH?=
 =?us-ascii?Q?Cc1/rHWVNm7gGAigTqtbweftingxGa5o4NjjHwyxeu8k/SEGMAI8HtObF2AX?=
 =?us-ascii?Q?hKYF4U5qfjU5KQiH/s7YiUAYAwUcFZVc9og7KCrivlsQcsT3ptFNtZwX1Gpv?=
 =?us-ascii?Q?r/5736A8OVsywhj9rIKlfpLHY1LUxzXF1nzHafWppmfs8rjtWljDMjxUgK9k?=
 =?us-ascii?Q?2k+tVleO+Xo0oU6nMhPVdqLaR9Di36f2gZtxjIpbwMKw4qJzE6ehfKcLUSPW?=
 =?us-ascii?Q?Y6TOuox2Th+tR26HrgHwH9E0zGkt+cAteazEDh9UMWZdH1q2UxSSHj0jqOlX?=
 =?us-ascii?Q?8uw4TPRsuYE0NfChxE1SAN+g3oKFweUUyuBqr6hKhNsw/8nBBvtljOYt2tOC?=
 =?us-ascii?Q?UDK8vF4GE/fFKFiVwCN9AxFP2Jd+W8U+6vEQdkMD8Wnt5kiE4ijIyv4zB8xW?=
 =?us-ascii?Q?I5BQlmf/VLlpJpiI5/1foLvgqy9gGMp+Sj29lUkf+cb4ipf/XBthHFEvUolN?=
 =?us-ascii?Q?4pIpxYUVFGVZs7KupV/RwrBZqzr439gJ6Smp3Am/zMxAvbuJI8wa+3g+BMqc?=
 =?us-ascii?Q?0Ysir7WI8++a+O7jbKtY3YyJEblCFAzSsOb9WE0HUYo33ot8NFUUCcZxsYjn?=
 =?us-ascii?Q?2Btn20k4KqwKzd5Lr9NpsaMJvkDDGw2XGkCJB5p3OvOIgK56WKChhULQ2Um+?=
 =?us-ascii?Q?xhWC8E+7I2MxRWBooNa9lw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b243f7c6-67be-448d-963c-08dbbee59ebb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2023 23:09:22.4158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mBJbQC1p79WQH4gZ0pkqrF69CvJ8NXo2pd5jYP+L38Vuzu+G0jaEbAnm/xYQbKRF059HkAsWX/C1db1skHUhbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5069
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-26_15,2023-09-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309260199
X-Proofpoint-GUID: nxju4DI2XURNTbFX_5mW5n8ym02S18yE
X-Proofpoint-ORIG-GUID: nxju4DI2XURNTbFX_5mW5n8ym02S18yE
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is to minimize the kvmclock drift during CPU hotplug (or when the
master clock and pvclock_vcpu_time_info are updated). The drift is
because kvmclock and raw monotonic (tsc) use different
equation/mult/shift to calculate that how many nanoseconds (given the tsc
as input) has passed.

The calculation of the kvmclock is based on the pvclock_vcpu_time_info
provided by the host side.

struct pvclock_vcpu_time_info {
	u32   version;
	u32   pad0;
	u64   tsc_timestamp;     --> by host raw monotonic
	u64   system_time;       --> by host raw monotonic
	u32   tsc_to_system_mul; --> by host KVM
	s8    tsc_shift;         --> by host KVM
	u8    flags;
	u8    pad[2];
} __attribute__((__packed__));

To calculate the current guest kvmclock:

1. Obtain the tsc = rdtsc() of guest.

2. If shift < 0:
    tmp = tsc >> tsc_shift
   if shift > 0:
    tmp = tsc << tsc_shift

3. The kvmclock value will be: (tmp * tsc_to_system_mul) >> 32

Therefore, the current kvmclock will be either:

(rdtsc() >> tsc_shift) * tsc_to_system_mul >> 32

... or ...

(rdtsc() << tsc_shift) * tsc_to_system_mul >> 32

The 'tsc_to_system_mul' and 'tsc_shift' are calculated by the host KVM.

When the master clock is actively used, the 'tsc_timestamp' and
'system_time' are derived from the host raw monotonic time, which is
calculated based on the 'mult' and 'shift' of clocksource_tsc:

elapsed_time = (tsc * mult) >> shift

Since kvmclock and raw monotonic (clocksource_tsc) use different
equation/mult/shift to convert the tsc to nanosecond, there may be clock
drift issue during CPU hotplug (when the master clock is updated).

1. The guest boots and all vcpus have the same 'pvclock_vcpu_time_info'
(suppose the master clock is used).

2. Since the master clock is never updated, the periodic kvmclock_sync_work
does not update the values in 'pvclock_vcpu_time_info'.

3. Suppose a very long period has passed (e.g., 30-day).

4. The user adds another vcpu. Both master clock and
'pvclock_vcpu_time_info' are updated, based on the raw monotonic.

(Ideally, we expect the update is based on 'tsc_to_system_mul' and
'tsc_shift' from kvmclock).


Because kvmclock and raw monotonic (clocksource_tsc) use different
equation/mult/shift to convert the tsc to nanosecond, there will be drift
between:

(1) kvmclock based on current rdtsc and old 'pvclock_vcpu_time_info'
(2) kvmclock based on current rdtsc and new 'pvclock_vcpu_time_info'

According to the test, there is a drift of 4502145ns between (1) and (2)
after about 40 hours. The longer the time, the large the drift.

This is to add a module param to allow the user to configure for how often
to refresh the master clock, in order to reduce the kvmclock drift based on
user requirement (e.g., every 5-min to every day). The more often that the
master clock is refreshed, the smaller the kvmclock drift during the vcpu
hotplug.

Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
Other options are to update the masterclock in:
- kvmclock_sync_work, or
- pvclock_gtod_notify()

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 34 +++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 17715cb8731d..57409dce5d73 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1331,6 +1331,7 @@ struct kvm_arch {
 	u64 master_cycle_now;
 	struct delayed_work kvmclock_update_work;
 	struct delayed_work kvmclock_sync_work;
+	struct delayed_work masterclock_sync_work;
 
 	struct kvm_xen_hvm_config xen_hvm_config;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9f18b06bbda6..0b71dc3785eb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -157,6 +157,9 @@ module_param(min_timer_period_us, uint, S_IRUGO | S_IWUSR);
 static bool __read_mostly kvmclock_periodic_sync = true;
 module_param(kvmclock_periodic_sync, bool, S_IRUGO);
 
+unsigned int __read_mostly masterclock_sync_period;
+module_param(masterclock_sync_period, uint, 0444);
+
 /* tsc tolerance in parts per million - default to 1/2 of the NTP threshold */
 static u32 __read_mostly tsc_tolerance_ppm = 250;
 module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
@@ -3298,6 +3301,31 @@ static void kvmclock_sync_fn(struct work_struct *work)
 					KVMCLOCK_SYNC_PERIOD);
 }
 
+static void masterclock_sync_fn(struct work_struct *work)
+{
+	unsigned long i;
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct kvm_arch *ka = container_of(dwork, struct kvm_arch,
+					   masterclock_sync_work);
+	struct kvm *kvm = container_of(ka, struct kvm, arch);
+	struct kvm_vcpu *vcpu;
+
+	if (!masterclock_sync_period)
+		return;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		/*
+		 * It is not required to kick the vcpu because it is not
+		 * expected to update the master clock immediately.
+		 */
+		kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
+	}
+
+	schedule_delayed_work(&ka->masterclock_sync_work,
+			      masterclock_sync_period * HZ);
+}
+
+
 /* These helpers are safe iff @msr is known to be an MCx bank MSR. */
 static bool is_mci_control_msr(u32 msr)
 {
@@ -11970,6 +11998,10 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 	if (kvmclock_periodic_sync && vcpu->vcpu_idx == 0)
 		schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
 						KVMCLOCK_SYNC_PERIOD);
+
+	if (masterclock_sync_period && vcpu->vcpu_idx == 0)
+		schedule_delayed_work(&kvm->arch.masterclock_sync_work,
+				      masterclock_sync_period * HZ);
 }
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
@@ -12344,6 +12376,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
 	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
+	INIT_DELAYED_WORK(&kvm->arch.masterclock_sync_work, masterclock_sync_fn);
 
 	kvm_apicv_init(kvm);
 	kvm_hv_init_vm(kvm);
@@ -12383,6 +12416,7 @@ static void kvm_unload_vcpu_mmus(struct kvm *kvm)
 
 void kvm_arch_sync_events(struct kvm *kvm)
 {
+	cancel_delayed_work_sync(&kvm->arch.masterclock_sync_work);
 	cancel_delayed_work_sync(&kvm->arch.kvmclock_sync_work);
 	cancel_delayed_work_sync(&kvm->arch.kvmclock_update_work);
 	kvm_free_pit(kvm);
-- 
2.34.1

