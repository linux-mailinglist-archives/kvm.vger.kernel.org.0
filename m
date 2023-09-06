Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49265793C54
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 14:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbjIFMIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 08:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbjIFMIu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 08:08:50 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4D3137;
        Wed,  6 Sep 2023 05:08:46 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 386C4ujZ030094;
        Wed, 6 Sep 2023 12:08:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=R4C1fedtckwYprUsql2D1NC8WPURI6fPkCw2Kc63XMY=;
 b=Lz43DRuLsHotsp0txAyEzLYV3BdUzH3yjvP0zD3Ra1eJqk9TWCwlsxGbfF0t7osUwqN3
 MIdf4Rtcn/aDGLhSVVBiIYiRfVJLw1afoYEEozWjjQhNZ3B9ECeufBdkmRrkTRNDZU/w
 HjnEcUcblquMV5T2wi0IBTHMVSW82qy2p6cu3qQR6Fqk8ZVsSazIgNewfj8/hVXLX7lT
 kcUjUNSeVa5dE8b1tkKlu+tLoby8p9zS44OwGpnu0XU7SBK5OL27btdx8JNAZuDdQIrf
 KetOQKccBiDlfMd/eSLub0sB0l9san3ZvEZ67+01kWWrYExPmj2VQPOcn787DFfV19I6 Sg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxs41g053-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Sep 2023 12:08:25 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 386C06vn029123;
        Wed, 6 Sep 2023 12:08:24 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug644py-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Sep 2023 12:08:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AmKiVaQvKE2YnorJBmQ80bFt/IhRslgy5QEuBM9MZoyb/769s1Myfcs1wbirij1pTjZyrZxWKLLC2CNS0gqyoTMz19TyNKUIH/dJbkjjM03+aOh8QSLBzSgrNKWEKYugn4YDu42UmFEcs48++UQ/u/3jIbk1opuHGgusRve9Zh4TeQ94gpz4rz3zZnL10sXKKn7TXLJ4Hl78asAzIbNAearXDGecy0tIHgVmpv5Ls7mhH4olCT0gPoZLV705Slmtn0wNaGq+ffbOiq6aL4AZh0eKvjekyqGOsWtj9gDc1wkJAOFYMU/k4po9kAMFOZYkB0o5MK6bQHnobHQCL1a3Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R4C1fedtckwYprUsql2D1NC8WPURI6fPkCw2Kc63XMY=;
 b=RE8zH0ihPbAVEEiMm2Y1FNCmbiOXmfkq5HtB0l7UNG4hRlcPBdPBrijLB5hNABIYl43SKw2z4ZGkQxQU+IhBKKV5bysEcfGAyl0BncOKOzyzE1DK85Uilzdqvn+epOfYwebJe0YTe0Dc8ngR0Hc6xrvzsRnmCJMmkCMfvR1fkLCeGxQFTxId/JqTC5SY1o49vRQwFxBtmUPi/wAbLkW2oM6r5rDARk72DJjDtZow6oxA8Y7kPU9JlUvdiFCJukvw22dQwRfLumhsLdE/7DhknnaTK5yBzkcCHtOeUnJTF4Eox+v0itBrAM9RVBpi15dCeaa8sKRiucC56JhC9yorTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R4C1fedtckwYprUsql2D1NC8WPURI6fPkCw2Kc63XMY=;
 b=i0xNo7Sp40/XEp/ZVRAhvi0wVkIc8iPV53r2S0Z7yUERQdA+bKFuVO+5G47Pm2GXcHgenA7bi4KoAshG7JLOGpEaGyxsPjljuwU/wPd0iFHMSgg4ZI5N0Xi7F6cNz3+PGxltu75SQ9/EwoimSC3goOmes7oDBmB5hngJAnihe+Y=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by IA1PR10MB7447.namprd10.prod.outlook.com (2603:10b6:208:44c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Wed, 6 Sep
 2023 12:08:22 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2867:4d71:252b:7a67]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2867:4d71:252b:7a67%7]) with mapi id 15.20.6745.034; Wed, 6 Sep 2023
 12:08:22 +0000
