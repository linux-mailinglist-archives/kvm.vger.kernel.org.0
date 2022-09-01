Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA735A971C
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 14:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbiIAMph (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 08:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232864AbiIAMpf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 08:45:35 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E724057F;
        Thu,  1 Sep 2022 05:45:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dWXvbdLo8TxywiR3Up/eW3hk0S54iNfPuWDPJQ/6FTgtoID8vk/tQvuVxyyEa+4GYuyq4jXQRMojUV5K2XlbZkXQrD3Zl4GmnGHo04FKEBGT5MTdAQL0xFMvXQxrWxXyhjNuTP6QNWYZ1FfmI6BYK0QmL34/8bwEy32NRf87fR3J6paQcvC03p9DqxkwQW/bfiWyu9VFp6GRyW/Yi4KdGiFBEuC/Obwl5ZS7QPtv5oqZMbfFt7ehq5Ly6hPmuqkT4gxaJiOuuXu2xnQskfoFQKTycDSAOC9v5MlPOCNswfkRXFmpNBGkSP4nXpBHULpeCb7iQW0RlbcI0oAdQIJcSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CFL06KRN554GfEzkQpj1AnLhdBFhRPpdTc3a216pat0=;
 b=F/OG5O2WstA3Xb8xYgLgdxBQq2HZA3BEks+v1NbbxARbZct2lEx5ImcnHye0aYAnnEvwHrAGA+izbEJntefLbqNUjI7IB8zDwQmJLGzHziRmS0fJLnLBZtcFwzr14kfiMS1cOyGDH4nTQLcdU/51B2at0emQY09up8iTlDEmJDyMLj2wutPjzC+08nCqeT9vfutJisty+hAWvIJMy0GVHfG60zPgS3yelQGSCT8dlX3ph5hQSGSD1eS4S9Yl74RCexoaGeQId69k8f+Z2FWe/WRwjSo3agvL5ERC69BR5QSr/7gwa9Lzj7XmDT69jS7xlYclFcmj0nGQpu57yy7duw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFL06KRN554GfEzkQpj1AnLhdBFhRPpdTc3a216pat0=;
 b=svoLxMCGL8tGs7zc8urXDdX3Ckx/ZFY35OyJytsezjMHBeGZui5yn+MVCkdb7+86nLYbqMc4ad/LHEUffDN/dFuMPgteM8C+zUC434qgOhry0E526Fz0rJsWYnhSbEATyvW6lQ7TisW8eErzFWB4pl1f2/UhnaA02qeaGQBLqZw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by BL0PR12MB5009.namprd12.prod.outlook.com (2603:10b6:208:1c2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 12:45:32 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::40e5:d623:4a03:af0b]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::40e5:d623:4a03:af0b%3]) with mapi id 15.20.5588.010; Thu, 1 Sep 2022
 12:45:32 +0000
Message-ID: <a599f0da-3d9b-a37f-af7c-aa1310ed77e1@amd.com>
Date:   Thu, 1 Sep 2022 18:15:01 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCHv4 1/8] x86/cpu: Add CPUID feature bit for VNMI
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mlevitsk@redhat.com,
        mail@maciej.szmigiero.name
References: <20220829100850.1474-1-santosh.shukla@amd.com>
 <20220829100850.1474-2-santosh.shukla@amd.com>
 <CALMp9eTrz2SkK=CjTSc9NdHvP4qsP+UWukFadbqv+BA+KdtMMg@mail.gmail.com>
