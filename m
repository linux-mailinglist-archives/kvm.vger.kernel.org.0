Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16337CC1B3
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 13:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234422AbjJQLXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 07:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbjJQLXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 07:23:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0751EA
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 04:23:06 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39HA5vCq000753;
        Tue, 17 Oct 2023 11:22:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=AoaDBZRQGNdwBMdyyj4cjZ20XmtbcZF5tf0rCVZlyLA=;
 b=duzJDRAVykasSQC9gqwOmMkCZKcAdKbZFpV9CKCeDw5Kcf3ZfcJp7a7RymxehvpMYSoB
 IZAgD3+GJAPZE+n2Y7w10lv1XohgmYa58dzgoLzd9eyAATGGPHe5V0FBS9Xwxe+3jHBW
 DcK6n9aJ+O7oGbinJM0MT9weMa3eLrBcNf0QBxu4OR6OKUo4Ruj5/M1qiWDS7/ZOliTr
 b+mBFwEDQNoFSqnZR5bcJ7anWzT088/tGsGjticPRky2Dz85fsiKSf75RjYOkY8y6Dp0
 qRpz8WrjVkTOlDSPGwqUhqA+igk+gBf/r1e4XiXoDHY1416Epu3CAxA611nQbjIum7rc RQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk28mxx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 11:22:43 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39H9cfji040745;
        Tue, 17 Oct 2023 11:22:41 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trfym5h83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 11:22:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BdnDVdx2N4AvLO0Uxxv05y2pgJIehefFrSZ9bIUi9skn/0FZGW0U/rr7NXhzp7cASrEB+daVh6bxCOtgAqZuf2exfXiwiyOjr7uUwBXQjZ+bsgekNxgV4IEkr/EpLUtKPcPduqbC61LYVqaXEGElQK/M/fqIRACHZdiT7S9cr1uX8t1UHefMfK1Zo9KD5rBxrZsMKORhgn/0jszweBuy+rOruIT7kxU+689crYoMBTm4K6BBolX1hV2iYFeIvAkE6Qyg5a9WvFql+03TbnLMm1mA8S8yAiylWbhlHywmh8TuFOZc3dA/Pxy/Z8bY67MyLOogiYiDbGwko8tqtzVTfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AoaDBZRQGNdwBMdyyj4cjZ20XmtbcZF5tf0rCVZlyLA=;
 b=YcQkxqq5DDDwgjc+BA5TcVPyeV+ravqjMaEuEzn3HohGRaAiFBTQQ2pkGT300vR6Os5aYLEiUBnpx/zwsOB9ayhYz1rwUkFWAmGQ13ofugPWen8PLvBwl9tNKKovYKXaRNTPAUtL3CZnVA+iinKb4sBYX/AzBCAgCCBmDlQ1wioag41nQriNxzQPqE9V184GAzAdvtow7ojg1vFrL2xczUdk3oqfmYHTVNdvupbxmDfTqdf59TQJTvHzoLGkQHZHuxGHWJzhkyc3udgMwbLepHkCGxto6KSUQSRIjZcqQe6XbldyaiAtBIXlqcNXi0Yi5kOUlb+bRtEAdChWrai7Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AoaDBZRQGNdwBMdyyj4cjZ20XmtbcZF5tf0rCVZlyLA=;
 b=m8TiGO4F8bERUNy/0DFSKEyOw5cz4oyAmCxY5NUIPzwmqU/oXbKGPF+FvF5htZZXxGPWFVuESEQNTOl2oRyx9XxJu6NdJFgELDKuxLLe/8PlZ47JpyjJlyg4Skc7+v0vf1gb1uUEzaq83V19g2MBmHI1P7pbG/OQJksJbjGzPEY=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by IA0PR10MB6794.namprd10.prod.outlook.com (2603:10b6:208:43a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Tue, 17 Oct
 2023 11:22:39 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.038; Tue, 17 Oct 2023
 11:22:39 +0000
Message-ID: <e797b35b-6a17-4114-a886-95e6402ad03c@oracle.com>
Date:   Tue, 17 Oct 2023 12:22:34 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/19] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
To:     Baolu Lu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-20-joao.m.martins@oracle.com>
 <d8553024-b880-42db-9f1f-8d2d3591469c@linux.intel.com>
 <83f9e278-8249-4f10-8542-031260d43c4c@oracle.com>
 <10bb7484-baaf-4d32-b40d-790f56267489@oracle.com>
 <a83cb9a7-88de-41af-8ef0-1e739eab12c2@linux.intel.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <a83cb9a7-88de-41af-8ef0-1e739eab12c2@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR03CA0077.eurprd03.prod.outlook.com
 (2603:10a6:208:69::18) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|IA0PR10MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: 50176a16-d517-4351-451c-08dbcf035f50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 77Ymgv1pjUoE/Hq6+1lN6hSAEHtizxMBnAyi+ufcakTI9ZniaVeBoSf7tioXTg4IRv+rjvykG0GUUb4WUk8vaFEEAQ4++5Ia4JiSpuwQ/g6JZbKxKKqvDOGWSqtRaol4HMzmkv0ZAkBqfwikHe/NBZAuYTZC52EdNsp0Q3PQu5Shxuq8ipsoEd3W4quLXEP04xjgx8UnhUT1G62Xe2SmPGHGTvbyHTbxY1PJZPs9DmWT/htP6adIklHKqjcytlRM6p8Gv3/CrFzY/uRLEmmfEgnb+EAbeW7w/MMtNndtkwRPZZoHR7IyllkaPaPqE/dJzVSjE8CQffytUzRPWFTGKeKQChKxqtWI3VIgoCoVedQMPEfd+dTo+qGasnnE78QXxNuV6tj+mbAQyU+Prl8YXpK8uRIysYIpmBPcic22pSIBruI84XB9PJDIbOxtGvBaI0BcEh0zhdrGXEJoQdqUD4iTJ86W3dcWp4aCVdiRpTeMcWaQMo6f6yaq6rkRqX8YmrIr/d7u/DkEcqf/nArEjqdZfXhmFhKM6Lvg8dFXGXYJlvNnG0xBpZwDa/azIk5Ungmu0VkQSoPLMfPWfydogX6qbWna49XmsSPWI6k+EUlUDMv9rWY2cT+BMDyQNbfuq3BzALM5xb3nF6UNkZ/yUb0ltYP7I731RvjWPpwIjhk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(366004)(136003)(39860400002)(376002)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(31686004)(53546011)(6486002)(36756003)(38100700002)(83380400001)(6666004)(6512007)(26005)(6506007)(2906002)(54906003)(66476007)(316002)(2616005)(478600001)(66946007)(31696002)(66556008)(7416002)(86362001)(41300700001)(8936002)(30864003)(8676002)(4326008)(5660300002)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b2dBTmd2WGNEWnk2ZGY4RllTdDNyZStYM3hOcG1ISDM4MmVPOHBWN2s1a3dK?=
 =?utf-8?B?cDNDWWplbG9sMUdPeWVtQjBwTkhvTS9TT0VGVEhIaUhkaDQxTjhPZFRHbmF0?=
 =?utf-8?B?R1JIWEpteGk3UVRUVnNSQ2UxbjZxNFpaZ3lRU3ltZ0FJY2lsd1lOVzBldEVq?=
 =?utf-8?B?VVlhWktiYTlrbFJydkFiM1VqV3pJOWRJRlBtL0JQMHhrNnY5SGx1QThHQjdR?=
 =?utf-8?B?RGQ0TTB2clhmSmZYRVc2MjJBMG9GR2QvRzNoVGIxWlNnK2diMm1NNnZYSEpm?=
 =?utf-8?B?UmxaQWNsRk95ZnlZUDAyVW5jWThteit5azU2RmszRi9WbVlTZU05R0doOG9x?=
 =?utf-8?B?WHFOT2ZMMWtQU3BwUERRcCthWCtlY3lhNFhGRVZHWEhxV1VlbklReFlGVE5m?=
 =?utf-8?B?a3hNWkNtMytuV2hhbVVTNk41SEVaZXdxWnpYZU9STmpKVUVpYWZsOEJIUVR1?=
 =?utf-8?B?SXRpS0t0S2FXRVNoMXVZTHVUblF0R1pqRHpQdVhZcWR6Mi94MkU1R0tQQ3RF?=
 =?utf-8?B?dUkvTkZKQjJzRkk4VUp5YmEvc0ZVSWVIVjgzamRJM0loNzY0SGcwYzlSS1FL?=
 =?utf-8?B?bE5MZmQ3aHZLR1VlREtEbnZYeEtvQ1o3YnRiOEpzSDd6a3hPNWhZRE83ME1L?=
 =?utf-8?B?VmNsSE1TeUgrSXRmZ3F2ZTF5Z0FLeE9Ib2Faa1hpYlNDQURyQmlFSXJFVFJj?=
 =?utf-8?B?OXZWR08wRUF3cXc0ckw5c2FzS0IxM0xORTVRZW40L1BWN1Y3T2VoWGN0bkFH?=
 =?utf-8?B?b1RSYlpZOVZGN0pXcUJhOHErTjlmZUVvUHlPRHFqZ0pqOURrRnNZRlhJMzlM?=
 =?utf-8?B?U0pSN1VzTkVMTklqZDZzNFhYa0RmQWw3eEduYUZSTXY1VjlWN3dRMjI0akQ0?=
 =?utf-8?B?RjlIWXIrbEhabkZtUGZVRFpuY29pT0hUektQcEhuNGhDYnlyV1phSTgxc0pa?=
 =?utf-8?B?YUk0YTlRNFR0djBuajRmcDA4b21lc1NEZVJzK0dlTzNVbC83eWxjclNxbkNP?=
 =?utf-8?B?eElEZDVrYTkzNWllWUN1RS9jdk4xWDByeDBxUEF1YkwvMG01aUZOVXVnUTdF?=
 =?utf-8?B?UE5RUWx5bzIyeWJoSlhkVVhUaGdxUlJFMnFtWk5HYkkvdlh1eTdJc0lPSUlq?=
 =?utf-8?B?ZjZraUdnN0FZcG03eU9zaXJ3ZWZ4dGdoeHMvWksrSVZ3dzVGOHRUUnp0ck9C?=
 =?utf-8?B?dkQ0NmJLbDJOSmFIb3pBN0Q4a3Q0c2xVemh0bTA5MkZCSTM5am9BRDFVcG1Y?=
 =?utf-8?B?NkdKUm04by84ajZNd0tGOXRuNkFyaVQ3U3c1d2JzY1N3NnZJZU1RbmN2SHM5?=
 =?utf-8?B?bFVwcTg5WDVKdmg0Sng4MkhCY05rN3JNb1VyeXNLYSs0MlhNRGd1cFZUTGcw?=
 =?utf-8?B?WUNpUG9WUU4rWkY2MnNJc2I1eStWTDlHV3RZcWhXREhRNUNoRDlEVnV4Wm9n?=
 =?utf-8?B?T3AzSk9McUJ0RmxoV2IxZGd5RjhrRnJUbEQ5NzVyd1krSXJOYm9XUXBwblBm?=
 =?utf-8?B?bzFsY3RXeC9adGlIdWlXQlJTNU9pUmpxd2tja0IweDQ3UW5yNXNpWmc0c2cw?=
 =?utf-8?B?LzBhSVZhREtlRmxaWXhFeHUzVmFlUHFiNStma1RFTzNrb2Rab0pEVVF4QWFt?=
 =?utf-8?B?cjlvbXU3cm1lYzJkbUZnL0NBY0thVGNPZjVYUGQ0T2xhNUNFL1BmRDNXWW9j?=
 =?utf-8?B?SlRTWDBReTZSVmdjdkNDUTZ4L3NpNmJRaHUwa29jeTA2OE9QS2RheHZOL1Q5?=
 =?utf-8?B?UHlySDdFNzhtaGR0b3p4d3N3b1F5MlJzSVhQcjB4MjJPdlovT0syTVFmanBT?=
 =?utf-8?B?cWo5cktZYXIxc3hxWUNxSVhSekdKMFhmU2lXN3E4VzdFemxWMmp3SzlCNDRD?=
 =?utf-8?B?cUhrajFxeW9FL0ZndlpvdWhJWlNMRTA3Y3BFMUhuL2FtWkZZd0RsQk0wRFFS?=
 =?utf-8?B?bzJjbVI1RWRvaHF6NXdVVXFpNTU5c0piWHhOOG16T25iT2lYeW92VlNVcFVB?=
 =?utf-8?B?QUc0Unh3VjBlbUg4S3BGeVV1a255RkQ2YTBJMUVuVU9KZitUYnp3VmNOUVBF?=
 =?utf-8?B?L1djbHk5NjltZjNuNjV4THZIK2xxNnNmekNwV1U1V0dCbm84N2RqQWY1R3cx?=
 =?utf-8?B?ZnA4UWRpczZUcUgzQlhyVmlzZUgzbDB1R3NDdjlOaDRVcGRKSG1lNVA3bG1G?=
 =?utf-8?B?cEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?NTVWQ3dvNCs3VTNMSUo2YmFNQTFaQTBFVDNJZzdvUVFBYXJGeFdjZHRpdVAy?=
 =?utf-8?B?c1lZcklmcEVEY0dJaFk4b2d4aDNaUTR6Uy82ZmtMODQ5OGlKMXppeVJTVFZo?=
 =?utf-8?B?ZllyRHZZY1lVWHdYWlJYd0RxSnFLSlprS01ySmdENWlPQVdWZlVkd3VENHZX?=
 =?utf-8?B?YS94RXJPQmJhWGhQWEEwTzBWZXMraWYrckFGVkdMaEdQakRwaFBSV0tYMHNx?=
 =?utf-8?B?V2Qxa2VQa1JFbkxDTFJwRTcvTEZBTnJxam14MmZNdG9ZR0M4NitjQkh5R1Fn?=
 =?utf-8?B?RE01VjR4dmdvN2RFWWJUZ29PUlZQZ0N1UzI4SXFKTTdpYUlQSjQ3djk1Y1NN?=
 =?utf-8?B?cVFoRnhLZzhhQ3V3aW5FZ1JESitIR2dWOTg0RCtJcVh5azR5SjRSdWd1TmxK?=
 =?utf-8?B?NVJOLzVraDZXTlRSNzJOUjQrTDNXUHUxSEEvcHg4RTdjRUh0S0ZNR2R0ZzVR?=
 =?utf-8?B?MEV4SGFGNEYyTlQxVkRjRGQ0dkxQUGg3dWx0OFYwc0dPaXlCNzdNWDFaWGxq?=
 =?utf-8?B?S2VqRW56ZGNsRlNQMDI0ZUdFNkVjWXZZd3VLNXp4OHZXdDNxMmNZUmw1N2NT?=
 =?utf-8?B?MW9ISWpFNE03TTFJTlJUMlBsNjdXV092L2JDRXlVbmN3Vnl3ZU00d2RYZGpn?=
 =?utf-8?B?UVdLWjZGZ3lQRHgyYlBqcFVIK1F5Qy9Ud3liSHdpclpmVkVRRDhHSk9JZ1Fn?=
 =?utf-8?B?MXRRdmI2U2JIaVpZZmlJRVdQakU4eWRnZ3U3S29WOGxKL0xhL1pKcnUxZ0ZZ?=
 =?utf-8?B?WlhRWjFUR0pWWWJ0Tk9NOEFvdUlFazdEMy9HQnJUQU00bVdpM2FDR2hPaVE2?=
 =?utf-8?B?cmlSV09NVE5UZkVUZkQvWWhYOFdXQ0Z3QUZOTlZONG9TbnAxK0hYeUlCbE9j?=
 =?utf-8?B?U1J4K2NaK2xRSUtWK3I1dVZNTnM1aERUL1hUOHk0Y1JKVGt4ejBhMGhNYVNY?=
 =?utf-8?B?TUtzT21DaHJ0UjNReHpiRXhYbm91SlNQTkV5ME1nM25MNnBGTk5vZkNyQjJT?=
 =?utf-8?B?Z3ZpalViSWxlNmdla1lDM29uTWZlMG9paTlaczUyZ0x5akJORnhXZmkzVk1B?=
 =?utf-8?B?bTJGN0JtanFaYXRJQ3BHeVAwcVBWc3h5NUExSFlzKzJqRmRHVm05NXo3TE9j?=
 =?utf-8?B?Z1pOQ2o2SFN5ZVluejZlOU16ZDZXK3lBK2E1RXBEM1U4b09lWS9kYXlxMElP?=
 =?utf-8?B?MFFiZTJsMDZ1V0dpVDFXTTVlQkZGSXZ5QUU2UXZCbXBsL0tYUm52dVQ1UHVv?=
 =?utf-8?B?UmhzQ2dNWmdReTJhWVAwSzcxSy83T0NwSlQvM2tDQ2tmcTVUaGJLNXdPUlVY?=
 =?utf-8?B?UUVsMllzK2srNUdIaXNNNHhvSy91NzVXbkZvMk85UTYvcjhXSXJrOGZWekJr?=
 =?utf-8?B?UkZReHZwcFZNazdSQ1pacWx0aFdFVXZiTGJYVDljVW83Ylp1OFNQY1NOcE8r?=
 =?utf-8?Q?TE8KHB2+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50176a16-d517-4351-451c-08dbcf035f50
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 11:22:39.5951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ti3GBkeFV0FD+qbT5FErS6ja52GvRESuiAVpCMfJLSnOHJE9Vvv2w1SYTO1hDPHuTOpDkclgb6wKoB6HpgTeuGdOt5yfxwxmxa80e9PFJNw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6794
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_13,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310170095
X-Proofpoint-ORIG-GUID: WMmJ5HPI2C_uzzTj4bSNpE6GC_bYD7eq
X-Proofpoint-GUID: WMmJ5HPI2C_uzzTj4bSNpE6GC_bYD7eq
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/10/2023 03:08, Baolu Lu wrote:
> On 10/17/23 12:00 AM, Joao Martins wrote:
>>>> The iommu_dirty_bitmap is defined in iommu core. The iommu driver has no
>>>> need to understand it and check its member anyway.
>>>>
>>> (...) The iommu driver has no need to understand it. iommu_dirty_bitmap_record()
>>> already makes those checks in case there's no iova_bitmap to set bits to.
>>>
>> This is all true but the reason I am checking iommu_dirty_bitmap::bitmap is to
>> essentially not record anything in the iova bitmap and just clear the dirty bits
>> from the IOPTEs, all when dirty tracking is technically disabled. This is done
>> internally only when starting dirty tracking, and thus to ensure that we cleanup
>> all dirty bits before we enable dirty tracking to have a consistent snapshot as
>> opposed to inheriting dirties from the past.
> 
> It's okay since it serves a functional purpose. Can you please add some
> comments around the code to explain the rationale.
> 

