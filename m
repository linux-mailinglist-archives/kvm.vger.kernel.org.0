Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463C37098CD
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 15:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbjESNz4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 09:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbjESNzy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 09:55:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB31107
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 06:55:53 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34JCicl4016699;
        Fri, 19 May 2023 13:55:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=5vw9+4qdSAPUq9WYVvV9WuXmlmnQGsn8mmZs0jZxCfU=;
 b=CSliwow1AnebQUHMflMwuhieCK6Qb8iPv4c/sI6cmQhu3G0gPiVqQyBCgCFNSLDL7rH3
 SIjcgGedYacjeKXe2YMgh4ODD7v3fhIJhyrpUVkHe9fQwuSEFi2AdHLUu9FwHdXIvNJT
 PatJsiYQT+FbXXT2oqdhpurKFCkqH9TqS80IgHm9+Oq5PS20aWn7Q+zip3Idxtjlz8KN
 OXf4HAJX6ct0q9fCIV8WiB2laa6R+lWhbBmDjhq3EelEsVBlT7BTzD7QdxTnOIgBwef0
 hBgJNzb6GHmtPVJQ5o8a3WzckH85oZ+VOD7zKC8RjOgcjjuZYqLBXlRUpKNYotBrgas3 2A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj2kdtn86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 13:55:24 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34JCVkMt040023;
        Fri, 19 May 2023 13:55:23 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2049.outbound.protection.outlook.com [104.47.56.49])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qj107v6k6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 13:55:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZbkTFTN23V4hE3t5S2ePgF5ngLcCo5SUA2UJNqU0qTCQNq0jb04+gFkHlic44l209yXnIe+WWgtTTw6NmAczE1keRypcisK8apA+/rmWInHChNzOgCYNd5TKFt/DLvnQYUauOFSJvPaXvOmdXUxTAd1zj96y5gtLKzJrmFMkjsb0mSHnxxzgs7urYr98RxxlqRpYePDq2HgTE39ou1WHluBbaUmgVllX1qZfirztnvkQB01inoZxGGeGLSORdxGWqnLSU6hCRsSTKSC3wpPM3E1X9IjM+iKI6hVLvfISNH2QsTW3J7EZK0Kn5Oy5W5AULtN/5z8Acm2W33a1sLZKhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5vw9+4qdSAPUq9WYVvV9WuXmlmnQGsn8mmZs0jZxCfU=;
 b=jPoREGzd4Z7i8OJYDPlWSmgqeB2XfcaWvFyQOKZYb3VpKC1TI+xVDSYBTWLlaJWs2bU5piM5dFnL8vpykYmDjqGgE0dJjJlnnZugL4T9DJ7dfDxvvlgKkbC/mAvzN+vgesS7hE8Lh+LD1bIZfH0LsdEvL8GuUirGFoRF9p67OYoamNKNz8OPpt7S2cJvtrJ/aDLuwKb3Gnlll6DXnfBuhwrQBhDQysYuuhiW5mFCM7Tn24YC/QDeSNEp3IrAcuvlJDmAmDLFlw2x78R+VAjKxjxZXZTv2LeBxk5HH7A8KL3J5++zCb21FHRQjJWOaZ5VoCWqOtBOWV4QylQHlIwJMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5vw9+4qdSAPUq9WYVvV9WuXmlmnQGsn8mmZs0jZxCfU=;
 b=GNlBopIRLUr1TUyuTX9V9IJUWwmRqG1d5R9E7w/DC0VV4NySLUecl2M/El1+x3pd/ExMkYJw4Qmrcb5Iu9wZTH7tmQWT+VnymTRUX8Jw6i/m0nC5Eofoc3oqxVk8FLX5vnI+hqiVpQixmTv2Qyidt7+LaQidk5HoVH8gCZ/orDs=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SA2PR10MB4633.namprd10.prod.outlook.com (2603:10b6:806:11a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Fri, 19 May
 2023 13:55:21 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b%3]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 13:55:21 +0000
Message-ID: <86074994-0be8-5687-cccf-04c5af85f509@oracle.com>
Date:   Fri, 19 May 2023 14:55:13 +0100
Subject: Re: [PATCH RFCv2 07/24] iommufd/selftest: Test
 IOMMU_HWPT_ALLOC_ENFORCE_DIRTY