Message-ID: <83631b8a-f4d1-f581-0bcb-993c81f8fba9@oracle.com>
Date:   Wed, 6 Sep 2023 13:08:15 +0100
Subject: Re: [PATCH V7 vfio 07/10] vfio/mlx5: Create and destroy page tracker
 object
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, kevin.tian@intel.com, leonro@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com,
        'Avihai Horon' <avihaih@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <20220908183448.195262-1-yishaih@nvidia.com>
 <20220908183448.195262-8-yishaih@nvidia.com>
 <9a4ddb8c-a48a-67b0-b8ad-428ee936454e@kaod.org> <ZPhnvqmvdeBMzafd@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <ZPhnvqmvdeBMzafd@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR01CA0150.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|IA1PR10MB7447:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a26cb07-60b6-4fa5-ba8f-08dbaed1f745
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VH+L9krWFBxvNYEuCyS/vvUCtL+sgb9jGTMjoZkfCAWFsd2v2uxJXjxmSsFUHHAvL//tnFdp1ZbZz3gXDksrRr/p1Bmk4CtaODsdpDBRb76Is2f98Br2MU4YWcMXh4VnE8vjOvJ4xJFuOqi64sijUk0vRnOc4kMzzMtOInpzm0kmu2ivbzVtM2qxBF6bFqvCTpwg6TucCTTnsIXOZAUF4NmSx3DVxPqiZjn9jmt/S/OLvc12a72+pxifmWN1x0BIS1fFd28grTTMg1Ww4x9kc49tpO9J2mMI2UKxRRiErw1mK8C7+RcWBNH/tSqoMQbRTaAM8PA2gEBW2qFo0ufIMX6AF8F+ZLDbvrjTJwf2nQdt1bDrqmevP4IohWDPDxiyVS3+gABoARcIUzXEVpjYaTtfs7tYnch8rbtvVoM21Mk2oqg822p6hwPfMiGCOeRBidZdSHNEulKTNOwCU6dpMCao1GAB78qB9E/5/sBnAR0gxqR2sh8gIaT2SrKfB9x2N0LFFhuFP83U/f27eHHjRaq3SkP+QL+NdIuQM6yKzRD0s3ZoO79p9mWCIi0h6FuO6aZRIAema+sUB0GwFBFVYF4ZkYcHYblyiZ0sLqSZxRTOCPecA1H9Z/tTtXkubSxR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(366004)(396003)(376002)(136003)(186009)(451199024)(1800799009)(2906002)(66574015)(38100700002)(36756003)(31696002)(86362001)(41300700001)(6512007)(6506007)(6486002)(53546011)(110136005)(66556008)(54906003)(316002)(66476007)(4326008)(66946007)(8676002)(2616005)(8936002)(31686004)(6666004)(478600001)(83380400001)(26005)(5660300002)(7416002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dlN6MnRWQ2JOT2pjQlBJQnZGV0w0d3h6M1JBdVM2VlNBdGk0em1mQkVGZk5a?=
 =?utf-8?B?TzFFYkNYZm04SnRKMCtPWGYremxTckNwMW9YdW9rRk11RlZoM05ZbDFaMm81?=
 =?utf-8?B?bTJ4UWNQSFZrditLcGNxYUtNUXowMUV3TllBcnF0UFB2UmJFVEtNWURHSFE0?=
 =?utf-8?B?OVo1YnhZTEtrU3RTL1hROGw0Y1RSMzVaN3Uxbmk3aFVydFhHMlFyUnozVlF3?=
 =?utf-8?B?ODhmL2pIK1pLdzUza2IvUTFMcnZrL2dTd2dIbnVhK0tBTU12MS9zSkRteGdt?=
 =?utf-8?B?R3lobm0vTUxRdEc5OXdmL1NHSHJ4QTc3dTBaN0xRdTcraDhGSFZ2VlBFRE1O?=
 =?utf-8?B?MXVkVmtNRm5TSk1wUEV2TjNqMjZIY0lUNmY4cW93RWFiWGIvc1lBbFVtTHVS?=
 =?utf-8?B?SzF5aDlzUForYjUwZ2YvT2dhTFFuZDNUM3ljcEdCTkdHb3lRZ0ZFOGN1bHFN?=
 =?utf-8?B?bkhlS083REoxK3ZYZUtaYmpIdnVvUTAvOTVRV2tvYzdTZXlmb25rNk1ieFhO?=
 =?utf-8?B?NDY2SjIyTTdHd3pVNjBkK2c1REd2YVBGVlNMQmsrcmJuNFlRTEZRRC9BVnUz?=
 =?utf-8?B?WkpCVnJZV1RhaVFnMWV3VHBqOUFaRGtHZ3FWRUY0VFhPb1Y1WkQrTjUrbXlt?=
 =?utf-8?B?dzZCNnVzSTBjMEJzT25CaXgvSW9kMWYzM25ZTmRhblh3aytZSFBkSFJieldm?=
 =?utf-8?B?WVV1UjFlNTBYUlBPVzlaL1ZzRTJ2UklLME9SSnAvNW1LWlR4L1ZUTXZqTHFK?=
 =?utf-8?B?L0lrSWZpbCtTMVhoSGVnV2RySFFqVzhNK2pxd2RYTVJZNEtYRzlLSHdNaHhh?=
 =?utf-8?B?azNqNTg2OHFqZ0FzNnlXTWVMVkgvZzl4WWZBL2JrNHRLV2t1UXJ5Rk0rcUx6?=
 =?utf-8?B?NnViVVlqeDZ4Q0wwNkVTdUZsdTk3SUIrR0VzYi92Rk9CdHJMcjBHei81YW1S?=
 =?utf-8?B?UjdNWXRyd00xcFY0ancwZXdpbm43c2RqQkFrTkVZMGlDUFUrbnN2OU96MnRy?=
 =?utf-8?B?NklCem5oN3huNXdneVFJZ3cyVytCNE4vTTdTaEVQZ3Qrbkl6c2IxUkNzNnpU?=
 =?utf-8?B?Z0VtRHZNa0VmMTFIUWVDS2plM05BWSsxQzVmSUJWNU9CK2cyVWYybnpyY2cx?=
 =?utf-8?B?aGxjRjVUcHN6ZGw3VEdHbmFRR2x6ZU9NUDczTHhXM042SW5ZNWh4L05pSldP?=
 =?utf-8?B?MHJxaHdmY01Kc2pxbUp6R0xINVFqZVhad0RWMnEvZHZCRWppRXNWQWlSSVBL?=
 =?utf-8?B?anRESVZTTWJUUk04d2V1clBzaGxyVGF1SFd5OU9WcjNKYlZ0b1JCRG16VDlt?=
 =?utf-8?B?ZjlVaWFVckowbkZwY2NTcHNEUHRuNkt0Q2JEc2VSWnBuRmlsWUx0MjczZjh0?=
 =?utf-8?B?a0pSY0JsZnlyNkp4UHFUdllybG9adFVkQmxSeWhKK3p2UENTbm90QTc1SzhZ?=
 =?utf-8?B?RGhEUGRRbnNnamE2SkE5WVlueFJWVGh1V0laZFRPUWZrMkl6OVJOT3VJa1JN?=
 =?utf-8?B?ZWN0VllBOWhuVjYvR2l3WThJampndytPQnhZajYxYWVVcE5VUHo2dXhLNEcx?=
 =?utf-8?B?cEdEd1NORzZVM2xqVDVRTXVuczNpdmVRVWdMNnJLaHhOUVJjU2pYbkhpcHd0?=
 =?utf-8?B?bmhYMElzZUZHSUMzSXY5ZFRCM1Q3bm4xZ29nUjErLzFLd2owM01uT1VlVkhv?=
 =?utf-8?B?bk5Kb0s2c2RzOXZhSEQxY09aM28yMS9tOGZYUDFDamVFdGJEWGRUZXdKa2hD?=
 =?utf-8?B?elppMkhUZkpHcHlzRVM4eWdvUnJlVXVKa1lPTVhobW84M0xPRHFKYmRrQlN5?=
 =?utf-8?B?SnVaSzZ2VmF1cGl5YVYwNnBkK3ByTGxoVlhWMmhHdG85WWZpU3ZIK01PL3U2?=
 =?utf-8?B?RnpPOTBJM0E2eGw3T3RIcDhjYU9qQ3lqUGlabUtyay9aM1ZEa0lFbWtsL0Jl?=
 =?utf-8?B?dmNkMG1LVHlFOEI4MUlrZEUyRGNjTXBjRGFhOUNSZ0hYM2dOUkJ3T01TdTBx?=
 =?utf-8?B?Zjlqdi94VWpMMmhRckM3VzlQOHhnSkg2U0MzR2FUakNCL2p5Nm1Ta3RBN3ZV?=
 =?utf-8?B?ZlVKUitrSDM0UDQ3bHAvTkFTTzZnVlJFM1dKMUE2SUY5TmxLMXBQVnR1anpS?=
 =?utf-8?B?d3ZTejNROXVIL2Mvd2Rpd2owVC8wc1JaeWxqMU5LN1RIb0hzSklOeGd1RGxD?=
 =?utf-8?B?emc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: n2xdL7ofaQRk2nBeKFKp1uEXObWjkbVJmGoTp7QBPNRJg+wRReBgnWuD4Vw2yhBLR/wn9++vh0DxPwCOahOS7E3qGkFa4X5EqS2Gjc4pCnHUrL9P7rfdacJqbiCsDOwbdRlHW5jHWoDFWiDIRXqPf07JFF8gavQv7WgObTdxDKm/Tk37oHsLkNnrkMi6Cx/TGxQo3b4n4RSSkHe2TbLn0Hh3DLx2IZoUUiHvb78qPEB15UC207PDxV/k+vqobERbjdH/94WwEOCJOjQbGpzys/tjOSMXB7C50s749e8CiuvWkGzCCQ1uaWcGHZEjOwmcF2oBMr/Mu/tCJZHYa9yTgUNa+WzzmbejZ1Fro9sHLn389uX4sT5G1tlDUUGBjvOqht7FiJOwIY1YQcD4LckZKV7N5/7R203y4fz3xwGcqNH4RzRGI0PhwcSZQZ6NhTq0Ff+D3SmvJmlrSYbhlHe/MmgZzJIBSamPkQmg1/bGJilK6/GmgYNzEin2ml7dGXGSE8duaueglmM07bgughorqO4S+rjOI9s6C5Gk3dUZ5L1dphispGKYsfGods9cXhrq5zFd9wSFP49Nr7s2Ql6tRxJTBcxnMvqqUGAYfeBPsEGWwR2ugt3+Fii35EI77K2mFfPXI+byKzeASzZ6JhO+YQ6aOYn2cMF2dJ3mUT3nlp290RNT1WTWcVhTpxOCPV3BnuoeA2US2TndYnPjzQtihMnbRNHbdKPLvTuIxM07QoqUXvDmEwmsa3lSfTLxgucYvt+aIQmhOE0dpSqfol8dMe7Kte8b+7Hu5J6pXDtVvtlzwLZMUWVI5C6+Acm1/eQRzHBv17q+PhFR6p1TMhshi8uN7PjQvDWQSQD7LbwdPZYWq+0PiUlRcyTS7FEfJ9zLVGRALlPXs9LQz4QeaVKEhg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a26cb07-60b6-4fa5-ba8f-08dbaed1f745
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2023 12:08:22.4793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /HfC6X05g8DdT9m+kHfVruhNHvulDTPOVIyM4S8h0S28bgV8wy4ZiPrODP32Ly8WvwGeQO2FPae1cco/ioIic1sH4Ry+VHyIKJOscaD19Ts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7447
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-06_05,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309060103
X-Proofpoint-ORIG-GUID: Il5AMsF5yDZCW1qnhb0L210_7WS67iqU
X-Proofpoint-GUID: Il5AMsF5yDZCW1qnhb0L210_7WS67iqU
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/09/2023 12:51, Jason Gunthorpe wrote:
> On Wed, Sep 06, 2023 at 10:55:26AM +0200, Cédric Le Goater wrote:
> 
>>> +	WARN_ON(node);
>>> +	log_addr_space_size = ilog2(total_ranges_len);
>>> +	if (log_addr_space_size <
>>> +	    (MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_min_addr_space)) ||
>>> +	    log_addr_space_size >
>>> +	    (MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_max_addr_space))) {
>>> +		err = -EOPNOTSUPP;
>>> +		goto out;
>>> +	}
>>
>>
>> We are seeing an issue with dirty page tracking when doing migration
>> of an OVMF VM guest. The vfio-pci variant driver for the MLX5 VF
>> device complains when dirty page tracking is initialized from QEMU :
>>
>>   qemu-kvm: 0000:b1:00.2: Failed to start DMA logging, err -95 (Operation not supported)
>>
>> The 64-bit computed range is  :
>>
>>   vfio_device_dirty_tracking_start nr_ranges 2 32:[0x0 - 0x807fffff], 64:[0x100000000 - 0x3838000fffff]
>>
>> which seems to be too large for the HW. AFAICT, the MLX5 HW has a 42
>> bits address space limitation for dirty tracking (min is 12). Is it a
>> FW tunable or a strict limitation ?
> 
> It would be good to explain where this is coming from, all devices
> need to make some decision on what address space ranges to track and I
> would say 2^42 is already pretty generous limit..
> 
> Can we go the other direction and reduce the ranges qemu is interested
> in?

There's also a chance that this are those 16x-32x socket Intel machines with
48T-64T of memory (judging from the ranges alone). Meaning that these ranges
even if reduced wouldn't remove much of the aggregate address space width.
