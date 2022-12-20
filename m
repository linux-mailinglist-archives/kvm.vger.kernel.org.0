Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3186528B3
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 23:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbiLTWH0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 17:07:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234154AbiLTWHD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 17:07:03 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EF61F9E8
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 14:06:56 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKLTCm1028213;
        Tue, 20 Dec 2022 22:06:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=/40s2wj0zR5SAeLwgVoB2SVXOOBKq9Z3fhCiHZCJIto=;
 b=jdq3gzvk/osv6TFyE2Ew6+K1tIb3L0GHpx8sUBczX/lvvYfVg5W/atR9vWxJbfXnGziq
 k97qBM/m//KAlBC/OQcy3+xCIs3gPd1UvVxpcdOlHbrv4b+/+4Eyg/RAkUx6puLQGdVS
 nrFuXIeZWeLuu3XuEfl8tcgiBbmms8xjABNe1wwqg2EkqOFEKvWuJSo7jc2cYSS+hKfu
 Kmsn5tAzHKyJMQuAnLPGPkf4XRm7SYuI+NeB9qOJr67+l1NAoZ1NeYNhdf53S3NxtwaD
 b+cgff0DmC3cIONIEXVOpqKzXA49T1eKVvCgupYRw4CrnwKLKMMqPnIC7IVfHHeZlIoN wQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tp7a4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 22:06:53 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BKL3jKj027602;
        Tue, 20 Dec 2022 22:06:52 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh475qn68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 22:06:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NT5dXdnUGO/JcuGVP9wcmieyeDbXvt7dip/JawDGgQDGS5NXgykJX3Gy4n7rF8voS3Gzue4nLMNPbAmxhRLIaCh86+A7v19ifGi7YxXMrMEw5mhBWGAw3eWf0Q4QoABCW9Ax0HNLp4WaNdopgOpKALpQSUdW1h0jIL8v/Oa0eFBGmQKH0iJ1XoFROC0Tx+zpJc8MsBiatRltD/CXRHAvTboUbsM3YQ0iYPTZyDF7uPe/moXfE3nzUted0ncIiJOT0pTma4P6sszi0ri6JP8UFNih9CEOTDBDv27oknP/jtQpwkTz939Zxfsn/x8oHwETEwr5VlSAhh18QnYlfnXywg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/40s2wj0zR5SAeLwgVoB2SVXOOBKq9Z3fhCiHZCJIto=;
 b=OYEGkK2HzRmlE0lWVpAP5fLNaemupPS26kek1MFFL7TtM7xdVtfkaI6g36YU3FNI/ZEtikcBf+VNdyBTKYasZeyQc7a2Tedtrq5UAbC+cTb7PaYOHrFSRdyAyOgCL7qOvrjs7TjNtjEqQuihq9+ryYQNCnvIfglZ5QlSAdJmmqvBSMO2kX5esVQg/so3oTx7jTsypoWp+VbSKQugHG436KShsjaVjPslLI+nX4qmeDdMZUJbSQeAEa/FR1rYaXlcxShb1NHhlGuS0HsvHCl+cjTrEyi9pdpJNidr0WeE0tRPJfZoIsY+JndUyNhIBd15VRXjsK+IkwVDRvPY/eQMEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/40s2wj0zR5SAeLwgVoB2SVXOOBKq9Z3fhCiHZCJIto=;
 b=CdlnVDQREQAKOibm9N3sXXvQUTucOpVL0JORWNyW70k1G0PIM2jWxRel/wWFWctSPY1oakur9QiYAmkPF/49Gbm3ewImKXjBENQoGl2howuitOv6XGdOzkKdhGTfYVSJUe0JESwCAGx4LyCbo4cgL15XNqiUaFIDxuYlzCvFBzY=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by CH0PR10MB7536.namprd10.prod.outlook.com (2603:10b6:610:184::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Tue, 20 Dec
 2022 22:06:50 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca%3]) with mapi id 15.20.5924.016; Tue, 20 Dec 2022
 22:06:49 +0000
