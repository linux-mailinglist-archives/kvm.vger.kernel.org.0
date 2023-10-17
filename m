Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B83C57CBFF8
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 11:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234806AbjJQJz1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 05:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234752AbjJQJz0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 05:55:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F34F9F
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 02:55:24 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39GKOYoX012565;
        Tue, 17 Oct 2023 09:54:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Ho8fOSnD7P7pg0PqD+bBYeq3UFv4nYDk9x6LMgMyrXM=;
 b=4NPByu19tgZ941kuf67p0J0KotQ7ar9Dj1D82v7BmaUDbXFbbCn8x3nwNV0hc7oVC3Ze
 DzbJs+e+yXmc2nUlsHSuDBN8P+HMczZbNoiXkk0KAONr8N8v0kGaM2WCDqFL09LmINY2
 AAq9+6q22bGpzfRZ5dDF1E4WPvSQchwxN5weDH3CceE8zmLRHq6BtBhwFEbiCV5Ap1JJ
 ub/0YXtouqdsvoazHQraPR5akGRP2c5fQxDzH+cjB3rbej3M8vUx1tSjFX6nGvd6h6E2
 Rk9lUNTLUZhRm8nU7mJNrGuIuS7iJU3D1e18COPZwMLG+g0oz5uWWdZgJSmp/4cINmwm Ng== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqjy1cq7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 09:54:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39H9n8FZ009668;
        Tue, 17 Oct 2023 09:54:51 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg0mj4nx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 09:54:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUotL6Gkuur88u7uPUzolVVjNmq54BylQo4uS6LgaDrvJ0ONybSFOeOebn6F3z2cfEcbzHmkcqpOSXOBDMaHugGMA/eW8offtho3OBuJb7vdtvsWvv91MaHPvdvYSOk+gaId+GlpSq2hRtEnJCpSZMqGnXYzwKhB5rdQohVbimvNZSyo92NWuF/mfLnQyuzeMzCHiCSxfza2jQk4r5d7UUyUS4Nhguc/e3mE9OcFoNm0glvgD6TCQa/f4ydWetVVgwG67ID7628oySDcLfy436OS7oJnQj6WITGDm+hFVy/ouhjZ1d9bn6n/YX8UoxWPzH5TqnaCi8tfz+Yniu5vJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ho8fOSnD7P7pg0PqD+bBYeq3UFv4nYDk9x6LMgMyrXM=;
 b=VHUCexSL78tKnno8KkxV13eVZ0B1QdHD5Df1VVJ2nAuaRnyQwtwQ7jJra73vjNyAfluo8Rj90xE6taJUy0O9c1URAordhyT4Qq3iPUkEQFV6FkXO67HwTK0jdR1q2OzGcaxIvJwoSkVhdkerUEea79oK7sfK0j2Eyy830Veogjlfrv9UAmCK3BKhUdDF18n1px0oVOXuBamaX6pzDlgjtcgjCjB/3ujLXWxgTQA5GSGBsmUrLf8TG9Zui0JlhAWOotsI5Ny6WSVq21U4m63nBN37Ut/ZgayghM9NT7gC6mXKb0Xc9pek8r9nACIzY0rrjSpJGjgRrVv7VEP8gKqplg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ho8fOSnD7P7pg0PqD+bBYeq3UFv4nYDk9x6LMgMyrXM=;
 b=ZK+deyqg9TpK2rGregX5iXQeNxmz5I2J7/arX4hUXnFPhct56T1A/wlwBReEsHgHJzOiyrKJWEPtXKwN465euglQXP7wcBLfcG+iPLeUxAQmQxbdEVgm++r9WS7syCipx4hrnROJCpI4uvMN6V8K20MXNsUIM3okyfu4e9gkflk=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SA1PR10MB7856.namprd10.prod.outlook.com (2603:10b6:806:3a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.46; Tue, 17 Oct
 2023 09:54:49 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.038; Tue, 17 Oct 2023
 09:54:49 +0000
Message-ID: <37ba5a6d-b0e7-44d2-ab4b-22e97b24e5b8@oracle.com>
Date:   Tue, 17 Oct 2023 10:54:43 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/19] iommu/amd: Access/Dirty bit support in IOPTEs
Content-Language: en-US
To:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>,
        iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
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
 <20230923012511.10379-18-joao.m.martins@oracle.com>
 <e6730de4-aac6-72e8-7f6a-f20bb9e4f026@amd.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <e6730de4-aac6-72e8-7f6a-f20bb9e4f026@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P190CA0004.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::10) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SA1PR10MB7856:EE_
