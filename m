Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927C43DE268
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 00:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbhHBWWJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 18:22:09 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:40830 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230156AbhHBWWI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 18:22:08 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 172MFn4w013962;
        Mon, 2 Aug 2021 22:21:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=puJGYWEDYKbbm+XEA5x9Pv7C2Ln2OVp9oJWtmM1H53w=;
 b=obS4eBd4/P/BV6PsPfbdvEZbeAAPWnxTEj5Znj+mDQRprc3YA65iS1/wJJ+MendsKRJg
 s6My2+uy0rf5DYmrfM+7N8jQKZXhs4i2F4K32Wck/bkX6SXL1Xs+j4OQWNz8/BfuXdv3
 rfLCblMZ24spMaqVs4Vhy8ZqrQd9rGRsbDzX/xJTl1wKFgR9YX+jPW/JzR9TwQTaxiL5
 Mf9CDXc3x1OZOUfPL3r2IFTpWTbVfn3kQrcqrBgtDrPArT3ZbtPDHlt6xePTHKQVMLFa
 4+DJKDAck5dgkmKoqyKNd+FkDFOFOHbHbC61lqFTjl3jrX1YZ29uRrfAdCFnnXyNnYvG Eg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=puJGYWEDYKbbm+XEA5x9Pv7C2Ln2OVp9oJWtmM1H53w=;
 b=KqHPhRMv0IlG1b4m4Oc1alsDVnXS0ZVkOHjPZrNN9x1uxylbAloHR9SGiYItWvC0wjec
 SBZN1fXsLJe33ToHdUf4bDCr1mWwVfrHMceWoaysKcGGovgrvIgxGP28i7PTzc4elVET
 l4hW2dzCfZ8xY2XaYlDUKbn6YVIGAH0Mq1Cdnp1e4iOOW6RjILRYT5MoNPMDyrPtWsg/
 DH7GFGT2EIIpmqkeqD9WYgiQDT3awzjdmA5GGReo6wyW+m/cHawOiXvNFsG5Tbqc3DL0
 CUBG2jOxABVT2wtjtauE2+KoylX6rziAIG5NaU1tsgoQ0132Q17S2o7svCVFAPJYY+LX eQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a5wy1jqb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Aug 2021 22:21:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 172MG39u103575;
        Mon, 2 Aug 2021 22:21:12 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by aserp3030.oracle.com with ESMTP id 3a4vjcsbu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Aug 2021 22:21:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kJFZ/wYP8riqXunFUEMOMGp9wduNFkEEqv5Nz9W8CyvgfmQuBSsnobCELlDyXKlZHRn30wsMZttxTi4LyH5FJ7WNbXMX7au0Du1sqPz7BkIv2RJjSX/sry49joh6DMyihUFUJQSaYLEHZIMcPGR1A0enhs9rgwWAe59Re4JJL+wXgLt/Wpfz58IkPg9/+ruPoZiNRYgMr1xBcbtybbTyJ6qqFngcPwytsNozK29kH4ZDq+JPwvlXPQ2KHIP0iteXRb+oIdw2PoUfs40tiWNo+9yK5aQl0FdeIzlP+l+lC6M5wEtQuANQh7EXgaazQD3ALsi/OFZOh8o1L2b0YonzVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=puJGYWEDYKbbm+XEA5x9Pv7C2Ln2OVp9oJWtmM1H53w=;
 b=ZT3PSyX3WSm0g8lyrcz6VfRy0l7IU/NGD4OwsAr25B53tO4IBE1WD0oZdh8S7SCWwlcaECTCE0ezT4rdgbW83/FHBG1Vea+/0V85r8LBFUNuwQbikauHrSQX0Ay2NG1+kKbSZUHrDv/Od4899Bhyu1WPP3ZYtUogirdz7/C0pCc3eTAC0F5qOqiqdNdtQBUGJ+D3rvzy6vdNqBshVXZl4ZQ2AXIxWQ3mESbkV/0tt/Fznuc4b8o60ECpoIqZ2Mk4O5IiEQ8hWc21Y+q3v3LjFQdJhPXNu1157tltrvDUSdZc1FGLzDahTXBnO4fqUqoPge4phY2j7vUCLowLsHkl8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=puJGYWEDYKbbm+XEA5x9Pv7C2Ln2OVp9oJWtmM1H53w=;
 b=Dk+2Ayl6RVjcdo0YzuVAhqAJo+0kpxUIC6sOH+MZBvZZHQT99OcCEVWLd7JLp5GuyukXfsgzgcwLFGvlK2u5oSGhndnHvHbTGCe4cFlxraMLiYggO2DZGFhcFUy5cBNB1ivzOH3PlHEzwmvZVUXHKF8BtE6msS9ernijhM8J1LM=
