Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217FE485607
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 16:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241590AbiAEPkR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 10:40:17 -0500
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:43894 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230307AbiAEPkQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 10:40:16 -0500
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2059dQ8i006379;
        Wed, 5 Jan 2022 07:40:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=TdTS+knNmGLcRI/SbElVobGMH40uNQS/qhZbYRt38Eg=;
 b=g6n/IsLCbLa6mwRSJOcOFYJANV1t8rYpB9eMTLZ89EOBadSwL2nFgKNvJKXr5ldpRzg3
 gVRyUO6zmTrVCM0ZH60DUqOaWgeA6swkC6VkUTNxEeA4+xQVdOFSNzNohgJQ4x7G5mhn
 zCR1sJT/X/Mgg6Hpttg/n6qSowzTn1YWeApzrCxQ7ByCd12EEGOC0XUt1AZyGY41xhPG
 cbheKcDhVkm9tAxTUA63+uwRyVHHvaI3FcqmoIiemLTq4CA357OJaMFCTAr5IoRh9Q5r
 W4I+GgtlBOlABQX+lR6+efYzBmDBjnuAjhQMyW8MXFN0aaOWdA3C5GEEZmfj33srsRtm Bg== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2175.outbound.protection.outlook.com [104.47.73.175])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3dcumnhtkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jan 2022 07:40:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mBGLI9pXsbL3lPebTUtX99VZ10TFBqQHRYwe3zccmlbX5NqMPQD/p3/liEYM5XOJ50UILKh+yABBHJEQhqJOKINTDG6ykjKazBuuLz4Qns4xe19hRiXCbGQtpZKrTwWhV0YO7pvB0WQOifKX79EpFoyO1/qIcKWDcdxjaphNcfif/DCiIYFxwh8JR920xzamiE8jOPfDiObuWNqvgDc5gOUoNQeB7q2o5SWiqOEJEM2aCDaRXo8m/B3ke+ePtH7HxNuB+ZoKxVIFe5I0q5h/jmGENyS1IAZLZbVIPy+QamcEqRrLGmSydJkViSJbzfdeYJNrELlLSySaa7bmBpxOnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TdTS+knNmGLcRI/SbElVobGMH40uNQS/qhZbYRt38Eg=;
 b=VrZ3i/0BVj+XQsHYJEvA8xxNncMDf/d9srBk3ieImbyF9LZ+X9x7r9y5n88kHSGlQi5oh6HAFyVsbGOcP7//gaG0Scsn6dyB28FyJK+MkH7160LinRDuq813pUn6pz4HLV8KFfFnlKR8oBaNC68LtLmzPkLn6MsMExjsmaT2aSOXuCmV3Vxpj+VH2YShain8MaQNQf6iMawKy9P0c/+6pd2rj2qBGBcsXKg3To6NA1xS/RcNv3T6LTN9nKkZ3dazF2pFUCDHumoGGpRtl7eC0b/5cQGWdiJFyA+4wZMosdgKbPpRuQSeeZ/M2SklpLVQVSQaApxcOs8pugkV0AaxDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by MW2PR02MB3771.namprd02.prod.outlook.com (2603:10b6:907:6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 15:40:04 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::586c:4e09:69dd:e117]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::586c:4e09:69dd:e117%9]) with mapi id 15.20.4867.007; Wed, 5 Jan 2022
 15:40:04 +0000
Message-ID: <652f9222-45a8-ca89-a16b-0a12456e2afc@nutanix.com>
Date:   Wed, 5 Jan 2022 21:09:54 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v2 0/1] KVM: Dirty quota-based throttling
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, agraf@csgraf.de
References: <20211220055722.204341-1-shivam.kumar1@nutanix.com>
 <f05cc9a6-f15b-77f8-7fad-72049648d16c@nutanix.com>
 <YdR9TSVgalKEfPIQ@google.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <YdR9TSVgalKEfPIQ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0164.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::31) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ed477ba-98d4-47ab-4ab5-08d9d061a476
