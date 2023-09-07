Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454BE797568
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 17:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235140AbjIGPrJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 11:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344161AbjIGPcg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 11:32:36 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20618.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::618])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA82C1739;
        Thu,  7 Sep 2023 08:32:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JeAlRWHu/aNukUybtpjXuq+UsdMcRGsewgzChWOQO/nJ6UrEhH1P2xB8JgN+vilKom1X29NKR6WVjRtK89CaWcqkyeFvhA8FQh0Jh+AgMqEKf7WbGXfVTFfAFeBYhWimCb507e5z1QbJjmljW/oZTy+h1GYugUKGL/K4l+sdTJ5vW87VjjRh6oyYG0z46UYmmbWiKNQ4kPTvQaZ3IzjPY+lOpRw7DO6FrvlcXfHZX2ZJihru/Y0qC8DmY3KhbmyO6DxojJmlLvhFi7fn8dStjn/EY+lhDX5/svG/4iMRTKUbhu3T6czgA1+OaChMei/4XASO1dP/i0VwWcegprHhWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tSovdzbRAPE3j+pzKCVHVRAQ4AtnQaD0dILMNynw5Zo=;
 b=XR12v8kFA4S2p9nNKMh+rDPg/IC3cJiL8qnEfSyJwOViSV5p55AkmPYlrK2kmcu5wsu5bFnk2XxMr6jtiD/wymP2bv2TdjLlJ1fYm6WYlrQniGUvOgUmBrHLmGeG55RV+1Th+mQ+Zbkpa3SbasGF/ghDUifARBwFo2gsjJzpAywqtp7H8e/p5edg3ssr0Pp9Vj28doDFvBs9YM2Nft+23aENSs7/i+7TzAYB2/5XqaA+olhK05fqYy3/H9WThMveZKbGG66fcHVxr5jaivUW06QUvWpNCSznB3xDmEdXibvW9GwSjkzM78hMSmX8n7pvAWRfPbmt4fMumsL0d2fflA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tSovdzbRAPE3j+pzKCVHVRAQ4AtnQaD0dILMNynw5Zo=;
 b=L1X0tkyUhBNI0O+TgwGlL4DypjlqA30bgW10liVC6w4Teo+mz7QTAEA6TK1n8QWGQDp9EBh3aM1rSBQQpZTxplUYfcwA/rn45y5+Qt7IaOufkCP8xQ+zoYhwSmBX4//qNO8t12LxgKjGdnyOBnDc969qYDHkWDShnrn6cNpaTTM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 PH7PR12MB5656.namprd12.prod.outlook.com (2603:10b6:510:13b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Thu, 7 Sep
 2023 10:31:55 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::12ec:a62b:b286:d309]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::12ec:a62b:b286:d309%7]) with mapi id 15.20.6768.029; Thu, 7 Sep 2023
 10:31:55 +0000
Message-ID: <657e86cb-76b2-ab2b-5ce3-f53ec4341f08@amd.com>
Date:   Thu, 7 Sep 2023 17:31:35 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH RFC v9 47/51] iommu/amd: Add IOMMU_SNP_SHUTDOWN support
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-48-michael.roth@amd.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <20230612042559.375660-48-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0090.apcprd03.prod.outlook.com
 (2603:1096:4:7c::18) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|PH7PR12MB5656:EE_
