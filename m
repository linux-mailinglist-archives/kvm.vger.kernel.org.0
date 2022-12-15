Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 693E064DCF8
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 15:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiLOOi4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 09:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiLOOiy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 09:38:54 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CC313CE9
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 06:38:53 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFDjTAx031219;
        Thu, 15 Dec 2022 14:38:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=D15q0alEEAsGg+yRYJJzPt+deIOvhPmlOKPfjm4py8M=;
 b=2xcoj9IUzgxBeH3KiUDfF7z44EkYJaLKL/mN1oMDrmZILs9MMDizq1eclKXIi2vkqXYc
 aPyv7NR1dll4DdT6ToXlIjvC72B0e0464YNlWTGV8nVQhAfQ7zEyA/bQ1+JkFCDlzP/7
 0MHQKO+jI0FWPoz9qcJJ+l6VJg4ndOIola+ufvrOoAb26PVbVfx6rF8FXMgdeLFNJGzs
 c8vXSP3RI2/oAaJPXzTRSEBRKCQxkWNEof9zMVPdr97T8YmVg4G43Jx0JT3dgRhRkBqI
 N++hhdG6SRuiWpSUEkjjKYgZ6zLkf6D7iBFsqfLsx+e8gOGPbUQtqZysX7b1lqvgx17g uA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyeww6rf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 14:38:49 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BFD6g5U011100;
        Thu, 15 Dec 2022 14:38:47 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyevtfpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 14:38:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWeTISq2UUaXp6Ol/XTuqC1CL/lE6X7wL8gj7+6sB+Onq84R6WQJw5TtwVl6fqmRBttgUjUDkcxrzE4ZCVGvwE+AcQvuH/JVFHUaWEyGMUWElzkI4/VmY4MhP5KmH7t1BGfGV7zH/ULL5KN0YT0retxUK6LL9VkWoPVDmUa/JMNhWbcvPAoyok6y2z5m8QU+QiOC34Mz+Wfb2Z4wNUO5ua7ZBB7LfkXv7CiLycinPeXXeWaIJxWsHvE+egy4/evzGu/dTqGJsQrgIg5We2Kyj7j2ti31w9cFa/uin1GR7DRLbnsYAtXJFo0tPSzG58sdWiUNjTlPrIG/zkh6xLd+Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D15q0alEEAsGg+yRYJJzPt+deIOvhPmlOKPfjm4py8M=;
 b=ZJ8kWCrnUnTbpWCCsN88zl1V3kliLJtdtxwNx09s87hh27poYSQg8nbXI2ZAPApmrMkZfQGSM+XF3VhCkbmWI3I5gaXyuunakfg3sc34BXXUUrRYcpNI4jdqjhVEe59ikSLsgD6R6YkTs+sAo/rncOHUgRgrTZU+RvVRmloN/QMPQXUfFkNcMqGQES9u7xf6DAi7SUdz1WTGHNHladB3ph46y2tv2NERdHkQw1FOfUaCeZnZNNrsMvA0WZ1e/8FIG1X8SGnH0fM0Hg8t/g6DqVOCBh8eSWAGTzWp0FM9B87hoWUndMJlBy/t0n4IlwRfBrcuqkz5A08TilN/uKmEZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D15q0alEEAsGg+yRYJJzPt+deIOvhPmlOKPfjm4py8M=;
 b=cEg230vbdq/5oDoKoqx/Mor3A0CQDBDyUe5GgYeX2zqeAilFNE3h4MQXfxdEIMhxhQpPqP//e53B92pdcmj0DHDq0mzr4bjCKJ2JZvab8FmjIEf5Ep1dGGoroKTFT+uQ4wPMcrKBLU6lNgwq39PSBeg9JI0s/KTZCw6SV92YnkY=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by PH8PR10MB6600.namprd10.prod.outlook.com (2603:10b6:510:223::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 14:38:45 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca%7]) with mapi id 15.20.5924.012; Thu, 15 Dec 2022
 14:38:45 +0000