Content-Language: en-US
To:     iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
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
 <20230518204650.14541-8-joao.m.martins@oracle.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20230518204650.14541-8-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0025.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::35) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SA2PR10MB4633:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c31809c-9aef-42b3-3a7a-08db5870af7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mh4VvBZsCP4FIAryRhHk9B9Fae3ghRjTZcc/gZxatewtbht/QiteNJ4vscQmd6IeUZzMD7nXhCLD2ZG4X5U8i1qBjGa/yFljyRSbQCP5SQAldFT4iWNHJt4MDCDgHUMspB/cWCnyiv4yWIOnlqKSudGufl19mnLGclbRC+xsuecXopF0q88lU28jPuncOFH61KfkKlCmG04fS5duyW0hHPUHQD3zHkilERrn1pcfQ26L6RX6XxKBsuJ9RQbMqP6juKS+ISNpmjFTsvtMu56b5C2B9m8yjfrXdYvFPwkv2oEcp5/y7j+69Jkq92lhl7Ik/p/5umrd1A0eA8VZwrqrwS0yzyYfFeKUM8DrD/nANULnDB4l3joetEjlYNnlNq2UAILa2bKMH8k3Yhw6NULozX8oEbsOXR+ZTdGiOp25ZBbshJcqfpOwYMDBWLWhjUXFX3gzlbjFLhj1PL5Likey+ndJdDysAgz/tZgvZlKcSmU3CCovyQQTLd9MjYKCCV6nd1eol3U2MkPf18hOlsM0KI2Ko9PtRZRwHZLSMkhwTrjgLL3MgXrPbAwWwZEGzLAdXmvcHxY29rWyILrBqqHsDkkgO7z+PiFaaT/i2FjbASN7+UORsemoPzbAl5ug0GTTG5Q2Mvy2Th1DRTmI7LQH6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(376002)(39860400002)(396003)(346002)(451199021)(5660300002)(7416002)(8676002)(2906002)(186003)(8936002)(36756003)(2616005)(4744005)(31696002)(38100700002)(86362001)(53546011)(6512007)(41300700001)(31686004)(478600001)(26005)(6506007)(6666004)(66946007)(66556008)(66476007)(316002)(6916009)(4326008)(6486002)(54906003)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dzNCQkEyZm0zT1Faa3R6UUhJMUN0dmg5WHF2Yk5RSmpmOFFVWFRVd2Jkc1FP?=
 =?utf-8?B?VHhvVGRUQi8rMjVsTFdJTXRZZHdqb0czMitNYXF5VHdySC90Vk9ENDFBTXNo?=
 =?utf-8?B?cmN5ajFGY1pEREN3WmVWWFBsSVlMWEZvd25oMitJcnZHVWduOEJXNzV4K1hq?=
 =?utf-8?B?M1RMZktpWDErcjh0MW5WTDNBZlRBSENKeHo1czZpekNPU3ZnRElaR3pGajVJ?=
 =?utf-8?B?aW1RSlN1WHpCZ1hUY3hnN2J4ZjBsMWVVRlRWRFU1YkhTdGNPZS81bzNhL0tz?=
 =?utf-8?B?SnVkY2JScUt2MEUyOEVpaTdUTkxOZDlTWGUxVFRYb2dZUURseW9EMkQzQ1lF?=
 =?utf-8?B?cEk4Wms2OGNHSldEQlhvOVVyQmJ5ODJLMFJMa1pFTVBSN3hxcEdxdTNOMnpr?=
 =?utf-8?B?c1RDRHhCRXVaSWRQSkZ4cW1Xb1hpTEdKMXpUbWpPcnFDaHBZOVRQTm1KUEs4?=
 =?utf-8?B?MEhqeUUrTTA3MDB6MCtVcWp5WDBsRHBPMlNSWjNRUWlCQnJNSGd5TDVCM09T?=
 =?utf-8?B?dm1tNDRLK1BYR1R3MjVHUG5pQyticm5YSzhqK0tJTDlXVEJhcU0wRU9LWU5a?=
 =?utf-8?B?T3VmV3h0ajJPd0tUU3grblVYQ2JPdFdSU2h2Wlduck9hQkxqOGx6cVBtZkdY?=
 =?utf-8?B?OGp3QXRabWVJTW1WanN0dnBkbC8rc0luOUFkc3hjZzlaem5mNWJvT1ZSeStz?=
 =?utf-8?B?V01pMUdMWEFqYjJvckN3MWxKbkVwS2tqTmtncUxkVllHSnJFbWFDdGF1TXBo?=
 =?utf-8?B?azVlL1QwdXQ3bnE0aHUxd1JRaURNMnJ5WlI5MDhTck1jNUpHV0dTUjVNREI0?=
 =?utf-8?B?SjBteVRwSkM2cStkYXdKMEZIZUxuakEvV0hrTXM4Vms2NnpzYVd5NXErWFRh?=
 =?utf-8?B?dXhVaU4ybGxNeDV3L0hPU0FnNUJHdXB2WVhSaVNIbXFjb3hqVUdhYS91Y3R3?=
 =?utf-8?B?aW5jUWM5ZHQwalR3azF2OEJyWDVOQWovZGVJZzFsMHR3cGgzRkY5azZNRWwy?=
 =?utf-8?B?M3Juc1NzdjdzOTNVMnViRHpPQjNEZnFoczBJTHM5QXl4eEhubDBKclhNWVNT?=
 =?utf-8?B?azRXNjNMN2tsU3VzcW5kSUFXRHNwVUlOSzFlVXZtbCtpYVNqb25pWGpSVDF3?=
 =?utf-8?B?VHN5RXl4Y1JscVZjRlR3V01sdXVJKzRseE9DZ214dUg5a2sxdDZITmlNSElX?=
 =?utf-8?B?d3VUcWZ2Sjd6dndiYmdIdEJJRGxhdGFDelF1U0lWZTRSa0QrZmlKYThVM2NF?=
 =?utf-8?B?OGpjdHNCWVJZcThVMFpKRURlYVAwN240K01TcHJlNWE3VlFWcFZvZERQRTBw?=
 =?utf-8?B?YXFXN3BQSjJ2V1k3dWtJYkZ2enI5NXVjbHpocTZoQVAzTmUwZHg4cHlMbmpQ?=
 =?utf-8?B?TXZWbjh0SHcxRDB3amhSeU1ST1l4cE1Oekc4SEwwR1ZtMFNGYXR4RFRJZlU3?=
 =?utf-8?B?V2tubkdHK2MxdmR6Z3FnZFR0OW1yR3h1bk41RDF4UGRXald0M2JZeTdXL1Bk?=
 =?utf-8?B?NWdEN01mUUdOaWVxdU4rRXh3cmg1bjlvUk1xcW9NdlBQdjhKNmNsRi8yWXJD?=
 =?utf-8?B?VTBqd1FBdmNHemZlU2hUbzg0dWZiMnNTM0g2K3haeXlPbDlnOEFyb2h2SEpL?=
 =?utf-8?B?dHA3dGJHQUhWZ3hQakFoTm1hWEVWOVdlV2JhRnZPcFRWMkc4aU94UTRMV293?=
 =?utf-8?B?WFI2dFhRRkpFMXNic2JmOVRKN09pRy9XaCt1QWJ0USt5ME10bGEzM0RDOEdk?=
 =?utf-8?B?MmpCVmF5NVlVbTJJWmZ1K0Q2cTA3c2RhYzVnM3B4eld2ZWpLTkwwdTFNWGlq?=
 =?utf-8?B?dnpUL2haNGhlOUFsY1FYQzRvbHBrL2EwTkw2d0lOVTExV0htenF3UjI3SkNN?=
 =?utf-8?B?SzdDb2Jza3lZeDcvNmdsM3lZQjllb3duck9CUDdGQzQ4dERFK2pvNE0yTkdH?=
 =?utf-8?B?aERtNmQrcVJDUThDQTZGeUJwQXdKV01kcWxDYU95Q05WWkhObEZtQlYva29N?=
 =?utf-8?B?SlhSdkxIZFpEaVBHdUw0TTRYZXZWSnM1cHphMDA3U1Jla3FGS0VOcGU0eGZQ?=
 =?utf-8?B?L25pdUJWUnEybkM4aCtHb2xWRUVoMDQyR2ltcHZ6TjJqQXhIbit2MU40dFZI?=
 =?utf-8?B?SW9NTEdRWWRaTG1jNEg2b21ReHZ3dWx3SmxweU5PVEo1a2QyU25nVk4zL1lU?=
 =?utf-8?B?SFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?RWVSY3JrYVk3Y3VZTnZha3B6YXRLWVQvNjRLZTZLVUsyTEU5cFBHTEhvNjdY?=
 =?utf-8?B?MG4yYmxYajAxcFJ0Nmo3Z2I0eG40dm5zdVBEVWNIM2ppTkx5c1NkTDlFVlJk?=
 =?utf-8?B?eEhLb1hJUWs1UHBCUE4yQW5IVFVpdVhlZlhJZDRBS1cveGZKc3RpVGYrRy9F?=
 =?utf-8?B?V0s5QUtkWTByamU4NU9yTGNsTXg2ZVpWZkVTSElvWDJRVnZoYllFV2Fhc2I5?=
 =?utf-8?B?a3NRdG94MlJzMFZSRXpaYk53ZnZNSXBQZ1NFcmJpWk5aemJxcWcwSWFkVzNm?=
 =?utf-8?B?OWFkRlN3Uk5IS250MkZrLysrTUxhQTlHK2lKNFhVNitmbzhJcWwvV0pZZytk?=
 =?utf-8?B?ODdUNFF1TnBTM3NkNW5PMzB1M2o1aHZKSWQ4cTdIOTBjV3R5cnlKdDRJcENT?=
 =?utf-8?B?RnVDN3FhL3pGNXVQRGUxUUlKTWxhVW1vV3huQ01rTzhUWGFSMkZuT3lSRkNv?=
 =?utf-8?B?YUl1V3dDajUweHlLSmZKakxjczVJUWIwMzBLR3BPT2lXSWNsbTR2R3lCWTVj?=
 =?utf-8?B?Rk9nSTBLRmZ4S0I4L3BmTUdZbXZPQmduOTV6YkYwUjMyQ2wzKzRQNU1RYXhR?=
 =?utf-8?B?NGxTRnR1WGJjRm11QUFxN1BFVEhGbHdtaW5jWUdINGkxWk9HaEcxbW9pVmFT?=
 =?utf-8?B?T1liMTRIajBSVkRpOXNFQkpzTmV6U1NraVE2WkV0eUFiNEozWG9ubjVUMXJH?=
 =?utf-8?B?THVlSk9MU2FONnpjYmJudjkrRzQwalNtY1MwcnB5alY5SlZBUFpSME5VUHdX?=
 =?utf-8?B?elpyMDIzUzJjREcyUHcrSHFDZnRwYVNUWGVXTk5lcHZpcmZmTURiVHQ5cHpo?=
 =?utf-8?B?cWdkOTh3NU9qU0tzUHpYRUJKS0hDanZhSisycm44UGdsSFVnaTRBMGlrZjAr?=
 =?utf-8?B?dVVFUTlrQzlrS1pNNzZzYWxZMmhXbUxucmY4Q2tOYm9FNGFPNUdST1lBS2R4?=
 =?utf-8?B?ei9aSjlBVEVLb1pSb2JjY0ZYSHRJc3dtcDEvajNyUjA1cURNWUsydjdJbEts?=
 =?utf-8?B?VFRhc2QydnQyaW5JNm1JbkxtSDdmVUh6UUJlRVBSSUlsbFEwSEZiZTlYWTlR?=
 =?utf-8?B?ZHhkOWJKMWVES20vYklCeEdqbmpsTkNMcm9PalpLWW82K1FEOFNVVUNiNEQy?=
 =?utf-8?B?d1RaRG85djZXRFJJclREaGNtWjhGOHZ1ZEU2VjY0QklqQ0IzWjFvcEQ0MUVQ?=
 =?utf-8?B?WGxJRGxVN1l0eENNbXJyVHlraTZ3RHlyZUl6L0VGVTk1QjFxM3lOaEFabUh0?=
 =?utf-8?B?UmdnNkZXSSsxTnpTVFA3L3NjbEhRbUhjS3l6ZHp4WDdVT1BNMTIrSCtsd1FF?=
 =?utf-8?B?TGdjR1paZE5ZaUFtb1VadmRDS2ZaM0FqOUt6eEtRcUUvQ21MNjM4OVVFZW5J?=
 =?utf-8?B?SmplUndNcWR4Y0VMTWdUZ0p6aEdMK2x0c0xiUTdTOUhWc1doMmZMOFA1Wmtu?=
 =?utf-8?B?Y21lL3pwVS82M05FN3pEcFJVNVdnRytEY3J3czlnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c31809c-9aef-42b3-3a7a-08db5870af7f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 13:55:20.9773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DWaBB9S/xwRnGC7mO56lNQPFF57II1yj9Sv1fc02alR2tU5FQJHjco1DbKhAZjTJ6gQMmu0ywMBiqegJDkvFFVKKxQIaKDE4LPiMi4Hte9M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4633
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-19_09,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=970
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305190117
X-Proofpoint-GUID: 9MfAktqRfWF15xLW67wFsFI-8nMhDbM4
X-Proofpoint-ORIG-GUID: 9MfAktqRfWF15xLW67wFsFI-8nMhDbM4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/05/2023 21:46, Joao Martins wrote:
> diff --git a/tools/testing/selftests/iommu/Makefile b/tools/testing/selftests/iommu/Makefile
> index 32c5fdfd0eef..f1aee4e5ec2e 100644
> --- a/tools/testing/selftests/iommu/Makefile
> +++ b/tools/testing/selftests/iommu/Makefile
> @@ -1,5 +1,8 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  CFLAGS += -Wall -O2 -Wno-unused-function
> +CFLAGS += -I../../../../tools/include/
> +CFLAGS += -I../../../../include/uapi/
> +CFLAGS += -I../../../../include/
>  CFLAGS += $(KHDR_INCLUDES)
>  
>  CFLAGS += -D_GNU_SOURCE

Please ignore this hunk here. I had a few issues with headers for the bitmap
helpers and this was a temporary hack that I failed to remove.
