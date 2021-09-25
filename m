Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC107417EA8
	for <lists+kvm@lfdr.de>; Sat, 25 Sep 2021 02:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345794AbhIYAoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 20:44:24 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:56088 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233410AbhIYAoX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 20:44:23 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18OMTGXk003522;
        Sat, 25 Sep 2021 00:41:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=yVbhW96dKXOzC0dsNN3DHZoxX2pR0v3AAmsExkVByOA=;
 b=Osn4ZDG64O26UqdlS1SrHAoDYxy9yJGYo6xKkZSBmqNaH0HeIgjeJD0LFYbLhlEYd7N3
 mSXabg1T+EaxhX7wmktUKkC3NQd+Sv2Fx/OMboUkbd2ZufkJwkyoWHDui0k6Eo6I/3Or
 hgv1J3Qx2r2A0cmjknz/vK9hG2g1Ep460umqoGIEgefVFvoxu9SXnz6NaSsTADLOVuOY
 7Pqu+o197cLxDob95Si0zDy9BkspLoNuxwAKmd4glEF9okns4VPs1ALyNXbG2+HGa7jx
 4+pEBOkHarZERFRLL44H2injdsJ3z5CpB30fYTgZ6dS4VayDaMkP514AvLD3tYcPUcox MQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b93eq6ft2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Sep 2021 00:41:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18P0ZgiU166457;
        Sat, 25 Sep 2021 00:41:53 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by userp3030.oracle.com with ESMTP id 3b9rvrgt6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Sep 2021 00:41:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cNj/n4ynQVRuqbF+WBKSbl9LJhPXJ6ab1OGHsjy+g0mpXUzepZ01ni+iNAtkjTVIVd2pGd1JgRuytpo6KIrYs3KNF5q0Vs3bF+w1z20Xt9Nq/VNf64ZiPqe/TB30Brar5Kz/Z4l3b/zC2hWH8eF0Gz/tgl0783GbRNplkuURh9WGbPzJGNYQeEFU+wtwsTCcu7hBv/VPMnm6aw+eFBtfU5Mi/xuF8mxZ54dZnJnB7uSQ0jV5jSd6rPLClwFuVzqjXaCWFwlQWqOihmfqx/+YiZlOzs2LiMaDQQfu3tRR8/Ql5ZAEmo8LUjA+gFPEfxFxOKXQTbBUJGzyMTO22BuyHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=yVbhW96dKXOzC0dsNN3DHZoxX2pR0v3AAmsExkVByOA=;
 b=mrMIP0pdxyNZLbUmU9JyuQPktPCFvk6poKterwBGG1QH8qSMIyjHTwYBuzcYlS9jRI7wEZBF1rkWeKMFm4XWpEDVXdaJNthpN1P/dOX3gzYTGpbYm8qSYX1Q1cdQ769tABRlwNqJMPyaJdbpknfjEf4om4HcFyblQdGHQ62bmA/bmRnBwzUwWZESJEfXZMh2naBBYfcul+4MSqyOYfS0Xgaad1XRXgFxCI/16nuN9atvx6NGECG7Te8RXtfBSus7CnIWSi+sFWOv2gEp0/oNfuig6d/Wm58XVA34m8bR0+G9CGlw9gGp7G9+leQWYUq3R9RaDSomLBxTxcptefFkGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yVbhW96dKXOzC0dsNN3DHZoxX2pR0v3AAmsExkVByOA=;
 b=My80/vz7tAElfRrkjyQK+u56/5yIv/Z/z2e2tPt7f3DJIb5qdah1XrZv9uF5crOBpo/sOKXRcWf88t5YkE/MqDoiLO0Wn9lm7Vhvdb5z5TfsFp9rBcXTDC9gC8rHpgRMrt5XK5jZ2vbXr3jGybI+7iUKmIYHeeoYZIfXWJD2tm8=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BYAPR10MB2951.namprd10.prod.outlook.com (2603:10b6:a03:84::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Sat, 25 Sep
 2021 00:41:50 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::39ae:71d3:1f4d:b4d]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::39ae:71d3:1f4d:b4d%4]) with mapi id 15.20.4544.018; Sat, 25 Sep 2021
 00:41:50 +0000
Subject: Re: [PATCH RFC 1/1] kvm: export per-vcpu exits to userspace
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org, joe.jin@oracle.com
References: <20210908000824.28063-1-dongli.zhang@oracle.com>
 <YU42b1iwIpZS0iCp@google.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <287241e3-5a5f-3a36-efc6-3d2dde7c10f3@oracle.com>
Date:   Fri, 24 Sep 2021 17:41:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <YU42b1iwIpZS0iCp@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0071.namprd05.prod.outlook.com
 (2603:10b6:803:41::48) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