X-MS-Office365-Filtering-Correlation-Id: 15ddf002-5b8d-4f68-9f87-08dbcef719d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: usS8gd7ioEOYRRAvEd5FGcz9i5RBNV48MmXbw7+DSYTE2Q6PQQ26m3eurgp2BWdPoD+BczkysH/tt8wYRDMCXtIjpA2zbgOgpnlKWBYMn4UxTHS6eHzS10/UF+O0QsVGhSFi3uB+d/OEnRv1h6xddOgLmGT/D+d2/9XPO/BkOIdBlyjgtbs7x15eqQCXfGV835OqH1sHPi3/pD+SSoOZ+1Awwab4AcsBXgMzr8ARFhkZmL8eBCE1aKP0TnBAtiORBBr+sJxIzX40LNytybBczHlCzZ5/wpfonImmXUpe3ViejL/OE2fGMkMkyiR2LLfK2VVEIHV2aeDkXOiG4WXm7Wdi1c2txogsYOa0JLLNV22KNG46Zs8Lz51Va6ph1ySlsqj/9isADcq6JrxTkqyEmkf+A09CgL9g9uHJq9mEQGnOOJpAeUNkoOyKAPE0N6T6ybnCZoZHpYYtqMG/oIBcoqmGMxltl2ERN8BBlPk1nLlrJstn0oI5boc1VdGORxTcCTzogANV/68Bam+qQcDdhdBqwjxVj1QgWdr1JnrZfPnKu5SUMSoBnvRswmrArKy9Syk0+M4npbtmWZts/netxdNks3gjRMYamt2Md98GoUWtIAz+vYB6AiKQoAvzX2YjP2lpoCXIxbelyNUz0El/Esc1OlfiQr1Gb3qGcjuZz+o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(376002)(366004)(396003)(39860400002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(31686004)(478600001)(966005)(66946007)(54906003)(6666004)(66556008)(6486002)(66476007)(83380400001)(31696002)(86362001)(38100700002)(6506007)(6512007)(316002)(53546011)(26005)(2616005)(36756003)(5660300002)(41300700001)(4326008)(2906002)(8936002)(7416002)(8676002)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akdXVmFTa3BLOWJkNlgxRTJkdDFQOHdWSCtocEo2Wk16d0gzc2c1My9hcFRR?=
 =?utf-8?B?V1BUYmlqV3JIZFpjU2lwVGc2OFVRVzVWN0lqZEZSNFY4ajI3MDMzUDY0MDl1?=
 =?utf-8?B?RktoUGxxV3M5OFNvUVNCcUdjVktJMnYzZ1JORldQc0lha2dIdzRJUm1lamow?=
 =?utf-8?B?d3Bhd2xBcHo3bnR0Vm8xNzNnbjhsMW8wakR5VHpua2VPeXphUGNwSk11eWJV?=
 =?utf-8?B?YjJjcU5vK2svNm16bHd5ajZKeUJOcFluSXp1M0VSVnRtVmFSV3JjZEZOTVdq?=
 =?utf-8?B?Y1IxV0ZrTkNzKzQ1YmlBQnd4TnhRSlJIZTlHMDlQTytMQkxTVU11NVlzbTRR?=
 =?utf-8?B?SmJ5NDI2T0pKNnE2YzBFZkVydktUMzZWL2tMZWtiVUlHRFhOc1NUWVNzQWZm?=
 =?utf-8?B?SEFCSHBtdXBLTUlzSC9WZ2h1TW40TG9pMFF5YzBhc2t5YWJyZmZzNEx1Mm9h?=
 =?utf-8?B?cGhLaURZVk9ENkpjZ3E5K0h4bE13b1c1VHh4S1R1QTFjNW1vR3lYL1NrSk9N?=
 =?utf-8?B?U0NxU3piTlVBaWhtVUVqME1vMnpwMTZSVHlBZ3NIeGtzeDh6WERnUllRMDhE?=
 =?utf-8?B?OHdkaE5kakF0a0JrMWVZaURoZU1Fc1ZtcWtNclNSRG9oQmt5cFZPb05Jb2h0?=
 =?utf-8?B?VWdEZzAzczBQeTFoVVkxV1UvdS9YVjgyU0FsN0xpMmRxa053UGdPdVZqdzhJ?=
 =?utf-8?B?ZUpLMXNmNFFsa3NyVzFVMVdvNGdYNFl0MU5ja3UxcldoNmN2QnNWRm5mOWxa?=
 =?utf-8?B?TCszQjlPZkIwTlJpNWZmbFVtSXNUNmEvOExSQjNRKyt5ZHRuYTI0TDdGdFFo?=
 =?utf-8?B?dFFzTkdBYW00bWVlSnI2SHgyOXlWUlBpSXNHL0FWWFJwUXhBY1BGU1lEc05u?=
 =?utf-8?B?YnB1cGhZTXpjaWZnV1BnV3JNallYWW15ekhBSm9OY3N4SlBCY2lnVjhrN3Rn?=
 =?utf-8?B?TlQ3VTA4STBxV21ncGJ3R09sb2lDaXBSa3pGQTFxdW9LbU8zbDJ6WnJMVTFX?=
 =?utf-8?B?dTRlOUc2Vzk3Nk9hTmRFekh5MitsRllmK0JCNlZ5cFhsUjI5b1g1ZGJLZndM?=
 =?utf-8?B?VkIvcWNzSmExa1FFaUpTbU9wWDAxcGVrZWhyS3hTRkkrODNSejR2cHVaeDZz?=
 =?utf-8?B?clNtb2hNMEJ3eVU4YXQxc0JHc1MyMk5hVm92ZUZUdDl1OWQvUkN5ZmdEV2N3?=
 =?utf-8?B?akNuREpxMFVudE8wUzZqN1FuY2dWRDZNa1YyZ25rbkozOTNxU0w4bDdaTjZW?=
 =?utf-8?B?QlpCSFBsWHNLcjZ5eEk1MmVNYXdkNFBYQWxyTThvakZMNjBxdUt4Z29uTW45?=
 =?utf-8?B?b1VndlJRdWdOVzU1VDFGR0kxRE1yUEdDS2xBYWhGZzZCamJyQ1lCZ3pEeTZC?=
 =?utf-8?B?byt2Tm9VcldGdmVJVlR1VkN5NlVvT0ZIWHZ3R0RlRnNPSXEyTTZXTHlUR0tD?=
 =?utf-8?B?OEo1NWc1QllPM01IdmRaR0ZtT1dRVnVQbEVjeWVyM1dUY1ZLRHJIYU90b01P?=
 =?utf-8?B?RUFvNHpQd0xFZ2lsWkpCa2RwVzdDUG0wOU1tZmpYTHZaUWVDNENuRHgwYW8r?=
 =?utf-8?B?b3h0ZFBSM2NiVzlxcUtSM2FkZ0VleHpGWWUzVkVuRGxwNmFCQWtQa1lzTTJq?=
 =?utf-8?B?UTB4RVdNcy94bDB5ZSs2Nm12dUlHcloyaUtVcnJZa1NRVHZGaFI5WVdIRU1i?=
 =?utf-8?B?REsyZEFSanR1ZEJSdm1vT3c0RnorRzZKWDRISUw2SmlYOUg2S2h1dUFIaWtZ?=
 =?utf-8?B?YThCY0JSV2FXQnRtelJVb0lBem4yRHl3aTBoUGJnT09HYUdFWWozUkZUNWhL?=
 =?utf-8?B?dTRLajNPNFdTVTVKeC9mZlNSMTlsQzlrUURIK0V3QUNkS3cveUNyQ3MvaFpo?=
 =?utf-8?B?RmJMaXZGa3JPdE04RHplSTQ0T3N4ZnJ3d0dqZFc1T3VBWk12ZytpWmpVR0dt?=
 =?utf-8?B?aFAzMzA1S09EcDRBV0Mwb2dyOG9adUh3Vzd6bXVJYWhOMTdJaVdIbkJHOGo5?=
 =?utf-8?B?N1FUTzVOZkYzaCs2TVpYODBqYVhhOUJEUzNFVTc0bHBZS0toR1hzVStTUVUr?=
 =?utf-8?B?Y2tYZ1Nla1F0ZUlkUXZUdU9TdEFjc0haQ1lwTzVDYS9yeHplcStseUVacXFs?=
 =?utf-8?B?Sk9rSHBIMU4rZjlBQjlXQ0VEbUR3b1RrVVBVUVQ3ZHlqbXBzSFpGcDh3eU8r?=
 =?utf-8?B?YkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Q0FMSHUrQVdEQmxjWkpFZC95VWpDeVZsZ3UwVkpKRjA3SlMybVg3Mzh0REpX?=
 =?utf-8?B?ODg3WEhqejBSMVkvQ2I5RHZFWTRBTHgvVFNCbmpCRW9YaEcyWXFhUWhGdTZq?=
 =?utf-8?B?U1o4TkhtaXkxMDNsUUZiSk83a0Z2YVFSdXZqNTR5YWtnK0s2bTJlZTEvUDR2?=
 =?utf-8?B?bVR4b2JGUEJjaFdzUmo3NTRnbFpSNVVyQ1FEQk0xL01LY3c4NEc1bkJFaGli?=
 =?utf-8?B?YlNXN1VjTEp0OFYzYzRYOHR2VXo4aVdKSlZHNEd3cTRsSEgxS1N1ZW5hRmNJ?=
 =?utf-8?B?R1NYc0htOXErTTVlSExvVlFyaStZQTJNTlJqLzdKMUJuVXdqTVU0Q3hYMUs4?=
 =?utf-8?B?ZmJLMWVIYzQ1TjkyQi9tZmdEdnFNS2ViSzc0OTkvK3M2MmhNN0xOWEltb01S?=
 =?utf-8?B?R0tIR2ZKeUJ3UWd5M3ZXak5Mdy9mTjY4bzRBbytYK2p5UEZBSVRuNStvTkRR?=
 =?utf-8?B?SzRUbjR3SExDd3hCT3VUem4ydnlMTXVpa3UvVzduaGVGTHZNWHV3RnBZeVF6?=
 =?utf-8?B?eTNkWjhHRXJQN0hoUzZGT1FlU1lacUdRRjh2azRqYnNRZWhzemwzT1Z6VkVo?=
 =?utf-8?B?bXBTWEVKV0FpbGpodzRMMkZNZGhlSzFjVTMvek4wemhDdTRuem40VkdiczVB?=
 =?utf-8?B?SDlDeFJmbnBCMEs4aytEbVJXSWtpaHVIZno0ei84NzJJWjVEVjRIamd3bjN5?=
 =?utf-8?B?eHh0VTkwV3lpU3ZOQlNnYkhUMkZ0S0Y2YjRRNTRyTXJlNS80MTZBNWJmZnVR?=
 =?utf-8?B?dkRsc1Vmc0FPSGM0VHU3NFFscUJ4MnJIY2tvbTdCNSt6eVZGTURlR292NERL?=
 =?utf-8?B?bHFWMVhBTE1UeFdTUFc2V2xJZzZVNmZqUXYwSUZZRjV1TjdHM2w0allpT3Fz?=
 =?utf-8?B?Y0lLdVk3ekRkN2paNGM5bjRUSFhFQi9uckVudGRLL2dkYlBVMmlwS0V5cmVT?=
 =?utf-8?B?a29vQVY0SGhLck50R2VubDlCQ0RPUjNlOHg0TXBDVUE2N0RmWm9hWWplcFNq?=
 =?utf-8?B?UUlLNXlKMHdaS292ZlVnQ3k0MnBlU2swOWJ4V0MrUE1YaDhiZnVVYUUxdXhC?=
 =?utf-8?B?MTU0ZGVwWm4xMzBsRFRRdUdRTWNBYytsMDAxZWl1REw1Qlp0OXJIcGUyWVFK?=
 =?utf-8?B?WXdyZUt4OCsrOTBDV2pVb2UyVFlLN3QyK3A1R2FvNStjaG1RQzJxTjhsRk5u?=
 =?utf-8?B?RWNkVXNLbnVxNW91bkg0b01uUkFCbEl0V1FTakFKVjFIdnlyU2d3TW8xN0dN?=
 =?utf-8?B?S0ZicW9DVjJvSGlZRDJDcWl1M3NrNHUzMm5pNmJNa0JnV21PUEV6dFZ5eHpp?=
 =?utf-8?B?RWdkM3hjWnNKUENXUE1RUStXSi9tbjB6UTZiMHF3MzlaQVBlZFVpb213VjhB?=
 =?utf-8?B?TU5zRnNyeStMWWl4RURhQUhYMFN0NXNsL3VhbEtWTnVTRlEyU0wrbjdvb2Qw?=
 =?utf-8?Q?wghT8dig?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15ddf002-5b8d-4f68-9f87-08dbcef719d5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 09:54:49.0427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W60LU6HaOkIvKoZ6IDn7LAvkaLvTh81eCS4g8/g68k/JMXFj5SvTwnPwWb2e9Vy/ivs7QroaXf0hBwcTJ4r+No2U7HeXIJH6WqpaKzR9OU4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7856
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_13,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170082
X-Proofpoint-GUID: qMsJEkQeZ752_KoeIDDG5SWB5XOl79lD
X-Proofpoint-ORIG-GUID: qMsJEkQeZ752_KoeIDDG5SWB5XOl79lD
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/10/2023 09:18, Suthikulpanit, Suravee wrote:
> Hi Joao,
> 
> On 9/23/2023 8:25 AM, Joao Martins wrote:
>> ...
>> diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
>> index 2892aa1b4dc1..099ccb04f52f 100644
>> --- a/drivers/iommu/amd/io_pgtable.c
>> +++ b/drivers/iommu/amd/io_pgtable.c
>> @@ -486,6 +486,89 @@ static phys_addr_t iommu_v1_iova_to_phys(struct
>> io_pgtable_ops *ops, unsigned lo
>>       return (__pte & ~offset_mask) | (iova & offset_mask);
>>   }
>>   +static bool pte_test_dirty(u64 *ptep, unsigned long size)
>> +{
>> +    bool dirty = false;
>> +    int i, count;
>> +
>> +    /*
>> +     * 2.2.3.2 Host Dirty Support
>> +     * When a non-default page size is used , software must OR the
>> +     * Dirty bits in all of the replicated host PTEs used to map
>> +     * the page. The IOMMU does not guarantee the Dirty bits are
>> +     * set in all of the replicated PTEs. Any portion of the page
>> +     * may have been written even if the Dirty bit is set in only
>> +     * one of the replicated PTEs.
>> +     */
>> +    count = PAGE_SIZE_PTE_COUNT(size);
>> +    for (i = 0; i < count; i++) {
>> +        if (test_bit(IOMMU_PTE_HD_BIT, (unsigned long *) &ptep[i])) {
>> +            dirty = true;
>> +            break;
>> +        }
>> +    }
>> +
>> +    return dirty;
>> +}
>> +
>> +static bool pte_test_and_clear_dirty(u64 *ptep, unsigned long size)
>> +{
>> +    bool dirty = false;
>> +    int i, count;
>> +
>> +    /*
>> +     * 2.2.3.2 Host Dirty Support
>> +     * When a non-default page size is used , software must OR the
>> +     * Dirty bits in all of the replicated host PTEs used to map
>> +     * the page. The IOMMU does not guarantee the Dirty bits are
>> +     * set in all of the replicated PTEs. Any portion of the page
>> +     * may have been written even if the Dirty bit is set in only
>> +     * one of the replicated PTEs.
>> +     */
>> +    count = PAGE_SIZE_PTE_COUNT(size);
>> +    for (i = 0; i < count; i++)
>> +        if (test_and_clear_bit(IOMMU_PTE_HD_BIT,
>> +                    (unsigned long *) &ptep[i]))
>> +            dirty = true;
>> +
>> +    return dirty;
>> +}
> 
> Can we consolidate the two functions above where we can pass the flag and check
> if IOMMU_DIRTY_NO_CLEAR is set?
> 
I guess so yes -- it was initially to have an efficient tight loop to check all
replicated PTEs, but I think I found a way to merge everything e.g.

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 099ccb04f52f..953f867b4943 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -486,8 +486,10 @@ static phys_addr_t iommu_v1_iova_to_phys(struct
io_pgtable_ops *ops, unsigned lo
        return (__pte & ~offset_mask) | (iova & offset_mask);
 }

-static bool pte_test_dirty(u64 *ptep, unsigned long size)
+static bool pte_test_and_clear_dirty(u64 *ptep, unsigned long size,
+                                    unsigned long flags)
 {
+       bool test_only = flags & IOMMU_DIRTY_NO_CLEAR;
        bool dirty = false;
        int i, count;

@@ -501,35 +503,20 @@ static bool pte_test_dirty(u64 *ptep, unsigned long size)
         * one of the replicated PTEs.
         */
        count = PAGE_SIZE_PTE_COUNT(size);
-       for (i = 0; i < count; i++) {
-               if (test_bit(IOMMU_PTE_HD_BIT, (unsigned long *) &ptep[i])) {
+       for (i = 0; i < count && test_only; i++) {
+               if (test_bit(IOMMU_PTE_HD_BIT,
+                            (unsigned long *) &ptep[i])) {
                        dirty = true;
                        break;
                }
        }

-       return dirty;
-}
-
-static bool pte_test_and_clear_dirty(u64 *ptep, unsigned long size)
-{
-       bool dirty = false;
-       int i, count;
-
-       /*
-        * 2.2.3.2 Host Dirty Support
-        * When a non-default page size is used , software must OR the
-        * Dirty bits in all of the replicated host PTEs used to map
-        * the page. The IOMMU does not guarantee the Dirty bits are
-        * set in all of the replicated PTEs. Any portion of the page
-        * may have been written even if the Dirty bit is set in only
-        * one of the replicated PTEs.
-        */
-       count = PAGE_SIZE_PTE_COUNT(size);
-       for (i = 0; i < count; i++)
+       for (i = 0; i < count && !test_only; i++) {
                if (test_and_clear_bit(IOMMU_PTE_HD_BIT,
-                                       (unsigned long *) &ptep[i]))
+                                      (unsigned long *) &ptep[i])) {
                        dirty = true;
+               }
+       }

        return dirty;
 }
@@ -559,9 +546,7 @@ static int iommu_v1_read_and_clear_dirty(struct
io_pgtable_ops *ops,
                 * Mark the whole IOVA range as dirty even if only one of
                 * the replicated PTEs were marked dirty.
                 */
-               if (((flags & IOMMU_DIRTY_NO_CLEAR) &&
-                               pte_test_dirty(ptep, pgsize)) ||
-                   pte_test_and_clear_dirty(ptep, pgsize))
+               if (pte_test_and_clear_dirty(ptep, pgsize, flags))
                        iommu_dirty_bitmap_record(dirty, iova, pgsize);
                iova += pgsize;
        } while (iova < end);

>> +
>> +static int iommu_v1_read_and_clear_dirty(struct io_pgtable_ops *ops,
>> +                     unsigned long iova, size_t size,
>> +                     unsigned long flags,
>> +                     struct iommu_dirty_bitmap *dirty)
>> +{
>> +    struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
>> +    unsigned long end = iova + size - 1;
>> +
>> +    do {
>> +        unsigned long pgsize = 0;
>> +        u64 *ptep, pte;
>> +
>> +        ptep = fetch_pte(pgtable, iova, &pgsize);
>> +        if (ptep)
>> +            pte = READ_ONCE(*ptep);
>> +        if (!ptep || !IOMMU_PTE_PRESENT(pte)) {
>> +            pgsize = pgsize ?: PTE_LEVEL_PAGE_SIZE(0);
>> +            iova += pgsize;
>> +            continue;
>> +        }
>> +
>> +        /*
>> +         * Mark the whole IOVA range as dirty even if only one of
>> +         * the replicated PTEs were marked dirty.
>> +         */
>> +        if (((flags & IOMMU_DIRTY_NO_CLEAR) &&
>> +                pte_test_dirty(ptep, pgsize)) ||
>> +            pte_test_and_clear_dirty(ptep, pgsize))
>> +            iommu_dirty_bitmap_record(dirty, iova, pgsize);
>> +        iova += pgsize;
>> +    } while (iova < end);
>> +

You earlier point made me discover that the test-only case might end up clearing
the PTE unnecessarily. But I have addressed it in the previous comment

>> +    return 0;
>> +}
>> +
>>   /*
>>    * ----------------------------------------------------
>>    */
>> @@ -527,6 +610,7 @@ static struct io_pgtable *v1_alloc_pgtable(struct
>> io_pgtable_cfg *cfg, void *coo
>>       pgtable->iop.ops.map_pages    = iommu_v1_map_pages;
>>       pgtable->iop.ops.unmap_pages  = iommu_v1_unmap_pages;
>>       pgtable->iop.ops.iova_to_phys = iommu_v1_iova_to_phys;
>> +    pgtable->iop.ops.read_and_clear_dirty = iommu_v1_read_and_clear_dirty;
>>         return &pgtable->iop;
>>   }
>> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
>> index af36c627022f..31b333cc6fe1 100644
>> --- a/drivers/iommu/amd/iommu.c
>> +++ b/drivers/iommu/amd/iommu.c
>> ....
>> @@ -2156,11 +2160,17 @@ static inline u64 dma_max_address(void)
>>       return ((1ULL << PM_LEVEL_SHIFT(amd_iommu_gpt_level)) - 1);
>>   }
>>   +static bool amd_iommu_hd_support(struct amd_iommu *iommu)
>> +{
>> +    return iommu && (iommu->features & FEATURE_HDSUP);
>> +}
>> +
> 
> You can use the newly introduced check_feature(u64 mask) to check the HD support.
> 

