Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428897CD713
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 10:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjJRIyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 04:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjJRIym (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 04:54:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF321C6
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 01:54:40 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39I74O70023674;
        Wed, 18 Oct 2023 08:54:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=5+FVtkDpSGzYa3sOG79cto4+ta91ochxvrx1mBwA1xI=;
 b=Sil6808BRLn4eH8sOFb/k/XJa/La3W8XTG8LdjVuI5zq2W+3xq1MQbwhwAk/S2fIpkS0
 wve2di4GDm66iTjMLD0Fylj4FLp7xGPpt5Ar7VROpeDEx8Waru83Jp4io7ndbWz2qSlQ
 7edJFQDXFagrbBxMvXQma1ooS73UTCmsHjr5DPBwcgKVVOJW+5eDg1A8PC25j/w/GuCn
 ojBrggfUXnKYPq+0E4ke/2Qp2I9z2TlP/dYZLHd6L2e22y+mJ3u5CWFkd0NtulrqgSll
 Smr7yic6901cLJqyqp1iQWX5pEA6i9I+UBcQymWQwiInuqXL85OvECEeYIc+ygg/pFHF LA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqkhu72au-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 08:54:05 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39I71B7n009788;
        Wed, 18 Oct 2023 08:54:03 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg0nxt49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 08:54:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L9MSj0FaQIzvHtIPmk30NU1lfrJnxiq2zQdtghAaLZdEvG+piU+qIccgDP46JV4B/hn5e5AdttYpstiwVWH5BQVWbVbyA7nNwhfCeE/d4ttFOaI5yGgyst0+EQtebiAF8BDoS/HxrRexKbKf4QO0hYgqrEhPWHyUEtU5nsPmY9YHO2EtYtm1K3UxGAfKk4m06HCwhKpN5uMTxyKcv00CGK+dnDY89fKDRQpW9zWD7r0Szg/8Wo5Z9f8elKCgqTftPDnvU+aXdtxVqEQb7fiEXXHNBk+gKXQAk86JSfmWrK36gKy588kGONlxoZ/YuwDTzWIYEtSO/19JHpJRJQceAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5+FVtkDpSGzYa3sOG79cto4+ta91ochxvrx1mBwA1xI=;
 b=KciwMiSwvhC4kjI7Y4EQKIQHGUW+zf+MQdbK46upBbYwJ/FjDmejqSph82M4ZUq7xIQdREFGZlhDkN2QeAoGAfyia3eF1eB55GqZTRyAz7aT3e6EWkNU24Og+VcT6i8JXjP499HdsXs2IkFESAUy3uslekgQPto8Uxf9CuVYTigwPbY46WMnH4LsLWHZ+V8r8hXrYyGFipTlbZZ+xg6tYJwZSWFB24vsJonAgU6Aliifg65HU6u+cuPxOSrXbPolhEAsS6CM29CnVWzmupW541NBEU9YiS5iLbWD/uA3KpSnrxxJvmFQVSla784AjTKka1jen/6xCAOCkSqDfCc/MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5+FVtkDpSGzYa3sOG79cto4+ta91ochxvrx1mBwA1xI=;
 b=o1WoDSJnEgK5KY7x57RxCI45XLPaElIZUGot01bCOpDQ1EbUZDadx6Zi2JqoHTktF621Pt16ogvo+kl9dttInf7c8xrkLyGKv+U5EpM8zEtwCmrDLggVkTQOh6eLJGhLJTepetWsKPSJmJXflqprRxpqtIPrardaF7J3Mq0MHEM=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by PH0PR10MB5612.namprd10.prod.outlook.com (2603:10b6:510:fa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Wed, 18 Oct
 2023 08:54:01 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.022; Wed, 18 Oct 2023
 08:54:01 +0000
Message-ID: <e128845a-c5f8-4152-9781-cd7b5026ea8c@oracle.com>
Date:   Wed, 18 Oct 2023 09:53:54 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 18/19] iommu/amd: Print access/dirty bits if supported
Content-Language: en-US
To:     Vasant Hegde <vasant.hegde@amd.com>, iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-19-joao.m.martins@oracle.com>
 <b7cb98c2-6500-1917-b528-4e4a97fc194d@amd.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <b7cb98c2-6500-1917-b528-4e4a97fc194d@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0026.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c1::18) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|PH0PR10MB5612:EE_
