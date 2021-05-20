Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE84738B5A2
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 19:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236058AbhETR7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 13:59:55 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:34538 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235920AbhETR7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 13:59:54 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14KHsMjd058287;
        Thu, 20 May 2021 17:58:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=sXYS2Z2Gd3uOJ6v4a+bdP31MV5mgEM1jcH2OyNvnA1M=;
 b=htz8vvs+9VdBkSgF7Dan7mOZabNuxgimoIQKkx74alVN4fFLfyH6Z2jlUuddi3STUYzz
 79uvDscwcx1uIYjLBD5ixVmQD4ci0WYta4tqrb6M+OEr0r6AZrq1jj4YItw/fS4NYyIX
 xoREQZ9+3/OeXlCOoMXneRu6gtU/TNxgu7gvyCOFNPNReYnKbSyH2BCFL5Np9oNvof6H
 tl1e0EWWyawgya24APqA/nzZufsxmjH6UCMHOycsRxRzsEV6f/9MvywYOh6mBCJuQNEh
 mTb+DPKM31UOty57lSuRs7kVh0wf15NFViKFfRMwip84wpPO9IDjKq0YoRlrgyFoaicm zA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38j3tbnkrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 17:58:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14KHu8h2178615;
        Thu, 20 May 2021 17:58:28 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by aserp3020.oracle.com with ESMTP id 38nry0ey4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 17:58:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A/l8RF13Rtrjq7eS05pTu82XMmotjXOW5vSIP8u+2QbYSdlJSHaOE818/yMEOpOsUTj8klUUdSGLinKzi+kGnjNLhtIhoIEEFFKMPCa2BxTUZFh5g9/P+KAeo3PRCwMyZkOTG6KvmpZuQYqfpNShOQ0tj8Xqy/8jhmticqgURDpbA4Uo5piDKuo/rgyLT1dX19vpzEyZyIXysVuO0tNP+5LYUKrv4gEm3mxE9zw+fPHhZg66fKYUH+xSRNKncZswPjY59qQccqI4NDmgqW3fDgEJTal4+9a4elUbue5Unkp0k/zW6x1f8aWg3ljrY5Z6ymWNrR+fLcWZECMTme2PSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sXYS2Z2Gd3uOJ6v4a+bdP31MV5mgEM1jcH2OyNvnA1M=;
 b=g1uAhwZyCJiXyjdIxAlpKFjQvVBEpm9aIH08CwXUjsbLX0J9YCHsncvxvDuv8JS0IGXSaAp31JMHP17caBvQsDftBB0zy1yoa9fl+tUGnva8573IjaTxPEpQbg2jeT0zpdd5X47lu27AR+c/RNlVpoaD8xcoxj/ChUJw6ahUEEkMcoIbAhNTEAKzqYt/J9K9d3v8IJahHESNLQylosHc4Y2CGmk8zk0W9DHuraoB/LU2oj8KNMH6aV/caMyCEl7mIE/dGGZvX5HyPN2ys7CCriHhlPq1kh6xcfKgqGF/20mJdLQ2r8Cq1vFeuWzz9X4XnkafPWN0FTy3iixmxA8T7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sXYS2Z2Gd3uOJ6v4a+bdP31MV5mgEM1jcH2OyNvnA1M=;
 b=Qt5MIkC7K9MLXVxntiYbkZX/h/Wi2Ot301LVN9Kks+Q4How0u3PZTBDkc287l8CqwiHKWOjddBd/Nb4QenKlX3t6jnlBxMVIspuJ6fCbksZVRnuGb2pE6bFbxPPk0JKXfycz2x3BbpvbevxPd5G7qo5qBnJktp3dt2VLNyLGgh0=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4682.namprd10.prod.outlook.com (2603:10b6:806:110::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Thu, 20 May
 2021 17:58:26 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 17:58:25 +0000
Subject: Re: [PATCH 2/4 v2] KVM: nVMX: nSVM: 'nested_run' should count
 guest-entry attempts that make it to guest code
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
References: <20210520005012.68377-1-krish.sadhukhan@oracle.com>
 <20210520005012.68377-3-krish.sadhukhan@oracle.com>
 <YKZ3115oZOB7eH5d@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <b5e44a57-b2ba-7583-9293-9515c8d9a5d6@oracle.com>
Date:   Thu, 20 May 2021 10:58:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <YKZ3115oZOB7eH5d@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: SA9PR13CA0098.namprd13.prod.outlook.com
 (2603:10b6:806:24::13) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by SA9PR13CA0098.namprd13.prod.outlook.com (2603:10b6:806:24::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.11 via Frontend Transport; Thu, 20 May 2021 17:58:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa2c6ddf-37f1-4aae-803c-08d91bb8ddb8
X-MS-TrafficTypeDiagnostic: SA2PR10MB4682:
X-Microsoft-Antispam-PRVS: <SA2PR10MB468228695C5AAA2D8B78F18A812A9@SA2PR10MB4682.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AVy3Sd4Jcadbzl7jf2Q+0XRVCsZPYtDL8ttk9wYMvGzV50nrc3DCPVbJMQ7I6f/PVaauD4u3wWXeR47qa+IUQ5J8RrfG0zvaRGHzFzNYpAX+SMR6PlX5mfD5RyJwArhSKuY6llEb2uw/N95Ta2rNYKryQk1bEKuLxrTEl3tHopnmwnq3Xw2RSfRBJ9OfJO9nEAn9W2LuHyjBi1/gvzyCrYPVz0rvYdK5J1iHVbzuIZ2sQSnBIkfBYoMaxL1L81CwoDiX4VOpc8GIlsPFEym86HofIsbZqh5h1rV/SSi1MQOxgFyqOKvTizrEHomF52bXO8WJ6wAo0clJODGhwwky4zPJr6V6W4wc96FXaGMNQ8KYJlgpoT21Bd9lyp3wS6LvJsLdCDfIfklWd34C04UBPU9EWpW6n7GzXu9uHXn0HrzwYwi+RMkIWZ74G3C87/W9KzFp9W0UBV1/xweFm7HdhgziKiSXfOIYJ4VrOabCiWD697gfnYwsxGQsezA3z623VMTodPtm+NmL3gTMDcVnM6dmrh4H3ETlX2LZmZ3hZkkASjjI4FNlbEYAXKf8OcHLLqDrtn5o181gIGMBH9NqAPDt5pNnIuek/6PB420cbrWm8SYpWL/8qNpNuFTcFv5Tky2rUR66+O7chHG1uiXEiPEF4iIMrOS17H0EuKl+lXT8u3F1UFHq6PCJtC/hbFk/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(39860400002)(346002)(366004)(396003)(316002)(44832011)(31686004)(478600001)(86362001)(83380400001)(5660300002)(2906002)(6486002)(2616005)(4326008)(38100700002)(6916009)(8676002)(16526019)(6506007)(186003)(53546011)(66476007)(66946007)(66556008)(31696002)(8936002)(36756003)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eW5EOHdwNkNoNmhjQ3JVOHdMTnBQK1daSHcvNmZRakZPbFEvU3pTOExwcFU1?=
 =?utf-8?B?anRlYXQ5LzZIL1BLUnRKUERDOHdzbEQ3QTBOT1I4ZGovdnVSZzFHbDVHRTE5?=
 =?utf-8?B?TUhTWlJFZmlQZExqczI4K0FibURIcW1wZERCYUYvNHNiTmp0S1lIa1VTTGUw?=
 =?utf-8?B?bC9TWXdzbmhZczNaS2d0NnJTRnorY2VGeFJLdFk0cTdwc2hTcndQRjA2RDRj?=
 =?utf-8?B?cmpiaHAwbmV6OEk0OVZDajhpQ0RYb0ZBU29NbkFIbFNiQUlxa2xiL1hOZ1Vo?=
 =?utf-8?B?OHFJRGZLazdGVURRT0hoSWV1TXRDUEJRdGlMdDVrdGFkS09KTnpndFEvYlor?=
 =?utf-8?B?Mkc3N2I4eUFVSzNwdEhDQWFHUHNXUnJCN215NkJQZDhMVXFxRzljNm5NVm00?=
 =?utf-8?B?dnJ2eHJxU2JYSkVRb3R6a0lzajdmcWFMSHR1Mk50cHQ5ekVzN281RFVRaGpr?=
 =?utf-8?B?cUZ1TkhQeFI3OXZ4UTcvd0hXUEtTU2EvZ2VNZTRtcG5JNXlZTDRQK0tjWFd2?=
 =?utf-8?B?NTM4NzFDUkVrVS9QSncxS1VYdnY5bWZzQzNYRkJ0VFVHcGpTVUxISloxelZP?=
 =?utf-8?B?bEg1ZGR4RlJLQll5eTBOOVpocUsrM2xxcEZlMkVITUtBYkkvd0VqakVxQVlk?=
 =?utf-8?B?TmNiNlR0cG0rSlc0a1RPUG53bGt5VjFzcVRJWEt0T2tmT2ZYdHBycW9CQ1lK?=
 =?utf-8?B?TXI0U3hJZzlnU0tCVGJQRE1pRUF4a2o0MG1ILzNpY3AxQ0V6T1Q2cGVWR2dP?=
 =?utf-8?B?YmJHWDVRTStuNkg1UGJPSDFUTlB3eXliZ1ZQeHk5TU5BajBQOEZ0VVJSMCtQ?=
 =?utf-8?B?QUY0M291UWZoRXZaUm9sRk1oaXc5eTBFR0Y3UDNkRWhUUTNzajV6UzhkblI3?=
 =?utf-8?B?eFYzTTlxUm53Y3hyKzJhdjc4R3hmVlZLbzg0SnpPMGtiNGR6UlJuQmZzV05w?=
 =?utf-8?B?MStQYzJzUVJ3L0FRMUlvOWxqbDNjSzVmR0FTVE9CaEpnNE1MbkJSQ0hGUm1X?=
 =?utf-8?B?eHhPa2lmQXB1VnRhU0RJa0FjNzM0NU16TzR2VjhVRlN4VXVkSGZuWmMvT3ln?=
 =?utf-8?B?djZGdlFsSVF4REJBNmR0N2hPRVU1Ri9TQVB6cGNtTnlYRVc1QkdzTVVNNTJB?=
 =?utf-8?B?d0VBdTZlZmhRM1FXdEdmZ0JuT0llWWIwMHhYV1V5dytXbFkrYXc5TU5YMVdS?=
 =?utf-8?B?aUhhd2daNEtOOTRuN3Y3bi9tTEpkR2VLeFB6VFR1RzVwYm5KR3ZPb3pOeTFY?=
 =?utf-8?B?NkJQL0ZhS3M4SmE0emc2N0NiWjNscHVtK0hCKzl3UUJuaVlZVjJERmRvWkZk?=
 =?utf-8?B?aW85SGtKR2JwU3hHK1FkQTRRNWZMOEZsRGRDZ2xXempKTDd3amZ4R0plVG9J?=
 =?utf-8?B?YWdXY0ZORU9HU1A1T3NIVW42ZW56NXBac0RvUzBLL0VGNUxHY2ZFa004YlBE?=
 =?utf-8?B?S0pheHNCWFo5R09YVzBsMG5waGxNUmFaaDV3ZFlOQUpvU3NOaU5DdWlzTEpx?=
 =?utf-8?B?L0lOK2o2WVd2bGxHSVREbWk1VjVQWVpmaTUxMFZyTUQ2Z21GcHNvLytRUjJP?=
 =?utf-8?B?cy96UWhOWjJ6N0NQbVlrelkwKzhPWU5EYnNYS3FWMXpvV3V0aUVGRXVnNjYr?=
 =?utf-8?B?eG5OUGhqK3ZtWjZoT0JDd2tSbmRCSFdvNWZvOElqY0hQcEVSS2RSOHdtcGxl?=
 =?utf-8?B?TUk0MHcrM2sxVWExYmJ2M1Y5d0ZHQXNBRXhZQTFVRXNGcVJQTzJZMVZjanRm?=
 =?utf-8?B?V3d3V3oyU0VPNHExZG9FbWNweXVWRVhDMFlGdExkeWlnVFBTRHE2SW02djBo?=
 =?utf-8?B?WkZWMlo2VXJlMjFJRWhJZz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa2c6ddf-37f1-4aae-803c-08d91bb8ddb8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 17:58:25.8943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G00H/bmQvYNCZmv04MInoWpMfdoMGZBzFaJ/k5MmiLf41+twBOd58KnMPLGds7sJ7mMVgXY6vkUy5vkHEx/ickVwaTSa9xM8oM6BbGdDyA8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4682
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9990 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105200111
X-Proofpoint-ORIG-GUID: IiLcsgr2Lmi2HniO4cJBjhO8p7ZuAi2s
X-Proofpoint-GUID: IiLcsgr2Lmi2HniO4cJBjhO8p7ZuAi2s
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9990 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 adultscore=0 clxscore=1015 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105200111
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/20/21 7:53 AM, Sean Christopherson wrote:
> On Wed, May 19, 2021, Krish Sadhukhan wrote:
>> Currently, the 'nested_run' statistic counts all guest-entry attempts,
>> including those that fail during vmentry checks on Intel and during
>> consistency checks on AMD. Convert this statistic to count only those
>> guest-entries that make it past these state checks and make it to guest
>> code. This will tell us the number of guest-entries that actually executed
>> or tried to execute guest code.
>>
>> Also, rename this statistic to 'nested_runs' since it is a count.
>>
>> Signed-off-by: Krish Sadhukhan <Krish.Sadhukhan@oracle.com>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
> I didn't suggest this, or at least I didn't intend to.


The idea behind my v1 patch was actually to eliminate failed attempts of 
vmentry but of course I didn't place the counter in the right location. 
In v2, I placed it based on your suggestion.

So, the burden of the intention to count only successful vmentries still 
falls on me 😁.

>   My point was that _if_
> we want stat.nested_run to count successful VM-Enter then the counter should be
> bumped only after VM-Enter succeeds.  I did not mean to say that we should
> actually do this.  As Dongli pointed out[*], there is value in tracking attempts,
> and I still don't understand _why_ we care about only counting successful
> VM-Enters.


If we count all attempts, failed and successful, the counter won't tell 
us if any failed and how many. On the other hand, if we count only 
successful attempts, we won't know if there were any failed attempts. 
Both ways we miss potentially valuable data, but unless the count of 
failures is greatly useful we just count attempts that actually ended up 
executing a nested guest.

The other alternative is to provide two counters, 'nested_run_attempts' 
to count all attempts and 'nested_runs' to count only successful ones.

>
> FWIW, this misses the case where L1 enters L2 in an inactive state.
>
> [*] ed4a8dae-be99-0d88-a8dd-510afe7cb956@oracle.com
