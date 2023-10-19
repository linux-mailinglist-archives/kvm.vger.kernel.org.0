Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7277CF7C2
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 13:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345481AbjJSL7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 07:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345474AbjJSL7G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 07:59:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48213134
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 04:59:04 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39J7OPGw017202;
        Thu, 19 Oct 2023 11:58:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=A9sbHfdIVgV3eLNN4zIcRd69CuqMV/lm3usQ0UENWm4=;
 b=BAaAvsdOVGbuQkpYKh8Q3S9vm+VOcrpDrWKwHu/airgD8iWu5TAWK8tUfY3mc3t7j06f
 Y0IICMwsa7v/0eoBKH9FdjT1yj8AAYU27U9EqtWT6E+h8qg4V0Ae6ZGbLekJSUf5NSUY
 GB6g+R7y5ZyWuYT2ZH89NEihn6G/KuuYQ+ouNQvyxKB7YC/Kt7dlABU6sCMIwpIvO+dw
 fvWfDkp+76C65f7Ihe6NCM+Vuw/yLKyQCSISCmnIBWCugNVLNZ4fB657vL6yrMtYWndx
 mWZ/XcR4dI2sfkIS2eD4CBdhRR/Wv/kvV8oevWj1W0vYBviBD08+IKW8bDnNL2CKo8nt NQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk3jthat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 11:58:38 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39JAFZnv009836;
        Thu, 19 Oct 2023 11:58:36 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg0qmkpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 11:58:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hw8xjuW213d3t1W5iOMr3leqewIpVRFBGgyWOdQ5Sb7RC7nmMi2qd+MXoyMoxEa0e6UpKBVRRXKx6NDzJtUwmuIAezsa4hx/V9LNSNEl2tY15ol4hGNHjiONuvAHBztdxWILbkCfaZfTF9l3YAkh3MAoECSFxDBEZ22tJ9kcFPXy43mYcWra8JX/jCCAGmrUB20oApeNPBiC19eMyoNgRL2shV+sGfOMw2aWtJKCygIPF5aHpjgUlRZUYM9jWCTSbw+UFqjZpEZf+h4ZzlHaPxGQB9d+09gejmvtfJS6Y7Mm+wYo1/EOo+YFuNFVBiz1QNK22+7swsPio9ydXWpTkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A9sbHfdIVgV3eLNN4zIcRd69CuqMV/lm3usQ0UENWm4=;
 b=bcvkZtQUuPQr1VT4cuSl2uio2PXEllFMlcZmQTmZyjR9Y2DIGXZ3xfY+ZN9gF3/L85F2wGEY59/h6ktDREi0V32ocu72m2Uzih7ECmvtTyOKM1kM+JMT9PgVxLH0PZwIgdIQtO0CMtC61oJO2h8y+cPlwsYyDRYR+AYk1PxjCdhlK69S50aZkCXYNcNqjYDGUSWXpwv0cHzkyigbTLaydMOZKCXH19ABd69zKRogtS8/carvRbVmzt3ZHeu53Lv3jny2PzqZ5HiwRF3mKjsxkBSFNYlm2fGImLweZuyELLbeVvbkIQGQKVq8UEJPl7iPGJHqeUdJdGfFWaQrJw4gFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9sbHfdIVgV3eLNN4zIcRd69CuqMV/lm3usQ0UENWm4=;
 b=SzgzrZSW93/iXNAf76xREekZU0bguq8+vvdvXSmsTcnswhj64lrMU1myDz4CIBI08IamRPpmPE5oytHd1yNypDHpHXnS6HqCbnkuY9cZ184WD6N3RoaVQl0YO5+B9ZBr3WSURfcRMwKgTOi17jzxiW871YGAS809qfeMie5gIVg=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by IA1PR10MB6145.namprd10.prod.outlook.com (2603:10b6:208:3ab::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Thu, 19 Oct
 2023 11:58:34 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.025; Thu, 19 Oct 2023
 11:58:34 +0000
Message-ID: <f2109ca9-b194-43f2-bed0-077d03242d1a@oracle.com>
Date:   Thu, 19 Oct 2023 12:58:29 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/18] iommu/amd: Access/Dirty bit support in IOPTEs
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-12-joao.m.martins@oracle.com>
 <20231018231111.GP3952@nvidia.com>
 <2a8b0362-7185-4bca-ba06-e6a4f8de940b@oracle.com>
