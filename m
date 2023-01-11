Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15EFE66670E
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 00:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235566AbjAKXSw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 18:18:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235824AbjAKXS0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 18:18:26 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2085.outbound.protection.outlook.com [40.107.101.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C077A3C0FB;
        Wed, 11 Jan 2023 15:18:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtnBhywwfgZb8i8ejOitZiZJJsJwRy72HiL9f26f/lxZYQp3cH9DyJuWwywsU+mdKr0htQ0MYXdZKX/zCbnaqPROj4Wko6+wbxdItP1HUV0k0fMquw9TptbchqVs44pwMwgD0IAu4j4mwx1SsOfAox3/xwB5WSQ2WKuI5UH1f/lH58O3J2FVMU/qt79TRuI/20jI4kdkJcBNf0RVgzv/Q+5nAD04MFVHk0suFgX03TRdNUFCAUJsxF7+C7ycnjoiNxevx0/MXZvK2WM3JC/XyGAL1Od9q2hzBKGvRpoazwPHQvfRUz5b5Vh93Icvp5oZObW19Fja/CEmnSaH/mDtFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2EFJ4M8HhmT2IWsebnxl2ZlGqs3m5zKvHtC/Sj4bzeg=;
 b=bIxZJgzCTI6Hz3efpmSBSXkKBSDC8Q47r8nzeuLg0ri2RyYZIUxV26ZTuZc4D54L6gAS40khTAuvt57gnAZJzQHwF0tBkYg3NInTZmvX11pFG+LfTexS3rCPu7bA8nwZP8LEsqip8SUNjhzIdtjlWj71hvqYj1Vx6GsERAZza6LBnmyBYkGdmnwLJ7u8RU+1h7KHmKlnNvIXlVFASM1mLtl2Qg6fWh2NUGIFB60vZyZaPF3h1JRP28ZJlirXX9He44EcyNfIaY7FYVTQbh1NSWPyEyLGBLAZNixxxkRjBA9tS2jwaUOTkaKDp7Adj57wdPG+IzQqgIme03FsXfAS8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2EFJ4M8HhmT2IWsebnxl2ZlGqs3m5zKvHtC/Sj4bzeg=;
 b=A9wYf1UEZLAQ7wKq6iV3lys1qiRz8VRXi7TKlhJznbXcLx5Yp+r4h88vpUzKM+HWaWfdUqWrRqJCJ96943BrHdy1xIxe/zLsPS4c71NoinTZHTd7sm8fmTwez5T5s/hLIxupPlnken9U09MyaoVz4So6lq0SQqe2ZchDbn+5ovY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by PH0PR12MB8049.namprd12.prod.outlook.com (2603:10b6:510:28f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 23:18:22 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9%3]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 23:18:22 +0000
Message-ID: <0a8727f0-d3fd-f842-e050-bbfbb72b5728@amd.com>
Date:   Wed, 11 Jan 2023 17:18:16 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC v7 40/64] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH
 command
