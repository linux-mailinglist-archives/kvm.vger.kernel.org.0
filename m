Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40CDA7CEC56
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 01:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjJRXvI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 19:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjJRXvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 19:51:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24949B6
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 16:51:05 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39IIp60x018161;
        Wed, 18 Oct 2023 23:50:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=8VRE6CajSeVnjfamUdGL/UqeD4/Zbl4DZfhtWukppew=;
 b=KwM5wIJJFfBqIMI1gnsw8TggXmFr1tYcnh3KFLpP0kOoOpea77H9obGtuTegCR2kbI2f
 U2PljIPLEh0Z+HRLaZcFq2CYedL2+J/CUGQy78hjPjYsgT9ZFM1+p3WY9yi+etSrncBf
 OkN4gtgMyI7zabRI6u5iLL4nNr9OHfNK91Q1jyhEAHHoRnTacYf6CZlo6x8E3p1e4OCx
 uNJ8JDdlDM/5Xx0f1FiyrH+BD8bDLGXyc4yLWFEMhe/iQ29cJNVCMEhcxlNiBsKNOzNF
 WMLwU/h1tlOrFJnjTt09MtmgpWQ074fh3a/dtuu7h8P7ZVa73ZWKW+xL4s6cqfuNNsPW HA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqkhu8x0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 23:50:31 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39IMOwAH009788;
        Wed, 18 Oct 2023 23:50:30 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg0pxwt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 23:50:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h2UXJIjYfucAjzsXORNUWFmRFJfnYMgtAgFvR5UxP3sO26eVow1R/s7zHHxYaBuQn7lbLPoMlAvJwShLa1sHfA6sL74k2+gGvge/V/sqR8RXWBJjHXUqwjtgNlsax5AYYoTWpBfGqOqSszS6prId3QyVfvvb7i5sLPOBNiUIVZYLCFWFYcR4h3dBm5rI0kMLhGkXPOUl1YK4z817kKBpmSMl2UdDFpkFFdD5ft2RqFWVOrTGKeyqILnXQBoCcywvRSFCGoAIo4PQmlgZKHe+LWJjysEj3Z1lYkSlQhHmqW2jVMYbMcGn6TC3sQ6iQW17yU4upcqUIb8KuJcQcZJ2Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8VRE6CajSeVnjfamUdGL/UqeD4/Zbl4DZfhtWukppew=;
 b=GSNtWL8LOCqEba+9/XaHkJXToKAtwFuosawzVrLroDTDtdT9tMTur/EjKjjdKgV68kFFz+ViJdp5VkaHGV1efhrEoDMfmrCXna/JzPAm9m79te0dqNk4MEIH6YYJoJPOHZ7hz2/LpFvaL7D0wp6C6QqIe6bULlyPB1gX5tnPwe9F06QK6SR58wJjonFs7U5YtAJ9Tsaw7K05IkSAtoiz20k1res8dSMCzbU5fQEbU7H03eke0mbn7lUA+VKNdXoGB84J3/H4Ey0EclqV1DjieibSUkLxbk1gJuqvJz/nBmPWWG16JG8Nr45dTzw11j6X9PCaANgOM05dvaPwhJV9ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8VRE6CajSeVnjfamUdGL/UqeD4/Zbl4DZfhtWukppew=;
 b=k1DbEPQoPtun9Tfe74frx77XijpbVXlpP40Pc9Mfn+hK98gWxvucjYLTaHTO2BuD9RgM1rVvlD71ZZ0gEsyspOrK4MLxDsNvF3YxmT4eSeGgCSQQGdjuReutlNE7DMj7VQb8V3dpQEnNQs/MhlT0qmxXGydEuSZ4K9xDd1maPmg=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH0PR10MB5018.namprd10.prod.outlook.com (2603:10b6:610:d8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.23; Wed, 18 Oct
 2023 23:50:26 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.022; Wed, 18 Oct 2023
 23:50:26 +0000
Message-ID: <1b562b37-f75d-445a-929a-866c0cfc0a84@oracle.com>
Date:   Thu, 19 Oct 2023 00:50:21 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/18] iommufd: Add a flag to skip clearing of IOPTE
 dirty
