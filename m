Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD8A3231EC
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 21:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbhBWUMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 15:12:38 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42810 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbhBWULq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 15:11:46 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NK4KM3091502;
        Tue, 23 Feb 2021 20:11:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Y+uC3TCZPOHarn5SUfcM0sfZUkY2wilbwi2xA5wafes=;
 b=UgcNk6amx2a12po7mNATeTxsylepxQgtdb9+fnfDFodqn9vKVttol+uU8olZ1gAGYtjy
 ERNyjBsUCoLN77XpdRB8xrchfccC9MoniGovRhVOgofGy9bAqI23H3FePoa2V4SIWQRG
 PMdYtrLHblaHWURVpHKK37mdsiFn0g2C/0E0JPC9gAFHEoSMvJ8WKzQpfRCeqGDAEMfr
 HAqlU6+30nGHsifxDOtZkyvVRfI9qWZBipoDopDXqNIftXSDwuf0Nyty3KVFcF6k6B6s
 nzdKq9cKax72sGmSqS31q1qFzyWirprwxoULV6DtrDjsE/GfYRGTc5HnL1LsdxPXDSoY 6w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36ttcm8puv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:11:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NKAaIq121179;
        Tue, 23 Feb 2021 20:10:59 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2043.outbound.protection.outlook.com [104.47.73.43])
        by userp3030.oracle.com with ESMTP id 36ucbxyf28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:10:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FV/bbMh6t5JuwRioe3ttS72Qolz4qIjQW4lw8j+84MTB7XPiM5vMuWpXG2vZtIUEUDwnO0byhV98Xg7581dn7R/OLqeB1I1FITf5XkrlEebOzZ4gdedgHD7KPfo8CwwFIsamEfY0TcG7hXP8+jy9PgXY5jSWIIww6tCnPSgFFf37D5Yf7Z8O96DqA09BPqKwaLP4ziwStpZqUkeFjcK95F2/0RSD7gdBTp45keGUQz1MTbOk7W6OrsTdYVwrCkmAbR4JuPz0OPselItTjhDh3cwv2LWsZaFQLJMCQkgSPR9IcYeMPRENT4hRJeEkqSuw6wOpTBHyB4DJp51d9A3vYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+uC3TCZPOHarn5SUfcM0sfZUkY2wilbwi2xA5wafes=;
 b=Us7sXP1tuv8axoDx9cgroHQlo8AaA2+N7UEpVfEF+fVgcBg+ch0iTi/KlgCd8AQleU8Ds+1K31A813/tbPAQtfcjtGd46w88IcNUul6Pn9nMdsB0+Az8MUHUzfHVVQJgpm4kSTl0DbGyYVDHBBSODU4jV+3XmXWWMycPzzlqbCtFpMkEoCE3AyRjoyVrY4NRkZaEo/YiloVq/SzzZ3KixebAlje00Dsj65+TPur9RfqcDK/fxz/CiELn5gJMImau1qr5RWHJAupJqyNIUDjhgAyIh3OaVJlvGJ7Zo3dLxI7trOyDyANNWxcIWgZDMv5J4wKPwJuyh1Cc8f00Ggs5aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+uC3TCZPOHarn5SUfcM0sfZUkY2wilbwi2xA5wafes=;
 b=DLboR7uHAcykZIn+VSsYK1ZnpTEBTm10KfQZVeebaCnUuJy/wXNs+qDkWT+aEeXt4NeEbHd2ebw8lDPs6l6ix2bbPpIPn4OINcHnZ8uDK0ojnA3W81zSFG5yAj7zZ4ineEmFsXl8sAUpV0Ztrl48+KuMlzC0AxvqndRREOZg490=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4538.namprd10.prod.outlook.com (2603:10b6:806:115::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Tue, 23 Feb
 2021 20:10:57 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 20:10:57 +0000
Subject: Re: [PATCH 2/3] nVMX: Add helper functions to set/unset host
 RFLAGS.TF on the VMRUN instruction
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com
References: <20210203012842.101447-1-krish.sadhukhan@oracle.com>
 <20210203012842.101447-3-krish.sadhukhan@oracle.com>
 <7599c931-e5a1-1a49-afe9-763b73175866@redhat.com>
 <4022ce07-c1cd-0124-6874-6c40b1a9a492@oracle.com>
 <78820a68-402d-ebbe-7070-a5b916fb2516@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <6a2585cf-9ffc-0137-4184-75ac2bd1685a@oracle.com>
Date:   Tue, 23 Feb 2021 12:10:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <78820a68-402d-ebbe-7070-a5b916fb2516@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: SJ0PR03CA0195.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::20) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by SJ0PR03CA0195.namprd03.prod.outlook.com (2603:10b6:a03:2ef::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Tue, 23 Feb 2021 20:10:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb1dc58a-81c0-46d9-2844-08d8d83721ad
X-MS-TrafficTypeDiagnostic: SA2PR10MB4538:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4538DB5A34F0F0F1A8CF6F1081809@SA2PR10MB4538.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SqDDSyniw22UNmb1TgrcKSTtbLCammlun/q5d6M8qSa7AM/DcPU+xxbbxd4OnFgt7jMXYQmggPnkazRQP/q/Z8U70vbhAs/XkzZpvl2JqRX9gnUD9c+fz7m5tDTL1ozbfL2rPogU42AE+Al+HavKec7C4m7Tw3oUMDUiGzr7h793ZES2IIc4rrRzHz6UjU3vXiGP/sxLLcKOp9mJNYrNteu8s3NLSlK5Z+JFnyUeNfgol3vJngfHWZ9nB8PB4J9YN6GHFNSTDaf8PrLA/g/vezqTsvKfeBKmBZre9BVDVbabnk3V5TrDFT7uDskddqBQuFDqKT34Gbm6BWml8yHtjIpC1JmV9/w0Lyh5MqAI6SFRYOZbDyEyvBxVdIy4ajfkNsZxAHS28XCqcVyNA8NvUoFcOW/2PcIAQzz5DdcxOmA11qxXabNfR3TVjKKu83Kmn5WbRAUFLBs0pvYQBkQYvlGeJGX0VNVVi9pY6ilS5WbSytEAcv+9XhRn87LICXrLL20WXOiRoQDByql23KSHh8qRJVYk8M3eOZ0uY/5+44iDUTfCp7bCxBviSkT77Zzo3pWQ7HfZPDeJCTnj8UzKckz8T2C+2SoQu0XwwemZm7s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(376002)(136003)(346002)(478600001)(36756003)(316002)(44832011)(66946007)(66556008)(66476007)(6506007)(5660300002)(53546011)(4326008)(86362001)(31686004)(6486002)(2906002)(31696002)(6512007)(8936002)(16526019)(2616005)(8676002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RDNQSmZ6eHJ6b3Z6cVFJMVpPSk5rQmZGb0FyRncrWVQwWGJSQjNBR1pPSkto?=
 =?utf-8?B?QzNDVGFLVE5zczNVL3h6K2c2UnFFUVNMdVFYV05ZYnRDenA2TU9MOHRPbkNP?=
 =?utf-8?B?cmtXbFZrTU5HRk91LzN1b0puejhuaEFLNDR0R1ZLeTQ2YkttMmRoTjdkYk5Z?=
 =?utf-8?B?dlY0Vi9GSTQ2dk5xUGJjeHVyc2VCeit3SnMwQlBBOXlwakQ1YnlUL1FmVWNN?=
 =?utf-8?B?NnZZUVBMbzVkY01jaVJ4RE1CYzZXOUVETnF0ekNENS9Wb1JzQlBnaTk5MkJK?=
 =?utf-8?B?NEVhTVh3RmdsOEJya1RxQW11YXV4clUzQ0VpOXJjSnV1enRQYWoxQUR3NlEr?=
 =?utf-8?B?c1N6UFJ6VGRUa1JtRTg0MUVQOE5Xa0drSERYbWZ6Yi9LSjlCZmxZMkg2ZG5P?=
 =?utf-8?B?RVI3M2I3M3lVbzNWRFpzK2lIRGVFZnlSNURraTFPeDdONU0vRmRaa05DdzhJ?=
 =?utf-8?B?NmxhUEZ4dGhhQjZIQVlkbTRVbzJ1ODN0ZUZMdmMxRGVaamVqYkhnK2VjNnVj?=
 =?utf-8?B?TjRHYXl5bFVSSnU3UDQ5bVY4QUpWWjV5Q1d5c2V3bkFjVWlGemdnNXlSZnRo?=
 =?utf-8?B?UDJKbXdPTExNeHZqQzFMQldrSXB2QXRQS011bjI2WUFvbTBVSklmZ1g5ci8x?=
 =?utf-8?B?TEROQTVQZUtMbWhKSllpTnkwcjRtcDFFV0VMU0FhUjBnTjkrSVBFTWlXWFlo?=
 =?utf-8?B?VHFZM2cwUmp4VTVnVXhOM2k3RXhTRlFLREtRWjN1am5Tckt1RjAycTlSbjdy?=
 =?utf-8?B?QUlXRkcrNHQ0bkJ0ejVzQ2J1U2pMc0R2R0JXbGxGa1loNUZyTE9BUisyNkdS?=
 =?utf-8?B?RVhMZnhxVVczby9WVGpzT0o1S1daUllUWVU2ZTlEMlEwS0xUcTJOcTZidXVH?=
 =?utf-8?B?RVlzN1M5S3l1NUV5aFBjV3pXazN6eXhwNC9LTkwvaWZ5V2ZGQjJSRUJWbEhl?=
 =?utf-8?B?T0M2Ykp4QjJMZXlKOXA0YllCZUZNU0krblNhanJ2YVlPYlNiVThhUzA4aEhU?=
 =?utf-8?B?Y3FIRUFRekJoaHNtalhkOUQyNzB3blQxSFFKWDg4Tmc1QUFSRUpYbStQMDVF?=
 =?utf-8?B?dlV3aytHN2pPaDZKVVQ3YkorQk1sVGowSHdHSUVxSE5vcmhMenhBUmd5Zjdx?=
 =?utf-8?B?ZHQ1eFZFWEtlN29JY0xpdmZJVU9DR01FcktxaDdFTFdUOWU3Mnc3SDJJRldM?=
 =?utf-8?B?Uzc3a3lYdHIrQnBxV0NZTWRZY01Bd0x5Wnl5dHFRODN0UXJ4bGUyTjBOeEJk?=
 =?utf-8?B?QWxCbFJLeUFMcWZFTWQxM2ZTTDM5STd6NGxqTGpnMkk0M2VQUGszdmh5TlRu?=
 =?utf-8?B?cExwSVpud095STJaVk0wT3NzSndLQzRlRXlmSDNTL3FzaFVJSHlmR2pNZnhp?=
 =?utf-8?B?YklKc3o3bkNlVVk2Uk1LMTROYUdsT0hKd0ZvUUZncFMyTzBQREFDYkxZRkYr?=
 =?utf-8?B?b2VFUy9hbnVXNVVqRFlUb2NOMkxkMlhYOU01VXFVOU1TSUd3aXh1aGRUQXRL?=
 =?utf-8?B?ZlRNS1VEYkJwalpNZjRxZmZaSEg2bUhtc2JlNU05VEZ4Z0pyUVBNaVArbXBK?=
 =?utf-8?B?QVBBVWVYWTlUVk1ZYU0zUEVVMmNFT3o2Z0ZTVHczdHdHeXh4YnZ5ck1RUDhF?=
 =?utf-8?B?U1ZKdk5wTUx6SEJ1cFRvV2FUcG5XMFJRdHgzalJwRFZnQ3F5cUtvS1ZOL3pp?=
 =?utf-8?B?VnVrZFNiTjdDUjA0eExyOFV3UEVSNEFzUU00QmsrenM1bzZXU1pvWHBpMm51?=
 =?utf-8?B?dHF5MXFUUm4zamVYamV0TWxYSVhxenZFYndibFh5R0pzUC9PYjZaMXBrejNM?=
 =?utf-8?B?NDdLcTIyL053U3V0TjJtdz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb1dc58a-81c0-46d9-2844-08d8d83721ad
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 20:10:57.7259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tle7PZNP36qaL1QU8lKwkf6aRX1Xy3OWnAupQKWzi6ZZvY+PUThkLu2+rJyB/dLDgtedgZcIEE7Z+yuaK+m5nnsDxARDyYZb7FYaD2wsQUg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4538
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230170
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230169
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/5/21 12:21 AM, Paolo Bonzini wrote:
> On 05/02/21 01:20, Krish Sadhukhan wrote:
>>>
>>> I think you can use prepare_gif_clear to set RFLAGS.TF and the 
>>> exception handler can:
>>>
>>> 1) look for VMRUN at the interrupted EIP.  If it is there store the 
>>> VMRUN address and set a flag.
>>>
>>> 2) on the next #DB (flag set), store the EIP and clear the flag
>>>
>>> The finished callback then checks that the EIP was stored and that 
>>> the two EIPs are 3 bytes apart (the length of a VMRUN).
>>
>>
>> Thanks for the suggestion. It worked fine and I have sent out v2.
>>
>> However, I couldn't use the two RIPs (VMRUN and post-VMRUN) to check 
>> the result because the post-VMRUN RIP was more than the length of the 
>> VMRUN instruction i.e., when #DB handler got executed following guest 
>> exit, the RIP had moved forward a few instructions from VMRUN. So, I 
>> have used the same mechanism I used in v1, to check the results.
>
> Where did it move to?  (And could it be a KVM bug?)


It moved to the next-to-next instruction and it turned out to be a KVM 
(SVM) bug. I have added a fix to v3 that I have sent out.

>
> Paolo
>
