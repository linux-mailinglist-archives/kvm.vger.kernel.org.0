Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D53960FFD3
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 20:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235637AbiJ0SGW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 14:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235842AbiJ0SGT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 14:06:19 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7346247;
        Thu, 27 Oct 2022 11:06:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MlF5hqoUwzyA6377pM8aOB+QOi0n9BTm/CJxWjbD/Qnd2yzMHS39eFACo4Hd+ShEddkbJjlszu5aobC9qUIB/EdOhquAlpi8foSe4XXypDwrYAo4ySsu8uWZpBDa/oFsfJg/6ynlkezcZurUuBYnqa+EVfSJFkZjwg+DRgbbzbEIRd2E1774+XyNuAsh7lBYoVrxVoY7YX/PRvRw5s03s+IR176W/nSRBOEz/csK0wcy20pOZzzHJwqGJ8mXvpXCUYvLoyxI2dU80NKpBjW4Uw2jRzyiVDr/sVm+u6gM5amQskQ9RJGvhoLo9MGv8zOsK2C3RitJEEAFkYJMayz2bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pCjO/TND/jKMRB35Wm/H4ZlCmwm/4s77sN8TjMLsORI=;
 b=HS9JNMpZSW3364Sq0SvcLD/mY4MMXUqnHzLmuZxHYk2ZG5jVeapLtWc7AkGtgr2K/Xeozfs+uUtOwFCJASkxJ3ntUbVz9rl4GM78sIPFZ3d6c4CPJ7icEehpP3L7qqD9LSxVJe7a6z1O81caKCoC5kL+S7Jw9X488fhj8ZGTj3v6fBeMHxN8mmz7eY8MzunW7Xw7JN+bxyzv7PTzPbIDU/1FN6thD8q08J/RQxIlrHpam7XllOREg0CV0NTVy14x1qOQOWuqPiNRl++K2hI9t1UDnOcidqA3h06vYHrIIv3hqEbTbBh/Z+QEVwWVKxANosuP6uQ1B1wuGwHdyYrIFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pCjO/TND/jKMRB35Wm/H4ZlCmwm/4s77sN8TjMLsORI=;
 b=CDu6HR2vn3SWUhVBeMmFWZaoa4GtrJCVKZjvsLd8H1ikWcnMO7XeYSgfd/DvK1supwLkY8yvR7u4giYhFyNhlKwrcR7zv5e0m3aXuPVo17UPOlBjp5Le9HHx3lDiPtI9yHIivC4Ysw0CBvMDxCPZaIBDTBzMj/vO/XnzHvT+dvY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CH2PR12MB4310.namprd12.prod.outlook.com (2603:10b6:610:a9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.26; Thu, 27 Oct
 2022 18:06:15 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5746.026; Thu, 27 Oct 2022
 18:06:15 +0000
Message-ID: <10e7e8df-69ba-c1bc-1f94-c77fe64774ab@amd.com>
Date:   Thu, 27 Oct 2022 13:06:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH V3 1/2] virt: sev: Prevent IV reuse in SNP guest driver
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
Cc:     Dionna Glaze <dionnaglaze@google.com>,
        Borislav Petkov <bp@suse.de>,
        Michael Roth <michael.roth@amd.com>,
        Haowen Bai <baihaowen@meizu.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20221027150558.722062-1-pgonda@google.com>
 <20221027150558.722062-2-pgonda@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20221027150558.722062-2-pgonda@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR01CA0045.prod.exchangelabs.com (2603:10b6:208:23f::14)
 To DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CH2PR12MB4310:EE_