I added this comment below:

+       /*
+        * IOMMUFD core calls into a dirty tracking disabled domain without an
+        * IOVA bitmap set in order to clean dirty bits in all PTEs that might
+        * have occured when we stopped dirty tracking. This ensures that we
+        * never inherit dirtied bits from a previous cycle.
+        */

Also fixed an issue where I could theoretically clear the bit with
IOMMU_NO_CLEAR. Essentially passed the read_and_clear_dirty flags and let
dma_sl_pte_test_and_clear_dirty() to test and test-and-clear, similar to AMD:

@@ -781,6 +788,16 @@ static inline bool dma_pte_present(struct dma_pte *pte)
        return (pte->val & 3) != 0;
 }

+static inline bool dma_sl_pte_test_and_clear_dirty(struct dma_pte *pte,
+                                                  unsigned long flags)
+{
+       if (flags & IOMMU_DIRTY_NO_CLEAR)
+               return (pte->val & DMA_SL_PTE_DIRTY) != 0;
+
+       return test_and_clear_bit(DMA_SL_PTE_DIRTY_BIT,
+                                 (unsigned long *)&pte->val);
+}
+

Anyhow, see below the full diff compared to this patch. Some things are in tree
that is different to submitted from this patch.

diff --git a/drivers/iommu/intel/Kconfig b/drivers/iommu/intel/Kconfig
index 2e56bd79f589..dedb8ae3cba8 100644
--- a/drivers/iommu/intel/Kconfig
+++ b/drivers/iommu/intel/Kconfig
@@ -15,6 +15,7 @@ config INTEL_IOMMU
 	select DMA_OPS
 	select IOMMU_API
 	select IOMMU_IOVA
