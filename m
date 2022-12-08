Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E798D647706
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 21:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiLHUOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 15:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiLHUOH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 15:14:07 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A052E78B95
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 12:14:06 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B8Jg08t030140;
        Thu, 8 Dec 2022 20:14:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=BgsqFHAgIVaoZhZr7Fwc/Tu9DEcZIEjo3SW5N5eHGLs=;
 b=Rq67vGJa+abShVqW0spx3OYHS6lCt4GQZETSGBpMt7Acj3hUC1RARriuMluvJLfFgVrJ
 CtQGlFNE43/oSILdg7wFqY7qR+U2XNRWH1X49WihX9ez95+LmU1jkI/JDTtOi8u919+6
 jiI5Fvv62Ih4ycFStnFkh6eQ2JY6Wi4eUIZAoB6q/cC0Rq9c6+NnSOS2dAEnb4T7/HYC
 7xvru2SuYOInqhKurlSgwWUmvRg5SDDpiQnC48qm0xUv0vcKhyFvem3XNglNYbj2hN/C
 dylRnb5THNlZFhBaPbl+KM40XivKbk+C76MBYItjswzJC5cCW6R013nt5g8YMSCilyGg IQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maujkkmbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 20:14:04 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B8IZZQZ032631;
        Thu, 8 Dec 2022 20:14:03 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7esv6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 20:14:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W7Y+n/INMnAIE78PbPP+3vLbQEhA8ewTWpM+tzDvhY3rnIvqEAq7B44i8XuVcjzYDCxbbrNA/AgV3bvwU3EsyyET7vfTsd8tb4ws8xqXf5T3mOuX2xwWSwGiiSXtuBVtLCFYq7EC7NprVMUuP/EKfMGJUmjrWZodFnhY59yBJr4s8tSNw4yYVa3D2F4ruqxcyzLznClqWM7Llmj6jud9yTZWHunyGltrcfYCAzSjzI0GjCnCgKEAqsB/ZmV8p7M4p93iYCy5zILMIQj11B6ZovKKCf26zhrFslueaq4envNPIcsNsGnvl1DXzKuGOwOYFDvIUtQK00QToTdpKO6QbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BgsqFHAgIVaoZhZr7Fwc/Tu9DEcZIEjo3SW5N5eHGLs=;
 b=Kh1K6qv6mIm8uK0mQ4YKJSdMRAO6uRwE19Jt4YrfjdALmGPtpRiFlSqCA85/DdLfqCbI2tQ5nREkNRqBDy7buUopwpug7aza74apPL0VU8PPCcjSjxkCDn92oXKgbXyHR3v6YjJFLjg/h/eOLxjPvRHDSTMdhhaz5+pHNEYev29Uz2mGJQEGD7yY7YXXcpCrV4eWGjIEOQsr48QNtqft4vSD3bBhtwDSxX8hrBgvJceXRsrhVyHgUhVcBOv7EfrcphrssVyRAhW2tP+8ZdJ0dGHtPatOAl+NER2nmwrg5tZ7GwQIXMVRwEDXhSkVcD323MbnGz3WmrOl3C5+Zpq/OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BgsqFHAgIVaoZhZr7Fwc/Tu9DEcZIEjo3SW5N5eHGLs=;
 b=M/aNLKsm9MT5IMxvA/K0gfMJouax5WZhQYbVkbGjfowWiPle06+rUmrr9AplCvBXv+JD3tRcI9UICVDZLLpBHHW7TF2DI2GrpzZib1tIlOKf5yNOHEle4ITs/4oqghv4Yo8IZaYE/FPGTc71xqB6SC7KppEJAxbyw+qRb4kYy3U=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by BLAPR10MB5124.namprd10.prod.outlook.com (2603:10b6:208:325::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 20:14:01 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e%4]) with mapi id 15.20.5880.016; Thu, 8 Dec 2022
 20:14:01 +0000
Message-ID: <ad1a2948-518d-18f8-1bea-c2eacbdeec92@oracle.com>
Date:   Thu, 8 Dec 2022 15:13:58 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V1 2/8] vfio/type1: dma owner permission
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
 <1670363753-249738-3-git-send-email-steven.sistare@oracle.com>
 <Y5CxCS53/aBT14EH@ziepe.ca>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Y5CxCS53/aBT14EH@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:8:2f::17) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|BLAPR10MB5124:EE_
