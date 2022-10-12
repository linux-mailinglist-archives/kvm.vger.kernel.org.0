Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA1A5FCBE2
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 22:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiJLUP2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 16:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiJLUPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 16:15:25 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2062.outbound.protection.outlook.com [40.107.95.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362256111C;
        Wed, 12 Oct 2022 13:15:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ERo9aNiGM03vSWfZ2GD978Eykyjyvt8X6E4dBiUl/8yWjLckUYfPA4KOtekE0OAiiAPPFYpCfuFtFzUHPhkn2Wg1FJbiAz3jaC46mlY6J8kST7m4/qI8kMTWcUFa74/ABxsVTr9199TDTvyj8JHHSehBmu2B6SrQMt7qRWgeFJpOT1szXGliEfmkPuaejoEVMacMAwnsb7uk7bZzd5q9K5FEFB8GD9b/F+5Fj8W/hhiecnkipCQBsdANsgv2gSbVyNrPsUuxmatveO7DhCXKVsL4s+CfVoN4VJrFg68apqS3U1t01e7xtIcbj943RGPhMKyLO4rIuE0nNbcb/Hus6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U/3HZQmwknpYl9oZt59nlPrhaIIW+sGjgbq4ShTpvuQ=;
 b=PSkHDzExp6LPDePCOBEvCb9aYp/my+3H9Kb6ooiTWVm4woPdUtZll0rRGFKoCyzfURdCVHJ2oC649q8dKth60rnsaPFAAWbzHa1VoTW944DCqV8ErHAvhpeMUU1kZaItPUlQ2tgq4h3QKizPZWBxrk6LOmXaNLdXeilI7cnjH0TAU2XmMriaRuNu6WYMLNQU5b+f4UD7XqHHHUdgEopnczFIJaS8znKryaHaIr8rpE/kZ0nlMKUMijxOU4/OOXbXQhR+fFgbdBN7SkQStWcR8JIukIbVCw3EwYL+lkRqgWXC95Aec/Ogep9fxnZBXaPtWiFopUf0+0Jr5J6GWxrUsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/3HZQmwknpYl9oZt59nlPrhaIIW+sGjgbq4ShTpvuQ=;
 b=A1HR7c0Jz9U4sdUHEzxkMh9nx+WAlTwEamsyCJyJisAZwVN5rHHOIgO9BrDJSdZFSmChiStn1WEfx+5FZ8X4o4oncLi12gb1T3CrDSvIE+bGWsw8Rmq4MzNflgDUetQpJ9m82vptWg6zdEf1PiBGl+v0DS+Wo4l8OWVPty6mnlU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by CH2PR12MB4280.namprd12.prod.outlook.com (2603:10b6:610:ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Wed, 12 Oct
 2022 20:15:22 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::b3f1:abb4:f311:5193]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::b3f1:abb4:f311:5193%4]) with mapi id 15.20.5709.021; Wed, 12 Oct 2022
 20:15:22 +0000
Message-ID: <53010b89-ae47-0065-9238-0ab065b70a44@amd.com>
Date:   Wed, 12 Oct 2022 15:15:15 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 37/49] KVM: SVM: Add support to handle MSR based
 Page State Change VMGEXIT
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>, Ashish Kalra <ashkalra@amd.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Alper Gun <alpergun@google.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>, jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <78e30b5a25c926fcfdcaafea3d484f1bb25f20b9.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6rrGJ5DYTAJKFUTagN9i_opS8u5HPw5c_8NoyEjK7rYzA@mail.gmail.com>
 <CABpDEum157s5+yQvikjwQRaOcxau27NkMzX9eCs9=HFOW5FYnA@mail.gmail.com>
 <0716365f-3572-638b-e841-fcce7d30571a@amd.com>
 <CABpDEu=quPsv6cXfbvpsGS2N+5Pcw7inCfmv=sx3-VaK0UE76g@mail.gmail.com>
 <8113b5d4-31c6-012c-fc0c-78a9bdbb1e69@amd.com>
 <31c1b2bb-b43a-709a-2b7e-0e945b9e8bb7@amd.com>
 <CAMkAt6o=G7W3pRgVYiBKK5RjQskMfzL_9me2Hcr7_e9rTHuStw@mail.gmail.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CAMkAt6o=G7W3pRgVYiBKK5RjQskMfzL_9me2Hcr7_e9rTHuStw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0088.namprd03.prod.outlook.com
 (2603:10b6:208:329::33) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|CH2PR12MB4280:EE_
