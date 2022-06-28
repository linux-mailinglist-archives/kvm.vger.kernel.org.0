Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6C255E700
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 18:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346261AbiF1Ny2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 09:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245534AbiF1Ny1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 09:54:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CFD1D326;
        Tue, 28 Jun 2022 06:54:26 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SBLvB6024227;
        Tue, 28 Jun 2022 13:54:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=k/7RgisgStEMFzdu3tuuzp0wc6aRaOhsr60PlETMkIw=;
 b=FLFn4VIxaP3St1LLoa3vEHnr0AIt8iYWvm0MCPVWLlvmsObRd7jZ1mAg6zV14iqeiqkr
 2Lpr+haD6Vh1QYdwOu9qqwDDwsgz4easmJ4qk6RpUWWvhk3rHcYjYch9Kgq0oHlZ9ilK
 8jrzZjXbHRpwvH12tW/SFIWyL+VSFUaRJ/8B3OR7R/9yowIyWWEq+K5J1sjk6B0OnuF9
 MVuDxDyGRGlPkfkwGctm3idD8ZEfTWTCriXeA/ua02WUDHkabWtdPQvHTUcUBsmXoonP
 koaFmPIT79B1aeGistqKrYtQH6InB0EKY6QjJNAIqmm7EGwNOJOseTm4SPprcaVtYUmS SQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwsyse3uj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 13:54:23 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25SDp3il004885;
        Tue, 28 Jun 2022 13:54:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt7yhuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 13:54:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N4aOF7pHr+eabRlJc2tqjX+GyKrDRi1f1C2p4qNuhmEwP/tdv6NZcbgQWStGtWqYwRnVYuddmVtSr77dywj47qhrF+eJ8mOEoQ3L5cxZOYNrU+YXA33UY8iGi/WeMnvIOJVzAlMzzMSUGBfbEhmLcya0DSrn+gnJw0KfcORTFl19q3gQfq+vtyPoIvwZtrWQHdy9yd0cuNXgeusZJh8VNNydgF+Qbwol0jPqEy/U5Bcts1RpQgZEjpy6gG+gzkPKtQR9nYDSDQO+YQqgWSoM7ViOXjeQODr4X0V+v6h9UNtgNZimhz9FeAiSZp6ZaDnrJPhsqk1cT6yM/9YGloP6Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k/7RgisgStEMFzdu3tuuzp0wc6aRaOhsr60PlETMkIw=;
 b=jpNzIfawNVrEMwhzcxDl89dfW+lmqYI2c6mv5Sy0lBESPGeLXbaYNbqo+zkcMgcfHsscme60SQ1T1D2AGJEOec6hgwauk70QboN3NbQ0Qh6EX7sL9eetzPhe9en5JZQYQFBhriRBwcBu+VGwhimNE0f0oAxlPdGfI9NkNeaBkSv5uFn3tjfvgRwCoJ6ii6I8PnvHG2/sgv7XK9/Xel3+s8Ymz13sXAMKGlnlxXIdgzJ0Q8HR2ReRf2OlD1mQp+NC7bTgcDJNROaE37eO3XcdpBOn8UtEavVirZR7oROobAs7D31jBLEpholpmWsqpzGpzKfI8O1Syjg+3BR7UYsXQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k/7RgisgStEMFzdu3tuuzp0wc6aRaOhsr60PlETMkIw=;
 b=M1yQDnhGeJW4f7DvSyD1q7WMlm4J3ELb9frbvtmpriuciG7IZn13LCE+Hz4nJaxESjjStVwzMF0Nz7wgb5wIgbPeFdstNk3hm7ym5BroKbwBFbqos+IcVfRs/A2Fd8E36/ZGQIec5EN+jcQNiF0Y7EAgBLc1hc5AyHwqTXZj/KQ=
Received: from BYAPR10MB3240.namprd10.prod.outlook.com (2603:10b6:a03:155::17)
 by DM6PR10MB3899.namprd10.prod.outlook.com (2603:10b6:5:1fb::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 13:54:21 +0000
Received: from BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::dc4d:56f4:a55b:4e9]) by BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::dc4d:56f4:a55b:4e9%6]) with mapi id 15.20.5395.014; Tue, 28 Jun 2022
 13:54:21 +0000