It appears that the check_feature() is logically equivalent to
check_feature_on_all_iommus(); where this check is per-device/per-iommu check to
support potentially nature of different IOMMUs with different features. Being
per-IOMMU would allow you to have firmware to not advertise certain IOMMU
features on some devices while still supporting for others. I understand this is
not a thing in x86, but the UAPI supports it. Having said that, you still want
me to switch to check_feature() ?

I think iommufd tree next branch is still in v6.6-rc2, so I am not sure I can
really use check_feature() yet without leading Jason individual branch into
compile errors. This all eventually gets merged into linux-next daily, but my
impression is that individual maintainer's next is compilable? Worst case I
submit a follow-up post merge cleanup to switch to check_feature()? [I can't use
use check_feature_on_all_iommus() as that's removed by this commit below]

> (See
> https://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git/commit/?h=next&id=7b7563a93437ef945c829538da28f0095f1603ec)
> 
>> ...
>> @@ -2252,6 +2268,9 @@ static int amd_iommu_attach_device(struct iommu_domain
>> *dom,
>>           return 0;
>>         dev_data->defer_attach = false;
>> +    if (dom->dirty_ops && iommu &&
>> +        !(iommu->features & FEATURE_HDSUP))
> 
>     if (dom->dirty_ops && !check_feature(FEATURE_HDSUP))
> 
OK -- will switch depending on above paragraph

>> +        return -EINVAL;
>>         if (dev_data->domain)
>>           detach_device(dev);
>> @@ -2371,6 +2390,11 @@ static bool amd_iommu_capable(struct device *dev, enum
>> iommu_cap cap)
>>           return true;
>>       case IOMMU_CAP_DEFERRED_FLUSH:
>>           return true;
>> +    case IOMMU_CAP_DIRTY: {
>> +        struct amd_iommu *iommu = rlookup_amd_iommu(dev);
>> +
>> +        return amd_iommu_hd_support(iommu);
> 
>         return check_feature(FEATURE_HDSUP);
> 
Likewise
