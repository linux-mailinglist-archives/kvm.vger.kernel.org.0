Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448DB485DA6
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 01:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344101AbiAFAvs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 19:51:48 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:58098 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344111AbiAFAs2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 19:48:28 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205N4XNX023551;
        Thu, 6 Jan 2022 00:47:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=MV+YejxdH3x69KnprYQq0pLALcrsFEp4tu7Gfe7m1Gg=;
 b=dEgdxf23QbjMzJQ26kqkOuBeBDv70tM8OUjhmWDoIHk6rxfVg36rvAetMX+H8dclybFn
 3oVdRMWzgdnC0m1JuSuGSVFLQBO0IPqq3mci4DkPL/Vd1wrllIyjkfG2aJwJ/hEx6t+1
 LnHGS2Pqn83xeuz7ywuacxsj06EV1h9lio5oOuM7vnDxh9rgWLqkjx+GrjzugiqkeNvA
 4UHngmYXBfvk6GuJPNbx7VCps5hwR+J83GLPrABrb0YmPliqt5pbWNzhA3bBKiJkbjx3
 C5JJ0F81SpjMkMOc34Fl9uLsp/6tu2EItqcZffdGOm8GsZct01O/M/IcnPRvVYcvZV3I Sw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ddmpeg42d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2060VgMY076288;
        Thu, 6 Jan 2022 00:47:54 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by aserp3020.oracle.com with ESMTP id 3ddmqa3dmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e56p08mDL8WBntRkoxhLmRxBIvC75KvgxsCI/WGB+Cs5p8CsEoOv5J5ZzmUtvX71KTPlDVOmuJj/VHAEtqI/35nMB/mdsTtSkswsRs6KdBNlUkrbaPPrHg8CLyUR4yq4QEO+Jurie08GxZa8WlPY+YgCLBhS1MtbugP5V716dVgEFqSMxpMLHbPbRj3Uz30caRy+8AQ4WmN0Frs0hcwDpbSgX5hIqoEHvlLeWDKQJ1DxXdLLFcrpTL6mjRwarDLj/qIaTjZe8/iOFX0bzQyf7B/+JDKxpzGPNDsY7sZzsXlvN3+j3bOKt3YByt08T9FxKA3fWdkHCN4c3SQ0KO1g0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MV+YejxdH3x69KnprYQq0pLALcrsFEp4tu7Gfe7m1Gg=;
 b=cEo5SIOJrt/NVdcZxORQFU21lpt1o8UJuqYG82k7QnJcvL/3u8a43Asab7ItG/Nlh6Gf3zmyqv4UgtuotD2o6iFhVzUzRMlp5YWzmgJQvWywfv2WxRIeb4mMzTwL3A7CmwWSmMHqGOexy8DjFlULA/lvjoDHWbvIpBwV9Q3vy7hEtgvffR0lqJVr4GslLnHQbhDieT768g1dkMd0tF9EJEwqs6oWPaYOKoqfLM88rjJtPa+8Douqkc5eBYGi8oc95aprqeG5qj15SNUMVG3iO+UNzTyGW/u8pP85AtsYI6PnPg1Pve6Av5yGjKnVSE7shNqo0+KpFqae98oWlEUz1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MV+YejxdH3x69KnprYQq0pLALcrsFEp4tu7Gfe7m1Gg=;
 b=M9iUloDmUi5Ha8G86TbOaf1cu0SzaZSHl+oWl5oT9LEGZp7K54JtjT6LiYyE2dTzKjiVZhIllHr2yIE0Xc4Qbt74/HcK9p3C7/6L8XPBbo44oMgj1L91GgiFXnIWciyNLDy7w73yF/J6/RnTnw+HZknsac8/mIsomtUAa+hPlys=
