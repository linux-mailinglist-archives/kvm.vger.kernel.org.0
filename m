Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9385BD719
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 00:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiISWSO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 18:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiISWSM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 18:18:12 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F5549B7B;
        Mon, 19 Sep 2022 15:18:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jj4qJr9mgB4a0EaS+sltQF+jrW5inP+UWuGnbZEgieRsqvVbEzsbQY+AfnwAg1kUJCdj2pya1dguy5+9rQv5OVzzit24D+ds5HLelsPGoApHs2VM74fXpPZAxx41EDik3M2pSHOJbhWx+puaBQV0o/1jreYrWyw383mpQ0eGndXGpJS3KA0s7qyIN/NyJKpuQd7vom0MfaeRb31UY2lRYB9X7fV80oDxSStCXOw/l0V6iiMl7O1pK0StpZ1QYfrCKsmKJpK0hIIZopWr7RH1PP+BDyfCLYO7TW+BX5oH0r5/yx5g254/em7wLXeA29t26M8qUiZ74ur7EZPZdMEyqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ztc1Ph71OP89no6zx8qe1bQXZ/oEWV/B1svj5WgKoF8=;
 b=McH7XnZZX79MaP91hGmOIzbeWpHnYyUTJa/xMx+YgBPJV2K5Sj0H3f+mOMZj3plUH8DXnHb6fqGfh1FFbBs7tcWFctVw0H7Rm8E7jdS7rEWGuS3+b5UgpQ5v35OUKqWCsgnqgthu44zUBRrjPHAz9cbag/C4rw8XuQECNcZHir8uzzZUhQbY1fGchuL+DHyLpNWzqJQVG5ndlYlEho2kroRTWGqfuBjYDtGR+qRXdTEa+M+205+TUgSZ1RzM7/bbkudpkc89t2V6EyRONlf06xyv/EyiFMTOExAb6lxHS7s/oyvuk+hxxqHsuJVA2C5CntJ8+zH0wH5eNcGkNmpgMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ztc1Ph71OP89no6zx8qe1bQXZ/oEWV/B1svj5WgKoF8=;
 b=mQ9Wt3TtSlzjFmd9m1pc2YgCRlNwmMovB8zco9Pp0rZ+rR4TxI1AVfVB/MapMqbjpYVqDKOvXCbFd/3ZuiPOu1wZJFe/I6Ho894PWgp2yMzUAm4y4frJz1q5mG/LGhhmn8kI19RVU7tlrYgx+U7/TrnKm4rdFdU1efbg7hbdmKI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by SA1PR12MB7342.namprd12.prod.outlook.com (2603:10b6:806:2b3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.19; Mon, 19 Sep
 2022 22:18:08 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::c175:4c:c0d:1396]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::c175:4c:c0d:1396%4]) with mapi id 15.20.5632.021; Mon, 19 Sep 2022
 22:18:08 +0000
Message-ID: <8113b5d4-31c6-012c-fc0c-78a9bdbb1e69@amd.com>
Date:   Mon, 19 Sep 2022 17:18:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH Part2 v6 37/49] KVM: SVM: Add support to handle MSR based
 Page State Change VMGEXIT
Content-Language: en-US
To:     Alper Gun <alpergun@google.com>
Cc:     Peter Gonda <pgonda@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
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
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <CABpDEu=quPsv6cXfbvpsGS2N+5Pcw7inCfmv=sx3-VaK0UE76g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0009.namprd02.prod.outlook.com
 (2603:10b6:207:3c::22) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|SA1PR12MB7342:EE_