+	select IOMMUFD_DRIVER
 	select NEED_DMA_MAP_STATE
 	select DMAR_TABLE
 	select SWIOTLB
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index fabfe363f1f9..0e3f532f3bca 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4075,11 +4075,6 @@ static struct iommu_domain
*intel_iommu_domain_alloc(unsigned type)
 	return NULL;
 }

-static bool intel_iommu_slads_supported(struct intel_iommu *iommu)
-{
-	return sm_supported(iommu) && ecap_slads(iommu->ecap);
-}
-
 static struct iommu_domain *
 intel_iommu_domain_alloc_user(struct device *dev, u32 flags)
 {
@@ -4087,6 +4082,10 @@ intel_iommu_domain_alloc_user(struct device *dev, u32 flags)
 	struct iommu_domain *domain;
 	struct intel_iommu *iommu;

+	if (flags & (~(IOMMU_HWPT_ALLOC_NEST_PARENT|
+		       IOMMU_HWPT_ALLOC_ENFORCE_DIRTY)))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	iommu = device_to_iommu(dev, NULL, NULL);
 	if (!iommu)
 		return ERR_PTR(-ENODEV);
@@ -4094,15 +4093,26 @@ intel_iommu_domain_alloc_user(struct device *dev, u32 flags)
 	if ((flags & IOMMU_HWPT_ALLOC_NEST_PARENT) && !ecap_nest(iommu->ecap))
 		return ERR_PTR(-EOPNOTSUPP);

-	if (enforce_dirty &&
-	    !intel_iommu_slads_supported(iommu))
+	if (enforce_dirty && !slads_supported(iommu))
 		return ERR_PTR(-EOPNOTSUPP);

+	/*
+	 * domain_alloc_user op needs to fully initialize a domain
+	 * before return, so uses iommu_domain_alloc() here for
+	 * simple.
+	 */
 	domain = iommu_domain_alloc(dev->bus);
 	if (!domain)
 		domain = ERR_PTR(-ENOMEM);
-	if (domain && enforce_dirty)
+
+	if (!IS_ERR(domain) && enforce_dirty) {
+		if (to_dmar_domain(domain)->use_first_level) {
+			iommu_domain_free(domain);
+			return ERR_PTR(-EOPNOTSUPP);
+		}
 		domain->dirty_ops = &intel_dirty_ops;
+	}
+
 	return domain;
 }

