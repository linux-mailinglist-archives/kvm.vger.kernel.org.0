Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6797D12CA
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 17:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377657AbjJTPbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 11:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377758AbjJTPbN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 11:31:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD5C10DE
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 08:31:05 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KD8e0n017965;
        Fri, 20 Oct 2023 15:30:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=90jyDA8Wr7eDSPkV3tEk1hKK+BOIBDHu3dTvG3Abzzw=;
 b=3eoPFZUmS5K5FPJZiCExd3yA+HplIDEFQXqTT+21v2IVyqIJQWmGm82HgdibDad49vpC
 /Hdm39i7sseEH3kW75VJmZALifDzjrELFuJ/hdDZqOQHVkZ0/aKObTaUdNd2WDN7s/ut
 x0xEaY92tSqzqbJgqSJf0RD2IrDXhgiWK4cn1OHP+TbhWAk6Nide5woweRha+JLV4xer
 qZaiz9lbZnzquWkQgoO+cLk6lg+ricrX3qF54qJaNURfC1UY2/MUYdeJQauD816vf1He
 r7rUjGHN3sYoL7LFOzLxhl3WwJhgnVZfiSj6Ja2j8O8gBO4BXMxcqOjAn9e8IcXFE8z9 YA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tubw824e6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 15:30:38 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39KF7OCg038591;
        Fri, 20 Oct 2023 15:30:37 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tubw4xkqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 15:30:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=czt0J9z25O6Qyra64Sx+vdOc7pTvwzddl8a/YmSmtGAtW8fSLeX7vgFHey3gaRAvs8OIHKlbXgn7j3ph9TvvnuNh8/XyhRqqzfofwFcgWHcDU5WtSZlLRYTuVLi0mDMq3HAGgzC4Z89RXAimBKTEV+azO5b8XcLZYQY55qAWO3ujNGtylcmF6cGQF2Ahv5fON96s3vWa+Q1FCbIr1Z5WvhiO+2TqJwEKtlFNRgHDiFfAnWKarAkTcj5aIx4SAuFXKMqS881bcgs54LgRKtZm5uUvnJ2FtRlmA/oMXgK/oPJpWF2S2mywA4vvaMSNGLeIc6ox9d1OwyxJ16vllSl1ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=90jyDA8Wr7eDSPkV3tEk1hKK+BOIBDHu3dTvG3Abzzw=;
 b=Pwe4MtXiBQh8pB38ObVLC/ityebb4wDwV/RnlbOJSgpkDljjck/6dQHwosoM5BPg0BPRLg+GJW8n9BzOkswoGbNriGp6DqDjXbNKXNCk12/i+FWg/wCpIyElQLWIdRNENU5JeMQ5eQT13Z8tXYf7g0HFmDaIf7MXlhI5uLezblCbBw+Pxubh7BzTt7Jc0F4Kkagmh71LxMh2nt39FF36kixphY07Ce+9CpB/KGSeSMAz2aIMVHsP217n/mLE77k+KzcXIQiHbWtlfb6BDy+aiUKTJa4skqWKaYbTVbvI8LW8c80SEv7Ox1qxln1y+Cix2tGuEWnndAdZ2ozV4PfsqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=90jyDA8Wr7eDSPkV3tEk1hKK+BOIBDHu3dTvG3Abzzw=;
 b=Yc3TMwBlZBw6VgJ1oD0wubOlnp/W8t1wu4mlRik7zYttoVOYfenF/5lG4oOzd9jj+wLeQBW+mMmV7OUe6we7AKY1sH3qOr6z4eciW+pWleODvvBArP6B8tGFQXubW7EsETqOzfiudNOHprLiuEgiBfAno6re2kVUwNVhxPvp8Wg=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SJ0PR10MB5647.namprd10.prod.outlook.com (2603:10b6:a03:3da::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Fri, 20 Oct
 2023 15:30:34 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 15:30:34 +0000
Message-ID: <3e2453a8-ba2b-4125-bbfc-596f04481293@oracle.com>
Date:   Fri, 20 Oct 2023 16:30:29 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/18] iommufd: Add IOMMU_HWPT_SET_DIRTY
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-7-joao.m.martins@oracle.com>
 <BN9PR11MB52764CD9B4741197FD01DDB68CDBA@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <BN9PR11MB52764CD9B4741197FD01DDB68CDBA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0677.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::20) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SJ0PR10MB5647:EE_
