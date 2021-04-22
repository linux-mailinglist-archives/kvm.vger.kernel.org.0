Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB9A368639
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 19:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236882AbhDVRvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 13:51:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52928 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236459AbhDVRvR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 13:51:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MHoNSs090660;
        Thu, 22 Apr 2021 17:50:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=zqHgqV8hLXafHnU5PaJCxzZpKHRhBArj7ZavRz3akz4=;
 b=M/aGPZ02TDclloU/o4wu6SdrAtM7EASr6iG8SY4zhncNfaUiYgXkJtLR3m4zva85Jkra
 cjyNjOG8Aqvs/LgbOGuQ5v561yX1kSw6pI2rqOp4lJfYW/Ms3530BruSMPcXFjSoWByh
 vCsTK6zN6yJlvoqdfKWO5WOJ+c/AaElbeRl5PCiDHWTJY1U1UcDOGVANiL6KfNt7ZJ7G
 YGVkho9jbce/l53Hx9FMJ3x1MkhMWvOOim3edCk98omcNeV+uX3wUKMJwfP11RhY1qFb
 sZ/6wNBuk347yMeEUF+whbblp5SfBy8IJ3I9Q/sgCIrK51iZflNQuatUg4wFuwlvH22z HQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38022y5kpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 17:50:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MHfNPk150361;
        Thu, 22 Apr 2021 17:50:27 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by aserp3020.oracle.com with ESMTP id 383cbd4g20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 17:50:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZWrs7Y/6WLS0nLkJiMLMRPYxwtTJ8CXwmQ90mRWdiojNy9Ju/W0wERaWFdpNpLfPezoHfQcjFFUan94b3QRbyfbEpwEVbXzuD0u7DR8HjyYr7axwbKtY7zoUf2RZU4H8dLjNBaoGBFmMcy6IXa9CQT4n4LI8C63VaJyp/TLfuikCW0NGYP2EuE4QlRns6N8xbq/d2ck44N2j3pebF3bGSXxGu8yskQSCj/CWx7nsSoIWHZSlS3PoehM+Jq35/sVS6rn1B4sFAEnE/sILHEX+auckY+NMHR9w71j6dNR1zg7+/MAnniTzN2pitF1XdYMuZddc6YIrY0VZDYsKJ7rsjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zqHgqV8hLXafHnU5PaJCxzZpKHRhBArj7ZavRz3akz4=;
 b=EgI1/Ul7l1hsmyPtiwDx0uWDwCcR2apEE31DzGVO2SEBkfrWT9OzF91MOQTQ61yKmUZbR/H4KcsdRZrYNxwJ67qTeS3GxYNTg1VMzBgBK1KVrcV8F8xEWAKAqGfAofHGl5Hz8EMm4C9ItMbFvOySqXiMfRkfzSw76oTD40OKX1x6AX34ccGpgfppm4m/ZM3ACuCnCxR/aWNoAcdmoA5qqkVM6fZpbUjCAK1mirwA2bsKurf8dP7PUCllxl/SxeYRV+40fEWMGBiM+arZICtmOKp9ObuJeFDIgO461V+d1gOYsNl/aV9yPfhtom5eV0+wd0G5IFhas9h8lxx3WYjAGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zqHgqV8hLXafHnU5PaJCxzZpKHRhBArj7ZavRz3akz4=;
 b=yCY0u7lSkWnq0g8HMLISH1Xgposr11WZZJL86ury/gv9B5XVpUD9pXmHFezcFYeNcTksytTsK9neYWIBYN4e6bkWcYoofPz8Q1MTJSorqaxWhkx1fGEg1Pg+NukAejbDKqYfYCI36ovFDZONPF5haRZmHqnwIzajrepNykdFAEk=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4426.namprd10.prod.outlook.com (2603:10b6:806:117::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Thu, 22 Apr
 2021 17:50:26 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 17:50:25 +0000
Subject: Re: [PATCH 3/7 v7] KVM: nSVM: No need to set bits 11:0 in MSRPM and
 IOPM bitmaps
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
References: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
 <20210412215611.110095-4-krish.sadhukhan@oracle.com>
 <YH8y86iPBdTwMT18@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <058d78b9-eddd-95d9-e519-528ad7f2e40a@oracle.com>
Date:   Thu, 22 Apr 2021 10:50:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <YH8y86iPBdTwMT18@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: BYAPR11CA0079.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::20) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by BYAPR11CA0079.namprd11.prod.outlook.com (2603:10b6:a03:f4::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Thu, 22 Apr 2021 17:50:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84a4daaa-09bc-40a5-841c-08d905b71c15
X-MS-TrafficTypeDiagnostic: SA2PR10MB4426:
X-Microsoft-Antispam-PRVS: <SA2PR10MB442610AAF30889FD613C612F81469@SA2PR10MB4426.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z5ey73aPOp41Ok9JhCJ07GMXdsNKTIoXvlY0MbNQ+IkzhcCpE/qz6DKIiUR17i8qitusVviV7lddOo9M0j6wTXGwPZjaAfYZsQmLL59SYs/tJLBmNkuZE2cS4dYTmmtH1d96NJXLbKvOJdDxFuhSot0upgqxUj0wZazArho8QXUYHyUNS70zsiwjUd3YsRgGxVM0DW5aD4xK7ZEV+0xjhiVHn3wBleRCYqaNNpdmF4tc4KIZcm/YjeYpTyEwKhCfNnZgeWQKQgbdjohDPS9P1s6gEFzalVzXxwSRa1fZPvAtM6wPb8wItges8+b0nAVx6hkIYsfB6YPx89ReC8m4xyyy0IHSouCoqKtXN24TtP9Gkm0+2m/IEL/W0XrUyN2oOyS8bVI5WS0UdCJSfo0p+hq4UOM84gfuyzDUOJKJ+JehIrKke3rmTItGoT4AGI2IoWctftzwqRdGt9aZ4mcIvYCpqn2cAG1m9/mSHAPJi7n0swTxcOUAj8JazSD5Q0s3q3v172zmK19nC7mS8D9tYcee6tVEBuD3AVZCmoalRXs9p5DlXCA+6OzrY7w6bq0+BeSEsiwOTg24svtCeYqqk7giyQ6Jy6tZJsAlLOO1vaSlzWovV94hnNphcUoFducY5d2q6RCVVgDWusLksk6v2ak94RpRRQw35vr675vjV7lpHAq2KxKuWB0gZnls7pTq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(346002)(396003)(39860400002)(36756003)(478600001)(66476007)(44832011)(31696002)(66556008)(6486002)(6916009)(4326008)(53546011)(8676002)(8936002)(6506007)(186003)(16526019)(38100700002)(6512007)(316002)(31686004)(2906002)(2616005)(5660300002)(86362001)(83380400001)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Z3UwMkYvdk5mRUYvZXMzaFRkREVQWkRoWE5XMDU0K2tHU1kvQU5lUUEyb1Ry?=
 =?utf-8?B?enlNYVp0L21Yc1gvVHRzWXlCbENLc0VkdEVPRWIvaHpEdWV1WThCbXYwTWVz?=
 =?utf-8?B?Q0hESjJET0libnVzUUdoU0hVTDk0a0Fnd3dYN2hzL3BSTFBZeDduaUt0QmV2?=
 =?utf-8?B?L3RzMW1nblNmM0t0U005bTVwODlPODJRTytFdWM2Q3U0NHRTdnVmQ0VrWEhY?=
 =?utf-8?B?bkQzTWFONmxubTlyQ1I2V0QxMVhFcVYxZFcyeFJ5cy9wNjdQL21hVDd1S3Fi?=
 =?utf-8?B?SytGUFVnNEc0VHM2S05pZE9kL01LVGU2K3VJMS9XeWZ4Q1lzazRJUG9ZL2pM?=
 =?utf-8?B?SnNiWEcvT09QMndJOHAwWHcvTFdpb3NPT3hrR2Y3cllrY29oVVVJenRSdEQ3?=
 =?utf-8?B?WDV6bm0wVEdoYWNJcExlU21vUXV4SldGZmEwd2U0RUFuVDhHeHoyMGdKTlVZ?=
 =?utf-8?B?VG1kd0huNDVoeGZDUmdId05qZWFyWFRXSUR1eVJZTHBJYVJLVllXMUp4V3Vv?=
 =?utf-8?B?UE5aV2FWWHB6cEsyYXRialpwTlJRZ0c1bzNMd3dhRXBJQUdPN0ZhQUhjanBi?=
 =?utf-8?B?QzJvdU5RQTdvdG82c3RUNGxVdWIrcmFUK2F4TEtNaE02NUsyY2Q1a0tILzRu?=
 =?utf-8?B?aElUc1VqbytiYkU0MzRLWnNaSVJ6MHZyWFRPbWRJNzBaTjVZN1NGMlFjYk9U?=
 =?utf-8?B?RWVyU3JTTzhReFU5OFo0bU5LbTlPU2tXYXl0Q3ZZYXNKaUlZdEVyemRqRHp2?=
 =?utf-8?B?RlZGMW51Ui8zMGNRRjZ5WjRhck9mLzUrSUx5Nml3R01RdlBwaGREcGNhc0h1?=
 =?utf-8?B?VDVSamF2Q1UrdTRld2V6a3BGTnp5VHVXckpsV0NIeGx6aW1PRVNES3l3N1VG?=
 =?utf-8?B?YStlc0YwN2d0ZVczdnU0MHF3NDdpQldWOUdUNzhMblFHeUpaeS9BUFJKYmpm?=
 =?utf-8?B?cnJoeWFLamE4RHh3S0t1OEtSeTRQTTZ2TlhBR3dndkJmejY1YjQxU0UvaUZ5?=
 =?utf-8?B?NE03bHEzejRMdTF5aXRlTTB0KzlFdUgvZlg1ZGV1MGU3bHdNZGxsSG1UVzB0?=
 =?utf-8?B?MlArOU5GcTVqWk9oS3JSaWF0dlpONG5Qbk4vdzBFKzVkbUp6T284MXllWmZ1?=
 =?utf-8?B?T0JoL2xxV3NQRGVMcEtGeFgxWGtmWW1yekdiNGtXL0l3SjBLdXVneWFNMzBY?=
 =?utf-8?B?U3ZtUGFkcGJWd2ZrWStJMzlvYU5lTGw2RzBISklPaElheTIzS1hQejI1WkxL?=
 =?utf-8?B?QjZIVUswZGdITWtlbDJIS0cxTDk5a0xqb1NER2JFSGlyalBwNnVPa2lsVzZw?=
 =?utf-8?B?cDFwSW1pZ3RndUZEdWI5LzZSUTVvaUEyZlhmV1VsaE9PUzk5Ym5Hcm1zQWpp?=
 =?utf-8?B?N3ROeXpXTDNqSzM5Tzl3T3ByamxDQmNUbkp2d1VSd05RSWJiVS82OVR5WVll?=
 =?utf-8?B?SzRJKzdrYTFZSVFqYUZibGtJVFVSSVl4Y0F4WjNqUjJWUzc2aUNGWnlLOENJ?=
 =?utf-8?B?NUV3STBWbyt5QjhOSGN3cFdXRzFabVB0Z1lBTDlPNnA4NlY3VE5OUWV3VzJa?=
 =?utf-8?B?cDE5V3o4SnAwV1I1K1VqOWc2VjRWMklvM0Nhd1VySkxucGdXZWpsQkxCRnAr?=
 =?utf-8?B?dG1aMHU3U3ZMZ1J2c0hlUnV3ejJPQVBUTzZFZjlkMWRPQk84N0FDWmE5Szlq?=
 =?utf-8?B?bXNBU1VNV2RHODUvNit3SHNFcXJEaE1VVkJubUZMRktiRzVCd0k2cDVHV04y?=
 =?utf-8?B?RHdwVWlWaGx6R01pQ3BqRlpDQ0NFUTlEQ3JLeC9TSkZnQjQzVjZiWXIrdkZI?=
 =?utf-8?B?ZEUzZG5yUWt0WEFOOXlyZz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84a4daaa-09bc-40a5-841c-08d905b71c15
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 17:50:25.9221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2HAv2CNvqknCqS6C2Gn3qFMXsMp+u6T4E9sdranDvDnab8JC5BDi5UL52M78OMNxiK+iEbj7fhUwa/PgS0An0pzfsDXDxtxRa8sXfa5o+RE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4426
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220133
X-Proofpoint-ORIG-GUID: vb5jwfQtJ1gsUAG9ip95tUWBeMFPcCDi
X-Proofpoint-GUID: vb5jwfQtJ1gsUAG9ip95tUWBeMFPcCDi
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220134
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/20/21 1:00 PM, Sean Christopherson wrote:
> On Mon, Apr 12, 2021, Krish Sadhukhan wrote:
>> According to APM vol 2, hardware ignores the low 12 bits in MSRPM and IOPM
>> bitmaps. Therefore setting/unssetting these bits has no effect as far as
>> VMRUN is concerned. Also, setting/unsetting these bits prevents tests from
>> verifying hardware behavior.
>>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> ---
>>   arch/x86/kvm/svm/nested.c | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>> index ae53ae46ebca..fd42c8b7f99a 100644
>> --- a/arch/x86/kvm/svm/nested.c
>> +++ b/arch/x86/kvm/svm/nested.c
>> @@ -287,8 +287,6 @@ static void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
>>   
>>   	/* Copy it here because nested_svm_check_controls will check it.  */
>>   	svm->nested.ctl.asid           = control->asid;
>> -	svm->nested.ctl.msrpm_base_pa &= ~0x0fffULL;
>> -	svm->nested.ctl.iopm_base_pa  &= ~0x0fffULL;
> This will break nested_svm_vmrun_msrpm() if L1 passes an unaligned address.
> The shortlog is also wrong, KVM isn't setting bits, it's clearing bits.
>
> I also don't think svm->nested.ctl.msrpm_base_pa makes its way to hardware; IIUC,
> it's a copy of vmcs12->control.msrpm_base_pa.  The bitmap that gets loaded into
> the "real" VMCB is vmcb02->control.msrpm_base_pa.


Not sure if there's a problem with my patch as such, but upon inspecting 
the code, I see something missing:

     In nested_load_control_from_vmcb12(), we are not really loading 
msrpm_base_pa from vmcb12 even     though the name of the function 
suggests so.

     Then nested_vmcb_check_controls() checks msrpm_base_pa from 
'nested.ctl' which doesn't have         the copy from vmcb12.

     Then nested_vmcb02_prepare_control() prepares the vmcb02 copy of 
msrpm_base_pa from vmcb01.ptr->control.msrpm_base_pa.

     Then nested_svm_vmrun_msrpm() uses msrpm_base_pa from 'nested.ctl'.


Aren't we actually using msrpm_base_pa from vmcb01 instead of vmcb02 ?

>>   }
>>   
>>   /*
>> -- 
>> 2.27.0
>>