X-MS-Office365-Filtering-Correlation-Id: d3f1dcec-e0f5-4a8f-db9b-08dad958bf11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S3fN4H9WZpLCWMn0WpWFnb3hiMzIdPYqRRppC9V/w1c6eg8j8nokjLuYQbQ/0bCRsXDjdMrccAQn5OO544DJAImWaS2TPDscZvXpmQLFgi9QFm933GL1jYSET+cqOQ/q2e1hyGcckJyObAw11UNMS54g9DrkR0A57FjcB0Rjw/3R2I2lZJ6QZZm0Yy+j3b+HxMicBcCC1SOr/Apqdb87FcLzmQi7dn95QezV1G8pXv5Vub0+nrhMBS3Bl0NckpHbqPnkISIPAGv0ZlpxPIj29dyY06IVzCbky3p9q7NkoMa4dtGtaRv52oTgiCLErejODo6iDPJHdWKWd67LptErC3N+NKW6edIw76ZOnHfpOwEg1rQDVrzdS2vb+uygHph6YByjtjrLQxgt+EMfRZi06T1e4QHwdTYERxag3sFtFVBE9AoemcO03IplUS/sNnoTbrn9uNaU+8J4JbmIwyHzK6BQDux1gMt+wst1pMMzVg79TTocJejas3wVAv+xrwcJX+egrqIcFXxxo8KvS9M7SfiCVf6tHsUSL8bGG0KyWBHOR3Ths37PE7rPzI7WqdLzWJnle8hsBUOGwu8j5UeJTfD+DXly7VfxvKoiaw/HhhOSpbmvItz81i4E4daDrP1SQNiDC1uMI9oHk3ugPt18SHZ/5h2KqcWG/+4xJu8vHe/P8vpyb2zgdOF8Ug2nm7DIup9UyOPpENiWYqBIOUvCZvJq8w7fDdsUiE2BZ49r8aw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(39860400002)(376002)(366004)(451199015)(4744005)(83380400001)(41300700001)(6506007)(8936002)(31686004)(5660300002)(66899015)(36756003)(36916002)(4326008)(66556008)(66476007)(6512007)(2906002)(316002)(66946007)(8676002)(44832011)(38100700002)(2616005)(6666004)(31696002)(86362001)(53546011)(478600001)(54906003)(6916009)(6486002)(186003)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1ZsM1RaUExLL3ByU29Dek9OWnk4L0dXUlFmWmIwVnU5akVMTSt0SnFQaE5i?=
 =?utf-8?B?Y2wxemhLM0hkYkRaM2t0dERzRnc0U0hWd3hkMnpqVHF3SkYySmZHenhCRlZM?=
 =?utf-8?B?UVRuRjFXMXlBTS80djZWcDJVS3dFRC9ubUdvOTNQWGcrNHpXRnhaaVZTejhz?=
 =?utf-8?B?bWVnaVBlNjhMUGVFazdHeWZKV1hSSml6SlZZNlZnbWgzVjFTd2lrbnFwdExK?=
 =?utf-8?B?OUFlSHVWNW41QVRxK0x5OERzWjBMS0VJaHg4L25tWnNQVm84RXJ6OEFNNWNz?=
 =?utf-8?B?VlpyTmN0dzdnbFV0MFEzbytNQUluSkJZOCtMWXJ3dkh0ZjRlRWZCQytSZVdT?=
 =?utf-8?B?T043YnZNekJMZTNJbDZUbnh1eDR3aVNnZWFjUDcyNFdEeHBLT05TbGVsc05z?=
 =?utf-8?B?dnF6azVJM1NOSGorRzJJV0xhbHFNbXo3OFFsWFQvSm5lNlRKSEU5VVdsak50?=
 =?utf-8?B?ZS8wbFNHV1VUMysvZVoxbldqakNiSXFtY1hlSDREeEJ2YmhveE9sMm5UNWts?=
 =?utf-8?B?alVBSGYyM01PKzFqKzZFMTJkQnJrK3B0KzVBUllGcWdYOFErSHNVV2RUQWJH?=
 =?utf-8?B?OTZmQlNWYW9KYk9YM2k1WkNQQmFsZWwyS25Zd1NjQ0VKR3lHcHgyS3lRbTYv?=
 =?utf-8?B?KzdCeE9UZHNUQ1ZidjFsSWxCc0w4MG5JYnNHb1FkY0RWRlNOcnozUWNjNW5u?=
 =?utf-8?B?aVZCVUxwclhxMlVNektrUE9CSXg3M1hGUUIyQWRHVUJjWVBUeXE4WGFvcGVQ?=
 =?utf-8?B?dXRRZG1CUzh3Qk44RXJ5blFsUTRNcFhOQm5mTFVBRGpxWmZTZlNrOWduT2Qv?=
 =?utf-8?B?elFEVXB1VmdzSTNFekdwL0Q2VFNqaWZLRUltajRoc294QlhyS1hQcU5uSlBV?=
 =?utf-8?B?Nm52alBrMHhFMmlIa0l1S1Z6dGdvaS8rbG4zazErTmpobkNvaVZKQ096cm5v?=
 =?utf-8?B?T0Z2TWpkTG9jQTIxTzBrbkFkMTZUQlpXeE1wQ1MzaE9JTm5UY3VtbUEvQWUv?=
 =?utf-8?B?UFZXM3VvaXR3cFgzeldoQWZIaHdReXlseFRLVTc0eDcrU3E5RFVPWnBreWtW?=
 =?utf-8?B?WmxqUzVwRGlXazhWbWNVWDN4WWFMcHdUSEJHZmpoN2kyUDJETHliR3F5eVh4?=
 =?utf-8?B?VFZNZVdVOGUrUmVqMFN4bERpOHlpc0x5M0dWekx5dzZZc1dIdzM3ZHp3RFpt?=
 =?utf-8?B?SlpMQmlDWEx6SmZIbUtlNkFkRU9MdzZsay9SMXljM3BmUm0wcjJnWFpFdk1i?=
 =?utf-8?B?cHlGcTdJQ0p4d2xmWHBzNTJJbTgvOEhrR3g4WHlSZE82TW4waTA2b3Uvajhx?=
 =?utf-8?B?TDU5Q3M4WFpWRHNHZkgxVEZUQ1BYbEs4bytRaEJ1MG5SVU53UkVPd09VMXNO?=
 =?utf-8?B?SXJOeTNCYzFMMzUvU0dSMk1VeGo0b1Jyc2hIRnlFdFczUGoycTY0YUY1bDg1?=
 =?utf-8?B?NkttZFcxbEJaWER4THo4ZUJqMlFuODlWaERtbjFLNFh5QVdLMTZVRnhsOVJN?=
 =?utf-8?B?ckNUcFJHVDNBMXdrc3dQbTdzaENRME85QmRPdy9YYzdaVE9EQmk2ZEFTV00x?=
 =?utf-8?B?eXVCT3kvSXM0Um9yNUxOSGtESU1KcUFYeEZiaitZc2M4NkYrOVFjSnd6NlZJ?=
 =?utf-8?B?UzZQNUY5amVQTUdGUldrNWlrTWJOZzY2OEJYOEFFU0RwTmpHc0xYSHBYcFRP?=
 =?utf-8?B?TEhRRWljWHpHb3ZaWTRnbXBMMEhBQkszYjRwUDRYMzRKUm1GandnQVk0QitQ?=
 =?utf-8?B?bnZ0R0xpSWxneWgrbVhJYTdNWUNldW9GU2xuWmsxejdBUVpQWm0zUTJ6OWI5?=
 =?utf-8?B?bFU0MTI5Zi80SFVtR28zYWVjRS9PL1ppc3p0VWN3SEUzZ1JVZEZoNmo3OFlX?=
 =?utf-8?B?MGxDemdFdXRSbFJGOG9Qd09OelpCWEhGY24yT3cvUk5pd3hrQzYvSitOYVVP?=
 =?utf-8?B?a0QzdFFwSnhDMXhhUW9tNnBaOTZwckN3YXNGMk5nQ1lJU0V6alB0SlFZS2Z1?=
 =?utf-8?B?K2FRY2drMFgvdjkySW5RNVRIaHZaTUdmZy9mU1gwUjFSMm4vVExQR0pWV2NT?=
 =?utf-8?B?VkZubnNBNVMvdUU4YWEwdldKVGRmT25kTThHZzl5ZHNXL1Bxd2hlY0hrUmlZ?=
 =?utf-8?B?dTR2TFdsVS9nRGtCNHJUbVdsWUJlL3ZyaVRWNytsaitsQ0F1TkZ3K1UydlE3?=
 =?utf-8?B?enc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3f1dcec-e0f5-4a8f-db9b-08dad958bf11
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 20:14:01.3720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1QU3JUMRnqWjwgbBcAbSdXcQB/DL2rWMpwotXHhSdjseUoLlSYznHaoGv/J1R3/HJ6c+J0vfNszXb8Zx61fLFjDZ+LtJGboZ2tDUCeYp51o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5124
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-08_11,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=850 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212080169
X-Proofpoint-ORIG-GUID: 9xKAw0Qcia94hHtHLWgdEe7iCxTrygTN
X-Proofpoint-GUID: 9xKAw0Qcia94hHtHLWgdEe7iCxTrygTN
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/2022 10:28 AM, Jason Gunthorpe wrote:
> On Tue, Dec 06, 2022 at 01:55:47PM -0800, Steve Sistare wrote:
>> The first task to pin any pages becomes the dma owner, and becomes the only
>> task allowed to pin.  This prevents an application from exceeding the
>> initial task's RLIMIT_MEMLOCK by fork'ing and pinning in children.
> 
> We do not need to play games with the RLIMIT here - RLIMIT is
> inherently insecure and if fork is available then the process can blow
> past the sandbox limit. There is nothing we can do to prevent this in
> the kernel, so don't even try.
> 
> iommufd offers the user based limit tracking which prevents this
> properly.
> 
> And we are working on cgroup based limit tracking that is the best
> option to solve this problem.
> 
> I would rather see us focus on the cgroup stuff than this.

Yes, this is N/A for an iommufd framework that can enforce aggregate
limits across a group of processes.

- Steve
