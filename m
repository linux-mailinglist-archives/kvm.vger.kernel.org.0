Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21ABF64DCEB
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 15:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiLOOeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 09:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiLOOeL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 09:34:11 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9E32E698
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 06:34:04 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFDjUG4031247;
        Thu, 15 Dec 2022 14:33:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=WSrJo9tiCSPV4WgwaldgIy1yzqSpQuvSSBAnXTH3pjE=;
 b=wZXYKWCxuXL1O6mcD5mUutATpXOeEQGLz/2q33jpDgXR1a37TFWKS1VgfFqLunJBj9TW
 AwzcGNC2lEBX3XCdJNdOxex5K2ZRLOITF+cuOi5zRnsQWgcK9G/BpgkiKviDv5VAvrn/
 ug2tOcmuWKaqWHKs0Hq1RHMZ1OQdL9wFmZeRs+TRkvIInPJvpczFQsfn4cvPgA286fsA
 6NZvM9KqFssigrk8IWy19/RJysxCNYsCZzDi/KJbOYcK4R/Z+vDXiOFQgAl8hg34m5Wr
 kqSJAqXZ1uok4zm1xZGcllbkHS2dG6G4bKlg2Q/8/un6Jc+TJNSms8zwWyx711cayYhq mw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyeww6ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 14:33:38 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BFD6gGe011094;
        Thu, 15 Dec 2022 14:33:36 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyevt54d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 14:33:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fm3v23V0jEcbVNlRHMs3RdWVUPScnJWk0UEMw6kTDdcL5wXgVxDXiMlVA0wykEL/doJo7Mc52xJii3g74Un6F0lX9dYFyFxWCrUknjVZj6XkSw+Cb/1PRgvqbUluL9MvGHr1j0AXyNeCAQ3G19rzND0outqSXYDvRffAPp9guUksSKsgIAAwGwJZHYwGFVDMT3W1/0DHXOSJp4JdaHxy3bvdHNyP22xp5qLtft0d89TDzwxRCU3bPQtnWHJHQ62Y9IkEDHy/AW8yphyckI8eqZg0RMpS9s0fChFNogB7exYT1rPL/2CEz0+Ft+8xCo/tqJhCbsa5F3cz5R2UGglHEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WSrJo9tiCSPV4WgwaldgIy1yzqSpQuvSSBAnXTH3pjE=;
 b=YLr7EGeWysSKR3zA7BDGOfk9Zd/LVpXqea3QkZgBcizbfjcyIj8jrmbxUO9/F5bxL4jwCqRPdq/JqmH8kWJtMpiXBhH1l/H7SG31XekCj+3d3OKegtW00Gsoox3gKLecbEa1NcSUCTCVWSTbbJN4jzrigzvFzer8XYcYz4ZRzvWwDgEtWXRmwJGX38MQsEa+1JLvQaX7x3VZVdNupBUrwGm/x4kXOFXAqtAghsEZzK+DU3h5AaTUXmLt89EOrkBy3YwBGfEQpPuIRj3mh1Ri59BEGbMtK8bkT19KLV9rLqjmX2mocMrz2f3YghsFNNeWkTXCcg8qoUrQ98qapoUafw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WSrJo9tiCSPV4WgwaldgIy1yzqSpQuvSSBAnXTH3pjE=;
 b=aiJXYTL0ShAy/S6xyd7mFYRsNL7sqZ6IHkN9o0v7XeJSRHDeafHbwvzi+5K99Jo/dBVUNDVnvYHZfHv7TReuwBrVlhD5N9zq0GUE6XjPi9yC7Ck4LVeach6rmEfjlw9a5a8+6ogHdqqkXfmN8nhsDAYLwFffANnedUu11q5SV9Y=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by PH8PR10MB6600.namprd10.prod.outlook.com (2603:10b6:510:223::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 14:33:34 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca%7]) with mapi id 15.20.5924.012; Thu, 15 Dec 2022
 14:33:34 +0000