From:   "Shukla, Santosh" <santosh.shukla@amd.com>
In-Reply-To: <CALMp9eTrz2SkK=CjTSc9NdHvP4qsP+UWukFadbqv+BA+KdtMMg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0098.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:27::13) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18815fa6-5b0d-4eb3-44b7-08da8c17db1b
X-MS-TrafficTypeDiagnostic: BL0PR12MB5009:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E+qp0YIzAqRHl78bUOZWWpJomQc+d1wAwoeQCVWvznq+RQoFsDifz3APijyKKetiC51rYdkyaaaL0LfYgAQY5E2/4BN98Q3+jwVBJSCQhA4J6Rz4MXpujcuWkpX33hMQRddMAv4hD9H4o+1x4WAhktDiybuy79bTB0jeya1w1mPJUq43df+WLmbkbfuE3PYlymkg/5bpuMj/5khP6gVKmMedFdJ4W7C+IQX3ilt25xxYQuqPkV3dj5e8RUy8Sql0PULpgnzOdhxXC+1WCnDwS33Kks/IeGDK9M+oVin4AxSUSDSd0RgI1jPn6oMfg208K2u4s2M556VSQ4xfnfxEqLtf+NEglQQM+CMrsuhSqVdLQ0EXClL/vmhv+dsbVly/hoTd7S3clig08qTLJrmrarclOQ4nR6K113LP6orEq2M5Pnb3k1vBta1LJlWidJltQK88HmA1AyS1e43M2rejKyhx2bRP7YO02iC220IlZ/O2R9YYuq9+9pUp73anliHQHcrFFwnN48Rmu0k73Xh79XPRtfh8BWWDwQrmCgmc7G2+GbBf1ZsLztjj7WEef1SJtPQJR9dkWLIoa4EU2smWlrw9y7WsFO5OX98+QmnlJtVo/BhpD9yB+R7h79zSfw/vAqNhMK7BJqiKyE8VmuGV8tXxdKEAnn4X31Rw4joxVFjMdGEBon003ZRrDmctUMElaxEJyO5PVqfjHXxaVGcMaH/5sGrZKzFmE0Rp8f+lnLej2sQ8KPyK7lqtjFfCVc5/eQV3uxvprZ8swkY/MU2y4CONJxHrBwx55mCkKUJRwm0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(366004)(376002)(39860400002)(396003)(83380400001)(2906002)(26005)(6512007)(2616005)(86362001)(4326008)(8676002)(31696002)(186003)(66556008)(66476007)(66946007)(36756003)(6486002)(478600001)(38100700002)(8936002)(41300700001)(6916009)(6666004)(5660300002)(31686004)(54906003)(55236004)(6506007)(53546011)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UklDZDRpblhXSWE2MUhNSFdCQlJaUmVseDFYUmpqQm9xamxxR3VqYVRTQUcr?=
 =?utf-8?B?VW15Z0xvSEJNL2R6SGIvWlJENi9OYWRBNU05UGtYRE0xa0NTZG5vOW5RSTZj?=
 =?utf-8?B?UTRBQVhKSk5UcksxR0swWDVmTTExSTQ4RDRFMDR3WkdsUVljNDdyTzZLS2xi?=
 =?utf-8?B?TkhSNkVYTjFhWkpQbmZ5Nzl5Z3VGaWpHWlVEZ3NkemwxTmxvNE0xTzlEUEVT?=
 =?utf-8?B?R0o4L1oxN3NMbW1IVWNaeStvUCt2L1hUYmU0SjJiTEk5cFhFMFRyOXByT2d1?=
 =?utf-8?B?N0F4ZUhMK29ka0tkRUJNNDVGOWRDVG5pRzNCMWJhZExEQUJqd0xlcUlVdXE0?=
 =?utf-8?B?VGhENHdmUWtUSHIvcWtRNFh6RDZTMFh1U0xsOWVFTWR6RlZUUjZnMStaeWRu?=
 =?utf-8?B?QUdLWlRHd2dXdkdkcTY2alRuNElFRDMwR3dkY3dYMUc4NHYxaGRzS0xMZWFH?=
 =?utf-8?B?ZmFwZlNTY01ORnRpUXpNRHB6NDN1cjZLbzROUlZlQ3B2YS9pOTBSNUZTRzAy?=
 =?utf-8?B?SGxKV2tnU3RXSzZTRFVHVUcydm9RMjV3ZDh2eEVDblpNTEZsaS9EMVdnWDM3?=
 =?utf-8?B?dm40UGFCbDRTWTBxMnA5TCtpeTJaOE5HWThqTVZRWGt2T0Z5ODBBbytqeFhD?=
 =?utf-8?B?SmlSY3NaNENJdUZTZTBNMnlIZ2RoM0xTdVdRMkEvMmxXRVlVeUJUVStPL0pT?=
 =?utf-8?B?NXM1a2J0VUhBNmswcXFUOVIxbXVyQmJ0Q2dJMlJCdjFHUFduMmUyTy9SQWtl?=
 =?utf-8?B?eVR0M0FBT2JxaGk1VTdqenZWTVVva2JSeWd5U3RHck8wS25zb0RJRk5tZVB6?=
 =?utf-8?B?K0xkRnRIazI2MHpSTkg1L3Q5K1VQRmVrVHRvMnU0QkloYjRlZitBZ2FBR1hH?=
 =?utf-8?B?L29hM2xjUnhsaVUyZjl6cS8zY2E4bjk5bnhFNVhoaGhybUdEUk1EMlAzSFlq?=
 =?utf-8?B?K3JZUzZxWVRNWWZnNERFRVdCYVVtVHRLSmltY3JJaEwwV1paYzg0ZHU3NUUy?=
 =?utf-8?B?S0J0QVBtdXNheXh6LzI2QWU2RTdsV0JXeS9uMVgvRHMxd0VTZ1lXQWErWkh4?=
 =?utf-8?B?aC9xQ3VURjJUaklqZHJTdXA1a3k4MGxVWUFHOGlyNFJnTE1uOWxFaDFjVWNk?=
 =?utf-8?B?SVBER1NRUlBiQVd2RDduL09OdDBHcXhrYmpaaE1HOGNmaGJjZmpkdTVtSVds?=
 =?utf-8?B?MHpMSjMvc3NrSUl1d3BUQWxQeW9zMnhnd0Z0NU4yMndxNE0zSVAvcFdKUHIw?=
 =?utf-8?B?dmUzekNWUzFrRllUbkhpaUVxQmNNbnRFN3VBMVJPd1E3azgycFUwQndyRy9D?=
 =?utf-8?B?RkNFbUdCN2hDbStqLzV2NWRZZXRzNVNvSUhYVWxBbWFWSXZocjI3UkgxZlJO?=
 =?utf-8?B?dUswb24rZGJUZFdGOW9oU1VJVWhNVnN1TytyZDVnVzVnMENGSXJmZDQ3VEJw?=
 =?utf-8?B?N01yVGdSQ3E0d094YW9VTjZVNE9UZHIyV2hjTzVrQTRwM2JIZmEzZm5DeGRh?=
 =?utf-8?B?L1U3WFdLV0VqQjI4aTh1RjRFMUU4OG1DRXAvdFI4SUNWQkE5UnUzSjEyWk8x?=
 =?utf-8?B?b0xPVEQzRm5oKzBQbXVjc0xtR25iTDlJbm1lcHV2b3dRaGhNblA5ZTdoa2VG?=
 =?utf-8?B?QzNYcFNVVVMzVmE5QzlsdjdlU1RvOGtPcVNnVm55QTIvK0ZiV21HSFF3N3Jh?=
 =?utf-8?B?RlpadGREZGRsK3lPaG4yb2VLdFZBQVVHVG9KSHMzY0FJbEo0UDJBQm9OaE16?=
 =?utf-8?B?QWhhekwrNGhEUEY0MktJVC9WZHlCRGNTcEQ3R3ByMDdGK250UlFDRGJuamRk?=
 =?utf-8?B?aWlHME9sTTNkRzJwaVpZeHJ6ZGFRUXdaVDBhbG5tRFVZcCtya2ZHbUo3UEtE?=
 =?utf-8?B?OThHTks5ZGZ0QTY2OGpJVzc1d0ZjU05GNEp6UWM1aElwSnpvbis5NDB5K3U4?=
 =?utf-8?B?b0IrOEtRcGlKSUJMcjBUcUJTa0dETTFKUU1kNW16TjlBWHhwTkY4YWdPanFH?=
 =?utf-8?B?amhzeUFnN3JQTlRXVmFPWU9rVXhmYnVYV2Z1VHJKUHpxUWJRb2xKc0pxQVFx?=
 =?utf-8?B?aEZVT0JEQXpvaUx5TkMvMGlQY0NmWkxzRzFlalo3TlRjK3Y0QXVNZWNoZXpu?=
 =?utf-8?Q?NUGzLauQCDy3Ji9RiB4H1xVJS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18815fa6-5b0d-4eb3-44b7-08da8c17db1b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 12:45:31.9948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6gZSjnn7zdicrmrBs9zj8q9CCzoLYqE98WLsx81u0ijqdfiWl7+UAO/C9Va3EuCcY9ClvDNPS9gt7Hi7zC3i3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5009
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jim,

