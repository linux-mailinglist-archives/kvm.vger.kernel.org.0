Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510F87D17FC
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 23:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbjJTVXB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 17:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbjJTVW7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 17:22:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C2C10C9
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 14:22:49 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KD9GMs019054;
        Fri, 20 Oct 2023 21:22:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=CsPMm6eZd3nk6AK7Ky//xAH3FIcCYCJ+80wzXoxyRXI=;
 b=LDab5LczUDpfVqexYwri1QUfyl+RPF0z2ZZNJ70pGizpq6T71yTdvuj0jH/uaj3B9EAE
 XGoZ7tS1l/TCcuEkuKzgR/atR7aiAA1lJCwU8ygsXds5m3F9EzbLewH4loUJ1Dbq/HFN
 p99aPWmVQXplGmiZ0F9HEq1jsBlAL3tO4OJ/QfkhiEn6cZPXy3psWtVkPsMSdcqJ26ja
 wweo1T8TqsmF7fE0tjn7yVlIply75vbPdQYTXkoPSBIHmj9jX/N8Sgq0eiUl6b3FE/OA
 feJnmejnpgFqISwxNLGCRHDsQeQmIdiFrwjKrxZGZaBXYTebK83Vc0xre9BvIvQ69zk7 pA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tubw82s00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 21:22:21 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39KLG4nP012845;
        Fri, 20 Oct 2023 21:22:20 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tubw6huqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 21:22:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PhDDnsNvN8lh29FRjrSE99MEwUaZTXl/nOKk5ukfHcgZWdo/TlN4Td/WTYQTHFs28fwVchfNGEGWciAho8o8dVbLbjlkRb4RIdCTL3TOAV/6V70IfyV2HgVjZkQ2pOrKue21DWT3Mm1Xvvc6fSNu99jAMGyBy38AX4EXrdE18NsXhLZbtDPIw5b5AZFcDYUsLPLoksiMO4PO9aS3oF+Ef61ND3uVKIWQRC+mNRYV/+5+TNdtnI+CZduFku1WlQ/T2uVUS67B9a+pvFCiDnC1RF977CNIgUkvKBcXazg4z8qA89xsxHTKsbxV2mOI74bfPUvm83NZQMECM9gEJdb4MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CsPMm6eZd3nk6AK7Ky//xAH3FIcCYCJ+80wzXoxyRXI=;
 b=R93CfktUn/mfxjDlfoV1TVMGUz9px+CTUqQTz7P8fk9+Q7moHQD13IuQEp7FLKlYGzh5Y0b/tC0epz2VK3/lxFMESX4t1MWu1LT4LD3kWjXdNza2YdZC6kTXGLHaYed7P0d0l9TIJV72Jy3CtLLC4psbeLSqmFt7n24M1TvHCDN0Nxbi2+oCdCiIFw3rvqqSTGGcGowsC2/V8JKKCMJWR0tNCo3Rr1De6Lxkv9793NOiY33RplRCuIY28kVnbM0PmMkap64JX6xFgGgUr5mAHLXqz6QSvXGhO8KVV2m0ZDO4izvquoMltwtrDly2wQfoJ9mcCUxTPja1rWp1gGBjCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CsPMm6eZd3nk6AK7Ky//xAH3FIcCYCJ+80wzXoxyRXI=;
 b=ZhIxBfjwkTQoJ48eWrco8eGvg8pEr6XrRL3bO5893wZ0so2S4RYediaoRj5zKAHUtIVkZ/mRXR+z3LDeoEXsaIUmURHQcKHVIljQVR+lVLe13F5+xNb0MpeXCt5Nk3TaNsNYlyjHJzfHpEffTgMV+3vqH+YoK6clfR6nI0pe8Ec=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by PH7PR10MB6310.namprd10.prod.outlook.com (2603:10b6:510:1b1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.41; Fri, 20 Oct
 2023 21:22:18 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 21:22:18 +0000
Message-ID: <42cdbe7a-a320-44d2-ade4-a29834f02779@oracle.com>
Date:   Fri, 20 Oct 2023 22:22:12 +0100
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
 <f2109ca9-b194-43f2-bed0-077d03242d1a@oracle.com>
 <20231019235933.GB3952@nvidia.com>
 <a8c478f1-209e-46b0-9b91-7cd8afccd7ca@oracle.com>
In-Reply-To: <a8c478f1-209e-46b0-9b91-7cd8afccd7ca@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P190CA0058.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:656::7) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|PH7PR10MB6310:EE_
X-MS-Office365-Filtering-Correlation-Id: ef6ad404-74fe-45eb-89e9-08dbd1b2a371
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tdkoqwed+rOXFGuAEjD2TifFbR/Dy2GYBgNw6DfBIHUMeTzZOW46WoWnsTc1wSaHYBi3TNsG3YrFNQCX1zgO/0GsqfZpRyP+MJM2f4nh8WhlTwJ+E4gjoKQDUBU9NMK8Nx3oi9a6+9G7beFczfpeKnrB07RdJiGM+5AoWP/Zwn9HHCflnoAZ5/JaZqtIFndXEGk3+aGkjux7pK44m9RsobedF+pLbRuAY3flyCz8d6v5i9AG3pbJHoGJ7IbTfosNNGeRiN1W13qdcsMx4s6LILwUXv71wKVdSssNCNv/bHthnGDA8Ga6g2T7/wY8XdO2wsJcAHHcjdYvzh8FS6cE+X62qTujg5++JCcotnkivVUUs/+nM6+XV++8Gx1wcJn+dGz/bN7e9S6869NWFMcfyrE3FQQSeC5c4xYozWa1XOc+tFOFC/Q60uHt33VJE3kWsiCtziuARLOjqFdIZC+W7YrtiDsanoIdK2kX/kZPgX+1OPHnwBibz9XCLlAgr7DoapGMUu7Ez7w71cjFDPRKZVa94tSpC48MPQLNxFxk99SL+0BkMzWprnFCcyu9d3OGEu0qxlYXlaHfqtWs4juMBN7PGUz7sb105iyq5jvArTRiqL8FbP1pwNxkGBxGyadi9b5MBq6KBA7HJPiZUrvvcXRLXyKRU/a7tlhmE2SGjVo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(396003)(39860400002)(376002)(346002)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(36756003)(26005)(41300700001)(38100700002)(6512007)(2616005)(86362001)(31686004)(2906002)(31696002)(6666004)(6506007)(54906003)(53546011)(6916009)(66556008)(66946007)(316002)(66476007)(5660300002)(8936002)(4326008)(8676002)(7416002)(478600001)(6486002)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2htVG1QMUljcmpXOTRDWmo1a0JsUXhiSkZLREdXVTdJUG85RmNJZzFXOGZF?=
 =?utf-8?B?U3Q4amkvR1BCRGhZc00xT0R3VDlDR2h0eEkvMGNzcnByUzdudElMMjg4UlJD?=
 =?utf-8?B?TjdEUFRMK1l0dit4RHhqQlJrM1RkNUt2aGZvZ3RFSEU5UTdEczlCRVg0Qkpl?=
 =?utf-8?B?bWc3KzJ5UzR3V01iS25YdzJjdTFSbC80dkQ4MTc4dUlJdWZxNEVwV3k4NFZX?=
 =?utf-8?B?SEh5QWFyZFY2ODRnSzhEOGUzeGRrSElKZnZNQUxVQnN1cUY2RVlLRzBPTUh1?=
 =?utf-8?B?UytVZlkxWWhpcUx0T3VFZEozTWxiaGN2MmlnK0dqNDI1T0pDaUF3c2FzZTU4?=
 =?utf-8?B?bXpZUkorUFExRGJXVk5vekxvWmM1ZTJxbmowTzdCTm4xck9PWUxpQUJEYnBi?=
 =?utf-8?B?cGt3N0gwVlJkZTFMMWJCU3lLb2NKWkJxdGJ6VEN5QkV4L1N6aEFZKzE4Q2xl?=
 =?utf-8?B?WjRTL2FVU2pWSDM4Z1pqOVhkV2gvUnNrWXB0OUFtZ0ZiL0NTQ0w2dFNFOG9P?=
 =?utf-8?B?dFVHaUVlOXJPQTNNYmVzWW1uYVNlamUvb3VLTk94Mzc1VnE3ck5MT2NJSDNG?=
 =?utf-8?B?OWVPUmxDQk1VSHJkR08vZW4wTHZhWmRON0N1V2NZYXh5L2I3QU1TVzZlV1kw?=
 =?utf-8?B?VXhYRUhzUFN3cHdIeG1lNDhqaHE1djVxVk1rWkdzUDlPbTl2UHE0R2M3aE9z?=
 =?utf-8?B?eXZiRXNGd2ZBbmlhbExjY3RKOHIrTFVSMzF6WXBxSGdRNldHejhLT055eW9w?=
 =?utf-8?B?aGY4M1JKTzlGdU0rNzg3Wm9LMDlSeUdRU0t4T2pMZm5kV09zRzNzazk5N0M4?=
 =?utf-8?B?aVZaR2tGeTUyKzhZc2RKUmdOeFJEY21sMEQvQmw4NHd0MUNaY05BRXg5SW80?=
 =?utf-8?B?OTFkY2k0d0VqT3FFM1k4Qk1zRE9VcC9Ga1I1dlA2ZVpRMWZHMTQvRVp1WUZi?=
 =?utf-8?B?alBCdXJHTFpTVENKd2R3dHNDM09LMmloQ3Z5T2hUaHVYK2xjK1k4NW4xUjRa?=
 =?utf-8?B?N3ErWjhPWnRDeVdXT2Y5VXlaVDNUYjVSTU9SSElKQm90NzBIM1RCTVdFYS9S?=
 =?utf-8?B?L3liQ1BKbHVSYTZ3L3JQQXVTRDBXZkw4b2hIdkF5OExwcEZ1RUNDVVZoOUJ6?=
 =?utf-8?B?MnpkdzBOclB3QWRsUTRQam1Va1gydGYxQWFEMk5zb0pLbUpXaWUwMVFWR2lC?=
 =?utf-8?B?OEFnbkZOZ2dQSDhkNXZxZUtCL2NNOUpVUG9jMTdBWjQwV2lsUyt4b0ZDVVJ1?=
 =?utf-8?B?YjIvKzlqanhQWFdyNDZyTUowTzI3a2Q5UUY3U0d2bWFXZWowVTRBU3RHdmE3?=
 =?utf-8?B?OXFFZ2tuTTRJS2wwNjRSQmd4UHRkRTBHTnBVQWt2Ym16UFZNQ0pDYkJnWlhV?=
 =?utf-8?B?b3NEejk0UXkrblhlb1dLUEJQQ0t5WjJoc0FDME0xaHc1b3FwREF5ODNOZTNY?=
 =?utf-8?B?ajFlY2FVc3VTaWljK3pRaHRpajVzN25JWXg0Tm4raTV5QXEyUXRoL01td2dK?=
 =?utf-8?B?Wnkzd1h5dWtuUExlNEFld05EeFBvdTBwMzFaVDYzbm1HWnk2b0NzcXZoeDFw?=
 =?utf-8?B?NmJFN1JoSHRSclowVURXTmVxb0lJQWJISUJycGJ2RGJXVkprZURVQnk5VUVn?=
 =?utf-8?B?aG9pZ2lOM09mVFhvd3BGMWxEaWlFQTdaS3NxYnQwUEpCZWVTWU9Oei9nc1A3?=
 =?utf-8?B?Wk1XV0p6RWdJYnpYaXhFSDZ3NVZjdDZBcGFrMGU3MThRbEhrbW9LK2dsM0ww?=
 =?utf-8?B?QnorbDQ5TkpEQ054OUNJT1N2VEZPNnNhT0U1cCsvRENRUkxlYUxLRFZ4NjF0?=
 =?utf-8?B?S3dWU25Yekg0Vm8vaTFHcFlreDJLbmd4U1lENzlhTFJBWXlQWU4vM2Q4ZkEz?=
 =?utf-8?B?SG92SWVkWGd3WnhsdnJISGN0RTBIUzdVSXh1aTBGbVBkY0krQkNpN05HeVRC?=
 =?utf-8?B?L0NMV2t2N3hQeWpNK3NhWkp1Wk5XbitzM3FLM21OK0pTeUhDbGNMRGhpdUhu?=
 =?utf-8?B?TnFmekQvRG1lYldVWGU2dTVqVVFvZWh1aUlGT2d1VjNSNlFiK2tldFkxM0VP?=
 =?utf-8?B?ZS9GQmQ5NEl6cXFjQUNLYTFCanRDN2xUK2psTUM4ZVliRGM2L0dMZnVYNm5W?=
 =?utf-8?B?Vm5Sd3VucHg1bWVMY3hVb1hNMlZCbStNd2VOYkIzZE50TElUQmZBUVhacjRK?=
 =?utf-8?B?Mmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?UHI3Ung3WjZnUnVlWkh3VjFoV2toczJOSjEzODdCeVJ0aUlINmVUVFp6ZDdY?=
 =?utf-8?B?Y1BESWRhaE5yYi96bWREUmwyR0lScERXNnluZHB0bE1ISk9VZ3lQaWdGQ2JU?=
 =?utf-8?B?YlBpR29QQnFXelQwcGt2Y3UzcmZCNWRKUTlLUVRXWUZET3ZFQTU5bTJXSlB6?=
 =?utf-8?B?Q1QwdTVHWERKaFgvb0NsbjZoVDR3OFFWM2NNZmxhWmxKWUxraWNDMkZrdVYy?=
 =?utf-8?B?TlRleURzYmwwd3Q3Um9ySVVudXFNZVV1K1lWZHRqODJaRmVUZ3B2aEdrZUtt?=
 =?utf-8?B?U2dFNk5FT0FhVnVOSVRISW41N1RpZjN0TzBJT2trVlp0Y09vcFMySXR0bHUw?=
 =?utf-8?B?OFh6M2JmOTVuOEFPT2x2N2g3aGRMTWp4QW9OZEVQZXQ0WlpSTEg5U0Mvck9C?=
 =?utf-8?B?OXJMVU82Y1VQRm5rYkdkOHVaZlNKSTRRRDRRV0toQXkvRm84MS9TRkNuT3ZO?=
 =?utf-8?B?MTl4a2hUV1dHRjRlVlZ2dWtBVW10WFV4MmpvTFMyMlZ1YW9Jb1lHYjJqQUIz?=
 =?utf-8?B?REFNQXpPUHl4UVl2cFVhNDJRbTNxWEJ0d09kU2JlamFRSUdBaU16T0FOV08w?=
 =?utf-8?B?Kzg4ak5Oay94NUZKTTRmNEI3SWFIeXF5Y1ZaN3ZEZVlnalk5dms5bUl3TVFM?=
 =?utf-8?B?M285ZXZKcHBPUnBvMEFXQzkweG12TW9ycDg2MmRaemo5cUdvT1p1OUFqRGor?=
 =?utf-8?B?Y3ltS0s3emYwR0MxN0FvMGt2RUwzZ2VJcFgxN1NneTlqamFNZVNldyt2dE1q?=
 =?utf-8?B?OGxVeXpJUEJERHg0eWhDN1pncTRhSkczeElOL1U2YXpvZGJZQlNJZWdidENa?=
 =?utf-8?B?ZCtrNWFrNjIrc1ZEZTBxUUhqNVM5eHFQcjh3djd0TGtFbURKZjZ1QVRlek9J?=
 =?utf-8?B?Tk5YTFZEUW1ESGNBeUxHcFlPU3A1MHBVTHlOSVpjbWYrZS8rcE1wYitIUi9L?=
 =?utf-8?B?ZGJVeFlEbTRpSC96aGg3dEMrakNQWGxjN3hUQWFrMHBqQzhQUE1nYkNFbTUz?=
 =?utf-8?B?dm9XRE8zcHN5MzA0R2UvZlM0Sm0rVnJDNVpPSGNEN0RpdHUzK2hHVk1rWnli?=
 =?utf-8?B?a3JUZHgzNXgwOVl5RkZpWE0rQzhma3FnQmNseUtYOHdsYUhXdHlKclZGSEVE?=
 =?utf-8?B?TWNZQmVpQmpFQ2JOa2s3b1BsdEQ5VmZ6eFNQV0k1YWpUSC8ycnErZ2JTQyt0?=
 =?utf-8?B?WndQdGRBTUdOYXpQdHlXSGd1cWhFWm10SnVFTXMyZ3NvOU9oTDVPZUVGUGFE?=
 =?utf-8?B?bCtVMGV6R1pmZlljV0tqUzdsZlVDSU84TzhZTktrek1SaVMxd1JlVHlvMVNm?=
 =?utf-8?B?emRqU1V1STdjRzc2TzBzZFZxWUk5WFlPcklCRVphNWNvb0U3Mk1oa1I5bHZl?=
 =?utf-8?B?aW0rbytSOG5taVNxcDdMaWRyT25ZcUsvOHJ6eHY5SEFGaHJrTkZRTVNxRC91?=
 =?utf-8?Q?24d8OfMz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef6ad404-74fe-45eb-89e9-08dbd1b2a371
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 21:22:18.1545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ayR/Ui0MGHTvnJ+Kq8I0QdSpUY/2bdUY1TIn/Q6Bz4w3qNPxjy8g1Z+1rD9RDKScdsE3S2+e06qvh5w4myMPsPcx/OEwe2sobJN3eOvv0Xs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6310
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310200180
X-Proofpoint-GUID: LZrFT_n81CswwcDdezqmN6exBQuIZzHU
X-Proofpoint-ORIG-GUID: LZrFT_n81CswwcDdezqmN6exBQuIZzHU
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/10/2023 15:43, Joao Martins wrote:
> On 20/10/2023 00:59, Jason Gunthorpe wrote:
>> On Thu, Oct 19, 2023 at 12:58:29PM +0100, Joao Martins wrote:
>>> AMD has no such behaviour, though that driver per your earlier suggestion might
>>> need to wait until -rc1 for some of the refactorings get merged. Hopefully we
>>> don't need to wait for the last 3 series of AMD Driver refactoring (?) to be
>>> done as that looks to be more SVA related; Unless there's something more
>>> specific you are looking for prior to introducing AMD's domain_alloc_user().
>>
>> I don't think we need to wait, it just needs to go on the cleaning list.
>>
> 
> I am not sure I followed. This suggests an post-merge cleanups, which goes in
> different direction of your original comment? But maybe I am just not parsing it
> right (sorry, just confused)
> 
Oh, I think I now really understood what you originally meant. The wait was into
other stuff that needs work unrelated to this, not specifically for these
patches to wait e.g. stuff like domain_alloc_paging as your example, with
respect to domain_alloc_user being reused as well and different domain types.

I will follow-up with v5 shortly with both drivers.