X-MS-Office365-Filtering-Correlation-Id: 508a5eb1-dd64-4fb6-475b-08dbaf8da7e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hDPly98E4WIV0WGEJM9NIWFNObX+Aday+l8qUZ5nqHmBBi+rFi+l6FwFkl7lBz4CeeA7y44LhO/p/BXIfgNlKEGer0/s2MzTqwnNMVzmg1wWF2hiuVnMUembldszX2hepvtvpX04By+q40/wCq8q1wQeivBis3zGxB9lo0qbUxWuTqla1XdK3m7DaWsv7zQ0cChhbsHW9aSQQozQohrYll5PZYtL8HQKmWmVyhba/hS5lZqBb5UJzaJWjKok/f83sdONQC1w6KQLJIHI2+xVG6yPFIPzusAfWosF1S00CL6AeT5A3XoQCblg3C5x78s+V0VtxyzIUu7VyNZhkIM/8fqrlFi20leQnfDF8uYHy+3ggGGjob88seT11o/S7OWQtkObRYHWaEpmejXluzZW7ci5qrUDsAJjSryJUV7dnlIwM81MpePdWQgoJr1crgLjOgImoj0vRDWekCl+iAFzJVWQ77LFRvnw1aPSZEcU8G7EppssjMWICAUEZosW/UTTFvX4xTB6Ba6Cj7EasU1X4Bk7/R3lBBH6wNVkvKJE3zBWvx6eOvwDb/YTn7iEm1IIs52kx81p37DkhsQWvu2Bw/jJGSuj2kO1HA3PvayU7wVhwy1giM/CuZZbbrX9kKb7K1uE6gmQGsesWyR5o1VB+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(376002)(396003)(346002)(366004)(186009)(451199024)(1800799009)(38100700002)(53546011)(6666004)(6506007)(6486002)(26005)(6512007)(478600001)(2616005)(966005)(4744005)(2906002)(7406005)(7416002)(41300700001)(66476007)(8676002)(66946007)(5660300002)(66556008)(4326008)(316002)(8936002)(36756003)(86362001)(31696002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHczNjRmMSs3TjBUSTJhemdiYk1oWlV0cXIrSktaalBOM1pZaDN2QTBkL0Iw?=
 =?utf-8?B?YUI0RVRkelRwQlF6M3lQMmJ0ZE9iSFdWaFZBRXIzdkxLK1c4WVdFYWdpd0Z1?=
 =?utf-8?B?ZUdlVnRMa3AxaXlaajlNak9NbFNIYXdNa0V4eGNZYzlLdTNKSEdwY1hGUnhS?=
 =?utf-8?B?UzcwZ3R2MHJmUUtSUDZvWnVIME5vSFR3OWlXanpDMWkvamU0UmZJZHBqRGdN?=
 =?utf-8?B?ajEwZ2FhR2kycGdqdnBqQ0lPQlpCWHExaFMrL3NxZFVuNWs2bVpQVFo5NTF6?=
 =?utf-8?B?K0MrcncvY202c2wrUGdHNVVWRENrdmNrbFhxRUNKbzJ4THNWZXhVZ0JYWjlG?=
 =?utf-8?B?Zjh5bzFFVXRTT3BVMi85bmpiYVo5ZU5ZR3RFZXF0ZkY4VFZZYUxOVHlmMGVD?=
 =?utf-8?B?YndSTEVIaS9aVU1mQ0tLbFJmSGpSNG9JU24wMmRtWFAvT0tscG5kVHFMMlo2?=
 =?utf-8?B?MEZXb0RZeTBlWExzKytpVlA1emRrL1pPcjZ2aTFjdWd4UTVRRExlQktCd1VD?=
 =?utf-8?B?YUI5TTZmcEVKVDhudno0dk8zUnRMaEMwYXMxVTZZYlN5Wjd4WjVGTE1kelZa?=
 =?utf-8?B?b0hnM3UxZHA1bXJPUWMvdzB6aHhPRnRlN3FvdTdzWVMrYTVFQ2k4d2tvTVBT?=
 =?utf-8?B?a3BhcXhxaHo2ZXNVUlJkZVFMRExlenVUbVllcEIxZmhkNFo0UGI3bEJsTnpy?=
 =?utf-8?B?NCtEVTI1Ymk3TWZpYVhJMGFXUnFKZm1QU2RiR0JhTW10VUl0TXA0VXpTeFBF?=
 =?utf-8?B?QjNvTHUrNElzU0dCeThZSjV5L3Z6QzRKVmRUcWFJQmhZVnM4SDB4eXRwYXU3?=
 =?utf-8?B?SmNVRHVzcmdQR0h4R2tGd2t2RjdzeXFBak1DSlFhWjJ4QjZNRHJzMU0zaVJ6?=
 =?utf-8?B?RlJ0NkZOeFJzeitDS0EvZ09ob1JqdTZTR0wralpCWG5XTFpmN0p1VC90enRO?=
 =?utf-8?B?ZE41VHUvR0pFQzEyUDQyeVhvWit3SHY2KzRtK2l6U3JBMW95dUpPc2lZb0hk?=
 =?utf-8?B?QlZsTXBkT013RkZySVZmV0svaWVCVUJaTlZtS1c4d3NQT2FCT2NMci9BckVM?=
 =?utf-8?B?cmxGTzNHM2daekpDOWZTUFF3dGpQdXNodTgwQTVGT3BhWlpRU1NvRUhuNUFJ?=
 =?utf-8?B?elMyRGpjeDJGK2YvVXhQaDZKb3RDcTIzSFZ2SnFHZ2Z0dVdOU3c4TUU5OHZ1?=
 =?utf-8?B?dUkwZFA5Vzlrb2JnQkt5ODQ2eDdOd0ttZXMxenN1RDJuV0ZENVlwWkgwWHRM?=
 =?utf-8?B?UzMvcjZlY3NzNmN4LzNMRG93eFpKOUNsUHZMR2phZUJIOStOUms3Y29HdmJE?=
 =?utf-8?B?UmlhR2tZS3o4VFZIMTd1cFlNQnZoc00wdytEQ1VhMlhRVitTVUY3UVFtOVc5?=
 =?utf-8?B?S2dZL2tPNzJ6QldNejZMaUc5eHJnTk1oL3UyN1BVR2l4T1pNN3IremgvSm04?=
 =?utf-8?B?RFlaWTNYWmJYaUJPZGNSendza1JmMVV2ZDVESUp2QmRLTmlIaW9sb2x6emRI?=
 =?utf-8?B?aldrS3ZXa0YzaUo2Nm5OYlY4c09ybkdOby9qMTNIZjhacUV1TFZ1SUZNbFZu?=
 =?utf-8?B?THBmRW9wVExyQld4d1RSU1NaSVM3ZnBLZXBqUEU0NHpDcHJ2d1pZYkRKd2di?=
 =?utf-8?B?OFcrMjFqcDNaUkZFUzgrVEtpbnE4OTExb04rcUxlSVc0ZFlkaHRDSW41d1Zr?=
 =?utf-8?B?Y3dXbU5wMGx6UHBta0N0OXVzYVEwcEp6bStsOEhFM3ZWMy9jSVhZMXplVW1a?=
 =?utf-8?B?aWJxNjdCd1pYdFVzVGdROU95alFJaEg4d2laWUMvcElkTG1HYS9kOFdlK0wr?=
 =?utf-8?B?dTBDdFU4RFVId2VWTkdzL3ljbjMrRVIyWFpsV3R6aGxFa0thazV0aS9adkd5?=
 =?utf-8?B?WnR2MW03V1A1UEdmM3RPMHl1TGRLSHNNWXdMZUk3R3NYT0lNSzZXcDl6ZzBa?=
 =?utf-8?B?d0pYZWxGbXBLK3BMMGpDcE5zYUttMkc2NG1vRWV0RnpEQlJBMlJGWmpGMm1l?=
 =?utf-8?B?WlVESnNMazdXNjZmQmdWb3ozQ3JSMEdESnU3VGhjV0dMS0J6WHkwenN6Tm5T?=
 =?utf-8?B?ZjEyWnYyNjlRL0VabExLdXJ1dlhHeXFqTTNPMk05TkQwVWpoL2VFOUc3RWFJ?=
 =?utf-8?Q?YUD4Jjlb1dm5tlYSrCicdNTUP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 508a5eb1-dd64-4fb6-475b-08dbaf8da7e7
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2023 10:31:54.9018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xOuG9z9ULsZspiOYXAzpHc+AkcZfGsspVUns/TQ2mR63sXUYi5f/EXC7OcXF7hPc/ZS3yWa4yuPhq8IshMmZ+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5656
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Mike / Ashish

FYI, you might need to start including the change from this patch

https://lore.kernel.org/linux-iommu/ZPiAUx9Qysw0AKNq@ziepe.ca/T/

in this series since Christoph would like to remove the code from the 
current upstream, and re-introduce the change within this series instead.

Regards,
Suravee

On 6/12/2023 11:25 AM, Michael Roth wrote:
> From: Ashish Kalra<ashish.kalra@amd.com>
> 
> Add a new IOMMU API interface amd_iommu_snp_disable() to transition
> IOMMU pages to Hypervisor state from Reclaim state after SNP_SHUTDOWN_EX
> command. Invoke this API from the CCP driver after SNP_SHUTDOWN_EX
> command.
> 
> Signed-off-by: Ashish Kalra<ashish.kalra@amd.com>
> Signed-off-by: Michael Roth<michael.roth@amd.com>
