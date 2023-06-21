Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B72FA7378C7
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 03:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjFUBkU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 21:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjFUBkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 21:40:18 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A8F1730
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 18:40:17 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35KLXrmb028606;
        Wed, 21 Jun 2023 01:39:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=pTylnmkQiEkuLZcOffDTQp4QtlPZ5g9pa/a8moapo1w=;
 b=nOq+rFG0Zt1z7D2M3/0EUtrOcKlAPuPdHNsYsRxBfN1V9smYSRl52VMo/HZkmN70C7wV
 mVUUZFast2vASWmysIICpxGKZ0BkfyhhYuPSZFVf0RTqZ96yQgiMB6Sp5PvIIAyNUoVb
 kzXtSI5PEHCrsj1+QnNMGKsNWBcXOjOVzm+vB26/UTzTZWWK2Fal99YqrXKnrW/l4Tp0
 pYfXnQZ9nZ5OmfTmzYS0GEUcnVjMiNkhZjpcZPK/sz16zNTGbf+J93DzZsqwqK8lKX/b
 qIJAg1IuxQppSux3AeBznhL1PHCA8XAT9AWVIpSCycH7AZGa4stV+TMiv3DoLXe1wikf Wg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r94etp721-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jun 2023 01:39:02 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35L1cT66007913;
        Wed, 21 Jun 2023 01:39:02 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r9w15r0p7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jun 2023 01:39:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/3NcT1mFX7pVVQSHCwhQJGRVtyHT4SICQwKbXYCIM6JIy3iivYl2gIgBFhx4xAnOI+0SIkqkbKu34aCVESlBUQ9y8SaPfPJ5IvVlr9a4D/9/lc07/061hX6S0+DJm0IiEIvBICRMjy3jPwTZUZrHUVMNqcHncaJtySlRxY4eEXPfj1fOWmVaY5cbgSPeuvrGmQ4hVZ8AS4/0thPIWXbuZ+jxzA4XtZwhFAZfVAzYl5kxEX0+k5KbHXoVqY9Gez+dMkXgL03Eskpsv21qDozLn34AddKGWZrdlxgjB8JEViz+kD2fhBklD5E1TrDoBKT04Jt7rUhyWSo5bb4mZHlEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pTylnmkQiEkuLZcOffDTQp4QtlPZ5g9pa/a8moapo1w=;
 b=JaVyUsuDDkLb1H1BK/TklPNZw8FGGDbb7d3FzIeC0t8jIbRkFsoUcNrQRZgZPAoNItm1O8YmZvxC0zof0e8rsGekiufl/1Dj4tyT/Rc/f7Nt+5NMiiGwMBFpbLrld8P1dE4unTjEXJi7KvxEZaAmBiypnqcxLL9uCvyFj3ovvT5PWNslm+C55gyl5GQPOfmNwITYmQFXpWB8v6pDTg0L5jpV3vd9GFntZdFjuwAAwupv5rqucH0qjGwl2aMzVByhtXHh5iVeD1ICBj3xx7hu7lZGc8a//TPrFT7HgilAbdyMdoUi04tBB4U1f678i20DxirZ45edy0cBw1zGl2Qv9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pTylnmkQiEkuLZcOffDTQp4QtlPZ5g9pa/a8moapo1w=;
 b=RWEOf9MPsC1D8qeYV7DOwZRlSjFt1IQP+EOWjfkXyJRe0J44F4y1A26TGsk5uNtptZO29EJcZrXceH3GEcVD/jC9KAV1FaHTvBgrC9fgvAvQu5K2rs9RU7Z1xFpLFiyszKqXiJgvmft7Vj75GtXkaDcaa+vDFO2hDemL0AiBiBo=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by IA1PR10MB6783.namprd10.prod.outlook.com (2603:10b6:208:429::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Wed, 21 Jun
 2023 01:38:59 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::96aa:8e73:85a9:98b9]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::96aa:8e73:85a9:98b9%4]) with mapi id 15.20.6521.020; Wed, 21 Jun 2023
 01:38:59 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, joe.jin@oracle.com,
        likexu@tencent.com, like.xu.linux@gmail.com,
        zhenyuw@linux.intel.com, groug@kaod.org, lyan@digitalocean.com