In-Reply-To: <2a8b0362-7185-4bca-ba06-e6a4f8de940b@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR10CA0020.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::10) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|IA1PR10MB6145:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b1157fc-9377-4c0e-643a-08dbd09ab8a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tsmk36fzagO6DKM9xTlk+TT+q6AIhjyjddI52G9+nvWcrKKYpqK8mroYOZ8VSbGEqzTkdhsDUUPrjYrVtnfqHelBH5j8uytsa8aqPKM4MQcRgB3pl2IbyLzyTw5tNPcaZcMvkMSs5TFt+4+OQXbyWLotRBgYm412tY6cw+yssOE8yKPRgJ0smWiuA9+arqUQKCD4+FZ9iFcKQjZlDQAeQ3lbWjxqk+OstxaPYGnT4RjRH4NdyHBfnQoVxr7E69AnwQ7g0VEgAuQjQxlQVtB1Oh8PiBroAEuf5dl5rKZx7vjIy0z7/4Jj0mTY9so2FuEZjjvqvGNT6I1/Kqrmmn8/oRe+5kjasb5hCJy5IdROX8wYYLPX7/b/nHYszK1W92wn6HjMdNOS4BVu3RT0p6oD3DmDLR0L4I6GcHGmEGvx57SwRCbHDEFrIgkyhuoDzAb6XXkAiuxFaVZpihNfd2EJ8OiJGrX66KTvvD6R+TrqkpLs15OebJo5HQ/77VwRtnx20Sa2mpprC9UrBPGgzrv1N0EdXCZlKT8xtOdG9Ba/EsREub/HhpJJLztwUb8IoIPK4ep//bj/zJf9On5M835PPk2hiAHBdwzpKn5hCJi4gNbxQlcCh1DB0X86ZUhyjFyk2CBKquxl1UY/ZkOroiRjuGL9vW5/z7vh0u6Q7Rulqq8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(396003)(39860400002)(366004)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(7416002)(4326008)(8676002)(8936002)(38100700002)(41300700001)(5660300002)(86362001)(31696002)(2906002)(6506007)(53546011)(6512007)(478600001)(6486002)(6666004)(36756003)(2616005)(31686004)(83380400001)(26005)(66556008)(54906003)(66946007)(6916009)(66476007)(316002)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RjkxTnNLNllKR2VUMW5QSzRCd3M5R1VmM0loVktsVlViblpLaHc3bG1zbVRo?=
 =?utf-8?B?VEZHSW5XVC85MmcxcHpKWlBXVmdZRFQvdDI2RE9VR3ZqYXRPZ24xY0tYUjZV?=
 =?utf-8?B?VEgxZTNNeUx3Q2hlMUsyRGIyWDdEUWREZUdSVHk3eEZqYTVnbGhDSXNIMm9n?=
 =?utf-8?B?dWhtdGl6cU1qVHdZNkVzdHpxREFwcFg5TGcyclpHOWtyMkk4WHllc1NaYXY4?=
 =?utf-8?B?MXhHR0UyNzJ2Z1h3K2NkVTRBbFhHd0pPeFQ4aFFpb1phTm9RbklZRVF4dklm?=
 =?utf-8?B?RWx4aTlTajJ1N1RWaWdWN2I0MmN0aWFxSEhXaENCQ1pGZmtlcjNZcmE2c2x4?=
 =?utf-8?B?eEhLSHVxOU14MU9SejJjcUluV0dOTTN3Y3dGY1d3a09zMFpjVVRlUmtDdW1Q?=
 =?utf-8?B?UklodktPZEQ5SldiOGNkTUp3R2M3NllJcUpUekxFbEw5VGRBbFp6cENHSWl0?=
 =?utf-8?B?N3o4TGpnbGtqNWdFVlZ6SjVNK1FBYVN3NjFTMWI2V2lEU3hXcUljdm1abFBW?=
 =?utf-8?B?M0VsZ1RZbFlyb1NzenZ1dWZlUHVNcXFQdldZS2wvSkJWYWpsWXBsSVB4YzN5?=
 =?utf-8?B?UVRoRVVHak41eVplWXAwZFROZmwzRCtUb3dSWkFDUmRkeDJ4U2ZNcFphaS9R?=
 =?utf-8?B?NnZUYk9ydHBEN015c1VXRkpkNmo0OGdHSUZxWTdSTkNKSmxpSkpmcG9EVS8w?=
 =?utf-8?B?TGY0STZCbEh5VjlyYUUvUHRhVmpQVjFFckdUN0F1NDZQVDNWN1dnTHk4L0xi?=
 =?utf-8?B?TnNjTWg3VDJta3d0WEdFOEFMelk1OTJtWE1Ub0h1UXVnZEtNWXNJdXpCTEMv?=
 =?utf-8?B?Z25PSi8yNEFBeFNsRkZHSkxsMmFGWGdTaExmWWUvazBKZDl4WDdTanZLZXhX?=
 =?utf-8?B?UUtDaDB4RCtWNUo5OEphd2hZMCtSK3NDTzhIdkVWOWRGNlNYSmFjZDhiNS9n?=
 =?utf-8?B?QXlrVVVtTXgzLzJORm1Cc0pYY214Q0NjYVVqeUs2QVpnZ3FoUUFyYlpNYTIz?=
 =?utf-8?B?S2VydXZQekxZZzBRRUMvVjIreWhib3lLU1h2T1RTd1RSYit4WWovZXRtRDlF?=
 =?utf-8?B?OGlwd1F3NUhlcjRCREZqNUJoU3JFMkRjMGZvNnUwcjZZbXFoMHpIR1FPeGFL?=
 =?utf-8?B?SSt3OHdUSEJET3FRVGdMaERGQURWRENFc3R0M25UeUVsQ1V6N3dhd0d1eWlt?=
 =?utf-8?B?US9FdStrR1ZlcHRvWUVScVZSbUhQZTZTVUh0ZXJmQk1OQzRLY0RPck5kcGVQ?=
 =?utf-8?B?cjFwKzdTQldPSmk1MzdHOEh5VGF4RkF2UkVRQ3RKaGE1cHVmYWl1eTIrYys5?=
 =?utf-8?B?Y05ranVsYmNrb2tZS0p3TnZYKzdiNFZKenZIaU9HclVGRjZpc0tRQnFEc2J1?=
 =?utf-8?B?L2diSUx4ZnRuTG4rQUF2Z0o5aFJxaWRQUk8xUWFwb1lKNDZyOEg4bkFqY1Jo?=
 =?utf-8?B?UWtxVHlQWHlZSTh1YkdVaEZwQ29WNE83MWViZU9XRHhJSDB3K0JVNzhVekpw?=
 =?utf-8?B?a1dUblg5VmM3aFpqdHBMR0U4bHRQWnR2Qmp5MW1xc01rK1lJYUx2WmlWU2xp?=
 =?utf-8?B?TEZHVzlpbGduRnVsUDRwekllQThFK0oza1I0M3NQVFlvcm4zV1RzZnVyN0pV?=
 =?utf-8?B?cWlHck1DS244N3JMQXpZVzQremdYWjJ5VmgvekFJdHkzNlJkdDA2b2ttRU4z?=
 =?utf-8?B?WHpQMm42UWpWMitISk9ieXI0bi9TRmpkdWdKMFBJR1YyVkhBWW01NGl1Q3ZZ?=
 =?utf-8?B?S1hEeXQvYUl6dG4xaUVTaUN0M3RDQU44NWxTUHJiN05iUVRhLzhBdlhqZnI4?=
 =?utf-8?B?NFhoaERncko5NGsvbjR5L1EydDZjeWJkVFZhNWpnT2xqWnNzTmM4ZVA3MG5h?=
 =?utf-8?B?a3RJdFBjQlE0VVZEdUh6a3ZVZUJXY014ZDB0bC9YZUI5N1VMd0ZsaUs1QVdW?=
 =?utf-8?B?czVtWURsTlUxWXg2VU5jZEhGQ0N6NFdBTWFSS3lMQWVZMm5OOVRibGhOdEc3?=
 =?utf-8?B?UG0wemU5TVg0S1VPQytScDZJUVdUR3pIbGNSbGs2bzRXOUgvWmUrYTVvY3Ex?=
 =?utf-8?B?dUlZRTVJSkFvT29TKzNBNlM4ZERRVGR6ZjFFNS84b2RPSHFSRjVLRDRsdVZX?=
 =?utf-8?B?YjNUalVsdzQ2Y1Y2MDhpZ0E2QWNweFZoLzdKYTQrS1VEaFR6NTUrYjJQTURn?=
 =?utf-8?B?Rnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?U2FkY3I1cEtGSGNYRjZRRUxHTjNjUlVveFJ3YXh6cmp0UlQrWFFsOFlBNEl5?=
 =?utf-8?B?OFdobXZXaUNVSEpQbnBkZDdWSXN6dEJUK3pXRlk0Zy9wbFgzT3g5SHdQRUUz?=
 =?utf-8?B?WEtVQlNOcEdFQVNBUHlRUTBteWgxZVcyRkhkeCtZbkthckZkTElwVFo5VWhS?=
 =?utf-8?B?SXNqZFY4WHNTbDJKUjY0dHZXdEhibG5mbWJKQXkyNzkxVi94MkZkc0dQZ1RN?=
 =?utf-8?B?WnVSdXJxcksySWN6cFVhOCt3L0pRM3FOOGt3QllSTUJ6R21pTTZjcHlpOVZx?=
 =?utf-8?B?MXZvV0pXa1F3SDZNSTVaSVFkUEEzZnZhMWRWa24yb01tYVhxL3pyUnpVdkQ4?=
 =?utf-8?B?a1Fncit0NTcxcWpVd0M2TUN1ZUhNYUlWd0NqbmNQcnlGU01WTUhCNW1MWjhF?=
 =?utf-8?B?S0JscDdoWEluejBQc0w0eDNXS0R5U1NCQ3dhdGZHN0ZPUldaaGoxTHVHdUdw?=
 =?utf-8?B?My9UZm5qcVJZdXZrTVhqMVZ1ZWdpWHRqR21TSU8rcFdxaU9abjF1RDhNTXV2?=
 =?utf-8?B?M1A2WFk5NjlsVDlrT2NUMjlpNGZYS0tLMzVyZm1ieXlCcEZjTmpUeXVGVHVK?=
 =?utf-8?B?Y0Z3UkcwbWJmeG5GMXc3WnA2ckpVZjRQRHZqNk1zaElONTFlYXA4RGR4aklJ?=
 =?utf-8?B?THN0V2ZtdFE1T1QvUFQxeEw1TCtBNmU5NFQ5K09ONFZDeEZseVYydXZObDNZ?=
 =?utf-8?B?ZXZrSEd0VFhJSHowU1pna1dwaDhLV3ErK3luZ3FreFptMEVxMnBGQ1U5ME9K?=
 =?utf-8?B?RGs0MDRrall0KytQTVJjT29vandWckNWOWErdXBJeEpDRGtQQ1J3dkJUUkJO?=
 =?utf-8?B?Y3dNZXU5NWtZL0lFN2VuNE9TeFNGem9Od2I1N0d0TGNNMUVDN3lvTnN4U1JZ?=
 =?utf-8?B?cjE2M0k0aWg1aDcybGtIOTVYOW9WUnNybnFWRyt3VmFrRFVmdWxhS2hQYnZ6?=
 =?utf-8?B?aENsckFGOFNlaSswS0ZQc1Q5Rjd6UzJpWmFMMUdNWCtsUXJSSnNjWmhPdU5W?=
 =?utf-8?B?c0FEV01pSVl4TFFXVDEwTWk2bWpudDhESUNwdzBtcDFYRVBVditwcEc4ZDBl?=
 =?utf-8?B?KzlaMlRpRStuUlhsTjhpakxCYmdERnAwYWFBcEZRZkxZK0FiaGdScXpmVW4r?=
 =?utf-8?B?bVRYOVB2c1hUWlJ1YU5pWUoxVGRjNWlxaHVZazZIWTJHd1Z5RU5XeFF2azRp?=
 =?utf-8?B?dkhHV0I0bFJOZjVjd2lxSjV5ak1DankwczdJSGhPQ1JQRWEralU1ejUweWUz?=
 =?utf-8?B?OWcwbkM5WHNTTC90VmhpSmpuMHZ2SjJoV1NtSjZHYjlvS2RmUVlIbTVyYVZz?=
 =?utf-8?B?ZGZUQUFGTW1ONDZYbXpRMU1mZ2tCemh3WCtNQmlLMHBRQkJ4Q3E3NEhoUmhI?=
 =?utf-8?B?cmphTmRDTEpnTFdUNElQSy9GaEFiT2MvdTkzLzgzVmxjRkxkNFI5V1FENU5t?=
 =?utf-8?Q?F/KE2Qhf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b1157fc-9377-4c0e-643a-08dbd09ab8a9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2023 11:58:34.8601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZidUIO8jT0tVAbeLjznL1kPiphCqBAj77HJlnLDS+d4fhHruxo9ZCLMVyXU2ZOoYhhef6ysUzEy5X0b4WJHd4NlUbV1WL8W0w1Es7poxpMA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6145
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-19_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310190102
X-Proofpoint-GUID: aQFNmPrTsHVRGFYWlQyiUoqCF13AYQuH
X-Proofpoint-ORIG-GUID: aQFNmPrTsHVRGFYWlQyiUoqCF13AYQuH
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/10/2023 01:17, Joao Martins wrote:
> On 19/10/2023 00:11, Jason Gunthorpe wrote:
>> On Wed, Oct 18, 2023 at 09:27:08PM +0100, Joao Martins wrote:
>>> +static int iommu_v1_read_and_clear_dirty(struct io_pgtable_ops *ops,
>>> +					 unsigned long iova, size_t size,
>>> +					 unsigned long flags,
>>> +					 struct iommu_dirty_bitmap *dirty)
>>> +{
>>> +	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
>>> +	unsigned long end = iova + size - 1;
>>> +
>>> +	do {
>>> +		unsigned long pgsize = 0;
>>> +		u64 *ptep, pte;
>>> +
>>> +		ptep = fetch_pte(pgtable, iova, &pgsize);
>>> +		if (ptep)
>>> +			pte = READ_ONCE(*ptep);
>>
>> It is fine for now, but this is so slow for something that is such a
>> fast path. We are optimizing away a TLB invalidation but leaving
>> this???
>>
> 
> More obvious reason is that I'm still working towards the 'faster' page table
> walker. Then map/unmap code needs to do similar lookups so thought of reusing
> the same functions as map/unmap initially. And improve it afterwards or when
> introducing the splitting.
> 
>> It is a radix tree, you walk trees by retaining your position at each
>> level as you go (eg in a function per-level call chain or something)
>> then ++ is cheap. Re-searching the entire tree every time is madness.
> 
> I'm aware -- I have an improved page-table walker for AMD[0] (not yet for Intel;
> still in the works), 

Sigh, I realized that Intel's pfn_to_dma_pte() (main lookup function for
map/unmap/iova_to_phys) does something a little off when it finds a non-present
PTE. It allocates a page table to it; which is not OK in this specific case (I
would argue it's neither for iova_to_phys but well maybe I misunderstand the
expectation of that API).

