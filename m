Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F2E5E5BEF
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 09:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiIVHLX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 03:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiIVHLV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 03:11:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90332B775F;
        Thu, 22 Sep 2022 00:11:18 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M6m1PY005870;
        Thu, 22 Sep 2022 07:10:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=QlEODYos5W4etpTZ+9oHTYv2gZJ9Jdc9yCPjDqwdJDA=;
 b=3Agt2cBof+5y6DoXC6mQmGcNoyvWm9msSzYIBYfM0Nk5kdpE5eNTBXxX58z9mmfzF3g3
 VX/nCLi5W4A/iXgKqfKtsT2sMM3jB+B4JydkDQw/ctzd2f/MvNcmERBWDzBXfhVL58Un
 nZWUUiuAuq7pu4EI+Sqi9YcaDf4KVLAjP7jekKrNEL+Ln7SWMioPLZx7tP2IUR18Fx5u
 Xvg51q+AckSCfrvb/o1AxP2QuvNm3EqzoSB7a1QdggaEVKPoX5l8n6motB3PfQArp3Ue
 BpzPDRor1xnkl+N4gFA7azS5b/s6SIwVBYZdtbIKJu8HbpbjKoEwZvtbPtUePsPaOyO8 zg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68mckne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 07:10:34 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M5VlF8013950;
        Thu, 22 Sep 2022 07:10:33 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39n9py2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 07:10:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a7+d9RX5FTLmMSuQsTDxWAfblEEk5zDW+bOL8qrjqqyAjoCAyFJc1RoTWdCq2zvVRM3YEDJHunMxP73gKrooeLGbw+Vyrjh8zt8/ss6+iPFnybBld8x7LXXCVisLuFDfvrGU844LB5la9t3v73CFVAYRkGL0ywN/NBfaGtJIM0+OA5s7WSM+MNHGL/YdlGjWbsj8+696ZXhtl7R/Aj0rTwi/uef5cGcGVPmZae+eq2zUrRucFyWXVPFn2pqEaEAUrec1Ty8tw0ziP0hlNFBw3nbGDOPsiX7B7qNuUbQJfd9R7IiUUPc8V2X7sx+soaf26+ObJoRJhy1r3cY4B8Lzzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QlEODYos5W4etpTZ+9oHTYv2gZJ9Jdc9yCPjDqwdJDA=;
 b=fp2uDjIz3BbxPryhLD/Imjee6k5rpNXGuJVX45HybjKZL66rChB+1iPMNwPceRvuw1aIbjgmNKata6Y3dSHjCdJEOXUECYCfgDbaaKNE7BOs2aRvmgyAVvy7KmhGs5BkxE81l3tiVTUnFfdn8aFln4X8fm/GWws5XaTvIJI3x/gq+paOR4WfwdPQD0x/rC34vtamJMQjPdj+C2e2DaklfKmx9woY99g5QeXRig6io0kNe2SvyBXA0R0Uptf0EcxOgUTTU2pW/zJT4bM7lGw6okQPef17frAagLhxTvGCE+HOMHIwGwRqSaR/8TfPz374DRg6iZuqqGUj+lVtNN3YXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QlEODYos5W4etpTZ+9oHTYv2gZJ9Jdc9yCPjDqwdJDA=;
 b=zpHiD7MOxS9Zjnl7YIYYsJGgSWTyT509FhFUVarhzHuRu5r0/lOzT3olnWKa4Vli5+WnBOdd/XFpwfkcwgBfQPgpYcWW58jtuy3QPQzlUUdArdVErAcUox54mF53e/flxGl560h+Ayrxmsg0alY42YdOgEUANEFaIXjcP1CCfp8=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by PH7PR10MB6154.namprd10.prod.outlook.com (2603:10b6:510:1f5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Thu, 22 Sep
 2022 07:10:30 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::36d2:a229:987:a748]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::36d2:a229:987:a748%5]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 07:10:30 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     linux-perf-users@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        mingo@redhat.com, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        namhyung@kernel.org, joe.jin@oracle.com, likexu@tencent.com
