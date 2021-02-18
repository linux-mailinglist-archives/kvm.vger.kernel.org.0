Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592FD31F257
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 23:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhBRWc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 17:32:56 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:58796 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbhBRWcu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 17:32:50 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IMUQk1093515;
        Thu, 18 Feb 2021 22:30:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=vW+73/SpSu+/WtZ8aG65P7qeQkeGxi417Bvvik5fFVQ=;
 b=EFxAtumrLvDhOKYoITwLSamayP8Vqo4Hcr23JZs8z+K/4p7hKYkwO2Jvzo7tIiQx7C34
 2J5sXCCiPi9c6SMfnWhMoBqG2YkGUhckw8VtyopeGf0CbwZMikumVlKxbjmPzLIvItlb
 Q5tq9qjVDiuh1H1pewhq4G7BEWZPRr3lhF59S9xT7cKv/UeAnEXj0FLoBArikoiOVINm
 1w4zow8nwHa2SRDc6YpBZKMn4arquLdcQFozN2/CTqlgfAwjB3q+lmpXWQXvc0H6b5ht
 oRe6OCBHX5YYGTKWNZH+AjadtXS6+l2KwUgPs8uMHcG2Mp5ahCASihlZSuysaH6uT9Ym 3w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36p49bfrt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Feb 2021 22:30:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IMUU4D115090;
        Thu, 18 Feb 2021 22:30:59 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by aserp3030.oracle.com with ESMTP id 36prbrcbcy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Feb 2021 22:30:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/UobslGUN7AEWlcI9D5x1Zx20foTF4JiEMztQ9fW+K5vFoeAsFe20wqxuUGT4FF8Kq3rgJk9AfL9AHQGy3D/ikEcyC/L3ffwjaFLaY+vhRrQT5fz7eTsw+XvdMFTx23j3keWelGFnw5JyKCmpAHttY+ndm3Ld6NGCU6z/m0Luc0g5Rh5EepTEYGRD2jt3IIf9fzczxB95vraxDIH2YuUEYufmdwTfTaLSTjUp9Kl6St6Pd/hzzzrBECjQj/4am1x889MuOMqDc6eS8OKpK0jMAVqZOshFVraegb3p0fDSBAjbicmmpGglpcief8pSEphPNWmOKEQzNC4iLFWRmDnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vW+73/SpSu+/WtZ8aG65P7qeQkeGxi417Bvvik5fFVQ=;
 b=DCMUHc1dKAzo5iwuqG/PDb/AsxG/bnslyqp/6gYDpjO18BaqS4X50yDGH6Wf5aVL/dJhCjLf9za17dFrZg7g2A5wPyQfA8Nw+r4nu0u8xzApMdMRQUz9J7g1fMwndbxdEGxgrOrgWVIfDcXYRFWuUnM/09DApG7pbYHv8O4csc3lpdqUopNdYLIPo+G2GZJHGsV3KwnFSI4EJksZl9GlnXu26XCdVMjqdeMiybyUDKPljSVa9rRvuwTET+7GnuEl7WhC7xzsJbzmatuAGlxE4qZ73asoqCwH9pD/eMtycFt722UZ+5a6qQG2ID5MJkhMBc3Qu8jYijiZEJ7zH2CGdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vW+73/SpSu+/WtZ8aG65P7qeQkeGxi417Bvvik5fFVQ=;
 b=0C9Yw2EWJJI7ChrYWeoJcJ/qbmAhk7YHG2Pv28xSAQuRPAW7biab1f8ndqK2bmgUGGLkCHc+AiOIpPklf0stzCIdu+HAmLVOkc+m/4k4COo9lGSt8NHRO+7wNL2u51GdGH6jPS+BThj0ACDUZVfK66EnHcYmne51IQvkD3pO5rQ=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SJ0PR10MB4704.namprd10.prod.outlook.com (2603:10b6:a03:2db::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Thu, 18 Feb
 2021 22:30:57 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::e035:c568:ac66:da00]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::e035:c568:ac66:da00%4]) with mapi id 15.20.3846.041; Thu, 18 Feb 2021
 22:30:57 +0000
Subject: Re: [PATCH 05/14] KVM: x86/mmu: Consult max mapping level when
 zapping collapsible SPTEs
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Makarand Sonare <makarandsonare@google.com>
References: <20210213005015.1651772-1-seanjc@google.com>
 <20210213005015.1651772-6-seanjc@google.com>
 <caa90b6b-c2fa-d8b7-3ee6-263d485c5913@redhat.com>
 <YC6UmukeFlrdWAxe@google.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <df6eb767-0ae0-84a3-3f05-1ece4cb9ce22@oracle.com>
