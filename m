Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A449F37981D
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 22:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhEJUIb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 16:08:31 -0400
Received: from mail-dm6nam12on2064.outbound.protection.outlook.com ([40.107.243.64]:53601
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229566AbhEJUIa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 16:08:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKYUlF4I/RmAfZq7Ze1fApPPJGCsD2GkZud682JjrDeta0PT0wy+SXva0kq311nHtbF9B/3KNhpC3yLjnVu60A/D64b6/QvJc2WlhtflCwg/Lzah5zeCuu0kBrHKsfOsaRYVhMawuX0TM6znzIpm8SrvsTr2aJZ8i4nESXGBX9XCJRzwQvNTQ5NFgnHXR5Gn+UGrLBVedoroEFM97NHDn3rJAgcccFA11+AH4CbXa9cYMNeuVRmDovfcthaM2khET8AbPFKPNfBdDs9uhPt0jvaL0+Ypo5sfBinn+IcHNUG+Y37oOE814U96ufuQvY2BtFJhicLhqU5n67/xU475ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q+lPRs8YqkOHSdWRlYPsZANOSZCjb7RFqWFeuaCMSHg=;
 b=VaQXagHjFiYNhRfsbrCK0ebwARpfRYxWFgBETkOl7ZQrhgu+P57nyTY96mkOrXMMg80fa/+JeBY4FKYPkmbyneh9uYU90GCZJjCqgcuxaYKxUn5a+7tj1d3xP+sR0Q5rkHBjTvhfACyK0vQcsv1bW4C2usEN2r1iRN05nI4UBLMNKuc3nzw6grpYAJP6gMBrGOnyN99jf3st0gg8L9Ek4IeZdh9vO2jAcEjHfnO/rWdWF3oTfmFw3QgufCNSQb0y53VtWDKdMtfRFpTQ2Fy5W6wsNElv/jHZV37cJyFDTg56pAlsPi9bP8op5NlGkm7tLFuZBwTwl36ijk1AhJBCRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q+lPRs8YqkOHSdWRlYPsZANOSZCjb7RFqWFeuaCMSHg=;
 b=m9jiW4SzAmyK+W1HjZhI8C+B9M85OmM/RFgSvV8egm5m/2LtX0n1weS+wwvdUmVmV2swHLEzHYj2ccHKqJsUIl10xgM/+X21hhhRB7XzWSy/qtomVu4SikcBIS6GV2nqewwTSWPlfx2AyB4VtYzv4U28Ol8g9rfs2ZJLY8m6JE4=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4575.namprd12.prod.outlook.com (2603:10b6:806:73::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Mon, 10 May
 2021 20:07:23 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4108.031; Mon, 10 May 2021
 20:07:23 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, jroedel@suse.de,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>, peterz@infradead.org,
        "H. Peter Anvin" <hpa@zytor.com>, tony.luck@intel.com
Subject: Re: [PATCH Part2 RFC v2 16/37] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
To:     Peter Gonda <pgonda@google.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
 <20210430123822.13825-17-brijesh.singh@amd.com>
 <CAMkAt6q=G96mG905u1GisbkVR42saPsgzQkXTtPVM=ar0Pdasg@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <2bd596a2-5d7d-2873-be11-67f6db0dd296@amd.com>
Date:   Mon, 10 May 2021 15:07:21 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <CAMkAt6q=G96mG905u1GisbkVR42saPsgzQkXTtPVM=ar0Pdasg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0201CA0017.namprd02.prod.outlook.com
 (2603:10b6:803:2b::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0201CA0017.namprd02.prod.outlook.com (2603:10b6:803:2b::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Mon, 10 May 2021 20:07:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5461603d-3e72-4533-c580-08d913ef3956
X-MS-TrafficTypeDiagnostic: SA0PR12MB4575:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4575BED717547490B663C92CE5549@SA0PR12MB4575.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bdb5HWymFIiK/4LQ7qrE8bQN1WgMXgSg6AZyLpAM1lOHuetA+5SK0FBzXJy0G2RO+22KR7KZAwxfBrKVUeBP1TZO49/XsOKXhjYQko0CgzURfgOXIMP02wJy+l6dUbXxRczIw2Y2C7GLb7WkuvhpVlmm6Zsrpr9eZFoSVew2QWYcReo9I31bJp0uu24R4N/KsVyqrQhw6KXS0RNSDARg9SX2wdH1iKKDbdM8Xlad0NEEesl5B0GnxL/oiDjZajT2r93SBmhCVlueS8RehFTwuiz5IPHZ9NPyhuXs7BBAf1cgpPO0UVJ5WSXka/aFyFmJ4dz1midtG1Feh9VQ9kY6k1ncwjFnU4ZU0f7hCcvU2Uk5Rd1kXptLpCtcLRGRooWhKC8fWYuIj2eZqbSXhpOAGCNknPlk7Yhliir7QhOA+Vsvn0MNFxpOzUD2+Q6igrEgAVjxi9thfb39LTgTlRCThnV/L6B9rH0bamf0VeCCsUphninH8+RKEj8iE1z2RvDg6OJSmChwdfkLdO99LhgcflLw7fdpe+Nbnfd0PSk1z39lAkhUPsrBqUjrflxldpa6lUf0xiMN0cexGj5UwhlvNNF4j4BUBpQy71KoeDMHoQJD6F2hu5v6VvhkuolaPccAaxsToZa2AfcP7u4ECl4SV+54lSKD0eFXjcF6s8ZM4iKVpq12By0ykr6+DWuhSic8BP3ZnEBHfsICCoR1xWTtn8MOB9n7+7ULruqcrIvSEbc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(7416002)(66556008)(956004)(6486002)(26005)(66476007)(66946007)(38100700002)(2616005)(38350700002)(6506007)(8936002)(5660300002)(44832011)(186003)(2906002)(31696002)(54906003)(4326008)(478600001)(36756003)(6512007)(83380400001)(86362001)(16526019)(8676002)(6916009)(52116002)(31686004)(53546011)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZGpTcEJyUnZjL2greTh0NWg5eXZORzJ0RUdQaEJFZm5pL0N2cFZHcEdleHp1?=
 =?utf-8?B?NXVFSVBINzRydWdGcWdBdHJ0Q3oxYzZLRWRsVnQweFJWMjVuc1U4Ky9oSDMx?=
 =?utf-8?B?STlLZ3U0R2J5ayt1R3dsWGQzclNja2hNUUMrV1JtNjVCQXpUK0ZGd2lDR1l6?=
 =?utf-8?B?WUdvR3l1Zjc5bk9mRGhmK2daOFdmMElJaFJyQUF1U09GWFU4VXlXUlF1K0xn?=
 =?utf-8?B?QzJuY081c1pDYU5IY3Z0Sy9taGFsTTAydkVsMnh2eWY3TjE1NmFza1ZUczJN?=
 =?utf-8?B?eGg0SHIyOHFiVzQ5dHhRYnhkOVRnbnJod2l4Q0ZPMm1aUGZzNWZzTERCWTZK?=
 =?utf-8?B?K0NUSkFHdk9IczJwWjYxNGZJTWVkc3BzMHEyZG5qYjJDdFJOTnhlSFhYZFBX?=
 =?utf-8?B?d0RLa3FxYmUxelVTaEl0ME52Zjk3Q2lZc2c5VVppQW50MXJJWi9JY3BXeGhH?=
 =?utf-8?B?c0dGRUNKR1dmREZocFFiaXRrZFdNNXFRTWRFYzVEblNVNWU1WjBwcW00aGd4?=
 =?utf-8?B?cXk2YWlyTisxRXRHM3NtekJENXlVYlNZbW5KeFl6c2t1bDlzMTlvWENwNU5F?=
 =?utf-8?B?bE5NZnNlTlVaL2dMa0ZuMlREMWt6bVJ1Rk1VQ1BPeWdxcG5ZY2oxZDR2OUhm?=
 =?utf-8?B?MG1LOStEWWlwcHVORFhQaFRycDEwYlZiL3J1UTNGYUVENmszSDIyU0Y1Qlcx?=
 =?utf-8?B?V0xtYVhoY2Z5cHcvSVErWS9BZi95bnJEbGZhQmMrSjdDazlGMENmUkVTZkdW?=
 =?utf-8?B?cFhlZEUwVEtGcHpmYVliWXFQcnFCNWpLWTlzaTFiYjlJQWMvVW9LUUUvTE0w?=
 =?utf-8?B?YlFIVkkxNUkxTVRWVDNMQzRjV1NGSGV3aUhJWmVGbWRCVHN3ZjltTmhRTkJV?=
 =?utf-8?B?akgzd095K0FFZnVzb3JFL0xWWHkzVnFWQVIremJINkhra3NBK2k4b0Q2OXRY?=
 =?utf-8?B?M0ltUExZMTVxQXpCMXFpUklWSTUraG96S3djaUNVd1g1NytWMWRzZ2dJWnFN?=
 =?utf-8?B?OGhudjJNM2xhMFYzSzhLTnB6TUlUUDhKd1pjNGZITUtTZmN2Y3RobnQzdEFW?=
 =?utf-8?B?Q1pmY2h0L1JWN2pSTE5wenlheUlQOGxsOUcyaTl0Zkc3UjIwNlJtV3NLMXlR?=
 =?utf-8?B?WDNFK1M4OUJDMGcwWUJlV1o4bE9ScURiOStBOU1aWlVHZWw5RW9sMjRjbEFa?=
 =?utf-8?B?KzcwaW5lb3NCWSs4RC9Kb1owcDZDcDFrTXRnY3EyVThpQ3lVb0VEeS9EZTBJ?=
 =?utf-8?B?dGRBamtJL0swbmp2MUVSSmFJb1ZjOUs4VFF4R0JjTXk5bVlkcWdoMnFQQkpp?=
 =?utf-8?B?eU1zWmN1cDZTQzBqNXpJZHkxbW9DZjJrRGZsVEh0YkFwMm9YajlmOEw3VjBJ?=
 =?utf-8?B?QnJtWnpiWVNIbEZIUkxxZHJjc0JRWjNaeTJwcGxzUksvd3N6THI0QmFOVytO?=
 =?utf-8?B?Snk0Ym1Ca0hqMUc2QjFIQ01VVG5XUkswY3l6ZkhpaTd1YWZmRHJaS3pmemk3?=
 =?utf-8?B?UGVxaGdoYU12TXp3bkFna3JObFhTVWtneGsydEFEY250eU9FSmtlTWZLWXVz?=
 =?utf-8?B?bjhDOEZkWWZWVnIrS2p5SGRRYnlKY1NoTzBUNXNMbmVXTXVEcE9Cdjlxc0JE?=
 =?utf-8?B?MzRxQkwvWjl1VnF0blZGdTQzM3BIWGJJWWY4OWVRUDBiVm9Xc2srRExZRzZI?=
 =?utf-8?B?T05ycEJVaDQvMm50VUZkR1E2QVBpcFJsU3pNQjEvWERmb2x0QWdHS3l3RHhO?=
 =?utf-8?Q?9cgqUDMOX9SiS6SykEbpMs+9OGWwEUfjFLQLBBL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5461603d-3e72-4533-c580-08d913ef3956
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2021 20:07:23.1844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 88pzAce5cMShoFukQJ/wd9aHYGGQ9cm8eVU3rYiJqrKYZhSK3uTlc4KvlATB6DFOzhi5n1DROepwMjqzuNvtLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4575
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/10/21 1:23 PM, Peter Gonda wrote:
>> +
>> +static int snp_set_rmptable_state(unsigned long paddr, int npages,
>> +                                 struct rmpupdate *val, bool locked, bool need_reclaim)
>> +{
>> +       unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT;
>> +       unsigned long pfn_end = pfn + npages;
>> +       int rc;
>> +
>> +       while (pfn < pfn_end) {
>> +               if (need_reclaim)
>> +                       if (snp_reclaim_page(pfn_to_page(pfn), locked))
>> +                               return -EFAULT;
>> +
>> +               rc = rmpupdate(pfn_to_page(pfn), val);
>> +               if (rc)
>> +                       return rc;
> This functional can return an error but have partially converted some
> of the npages requested by the caller. Should this function return the
> number of affected pages or something to allow the caller to know if
> some pages need to be reverted? Or should the function attempt to do
> that itself?

I will look into improving this function to cleanup the partial updates
on the failure. Thanks


>
>> +
>> +               pfn++;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static void __snp_free_firmware_pages(struct page *page, int order)
>> +{
>> +       struct rmpupdate val = {};
>> +       unsigned long paddr;
>> +
>> +       if (!page)
>> +               return;
>> +
>> +       paddr = __pa((unsigned long)page_address(page));
>> +
>> +       if (snp_set_rmptable_state(paddr, 1 << order, &val, false, true))
>> +               return;
> We now have leaked the given pages right? Should some warning be
> logged or should we track these leaked pages and maybe try and free
> them with a kworker?

I will add the log about it. Only reason I can think of this function
failing is if the firmware fails to clear the immutable bit from the
page, If it did then I don't see any reason why a kworker retry will
succeed. Per the SNP firmware spec, the firmware should be able to clear
immutable bit as long as the firmware is in the INIT state.


>
>> +
>> +       __free_pages(page, order);
>> +}
>> +
