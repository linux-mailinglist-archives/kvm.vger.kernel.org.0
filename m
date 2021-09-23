Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D05B4164C6
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 20:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242688AbhIWSDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 14:03:25 -0400
Received: from mail-dm6nam12on2051.outbound.protection.outlook.com ([40.107.243.51]:37253
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242651AbhIWSDY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 14:03:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ser2amwShtb5A9r9yifMxsjOhCjoNCVjot3BMroPoZ2abO2LRJB32Wpf+i8TweDaYEkYO7SQPf8W6HgcWwFpc2zzzvS636FZdokEm5c3vp37ZlMlMWme2DRqctOdVTtV1VA3UzGTENbAnd2t50khOwJ0MIuY0mAdrGlIo7MbmRST09n3ac7FLjADpCdqMlrgx9szUq85D7RZyZVcqS+BuxT1JvNa9uue/XDukw/mGpXBfx/IlXh9r44hPYXAlyfGGcE7rF5b+ewrWOVWL1rVdo1lzl+SJJyv3yWTqYCBIDHM2gU/G1RbU/4F1EMH05jdpHQkeX9kzQPf9AnBNbQorw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=4FdErOwIdWyrSrNiR2gicUXb7BshK1+fOwYDkkDXCqQ=;
 b=VPsS8o0FgfX69o3i9dpp17kujuwiDSjHPyV/nfUTtydIQ++HDkIKZ+5JTXEqkOm3/TQd/K3XqWc6vxFsFPcLl0dtQwYyYG/g+ASA31P73lG154AbsPijqmtXQAhBI3C2xhlvgfNRboukoyN2RKHMdWh+mKWgoRdCdyH4iMB2U/I58gLC7t4JoMSMdrCKRL2m4QiWB9p0+jOSJNyRb9i7DnUAtol1xT4DvXrjAGstrcnPb3IwEBFVUFmTBs3SFXnlr4W22eo1folFn7fPb9DG9lmNUC3RjcVfvu/0hQuHVQJoAzlGt1FA9o4CtJOOPfOStIA3DgrjCIux6PW2XizSew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4FdErOwIdWyrSrNiR2gicUXb7BshK1+fOwYDkkDXCqQ=;
 b=EMspK4TQkKgwj5Ou3QaCon9dpS/P4CMDZTgMWAS9OCo+pn+0cfNe3m2t+lCx8fVDlXEghpNqn/+nAYuoLdxFeHWQ7QlIfxCPpXUjFpKQqIq+hf+JMfXHohcs2pQy4i0JwB26B3GH5iPPBxBFjGUqgCmrzP6HXSnuKrVjbibyVU8=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 23 Sep
 2021 18:01:50 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4523.022; Thu, 23 Sep 2021
 18:01:50 +0000
Subject: Re: [PATCH Part2 v5 16/45] crypto: ccp: Add the SNP_PLATFORM_STATUS
 command
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
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
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-17-brijesh.singh@amd.com> <YUtpX5q7WQ9RJISf@work-vm>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <4bbf2fec-04b2-6eb1-49c1-d51d3c8236e7@amd.com>
Date:   Thu, 23 Sep 2021 13:01:47 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <YUtpX5q7WQ9RJISf@work-vm>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SA9PR11CA0001.namprd11.prod.outlook.com
 (2603:10b6:806:6e::6) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA9PR11CA0001.namprd11.prod.outlook.com (2603:10b6:806:6e::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend Transport; Thu, 23 Sep 2021 18:01:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c429d4e-7c1a-4ff0-94c3-08d97ebc3792
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45572C282F72E31CAB5CE457E5A39@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JEw+7BdqGnWoaNwbvuADLBWTNG49X+8vFdm+HDIYKbMAM2gzvhSRGOzynyTQ22UiwLpQvfhJLVGQmTsQTnNlACQrn55jjwaiOWOhNXaOTtVyDIFpbqn+HMd4KxzbmEfmAW3JohyFCJgJadkZ+7AL18NFwK13Zb9K320lBgmdt3e0DkBfwmK+EQjzxGNQrmakiHmt6uZW9GFPf3jIB58gKCdtpa77jkifGLBOvVi9rXE9TD9enGaEjUcuJVO9s41Acqt3X7aLtHo2hT4bRH3xqLcD/5E5xIUDtDfuCrFiQayvYUcUtH8EBP/b88DaLNpRrGVRSvMbywBCG/tfph/cEArowm1S/8NQ4e4pMEG/gUtI2DQVIGIV3NJWMLNGBfxeCMKPfgnm3o6Sc2rYD22B1L/SIxjC/Eq5FeNmGe/MIVaO0YMFJf7GI6BjVJs1kSojnnc8ik5d8+Ai+9DJMZnItECsLfVptbzNi+bCDgf//iSLWpmr0QsYUg0NVorvAZ8vBt5zwDUeDsfojqanjMj1VAjWG+37yHzO1uvBppeJ8w/TfeWBsx3/JCvhIDZa+yQywT46+47DRw7gvfwU8cfkTedc9jEynVDf9d4RziuzABH+cx8/WKGsROu8aLiLPPyxdZHSbPmGyJCFI1HUC19b19t0DhEXQTGVgPqFm6haUe0piBj6wTYCSC9p6af2P593N+e39gb1MRLsG891YHmQbNbMevFa9YA+5d7ntciWls9gi26rgT4PeD7Fxv70x+4aZ5MlwQikr+L2SPbNleMXyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(316002)(31696002)(54906003)(6512007)(6506007)(52116002)(66476007)(66556008)(66946007)(8936002)(53546011)(5660300002)(6486002)(2616005)(83380400001)(956004)(7416002)(7406005)(8676002)(26005)(4326008)(508600001)(38100700002)(38350700002)(31686004)(2906002)(36756003)(44832011)(186003)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2dYTDFabExER0pCY0RYSW9TOUFaMTB0V0htNzZLM0xEUEt2MzEvS2h0R2hB?=
 =?utf-8?B?bjJaaW1ycndxeHFrWGlwRmJaTXREcmJVdDQydllhMzRrRGdFa21xK2FmaTBJ?=
 =?utf-8?B?K3h2dCtaQWJyR3E1TGFkVnN1WEY5NjdLdUNSV004b240RmE0MmNyNDBaV3pX?=
 =?utf-8?B?QjF3Ykl2QnM0VHRoUGd0SGZHWmtUZml5MEEra3M0YmZCK3B5VXNpTWNwUk1J?=
 =?utf-8?B?ektNTVE5c3FaRW0vV2xDZFZLK0w5MkpRdU9nTzVlZXovU25DNW05b3doZ1Y2?=
 =?utf-8?B?K2ZFaUNPYmtUUGE2dC9EVGhjZ0pmV095bHVPbDhhS05TODlkMXNhbk0xM1ly?=
 =?utf-8?B?MlJDYUpNUTVrdStGTUxMcklCYnpONlIwODZzZHR3TFNkd00rcG5xd1pZSkF4?=
 =?utf-8?B?Ni84UWlRNFdMZmJCUTYwUFJHTEJuajJsaFFwNEdHQ294S1ZCRzN4QmNWRFJ6?=
 =?utf-8?B?T2FTdE1BdmFEUTA4MDhwZDU4aE1RRkFxbDlTeHFRRWZ1VnllVDg0VjRueXVp?=
 =?utf-8?B?UjFXaC9wQ1ZhNDNQeld2bHIySitYbVhYcy9ld09seHorbGVPK2FoYlB6bE9M?=
 =?utf-8?B?S3VRVUJwRjBvVWlTb3R3OWJVYjZQc29CS2M2NEdNNWI0eVRWeVZRWlpNc3ZN?=
 =?utf-8?B?dDZWY2xsYTUyZk1iMDJrNVNpclJJc3BLU294ZmdtaG44bzZHdW82NFR5WSto?=
 =?utf-8?B?L3NoU0p4YjBKaXE2d2U0K3VyRFl6L3dIY2ErUlNMOFRyQVNINWlXZ1MxUXdM?=
 =?utf-8?B?U3pwK1FaTE4wSGRqWGxVb0FnZzJUNDZDVTJtdmxVU2xMWWFubVMzM0xnQ2p4?=
 =?utf-8?B?KytBWnV5cm4xcVd2WHJPMCtzdFJHVko5R3B4Ui9iY0h0cVFJNjkvWUJuVkRl?=
 =?utf-8?B?amVaREVST05CSHRMRU41ZzdOd0FOczhGNDVMNWw3UkY3OW5zMnFoQUJFWWJz?=
 =?utf-8?B?cThRSWNSeTM5TjA4R3Y5N0NFdFB0eVQ2TkZOSER2eHZQVE9DSk04Y0VPNmpS?=
 =?utf-8?B?Qy9wWFArUGs3TGZqb0dmQVN2OXRpUDdNVTEzVUc3cmczakNLSHlNTmx0MXQw?=
 =?utf-8?B?TFVhdkMzVFBKbGh1UmZBQUFvWVBpcHQzblc3akpDbVpzNDVlQStGZFNoUkZJ?=
 =?utf-8?B?aC9zZmhRWm4zR2xkZ2U4ZXQ3MWZaY29TUklLSnhpT0dzVkZSS1NqWVVkdjB3?=
 =?utf-8?B?RitlNWgvTUs0b1pGN0gyT0t1dmtKWmp6Z0doUGZrMG8zOXpOd1l3dWcxS0l1?=
 =?utf-8?B?dUtQTnBCUXFYckZNREg5V3hoSnh2aWw3N1Fzc2hLa280aTVKdlA2QitiWm5a?=
 =?utf-8?B?RmRIV0hmU0YvaTBpRjdRTWc1VnlOZ3hua2owL0lTcG5vVXFzTFk1QlZpa2gz?=
 =?utf-8?B?b3B5bHMxY3BxRldYOUt1VGc3SFhUNk02VTkvVFNJYlZsYlBpSUw2QUJJMWxu?=
 =?utf-8?B?NnNxOGI0YktFeXo1QkNveFFnN0wrUU1JWllLQUp0VzBlNFlEWi9GalpJcm5U?=
 =?utf-8?B?TTZiOFZLcW9OQWdFazk2ZDc1NGthbG9MeTJzbUxIZmhTV0VpTjFMNnBOTE00?=
 =?utf-8?B?eDNQMmdNR1lVMm1aUHorcmxYTVRRdDZ4dDRwUU1pMkJ4R29kbEw0UXNXVEx3?=
 =?utf-8?B?Q1hBVVRNL0lpQXJPMnBuQ3o5Sk9WZHlXTVpJQitoOWFGQ1JqaThyRVJHZlBk?=
 =?utf-8?B?bHlwdkVSLzUxTGRqaFpiQkpGNVFBSDkxTnN3cktNS3VxKzRHSzQ5SEd3bFd1?=
 =?utf-8?Q?LWFOVc0AQjdsAsLWladqWayANhg/8qj/ZrFlYUI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c429d4e-7c1a-4ff0-94c3-08d97ebc3792
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 18:01:50.7306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8rQZj8rNgs5uWO9WkeyXC0dTff32PY9TLGqQKQCN/M4PaXRJgkUU+ZI75wA2Lu/B03SlLn/Z5oJ/5geTvbqW8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/22/21 12:35 PM, Dr. David Alan Gilbert wrote:
> * Brijesh Singh (brijesh.singh@amd.com) wrote:
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
>>  	return ret;
>>  }
>>  
>> +static int sev_ioctl_snp_platform_status(struct sev_issue_cmd *argp)
>> +{
>> +	struct sev_device *sev = psp_master->sev_data;
>> +	struct sev_data_snp_platform_status_buf buf;
>> +	struct page *status_page;
>> +	void *data;
>> +	int ret;
>> +
>> +	if (!sev->snp_inited || !argp->data)
>> +		return -EINVAL;
>> +
>> +	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
>> +	if (!status_page)
>> +		return -ENOMEM;
>> +
>> +	data = page_address(status_page);
>> +	if (snp_set_rmp_state(__pa(data), 1, true, true, false)) {
>> +		__free_pages(status_page, 0);
>> +		return -EFAULT;
>> +	}
>> +
>> +	buf.status_paddr = __psp_pa(data);
>> +	ret = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, &argp->error);
>> +
>> +	/* Change the page state before accessing it */
>> +	if (snp_set_rmp_state(__pa(data), 1, false, true, true)) {
>> +		snp_leak_pages(__pa(data) >> PAGE_SHIFT, 1);
>> +		return -EFAULT;
>> +	}
> Could we find a way of returning some of these errors into the output,
> rather than interepreting them from errno values?

I can try to find a corresponding fw error code and use it where
applicable. e.g in this case I can use the SEV_RET_INVALID_PAGE_STATE.

thanks