X-MS-Office365-Filtering-Correlation-Id: dbecd3fd-5df6-40a1-8ded-08dab845f06f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qD3H7JIme2qmYADsgtc0ZvW6C5KSayPn1czG0j6EZ/N/Hjs8Rsirg+Ey/bxGx4SRAHGgqqb3V5KAq2rnzoPUIDZRamng0IjggvhwRwHmmPEX5Eq0/LunPdjQ8io8gVNjj3LPdsARhQsnjasVa/radY2NKGUlBtknlE4t8uzA5JAb5wJ2ikfbOUIlETVWE8HNK4MWFHo5owIhNrWITKrkSvUM1po890XwVUeS478mVvKWFxGjAPCyhC6Ol05rH3THSXUGfJrZwxFiH9YyD8mgGsRoLLnF0/01tb7Y8aiXZunEkV9nuSA8TYyMZfyO/OK+X5QvCdjtgkZUcIdE8uBuWbYI1PruuvlgXc3iJKFGQDFNfQ5efjK9+H+n6HwtteHILRVJIRVgHhpMuKCtS3qqLMSM+XidxmpWhuxnbn2ew2LcR9zBxG3nuDrShXUZy3uzZ9BLYnYKRpwmxtIIiVYd1X5Am+p24C1SHIJpwwL/w908IQzVb2+8vukH8Dp99DFMwiY+p6o/69ghP8Ch2g38M+foL1Z09qrSgI5az457ulRsmKRY7IBnG1Ub4Hp8qLD5AQONLuPvV9g/n6tVfaeQkc4fwXSL4sZuwbWsDiQXyFVl77nMmUDfc9WZsCmc+wnctjAAlvWDVWCrmHuQUHHe96g75YvIMX8EwXMDUvpNduTKWNCZ4xCGvUR6V6chAJ3izPh0n+nmEz6eHkx4RwXNgP5XKftkgeZtaS9/2SagaYil98Or2kidGIUUuhAL5eLFyro5NcnmTpvQjSWIRYel55xuY/Ma7MdsrX2IUpbNqQrYB1rXLFi0oAQQp+gC50emRTWtJBZkod0gyYjruRiWuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39860400002)(366004)(346002)(136003)(451199015)(41300700001)(8676002)(4326008)(66946007)(66556008)(54906003)(6916009)(6506007)(53546011)(36756003)(6666004)(66476007)(86362001)(31696002)(83380400001)(5660300002)(6512007)(26005)(8936002)(316002)(2616005)(478600001)(31686004)(2906002)(186003)(966005)(6486002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YjM3ZUhnUWFyN3luTSswc1JLN3g3cTE1TTh6TkZmWmcrZTBZSXh6U0dyMzkv?=
 =?utf-8?B?ZGRFb2VMQnhrRk1UdFBXc293RTE4d0tDdlhienk4eGRMR1JMNUZSVCtHUmts?=
 =?utf-8?B?d0pWeU5CQ3RmN0ZKQXQ5R2VQWjdWRXBBT0dueE92S2hwWS83MTVkcDVrVXFm?=
 =?utf-8?B?ZmpzSFJTWElGamM2eEIyZk5HTk9qbGdGUlhGZHNWMXVwUk84QnN1WEhlNEJZ?=
 =?utf-8?B?Z0lHc1d5bHdWS2pNZXc3bnhKRS9CYmpBZHJKcVpWblN5RHFaN1VBVXRXMzBQ?=
 =?utf-8?B?RENXSmIxd0RXVVVGdkdzTjFsdWloSDdUSEptTExIZmc4ZEd3QVRZQUk1eHlz?=
 =?utf-8?B?Z2owZ0FjUlFqTEJ2a3NBZE1zQ3o3RjBWeEd3cEVLeUlJVjJHSWNXYktlTWN6?=
 =?utf-8?B?VGpndWw2ZW1ubE5oQ3lvczdweVc2aFpqSm1xV3NyZmI3V01RYXhBSVBEcFQy?=
 =?utf-8?B?RVVMbjFCZ1M5bWs2bDVWT3ZBUCsrVThFVmdlOGU2bStkVmEwdmg5bXZDbkdw?=
 =?utf-8?B?M0lFRldKMUFOUm9OVldoc2lzSERGV0s5WS9DNjhBRFdlQ3dJbEFDcDhaWEV2?=
 =?utf-8?B?YmZ1emdLM3gza2pnZW1EaXBOc3R3djI4VWZnVmpwNlVoeWhlL3UxNUpTMHFN?=
 =?utf-8?B?UXd3RTZCSXBlTzloM0EvdnJ5NFhiSkV4MGJIdlcyTUdkdVlYR3BqY2VnckRh?=
 =?utf-8?B?d0ZsZk80M0NZQ0c0anBQTk1lV2hFZWtEZ1pkQ0lvdnFtYkJ6aEhVRnc4UjQz?=
 =?utf-8?B?dUFEcXJkR1V6Q3U0SjErT1d3L2ZxYUhEaTI2a1hUWXltSkxFZVNMM04ycWNk?=
 =?utf-8?B?cWlCWGRkR3hUVDJML2t1Y1JyaEJ5SXZITUl4NzhuWjVneTRBa200bmY0YnFO?=
 =?utf-8?B?bXdGWC9obFk3VnViNnRTckM2VmdMYjZPZGVLQ1BSNlhyNUZZbkRxUnBURlRm?=
 =?utf-8?B?WG9lUE1uMVkxY1ZMQTJUNVBnNlY4VzAwSHphd2JxSUZzWUFIM3k1b2xQa1BF?=
 =?utf-8?B?UTBnZ2tjVDlnblIxM2I3MnVXUEFETm5jMnJvcW9CaVFacEpyZE5ReTNFdi93?=
 =?utf-8?B?M3NqbCszanlTc1F5NE1zaGZDT1VNTUF3eDI0THhwRVZQZm9xYUVpN3ZOWlVQ?=
 =?utf-8?B?MDR4bnZPcXdyTDdWRDZoL3cxa3V5VjRPOG9WRGxudzcxRExIdlFuMDM4QW9S?=
 =?utf-8?B?Y1FLbEgwRmwvMFNmbzlOYnJmTUtRdXJCMGlXMlo3Z3BxQ1hvSGVweXJLOEhl?=
 =?utf-8?B?S0dDaURUNElLdExSQk11M01VdFduazg5SmFsa3gvRVdhUW84U09ZU1YzL01Z?=
 =?utf-8?B?Vm1NNmI2ZG03TCt1bXZFRWVnZjVkNy8yUUowN2pYelFCZXlpWDV2bHd0U0ZT?=
 =?utf-8?B?WHI2RmNhb3J1ZzE1TDFjRVQydmRrWFg2K0YycGpsZmIyb0NiV2g4RStjcWZP?=
 =?utf-8?B?VmhwZnY0ODBrRzNiU0RRUG0rNUtwQUhXeEtDZE83V21FajZhMTlKOEtVYk5N?=
 =?utf-8?B?bUpjOG1QNkZJbDVuMm0vZ094UTNNMjlKeUxZb09MU1BYckltODRBUlBHZWRn?=
 =?utf-8?B?YUw0UDlXbEtaQXRoVnRwamtqTXZha2h5ai9CY3I0ZS9CaG9jWjgzWVFlY1l1?=
 =?utf-8?B?L0orRXoya1FQN2djNzFqSVlJdENqTGJrZGcyWUxZbVZIbWJ6YTArME5Ga1B5?=
 =?utf-8?B?eExlQk5ZMDNyaDJKN3c2M3JJQnV2T0F3OEtqSDZPK0VHWi93RDR2VHp4c2xF?=
 =?utf-8?B?aktISjZLRTFvOWZwcUkyRlh0NkxaSTczK1o4TysvdUx5cEQ1eVRDcklhUUVj?=
 =?utf-8?B?eUtpQjlCVW9lTjl0U253N1FVSzdIRnI0YWZkT0MvSkVoWkd2NjkzYS9hWXZ0?=
 =?utf-8?B?eGFaUnFGU1lJZmtvdW0weFROVi9KdVdwQ2swMTBRRjY0bkhIcWwzWG5vWVRs?=
 =?utf-8?B?dHY2THFvZFFtWXdFU1E3cjQ4K3JmeVNsSldyeVByQ1NCQnJOT1haUFlzZ2ZB?=
 =?utf-8?B?WUlZWEpvcHEySXFDZ0pKZkp1b3pDWHViSERvdWxrNTltTFNOdFk5OFpzb3lV?=
 =?utf-8?B?Q3U4dnFBUlA5MStwcnJFL0luNW5QenpYUEJvdGltVytPVklSMWxaNy8zWnhH?=
 =?utf-8?Q?+nUss/lx++oZc3Xe3ILoxIMlU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbecd3fd-5df6-40a1-8ded-08dab845f06f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 18:06:15.4161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2I4NSdr6uW4/5SX/1a9aFxeq7WyYj7fjUr1drIDqDnfbYlxDKCrrUQNbBQykqBFiIVCOxoM6OAMnu1pmtP4uig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4310
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/27/22 10:05, Peter Gonda wrote:
> The ASP and an SNP guest use a series of AES-GCM keys called VMPCKs to
> communicate securely with each other. The IV to this scheme is a
> sequence number that both the ASP and the guest track. Currently this
> sequence number in a guest request must exactly match the sequence
> number tracked by the ASP. This means that if the guest sees an error
> from the host during a request it can only retry that exact request or
> disable the VMPCK to prevent an IV reuse. AES-GCM cannot tolerate IV
> reuse see:
> https://csrc.nist.gov/csrc/media/projects/block-cipher-techniques/documents/bcm/comments/800-38-series-drafts/gcm/joux_comments.pdf
> 
> To handle userspace querying the cert_data length. Instead of requesting
> the cert length from userspace use the size of the drivers allocated
> shared buffer. Then copy that buffer to userspace, or give userspace an
> error depending on the size of the buffer given by userspace.
> 
> Fixes: fce96cf044308 ("virt: Add SEV-SNP guest driver")
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Reported-by: Peter Gonda <pgonda@google.com>
> Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Michael Roth <michael.roth@amd.com>
> Cc: Haowen Bai <baihaowen@meizu.com>
> Cc: Yang Yingliang <yangyingliang@huawei.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Ashish Kalra <Ashish.Kalra@amd.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: kvm@vger.kernel.org
> ---
>   drivers/virt/coco/sev-guest/sev-guest.c | 93 ++++++++++++++++---------
>   1 file changed, 62 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> index f422f9c58ba7..8c54ea84bc57 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> @@ -41,7 +41,7 @@ struct snp_guest_dev {
>   	struct device *dev;
>   	struct miscdevice misc;
>   
> -	void *certs_data;
> +	u8 (*certs_data)[SEV_FW_BLOB_MAX_SIZE];
>   	struct snp_guest_crypto *crypto;
>   	struct snp_guest_msg *request, *response;
>   	struct snp_secrets_page_layout *layout;
> @@ -67,8 +67,27 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
>   	return true;
>   }
>   
> +/*
> + * If we receive an error from the host or ASP we have two options. We can
> + * either retry the exact same encrypted request or we can discontinue using the
> + * VMPCK.
> + *
> + * This is because in the current encryption scheme GHCB v2 uses AES-GCM to
> + * encrypt the requests. The IV for this scheme is the sequence number. GCM
> + * cannot tolerate IV reuse.
> + *
> + * The ASP FW v1.51 only increments the sequence numbers on a successful
> + * guest<->ASP back and forth and only accepts messages at its exact sequence
> + * number.
> + *
> + * So if we were to reuse the sequence number the encryption scheme is
> + * vulnerable. If we encrypt the sequence number for a fresh IV the ASP will
> + * reject our request.
> + */
>   static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
>   {
> +	dev_alert(snp_dev->dev, "Disabling vmpck_id: %d to prevent IV reuse.\n",
> +		  vmpck_id);
>   	memzero_explicit(snp_dev->vmpck, VMPCK_KEY_LEN);
>   	snp_dev->vmpck = NULL;
>   }
> @@ -326,29 +345,29 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, in
>   	if (fw_err)
>   		*fw_err = err;
>   
> -	if (rc)
> -		return rc;
> +	if (rc) {
> +		dev_alert(snp_dev->dev,
> +			  "Detected error from ASP request. rc: %d, fw_err: %llu\n",
> +			  rc, *fw_err);
> +		goto disable_vmpck;
> +	}

Realize that snp_issue_guest_request() will return -EIO in the case that 
the returned SW_EXITINFO2 value is SNP_GUEST_REQ_INVALID_LEN. So all the 
work you do below in get_ext_report() doesn't matter because you end up 
disabling the key here.

So maybe this patch should be split up and parts of it added to the second 
patch (but that patch seems like it would still hit this issue because 
-EIO is still returned.

Thanks,
Tom

>   
> -	/*
> -	 * The verify_and_dec_payload() will fail only if the hypervisor is
> -	 * actively modifying the message header or corrupting the encrypted payload.
> -	 * This hints that hypervisor is acting in a bad faith. Disable the VMPCK so that
> -	 * the key cannot be used for any communication. The key is disabled to ensure
> -	 * that AES-GCM does not use the same IV while encrypting the request payload.
> -	 */
>   	rc = verify_and_dec_payload(snp_dev, resp_buf, resp_sz);
>   	if (rc) {
>   		dev_alert(snp_dev->dev,
> -			  "Detected unexpected decode failure, disabling the vmpck_id %d\n",
> -			  vmpck_id);
> -		snp_disable_vmpck(snp_dev);
> -		return rc;
> +			  "Detected unexpected decode failure from ASP. rc: %d\n",
> +			  rc);
> +		goto disable_vmpck;
>   	}
>   
>   	/* Increment to new message sequence after payload decryption was successful. */
>   	snp_inc_msg_seqno(snp_dev);
>   
>   	return 0;
> +
> +disable_vmpck:
> +	snp_disable_vmpck(snp_dev);
> +	return rc;
>   }
>   
>   static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
> @@ -437,7 +456,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
>   	struct snp_guest_crypto *crypto = snp_dev->crypto;
>   	struct snp_ext_report_req req;
>   	struct snp_report_resp *resp;
> -	int ret, npages = 0, resp_len;
> +	int ret, resp_len, req_cert_len, resp_cert_len;
>   
>   	lockdep_assert_held(&snp_cmd_mutex);
>   
> @@ -448,14 +467,15 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
>   		return -EFAULT;
>   
>   	/* userspace does not want certificate data */
> -	if (!req.certs_len || !req.certs_address)
> +	req_cert_len = req.certs_len;
> +	if (!req_cert_len || !req.certs_address)
>   		goto cmd;
>   
> -	if (req.certs_len > SEV_FW_BLOB_MAX_SIZE ||
> -	    !IS_ALIGNED(req.certs_len, PAGE_SIZE))
> +	if (req_cert_len > sizeof(*snp_dev->certs_data) ||
> +	    !IS_ALIGNED(req_cert_len, PAGE_SIZE))
>   		return -EINVAL;
>   
> -	if (!access_ok((const void __user *)req.certs_address, req.certs_len))
> +	if (!access_ok((const void __user *)req.certs_address, req_cert_len))
>   		return -EFAULT;
>   
>   	/*
> @@ -464,8 +484,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
>   	 * the host. If host does not supply any certs in it, then copy
>   	 * zeros to indicate that certificate data was not provided.
>   	 */
> -	memset(snp_dev->certs_data, 0, req.certs_len);
> -	npages = req.certs_len >> PAGE_SHIFT;
> +	memset(snp_dev->certs_data, 0, sizeof(*snp_dev->certs_data));
>   cmd:
>   	/*
>   	 * The intermediate response buffer is used while decrypting the
> @@ -477,25 +496,37 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
>   	if (!resp)
>   		return -ENOMEM;
>   
> -	snp_dev->input.data_npages = npages;
> +	snp_dev->input.data_npages = sizeof(*snp_dev->certs_data) >> PAGE_SHIFT;
>   	ret = handle_guest_request(snp_dev, SVM_VMGEXIT_EXT_GUEST_REQUEST, arg->msg_version,
>   				   SNP_MSG_REPORT_REQ, &req.data,
>   				   sizeof(req.data), resp->data, resp_len, &arg->fw_err);
>   
> +	resp_cert_len = snp_dev->input.data_npages << PAGE_SHIFT;
> +
>   	/* If certs length is invalid then copy the returned length */
>   	if (arg->fw_err == SNP_GUEST_REQ_INVALID_LEN) {
> -		req.certs_len = snp_dev->input.data_npages << PAGE_SHIFT;
> +		dev_alert(snp_dev->dev,
> +			  "Certificate data from host: %d, Max size allocated by driver: %lu.\n",
> +			  resp_cert_len, sizeof(*snp_dev->certs_data));
> +		ret = -EFAULT;
> +	}
> +
> +	if (ret)
> +		goto e_free;
> +
> +	/* Pass the actual certificate data size back to userspace */
> +	req.certs_len = resp_cert_len;
> +	if (resp_cert_len > req_cert_len) {
> +		arg->fw_err = SNP_GUEST_REQ_INVALID_LEN;
>   
>   		if (copy_to_user((void __user *)arg->req_data, &req, sizeof(req)))
>   			ret = -EFAULT;
> -	}
>   
> -	if (ret)
>   		goto e_free;
> +	}
>   
> -	if (npages &&
> -	    copy_to_user((void __user *)req.certs_address, snp_dev->certs_data,
> -			 req.certs_len)) {
> +	if (copy_to_user((void __user *)req.certs_address, snp_dev->certs_data,
> +			 resp_cert_len)) {
>   		ret = -EFAULT;
>   		goto e_free;
>   	}
> @@ -676,7 +707,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>   	if (!snp_dev->response)
>   		goto e_free_request;
>   
> -	snp_dev->certs_data = alloc_shared_pages(dev, SEV_FW_BLOB_MAX_SIZE);
> +	snp_dev->certs_data = alloc_shared_pages(dev, sizeof(*snp_dev->certs_data));
>   	if (!snp_dev->certs_data)
>   		goto e_free_response;
>   
> @@ -703,7 +734,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>   	return 0;
>   
>   e_free_cert_data:
> -	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
> +	free_shared_pages(snp_dev->certs_data, sizeof(*snp_dev->certs_data));
>   e_free_response:
>   	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
>   e_free_request:
> @@ -717,7 +748,7 @@ static int __exit sev_guest_remove(struct platform_device *pdev)
>   {
>   	struct snp_guest_dev *snp_dev = platform_get_drvdata(pdev);
>   
> -	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
> +	free_shared_pages(snp_dev->certs_data, sizeof(*snp_dev->certs_data));
>   	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
>   	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
>   	deinit_crypto(snp_dev->crypto);
