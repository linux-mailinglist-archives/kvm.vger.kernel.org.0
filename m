Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452BC6368F2
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 19:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239807AbiKWSdM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 13:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239731AbiKWScc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 13:32:32 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2076.outbound.protection.outlook.com [40.107.212.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50088BA3;
        Wed, 23 Nov 2022 10:32:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mgX5Lfr+ltAJsC+HIF8gNaLou746szAghmzpIv+cnvPLxhEb30oh9iIcGOx+xu/sR2Cndq7aV+S0FujuwhxsACS0RgsMOPlvMq8MdD+OT0y7b8575RzxIXF2ghr4Bd8QUPp0sUQEDkSEOuempjbPk890Ii+PzlUtZr3kHSSjXEm3JrNUoPeSXIjFl2t6c2GkZLB2JVcDNOHWAeHj1OroqhRP0OM8vhjuEyjm3RyCqVsuiK31BzCDTTkFor/kW3tWMCWFb9Q19Niji7AnLjF80f3E0XMQt7dOinA1C8fzOLiAHwYyrwRgYtDsmS4YHNp+DARGpCJnAQ0KbthlWg84nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hRiqhIiXO8GIT2UWTrN75zZblFyLZ1f1hjv2WVtrmes=;
 b=fxU2DqdM5POq1qMKP3eFUxpDFH7VZDAOAn+bclpQGHqMu2vxAsRrYZOaBu4xNeRXsVMRz1T4yMFsciiA+5wDwMR84NZsRNzxKiCXKYA7zg4fartDthof2tLMoMao+NycFFFPOag6pAomOGYDYlxG5diq50cyKZolaHr/v7dyKIDexcWqKCtq30Eh4LkfUUXgfRnX8muedB47SVUpGj8H6EfO+WTDDUcTZM+I6FlWGj6hZaS4iFTGp0SOg5roR1QmsL8M6u8SpjDsk05KHCifvifyKWKMmidAeCSBuwEYpPVOkQUxEjWbrU39ulsVW1kTRJvHDxZxfiqymiibcabkUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRiqhIiXO8GIT2UWTrN75zZblFyLZ1f1hjv2WVtrmes=;
 b=zK9YttOS4wmFfprCecn2IPlT3aZGL3Z7PR43c/jJOOsjwcS3fRV32kOqjSwppWUo9gsWMEof0LEYoAdiZXYDCxT+NMInh07c2ekSF+pQwfYp5ITeVD5mTW/usDt0waaVPoo9meFfaJC++Jg4tJLUfZHEthTfBPgKFlACmnrmZic=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN7PR12MB8148.namprd12.prod.outlook.com (2603:10b6:806:351::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 18:32:25 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894%6]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 18:32:24 +0000
Message-ID: <57c77407-d0bc-5e74-490b-f604b4f97691@amd.com>
Date:   Wed, 23 Nov 2022 12:32:19 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
References: <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <Y0grhk1sq2tf/tUl@zn.tnic> <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
 <b712bc81-4446-9be4-fd59-d08981d13475@amd.com> <Y3qdTuZQoDZxUgbw@zn.tnic>
 <cffed3c2-55a9-bdd3-3b8a-82b2050a64af@amd.com> <Y3yhthJTIWqjjAPK@zn.tnic>
 <d85bf488-9050-13d6-a23b-1440a4df4c81@amd.com> <Y3yoB015qCpbnUzl@zn.tnic>
 <13bd73b6-592c-66c4-cd42-0913380da745@amd.com> <Y34GuNXaa3csthJY@zn.tnic>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Y34GuNXaa3csthJY@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0078.namprd03.prod.outlook.com
 (2603:10b6:610:cc::23) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|SN7PR12MB8148:EE_
X-MS-Office365-Filtering-Correlation-Id: 7abe33c1-c0db-4fbb-1bbc-08dacd8110e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FtZ1bXNdZhF2l5o7CX4i4o7WRHchBYgcBPD/vyGoIxD6zsIQkAU+C/+pT1CaBpGgbomi01VAuiH7RXawyoCNIRE9tnDmGk3gPsXJzzXbR0jZsV4ilG8iR1XoUQqFZFBqL7mswBvQ1jb6VgwcJ2BTCPIcBufZvziu1JrI0iukcltCWLB/iPDr6RrSeAP83liV/L+nXBQMonOge9CKpQV3ZTCxLzPli4oxzEtNC3iAQGermF3EN1wN6yU9nackyGWM73hseNkkMbOK7qVrKIuUBnL6LU7s4BKbL9E21QdJ/j32UIZQfx4On9xsktItjTvCrt62L/vknqvLEtDS9zDsPoqHnn+R5yFCQoC1q4r9yPZHZpqaTyX3lj7zgHWQdOtasdF99u4yWyY1F4vVziPhE6UK6KiPTNChk0Y+FzNneaoc0I1eE7d2SBDp6bor3As72GysHqDZ1dkGrfDnheCeheAy+rI39ikTQjiB7Fp34alK/PAJct1KX1BsGUFB+iTCxQkuUy68UKTHGOniEMAv7zqJUoePIqWLnZJM2wTqD3vGIL5hGMkVOhL9sur7eeYRRmObdU+MfmZHfrBSL9r65Ah4ZhNFGEjUwp36FYQJ5duKt+5kC3vnTF3Y+nTUo3JS+t5ESH1RpPt8goRNlqCs9LFYxoEBG9c9kIY9d67UwjrQe4rCTEb3A31uLSeQQwm6hHIh6Nvwq8NjZIhnEhj7BXeSBYYGT0wHnoSvVkSLwEI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(39860400002)(136003)(396003)(346002)(451199015)(36756003)(31686004)(31696002)(86362001)(5660300002)(26005)(7416002)(2906002)(186003)(83380400001)(6512007)(2616005)(53546011)(6486002)(7406005)(38100700002)(6916009)(66556008)(6506007)(4326008)(66476007)(41300700001)(8936002)(6666004)(66946007)(8676002)(316002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TjRsOW1xMDlzQXVYZmY2OHNud0JEK056dnQ4UnNUNCsySXpNajJFNFhKRklU?=
 =?utf-8?B?M0tON1lVay9wR1JmZkIyamJQRXBrdElueUowTE5kZ1dBSzZpY3ZrY2xseTA2?=
 =?utf-8?B?ZGNLcXZWU1J2dHBNUGlza2IyMmlsbGtQY0FJN0MvMHp6bVZWRkZxY2lkT09t?=
 =?utf-8?B?aVRtRVVVZDhkZERRUGRVaXRWUTdLOHJKNmpETXl6ZGUzNVlUQVE5UmN0YmZD?=
 =?utf-8?B?anFOa3liVjlLdHlROCszcSt3S0hWZUFnbnBGd2VuL1dnSWM5cTROMUQzY0NJ?=
 =?utf-8?B?S2p0b1lTQm44VTY4MjFkSlM0YWFXSitwMUNrNXNZTFRROGdRVUhHU1cvMDBG?=
 =?utf-8?B?MFJxTDdZY2dtZEx3cDY3NzVUbUNGYklRRWJVZmdaSzIyUjFPVnlSc3pBcjFp?=
 =?utf-8?B?VEZYYklRSUNBMkdmaDZwNWY1ejJPQytrS1Rib2QrS09xUkh3SEd0NVB4Tity?=
 =?utf-8?B?RE1LOFZreUNrTVBwNE5JSEdYemZrcm5MS1BGNUJpQnkzT2ZIOEM4by9XYUh3?=
 =?utf-8?B?OHF0dHU0TWExWkdKckwreUFDejM4ak9IRnVVeTYrbFc4emw0N09XVEVGcWFl?=
 =?utf-8?B?SWUvOURWejA2bnVWRFBQVGlwUitvem5OdVVmTm5YeVRtMmpFN0U5OGxjWkZU?=
 =?utf-8?B?M0hLa3ZBdTlUNlUxdHg4cFA2dmlESVcvNmplQTdrb080TFNUYWhKaXB1bGFi?=
 =?utf-8?B?QkozNCtSZkhwNlNIWnRFQm92Tm82SklzMHlrVDRKWGxES2psZFpiQWZramY4?=
 =?utf-8?B?NXV4Q0ZyeHZ6TnN1M1N1b2VPbStkQ0JvVlUzTnhMSmpsSjFQcmU5UXAxQmFx?=
 =?utf-8?B?NzNwdzhpZFlZdVcvbXZ2Wm1QdUtxZjNySlU4dlc3ZFNla3lYbGh0Z1ZNSi9o?=
 =?utf-8?B?UU9nd0NsQVphRng1d294aDJSMTk3YWtlRjB3a1FFZVh4QWt1OHVjRmhlWEEz?=
 =?utf-8?B?VUgrblNYTFFkY2hDeXp6eW1VUkNZYTkvNXVTVlhiclJFdVNNOGpScWw1ODNn?=
 =?utf-8?B?NjdiVk93M0w2VHRWUTVmWGNoTnVGSmNiTFo1dkluM2JIbmhaNHcvMVA5RVdI?=
 =?utf-8?B?LysvbHFSdEdkYk5BK0VUWm50TDdYTEwrV0xvbFRna2xGQnN2TU5Ba0FoMTRP?=
 =?utf-8?B?TlV4OGowVm5nM3JuSUlHd1pxRmF5UHA0Q2JyRG5JT0ovOHhDcnZBNHdLeXlZ?=
 =?utf-8?B?UFl4cGVOaDNEK3RlSUdDeFV2NG5OWTFza3h4WjE0Mmd5ZUNUN0JBVzJmTTlh?=
 =?utf-8?B?Nlh1OVo3aVY1SVA1ZEFrbnhDMFNvMUVhb24wUjdRQmxKVGhncDg3blErL0o0?=
 =?utf-8?B?RUhVVEg4VHlnbExwUWxDMWNocldtOEFYeDRLZWF1Mmt3ZzdlL1lGK2hrUEkx?=
 =?utf-8?B?MEZhYzVtRWR6dTNnUHpBMzFxZU9Ua09BblErT3ZiRFA3UC85Q0o4RjVOTi80?=
 =?utf-8?B?UnlWOUdQVVNkdVlpd2d2VkJicGpjSFZUanA1Wm9YTWgvLytVODl0RHBrbk80?=
 =?utf-8?B?OE0zbm1SeXJJcFpVc2dTNzljbml5SlhaOGplNTYvNGw3WFNRakN5NHY3aC9R?=
 =?utf-8?B?LzNMQWtLWGc1UGc2UjRyRStjRFJuc09INXdUbG9jTDB1MForT2F3Y09VR0J0?=
 =?utf-8?B?UFZCaFc4Y0JsK29IOElPZVhvNWM1R0tIZWpicXI1bTcrSCsrTXVoNHQ1dklD?=
 =?utf-8?B?ZStqR1Z1aVpsTXBSZkIvNm5OT2c5eEc3RjJ0Smt2Rld1Z1JlTzh1ZjZEU0c0?=
 =?utf-8?B?bjg0ejFXNG9sbllhRVMya25ZUTg4K2daeTkwOUxjNVVvTmdQSEtYL2RYV1ZB?=
 =?utf-8?B?QnBxZHBZS0tzRTVPYzhBUStsZHhHdUx3Y2xVSWNhL3BDSURoUUJpTFpKK0VD?=
 =?utf-8?B?alAxYnM5OE0xOVlqUXUyTE5WNFlpd21yQlFNdDlBZnBNTXFDRzNsM290eW1x?=
 =?utf-8?B?emFpcURBMjdkdWtaK0ZZRUxHUkpJeE1yMkl5ZFMzdHR0OGVHVEd2VUE4ZEZk?=
 =?utf-8?B?QlNwTnQ5bC9pOEdSZ1hlZVlFT1pCaHIzQy9lQnpUSXpFRm01VEY2TDJTTkE3?=
 =?utf-8?B?dmhsYVZLcjRBdCsvdGRaYktabW9CVnNEaGVhYm1DT21Vb0JpSHJ6R1phbUlM?=
 =?utf-8?Q?wk3aLGc7L7+kH+FEAd7kWDAFz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7abe33c1-c0db-4fbb-1bbc-08dacd8110e9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 18:32:24.6252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X00k21BPys6c6hCICrYwGLbNxPBulQisFoDNeCuPO3dOGTerQvWOT4+h9BGqaYtqT50u1X6QUia8AZhXYB9ihA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8148
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

On 11/23/2022 5:40 AM, Borislav Petkov wrote:
> On Tue, Nov 22, 2022 at 05:44:47AM -0600, Kalra, Ashish wrote:
>> It is important to note that if invalid address/len are supplied, the
>> failure will happen at the initial stage itself of transitioning these pages
>> to firmware state.
> 
> /me goes and checks out your v6 tree based on 5.18.
> 
> Lemme choose one:
> 
> static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
> {
> 	...
> 
>          inpages = sev_pin_memory(kvm, params.uaddr, params.len, &npages, 1);
> 
> 	...
> 
>          for (i = 0; i < npages; i++) {
>                  pfn = page_to_pfn(inpages[i]);
> 
> 		...
> 
>                  ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE, &data, error);
>                  if (ret) {
>                          /*
>                           * If the command failed then need to reclaim the page.
>                           */
>                          snp_page_reclaim(pfn);
> 
> and here it would leak the pages if it cannot reclaim them.
> 
> Now how did you get those?
> 
> Through params.uaddr and params.len which come from userspace:
> 
>          if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
>                  return -EFAULT;
> 
> 
> Now, think about it, can userspace be trusted?
> 
> Exactly.
> 
> Yeah, yeah, I see it does is_hva_registered() but userspace can just as
> well supply the wrong region which fits.

Yes, that's right.

Also, before sev_issue_cmd() above, there is a call to 
rmp_make_private() to make these pages transition to firmware state 
before we issue the LAUNCH_UPDATE command as below:

            ret = rmp_make_private(pfn, gfn << PAGE_SHIFT, level,
				  sev_get_asid(kvm), true);
                 if (ret) {
                         ret = -EFAULT;
                         goto e_unpin;

                 }
...
  	ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
			      &data, error);

So in case, the userspace provided an invalid/incorrect range, this
transition would have failed and there would not have been a need to do 
any reclaim, so there are no pages leaked here.

This is also the reason why we need to reclaim pages if the subsequent 
LAUNCH_UPDATE command fails, as now the pages are in F/W state because 
of the rmp_make_private() call and they are now unsafe to be used by the 
host.

> 
>> In such a case the kernel panic is justifiable,
> 
> So userspace can supply whatever it wants and you'd panic?
> 
> You surely don't mean that.
> 

No, we don't want to do that.

>> but again if incorrect addresses are supplied, the failure will happen
>> at the initial stage of transitioning these pages to firmware state
>> and there is no need to reclaim.

This is the case i mentioned above, rmp_make_private() before the 
firmware command is the initial stage of transitioning the pages to 
firmware state before issuing the firmware command.

> 
> See above.
> 
>> Or, otherwise dump a warning and let the pages not be freed/returned
>> back to the page allocator.
>>
>> It is either innocent pages or kernel panic or an innocent host
>> process crash (these are the choices to make).
> 
> No, it is make the kernel as resilient as possible. Which means, no
> panic, add the pages to a not-to-be-used-anymore list and scream loudly
> with warning messages when it must leak pages so that people can fix the
> issue.
> 
> Ok?
> 

Right, yes, i totally agree.

So now we are adding these pages to an internal not-to-be-used-anymore 
list and printing warnings and ensuring no panics as we don't allow 
these pages to be released back to the page allocator.

Thanks,
Ashish