Message-ID: <ab437361-50e7-fcf6-3281-9f8c120b6172@oracle.com>
Date:   Thu, 15 Dec 2022 09:33:32 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V4 2/5] vfio/type1: prevent locked_vm underflow
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <1671053097-138498-1-git-send-email-steven.sistare@oracle.com>
 <1671053097-138498-3-git-send-email-steven.sistare@oracle.com>
 <BN9PR11MB5276AAB95CB64CB1B48123288CE19@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <BN9PR11MB5276AAB95CB64CB1B48123288CE19@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0049.namprd11.prod.outlook.com
 (2603:10b6:806:d0::24) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|PH8PR10MB6600:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b68cee1-1507-4a90-b1d2-08dadea9586a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SG9MV2jurkcB3MbE4XjSF1JpIdvsZxH6ALccK8Gxfx3z/H6iekkaWXSTg8+Es0qpGSLt1DMSovzn+FZXizZulbbtPOLgv7YChgSQbBeElEPbo57O5LHSKcDmmrZlixmmUiwvdpqluAvZI+Ychsl7FD0IWqDUF7ibW7eHpH3qc8SuntgP8RdjPrvbelMBU/qmKeF1iG77Bo46Ztc5Mf0O8a+rJJ0n0BHeI9xB4JKhJJ1GutTi30ILHut2jFGUn2qLql2Rrx3lhqfYruTNDf01cwsil+vzFXp5KSq+M+Ybr5wl3i2HsHX1cSXOn2hpOZVIAdI3DunaGKKDba/ZKWiHxmrjN+7PztExykhIa0SNnU8S66sJOFh9LP2/u+TU94VXxPEK8B801+tzexjKyDNt5WLypuMbwSpwypiZf0+XmGpA5G0eGk0QQHCiJvxQtyCJr/etpI2OZM9gH6bv3w1rqeGI/yyfPkgqMaSi7nHk+WpYYgKvpk60ghq0VdareXYNeq4sHUvUWV7zuRzkfj4sTUuh5scS9qE5tihDkWuakR0QoMyXhSHHTaIbuIm7Hz8+GYmwD9e2ep3J2+BNag08pgqT3KVIK6lOREBVs6ULq3GRPyxqidxPZU77+dKrqWSoBmUwsCtMFgTyXM7UepoNc0byWaX5vArs39k9RcYUw5F0KM/wjkCqxBLv0ZVzyAJWjXEwZthRACajpxNqOdcE6Skow2g4r2uGdOYTzuHFgJI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199015)(36916002)(6506007)(2906002)(2616005)(38100700002)(31686004)(478600001)(6486002)(5660300002)(8676002)(53546011)(66946007)(66556008)(6512007)(66476007)(54906003)(26005)(186003)(41300700001)(8936002)(110136005)(36756003)(83380400001)(44832011)(4326008)(31696002)(316002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVRuQi9YdXZwdVovSWp0Vk5ER3dzcW1JZkRxNE92ZXl2RUJMTlhqNXpZRFM3?=
 =?utf-8?B?aUhHcXZYaFVYbk0rK0NWbWpPaGMrK3Nlclp5NEEyenNNUE5uM0pWNHdxNzN4?=
 =?utf-8?B?ejRJV1hWSXpxNkRUNk9iR0o5dGVqWVVud2FOTzRSamZZQ09Pay9Td0RxR21C?=
 =?utf-8?B?MUpZbmc3SzhqNWw1K2VZRjI0bjVPeC9va2owWFNqL0ROTjlpWXo0UnhtWUZx?=
 =?utf-8?B?M0grd0xnbkZtOERBc0prV0xHaThBaFRZVHY4dFU5NXNmckV5V0tocmZRamxt?=
 =?utf-8?B?dGlNRFh2VCtDQVltZ09IdjdTYi92MWE3Y2ZzVHh2MGwwOVhXMitFNjhJUWlH?=
 =?utf-8?B?WlNUVXJUbERoMmhEMjk5VlJWTmZHbWQ4aWNxM2xEdFowZ2YzZ3lmZzkxdjVa?=
 =?utf-8?B?aTR3b3BobEtGSnc3a05DUWpzUTZpeGVlV0xlcFBRclgrQ0pwMW16ODgxNTB2?=
 =?utf-8?B?a1JTTFRVbVlmai9nN2labGtJc3FXTEtxbHhuY1k3MWhaTnlkaUdTV0hFRXVQ?=
 =?utf-8?B?WlMydE1GU212aFFhNVY4ZTg4K3huWE41MExWMjZNU3grK1dMcGNVNXh6OHRH?=
 =?utf-8?B?R3lTbXE5bU5aMVlNUVJxbEFqQmkycGlyQkdlTU5zWml3YlZycDNWQ2VoMDVx?=
 =?utf-8?B?TmY1d0JaRlR1b282RXFDVE1jc2ZzcmdNSlV3YzRhbEUxdDNFQ29ZT0tVNXBn?=
 =?utf-8?B?ZnAydDVHblN3MDlYeWZlOHpMdC92bHNBaVd3Ymc0bU5XZ0xwVnRNS1VxdmZH?=
 =?utf-8?B?VFplMFA1MjVyNkdjSUZRZlBkVjJocHlzSWhlMGUxK243WmhsbHEyMzBHcm83?=
 =?utf-8?B?VkNscEs1TmJVS3JOZ3ZIMDBEMnNuTzFXUVpiazYwcEc4UzhzcG1MK0o3Rith?=
 =?utf-8?B?b29NU0dwWDAyTGhRUVM1M05EWVhZajAramQxMVVsVDRhUnlhMHVoNDd4alcv?=
 =?utf-8?B?YnlFaVJmTUpST2k4SXlRWGdwbWJyenV5UXJkZkdYS0VSTjlTMmtOR2t2RmZP?=
 =?utf-8?B?TTQxRXFKdzNMaEx0WWlqN2dtK1NpTmhibFpoU1FYeitibnJacytOZkVmV09h?=
 =?utf-8?B?VVFyOXUycGY2VWpqcnhLRXRMRk5EbzRZN3pQd3g5dHk2bkZXc2hPQ1N6MG9s?=
 =?utf-8?B?Sm92RVBsbXc4Nlc0NUdxd0p2Q2VzK0dKR0tpTCtCVWYwNE5WUmZ6djA0SmtF?=
 =?utf-8?B?VzZma2F4TzNKNXBjNlJXQVpTNEhIK1BqaDNscGtzY284RHpNd2FWTmNLRllj?=
 =?utf-8?B?S0VQdEhJcmNkTXA5Vzd5Zko5MGU3TjNyNlJvYmcrQmNzSldDQzEwNk1BRWNa?=
 =?utf-8?B?OVFKYktnVkJRVVBUOHFmNHRnQ3B5V2k1RHQ5U0x6YndqbDRpZ1FFMC90RFYz?=
 =?utf-8?B?b2FINGREbHFpUUY0d2t6dHoyMzV2SUViWUMzb3JKaEw5dkFVTmtzb3gzT3pC?=
 =?utf-8?B?NndYbERZT1ZkeGdXNjBEM1RvQmF3Uytwc0M0R1JMVGRnUFUzLy90c1NibkpH?=
 =?utf-8?B?d3NBSXZMUFVBY2txYTVGMkRKTEdQNXlDZHFIWVM3SkNFam9zbmZyaGliY3dL?=
 =?utf-8?B?V0wwQVdUU0pudm8wa3FCTldXRzEzNWNtTWRhUnQ3Tk9jOTlyYWRuZmFqQS9p?=
 =?utf-8?B?d2M0a3pnZi93eUpzcFlSUUtjOWZQVDUrR0svcGFQemJBdWs4QzZlU2dRdE1j?=
 =?utf-8?B?c3dpMDFFWWMycVZ2cnNOanQ0RmlTNGwxalFjSjBSQjQ1dHRjKzJVaE5jc1h1?=
 =?utf-8?B?Q1hwT3dvcVhuUWJOSnEweHFhcXhSZ0p5Mm91RlVWa20xVmdubG90aGdGeTF1?=
 =?utf-8?B?eERlQmRKdHdhZ3daQklWM3VSZkVseE12ajRCQ3pvUER1MllEcDBwck91NjlP?=
 =?utf-8?B?RkZtb0l4dzByMUp4ajU0bFd1UnhmZ3V5S2I4WEYreGtSOTlsK0hpdjFxZk42?=
 =?utf-8?B?V0hJTmlTWE9KMC9XamdwQTJCa2VOMHlHam1TU0x3akdXUmF3ZkVhVDdkdGJ5?=
 =?utf-8?B?SXc5Q0tWRmpJZktwSjVsZmZMNlZYVFlmaEUvRGJVTzQxdjkvYUhqdzczdkZW?=
 =?utf-8?B?N21WSytNTHZwdm1Cb25tcThYUjhDYzVSRzFQdUwzNUtqNnR3SkFwYnlzYnNX?=
 =?utf-8?B?aXhjU3NpMnRtZ0lOMThIS2FQcUVUVmtXd3E5ODNjUm5VL0Y0QXlYdEl4ODhY?=
 =?utf-8?B?YkE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b68cee1-1507-4a90-b1d2-08dadea9586a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 14:33:34.2447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1MTDq/iWibaLEZEdFgZaMoL2owPPIbKky4ZfQDtp4DGHZgMP+iUInBhdN/0ak4zngfItmRc4hWhBsZZ2ehi2WZ9lgwoXbl6C92niVVMHXAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6600
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_08,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150118
X-Proofpoint-ORIG-GUID: 0AWJYaaO8jFD0QGr5T4SwTO6jSeje0WB
X-Proofpoint-GUID: 0AWJYaaO8jFD0QGr5T4SwTO6jSeje0WB
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/2022 11:52 PM, Tian, Kevin wrote:
>> From: Steve Sistare <steven.sistare@oracle.com>
>> Sent: Thursday, December 15, 2022 5:25 AM
>>
>> When a vfio container is preserved across exec using the
>> VFIO_UPDATE_VADDR
>> interfaces, locked_vm of the new mm becomes 0.  If the user later unmaps a
>> dma mapping, locked_vm underflows to a large unsigned value, and a
>> subsequent dma map request fails with ENOMEM in __account_locked_vm.
> 
> Isn't it the problem more than underflow? w/o copying locked_vm to the
> new mm it means rlimit of the new mm could be exceeded since only
> newly pinned pages after exec are counted.

Yes.  I focused on underflow, because that will even cause an app that has
no limit to fail, but I will add rlimit to the commit message.

>> @@ -424,6 +425,10 @@ static int vfio_lock_acct(struct vfio_dma *dma, long
>> npage, bool async)
>>  	if (!mm)
>>  		return -ESRCH; /* process exited */
>>
>> +	/* Avoid locked_vm underflow */
>> +	if (dma->mm != mm && npage < 0)
>> +		goto out;
>> +
> 
> the comment is unclear why the condition will lead to underflow.
> 
> It's also unclear why the guard is only for exec case but not fork-exec.
> According to this patch locked_vm was not copied to the new mm in
> both cases before this fix. 

Correct.

> Then why would underflow only happen
> in one but not in the other?

Underflow does not occur for fork-exec.  I was wrong when I said so in email.

For fork-exec, if the original process has exited, then we return ESRCH.
If the original process is alive, then dma->mm == mm, and we proceed to 
decrement its locked_vm.

> Anyway more explanation is appreciated here.

How about:
   /* If task exec'd, the old mm is dead.  Avoid locked_mm underflow. */

>> +static int vfio_change_dma_owner(struct vfio_dma *dma)
>> +{
>> +	int ret = 0;
>> +	struct mm_struct *mm = get_task_mm(dma->task);
> 
> should this be current->group_leader? otherwise in fork-exec case
> dma->mm is still equal to dma->task->mm.

Thanks, that is a bug.  The code works if the original process exited, but
not if it persists.  The test should be:

        if (dma->mm != mm || new_task != dma->task) {

>> +
>> +	if (dma->mm != mm) {
>> +		long npage = dma->size >> PAGE_SHIFT;
>> +		bool new_lock_cap = capable(CAP_IPC_LOCK);
>> +		struct task_struct *new_task = current->group_leader;
>> +
>> +		ret = mmap_write_lock_killable(new_task->mm);
>> +		if (ret)
>> +			goto out;
>> +
>> +		ret = __account_locked_vm(new_task->mm, npage, true,
>> +					  new_task, new_lock_cap);
>> +		mmap_write_unlock(new_task->mm);
>> +		if (ret)
>> +			goto out;
>> +
>> +		if (dma->task != new_task) {
>> +			vfio_lock_acct(dma, -npage, 0);
> 
> Presumably this should be always done on the old mm, even in exec case.

No, for exec, the old mm is a zombie.  

- Steve