Received: from PH7PR10MB5698.namprd10.prod.outlook.com (2603:10b6:510:126::18)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 00:47:51 +0000
Received: from PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3]) by PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3%9]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 00:47:51 +0000
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Alexander Duyck <alexanderduyck@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Segall <bsegall@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        Tejun Heo <tj@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     linux-mm@kvack.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [RFC 14/16] padata: Nice helper threads one by one to prevent starvation
Date:   Wed,  5 Jan 2022 19:46:54 -0500
Message-Id: <20220106004656.126790-15-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0019.namprd20.prod.outlook.com
 (2603:10b6:208:e8::32) To PH7PR10MB5698.namprd10.prod.outlook.com
 (2603:10b6:510:126::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f987fd7-cb43-4afc-d014-08d9d0ae2adc
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4422866C0CC6B976477B8EC1D94C9@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h9GVDkfWNdmOnx/60QnwMDRXkYRTPYCjA+1+nCUm2646NXlIUNsL2nAHyX7UUB8KHPRdn/NPh0iG9KU/DKSXyo65jTReNlaeb2z7eKDb7IpzCYCSiNdnR0hNIDnpOwJS2xPCCTefRYbYaQoK2H623tDwJ+Zzjx1rG3OMpkCwmSrmXdATx3kY5ZNdgVe8nCvB2V8ZoSuB8kQFH5XfYyjHV11NZs3KoDT5MhvQNB49Wh7AalYve3weLVklKMRGhpar1+H8/grz/eB0N0PR5SkTO0TQxmWQ5Ew4PHjOCtmBe22sHL6dbN9wA+vIBxgoDyz2R7vncgkabFacUsaQLbAzZJTlUIJjFngDzcNm55f50WW2AISFRlrniie5gRz85UMn3Mbdn42cD0dGqoYtX5NwpwPcJlqOb0Mhht+6ttMjLCTyGrsD3AuKwRRWxnN1cHpeo6JbJyLvhixvJSW1HM9oXSZIZbZVQLqm4+kl+rs4Tx/ux5g9u+4aaw8/T3KlLY/35vzO+cyxgfceJfjflPyBYNtNs0T/DoIEC25FcSiO0DIKG0SoPj+nciYr3g8SYBuC+YhLjbAFZIE2Que1f6OUk3xyETCOiccVIB6P9YIHD7M9Ub6/k6gFz8FCXSDvOSRtJDL3SoDjC+nSqSEJYiD//Y4rxBp0XCsmo0YDcrT/gtgOnYgunHX1xX5B0mpx/PFz+HgrEcsvrKLU/UI2iG3KK2fIiIMIK3Gm5HoHf1sGuLY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB5698.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(316002)(38100700002)(5660300002)(38350700002)(83380400001)(508600001)(66946007)(66476007)(66556008)(26005)(52116002)(186003)(6506007)(7416002)(30864003)(8676002)(110136005)(8936002)(921005)(1076003)(6486002)(2616005)(36756003)(86362001)(103116003)(107886003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FiL7wRiszdCYcnC50semlgq3ttv7qZG1sfxqiKocmcNRNon6zhIR5qT5Oosj?=
 =?us-ascii?Q?/zP6ldndlcQUzFWDNMMVGg79t/WUp9D/mR9DDrj1vCQU+n7DTTj66pFg2IpA?=
 =?us-ascii?Q?9PV48y+Dw1b4A4TAwvRiRu/1EXsdquVfKVNGsAs+1RqnhaxP5aYCbfQgpX0B?=
 =?us-ascii?Q?QJcfYcFdaooGFVIiUY+DtslDu97VJzRwqtaXGCvOCd5bOpYMDTKyH6cVrvSU?=
 =?us-ascii?Q?OyMmU0yTN0DMv0gQKMeR9iAOjRHSkp87s5giA7u5SM/LV852Y36hVT0gPc86?=
 =?us-ascii?Q?3DCVULWsBYk0rs4t/xaO+/n9q/GQfHhp7lE9JV8Z7oGlxM/FsVKt27NDqwcc?=
 =?us-ascii?Q?8ckDdt0fa2X2tv7nldYh1IzlQ7Itymv4Hed/Calgo9+tAnmW0MtFk4xt+YsC?=
 =?us-ascii?Q?F93TVAl8EPCp2jVrdZNVxHhUfewhC+NgnNovAmQVc+6QMEp1p8bIKY3m4gxZ?=
 =?us-ascii?Q?9E+4Kvb0bb1SwlftGiQsz3J80S0Weyq6yGSjYQN/BMJqp36Okqrij9aBK739?=
 =?us-ascii?Q?MTpIAWrbRFB1pdVhMaZWva7Eq0B64B6rcy3JWPow+rSJmO7z4DNVGdhN5hSX?=
 =?us-ascii?Q?Ux0aBz9C3ocXtdNODwr3YjBslBNM8JoU0CXFVbIKuatTIiaFbjFwq4EtlUsi?=
 =?us-ascii?Q?jOmb4FVQRt1pfR1G8pkHX6CQGIhbWeg8FMiYeD4m4G5KQ2G5bOQOsP289LFJ?=
 =?us-ascii?Q?WPrn0ephwnibP/VcMpp1v5bAXTS5it1gof2e1/xR6D5SOBg/ENTYtYOqIPot?=
 =?us-ascii?Q?zDc1fSu/wAVPyGukXO2UjVj+8emnDxMw/itcVSP5Tkp1aYGzBVKFyQVvNHuG?=
 =?us-ascii?Q?p/4TKfj0WFs4i5m6m0f0ecEcDs6zih1ZZuTuEMmaf8hQolDw3cMa6MtBiiRc?=
 =?us-ascii?Q?Mp1NHdv3KVY7lteDx9AAGok9rI/Su1XJKzydTQt+PrZ/qtD6j169JFgoYZPu?=
 =?us-ascii?Q?rm3d2PuzLxv7rLTiWTttDgSiHgl5zZgp/9A2Ny0v+4xIxW/dMMiYYKvnPBDZ?=
 =?us-ascii?Q?ZBYedDh/mVGWLOSfVPeFax/Hxg7j9zQzkTfV2ZIE0eOFjchdZ4vbDlXPTkVm?=
 =?us-ascii?Q?rFTkNaXFz9S68EjfNXGonqr4rTag63qJe/IvF9w2eE5p/CGL+95icMHGdCdw?=
 =?us-ascii?Q?7Kyxp2/p6+UWhc4eOJk2oyARI8lk5S/VmWi0Fd3ECHQRugHdSTqG8oVbIld/?=
 =?us-ascii?Q?fENDEVvYLISoYJHnH72UsQLcrxdp773tvXAL2a99yBAxLuigJWSdq5OQ4sAJ?=
 =?us-ascii?Q?ulfhfNyqlF0Wfvn/FP19jdbxwy+1GoxaQOOt8zaTjDjce3xSFP3qmqKlMF0v?=
 =?us-ascii?Q?ljv6TbuvbfD5FbfBKGtGzkRGKlTAAtaG0aH/YJe2AHXSdjvxoym7GEgtzRgh?=
 =?us-ascii?Q?pvFYqWDXfDnrs1KcZPW6kWhfrSmtzvj4CBhlHZkR64er/MWtHvYTKTAw9tpB?=
 =?us-ascii?Q?csi50WJxGQk/1sE0TL9YoehpZa0xa6FtUWBIV/re2h4pufaTw0IyWv2N3i08?=
 =?us-ascii?Q?hQ/30XxRRPe/+z++iwMJ2dUlXrc2KAtLVhJdyyb+8rFt43rDnsRPYyQ0XoxO?=
 =?us-ascii?Q?/WPRw+hR95IFXjwBbmcF8qopBfeFwcSWw8SOKKf99uOAFuTQYxg+5ssfYKgk?=
 =?us-ascii?Q?OA8eyglK7tu5fC6qXnks9fF7wX9wyDAAV7+0Rd7BuOME80UKiexxXJpD8ote?=
 =?us-ascii?Q?sgsqum1ydv2D20O68uBaFdpranU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f987fd7-cb43-4afc-d014-08d9d0ae2adc
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB5698.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 00:47:51.3001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NhuDKtPonlt7nmNDn9F1oteR0jR8vhS0ShjxJrWjvhNCTqeCgwb+FCHhy4xGa0h0jRz0VkgerFZywsZWfuB8vU1dXonffQZo2osELtYjU7E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10218 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2112160000
 definitions=main-2201060001
X-Proofpoint-ORIG-GUID: 2c8ETdJ4PhGv5ipu-TOTB4kfOwDkouvL
X-Proofpoint-GUID: 2c8ETdJ4PhGv5ipu-TOTB4kfOwDkouvL
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With padata helper threads running at MAX_NICE, it's possible for one or
more of them to begin chunks of the job and then have their CPU time
constrained by higher priority threads.  The main padata thread, running
at normal priority, may finish all available chunks of the job and then
wait on the MAX_NICE helpers to finish the last in-progress chunks, for
longer than it would have if no helpers were used.

Avoid this by having the main thread assign its priority to each
unfinished helper one at a time so that on a heavily loaded system,
exactly one thread in a given padata call is running at the main thread's
priority.  At least one thread to ensure forward progress, and at most
one thread to limit excessive multithreading.

Here are tests like the ones for MAX_NICE, run on the same two-socket
server, but with a couple of differences:
 - The non-padata workload uses 8 CPUs instead of 7 to compete with the
   main padata thread as well as the padata helpers, so that when the main
   thread finishes, its CPU is completely occupied by the non-padata
   workload, meaning MAX_NICE helpers can't run as often.
 - The non-padata workload starts before the padata workload, rather
   than after, to maximize the chance that it interferes with helpers.

Runtimes in seconds.

Case 1: Synthetic, worst-case CPU contention

  padata_test - a tight loop doing integer multiplication to max out CPU;
                used for testing only, does not appear in this series
  stress-ng   - cpu stressor ("-c 8 --cpu-method ackermann --cpu-ops 1200");

            8_padata_thrs          8_padata_thrs
                 w/o_nice  (stdev)     with_nice  (stdev)  1_padata_thr  (stdev)
             ------------------------------------------------------------------
  padata_test       41.98  ( 0.22)         25.15  ( 2.98)        30.40  ( 0.61)
  stress-ng         44.79  ( 1.11)         46.37  ( 0.69)        53.29  ( 1.91)

Without nicing, padata_test finishes just after stress-ng does because
stress-ng needs to free up CPUs for the helpers to finish (padata_test
shows a shorter runtime than stress-ng because padata_test was started
later).  Nicing lets padata_test finish 40% sooner, and running the same
amount of work in padata_test with 1 thread instead of 8 takes longer
than "with_nice" because MAX_NICE threads still get some CPU time, and
the effect over 8 threads adds up.

stress-ng's total runtime gets a little longer going from no nicing to
nicing because each niced padata thread takes more CPU time than before
when the helpers were starved.

Competing against just one padata thread, stress-ng's reported walltime
goes up because that single thread interferes with fewer stress-ng
threads, but with more impact, causing a greater spread in the time it
takes for individual stress-ng threads to finish.  Averages of the
per-thread stress-ng times from "with_nice" to "1_padata_thr" come out
roughly the same, though, 43.81 and 43.89 respectively.  So the total
runtime of stress-ng across all threads is unaffected, but the time
stress-ng takes to finish running its threads completely actually
improves by spreading the padata_test work over more threads.

Case 2: Real-world CPU contention

  padata_vfio - VFIO page pin a 32G kvm guest
  usemem      - faults in 86G of anonymous THP per thread, PAGE_SIZE stride;
                used to mimic the page clearing that dominates in padata_vfio
                so that usemem competes for the same system resources

            8_padata_thrs          8_padata_thrs
                 w/o_nice  (stdev)     with_nice  (stdev)  1_padata_thr (stdev)
             ------------------------------------------------------------------
  padata_vfio       18.59  ( 0.19)         14.62  ( 2.03)        16.24  ( 0.90)
      usemem        47.54  ( 0.89)         48.18  ( 0.77)        49.70  ( 1.20)

These results are similar to case 1's, though the differences between
times are not quite as pronounced because padata_vfio ran shorter
compared to usemem.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 kernel/padata.c | 106 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 73 insertions(+), 33 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 83e86724b3e1..52f670a5d6d9 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -40,10 +40,17 @@
 #include <linux/sysfs.h>
 #include <linux/rcupdate.h>
 
+enum padata_work_flags {
+	PADATA_WORK_FINISHED	= 1,
+	PADATA_WORK_UNDO	= 2,
+};
+
 struct padata_work {
 	struct work_struct	pw_work;
 	struct list_head	pw_list;  /* padata_free_works linkage */
+	enum padata_work_flags	pw_flags;
 	void			*pw_data;
+	struct task_struct	*pw_task;
 	/* holds job units from padata_mt_job::start to pw_error_start */
 	unsigned long		pw_error_offset;
 	unsigned long		pw_error_start;
@@ -58,9 +65,8 @@ static LIST_HEAD(padata_free_works);
 struct padata_mt_job_state {
 	spinlock_t		lock;
 	struct completion	completion;
+	struct task_struct	*niced_task;
 	struct padata_mt_job	*job;
-	int			nworks;
-	int			nworks_fini;
 	int			error; /* first error from thread_fn */
 	unsigned long		chunk_size;
 	unsigned long		position;
@@ -451,12 +457,44 @@ static int padata_setup_cpumasks(struct padata_instance *pinst)
 	return err;
 }
 
+static void padata_wait_for_helpers(struct padata_mt_job_state *ps,
+				    struct list_head *unfinished_works,
+				    struct list_head *finished_works)
+{
+	struct padata_work *work;
+
+	if (list_empty(unfinished_works))
+		return;
+
+	spin_lock(&ps->lock);
+	while (!list_empty(unfinished_works)) {
+		work = list_first_entry(unfinished_works, struct padata_work,
+					pw_list);
+		if (!(work->pw_flags & PADATA_WORK_FINISHED)) {
+			set_user_nice(work->pw_task, task_nice(current));
+			ps->niced_task = work->pw_task;
+			spin_unlock(&ps->lock);
+
+			wait_for_completion(&ps->completion);
+
+			spin_lock(&ps->lock);
+			WARN_ON_ONCE(!(work->pw_flags & PADATA_WORK_FINISHED));
+		}
+		/*
+		 * Leave works used in padata_undo() on ps->failed_works.
+		 * padata_undo() will move them to finished_works.
+		 */
+		if (!(work->pw_flags & PADATA_WORK_UNDO))
+			list_move(&work->pw_list, finished_works);
+	}
+	spin_unlock(&ps->lock);
+}
+
 static int padata_mt_helper(void *__pw)
 {
 	struct padata_work *pw = __pw;
 	struct padata_mt_job_state *ps = pw->pw_data;
 	struct padata_mt_job *job = ps->job;
-	bool done;
 
 	spin_lock(&ps->lock);
 
@@ -488,6 +526,7 @@ static int padata_mt_helper(void *__pw)
 				ps->error = ret;
 			/* Save information about where the job failed. */
 			if (job->undo_fn) {
+				pw->pw_flags |= PADATA_WORK_UNDO;
 				list_move(&pw->pw_list, &ps->failed_works);
 				pw->pw_error_start = position;
 				pw->pw_error_offset = position_offset;
@@ -496,12 +535,10 @@ static int padata_mt_helper(void *__pw)
 		}
 	}
 
-	++ps->nworks_fini;
-	done = (ps->nworks_fini == ps->nworks);
-	spin_unlock(&ps->lock);
-
-	if (done)
+	pw->pw_flags |= PADATA_WORK_FINISHED;
+	if (ps->niced_task == current)
 		complete(&ps->completion);
+	spin_unlock(&ps->lock);
 
 	return 0;
 }
@@ -520,7 +557,7 @@ static int padata_error_cmp(void *unused, const struct list_head *a,
 }
 
 static void padata_undo(struct padata_mt_job_state *ps,
-			struct list_head *works_list,
+			struct list_head *finished_works,
 			struct padata_work *stack_work)
 {
 	struct list_head *failed_works = &ps->failed_works;
@@ -548,11 +585,12 @@ static void padata_undo(struct padata_mt_job_state *ps,
 
 		if (failed_work) {
 			undo_pos = failed_work->pw_error_end;
-			/* main thread's stack_work stays off works_list */
+			/* main thread's stack_work stays off finished_works */
 			if (failed_work == stack_work)
 				list_del(&failed_work->pw_list);
 			else
-				list_move(&failed_work->pw_list, works_list);
+				list_move(&failed_work->pw_list,
+					  finished_works);
 		} else {
 			undo_pos = undo_end;
 		}
@@ -577,16 +615,17 @@ int padata_do_multithreaded_job(struct padata_mt_job *job,
 	struct cgroup_subsys_state *cpu_css;
 	struct padata_work my_work, *pw;
 	struct padata_mt_job_state ps;
-	LIST_HEAD(works);
-	int nworks;
+	LIST_HEAD(unfinished_works);
+	LIST_HEAD(finished_works);
+	int nworks, req;
 
 	if (job->size == 0)
 		return 0;
 
 	/* Ensure at least one thread when size < min_chunk. */
-	nworks = max(job->size / job->min_chunk, 1ul);
-	nworks = min(nworks, job->max_threads);
-	nworks = min(nworks, current->nr_cpus_allowed);
+	req = max(job->size / job->min_chunk, 1ul);
+	req = min(req, job->max_threads);
+	req = min(req, current->nr_cpus_allowed);
 
 #ifdef CONFIG_CGROUP_SCHED
 	/*
@@ -596,23 +635,23 @@ int padata_do_multithreaded_job(struct padata_mt_job *job,
 	 */
 	rcu_read_lock();
 	cpu_css = task_css(current, cpu_cgrp_id);
-	nworks = min(nworks, max_cfs_bandwidth_cpus(cpu_css));
+	req = min(req, max_cfs_bandwidth_cpus(cpu_css));
 	rcu_read_unlock();
 #endif
 
-	if (nworks == 1) {
+	if (req == 1) {
 		/* Single thread, no coordination needed, cut to the chase. */
 		return job->thread_fn(job->start, job->start + job->size,
 				      job->fn_arg);
 	}
 
+	nworks = padata_work_alloc_mt(req, &unfinished_works);
+
 	spin_lock_init(&ps.lock);
 	init_completion(&ps.completion);
 	lockdep_init_map(&ps.lockdep_map, map_name, key, 0);
 	INIT_LIST_HEAD(&ps.failed_works);
 	ps.job		  = job;
-	ps.nworks	  = padata_work_alloc_mt(nworks, &works);
-	ps.nworks_fini	  = 0;
 	ps.error	  = 0;
 	ps.position	  = job->start;
 	ps.remaining_size = job->size;
@@ -623,41 +662,42 @@ int padata_do_multithreaded_job(struct padata_mt_job *job,
 	 * increasing the number of chunks, guarantee at least the minimum
 	 * chunk size from the caller, and honor the caller's alignment.
 	 */
-	ps.chunk_size = job->size / (ps.nworks * load_balance_factor);
+	ps.chunk_size = job->size / (nworks * load_balance_factor);
 	ps.chunk_size = max(ps.chunk_size, job->min_chunk);
 	ps.chunk_size = roundup(ps.chunk_size, job->align);
 
 	lock_map_acquire(&ps.lockdep_map);
 	lock_map_release(&ps.lockdep_map);
 
-	list_for_each_entry(pw, &works, pw_list) {
-		struct task_struct *task;
-
+	list_for_each_entry(pw, &unfinished_works, pw_list) {
 		pw->pw_data = &ps;
-		task = kthread_create(padata_mt_helper, pw, "padata");
-		if (IS_ERR(task)) {
-			--ps.nworks;
+		pw->pw_task = kthread_create(padata_mt_helper, pw, "padata");
+		if (IS_ERR(pw->pw_task)) {
+			pw->pw_flags = PADATA_WORK_FINISHED;
 		} else {
 			/* Helper threads shouldn't disturb other workloads. */
-			set_user_nice(task, MAX_NICE);
-			kthread_bind_mask(task, current->cpus_ptr);
+			set_user_nice(pw->pw_task, MAX_NICE);
+
+			pw->pw_flags = 0;
+			kthread_bind_mask(pw->pw_task, current->cpus_ptr);
 
-			wake_up_process(task);
+			wake_up_process(pw->pw_task);
 		}
 	}
 
 	/* Use the current task, which saves starting a kthread. */
 	my_work.pw_data = &ps;
+	my_work.pw_flags = 0;
 	INIT_LIST_HEAD(&my_work.pw_list);
 	padata_mt_helper(&my_work);
 
 	/* Wait for all the helpers to finish. */
-	wait_for_completion(&ps.completion);
+	padata_wait_for_helpers(&ps, &unfinished_works, &finished_works);
 
 	if (ps.error && job->undo_fn)
-		padata_undo(&ps, &works, &my_work);
+		padata_undo(&ps, &finished_works, &my_work);
 
-	padata_works_free(&works);
+	padata_works_free(&finished_works);
 	return ps.error;
 }
 
-- 
2.34.1

