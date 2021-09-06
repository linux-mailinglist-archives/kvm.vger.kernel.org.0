Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13581401F68
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 20:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbhIFSE5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 14:04:57 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:47062 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244369AbhIFSE4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 14:04:56 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 186GSuvH028664;
        Mon, 6 Sep 2021 18:03:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=DihQvp1oh2lgTsz6RpAw7UOhzyalUdKTFKuwVtJY9nc=;
 b=yd06W7gfgZuOU9t5YNn7PQQNVbRHUkjP+1laO8xyQyB+VcrJpJ9ttlmYm3wNv4MGwGGj
 UN4RcdlmYNmvkPTDxxMQ/3LVzlT6v/u5PJiWdPT2Ud9dMXRyCRwU+/J22yNX0Ic5X18t
 4np968yHAsFmGlZec39rrSz2zV2A99mfcNPBILNrABY50JrXxPVbWpr0+aUgqtNLcBp2
 62Wi/QRTw1bR0t9yC6Osff5r3+5FXfNJOlQdYl4MVubLnHJLlbifXX99brUEu9pdbAb0
 wnIyTb/fETQ5D0l6jD2Tl76Oj/kualsXBsi9fMgKFtRIH83+cqxH3D1U6c0gnPEyJ0o6 YA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=DihQvp1oh2lgTsz6RpAw7UOhzyalUdKTFKuwVtJY9nc=;
 b=ubXiEHIWHaJc8n8PW1WMNrTWZYr3fzP/ptTZxnSt/egYNP+BILlvlYfba4tFqzhJh14L
 m1/wmdqd7B1y/ZWY6FOYSTu8nQCm1GK1yCgEZob9if+V3bGnqcsNQ4MLEzLajcZt+iup
 UREKz89jUrwIDkH+IgoWYjAI9fUo7oh+iJ4IQ8U3nPrMG1fsUgCnH7773oQ89BnjwUU0
 zGe/d08SQdoB9R22VyxGXn53lQBJm5Lnny3icnlHyoXEQ6z9aOEsKyLqyv8SQSAGSzcm
 bNtNNQPJPSwcj2JTOiPkFTsURYnqSdopG86q7RrE8bpxRsSjSovS8sLPQM4oyV6mzwqr ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3avy77jn71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Sep 2021 18:03:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 186I0AJS005532;
        Mon, 6 Sep 2021 18:03:44 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by userp3020.oracle.com with ESMTP id 3avqtcnp3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Sep 2021 18:03:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GOBbhjdFYgmjKYrL9EIaV+JKO07HDeiN896NsYK5ntAyGlHajMgtXVcD9BeBEE+k6In7WugWGQqr33TiqiwdLGg9DoJseSd0hqucorZ5Js+RaZ1E1mvd/IfUbgmOh63RM2MGP45ikVz5hlA6oWM3HU/5PuvL0UAgpXvxFJp0YVv863rnCTTukeH+l/nUtWNk9RG7yzlma5Zqu3wJ9fxQBntAcpX75ttOyBxEmt9+/2ByCK0eN8VgdYtzjyWAv6/e0FL1EkdbsZtVgJjtEv+BZP6J7wHajvezIx+F3RnW7CUr1S64/E4eQGJfTbnsY4eefJIvNuyvIyNpFOUXw6cdLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=DihQvp1oh2lgTsz6RpAw7UOhzyalUdKTFKuwVtJY9nc=;
 b=mH726d7vczEsihhfF95Z1KV2P6cUtRYVbTFlRxhKT416ABBn2BMMfpBoWjKr06iSuTrfT6mtRHA351JDuH8ACNKOG5AwJlwNcGgMf5inX/oqz9rqMPGk3vDIZ6NMAE2N0dxI/vAogVQWb6DZeUr2tQ6pCbGnc7EIVHrAwyVTgWJHZmnotC+Dc/QIGFiV98WJF1wTtG40qFuY/zlKeakWRll3HbuW7oqIxWBk61WQigdFdHKgzLMrpYNbdx4CIVjVGmbnA36zZnoTowD8rc6BLAB47KeHKhx+seAwWNKpz8xHE+sL4ZaUJNrJKr6VS3OSWaivkmBkR/CW3SNSeZyJ/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DihQvp1oh2lgTsz6RpAw7UOhzyalUdKTFKuwVtJY9nc=;
 b=GGc+a6FOd+wBkEQ8BInSlvOrH3XlwwYxQ5r9mV+xWrrT2uYl304pBRe7iLBH2lVrzGQ2cnVGzyHpirdySMoOZZa0M+AsneBMgp+uj7kLGZ8EqkHZgrAO7IYuU2+vmMYW+8MO7fDaamZNqKcMfW5ikNG7vQmQpG1nC6M0jvT6tm4=
