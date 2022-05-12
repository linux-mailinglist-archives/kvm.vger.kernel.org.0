Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFB8524CCB
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 14:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353737AbiELM1Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 08:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353650AbiELM1V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 08:27:21 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B5A13F5C;
        Thu, 12 May 2022 05:27:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mPvQetOIW/Ptiymp/J8NeEe9LRnokNvNamQ8QrMprzxgy/FIayGD02IKJK1nSjjRREvUhmjSQVuTl9Xhb6mdtPPRF7IvQ2ma20qy7z1AiR9zoJqYuufi38uxEkHmU7ow8gUr/4ekU65yH+0pRWZDc7rvHGqJMQGxaeK6GYlsp1WtTNyOYOpt/rrRJD1EevUr3V3XgE9nU4ATdrxOnl5uOk9t2zmaRgA3oQh1RjmBdIJkmJ2W3gGLCl3WX8f3+54j+vygTP9pG9EOw+KYGkTaiP7X58cTjZ6gcqe0s0bu3vYdyRztYm2u7aUgC2VJ7QFlY35YkE1LL8yuwUekaEd3BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lmTA2DUf8+saemp/sMfgnsYZuSMbczp+V+9FYvtgrvE=;
 b=UyVMvCGpJQZ2EPdF8CnfAkUJJuvTTGHX7EOjIxSFGZXRtW/oFAnsB93lAX0ZSHVrt/t1qnICQdVyleMD73x/7wU1KPDqEu7NuTa91C6AS4RQhMBXpULXBX5z6UKbFEYv3YvUMdeeH3ez/sRmC3d2+TjS8Ly4VX55mdC1/060vc2oNQUe+3fuKwnMK6D4SSbKJ0BmjjSBo20vH9iCIggQgYjj1S3eGy14+EqL2J2dWnXi87iSYGULhP+Wj5bIvTm1Tso+DxJl5kGDZ6h4BHEZf0XmEDXAD3Ve07HiMVeR1bW54Km1x7c7y2+ZmEVjTqjDfjOsH02RnaXesBcucaMVBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lmTA2DUf8+saemp/sMfgnsYZuSMbczp+V+9FYvtgrvE=;
 b=ppnlvH/Mpgzl4Lm8XZtVSJuhQHQtqeB9jFzsh2/y8r+hNHZppWiBBJl0WNjkRgseeLFcl4amseU3Yb+AzNC07to2X6/hHF4ayNJNYWK3rCjqME0sfo+3/BlrDRbOKXRj3ywt/jHG6IQbcAKMe5w+XSlr3NcfZkVvDEW9ZY38aE0PEDgjHC9bwdPi13HLV+ZrSCOOPYzs7PXCxq6DKw1awr5o48xvzsFWJTBI2KEBQosuJrfJl/ImqOR9e94lU2ES8lNdrkEcj4uesEYCfrpnrrL8Q4oK9p9SRPpRaw1YJnVbM/hA3x1VC/NUMTOnrNYumk5oEW2ARRE2urXNsn12qw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by BY5PR12MB3812.namprd12.prod.outlook.com (2603:10b6:a03:1a7::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Thu, 12 May
 2022 12:27:18 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::a9fa:62ae:bbc8:9d7d]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::a9fa:62ae:bbc8:9d7d%8]) with mapi id 15.20.5250.013; Thu, 12 May 2022
 12:27:18 +0000
Message-ID: <fdba8dd2-4db8-81f3-d9d8-4742c88e99d9@nvidia.com>
Date:   Thu, 12 May 2022 17:57:05 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v3 8/8] vfio/pci: Add the support for PCI D3cold state
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
References: <20220425092615.10133-1-abhsahu@nvidia.com>
 <20220425092615.10133-9-abhsahu@nvidia.com>
 <20220504134551.70d71bf0.alex.williamson@redhat.com>
 <9e44e9cc-a500-ab0d-4785-5ae26874b3eb@nvidia.com>
 <20220509154844.79e4915b.alex.williamson@redhat.com>
 <68463d9b-98ee-b9ec-1a3e-1375e50a2ad2@nvidia.com>
 <20220510133041.GA49344@nvidia.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220510133041.GA49344@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0169.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::21) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09afed3d-6a8a-4986-0dee-08da3412c0f4
