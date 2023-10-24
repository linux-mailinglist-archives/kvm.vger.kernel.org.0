Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA9A7D5053
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 14:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbjJXMx0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 08:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234376AbjJXMxY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 08:53:24 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4F39B
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 05:53:21 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39OCJZ57003716;
        Tue, 24 Oct 2023 12:52:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=pxFKmNoHHwlh89MqupCKArVJwFAT7BTQSm4UTfRnw54=;
 b=0E7uqrzfm/5ZmhSEn89HUNv40FNN628yjnsuUD3HBVis1/UxvvyQjpuBGBmIWQNjmM0m
 VXJoqXgJR3f/HfxUEsJg5Loc6MgP071+CPF6xPIzoy5aBsfAH+OLHeLpxTOgOS64iWWF
 /eLY1ieITO5/tkz4Qz4wkW6wuOXMZAdVfeevfL1ev6HyMxGWj/Hdf8Hu9L0Jp2HSY//7
 X599LILSqRo5tSeRloWXXr7fzhlQHfQ8mdyv2N3H3+1RdrF0vlvNORg9L1bmgCd3xIxt
 320gVm73t9wcjcGV5PaX4wsmikFl3pQwxDfiDa3qHSQ1fvjCQiVm/bL3THR0aOSk5wef nw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv52dwc9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 12:52:58 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39OBut3m001784;
        Tue, 24 Oct 2023 12:52:57 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tv53bpse7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 12:52:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O6f8yRJgn0XMIABheLdCGkJZgIe539bJMl1RKMcQSWZx2+ASnm/oPWASYSt7HERkMp2hJq5egN9YFigvz7wYRYVTHu3K6cfMRXQkoToIFD4qvqavJ6TdpMPTBeBGBY+ioZnBH4ocHq91jTLnsbAj95ATS5F4fauMImnZcKFSedTcJbtvA8oKsFB+2GWlTEEJLu96eapv3aPrjQTgKVsZv4+p2mAHmpaMRvWqa8OvTEOItwjHcB9EFZ6fvQDMpwrrqfU36AtOaJD9dcmJ/PKh+4S3T80SdfAa79GH7jRbP/s4b4Vq6uvu4vbAfsqab/RFYMHxESMmQ7RmnrjJ3aE+7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pxFKmNoHHwlh89MqupCKArVJwFAT7BTQSm4UTfRnw54=;
 b=PymkhimVp8mP0+N3DH+WJjd+zjcaM39/06YNCgyQR0dm7+4UwxsPZicO8b3gtTjO82FgbHKrmOUReQc4THiwGIBj0k9Wn7yblyv6ezpRF3vUf7viKfUFiyqc34HkMakqgF2NeQjg+zNolIMpV7NCcQGEwixLtwDfVKWcb7CxmG/lxf+4X+PItvkm8ESkcyz8Gd4VTKtrLKJnq/SAhI04BU2U0c54Cl4AhzlcTpLlnR46lgBBJuz9Z2mGWoesJjn9cjbMqpZaeRe0OSjPwaIb4czcjpAlBqJdHZIqgso+XegXJhBDh6KnWHrDSmQW9gHO0SgfRQLsd4+SWPuZnxWFwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pxFKmNoHHwlh89MqupCKArVJwFAT7BTQSm4UTfRnw54=;
 b=TXdA2nAc9u8PPQQByHn+gfHYKgo3JVm9Rh/lY7662lNwBER2nW+hzO/9MkGgy6Epjsv0+taDaydqW1J+Pa5nSzAmQuT2v/JpaUVGFG7qN2GQBb3tUy6Trt71hb03JxBN80INNp4VqHXGMqvFOa1X80I5oRR28Ih7VFcU0CUbhV8=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by IA0PR10MB7666.namprd10.prod.outlook.com (2603:10b6:208:481::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Tue, 24 Oct
 2023 12:52:55 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac%3]) with mapi id 15.20.6907.032; Tue, 24 Oct 2023
 12:52:55 +0000
Message-ID: <61c0fbad-b441-4a8b-968e-c3c36f18e8bd@oracle.com>
Date:   Tue, 24 Oct 2023 13:52:50 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 12/18] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
To:     Yi Liu <yi.l.liu@intel.com>, iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231020222804.21850-13-joao.m.martins@oracle.com>
 <ad8fcbd4-aa5c-4bff-bfc8-a2e8fa1c1cf5@intel.com>
 <2b4beb4c-3936-4a75-9ecd-6d04e872bd90@oracle.com>