Content-Language: en-US
To:     Sabin Rapan <sabrapan@amazon.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-41-michael.roth@amd.com>
 <cc2998c8-1d18-caa7-0421-584c08406847@amazon.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <cc2998c8-1d18-caa7-0421-584c08406847@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR13CA0011.namprd13.prod.outlook.com
 (2603:10b6:610:b1::16) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|PH0PR12MB8049:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fb67bb6-026f-4b76-1234-08daf42a217c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JbNBxC7fIvslTS3ELjJIjLj334pa8IFBuDK6GSaip+g5dgcGeRjstRD/7G/gsxKpTrdiW4xq9tn5ermzHKkEZbNNKQcf/qRrvMjIMHhtz4ENYL37L+hZ2tyRXAQ1ar/KpeJjFENVMKj7phZn6EfX9fxkrrbUuXmSQf7PYK/HDFd1oCuQ6bcI8L7cjp4F7393ZnmvV27V2gnpcxexyyenuzHAI8BHbgQxHmnNRgqwuY1LjDsHCQZHEsLFVHvJsL/wwFEyeYTjws2PkPtV+O197M+iEDP0D0vyYPofyT3PoeGW8m5BDL8wef/kPCThISgeoDXRwZml5VfuzYm6n+54uii0NAZ9wPplg2bvIRxkJAhYcu3TgMkqPk3uUUSaUUpG46EzRE2tRaPvrl4bwYaK3+EtuJ2C9GsvpzcTEYI5Z3aeNyu750CJTybNC3uEsZbzSVpWQbx4VV01frYpUTSdYqtNauP4E2qxC5cQ5iPsSpUygxIWUFQrydnFCIQ+ANxjJJouFy6HzgBJGUEcmBZLPeD8IjixvnbJg9fHSquQ+pESOsQzdPRkTqB0xpw8ueR9GWanzne9JVAWwXKS/B0KUPxL7g5+KxlBrfbTUEmoPj9P3tPP8AYTU9Aee2OVo/hIaMJcS/bEvTUuDf7cnKkP/vMIwDlW/GmOT5NHEseTI43/7nNx6uw03aRVU2+NQ8HLdvOpIh4hrxhUpf9H5fW6zlzwlUNaUrEHKJh4E0I67pU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199015)(31686004)(66556008)(2906002)(7416002)(7406005)(5660300002)(4744005)(36756003)(8936002)(6666004)(66946007)(8676002)(41300700001)(66476007)(2616005)(316002)(4326008)(53546011)(110136005)(6486002)(478600001)(26005)(6506007)(186003)(6512007)(31696002)(86362001)(83380400001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUtCb2VyOVZvWkRTSmxibFlWb1hMTmRQMVR4SVZWWFluV1hCcmdab2h5WW1H?=
 =?utf-8?B?OEdoeC92NkFXV1hFaGN5TTlKZ0JURlJmVHJiRk5xQVdGekZ5S2d0emRQNldC?=
 =?utf-8?B?SThlSVp2Z1d6dEdEU0dFVHZ3ZzhDNTllUHI1d3hRTXZvYmNkRCt3MGVFb214?=
 =?utf-8?B?KzFacW4yVjZ2K0VmbmFTclJ3MmlISUVGdWtKS05qWlFtVnFrcDN5Ni9IOGsx?=
 =?utf-8?B?MFl6TFlxcFVUcVpTYlZCOE1hdWZEUXRXc2s2T0R3ZU0yMi9WUnpYR01Eb2pM?=
 =?utf-8?B?WDNZdFdocytmUm9qOTVkNFY1RHRLN0NLbkJ6cXNiVUxha0cwMDYyT1JudXJP?=
 =?utf-8?B?Qjh6dCtvaWltT0E0RWVrV1M0cjZwVmRYamVmOUVLaEVOUkZjMHRVV2NFcWo5?=
 =?utf-8?B?bS8xRUU0Y3V1Ym10SWFRZ0xxV0FXa0wrNDBuQlVhOG05dnZpSzRHYzlhSTFr?=
 =?utf-8?B?WWZMRjlPRVRpY21XUEczMHdNa3V5Z2NNdjlUK2lPWndEVGlLcHE0cVZOQlJx?=
 =?utf-8?B?RlBBZ2V3bEV5WDk0dTdERFNMM1RDUFEySWdUdzdKTG9IYWZ4dXh4OTRLUCtM?=
 =?utf-8?B?OERPTmxQQ0xVY00ybmdqRndUU2pQcDcyRTFUaUFhYzhIT25JWXA2QWpnS0ln?=
 =?utf-8?B?WW5sU2dWOGRVYW40Q3Q0Q1AwSEYxa0s3cTBJMUVkVzlhRTcrVjhVaHp0Ymdr?=
 =?utf-8?B?Qm5YcllnRmFSUmRocXQxbEJEMTZYeVljd3Nna0F4RzFaK0xEaGtmcGFueUND?=
 =?utf-8?B?SnJtaWNBem13SDJ2SzJCOGMvV3NLSXlkVWcrM3Vpd0xMZHVac3A2ZUZMaFlU?=
 =?utf-8?B?TnU4N0daYlpIcTVEY1RyWlVVSFhtSWVXVm43TmxucG9ZMVJmeWVsUkVORlF4?=
 =?utf-8?B?VTRkbXlaMUd2bWozcFhuWnVSZEpOVWVHTnB5Z24zOVBISUpnakxtWEdYeWRm?=
 =?utf-8?B?Nmh0UXA4VzFuY3g2b3ZIUldrNHFCU0lCandJSnJuUjhLUmt4RnhsVm5VQ2Nu?=
 =?utf-8?B?M0FQQmpveEUydHFrVXFUYXV3OHpIektFVmZDMW1nUzNPbG4xV2dqSS9Mb08z?=
 =?utf-8?B?aDFYVitKelBZSG1lS2lRS0lYQ2NUdXovTm5mNSs0SFhoY3l6d05ScDA4WUpQ?=
 =?utf-8?B?WWhpWkhHSjIvM3BGYjhmWUx5c01qaEtOV3VSbnZiYzZ6MGUzZmt1Rm9kTFR4?=
 =?utf-8?B?eW85Z3JGcU43UDNMeW53L0FxcTdkVVhIREQ5TFBkOGp6WCs0NzZsUUJzMXBq?=
 =?utf-8?B?MVplUnJxK0tCZytTL3J1RnpuNjRtdWp4bXJibGwxb1FnNFlwb255di9Gcytx?=
 =?utf-8?B?T0JQUlFvOElJZnZvR21tMjNuRjZqV2ZxTUVuK0NiWmZNL1UraXI0bk5oOU9n?=
 =?utf-8?B?SWVUZGsrQXc4TXRGbE0wUThlWUl4S3A5bGRPVC9tUmdRaExSUnRiUXY3Z0VM?=
 =?utf-8?B?d2VQeWlmamFnblhwam5qZUU2QmI3Q3dNMWUwYkltOE1qNjAvOElXa1IrQ0lK?=
 =?utf-8?B?Y2lvOUhDRTExSFVEb2hJZlVBS1JHa3NnT0VvSlhsWkNxbHJTSjV4dTBJby9v?=
 =?utf-8?B?NFMxVjZhVVZmRWwxcDNNTUZOWVoraEFRWi9WczBaT245YkxVNmVGWDRZaDlB?=
 =?utf-8?B?eHM5MWVWN1MxVy9WRDBpeTJGN3NDUHA0UGFZN3VJTWNUUk9odXJJRHcxL3Rx?=
 =?utf-8?B?L0FTZ1Q1bThHVGY5QmN1N0c0SzIvNUtOd1RqQ2ZOVS9WcFE1eUdSNlNBWG1r?=
 =?utf-8?B?Qm1Nanh2Qi9UeHJjNW5JY1AzOGNnVHdqU3orajhrRVdrWTR1a3J4Nmd1djJE?=
 =?utf-8?B?Y3RLekNzMFloa3FSMGl4RitQMVNzRjZhVVgvcEtEQW45VGk4WmtqUnl0M25B?=
 =?utf-8?B?UnlMeVZBYUxWUEJFWUd2TFo4bEtGbi8wMGpDaUNDMnRFYXBoNDZZZDVmcWMx?=
 =?utf-8?B?SXhBTG14NVhrQ2xoMWhVN3d6VFpoNGErMXBqYVIzZVJxTE8vMEdHN29DMElx?=
 =?utf-8?B?Wlp3NlQxUTA3L2praU5lYktTd29QbXRaU0RCY1MzSmxkekxHWW1ZWXExUitp?=
 =?utf-8?B?dlJXSFNJMmprOVNkV2MwU1BMcGhEZ0JtVHZ0YjRzVDdST1lrZTdjRW0wMUht?=
 =?utf-8?Q?dVClxQx8j5GCodPBCI/yq7pu9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fb67bb6-026f-4b76-1234-08daf42a217c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 23:18:22.5491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WVj8bLH2bNMtDu5dRLEMUKhAl7UzW9OZGLTRzWFofeMhUpGRWg5wR6nNdKPJplj67qWqJJwjS/sfPHf+//ZhRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8049
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/11/2023 7:27 AM, Sabin Rapan wrote:
> 
> 
> On 14.12.2022 21:40, Michael Roth wrote:
>> +static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
>> +{
>> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> +       struct sev_data_snp_launch_update data = {};
>> +       int i, ret;
>> +
>> +       data.gctx_paddr = __psp_pa(sev->snp_context);
>> +       data.page_type = SNP_PAGE_TYPE_VMSA;
>> +
>> +       for (i = 0; i < kvm->created_vcpus; i++) {
> 
> Should be replaced with kvm_for_each_vcpu() as it was done for
> sev_launch_update_vmsa() in c36b16d29f3a ("KVM: SVM: Use online_vcpus,
> not created_vcpus, to iterate over vCPUs").
> Prevents accessing uninitialized data in struct vcpu_svm.

Yes, fixed this one.

Thanks,
Ashish