Message-ID: <f7b7a7b0-9404-6b0f-99b5-346af041a479@oracle.com>
Date:   Tue, 28 Jun 2022 09:54:19 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] vfio: remove useless judgement
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        lizhe.67@bytedance.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, lizefan.x@bytedance.com
References: <20220627035109.73745-1-lizhe.67@bytedance.com>
 <20220627160640.7edca0dd.alex.williamson@redhat.com>
 <7217566f-9c40-ae9d-6fd6-2ef93f13f853@oracle.com>
 <20220628130350.GN23621@ziepe.ca>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20220628130350.GN23621@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0066.namprd08.prod.outlook.com
 (2603:10b6:a03:117::43) To BYAPR10MB3240.namprd10.prod.outlook.com
 (2603:10b6:a03:155::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae1630ea-c2b5-4aa0-5da1-08da590db39d
X-MS-TrafficTypeDiagnostic: DM6PR10MB3899:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /PQxLpxy9BlOvhTHfsJCmKdccHYZSxbGD983he6L2gEq1ntmBaoVjoGrvK6v8xEiidysBCA3yP0gqQXCcW3o6n4VioWrMsbqRQYrdvgCmd9l1mCJkLUzHeRgmekFNhNB4sl4b95ULKVzOFE1DFk+ssihicP4JXkoOKutqBU3GbbKXwvAO5+qLkNAT00CBr5fjinpLsarmHVGbWN4DVSMLzhoDOgcAu2/2yYmH02mfpsB71L6mbDn/5nayQQU3TJh2ovqZyAzKMKUdUyTN4YWJhXo+nqlPPlrTFUOAoAzc8EPUD05EWaVIeXSo32KjB5tHqH4aXNXknZi4fJFkxSYGE3lZ0M/uJXmMt2MxgycG9F9ewCK5fpS5nJXkhfVb/EjPDL8/et9BOk1M4P4YR7F7au5PAow5j39FVttu6q1cW3iI5Cm3JUO0FfzyludKhRPEkPsBf/rECHJjX/oWVoO2gPJV/xcIg3N5T1i7KRgmw/x+netsxNcdPza2UtN1Vdm1iI6tJa1UFxJvhEdzN0EswqWzOyLxxu0LALYA7GZuWhh04CxWf3HmHxbVk8m5AZRpHj41p2ii5GgaVk+ySfG1sMWi+afsw9YvFKaOQ79XaTX4hIwmEUbrMC3OX8e3Bw8czzweETEcIOZQrs2EgC/6YrSuakyave0zcYn47KHI+TMC4/A59uG/DXZtboP3tDV/Kc10DVyaM7VvrLkj2bUSjIHuvFwYv54gaPkrqJ+RLbpHpEEtxGgQ1F6ajJ5HU6gyugn5NWfqYsErhF5tHV5yLPsf9pFPgPGN32Na92XvdMNsXCCPb+8rS3GQU8nqbI9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(39860400002)(346002)(136003)(366004)(44832011)(5660300002)(36756003)(8676002)(316002)(66946007)(6916009)(8936002)(31686004)(2906002)(186003)(86362001)(6506007)(4326008)(66556008)(478600001)(6486002)(6512007)(41300700001)(83380400001)(26005)(53546011)(2616005)(38100700002)(66476007)(31696002)(36916002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cEViUDc4SGhvK0IwdEVZY2M2c0lINU1acHF0R1pZQzB2U2pUa1JDYzh0blA4?=
 =?utf-8?B?MGFjUVdBcGg2YWZWd3MzVThGZldaSVRHWHpxSmdPOHFVSUZLTk5paDF1UDhz?=
 =?utf-8?B?clVyWDRiNnJyNDVxUHF0VTNweEM3Q0l4WkZQN0Jva3pLL2k3OTltbVd5YTVm?=
 =?utf-8?B?OWMwRjhQQlBja1R0a0lzWTVVR1FTNHNnSDcxckdUcXlZOTYwalgyRjJCNGgz?=
 =?utf-8?B?b05wK04vL3FVN0VUaEZydkpGMCsrR2FOZ01WMDg2V2IrcDVhZE5BRzlxeU15?=
 =?utf-8?B?NytMQ3FyU1l3Yzc4VWhCZS9aVkc0c0lpZjB0VWpOeDN6TDJnSjhBU0o2aldi?=
 =?utf-8?B?VmVpOEc1TFJqcnNKUE9peTdWbGpjOVJuQU9jenNJSDhvSW9KMGNSMStUQUZQ?=
 =?utf-8?B?RFgyR0JURERReklFL2svVS9sOTlIRWtFdlh0ZFBRYVJCM3pMdGc3RnlYSThH?=
 =?utf-8?B?ZnJicEtCS0FTREZoc0s1bXdCOFF5RVV1RFZ0OWNKRUx0Si9nT0U2MnlHcEI5?=
 =?utf-8?B?cWFQVElGcUhLQXFaVWh2Yll6UGgzdGplZ0JsVjV1RDBuMUZ1Z2luOWFGb0Na?=
 =?utf-8?B?RDBmaWgvaE5oZmFEL2R3S1k3M2IzQ1VzUFdlSXFpbCtYMk11WDNYcFB2VS9a?=
 =?utf-8?B?czFtaWdHR0c3cHlUeUNwbVJ4aHkvWUFHQkswb0FwVkZjRkJybFNvb1JHcVlU?=
 =?utf-8?B?YjRFT055KzNRZ0F5S0Z6SjNMNnpKL2RYVkNiSUVRZkxKKzR2MkpCVm9lNE5m?=
 =?utf-8?B?ZHNzWXdDZ3dnTnl2RUhoWUs3RWZsR0pYSFFYRGFYMVNDMmpyQk1FWkVNcGkv?=
 =?utf-8?B?eDJFRWxGOTloelI2UWJ5OWkrWlkzamM4bUN3bndGTzVISGRxZDEvRkJzbVRV?=
 =?utf-8?B?Sk0weUsyaFFjWk5jM2hwU0JqR1JzcERqMkJ1ZXJrUVByWlYzYVlvWjZYTWVr?=
 =?utf-8?B?OE40OWoySyt5WTBlc3VBaVV5UUUvOWlHUGZDZ3FGVGVDSUJRVUxrb0htdGVz?=
 =?utf-8?B?WFEwUjNBcWYzNk1ZRkdRejhtNGUvdzlXYjVjTXFxTnBWR2IwZ0tkR0RpWjF0?=
 =?utf-8?B?cW9tYUQ2WEppWUZ4VU9NWFNFcm9DUTVOa2xsWFYzSndPc2hkUUdsSkgzLzFT?=
 =?utf-8?B?U0RLY1hUdkxrYjVTVjJXODQ5Sm9zNmRCb0VBSnRqWGpnOUZ3UkxaQW81ZDlt?=
 =?utf-8?B?Z1h2dnR6Tlg2aHEyQXYvelpYOEEyLy9IWTA5L2hsenJIeGprZ1Z5dEdhWnh1?=
 =?utf-8?B?TldWS2lwQkgwdnYzWU9VQUN2NUVpSXRFUVNCSHlEVUpyMFlEVlRCRDZWY2NE?=
 =?utf-8?B?citOK2p5NUFhc054U2c2RzFCOFhuOGQ5VmFwaEQ4S2I5UVdDWWlOMXk3L0Fm?=
 =?utf-8?B?S2k2ZU1oMVN0NzM2T3cvL3IweFVDaHBRQ043dUZiZXhsZHFwTW1Ca3VZaDhl?=
 =?utf-8?B?Rm1HSDA5ZTBUL1RrQmYyQWZjWndQbmViRWYxSWRoTC82dTVIaWNnaVBPSi9h?=
 =?utf-8?B?ZDByYTl4dTFYUzJ5RVlWQ0Vvb2NQSWdjV3k5bkFCQWFaSk5zYmZrNWNaL2R1?=
 =?utf-8?B?SVFrcm9IZlhvYjNPRUpzNkNUaE9iNjNRaGczaGovR01TNXdOeEVTQUZURUhR?=
 =?utf-8?B?ektUMkFyUDJaYjRoaTB3a3lLUmRMdXBzUGZXM1lKMFdCSVE1ZXRic1BnUFBQ?=
 =?utf-8?B?YkYwS3hlb3BvVjB1dWppVTVuNXFvaXMvczA4Tit6TlNUYW1sTCt5aERNMkJH?=
 =?utf-8?B?emhZejc1VUdmTnhtL3lqajNxNmxDOGRSdllBcUhiZGJvVTdxbU02NjhuSVdE?=
 =?utf-8?B?eFpCbWhJNkVLNllMVm0xNnBkMEN6SUE5emNnMkh3OVdTTG1mRjFvUXlTS0NQ?=
 =?utf-8?B?K1Y4UFNhN0RqYXpXTnN1WFJaQ0g5WkJ6RlJ1b1FQekQzcHI0c1JWQ2V3WFk4?=
 =?utf-8?B?VVpGUnMxbDBqS1JkZFc0YW1qdSs4dGdJWk1UL2tVZGZjZ2JuRTNJQ0JGbENk?=
 =?utf-8?B?Z0gwRTdnOEZuTEx2Vms2LzZYVi9FdU4vengzdmVJaXhOSmU4Z1NySzlET2h4?=
 =?utf-8?B?Rmo1K2ErR2JTUnZYdnZCOHV6RVI5REMzWG5qUDlnczlucVpuNndiL0ZkQUdX?=
 =?utf-8?B?NU0reFg1cVBrNzM4R3g3MHdxQWl5YUpkTjBOTmpIeFVjY1lGdGtlamJqTjZu?=
 =?utf-8?B?Umc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae1630ea-c2b5-4aa0-5da1-08da590db39d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 13:54:21.1103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jp1+0No0pkZhXkDrwy0ZYjx7IAA1G4PU5/eUmiOnTdUg8CRXCRmungLxpsj3t1PD1hiZrcrOvsWhypALeF4EgD/JGudPViTC9/jpW1u4Sq8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3899
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-28_07:2022-06-28,2022-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280058
X-Proofpoint-ORIG-GUID: cXt51qLKrjjMjCIw3GSZPi2XmHhXP3YA
X-Proofpoint-GUID: cXt51qLKrjjMjCIw3GSZPi2XmHhXP3YA
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/28/2022 9:03 AM, Jason Gunthorpe wrote:
> On Tue, Jun 28, 2022 at 08:48:11AM -0400, Steven Sistare wrote:
>> For cpr, old qemu directly exec's new qemu, so task does not change.
>>
>> To support fork+exec, the ownership test needs to be deleted or modified.
>>
>> Pinned page accounting is another issue, as the parent counts pins in its
>> mm->locked_vm.  If the child unmaps, it cannot simply decrement its own
>> mm->locked_vm counter.
> 
> It is fine already:
> 
> 	mm = async ? get_task_mm(dma->task) : dma->task->mm;
> 	if (!mm)
> 		return -ESRCH; /* process exited */
> 
> 	ret = mmap_write_lock_killable(mm);
> 	if (!ret) {
> 		ret = __account_locked_vm(mm, abs(npage), npage > 0, dma->task,
> 					  dma->lock_cap);
> 
> Each 'dma' already stores a pointer to the mm that sourced it and only
> manipulates the counter in that mm. AFAICT 'current' is not used
> during unmap.
Ah yes, no problem then.
Limits become looser, though, as the child can pin an additional RLIMIT_MEMLOCK
of pages.  That is the natural consequence of mm->locked_vm being a per process limit, 
but probably not what the application wants.  Another argument for switching to 
user->locked_vm.

>> As you and I have discussed, the count is also wrong in the direct
>> exec model, because exec clears mm->locked_vm.
> 
> Really? Yikes, I thought exec would generate a new mm?

Yes, exec creates a new mm with locked_vm = 0.  The old locked_vm count is dropped
on the floor.  The existing dma points to the same task, but task->mm has changed,
and dma->task->mm->locked_vm is 0.  An unmap ioctl drives it negative.

I have prototyped a few possible fixes.  One changes vfio to use user->locked_vm.
Another changes to mm->pinned_vm and preserves it during exec.  A third preserves
mm->locked_vm across exec, but that is not practical, because mm->locked_vm mixes
vfio pins and mlocks.  The mlock component must be cleared during exec, and we don't 
have a separate count for it.

>> I am thinking vfio could count pins in struct user locked_vm to handle both 
>> models.  The user struct and its count would persist across direct exec,
>> and be shared by parent and child for fork+exec.  However, that does change
>> the RLIMIT_MEMLOCK value that applications must set, because the limit must
>> accommodate vfio plus other sub-systems that count in user->locked_vm, which
>> includes io_uring, skbuff, xdp, and perf.  Plus, the limit must accommodate all
>> processes of that user, not just a single process.
> 
> We discussed this, for iommufd we are currently planning to go this
> way and will See How it Goes.

Yes, I have followed that thread with interest.

- Steve
