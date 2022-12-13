Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C9164BA65
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 17:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbiLMQ4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 11:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236292AbiLMQzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 11:55:49 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24EB62315A
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 08:54:42 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDGE105013777;
        Tue, 13 Dec 2022 16:54:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ebUuBCAuiZJNq87D8yV7Am1JXtorQ101P+ufzG3QH+4=;
 b=dHtQ7DuV69+E/nVhLZBxX77v81fcffi1qwl4Gw9DNEH+m0gNksx5JpT83EsEnK2RFAQZ
 8kUepJAuPrmJp48IIRQPfTi8DdmEVpWyHXvBWOOwjLAdLXOn5oHtmMg5M0vqYjq+QR5U
 8lz2MRdhzTs6OEpyR+ZvOGrCXxJQwdu+RJfIU71xifdyX7dl8iYvbvca0MCXjq1asH2R
 hUkmKoqp0T1lykDgDYzN1BQkNt0/ZrG5LBFb6YUalRgZD8VJRR4cqu+omJ13OV8EA+67
 /LPz+YB9mE0yJQQJImjkw+LXzomll4/8DgCQX9Cfa3U9WEa+5wFg9QITgj1SkPVyFnDd 1w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mcj5bwx60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 16:54:38 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDGZDHB032751;
        Tue, 13 Dec 2022 16:54:38 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgjcc3bp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 16:54:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIwC11v8wzkg7Qu5VSigi9+pRKgi/wGKT1kh22rg2vknHEKIWBTQDAYmZi4nE5FwM4zoBpGVBUGwAebRKyjrWsT+TKwhEf+bAzukz90q4sonayodOAz1CYFt5BhVdKdScRJeFJgVF5czRBmuCvkWcK5i+DsHPDPobkiJP32542QqBMhQHmKkF/xsW6O6WaEA15rrW5oF7aIeEXRwp9YP0ck7NVnHLMnlr7r4zgoXNrJU6fKMZeDizomF92Wj52P4wKqdBA/v50bSSFJz7eSf2Fg3fc12URZHmLeqjB35Yp/jq5O818FeNEvYkHvbWqadx0fejFodUF0Bzm8kirjarQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ebUuBCAuiZJNq87D8yV7Am1JXtorQ101P+ufzG3QH+4=;
 b=mYF4pReCUSv+bmG4ixEo714evoRQc5fFYPHYtH5burOz70sn0+dq+caLAvDZZIs3h6dmns+fWyxZIMGt6fqADQmXRZaFOD1pPjike8s/3hteirRxqMEu5H1lfjR9RkyphOdcksu7q9HRpb5ZU9m8jVLjAZl21vkfn3Clx41JEAnIWNxmSlgTnxpqsND5UkAMuS3C9vMm202o8MPEkhTN4YqpAVnsnLqXJAujJTvsW2bTDWNMtg7rk6KpTo2ox77HxOwF8K7igXEyFbecuwTC3O+yUfhAMF2dmkRybWETweHiYKHnxnf8yZB7QwEX+Na8myRMT3a7HBozg7QF/jF9yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ebUuBCAuiZJNq87D8yV7Am1JXtorQ101P+ufzG3QH+4=;
 b=KEI+Dv+BTIPEvfyXdG+OV+PMtuFRjx7tBA7qHwDhuB46LnkkXdUATiLJzy4Sk+P1aeAOYaajPxBpo6iGWqH2Ve45aOb66ehGHCedHqHA38pZN01rl61YLtQQOY6ys9Rkf89oZyWByhrfFhgljPR+ktjOJ+V5K09QIZi50V375jY=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by SN4PR10MB5606.namprd10.prod.outlook.com (2603:10b6:806:209::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 16:54:35 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e%4]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 16:54:35 +0000
Message-ID: <3f3ca4c0-b401-0d18-e911-18189ff9c1d0@oracle.com>
Date:   Tue, 13 Dec 2022 11:54:33 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V1 1/2] vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <1670946416-155307-1-git-send-email-steven.sistare@oracle.com>
 <1670946416-155307-2-git-send-email-steven.sistare@oracle.com>
 <20221213092610.636686fc.alex.williamson@redhat.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221213092610.636686fc.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR07CA0085.namprd07.prod.outlook.com
 (2603:10b6:5:337::18) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|SN4PR10MB5606:EE_