@@ -4113,7 +4123,7 @@ static void intel_iommu_domain_free(struct iommu_domain
*domain)
 }

 static int prepare_domain_attach_device(struct iommu_domain *domain,
-					struct device *dev)
+					struct device *dev, ioasid_t pasid)
 {
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 	struct intel_iommu *iommu;
@@ -4126,7 +4136,8 @@ static int prepare_domain_attach_device(struct
iommu_domain *domain,
 	if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
 		return -EINVAL;

-	if (domain->dirty_ops && !intel_iommu_slads_supported(iommu))
+	if (domain->dirty_ops &&
+	    (!slads_supported(iommu) || pasid != IOMMU_NO_PASID))
 		return -EINVAL;

 	/* check if this iommu agaw is sufficient for max mapped address */
@@ -4164,7 +4175,7 @@ static int intel_iommu_attach_device(struct iommu_domain
*domain,
 	if (info->domain)
 		device_block_translation(dev);

-	ret = prepare_domain_attach_device(domain, dev);
+	ret = prepare_domain_attach_device(domain, dev, IOMMU_NO_PASID);
 	if (ret)
 		return ret;

@@ -4384,7 +4395,7 @@ static bool intel_iommu_capable(struct device *dev, enum
iommu_cap cap)
 	case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
 		return ecap_sc_support(info->iommu->ecap);
 	case IOMMU_CAP_DIRTY:
-		return intel_iommu_slads_supported(info->iommu);
+		return slads_supported(info->iommu);
 	default:
 		return false;
 	}
@@ -4785,7 +4796,7 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain
*domain,
 	if (context_copied(iommu, info->bus, info->devfn))
 		return -EBUSY;

-	ret = prepare_domain_attach_device(domain, dev);
+	ret = prepare_domain_attach_device(domain, dev, pasid);
 	if (ret)
 		return ret;

@@ -4848,31 +4859,31 @@ static int intel_iommu_set_dirty_tracking(struct
iommu_domain *domain,
 	int ret = -EINVAL;

 	spin_lock(&dmar_domain->lock);
-	if (!(dmar_domain->dirty_tracking ^ enable) ||
-	    list_empty(&dmar_domain->devices)) {
-		spin_unlock(&dmar_domain->lock);
-		return 0;
-	}
+	if (dmar_domain->dirty_tracking == enable)
+		goto out_unlock;

 	list_for_each_entry(info, &dmar_domain->devices, link) {
-		/* First-level page table always enables dirty bit*/
-		if (dmar_domain->use_first_level) {
-			ret = 0;
-			break;
-		}
-
 		ret = intel_pasid_setup_dirty_tracking(info->iommu, info->domain,
 						     info->dev, IOMMU_NO_PASID,
 						     enable);
 		if (ret)
-			break;
+			goto err_unwind;

 	}

 	if (!ret)
 		dmar_domain->dirty_tracking = enable;
+out_unlock:
 	spin_unlock(&dmar_domain->lock);

+	return 0;
+
+err_unwind:
+         list_for_each_entry(info, &dmar_domain->devices, link)
+                 intel_pasid_setup_dirty_tracking(info->iommu, dmar_domain,
+						  info->dev, IOMMU_NO_PASID,
+						  dmar_domain->dirty_tracking);
+	spin_unlock(&dmar_domain->lock);
 	return ret;
 }

@@ -4886,14 +4897,16 @@ static int intel_iommu_read_and_clear_dirty(struct
iommu_domain *domain,
 	unsigned long pgsize;
 	bool ad_enabled;

-	spin_lock(&dmar_domain->lock);
+	/*
+	 * IOMMUFD core calls into a dirty tracking disabled domain without an
+	 * IOVA bitmap set in order to clean dirty bits in all PTEs that might
+	 * have occured when we stopped dirty tracking. This ensures that we
+	 * never inherit dirtied bits from a previous cycle.
+	 */
 	ad_enabled = dmar_domain->dirty_tracking;
-	spin_unlock(&dmar_domain->lock);
-
 	if (!ad_enabled && dirty->bitmap)
 		return -EINVAL;

-	rcu_read_lock();
 	do {
 		struct dma_pte *pte;
 		int lvl = 0;
@@ -4906,14 +4919,10 @@ static int intel_iommu_read_and_clear_dirty(struct
iommu_domain *domain,
 			continue;
 		}

-		/* It is writable, set the bitmap */
-		if (((flags & IOMMU_DIRTY_NO_CLEAR) &&
-				dma_sl_pte_dirty(pte)) ||
-		    dma_sl_pte_test_and_clear_dirty(pte))
+		if (dma_sl_pte_test_and_clear_dirty(pte, flags))
 			iommu_dirty_bitmap_record(dirty, iova, pgsize);
 		iova += pgsize;
 	} while (iova < end);
-	rcu_read_unlock();

 	return 0;
 }
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index bccd44db3316..0b390d9e669b 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -542,6 +542,9 @@ enum {
 #define sm_supported(iommu)	(intel_iommu_sm && ecap_smts((iommu)->ecap))
 #define pasid_supported(iommu)	(sm_supported(iommu) &&			\
 				 ecap_pasid((iommu)->ecap))
+#define slads_supported(iommu) (sm_supported(iommu) &&                 \
+                                ecap_slads((iommu)->ecap))
+

 struct pasid_entry;
 struct pasid_state_entry;
@@ -785,13 +788,12 @@ static inline bool dma_pte_present(struct dma_pte *pte)
 	return (pte->val & 3) != 0;
 }

