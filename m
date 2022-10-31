Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4430161403E
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 22:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiJaV6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 17:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiJaV6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 17:58:47 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2083.outbound.protection.outlook.com [40.107.244.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029DB13F1B;
        Mon, 31 Oct 2022 14:58:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A5kSv6ZIaMwxASKoISea/qblymKcex0U9tQ+1X+GdFErpGcOPfqYelax2WVOirUMN8l2BFFuMbg6/4Q3cFDdzosYotKyp5YIYMudTL9Cv8nSz7BR3S6bS6/atIGFJPz3eMHIkAK4DZo/wHdNMVYClu+26HwQH2R75pZ0toj9FFYYm/1mJ7htwt96DjECOfqe0G3iTJoC7rhMS4OUBset3VVFghQGD9Umsz7NZK2pwa4F74+YxycuOk3JpH6ISp5qddbmcuieL70p3aKWmbXJOgpyas/jwKp73FcxczdFI0I1hoOIIYssHYE0Uhr7McpwBK8AOQDAb5elAUj2iG1mpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S9fDTg0niu/ErLEPDsEctK++fODe4kOhzChqCvj6XkY=;
 b=PFoQZgNJf+rHcpPWvTc2BpOV21G9/qlATwU0kyVlvNQa5DBzLdJiRvI1aJkh/lS5XouG7jSvmBPspMuDi5ZxqTnH3HAvvHXZa4tfq4eNi5p77d7oOVkqn78FLcjhEYpEPA28tY6tuVWVzv/lCL6TL3679TDdPf6IqEh7hF8rq4jwMtLLxO7ngAnaEirvNumweM43NlsgdoOd7+YA+fYOP/e+AmvxvroasXNlbvm326Keo1wZI5zEeBaRcn3q89I8R21e8lRapPTz8/OdsKa2CE0ZLxEhFD4uvIr7EN2JuHJYa0aPP/k5P0deMCiE9FOiEPGUWCv7R1zTNa1POzAt/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S9fDTg0niu/ErLEPDsEctK++fODe4kOhzChqCvj6XkY=;
 b=1ziccmKw6dCllskpLsWT/iZxh5M081d28odJIOySPVY9Nw38L8M2afTwFMxoKSepSsJz0E+WhbJKcHc1h5VOvAhaXEHbzqRfX/oNdmgZQbBx+Tb71g1IFE7s1Od6x3jfKUbXPdQPmbo8pO0q6/ROzzMy+Xy0ns7lZmxNGZm2Mic=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM6PR12MB4546.namprd12.prod.outlook.com (2603:10b6:5:2ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Mon, 31 Oct
 2022 21:58:43 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::36e7:b51d:639e:ed6c]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::36e7:b51d:639e:ed6c%3]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 21:58:43 +0000
Message-ID: <dc89b2f4-1053-91ac-aeac-bb3b25f9ebc7@amd.com>
Date:   Mon, 31 Oct 2022 16:58:38 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     vbabka@suse.cz, x86@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
        thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, michael.roth@amd.com,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org,
        "Kaplan, David" <David.Kaplan@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <Y0grhk1sq2tf/tUl@zn.tnic> <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
 <Y1e5oC9QyDlKpxZ9@zn.tnic> <6511c122-d5cc-3f8d-9651-7c2cd67dc5af@amd.com>
 <Y2A6/ZwvKhpNBTMP@zn.tnic>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Y2A6/ZwvKhpNBTMP@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR01CA0054.prod.exchangelabs.com (2603:10b6:208:23f::23)
 To SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|DM6PR12MB4546:EE_