Authentication-Results: 8bytes.org; dkim=none (message not signed)
 header.d=none;8bytes.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4602.namprd10.prod.outlook.com (2603:10b6:806:f8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Mon, 2 Aug
 2021 22:21:11 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::c84a:b6c5:6a18:9226]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::c84a:b6c5:6a18:9226%5]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 22:21:11 +0000
Subject: Re: [PATCH] KVM: nVMX: nSVM: Show guest mode in kvm_{entry,exit}
 tracepoints
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org
References: <20210621204345.124480-1-krish.sadhukhan@oracle.com>
 <20210621204345.124480-2-krish.sadhukhan@oracle.com>
 <ac5d0cb7-9955-0482-33ee-cf06bb55db7a@redhat.com>
 <YQgeoOpaHGBDW49Z@google.com>
 <68082174-4137-db39-362c-975931688453@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <c0f5ae5d-da93-8877-ce00-ee87b0b3650c@oracle.com>
Date:   Mon, 2 Aug 2021 15:21:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <68082174-4137-db39-362c-975931688453@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: SJ0PR03CA0216.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::11) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by SJ0PR03CA0216.namprd03.prod.outlook.com (2603:10b6:a03:39f::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Mon, 2 Aug 2021 22:21:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7609b01-42ac-4855-9bba-08d95603d4f2
X-MS-TrafficTypeDiagnostic: SA2PR10MB4602:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4602925A0344AAF971210BEC81EF9@SA2PR10MB4602.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: inrnCJX9DAaA2HsN1/KATV+o5VXd7Et6XR65wBElNx2KA/EhWt2frVh0vrUKgM4EJ+fMbInnizrOxqxEGBku/YRiGeClERcyrNV1x+oKPZnp4xQ1+8NrUygZz0XWt3EJtYkXlA/W1ImDxaS4YKSGoQS/7EWHTmjFVGhs4r7r6prb1yt2dnMupbmtU9pHJhkFOscbITaNHvcXiYZq67L9ausphwMDop8y6jEonZyYp9t+GRuCokgNy+9fYLqez5fj95h/Zuh6OyMVF5+YXVfH9XSADGcjFS9z4vPgetJN5gtTatPyXNrpHHyl6bRXhN6x5NAbPOUt1jfAShHSHlEfOyP0TGX64qlZirQ79tEpXKw6C+9+/2cwW7zTb8l8PmzSufwYur2YkfXlBBTZOrBKL1S5D4IRRvA6JlLyq4+oXokdRQtNrXdAQrn/xei3mc7GC6xFCUVK3cLU95oUJ1aJKMuZbOe+K98zopGx+FZK6diTFHtNCNwpIVKkNCgx9G9pFfW+GcWH4498tLD0qnW0zsUkW/JiYWp7pXnmPdLbU7I4ycoZ9/ul5k7wjv1PJTqv1nhnJwXteOAFZ710YvRrEoJg54c9Byj4oc9erF29tFjpftG7r/CABSb5MyQOgJWO8RHnMgXz/iQB1Zst/qRwW5KrJW9C8yKV48Ft2TMyd3Cl+JXIoOZ/qwIBg9LhcNU8PaOfuRIxJCtShl2TnBaSJknjYO5N5w+xebhurxwdae4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(136003)(396003)(346002)(6486002)(478600001)(44832011)(110136005)(2906002)(66476007)(5660300002)(66556008)(8936002)(31686004)(4326008)(66946007)(8676002)(2616005)(6506007)(53546011)(186003)(36756003)(38100700002)(86362001)(31696002)(316002)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UWJhZHB6TExHR3FJRFhaRVp4eEVYOEp5WnQrYWg5c0d5WUxoN05nQjJ0QXgx?=
 =?utf-8?B?c1dRU1F5cU03NFA1M0xCWUFDcDN1cWhjSDFaZlYrK05ldVRnTGFpU3lNeCtS?=
 =?utf-8?B?WFJLYkRDVytndHJVZ2tLcjBOc2lWeXAvbmRnWnJvWUl2TkVCQUYwNmxoSGdP?=
 =?utf-8?B?ZGxQVWNENU1YQUsyazFrWXBhcDJQRkUxbS84c3pmRXRVVTMyazJYNWFYcmRl?=
 =?utf-8?B?UUptSFB3d0V2L1d3bDB1WkE2S1MzTy9aTjBJdVE5NDJQY3VqY0dSbTl1d0hN?=
 =?utf-8?B?WWNvV2NWR25GMHZlTklsUzBnd2RZTmt1N2lBcStPRldXSXgzUTV1VmFiclp3?=
 =?utf-8?B?blZIMjkwZ1hCbVNFMG9YMzdnNkJnbFkzaWVNUWFmQ3l3ZXFQYXlwYnlVNlcv?=
 =?utf-8?B?amVlOWEzNFdpY01mbC9keEJoOU1pQTU3V3NGZitnWWFJYjBZU3ZiVHRFNkFQ?=
 =?utf-8?B?UzNWaDdmam52QnZ5NG8xNWVZMVJKeEdGRnh4ZTBOQ3lpMHBLek5aaEN2ZXFw?=
 =?utf-8?B?bU53NDN4bVBEb0llRzRNbHIrUFo5UzNRQ3RlRGhESnN4K0FLL1RyMzFvai9t?=
 =?utf-8?B?TENjcW5RUCtZZEpJZzhRbVYwZlQvK0FmS1RGNlNIWDQ4elQycVdjWFByRTlj?=
 =?utf-8?B?QWhCQ0dDVFNnWE5nRldsMEgreW9CaGVaaUFlRDU5Nk51UXNjK3laOGY0SmVB?=
 =?utf-8?B?b1hLRnB3dnBVN1hTc1FCUVNyVGIramZEYWROWHNGRkFMaDZtSHp3UHl4YVhP?=
 =?utf-8?B?cnVCeVBUR3JDbVRQT0VpZDVPRzFvTDdyTW5WVDEwK2FqWlpVK2FQODg3ajdh?=
 =?utf-8?B?bFo0MmN0WmorajhWS2UvbnBKZnNQeWNmaVU1ZmpEUC9zUDdiWkRLbmswK2Jz?=
 =?utf-8?B?UHVzYlppNU1nQ3BoVldCYnVXRjJpRW1pNit0cSt5Vm9vWmpRekphbDR4Y2hp?=
 =?utf-8?B?cnNkQ1dCRXN5V2ptdHV4ZUpCWGxaMHVMUEFjK0xDTTl0LzcrOC90d3JlWFpV?=
 =?utf-8?B?L0FkK2ZIRlFRNXJWRUpQWGJtVEg4bC9NQVVxTlc4YXlTOHgzaHBUODVsRVYw?=
 =?utf-8?B?SytnOUlMZE42SXd2SVFKWlQ1LzdlZ08yMVc0NHZkWXRoS3Q4YVY3NXNFOTlj?=
 =?utf-8?B?d1FJc3IzUjJwUUJRUS92bVg1SDFMaGtGRWJ2bSt1S2JlclN0T2dEcXZkVzBO?=
 =?utf-8?B?UXhjU0ZzVkZiaUI3NTI4L25LbDNsSUp5MXcyNzIzaG1qTXloSnhPUno4NHBW?=
 =?utf-8?B?TmFTdXNtRmxsQTdFeTJDc0lXdU1Ic2RPRG8rRGdQMG1KSmk0T2F4TkNBTGx0?=
 =?utf-8?B?YmFlVWZ1VjJoWEorT0JwNW4zcVowQzZvUWdCbk44dXhYdjUyUkNHeExSenV3?=
 =?utf-8?B?YUo0dWUyellqNGpKNkV3SitGS2ZQK3Y2NlE1cm1wSWp3TE50RXBBSVZXN3J6?=
 =?utf-8?B?R0RhVTh2NW9oRk9rL3BRS3ppUzB3SUVOZ3hoZWN1UHA5c1VvNm41VHd2MGxk?=
 =?utf-8?B?b3NxU3RWc045Q2hIWVhUSTUzMmg0alAxRGRKZkQ0WUNPbitHeW4zRVZRU3kv?=
 =?utf-8?B?U0pIVmsrZkF1bTJVc0Q2OFR3L294T3dKMFlxL05zejducVdTQVFWaDFDQWxX?=
 =?utf-8?B?M2hPa21HeUpaQzFSWGtyb0RKVEdseXFxbmVldWNZMTVVR3JzSmxSczFSTXFX?=
 =?utf-8?B?Nk9ldElnOEVFQVFDbkI3OWpzMmErSk5rcm0yZWx2bUFmcklFcVpBSENiWUJ4?=
 =?utf-8?B?WThnbVdRWjV4bUtXTTFWcGFRZzZPQ212aFBldU1vSStEcWZKSVEzWGMyZjln?=
 =?utf-8?B?R1JLenBXSlZldk92V3hYQT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7609b01-42ac-4855-9bba-08d95603d4f2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 22:21:10.8704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jjdm25ViRIU6to9X3LaX0zTYwotcRzZuew7vMrZ7xQw+6UOSZqdyG3QGhTNPAZ8xwz0wYuwMfqivs+J0HG6PvZUY+X6JbHQr3AaeAY+PfFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4602
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10064 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108020142
X-Proofpoint-GUID: Hlx9NQ4nfryBogi8I9-4nQrovWTpTYR9
X-Proofpoint-ORIG-GUID: Hlx9NQ4nfryBogi8I9-4nQrovWTpTYR9
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/2/21 9:39 AM, Paolo Bonzini wrote:
> On 02/08/21 18:34, Sean Christopherson wrote:
>> On Mon, Aug 02, 2021, Paolo Bonzini wrote:
>>> On 21/06/21 22:43, Krish Sadhukhan wrote:
>>>> With this patch KVM entry and exit tracepoints will
>>>> show "guest_mode = 0" if it is a guest and "guest_mode = 1" if it is a
>>>> nested guest.
>>>
>>> What about adding a "(nested)" suffix for L2, and nothing for L1?
>>
>> That'd work too, though it would be nice to get vmcx12 printed as 
>> well so that
>> it would be possible to determine which L2 is running without having 
>> to cross-
>> reference other tracepoints.
>
> Yes, it would be nice but it would also clutter the output a bit.
> It's like what we have already in kvm_inj_exception:
>
>         TP_printk("%s (0x%x)",
>                   __print_symbolic(__entry->exception, 
> kvm_trace_sym_exc),
>                   /* FIXME: don't print error_code if not present */
>                   __entry->has_error ? __entry->error_code : 0)
>
> It could be done with a trace-cmd plugin, but that creates other 
> issues since
> it essentially forces the tracepoints to have a stable API.
>
> Paolo


Also, the vmcs/vmcb address is vCPU-specific, so if L2 runs on 10 vCPUs, 
traces will show 10 different addresses for the same L2 and it's not 
convenient on a cloud host where hundreds of L1s and L2s run. IMHO, the 
cleanest solution is if the hardware vendors can provide a UUID space in 
the VMCS/VMCB itself. Today, we can print the UUID of L1 (by getting it 
from QEMU), but there's no way we can find out the one of L2.

OK, for now, I will add "nested" for L2 and nothing for L1.

