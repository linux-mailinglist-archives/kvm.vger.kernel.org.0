Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B900536BB62
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 23:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbhDZV74 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 17:59:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59606 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbhDZV7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 17:59:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13QLnipH063862;
        Mon, 26 Apr 2021 21:59:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=2kkfftmIy9bmENkekUJAj1xfTNt9c4h8n9m6KNP8O8Q=;
 b=gXqeedthZrLI9VQhekoJPbuFUeU/2Kqmp87WOmk5oSTtbAROoVQbsjaSgjOQdNidN1BK
 DLmbZ46XkEv2zP5304wCgAzEAGyntqgieedCrYvGyjT5MiFOkuVYxakt30W5u2y5m+4i
 +ia6MvFz97vRAOhDakURh3A89diCBocmkwSEJrAdf+te8dWamunNfaaIebTIjMc8fSm3
 kyaO/74SmVsMTCRHMylB+wQ8uKWh/3qyNC+2De3edlc9viIY3fYAVLcsgRue5DuLb0Wx
 d6Bxqk3f57s+1Js+L0QWVd2b1NWG4ctnPEVbXp9bOlUglZB78ZOHp6ujlNPkq3fD4ySt jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 385ahbkjr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Apr 2021 21:59:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13QLoPIW165877;
        Mon, 26 Apr 2021 21:59:08 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by aserp3030.oracle.com with ESMTP id 3849cdtch9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Apr 2021 21:59:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ALC/Jh6rL2IF0G3Ae7OKwXj2hpbTF+APQHAZ6PqZ2r89ZoJlG9RG4UNGHJr83BUQNllURMr9KXCaNurk9b7Ga/1oz6rE/4QUreOMUt6hOu7jW+P/LnxWsvu7N0A9MqLDCARTvPDARV+EjfrfCBK9vBFDt58yFjc/Cj2x5JLmsV+pMDGPDKNUFfOsOJa3kvElqjP0zZJD7rjtj8KmBRISIO9Z4QLAYVwlzIKLWBUvCeNAZNrwiP6gAyyBFzMLEfkpPn1xlKGoeRZ0XXZlhwhHXwrRQpOcQRMSW9yGzp7TTtC8R80ZxrJmaavFWhQ1DU8yGM7reju/hfWaATwfDrelZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2kkfftmIy9bmENkekUJAj1xfTNt9c4h8n9m6KNP8O8Q=;
 b=KsL8jDUaI8l8brNG0sjQIsAxo5uWkMF8iw4e6GOUQ14ntUBWKfJzi+XPRtdMPrzIMrmwaXpAuQudCvWOioT8AQfT1iiYXjV1l8Ylbs6iUq0ObzSIGHAmL2S814hdFvFRLMp9Yj5WlJLZR6aHeEgcNFaZzU3qlEY9PHc+RCWVtbP8+95D6C2Tgcr9OQJ5ogvcjCHuu2hATo72+bRfJljLfVAMmR7PtuYoJHjr0fhyfBPVraF6EJJlHurVU9tw79wc90DT7/RKhwOaZt3ssYOGUnfn35sZQEFP5odji2FrmaXnZDnqLudANIzVlT91Wx5l17mIpj5BEeCd/Uh0SEAkJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2kkfftmIy9bmENkekUJAj1xfTNt9c4h8n9m6KNP8O8Q=;
 b=fUcsYvwVGl3tf8yvMS5jWkBUDf6wL3AP6MHvEED/yryj8PgJ04rA2ZOvUzwUSydAhnr1+Uc23tLf375Tc7wz99lR0/xsiiHb7A0T150jOicfSDZu/hiBFwVqUj1n4jNblqGAhIi+fgcpAYIh8m0pnzVUZ3snbt46DGw+tjy3yPE=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2623.namprd10.prod.outlook.com (2603:10b6:805:46::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25; Mon, 26 Apr
 2021 21:59:06 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4065.026; Mon, 26 Apr 2021
 21:59:06 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH 3/7 v7] KVM: nSVM: No need to set bits 11:0 in MSRPM and
 IOPM bitmaps
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com
References: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
 <20210412215611.110095-4-krish.sadhukhan@oracle.com>
 <YH8y86iPBdTwMT18@google.com>
 <058d78b9-eddd-95d9-e519-528ad7f2e40a@oracle.com>
 <cb1bb583-b8ac-ab3a-2bc3-dd3b416ee0e7@oracle.com>
 <YIG6B+LBsRWcpftK@google.com>
 <a9f74546-6ab7-88fc-83d1-382b380f6264@oracle.com>
 <YILuJohrTE+P06tt@google.com>
 <d6bf17a8-029a-37ec-ab96-5e2bebedb88a@redhat.com>