X-MS-Office365-Filtering-Correlation-Id: e697dbea-de69-4c7c-3c76-08da9a8cd4e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CH6jUlvmQcFCq9btxQCSwGuX43CbqseqWzW8buKnbW33GBCGudA8GjPMjiAT4lhfFvt704vCW3mogcOS/PJFhO+MuoxogcBerb93oInR+Y5vsphEHykYr36GyxvRO9/hKXfjtFTAQKOYrNwnWs3Mr7YcDsIFg0AaSrAnqbQQBaRHwGXMRwNm8nJbPLNJonaPz5JfCKtug7nLwbXa05OJWbULxyWBXMN4c/zOaCs7IjzstyTaM6ubsYCa6eDFCRTZlN8B4q2sA5gJ9iGI2w6fAMUJtJDWlCoMJ6SFg4/Ry3BlHeqqY6SXTRNOnJzFkr16jjm/Rlx88roPVdejoSI8z+w+VuFLBTO/Ya0jjHzmXtsNWyDqoZvizMVGPop3WC/kBGBYhM2b2EAd2yKMnN4QjzZdClxN6JzOPIncxmbGXzyvcQtR6b5HOZNEhcm7rh9AW09Sf3/dv23fPJmgC1rRYHlSCXonjTMiYEUJz/SRHRbWQxneayYrZ8ZTsXtGfuqiT9SaqvTblEHQFhBEgfh0WESJyYdhjQSDcwxgQArh4lzXz552DWeJRPmdXXaq33PiOAojdLSIspshI9YOFpr0xcdWTMTSvbHmtPTkpM7yGrnFvnWEQy1C6egO2lAu6LRxFoVU6RZoJQ31oQBkvUmuPjx1RGgBwAhaDt3SUJvox4VK1LKCtPXVxU4n43iSSQXOPKBKMKVCey0YSnuO8JqpnbcOR1OsvWwZgDYIS/dwQBBv0xuloOFZSTgeV0twKZAVWxGl22c40Bi2/2WXSdI4chmuThYTFvdX1wReu8PPKCQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(39860400002)(366004)(136003)(451199015)(2906002)(36756003)(31686004)(316002)(83380400001)(38100700002)(4326008)(8676002)(7406005)(7416002)(66556008)(5660300002)(66476007)(66946007)(54906003)(8936002)(31696002)(86362001)(186003)(478600001)(2616005)(26005)(6512007)(6916009)(6666004)(53546011)(6506007)(6486002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnVvdkRSVWxjSXkrU1VwRTBGQkwwdk5vZlJQdnppK1NlT2IybkV5bHBtaVNC?=
 =?utf-8?B?RWdSTEdvMTZEN0FpMkhSaVVxSFlSSGl3M3BzL0VLL1crdE1FVXFldk1MR1JN?=
 =?utf-8?B?OGRVaXFmRjRYZHJ6QjZWcHpiTUd4Q0NOcmROTlBYSDVDMVJwMXdrS2tFVGUw?=
 =?utf-8?B?WnBITHUwZENCdEQzbGk2VkNkb3dMeldoZEhJcjBFVnBUdktQQXNFNWVLVW5t?=
 =?utf-8?B?aTloUUlrakRtNlVSSnZkMzkzd3A1aFhyQmV3dUNzT2pKcUtxT2t4MFhyeW9a?=
 =?utf-8?B?Q1ZBWkJVcGlFSkJEMk5SYTFiTnFmd0tJMmNWQ05URHhRMnNvWkJhNHZVNm9U?=
 =?utf-8?B?Skt5UHk4eHlGdnJ2S2hsdUZkZTZNdFNKUTY1SkkyT29HdjJqVmxDUXZnUStE?=
 =?utf-8?B?UmRXd1htQ2QxbjVRSS9jamgyYldHVE16T2pCNkEyblQvQ3Y3dEVxeXBYdGN6?=
 =?utf-8?B?RmFYYVllZFJReDdNbVB2eTBSUmFVQk1EVEZ5L1lsSkxZVEwzU0pyaFFNaWlR?=
 =?utf-8?B?eHJjOFBySmhLcmtiNnhVa05DWVBneTRiWFlwa1E1Umd6Tkp1dDIrUXdNNlNV?=
 =?utf-8?B?ZnZVbENSRXZHQ2RWS2JJWTlQUWJmdlo2OHhRWWxBOEZxdWgyc2dLVEcxa0Rs?=
 =?utf-8?B?SUJqREc4SzdUQW0vcDg5aS93L0Z6d0JFamg3Ni9ST0JWSjBSWC8rWFdaYTZx?=
 =?utf-8?B?N2h1Nzl4L25lZTNRditVcExCa1QrSVU3V2JsUmo2dk42dmFXRjFzMEkrc3dt?=
 =?utf-8?B?U0dFY1hySDd0N1dJYXJOY1kzN3V3M1k1ZUtEOVB1Um1yRmh4R2g1bnpxdFU5?=
 =?utf-8?B?cjdNMnNwY0IxY0ViSmU4R0libUxJclh6V1hpUzBoYW9SMHZNWUU0YWw5SU81?=
 =?utf-8?B?RVAxQkVsYXpzaTU0V1YwMEx1MEtJRlBZSHhKUUpSSWR2YTY4MnlZTllkaEMr?=
 =?utf-8?B?c0RQenhoc3JQTzVRTHZMV3VTeXZDbW42MnhDV2I5Nk50dFRhZlBNdnRKQmZI?=
 =?utf-8?B?UTdzSEZKdExOS21WSXoxZE9uaUMrT2t3dHpQUndWUHlWVGV5aXQ5WUFPNEF4?=
 =?utf-8?B?cE5HUkNOL2hqcTlJbmJGRHZnaWlzYTZYaVpaMGJPNUpsTkQ2T2xlWEdqcEpY?=
 =?utf-8?B?ZWM1TFl4anczSU53MTdNRXhZR3RoT0NGVnI0UjRjUnRhOTdYa3BMVll0VnNi?=
 =?utf-8?B?MmJNZXhZQ29odGExL2VuU253eFMrZVZoRm1jZDlzdkYyaXhENFIxSElBZzZP?=
 =?utf-8?B?QzlLdUFnaUJicmMxcDdrL3pTb0IxYkhBMXJaWU83ZlQyTVN0cHhxR2RFWklo?=
 =?utf-8?B?ZUhlb01MbU9RZ3B0UUZiSmVaaFE2ZEVReFZ5NkI4VGpJenhWQ1hmTmtzM2FW?=
 =?utf-8?B?Z0hRUVZ1elFQa3czUG5xNmdYNGpIUTUxeHBZcmszTjg4cmFlNkRVWGF6dEJX?=
 =?utf-8?B?dHJmYTJkb1RUSlQyWnFMN2xwekZmSVFobHBGZDlhNFpQTnRwTmFLVGZvTEFX?=
 =?utf-8?B?bytFQ3NlZGRHUXZHYiszY0Juc0lrcXFXaTI5U3JTRlh3WUlPam1PRklMbmxH?=
 =?utf-8?B?QzZkNFJncVZJdStpbWFxNmwzR25XWlk3OFpTSjJWc1RiYS9NNElYM0U1azJB?=
 =?utf-8?B?c0hYS3pDZHZBb3lnNHBSSmoxSm5LR1JIeE54RjZlWlJHYlZJTldaU0YxaDVS?=
 =?utf-8?B?UGRmMGQ3cTlEcDdXU29qNnV3RWRSNm1tdk1tSWdMaFg0UWNZTTR5UEJEY1J5?=
 =?utf-8?B?V3ZtaWJMd1FaREtwNTh5UlVMODU4bjVhUWQzTVh6UG9xYTFQeWZVUmM3NUNK?=
 =?utf-8?B?K0NiNFM1VkNvT2dNbko3RmVqSy9NQkEra1gzdk1LT3NwL1BxQkFtOEpqMGNZ?=
 =?utf-8?B?U1FUYVpiam0yanVVS2hOVFhvMHVvRTdOaUVtaFFrYjFjYm5aWEVkb3RIZVRm?=
 =?utf-8?B?d04yVUZBLy9MbVlrTVBDNDZtYXkrTm0wM2sySHpXL0ZiWFdvRnhDVDVTajhX?=
 =?utf-8?B?QklyQ1VBRDJJbldWb3RYdzlMR3FxVjdqRFZoRXowTmptdDUvaTVIdCtZQzRx?=
 =?utf-8?B?L3FISU4wZWx3a3VaVmJQVWhaMDQvYWtHS1FvMmh6cXN1L3l3NkpPazVPNUtQ?=
 =?utf-8?Q?uI2RDNfg8Z55KeSpjsUjbbWBE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e697dbea-de69-4c7c-3c76-08da9a8cd4e0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2022 22:18:08.6098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QvLdqwgPsYlbu8ixy02mNkr/iQ6NHGqTpIv+ISRmBo6CZt0iHOintaLUjjOSGpZfMNMM2TPFkHFM6rCS0+MuRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7342
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_FILL_THIS_FORM_SHORT
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/19/22 17:02, Alper Gun wrote:
> On Mon, Sep 19, 2022 at 2:38 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>
>> On 9/19/22 12:53, Alper Gun wrote:
>>> On Fri, Aug 19, 2022 at 9:54 AM Peter Gonda <pgonda@google.com> wrote:
>>>>
>>>>> +
>>>>> +static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op, gpa_t gpa,
>>>>> +                                         int level)
>>>>> +{
>>>>> +       struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
>>>>> +       struct kvm *kvm = vcpu->kvm;
>>>>> +       int rc, npt_level;
>>>>> +       kvm_pfn_t pfn;
>>>>> +       gpa_t gpa_end;
>>>>> +
>>>>> +       gpa_end = gpa + page_level_size(level);
>>>>> +
>>>>> +       while (gpa < gpa_end) {
>>>>> +               /*
>>>>> +                * If the gpa is not present in the NPT then build the NPT.
>>>>> +                */
>>>>> +               rc = snp_check_and_build_npt(vcpu, gpa, level);
>>>>> +               if (rc)
>>>>> +                       return -EINVAL;
>>>>> +
>>>>> +               if (op == SNP_PAGE_STATE_PRIVATE) {
>>>>> +                       hva_t hva;
>>>>> +
>>>>> +                       if (snp_gpa_to_hva(kvm, gpa, &hva))
>>>>> +                               return -EINVAL;
>>>>> +
>>>>> +                       /*
>>>>> +                        * Verify that the hva range is registered. This enforcement is
>>>>> +                        * required to avoid the cases where a page is marked private
>>>>> +                        * in the RMP table but never gets cleanup during the VM
>>>>> +                        * termination path.
>>>>> +                        */
>>>>> +                       mutex_lock(&kvm->lock);
>>>>> +                       rc = is_hva_registered(kvm, hva, page_level_size(level));
>>>>> +                       mutex_unlock(&kvm->lock);
>>>>> +                       if (!rc)
>>>>> +                               return -EINVAL;
>>>>> +
>>>>> +                       /*
>>>>> +                        * Mark the userspace range unmerable before adding the pages
>>>>> +                        * in the RMP table.
>>>>> +                        */
>>>>> +                       mmap_write_lock(kvm->mm);
>>>>> +                       rc = snp_mark_unmergable(kvm, hva, page_level_size(level));
>>>>> +                       mmap_write_unlock(kvm->mm);
>>>>> +                       if (rc)
>>>>> +                               return -EINVAL;
>>>>> +               }
>>>>> +
>>>>> +               write_lock(&kvm->mmu_lock);
>>>>> +
>>>>> +               rc = kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level);
>>>>> +               if (!rc) {
>>>>> +                       /*
>>>>> +                        * This may happen if another vCPU unmapped the page
>>>>> +                        * before we acquire the lock. Retry the PSC.
>>>>> +                        */
>>>>> +                       write_unlock(&kvm->mmu_lock);
>>>>> +                       return 0;
>>>>> +               }
>>>>
>>>> I think we want to return -EAGAIN or similar if we want the caller to
>>>> retry, right? I think returning 0 here hides the error.
>>>>
>>>
>>> The problem here is that the caller(linux guest kernel) doesn't retry
>>> if PSC fails. The current implementation in the guest kernel is that
>>> if a page state change request fails, it terminates the VM with
>>> GHCB_TERM_PSC reason.
>>> Returning 0 here is not a good option because it will fail the PSC
>>> silently and will probably cause a nested RMP fault later. Returning
>>
>> Returning 0 here is ok because the PSC current index into the PSC
>> structure will not be updated and the guest will then retry (see the loop
>> in vmgexit_psc() in arch/x86/kernel/sev.c).
>>
>> Thanks,
>> Tom
> 
> But the host code updates the index. It doesn't leave the loop because
> rc is 0. The guest will think that it is successful.
> rc = __snp_handle_page_state_change(vcpu, op, gpa, level);
> if (rc)
> goto out;
> 
> Also the page state change request with MSR is not retried. It
> terminates the VM if the MSR request fails.

Ah, right. I see what you mean. It should probably return a -EAGAIN 
instead of 0 and then the if (rc) check should be modified to specifically 
look for -EAGAIN and goto out after setting rc to 0.

But that does leave the MSR protocol open to the problem that you mention, 
so, yes, retry logic in snp_handle_page_state_change() for a -EAGAIN seems 
reasonable.

Thanks,
Tom

> 
>>
>>> an error also terminates the guest immediately with current guest
>>> implementation. I think the best approach here is adding a retry logic
>>> to this function. Retrying without returning an error should help it
>>> work because snp_check_and_build_npt will be called again and in the
>>> second attempt this should work.
>>>
>>>>> +
>>>>> +               /*
>>>>> +                * Adjust the level so that we don't go higher than the backing
>>>>> +                * page level.
>>>>> +                */
>>>>> +               level = min_t(size_t, level, npt_level);
>>>>> +
>>>>> +               trace_kvm_snp_psc(vcpu->vcpu_id, pfn, gpa, op, level);
>>>>> +
>>>>> +               switch (op) {
>>>>> +               case SNP_PAGE_STATE_SHARED:
>>>>> +                       rc = snp_make_page_shared(kvm, gpa, pfn, level);
>>>>> +                       break;
>>>>> +               case SNP_PAGE_STATE_PRIVATE:
>>>>> +                       rc = rmp_make_private(pfn, gpa, level, sev->asid, false);
>>>>> +                       break;
>>>>> +               default:
>>>>> +                       rc = -EINVAL;
>>>>> +                       break;
>>>>> +               }
>>>>> +
>>>>> +               write_unlock(&kvm->mmu_lock);
>>>>> +
>>>>> +               if (rc) {
>>>>> +                       pr_err_ratelimited("Error op %d gpa %llx pfn %llx level %d rc %d\n",
>>>>> +                                          op, gpa, pfn, level, rc);
>>>>> +                       return rc;
>>>>> +               }
>>>>> +
>>>>> +               gpa = gpa + page_level_size(level);
>>>>> +       }
>>>>> +
>>>>> +       return 0;
>>>>> +}
>>>>> +