In-Reply-To: <2b4beb4c-3936-4a75-9ecd-6d04e872bd90@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0235.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::31) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|IA0PR10MB7666:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fec1bff-3377-4754-d83b-08dbd4902484
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WU1LPgnqIQS3HKLAg/Q2TX20RqaoxfDK1IFSRThc1CGwMy7aKGSdn6m8IPh79XUHFTHVaEO+rcMEvgL7YSDvJBb6DU8+LSUCMZ9wgdlssRWlrxi6RoPVC4s2kOp2Ii+BQZtzxG1nKKb8qRbm1SZX94o1s8PCFvweDuwB7VG7NTR37k4UCcq3OH07yfDuG+iaVMNpUo5KvRSKylr5RCo1UKrLNZmSEDQDaVRTUyDRie58z+6OjFDVgqNcn7hduKWZXBQ7sFVO37x46/yrbQlZfY0So4uyUWfaeMVfj/ZSujEWQMaflq/jabZWHpKxL9snNOS7yB4EHB0P8EXz5xaEU6vc1hpBI9u09z6iq7tbnzTgixQ8c3v8Yyk1lb5Np0NbJJ9spufHpALFd0JufAwW/9C0n9OIbW0+vjqRRHQYiZMiDcmQKpXls0Jsh0/KcaOuZ08lpo9m3r/IXwP7dS1p6XfEanSHBHGMSU6EFHg7qQlmIjgNcavgarR2KC/e74LGo8vcyfkd7PlnGoB8N+Tcb7rue7hwHX36S1TsYhusTvRjgAHd4Vk/gOMLKonds1c7lB3FPF8EKbY6bOS1U+G1tOegAmEKpz5uXVZPfsbsWS98okNJ1MgWgya+I4qs4QSIN+WdITXkNPTVIpWEIhPsEc+XwRrGK02v/UTyQK0HAnY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(346002)(396003)(136003)(376002)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(41300700001)(36756003)(2906002)(38100700002)(316002)(2616005)(66946007)(66476007)(66556008)(54906003)(478600001)(6506007)(6486002)(53546011)(6666004)(6512007)(83380400001)(5660300002)(86362001)(31696002)(4326008)(7416002)(8676002)(8936002)(26005)(31686004)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dW11bk13eG9xN1FIKzg5ZVdxNGJRMUhHb2NQRVN4RlZET1VocVdiUDgrMC94?=
 =?utf-8?B?enJmUjErM2tLLzYybmlCaExuOVAxR1RVYzJTOThseVNjMnFwbHg1cXNyOE5a?=
 =?utf-8?B?bDVOczNCS1NwVkFWWTlMcVhISVR6ZFNnaFg1T3AxVGE4Y29ZNkJSYlhRTEhl?=
 =?utf-8?B?Q3F0RmxscHlSNVFZNnBsZXhtMUhJNGJ0Tk9FWnlhNDl3eURqUGg0Z2pMVW11?=
 =?utf-8?B?U2wzaHhRSXo2MmNRTW1vaHFBTkFscUZzNjJXQWp3V3VmYlI5d2dGNENtelRU?=
 =?utf-8?B?ZlhlakJmL2NQbFlrVFQ4UHBqL3FtZGhlK0lqandPa2lrL0dTc0lmYUZoTUdz?=
 =?utf-8?B?Uk1FREhyV3NySGFxSG5YN0lGYTRQcW4ycW14WVJUa3VROFJISFk0WTVmQ1Jj?=
 =?utf-8?B?ZlA1bTRHdVZSaUthQmhUQkV4amNzblA2cHd5M2Uxb0I1ZTdYVENPc0JjT1R4?=
 =?utf-8?B?cmlkbkNQaHZuc3h3S2U2VlpQMUlsSE05bEZMRFlUYVR5UWhKQ21UbXo4QVkz?=
 =?utf-8?B?am9VeTdnVFJyNXhGWmEzTlRBOUxsZEtoNVBkMG9XR0VCc1lyRzJuOXpmaTRa?=
 =?utf-8?B?TW9tZkl4K2o1UGs3WDdueWFwekZmZUpHUjlHaGVBbEJUOTBKbUhtWnR4V3Zt?=
 =?utf-8?B?ei9oa2dzRG43d1M5R0dmMXRyQ3ZzVC9rVEpJOTl2d3hhc0VEVDFvN1RPUDNG?=
 =?utf-8?B?ZG1CaisvUHBrdzc3TSs2dzVaVGpFckxhaGdKMUVsS0s0aG1CSm9oQUd0RGRK?=
 =?utf-8?B?YXhpSS93bTA4NDk4UFZJMVhjNUZETFNSVHBxQUpuK0M3SElEL3liZm5GZ2tN?=
 =?utf-8?B?cVo2UGxXVmlDNUZYUmJENDVZaEU2ekNtVkprL0tyY0gvQ1E5UlZLQkR3ajNE?=
 =?utf-8?B?SGN3dEQvOTZoaGdwalkxNDVaUVVVaFpwdUhQUDZPditFTHFmaXlRYy9wdXlt?=
 =?utf-8?B?K203WDF0eWdTVHg0aFhWNS9MNDZIVXd2MUZaVGpTcCtsQWoxTEgyUStQMThx?=
 =?utf-8?B?ejdrN1AvcDQrekY4TjZZYWUyUlc5S29sY0Mwb0hxeEhGTzd2RU5RZlY4REJt?=
 =?utf-8?B?VzU0WTFOV0xmdEV1WTc5TWJ1VEZ2SisvcWhBa1NVM0xTSjMwQ0tpdDVGK3do?=
 =?utf-8?B?cUVVd0UzbmFHc0dPQzZWMWdlczZya2ZJYi9qRkFWRHZqd3kzZDU0akF2U2Jo?=
 =?utf-8?B?MC8xNzdQUUNUUDhMVUNsOFpNTEsvbnZsTW52SzBjNVl3cDJ3VVdiMk1XaWhT?=
 =?utf-8?B?Z0lMRlNVY0ptTHNlWnhGUE1DUHZQWTR3UE54QzYyUXpKV0x5RG9DczJsa0tC?=
 =?utf-8?B?R2VWMVEzN0VZKzM2S0xHdFJZT3Vha3ZqR1hVWkFpYkE5aWhRbWxhZGh0WU5m?=
 =?utf-8?B?N2RFNFA5OXk2aDNpaCtQb0hnWGpoT1lKY0g5TkJpakk0Rk5WQk9hTE4zby94?=
 =?utf-8?B?ei9LMnJIQWpKSHBNeUhBa0w2L0ZhQWVPZk9IWWNBQ0UydnNKRHpweERlaGl5?=
 =?utf-8?B?RHVaOEFucUVzaWEvV1FRV24rMVN3UGY2Q0YyL24yTlgvanU4MDNLaGp4RkZR?=
 =?utf-8?B?TnEyZ09sT0I1azIrMndPaDdOK2pEUzFFLzVTa01GN2JkTW95VUdZMjllMk16?=
 =?utf-8?B?MVh5K3NqenJvdFF1MHZwWFRhMFo4b2Fsc1MySE5MdXNhZ2ZVaVArRlp1UWV5?=
 =?utf-8?B?TkFqSDRCczlPZmo0UjgwZGxFV1BaWVBJTThmbmRXYWUyK3VCeWFzaUtjb0dz?=
 =?utf-8?B?Y2V1VmltbXd6dldQbUtVelZDMldlSUFsSWsyZCtwZkZON1lUOFRZWEdMeFFW?=
 =?utf-8?B?OTI1NFdRNzY3SlBDMEI0RDNWazhrOTlEQndUYUljVmRsd2x5RTJzamhVMlQz?=
 =?utf-8?B?L2lDcGFvQ1l1TmliWTdhNHBpQTBpVVJSaHQrTFNQWFY1STZyb2MxNVlNeTJu?=
 =?utf-8?B?R2FWWHVPTzdZeXp4OExGNS9DZkZlR2R6cXVqNjV3bTJ1NThxRzVQc2VXU2Rz?=
 =?utf-8?B?Z2xTakFRRGdQK3pCa1RaUTZYN3E0RXdWSGFJZmprYVkwUk13TGR3SGRIRzNT?=
 =?utf-8?B?MldnNXZOYVkrM0ZnV2FFK3Zya1l0R1VjYkV1R1J0cmNLeFI0QlF2MXIwRjhL?=
 =?utf-8?B?cmcrVzBadm9BNWhzMnAya3EvamxEN3ZkZkZiWkp6Z1BKV1RVcmIyY0RieWFM?=
 =?utf-8?B?bHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?KzlXellNbGQ4QVpYSHFBeDgweis1Z1l3L1hESjJEb1Z3cnA5NDN0MjRUZ1M5?=
 =?utf-8?B?TEFnQlFXN25WOUdldXFucVdya2d3eEIyTXlNNE1YQXpGU21sKzF6Vmx5SCsx?=
 =?utf-8?B?NUtDcjVmQTF4OGhwWHE2b3dpLzlzM05NRFZPSG5tRWdoUGY2VXF1QVc1VzZY?=
 =?utf-8?B?d2VIMXE5b3VBR3hsK3dVQ2hYekFFb1R2Q0tqRTBJS3pTbVNQNTh0Q3hJNEZr?=
 =?utf-8?B?LzIycWRRMTFPYnpQeGN1b0pDRHRNcndHZjNuejBlUnV1MFJmcWhrQTE3KzFq?=
 =?utf-8?B?YWYxcjljTlhOeVB0RDRtcm9xZnlBYXAvSWVhMER1Tmd4VFJYZUZMUEdOZG5w?=
 =?utf-8?B?Ym1vbFEzNjkxL1owOTBjS284QXlIU2U3Z0JYWmJ6SUZYc3djRm1MWGo1UXZL?=
 =?utf-8?B?UjZoa3ZTUVhRZFBlYms2SmxnMFRGQXN2dnlhd1crVTZiRkR4elo5Nk8yL1lp?=
 =?utf-8?B?Z24ybWtxdFFPV0F2Y0cydC9JMW9oTEZDSURBbXFjbXEzblE2WWl0eE83SGhU?=
 =?utf-8?B?RndNRFoyeW9wZGR4b2lqbUJnQ2xaYnRoUDhvL0g4OUtlbHY0ajFOUEZyL3dU?=
 =?utf-8?B?Wnh1ZW82cDNZN09Kd0RmVHZvVnF6dmJXS2ZuNUt1VDZQRDQ1bit1cWF1WVM0?=
 =?utf-8?B?ZFA0Q2FEd1FBWUZmRXBFckdaREQzSUREaWdEeE5jRC9COUcvM00yMzVCQWhw?=
 =?utf-8?B?TFFzK0tUYkp6VE1nc2pFYlZsUzdvaURlQVhzUzVBWjVOWUNPdWEwUk5qK2U0?=
 =?utf-8?B?dXFOeS9zZ0VFQ0tDQXg3Nmw5cGRMSDdUSE5uQlZLVXNjSGhlMTVKS25Kbkdx?=
 =?utf-8?B?ZUtvVGljZllwT3RZcUE2WW5HcWEzeXVLUzJMV0x3UGpGT0ltNFZOVUxFbkZH?=
 =?utf-8?B?YzcrREtnMjlHR21nODB2Y2J2UWEzQ0M4a09YSmU4MERsRkM4L3YvYWE4ZUJN?=
 =?utf-8?B?ODJCUGNsanRvc0t1SmpwTTBMS1EwNDFIcW5ydkJsWGU3VXAvSkRhVlNOY0Rj?=
 =?utf-8?B?UGhJNitjcUNwem1LQmlGVUVYOUFBMm9vSTdXbFdVOXViYVJac0RIUEYyV2Rt?=
 =?utf-8?B?YytYWmh4S0Zjb2ZCT3NiRzhCRFVEQktiLzBHUEZmNjFsc0JSS09mcTVMbVFl?=
 =?utf-8?B?RkpYcXVEeWc3WTVLNWgyZ2g3aUc3VVlxcVdsUEVGaWkrMjl0dlBQT3E4L1FI?=
 =?utf-8?B?cVBVM2U4RHdFTjVaK3VRcUpwYUsrNTA1TUxEczVCZVpJUHlEOFA4TVZzTENQ?=
 =?utf-8?B?SXlRQVpLRE9xSGhnekRDNDRYUE5aMkhGUUdVR2RqeWlHVGN5cE1vWmFQbFFs?=
 =?utf-8?B?RGJXSjlVV1ZMNms4TDIvRmQ3Ny9ud3A1TE94SVJHeG13bHo2NHdDd1dDeWtO?=
 =?utf-8?B?SjBVNUlhOEJxUjlqZldML2N0ZlhYcThFMDVGeXBXVDY1T1ZKZ0xQczNvZ0Vr?=
 =?utf-8?Q?qAh8S62h?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fec1bff-3377-4754-d83b-08dbd4902484
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2023 12:52:55.8595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k8lG0BjJwuRNooGPDZ801fXe29547Eh8OOBc9kVnw6JGqg6Crfizzcdw9dkFL1inZL9ZYcNOhF+GeCvPE2YjthpUMhfra1bJ5+17DbkL8Uo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7666
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-24_13,2023-10-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310240109
X-Proofpoint-ORIG-GUID: JOfJ7T-EmnqEBogcpB8Z19kymSy7rFxt
X-Proofpoint-GUID: JOfJ7T-EmnqEBogcpB8Z19kymSy7rFxt
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/2023 13:42, Joao Martins wrote:
> On 24/10/2023 13:34, Yi Liu wrote:
>> On 2023/10/21 06:27, Joao Martins wrote:
>>> ---
>>>   drivers/iommu/intel/Kconfig |   1 +
>>>   drivers/iommu/intel/iommu.c | 104 +++++++++++++++++++++++++++++++++-
>>>   drivers/iommu/intel/iommu.h |  17 ++++++
>>>   drivers/iommu/intel/pasid.c | 108 ++++++++++++++++++++++++++++++++++++
>>>   drivers/iommu/intel/pasid.h |   4 ++
>>>   5 files changed, 233 insertions(+), 1 deletion(-)
>>
>> normally, the subject of commits to intel iommu driver is started
>> with 'iommu/vt-d'. So if there is a new version, please rename it.
>> Also, SL is a bit eld naming, please use SS (second stage)
>>
>> s/iommu/intel: Access/Dirty bit support for SL domains/iommu/vt-d: Access/Dirty
>> bit support for SS domains
>>
> OK
> 
FYI, this is what I have staged in:

Subject: iommu/vt-d: Access/Dirty bit support for SS domains

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 4e25faf573de..eb92a201cc0b 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4094,7 +4094,7 @@ intel_iommu_domain_alloc_user(struct device *dev, u32 flags)
                return ERR_PTR(-EOPNOTSUPP);

        dirty_tracking = (flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING);
-       if (dirty_tracking && !slads_supported(iommu))
+       if (dirty_tracking && !ssads_supported(iommu))
                return ERR_PTR(-EOPNOTSUPP);

        /*
@@ -4137,7 +4137,7 @@ static int prepare_domain_attach_device(struct
iommu_domain *domain,
        if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
                return -EINVAL;

-       if (domain->dirty_ops && !slads_supported(iommu))
+       if (domain->dirty_ops && !ssads_supported(iommu))
                return -EINVAL;

        /* check if this iommu agaw is sufficient for max mapped address */
@@ -4395,7 +4395,7 @@ static bool intel_iommu_capable(struct device *dev, enum
iommu_cap cap)
        case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
                return ecap_sc_support(info->iommu->ecap);
        case IOMMU_CAP_DIRTY_TRACKING:
-               return slads_supported(info->iommu);
+               return ssads_supported(info->iommu);
        default:
                return false;
        }
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 27bcfd3bacdd..3bb569146229 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -542,10 +542,9 @@ enum {
 #define sm_supported(iommu)    (intel_iommu_sm && ecap_smts((iommu)->ecap))
 #define pasid_supported(iommu) (sm_supported(iommu) &&                 \
                                 ecap_pasid((iommu)->ecap))
-#define slads_supported(iommu) (sm_supported(iommu) &&                 \
+#define ssads_supported(iommu) (sm_supported(iommu) &&                 \
                                ecap_slads((iommu)->ecap))

-
 struct pasid_entry;
 struct pasid_state_entry;
 struct page_req_dsc;