X-MS-Office365-Filtering-Correlation-Id: c9a8b8e2-8c34-4fd2-c839-08daac8e7d90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U2TFPmQiHcWsNH/NvpLW/SI9JVF9oKRPmLDeQw2SFmnNY6wRe3EUOVKmKQZPvmPkaH6JLDB+pz2UPvXPQrDgrCsz/FGJNr6CJ0U56elVymXRRzHVmVbXXwzWaLWBE0qpCJDv/6LZhy0rBojCxBS0jdrr3fdSWCxKXVePGnJzrCiPgfmtSw6hl1B2eu/t351I26ttpvx3TBt1Orxznoh1ICrEtnQF2odzwMdsD0GN5z+Tetyh7EDewH0H5sFGn//yoOKVGp6Qhn7qtpMn8XL9glnTm/95MWKMo/mlnriZKnS1Z44i4gfKe62EnBD46VkrbjIw807k0TgrqKbl7bYRx+lVgEFWEmB4uH9jdMaQ/8RCV9BMvj4SJRX9L4zab9DDRIbcAzhCr64ZAG+nucfQIEBE8Y17eWd5smGoLjHMLl95l6MnQxuP/qUA/gJsHDrbxPAcVfG3M5Fwx8gFxuvWb3K+/q46KIjfGdNLpmYckmLcHScAXA5Cfo9J03xVnjXyqaPQ9Xdy+kIN2QI+qEmCDi1iWI6CQJUX3VMyZq8FiuFVTJ2tFRGB01VV/46Mz5th3VBdcJNYpW65itHGTHF3DMfqukW01gro1wTv1aRTkdX/Q8ayMtAxnrbKxeIfoORlLildfv+WfBTBw0qOn6KVSud1QCy6UrVIyzTUpoKFazu+ujeaszwbs8Hs2gws+YsdN75LSwQbvHp6onhaSfFLtKo+hGmxHo2vDtlSbC9PrOyjZma+bxAXabjx8fxwNWUruuLBPAO9kuPkXHtWFd0uZeTtgmGzopG/nM5k3aEtwqE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(366004)(136003)(39860400002)(451199015)(54906003)(6636002)(316002)(110136005)(2906002)(8936002)(66946007)(4326008)(8676002)(66556008)(66476007)(5660300002)(7416002)(7406005)(41300700001)(26005)(83380400001)(6512007)(186003)(2616005)(6506007)(53546011)(478600001)(6486002)(6666004)(31686004)(31696002)(38100700002)(86362001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zkc3WTFPN2kyOEQvUG5NckY3MmNtZkxqcy9Pa0Y3a0gyY1NlWTNkQ2dNOTlJ?=
 =?utf-8?B?WVYxeW41Tkt6RWk1c1hVeUdPNEd6MTNic1ljOEwxU1ZmU2NmbTN2MHhOdzRm?=
 =?utf-8?B?OUhBejFCUFhqeUN6UGd2MG9JQ3RpOFE5VHBvYWNUWmE2Y001QzgyMHR5Q1Iz?=
 =?utf-8?B?YS9nNUhHUzBlY1JuNzU3dmp1MUIra1I2WTEvbkR2T2hSV2ZyT1V0aFpNdC9i?=
 =?utf-8?B?ZmdxVm9JdW5sV0Z2S0FrU0ZmdVpqSjNSZHh0eTlJQXFMUHM0cWRMclp2RHd3?=
 =?utf-8?B?RjlPSG0xTUZTTGtuRkM3aUl5Q3BSNkVLckp5ZmUvL29vMzh3L21hSFBmc2JX?=
 =?utf-8?B?VGhmelhndStFUUo0ZTZKcEs5ZndlNVhxUmZzWEhSSnhLdHk4MERyYXV1WUpQ?=
 =?utf-8?B?N1JrVXFKZXdxSGlPNnFhWVNYdkV0UlVMY2xHZW5OSEwwK3lEb0drMFY5S2Jo?=
 =?utf-8?B?d0lZYTZtUVJQbXVEb0lJZ2M1T3E3azlnK3lQYlBiZTFFaXFjeHR3V2V2K0RX?=
 =?utf-8?B?cHB5eEh5WTA0V2tMSFBxRi9FQWw3MlJOYXQwMnJIbUoyT25ua3RZTG1XYlRm?=
 =?utf-8?B?YXo1WDB6N2IxVktlMXBVVmdJNWJkU2U0Y2o3eTNSNGN5NFBxMU5GSldOeFZn?=
 =?utf-8?B?bHdJV3F6c3RoM3o0WDVCZmNsbGtLTkJPcHFGZHducnp3dTNHV2hPWnozbEFs?=
 =?utf-8?B?bFV2OHVXM1BXNWhxZ0lncUt2S3RydmljNGZjOS9TWUtFVGZyNUNpNXErQlUr?=
 =?utf-8?B?djF5WGlyemFUOTVCeTFDNFN5bXpMaGRGZUtFckVNRGF2K0U2NWpZWUhIRk9X?=
 =?utf-8?B?UXMxTDZoZTBlTWlBUDlYNSt4VGJSV25nVDI5eVgwNElDTUNIN3ZYZVNGcVdT?=
 =?utf-8?B?NFhWQWFSQkhhSHUxSWowditLSDhvaFlwQllGR3Jac2p6Y2xnaWdma2tZTklm?=
 =?utf-8?B?VWZBSUZvRUxXQU1icHBaVkNBV3hocDN0aVc4cEwrRmVrejYrMDQwSUdpZWh1?=
 =?utf-8?B?TWYrQVhUaEJOaEVscFhaTXNjUnIrNGN5b2ZwUW85dHlYdHhVbGR3OXZsYytF?=
 =?utf-8?B?cGwzbWw4UmJnMDRTenBoeFZTYS9ieGZjcmR4U3RiR2ZBM0o1Vi9zM2F2NW96?=
 =?utf-8?B?NVBkd3lOK29QNkV1UVFnTWEwdXlnMnVNTmYrQ3ZDMU1qWWk3T2ZpK2E0c3ZE?=
 =?utf-8?B?blRvdkl6WVFOOWFUQ0YzTWdacTBjNkFYREVhSDVwWDI5UWJwNnFQWFNCNTVL?=
 =?utf-8?B?YXhJM05ISFRpWm1jOUJ2WE9lYVhIbFZpRVRycjIycE51ZHI2WkJZcXlORjRY?=
 =?utf-8?B?cXVCa1JuS3ZPZXlIQUZYakt0M296ZnFSL1owU2YwNUJWK0ppeXhUc1ZvVzhu?=
 =?utf-8?B?b1ZQM1hJa3M4MmtZVXpVdGZ5WEtDcURWK09IbkRsWmFiandVRFlRQjJSdkdt?=
 =?utf-8?B?UzI4LzNaUWxFM2U3S1R1RGhzQkcxcVlGQnV2MDVqQUNGY0kvQVVIbnhCN1NB?=
 =?utf-8?B?dkpPZUlsallpNGFHY3Z5bEUwTVBTSVZtQ0tVbm41UzdLZnp2ZkpSZ1JDU2Vk?=
 =?utf-8?B?akRFN05yWmlqcUxRT0xVWkZjem9yRzd5NWVITFdwcGpBdmdmbGFKczJ0dTUx?=
 =?utf-8?B?MGN1ait1QkY2T2JoS2tGU050SFRTRTFQT0NVSU9HeXNyWWhKS0VrcmFNMjI0?=
 =?utf-8?B?aEpTb09Da0pVZm1PcVUzS29tMU5hQ0hXK25hR1dsTDJESm13c1RRSHZjZHFr?=
 =?utf-8?B?TXEyL1RnQUw4bWdKK0grQTYvTVJyTkxUR1IxSC9BVy9SMmpVeGtXcGUxRndt?=
 =?utf-8?B?VGQ3eG8wTHNvNmZPalAwWktjaW52TDlzZDNYZW9NYllPN1M3djBRVHBkRWF3?=
 =?utf-8?B?NG9NbnJGZmhLMEp6MzdaMlZTVGpJRlRvYmNZZU8zNDBuQ0tUTVNlQ2doSkl4?=
 =?utf-8?B?VEVuRnpGUFI0dWQ3MTNpeU1oMGVXcDM1aGZZVUQvSDV0Q2RXNVhvVFFDaTly?=
 =?utf-8?B?NW9TMVNQeEhUN0hPc1ZwcDhiNDkvS2hyRWtCVzBKT3BoMnNxTmV5OHRyOU91?=
 =?utf-8?B?SkFTTVpzWlpXaEJSZTRiYmtvK0w3OWJyMFYzODMvdCs5MUJTQW55VGxZQUNx?=
 =?utf-8?Q?myMtX/EyfsYjTXLmERQVLVIv4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9a8b8e2-8c34-4fd2-c839-08daac8e7d90
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 20:15:22.0664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /C0cZyjBhCr8i6BhquIAh0c8FGL7rBCHN2OWdsHIJ4DoK+r+iyUfWlS9ynY0EeLPRRS3Z32vNRP6v7eMns3xxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4280
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_FILL_THIS_FORM_SHORT
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/26/2022 10:19 AM, Peter Gonda wrote:
> On Mon, Sep 19, 2022 at 5:47 PM Ashish Kalra <ashkalra@amd.com> wrote:
>>
>>
>> On 9/19/22 22:18, Tom Lendacky wrote:
>>> On 9/19/22 17:02, Alper Gun wrote:
>>>> On Mon, Sep 19, 2022 at 2:38 PM Tom Lendacky
>>>> <thomas.lendacky@amd.com> wrote:
>>>>>
>>>>> On 9/19/22 12:53, Alper Gun wrote:
>>>>>> On Fri, Aug 19, 2022 at 9:54 AM Peter Gonda <pgonda@google.com> wrote:
>>>>>>>
>>>>>>>> +
>>>>>>>> +static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu,
>>>>>>>> enum psc_op op, gpa_t gpa,
>>>>>>>> +                                         int level)
>>>>>>>> +{
>>>>>>>> +       struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
>>>>>>>> +       struct kvm *kvm = vcpu->kvm;
>>>>>>>> +       int rc, npt_level;
>>>>>>>> +       kvm_pfn_t pfn;
>>>>>>>> +       gpa_t gpa_end;
>>>>>>>> +
>>>>>>>> +       gpa_end = gpa + page_level_size(level);
>>>>>>>> +
>>>>>>>> +       while (gpa < gpa_end) {
>>>>>>>> +               /*
>>>>>>>> +                * If the gpa is not present in the NPT then
>>>>>>>> build the NPT.
>>>>>>>> +                */
>>>>>>>> +               rc = snp_check_and_build_npt(vcpu, gpa, level);
>>>>>>>> +               if (rc)
>>>>>>>> +                       return -EINVAL;
>>>>>>>> +
>>>>>>>> +               if (op == SNP_PAGE_STATE_PRIVATE) {
>>>>>>>> +                       hva_t hva;
>>>>>>>> +
>>>>>>>> +                       if (snp_gpa_to_hva(kvm, gpa, &hva))
>>>>>>>> +                               return -EINVAL;
>>>>>>>> +
>>>>>>>> +                       /*
>>>>>>>> +                        * Verify that the hva range is
>>>>>>>> registered. This enforcement is
>>>>>>>> +                        * required to avoid the cases where a
>>>>>>>> page is marked private
>>>>>>>> +                        * in the RMP table but never gets
>>>>>>>> cleanup during the VM
>>>>>>>> +                        * termination path.
>>>>>>>> +                        */
>>>>>>>> +                       mutex_lock(&kvm->lock);
>>>>>>>> +                       rc = is_hva_registered(kvm, hva,
>>>>>>>> page_level_size(level));
>>>>>>>> +                       mutex_unlock(&kvm->lock);
>>>>>>>> +                       if (!rc)
>>>>>>>> +                               return -EINVAL;
>>>>>>>> +
>>>>>>>> +                       /*
>>>>>>>> +                        * Mark the userspace range unmerable
>>>>>>>> before adding the pages
>>>>>>>> +                        * in the RMP table.
>>>>>>>> +                        */
>>>>>>>> +                       mmap_write_lock(kvm->mm);
>>>>>>>> +                       rc = snp_mark_unmergable(kvm, hva,
>>>>>>>> page_level_size(level));
>>>>>>>> +                       mmap_write_unlock(kvm->mm);
>>>>>>>> +                       if (rc)
>>>>>>>> +                               return -EINVAL;
>>>>>>>> +               }
>>>>>>>> +
>>>>>>>> +               write_lock(&kvm->mmu_lock);
>>>>>>>> +
>>>>>>>> +               rc = kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn,
>>>>>>>> &npt_level);
>>>>>>>> +               if (!rc) {
>>>>>>>> +                       /*
>>>>>>>> +                        * This may happen if another vCPU
>>>>>>>> unmapped the page
>>>>>>>> +                        * before we acquire the lock. Retry the
>>>>>>>> PSC.
>>>>>>>> +                        */
>>>>>>>> + write_unlock(&kvm->mmu_lock);
>>>>>>>> +                       return 0;
>>>>>>>> +               }
>>>>>>>
>>>>>>> I think we want to return -EAGAIN or similar if we want the caller to
>>>>>>> retry, right? I think returning 0 here hides the error.
>>>>>>>
>>>>>>
>>>>>> The problem here is that the caller(linux guest kernel) doesn't retry
>>>>>> if PSC fails. The current implementation in the guest kernel is that
>>>>>> if a page state change request fails, it terminates the VM with
>>>>>> GHCB_TERM_PSC reason.
>>>>>> Returning 0 here is not a good option because it will fail the PSC
>>>>>> silently and will probably cause a nested RMP fault later. Returning
>>>>>
>>>>> Returning 0 here is ok because the PSC current index into the PSC
>>>>> structure will not be updated and the guest will then retry (see the
>>>>> loop
>>>>> in vmgexit_psc() in arch/x86/kernel/sev.c).
>>>>>
>>>>> Thanks,
>>>>> Tom
>>>>
>>>> But the host code updates the index. It doesn't leave the loop because
>>>> rc is 0. The guest will think that it is successful.
>>>> rc = __snp_handle_page_state_change(vcpu, op, gpa, level);
>>>> if (rc)
>>>> goto out;
>>>>
>>>> Also the page state change request with MSR is not retried. It
>>>> terminates the VM if the MSR request fails.
>>>
>>> Ah, right. I see what you mean. It should probably return a -EAGAIN
>>> instead of 0 and then the if (rc) check should be modified to
>>> specifically look for -EAGAIN and goto out after setting rc to 0.
>>>
>>> But that does leave the MSR protocol open to the problem that you
>>> mention, so, yes, retry logic in snp_handle_page_state_change() for a
>>> -EAGAIN seems reasonable.
>>>
>>> Thanks,
>>> Tom
>>
>> I believe it makes more sense to add the retry logic within
>> __snp_handle_page_state_change() itself, as that will make it work for
>> both the GHCB MSR protocol and the GHCB VMGEXIT requests.
> 
> You are suggesting we just retry 'kvm_mmu_get_tdp_walk' inside of
> __snp_handle_page_state_change()? That should work but how many times
> do we retry? If we return EAGAIN or error we can leave it up to the
> caller
> 

Ok, we return -EAGAIN here and then let the caller in 
snp_handle_page_state_change() or sev_handle_vmgexit_msr_protocol()
(in case of GHCB MSR protocol) do the retries.

But, the question still remains, how may retry attempts should the 
caller attempt ?

Thanks,
Ashish

>>>
>>>>
>>>>>
>>>>>> an error also terminates the guest immediately with current guest
>>>>>> implementation. I think the best approach here is adding a retry logic
>>>>>> to this function. Retrying without returning an error should help it
>>>>>> work because snp_check_and_build_npt will be called again and in the
>>>>>> second attempt this should work.
>>>>>>
>>>>>>>> +
>>>>>>>> +               /*
>>>>>>>> +                * Adjust the level so that we don't go higher
>>>>>>>> than the backing
>>>>>>>> +                * page level.
>>>>>>>> +                */
>>>>>>>> +               level = min_t(size_t, level, npt_level);
>>>>>>>> +
>>>>>>>> +               trace_kvm_snp_psc(vcpu->vcpu_id, pfn, gpa, op,
>>>>>>>> level);
>>>>>>>> +
>>>>>>>> +               switch (op) {
>>>>>>>> +               case SNP_PAGE_STATE_SHARED:
>>>>>>>> +                       rc = snp_make_page_shared(kvm, gpa, pfn,
>>>>>>>> level);
>>>>>>>> +                       break;
>>>>>>>> +               case SNP_PAGE_STATE_PRIVATE:
>>>>>>>> +                       rc = rmp_make_private(pfn, gpa, level,
>>>>>>>> sev->asid, false);
>>>>>>>> +                       break;
>>>>>>>> +               default:
>>>>>>>> +                       rc = -EINVAL;
>>>>>>>> +                       break;
>>>>>>>> +               }
>>>>>>>> +
>>>>>>>> +               write_unlock(&kvm->mmu_lock);
>>>>>>>> +
>>>>>>>> +               if (rc) {
>>>>>>>> +                       pr_err_ratelimited("Error op %d gpa %llx
>>>>>>>> pfn %llx level %d rc %d\n",
>>>>>>>> +                                          op, gpa, pfn, level, rc);
>>>>>>>> +                       return rc;
>>>>>>>> +               }
>>>>>>>> +
>>>>>>>> +               gpa = gpa + page_level_size(level);
>>>>>>>> +       }
>>>>>>>> +
>>>>>>>> +       return 0;
>>>>>>>> +}
>>>>>>>> +
