Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAE75F9799
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 07:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbiJJFCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 01:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiJJFCV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 01:02:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB81D4457E;
        Sun,  9 Oct 2022 22:02:19 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29A4f1DX019044;
        Mon, 10 Oct 2022 05:01:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=CDHP0bW7y+KS1Oj4STXu/h+0wMuRtv5e02KG5I2CWTg=;
 b=1oLvbcZLJLxDkhosIYUYGBMEdNMgmQ2BY0cSu5X6hSzViX2yFCRojgt/W9SN1RWmNQvQ
 8ELYScNsV5y0XdLylARtGxHxfq8ecFlcwN08HZ+oDikqOCBQ9P65rmKUEPY3m6i3Y2MQ
 YGR0ETHWnAR/I7iHVPg3wKe0Bwwc1Bv/RnN4gUVLiBkYGe/DaXKugD94+zL4EcNK6u5m
 crz72R7HeeOmRM8Js4keW4uBFJxAE55LuMS5lM6HvEz1r4CFV2ei+hHOme32MpJqDV3V
 6DLA2b+q9c99T65rVLNftPZlxoS/4kL3Fat68CGo05bB3rQStdDgB3mgwPR/Ddj0tSEP 9w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k2yt1aj3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Oct 2022 05:01:53 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 299NFl0g039665;
        Mon, 10 Oct 2022 05:01:53 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k2yn2aemh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Oct 2022 05:01:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vlngvev+6lAOrSV3nzYaWwswI20DI8zR+DsAZYBLbKuegEiyryTmxtl/bW02bEFSFxvw0pAPg7Mz/f8m0MIAGZkGOvXDSGN8/FwNYdzGMNsawyKTGw5iBmwHhWNDOEW9bpM+aupGdHV23c0TbS9EBLJLw4L5FfnAWXMIIRwgGQlERNrvjY3xAOoqmcX3wI8Oo3Cbdbt4wAh7Q45z4mqKbmqPPbyeUYY6XQdoi0hotBmuIsEzXz9I95oL6NKdP6HVNQn+84zfvOPGVkUKI3PaGSmlGOvCSx/1mPJMsRpFE9ofPGa56CV6wSrqegb463tEiUrTd8plAGxbUdCvbC38WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CDHP0bW7y+KS1Oj4STXu/h+0wMuRtv5e02KG5I2CWTg=;
 b=kMhoiEhYIuv4yHME/0aw3pJoLcrbA+7RyEffSZ4/m7YYs1fR1cF14znFNJcoWDks1pE1P6B1Yc+Z3r14enGXhakQgnXoiK5jWqqnwnesU+FJCBtt5HyxuCXIcZ04jwCsnRgbRQIJbCrssS2WD7n2XeK/MTfw0I16qnCiMR7qRAGu+UbRDC+qlEhOHfCiWNlgr7IoC2lWqOkvtiRCCFE95oAbe6180tWeR136tYZj1G1W+0l/jq5xAr7PndhmT5A6Q5XMXHfxryUbwuZCQOW5FxzCtNpYJsHWGusHKH57lh4gFBn4OilVaQkU8UW54SvNXDbI52qkhTVUIUTV0suuFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CDHP0bW7y+KS1Oj4STXu/h+0wMuRtv5e02KG5I2CWTg=;
 b=uNMrjiVeBGQM6HBMwaJHGF9Bz1twldzBROe4vovGiVznWtL8sSrPy0YAUxDzvfxMnmPBj1l+QB0AIuRSE1vlRPLVqZfI0QPSZU7Q4H8nRhIsjMymRwG8bQ00XRrPHAy3W29GLGgW9lNu4g/TzZKWjf0PXUPIae0JAKav239SgHk=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CH3PR10MB6716.namprd10.prod.outlook.com (2603:10b6:610:146::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 10 Oct
 2022 05:01:50 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::d8bd:518:30e6:e7b7]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::d8bd:518:30e6:e7b7%7]) with mapi id 15.20.5676.028; Mon, 10 Oct 2022
 05:01:49 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     linux-perf-users@vger.kernel.org
Cc:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@kernel.org, namhyung@kernel.org, like.xu.linux@gmail.com,
        kan.liang@linux.intel.com, joe.jin@oracle.com, kvm@vger.kernel.org
Subject: [PATCH 1/1] perf stat: do not fatal if the leader is not supported
Date:   Sun,  9 Oct 2022 22:01:13 -0700
Message-Id: <20221010050113.13050-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0029.namprd21.prod.outlook.com
 (2603:10b6:a03:114::39) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|CH3PR10MB6716:EE_