X-MS-Office365-Filtering-Correlation-Id: 610de78d-1348-4e6e-a3ec-08dabb8b13ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UwjSg1jg30vSh+jy21PNUiKtjPqP/TcyBBGiO3JRkdnIhoXFu8esQBmG+spOUlS/yi7jpT2v2TrDovHacw3JM6w0jmHiiyY9/Vs5OzP92RKmLf8zSe4qZzZkpFxqz/RsL5OFrIhQx+xTU24yr2NXgG8u/8jaZCWUHRqI+ABQf5g9b+6eC+xNeOzCtbljJ5zhPewIA5Eosb8s7oTYf6S7rwYaVxar841wMVDTNpGbwkO53U3dH9IjMr9ilVzDN0QZ33thymGiJZoQFm6pmWV275oV7TY7VKlB3B4qkyQ3EGx3ZpFpRnFgGMNEaTr2WYOJ2q/tckdJdaYWqy+Q+C8Bo42cdq1cimwD6ejAPElDsNjpZeQWyAo0E8ZXYZxgmGpO2ovZUm8iJp/qMVDZctruptqd62rl2QcmhVZrjl5IbkRTvByklV9mM/pMkWF9giNl0eIHbuTOAnxtrv8Eavyzl+aV5+188KYEF9niKKrjXHSE0GDrPWcFo4LTtl4LndYOuno4AL8GMNE7injbBdng5ZlDG3XP96u57CXz03oxQ8RYxCwWphnUT9ZfNjaWTe7uSpjbIdCzkG9XSHiBdX4mNfRM26LbBADxh4kanG8QB5sPu7GQe/WjgRge8P7LZjt7/9LgRhFGi8zaz5gy9S1cX03MX0XHx/QF8ic+bD1Xd3eh0m+e1Rp86u9wkBbiETLFbQT5dN7GWb5bCt1oH1C9uxDFw3kVqdrijCX0T/uIjvggEcO/w6zU3Xp8KFk3dew7kPgv1P+Cxe5DzTUUQQfshMe0KNejXR74Au4d/Mqaxss=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39860400002)(346002)(136003)(396003)(451199015)(36756003)(31686004)(38100700002)(5660300002)(2906002)(7406005)(7416002)(2616005)(83380400001)(31696002)(86362001)(6916009)(186003)(6666004)(478600001)(6486002)(8676002)(316002)(66946007)(8936002)(66476007)(4326008)(41300700001)(66556008)(26005)(53546011)(6512007)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dklCSHBKOEpQRDNPZzlVWjd6SVRENzExaFIwSGp1N1hJS2pUVWttS25rTVIv?=
 =?utf-8?B?bm91d28rMlVFci93dXE3dENwaGgxRjJHMWxxdklZcCtpekpZUzVMU0REVGFC?=
 =?utf-8?B?dWwzYWhsbThMemUwV05vZnYzemtXM0FjWHZRYm5WcXl4MzlEQ2FtWThFdEd0?=
 =?utf-8?B?RFlSUU41blZONVpQcHBGUVpCV3VGK09yc1JYZURFMWVHNFNGZWo0MWRBVzJS?=
 =?utf-8?B?dTIwZ3plbHhlcE9ONkZBeGM1MktFMzVUNFBRclBRZmF4cC9UN0orYVdBMXZ0?=
 =?utf-8?B?bVYwbFVMc3hQZjV1QTJmRTU2dGZoKy9iMklBU21UZ3FBbG5tSlRnajVqTnBn?=
 =?utf-8?B?Y1c4emNSNzAyNXJiU1FqZDM2eWt2Q0taYVdJWG1LcmFCL3RjRTJrbElIRkpU?=
 =?utf-8?B?bVFkVWdrMTJCd1FtZkxZOFNtVmgvdjlTR2JqSmxYYXNULzhyc2NhVlpueE14?=
 =?utf-8?B?TndiYTIrQlVDTFNIV1ovN0t4Nkc3L3ZHdFRMNmVER1NJY1RBWCtqV0hkV0FZ?=
 =?utf-8?B?OWRNSFBMTHprcERwU2Z3Y0VQSktIL1VyMW0xYUNLZzF0V05abGVpaEptdnV2?=
 =?utf-8?B?OVFRK0V0MXdRaEY3VkJwbzhNdDFsY2RsUzl1T3Zkejl5dE9oQ0dYQXlnV0cw?=
 =?utf-8?B?bTh6WmJwekFIMFBOWEF1b2FnU1NHRHdaSzcvZERBTzR3VGk3QzB4Z3JoM08v?=
 =?utf-8?B?MG1lMGJpYzk4UW1CckVIZ1NidWRJdW53NDVtSU9nQTdNV2EvUDRnRkNETmk2?=
 =?utf-8?B?N3U4Wk41anRTdXNSWDBNRWtYV0hSUDI5bzlYVWhWcmFJWXlpcUtzSnZmL2Y1?=
 =?utf-8?B?NDBXczZIbGRrelBUa0ZwcWg2MGF1MTZldFZIbkFDanFwdU9NdmlhMU5teGMr?=
 =?utf-8?B?cDBzNWdwelpsTUhCQXdqMCtlOHVDWHhJYXJGQmUveFpGR3crdnZkVTdQakJj?=
 =?utf-8?B?bkRjcFBRbmprZnc3WEMxeEdJNWlONUVnQ0pGaEpIYmo5RFRjK3lBaTAyQ2ZL?=
 =?utf-8?B?b2JoMmJObEYrQ1hyTkJ4anlHQk9wZGVUS3RRVTcrbUIzbjVyYXgwWjBNeE9L?=
 =?utf-8?B?WklGenRtOUVTVU1oeDhWYmVKTm4xZDB5d0gyV2Q5ZTJOSytkWGtqRTFWM0Rq?=
 =?utf-8?B?NEZ1RmlPY3BsRXBDS0RMK2ZUb1BkQU9pRDJ3Y1Q0OEZmZFN5aEZkTjkxbXhy?=
 =?utf-8?B?aHM5TXJwcDUwN1JWKzRGbU1xTVlwa0hxTnp4OURBZ1pYZmFHYnBCN29IYm5W?=
 =?utf-8?B?UU9hNVZpWU4zTUxvQ2Q3ZHBPR3loa3pzRjlWcXFxVi81RHJqUnBMQVNseHFv?=
 =?utf-8?B?QnZRZmN6dG05eVVjQWlqU3NYQzhtRnVWMm16RkVBcjlRWFVHbFU3dzFkRlgv?=
 =?utf-8?B?bW42UGgvUm5WNEc0KzdPempHVnQ2dnl2bUlIVG0yUmYvSDhYaTBFYzJLYmJK?=
 =?utf-8?B?clRxVWZ5aG10Zk5zNUZuR0ZyM3NjSjRldllKNHdjcXo4YkF1c0lqUXBHNzBq?=
 =?utf-8?B?bXV6UHcrV3RYZ0tRZEw5QllSY0JhSExhb2VTQjJGSWJybTRQcWY3cGg4WHBY?=
 =?utf-8?B?K3NkbzJqZ2lweDBDVW5tay9uZ3BXZWhWM1dGeWs0ZGsyYytFRjEzckpjUW1u?=
 =?utf-8?B?ejVLdkdDSlE2VFFPcTlIb0RrYlcrbUtKemplR2RGYW9NRFNWcjUwUDFzemlW?=
 =?utf-8?B?cjY4aTRERTVhcHVkRWExaDlTQmxUVUxxS3N3LytjZ1hBZXZDWGRKV0tXdzlZ?=
 =?utf-8?B?WFhJMERNVUZZcU1uOTRqeGY3dWR3QWp3U2pVZmMwZ0QydjFmUHRkcWJsUFBP?=
 =?utf-8?B?SlAxSHVyQmFIOFloL1VFekxncUJ4VVo0Y2t0OUNVcVNISk9SUHNOdmt2bnpS?=
 =?utf-8?B?TU01Ti9vcThHVmZsNW9Pd2dRRC9ET3E2UldKeTdmeGVGM2thWHh2M3V3WGow?=
 =?utf-8?B?ZWZWbGVrODhmanFKTlh5Tjkwb2RGOStqZ0VFc0NNVTZqUnN2eXR1Y3haKzRs?=
 =?utf-8?B?ZmlneTBFdVh2M3lYdmNWQVNQZ3ZkZGFiZ0VlbGMvSkxKcEJseW9XZ2FoVDlH?=
 =?utf-8?B?TmgwNFozcURxbHJBdTZjczU0UGtkVHdTVVdyWXdBc0dHNEZ2UmlGcmZ1Tm1R?=
 =?utf-8?Q?t3DTfcsaVMLFVrr7lJQ1sGnas?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 610de78d-1348-4e6e-a3ec-08dabb8b13ce
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 21:58:43.5535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jak0Hew1op0zb42Yv//gPIY48NiX8Qoetz8LcsCRX2csqzPwsaMUIELtx1KUEAt6j+pKHxC+AujcLKbDDUKO+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4546
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Boris,