Date:   Thu, 18 Feb 2021 14:30:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <YC6UmukeFlrdWAxe@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [50.38.35.18]
X-ClientProxiedBy: MW4PR03CA0079.namprd03.prod.outlook.com
 (2603:10b6:303:b6::24) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.112] (50.38.35.18) by MW4PR03CA0079.namprd03.prod.outlook.com (2603:10b6:303:b6::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 22:30:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75c3e32b-3940-4bb4-3a2c-08d8d45cdc20
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4704:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4704F85FD9EAAB39C03689F5E2859@SJ0PR10MB4704.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xuSiLWEgNCd11jYxfkCMGewzY7SDzz1aUh7vNO36cebGOFkitssSECnFQZtR6MLVnXXHKnUcoAwSc2UVJHegpgqvoGYiCemB9eqp6saINqR83AL67byCsappXE+vnqY5y/s1dr1CaYjMa+iHEGlqfegJxdzvPKefn0ZwzYEkZ8cPqWQJOdflenuVH5p3SC+mtJ9K8sC9HX1xJTkoPpxtSaACk4w8AfjjpmfOZ9bX5lt/fq2bsfcsUI6VBzQ0AguTQ4p0lRKAmO1W3N2a/LEaa3hJL5+dN85fTdS2uGzApNyygjKtgC/afGvGxEaYxC6IgRoIYWOt47nHx7iK2oLtLAvKQUY0J8CxM+o12Bm2tgapkuxe/KBIWjiM72T8TopMJ7RDtKFF1iEtWuT/14nIISvlNwvMNTs+4mGpPaEKXQE545p26J9xp5QZe/UgytB+X6CLwpWY/D8n5/q2K6/RagwF8/+YD6q1YNHHdvVMIhnOGyQPYFLcieh7ir32fjb50ZpaNNSYAuC5WdMMb30Nrf+ydOLclGWpiPhdi81CqOmBIs9ubrz1aLhIbG+9RdDSP1MQV/7BAWfmiQnQn3qptrPmU2vBGjysXHOjwGIlc+I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(376002)(396003)(136003)(8936002)(7416002)(31696002)(956004)(31686004)(478600001)(66946007)(66556008)(53546011)(86362001)(44832011)(52116002)(66476007)(54906003)(26005)(36756003)(6486002)(8676002)(83380400001)(4326008)(110136005)(16576012)(316002)(16526019)(186003)(5660300002)(2616005)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QWZ3eStYei8rWFJMMUd4N3JRdEJiaWVGRGdJYStwZlN6VHhaMUdRcG8wMGpv?=
 =?utf-8?B?Y1F5cm0rYUtLNUhZMkxvZnpqYUNEdGlvVFFmcWdaLy9EQklxUVQyVkdMMk96?=
 =?utf-8?B?aUtmS2MyTW83aEtuR3lvNmdPSHlJWTM2dkV6V09SV3lWUEw0VVp5Q0xaM2cw?=
 =?utf-8?B?RWdHNlp1YXZOOXpmSHpBUXFUdmtrVjVCVmtoZXhlR3JIOFNmRkMxVGdacTRT?=
 =?utf-8?B?UnFVaVluRGIvUnhWaTNBN2xNWndKTzk3OCszWFJ6M2x2Z3RxallsNVVZNFlK?=
 =?utf-8?B?WnJqc0l1MmpScExqc3pIUXR0MGlBOHUwWXlLaXBQbWtEMStTTXkzU2x0c3Zj?=
 =?utf-8?B?WEtwSmJKc2tXa2tMcVpMdmFHZEZka0grQ1RvS2xqL0Vtek5ZRnJaWmNxdy9z?=
 =?utf-8?B?ais5S1pKMGx5aUYxb2c1cTBRY1JnWjBpYlpLZWE2UnRPUDljNlB0RXVDYmgv?=
 =?utf-8?B?bVBJcFRYamtKQnd1cjBBdkR4dEU5VFY1M1RxTHNJdktCWVU2RUxONm5CbWNI?=
 =?utf-8?B?V3ZGbkVLOVBSMUxCcjBvSDcydmNDVmtGS0RmdGRyNlg3bXJ1ZHZZVTY1RHIr?=
 =?utf-8?B?TXp1VGh5MUdZRVlnZm9vVktwd3lYb3I2OWpUa2RCelRzVXUyUXkvYXUyVVFh?=
 =?utf-8?B?am1ZZjQzSytDanRJN2VLMCsvSEhmTDBIWFlPOWlpcTI5MjVSSHNOaVdzR1lL?=
 =?utf-8?B?ZjN5c0dYR3lNWlk1SWNUNW9oNHNNcTdNOHVtWUVvMncvWG1kMkpadGREZjhF?=
 =?utf-8?B?TGJJMFhhWTU3VnJRUmVBRVUwWVVrT1NwUlNUaEtuQlhraHA3MnNpVnR2ZXMv?=
 =?utf-8?B?ZCsvM042Qmw2MUJ2c0I3MDZYd0JwRWlqS25nYnNOT3k1YzdSWnBjQnVMUWFr?=
 =?utf-8?B?TFllYWxRWFpLRVg3V0ZuR05KN0w4VkJtK2lxMmNnQ3RxV2tOUjIzQ2VlVnBr?=
 =?utf-8?B?ZFF6SlRUcTFsbXBSR3lXb3FxVmFzTUF2YkF4Vk1oMUJOZDEwNUlFYmxWbXU1?=
 =?utf-8?B?bXRTeURBek5pd0s0cXRGOVhDMlVJc2l2bXhxT3ozczFXdkV4VHUySlBjM1hO?=
 =?utf-8?B?THpmUS8xUFNES3NrQUx3cTYyZEw4ZGM5enM4MUcwVkswOTlkZSs3dGNpSkYr?=
 =?utf-8?B?UVlvMTVIQWZnMlhldmtpNDBObWljVEZPT1ErRkxiZDJWR2pxMHdlZFZIWnh5?=
 =?utf-8?B?aVljRnZTdmR3SS9hbHZ0a3prSVpBMHo2bTZWVUp4bDFCM2h6Y1VreDdSU0lq?=
 =?utf-8?B?S3BRU1F6Z3A4UHJJTmdWYXpyb3VFL3dRMjZCTVpxbHN4OUZXeFNTaldWMGRV?=
 =?utf-8?B?RUt5eExrUzhBQktNbkt2d0FKdjFaSGNFR3FtcEZOT2ZNNHpvUTJWcEhRR3di?=
 =?utf-8?B?OUIydUJuajdGVm5MMENpc1pSazE1Z3IxNi8zS0x1bVpoWVVyclpybjhIRUdo?=
 =?utf-8?B?dEo2enIxOFVKU3owRTY5U3VEK2k2bW1meXlHQkxPRnEraGFsRzRtckxQRXF6?=
 =?utf-8?B?UnRBTUVlWmVsZ0ZnWWM1VlJDTlBKTUhmSmd4d3BXUFg3bytNemRQZFdFWWdT?=
 =?utf-8?B?bE5jZDJySWNqWHErMTdEMnZydDJSbDlVdGFtL0V3WGs4Q0F3NHRFWGJPQi9q?=
 =?utf-8?B?SytQTGNBT1lpUHQvNk5KUUoyY2Q5TGhrSEFKVFNrUnUxL0Z6L0NLVlhySjAw?=
 =?utf-8?B?RlJVOVVCUEFoOWF3WG1oS0Jmd0tuOTBLRGF3R3FXUDl4STBuTFBTSW9aNzFr?=
 =?utf-8?Q?+Q5yts/deGCXqCV59phz9QvzeMAqAxdpffXxkzv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75c3e32b-3940-4bb4-3a2c-08d8d45cdc20
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 22:30:56.9289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZH5BYfb/JTqQI2d3GAScZOiBQXYpght8Gz85hbAvaqH6d4SGbXXE2QXchTPYj6jQgg38f1iFooAfnWcqGFeQDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4704
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9899 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180187
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9899 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1011 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180187
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/18/21 8:23 AM, Sean Christopherson wrote:
> On Thu, Feb 18, 2021, Paolo Bonzini wrote:
>> On 13/02/21 01:50, Sean Christopherson wrote:
>>>
>>>  		pfn = spte_to_pfn(iter.old_spte);
>>>  		if (kvm_is_reserved_pfn(pfn) ||
>>> -		    (!PageTransCompoundMap(pfn_to_page(pfn)) &&
>>> -		     !kvm_is_zone_device_pfn(pfn)))
>>> +		    iter.level >= kvm_mmu_max_mapping_level(kvm, slot, iter.gfn,
>>> +							    pfn, PG_LEVEL_NUM))
>>>  			continue;
>>
>>
>> This changes the test to PageCompound.  Is it worth moving the change to
>> patch 1?
> 
> Yes?  I originally did that in a separate patch, then changed my mind.
> 
> If PageTransCompoundMap() also detects HugeTLB pages, then it is the "better"
> option as it checks that the page is actually mapped huge.  I dropped the change
> because PageTransCompound() is just a wrapper around PageCompound(), and so I
> assumed PageTransCompoundMap() would detect HugeTLB pages, too.  I'm not so sure
> about that after rereading the code, yet again.

I have not followed this thread, but HugeTLB hit my mail filter and I can
help with this question.

No, PageTransCompoundMap() will not detect HugeTLB.  hugetlb pages do not
use the compound_mapcount_ptr field.  So, that final check/return in
PageTransCompoundMap() will always be false.
-- 
Mike Kravetz