Authentication-Results: lists.cs.columbia.edu; dkim=none (message not signed)
 header.d=none;lists.cs.columbia.edu; dmarc=none action=none
 header.from=oracle.com;
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH0PR10MB5243.namprd10.prod.outlook.com (2603:10b6:610:dc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.24; Mon, 6 Sep
 2021 18:03:42 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::18f4:28d6:63f1:58e8]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::18f4:28d6:63f1:58e8%5]) with mapi id 15.20.4478.025; Mon, 6 Sep 2021
 18:03:42 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH 1/2] KVM: selftests: make memslot_perf_test arch
 independent
To:     Ricardo Koller <ricarkol@google.com>
Cc:     drjones@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        maz@kernel.org, oupton@google.com, jingzhangos@google.com,
        pshier@google.com, rananta@google.com, reijiw@google.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20210903231154.25091-1-ricarkol@google.com>
 <20210903231154.25091-2-ricarkol@google.com>
Message-ID: <6082c051-03f1-653d-6188-b09974c62512@oracle.com>
Date:   Mon, 6 Sep 2021 20:03:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210903231154.25091-2-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR03CA0075.eurprd03.prod.outlook.com
 (2603:10a6:207:5::33) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.175.250) by AM3PR03CA0075.eurprd03.prod.outlook.com (2603:10a6:207:5::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Mon, 6 Sep 2021 18:03:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30f9db95-36aa-4d79-bc6c-08d97160a97b
X-MS-TrafficTypeDiagnostic: CH0PR10MB5243:
X-Microsoft-Antispam-PRVS: <CH0PR10MB524365D9FCBE27BDE8F02D25FFD29@CH0PR10MB5243.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HN5rf425KQd4FQJtI9OTipkJiT1DNTWFn0xYZ5YTUZYG0Osbrt4QEsKcjEm/dwWh++BeJZTGdcwqjHfgnNmtu7sQzk/u66oMkzKUP3gIJiKpXDurgFsNH1M9fSe6zpzyap7um1aypH5Y8pH6dPv4SNZekfMVEkZl1b3BnyRUFn1sZVcxA3zk40k7HOCDhxPMhpfpZ119Z8bzTcg2aoSXQlj0PguCfkkn9pfGF330zCV3Evd1ldqYVR3UrWgngFCLOXy9UEwbKV+B9RuLn8WzS/CVVhfZUJ27YCsUbObXbZRxK+dcPPfkVRx7svEQBudxPpmijgYNuOuklSmWZDLQUdiWjLmTxVkvNPoIvbEuVjCcaWBHwg9u2vvGmnVaE6In9SHo2j5iqIMQICoxYL0FFWfgrUfPmJi17d/STyGJeeEuDHqccfX4G16GoR57iXx7czAg/NFFcAF8Rr5RvcNR6IPmJUTVt3RzCbuVIQPDXAvDWvFeVaww3RLoU2g4r78axy0cw6PohNuckLEomS1D7t9gxMw9s0d6IfZiTph+oitcrHS65NExsCeKCW9NcB8olnvHo7AqJb2D8I7wT0iFHdoMGYNzncU2LJ5u14iNhwFsxuB+FkEnUNNeF/uqoymiS+1hWLLa5/X9GkR+sdCQ/0bUyUmhG6U6TTRn49RSH6o3AvOssnuQo+3PifjnhPzaPDdhDvfQwKDnocnWGMHE+xW75GTYj1a/V4/7B9QXwjA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(39860400002)(346002)(396003)(53546011)(2616005)(8936002)(7416002)(4326008)(31686004)(38100700002)(86362001)(5660300002)(31696002)(6916009)(36756003)(6666004)(316002)(4744005)(8676002)(66946007)(186003)(6486002)(66476007)(66556008)(956004)(26005)(478600001)(16576012)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Sm1uSGdmQWI3dVlOMGNVcGcwWUtuVDlHdit5NXd6SW9nOVhGcUxlNVhjbzQ3?=
 =?utf-8?B?NHA4Q0d2bTBMRDF1TUF0SHY3UjRNeUhvMENjTkpvVW5icHN5S05UdXNBR05n?=
 =?utf-8?B?T3pDRUxnSXhVL3liLzZRMERtWFFZcUZDZXFMdEZYNVVmOEtLTGQvaTdSNG9O?=
 =?utf-8?B?ZUxNbkNZRG9UajRxSWlBS0x6aFI2QlRaeHg5MVpQTVB2TEV1LzhwTUJ4Y2NH?=
 =?utf-8?B?MktVTUhzYkx6RTNUV1JpZ0NUbWJBNUVmSmNUV2hzK1FEUzUwV2swQThDU2ZV?=
 =?utf-8?B?NjJ0UWpMM1psSWtzaExpUk5JVENkYldWamF6RGRndzFqNDVqNkNYbjhGM0pF?=
 =?utf-8?B?M0prSVNHeXMvTS9zaEF5QmUybEhJTWVZNmk4TVNIeWxDM2hNTnJBc0s1UWNJ?=
 =?utf-8?B?cGRUd2gwV3JKWTlaMGxYRDc3MjlMcHdMbXg1Vi9MbTBzRXlnN0NoWFJBbVRD?=
 =?utf-8?B?Wno1RmlqakxnWW52Vkxvd2NiMlZzSXhOQWVFNE9DakRhbTJSSng4Rm12ek1N?=
 =?utf-8?B?RVg1ano0azh2NTBzY1FkZmgrc1p5WUZxUUhQTWhsWHZvWnpuVzgwUThWWmFO?=
 =?utf-8?B?VWhaaXFMOTBZTmh4UlJRS2tpM3cvdHh1WFhIL1YxeGhjKzhzWmU4RkZ5TXNw?=
 =?utf-8?B?Rm00MDU2STJBNy83ZmFmdm5BUlZFNVNUcS80aFpVWTMwL1VEWVF1TG5LOTdu?=
 =?utf-8?B?cDcxK1dPOVE1YlFPc3VGeGR3WCtwcDhIakFTTXlFNzJ2MWlhT3NoODFpbUND?=
 =?utf-8?B?N0Iyck9zekhTamFlSzFseUk0Uk5wVEpOanBMbXdwaFRpcjJqS3BiVWpBdnFD?=
 =?utf-8?B?NWVIaml1RDNOc0dTc1dVRzZLZjBMejVVQU5uVy9ILzdYRkI0ZE00OGhFZVpB?=
 =?utf-8?B?R1Q2OXQ2T2tKN3ZFYkJOTmE4b21ucVROS0pwMGJ4Z0EvdHUxV1BVc1BBT3Bo?=
 =?utf-8?B?bjI2MmFGdUR2RFo4MWcwcHdmZno0a1kxTy8xeWRaYkZRYVArdzVIR05WUG9n?=
 =?utf-8?B?VmtwQjF0ankvck5yZkI1SDBJTnN5bzFPalMwSUZmcmlMZFNCRXBEOHozbHJ1?=
 =?utf-8?B?TjNlTHV1QTJQVmFrSnJrTFVIVnhZK09KMDFvV3pJY2g5aVk1REtMcGFCZ1B5?=
 =?utf-8?B?V01aL0dnY0ZkWWNrYzNRYkREd2RMTXF4TnEyNHdRV0ZNT1B6RzY0Z0lNWUh3?=
 =?utf-8?B?YzY1dGpvOWsxZHYvWk9yTzFHd1dKU0tlUm1TRXNEa0w3SW9waWdnQ1NSUXlK?=
 =?utf-8?B?UTNwYzhQYmJOYVJNUVQwelV2SnhOYVRwUDdEck16NTM1ZlZjK3I2ZnoyUjk5?=
 =?utf-8?B?QjZQQW5OWmVMaVBWRVI3cmVHa2tDWGhYSGc4dVV6NGFISTJnMlBKQXNubktl?=
 =?utf-8?B?aG1FckNZQUlua1VGZzlsMnIvU0ExZiszajhBZjlxUFB2L3hMSTVHWDFTcEV2?=
 =?utf-8?B?Z0tlOE9aanZZRjN0RlFObTc1Q2xRa2JoVzF1a0FRenlrZ3N3dkFIZE5TV0x6?=
 =?utf-8?B?Mi93TlBmTVRyNlpUODFsRDc0QXM4d3htRnJycWZIOFE2Y0ZyY0hKK0xacTRt?=
 =?utf-8?B?UmZpZTVuRW9XaG5kOUg2eEpoK1VjL3hyZ25KNkYyRTI2NC92NkVHUFl4dkNO?=
 =?utf-8?B?Z3o4WUltY1FLTzc2L201NTNHM1g4U0g1ZnVQMmllSGlSNzRndkM1cXpEZ3l4?=
 =?utf-8?B?cWUrUEpVZWJXTExkVFA2K01HZ1dkck1oOHdWcVovTE11OWk5eVlGRk5BdHR1?=
 =?utf-8?Q?rn48ajG7ykmJJjKHXoEzM+Mdmm/bY9FszHYQssH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30f9db95-36aa-4d79-bc6c-08d97160a97b
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2021 18:03:42.6312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m5OjfSgTqAPKYW6t/mJRsu1175sAYWBoYJxsnVdtxQKyG7l/OKIwcYG+lTAfjF3jG4P8Jpd512WR2dWgwZSHEQEVmG9LW6lBWr0WhRArxZs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5243
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10099 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109060115
X-Proofpoint-ORIG-GUID: jfn79EwcB4W31k_b_dXNf1uxzkX5qD4t
X-Proofpoint-GUID: jfn79EwcB4W31k_b_dXNf1uxzkX5qD4t
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.09.2021 01:11, Ricardo Koller wrote:
> memslot_perf_test uses ucalls for synchronization between guest and
> host. Ucalls API is architecture independent: tests do not need know
> what kind of exit they generate on a specific arch.  More specifically,
> there is no need to check whether an exit is KVM_EXIT_IO in x86 for the
> host to know that the exit is ucall related, as get_ucall() already
> makes that check.
> 
> Change memslot_perf_test to not require specifying what exit does a
> ucall generate. Also add a missing ucall_init.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---

Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Thanks,
Maciej