X-MS-Office365-Filtering-Correlation-Id: 8705b9c9-a982-47f2-8b38-08dadd2ab717
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AS4438u76Ysy6N+xctvaOHUpbpsOGytv/bm60unqVU7Af4E8ItrsLGIS1us7IEQfGbdHr+v4lHJQ+80UZ+rymOYvSmuqfm9A2VNwKK3Wcs7q6goxOoA6Tliq5JVyruOo4WuAHCqkkR7Iyo3q1OWbY68S5ub0AOmlLysjYFlPtGxzwFxXeZ/Rd0ApIppKQZvwHklcg25Vl842grs1kuzKfw7nxPoO4ayFcXl/sh8a/NwUiRzNquSYcCQ/tRVFuQIzCE8el1IPrwMWxMEMryEsoO0bApnmiUhPjXFq+qwrZrVOf1FKGbEZQ1ORu20QvwEREFhMV8+/Pp3Eqp/n1hYCvx0GR20pUjs+IHwItglZvEsZZgzBEPhivuOr96bHMNKjRoIO5KyPKSBYyVtpxhNslka4T1JzkZTMH8xhoAbbK5iJw1XwPGx/LPMq6JGbatyTqqgaq6Ra38oaMfSPUshW7Em32qvFgv1EbDXGIrxIPYUq7blsFf7gmG31xQ6g7WUjQPDf4HBgwb9izlBav2WPVZ740cH/qSBEAkCBAsBp+0M8Ttf8EAGNw3E4ZjWuF4a97LPPZpzAVQG8bZCz9t0eBuqpKWYx4mT1OiWB6tdM3j6W4RKgTH93Lzrjumg8ym0WUjtF3hQWx6Arz9aPRxHeKgMblotivrgotr417LEjnPchyLg8yCaStlNGqn0klVU0CdOVKrCGUoiGixUeyiNdrMCYn06w9lgzNtsR2jjAMY0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(366004)(376002)(136003)(346002)(451199015)(38100700002)(86362001)(8936002)(478600001)(31696002)(36916002)(6486002)(66476007)(66946007)(66556008)(6916009)(4326008)(54906003)(316002)(186003)(83380400001)(6506007)(26005)(6512007)(8676002)(2906002)(2616005)(5660300002)(31686004)(41300700001)(53546011)(44832011)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXRCU0NtZ1Nwek45SmhLdHJUdU5IM1llZjFkK0lsaDV0Rm1rRVFjRDNSNGRX?=
 =?utf-8?B?RVZ4N2hiNWNGRFgzK3RjVkJYYWFXSlcvSVUvZHIvd2x2SkxicG0wZ2taZExQ?=
 =?utf-8?B?OFZvWFN2NDZKamxlbER5cTV3dk5uTG9WclhUZk94SkRrVXIyTk9ab1ZINEZ2?=
 =?utf-8?B?K1BsT2RHalNyMnQveGEzUG1SdzMxUWdGK1g0aUJEK0lsWmxFMkxsb3VzT3dp?=
 =?utf-8?B?ZGQzNlBMRXptbHByTWlXNElGSFN3NkkzMzFZUnhES1ArSEUwWFFQS0liLzhl?=
 =?utf-8?B?RVlESjUvaFRKMHFKSGdja2ZJSDJkSHVDZlpudndxdVRVM0ZjUjZIZUNQVjZG?=
 =?utf-8?B?b2xQZWMwSUZDN1NobFJYL2tQeWZ1ZDROdENaeWpRRXhsNWtaZTRKK3kybnQz?=
 =?utf-8?B?UWZhT1kzYUs2WU41L0FUQ3VOT1JlRTRPb3l1K0lhbnRzUHdFSmY3NVp0bkVs?=
 =?utf-8?B?R3Rjc0t4Smdrb3BxUXJQZ3FhSnUvcTJNNmp0ZCtHeEY1WFVEQzRMN0xnU2pJ?=
 =?utf-8?B?U3NkQk9oalBFTnVBRXRXWE5CVHRSTE81WEVkdzZDR1Q0Ulp3VkhYa2VDTHAy?=
 =?utf-8?B?TFBRNUxKNXFXK096OTAyRllrSE80bkxITThBWnU1K2w1ZndId2JTZ2c3UHp3?=
 =?utf-8?B?Wjh6RXJJSmRYWWVnTWJ4RXFMNnhhQWhEMFFUNGVKeXJqV2JRK2VielI4Rml6?=
 =?utf-8?B?SGdTK3gxemZYQlFBSVlmVTNlSjBMSGtOZUp0U3JZNHNRMVBSdUJpYjlMTE5E?=
 =?utf-8?B?SHFFdmhGQUllUTU5UVZEVU5TNGYvaVNtV2FieXhtcERGK21RUEw1Zlh4aDJZ?=
 =?utf-8?B?SkJqNG9MUXZZMWc2YnlZb2pKVVhCeEJuMjgrMzdJWGp2Sm9SVkt2MEZBemow?=
 =?utf-8?B?eFpzaVFmcTJFQnVOTzFSWmdTYzRBZGY3UjJ2d3lRV2FBNklzM2FqU2lXa3Fo?=
 =?utf-8?B?Z1B0MGszUng4ZWt4NlBtYjltZFNERWJyaFhVb1BUQVJqUFJKU3dWdzE0WSsy?=
 =?utf-8?B?a0F0QmpUdStxYjg4anVxZzUrV2F2WGM2RHlYWW16M2RMakRYTkNudk1pUXBu?=
 =?utf-8?B?SVZOK3liSmZNSllUV01UUVYxUTdldUZ1emRONFdXalNvSzNGdm43amdTSmZ6?=
 =?utf-8?B?SHVuMC9YK3VMN1FmeTA4cS9SWG1oTHNWVmpTUzlJV2ZnOU9JRnlTOG55UjRE?=
 =?utf-8?B?RytCL0hGZ1ZGREwxWmxPNTBqeDE4WFZocHVEQnVCRU9obmFjc0pQd3ZaMjgz?=
 =?utf-8?B?Y2ppMUxRMDQ2c1FocUdhaVg3RDdnM2VXWHFQK2kzU0kwdXJrZU9BdndjWU1Y?=
 =?utf-8?B?ZVUwUW9WVGNlVW1ZSUsveXpVMFNmaXQ4cEl3T0Mwbldxd2NjTEZzbDhEc041?=
 =?utf-8?B?VlVCSWlhSlV2R2theWxocldWQkl0TUdGU3UvS2xuRjhTeXVzSGx0UUpDbVRI?=
 =?utf-8?B?aHROemFRWDFNNTUvR085aUtvUnRiV2trZ2RINE56V2lzQjhmUTZuMUJwcGRP?=
 =?utf-8?B?TSswM3FXWi9obExZdHJKRytXTU1JSVY1MnJKOHE1cnRWeXV1bkdZV3dtNjk0?=
 =?utf-8?B?eWg1VUhUVUl0akorSzAvUjVNaWtiTGJjVXRCc3ZPYkpTZ1Yyall0N00vV09r?=
 =?utf-8?B?MWhkU1hQcXVVaUs0Z0l1SncwY2xQWDFaYnR4MHMybExLMXpvSUlTMld2bnQx?=
 =?utf-8?B?MDRzek1DNVJVNEVJM2Nkc0QwdlZOR1gycWNUcjJiNE14Vys3a2pxMzlFazEz?=
 =?utf-8?B?d01COGNkSWZER2dBaThFNjhHQ05WZi9sdHBGNkd3Ukd0RktsQmd3L1pKSnJh?=
 =?utf-8?B?QkRaOHBSbnI4ZnNBNCt6dk1jdDRPc1VFRFU1dHFXZVRmNURmbEV5M2RrTTB0?=
 =?utf-8?B?SGhwV3NkRWJYQ0RMS20rL2FOamhiZmtsbWhndnJEM0J3aTE4bFp0M3pBdHl1?=
 =?utf-8?B?d2xFNWY5YUFYb21MbW80eFB2eE93R043OTJhdFJSUjFweVVsR2xpNVlzVDBj?=
 =?utf-8?B?SzI3TzVxd2ZuMlc0VnJ6NHNDeUF1MG5iVjd5ZFpiSFQ3VzlJODJOc1I0ZGwy?=
 =?utf-8?B?T0xoZXE3Z3RFM29saGlxaSt5RWVRcGVnTEdweW9WbjhqZVIzL3RJUDYzNDFF?=
 =?utf-8?B?MERBb1lSRWZkMyszWkI3ZzZVd0VYTHI3NXVHczF6ampaRWFKcUhUTUhiT2wy?=
 =?utf-8?B?UlE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8705b9c9-a982-47f2-8b38-08dadd2ab717
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 16:54:35.8047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6nXc76lPsvw9ld5ywsD30ZUSNyxgbNM37AEriY18Fn3y4SMg4ko1gsmTwj6IbOciWpjktKwNs57rzYuhiaAVfOQuSnVmqABCx/IQz9HkReI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5606
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212130150
X-Proofpoint-GUID: mhlbV5PWXzlt13tqODwJLDKwHYuLF8yJ
X-Proofpoint-ORIG-GUID: mhlbV5PWXzlt13tqODwJLDKwHYuLF8yJ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/2022 11:26 AM, Alex Williamson wrote:
> On Tue, 13 Dec 2022 07:46:55 -0800
> Steve Sistare <steven.sistare@oracle.com> wrote:
> 
>> Disable the VFIO_UPDATE_VADDR capability if mediated devices are present.
>> Their kernel threads could be blocked indefinitely by a misbehaving
>> userland while trying to pin/unpin pages while vaddrs are being updated.
> 
> Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
> 
>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 25 ++++++++++++++++++++++++-
>>  include/uapi/linux/vfio.h       |  6 +++++-
>>  2 files changed, 29 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 23c24fe..f81e925 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -1343,6 +1343,10 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>  
>>  	mutex_lock(&iommu->lock);
>>  
>> +	/* Cannot update vaddr if mdev is present. */
>> +	if (invalidate_vaddr && !list_empty(&iommu->emulated_iommu_groups))
>> +		goto unlock;
>> +
>>  	pgshift = __ffs(iommu->pgsize_bitmap);
>>  	pgsize = (size_t)1 << pgshift;
>>  
>> @@ -2189,6 +2193,10 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>>  
>>  	mutex_lock(&iommu->lock);
>>  
>> +	/* Prevent an mdev from sneaking in while vaddr flags are used. */
>> +	if (iommu->vaddr_invalid_count && type == VFIO_EMULATED_IOMMU)
>> +		goto out_unlock;
> 
> Why only mdev devices?  If we restrict that the user cannot attach a
> group while there are invalid vaddrs, and the pin/unpin pages and
> dma_rw interfaces are restricted to cases where vaddr_invalid_count is
> zero, then we can get rid of all the code to handle waiting for vaddrs.
> ie. we could still revert:
> 
> 898b9eaeb3fe ("vfio/type1: block on invalid vaddr")
> 487ace134053 ("vfio/type1: implement notify callback")
> ec5e32940cc9 ("vfio: iommu driver notify callback")
> 
> It appears to me it might be easiest to lead with a clean revert of
> these, then follow-up imposing the usage restrictions, and I'd go ahead
> and add WARN_ON error paths to the pin/unpin/dma_rw paths to make sure
> nobody enters those paths with an elevated invalid count.  Thanks,