Received: from [IPv6:2606:b400:400:7446:8000::1bc] (2606:b400:8301:1010::16aa) by SN4PR0501CA0071.namprd05.prod.outlook.com (2603:10b6:803:41::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.7 via Frontend Transport; Sat, 25 Sep 2021 00:41:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6772e44b-235a-4049-d6d1-08d97fbd4352
X-MS-TrafficTypeDiagnostic: BYAPR10MB2951:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB295180A290ADDF8B8187C843F0A59@BYAPR10MB2951.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K+Sw3zWVLoykNbtXEw6A2007xe2/48rS9l1+sz9EJaJs77dA/4NUG/dmIbpwv3ab/rvRz/WgF8tTVf+LHA3xmgsDDFLud96B/AvmeP+TgAKnthP5JGduft4n9AP76JZR1cSEY57laNH1q3Z70BgyQmcIUJLTmFGlUyRCYRUFjDP4VtnR/CPDfs3AUtgbpM+urSCUfAKzrlR4A2na36IszelxjytjucKStwqCrvbG3I6tXMzxEGsi+kAB27p3GlRMjHBCmfUFYdtqDbj75PUoztSCnX63XphabE1txBvMD9dZnzJg/EG9/OCz++smMxOJoszx+QYyE3Q2QnDAJbCY6QDRA/TOhh06MCVTuj1Nogm83+vrQvU3ZemKKYUUySzn1IPCdbuMl0nEOgvEnxPh1M97Wz07d3IJ6dtkDIZ5vI/3CnHNBmCxpsYfdsdeer9GhVH8Qonu0gDh69zN+DU0hyBF0wvh7BZsge4ynrAyrc+0z8bJgelz7bIsuXJvL1KED4NXbg6r4UxRzvxLEwzG8tob/TxLcgzIf9pNmoEU/H1xeZ8b9u6oTxvT+cyNIJGauFBJx/tBAvaA5nTaLGoDr+XYz6wmNm6RMvML+l7Dee5GxbVDbYsr+Ckp0+xESJTjH0pWChN9AB1WQHdbpvCTX2/hq84iEtpnA8PSXz72H+fFjRdPO2ApETgLQibxwYWjz4TnyJjnesTQShJL3Hcy5iD9vrBFGHcgO2Ue5/L6v4o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(8936002)(83380400001)(38100700002)(107886003)(6666004)(66476007)(6486002)(66946007)(53546011)(31696002)(186003)(508600001)(36756003)(31686004)(44832011)(2906002)(7416002)(316002)(2616005)(86362001)(5660300002)(6916009)(4326008)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VkxQSlh5ZHNCR1VtTHlvZGI0NWhaSk9HRElZZlJWSlFuWXZjUUtwTG9pY2ZH?=
 =?utf-8?B?U25HTkpRRHpHaVhNOXFJMjZDTzFjR0RLWEF3V2k0QXpwOUdtZ1RMaGNxMGo1?=
 =?utf-8?B?T2lIQjZQMzcwa2RoY1ZacFhOL2sxSmlwSE5yODJZbGljcFpTZ05pd2Q0bG5a?=
 =?utf-8?B?b0pOcnVYbGVHaUxLcWdSU0RqVDZtZkRoeWx5dG9MY3IzNG5vcWR5STNqbXM3?=
 =?utf-8?B?aFhEM3VxR1hXM0ptcmJFZ0xOKzE3MmJJbnlWTkpPQVk1S1hLNFBncWJ6STJt?=
 =?utf-8?B?cE5ka3RFMkhyMHJOMlhxMjZlR0luTlp6eVJ4bGZmbnRsU0s2S0hQUG9JSUI0?=
 =?utf-8?B?WTJSdEU4bldDZ215K0FFUUtBRm9rd004K0ZMVWJxTndOcFMrZ1RVNEJFWkNu?=
 =?utf-8?B?bUVwcENPZVArMG10aEVSQkFUQVZTakpQV0g5bG9HdG1mbWtPVGtCa0lJUURR?=
 =?utf-8?B?cWhiUjJFbks0ZFE5bVZwT1J3V2tOY0o1WEZ0cDI2STZ3a1BwZmI0VHlSOGZZ?=
 =?utf-8?B?U2tGZWJEKysxcEsxVEpLR2F2MjdsT3RNeFpPNExzVDI4bDRoRS9NcE9aWjdK?=
 =?utf-8?B?bUJSK0FXbXRmUGUxZDFIZTBPQzdaQ2RGZk5nVHNiTUxqdThvRTRVVWl1YlJP?=
 =?utf-8?B?b2tFYWo0V1JQUHduK0tTUDBvRUhLSko2UEF3RlRxeDV6ZUZYRzFEZjkrUkNw?=
 =?utf-8?B?eWx2MUtyYnFGa09hcWRKUkhaTEFYNFVQV2pEM2ZTSDFQaWppN1p1d0hzajQ2?=
 =?utf-8?B?cDl2KzB3TmhsYmNaNkgrMGN6dmg0RUJTWkdQWlNnUFV4SjFDSFlhREpmQXVE?=
 =?utf-8?B?ZlJjRHQrM1p2NklNVW9ZQlQ1M3RrSmhFazBUdWkvdG4yeTJYQjhsTVVvMnMv?=
 =?utf-8?B?VUxYbGVtT2tqWlRyOHpUcmpVNHR5NDZ3NHljcmxMdDFVcUYxTnZ6ekdUNTlL?=
 =?utf-8?B?UFVyN2I3SyszcmdReDJzaFh0aTNFUGJVYzZjc0N0U3NjdEZxK2RxTStoM3RH?=
 =?utf-8?B?Skg5SzNaTWFYM2JEQVA2TStNTWp1VEVxbFlWR1JCM1JIcno4TW1jblRFRStO?=
 =?utf-8?B?bWk5eTN1TWZRaXpMQXFmUkNocXcyYkpkeUhwdHdNTzc2Z0NBU3c5LzE1cGth?=
 =?utf-8?B?M0dvMmkwK0VIM3lJU0YwdkxXL2tvV2loaTJ4cUppQmVlT3lsSi93ZVFXNmRS?=
 =?utf-8?B?UG5kNnVPdGFsMVNCNVYxTzN5Q09YWThaRU5QeG8wNnduc3ZtYTBWbFVQWERx?=
 =?utf-8?B?RWZWV2tBWDA1OFZZYjBxRWQyTXBBMDV3eU01SWlUU0RqYW9kc0JCMWVKNG42?=
 =?utf-8?B?WHJsenhNb1NTZU9WV21JL0lHSWQ1amc1dWNBdTFYRWZGL040dklPcG1SWVB4?=
 =?utf-8?B?TDIvbmZpL3dtd09qWU1yRE9oUzBuUHJxMTlWSFExM2lydXkzdDBXUTM0Nzgx?=
 =?utf-8?B?cXdZWW5sUDdsSVlScm1nbFpCa2xJaWtMUDZTeWFURWFGdW5CUEpSb05zM2pB?=
 =?utf-8?B?eXA0eEg0ZXUyWWp1V1RhVTlMSUx1WjlKNHJnNmJLYjNTZjY0QjEwVWRGb0c2?=
 =?utf-8?B?TkFmOU52WTM1clFDdXpRQkVJN2hDczg2YnRhM2xUOWNyd3lMbUxlczhrUnEr?=
 =?utf-8?B?QjdDVis2cWw2VGtXSWJ1V0NCekMwd3paYUpHcnNPeEZKamdaWHdQZ05CVlJj?=
 =?utf-8?B?Q2F0R1BBSldGSXhYSmhRU3R1TWVKRGFUc05GVWY3YlRjakxDWjlpeVpuQ0dS?=
 =?utf-8?B?c2RpUFgvU3FSTURybmxZY2RrUWFtNHlSYnQzcTd3MWVTR2FGdEpuU20zUGpH?=
 =?utf-8?B?RTBKQ1dKWXdLN3dMa3dzQT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6772e44b-235a-4049-d6d1-08d97fbd4352
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2021 00:41:50.7092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3bCnOYxxA54wIVJw4ychhGG2xhfJYtrZYHvz7vXjeaHS2dl33uRYpCOsSvaMJQKzV2TSwquzg5EN3DVbDcTZaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2951
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10117 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=842 phishscore=0 mlxscore=0
 spamscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109250001
X-Proofpoint-GUID: olg20-vgxtUV3fV5NWSOsdgArY7EcI8H
X-Proofpoint-ORIG-GUID: olg20-vgxtUV3fV5NWSOsdgArY7EcI8H
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/24/21 1:34 PM, Sean Christopherson wrote:
> On Tue, Sep 07, 2021, Dongli Zhang wrote:
>> People sometimes may blame KVM scheduling if there is softlockup/rcu_stall
>> in VM kernel. The KVM developers are required to prove that a specific VCPU
>> is being regularly scheduled by KVM hypervisor.
>>
>> So far we use "pidstat -p <qemu-pid> -t 1" or
>> "cat /proc/<pid>/task/<tid>/stat", but 'exits' is more fine-grained.
> 
> Sort of?  Yes, counts _almost_ every VM-Exit, but it's also measuring something
> completely different.
> 
>> Therefore, the 'exits' is exported to userspace to verify if a VCPU is
>> being scheduled regularly.
> 
> The number of VM-Exits seems like a very cumbersome and potentially misinterpreted
> indicator, e.g. userspace could naively think that a guest that is generating a
> high number of exits is getting more runtime.  With posted interrupts and other
> hardware features, that doesn't necessarily hold true.
> 
> I'm not saying don't count exits, they absolutely can be a good triage tool, but
> they're not the right tool to verify tasks are getting scheduled.

Yes, the high number of 'exits' does not indicate the guest is getting more runtime.

This is used to prove that a specific VCPU is entering into guest mode
regularly. Sometimes it is much more difficult to prove KVM works well, than to
resolve a KVM issue.

If the VM side complains that a VCPU stopped entering into guest mode, the
increasing 'exits' will be used as convincing evidence.

> 
>> I was going to export 'exits', until there was binary stats available.
>> Unfortunately, QEMU does not support binary stats and we will need to
>> read via debugfs temporarily. This patch can also be backported to prior
>> versions that do not support binary stats.
> 
> Adding temporary code to the _upstream_ kernel to work around lack of support in
> the userspace VMM does not seem right to me.  Especially in debugfs, which is
> very explicitly not intended to be used for thing like monitoring in production.
> 

I agree. That's why I tag the patch with RFC.

Thank you very much!

Dongli Zhang
