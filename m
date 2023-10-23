Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDFB17D3E4C
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 19:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjJWRuj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 13:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjJWRuh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 13:50:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1784B94;
        Mon, 23 Oct 2023 10:50:34 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39NHhoYm001785;
        Mon, 23 Oct 2023 17:50:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=g3oAIc3yzVCuEtTLJYzGg1NMAsUkFOpxpyfmLbVWcDQ=;
 b=3aip/6M8nLjfMikv5Tf4uMXfsaw6WpnZvtZCxL4mcbVEz+Xa6+TBMeTbU8xPAQ6dQB8M
 ATx8JkuWTyOGRoqyivnnXdqaVndYMkxYHCy+W3WnugvmnfAQ72aSS5vT1sFmbIcDe/Y0
 Iuu5lh4d6hhjKdAaNenCtzCu0Vp+lIsQtEHPWAV17drTMkmamG1Kjd8922vATeICxNCW
 gW6Kb7H9n7cIWsFnDeSzkMs0BYJ3DNut9G0fK0RY1FwUfo3yBeddhhofJBIarwQD6plT
 bRDNHbXgDBJ10z5kLcXGq1W02P/5RgDaGTVVUPVcwQcj7+FG7468nDCe6LPIQqe5CWBW 7A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv68tbqmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 17:50:13 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39NHNwAS015180;
        Mon, 23 Oct 2023 17:50:12 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tv5349tq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 17:50:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=npNroe68wWKULkv5reeSxV3rlEoMQ7oTSjEiLB35Npd3owpR0FgT1xlGgRH/18RaSlP+AUb/pjtziaSawscz1kDe9ltwJvmZXoy7QRj7jq7GvlijQZfD9VXOdy7jxaN5NtO48MtmMLXxets3XdQ+s7jeStypGSy1uKKv+jmVRVS/vIB3HWDmYk7zD1YJTInTMyxuf7JGtThW+jZ6VcSso/nUzeiP07mnYF4SZWcDEUnrdI5oXd/UWS2XZmULC9KlhVSv8g5EbA0DfgurOAVu4av3ykv3qLZwtgLAGdFYtg1WfkpvHLDVpKhdt1ZpyHHcTxFk8clNtA99H33MZ+plAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g3oAIc3yzVCuEtTLJYzGg1NMAsUkFOpxpyfmLbVWcDQ=;
 b=kglHNonC5/8cXTvdK1oG6Sq4mfncszRzEec4YQre3CWgDGytqE/o2jDJ7wTwHE3n63B/1+TCwraLjMslquj/gmtNx1KCozkmbyGU7I6jhmWJH2nGDVjF/fvSDqJFy+xKsF5AX2aWrtmivG9v6rapVzbdVitjlHk0rQJh7Ohzs2NmFDWyeo/U3re7OFb7n6QGhaGlThxlvgPDT5ReW7s/JbElR46e8TodpgNxhUTTBgRPUu+2WF+Ttw0n0svqABrMJIDvpNHUSFVA4afFOqax48tYzc+mroUsf+ggHq0ll50FXI7/09OtZ9LhYT8EDsJCsaz+/GIIYATP24jCnZRIIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g3oAIc3yzVCuEtTLJYzGg1NMAsUkFOpxpyfmLbVWcDQ=;
 b=LRm/DPnvhUHP9dK8Ms3FbCakfHAwGbJKrQaz7yBeDHXslxywDJhs2UALyAQwBUkjtgn8k/P99G4+Lm1XLSORT5k9bFIfXA9qKN4SY+ZLsC6nkiw/qbJxeumVvZC+CPrV3vXNFY/vkFqVXrpRLPWPK6dWbbZ/RwEnn7yMSY7GaOA=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN0PR10MB4951.namprd10.prod.outlook.com (2603:10b6:408:117::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Mon, 23 Oct
 2023 17:50:10 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac%3]) with mapi id 15.20.6907.032; Mon, 23 Oct 2023
 17:50:10 +0000