On 10/31/2022 4:15 PM, Borislav Petkov wrote:
> On Mon, Oct 31, 2022 at 03:10:16PM -0500, Kalra, Ashish wrote:
>> Just to add here, writing to any of these pages from the Host
>> will trigger a RMP #PF which will cause the RMP page fault handler
>> to send a SIGBUS to the current process, as this page is not owned
>> by Host.
> 
> And kill the host process?
> 
> So this is another "policy" which sounds iffy. If we kill the process,
> we should at least say why. Are we doing that currently?

Yes, pasted below is the latest host RMP #PF handler, with new and 
additional comments added and there is a relevant comment added here for 
this behavior:

static int handle_user_rmp_page_fault(struct pt_regs *regs, unsigned 
long error_code,unsigned long address)
{
...
...

     /*
      * If its a guest private page, then the fault cannot be resolved.
      * Send a SIGBUS to terminate the process.
      *
      * As documented in APM vol3 pseudo-code for RMPUPDATE, when the
      * 2M range is covered by a valid (Assigned=1) 2M entry, the middle
      * 511 4k entries also have Assigned=1. This means that if there is
      * an access to a page which happens to lie within an Assigned 2M
      * entry, the 4k RMP entry will also have Assigned=1. Therefore, the
      * kernel should see that the page is not a valid page and the fault
      * cannot be resolved.
      */
      if (snp_lookup_rmpentry(pfn, &rmp_level)) {
             do_sigbus(regs, error_code, address, VM_FAULT_SIGBUS);
             return RMP_PF_RETRY;
      }
...
...

I believe that we already had an off-list discussion on the same, 
copying David Kaplan's reply on the same below:

So what I think you want to do is:
1. Compute the pfn for the 4kb page you're trying to access (as your 
code below does) 2. Read that RMP entry -- If it is assigned then kill 
the process 3. Otherwise, check the level from the host page table.  If 
level=PG_LEVEL_4K then somebody else may have already smashed this page, 
so just retry the instruction 4. If level=PG_LEVEL_2M/1G, then the host 
needs to split their page.

This is the current algorithm being followed by the host RMP #PF handler.

> 
>> So calling memory_failure() is proactively doing the same, marking the
>> page as poisoned and probably also killing the current process.
> 
> But the page is not suffering a memory failure - it cannot be reclaimed
> for whatever reason. Btw, how can that reclaim failure ever happen? Any
> real scenarios?

The scenarios here are either SNP FW failure (SNP_PAGE_RECLAIM command) 
in transitioning the page back to HV state and/or RMPUPDATE instruction 
failure to transition the page back to hypervisor/shared state.

> 
> Anyway, memory failure just happens to fit what you wanna do but you
> can't just reuse that - that's hacky. What is the problem with writing
> your own function which does that?
> 

Ok.

Will look at adding our own recovery function for the same, but that 
will again mark the pages as poisoned, right ?

Still waiting for some/more feedback from mm folks on the same.

Thanks,
Ashish

> Also, btw, please do not top-post.
> 
> Thx.
> 