X-MS-Office365-Filtering-Correlation-Id: f6133ee1-2681-4303-d207-08daaa7c8a3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /2Mnb2hFRbNIrDB25eMQ41P/tlwAARjgxQ+VKryvFeLcEeHJ/ir7X5B5gT989smbAJfDlvHWI9a+ZxPuiYm0qGW2kyZhOlhaC6HPEYQK1YghdNum0hddMnNfwypls5ACDywfAtVVRUjPTujQvhoAAAZFvHo4sudtTaU8CQ5LkmrKfijrk7H2VFiN8KNKHBwXe2iA47ywgmawBkyxjw5+j6SP11+l3mwKOTdBcxdJcDtiU48w5xyHVa4vY1M4V7wgVB2NbSHClK2XVhgn73d59U8KFRMHQbFHQjm4uH6SDJA0QotLXJm+COw6F6DOJ7otInP0p6TuXsCNwLffYe2ETO/0RXCDnXSctXzGG9pW6sWC4LagqciUeHUtVuqVywMKMrSY2T4ZdLEAZg9qXUxi9OUSezz6TFTbC2TmuItJTuQDqt9x0wZ1/0fXG0HhXw/OjYq83sdMYYCIyqTqnj0Bekty5tqFebzuJou4efO6EWxmguE/JqOPhe9kOmsHm18CW/ScP2Dht29ZoO7UY4MZCeiwDD1qeg0Y4xAhrpvonFAVLwrxlOh+Exx8DcJxtXETbIeavsu4yzJIF/8l0adyUFePbPh/XhHBNcitmr9NutfdVm0YXPWW68T9z6iKYLq2jcxsF1xMJrKov1IKf+glyDs5kPjaO+Kz01K6geaIBNKEef723SCT6+1/3VF3NxPnh7Ym5QbcD1blsZGb4Qv/Svyc9ulMydKYoRyL8H0zKe/6Ungk3+sK2L6vqxEOUEA1PMycm7GEb3YKxRBG/8vkwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(396003)(39860400002)(136003)(376002)(451199015)(186003)(83380400001)(86362001)(38100700002)(966005)(44832011)(6916009)(5660300002)(7416002)(316002)(4326008)(66476007)(8676002)(41300700001)(66946007)(6512007)(1076003)(6506007)(478600001)(26005)(2906002)(6486002)(66556008)(6666004)(2616005)(36756003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BEamasBLsaZvlBnyeIu3iWBXKvah7hFudH3vNjxtVKW3R7EgThaMRSyzJtZT?=
 =?us-ascii?Q?CpkImnKr6NsXRQrYxXCfJ7s/yTWtvnZtb0SDb3tawPvKXSTXxIOnbVCsH4Et?=
 =?us-ascii?Q?eJWxyjLcM+OUKyWewI/X/ljXVkjxSFb1WjZTSfyfdSbHpaRmZviDFS7YjYkR?=
 =?us-ascii?Q?yac1NwcZVWYsQh3n7FDwEpSmx6GPjA3972P0FliX6mPE0SC/aXZiloK1KhWh?=
 =?us-ascii?Q?maPIyDyijj6Od9GWWEWG4tSBCUoLu6uEEhqvbafrADAcPg6cl8FVMrAKknjM?=
 =?us-ascii?Q?5NW1TNjZm1A34ya0vocEinltrB1L/DVUIUjzouAqn/TiJ+hHCqSZUvv/hIUL?=
 =?us-ascii?Q?VdIzuQiJgonSfL+8RSPFY89y4pxG+GmlaFlctDRY3J9ZvvtaZhtAPYr4yHRX?=
 =?us-ascii?Q?CHElK7BnAkJi9Upfa9RDTSL0/UuIOnI9jUQ9YbLNpAdPj2B10hRyRvXpewLj?=
 =?us-ascii?Q?w2DBuLE887X3r+hTETXO4DMJLVAZvGZTRCtH/izzssS6ZtPhU4M+1kUtEkwg?=
 =?us-ascii?Q?bfg3qvAb2wybniU7qLMUxyhITnElCwD/N8hqLeW1li5tvB7q3oONFE+z5IeR?=
 =?us-ascii?Q?Gv7LMWiPVxUSsE6eIWLr0rht2KzdASkai/DKleR6aDYxT55qoxFFmizge+3M?=
 =?us-ascii?Q?sLsRL7d8JBpJ2OAAB1WsP9wdowbOocx1vrz8sY+j1koqScbDwlKY05FAbcw2?=
 =?us-ascii?Q?/DkiJHqapKwxOBrXwdY0yK8B+h4pg0CgqQ5MDE53xAsC6ATcaxYzfS052irJ?=
 =?us-ascii?Q?ha+ig4/x6nkkA4i5BzzjBufY/DGrorQESpnId7SvnOLGL1tj3qp2Ao5OXSpM?=
 =?us-ascii?Q?Jjm5eNRrqFy69U899Y3suQyoOesY/1mKTyXRRujlijHpEn95ucbG/ZKLliQU?=
 =?us-ascii?Q?JrBU5mrJQuNye+XWF50X2/6/Rm9MJQcmIZFBaIdRNGv9926aJNIj0QoiPlcp?=
 =?us-ascii?Q?yqbctj/1hOHTdJTQyNLsjbL5ZOSVWvZzbRuuAUG8fJKAhu6+s9fcKfLK8AEp?=
 =?us-ascii?Q?RdCL3622ys1SXvbca8OHhFr2mIopt5OhZYAM7qnNMpgexBsY7QBu/nCD+Rxf?=
 =?us-ascii?Q?jCbCOqzCcoBEQXBMMnu6C1W6I27U7QkKYP781BWTvIFNGVJb3NCWA6cfca01?=
 =?us-ascii?Q?Fr0k06oUbz9bi1p9KzMJxIrTQT32uPTd4G7niuW5Gi1wm4c1BjybfD8cC+XG?=
 =?us-ascii?Q?nSRtC8H8M3SNr1OG1+Kgrp7H6HUs3u4lbOd2yGXB4SSZcd7pO7Fl3TVRMH9V?=
 =?us-ascii?Q?Gkwc9imd/7xMy7x+GovsCOafC9ICoSRa7J57AvYwRw/GWavmaycKBGY/pH5N?=
 =?us-ascii?Q?rREYPZyohk05Vtbxkidp+Jurtu4LqlvGSgkxMKFxtEGSzQRCOfKv2eRL/Ozs?=
 =?us-ascii?Q?gWn3WQZxnxG4CATFiHUGESmagS6NF3DvPEBtKDv2Xa89D3LYmdTwDWZ00S1u?=
 =?us-ascii?Q?MIip29QQbO50BeNoAPO7k9XD8j5zoVDgOmW95cUoWQk2YTkhZpjRYbmhuyoC?=
 =?us-ascii?Q?PrOEAr0Nq9YQR3ZWQ+4sAobd0TxSx+UqhZp/WfA5WtK1XLCngiBbKaZ5Kr//?=
 =?us-ascii?Q?hBRrtm+CEbrWwKS2+GFC11hfmCete/0IhtLGF2zLUO2XCQSWdcFL4J+UxORs?=
 =?us-ascii?Q?Ig=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6133ee1-2681-4303-d207-08daaa7c8a3a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2022 05:01:49.8904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nlROeQK4pzyqtgcXIPGBlWiPfPaJFPlIyUGQKLjQQgKO8JyOJe+IPrQC1YSU/nNe4o3tpBnLUBmDsofVtE0ohA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6716
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-07_04,2022-10-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 malwarescore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210100029
X-Proofpoint-GUID: jNVviIQNX0q8CbFx12HkSqO3VYcFOkqw
X-Proofpoint-ORIG-GUID: jNVviIQNX0q8CbFx12HkSqO3VYcFOkqw
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The topdown metrics events became default since
commit 42641d6f4d15 ("perf stat: Add Topdown metrics events as default
events"). The perf will use 'slots' if the
/sys/bus/event_source/devices/cpu/events/slots is available.

Unfortunately, the 'slots' may not be supported in the virualization
environment. The hypervisor may not expose the 'slots' counter to the VM
in cpuid. As a result, the kernel may disable topdown slots and metrics
events in intel_pmu_init() if 'slots' is not in CPUID. E.g., both
c->weight and c->idxmsk64 are set to 0.

There will be below error on Icelake VM when the 'slots' is the leader
, but to create the event is failed.

$ perf stat
Error:
The sys_perf_event_open() syscall returned with 22 (Invalid argument) for event (slots).
/bin/dmesg | grep -i perf may provide additional information.

This is because the stat_handle_error() returns COUNTER_FATAL when the
'slots' is used as leader of events.

While the issue will be fixed at kernel side by hiding 'slots' sysfs
entries, this is to fix at perf userspace. The event is regarded as not
supported if its leader is not supported.

The userspace fix changes the way to report error when the leader event is
not supported.

Cc: Like Xu <like.xu.linux@gmail.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
The fix for kernel side is:
https://lore.kernel.org/all/20220922201505.2721654-1-kan.liang@linux.intel.com/
As suggested by Like Xu in below discussion, we may also need userspace fix
since it's easier and more agile to update the perf tool than the kernel
code or KVM emulated capabilities.
https://lore.kernel.org/all/20220922071017.17398-1-dongli.zhang@oracle.com/

 tools/perf/builtin-stat.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 0b4a62e4ff67..0cde917b9a26 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -762,9 +762,7 @@ static enum counter_recovery stat_handle_error(struct evsel *counter)
 		 */
 		counter->errored = true;
 
-		if ((evsel__leader(counter) != counter) ||
-		    !(counter->core.leader->nr_members > 1))
-			return COUNTER_SKIP;
+		return COUNTER_SKIP;
 	} else if (evsel__fallback(counter, errno, msg, sizeof(msg))) {
 		if (verbose > 0)
 			ui__warning("%s\n", msg);
@@ -843,6 +841,9 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 		if (target.use_bpf)
 			break;
 
+		if (evsel__leader(counter) != counter &&
+		    !evsel__leader(counter)->supported)
+			continue;
 		if (counter->reset_group || counter->errored)
 			continue;
 		if (evsel__is_bpf(counter))
@@ -901,6 +902,9 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 		evlist__for_each_cpu(evlist_cpu_itr, evsel_list, affinity) {
 			counter = evlist_cpu_itr.evsel;
 
+			if (evsel__leader(counter) != counter &&
+			    !evsel__leader(counter)->supported)
+				continue;
 			if (!counter->reset_group && !counter->errored)
 				continue;
 			if (!counter->reset_group)
-- 
2.34.1