Subject: [PATCH RFC 1/1] perf stat: do not fatal if the leader is errored
Date:   Thu, 22 Sep 2022 00:10:17 -0700
Message-Id: <20220922071017.17398-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:a03:40::34) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|PH7PR10MB6154:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cf7e4f7-3fde-4359-a578-08da9c69886b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J8HhUX29a99/XVDoIllPlS228vnqfskDeOyz2jrcHK1LpXYmJD0DdMFceLxrp/cMqxIKIkMPsQC0la10CS3MWaeTLwQ6zY+1wqR3PpmihHKNo1uC3GJjNdmPREtZZb18NVoltbS7X3IawABz3p/LqVik2j8ZbR1MvweO7rPSl4rsDOLcxhnQZD3Ek7muFnEYP0xvEZKXJai+OhpsYO9XK0eLLIQRJ8IK4YuNQxyN0qyzbcnjMjVoii3nDFlmZFtAEzVj/xFW8YAK4seRDOpIjxujap3nI7Mk3uEkU5MIV/y01GiA/964JkarUdO4l5Z8Tc9r89Sd9ORBLelKg3r4YMX4ooO/vG8wxy919NOeoKT7WvsC/BlZKVS1FcVCK+mPaCZhmg5XOmu7FypSKDPLpA80DYmAZG5FB33C7MlZGummOxr3kxtO0ifFjX+CF9q/iDXvx3lgYaUTo85xbajAgR2IBxSRHbDF/BsXNF0BcIrFjA06NEglhYDewx6NOoPlZswtNejkEo3D1nLRcYK60/FeUSj6PBaexbd0i339dGMw9By+yQ0lEfxO+D0pFMd5cJ8e+01Zr/3qrW9OBM5dMLwwZjpIP1cheiZGlgfx4n0MV9zPGWx6NXJbbWxhT8AjkkyVJp0ScberWlXBGtlvra0OaURbSZZBaqisvHpZe1vSiO/c15csm/OjLPHwjmZURBoa5s/t+ibxGcKXSwft2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(346002)(366004)(396003)(451199015)(38100700002)(86362001)(83380400001)(66946007)(8676002)(66556008)(5660300002)(478600001)(44832011)(316002)(66476007)(41300700001)(4326008)(2616005)(6506007)(6666004)(6512007)(186003)(1076003)(26005)(6486002)(19627235002)(7416002)(36756003)(2906002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?okkLTyNwIUVRgJHmG1GLWBaytXYt3KWTDxdLh9eLtSHNHyOxJPVkqUVfCdPP?=
 =?us-ascii?Q?md6fQpF/xHykq3cmpYitKEV8sFqcM2POrmfZgGzltti8lt0K8dKx07HZS4PI?=
 =?us-ascii?Q?THf9OaprFKnR3EGUqhdEazpiOdoLqgQhUUSM4mGq3oPpMPEXdPdY8GRW2GDR?=
 =?us-ascii?Q?L+7TKbb2E920esTQOgyRE2BakwRTEKpavzJdo8u0/xcGsqYPKMpuEfNsIXP1?=
 =?us-ascii?Q?lRkP3LL7Z8XxYujt2aBK//akX0+aAwHXetB/xwy+TZw8GJPvs950LcewGhut?=
 =?us-ascii?Q?DAseYTovN5OXPQYUhpK1iU4sdOD6jaGardUtsW8S1qg0Ah+KdeHnjavjBMNt?=
 =?us-ascii?Q?xiyRlUh9VQ6uIVt2FF5ZRFBra6AL27T5urDOOd31RiCc8geu8cOIzAiYmvjA?=
 =?us-ascii?Q?9wHKym5/VaE9YffFru21zupe+B1x/WX3l4c7eDramhSAmOJ1YnlmIoFciv+3?=
 =?us-ascii?Q?+ecyhAVODQMitrUAMnxH++06ghDwj4eUZ7ufhFiPfm8+3LXlOxM8nzgiQHP3?=
 =?us-ascii?Q?EHeBR+pktV7hmnCAs9PZF40GwH2ow40NSBhHb4iqoxNlXFkowlaiBaeXC3Fg?=
 =?us-ascii?Q?ioUOOx38NKwiM7XTXnR0Dqr2i9/oaF5VACbFWQGoK8EnFEpV+DabpUbv8pzC?=
 =?us-ascii?Q?HiUiXX7vSI2fiCVJ171CAk0vae8Y/8yNBUPNKSf0nUPWGwpCAu5koi/U+zfE?=
 =?us-ascii?Q?3S2UC1N9S0ubYjgUu1sAsnm8X+md9B4+VJjlG6iXol5DKicsX8C/4jx3zdfq?=
 =?us-ascii?Q?CGkSXRZXIrtcT+44pIFwTjdGMFxATXsXc/GbEO95UdSCQmI+SKnbR1GypvA6?=
 =?us-ascii?Q?ev82erhRqEqwvPEJxUgjuI1RRlvPvP7HlNU+WyWxbRQy4ksPHA/pYWDqTr0T?=
 =?us-ascii?Q?Dp3ypcv32yhfx+6UbVJ4R0eqYKajlVwwk7+omJRO3fKd5xTVdPYrZ07bT3wK?=
 =?us-ascii?Q?ifJSSIjgcmPK8Z7Lx5DKoOraWDluCkvKmqO1Qt8YoPWeoB6tyuQjEiYqm+ns?=
 =?us-ascii?Q?c9FzTgcpfNDx6fkWs19KGqclp1uPpCzsafc5tlc80XLYGWXv4wMNLo5/on3d?=
 =?us-ascii?Q?H92kY4NeQnpOYS7WnOGFTLJ43qwa0FFD4XVyx3J+mumP1k0fHk+5eMo6Vx9u?=
 =?us-ascii?Q?wcNc6fqDPaIXOdJXjsG1BewCKvgWyqMoeT2Nrpbx21Asb77IUhSjY7y1jaxR?=
 =?us-ascii?Q?5EOHrpEukMpxEWEBxzrqXl+FLOZP2kh4YEentexGXZqaZF5N451n6j6MXG/N?=
 =?us-ascii?Q?PnFz5h7oII/pKKSp95jbelWken8MRlfsIP0wCjGlfhJ/hzBkuNCEYL71H50V?=
 =?us-ascii?Q?LAkrykLaR2MheZghIYWw3EPp4wUbShSSTLYlUZtlLvqWumO4Uitl658pCact?=
 =?us-ascii?Q?MalUbg6lBKQJx2cNVFyLgmj5IcOnBdbPpY6iv9o/KBRHVogr2nTBWXR9zLaP?=
 =?us-ascii?Q?IlJjtmhXyQLgOz3of6afl8P1gM3XgzCbzNV/8MVMAatmz/UBQ/BA1jj+icTa?=
 =?us-ascii?Q?jnGEfuwCXEglsz3+EPyqzVicp2ZLBpY1b72FZeNrlmRnCKMYIhdE05m3SZ4k?=
 =?us-ascii?Q?nfx3/uawNUzp2vycO6dN3xcy8/WFJJUXlm8i5Dlr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cf7e4f7-3fde-4359-a578-08da9c69886b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 07:10:30.1851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jHVV7s5MAq0dxHYCjW1H2ZoZSAlCq9Yi0es7B/Abz9BqE2qUnFkya65327AsyPIjWOAikCynf8WEU8PfRgL0/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6154
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_04,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220047
X-Proofpoint-ORIG-GUID: D3XB-8gBzrzTXPPL4UWCw2FlC3PxHbMp
X-Proofpoint-GUID: D3XB-8gBzrzTXPPL4UWCw2FlC3PxHbMp
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add kvm@vger.kernel.org as this issue is in virtualization env.

The topdown metrics events became default since
commit 42641d6f4d15 ("perf stat: Add Topdown metrics events as default
events"). The perf will use 'slots' if the
/sys/bus/event_source/devices/cpu/events/slots is available.

Unfortunately, the 'slots' may not be supported in the virualization
environment. The hypervisor may not expose the 'slots' counter to the VM
in cpuid. As a result, the kernel may disable topdown slots and metrics
events in intel_pmu_init() if slots event is not in CPUID. E.g., both
c->weight and c->idxmsk64 are set to 0.

There will be below error on Icelake VM since 'slots' is the leader:

$ perf stat
Error:
The sys_perf_event_open() syscall returned with 22 (Invalid argument) for event (slots).
/bin/dmesg | grep -i perf may provide additional information.

This is because the stat_handle_error() returns COUNTER_FATAL when the
'slots' is used as leader of events.

There are three options to fix the issue.

1. Do not expose /sys/bus/event_source/devices/cpu/events/slots to
userspace so that pmu_have_event(pmu->name, "slots") returns false.

2. Run cpuid at perf userspace and avoid using 'slots' if it is not
supported in cpuid.

3. Do not fatal perf if the leader is failed. Do not create events for an
evsel if its leader is already failed.

This RFC patch is with the 3rd option. Would you mind suggesting which
option is better?

Here is the output of patch.

$ perf stat -v
Using CPUID GenuineIntel-6-6A-6
slots -> cpu/event=0,umask=0x4/
topdown-retiring -> cpu/event=0,umask=0x80/
topdown-bad-spec -> cpu/event=0,umask=0x81/
topdown-fe-bound -> cpu/event=0,umask=0x82/
topdown-be-bound -> cpu/event=0,umask=0x83/
Control descriptor is not initialized
Warning:
slots event is not supported by the kernel.
^Ccpu-clock: 62021481051 62021480237 62021480237
context-switches: 437 62021478064 62021478064
cpu-migrations: 17 62021475294 62021475294
page-faults: 12 62021471925 62021471925
cycles: 15662273 62020909141 62020909141
instructions: 6580385 62008944246 62008944246
branches: 1446119 62008855550 62008855550
branch-misses: 30970 62008643255 62008643255
failed to read counter slots
failed to read counter topdown-retiring
failed to read counter topdown-bad-spec
failed to read counter topdown-fe-bound
failed to read counter topdown-be-bound

 Performance counter stats for 'system wide':

         62,021.48 msec cpu-clock                        #   16.006 CPUs utilized          
               437      context-switches                 #    7.046 /sec                   
                17      cpu-migrations                   #    0.274 /sec                   
                12      page-faults                      #    0.193 /sec                   
        15,662,273      cycles                           #    0.000 GHz                    
         6,580,385      instructions                     #    0.42  insn per cycle         
         1,446,119      branches                         #   23.316 K/sec                  
            30,970      branch-misses                    #    2.14% of all branches        
   <not supported>      slots                                                       
   <not supported>      topdown-retiring                                            
   <not supported>      topdown-bad-spec                                            
   <not supported>      topdown-fe-bound                                            
   <not supported>      topdown-be-bound                                            

       3.874991326 seconds time elapsed

Thank you very much!

Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 tools/perf/builtin-stat.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 0b4a62e4ff67..1053cf0886c0 100644
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
@@ -843,6 +841,8 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 		if (target.use_bpf)
 			break;
 
+		if (evsel__leader(counter)->errored)
+			continue;
 		if (counter->reset_group || counter->errored)
 			continue;
 		if (evsel__is_bpf(counter))
@@ -901,6 +901,8 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 		evlist__for_each_cpu(evlist_cpu_itr, evsel_list, affinity) {
 			counter = evlist_cpu_itr.evsel;
 
+			if (evsel__leader(counter)->errored)
+				continue;
 			if (!counter->reset_group && !counter->errored)
 				continue;
 			if (!counter->reset_group)
-- 
2.17.1