X-MS-Office365-Filtering-Correlation-Id: fa506628-1a46-4856-8061-08dbcfb7c625
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jVZ8SETYS/Mi+0XTiaxwqQ2ahGx+gailDqG6FEq11VBEhrW3jyaJF7Vc59/sivVIhIis11cXaPM+b2JPDUL31VYLyZ/qvONXCJti0sI6I8+LvtKxDfgjSIQnO4E1m22L9r/dWjLttMZBegNudTJjhlshNElrc53fvewfTBwPCKls46AB/8BP8a9nlncVkJchCzzJ639e6/4imyyZNcay0v6M6FejWmax+B1s0klxvZtP0qAkyyL6UERryIcmJ6rN9bJR/o4bA7w+DKprdCZE4PtY5XNYYjNo3aOb2za7jUK4j4C7w97N19Hf5+yxNDC8m9ikr5Qr1osKpVgKn3cDkh/mOJBBpTGp+2Gg8f1FnavR1rzQVCWypLI2o2+d/7m3k0+OT42zD2TtHYJjJnk6RN1BgAh6QS38hwRk93Jt/iH6Okx2m9llsPNOJgBkkc7cZcxKbKa1JtFMZ7PisRm01kRqnp1ehp48C6xwu/ZhCreZF4KnK/Tu2IcLpe/F0RIM3GJ8wx3rJWnKREQO5N/WRHT2OSH/ItU+2ZvI1UmfNzb0nU1fpGpiKUIP+zC69lhnzT3BMvK4WC14hfkARygJ62AIrJ12bthKNLNvanVpB6CFmMBoEDLayGiiR2It1Q+zyz5pQZRgEr2gID9128MMw7y0nGGABH51Sp5jlbOy6mQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(39860400002)(396003)(136003)(366004)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(26005)(6506007)(2616005)(6666004)(4326008)(966005)(53546011)(8936002)(83380400001)(316002)(5660300002)(41300700001)(7416002)(2906002)(478600001)(8676002)(6486002)(66556008)(66946007)(54906003)(66476007)(86362001)(31696002)(38100700002)(36756003)(31686004)(6512007)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUFpRWxkc0IzcnRNeC9zbS9ya2JyMm1mdHFLM2ZIUWJSdkxOZmwrd3E4L1pN?=
 =?utf-8?B?bVZlRmhWYThoMlhwd3p5anVRUlNhM21sRzNSbFJCV2dCSzFUQlVtT01QbDY3?=
 =?utf-8?B?MExtYUdRTE9CKzgyR25CTXZNN1V0Qkx4K3ZyTW0yOU5NRVNaZkxlU3phS2pO?=
 =?utf-8?B?K1F1emFXd3BZTDdVNndaWVJ5OG1NQjQ3UllTam84a3ZwdmhTWjFJYTVYVDJr?=
 =?utf-8?B?MmdRUTEwSjZiNVVuNVdoRjRrampKWkFDQU5WcmVneERMZDZCRHk3TU1vUU13?=
 =?utf-8?B?Z1MwRlcyWFVNQys0b2xkL3hhbUNaZjRRYnBVTzJqQmhkNG1lbldrUnZCWm9U?=
 =?utf-8?B?ZVB6NUJKaHkvaDYyNEFreWkrZmNpWVJjOGI3L1VGMVZIVFdrNXQyN1JudFVw?=
 =?utf-8?B?Q1B5RzgvMGlCYVhYS3pVSVNMek1zalFaK0dTMyswa1dWWHYydSs0Z2FCWEN2?=
 =?utf-8?B?QXFtWVMwWTYzSXZDZkVkZEVjcDdyVkFUYzRmZWk5alRIRGM2RUxVOTZobFhy?=
 =?utf-8?B?R01tdGI4bGg4TlBkSStwL1U1TGpqMmcxUG1hSTRCT0lxNW1weTlVT3RIbTIz?=
 =?utf-8?B?eDRxeWVmTFFmWm81SUt1Q0lCOW9US0pJRmtGSFFWenhKdFJnTmdlQ0lseFc2?=
 =?utf-8?B?ODZ0M3RYMmRIUWx1ajNLVDNEWSsySDN1b0NrTW1WVHUvQkhLSWlVU0ZDOEl3?=
 =?utf-8?B?Z3c3R0NIcFRaZndmWnZtZHdXalJ3T0czcmkxY1RpRlVtV1NZRDFkZUZNUGds?=
 =?utf-8?B?aHY4emQ1M3MyYmxmaVh1TS9UeFRNdjNCNUFBZ0tuQjJuL2pLVDBYQWUxMFBi?=
 =?utf-8?B?bVExTDd1VFlKbVg5NFkvWmFsSXdZdkZ1YWdNenRUbTRSaHNzL1NBbC9iTmRN?=
 =?utf-8?B?TkFaWmRTMTc1ZHUxdnd5MzRhODVkNGxnRHVMTDNrUnZtNXFVTlEwM1ZncHFH?=
 =?utf-8?B?blVoY21kTUJ5clQ0cDdTdGM4ekx3T1d4ekcrUTI2U0gxajJmWUw3WVFuT0wv?=
 =?utf-8?B?b1p3Z1l5UUdaRm1WYVlZbTlkbHVNOHBkK2l3MXhxMVBjRTNLNWJJWHFhdlFM?=
 =?utf-8?B?NXFhdkR5bFNLSFVBS0N6K0gxWnMvREh1ck9qWDBxMHIxTEFJYkV1UE0zU01q?=
 =?utf-8?B?QTU5QXA2ZmRib3E1OWlOQ2FwYUNwKy95T09BdldhTU4wVlg4RncwU3hTSjl1?=
 =?utf-8?B?YUhTNjRKZmdydk1Kalp3bDE4WW5nQ2w5TVNyZWpKNlhpRGI4R0pNMFJXa1F0?=
 =?utf-8?B?dEI0TDlyUmZFOVk0VjJWWDFsbzB3V2tzWWMxL0c1VEhmM2tWZldxeDViNWta?=
 =?utf-8?B?SUlUL2RMRDFPRjd6dEhOaTNLV3kxejczSmpWdzkzakZkc2JtejcxYkZCV0tE?=
 =?utf-8?B?WFJzeHExaGVMZjNXQlh3MVdQTmUyTlRMVnN5TUpEcE5SYWdERS9mNGhWUXVu?=
 =?utf-8?B?Y1A0L2g3S0VIRjc5M3I2U1Q1YTVzS0JwQXBoN1JlNzhYREZQcG5NN1ROT2Jy?=
 =?utf-8?B?N0s0bG80d1d5K01OdjVoRWU1SUU1cGhxZGNRSU9mSkwwWEwzMGo0UUcwdnI1?=
 =?utf-8?B?ZWNPWnBUclRIOEhCZm5HTE1JNVdKTVdlOEE2RWpKNmowK2pVWUJLa2wwcmNL?=
 =?utf-8?B?S1FDS1dUM1pYYm02OHFJSjB0ajIrb1YvYmtuTUFIYVZ2V2NXZk1nSU5GTExR?=
 =?utf-8?B?M2ltZjVXT2xxZFh3TW5oSmhZTlI3STY1WFdmbW5TTzYzYk1KSCtkNDZUTzh2?=
 =?utf-8?B?YUg2U3Zvck5iZFJkN0FrajZ6YWxibnp2eGZ4eEJLRHpHTE83bFh0SzVQQlpl?=
 =?utf-8?B?NmlMcERZaDhRbDNuenFydkJBODJPb2NjaTB6WmlaN29GNmlVcTYzZ0tMdmNj?=
 =?utf-8?B?UFRjUmhRT2Y1ZFcwK3dTL05OVDFmRm9aRzdOY2hYQ2diUUdkb0xLcXF3Z1A0?=
 =?utf-8?B?WS82MXJBbEJHSXBvcUhFc05GV2IxYlF2cmlUcjhxT0hVa0I3dFlrQVlyNDJF?=
 =?utf-8?B?NlhSZ2RtMjVrUmJoYTRNVFVybjZQZ1djR0JkbG9GclViVnhQeWZKaW1Ma3JB?=
 =?utf-8?B?ZGRwNC94WEFBL2tuZjUyVVBEODlBOVpVRkpVV3dlOHVzN3NST2JRa1h0L2Zt?=
 =?utf-8?B?OUFZRXlNYndvYm8vQWtEQUc0b1loekM4Wkxtc2taY0xvTzRTWXZvWnpRY1B3?=
 =?utf-8?B?ZWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?dEFMaGMrdFNCdHorQjJuaDB2UGhrdmRuRmtOZ2hrYWxoR0JyMzZvN2RFYXM0?=
 =?utf-8?B?RUJ0WmNzNmp2ZHJlbVY1cHZ2VEYrUEIvQVYvQ3VNSFEvT1FpbGFwYU1tNHIx?=
 =?utf-8?B?U2pqN3lvdXhvOTI5ZEd4ejd5VldhbWdkeHRRMURjNERJbDlQZ1QzMUxRRWJU?=
 =?utf-8?B?YzdvOVdEMHBzckh2dHNKOWZCZEZDZkNDNDNNZHRNM3k4SXkwNGNacEpDbElk?=
 =?utf-8?B?UFRpT2NCbklHd3VISHFPRGRKcCtFNmFOQ3haTkU1enYvR0psWUhsSE50dXNU?=
 =?utf-8?B?U1RjY0tMdlBEVTk2U0F6ZlJBcXhDN0lEempPd3JLdE12N0hqYm1YbS9ad2k5?=
 =?utf-8?B?UTB1aUthOWJuR0o2aDAxR2hUMTYydUVscFJtUFlTMGExaGUrNWkxV0dKcmo3?=
 =?utf-8?B?WTFmMWZpR3lrRDlpUW1Xb3FJTXpEdkNYQ3BUaW1vSm5xL01wUnNIR0UySlZm?=
 =?utf-8?B?dVRZVngyNllHeXl0NHFBRmxBdUliZWszM0lDaVJQSjNqT3N3czdGUlY3K3VC?=
 =?utf-8?B?UThiWjd4V3lGZmZoRmduNXM2VmtoNS9IajdvOXdaZWw5ekc4SFpuRTl4U2Rp?=
 =?utf-8?B?WTkxTzRUYnZFaVVnTStyOWZEemV3Uk9PT2tBWjBYVmpYb3IyZnIrWXpoSmw5?=
 =?utf-8?B?NjJrbWhQaFhpb056c3I0OFA0R04zb2hmbGJiTmwycHgrdGlielpIcHRpNUJj?=
 =?utf-8?B?bGhKTW0vNGtBOHpiT3ZkZzRsRCtUOFBSUUZtVGZkQmthUC8wdzdoaUxsc0hS?=
 =?utf-8?B?ZkYxc0NpRnd1NUMvMWhZMGV1UzJTZU96THIyUG9kbG1vaHZ6VVNoYjl5ZmJW?=
 =?utf-8?B?dDF3SXh3V0NoS1RNSGZzVGFBcnRxSDN3dXIzMHRhWm9nN2pRR3JWUTVqUEZi?=
 =?utf-8?B?RjF3SXhWdG13M0VLc0s4bW1iT2NkaERNOVo0NnFMcUROdlF1UEkybmZOVmZE?=
 =?utf-8?B?WTZxeXJQcitybGJIbmVZSUx6V3pXUXhZUFpxUGNobVJ6clcyR3dWaEc2d1lK?=
 =?utf-8?B?b3Q4Qnd6YjFYcXRkRHp2b3laSzBMbW1OSmptODNFNHU1T2NYVjJDOHgxU1lt?=
 =?utf-8?B?ZkhyM1BraTBzcUZOWVZWdmlIVU1LTDd3Ui9WSnhUVU5sWkxpQlVOekZQNGFs?=
 =?utf-8?B?K2huNkh3SjkzT1lsUVp5THZqU2dqekZFTjNCcTVMV05nbW00YlBoUkMvYm9n?=
 =?utf-8?B?c2RiOWxBMFdRNWtVeHRVQU9TQWp0VGZjWGxQNDFMaldSU0FxZFZMSW9WL1hv?=
 =?utf-8?B?ek9XTG12b1EyVEpwZFozNFdqZUI3dXNhNWpuNlVFcXQ4UWw0c3UwZ0xucXJz?=
 =?utf-8?B?TTFqL2hUK1RiVkQ0R2U5S2lib244TFAvYWVqbUlLc3lKeFdwWGZlRWhmYk1t?=
 =?utf-8?B?TnExZU1lZWZvRDc1am9UN2ZxT29kM0sxcm9FTUcwLzFkWHB2WTB3WHdxQmRi?=
 =?utf-8?Q?SaYU4P2a?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa506628-1a46-4856-8061-08dbcfb7c625
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 08:54:01.6254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HSuX8IW6GHZHZ++OQvH7zSNEOg0jvHXZoN9Rs78ET5c/JZtecYC+0N8Om2gWbEV4FB3/NGEjonrDkJl9wVAWPEYd/ARS/mZbBb2b1gnw7Os=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5612
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-18_06,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310180075
X-Proofpoint-GUID: _HBB7bAtPsUdHNYVEiwtiT-XoD9wbiQL
X-Proofpoint-ORIG-GUID: _HBB7bAtPsUdHNYVEiwtiT-XoD9wbiQL
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/10/2023 09:32, Vasant Hegde wrote:
> Joao,
> 
> On 9/23/2023 6:55 AM, Joao Martins wrote:
>> Print the feature, much like other kernel-supported features.
>>
>> One can still probe its actual hw support via sysfs, regardless
>> of what the kernel does.
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>  drivers/iommu/amd/init.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
>> index 45efb7e5d725..b091a3d10819 100644
>> --- a/drivers/iommu/amd/init.c
>> +++ b/drivers/iommu/amd/init.c
>> @@ -2208,6 +2208,10 @@ static void print_iommu_info(void)
>>  
>>  			if (iommu->features & FEATURE_GAM_VAPIC)
>>  				pr_cont(" GA_vAPIC");
>> +			if (iommu->features & FEATURE_HASUP)
>> +				pr_cont(" HASup");
>> +			if (iommu->features & FEATURE_HDSUP)
>> +				pr_cont(" HDSup");
> 
> Note that this has a conflict with iommu/next branch. But it should be fairly
> straight to fix it. Otherwise patch looks good to me.
> 
I guess it's this patch, thanks for reminding:

https://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git/commit/drivers/iommu/amd/init.c?h=next&id=7b7563a93437ef945c829538da28f0095f1603ec

But then it's the same problem as the previous patch. The loop above is enterily
reworked, so the code above won't work, and the "iommu->features &" conditionals
needs to be replaced with a check_feature(FEATURE_HDSUP) and
check_feature(FEATURE_HASUP). And depending on the order of pull requests this
is problematic. The previous patch can get away with direct usage of
amd_iommu_efr, but this one sadly no.

I can skip this patch in particular for v4 and re-submit after -rc1 when
everything is aligned. It is only for user experience about console printing two
strings. Real feature probe is not affected users still have the old sysfs
interface, and these days IOMMUFD GET_HW_INFO which userspace/VMM will rely on.

> Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
> 
Thanks!
