Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53BBB70930A
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 11:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbjESJ3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 05:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbjESJ3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 05:29:30 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F6CE43
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 02:29:29 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34J6kFvo008020;
        Fri, 19 May 2023 09:29:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=EG7eCNqliJ0P2PQ2zUW+C2KZd1IEYjuy5A1y+3kP7uI=;
 b=WkTIHKaN/j8aeimYg7xW9t93i56pXMciks2Hv8ggl3ceWrpXK9SvwksFENoFtFjhsJAr
 AyfqVR4PEkgClpnDPDih2GJdyBhfwZkVW1Y8VxbYax6WlAcX/kxkyaL9gmYkZpsIqvuJ
 +rkAfaYw6PhAuk3E8VVb2svCQ7//0mtQC5ZFAyL248/g5XYG34dvXSpAY5ccm/OkoAGe
 4cKF4lTjmf/NxfqLb8ZIXLeZJg4A/gDhuLs8+4zFtwNvLIHZJGF1MvVf/vlWnCSlU8O2
 78ViAulye3CWFN9uw/9JDTkqjwaF/I4fb3iJ+/Qt1cO+x/HxsLDfO2uQ/SEh3hJsFz9B zg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qmxwpmdxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 09:29:05 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34J8dl2V040073;
        Fri, 19 May 2023 09:29:05 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qj107mgt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 09:29:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kI20MQz1naipbH4v1XfxTfv5ZXYUbsVCBUbrHlcdn6N3vn1swoLCQyDQZy/lBsLhT0FBc4qwbfRhulKq7EXRzSFiN7sp7GP17txwECdL+Fb5HvSMMC3XSzqP0VBqweNdJES5P2cFtJ7xO5R43fwM4MhYtLKaQkcQ80C5oBdbNR3ehe2oWsZMZg9fUHVqhg62neX2DWhzctCZJ7RkPgt8ne5JxZtWAOC40lwHm3uC5JquKd6oscQ1Vd9XgE06gzXdR36LuKlVV21EI+kRVJwuueZhEkqEpLQ+Z3ynWlL5vM2B2fQLupnsRNM/ycIS2xNSX2JY+TABUUnDpNlSIU87rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EG7eCNqliJ0P2PQ2zUW+C2KZd1IEYjuy5A1y+3kP7uI=;
 b=knQzhBPTavqt0/hRhqJj0cPegXpCPzHI1+TkIoSE1mAPybu5U3BaJycr36jZh7WgG1+6mYAWyPaE50p/rejEEBDvEYeGDG+88acseS/vhG95FT2iLmaN4iRnXl+YdNk0q2yD0kfXZzll01xOhz/Lp/ABHdsqOYaFedV2FnXri+ceN1Ia3s8FKOnPMxMuWev5AjAznYawpaaT/HLd7cofcK1rn7YCOKeXm4M70N5++bXkSD8r/Q+zQjE1c5QrkokWn//h7yeykCYxTS0xM/RVbyxmF4+Eqk3nbUvsyjpqbuSqdwPAv7sr6oQ3WdmbqY6LIlqIXOpvBRIv3vqoRDAxsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EG7eCNqliJ0P2PQ2zUW+C2KZd1IEYjuy5A1y+3kP7uI=;
 b=E/Mz843713LZLkphRugWNshf1ynpsggJoNT1T4wWRdz/iOBJk4X1ab3gIo++PEi2ou5Q+zkhrO/fCQJm3RLTC77BsNHp9QYOrqwVgjdBcystlAN0pmKTmonJeul2fkf/nj/v5y6I94M97QKoutl0Kk6BZ9faMu/JdHXgDGngSTE=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SA1PR10MB7682.namprd10.prod.outlook.com (2603:10b6:806:375::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 09:29:02 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b%3]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 09:29:02 +0000
Message-ID: <d3c5566a-295d-4197-f507-4a55baef51e3@oracle.com>
Date:   Fri, 19 May 2023 10:28:56 +0100
Subject: Re: [PATCH RFCv2 04/24] iommu: Add iommu_domain ops for dirty
 tracking
Content-Language: en-US
To:     Baolu Lu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-5-joao.m.martins@oracle.com>
 <1e6a9967-6cf6-5906-3243-29e028967cdc@linux.intel.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <1e6a9967-6cf6-5906-3243-29e028967cdc@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0340.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::21) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SA1PR10MB7682:EE_
