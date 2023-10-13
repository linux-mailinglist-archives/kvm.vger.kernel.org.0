Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E017C8CE8
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 20:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbjJMSNI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 14:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbjJMSMw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 14:12:52 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D0FD6
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 11:12:50 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39DI4Nx3020299;
        Fri, 13 Oct 2023 18:11:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=POaXJukI2JWafQHhJl+gKy3Pr8Gls008N53I1ovphWk=;
 b=sW5WlChnVrt72YJIoV9A7DVDr+rrKDIhLlrp6iEJ2AYvclcJPjLkOlP1T4LHNYxNEjHU
 2+bg9CbhcuEECm14paaxSMcl/ghIRRnxyGK/vO5En4f2CdNr0BDF3c35tkyW4XFkv1jx
 HB6O61cCPLLzUKX9mMV1eNEvkIzlwoI0FZ4dYZvKpZgTD28RKsVQnT84eSiuxY58nKdV
 79rC0o/aq6Qa2YGyZYfl487LSssFFQStc4DPkeppyGntW5cH2DDq+RQvjsoO8tAUCP5R
 JZMaVdZy5PHp9qDr0Tuvojp3M9qTjRwjGncLTbuGwn8lG9+3FesLyqXBp61kIFYBG4HW zA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tjycdwprf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 18:11:49 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39DH8hWr020200;
        Fri, 13 Oct 2023 18:11:48 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tptcjxr5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 18:11:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZjEVjShGwr4kMDzqZKakQUlZMBNb1cjC8X+M+cOUR+eKrOKh1KjTtTClFAEWIuUxQttOCkJYcqbEDM8bIJOmIgVtDZj/3FnrLMxASxK8xnNuVgb0hOMSaxXy+VNBjwurd76rugXZpWGzY5giUSvgLL/0+UfZJlDN0EwefmVWhlYcbpdVyHAhW+8Cf9xuGEevjDrt0HlMMku2IBVKn8U7PSITZ1ROJVPPcP5PwTy6hjK6dBplguQb4XR6cYPblVyED8WPa9UG1Z6/TZWOGbo8HQCDB8MKr3mvwvN1dZgMHNtMvdN+/nXLqVE/YYIJrDRP+7Wef5KAqRv+KPVhljPuLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=POaXJukI2JWafQHhJl+gKy3Pr8Gls008N53I1ovphWk=;
 b=KKSdqTEvUomeX5O12ZeMEBaprLwOyqnM1z7gTsxnVzhb6OUarYRZCFqC77AA+5pnvn06CU3USg1YYMvgqHPulJUoNXcHxLL0i3iFn9jSwUWWRtggAK9cUVqkraiLWY6O9UEvs+zYovp1fbea5z9ogalCiJvpb2j3prvrwN+WQzQapc0+KIlhkkp59iiKlrGi23tl97kC6nv57XYR4H55fsv6HAYwrk9J0GpPcnA5X/1Ncmf0C+wrKaHC8AhwTNrtZeyM89gn81ECcqfAnd0AXxG2lJ0mF2RArAy0liDNSTTjzaE1korrG/pYc7O5l+XQol2eQFxodlMWa/chG6s4wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=POaXJukI2JWafQHhJl+gKy3Pr8Gls008N53I1ovphWk=;
 b=wGbJEubyFcTlAMM+QJ1UgdrpICUKf87wwqn4rgNrmpsqY16UWtlE/10s8OfvvauOi8fZWs9Cu64j0nxOdBy5CmM9x0h84hCqFnJ1zL6h35BCYNTFKVrSZu7qSFCfyVCuTE/6pdd/XbiIWTZ7D8BjkrM1f97ewoxfVSEcuvW3cIQ=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by LV8PR10MB7989.namprd10.prod.outlook.com (2603:10b6:408:203::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Fri, 13 Oct
 2023 18:11:46 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6863.047; Fri, 13 Oct 2023
 18:11:46 +0000
Message-ID: <9df305a4-1176-4187-9dae-37dc954289f1@oracle.com>
Date:   Fri, 13 Oct 2023 19:11:41 +0100
User-Agent: Mozilla Thunderbird
From:   Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH v3 00/19] IOMMUFD Dirty Tracking
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vasant Hegde <vasant.hegde@amd.com>
Cc:     iommu@lists.linux.dev,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20231013162949.GG3952@nvidia.com>
Content-Language: en-US
In-Reply-To: <20231013162949.GG3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0127.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::32) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|LV8PR10MB7989:EE_
X-MS-Office365-Filtering-Correlation-Id: f0bcc92d-728a-4e9c-a58c-08dbcc17dca8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o5X/LiTthv06Xn0oFgDl5W9jHDrAcPrM9eKrIpLjCBU8wIBziSkp/e6xIOboCzvm4gw2XO3G7udWX1oOpekvMsjkj6uvTstXXn7NATFZQ0SvZu7Cvkm9oEB70x1Qe47grH2pfujYkiXvezfLfRLqI6+o7cOaB+qFSx/joTymoyCC8wR+px2lpXvlJOEATFAqBgFZUMKTkPiiQ7SBF0V5Y8prchtzUgkFGyFn5sbfzr5k0OiS1swXexCCnKNyCkVQI2JMZ14jH5CvQAZ1WuJbBiSh/f2+d9HApd1Rr965aUXnpj5KLSYQnrUMNQ6ZHBILpMn9iwGMm2aTuYD7w0trVzwa561Hm/BU6ywPwHtdLS8sMZ3AwBnjEJmv6uHJhUvd1yotScg2UwxDQCtC1L9tBNW2Pzfz9KWGxYXDpUzuOK6GBSDq+w+3kiB2/mjlgKiErhzkDA98kjHUQdqE1nIysRwqf0MFvXGYjdX9SSQ1JVqWG+QKJ8++I+8mB81iSeQyK0WkqMvG/NvRINe5V3WnIsxfiaGCj4oMzN16tDdWCvxca3nr0TUK8Y6poX43OQJ/vhATsZzzAsgg4T6LBnKKKo83zZJnx5Q8weNGbDMVi8SoO7XndtUJ16PNb01NdZVH7sEyDss9ZRJ+Js/EzJ/i9DsFRqejmrfyweocr39FOr4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(346002)(39860400002)(366004)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(26005)(6506007)(36756003)(66556008)(66946007)(316002)(66476007)(83380400001)(54906003)(110136005)(2616005)(6512007)(53546011)(38100700002)(86362001)(31686004)(6486002)(31696002)(478600001)(2906002)(6666004)(7416002)(5660300002)(8676002)(4326008)(8936002)(41300700001)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWRMNXBick1qbFE4U00rNVoxOUMzY0NlYTJDOTBxQ3h5VWgzcExEeTJjOVMv?=
 =?utf-8?B?aHBhUThMNmZCZTBzcVV4Ry9TMzRTLzZTN1Z0WlRTYVpmeHZhZ3J6UmhIUm9N?=
 =?utf-8?B?aGN0SkR4Z2drVkdTOWlMdnI3UlZacTNPZms4d01adzloZ21KYVlwLzZKdlZs?=
 =?utf-8?B?UHZBWkRqWkdJYm5Ld1M1b2NwMDVSWmdoVUM1SFlwVzc5bjdwaUFxM1A0amtO?=
 =?utf-8?B?VzJCUmVUaXY0bGpTSVFDSERDQmdSdFdXeFBGY2NiTHhtaUtjeFFCa0ZzcEow?=
 =?utf-8?B?b0xqMUI5VFhIN09ROUpZVnNRenVmb2FUNXRybUpyV1pyVzJYR3NqSXIxVWlF?=
 =?utf-8?B?TC9xUGd1dUVaNk5BSzlsVlZ6dUFWYjQwelNWcWNjWUwxSXQyTXM5Z0NxQXdP?=
 =?utf-8?B?NU1qK1RBNmNoRUgvbUVkNFJSTUs0OGE5MmtnVzFJSnlyeFhxSnBMMzhndWYx?=
 =?utf-8?B?cUk1Q0ZXRlJlUzZ6K29yR0VUMzZKclpTTXRKc0dMYVlqdmJ3UG5nbTV4aHNx?=
 =?utf-8?B?MVBYNmNjMWhIbnF3cWFKYVgzYngrQm5raHlYMHpzdVltZXZnNmlJdGc5aGZz?=
 =?utf-8?B?azdTWlphUlBLalUydWF4R2Zsek9ZTTRzSG8vRXEvQk5OSWJRUWk1TzZqZGVn?=
 =?utf-8?B?N0Vkc3orb3NQb0NyWHU2cmNzZm9oc0JDVHdIS212bXVxQng3cTg3TXZmQTZv?=
 =?utf-8?B?ZWdpSVljZkJlT3RIcXI2Q2FvMWlnZ0VUQW13Zlo4VjFSRytZK3ByOVpHRVR2?=
 =?utf-8?B?MVBkSHl1NGRIQ2ZxcXNLRzlQNEJlbThnNk5QcW1HektqMGZmRmlOVjM1QVhm?=
 =?utf-8?B?Tnd5czQrS3NoSlZFOTNoWmtqL1FIR1MxR3NBcWtHTnNjYmcwbWw2MlVXdUYz?=
 =?utf-8?B?OXlPM2NGRi9icTBMRFByS2w3UldTZ0ZoZERTbmc4MHNhL29pTlFVVlVwdHlY?=
 =?utf-8?B?eFBQNTBPU1F3cm92QWtMekF2dG9jenFpSjRVc0ZZV0lBL2lTSWtybnkrVTNn?=
 =?utf-8?B?amRUWVArcklIcmxNWnVGeU10QkpuUEsveU1VTmJEU21tcE01d0VHaUMxeWdX?=
 =?utf-8?B?aHlJNyttODJGSTZHdktKbmtDYjlRNzhYUysxM2Z3bjR4TWx4d1d5bkZqakFw?=
 =?utf-8?B?MDRnZGxHYTQzSEVCaEZSZDlTdTJocThqOHZ1bTJwdlpZU0JmKzVjaWxTVnhM?=
 =?utf-8?B?bitaa1QxWDRHd3RhUlFEWXRQWXJhWFJGVlJPWFhlNGFwNmh3cTkzZVFWcHh2?=
 =?utf-8?B?MVhPNWZYUnJLdW9FQ2NTWkdyL3pMVnQ3OVcya0t0cFRiZFpURWwyWWwxZFNk?=
 =?utf-8?B?Q3pHTDBUU2c2NlRlOUFZS2gyTXJ2OEtCRHRFZW1WdHBMbXVEYXVoMEdNZmtH?=
 =?utf-8?B?NW5taUtXU1pkTytLNm5UbDdvdUZlTmNsYU1aTTdQeEFzRzVsNnpZb0dJRnQx?=
 =?utf-8?B?ZHRYQ1NwN0JPeHZEUnRHWnZ5V1NIZWZSNTM2QndjQW5nc1BRV3NuN2E0VWxQ?=
 =?utf-8?B?Y3E0Uzl2bW1RUkMzUGExTVB1SmhtOGk4cko1ejJ5TTlMRnpSdFVkMnFsV0RM?=
 =?utf-8?B?M0JiU1ZXYlJhdG5HVnJDRUVhQmdyN0syVElnQzFrb3c5WklRMzAxbG5HbVI3?=
 =?utf-8?B?b2FZMWk1UkRjTVVaS0xFQk52Q3dSWGJCalBJZFl4SVpzejFyV00vd3JOR0U4?=
 =?utf-8?B?dlhWQjhTTStJNVJoSGN1dUZ2WWZvQXdVbjFSdFpGMWdNNlhaVnRpRjBSL0Zj?=
 =?utf-8?B?RW1YdmlTUnpnQnhHWk03UEdCUWlFcE1MRWNuT1RzRHJWb0YyUFZuTFJpUGc4?=
 =?utf-8?B?K0EwcXdTN0s1TXlEZE9XdTFDK3ZjeG9NL2VwVHlBZGhnZ1ZDby9kYjkrR2FV?=
 =?utf-8?B?a2x4MU9UNzJIWVoxT0RZVVBJaGhDcWdHYnVXWFNheVNPNGZIZk1qREZFcENo?=
 =?utf-8?B?UEphRXFqU3Z0SGpPWVB1OXFHZG1SRWh4elBTR2xrZlU4WEF5R0hBL1lkOG9k?=
 =?utf-8?B?dlVBcmswV2diS1VRcE5UWW55ZEZ0blRGdkQ5OFFMN2R4ZGwwSzQwWkhyWmhs?=
 =?utf-8?B?dE9mVXhiM2IwZkQvaHFwc3kwMEhPK2FXYVc2MFJTTEhZdVZpUWhZMUhsN1RI?=
 =?utf-8?B?WVBXYklVWkUxb2tjUWljUk5jbWJkd3d2dFIvbGp1Wllta1hTd1l2Y20rWlo2?=
 =?utf-8?B?bkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?MnJVei96ZnJMN25WczhHQjV5eGh1QVVaZGFNMWFwZzMyU0w3bGFaMnR3cGVy?=
 =?utf-8?B?MnBaQ1YvZHdnOXFiMzZEbEI1OS9FMjQ4cmJVdUp1OGtvcVh4RkFnZEF0R3ly?=
 =?utf-8?B?Q1NGdmVNWW5CK1ZGN0xNeHBUcExMaGlRQ2dpRkd4UHZXK1NwOUhZSDIrUURT?=
 =?utf-8?B?OXlLT0VmTE1qSWZWTGpvY2FtbEhGOFlUQWhhUWtRRmJGZ2xacWFvNXNjWFhx?=
 =?utf-8?B?UXFRcHNWektrV2l3UHk1cUZUOVBMR3lyUDZQbUJxSVozOXkrQzBLMEplaFJa?=
 =?utf-8?B?a2lTbWJhUVlTM090anl6Z0hET3d1NUdTLzYrWkE5azRiMVB1bWQ5cUJ5ejVj?=
 =?utf-8?B?bTV5UC9pYVcxSksveGRCRjNsR2pNcHkwZWZ2SHR6dVA1RVBFbkM5WEFOVFNn?=
 =?utf-8?B?cGlEVjlFTWc1MWxXYUdKSmNvQ3B3cHloZTJibFFCYk5OSEhOU1VLZU1SeUJ0?=
 =?utf-8?B?Qlh5R09Bb1VkNy8wWlBvM1ZCeWNGY05iZ09aejRtekVyMkptM3VmSm1jcFFK?=
 =?utf-8?B?c0VLMkJwZHhhckpOWjdxMnlqakVXOXdpY0dVTEhXU2xob2poRlg3ZW5PdWZj?=
 =?utf-8?B?M0VWQmRUeSs5NFovdzhXQjRFSm44VjNNTWFLdGp3OFErdXp2U0VlejBNQTBC?=
 =?utf-8?B?YzdCNk4xKzdkMEQ3WTJFaWRwS0VDb1lZK0JUZ1NNcVpTNkFZY3FYOHljTkJL?=
 =?utf-8?B?SUVncVA1WTRMUmJHVlFSQWd0YnFzVHFGdDlZUlRPdUtKQkZWN3NBWWVMeUh0?=
 =?utf-8?B?WEhHUmhteEdzbkhNbUp0a1pKQ3QxUnZ3OFpBeTRZRHJmUzlRUGVBUExhNzQ0?=
 =?utf-8?B?anBXS1R4TytSRG1teEpPbnRrNTUyZ0xlRFJpK3piZ1duL0xCSC9DMTV3MXhO?=
 =?utf-8?B?Zzd5QmpkdXJqZlRCNU5MdkdFRllwZVdnMEZDcDVwdWEvRHdBVHc1am5XUFhq?=
 =?utf-8?B?SFlwQ1VGWlZMRmdXR1RvZHV0U3dPcXlTMTlrNkgrTkVIQ3dVTWovTW1tbGxP?=
 =?utf-8?B?WTRNNUlmb1BPYVFJVzdNOUZYNzViVGFVa05sMXljdkwvelBOajNPQzdoVzBh?=
 =?utf-8?B?Z1FsUnlKam9nanhyY2lQSWxZbVFzcEpLTG5Qc2V3QXkwN3V1cHMyN2dwTkwy?=
 =?utf-8?B?TnprZ0E2NFZESE13UkpKRGtuc2NHQ09RYVVqR0NRaGZyK21Dby9QVWNVYmI2?=
 =?utf-8?B?VHJHS1pBeWRicXVJRWJvbk1KN0ZhRnVwU3VRZWhwcFBJdlRhQnNLUnBSbnAx?=
 =?utf-8?B?WXdYMjZ6ajJWbTlFTFBUc28vWjdNK213T25VM3BXSmM2TU9ySnNyb1BrL3gr?=
 =?utf-8?B?WVRqVFY2SnNtdkZXNnozbzVuYWJ0TkFhbWJLK1dxR2xqQ0s0U2ROak5xd1lj?=
 =?utf-8?B?Tm9rREFEV1BXNXZGc3pXWDNKLzE4OUQ2dG5Yb1NzSDZYOVlQazlKbDA0NitH?=
 =?utf-8?Q?IBwrV+Yh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0bcc92d-728a-4e9c-a58c-08dbcc17dca8
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 18:11:46.3295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2YliijAh0bldub/wUNXpmItElOguxMemn/LfA5Ur3OyWu1ILHwIKeOFe51KiqRtccjhgIqJv6wId7TT7wZqCE6drc10pFm6Srg6Pg0GsYxw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7989
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-13_09,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310130156
X-Proofpoint-ORIG-GUID: EHvbr30LLikGnmdhHrwTveA19smC2GPt
X-Proofpoint-GUID: EHvbr30LLikGnmdhHrwTveA19smC2GPt
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/2023 17:29, Jason Gunthorpe wrote:
> On Sat, Sep 23, 2023 at 02:24:52AM +0100, Joao Martins wrote:
> 
>> Joao Martins (19):
>>   vfio/iova_bitmap: Export more API symbols
>>   vfio: Move iova_bitmap into iommu core
>>   iommu: Add iommu_domain ops for dirty tracking
>>   iommufd: Add a flag to enforce dirty tracking on attach
>>   iommufd/selftest: Expand mock_domain with dev_flags
>>   iommufd/selftest: Test IOMMU_HWPT_ALLOC_ENFORCE_DIRTY
>>   iommufd: Dirty tracking data support
>>   iommufd: Add IOMMU_HWPT_SET_DIRTY
>>   iommufd/selftest: Test IOMMU_HWPT_SET_DIRTY
>>   iommufd: Add IOMMU_HWPT_GET_DIRTY_IOVA
>>   iommufd/selftest: Test IOMMU_HWPT_GET_DIRTY_IOVA
>>   iommufd: Add capabilities to IOMMU_GET_HW_INFO
>>   iommufd/selftest: Test out_capabilities in IOMMU_GET_HW_INFO
>>   iommufd: Add a flag to skip clearing of IOPTE dirty
>>   iommufd/selftest: Test IOMMU_GET_DIRTY_IOVA_NO_CLEAR flag
>>   iommu/amd: Add domain_alloc_user based domain allocation
>>   iommu/amd: Access/Dirty bit support in IOPTEs
>>   iommu/amd: Print access/dirty bits if supported
>>   iommu/intel: Access/Dirty bit support for SL domains
> 
> I read through this and I'm happy with the design - small points aside
> 
Great!

> Suggest to fix those and resend ASAP.
> 
> Kevin, you should check it too
> 
> If either AMD or Intel ack the driver part next week I would take it
> this cycle. Otherwise at -rc1.
> 
FWIW, I feel more confident on the AMD parts as they have been exercised on real
hardware.

Suravee, Vasant, if you could take a look at the AMD driver patches -- you
looked at a past revision (RFCv1) and provided comments but while I took the
comments I didn't get Suravee's ACK as things were in flux on the UAPI side. But
it looks that v4 won't change much of the drivers

> Also I recommend you push all the selftest to a block of patches at
> the end of the series so the core code reads as one chunk. It doesn't
> seem as large that way :)
> 
Ah OK, interesting -- good to know, I can move to the end. I thought the desired
way (for reviewing purpose) was to put test right after, such that the reviewer
has it fresh while looking at the test code