Message-ID: <3b731349-38e4-43bd-9482-6fe43871b679@oracle.com>
Date:   Mon, 23 Oct 2023 18:50:05 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio: mlx5, pds: add IOMMU_SUPPORT dependency
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Arnd Bergmann <arnd@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Brett Creeley <brett.creeley@amd.com>,
        Shixiong Ou <oushixiong@kylinos.cn>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20231023115520.3530120-1-arnd@kernel.org>
 <20231023120418.GH691768@ziepe.ca>
 <a16758d6-964d-4e46-9074-4d155f9b3703@oracle.com>
 <20231023131229.GR3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231023131229.GR3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0183.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::20) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|BN0PR10MB4951:EE_
X-MS-Office365-Filtering-Correlation-Id: df16786c-1900-491c-3cb0-08dbd3f0806a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VOEfA5YqclGDaNqljLjhZY5K4tMLsTRC2KaaM5QbexTDq/8uUUte5vQ1+0rc/ArmjiGWzQnT+7YX5kQDi2GkqM2BP+Z494l7qkZ/1nrCd+/Sfow3vKa5LZ0X5+2GmPDbrDFpglGsUt71/XF/qUiM7tR+6gz3v0IIMV5Lc4og6Puxo3xL56v/Wj301krPsoyEgUoW/8mtJciNgNSZJfzNBXIGVk7UXp6tdPXLIzdb2V9jS4RWVeLW6UWps9yaC5A72qfKAHrqImvU13A3hSHa/mtQ4rD6QXDdcPUeMWckFL28PLqw+XvE99O2eQ1GBRgzULSk9+fGKnFbsSLuSP2+ucpshp+90y2KIgeLHdKVXCVZtqjP/ve8/LzZiWQsOy39dMqU8u7XhcscZpU0JbLW6pN92JYjgsqDhDq7timtym7UjEH97mchPQE9TA/Myqh+Ow4TKCiyHNUNVwvvGzuI/c91SFBsMV3rgXs5zwC+3gvZ1NhVV3+DVYwmT21SPd0cpbOBasDASshC/CmfzGSnZSAITXAflK341NxN8uX7Q80SDH2dsWX48tyhuKTgIiFVkfANlxOSW8X/lmyXj/YI8m8MPs4Zd9YzpaYaxKK7jpEtj5kqenAjVSIUv9AuglH+VeyXVqtc0JUzZT/+vQ+XIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(376002)(136003)(39860400002)(230922051799003)(186009)(451199024)(64100799003)(1800799009)(86362001)(6486002)(66946007)(66556008)(6916009)(66476007)(316002)(54906003)(478600001)(36756003)(31696002)(41300700001)(7416002)(8676002)(4326008)(5660300002)(6666004)(53546011)(38100700002)(2906002)(6506007)(2616005)(6512007)(8936002)(26005)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YUxZWU8vM0Z5a2hZNkNYY3g1UVFjbXEwRzBSeUhTYnBmckpHTXdSelY0ZkdH?=
 =?utf-8?B?QklBUFNRMW14K2owd2w3RzhiTXU5NUtxdUdvSlAycW93Q0k3NUFuWHpqT2VR?=
 =?utf-8?B?VFdUNWNlL3lLT292QnR1LzZueUwvS2ZRRUpvU1dCdTh0YW5pOUFldnlydk5P?=
 =?utf-8?B?V1M5Q0kycE8zV0JvU2twT3ErWk1BRm41czJrZm5WR29URVE1NmxqZWQvVTg1?=
 =?utf-8?B?R0kyUXhSVUpESzB1MmJ2UGhWdmd4ZThDVVY1VCtJWE9JU2NjeXZNL3g5bWdx?=
 =?utf-8?B?elpENkduTDRZbkJ3RWF3N3JUWUxtYW1lamZ2UE1KRHI2Y2ZqWjVzbS9DbFM4?=
 =?utf-8?B?ZHlxV2FvTExDRWdNbHY0dE43eitZOVRVd3FuUFVDVFg2eDJWZHdNTmpTNCsw?=
 =?utf-8?B?L0x0MGU5S2pCYnVTWjNFcVBEUzgvbDhyN1VvTG1ocDRGWUxZay83cjI4bFBB?=
 =?utf-8?B?TEU1WFprV3c5NDRjQm5EV3JwbmxjNVlXSG95bzUyQkYrSEpjYVRLSFNVTUZx?=
 =?utf-8?B?bU03cmNUWXl3ZHFvN2RNQkovQTY5UjhmVThPRkpoby9seGlmU3dVZ0dwR1I4?=
 =?utf-8?B?M1IwYnB6ajgyUGltYWthQVRld2xHcWc3QnluV0RzYlZObnNxVDlBa29EZEZD?=
 =?utf-8?B?dkNvaG1ka3ltSDJwS0JMb3lkNWMxMmFhL0hnZHkzSzUwL29ZVnFNeDBuNVJF?=
 =?utf-8?B?dU1qMmhWZytzUVZvVG94MGd4cDNGRlFxSkVjY0RManUyRmlPM3cvL0RsSHEv?=
 =?utf-8?B?U2R6emw1OHVJTGluK1Q0UllnVnJyRUwwOVZNRkthQjdSOW1lRmNxOUl6SnJw?=
 =?utf-8?B?N2ZQemx1MU9nZ0hwUDRlUmdaQStSOVM5VlRuWjk4WHJQSEFqZ1lKSGpKTW83?=
 =?utf-8?B?RXRlQjVZZS9lNEZBbXk1Zy9YaUJqei9nR2VjTkZuakJXMFNkQjI2dkVwT3VI?=
 =?utf-8?B?WnpBRSttblErR0JpSi9PVTNhU0Mwdkg1VnVEMDV2K0dHMnc4REdlOGxPZUh6?=
 =?utf-8?B?S2dCSFFUVmRPOGtTMmVmQkNoeEdGRklSWmlZTE1TYmNzbFF4OUNOczh4RWh3?=
 =?utf-8?B?d3h5akJrN0I2ODBvVUtWUXhDZ01ReXdRU3U0S3NiS3lLRFM5cndKSFlMT1R5?=
 =?utf-8?B?NmNXenZZdElFRTA3VkdJa1p0cmt1alhCR1l2djN4S0IyZDdaN05xWXZ3Y1Yy?=
 =?utf-8?B?WGJtOVpUei9MVnBtb05taHVhVEdGdkx1REViS004WGwvYWF2ZHd1Y2pUV1hG?=
 =?utf-8?B?SlBLRlBzRUozdWNkUEFhd0JRcFM5V2tGc3ZRSGZLSzBpamVLMmU5QjBycWVx?=
 =?utf-8?B?OUxTbVlkcTNYcW1ocmhTKzI3cG8wVndFTzBESkZIeDh5bDhhWmJXK3d5SlVl?=
 =?utf-8?B?LzZFWklIVGhxUEsvL2E4Zyt3Y1N4d3FUVkdtMXlTRGM4Szg1c3RDa2tFU3kx?=
 =?utf-8?B?dkVJTnZjSjF3bXRWMmhycEdWR3FmSnowWXlveitPbm9TdklrSWowNXJIbUVm?=
 =?utf-8?B?Y0Ura002MGVCNWRhcmdJVm5YYTNDZXcxUzdTQjB3VFYzTkF0aGlZbjlObUlv?=
 =?utf-8?B?YXloMG9DM2MzMnFydi9uR0FpYlNqU3R3bndpNkg4OU5ySVhncExJTFdZb0Z6?=
 =?utf-8?B?OFNwaHZOWGIyakhJOEV0WTJuaXVNcFZUVjlGYUZkS3grQlhFRDVLT2k1S3Iv?=
 =?utf-8?B?OHZiUkVCaDFEN1paS3RSR203a0xRSEhPcGdqNjJxM0tHbk84TXZrRWZaR3FF?=
 =?utf-8?B?Mk5ndzI1Y0ZWT1NLaFFiTGN3dmNLdEE3ZFpnUFllK2RldjVuVkJobDVWazRs?=
 =?utf-8?B?SlBkMVVGQWJLTXdpZklXNEZzd3AxUEJ1RmNZenlxNHBYaSt4TEhtVk9rcDZ2?=
 =?utf-8?B?MUtKVzUrMndJRUd1bkZmYjVlODF2YUgxU0pLdU5WaWdiK2RKdkl2ay9mQyt2?=
 =?utf-8?B?WjJVQ2VDQ3h3Rzk5dkRTMWtoMFZaekRwN2ZxTGpueUxBdGljUVhldDdnZ1Vy?=
 =?utf-8?B?SjdPTzBjS05EZXVzN25obFZSdE5DcUhHZ1Y5eDJlaHRYcUlwNUJ3WVg4U2hC?=
 =?utf-8?B?emUrbDNZN1VNZHZQNlN4UnJ0Wjk2MjJSVWgvYmFEalNCa2tKTHdHWjN5R29N?=
 =?utf-8?B?ejVqWFNCRndoWU0xUkpDaW5YbnUrd2VHcTNISUN3RzBVMWRxOHdkSENlb3Bl?=
 =?utf-8?B?L3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?NG43M0M4a1NvbmZxbGFyNG44cHhOUExpNjhtZEpvWGszL1FHMWhPNFNKTkxy?=
 =?utf-8?B?TXpXMzVUN0J2dnRuWm1tUG1saTM3OXdTeVgwaSs2YktzV21tcGpaM1gxejlY?=
 =?utf-8?B?VEJ3emYwelI1a3pWWWl0ZFJGYW1VeFVkTTFGNjNia0JhdkUwOVY2ZVJEQTZh?=
 =?utf-8?B?bUdrd1lBMXRtT1RKNzdrNlROTTZmbnA1OVE4N1o1WnF0aTVJVmYyc0t1K2Qr?=
 =?utf-8?B?WHJEcDYzeU96L0lyS2NpZ3ZvUG5RWDBOYUNCdWhNZ3ZwVGVJLzM3aExMTXNS?=
 =?utf-8?B?aUJrUE1MUDhsZkhLL3dwVkNyak5IVDlWR1h0NXRJeUJRci84VHFyeFp1M25t?=
 =?utf-8?B?L1ZXTVhIZkorbUdRaHpPUVc1UXNsQitZZDZoRmxqTlZReUduWnRyb0krOEs3?=
 =?utf-8?B?L0JqU2hYaUd0SlMzRlJBdVRSMlUyWWxrOFl3ZHBaWkJBTHlHTWM2bzhiTjl1?=
 =?utf-8?B?ZkdKMWhwT0pPdlExc0hHUmF2RXoyRXVNNmF2WHFOVjMxbDA2Ym5CWjAwR2M0?=
 =?utf-8?B?ZEpiUVp0VnVlUFVqa2w4d1d5UG03UHpaLzFQRnlJcVpOTHFEYkR2bjlrZ2VK?=
 =?utf-8?B?amhoTW9QTHl5eUkxeFdaeGxaNlpSMVdpYXBVTzBDZHV5U0ZydnAwNXo1Z0Er?=
 =?utf-8?B?Q2RGU003Y29qUUhOWDFDV0dKVzR0bkV5ZnRaZ3ZBVE5HZGdyblhqQ1NIN0dW?=
 =?utf-8?B?UC95dkRsNUFhdEprWnd4UXg4dHh0SkpSRHhuczFiOERoV1Exd1VNVWdMYUlz?=
 =?utf-8?B?RlRwRC9uMFhlVWdqZHlTRnRQaWpiOFFqVUJwZEEreWV4Z2dUbkFwbmx6KzJm?=
 =?utf-8?B?QW5KQkdvdzI0aUxmY3AwbldZU0QyeXgzYUhFbkQ2QlplWUlYR2FLajIyZ01k?=
 =?utf-8?B?NHlrUlJDdUJDU1MxN3BNcG1yZll1TER0VUpmaHFIcGhNT3FlVnRLQTZUbzZo?=
 =?utf-8?B?THlaWEJmQzhlY3NkT29DaC9mSHRaWTBuRmRYQ3Vob0o2THEvUjNlUkJIRFJ2?=
 =?utf-8?B?Ty9taDdPSVNpNjN6ZkhkcXgyTW1vOXlnNWFGRnZXWTlrYTdBcDFJY3FRbE5H?=
 =?utf-8?B?ZlNVN3Z6bXZGVW9rS1pFcG1XU1d2dFdZL1JoQ0hmUzduTzA4dWhvdURsOFJE?=
 =?utf-8?B?cDhFVC96QW0vNGVSUWpmeDJoVS8vSnZNcDRBcThKSDFNVlF0UlhJN3I0a0VK?=
 =?utf-8?B?SG1zL1plOE9tMU1sTE4zWVRnaExuYUhYM3JlWnZsTkpzSmFocW01SXdpY1VX?=
 =?utf-8?B?ZGJvOVpyZXRrYUdhN3IzRm5Ob3BTSk1nc2JzTFBraFM2RGZxa2ZYekJibmcy?=
 =?utf-8?Q?YrE5pWeB3CI/A=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df16786c-1900-491c-3cb0-08dbd3f0806a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 17:50:10.5434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vNmL8kMXnoTtkQTsvnbL81vwY3fALkUGLVSlWZTDtNfo28wIi9y6bsgEB2Q7cpC8Qv3Fvi4cn5PUIMbjCwpRrWHpCYnujVFZB11FMYvK0a8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4951
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-23_16,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 spamscore=0 malwarescore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310230155
X-Proofpoint-ORIG-GUID: EldKiBHg1Lt36E9BS05VeiZG8nF9uMhj
X-Proofpoint-GUID: EldKiBHg1Lt36E9BS05VeiZG8nF9uMhj
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/10/2023 14:12, Jason Gunthorpe wrote:
> On Mon, Oct 23, 2023 at 01:37:28PM +0100, Joao Martins wrote:
> 
>> iommufd Kconfig is only included in the IOMMU_SUPPORT kconfig if clause; so
>> moving it out from the iommufd kconfig out into iommu kconfig should fix it.
>> Didn't realize that one can select IOMMU_API yet have IOMMU_SUPPORT unset/unmet.
>> I'll make the move in v6
> 
> I think this is some cruft that accumulated over the years, it doesn't
> make alot of sense that there are two kconfigs now..

To be specific what I meant to move is the IOMMUFD_DRIVER kconfig part, not the
whole iommufd Kconfig [in the patch introducing the problem] e.g.

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 2b12b583ef4b..5cc869db1b79 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -7,6 +7,10 @@ config IOMMU_IOVA
 config IOMMU_API
        bool

+config IOMMUFD_DRIVER
+       bool
+       default n
+
 menuconfig IOMMU_SUPPORT
        bool "IOMMU Hardware Support"
        depends on MMU
diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
index 1fa543204e89..99d4b075df49 100644
--- a/drivers/iommu/iommufd/Kconfig
+++ b/drivers/iommu/iommufd/Kconfig
@@ -11,10 +11,6 @@ config IOMMUFD

          If you don't know what to do here, say N.

-config IOMMUFD_DRIVER
-       bool
-       default n
-
 if IOMMUFD
 config IOMMUFD_VFIO_CONTAINER
        bool "IOMMUFD provides the VFIO container /dev/vfio/vfio"

(...) or in alternative, do similar to this patch except that it's:

	select IOMMUFD_DRIVER if IOMMU_SUPPORT

In the mlx5/pds vfio drivers.

Perhaps the merging of IOMMU_API with IOMMU_SUPPORT should be best done separately?

	Joao
