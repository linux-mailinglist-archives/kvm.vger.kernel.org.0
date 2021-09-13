Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464CE408A36
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 13:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239551AbhIMLbI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 07:31:08 -0400
Received: from mail-mw2nam10on2080.outbound.protection.outlook.com ([40.107.94.80]:57280
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239387AbhIMLbH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 07:31:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E+kPAW/bvSUwpF9GXeaMqVQ5JtXsEH3ID1glpin6LnARCbRfMYcS1vy19Q6+vvP10PnJIafXqAxc4wut94u6QqsocWEkL3RpbJZs6CIVlYui/wPWFYv574iyKkDigPBOeMEzEx0v4C2pjqKLb/eKa7UAkru3MkKvjcow/v6+TFg52w4lhd0rt2AxNUBwInIY8M/1k9DQmuSGiTA1CMQDP7R/EhbR3jIxbHyV9Cg7UvR668lkNt7tRRGoqtEzVgek3Kitrpwjwn4WtJFVT5dxQr0oOTPr20GIlbTpvCU2EOHHc/z862fhfMfkHMhcCB0Q6SgDaU0ssExA1mPJeGaWBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=QJd8Mvt2vCt3vnugKnLg6cecLca099K2V4jEXF1p4WQ=;
 b=H0FgttGPX2Evhd19sDV2oj5w5WTYrq5cHcgkoJb0XfH8DYtfcdbZ1bUCIEtoDXyPHJM1y5DR4Vojv73Y2Zcj2RFA1UpjL0s9hj9c2hDO7dQKWaRYVCuX7o4i82h7xLQ31yBthaeyYGZfOM6dNp8YWnCqyfDZ7j6l22JDkOYnSWSLcgWjIwBl+BJSgU4e3f7q9Wp6HNqAkdEvYM5TlWKqRadlCKKLfWLUyW4Y5vEY3pJAmrm403OxPrnsNY9BIHsARbAWJiOrVKdmi2mkBqcQzormkdPnpT6MNfx8uNoS2m2X0o76k3u/b/+JCs1b4wa3QPM3HWbPJ/0aLdrDKNP3rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJd8Mvt2vCt3vnugKnLg6cecLca099K2V4jEXF1p4WQ=;
 b=QbyY2lR9COS28zTkCbK4gC0hgIELTIb4IpNWaeX9m7ztFgK4sNTth+O2+apsXDJj0RBeqNgVeUndvqV/OgTMmMMJLU010/rDDBoXTxIeW+InrFttzLvtfZymemRooOvvyqRR0EK7L01IsGIQZq31g+j/+Cxd3bexuvCuG7Pb+U4=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4446.namprd12.prod.outlook.com (2603:10b6:806:71::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 11:29:49 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 11:29:49 +0000
Subject: Re: [PATCH Part2 v5 17/45] crypto: ccp: Add the
 SNP_{SET,GET}_EXT_CONFIG command
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
 <20210820155918.7518-18-brijesh.singh@amd.com>
 <CAA03e5Fb9nGQ8mVJzDvRi4ujq_g0q8zOjOOx4+rYZOJRkrmbhg@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <b6ab3467-850b-dc7d-5656-f5e2a129d6f6@amd.com>
Date:   Mon, 13 Sep 2021 06:29:46 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <CAA03e5Fb9nGQ8mVJzDvRi4ujq_g0q8zOjOOx4+rYZOJRkrmbhg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN2PR01CA0047.prod.exchangelabs.com (2603:10b6:800::15) To
 SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN2PR01CA0047.prod.exchangelabs.com (2603:10b6:800::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 11:29:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef096696-664f-4125-e3b5-08d976a9cc09
X-MS-TrafficTypeDiagnostic: SA0PR12MB4446:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4446CA963D05496A5D4554E1E5D99@SA0PR12MB4446.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qK+6aAwYBo89N3Uh1yckuk44COWWJPhqzF0Gr42Gp662U52kfxD6Z+F2lIjFyfF790Zk7fODWFcCr0QzCeG50i6RURTReTXbksm0FWcbirfpdX5JcfuY21bIu4nEw41uMEIIsBBBElhyh3ZQ2eb0eBgEDhXYw1UVzLbPy8MMYYw+Nr0kQz01gLkxQsOLWUcBLAUNbWX3nJ522yODgDmQ4HtgorMneWX4RWos0O0sqZOi6dmkonlHaTaazY5mJxXSWWsbNv+ekVGMkl7ssX6P08vY4ARmYdS0Gub7pcrTO3Ur0jtrXICQTZT5arVOp6prNuYBvWrROxUg9yFhBQFxcsLUMKA14yO6Z+CUbwLgW/nRv1zoMfgF0KJOqwM4hErGpFOssdzdC9kFucTD1MZ+O2kP11u+GzPszoBU414jgqpdQcLVST9rw+y3d0toHCXY4wRlmJxfUdRS3Na6MokJ3X31CsYpvPUjiNMakUnjk5coIKh9UY6hCCLyoEyMJnyCAGEFWmIAjGrGrVMdLuMxP929DfrW37OxK6AQMj3kyRkaKqM+SKD2RIXEEH0mAoToSf7IZZ4A6i268rMKl9VybJ4s5LwOafs75soXz/INW7uoum4D1D3Pi83YQKsw3nUQPjlvJKznLL9iRVbz/retsU93EsuHHGu+VTw7jycFco+NdhKmjqhm0jbtFeOPNsShDjhLjE2CLxA1H6xdTWV1bmJIZMO0wzt8CPtFxK1rLsg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(36756003)(66556008)(8676002)(66476007)(66946007)(6506007)(7406005)(478600001)(54906003)(2616005)(956004)(53546011)(38350700002)(26005)(7416002)(2906002)(86362001)(52116002)(8936002)(316002)(38100700002)(186003)(6916009)(44832011)(6486002)(6512007)(4326008)(31696002)(5660300002)(31686004)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bW1oUnJHbDlVWS9qa3VJenZpblY4Ry9tUU1vQk44MHB5aXAzYlR5eWdYNGNP?=
 =?utf-8?B?ZUhMQUoyaGp2T0VoTzRCcENvUVdESVN1cUZ1NHhYQzVwcndnSWtSVjdQRGor?=
 =?utf-8?B?MFZGTzY2WThReFpaaytmcFJ5VVY1UGt0cC8zSFhKdktWMmk0U1VXN3J6Y3Rn?=
 =?utf-8?B?MDErd1FETXJvbDZoOWdYRElDazl3ZjgvdFZ3S0RIeWhtd3RrK0xMeE90WW1K?=
 =?utf-8?B?cFRJOFRvUHowSHhqdmx0TFZabDlPckZUeE9FbENtUFdDcDZMZUJ5YU5vdTFr?=
 =?utf-8?B?ditRaGczQmcrYU1TTDhPK0Z3VEdoaXhsUHJNMkFscWVzdGI5czhySm9Ibzdp?=
 =?utf-8?B?UmZ6Q04yY1B3dFFVRXA0MFRTWXlvaDlwenpDYUJRR1ZsZUpsYUcxVXFqR3M1?=
 =?utf-8?B?QW9FWURuSmhPUnJDaEhxMWdMdjllYU5wVW9mcWZDNUxrZzFSYm9TenNFb2Nm?=
 =?utf-8?B?a1owMktRVVI1ZEJ1bHZrN2FtM3ZrT3dFZUYrUUora1dqZTRQUEhSMmpFcXo0?=
 =?utf-8?B?L0ZUQ3cvazkyQ0FPL1FmcFFZZi9obU9GOEh0bnUwTzRieFZMUzgwK3hGWm1U?=
 =?utf-8?B?d2d2R2JzZ1MwRjZyM0F3T3JGcWNuK1o3dXcvcjFuOWcrRUtNcGhoYm4reDVr?=
 =?utf-8?B?NHBuMDFzakJ0dTNJcTlIS25JdTlNQTBLcHc3OTlVaENNVUJBdjB1d0VMemxT?=
 =?utf-8?B?REowRTFwTjdDZVJhWXN2K2VONm9ScVRmdkw4OWhzaVhSZTRyd205TUNpTFZG?=
 =?utf-8?B?TUpwN1pIRm9rNWIyVjQwWGN3aE1qVU9ZREluNDJobXFUdW5kMWpmNXpGZ3B6?=
 =?utf-8?B?K20rUkFDeE82SEtObHJ5OVhkVWExSnQ4ZGMyeTNZR2gxNUtqRnBWMmRTdVZF?=
 =?utf-8?B?YlBmVTg4RS9UeTlQZ3hkNWdFc0hJWEtSVHpIOVhUdEtsQlZNUlQxaTZlZjJa?=
 =?utf-8?B?a0lKcGQxL2FreWlKY1REaUN3aStSVUQ3aXpjUnhtTTdpd3lnSEQzV2RIbTBR?=
 =?utf-8?B?Qi81dUFTZEdYK3h5UFduWHY0a0xaSHJRYnRNQjhIRnNrWkdNVDBWVnVTR01u?=
 =?utf-8?B?V0xqbHlXN0xpOHhBN0hYdHdnMFZSSGRTSWJJUXpRRWFCZ3ovNUgxVTI4RW9i?=
 =?utf-8?B?SzRzaEpFU0h6djNxNmwxN3pISXBHdU9oY1phSEZhdGRocktJcWpaRHdBY3Nt?=
 =?utf-8?B?T2lJdEVXWE15QlhSRHlmZkRzWXlpYW42V3pUQmoxcnNxZlljWWRjUi9wd0tJ?=
 =?utf-8?B?cmVhdFkzekVKYVRWeG5IQ2RPbHlMeDE3OGo3ZGpYM0N0dFNxekI4QVZDYktV?=
 =?utf-8?B?SHYraEdZcHJPb0FhYWNKRlZWSyt0STNjUll5WGlONG5jdTZjRnQ0aHBGZlBu?=
 =?utf-8?B?Z2N3QXZLU3lvSUNVY3YxZ0J5SGNBR0NsTW9EYmZFU1dvbDRkNWRxWHJiYWlQ?=
 =?utf-8?B?aC8rcTlFRG5UN2dXWUVTd3VHR0VEelAyWUZOaEZqSWorL3JZUGxiUHJvOVZm?=
 =?utf-8?B?N1p0TXMxQXhlbFRYYjJsZXdMT2l1Vkc1c2pUOGxEbjNLWDRUVVpqZ1g2WUh6?=
 =?utf-8?B?MnFsYmxkK3RXcm54bFE1emtHZFp0Y3FLOWpwa2Z4YjF2WldvRm4vZkZKSHQ3?=
 =?utf-8?B?VHU1alljeFJsTmxzWmxFSG5OcHZZUkRJTTV1OXVqZ3hLQ3hmZDRwUXEvaGxm?=
 =?utf-8?B?RGt6bERUSkE3S3Y4aTRxcnM5M1FtYlJ3aVJkSjNoVkptR21xMEdObG51ZzN3?=
 =?utf-8?Q?F4gg3U6greL2T7wMKve+hFaRCVT+U/QFZMzbY2V?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef096696-664f-4125-e3b5-08d976a9cc09
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 11:29:49.6425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y30koPAX4YFepx15XH5D45wKpSDfOK5XWyd5apAqr/a0dpCmxPW2gqjHPcLXFzV+JCuwa6Y7Ll2u156/7R6f/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4446
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/9/21 10:27 PM, Marc Orr wrote:
> `
>
> On Fri, Aug 20, 2021 at 9:00 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>> The SEV-SNP firmware provides the SNP_CONFIG command used to set the
>> system-wide configuration value for SNP guests. The information includes
>> the TCB version string to be reported in guest attestation reports.
>>
>> Version 2 of the GHCB specification adds an NAE (SNP extended guest
>> request) that a guest can use to query the reports that include additional
>> certificates.
>>
>> In both cases, userspace provided additional data is included in the
>> attestation reports. The userspace will use the SNP_SET_EXT_CONFIG
>> command to give the certificate blob and the reported TCB version string
>> at once. Note that the specification defines certificate blob with a
>> specific GUID format; the userspace is responsible for building the
>> proper certificate blob. The ioctl treats it an opaque blob.
>>
>> While it is not defined in the spec, but let's add SNP_GET_EXT_CONFIG
>> command that can be used to obtain the data programmed through the
>> SNP_SET_EXT_CONFIG.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>  Documentation/virt/coco/sevguest.rst |  28 +++++++
>>  drivers/crypto/ccp/sev-dev.c         | 115 +++++++++++++++++++++++++++
>>  drivers/crypto/ccp/sev-dev.h         |   3 +
>>  include/uapi/linux/psp-sev.h         |  17 ++++
>>  4 files changed, 163 insertions(+)
>>
>> diff --git a/Documentation/virt/coco/sevguest.rst b/Documentation/virt/coco/sevguest.rst
>> index 7c51da010039..64a1b5167b33 100644
>> --- a/Documentation/virt/coco/sevguest.rst
>> +++ b/Documentation/virt/coco/sevguest.rst
>> @@ -134,3 +134,31 @@ See GHCB specification for further detail on how to parse the certificate blob.
>>  The SNP_PLATFORM_STATUS command is used to query the SNP platform status. The
>>  status includes API major, minor version and more. See the SEV-SNP
>>  specification for further details.
>> +
>> +2.4 SNP_SET_EXT_CONFIG
>> +----------------------
>> +:Technology: sev-snp
>> +:Type: hypervisor ioctl cmd
>> +:Parameters (in): struct sev_data_snp_ext_config
>> +:Returns (out): 0 on success, -negative on error
>> +
>> +The SNP_SET_EXT_CONFIG is used to set the system-wide configuration such as
>> +reported TCB version in the attestation report. The command is similar to
>> +SNP_CONFIG command defined in the SEV-SNP spec. The main difference is the
>> +command also accepts an additional certificate blob defined in the GHCB
>> +specification.
>> +
>> +If the certs_address is zero, then previous certificate blob will deleted.
>> +For more information on the certificate blob layout, see the GHCB spec
>> +(extended guest request message).
>> +
>> +
>> +2.4 SNP_GET_EXT_CONFIG
>> +----------------------
>> +:Technology: sev-snp
>> +:Type: hypervisor ioctl cmd
>> +:Parameters (in): struct sev_data_snp_ext_config
>> +:Returns (out): 0 on success, -negative on error
>> +
>> +The SNP_SET_EXT_CONFIG is used to query the system-wide configuration set
>> +through the SNP_SET_EXT_CONFIG.
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 16c6df5d412c..9ba194acbe85 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -1132,6 +1132,10 @@ static int __sev_snp_shutdown_locked(int *error)
>>         if (!sev->snp_inited)
>>                 return 0;
>>
>> +       /* Free the memory used for caching the certificate data */
>> +       kfree(sev->snp_certs_data);
>> +       sev->snp_certs_data = NULL;
>> +
>>         /* SHUTDOWN requires the DF_FLUSH */
>>         wbinvd_on_all_cpus();
>>         __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, NULL);
>> @@ -1436,6 +1440,111 @@ static int sev_ioctl_snp_platform_status(struct sev_issue_cmd *argp)
>>         return ret;
>>  }
>>
>> +static int sev_ioctl_snp_get_config(struct sev_issue_cmd *argp)
>> +{
>> +       struct sev_device *sev = psp_master->sev_data;
>> +       struct sev_user_data_ext_snp_config input;
>> +       int ret;
>> +
>> +       if (!sev->snp_inited || !argp->data)
>> +               return -EINVAL;
>> +
>> +       if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
>> +               return -EFAULT;
>> +
>> +       /* Copy the TCB version programmed through the SET_CONFIG to userspace */
>> +       if (input.config_address) {
>> +               if (copy_to_user((void * __user)input.config_address,
>> +                                &sev->snp_config, sizeof(struct sev_user_data_snp_config)))
>> +                       return -EFAULT;
>> +       }
>> +
>> +       /* Copy the extended certs programmed through the SNP_SET_CONFIG */
>> +       if (input.certs_address && sev->snp_certs_data) {
>> +               if (input.certs_len < sev->snp_certs_len) {
>> +                       /* Return the certs length to userspace */
>> +                       input.certs_len = sev->snp_certs_len;
> This API to retrieve the length of the certs seems pretty odd. We only
> return the length if the input.certs_address is non-NULL. But if we
> know the length how did we allocate an address to write to
> `input.certs_address`?

Ah good point, I should provide an option to query the length when
input.cert_address == 0. This will make it much cleaner that there are
two approaches to get the length.


>> +
>> +                       ret = -ENOSR;
>> +                       goto e_done;
>> +               }
>> +
>> +               if (copy_to_user((void * __user)input.certs_address,
>> +                                sev->snp_certs_data, sev->snp_certs_len))
>> +                       return -EFAULT;
>> +       }
>> +
>> +       ret = 0;
>> +
>> +e_done:
>> +       if (copy_to_user((void __user *)argp->data, &input, sizeof(input)))
>> +               ret = -EFAULT;
>> +
>> +       return ret;
>> +}
>> +
>> +static int sev_ioctl_snp_set_config(struct sev_issue_cmd *argp, bool writable)
>> +{
>> +       struct sev_device *sev = psp_master->sev_data;
>> +       struct sev_user_data_ext_snp_config input;
>> +       struct sev_user_data_snp_config config;
>> +       void *certs = NULL;
>> +       int ret = 0;
>> +
>> +       if (!sev->snp_inited || !argp->data)
>> +               return -EINVAL;
>> +
>> +       if (!writable)
>> +               return -EPERM;
>> +
>> +       if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
>> +               return -EFAULT;
>> +
>> +       /* Copy the certs from userspace */
>> +       if (input.certs_address) {
>> +               if (!input.certs_len || !IS_ALIGNED(input.certs_len, PAGE_SIZE))
>> +                       return -EINVAL;
>> +
>> +               certs = psp_copy_user_blob(input.certs_address, input.certs_len);
> Is `psp_copy_user_blob()` implemented in this patch series? When I
> searched through the patches, I only found an implementation that
> always returns an error. But maybe I missed the implementation?
>
> Also, out of curiosity, any reason we cannot use copy_from_user here?
psp_copy_user_blob() is a wrapper around memdup_user() -- which does
kmalloc() + copy_to_user(). The wrapper performs some additional checks
such as the blob size etc, we limit the blob size to 16K to avoid
copying a random large data from userspace.
>> +               if (IS_ERR(certs))
>> +                       return PTR_ERR(certs);
>> +       }
>> +
>> +       /* Issue the PSP command to update the TCB version using the SNP_CONFIG. */
>> +       if (input.config_address) {
>> +               if (copy_from_user(&config,
>> +                                  (void __user *)input.config_address, sizeof(config))) {
>> +                       ret = -EFAULT;
>> +                       goto e_free;
>> +               }
>> +
>> +               ret = __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
>> +               if (ret)
>> +                       goto e_free;
>> +
>> +               memcpy(&sev->snp_config, &config, sizeof(config));
>> +       }
>> +
>> +       /*
>> +        * If the new certs are passed then cache it else free the old certs.
>> +        */
>> +       if (certs) {
>> +               kfree(sev->snp_certs_data);
>> +               sev->snp_certs_data = certs;
>> +               sev->snp_certs_len = input.certs_len;
>> +       } else {
>> +               kfree(sev->snp_certs_data);
>> +               sev->snp_certs_data = NULL;
>> +               sev->snp_certs_len = 0;
>> +       }
>> +
>> +       return 0;
>> +
>> +e_free:
>> +       kfree(certs);
>> +       return ret;
>> +}
>> +
>>  static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>>  {
>>         void __user *argp = (void __user *)arg;
>> @@ -1490,6 +1599,12 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>>         case SNP_PLATFORM_STATUS:
>>                 ret = sev_ioctl_snp_platform_status(&input);
>>                 break;
>> +       case SNP_SET_EXT_CONFIG:
>> +               ret = sev_ioctl_snp_set_config(&input, writable);
>> +               break;
>> +       case SNP_GET_EXT_CONFIG:
>> +               ret = sev_ioctl_snp_get_config(&input);
>> +               break;
> What is the intended use of `SNP_GET_EXT_CONFIG`. Yes, I get that it
> returns the "EXT config" previously set via `SNP_SET_EXT_CONFIG`. But
> presumably the caller can keep track of what it's previously passed to
> `SNP_SET_EXT_CONFIG`. Does it really need to call into the kernel to
> get these certs?

This is mainly to help in the cases where the provisioning tools may not
keep track of the programmed TCB version and would prefer to read the
TCB version before updating.


