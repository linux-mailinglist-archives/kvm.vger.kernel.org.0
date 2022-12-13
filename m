Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1F764BE41
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 22:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236325AbiLMVQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 16:16:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236173AbiLMVQl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 16:16:41 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B532229E
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 13:16:39 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDL2BWv004143;
        Tue, 13 Dec 2022 21:16:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Okw6deXzIaI7bRwCT/KlpXjYBdqNDSCwGGWZqrNIUvk=;
 b=KzImmo9vn7kGaIh1uj6nqKc9VpmrvYlJqsWLd0R1+K2CwjJfJqQ7Gz8yEfYI/PV7S0bg
 LWwhKTnv9kgd4VEAS0c082bjc1B3MDkgBS3PhqpEtu+6uJPeDNQYYy/VbmAzikOJFmU3
 WGAKGw6bGaI5yJWBui8R4NVCLrDPiz8cQLgO/+Ii37xG++DT2eeV4IxVrpTbAN7qE4Qz
 Gy2F29EMcJQlHPKELdgGOUXhZcvIF+FdZJ+OFg8/xRwoBSZav8sNu7k4NOGwe/0TlpzG
 olxZBw+IJVCqzfOw0BFhS1zCq+PYNFBP7Qa353ySqxX8haIRxZ1bneDq7YW7lc/Jn9ss LQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewr957-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 21:16:37 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDJItS7031289;
        Tue, 13 Dec 2022 21:16:36 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyenwfcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 21:16:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SEQ5R8A8HvA2nJevPaFoAkxniUfyrzOFcgO0prbinCLj2UdDppl9+SxsSF6CbrcO6XFoLR1xTg5SyYMGdvSnG7dbRu+Y8iOG4upIlXttVQm2WGHav+lGYytfhhVUzSJB8O7o7MsZS49AkmONkqRGN5zWWT3d/h9XJ0RUYo+n6Fp4xPR5P7XFsBXFphqm0LUcUkOplR7uTuxxKlIvSiGmGGh3Q2AFxvPA5QA4SxePNQrgcj6mKE49bofeBXFZORJYNz1D1+xTsVJLlbNyOppDZwCI+HBg9s5XvIpBjkLt1Q2biC8rBu15IN8IEBSsSFv7jKtgv8ACdz1rEqU1AxSizw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Okw6deXzIaI7bRwCT/KlpXjYBdqNDSCwGGWZqrNIUvk=;
 b=brmxW963p+0tmhgOTV45w5ePvjBZQUbQiQOBTcBRJHhw5ZAs9Jjz9D979wqymVOewJyz3HLUuZAWPcZxJ51/fevNE6HDlRNw77vDPSvobTg4YrZqQ6H/qZ0UQnNpGfh31cmFkCpIst4BrPIN1wBd5AZcsJ1OX08Yb4NJWowCsowcR0xfdJoBq/Ynk3C36hN4Yl0hfJj2bLl14q2wc8WY1idqY/QMDtNp+HV+CE0Km0sarsGJ8/k0GjC38tusSToyFI/jL1qU630G0U9C+8PobRmWuS9p9RiJzsvcX0qLDSP+YvVqgcxjcVVv0GKDr7G/gNXC2aBntMD5Ja6E4LVlIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Okw6deXzIaI7bRwCT/KlpXjYBdqNDSCwGGWZqrNIUvk=;
 b=tMAxbIl7tNQlGXkd315lDv5jfBcHPSTyxr1BNSNPTrK0NPO2ImADEwXmA5uNOCzhdJLTOF92xcMkDohLhDFtdVN9Nlf9KEBRMgAoojdOaC7AVtNPiI9LE9AtEPNjzRQocmItiK3DSE2KmUkfjscV4GuqbxqVT/Akpn6qwqDxuts=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by PH7PR10MB6402.namprd10.prod.outlook.com (2603:10b6:510:1ac::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 21:16:34 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e%4]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 21:16:34 +0000
Message-ID: <7b0fc4e5-8bc5-27dc-10f6-06493abb4ea3@oracle.com>
Date:   Tue, 13 Dec 2022 16:16:31 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V2 1/5] vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
References: <1670960459-415264-1-git-send-email-steven.sistare@oracle.com>
 <1670960459-415264-2-git-send-email-steven.sistare@oracle.com>
 <20221213132245.10ef6873.alex.williamson@redhat.com>
 <16a49fb7-e7bd-f794-9e12-9e88fa5d536c@oracle.com>
 <20221213135907.71f56f8a.alex.williamson@redhat.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221213135907.71f56f8a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0065.namprd02.prod.outlook.com
 (2603:10b6:5:177::42) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|PH7PR10MB6402:EE_