-static inline bool dma_sl_pte_dirty(struct dma_pte *pte)
+static inline bool dma_sl_pte_test_and_clear_dirty(struct dma_pte *pte,
+						   unsigned long flags)
 {
-	return (pte->val & DMA_SL_PTE_DIRTY) != 0;
-}
+	if (flags & IOMMU_DIRTY_NO_CLEAR)
+		return (pte->val & DMA_SL_PTE_DIRTY) != 0;

-static inline bool dma_sl_pte_test_and_clear_dirty(struct dma_pte *pte)
-{
 	return test_and_clear_bit(DMA_SL_PTE_DIRTY_BIT,
 				  (unsigned long *)&pte->val);
 }
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 03814942d59c..785384a59d55 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -686,15 +686,29 @@ int intel_pasid_setup_dirty_tracking(struct intel_iommu
*iommu,

 	spin_lock(&iommu->lock);

-	did = domain_id_iommu(domain, iommu);
 	pte = intel_pasid_get_entry(dev, pasid);
 	if (!pte) {
 		spin_unlock(&iommu->lock);
-		dev_err(dev, "Failed to get pasid entry of PASID %d\n", pasid);
+		dev_err_ratelimited(dev,
+				    "Failed to get pasid entry of PASID %d\n",
+				    pasid);
 		return -ENODEV;
 	}

+	did = domain_id_iommu(domain, iommu);
 	pgtt = pasid_pte_get_pgtt(pte);
+	if (pgtt != PASID_ENTRY_PGTT_SL_ONLY && pgtt != PASID_ENTRY_PGTT_NESTED) {
+		spin_unlock(&iommu->lock);
+		dev_err_ratelimited(dev,
+				    "Dirty tracking not supported on translation type %d\n",
+				    pgtt);
+		return -EOPNOTSUPP;
+	}
+
+	if (pasid_get_ssade(pte) == enabled) {
+		spin_unlock(&iommu->lock);
+		return 0;
+	}

 	if (enabled)
 		pasid_set_ssade(pte);
@@ -702,6 +716,9 @@ int intel_pasid_setup_dirty_tracking(struct intel_iommu *iommu,
 		pasid_clear_ssade(pte);
 	spin_unlock(&iommu->lock);

+	if (!ecap_coherent(iommu->ecap))
+		clflush_cache_range(pte, sizeof(*pte));
+
 	/*
 	 * From VT-d spec table 25 "Guidance to Software for Invalidations":
 	 *
@@ -720,8 +737,6 @@ int intel_pasid_setup_dirty_tracking(struct intel_iommu *iommu,

 	if (pgtt == PASID_ENTRY_PGTT_SL_ONLY || pgtt == PASID_ENTRY_PGTT_NESTED)
 		iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
-	else
-		qi_flush_piotlb(iommu, did, pasid, 0, -1, 0);

 	/* Device IOTLB doesn't need to be flushed in caching mode. */
 	if (!cap_caching_mode(iommu->cap))