AMD has no such behaviour, though that driver per your earlier suggestion might
need to wait until -rc1 for some of the refactorings get merged. Hopefully we
don't need to wait for the last 3 series of AMD Driver refactoring (?) to be
done as that looks to be more SVA related; Unless there's something more
specific you are looking for prior to introducing AMD's domain_alloc_user().

Anyhow, let me fix this, and post an update. Perhaps it's best I target this for
-rc1 and have improved page-table walkers all at once [the iommufd_log_perf
thingie below unlikely to be part of this set right away]. I have been playing
with the AMD driver a lot more on baremetal, so I am getting confident on the
snippet below (even with big IOVA ranges). I'm also retrying to see in-house if
there's now a rev3.0 Intel machine that I can post results for -rc1 (last time
in v2 I didn't; but things could have changed).

> but in my experiments with huge IOVA ranges, the time to
> walk the page tables end up making not that much difference, compared to the
> size it needs to walk. However is how none of this matters, once we increase up
> a level (PMD), then walking huge IOVA ranges is super-cheap (and invisible with
> PUDs). Which makes the dynamic-splitting/page-demotion important.
> 
> Furthermore, this is not quite yet easy for other people to test and see numbers
> for themselves; so more and more I need to work on something like
> iommufd_log_perf tool under tools/testing that is similar to the gup_perf to make all
> performance work obvious and 'standardized'
> 
> ------->8--------
> [0] [hasn't been rebased into this version I sent]
> 
> commit 431de7e855ee8c1622663f8d81600f62fed0ed4a
> Author: Joao Martins <joao.m.martins@oracle.com>
> Date:   Sat Oct 7 18:17:33 2023 -0400
> 
>     iommu/amd: Improve dirty read io-pgtable walker
> 
>     fetch_pte() based is a little ineficient for level-1 page-sizes.
> 
>     It walks all the levels to return a PTE, and disregarding the potential
>     batching that could be done for the previous level. Implement a
>     page-table walker based on the freeing functions which recursevily walks
>     the next-level.
> 
>     For each level it iterates on the non-default page sizes as the
>     different mappings return, provided each PTE level-7 may account
>     the next power-of-2 per added PTE.
> 
>     Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> 
> diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
> index 29f5ab0ba14f..babb5fb5fd51 100644
> --- a/drivers/iommu/amd/io_pgtable.c
> +++ b/drivers/iommu/amd/io_pgtable.c
> @@ -552,39 +552,63 @@ static bool pte_test_and_clear_dirty(u64 *ptep, unsigned
> long size)
>         return dirty;
>  }
> 
> +static bool pte_is_large_or_base(u64 *ptep)
> +{
> +       return (PM_PTE_LEVEL(*ptep) == 0 || PM_PTE_LEVEL(*ptep) == 7);
> +}
> +
> +static int walk_iova_range(u64 *pt, unsigned long iova, size_t size,
> +                          int level, unsigned long flags,
> +                          struct iommu_dirty_bitmap *dirty)
> +{
> +       unsigned long addr, isize, end = iova + size;
> +       unsigned long page_size;
> +       int i, next_level;
> +       u64 *p, *ptep;
> +
> +       next_level = level - 1;
> +       isize = page_size = PTE_LEVEL_PAGE_SIZE(next_level);
> +
> +       for (addr = iova; addr < end; addr += isize) {
> +               i = PM_LEVEL_INDEX(next_level, addr);
> +               ptep = &pt[i];
> +
> +               /* PTE present? */
> +               if (!IOMMU_PTE_PRESENT(*ptep))
> +                       continue;
> +
> +               if (level > 1 && !pte_is_large_or_base(ptep)) {
> +                       p = IOMMU_PTE_PAGE(*ptep);
> +                       isize = min(end - addr, page_size);
> +                       walk_iova_range(p, addr, isize, next_level,
> +                                       flags, dirty);
> +               } else {
> +                       isize = PM_PTE_LEVEL(*ptep) == 7 ?
> +                                       PTE_PAGE_SIZE(*ptep) : page_size;
> +
> +                       /*
> +                        * Mark the whole IOVA range as dirty even if only one
> +                        * of the replicated PTEs were marked dirty.
> +                        */
> +                       if (((flags & IOMMU_DIRTY_NO_CLEAR) &&
> +                                       pte_test_dirty(ptep, isize)) ||
> +                           pte_test_and_clear_dirty(ptep, isize))
> +                               iommu_dirty_bitmap_record(dirty, addr, isize);
> +               }
> +       }
> +
> +       return 0;
> +}
> +
>  static int iommu_v1_read_and_clear_dirty(struct io_pgtable_ops *ops,
>                                          unsigned long iova, size_t size,
>                                          unsigned long flags,
>                                          struct iommu_dirty_bitmap *dirty)
>  {
>         struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
> -       unsigned long end = iova + size - 1;
> -
> -       do {
> -               unsigned long pgsize = 0;
> -               u64 *ptep, pte;
> -
> -               ptep = fetch_pte(pgtable, iova, &pgsize);
> -               if (ptep)
> -                       pte = READ_ONCE(*ptep);
> -               if (!ptep || !IOMMU_PTE_PRESENT(pte)) {
> -                       pgsize = pgsize ?: PTE_LEVEL_PAGE_SIZE(0);
> -                       iova += pgsize;
> -                       continue;
> -               }
> -
> -               /*
> -                * Mark the whole IOVA range as dirty even if only one of
> -                * the replicated PTEs were marked dirty.
> -                */
> -               if (((flags & IOMMU_DIRTY_NO_CLEAR) &&
> -                               pte_test_dirty(ptep, pgsize)) ||
> -                   pte_test_and_clear_dirty(ptep, pgsize))
> -                       iommu_dirty_bitmap_record(dirty, iova, pgsize);
> -               iova += pgsize;
> -       } while (iova < end);
> 
> -       return 0;
> +       return walk_iova_range(pgtable->root, iova, size,
> +                              pgtable->mode, flags, dirty);
>  }
> 
>  /*