On 9/1/2022 5:12 AM, Jim Mattson wrote:
> On Mon, Aug 29, 2022 at 3:09 AM Santosh Shukla <santosh.shukla@amd.com> wrote:
>>
>> VNMI feature allows the hypervisor to inject NMI into the guest w/o
>> using Event injection mechanism, The benefit of using VNMI over the
>> event Injection that does not require tracking the Guest's NMI state and
>> intercepting the IRET for the NMI completion. VNMI achieves that by
>> exposing 3 capability bits in VMCB intr_cntrl which helps with
>> virtualizing NMI injection and NMI_Masking.
>>
>> The presence of this feature is indicated via the CPUID function
>> 0x8000000A_EDX[25].
>>
>> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>> ---
>>  arch/x86/include/asm/cpufeatures.h | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>> index ef4775c6db01..33e3603be09e 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -356,6 +356,7 @@
>>  #define X86_FEATURE_VGIF               (15*32+16) /* Virtual GIF */
>>  #define X86_FEATURE_X2AVIC             (15*32+18) /* Virtual x2apic */
>>  #define X86_FEATURE_V_SPEC_CTRL                (15*32+20) /* Virtual SPEC_CTRL */
>> +#define X86_FEATURE_V_NMI              (15*32+25) /* Virtual NMI */
>>  #define X86_FEATURE_SVME_ADDR_CHK      (15*32+28) /* "" SVME addr check */
> 
> Why is it "V_NMI," but "VGIF"?
> 
I guess you are asking why I chose V_NMI and not VNMI, right?
if so then there are two reasons for going with V_NMI - IP bits are named in order
V_NMI, V_NMI_MASK, and V_NMI_ENABLE style and also Intel already using VNMI (X86_FEATURE_VNMI)

Thanks,
Santosh

> Reviewed-by: Jim Mattson <jmattson@google.com>