Will do.  I think I will put the revert at the end, though, as dead code 
clean up.  That patch will be larger, and if it is judged to be too large
for stable, it can be omitted from stable.

- Steve

>> +
>>  	/* Check for duplicates */
>>  	if (vfio_iommu_find_iommu_group(iommu, iommu_group))
>>  		goto out_unlock;
>> @@ -2660,6 +2668,20 @@ static int vfio_domains_have_enforce_cache_coherency(struct vfio_iommu *iommu)
>>  	return ret;
>>  }
>>  
>> +/*
>> + * Disable this feature if mdevs are present.  They cannot safely pin/unpin
>> + * while vaddrs are being updated.
>> + */
>> +static int vfio_iommu_can_update_vaddr(struct vfio_iommu *iommu)
>> +{
>> +	int ret;
>> +
>> +	mutex_lock(&iommu->lock);
>> +	ret = list_empty(&iommu->emulated_iommu_groups);
>> +	mutex_unlock(&iommu->lock);
>> +	return ret;
>> +}
>> +
>>  static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>>  					    unsigned long arg)
>>  {
>> @@ -2668,8 +2690,9 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>>  	case VFIO_TYPE1v2_IOMMU:
>>  	case VFIO_TYPE1_NESTING_IOMMU:
>>  	case VFIO_UNMAP_ALL:
>> -	case VFIO_UPDATE_VADDR:
>>  		return 1;
>> +	case VFIO_UPDATE_VADDR:
>> +		return iommu && vfio_iommu_can_update_vaddr(iommu);
>>  	case VFIO_DMA_CC_IOMMU:
>>  		if (!iommu)
>>  			return 0;
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index d7d8e09..6d36b84 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -49,7 +49,11 @@
>>  /* Supports VFIO_DMA_UNMAP_FLAG_ALL */
>>  #define VFIO_UNMAP_ALL			9
>>  
>> -/* Supports the vaddr flag for DMA map and unmap */
>> +/*
>> + * Supports the vaddr flag for DMA map and unmap.  Not supported for mediated
>> + * devices, so this capability is subject to change as groups are added or
>> + * removed.
>> + */
>>  #define VFIO_UPDATE_VADDR		10
>>  
>>  /*
> 