X-MS-TrafficTypeDiagnostic: BY5PR12MB3812:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB3812BC2CDF55346982C2C535CCCB9@BY5PR12MB3812.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OoKI8IaN9Bki5MNKZ6KoSd1oTT4ZS0FfLYLqyrtUDFaFniZNjEeUCnKIdRIzevsRScl841Bwm25AbocYUpuja0wJlsuD4Hjanc2kuSHzEKwnWNwravo9NR9AA6oCyeMKqsNC2V3r/aK7WygKnQ7EIMnWvX0dsnNWCSqFCLtYa7CBAnZbcD15qnDezjDjHZ7a+0MHfRYZAYwzIAkJfuS1ZtKHeaWKmKcfDWY1W0d/9kXL7HUPwf3txh1YjMxKriCt9u+pfXjKOu4bPdD+PcbVkHLCEIPum19D9yeSk/yHIcJJkVCEK7cW7ueE5oBwxCn8/usFtUL97TnLof3aN2qrKCJckJ8fbxUdkLDTWlCFI2DMgXC1g9VG5kJ+2Y43vxw4nVv0dxmWcOlLK4Pn5BjgQRUs2OYnpzv01OZd72qb31Kl3SUhZx3ojXB386jomiWAU1lsaNgDgVEiBXkZUEJEaFIdW0fhnp0PE+f/lTA1gerRE2VrHu8PhribcoaEU3yDlIcQUYMv52YuyCPR+QzKWtvNmNxs5KfWjfGmQALcPOPdxNWVlejQDrIsvqBlEQSm98+VKfma2aGdS+VGd1AZth/oawrFVwBzT04AOvEohFn0pg+iRPeaRJveAv8RbupL0Kom9cqdgG/jK4Fp0Dxl1nBZu0zYQ5y07ktsJChoG++o+ml7auqzMkGyVPdYOfYmtXDOrkZNqkHhOU8reElqC39NAn5Wc6HaC3biYIMiaaqWIPA2/cUkKFxE3b2B+KWD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(6486002)(4744005)(2616005)(38100700002)(6506007)(26005)(7416002)(53546011)(55236004)(86362001)(2906002)(5660300002)(186003)(6512007)(36756003)(31686004)(31696002)(316002)(66476007)(37006003)(54906003)(66556008)(508600001)(66946007)(6862004)(6666004)(8676002)(6636002)(4326008)(32563001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2w3RFBhaVFPdVJLU0srWVFnZlFDSUFHWE1keGE3NE9heW5zOTlDTFdtNVB4?=
 =?utf-8?B?TDAxeitEVTZqMWN2UFg1d0hLMUI3akJIcXBXKytxTFVNc0h5WmNTZWFjRy9Y?=
 =?utf-8?B?MWowbDFGQ0k4aFVDSDg1aE9GRkE3YVM2dHo4SVpXL2tYQ1J2ME5iZjlld0g1?=
 =?utf-8?B?SG5vVjlJMzB1eEFTdzdRME5wZTdibVJQaXJwRktOcjRVTFJHY0hsSUFJc1c5?=
 =?utf-8?B?U2h2ajJCVUhEU1NEQzJrU1ZXT0RTR0RyQ1BDZ01IVHdqL0RmWkhnSG9GK2RD?=
 =?utf-8?B?WkU0TmtEMjNXQUgreHRqWmlXSlRqUGRyZ1g0WFdGdTN4SHpuWWZKcHo1M0Qy?=
 =?utf-8?B?bGNMNmwxd1N5UTNmTTNQc296UFpBMWMvbDl2QkNTOXY1L1dzaDdQUUxkYXdM?=
 =?utf-8?B?SGgyQmQ5aGxFWFU2T1Vzc3AyV2o4R3NNcUVRbTkyUnpoRERuSTZqSVQxcEc0?=
 =?utf-8?B?MjFUd0xCSVpRelNBL1BjY2tDS3Y0R2hCTmVlcE9ZN2FYalJ1U2EyWk9Ndkl3?=
 =?utf-8?B?cFk2WS9zNVdCS3dwUndYUEpIZW1NMjY0SGdPVE82ZXpaNlBHMFd3cmc0a25s?=
 =?utf-8?B?eXliUHpxZlIxQmh6ZzBRN251bUVEd1ZkQmFXZjRJb0VjVlovWnlWUWFKRkVS?=
 =?utf-8?B?RURSMExYRTEvTTJIVFJZdTNuaGtiRlhwcFQ2eEY5UGNhRFJxS1BYQVR3TlhE?=
 =?utf-8?B?b2tEVjk3SEdJVjgwZ01GOFFkK1pJVjcwalg5VGpLcFJqVHdMc0Q2MURxRzJ4?=
 =?utf-8?B?ZlpzMjBvOTlybG9XL2xuVEkvVUZKSnhYZTlCRVRwS0hteWdQdi9JQ05UWGwy?=
 =?utf-8?B?cENuaDNlTHNLcm1NeGs0dmpiMytNL1Y2VHRWT3l2ZXJ3L2ZDbTdPUmpMR0VS?=
 =?utf-8?B?cnRuWnZTNGNPWVJQQ25hYjRNY1hSV0cyZDAyN1JNM3ZnR1RzaUIwK3dUNHEw?=
 =?utf-8?B?eTZhRG9lUFc5dTBwbkw2MnVCZ1VERkU1dUxnT2FHM3oydGtTaDVFZTVQakVN?=
 =?utf-8?B?bTUrVDd3emptbVA1TERLTnUyY2lOTmlrS0F4YjBuVkdJc1Z3RS9LRHJRdmVS?=
 =?utf-8?B?eDBrVURsRG9iQmQrM3o4c3c1WGdwbkVOSEpTazZqTEtlTWZyOGt6RFRUYmJW?=
 =?utf-8?B?QTNxQlh3T1hlM1JaTzdDdHJvR0pjVVBMSUlOMnhDT1pReDQ5Rlc5RzNJemVi?=
 =?utf-8?B?M3dYeStjYVExUy9DalhUSHFVd2tXV1F5bUhKMndyMnNKYnF6L3VScDhoQVBZ?=
 =?utf-8?B?SktzZlEvSUh2KzI0OWlJQ3ZiS1RUZjBlV09HRy80TzNDYVdQNFJjSWVmNGtD?=
 =?utf-8?B?N2lWWGtrV1dxZEhFYXo3RUhGQTV4TE1MUy93eU5peFZXa1Y4SVhvRlVEcmdG?=
 =?utf-8?B?blcwd0d2RFV0MmlNR08wZEVnTmlRcEtyT2EzanEzU2x1OWpjT1p3cjY3bkhG?=
 =?utf-8?B?VGNvSkhqQ3BFY2xIMDVFSGRiaHgzUFFvYVorVGJwU3pybGc1aGFpempLUm1o?=
 =?utf-8?B?eGxEOTduSUtsSGl4aHpDUzdGVTkxUDMyelVLL3BmQnFqQ25ZVmIwOVZ2bGhz?=
 =?utf-8?B?MVRBOFZFUGhuSEFlR0hxT25FMS9LcDE2SUNZd0hMOEtYZERsdUQ1SW02S1Bt?=
 =?utf-8?B?Q0hSRU9QK1RTUGhnb0kyWXlsZ3d3VGNQUEcvWVdLcTJUbzVnTWE0SGR6VW94?=
 =?utf-8?B?VW52dzl6bVFVL29ldHBONFhNWGFWdmRvNkVMbzQvMnJSRWlJMFV5dnFnUlY4?=
 =?utf-8?B?RzFoRy9tTWF3ZkMzSlZZa0RmOGJ3MmpXMUdDWjVlTmV4K0xIdjlIMXVwbWJr?=
 =?utf-8?B?RE1JZDA0akpMWVlmL3lza0Rtanp2OGNvbVRlb1RxaUROdFh0N09tS1l6QVRB?=
 =?utf-8?B?VEdIS016cThkUU43V2o0eWlIUHUzVkd3SlQxYWdsVzVVVHJMMzdjUWRRUkpI?=
 =?utf-8?B?NXV3RmFqWlVybG1rYVJXdGUvaGV1WFA0M2UwWjN2ekg3cCs2dXlyMFhQNVdD?=
 =?utf-8?B?cCtwa2ttZjZBOXh6cXdoVElod3BvbzR2ZGlBUDJvQVUvOHJXNHgwdGt2YXE0?=
 =?utf-8?B?dDVRRmdkRTdFVmIzT1B6bjRuZnlhWlQweFMzMXl0WWx1cUNUMzY1Z1hHQ2ky?=
 =?utf-8?B?d25QdmZac0pMWitFZlJ2emcxekV4YnY1elpZQTlGa0V2UDJJMVgvQkJpdFlr?=
 =?utf-8?B?NDNodWtEa2JKeXBmNmZPRjJCdDJaT1I5RUwzQS9IVFRkQVJDRWtxeCsrd2o1?=
 =?utf-8?B?NGpsSzZlOFhLUks1UVhDYTJITm84RWtid2JEdllUc3FSUGs0RDRoS3dDMDIw?=
 =?utf-8?B?eHhwdzJiMDJrNjBvL05qNmpSWlJuS1lwbXlnMndOQW4zb3FZK3R5Zz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09afed3d-6a8a-4986-0dee-08da3412c0f4
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 12:27:18.1058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HGC3X6b466dvBxNL662UhBpkNwW7dW1Nrrw0Si6kE8FSx7z7GhyDM/uvb9uEbpzqlMZssNLMleF7ZxrU5GNKjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3812
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/10/2022 7:00 PM, Jason Gunthorpe wrote:
> On Tue, May 10, 2022 at 06:56:02PM +0530, Abhishek Sahu wrote:
>>> We can add a directive to enforce an alignment regardless of the field
>>> size.  I believe the feature ioctl header is already going to be eight
>>> byte aligned, so it's probably not strictly necessary, but Jason seems
>>> to be adding more of these directives elsewhere, so probably a good
>>> idea regardless.  Thanks,
> 
>> So, should I change it like
>>
>> __u8    low_power_state __attribute__((aligned(8)));
>>
>>  Or
>>
>> __aligned_u64 low_power_state
> 
> You should be explicit about padding, add a reserved to cover the gap.
> 
> Jasno


 Thanks Jason.

 So, I need to make it like following. Correct ?

 __u8 low_power_state;
 __u8 reserved[7];

 It seems, then this aligned attribute should not be required.

 Thanks,
 Abhishek