X-MS-Office365-Filtering-Correlation-Id: a567ad4b-f3c7-40b4-7db6-08db584b7b8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QygjuPu+KCo0TRYQTvbu0eGRoGI2Hh1fxNfIHg2JRbzYzJCIgf67sNEC/Mj4xLWJx8GE+zQ20shAfR62HXOpGEfks5MkfD6fOqxffetQsPHUx3blkbxyLxeJXAjpc83ogYb63h9E95wcvtrTiy0uhmawp7EplEM5zVyckquGL8foGEI7IX7cqagirlz6J3Aag80uoy6bAE+2AR2Vtw8G2gthwoKIHlXOTQr+Qa8FC288IRLRcOnRCjaXJQApogjT6SnBbEHp63rrVUqkGr84vkOvPJS5rvDtCHd6OTtkJ68fn6Cg3zHn8LRxDNWJG0WHXn3LattQlUkxE/loX+4aG3Sdi85sQ6jp31MnNJrylSR599HrVJn6Dwd+cANcYKUVrYnkfupUPCYG8+OSi4RrgcedlCp3ZjUfeUWJAf1VPpoBVHh/uvVnlkKaWQkH7XzM2P5E6fenRax4M+dR7DSONT1gJeujtX6knoeu7TypiJkNcY7rC7CXHCyfPP43kfL8k2YdA++DiBz1JsUOhnOhlvxZB4uaWHQnrptoeAlMI0SFEEZ+hL/0QZ/ZDfxTf40FKAzQ0Qkrg/6DkiMreDaBy+xpcFE3njrfTjLsDjqvqVoivRdp5Ma4Uw5fV0Ybq6cGaJ97uo5RFk8hkvOSAUABaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(346002)(39860400002)(366004)(396003)(451199021)(31686004)(66556008)(66476007)(66946007)(478600001)(4326008)(54906003)(316002)(86362001)(31696002)(36756003)(83380400001)(6512007)(6506007)(26005)(2616005)(186003)(53546011)(41300700001)(5660300002)(8936002)(8676002)(7416002)(2906002)(6486002)(6666004)(38100700002)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QlVZWEw2SDYrbUpBbzJLMUZYVzMzSmtKZjk2SG9vVEdkYWJaQTd6b2JpbnJQ?=
 =?utf-8?B?TjZaRUF6bXp4Si8xb1kxcUxKWW5YS2VRdGc2aDUyRUJXYWRtWmR4OGVpN3hv?=
 =?utf-8?B?SjQzdjlVVlBObnRIdWxvd203bFpmcWdTRTJuWWRibmlXb1lLWUd2QmFjVjNS?=
 =?utf-8?B?UWNnNk5BSlFhVHZsSjN1YkE1OWhiUm1FMWtlZC84RkEwZFhCV3pkakdYTnNi?=
 =?utf-8?B?V3dZcW1TUzNBSkl2VkNQTkM5SGJlalRHbTdmdlhKKzlseEJqWis2T010YVc4?=
 =?utf-8?B?UEs3MlRIVE9weExCYlVUWmc0dHhKYjUzQ0VsZUxkNklIRUhGMGtNcm9uYUVv?=
 =?utf-8?B?d1JsYTJ0YytuWE44TTJtbFV6M0FXUmdFWFpvQVh3WTI5K2RsbDBZQTBPMGVT?=
 =?utf-8?B?dVBOQUdPSFp2WHg1RFRIcmVoMDc3bFRKWVJpNmhyMVVvL1dYSFF2NTIvK1JC?=
 =?utf-8?B?dStSVm95VUh4YU1nREwzd2ZOYnRGWkdlNW5iRzk4SEpYTWQ1aGV3dmRNQU93?=
 =?utf-8?B?SkxPeHB5STFFZTJXQ2NmOUVTSEtCbG0wWFo0WlN1YStFYTVNWWRGV0M4ci85?=
 =?utf-8?B?akZRRWhLdkZmRzI5eUNlaHkva3hGWFJ3QWtTRUxiSzMwTmJlblVnRCttSXhY?=
 =?utf-8?B?cDVEQXRoS0I4MkM0R1VyOUNyWm5JMi9BSGJ1MExUTFdiMndnT0VPZHpaTnA1?=
 =?utf-8?B?U1lNaHJsZG9vVFJhUk44N1gxMlRLQ0xqeVpBSG9CRGF3Y3lLSitjdXY5d2hv?=
 =?utf-8?B?S2tFOXpkZm1EWGdjLzBjeW1xNVRmQUpQZXM5VGkwNFJscHZ0V2lUTEc5NUc2?=
 =?utf-8?B?NWFWT29COGFuUFJjU1NsQXhBci9mRnZsTGUvbnY5TlBuSWFQdi9VSmQ3Qmh0?=
 =?utf-8?B?cS9pam1ReGR2L0drUnFMRlp6dVF3Z2s2dGVKbkVKZUhoQkN4d0xtUlFQVmlE?=
 =?utf-8?B?K2dVcTQ1Rmt2US8wM2MvSDJPOGFIbzVNMzNHTDJ5SDFPWUlVU2RrU2xFR0Fs?=
 =?utf-8?B?L1kvMWVLMUNjVlVkRkU5Z0V4U1ZNbW5NU1lDM2JmOHp0bXBQTHdzT0dKY1pM?=
 =?utf-8?B?RHBwanVZV2xxSk04MEN0WGFvREZ6cm9QUXdvdkNTWDNBWE5IcHlUckN4bzIv?=
 =?utf-8?B?bjlXNXloQkRzVyt0MGlDN21oQU5sdG14QzZ6MW5oUFFHNXd1ZWEramUzVGFo?=
 =?utf-8?B?QlNhaGxCSXZBbGxkYzduSzRJQmRTVTRrVHVZTmtxYXRxL25nWG9oczNzTEpo?=
 =?utf-8?B?TXR1eFF0SnA4SU84ZjBBT3l1YnpCUUxrbzViSldHMVREOFBQVU5wV3pxS0Y3?=
 =?utf-8?B?eTFWVGZyVVhDd01KWEZqWTdvUFhhL2dodFlvcWh5S2ZBQ1JGdDIxc21HL1Np?=
 =?utf-8?B?L2taZ0FoNEZ5d2dQUEQrZGVZWDJPQnRhaXdnQTBGKzY5aEZtaFFxZExKdGpV?=
 =?utf-8?B?U3pjc29mc1VaMTJ2ZG9WSUNNZkhHS3R3RnAvdE5WNzQvbmVZdVQyUXMrMk9u?=
 =?utf-8?B?UnVMUDJIU3BQYitTR3BaNE1vaGY4N1RjTHJ1U3pKV3h0YXdkQzg3YnRBdjd4?=
 =?utf-8?B?WS9iRFBuUm5hVS9LaklDMlJpZ05SODJVV1I5bGZ4d3JyVFRJVForZHgzVWRi?=
 =?utf-8?B?UUg5bWpIVmU5ZnlnVSsxcjFGdnhaaWpCZldCNHYrSk93MytHQktRWTV5Rmcx?=
 =?utf-8?B?MlFvc0U1V2RzUlA1aHFCbjFDaE1XYTBGQUN4QU1TdmV3dDFuSlkrV2NjZXBC?=
 =?utf-8?B?Nk1HWG56Yy9teUc0TVJQc0NsRTAwQlJma0k2OUZhL0xWVmFla21WM1phUjVP?=
 =?utf-8?B?Szk5TnJpUWxYOEYxY21XV2Q2Vjd3R25lNXVnUjhtUy9Zekx2dTQ5bVdhaFhJ?=
 =?utf-8?B?UWp4aWQ5eXdPNWxocWNDWWh1RFo0cHhZeXdHUi9PNUtoRUpibGRWWGdJWURt?=
 =?utf-8?B?Y2twTW40anVuaE5jRXVIdkZVRUZSYUxZWGdBUUZHR1NNdk5aZXNKME14M1RL?=
 =?utf-8?B?TG1JZENTZ1ZkeE5TeUhvSmdRZHZNVWtlbHQ0emdoK2ExY1UrRlJYS3hrdFZl?=
 =?utf-8?B?Q0dlVDZiVm5lMDJHME1ROUhuOFB4Ym1uUUs5dCtFNzc5WlFuYVVqdkRFTWRl?=
 =?utf-8?B?RjRNaHArTERrOUNuZFpaZTBYZ1FiMG9rUlNCbmhuMkxOOUJIOUhzYmh5Umxl?=
 =?utf-8?B?MHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?aDV1aVplcU1wbjJKOStPeHFNZmJ6RDZQUWJxTkQycDdXNnNvdXpYSDdtNUhz?=
 =?utf-8?B?VE96UXJzbFJ0VlNMMU9TQzFnbXViNnhiUHU1NDJJR1JiLytGL2svRkt0MmNs?=
 =?utf-8?B?UTlLZHJORGROd1FMdUo1Nzh4Q210RzFhanhITVgvRDZZWlQydTRKVERSbUsr?=
 =?utf-8?B?ZnFJYmtjSFNia1hNRnI2WmRTK2FSMUZWYlJqS3VVc0tFQjgrd2FDNUdkR212?=
 =?utf-8?B?dHBoZWZzQytqNmdHcUJyck5TV25pVjZOWERVNVA4UXFSazBiamlpdHhSM3Vu?=
 =?utf-8?B?L05ROEVSMjVPeFVwb0VnaGdybHhlZElaWmJGeHY1eG0xZ0RzclRlQUNOUVM1?=
 =?utf-8?B?ZkhqVmlYZXo1N0x6NkQ0MzVRNDUwSzc0WmJGcTlLM1hYLzdsSHdPaER3bDFX?=
 =?utf-8?B?NEE5QUt3MG5aTDFydGV1M095WHc0cTVyKzZVNEpxYlFJOUFZblVSMG9pUlZW?=
 =?utf-8?B?ellrbmhNSUtIQXhxeUZ0MUM5bWUyT2ZsaDhwRGtRMkVSM1F1dGRPQnNOSE45?=
 =?utf-8?B?N1ZkaHp0Wk51bFJoTW85NUR6aXFtZngya0M0dktOU1JMMXdBWWhxUWlvcFdE?=
 =?utf-8?B?RFFrYnAvb2M5YjA3a1Zpbml3RGkzelgxbWhSRkc4SWxKeTRVMWlIUTRoMWJs?=
 =?utf-8?B?K1poUDBHTzd4d09aWTVwdytKaDkyelpjaGJNNFEvNWMxZEh6SzFYVVpROVg0?=
 =?utf-8?B?VHk2QXY5czhucEJUVTRKREEwSkpTVFE1dWNsSVRjNEphOEorWEIzVU5EVk03?=
 =?utf-8?B?N2hkak1pcXl1WkNlWnZPSlBFemJSUE55b2dQSUtzOGJ1dGVQZmhabnJGbTIw?=
 =?utf-8?B?djZmZVMweUxOUVhodmVvVkNOaGtzLzAyMnZkM2NkSXlqdjNUVmovTG1ZV3oy?=
 =?utf-8?B?MUdNWXB3MjBXWFVXV3NNY1JXNEx4b1dOblRVbTErWDFVNWRjSWVJbG5vS3dL?=
 =?utf-8?B?RjVJaWlEd1ZVUS9vY3pEQ3Rvci9HdDRJQTdzdVRlSG1uT3hGSDU4OTFRR1hZ?=
 =?utf-8?B?T29PTCtyTU5KcElweEFscStOL1BNSXJTNXdGR00rT3JNdVZMUGZNZjV6V2Rp?=
 =?utf-8?B?WFRNWmRtM0Y5Umk4MDh5Z2g5bVAxR1AyUVd2dkp3REVVdXE5SDRmMFlNWGJG?=
 =?utf-8?B?SHBtVStjK2J3K0ZIakZxQW5lSGs4dW1LaVFYaHJrYkIrTEpWc3plMGNkNHhJ?=
 =?utf-8?B?NHpvWWNOZlFIelVzVTBTcnJnSVF1Zm9PR0haNlJYKy9HWGlySFhVNW8xKysy?=
 =?utf-8?B?YTJlaUtFN2tHQ1M5c2wzemNaY2pqeGtEWlRxRDhQNEoxR1lkVTg1QmxQYnV6?=
 =?utf-8?B?bUx4dURsZiszWm85RTZEakxQSWFmOG9LRWRaTnhvNHpGaWlZQ1k0bmtwa0VZ?=
 =?utf-8?B?bXBnVnJWUm4zSWJzMzFkNkE3dEhLcWRCR1hzc2pDUGZaMjFNYXRCNk1KMDE4?=
 =?utf-8?B?dUpUbVpwR0FaREhFSVM3SWdsaFQ4OGN0QkU3NVZ3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a567ad4b-f3c7-40b4-7db6-08db584b7b8d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 09:29:02.4383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3tv5zqpiC25HIn7IBWAnXjVnEKi91R6BNvammtyjbz4wA3P4iid/Tx0TN3WWT4NLEsKgDuOh+Rk3wRlZNwh7nPcBTalflx2VEXhgcVHXDJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7682
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-19_06,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305190080
X-Proofpoint-GUID: _SRs4TnFapQ5ryTwYp4xBbVCg7AcOG5Y
X-Proofpoint-ORIG-GUID: _SRs4TnFapQ5ryTwYp4xBbVCg7AcOG5Y
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 19/05/2023 09:42, Baolu Lu wrote:
> On 2023/5/19 4:46, Joao Martins wrote:
>> Add to iommu domain operations a set of callbacks to perform dirty
>> tracking, particulary to start and stop tracking and finally to read and
>> clear the dirty data.
>>
>> Drivers are generally expected to dynamically change its translation
>> structures to toggle the tracking and flush some form of control state
>> structure that stands in the IOVA translation path. Though it's not
>> mandatory, as drivers will be enable dirty tracking at boot, and just flush
>> the IO pagetables when setting dirty tracking.  For each of the newly added
>> IOMMU core APIs:
>>
>> .supported_flags[IOMMU_DOMAIN_F_ENFORCE_DIRTY]: Introduce a set of flags
>> that enforce certain restrictions in the iommu_domain object. For dirty
>> tracking this means that when IOMMU_DOMAIN_F_ENFORCE_DIRTY is set via its
>> helper iommu_domain_set_flags(...) devices attached via attach_dev will
>> fail on devices that do*not*  have dirty tracking supported. IOMMU drivers
>> that support dirty tracking should advertise this flag, while enforcing
>> that dirty tracking is supported by the device in its .attach_dev iommu op.
>>
>> iommu_cap::IOMMU_CAP_DIRTY: new device iommu_capable value when probing for
>> capabilities of the device.
>>
>> .set_dirty_tracking(): an iommu driver is expected to change its
>> translation structures and enable dirty tracking for the devices in the
>> iommu_domain. For drivers making dirty tracking always-enabled, it should
>> just return 0.
>>
>> .read_and_clear_dirty(): an iommu driver is expected to walk the iova range
>> passed in and use iommu_dirty_bitmap_record() to record dirty info per
>> IOVA. When detecting a given IOVA is dirty it should also clear its dirty
>> state from the PTE,*unless*  the flag IOMMU_DIRTY_NO_CLEAR is passed in --
>> flushing is steered from the caller of the domain_op via iotlb_gather. The
>> iommu core APIs use the same data structure in use for dirty tracking for
>> VFIO device dirty (struct iova_bitmap) abstracted by
>> iommu_dirty_bitmap_record() helper function.
>>
>> Signed-off-by: Joao Martins<joao.m.martins@oracle.com>
>> ---
>>   drivers/iommu/iommu.c      | 11 +++++++
>>   include/linux/io-pgtable.h |  4 +++
>>   include/linux/iommu.h      | 67 ++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 82 insertions(+)
>>
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 2088caae5074..95acc543e8fb 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -2013,6 +2013,17 @@ struct iommu_domain *iommu_domain_alloc(const struct
>> bus_type *bus)
>>   }
>>   EXPORT_SYMBOL_GPL(iommu_domain_alloc);
>>   +int iommu_domain_set_flags(struct iommu_domain *domain,
>> +               const struct bus_type *bus, unsigned long val)
>> +{
>> +    if (!(val & bus->iommu_ops->supported_flags))
>> +        return -EINVAL;
>> +
>> +    domain->flags |= val;
>> +    return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(iommu_domain_set_flags);
> 
> This seems to be a return to an old question. IOMMU domains are
> allocated through buses, but can a domain be attached to devices on
> different buses that happen to have different IOMMU ops? In reality, we
> may not have such heterogeneous configurations yet, but it is better to
> avoid such confusion as much as possible.
> 
> How about adding a domain op like .enforce_dirty_page_tracking. The
> individual iommu driver which implements this callback will iterate all
> devices that the domain has been attached and return success only if all
> attached devices support dirty page tracking.
> 

Hmm, but isn't the point is to actually prevent this from happening? Meaning to
ensure that only devices that support dirty tracking are attached in the domain?
The flag is meant to be advertise that individual domain knows about dirty
tracking enforcement, and it will validate it at .attach_dev when asked.

> Then, in the domain's attach_dev or set_dev_pasid callbacks, if the

I certainly didn't handle the ::set_dev_pasid callback, might have to fix next
iteration

> domain has been enforced dirty page tracking while the device to be
> attached doesn't support it, -EINVAL will be returned which could be
> intercepted by the caller as domain is incompatible.

This part is already done; I am just a little stuck on a
::enforce_dirty_tracking domain op being done /after/ devices are already
present in the domain. Note that today this is done right after we create the
hwpt (i.e. the iommu_domain) without devices being attached to it yet. I had a
separate version where I create a domain object with (bus, flags) as an
alternate incantation of this. In the variants alternatives I implemented,
ultimately picked this one as it could other similar things to sit on (e.g.
enforce_cache_coherency?)

I can switch to enforce_dirty_tracking instead of a flag, but I think it looks
more correct to ensure the property remains imutable at-domain-creation rather
than post dev attachment, unless I am missing something here.