Subject: [PATCH RESEND v2 2/2] target/i386/kvm: get and put AMD pmu registers
Date:   Tue, 20 Jun 2023 18:38:21 -0700
Message-Id: <20230621013821.6874-3-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230621013821.6874-1-dongli.zhang@oracle.com>
References: <20230621013821.6874-1-dongli.zhang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA1P222CA0007.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::22) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|IA1PR10MB6783:EE_
X-MS-Office365-Filtering-Correlation-Id: d3e34249-a2be-4968-1c03-08db71f848e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PSKrusnxzEZDVTNGuA5o+/pqA8vddfdmH4ReWCHBrGf5+bCzOBLdJJLVlJYhT1jYUKQWAe5T29Z12Qypj9jue5UqckfhnrV0A8syRKFY17ISbzNtkthr3gJXRs6mtPaBNJF+BHah0cOFQf0khZCPDS/2bPrD+OG8stTOw6jpG8PUAkPuuE6rMeDggQmdWttyCfeHo0Okttn+A89xSW0YKz/O9XHJvcE1pVyPtHU6azJK4L8+257HxkPlFsVcqMITk78YfIQGablUZYRAqysCTWpGnS4uCEKA7YTf1al7NyLmsaGhmh77LMRXCIZF3sH+zrJuroHBcDVnMhBOJQCUYV58GI/cyxgd83wltMGIlQt2RcgR5Vg/jxZWjo/KQfjse69T5/9ypX6csUHJjVojoQUNDD6nOWEOwM0V5DkiNQbUv/feUTWvcn21HThm1VaGmMPxvHENgFckqUOVq4Nov5k6B3qmEMtAn4JUI3w5TlrOgXe0gjpQSLugZBo0+ghr1PSB2E8GMPdsLJg3OJ9+lzwn5V7HaOdcmWxi7JMhOd/3T41udTBw4iDF3RiPXXVA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(376002)(346002)(366004)(396003)(451199021)(2906002)(41300700001)(5660300002)(44832011)(8676002)(36756003)(8936002)(86362001)(478600001)(26005)(6506007)(1076003)(6512007)(186003)(6666004)(6486002)(66946007)(66476007)(66556008)(83380400001)(4326008)(316002)(38100700002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/z9SHYnOkQS17C/jkBF2yyr9qhWUFQad4ZgIQSVafvB4Bi0x0WL8vFBAfLqe?=
 =?us-ascii?Q?MdzO0yQ+jcy2FsW/D7lfWAOcRteFaMBb5MjRzln8oxpOqXXWVHxYSHEwmbv5?=
 =?us-ascii?Q?xgja224pMiARUKY2zj5Zqx2FCaGc7KBbIoLcRAbturtz9AnGw/NpZdpiPaqc?=
 =?us-ascii?Q?UEvgkZgoNxo0WOrqXHP9z76X9zz8XK7iTrE7TpddIsgYnVtk00ev+nLfOH/k?=
 =?us-ascii?Q?PbAbfB2U1CFuxa0/pqiv9sifBMyfaU82aSI6mQs+aO+KY28JYh6RoB4MpYQF?=
 =?us-ascii?Q?pn+cPazBxxpBhcXKG7TYzyXgibyvjgIHrU/R3aSMzT3ClfAG+xPAjzuWTP1w?=
 =?us-ascii?Q?+9EcVlqmE+lhBphwnYXwjJDdX98r/NLzkuW1kvsSm52sUYeF9rU7LKbFVhXF?=
 =?us-ascii?Q?FfpqdiCqB/aI+8telnnglP0/1N6cUitM7n32990Go0HvlYTOZdzJ3Ko43eS/?=
 =?us-ascii?Q?o1n4fOvp16hqrOmkH20oSYceF5MLw3TgilRGKclnDxU6db2rmXM5fImNGtl9?=
 =?us-ascii?Q?zZ5gdNmvzBNbZhVAXzTizN/fP087emRi+I49cmGOO/Xws0foRZxY26SGJ6kF?=
 =?us-ascii?Q?Ogk4uKCnRqRR75keGeAJ5guiRjdomeIIyA8/ru071VsOiJEUsNkHligkfVoQ?=
 =?us-ascii?Q?TjcaCOpF+sqzjaD32TiIg+NqpPeEzvRKco62XirHGSeLct4r3dVqYbN9TTSp?=
 =?us-ascii?Q?gSPs6fnnVi2hHY8Y55zwUUe7D02Hh4TGeZT3QuF58+j8TBxo5HxHMtSM06c1?=
 =?us-ascii?Q?BSL6pUm0mzY24ayWa9l6g0QJYwaaQQH9lYOXTkxYyXCIHNo/3IqtTdVHTn2o?=
 =?us-ascii?Q?CBj1yhLSJnNuxT69UJaDwe7QWCZYssgj7aW6LI00akkpfnN4l0CTQz/kacSe?=
 =?us-ascii?Q?UrWPRdfAobuHz5lvvWWgUyhgSHgMdsxqJ7afAKiyh4taTe6TvNBrlPTWA9N8?=
 =?us-ascii?Q?CeXjQAEbPWvYBOkDwaOH09dfJMuEDXSKoCUk4hskok9FNx9MjfpZ0OEN+9t1?=
 =?us-ascii?Q?e1EJH2NprM3N5keV/RvD9ZuYdSN3bhgAs8v7aX2qroTOXtdivYVNo6E+BrBL?=
 =?us-ascii?Q?F1ypCvjkWRH98BRKzhE3SkiuNJAq0FB95fUnzAoo+zx5dlhGQgMMUyDciR/D?=
 =?us-ascii?Q?FmVplxSacpchkMPBcW9mJtg7BMTJgvVpAxn4TKjJ2VTicc9Xy7ZC4ycKUMCX?=
 =?us-ascii?Q?DqxOaq6CXaQaF5/6t0PkjFbhu7EHQCWOSj5XlWZiP1SZL1jfud5R6esTukIS?=
 =?us-ascii?Q?Th00qtxN3MF6pEcrXceAI+Danb3Amsd7VpY4SRgO7IWyIWSjXWPCZR5iUWCK?=
 =?us-ascii?Q?JrByr9HPTiCaF4cwjVqAiHqeRk9A2HUw2l8oxce3iX/4O5XKvsKDa4KfVIJA?=
 =?us-ascii?Q?aNerZk5NuKekSx7FZeVAtZZvj/9/uxktj9F1UgD0zyttDnejk8TAxUZ7wyxs?=
 =?us-ascii?Q?+plqYlq77x/T/l3ZwBDIUmnUTyWdnDg2aEz6O7pRMhvmvDcGZa/PS5WmTKfQ?=
 =?us-ascii?Q?JXToo3PHkcI7YidNHGVdChhGfTNaVVLlFueUZ6GSho9lLjQLB1AnfnVEIp4L?=
 =?us-ascii?Q?Tm8nHlR4ReXEmXDzor+c7gkAfO+cNkHdKfWntdQW?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?eiNv+kNzIWJ9s7ZOx4fiMVY3VUYEE74RpzJfq9Nakf+1kvd12NnAMIWNcUQV?=
 =?us-ascii?Q?uvmuDlGrWI1Wj+cW0Anr7D9+cw+5K/K2HGDl+dtm3OSEPksdNSK6OQYyUE4q?=
 =?us-ascii?Q?lNJbDktKRe4itmzi5ibgC3IlCoPhA94psR1KN4QnUBBTQ0SDOZ+W607F1XqJ?=
 =?us-ascii?Q?tnTuZ8V56ROpPbncyo2fy6n6nFDLWtJ6jMs2Mn2Ge6zqRGRJoMTJgqixnC8/?=
 =?us-ascii?Q?KFlomP81HGAV59TtmzV4L07J62k4KpkuYKIWLMNCbNWsWh55KFk73Qk6ELtC?=
 =?us-ascii?Q?U1hAQumvzPW3V8MDojWsPVuhK6Sa2HqkUfacxdvdXpta6kVGKTiQ4nNlZTzN?=
 =?us-ascii?Q?a/QI/EahveJDlKZyUWtrryrbtIAoNoheFxfBoRBtO8ofwtSZgAfS53wZO2wP?=
 =?us-ascii?Q?e5xo5CxB2bGM/JFMQlarLeXR6gDb5iOfgjYm8tc/kRqXqqREts4kCySjC3na?=
 =?us-ascii?Q?x8uEXkPr8XJe8EDMVj+ZZa1L/7Vdy+a42fjtkBjTXL77eAtAxvLjHyQ65hPl?=
 =?us-ascii?Q?AnBUuI81iitdNvb2g27DU6BF7hCCOwNfrxNOGRIHTH92VLZbrNAwkk5bX6sB?=
 =?us-ascii?Q?/ZiAsWTk9rvcs7ndEMRv8dtEpAR65St6C62GIweQfTcyikciDMjtcYbd+cRW?=
 =?us-ascii?Q?ff0NI6DCCPp+NfOUq/TeU1g2eHC3n52++aPMj0GHakHot40tpLs+qaRAjKR6?=
 =?us-ascii?Q?9HHZc4cwdKwcIz5buoTZZH0oUtdMzzr1Wu5/PbcUtnVH8nMKtvlupmUVwalo?=
 =?us-ascii?Q?v8pR36ZRFQ1M85zdQgIpkYTlh7cIwIhQkQriK4VtrgXqkitVyh9m8tMi0JRm?=
 =?us-ascii?Q?f/HpPCtKD0Xl1jAA7+Cm5x4hgS4ZKmE4eV7EtAQtjAaOI46R8ROlxwYCBzrT?=
 =?us-ascii?Q?qY1Pi2Bg9AIYzQQItxLjiAQgpmpgtY+QFMkwaY1XRflVTsf94lNUJ6MZmYBj?=
 =?us-ascii?Q?imIzRahMzSLPVp+aarg+TdMz1KNAFO6fiO7ANOaiMaI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3e34249-a2be-4968-1c03-08db71f848e5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 01:38:59.3444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hhIemsxoCmIdfa8/Z6Jb0h9912wczMaYcQpRjsKIrGFPb3cEcHBHwl0FCgdyyrNj/A4iOFrC2a9xuTJWwPt6zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6783
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-21_01,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306210012
X-Proofpoint-GUID: tqmmgjTDYHMuQssYfSr4I52-pO0U2HlK
X-Proofpoint-ORIG-GUID: tqmmgjTDYHMuQssYfSr4I52-pO0U2HlK
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The QEMU side calls kvm_get_msrs() to save the pmu registers from the KVM
side to QEMU, and calls kvm_put_msrs() to store the pmu registers back to
the KVM side.

However, only the Intel gp/fixed/global pmu registers are involved. There
is not any implementation for AMD pmu registers. The
'has_architectural_pmu_version' and 'num_architectural_pmu_gp_counters' are
calculated at kvm_arch_init_vcpu() via cpuid(0xa). This does not work for
AMD. Before AMD PerfMonV2, the number of gp registers is decided based on
the CPU version.

This patch is to add the support for AMD version=1 pmu, to get and put AMD
pmu registers. Otherwise, there will be a bug:

1. The VM resets (e.g., via QEMU system_reset or VM kdump/kexec) while it
is running "perf top". The pmu registers are not disabled gracefully.

2. Although the x86_cpu_reset() resets many registers to zero, the
kvm_put_msrs() does not puts AMD pmu registers to KVM side. As a result,
some pmu events are still enabled at the KVM side.

3. The KVM pmc_speculative_in_use() always returns true so that the events
will not be reclaimed. The kvm_pmc->perf_event is still active.

4. After the reboot, the VM kernel reports below error:

[    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected, complain to your hardware vendor.
[    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010200 is 530076)

5. In a worse case, the active kvm_pmc->perf_event is still able to
inject unknown NMIs randomly to the VM kernel.

[...] Uhhuh. NMI received for unknown reason 30 on CPU 0.

The patch is to fix the issue by resetting AMD pmu registers during the
reset.

Cc: Joe Jin <joe.jin@oracle.com>
Cc: Like Xu <likexu@tencent.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 target/i386/cpu.h     |  5 +++
 target/i386/kvm/kvm.c | 83 +++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index cd047e0410..b8ba72e87a 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -471,6 +471,11 @@ typedef enum X86Seg {
 #define MSR_CORE_PERF_GLOBAL_CTRL       0x38f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL   0x390
 
+#define MSR_K7_EVNTSEL0                 0xc0010000
+#define MSR_K7_PERFCTR0                 0xc0010004
+#define MSR_F15H_PERF_CTL0              0xc0010200
+#define MSR_F15H_PERF_CTR0              0xc0010201
+
 #define MSR_MC0_CTL                     0x400
 #define MSR_MC0_STATUS                  0x401
 #define MSR_MC0_ADDR                    0x402
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index bf4136fa1b..a0f7273dad 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2084,6 +2084,32 @@ int kvm_arch_init_vcpu(CPUState *cs)
         }
     }
 
+    /*
+     * If KVM_CAP_PMU_CAPABILITY is not supported, there is no way to
+     * disable the AMD pmu virtualization.
+     *
+     * If KVM_CAP_PMU_CAPABILITY is supported, kvm_state->pmu_cap_disabled
+     * indicates the KVM side has already disabled the pmu virtualization.
+     */
+    if (IS_AMD_CPU(env) && !cs->kvm_state->pmu_cap_disabled) {
+        int64_t family;
+
+        family = (env->cpuid_version >> 8) & 0xf;
+        if (family == 0xf) {
+            family += (env->cpuid_version >> 20) & 0xff;
+        }
+
+        if (family >= 6) {
+            has_architectural_pmu_version = 1;
+
+            if (env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_PERFCORE) {
+                num_architectural_pmu_gp_counters = 6;
+            } else {
+                num_architectural_pmu_gp_counters = 4;
+            }
+        }
+    }
+
     cpu_x86_cpuid(env, 0x80000000, 0, &limit, &unused, &unused, &unused);
 
     for (i = 0x80000000; i <= limit; i++) {
@@ -3438,7 +3464,7 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
             kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env->poll_control_msr);
         }
 