Content-Language: en-US
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
 <20231018202715.69734-10-joao.m.martins@oracle.com>
 <20231018225453.GN3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231018225453.GN3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR0P264CA0056.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1d::20) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CH0PR10MB5018:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a136a12-9aa5-4841-2d28-08dbd035005b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NSFmVaeRLg//oXA/N6c79lHH+TDGyIINW4h0ZCgFVSUqnxQe/PXZEUA2SXO+JF2R0FWoCE9wI35Ah5ASmnxLpBmhQgavxXQe+D00jUwIwqImjtyRVF5Hh9wztTu4f9nBTDRzIonmBZ/5wtCIKFU8T6Z8eOSJeDEBPLmy3+EghYB92P/izTQruRJ3Xw+XicqIBU8QMboO/C5Xw79ciBXDAoNUvHDBtBt4pJgq1cze5iP8r/ONGbaTBm5tADF1MiD27WGafHOlehXSVfUroUONzQzbDPMZh9oVhpl/SNBsfk8JNffvKufGs6et82K1KeFDg+qy/0XFfZZguinI+dxR1qEeyZnVU7Z92D9GWaS2icVpH3zLCOsZK24nSA5ibk+ZjU5mpz6vROAdNrgOy20RhvW5Z0MDmUYtBvpXIlHIpZBF+L6xWdlY+hPYxN2zpOUaXAGY6Sxh07nQ6mWTH+POQRXBSWV9izqfb1x2QKSllAB78rILVOWhk2t8lEWe63CI3WvfAr5HQodOJo80UOUZtqDUx2RnAfDPgr+/rWKwFaeTj6vMcCvu6xVx8HIwZxrWSdsMdwNsKNd//GgsJNXm6u6B2HH3mnnfuDF12YFFsOKndTKINtY2D8YqNYwo4D75dv6q5LZJrAD2bov6ySRpmi1HAst+DhQP70cb8jzngtI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(376002)(136003)(346002)(230922051799003)(186009)(451199024)(64100799003)(1800799009)(4326008)(83380400001)(478600001)(8936002)(6486002)(8676002)(2616005)(7416002)(31696002)(86362001)(6506007)(26005)(2906002)(6666004)(41300700001)(36756003)(6512007)(53546011)(38100700002)(5660300002)(66946007)(316002)(6916009)(66476007)(66556008)(54906003)(31686004)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QlpFTTBNWDU4SWJaN2JzNXV5N015UHpUaGVtcVdPWmdDR28xWVVKKzdjbUkw?=
 =?utf-8?B?ZzE3ZVJQUlYvY2NzdjZSMU9wUTIvd0ZqL2s5ZmpLbmRXV2F3SklaV21HMmoy?=
 =?utf-8?B?SnFTaXljcXJ5YnJKcThrd1ZOMXlGSU5ra2U2VXIxTEFBNWlUaEIzazVMS01m?=
 =?utf-8?B?TWxkRDc2OUdsZmQwMyt2UkxJNHQ5V1hhU0JZNVNpRFpvZXZZOTlNMWlXUmdG?=
 =?utf-8?B?QUpvQWFsK0NEd1RHWFNONElxSlE1dEx1RkVKeTV4OEdNZjVWMEFyTkVuY3FX?=
 =?utf-8?B?RTB0ZmpBdEtYejBZT1hjRE1vUkp3RXM4M0ZWY1BqY0NYdFNUNlFOampxOERn?=
 =?utf-8?B?SGFlYy80aDh5dVpydy93ZUY3MjA5aXU0em05bkl3OWhucGh5QjByMWdjbTVx?=
 =?utf-8?B?TzJYcEExZHNkcFJyaW9lMkJmNFNWT1plWmhKVjNCbllqTEZkODlObDI4Vkg5?=
 =?utf-8?B?Ymo1UlphQ29zOVhLbzhCU3BvMnFBWExJbUp0REQxZEFLeHR5aDdPYXFQa3ZD?=
 =?utf-8?B?WWpXb2xGMk01OWJSNTFEWW5qYm8xS2pucTR3U2ZFMlJVcnc4bHZKMHVNTnNR?=
 =?utf-8?B?WUlSK2xRMEFJOUlpVHN1R1Y1R1JSWjBTZkFwNC82S2FOZFptZVV3RlpiRUdL?=
 =?utf-8?B?QXNOa0lKWGw3T0ZlY1VZdCs3eWJjaS9XZzVNMXZySUtVbTFuc01MTktkQ0U5?=
 =?utf-8?B?MTJxUjlXUCsrU1dEdndoUFFLYmRhVmlnb3pCbGVGa0JaVzZpWWlVdFVYVG81?=
 =?utf-8?B?NkxDSElqRDJNd1RBelc3Q3lnRlNkZGQwYkN3R1Z2aXRnTmdyamQ1dlNyL3Yx?=
 =?utf-8?B?aXNMazY1Y2JpL3QwUG9IcnVlQTlhUUpVS2FtQUV1OGlnU2hSNTVOUWZaeXJY?=
 =?utf-8?B?OWlFM3VJb00zdTRHNWovOVluQmYvZHZqYW9RYnZDcnJUeUF2amNjWExoZFFv?=
 =?utf-8?B?MW9oTlZ3aUZJSjRWejJHNEU1V2N4ell3RzJzVkdYRFNvdVVRSmZJRmRpRXRp?=
 =?utf-8?B?eGtaQ2VpUFlzc05IdlB5am52Q3pvVFY3S3NqMVlSYkQycmRUT3gyVlN4dXJu?=
 =?utf-8?B?VEZmTXhZN0RWU1VuNDd3THNoYUxDc3hXSExxM2N6RkxJVVZPVElNYmlrVUpp?=
 =?utf-8?B?SDJ5MHBsTHRPcVV6YVpWak01OXFta21QVW9HczQ0RXFZS25URGM0OTNEUkNG?=
 =?utf-8?B?L1dWUnRXdHBhaXZXMUFIMVdQUXlRWXh5Y2YvNlpkbU9KeHBUU3czWFNzODk3?=
 =?utf-8?B?SGlOZ29OU2NlWjhTdkFLd21CcFAyU2czcTREeGVqdW9hMTYzYkV0ayswRU1I?=
 =?utf-8?B?dFZ5cE9xNUVuWlhHWnFpMnZIUjBtdDlobTlpbUM1bStTbW01emJJR0RtL0VM?=
 =?utf-8?B?d0I4UnFrT2ZsWklMZjJrdzBJRWRPaXhpVlYzSVp2T25uRGJCODhhUmlIamtH?=
 =?utf-8?B?Zjl1YzZNVm1DZFVxNzl2ZytVSExFaGJGT29vQUY0TTFaUlNJNkdLODNmL09L?=
 =?utf-8?B?c002MXdtU0FTWE1qR2Z4TUdrUVFiMXE1SVRRS213OVFqdkU5RDJ5UXJJb3F6?=
 =?utf-8?B?Y2pRRS84QXUyTG9RZHdZWVpFcHNKV1VmYzA1Y21WN29mZ01qSTNwSU9odUd3?=
 =?utf-8?B?OGU1N29jVFVJRG9GY1hsUERvdEhIdEY1RkswRzBGaUtVN2dlS2xOdVJ6RnBC?=
 =?utf-8?B?VllndE9vQXBaWG5EOFg5emhmL2V2QVdiZnZCNnl5VWxhdUQrUlBrVzUxTnRK?=
 =?utf-8?B?dmZaQmp1eitsUkZpT3RNdndBTXV2aVhkZGZ1WHBGYWticEpaVm1qelpuWUtt?=
 =?utf-8?B?Y1RSYVU0bDF6Yi9SUzlRN0x3SWsrSHhUNzl1bGpQTldRckc3WDJpZGd2TUVv?=
 =?utf-8?B?V1NzNHozQTcxanRqZHpWOG5vdTM3MDdpMU1zMVZuL2d3WHB5MmVrbkRyNStT?=
 =?utf-8?B?Tm9KVlVoOWlGTFU4ZVRsbjdHWUZNNDRSVUx3L3FHNEdOeTY2MFhHU1VxZjFn?=
 =?utf-8?B?TjltQ1gwN01HUTlNaTF3aUYraURuWmhTZzhDUTVRNXlCa1lJbmwrdzVIb0xU?=
 =?utf-8?B?VnBCSzhMUjR4eFNvQmdzUnNjd0FXTWdoeG9FcnJMaEFGbWtzbCs0cENaVVhN?=
 =?utf-8?B?Nlo4cDNtajJwenptSUdCNnBpdlZVa1o4R3ljNnhkWGY1aCsySUovcW9NcXJy?=
 =?utf-8?B?QUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Skh0TFM2K0xiT01UaXpjZWlLTm1ncFBCOHQ4cExwcWdEd0h5M3Y0OGg1dE5z?=
 =?utf-8?B?RDFiMmV5M3M5YUFGcEw1WVFtUGdEZ3FKVmFaSzVuQWcraUJLSGJIYW1HS0k0?=
 =?utf-8?B?Yzl2YjJmNU5DR2J3NmVFOTUxOW1LQ2pkNWhldTlOUkZQUHNrYkV0Mm9oMDJZ?=
 =?utf-8?B?TFBrRHQ4RFZERGJTSzdNUXpFaXovdjdMWkIrcDM3eFBSQXQ4Ylc4WXZkUVpO?=
 =?utf-8?B?akh6TUZ0eUx0c1BYNmZJV0p4QzhMTDI1VzJZdDdnMzN2UHcrNEdtdUQ1ZnVT?=
 =?utf-8?B?MDZQZE8wWUpHSmxMQStha3VycUJYbUVIR3lTQ2Zsd0dxL3QydkVOTHlITCtv?=
 =?utf-8?B?WU5IYWJoSnNlUmZVbHltRXdkbXEvMXRlQlFPMU5CWjNEN09lZ3E1YVk2cUtP?=
 =?utf-8?B?UlhKaDZRQ2cwS3E2dFJJY0c3bjNiRGgzcXlGMmQ1dnlMNCthMWE0dHFCbmsw?=
 =?utf-8?B?UHAwOUJ1dEVKUEsxMUpUdE1HSmpwc0VWbXd4c3hRSkNGVCtnUjhjdnFzdGUv?=
 =?utf-8?B?YzN2cXhoMkJBUG5uMTFRV0tXQ0owbHJvdGNuU1UyU1lCVXBaMFZlSlhkd24w?=
 =?utf-8?B?dWtoOEZ3WEMrcHRZVlQvcml3MXl4S1BMeVI3MmsrcCtVcktub2lwbFBMU1Zw?=
 =?utf-8?B?YWtISWNLVDQ3cm9CeGcwQkZWSUxwNFZMSHQzdXVsc2hlWFBUdTdDbDhWWHR4?=
 =?utf-8?B?QW5INVh0MU4xMFFsN2pHdmRNcE9vZU1IYnZYaGZrZjF6Y25pYjZKT0VFd0lM?=
 =?utf-8?B?OXF4TklnWTlNbjVQTGQwdDFlNXh3ZTJmV0FIZ0ZqYnlIdnVxbjZ4Y04zNEJV?=
 =?utf-8?B?cFlvWXJWbkdMcUh4OEt5cmh6Y3JZRk5jbEdhc3k5blAzcE1UZVlqN2U2ME1J?=
 =?utf-8?B?MXNjcjRidWZvZE1DV2lQYzA5T2dyQmNVcW1pS2VNSXdaNTNGclZKRzhLQ0d0?=
 =?utf-8?B?NTNCeGVKVFNYRU5SSkFXTU9rWmcrVU1xVWpTM3RDMmdBTG9vN1VWbVIwR2kr?=
 =?utf-8?B?VmZxZzIva3FJcVlUN2ZZRmdoTFAwazVFNko2czRNZFF0OFo2M3FkWkhZdGtQ?=
 =?utf-8?B?VWZCTXZCZlNPQXZEc0wxc09nU2s0ei9aWUk2S0tNR3RMUEtzTmdTN01CZVhv?=
 =?utf-8?B?WDlHczlnaG42WS9sN3d6TkJXRmUzell5UVExbjZwcHVSUHVPZjYrcTUxeTZU?=
 =?utf-8?B?S0pGamhNd0E3ank2VzZDakJ4NC81My9nVncwdnNGNUxBQWJtcEdtbGdDSXRH?=
 =?utf-8?B?RjNRK2hpREZ1VFBLMW9RMXRvbVl4a3lmYnYwREFjbnBMLy9uU0VFVDBoWHI4?=
 =?utf-8?B?cnN0TjB0ekgwcUhIY0NBR0tEVnJVeGEwcmtzTjZXRllCRXNDYVRSVDlXdGlZ?=
 =?utf-8?B?T2hKSENyMHJ6QXBpTXRQUDl4WDRKMkQ5WlExK2Qyejl1VHZaV0x3VzFqc2xj?=
 =?utf-8?Q?p9TWfJtC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a136a12-9aa5-4841-2d28-08dbd035005b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 23:50:26.2605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R/9e50JkXMxhKR+wyFE+h5UPZjNcY/i9ZKeJu1S/a2B0UkI+vqDRBcTSFsonwtpHxZEEu6G9ovXXDGUbDH/9ne2ZoRPTpRGX+XUgBaMgjPY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5018
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-18_18,2023-10-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310180197
X-Proofpoint-GUID: XIo2JgqDFVjQeu42UqzvvCG4xFkq49zy
X-Proofpoint-ORIG-GUID: XIo2JgqDFVjQeu42UqzvvCG4xFkq49zy
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/10/2023 23:54, Jason Gunthorpe wrote:
> On Wed, Oct 18, 2023 at 09:27:06PM +0100, Joao Martins wrote:
>> VFIO has an operation where it unmaps an IOVA while returning a bitmap with
>> the dirty data. In reality the operation doesn't quite query the IO
>> pagetables that the PTE was dirty or not. Instead it marks as dirty on
>> anything that was mapped, and doing so in one syscall.
>>
>> In IOMMUFD the equivalent is done in two operations by querying with
>> GET_DIRTY_IOVA followed by UNMAP_IOVA. However, this would incur two TLB
>> flushes given that after clearing dirty bits IOMMU implementations require
>> invalidating their IOTLB, plus another invalidation needed for the UNMAP.
>> To allow dirty bits to be queried faster, add a flag
>> (IOMMU_GET_DIRTY_IOVA_NO_CLEAR) that requests to not clear the dirty bits
>> from the PTE (but just reading them), under the expectation that the next
>> operation is the unmap. An alternative is to unmap and just perpectually
>> mark as dirty as that's the same behaviour as today. So here equivalent
>> functionally can be provided with unmap alone, and if real dirty info is
>> required it will amortize the cost while querying.
> 
> It seems fine, but I wonder is it really worthwhile? 
> Did you measure
> this? I suppose it is during the critical outage window
>

Design-wise we avoid an extra IOTLB invalidation in emulated-vIOMMU with many
potentially mappings being done ... which is where this usually is more relevant
to be used. It bothers a little, if it falling under over-optimization when
unmap itself is already expensive. But I didn't explicitly measure the cost of
the IOTLB that we are saving.

> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Jason