Message-ID: <d2f9d93c-0d69-56ae-c271-7fd040e60149@oracle.com>
Date:   Tue, 20 Dec 2022 17:06:45 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH V6 2/7] vfio/type1: prevent underflow of locked_vm via
 exec()
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <1671216640-157935-1-git-send-email-steven.sistare@oracle.com>
 <1671216640-157935-3-git-send-email-steven.sistare@oracle.com>
 <BN9PR11MB5276E8FEF666B4E7D110DE278CE59@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f2af6106-7898-b96c-000e-92e84190ee54@oracle.com>
 <20221220145920.6669de59.alex.williamson@redhat.com>
Content-Language: en-US
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221220145920.6669de59.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0160.namprd04.prod.outlook.com
 (2603:10b6:806:125::15) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|CH0PR10MB7536:EE_
X-MS-Office365-Filtering-Correlation-Id: 74f0807c-fc5c-4d58-ee05-08dae2d67e5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v3tR33lPm3oPTUwCMSiuJvtNwpK038SusOXK8YbqTMwd0KAEjSeuIH7xQaczX1s9GRieKOS11Qmxq/5QAHNcNotFfkYr1Dt+W4kt2dPL6p1RoAq68R76zWAP6QWqS3aHWmnixwjgsZjW5IjNs6MbS7dqVg7DgsLQjV/O4cVe32JQnrqdnICokaVNdF672WUxAIMPl1pMS0uSkyGi43Qhv1D9wrh7df4cWnAyynJWkRy7of6idla+JTktPvBhKNJp7FFxAJ+Mk2FjE0DMXIvxkpyvXPAMI2oLUE0XB5VTJ6GoykmRApuk9hVFtVC2X6MpLrxzpReTKUGd0FjQXTirlW/T64ad5Nc++VB6xDfDQLjaUAnPWl/IwKJgUEvHVzTMcjiwcSHphtt6/MprTKAhP66s6Jbo5FA+YtAbKERMR7uLmTQaJwSxX3leoktyhbKDXu9M61CJlBXG9bU1SmnvJTZtysGJx1ruFUE7b+L4JshhL2lR9Z9BbHDOf/ep8tpbyHM+Aff++qFxdgMzKOCVczOjjbTIQPkeYv0GbCRT3bnGotwtQjXQXws7ohKy81LXY0U+J3/zEqlPtifUexDFw+vNj32lc/IW/A0YXgtW1yJZ2TupMCO61xZ406Z4W17XLFa1shSqcIkXjCEyEeFgMLDnJMB2HmA+PNHbwvcACMxclL3xVvwaoJFIZzA8v1PUHlYZoEN+0aootoTMiWHAN61CTyJOWzgWdH2VYaMLvys=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(376002)(136003)(396003)(39860400002)(451199015)(6666004)(8936002)(83380400001)(31686004)(6512007)(26005)(41300700001)(44832011)(186003)(5660300002)(2906002)(478600001)(36756003)(6486002)(36916002)(2616005)(66946007)(54906003)(6916009)(4326008)(8676002)(66476007)(316002)(38100700002)(31696002)(66556008)(53546011)(86362001)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0hEQ2szOXhsK1hnWUFxOHJ5VVNCYXl3YktKcjBKWjFXZWxtZlNlODV3VUxu?=
 =?utf-8?B?eXpoMjkwZkxFS25KNzhQMldBNFlEQzVRZWoyblZQWTlZR284dXBiZ3NnM2V2?=
 =?utf-8?B?Rm40N1pBQXZQQVBLaHdLeVpWQUdsTTFMdDFtdTZVa3JkSHQ4Z0RHd1o1SjJp?=
 =?utf-8?B?eVliYUllUjF5d0dER21mK0tub0t6TVpCUG1oRkZ4cFJQNjBkL3RSUEJRZmpM?=
 =?utf-8?B?ZGprU3F4bVhhaTFzOFhENGo4RG1ZYXFlZjRxb0N6eGM4akZ1UGdDNDB0K2cy?=
 =?utf-8?B?OXFOQ0pYVlpTR1pvT1dnNi9SdnRibkhJN09zbHAxa2JibEN0emRtRFE5cFUr?=
 =?utf-8?B?WStHUXBMdlJUVXljYkNnRnllV0N2ZUlhNG03SmJUWHp2RzVqckh2K2ZJTVJT?=
 =?utf-8?B?RDRCbE00b29SK2R1dWhhNzFSOUY5TmhtTG1vRlF3SUdSTjluYnJJK0ZFaUU1?=
 =?utf-8?B?UzQzY0QvZnUvbEpSMGlzcWYzMWFJVVlMMktYYVVjbWtTb3dwOU9hWnBxSXJN?=
 =?utf-8?B?ajhaU0RXaGUwYkJxV2U0bzlDNDRCb3BRN1ZlZGVlVU9RMVVWc0dZak12Tnhv?=
 =?utf-8?B?REdEeEhGYjFhNHpTVmhRaDJSN3ZTb1RTTVNWOUZwZ1lzSFVFR1U3dTB4NnhU?=
 =?utf-8?B?UHJscXJaQXhzRHpMc094ODlQVzFKS1NIUmZFT0JNMTJnWHBENmJBdmhXcldG?=
 =?utf-8?B?Q2JWUENXbU1sT3hSYjl3QVo1aGJ4amJSdXVIeVo5MFQ3aGpyeGdGVFArbDk2?=
 =?utf-8?B?cFVsNTMrUTFkWWlRR1ZYUWNTZkk0OEFJM2crNkNPWGwrYjFVVE5abmgzdVQv?=
 =?utf-8?B?NmIyT0swdGFMQyttZmlyQUdFTS8vYlBWeFdNbXVTejA0SGFCRzRJeEQySnY2?=
 =?utf-8?B?bjVhVk9GNHlDY1JraTJNTmdCSW5VVXR3aWl1SXJ3Z2w1S3BxQlBDR1Z4U0Zx?=
 =?utf-8?B?WCtXeW9mS3E4MFFnaDUyK2I2YUpvZ0Nkd21BbW50bXY0SnJqNHNzc3ZFek9n?=
 =?utf-8?B?RW9NZkJONzJTcmpjZjN0QlpTZW55VEFDVUl6SGtzTFIva05KRUZ3dEVyTVI3?=
 =?utf-8?B?N0NYVUdWNTVvNHZLelhPZEN3UEtIOE42eHc4WG9YU3d4NDdHV2V5VzFtSkUr?=
 =?utf-8?B?alFWd0N3d1pIZ1UwQUl0VDlUcjhVRGdYUDJ2aFpxOFFpVnVORE93OEFKTkxF?=
 =?utf-8?B?djg1QzUxaWYxT2VRQ3JJV3BmM0xQU3VBQldKdVNVQWh2VDFycUZvdVFISzNm?=
 =?utf-8?B?M3hMMGtjc2pGVjlLTHRLUWpZRHlHSmZuM2lkUFpoNlVEVXI3ZFJSNVZyL0l0?=
 =?utf-8?B?YTcya3lJUWVjYTdOZmFnSjd1R2lLQVNGY1B4a0NWamUwY3RUaWN4SzJ0WnFy?=
 =?utf-8?B?enZCcVMydDFJM3I2bDdQOXErTnl3dnk4Uko5bUdKM3JzV1RDMDZJZ0NZM1Zt?=
 =?utf-8?B?bFRyZHhYcTJXRFNPRStGNm92THNFMDhmczhHbEE0UVJRWHlLSFpyQzVLNXc2?=
 =?utf-8?B?SEV4Y2pVYVc1Vjh4TDg3bEpKWnJKeGNVQU9iR2lha2pwdUVGTTRISzhGNjBH?=
 =?utf-8?B?T1V1L3grY3ZhbkcwWEFqVUk4UGZYTHppL1REVGxSWStkWlA4MS9VdldPNENB?=
 =?utf-8?B?S1pMQ01mV2RKTVl2YzlEdXhRN0NhaXJtQjJvM25GUS9MVjMyZ0lYendzTDMx?=
 =?utf-8?B?YnpnZ1BSN2IyRDE5UlVMQko1NThYR256VVdqSThpcVQ2N0NPSDlHOXEzcFNH?=
 =?utf-8?B?WDBKM2kwTEIrNW5VRnR5aGJad0lrZUtVWHkzUXQwMmRFOCtsNnVXU2w5NUxD?=
 =?utf-8?B?cG52aTZrT1ZOcTFIcUtzZFV1Zk53aUV4b3M3R3F5NTY5OGpsbDAwMUMxS0xH?=
 =?utf-8?B?OGhBL1BSOWFTNUlUZ1JiYVE4WTRJTkRzUm5BcUxHNy9JSEVVNGMxWDZFVE9n?=
 =?utf-8?B?Qy96c282aUJFbUNFdmhvUWpySUNzaU1oTGRsYndUMG5sdzhuNE95cnZqU2JS?=
 =?utf-8?B?YUtoditPdDRrSy9LdEFsOXk1RSsrY3VKc1k0VytVejJncXczZmtESjdPdnVM?=
 =?utf-8?B?MGw4RHpvaEMxYnh3UWpwamZCQWM5WWhhRzR6ZW42VTJJeGkxckkyOEFGMXZH?=
 =?utf-8?B?ZUdPRStVTld6ZzZMYXdJL1FQY0NweThLSm8vVGRmMEUwdFk1YytaWExRY2Vj?=
 =?utf-8?B?MXc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74f0807c-fc5c-4d58-ee05-08dae2d67e5e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2022 22:06:49.8937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tlXanbFxsNq25yOB/uQsuwBhspxTjyTjT39REdi5T3p1WLafGdbjyasQKKILwIFQfmh0iMbNMMS0vtYfB0GWiSAUiG3a6tIhluyZWE5guOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7536
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_06,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212200182
X-Proofpoint-GUID: fHnvvEiopphKvDfEjzues-zYeoCuOe6z
X-Proofpoint-ORIG-GUID: fHnvvEiopphKvDfEjzues-zYeoCuOe6z
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/20/2022 4:59 PM, Alex Williamson wrote:
> On Tue, 20 Dec 2022 10:01:21 -0500
> Steven Sistare <steven.sistare@oracle.com> wrote:
> 
>> On 12/19/2022 2:48 AM, Tian, Kevin wrote:
>>>> From: Steve Sistare <steven.sistare@oracle.com>
>>>> Sent: Saturday, December 17, 2022 2:51 AM
>>>> @@ -1664,15 +1666,7 @@ static int vfio_dma_do_map(struct vfio_iommu
>>>> *iommu,
>>>>  	 * against the locked memory limit and we need to be able to do both
>>>>  	 * outside of this call path as pinning can be asynchronous via the
>>>>  	 * external interfaces for mdev devices.  RLIMIT_MEMLOCK requires
>>>> a
>>>> -	 * task_struct and VM locked pages requires an mm_struct, however
>>>> -	 * holding an indefinite mm reference is not recommended,
>>>> therefore we
>>>> -	 * only hold a reference to a task.  We could hold a reference to
>>>> -	 * current, however QEMU uses this call path through vCPU threads,
>>>> -	 * which can be killed resulting in a NULL mm and failure in the
>>>> unmap
>>>> -	 * path when called via a different thread.  Avoid this problem by
>>>> -	 * using the group_leader as threads within the same group require
>>>> -	 * both CLONE_THREAD and CLONE_VM and will therefore use the
>>>> same
>>>> -	 * mm_struct.
>>>> +	 * task_struct and VM locked pages requires an mm_struct.  
>>>
>>> IMHO the rationale why choosing group_leader still applies...  
>>
>> I don't see why it still applies.  With the new code, we may save a reference 
>> to current or current->group_leader, without error.  "NULL mm and failure in the 
>> unmap path" will not happen with mmgrab.  task->signal->rlimit is shared, so it 
>> does not matter which task we use, or whether the task is dead, as long as 
>> one of the tasks lives, which is guaranteed by the mmget_not_zero() guard.  Am
>> I missing something?
>>
>> I kept current->group_leader for ease of debugging, so that all dma's are owned 
>> by the same task.
> 
> That much at least would be a good comment to add since the above
> removes all justification for why we're storing group_leader as the
> task rather than current.  Ex:
> 
> 	QEMU typically calls this path through vCPU threads, which can
> 	terminate due to vCPU hotplug, therefore historically we've used
> 	group_leader for task tracking.  With the addition of grabbing
> 	the mm for the life of the DMA tracking structure, this is not
> 	so much a concern, but we continue to use group_leader for
> 	debug'ability, ie. all DMA tracking is owned by the same task.
> 
> Given the upcoming holidays and reviewers starting to disappear, I
> suggest we take this up as a fixes series for v6.2 after the new year.
> The remainder of the vfio next branch for v6.2 has already been merged.
> Thanks,

Will do - Steve
