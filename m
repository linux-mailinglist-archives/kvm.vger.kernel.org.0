Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC66379678
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 19:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhEJRwr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 13:52:47 -0400
Received: from mail-co1nam11on2088.outbound.protection.outlook.com ([40.107.220.88]:58720
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230479AbhEJRwr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 13:52:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fARYUrgZTBfCe84+KmEZwqyNbID/wh9bVtRY/fw5dG8bSHFpnh9JuVjxBxhk9loUqcW0im6Pe5u0qfyf74FKj8pqc0RaC+Gl1pX/FLQGfza0xnFTGCC+EGGomUgvurLE/MzFz+Kyjo6lja2QDtyBQoYgwwRT5qLa7nCKiyftbgd2ey9aPp+SlW5HNdCA+AA9iZHC2Bzy8gG4sfXzchwB5vlDBeBsUuY+y5AakBYKSN/x9fHcMMh5vvXDbbdyBlU938+Lw1U0TqJImC8ITI0BG8du+JrjkZ9wtmdO2XrXN8j4DLCrza/AzVMcvPLfRU7UMReFWXNVv3VvF+l4oYfZSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3tEajDeiYXlURvNrvCDn0c4mRqgqZit8AzNlxFFxrs=;
 b=mZMcNWd8hJPnD6PCp/cbFpTgg7HqzAojAAhXT5E62PUgx3oNEPeCcacjKwnjV/3YMVQdIVC9jJ0HCYsLguCdX0MWmasgAnAoTGcrYX+h5he64Vk+i3YYreioxkrec9YK8xCggjA1xFj7AdtrsMMwul7ewMEvKAh+NkwKRUUOeUEhUqwnbRhYTlCHVTyEP8JYIwXrebcZxF5zHKYIQg0TM1Uua/i0LKPUFA+/kxgdAHgQG7B5HBWEMBrbS9xRtLhBvwGGMSJfh9nJhVtwSDmJ3DrRuG7SusmyQNB2sCRtGkBkHBnVZyYm6fRygK6Q/1eGnnHktyKuyJQeQtOMHYy99Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3tEajDeiYXlURvNrvCDn0c4mRqgqZit8AzNlxFFxrs=;
 b=vD8nNWPKxeRVizAha9nQm96vSS0Y5UmfdO5gdztk3ne6Fcha/G9uVm1lKG4EyZIWkgiL97BBcPV0/Kl8UstrkcogjR74h9km4ZKR7Dq5IM8GVSOPq4cbFr2W2vwThhesFNoFo78bd0Sm5WruQqC2CoG2Gb5WZz9wwXaBLxljF2M=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Mon, 10 May
 2021 17:51:40 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4108.031; Mon, 10 May 2021
 17:51:40 +0000
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
Subject: Re: [PATCH Part2 RFC v2 32/37] KVM: SVM: Add support to handle MSR
 based Page State Change VMGEXIT
To:     Peter Gonda <pgonda@google.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
 <20210430123822.13825-33-brijesh.singh@amd.com>
 <CAMkAt6oYhRmqsKzDev3V5yMMePAR7ZzpEDRLadKhhCrb9Fq2=g@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <84f52e0e-b034-ebcf-e787-7ef9e3baae2f@amd.com>
Date:   Mon, 10 May 2021 12:51:36 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <CAMkAt6oYhRmqsKzDev3V5yMMePAR7ZzpEDRLadKhhCrb9Fq2=g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0501CA0054.namprd05.prod.outlook.com
 (2603:10b6:803:41::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0501CA0054.namprd05.prod.outlook.com (2603:10b6:803:41::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.12 via Frontend Transport; Mon, 10 May 2021 17:51:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aee8979b-47dc-452b-f532-08d913dc4369
X-MS-TrafficTypeDiagnostic: SA0PR12MB4382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB438281B9FAAB912E81B8C0C7E5549@SA0PR12MB4382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RDm/MmKJtDvZijccRv8fl595LJwMsszdjIQ5QuYA66DrCJkhyny2RYpOTfbXYasV5OamTnPSPRt/G5AZCmKdqT8p4GwqMK9uR7FAkbsfdqBUFWDW68DWy9BbubQlRRVcemotGuPs6Ura/jSsBqd8R0NxOqVjksCzEOjLYpAjtfsfIlqyUz9uVSSj13ljoUONzPTG7C5VtjRdPj+lRVjM8m/gY4nkc58CElg6aoCdibekkcnurEv7sKV1hP1wraTc65MhvZfK7KNqobog5nZ6VqehnvTpgq3ZGfI5wxKTQqKMLfldaAxgonzefF/2ubepSaSYkWNvZ6odQnX2mWz00ffLk4x0ToQlneMOx2r+PL+xIRBRK0+gTcMig1W9kqBF8mOjrKEaUev6TJVUZI4U0KIoNpZHKrwzbkSAhslhY/TB6JmahHHEa99fzc2tb/0QGK3yxNcfjcYvz22BK63LeAXXVxeHD7kNXTLeD7Jw3bHCGcF3cRmjxmWQH4Nj42DM5NXVBu75pRSyXEnn3T/lHmdz7DyibDX2HkhnGx5VyvB9AGpbt0QjOoYt+/oe1Ut0i4uZ+GRyY33bRhbGySshXSTl7YoCtFMr0utlTuJVXk84DSSzwH/X/3E0NYcahJCgllauKlqb71P96sLpZlzsd2fGWkT6+O5yd8GyIcMbD400vwHfYpRR3m6Dr4/vbqTFxihwJ/9htRNmhGhZRfuIXf43wdM6itVNXmjaBf1VBIU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(39860400002)(136003)(396003)(6512007)(31696002)(54906003)(16526019)(2906002)(83380400001)(478600001)(44832011)(38350700002)(5660300002)(38100700002)(86362001)(66476007)(36756003)(7416002)(4326008)(66556008)(8676002)(31686004)(52116002)(8936002)(956004)(2616005)(26005)(66946007)(186003)(316002)(6916009)(53546011)(6486002)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YTdKVkFmN1Ayb1I3bkhaVitVNzZObHpTUjlsSEpCSU9uT2VWOGNzSVZGSktE?=
 =?utf-8?B?bEMySE45a0llNUJFV04wTmxCY1ZKVEVvbVVURHZFY1VaM2Z3Z2lKMVM5Mlln?=
 =?utf-8?B?SzZ3SEo5OW1GV3RRVkUrbFVKUHRyZ0lUTUx6R1J2SWIyc0k5L2FOWTY1bGJW?=
 =?utf-8?B?VkJrcFdSUTI5ZjhRRWFVQ0lBdDMrWUl4cVFkYThLWGRHajF6RzBpQWRuUHoy?=
 =?utf-8?B?c2F6RXNSdzFlWXZDNHpqM2kxdEh2UEFNOFdDaEk1QjcxVGxWMW1YakpPeHVH?=
 =?utf-8?B?ZndQQ2E0b2E1emZZVmR6WTNyR0lybjBXb2N4ZWlqYUxLbVZVUWNTbEhaamlB?=
 =?utf-8?B?UnM0ZHR2MW45dG9jNXRPWXIvRnNPNXR0YWtoYnBsNHp2clp1Ynk1cDlsZG1s?=
 =?utf-8?B?cElLWEJpbUZZeUhJamZEZEV6UXliUlk5REg3VFJ4RUsrSHB6R0I5T3hmMnow?=
 =?utf-8?B?RVJ6dnNMRVJnbnJucThPeElUb3Jhd1RmYm44MVdoRmtJRWFhOFVBQ0Q2bkFo?=
 =?utf-8?B?VXh4ZVJsd3h1Um55MTcvU2hHcUFQa3NqQ0Q3NUlxaXpEVjRhK2NxVTE2WUw0?=
 =?utf-8?B?MXhWczBucUtQYzFPT3NDeDQ0K2R2QnFJUHFJenQxcW9vT0tuamh1NW9IV1Bw?=
 =?utf-8?B?Sll4ZC9hQTFUOUtGRmh0R2xHSkEwdUR6QXJwQTI3Z3ZhMnREUThGano4Wmxv?=
 =?utf-8?B?OHozN2NYRFRCcHZDKzhTWVZlNzNXejRUemh5Ni9XL2h4UDd6WCs0b0lnL0FT?=
 =?utf-8?B?TkxtQ01uN1Z1c1BoSEFscjF2Z2F4bElKU2JRSnJCRFhhclZOT2hVQ20xdEg1?=
 =?utf-8?B?M3QzK0lueXBSd0tJcWw3TEJsMmFkbjkvcy8vWlRBYTdoQ3lpQ1RPUTRnNjZw?=
 =?utf-8?B?RXRuejY3bitqb2tpeEw4VHNDcDN3dU9yMDhEVzllR25pZ25ZRXl2U0NZNTlN?=
 =?utf-8?B?UHFJdld3Wk10dzB2bW0rQ256b3VFdno5ck9IQXZPRmxNbXBVemN0eVlGeGh1?=
 =?utf-8?B?RG1hNktENW9ram43YzR2eC92U3l1NFZPRWFPN1Z1RzJscXRMMDMyVkszQVpV?=
 =?utf-8?B?Q0FQb3VYYnNMWTU0OGhhZ2RRVnkySlV2cHhmVnkyMktUTUVLWmYwSXAyeHhS?=
 =?utf-8?B?eEtNaDc5K3ZYdWUwcW5NUjRSbDBiT0ZJNm1SeXBxbXhsK3ZZYzlkaTB2cTVZ?=
 =?utf-8?B?Z1kxOURwSzJBOXZUTkNDbjB3dWNoN1FSa0hIVTJOR0RmRC9lbkdnVUVxak5z?=
 =?utf-8?B?SHVoR3NnWFozTlFPYncvNzJ4b0tpNmQzVFNURVg4ZmtyaVpiUlR4ODVCWkNG?=
 =?utf-8?B?bjkvaDZPeUxnYjRIZmMrNDYrdVpYMWNqUWdZT3FmMWkvSForUXdTZnJ4TitB?=
 =?utf-8?B?Y0VGQzJtMHlzY1lrclVIRlk1UVBPK2VISlN4ZWMweFNNSExxSVJSdU1lbUNm?=
 =?utf-8?B?SndTcjByemFEZjAxdjlzNDNvYS9QQ25hdW9LQWFjZ0VFZmtZamR5aDh6RnAz?=
 =?utf-8?B?TzIrbTU4aFVPUWZkcldkWGFIUFM4cUk2YlM5NHh2TXU5S3lLSERLTEFBdkEz?=
 =?utf-8?B?Ty9qRUVPYm00b3ZJOFk5U0kzZFBHUDdJUjJiN3dLdStPNHE1d1dtUnpFVlI3?=
 =?utf-8?B?bjUvN1ZMYnE2M0RtdnZYWVUyN0RicU9rbjBwdnFMK0E5eWpuWXZ2NUxDanBh?=
 =?utf-8?B?Uk41MDQzMnVwN1VkcGl5dTBTcmRBWVlWellQbmlwaGZycXdHOTBESUVKMTBC?=
 =?utf-8?Q?u6bG9gpA3zE5y3gZHGpYJ5BRauZYALbAFo0w2+r?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aee8979b-47dc-452b-f532-08d913dc4369
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2021 17:51:39.7874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y07U+nLAJWRvMFmtACt1icphFLv6uQFgG0wOBD86VYp4xiKL5/SBC51DaF0wSGdxKGqfMD7M5gisLgD+w7Qm6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 5/10/21 12:30 PM, Peter Gonda wrote:
>> +static int snp_make_page_shared(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn, int level)
>> +{
>> +       struct rmpupdate val;
>> +       int rc, rmp_level;
>> +       struct rmpentry *e;
>> +
>> +       e = snp_lookup_page_in_rmptable(pfn_to_page(pfn), &rmp_level);
>> +       if (!e)
>> +               return -EINVAL;
>> +
>> +       if (!rmpentry_assigned(e))
>> +               return 0;
>> +
>> +       /* Log if the entry is validated */
>> +       if (rmpentry_validated(e))
>> +               pr_debug_ratelimited("Remove RMP entry for a validated gpa 0x%llx\n", gpa);
>> +
>> +       /*
>> +        * Is the page part of an existing 2M RMP entry ? Split the 2MB into multiple
>> +        * of 4K-page before making the memory shared.
>> +        */
>> +       if ((level == PG_LEVEL_4K) && (rmp_level == PG_LEVEL_2M)) {
>> +               rc = snp_rmptable_psmash(vcpu, pfn);
>> +               if (rc)
>> +                       return rc;
>> +       }
>> +
>> +       memset(&val, 0, sizeof(val));
>> +       val.pagesize = X86_TO_RMP_PG_LEVEL(level);
> This is slightly different from Rev 2.00 of the GHCB spec. This
> defaults to 2MB page sizes, when the spec says the only valid settings
> for level are 0 -> 4k pages or 1 -> 2MB pages. Should this enforce the
> same strictness as the spec?


The caller of the snp_make_page_shared() must pass the x86 page level.
We should reach here after all the guest provide value have passed
through checks.

The call sequence in this case should be:

snp_handle_vmgexit_msr_protocol()

 __snp_handle_page_state_change(vcpu, gfn_to_gpa(gfn), PG_LEVEL_4K)

  snp_make_page_shared(..., level)

Am I missing something  ?

>> +       return rmpupdate(pfn_to_page(pfn), &val);
>> +}
>> +
>> +static int snp_make_page_private(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn, int level)
>> +{
>> +       struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
>> +       struct rmpupdate val;
>> +       struct rmpentry *e;
>> +       int rmp_level;
>> +
>> +       e = snp_lookup_page_in_rmptable(pfn_to_page(pfn), &rmp_level);
>> +       if (!e)
>> +               return -EINVAL;
>> +
>> +       /* Log if the entry is validated */
>> +       if (rmpentry_validated(e))
>> +               pr_err_ratelimited("Asked to make a pre-validated gpa %llx private\n", gpa);
>> +
>> +       memset(&val, 0, sizeof(val));
>> +       val.gpa = gpa;
>> +       val.asid = sev->asid;
>> +       val.pagesize = X86_TO_RMP_PG_LEVEL(level);
> Same comment as above.

See my above response.


>
>> +       val.assigned = true;
>> +
>> +       return rmpupdate(pfn_to_page(pfn), &val);
>> +}