X-MS-TrafficTypeDiagnostic: MW2PR02MB3771:EE_
X-Microsoft-Antispam-PRVS: <MW2PR02MB377162A6BF7CB4B5A0E1E68DB34B9@MW2PR02MB3771.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hI19u6cDXwQHVNpRufoBl69Mr8xE0fays0uK/1+gH63kKKnlusgD1sYBqbMeBMh68JIjHu4oIn/aKP+90cLcmPVjU4+4TflAJYOet7nc5GLZenL6HSRF+UtKNAvs3UfWkePyJBfiKIn7WFxSJDUWBYIByCgDZVvJ7EoiikiwuihQok5t1jtEfK9BOj5mWclbRhwWal4BdKpLmL41LR0ltIPT7bZlEfuv9DfWwq7qkHjDuj8ndGRmJsYSEhbXF3j3ptWmBbSgCiI852zSJcYaZ7KB9BjIDelJLf3PxLy6eDTf7pSLFYpOvSLLTAZp9Z1/Xxjnnpt5PiRQFQKL4zQECc92u/lSGV2k0skp9VvCGVUaRgsEVpIgIrKXwqqnpqQuiW2+i+9YQliI/7tTsfmejTGdmd32ZdL4cj5w/iizTsVAh+wLDvX2yR+IqUFyO37TwaOD/hHqWwdB6OFKXf+rc+ES8n2lPPv8RZdm++xhnADozPh+jsfjGXc8Qy0viMXZH7AEst4TY3DXq8+HXBN8k3LHtvIdoyiv5kybmdU7QRKptb4KD7dhmKw97IjgdMKHVE5F+6MsAkMkv7LqJfXqMMxQmAmMw+d6Ztxf8vTEDhgmKEb3fUBJRysbHJyQotjnxPhhAmE7nHIqGaeh0M/1VKQAsIAmN73RnP233bQZa2qARn4oOfblxC9RX3cSjWpI551K6Li1XGawcwzaw5kEBqMT5rYkLO9/POVtHT8Aru+ZPahsZtCXU4dvyAZd4NFRCVV84LJn68KBVFW7ASSK8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(26005)(31696002)(66946007)(4744005)(53546011)(36756003)(83380400001)(6916009)(6506007)(6512007)(15650500001)(66476007)(6486002)(55236004)(31686004)(186003)(6666004)(5660300002)(86362001)(38100700002)(8936002)(2616005)(4326008)(316002)(2906002)(508600001)(8676002)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VDIvekJRZ0JSMTRxVkt5UEV0MTUyMHZabmE0TjFwelBjWThlNjZTcDNEV2pC?=
 =?utf-8?B?aGg0U0lLN3U3MGM5dDFuVnJoZEN2QXY3N2tvTUxhZXJJOUdMa2NtZk5KSmhv?=
 =?utf-8?B?b1RodER1L3RKVnpGMTEvbUZvMTUvL3R5Ni9mWXZjRzd3QUJBSzQvT2tYR0xC?=
 =?utf-8?B?Q21BeFFtTnJCNmZNLzR1UUNGYVl5ZGVndXFibWZUalRtenR2RGU5V2w5VlhK?=
 =?utf-8?B?Rk1SVTBzUUVKayt2RWl5Zjgrcm1WZzBkT0cvNS9KYVpFa2tRM01mVnFwMk9u?=
 =?utf-8?B?cXBDWlRmSlpjUmVmWHhNL1NOODQ1RHlteUt4MHJCalVocEphdkhwZWlkVHlw?=
 =?utf-8?B?WE1jaVNNN3ZGZm50Z3RDYWdtaCthMG9OYXFCYm9oZFBoMFV1Y1NwRTU3WG01?=
 =?utf-8?B?MHlmVm5icHQrRk80MUljcUNHZ2lqVFZTb3pPQ1NCMEhRaVlGNjg2bDZXK2Rr?=
 =?utf-8?B?NlVteWZOd0tjT0ZPYysrZ3JLMkw1OGZJeXIwVnVJSDAxVjA0WmhzMXBCd1p2?=
 =?utf-8?B?TUVoTnBhN2NLQ0g2SVlRUXh0aEJoZWFDaXl1bnQ0cExlenZleWhiU3Awa0JB?=
 =?utf-8?B?QytWek5sWndWcktQQS82ZFc3VFdId3R2ZjJPQ2VqOFdLaktvakZ1NzR0N2Zu?=
 =?utf-8?B?THp3SVpheDdkVnRFVldzQlNIcjhNZkhGa0tDazEya1VzZFlYMU9MVjZ1a2Jo?=
 =?utf-8?B?TTM0cjVqU2xuSGR5aFUzS29ESUdMQ1JmSDNkOTNvdlBWVnIxeVVhV25EdVA2?=
 =?utf-8?B?YmZHMG1URllzbld2eU1Fb2F2VVkwZlpPa1Q1QVJyZGthaHZDOVR5N2xTTVp5?=
 =?utf-8?B?SmpKLzlzVGNKeFdod1M1eTcwY3hheHdXaVN2eFd6YTB3NGkwZk5ZMG1RSHhw?=
 =?utf-8?B?aWV4V1dZN1ZnYVY2QVhIdkNkcWRyejM5MW51ak84UmFJTWZjNEZtMktoSDVM?=
 =?utf-8?B?Qzhib05IZzhzQkZVZlo4bTRtYnNJTUY0a0tnekxKT21OdEZOemZSZFRLSmtQ?=
 =?utf-8?B?aFFUOWc1Mi9HTTRLQzNpdFFnT2ZuVlB4eTVzdVhjdEZZWGxoOUdBTkZ3RlBB?=
 =?utf-8?B?cDhkRzZjQ2dVR1BJL2Z5Y3A0djF1bEFPeGpLS0R0dk5HTXlJQ1QzcTFMSzA0?=
 =?utf-8?B?NjAvcWZkZ3o3MnRwUlc4b1Q3YjYyb2NKNFRhVXhFYTRqcDRhRjA5NmdEQTNV?=
 =?utf-8?B?dlhOVXhnWDlTaHdYdSs0QjVNb3Bncm1hNlFIZVF1UXRXTk1mOFlqdUphSEVL?=
 =?utf-8?B?RDZDMFpLMWl1b1g4eitjakpBU25mVUNmQjBBMk5BN1U5K1VQMTB1eEZ0dUtq?=
 =?utf-8?B?TSttT3htWkZsaEVoWHRiSXdHSnpWY08wQ3c0QzVvT3ZXY3U3Y3dTUldQZWdn?=
 =?utf-8?B?eWtYenRaN0xYbVdYUE9vd2dyYTJzSDR2ZG9Ta2pFYkYyYlZObnNTQnNmSm1x?=
 =?utf-8?B?T0ZIU25GNEVGU1FrN0dOei8vKzNkTzA2R1kzSWQ4M2cxTW9GUWZ1ODc5RlNy?=
 =?utf-8?B?bGRhRDRNOThJRS9xREhJbnZjbGFpMXYrZTFWMHdyNDZaWkJoeW96cFlqRW0y?=
 =?utf-8?B?bFE2ZmRFbERxejQzNGlJWEtrNWdRZjZyYVpzNmhTWFNTVFhCUmNwcjVLYlpY?=
 =?utf-8?B?L045ZjlOMVE1Z1VLL2ZPc2pQcXRVeERDL0NoRUt4cnQ2UHFadWZJVG9vVjBa?=
 =?utf-8?B?MHpzUyswenhmZWtCcnM3UzBXZ3NBRWRRNzlxL25UR3RyMTNHdXczWkRBK1dn?=
 =?utf-8?B?N3Bkc3ZaUk1pNXcxOFdYM281eERVczErZ2RJMXNUWUtjczhOblE1ak51b1dP?=
 =?utf-8?B?ekNTNkozaGdYOHltMmgzUWI4NUtaODUwRlBmVXhhc3JKUXovZGlaYXdaT1dI?=
 =?utf-8?B?RDAxNFFzZVRLa3RDRWRYeU5jR3JwaVdEVFN6bm1YMWptMXN5aDgwcjVpbjgv?=
 =?utf-8?B?Q0V0TVREOGdMTDNUTXdYQnBvV1FWVmd3bmRxSktaNmwwVW13Wll2bGJ6eUs3?=
 =?utf-8?B?ZFA4L0ZTbHhwSmtIN1ZVSWoraHZBWEJFa0MrTUIrUEszeVJ0clE5T1EyazF5?=
 =?utf-8?B?Y1ZLRzV1cUpJWnFLODlEUFZhRXdKRGxyQkNMbW1RM0R6VDZieXhmM2dja3VZ?=
 =?utf-8?B?YWdWZ3gycU1pVkVLUHZISEZMakxsYXgyMGhaeE95WXJBaTY4YitLaDFmSEtU?=
 =?utf-8?B?TFRISEViT1lOWkVpZTZLSnRxZ29mY1Ixc3B2UEs3RTQrOUNjNHBIYjRyMVNi?=
 =?utf-8?Q?uOSzcrJKC+qqWewAJwE+okbGrJamHhNxGsxn9YjqF4=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ed477ba-98d4-47ab-4ab5-08d9d061a476
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 15:40:04.3017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SrsYyew1mabuSYYhbVLGxZwoJgA3/q6j6Iv5Zq5oRTjwqpNBggMI9kHdA6jVdDSBJJ4EhFN+cy2gQcEKxYGRxJk5KI0dFV25ixcPJGzDvx0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR02MB3771
X-Proofpoint-ORIG-GUID: lRienz_9GVE4wTG6mouFVitScn5C-xS7
X-Proofpoint-GUID: lRienz_9GVE4wTG6mouFVitScn5C-xS7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-05_04,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 04/01/22 10:31 pm, Sean Christopherson wrote:
> On Mon, Jan 03, 2022, Shivam Kumar wrote:
>> I would be grateful if I could receive some feedback on the dirty quota v2
>> patchset.
>    'Twas the week before Christmas, when all through the list,
>    not a reviewer was stirring, not even a twit.
>
> There's a reason I got into programming and not literature.  Anyways, your patch
> is in the review queue, it'll just be a few days/weeks.  :-)
Thank you so much Sean for the update!