-        if (has_architectural_pmu_version > 0) {
+        if (has_architectural_pmu_version > 0 && IS_INTEL_CPU(env)) {
             if (has_architectural_pmu_version > 1) {
                 /* Stop the counter.  */
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
@@ -3469,6 +3495,26 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
                                   env->msr_global_ctrl);
             }
         }
+
+        if (has_architectural_pmu_version > 0 && IS_AMD_CPU(env)) {
+            uint32_t sel_base = MSR_K7_EVNTSEL0;
+            uint32_t ctr_base = MSR_K7_PERFCTR0;
+            uint32_t step = 1;
+
+            if (num_architectural_pmu_gp_counters == 6) {
+                sel_base = MSR_F15H_PERF_CTL0;
+                ctr_base = MSR_F15H_PERF_CTR0;
+                step = 2;
+            }
+
+            for (i = 0; i < num_architectural_pmu_gp_counters; i++) {
+                kvm_msr_entry_add(cpu, ctr_base + i * step,
+                                  env->msr_gp_counters[i]);
+                kvm_msr_entry_add(cpu, sel_base + i * step,
+                                  env->msr_gp_evtsel[i]);
+            }
+        }
+
         /*
          * Hyper-V partition-wide MSRs: to avoid clearing them on cpu hot-add,
          * only sync them to KVM on the first cpu
@@ -3929,7 +3975,7 @@ static int kvm_get_msrs(X86CPU *cpu)
     if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_POLL_CONTROL)) {
         kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
     }
-    if (has_architectural_pmu_version > 0) {
+    if (has_architectural_pmu_version > 0 && IS_INTEL_CPU(env)) {
         if (has_architectural_pmu_version > 1) {
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
@@ -3945,6 +3991,25 @@ static int kvm_get_msrs(X86CPU *cpu)
         }
     }
 
+    if (has_architectural_pmu_version > 0 && IS_AMD_CPU(env)) {
+        uint32_t sel_base = MSR_K7_EVNTSEL0;
+        uint32_t ctr_base = MSR_K7_PERFCTR0;
+        uint32_t step = 1;
+
+        if (num_architectural_pmu_gp_counters == 6) {
+            sel_base = MSR_F15H_PERF_CTL0;
+            ctr_base = MSR_F15H_PERF_CTR0;
+            step = 2;
+        }
+
+        for (i = 0; i < num_architectural_pmu_gp_counters; i++) {
+            kvm_msr_entry_add(cpu, ctr_base + i * step,
+                              env->msr_gp_counters[i]);
+            kvm_msr_entry_add(cpu, sel_base + i * step,
+                              env->msr_gp_evtsel[i]);
+        }
+    }
+
     if (env->mcg_cap) {
         kvm_msr_entry_add(cpu, MSR_MCG_STATUS, 0);
         kvm_msr_entry_add(cpu, MSR_MCG_CTL, 0);
@@ -4230,6 +4295,20 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL0 + MAX_GP_COUNTERS - 1:
             env->msr_gp_evtsel[index - MSR_P6_EVNTSEL0] = msrs[i].data;
             break;
+        case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL0 + 3:
+            env->msr_gp_evtsel[index - MSR_K7_EVNTSEL0] = msrs[i].data;
+            break;
+        case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR0 + 3:
+            env->msr_gp_counters[index - MSR_K7_PERFCTR0] = msrs[i].data;
+            break;
+        case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTL0 + 0xb:
+            index = index - MSR_F15H_PERF_CTL0;
+            if (index & 0x1) {
+                env->msr_gp_counters[index] = msrs[i].data;
+            } else {
+                env->msr_gp_evtsel[index] = msrs[i].data;
+            }
+            break;
         case HV_X64_MSR_HYPERCALL:
             env->msr_hv_hypercall = msrs[i].data;
             break;
-- 
2.34.1