Message-ID: <0b239edb-acdf-f0c8-3712-6afb38ab86a6@oracle.com>
Date:   Mon, 26 Apr 2021 14:59:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <d6bf17a8-029a-37ec-ab96-5e2bebedb88a@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: SN4PR0401CA0025.namprd04.prod.outlook.com
 (2603:10b6:803:2a::11) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:7446:8000::ae4] (2606:b400:8301:1010::16aa) by SN4PR0401CA0025.namprd04.prod.outlook.com (2603:10b6:803:2a::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Mon, 26 Apr 2021 21:59:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79a1677d-b422-4dee-f875-08d908fe8339
X-MS-TrafficTypeDiagnostic: SN6PR10MB2623:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2623A588C4BF83E0389E74B281429@SN6PR10MB2623.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TNP/mO8XD1Dr3Lot84NKlKsO7bYlcVZ5jvK5E8/qnrCN0+N1kjDd75uWZ4M/VgwzmmDew+sYGDvnuT/XcvhSXNMY8eUSTfpNmA2R4IE/0e6Skuv8sdLwO6B+cf2/dMLUuzyqP4WYM73RO2M8wjSHowPILmTr+jgMEgWN8JU1G0ScLigtYQnqAImUYqC3xOKv7A001nwx7UDG9B9YwyxoWgYNRXzNuGLimPXwAxm7kSv/H6IA6cWabvYy7YS4sZ8Aa7Lk16YuTkJo+Qq4kdnW4+wVu3g6FGkiQ4Rep93RsHOilM5+kcx8mHCxvRvoM/w1HLQN37fJr032QS6gXPClq8rNvuhh46WMDltismG972CJGGqhMdhOdoa963XV465btGjs8TypfuUwAbbHjZ+BJKajon+z7qtMqQ0V5ECi2ptnR1Lapl65rvQIoYqPe87XmdbPkPYLWeNUQ5982n8oJX4w06uQXhKM5upTdS4uKZ8+zIrU+vXoCPWsp+ATGVPAQYztRqBjRXQ4UurwukL3xJbRAFVihqOZsGatr0jdHIarosQ/WRIOUWnXD1jSY8AjyZJBaExt+iPYk3ryh+PqcgTYER0Aad/rX1HyzJ00ZmOpw5IXQddkAiK98o7ziPhvWByRcZFEKNhLcv8uQpNP+fL9j4Hfmrht7SyIx6rXoZlfRlgbz8inmiOwxoQ8f4GQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(39860400002)(366004)(136003)(38100700002)(83380400001)(86362001)(110136005)(316002)(31696002)(2616005)(186003)(2906002)(4326008)(8936002)(478600001)(16526019)(53546011)(8676002)(5660300002)(36756003)(66476007)(66946007)(66556008)(44832011)(6486002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cC9xY2ErZnBJanFDb24wZEh0elU0WklBdjRpRmtmNUJlZGhQS3hUbFRtTHRJ?=
 =?utf-8?B?OUFkUlNWbWpYY1l2bnNUeHE4Y3krRStYRXAwd0NTTlVTS0p4U0tnUTllYURi?=
 =?utf-8?B?dWJZNTJ0WWhicjA4TlVWUmpVMGNveVB1ZUwzWkxYYUlYWWdUV2wzbVJId0t5?=
 =?utf-8?B?TnRQS01UcHVOZE5uS2VyNk9DWXJaa2dxZ1JWdVNlKzZxd1VsWDNmSURNdTlv?=
 =?utf-8?B?bE1lVjlnS1lRZVdINjdhOUlnanU3ZXQ2U2o3VE56ZVhVUGZDTmhYbnIvZEtX?=
 =?utf-8?B?VGNDVkZ4bEdUc0tvamlpWElScmFORWZGOFRCemtyVlpxL25rdzlDT1J4NmpH?=
 =?utf-8?B?VFE3SW5hNnpqS1JmZUh5SFB1YmFnaUpoQUlVMmV1QWg3YWRJZE9xbE5TdDY5?=
 =?utf-8?B?N1plQWpTbVp6TFpUbktZZk9Kc1kyOTgvWjN1WnVyWEZpdGZVUmd6VkIycTFY?=
 =?utf-8?B?SWk3WDZ2OUs4OXV5aFZIVkJ4Y0NvZmZKaVkwK2ZZWnBnKzRFZmNmbEhqSEZI?=
 =?utf-8?B?YUd5eWxxT202L3VyaTJnYWNiYkt5Z3o1Z2djbzJFekRRWEt1dHhPUEdpc0h4?=
 =?utf-8?B?alpvU042UGkyRkVKcnJndmlvd3cwdVNzUm8rQzlQRVdyMkVxZEc0K3Y2VzBw?=
 =?utf-8?B?MkIyU3BlQkNQRmVLRDdaQk83empNSTc5S21mNTZZL3ZMbFltOFp0VTR5QS9G?=
 =?utf-8?B?RG91QXhJVE9CSlRvSW5YUFg1QXRBV0p2S1dVbjF6TWhNVTJuWnpPc01BRk55?=
 =?utf-8?B?ZW1OWUgvbktVbzc4akswOHR0TEwzR2NzbHlUU0N4N3dQUUxCQnBpendIK0Iv?=
 =?utf-8?B?eUlzS3ZOd242dE1meGh6VVNtaW5qNWlOL1c2b2JWRkVMdWxDeHorODFnTjlZ?=
 =?utf-8?B?TE1RcVJDdTZiUmxwOWhmcW9SMlMyS0ZSdWlocFpQbmRiZUdvRHQ2S3kwb0px?=
 =?utf-8?B?UjdOR0VGS2JJTFhmYmE0VU5yalNLTUVCeGtRcUtXU2xYYVZSK0RwV1NJblJ4?=
 =?utf-8?B?bWtYVFRBandIR040b3BIN0RXNGJBYzJRd25XTDIxaFc1SWpxNVplekc0S2xM?=
 =?utf-8?B?LzliMFBFYngyc0Y1OHhrY3BXOXNRckp3VmJOcGxmcENRQy9qcVRBNmJoNlo3?=
 =?utf-8?B?MTZJR0laNWMvRjdLTGkyaEJyQytPUlpyMmpsbHVaYmZOVzhvMjBZMDFiUmhy?=
 =?utf-8?B?MmNYUWVYT1FOaTdvOFJwclNvR0JtWkswbWZNRXRlMzIwNW5HRVBldnNwVDJI?=
 =?utf-8?B?cWxVTWRDRFBQSFdVdXhVRjVDVUVLZ0tHQUZ2VCsvL3J5YmZ5Z210WVg1QlRK?=
 =?utf-8?B?SEQvSDZ3Z3BuZEp0WGNLVUVkbkNVU3RoNk9lYitVNXZKdDlFWkQwdFYyU0c5?=
 =?utf-8?B?WDdFeVgvMmk4Q3hNNkYyTm5waXJvT01OSlhTWkpBd2FFQWVhRW5Oc1Vsb0Qr?=
 =?utf-8?B?SXZpSUdxWVBtanRCZSt0MmZpVFVsL3Jqc21Teld3TkJvVEJIclE1Mi9PVWZp?=
 =?utf-8?B?RnhhWWVyWTcvZjVoZ3ZmMFBpVHRLY0F1OE9wdU4wbFVWNDFSU25lcDJML0ZR?=
 =?utf-8?B?VW0wcHluQk1Bc3h5T2FQL1hNVE04ejE3RDF1OXM1TUQxU2IrNEJZS01VRXFK?=
 =?utf-8?B?TFpQQnR3RDdRYkJacWpJbW8zcmlhUTVRWEFEM0JmR0tnS1N0TlljbGFGWXFX?=
 =?utf-8?B?UHBIOStTc3FhYlVCNHJCWFFIYzlJWDAyRVJ1cGQrcHg2WVMrNWd1WFRKUlRQ?=
 =?utf-8?B?c2t4NFVhNTVpR242b1BrN3RDaWhqMWFCMVU0MThYdHNZUG1CRzF3L1FYU0Iz?=
 =?utf-8?B?ZzZWc085cS9Mb3hrY0szUT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79a1677d-b422-4dee-f875-08d908fe8339
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 21:59:06.7664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eIK27vSnMZLaCSAeL5SQHHh7/KbG1GD7h92fWRdwiXbdFWbw/Ntl1nv+wXs8v9rBLeo7G0sxM+PVGxl4nCND/Td98mbhQs6gaNl5w9ctM1k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2623
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104260165
X-Proofpoint-GUID: Dq8_ZRlFAcJrMkfvRu74EQM_vkGMLqWt
X-Proofpoint-ORIG-GUID: Dq8_ZRlFAcJrMkfvRu74EQM_vkGMLqWt
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104260165
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/23/21 1:31 PM, Paolo Bonzini wrote:
> On 23/04/21 17:56, Sean Christopherson wrote:
>> On Thu, Apr 22, 2021, Krish Sadhukhan wrote:
>>> On 4/22/21 11:01 AM, Sean Christopherson wrote:
>>>>         offset = svm->nested.ctl.msrpm_base_pa + (p * 4);
>>>>
>>>>         if (kvm_vcpu_read_guest(&svm->vcpu, offset, &value, 4)) <- 
>>>> This reads vmcb12
>>>>             return false;
>>>>
>>>>         svm->nested.msrpm[p] = svm->msrpm[p] | value; <- Merge 
>>>> vmcb12's bitmap to KVM's bitmap for L2
>>
>> ...
>>> Getting back to your concern that this patch breaks
>>> nested_svm_vmrun_msrpm().  If L1 passes a valid address in which 
>>> some bits
>>> in 11:0 are set, the hardware is anyway going to ignore those bits,
>>> irrespective of whether we clear them (before my patch) or pass them 
>>> as is
>>> (my patch) and therefore what L1 thinks as a valid address will 
>>> effectively
>>> be an invalid address to the hardware. The only difference my patch 
>>> makes is
>>> it enables tests to verify hardware behavior. Am missing something ?
>>
>> See the above snippet where KVM reads the effectively vmcb12->msrpm 
>> to merge L1's
>> desires with KVM's desires.  By removing the code that ensures
>> svm->nested.ctl.msrpm_base_pa is page aligned, the above offset 
>> calculation will
>> be wrong.
>
> In fact the kvm-unit-test you sent was also wrong for this same reason 
> when it was testing addresses near the end of the physical address space.
>
> Paolo
>
It seems to me that we should clear bits 11:0 in 
nested_svm_vmrun_msrpm() where we are forming  msrpm_base_pa address for 
vmcb02.  nested_svm_check_bitmap_pa() aligns the address passed to it, 
before checking it.

Should I send a patch for this ?

