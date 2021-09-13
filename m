Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 321CC4089F9
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 13:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238684AbhIMLSz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 07:18:55 -0400
Received: from mail-dm6nam12on2045.outbound.protection.outlook.com ([40.107.243.45]:23649
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238424AbhIMLSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 07:18:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J/urQFPjn679/UbKbaEFcQUNgy/sGYRmVspzLhUtBL/dusTXB8Z8DsEqVHBKvQtGH8vWArGvfZSKlG7oTna33R74Xbn5kRv8sbHxR8PUtvorniJKbG6okylyOrj+gsirL6RHr/rrVxJrKytRMa9VoKny/txTuk+mShFLcno3qL3/WOKuuRWZde8xZ/qcfYs1ucov+rKmzqc0r7GB1BOhVdP8fcgvtdaKY6EV0lVzNmeOQTDzJHrEotC3Nadwlk2myc325OOQXWfN0M233fXppdHHCF7qj3/5sGj2KvfeWOqgXTP15q9F/tuOxkvEBPzwymLgVO4/Pwt0EqKT6IrkTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=B7g8ZtqAMBz8GJFfhdD8SqJsY9Px/xqPyUUpUVYgAY0=;
 b=PkBG1qAOTEgBGEUJlhPUgcY0sIyhXrvsRg3xaxWJanpjM5g+/dMILj2YeDYLXyrVRl3L9ljaV3hVWk+wCXIS7pVhB5/cx/KBaAo3AQ1Crc7ZBZTakb+DGubruhnk+cIXtOliO83k7BIXh/nWpKV2Rikl9jT0AN1d0wkVjNN5aBUbDIdiA3qo8gSnDowwaxP88lx9ZbUDzOJDfNChtpbVS2PthGiWpzImVww1yIkCKTlbJopmdKDbniG4eGaOctqHrs3VJYHbX+96YWo1nIZeq9bLz6swqWBUJjZA/YJinIUoiB08W5eAE2Gk57vObP/W4WpfKZy54TInMbe0Q5pQog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B7g8ZtqAMBz8GJFfhdD8SqJsY9Px/xqPyUUpUVYgAY0=;
 b=vbAG3mToWMScGJzLh4AvU8BHZGGlrjMz9nT41HpcqtgMPQ1hM0lpC0cB0/grcoZ8ql8GcwbjWEM/KxTHBO9ztR2Fu7y87NrUdipXiXAiKWZja6T1wt+Z/TeQ8FuIk24Og/QX68J7koshnzNZJLLY+OtxIEvBh6HTMi2XUpVXjdE=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2542.namprd12.prod.outlook.com (2603:10b6:802:26::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17; Mon, 13 Sep
 2021 11:17:36 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 11:17:36 +0000
Subject: Re: [PATCH Part2 v5 16/45] crypto: ccp: Add the SNP_PLATFORM_STATUS
 command
To:     Marc Orr <marcorr@google.com>
Cc:     x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-17-brijesh.singh@amd.com>
 <CAA03e5EGXiw2dZ-c1-Vugor1d=vZPwrP81K0LmpUxTrLCbc+Xg@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <642ea2a3-1a4b-ae59-5ece-37b06b0b2090@amd.com>
Date:   Mon, 13 Sep 2021 06:17:33 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <CAA03e5EGXiw2dZ-c1-Vugor1d=vZPwrP81K0LmpUxTrLCbc+Xg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SA0PR12CA0022.namprd12.prod.outlook.com
 (2603:10b6:806:6f::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA0PR12CA0022.namprd12.prod.outlook.com (2603:10b6:806:6f::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 11:17:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: caaeb201-3b5c-420b-aca1-08d976a816fe
X-MS-TrafficTypeDiagnostic: SN1PR12MB2542:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2542D21F8F4E6EA4D6E5A476E5D99@SN1PR12MB2542.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: okQbUWM5GmdgMcMA2XI63wYXVWOp/jsHVXfdE8F+5FFnB4bTnkKdKIu/jwYKfna3BFdUUKNGfdR4RgqFS7yxm1Mnq6Q6Uq6xhYdp4MUN8zrbd1M9CdHXBooFnZJdpbAR4r4HvoYlAYzrEp7A6ocXIVs9ho/5SeZZOginYyLZzp9vkY5sISsjIlVqpO2vvlf49tVYdREzvjNOxSaTSGnACRiZMO+qTGXew7xBtMMaDYceRyUOk2J88DPyBhftd74x3eVCNsqrgzpaDZF0Ykte4GjoHPiBS1frKQ+ON3itleVV0vvKoSRtkGOZxWAFau604NTSKfOb/q/BOnyLn/Nf9oLcrVldEsPBphTi0XZ3H5hqETBro0hU+iHcxIrRZZCZsM/mp9Cc4X8I9HHe6PsRc9UfVWergN5+Sb5rG0XbGdRU8jhSuvLuM4k/UXE10uciD7EsRidXdATzoE3JKGgJLLvjiU19OmO8NRiE+vNgPwhkxHmvqgDMtIPRN/SnvnQ2ucLtxauJ5sc8UTGS1ld+jqji9EgzbO4JctqxNR5q5MNX0p2Z/0wdH3p2h4h+2qHVAlLwdIR/QYgKpe+i8UzmkBbXlWvWdO7pGb54aKWVyhhT5YRlVahdnFs+o80dMKA9bCrjuIlgUJtDlTpJVAhW6T8PVMaCms2VZt1ABJEb2i3JVOnW3ShncW4f/6sk7OZ1ngV1Erw7B9+CYTgxLUxXu2K55xhLgx5ChxmjHmh9Miyfrnj6RBzYMklowNsPrK0kEsXTQD5srjvKVCns67eerg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(39860400002)(396003)(346002)(31686004)(26005)(38350700002)(44832011)(31696002)(6512007)(38100700002)(2616005)(956004)(7416002)(2906002)(6506007)(53546011)(4326008)(36756003)(54906003)(478600001)(66946007)(83380400001)(6916009)(7406005)(316002)(66556008)(86362001)(8676002)(6486002)(52116002)(8936002)(186003)(5660300002)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHdHRThybWJqcXBnTGNMSk9kVjNaeGF3ZnJYb2NTaHdYOUdiMkt1TWw3NUZ4?=
 =?utf-8?B?Wk40VTR5Um9EN1ZERG9PcnBpS1BuSzVZaHJIMlNpK3J3bjJNMDVqOXM3TjJo?=
 =?utf-8?B?Rkh3eXNuNWRUQTgwN3VzTkVBbWtyV01lREdGVlRGd2xvWS9GMkFJb1J5d2Z3?=
 =?utf-8?B?Ylp0Njh2S2N6ZitZMkpPTjV2OVB6Rm9MTnVxemxTVnM3MVV4UjNwMFJyeU9F?=
 =?utf-8?B?aWROZkRIQXFoWkdnbjc1TnZuaXIwcVA0a0ppekFSbzIxL2NzcU1adzk0ZUd3?=
 =?utf-8?B?UlRIN0haSTI2a01UMVBpZ1gxVU1meldSamRCczBtSXg2bDZqY3RpRU5mT0V6?=
 =?utf-8?B?bTNNYkkxMWh1VUVjMmhGc1Q0WXMxWHpMNFhJTzhMK1FiWkJGUXRyc24rcXMy?=
 =?utf-8?B?bXExOUJRNkNYem9zNlY0NzhWSm1NUUFXaVIxcmlPQmFjRkRub1h5eXJsNzBM?=
 =?utf-8?B?K0FoU1RkVEhtaFRKRHJvU0x6WU5DbithV2p2ZGlmOW80SjBqTkNvR1FQRXRI?=
 =?utf-8?B?ejlxR1pOUjVvRzRJOGlPNFVCeGhPdk9jRTdGTzhxM0VyNzQyeVN6NWpzRlpD?=
 =?utf-8?B?dzFvcHdjM3dBMURiRStJc1JXdlRWTUNRdXlUSWlSeGhwVEVpSlV0ejh4a2w3?=
 =?utf-8?B?aXFvelBvbkZZSWNHR0poTCszdEN4UEU0dlFMNGxFNmsveHM4cWk0VkM4eWVW?=
 =?utf-8?B?Z2VLdTlkS3ZLVnFaeFRxVVZweUJKdWNFOGxZcklzdGJxczd5djhDUElwWXBE?=
 =?utf-8?B?QUR0TTh3RHNKQU1nekptdDBiY3lWU0gwN0NEVXpQSGtjYkY4bDdzUlZXRjlq?=
 =?utf-8?B?UVdMTlpyc3RtNTNiODFPQjU5allxTE95M1hIRmNOUE9qNGhzelQ4MHd5SWo2?=
 =?utf-8?B?TU5rRU5KU2ZNcGpKMVB0TDh3K25QRTREenhLZmhUdjk2RHE2WGdkN095b1Fy?=
 =?utf-8?B?S0dyYVIrRFZCSlJ0OE5zak1iNkNKUlBnK25WYyt1bVZGSFVnREZoWTdyTEZj?=
 =?utf-8?B?SDBoMERuelhWYWd4RmZCTTEvMWlxWno5a21CUkJxWnZSUHBmdFlIMmp1ZVd3?=
 =?utf-8?B?bVh6QS9LTTl0dnM1a1dSV1NsM1VaR04zSW5SdnpsZjFETFNENFpMdWxlUVVk?=
 =?utf-8?B?bHRHekdOaWVCMXJRRCt3Q29nZEgxY1VicE5DelhUYy9xcDlrd3IwU0t5cFlv?=
 =?utf-8?B?WkdWRTZJUlF6NzNpaE1KUUMxTmhvRS96L0tLYWdvdlBDMUswZ3R2Y2ZSZ0RO?=
 =?utf-8?B?U1NSaVZPK2JQZmpMV0lqeXNNRDB0dWJNOVM3RXNTSU91d1ZsRzF1ejZaNzA2?=
 =?utf-8?B?QjFSZkVPWlVhOHN3WENXYS9MWEU0dXlnb2xZR2VpV2J1ZWl0aUU2Qzg3VTdl?=
 =?utf-8?B?RWZvUXJhUVFZelhLQTM4Mno3YWdRYzV4ZXRIaGRMMmdwU3lvU09QNkVJZ1Nz?=
 =?utf-8?B?K0NROTlPd1ZzSVZHNm9HZ3lCRzRVWHhaQ2lWN1VRQU9laiswUUZXOEY4Z09v?=
 =?utf-8?B?MlJ5a2pzME5JWlQwN0tKYVRDbUxXRnF4Nm1yTVFMUk01VllhR2tkZU1JblBD?=
 =?utf-8?B?eDR4cnJCN2hvNlpScWt2eWcveEl6a3AvVW50KzZ0Z1VkRlZhaVpLbVBWVU9S?=
 =?utf-8?B?cjVucGhkaFhqQ2RsMVlRYXJwQVFPTXNoQVZFc2U5MUU2OWdKc2NnZXUvdW1a?=
 =?utf-8?B?RStkWkJYTFdMdlRLT3d2MG9yUnVPYlA5WDlZMFZ1bnNDeDVJMm05QVp1V3Qz?=
 =?utf-8?Q?GzZQFf2uBE20BacNa2iuUysEaSG0OJZ+A1NeMWf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caaeb201-3b5c-420b-aca1-08d976a816fe
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 11:17:36.5746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7fGCBPb4zFLU3xQa1K0f7Ih9Ib147LPZfHi1Ui4Eb81d3FIuwH+UT98iZLRcmPxjFJc3bB3qnZeyi4dVmvsrNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2542
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/9/21 10:18 PM, Marc Orr wrote:
> On Fri, Aug 20, 2021 at 9:00 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>> The command can be used by the userspace to query the SNP platform status
>> report. See the SEV-SNP spec for more details.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>  Documentation/virt/coco/sevguest.rst | 27 +++++++++++++++++
>>  drivers/crypto/ccp/sev-dev.c         | 45 ++++++++++++++++++++++++++++
>>  include/uapi/linux/psp-sev.h         |  1 +
>>  3 files changed, 73 insertions(+)
>>
>> diff --git a/Documentation/virt/coco/sevguest.rst b/Documentation/virt/coco/sevguest.rst
>> index 7acb8696fca4..7c51da010039 100644
>> --- a/Documentation/virt/coco/sevguest.rst
>> +++ b/Documentation/virt/coco/sevguest.rst
>> @@ -52,6 +52,22 @@ to execute due to the firmware error, then fw_err code will be set.
>>                  __u64 fw_err;
>>          };
>>
>> +The host ioctl should be called to /dev/sev device. The ioctl accepts command
>> +id and command input structure.
>> +
>> +::
>> +        struct sev_issue_cmd {
>> +                /* Command ID */
>> +                __u32 cmd;
>> +
>> +                /* Command request structure */
>> +                __u64 data;
>> +
>> +                /* firmware error code on failure (see psp-sev.h) */
>> +                __u32 error;
>> +        };
>> +
>> +
>>  2.1 SNP_GET_REPORT
>>  ------------------
>>
>> @@ -107,3 +123,14 @@ length of the blob is lesser than expected then snp_ext_report_req.certs_len wil
>>  be updated with the expected value.
>>
>>  See GHCB specification for further detail on how to parse the certificate blob.
>> +
>> +2.3 SNP_PLATFORM_STATUS
>> +-----------------------
>> +:Technology: sev-snp
>> +:Type: hypervisor ioctl cmd
>> +:Parameters (in): struct sev_data_snp_platform_status
>> +:Returns (out): 0 on success, -negative on error
>> +
>> +The SNP_PLATFORM_STATUS command is used to query the SNP platform status. The
>> +status includes API major, minor version and more. See the SEV-SNP
>> +specification for further details.
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 4cd7d803a624..16c6df5d412c 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -1394,6 +1394,48 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>>         return ret;
>>  }
>>
>> +static int sev_ioctl_snp_platform_status(struct sev_issue_cmd *argp)
>> +{
>> +       struct sev_device *sev = psp_master->sev_data;
>> +       struct sev_data_snp_platform_status_buf buf;
>> +       struct page *status_page;
>> +       void *data;
>> +       int ret;
>> +
>> +       if (!sev->snp_inited || !argp->data)
>> +               return -EINVAL;
>> +
>> +       status_page = alloc_page(GFP_KERNEL_ACCOUNT);
>> +       if (!status_page)
>> +               return -ENOMEM;
>> +
>> +       data = page_address(status_page);
>> +       if (snp_set_rmp_state(__pa(data), 1, true, true, false)) {
>> +               __free_pages(status_page, 0);
>> +               return -EFAULT;
>> +       }
>> +
>> +       buf.status_paddr = __psp_pa(data);
>> +       ret = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, &argp->error);
>> +
>> +       /* Change the page state before accessing it */
>> +       if (snp_set_rmp_state(__pa(data), 1, false, true, true)) {
>> +               snp_leak_pages(__pa(data) >> PAGE_SHIFT, 1);
> Calling `snp_leak_pages()` here seems wrong, because
> `snp_set_rmp_state()` calls `snp_leak_pages()` when it returns an
> error.

Agreed, i will fix in next rev.


>
>> +               return -EFAULT;
>> +       }
>> +
>> +       if (ret)
>> +               goto cleanup;
>> +
>> +       if (copy_to_user((void __user *)argp->data, data,
>> +                        sizeof(struct sev_user_data_snp_status)))
>> +               ret = -EFAULT;
>> +
>> +cleanup:
>> +       __free_pages(status_page, 0);
>> +       return ret;
>> +}
>> +
>>  static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>>  {
>>         void __user *argp = (void __user *)arg;
>> @@ -1445,6 +1487,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>>         case SEV_GET_ID2:
>>                 ret = sev_ioctl_do_get_id2(&input);
>>                 break;
>> +       case SNP_PLATFORM_STATUS:
>> +               ret = sev_ioctl_snp_platform_status(&input);
>> +               break;
>>         default:
>>                 ret = -EINVAL;
>>                 goto out;
>> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
>> index bed65a891223..ffd60e8b0a31 100644
>> --- a/include/uapi/linux/psp-sev.h
>> +++ b/include/uapi/linux/psp-sev.h
>> @@ -28,6 +28,7 @@ enum {
>>         SEV_PEK_CERT_IMPORT,
>>         SEV_GET_ID,     /* This command is deprecated, use SEV_GET_ID2 */
>>         SEV_GET_ID2,
>> +       SNP_PLATFORM_STATUS,
>>
>>         SEV_MAX,
>>  };
>> --
>> 2.17.1
>>
>>