X-MS-Office365-Filtering-Correlation-Id: 9004f49d-bc6e-4a6c-f275-08dbd181808e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r7dctWMaOOT1L8t+23Ng9K5PVwTAULBkcQZPPoxaZIVuFYqvlmo+l2hRKWzHEzNc7QxYvsc71DrNaY9ZVd2uVBQFCJiWtOs2bPySvFncUcZJeY1B67bJfdVZVG+4FedbxZ0AMeWNs//0hIdwhIhy093v14oYNS/ckLJFWlgtt6TVQpzBpVH/zCy1aOYfzXLjEuN/fbtrFeJ4LIEu2RNrkkxutYVghd/J4sOL5hfPuURqkLmLiP1cMVoZr926CwT1bFiKzzXMBClD0talOfmBDdjQIpbjsok6FMBLRTXgIlP5Dk0U1gFopywcIFZygE1k6oxiUoyD2jZuvDXWPNYSIR7Rh302LHGx74e81lGa3LVj6z1XXh1zQeZ365ngKoV2Tczh1xsws4yiZgHjs96zG7r82gtDen6WweUBcNOpzn3S4CwO+mAXo68fwxg4mBY2g2F+QJVKGXOddxuwNR7NRVPoECILCxLmj9eeD1vCDibt0j+H38rsh600AfVlVSkUcqpoOo99UWVykj1xr9BCmRerw8wW/By0aQ1Cyy+sIUmd5uvCWDCOKPWGwLGnZUhTLRnYQNUxRATep6EylMufUmQQPTNIPr1a6BJc0+LPmjUiTSOgaK3ElHBYlZ0PC8bsMiMjYAK1cHVNeckXFgBBbY+WL2zr7q9WGdCmr2oc+mM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(376002)(366004)(39860400002)(396003)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(86362001)(6512007)(54906003)(2616005)(7416002)(6506007)(53546011)(8936002)(316002)(4744005)(41300700001)(4326008)(478600001)(8676002)(2906002)(6486002)(5660300002)(66556008)(66946007)(66476007)(31696002)(6666004)(38100700002)(110136005)(26005)(36756003)(31686004)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUtsV1NDaEV1eXdMdmRCU2lxZm9hTUphWlFBcFZMSE56UVVtS2ZQUlJVRktu?=
 =?utf-8?B?WXdDbSs0a0ZXdWVqZnVoUE4wdjF6R3dvYVBpYlFwbGRmc0RJYURKVUhHeHJW?=
 =?utf-8?B?NC9kNkJhZXBVMVdmN2ZDYXVJcU8zc0c4NW9xOHNaSVNJQmkzNmRuMG9idG5I?=
 =?utf-8?B?VVRRd1lFTVdqMTBkcXRTaHBzNlora1ZlTXhJM0dDSlJLNDdnMlNWUFNFYUNU?=
 =?utf-8?B?Q2IxMCs2dWFrVEx4ckVmQndoa1B3WkZBQ1ErK1VBV1pUMW5tK29lU1h1aGw2?=
 =?utf-8?B?RDBxMWtxK1JuRXhJOExkcnJQcHR3ZTIzb2U5bkRCVmpCaU9ieE45cW9SZkRU?=
 =?utf-8?B?bi9LOTJLQThDclIxektwRUJLOHdSQXpZKzBPdzd4Rlh1QkRVTXp6NGJFS1N4?=
 =?utf-8?B?VERJbEpnYjRlR2Q2SHl3dGtHUDljM0NPWWtSM2drb0J1QlFrOUMrSW9NekpY?=
 =?utf-8?B?ZVFiZzlWVFZYR0VEZnNOVGp2eGdxRElIdWlpbkZlbVp3K2xsSDhxV3lKcUlQ?=
 =?utf-8?B?L2lVSEp3VG5CLyt6ZWIyQXhONEVJTTdhbHJYdTR5LzhQTUFvRlhoWndRN0Rl?=
 =?utf-8?B?UXJlUURQdDFhMG9EVHlIMW9xYWJTdHVIQkFxOXdkUk5UUGJDRENYemxqVEhY?=
 =?utf-8?B?WXN3YmVaWFJRRlkyckJYU2RzMFVpL01sejZ5NjJ6ZVBVK1VSL2JxMXhwYVhR?=
 =?utf-8?B?SEgrbjg0UWdKeVdXd1VWazhQOVFJcVBHVEZleDgyTHdDS1lSclhicURaK0tS?=
 =?utf-8?B?akV4RmEwTElyK2NZMzNKNVVEOFJBY296dTEvMFpWY2VXTm0zcDM1ZzZneTNs?=
 =?utf-8?B?dG1MZHFnOStBR0tlWDFETHFseEtoWUFweTA2WS9lUU10ZHpLdkh2aEs5UzhY?=
 =?utf-8?B?ajliaUxCRWVqV2NIeEhDS0I4a2J0c3pIcmtqNk5PbVpmcEFORzJTOEFQLzho?=
 =?utf-8?B?VjdoYUV6M05UZi9rL2xNbGdQNzVkczFpQlV2YXExQzdHQzRzNzhpcjNZMkk2?=
 =?utf-8?B?WjZhRGFWbWhBaGlMT1VFMFhRYlgvcFVscUNPSTl5dVFFdW9LdTNBdytMdFVm?=
 =?utf-8?B?dG1zY0I0bHhJNDF3WGpzR0MvK0VlOThvRWtLZjl6QWh6V0dkeHBLT0Z6TFB4?=
 =?utf-8?B?bzdwdkpCM0V1elJHZlIzK01QQm1zbVdmR21XRFROTDNqNHk4N2Y2d0hRMWFz?=
 =?utf-8?B?QThSRlpLbnBpSjhRZ1A1YlRtcEtzbXdBdTNSQWpnTFJKWlBUU2hZblRGK2Vo?=
 =?utf-8?B?c1htQU0vNG9CaWRMcTIyUmVFeWZNcDRFWlVUanpPSnJnT2lVWFR0TVZoMFJM?=
 =?utf-8?B?OWo4MUFVVFY4VTJvVU1TeDFvZHdnbUliWGRCUVNwZHd4d0x0cE5GTVEzNDFQ?=
 =?utf-8?B?Unh2T1NTWDNFT2I1L1RZN1RhZndQbDdJT1dhRUhpZk5hNUp3NUovbC9zeVo2?=
 =?utf-8?B?OTFKWnV5WVh4aGc1WWpESXQra25DQ1dXUUdPMTZCeDNrSGltbWgvMlFiQU83?=
 =?utf-8?B?SUR4UWVwclAyVm1PNncyVkNzbm9GVktOdmVMckFxK01Fc3lCMmo2YnhaQXhF?=
 =?utf-8?B?N0QvdDc0Z0R3K0pMeDZJUlRTVkF6R1Q4enhhSVlZbFJiV2F1cFZuZHJHcFB6?=
 =?utf-8?B?TWlTV2ZpVGNMVFI1dDhXQjczcFdUQi8veTE2a0ZRTnMrRDZMT09DZG0xdWtp?=
 =?utf-8?B?Q1RYUEtZNDhpUTB4c2hBQUUzVkwyZm5NSnBiSTcrQ1JXQ2luYTFiTmFsLzFU?=
 =?utf-8?B?YnM4aGlxd1FGdUdHNGRTb0pRVURnZk9MOWg0a2RuWTJia29ZYzZyMUQySThO?=
 =?utf-8?B?dmk3TGtuZWhOaS9JY2p1ZXNEZlBMQkVmQVIycU1OMXZ4VlhSVGZkUVlHeE03?=
 =?utf-8?B?cGphYUFkdENWMzBvbGJMV0tndzBkQ3oxdURWL1N2eUVzd1dBdVE2dkNoSEU5?=
 =?utf-8?B?bHdrelMzMWpQRXFxSFozK1B1bHB3NUFhck5Ua25aVHhSU3dFSHIrZDR0bjQv?=
 =?utf-8?B?QmVGdEFZUHZRYTdzb3l0eTlscHJEQi9tcGJPOWtaZ1VwelRGa3VRWGdJdGJh?=
 =?utf-8?B?bG51aS80SUR2MzZUMFdCRC9tVlYwTTREbHdScFY4VER0TzN6MTFmQnQ1b0VN?=
 =?utf-8?B?M0hqak9xd0RNdXhMYkVjZXNiZTFiK1dmNFVNaVJVU1VzbldzeG56MFA3Q1Jj?=
 =?utf-8?B?V2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?elFIVE1NZzJweW1pajZ3MlAxd3RMVHF5QWQvYzNKdys0NTVXOTFqaEd4NkIr?=
 =?utf-8?B?R1hsdm1qT0lKVG93bnpLTFA3QVl3TnJPcEpDMnNQMTcxTUNpbkczbHdlMU9i?=
 =?utf-8?B?bnZBdTcrUklZUWtpVCs1ZWFsWEJ1dENjVTB5c0ZkY3BycGJWKzNBNFQ2VEdz?=
 =?utf-8?B?RWJXSThQblFVRzgwYjZWTDZkTG9YMXprVy9PVXZIdnFDUE5JSUtMV1ZuYWV4?=
 =?utf-8?B?MlliWWFMdi9KSzVqd0dHTmtwYkhtYllLdGxCclNjWjB3akFGZmVpd1VtUWpW?=
 =?utf-8?B?UU5MRkdYdnpRS1RQQ0l2UTc3NE5aRGFhbVZORlhKUEZMNUFGTXVwOUUzb0pz?=
 =?utf-8?B?OHZQZXQ0ZktJVEpUbThZRXdWYkFSNUlvU1dtU2lTTFY1cEpMb3dEalpLaFht?=
 =?utf-8?B?S1UzUnhnT05Ca2NBUVVNOURkWGc1bmcvVTNySk5CV25SRE5uV2EwZUpZQTVh?=
 =?utf-8?B?dmJWMGNTSFhibGRETDZOOER0SmxVVmtiRStDMlY3TWlZMG1EMERyaStIeEZ0?=
 =?utf-8?B?M05EeDZQTnB4U0l0VW9hUFNTNWFNUHJ6T3p1WnZIbm5YaVB1RkRMeGtXQUxF?=
 =?utf-8?B?WTFUeUdINDZDTzl0QXV3Sy9xbXJEMldhbWNEcW8rZHAzcTVJQldBRTBQWTZw?=
 =?utf-8?B?WStkWExVV3UyUXc1cndYRzZleWZTRXg5SFBFNG4vYVJjOXFDRm1IVFhTL3hx?=
 =?utf-8?B?S0R6WllQc1pjT2IrMEZsMmIxVnlaWkMvZ3lZOGdKU1h5ZnkxR0xhcXkxOU5u?=
 =?utf-8?B?V013Ri9ST2VJN1c4RFdHMG9wTTR3M3hCczFvK1gwbWtHUks2WE5pYUJ6UXJU?=
 =?utf-8?B?djNUbTNPQUpFQlhzNHJkRnI4M1htQmtIZlJNV1VzZEZkMWZQVFFEcU5zUU53?=
 =?utf-8?B?M2hQNE4vTEhiK0NCNTQrNkNJZE9OcVFCdkNJTkJ1azZGMUVwU09MY2xTYjRL?=
 =?utf-8?B?Sy9qT0VoY05UWVNpSTFFdEJRcEdPeXRyajF5Yzdza09zS0JMdlh2Nm5rL2E1?=
 =?utf-8?B?Z3pEQ0t3bU9rdHQwU0k2Z0p2RzFNZEN5TmxlalM3WHhXWjcxY0VYZEthamVo?=
 =?utf-8?B?d2dJZjc2R1doUEQ5OFVYeFhZUWRKM1hlTzk2K2l6RTVUS1hZRkFGTzRiOTNH?=
 =?utf-8?B?MHhCdFVHcVU0ODJIWGpibm1yU1hNS3BtVEptV2NjTWlsUmJXU2preDBHdkNO?=
 =?utf-8?B?SXN4aXF2aEVNSFBwNG5GcVRPZ3pWNFJGUnJSaTUxajdST2dNYnhyTkJPSzJu?=
 =?utf-8?B?bHhNM2E1R25XRDJ3Z0tsZkRFdFRuVXpYenZsWW5DNUxBbHdkVzNTMWtKWWZ3?=
 =?utf-8?B?cWNqQmI3OTd6OUtma0JIUHFnYnVFYWphSzhyNjBDeGpDTDlseDNGYjhmNnpq?=
 =?utf-8?B?WEhkNWFnTzUvS2tsUU4rajVzZHRjcU5IbUNZR2pXTFZzSVJZNWxGeFYvN3o5?=
 =?utf-8?Q?6ur1blqZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9004f49d-bc6e-4a6c-f275-08dbd181808e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 15:30:34.3377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d9lipHiSAx7FEKY1M0PxStzCC106vQs/lfDM7L0sKuODic83erE1GxXfyHHpqm68V0rLcxdxN8KJONsx8t4TjeOpc58QIwFc5BrpcoE4+PU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5647
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310200129
X-Proofpoint-GUID: 0WgGoXjFQfAHYRZB2ZE444zenaZojVpQ
X-Proofpoint-ORIG-GUID: 0WgGoXjFQfAHYRZB2ZE444zenaZojVpQ
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/10/2023 07:09, Tian, Kevin wrote:
>> From: Joao Martins <joao.m.martins@oracle.com>
>> Sent: Thursday, October 19, 2023 4:27 AM
>> +
>> +/**
>> + * struct iommu_hwpt_set_dirty - ioctl(IOMMU_HWPT_SET_DIRTY)
> 
> IOMMU_HWPT_SET_DIRTY_TRACKING

OK; I am riding on the assumption that the naming change ask
is to broadly replace structs/iommufd-cmds/ioctls/commit-msgs from
set_dirty to set_dirty_tracking