Message-ID: <4736f410-e925-3eb7-7c33-bcf4ad9b55a0@oracle.com>
Date:   Thu, 15 Dec 2022 09:38:42 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V4 2/5] vfio/type1: prevent locked_vm underflow
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <1671053097-138498-1-git-send-email-steven.sistare@oracle.com>
 <1671053097-138498-3-git-send-email-steven.sistare@oracle.com>
 <Y5stJHFWK/ZLzA1q@nvidia.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Y5stJHFWK/ZLzA1q@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0221.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::16) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|PH8PR10MB6600:EE_
X-MS-Office365-Filtering-Correlation-Id: ab04ed4b-2a78-44b6-8ea5-08dadeaa11f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7ZqTpY+nwGxrtNd3VPVqbDJQZ1Sfr7mKR+P2KqarIB74cPjNH+r7QslcIbQQafWZLpQNaWrB7dhIPstHB+hivAdMVX3elv+hr/TY7336kgv4Dw9zNO8ceEcbFWS9RE+0cYDpsL43qmzL6/tXIORxMu4+tBzD2gNvozRYuJv65zTu0a5DoQqrWC90qqVlDFfmvFZ1bWruPRPQZN7zRjoPNE5G3Yf8eKw8iUScOOJhhiAsxGTcs5IHnbdMDDvWOQaLedrr45rruymfDWR3aN60bT184/P13phPmAv1xRqaXdlanM0L3biDmKCA9iUkSjqpeOyOLo5gcOvrR5lzgww+9ZFlOM/JZNo/AaJHF5Ql1cU3V1Q7Nw4yawqWRcq8VM3dNXHuA3v8tpfMCjipShhL24kxgpIbtsuNUdxrnRDapD+vJQV8sqBjeoVrhm8IIP2sx0tZFmj8nJM1mCYp/5pbI0jShQrg+xHb4fKq9dgCuwxaP7ThHfv3l2Z6Jff2AJitbMX25Hqr0jFI2qwYs52YIex3QRiuWSGBqZTABKkpwEhUghniA3DJiEqd10Eia/2FmcIDe0oGGj7KGYYYM8ZG1y7UihMY4ixZTbIaavSPBhTmjPAzrAvV+0IYInH9P0KWY0+fV641X6t9x44igquqj2+BgQofiQqYdMie0NQAi9bTAJ4gpTN++MNK9j1fIElPuM0PutHj0s6SEnTnHjx6yLCN0w22QSQs14MIDgDBp7c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199015)(36916002)(6506007)(2906002)(2616005)(38100700002)(31686004)(478600001)(6486002)(6666004)(5660300002)(6916009)(8676002)(53546011)(66946007)(66556008)(6512007)(66476007)(54906003)(26005)(186003)(41300700001)(8936002)(36756003)(83380400001)(44832011)(4326008)(31696002)(316002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WTF4R0VKSUVvWHdhNXJiaTE1bk5rTkxkY2hEcUYrc1Z6aEdxUTdIZnZyR3NN?=
 =?utf-8?B?alRoUU1MeDVseHBqbm1qbkJaUXFOQ1lZRkpaTDRLM3NnMnA5YnZrS2hKalRS?=
 =?utf-8?B?a0VFQWpxNlpiREtvekY2ZndpUVp1VkVuWWJaYSs1K2MxTGxmcGk2d0pMdnRr?=
 =?utf-8?B?d3F2a25TK1ZsMjZYWHFrTWFWbnZHUzAyNnZFMUJVejUxK1p0eXJLSTQwOGc5?=
 =?utf-8?B?VGkzM0Voa0dVZUpSUnEwU1F4ZHhJMWpOa25ZcS8xUXRLSzN0MHptZTVOWURa?=
 =?utf-8?B?MzVKYldTSTlnNTVSa2tWNExlZU91MEpWMVNJMWZSRVUzVkJrSW90K1Fyb08w?=
 =?utf-8?B?N2c2OW96ZTY5QjY4RTJSS3JXSERTMWRkZW1FUUpZeUFIUkV3bW1La0hXRUFq?=
 =?utf-8?B?WGhNbkhudGpnYW9GZUNCNmhWZ0xlVDNxZUxQWnBnUzF3YWRNRmNJL1NsSTdS?=
 =?utf-8?B?R1NDR09lUkx2VVZFaVJxQVQ0YkpTdC9lT1gvb2dFZkxGRlNvd3R4c0dFT3BO?=
 =?utf-8?B?MFhVU01nMDg4UzA1WmtYQW95d1FkUHhUQ0U1VndlZmQ0emZucExpMHUybDM4?=
 =?utf-8?B?MVdxcHFHSXBkY2djZHhxR1NNdGFscUNDNnBmSXZGRDdjNmltMXdxMEpyRkQw?=
 =?utf-8?B?bDYzL1ZrWGZOdFBXUW5TTVRBVUlpV1lCZ25zTFd3b0M2R0Y3YU9JT1dUMGdV?=
 =?utf-8?B?UldYMk45L2N6aURnL2VRRTdPSi8vRzZTL2NpY1dqU1BOZEx4aFZrU2dEM3ZG?=
 =?utf-8?B?NURrVGt0bUFMeVdwT1YveUxUOUQzUnZuZXQ0WFAzaEY4cWMzem9Udk9IWDVZ?=
 =?utf-8?B?R2UrbnpWVDluckQ2ZzlLVDZKTTFFYSs1QVVzNzVxaGUxOTkvS1hhK0tnYkJS?=
 =?utf-8?B?TnUzZW9Mb1V2bUlwTjd1NCtFQnZCTkRFUE0ycnhBTEliVUhtaWdTT1BacE5O?=
 =?utf-8?B?WityRUFab0RtZWFYMTlrTHA5TjlZNHpERWRwWTZhOGVyK29zWlNseisvYnA5?=
 =?utf-8?B?RjZNcEt2VTYzNElsUXAzbkU5RFFqeUVsa2t2SGdBaGQybXVrbWlCTjdpMVRz?=
 =?utf-8?B?NmFsNU9aVXVOc2Y4anVTek41am1MV04zVEhTYjVqMDhucG5MSGlBY1VRUHFr?=
 =?utf-8?B?M1FpZjRnTGQxdmFFVEpTdEMrYjREVmZsbUJZdTNFblR4VDR5cTJZemg2MXk5?=
 =?utf-8?B?WGFrWjZQcTdBNUtteUdlWTdFR3BER1VUMlV2a0daUVNlMkRjZFFDcFZSUTBi?=
 =?utf-8?B?bFgrYXloZmdJY0xzSlB3b3FSQU1rOE52bGNDNTVYS041M3RWdmoxcXNqTUNK?=
 =?utf-8?B?YU40TDNEU0VkcXkvN3daa2k2dS9sWCtoR01YTFdldlQvL21RSEtaRW9nVXV1?=
 =?utf-8?B?SDBRSDlFRUZ4SEZhTGVnZHlDZWk1ZW1nM283eE80cG5DWmFlK1JneXlGWXd1?=
 =?utf-8?B?bG9yQ2txZGhjYVVWUW1OM2V1TFlscUdBNkk2cjIyVmhaSlJEWGNXcFBtSlI5?=
 =?utf-8?B?Skx1ZGx1eTNZTlZzT2RoWkp6WDBaU3Q4VVMyZlJWenZISERJMWUveFRCRk5V?=
 =?utf-8?B?T25xYTBxcEdWOUVBcE1RSkxjcUNjcHpNTU9CNlRVYXErZ21yTldIckNJUGtS?=
 =?utf-8?B?RUcyV2w0cmRsUTRQV2dUYlpoNTlseVdBMys5dXR1Ly84L044bUtvNEdaTi8z?=
 =?utf-8?B?WTFwdTZVUVBkTk01ZDJXbHB4cTkrZGtBY25kTTcraUV6ZExwR1RPK05VOTBG?=
 =?utf-8?B?OVJ6Z083elNYZjFueERocjhrb054VDUzaXN3dFFUUHVSVTFXdXdjelJCbzM1?=
 =?utf-8?B?a0s4QjE0aWRPd3p5RURHcG14STdIVHRXQ0Nhc2RuUmYyTmxpN2RaRkdmZndz?=
 =?utf-8?B?KytKb01XazhheWdHNFpFaWV0R2lyMGFRb2thUUUvcHp1UmQ5QWQwLzgxVU1K?=
 =?utf-8?B?allQekp5b3MwUmVTUkJGelZDdVlLRDhRNWZPR3EwQW44NTR6RjlwaTlZcUFy?=
 =?utf-8?B?MloyaEd6cDJFbEJxeDZFaWd3VlpPNEMrdkVkT0FQU05XNHZUM2dOU3UvS1lJ?=
 =?utf-8?B?ZFJ0emZSOXlPMy9vQkV0anlaT205NitDOUpqUUVyZmVPT2hUN3hneXJxaUQ3?=
 =?utf-8?B?SVdoQWNoZ0l3Wm1COVlGTTBYZU9PZGl3RnlDM3dyT0FPalRXUjVwR1BIaHhB?=
 =?utf-8?B?K2c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab04ed4b-2a78-44b6-8ea5-08dadeaa11f1
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 14:38:45.4289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pWTUxU8sfAruPUb8oIDZzpN2uGp7OosWJ5unA5jWGR95HAD+4Nqww2pVovsrOjJcZejlKwZdSGkpRFdZ+/Sm6C+MjAFxyWf+4slXihQqOAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6600
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_08,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150118
X-Proofpoint-ORIG-GUID: YoECRvluJoqhXaYyIfjR00OFlDP8gqip
X-Proofpoint-GUID: YoECRvluJoqhXaYyIfjR00OFlDP8gqip
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/2022 9:20 AM, Jason Gunthorpe wrote:
> On Wed, Dec 14, 2022 at 01:24:54PM -0800, Steve Sistare wrote:
>> When a vfio container is preserved across exec using the VFIO_UPDATE_VADDR
>> interfaces, locked_vm of the new mm becomes 0.  If the user later unmaps a
>> dma mapping, locked_vm underflows to a large unsigned value, and a
>> subsequent dma map request fails with ENOMEM in __account_locked_vm.
>>
>> To avoid underflow, do not decrement locked_vm during unmap if the
>> dma's mm has changed.  To restore the correct locked_vm count, when
>> VFIO_DMA_MAP_FLAG_VADDR is used and the dma's mm has changed, add
>> the mapping's pinned page count to the new mm->locked_vm, subject
>> to the rlimit.  Now that mediated devices are excluded when using
>> VFIO_UPDATE_VADDR, the amount of pinned memory equals the size of
>> the mapping.
>>
>> Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
>>
>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 50 ++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 49 insertions(+), 1 deletion(-)
> 
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index bdfc13c..33dc8ec 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -100,6 +100,7 @@ struct vfio_dma {
>>  	struct task_struct	*task;
>>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>>  	unsigned long		*bitmap;
>> +	struct mm_struct	*mm;
>>  };
> 
> I'm not sure this is quite, right, or at least the comment isn't quite
> right..
> 
> The issue is that the vfio_dma does not store the mm that provided the
> pages. By going through the task every time it allows the mm to change
> under its feet which of course can corrupt the assumed accounting in
> various ways.
> 
> To fix this, the mm should be kept, as you did above. All the code
> that is touching the task to get the mm should be dropped. The only
> purpose of the task is to check the rlimit.

Yes.  While developing my "redo" series I tried it that way, but did not post
that version.  Functionally it should be equivalent to this series, but I can
code it again to see if it looks cleaner.

- Steve

> That in of itself should be a single patch with a clear description
> that is the change.
> 
> Beyond that you want a second patch that make the vaddr stuff to
> transfer the pin accounting from one mm to another in the process of
> updating the dma to have a new task and mm.
> 
> There is no "underflow" here, only that the current code is using the
> wrong mm in some case because it gets it through the task.
> 
> Jason