X-MS-Office365-Filtering-Correlation-Id: dbab8db9-d082-49d5-468b-08dadd4f4fdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qxt+wz0uUCJDa4Vy/uIln28JW6ZFQxCFkkbPXMHOmHr68lI2zxcaiEWYLRy6PoouqyL7ukCUJ0AT8/vv7H9J0eJXicIgqjXvI8yH0Xr3tljIOtWe6soqDuIwTJFiakTwWQSgoT6KpyRWY++iG7PrHwfg/ANlhh5NDZ5VPP1Kmg2p89MfrPZABI5pHAxdFXzuFIGhvauYurfNkotIuw3zIWIKPplicdsJawbfQ0Z9JtAxc49CxfWy747LgvxbN2LuWJe6CxArwXErOMf1+0ykOJUBnE7mwdqSnIkcvlxBNPtFhL03RQFnxiQNfakg3fhpoeLcH5B+GFKpC73dCt3kPcGN/42+7DYSs8M6WbuRlXc5ruatUhnu1XUd6eumQnB79MhzEbOsZp088Lz1HWXSNmrmGL0epKKWEg8g7d8H9lGHukubm4GwG8QCn71fKwmh49ML8xbLv4tubj32dEfUdTT8ZtlEpXx4BuJoWhXaW4QKfb4XaDwLTJstdxFUvPomZ/Rq9BWU5OABg13DgrJqQVsxk/hfI/upkVQwQ4jfU1h76I4ZUP46Gte48HQm3ssVCuC3hlk6JfqxtPdjldnurI+bzxVJafupyt5ERY8XkaNVqSr6LdYX0Rnknma3Ue3wG5hLDiSKeNQZU89WxmK834zWoL3i9UhuGocKVBxHQgkUTKNZrCyCxnm6z3Bv4vTsNYF7rREwhckPN2raczBK3NbK/YnN01zu1arSgt/5H1c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(346002)(39860400002)(136003)(396003)(451199015)(38100700002)(86362001)(31686004)(8936002)(6486002)(36916002)(478600001)(31696002)(6666004)(4326008)(66476007)(186003)(66946007)(66556008)(8676002)(6916009)(2906002)(83380400001)(6506007)(6512007)(26005)(316002)(53546011)(44832011)(2616005)(41300700001)(5660300002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXRXZTZLRFp4WVpJdVpNcFdKajQ3eWZaNFZWTjd5emgvTllUY3EzazVneG9W?=
 =?utf-8?B?MVJyV1hnYytDMnFmMi82NXZYcTN5RzRaNFVhK0FjbFpFZWlpRlNaM1lqcFV1?=
 =?utf-8?B?TmYzY2d3SWx4OFJzUWlXbE1SV1VMbHRPQ3I1c2psS09hc1d4RFlzVzg1T2oz?=
 =?utf-8?B?V0Z5OWJiekdmd2x4Rk1GMW1GSE5ad3huY0RWb245KytkOUY1WHR0Y1Z3RVlE?=
 =?utf-8?B?TWlMOTlldFJNQVhMN05JZnpnVzczd1RjWURpVDA0U28wT2lnYm1pNnBHVzFh?=
 =?utf-8?B?V1hxaGViWmpEcjRxUnNjNGxud0JJcmpDVkNGc0Z4NWFjWis3ZWo1L01RdDlJ?=
 =?utf-8?B?MmVISjdKbnowRkViQW4xQXo1SWJnVzAvMW52bVRUckxKbWJHNW01YW1oRTNZ?=
 =?utf-8?B?ZVBrTHFOTWlMdXB4RnZMSlFhTjhUZ1ZrYjkzaFdac24xb29EQjR3RjFvUU5U?=
 =?utf-8?B?SmZpQ2hEci9lTXRTbVBRS0RPa0taVTFoVWJ4eUdRL09tc3UrQWZmcG1DNTZv?=
 =?utf-8?B?TjQ3V1lOWm1BdlpCL0R5eC9tUnVDcmttK2ROR0JNcWdnd0RTVDJXcnUxQ2xz?=
 =?utf-8?B?dElqVWRqZ0FzWlIwa1YzVk16YldyT2ZYY0VnVExEYmZpRi9CMmIzVHpjdGg1?=
 =?utf-8?B?NzVGdXFHRVZmaEpRVjRLUnYwMjVDQ1YxS2xCOHNYVC9TZ0p2Z0lHVHlicnhr?=
 =?utf-8?B?NTdHSXFsdGVkYXVQcnF3MXBFOGNJTmlOV1BrS3Z1bWc0Mkg3Ni9LWmE3dFdK?=
 =?utf-8?B?OUV6eld2OXoxeEd5L2NvKzhSZnJyaVVIMVdmZGNsVi9mL2dxQ0MvdExTbkJz?=
 =?utf-8?B?WjVTNnR1VWlZVkJ4QWo5aTMxaUpvTUtzZ0ZJdDVObkpiLzc4TGFqYW80VDB0?=
 =?utf-8?B?em9KUFZHSEJLSWRkWVh2R0plNXdYNkJqL0JMYWM2NFRPa2lxV2FOZVA4eUh2?=
 =?utf-8?B?NnZlUzB1azNreDZyVFlSUThYYWswUXE0Z2pZWjFhSC82WHJIa1BOUnNQSWJY?=
 =?utf-8?B?YVhLdmJVU1U4bFVVSXNoN3kyekdxVjNudUFSVWFlNExKSGlzWnlyb2hSR0pS?=
 =?utf-8?B?RkxLN0x0cWlyVFJXbGY4N3hQeEZKNC9lSDU0cDVKb0dXY3h5dXV2bjB3K2VZ?=
 =?utf-8?B?ZjI1SjA4cXBJTFcvaVd6d1lKU0VwWGMzVDhzZXlMSi9uSy8vNEQ4Yk1uTXI1?=
 =?utf-8?B?WVE5UWdWb2cyL3Y5SFdnN2w4TlJ2NnJNNXRsc0h6YWZPTWtyci91d3g2a0kz?=
 =?utf-8?B?T0VzU1RELy85WlV3emhtZzB3MXlWOXdlS1NsZVpad2dDcFdyMDhxRkNRWUkr?=
 =?utf-8?B?OEpJZS9yMlJHQzIzV3B5Y2dnN3NPaW9mck91UjRyT29mVTdtNzZjeEQweTlh?=
 =?utf-8?B?Nm5YTU9DUGpXSEFrQjUvQzRrS21oRFNYbDFYU0hZOFdJa1FpQnNIWWVvd2NZ?=
 =?utf-8?B?TG1mSTVHTkFwVFY3dGhQS0RhMlFkMjZJSkJ0NjFzNGF1N0xleEF1U2hXMGpQ?=
 =?utf-8?B?b0xoMVY5MVREcmw1T2pRK016R0IzdDBPUm5FZlZ1aXNOalBqeUt6dTZjM1py?=
 =?utf-8?B?bUdQSzd2Rm44Y1BMNk9DeG52bUhnTDRPLzlDTjVaZjJFU2RjK0YxbWJoejhm?=
 =?utf-8?B?SkpjSkxXV3lQdEJRK3VQaTNhZkw0WldyU3k0SkM5enFpaEVzbUtteWk3eWZx?=
 =?utf-8?B?UEwrR3d5Slc5bExZZVErUDdlMTFOL0lxMlZ6aTRGNk4vbWI4RnhVYW5hRkRq?=
 =?utf-8?B?NlZhQzVrS0I4UDNxTzRBS3Byb1M3dWtTbEZ4M1FDUmFwakExeS95YzJpamM2?=
 =?utf-8?B?eEorYTlsUS9pOW1VZEVtMXFLKzI4ckhUMlhwU0FOVmRlcmt6WFcwQVA0aTZI?=
 =?utf-8?B?R1NBOXJwSkFsYzg5bjRWMEpWTkdZZ0hQVGVDRGQwQStKVER5cmVCNFFNMGpC?=
 =?utf-8?B?bWlHUlpNaTlianFOelU5SThERVlzVVgxSjhxcmlycCtrSk1WZkhhZVJzQ3Rq?=
 =?utf-8?B?eitybk9WR0xzeC9qa0ttMnlVRjNzcVR2d0RLa1FQdGg0amxOKzVnNmszci9M?=
 =?utf-8?B?TW9OMlc1REFTNUNOK1ZqbDZMN3JqeTJlMmxRZnlmeGYzWTJ4NngwQUNZWkMz?=
 =?utf-8?B?bjJiUmpDWlh0c1REQllJQzRqWDgzRFZwTTdVbytKS1VBQkl2UmwvYUJjYXJx?=
 =?utf-8?B?Wmc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbab8db9-d082-49d5-468b-08dadd4f4fdd
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 21:16:33.9496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n86e++Wfn0CnWu/a7C7msDidbus9DjM4rWh9odgQkaMk6Suzf39zs594ubnkOPOKWw9lhospWhqZ1I9YIeeApNpK1nUjykeSnMta6dPzLUM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6402
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212130185
X-Proofpoint-ORIG-GUID: yH8qjnQatltgDhX6JvB3gXJMybNaCqw5
X-Proofpoint-GUID: yH8qjnQatltgDhX6JvB3gXJMybNaCqw5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/2022 3:59 PM, Alex Williamson wrote:
> On Tue, 13 Dec 2022 15:37:45 -0500
> Steven Sistare <steven.sistare@oracle.com> wrote:
> 
>> On 12/13/2022 3:22 PM, Alex Williamson wrote:
>>> On Tue, 13 Dec 2022 11:40:55 -0800
>>> Steve Sistare <steven.sistare@oracle.com> wrote:
>>>   
>>>> Disable the VFIO_UPDATE_VADDR capability if mediated devices are present.
>>>> Their kernel threads could be blocked indefinitely by a misbehaving
>>>> userland while trying to pin/unpin pages while vaddrs are being updated.
>>>>
>>>> Do not allow groups to be added to the container while vaddr's are invalid,
>>>> so we never need to block user threads from pinning, and can delete the
>>>> vaddr-waiting code in a subsequent patch.
>>>>  
>>>
>>>
>>> Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")  
>>
>> will do in both patches, slipped through the cracks.
>>
>>>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>>>> ---
>>>>  drivers/vfio/vfio_iommu_type1.c | 31 ++++++++++++++++++++++++++++++-
>>>>  include/uapi/linux/vfio.h       | 15 +++++++++------
>>>>  2 files changed, 39 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>>> index 23c24fe..80bdb4d 100644
>>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>>> @@ -859,6 +859,8 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>>>  	if (!iommu->v2)
>>>>  		return -EACCES;
>>>>  
>>>> +	WARN_ON(iommu->vaddr_invalid_count);
>>>> +  
>>>
>>> I'd expect this to abort and return -errno rather than simply trigger a
>>> warning.  
>>
>> I added the three WARN_ON's at your request, but they should never fire because
>> we exclude mdevs.  I prefer not to bloat the code with additional checking that
>> never fires, and I would prefer to just delete WARN_ON, but its your call.
> 
> Other than convention, what prevents non-mdev code from using this
> interface?  I agree that making vaddr unmapping and emulated IOMMU
> devices mutually exclusive *should* be enough, but I have reason to
> suspect there could be out-of-tree non-mdev drivers using these
> interfaces.  Thanks,

OK, none of the exclusion checks will prevent such calls, even for mdevs.  I will 
delete the WARN_ON's and return an error code.

- Steve
  
>>>>  	mutex_lock(&iommu->lock);
>>>>  
>>>>  	/*
>>>> @@ -976,6 +978,8 @@ static void vfio_iommu_type1_unpin_pages(void *iommu_data,
>>>>  
>>>>  	mutex_lock(&iommu->lock);
>>>>  
>>>> +	WARN_ON(iommu->vaddr_invalid_count);
>>>> +  
>>>
>>> This should never happen or else I'd suggest this also make an early
>>> exit.  
>>
>> I would like to delete the WARN_ON's entirely.
>>
>>>>  	do_accounting = list_empty(&iommu->domain_list);
>>>>  	for (i = 0; i < npage; i++) {
>>>>  		dma_addr_t iova = user_iova + PAGE_SIZE * i;
>>>> @@ -1343,6 +1347,10 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>>>  
>>>>  	mutex_lock(&iommu->lock);
>>>>  
>>>> +	/* Cannot update vaddr if mdev is present. */
>>>> +	if (invalidate_vaddr && !list_empty(&iommu->emulated_iommu_groups))
>>>> +		goto unlock;  
>>>
>>> A different errno here to reflect that the container state is the issue
>>> might be appropriate here.  
>>
>> Will do.
>>
>>>> +
>>>>  	pgshift = __ffs(iommu->pgsize_bitmap);
>>>>  	pgsize = (size_t)1 << pgshift;
>>>>  
>>>> @@ -2189,6 +2197,10 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>>>>  
>>>>  	mutex_lock(&iommu->lock);
>>>>  
>>>> +	/* Attach could require pinning, so disallow while vaddr is invalid. */
>>>> +	if (iommu->vaddr_invalid_count)
>>>> +		goto out_unlock;
>>>> +
>>>>  	/* Check for duplicates */
>>>>  	if (vfio_iommu_find_iommu_group(iommu, iommu_group))
>>>>  		goto out_unlock;
>>>> @@ -2660,6 +2672,16 @@ static int vfio_domains_have_enforce_cache_coherency(struct vfio_iommu *iommu)
>>>>  	return ret;
>>>>  }
>>>>  
>>>> +static int vfio_iommu_has_emulated(struct vfio_iommu *iommu)
>>>> +{
>>>> +	int ret;
>>>> +
>>>> +	mutex_lock(&iommu->lock);
>>>> +	ret = !list_empty(&iommu->emulated_iommu_groups);
>>>> +	mutex_unlock(&iommu->lock);
>>>> +	return ret;
>>>> +}
>>>> +
>>>>  static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>>>>  					    unsigned long arg)
>>>>  {
>>>> @@ -2668,8 +2690,13 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>>>>  	case VFIO_TYPE1v2_IOMMU:
>>>>  	case VFIO_TYPE1_NESTING_IOMMU:
>>>>  	case VFIO_UNMAP_ALL:
>>>> -	case VFIO_UPDATE_VADDR:
>>>>  		return 1;
>>>> +	case VFIO_UPDATE_VADDR:
>>>> +		/*
>>>> +		 * Disable this feature if mdevs are present.  They cannot
>>>> +		 * safely pin/unpin while vaddrs are being updated.
>>>> +		 */
>>>> +		return iommu && !vfio_iommu_has_emulated(iommu);
>>>>  	case VFIO_DMA_CC_IOMMU:
>>>>  		if (!iommu)
>>>>  			return 0;
>>>> @@ -3080,6 +3107,8 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
>>>>  	size_t offset;
>>>>  	int ret;
>>>>  
>>>> +	WARN_ON(iommu->vaddr_invalid_count);
>>>> +  
>>>
>>> Same as pinning, this should trigger -errno.  Thanks,  
>>
>> Another one that should never happen.  
>>
>> - Steve
>>
>>>>  	*copied = 0;
>>>>  
>>>>  	ret = vfio_find_dma_valid(iommu, user_iova, 1, &dma);
>>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>>>> index d7d8e09..4e8d344 100644
>>>> --- a/include/uapi/linux/vfio.h
>>>> +++ b/include/uapi/linux/vfio.h
>>>> @@ -49,7 +49,11 @@
>>>>  /* Supports VFIO_DMA_UNMAP_FLAG_ALL */
>>>>  #define VFIO_UNMAP_ALL			9
>>>>  
>>>> -/* Supports the vaddr flag for DMA map and unmap */
>>>> +/*
>>>> + * Supports the vaddr flag for DMA map and unmap.  Not supported for mediated
>>>> + * devices, so this capability is subject to change as groups are added or
>>>> + * removed.
>>>> + */
>>>>  #define VFIO_UPDATE_VADDR		10
>>>>  
>>>>  /*
>>>> @@ -1215,8 +1219,7 @@ struct vfio_iommu_type1_info_dma_avail {
>>>>   * Map process virtual addresses to IO virtual addresses using the
>>>>   * provided struct vfio_dma_map. Caller sets argsz. READ &/ WRITE required.
>>>>   *
>>>> - * If flags & VFIO_DMA_MAP_FLAG_VADDR, update the base vaddr for iova, and
>>>> - * unblock translation of host virtual addresses in the iova range.  The vaddr
>>>> + * If flags & VFIO_DMA_MAP_FLAG_VADDR, update the base vaddr for iova. The vaddr
>>>>   * must have previously been invalidated with VFIO_DMA_UNMAP_FLAG_VADDR.  To
>>>>   * maintain memory consistency within the user application, the updated vaddr
>>>>   * must address the same memory object as originally mapped.  Failure to do so
>>>> @@ -1267,9 +1270,9 @@ struct vfio_bitmap {
>>>>   * must be 0.  This cannot be combined with the get-dirty-bitmap flag.
>>>>   *
>>>>   * If flags & VFIO_DMA_UNMAP_FLAG_VADDR, do not unmap, but invalidate host
>>>> - * virtual addresses in the iova range.  Tasks that attempt to translate an
>>>> - * iova's vaddr will block.  DMA to already-mapped pages continues.  This
>>>> - * cannot be combined with the get-dirty-bitmap flag.
>>>> + * virtual addresses in the iova range.  DMA to already-mapped pages continues.
>>>> + * Groups may not be added to the container while any addresses are invalid.
>>>> + * This cannot be combined with the get-dirty-bitmap flag.
>>>>   */
>>>>  struct vfio_iommu_type1_dma_unmap {
>>>>  	__u32	argsz;  
>>>   
>>
> 
