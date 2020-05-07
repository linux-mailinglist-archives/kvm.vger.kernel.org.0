Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0801C9614
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 18:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgEGQLm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 12:11:42 -0400
Received: from mail-dm6nam11on2082.outbound.protection.outlook.com ([40.107.223.82]:6124
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726767AbgEGQLl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 12:11:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HnOcjmCPTXMwXOPMd6SE76hlx93/K7ldckVzgcaUEbJOINHnt+WFjKhpbjmyxP9KN0UXtBScGOZEVOEsuza3Bn5+mKcpK7H77PhjXpOwxXas7Eo+XlkYhwm35d9UFl2ITgi2Dddwiiqx9YP+idrW5pQfWHeyaZ5x5AGW2g2bizy9mXLzASwzLvyfIoVLcciAKZnoemaOImJM+EFwFiP7mLL/hUEIXTp8ytszjCpFAGayklGkuy11PF3QTtF5f6WtqADdAkbNU3MlQ5O7As0aRPQ+TzZt32UmCJD+xchHJZM4QWhx+1nogVlaZoPg9iRMRde9+TxFjtk3o7dyVoA31g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lmpNek7aTN3Snz2LxzsaAFwUjLYKDlaHSWDchFh262U=;
 b=Boob4I4/lnwuXjH7Un0NbKnsk9g3IW8ClY2i2W+zDJOJ3L/heE3sNOHXPznfUMI0QR29fr2zbXN11tYr6lpY+Bnu9TXluDQyJ/gnQ3bSzHDWOGj7v7d1nd8x3CtRdac/eagK1OKdXbFr+lDpZ906wM88APNUyspGiG2KoNpWENQSp9OXK0AuJ/MHr3F4XImFVT6xdGY+6xkUC89IjZZPOHAdTc1Ov7/GYwlMlh++7+XFOp4QUiABhrreRWNdAzaQLJeuBTb2mK3hV9MwAZHGKRNVSc1OIfG1Nc6l+c2Om4W+93RldHHj7uyz/6Q11lhkQJTOfXh/GyRJyygx9Qxc+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lmpNek7aTN3Snz2LxzsaAFwUjLYKDlaHSWDchFh262U=;
 b=POoD53xZeo9T5unfHIl+ieRRPZHMfHIGFoFJ63STnrBRhN69YRNJHckUjYSwkWI6jy6Rpc9MlmSOurOeTTxFnX1MGQ7AXAwvqPzAF3yxPGX05WM6QRa6MTWYUwJv+laRmELLVSBUaLJy5V2yBudfpLVEsRtVQdQNCcMKtP2dOXA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2461.namprd12.prod.outlook.com (2603:10b6:802:27::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Thu, 7 May
 2020 16:11:38 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.2979.028; Thu, 7 May 2020
 16:11:38 +0000
Subject: Re: [PATCH 1/2] arch/x86: Rename config
 X86_INTEL_MEMORY_PROTECTION_KEYS to generic x86
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, sean.j.christopherson@intel.com, x86@kernel.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, mchehab+samsung@kernel.org,
        changbin.du@intel.com, namit@vmware.com,
        yang.shi@linux.alibaba.com, asteinhauser@google.com,
        anshuman.khandual@arm.com, jan.kiszka@siemens.com,
        akpm@linux-foundation.org, steven.price@arm.com,
        rppt@linux.vnet.ibm.com, peterx@redhat.com,
        dan.j.williams@intel.com, arjunroy@google.com, logang@deltatee.com,
        thellstrom@vmware.com, aarcange@redhat.com, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com, keescook@chromium.org,
        jgross@suse.com, andrew.cooper3@citrix.com,
        pawan.kumar.gupta@linux.intel.com, fenghua.yu@intel.com,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <158880240546.11615.2219410169137148044.stgit@naples-babu.amd.com>
 <158880253347.11615.8499618616856685179.stgit@naples-babu.amd.com>
 <4d86b207-77af-dc5d-88a4-f092be0043f6@intel.com>
 <20200507072934.d5l6cpqyy54lrrla@linutronix.de>
 <034cfb90-7f75-8e36-5b1e-ceaef0dfa50d@intel.com>
 <1aca7824-f917-c027-ef02-d3a9e7780c3b@redhat.com>
 <4ca2dd51-c30a-c400-146a-8079ac4526c6@amd.com>
 <97773339-adf6-eab4-fbbc-4e20bbb7e024@redhat.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <730e8533-6385-7d51-9905-abca58bf8b90@amd.com>
Date:   Thu, 7 May 2020 11:11:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <97773339-adf6-eab4-fbbc-4e20bbb7e024@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR12CA0019.namprd12.prod.outlook.com
 (2603:10b6:5:1c0::32) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.87] (165.204.77.1) by DM6PR12CA0019.namprd12.prod.outlook.com (2603:10b6:5:1c0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Thu, 7 May 2020 16:11:34 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 02f65c40-6ca9-44ab-4a1a-08d7f2a151f2
X-MS-TrafficTypeDiagnostic: SN1PR12MB2461:
X-Microsoft-Antispam-PRVS: <SN1PR12MB24617A0D6EBA140F8614ACCE95A50@SN1PR12MB2461.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-Forefront-PRVS: 03965EFC76
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iBiN9qioqd0lVGoBvhNXuZzV9D9W9bkkRSz4VyhHzXysoPI2dVwSB9QDSF11Wl9zpekqZ/5XNEfpohkDF11hchD4/k38Vazhc6NsPUWVInuwIxieg47Y8IufB+8WiwEqajdYEUu80W9j2rLZTeEa5mHrh5jMqWMDNpkQ/KdNCphiVNfcs5IxYoJqdfOGI47lQAKU9aodc9uatYOtbwkhQXnwD9PWnNBm+aT4ZPVkZ59v9oCTJ8N6z2vbIOwZfX8kP5MQzjv2pkDfkKwfIwG9nN1wRHBycSee1e6eySqpKyqvSptQvipGuQu7zvl0OetSFkzSuNU8q+T9TYlOVEu5Nd9XVcyqsKtmfoIKF9MPsxb2AR1O1j5fx4UQA1wuMVbXpwMr+CvH304q798NltsCQkHQX59z568iPub3Ds9kwJfKTk4a9iY7HrWAifPtF0Rkt/zCs9bydOEE2sRV9ZMVX6D+PMUHWCILvABgS3GXqJS85i/UY8QpO9V+BHJt3Pj9c91aZEApnm4Tssek0GUxgBfr7DnvUk22PIUKh67XUkhgD6wydT/+plAkgvvaTTgycE1nXI2E/WQdNJdreNcKGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(366004)(396003)(136003)(346002)(33430700001)(52116002)(186003)(16526019)(8676002)(86362001)(4744005)(316002)(956004)(26005)(8936002)(66476007)(44832011)(33440700001)(16576012)(2616005)(478600001)(66556008)(31696002)(66946007)(53546011)(2906002)(7406005)(31686004)(6486002)(4326008)(110136005)(5660300002)(83280400001)(83310400001)(83290400001)(36756003)(83320400001)(7416002)(83300400001)(41533002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FKBnT8LJG6JdThVqUSrAyWmNh4TJppZmevpXPBBJqcvEMQ2/vFpR6temOx6xsfpAeU+VT98wl9qPj0aTJ5j+Mm6KQJwz6WUxu+Wm/1UZSsRAp8WUpTPx9W7mbfmxmu9t7NOaQU9E19sQAsbtbTcOKVwaky8Oqm0NgFNQenvpX2g09z8banLOaaf8/fYD6kbJDhoJuBtcqUzaXiK0uxKAEtPUtDkGipe+mjEoymKLGQyhWhlSoR3R9IJw1/TqKU4Y/lmOdn/p7RNcuj2Z3emlizJN9yxnUkhCaSpOaGb26RtcN/xAUFPcknR2TIBiMi2t0UhRJb2rBiNf/4LWhjTRMj60H9hkF7gELcI7+gmDoGN4obXx2UPt/r38KC9tAewdYnBkzfUhzQMXIRUO4Chbu6HcvKxZTppxjbpgbXUF37hKh/2UTQykXw+uARdW8dU3Q5e2hbH9Vr7mITW8aGEicbtR7B97wpCbvYCx8He+bUCXLi6I4jyE5+8wHVERMvWTNSG/NKO0N8/uMykI5QC6T19CDRmgcATvx7wqfgK0TvJ5eOMoXWZm/n5NMMH+EELRN4GPGyta1Gof1OqO6sj3pvFz43FdjsXJ9mN592GUIQaEA75Qu7IbwnceSeH/7ojOqr0aBH/bnYdcUDdJPXgMlh7wuVljAO+BOOTaEYuvVhD9E6/zvulABLzzl71XQY6qRExgqld0mseFpXCHIY1ceI1jnu8IWLH11m18Q4/eIqelRZWDPCKB+3bLbd8gYJexC0VgjdY/4EFTrLZK8jga4q+UVz0QEXf22xVBTPywHf4=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02f65c40-6ca9-44ab-4a1a-08d7f2a151f2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2020 16:11:37.7542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2mGyM4FrgCNVORmlKbz9ntYCiIDRmj1c2tUCcuEOXuwQFehHnpBMzAhpJdIZe6/l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2461
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/7/20 11:07 AM, Paolo Bonzini wrote:
> On 07/05/20 18:06, Babu Moger wrote:
>>>> So, for now my preference would be to change the prompt, but leave the
>>>> CONFIG_ naming in place.
>>> I agree.
>>>
>>> What's in a name?  An Intel rose by any other name would smell as sweet.
>>
>> How about X86_MPK? Or I will use already proposed name
>> X86_MEMORY_PROTECTION_KEYS.
> 
> Dave is proposing to keep the CONFIG_ as is and only change the prompt.

Ok. Got it. thanks

