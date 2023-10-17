Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC7D7CCA79
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 20:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbjJQSPX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 14:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343739AbjJQSPV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 14:15:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C4590
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 11:15:19 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39HHs9pE013668;
        Tue, 17 Oct 2023 18:14:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=zcP4hcWCchSn8D4bvEduUkih4/LVLPovkl7cb0wUJfE=;
 b=u+tkbFcwQq8VK0JCCLPZPEgghTujeyXkndE6HGaWQrPVL8+4H20BbxWA7UOLoDhNeiMj
 aQ2JeunY5OAh+E9N7wLOFhcBqJZe1kxx7FWKlG8fqgQ/Mn+K2415NUQ5T/zUWwoim5Fm
 /uWGZU5ETTW3DIv48SHtJPMAA3BCUPAxKETythQQZGNG8smscUSUvfWdr6Mw/o1Fm8/g
 9Gp7v4wgd9Ev+k/e2zm8OUT+BqdgRvTMsZm+h9WbAQkCLi94zJrflYV29PbD3tCHI6D0
 sv/FiLEd7j/LPJrod+YX1psXdGEU85GhoXaQOsixU5++JPSBLaCKUQHpJ4acKXRak18q Tw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqjy1dubd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 18:14:52 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39HH7g9F021944;
        Tue, 17 Oct 2023 18:14:52 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg51d8uv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 18:14:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nnfWINI/5b74F24bFcEz1uqMJMcu/V4SvK0vsvVA7ZMFlWJlEk+PUsqFsI1pipCIGRd7L5ZtHZal6RDkI4kLfsCdIoaMqjtYXlY30yGiGxjOABgv20TRR7N2BO0Zm83gdpxXXDazNhvbxGbU8wUYEMcfmDa7TzGj+jbBAF2qR0C9dU+5u5EjpDXgIj2JH0ae2I6i+liPFKk7d2kiRteQw6nPDx2ZT/n8njzBd00uSOlGPluxJWfgQdbRNl6n6HjiDAx8mfZzL8bA9ICNJqu88BcUppJABFQIfl/jz0PEwwJgp5VgOZO4KUUjQLus3Pd/P+HrO83wbufSkG4w7LtsLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zcP4hcWCchSn8D4bvEduUkih4/LVLPovkl7cb0wUJfE=;
 b=FDeKAeJgLISCfJLXGRKsoD9YHeSUxBh30jgwIlzvIwe+nY9Ln1hyAeR1V+JKwvKfGcIUOt4rOVCYw2+bPtXFAUzlORDUtcuh41K+0CwUq55Lfm4SdRk3l0qXnJGlxvVBbbFQDx0jJZGKtMGatM4Q715rEBMKzPAO79lhXV8X+hAMNon1id6AOaC6Udp8QP12EiOdKJgNj5Ga/Wz+1qexDPq0VYu5m/p3Q2zNvoL4Gvvj/4mmW+MZCQo3FX2ZhT350zx7TdHDjs0mKUynIUZ99lvWdgt6RiZ+bLo97u5HQjIIaMcDXrqi7UuGCSFEW5KxuNuK3M2aIbsOMHkJcc7/9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcP4hcWCchSn8D4bvEduUkih4/LVLPovkl7cb0wUJfE=;
 b=Hy+lHLtOhMBdN/XTCvstOEjlo7De4al169i997+OBjwDefEL4qlvd/VLUyjbvxyhsv4vi5ZyzVMptqxX3zhcfVLD3yJaXVj1AersBwrQtKlK8WEvk8PslVfhFN65zmPDaEnBMKJtWH/f3MiqLOWuwvq5gcB9QlPHnLcxR/CHkR8=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by IA0PR10MB6724.namprd10.prod.outlook.com (2603:10b6:208:43e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Tue, 17 Oct
 2023 18:14:50 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.038; Tue, 17 Oct 2023
 18:14:49 +0000
Message-ID: <d11064f9-47ef-4114-9964-0fc1a6bea408@oracle.com>
Date:   Tue, 17 Oct 2023 19:14:41 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/19] iommufd: Dirty tracking data support
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
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-8-joao.m.martins@oracle.com>
 <f7487df9-4e5e-4063-a9e4-7139de63718e@oracle.com>
 <8688b543-6214-4c55-a0c6-6ecab06179c6@oracle.com>
 <20231017152924.GD3952@nvidia.com>
 <df105d06-e21b-4472-ba1e-49e79f2c0fd4@oracle.com>
 <20231017160151.GI3952@nvidia.com>
 <765e01f2-c0c5-4d6b-885a-e368e415f8f2@oracle.com>
 <20231017171343.GM3952@nvidia.com>
 <ed81e5ae-57af-48d0-9368-b273848233c9@oracle.com>
In-Reply-To: <ed81e5ae-57af-48d0-9368-b273848233c9@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0534.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2c5::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|IA0PR10MB6724:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c95b012-8ab7-42ee-be6d-08dbcf3cf3bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KUyxbe1jm84HEmmz5B0AeVBNQgXxGAwEjCyPCVTybMaigB6C9ENC/zsgyjxJvY1oBQU1x9LxXIV5xvokfRXW5YBLdzA9ZZ8HIurwjgg9+jyMqOo3ZoctyBXa3rUvgc4AXNmhfgcwCfo8rCan3hp6l92FOw/e79BmMis3vaGEXLaNQl61nSfA9rdliXrr6ggQNtlOwIpn/EOwnoH0jn+5uWWpCdhfKL6ctWgF+6NqexEaFmbiVxhHDV2Z6E9PsNTVR+yLBTAu1fi7TQOrX+mu3PJHWAfculttxCRqXzr/wpwK82rDmM7njJezs8iObRWEKc3em7JHGs00k7rH2taYAz2N61Nch82v/tyUV7qXI5ZtCKDUsDlyjvokpmiAvVJllJUrv+IMPEfq2OheEIc0r+8HobsHOe9N7zqDVqyTNoR0wi4fD+lR1zXB3nbHlrjZOUkzJ96nZn0ltKTolP83Qf5ND6SusTUYyYNf+b/c9I8HRYgom6p474DzdMAUMfG4FpjV2x8glOLnkiKEKfrpJhBKXwHmYKXSV8c+8yHYFuq5qOTIoy41RM+ucLeOC0U84c1szKbibDrngJXaZP2G5nLsXGyKiPtUt5kMAEao5L0wp37jAdNhhRUSKC5fAPS0pm2e4LYGn1K+g4mSXUNWEXP606WuLNFq4j26eoBQ7dY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(39860400002)(366004)(396003)(136003)(230922051799003)(64100799003)(1800799009)(451199024)(186009)(2616005)(4326008)(66476007)(66556008)(6916009)(54906003)(66946007)(26005)(316002)(6486002)(6666004)(6506007)(478600001)(6512007)(53546011)(5660300002)(41300700001)(86362001)(7416002)(31696002)(2906002)(8936002)(8676002)(38100700002)(36756003)(31686004)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2ZtYldNdDBkZXpWeXJnQXRDQzMrWXMyeGl3ZVBiY2tGcTRqNnRHcEFFaHli?=
 =?utf-8?B?K3hMNHRuaEFBOFk4d0tWdUhvVjF1Q3hZWWR2VFI1dHVPa0YvQjIzT21pdGlN?=
 =?utf-8?B?OTB1b24zc00wRWYzMEJUK05neU02TlYzZU45UHc0SzkxcVVSMnJOYUZNU2tO?=
 =?utf-8?B?eHllcGhZeU5HVDJJNkZQcmNZbFdZMzhMU0xkS0VxQisyTEkxZGszeHFXaWFw?=
 =?utf-8?B?ZWV3VjJvdnpjLzBUeS9UdFhjOTZMTTZRMHZqY3JJcTIyQTU3V3kwSDdzcXFD?=
 =?utf-8?B?d01JTnB2a0swNDU4ajVXYmozeXhVSGQ2R2ZmUnpYL1lXT2ZOQlo2ZmJUdVNn?=
 =?utf-8?B?TUlmYXhwN0ZtVHZQbURmVHNraUY2Q2FMVVp1YkFha3BkRGFKdFNxM3BHNHNS?=
 =?utf-8?B?R0V2MFZvb1A3VHhBUFp5c1F4S3Y3RFpWanhrcHVGL2lra3ZjVmJ6a2c2d2ZH?=
 =?utf-8?B?L0lEQkRFSlFQWjQ0blIzL2ViS1hsMFVuTXp2OWZuVk1MZmlZMERJSUluSUQ0?=
 =?utf-8?B?NzRXWGR0b2NwczdGaG9CcndtQ0RrZE1SMWh0QWx3dlBLZStPYkJLM1MyVnYr?=
 =?utf-8?B?eTN0UG9Uc2orSzhTRVpTRy9wTGNaUmpKQzlUUDZDOVlsUGc5T2hWRGdod2ds?=
 =?utf-8?B?QnFmQVM4Zk9PVVljcFlZTDRxMXNYQmhWdVdIYTdXOEtsNFhtUWRmbVpobDRR?=
 =?utf-8?B?ZzQ1ai8zTE5HNlRZdlVGMloyZkcyNmlSNi9tbDBPa3pBU0ptOFBHR01CSXdq?=
 =?utf-8?B?NTJBd25JWnRRenRtZjAxNEJMcWRtVlpxWXJqSWREWVRicHpmNmNrRVNQMytQ?=
 =?utf-8?B?MzMwdFUrQWRDTHVpSUZPOW1YVXB3TklOcGRKUVVwaHlXb0tXQjl2N3lFaWdo?=
 =?utf-8?B?dlkzWHozMzNweFJLT1pxc3ZPYzdBakE5Z2dNaE4vdFpGZURuLy9WeTlHRTdU?=
 =?utf-8?B?Z0JadGlsS3pEajhPeHo2QmF0dnpUdVNKSEE2YmdDL3ZSWDR1Ym1ZSFBFVUFK?=
 =?utf-8?B?aWpqMXgzYTNrWmlVdVB0VXRkcTZ4SVhZSVljdk9WMldNaEdvMG1rSk14WThF?=
 =?utf-8?B?bGNtbnhHZkRKQUdzd3VrYUplbVpqOEFWRHFwK1NWWjJ0T251S2FJYWxuaDV6?=
 =?utf-8?B?bGd4Ni9WSTN2SXJKWUVjTVk5K3JSMTNhcnlSZVBLaXYzN0ZoLzJ4ZGxmYVVF?=
 =?utf-8?B?NTJPMFBHdWk3K0cwMVVad1FnWEpVeXFwNkFkTVNNUHQyZjQ5YXEwcWl1TFNW?=
 =?utf-8?B?K2hLa3RlUk13Z1pTSlk4VG5ZRElNcUlXc2FwTVVNZ2ZoWHNyNDBFbm04K3V6?=
 =?utf-8?B?QmxQZnl2N05qRFlMZ0lnWFhyRURsZGNKYU44YkJGbFpCbW1wTmRpbCt1MVRk?=
 =?utf-8?B?anQyNEtPekRyOFVwcFFRUVIyVW8xOGhubXRpZWdHNGF1enFJanBwN2dSalI2?=
 =?utf-8?B?T3lHMW1KNjAwS3pyZUJUSUdrTnB2MU1OWnFOTDFqNGRCTlZ1QThFc0dYbWRZ?=
 =?utf-8?B?Vk1UMy90OHVHajY0cnBSQ0hqc1QxWTZQbGpDZGNnUU9rVFJNeFJ2Q3llMlEz?=
 =?utf-8?B?d1RLbWQ2RUdoWGtnbEtCYWZUNUo0S0JDY2RVOTlKSWJKVHdZWTUxQmRSQktw?=
 =?utf-8?B?Szg0U04wWmZzS1k1WUZ3OEd4ZjN3SCtmQkh3TDhwZW0ycHJDL1lSemNDeWw1?=
 =?utf-8?B?L1FaYS8vY1UybWllaSszRVRBU0R2T2tzbUVlWml3WkhRTWp0Yld6czU3eit3?=
 =?utf-8?B?S3NWMzFqY0tmVGcrWE9aZkUza1d4N2orekdNVTNKSXpVWHFGNmVHRHpCTmwz?=
 =?utf-8?B?eEhjYXlZcmw5QVUycjhUM1lvVmFWYnNGTk1WeE9ha3crT2plZUcrNzVNSmRH?=
 =?utf-8?B?bTljUW5Yd0ZXa2R4bHMvcjdIZTFkdWhSdDFia0g3L1dQM3h5b0hQR2YyclNX?=
 =?utf-8?B?TklVcSt3Nlh1WUdYUDM0bTNYSlVrcXNHKzl4MjBiNE9hejJDT1JSQk5mOVZI?=
 =?utf-8?B?NXM0cXQ3aDhpRmVwYlRCLytTOTZHRzFhTVFUblpWbVBUOG13bllPWWk1L252?=
 =?utf-8?B?N3ZyMkQwamxPRHZwYkYzMzlvSUpDTkR3UHgrcTRtS0FWaW1XTlBZVzNWL1JR?=
 =?utf-8?B?TlJqaUZENWt4dkZOU0NlVHJ1c1dPQnVKY1BWbjFBbDJzQU5mWmtqOU9RamlE?=
 =?utf-8?B?Wnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?YysrZ2pNZjRpREQ5NWFldEhjcVk1U28yM2lKR0Jkck1oSUhLWGtxdGtxSkFu?=
 =?utf-8?B?NEJtVTFRQmFibWlRdDArcUxLeDhBZXpGdGJiZDJrd1JLeWNNcDlkazUwWnlu?=
 =?utf-8?B?aHUvYkRvdXNHYlMxck1QeGpKRWZic3lnTE95empjWVhjRjlkU1NjVEM5T01W?=
 =?utf-8?B?WVFFOUJDZG1nSW9iRS9wd3V5a1lySzJpMGthR2dyRTRBUUZVR2Y1QnVWeGhs?=
 =?utf-8?B?N3FHTmtneGNxU0RrTUNVYzhjb0RFRCs2T1BiWWJsQTZMaXBoMVZidEpSNDhC?=
 =?utf-8?B?Z0dESml3Z2h0YVVWQTBaZk9LYzBxbEhuT3VFTmlSbWhhYWl4dVBwcDBKd1Fx?=
 =?utf-8?B?dGYyRDBlRkhyck1zUTVOQjQ2cGMzbDU0TmZIdnBncGpDYWpKb0NlYkt2NFM5?=
 =?utf-8?B?aExOeW00d2dpYnl1MEJSQWhYcitWWis3WkJGYncrMGRzblZtblpYQ0h4bnJW?=
 =?utf-8?B?aHZveXBKYXBLRS9aK3ZCOTN6VERjeVZIdzJkaGY1Rm96dVQ2WnZjblpHRTMx?=
 =?utf-8?B?eXdubUYyNUZyQ1c0bStFaHFhajY1bE92Vjg1eXZhVzFYMXNlSFlwWE9NTzlV?=
 =?utf-8?B?RFF0WGNNQkR2bFIyR05RM3phVlFZU21IcmhhMDRFVjRyZWZDQUJvRmxBekhY?=
 =?utf-8?B?QmZ2Tmdvc3E0eC9mWU9yNjhiYjhqSUFlRUVuUGN5YmcyanVObzJIVFQyUEo3?=
 =?utf-8?B?UFM5Zk8wWFM1NmxCL05DMFF4T1dac2tmaGtvM0thWE1sNkxKRDEwNXE4UVlv?=
 =?utf-8?B?M0RQM2cwWFZTOFF4S0pBMWZPeGJhaXU0ZzBJdUdFR3p6WUdLNlUwaWxoR0Rx?=
 =?utf-8?B?R24wN0E5RTlQTmdHZWM5Zy83VlpFTW85NGh0RzRyRnlidkpvSFNnMmpsb1Zv?=
 =?utf-8?B?RUp0eFRtZVFMcGkvK3B5dCsyRTFycFhLRTZmSyt6eWxhc00vTUxRenF1Ty8v?=
 =?utf-8?B?cTRrYXJsaGRMOXdOeTgxeXpCdGI0cEZnbnlYNW1ZdFBpdDV3cW1VVEJQUk40?=
 =?utf-8?B?SzYwU0NFbEdsTFBOSGJobEdjcHVMVDVXU0g2OERmMHNtMFdkSXVrZEgvdk1y?=
 =?utf-8?B?bXVlSDcrTTF2UGxFZVA2a0g5Q09qT2V6SGUxWks3Z3FVNC9ac1lSTHBIRzJH?=
 =?utf-8?B?N09waE44WFJwMFB2UVZ6UGt5VjBIZ2t2a3ZVcnYrSTAyc2xodkNCQkxZMXBC?=
 =?utf-8?B?UlhReHc1QzA3M3c5WGRhbzhoVDlTbURqcjlWTVlnQXl3M3c1ZjUvdUVCYWZC?=
 =?utf-8?B?REF5aVFieXlTbS96R096ZHBFSXBzdXVwRlpxa0liMGx1WFNiZ3BjOVpzRVJI?=
 =?utf-8?B?cGJuQnJOV1dNNCs0ZEpaUjBULzV2VWxjTU9JWXlMc1RzbkovdXVoVjhoczZ5?=
 =?utf-8?B?MXFZdFhOUFhLTi9BeUJyQ2tWSHIxWEREZXRsbnV2aUdCNTJyQUFuSmR0cnVO?=
 =?utf-8?Q?mYWmCrAL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c95b012-8ab7-42ee-be6d-08dbcf3cf3bc
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 18:14:49.9181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IwJesOflz2aj0dQk5UIGHXvOMlLYlrjJcYCFUv9aJ+088Zpm6UylykgrWeFhV8FX3cQjI2z9DIo/Cwdh7aygVb70Abjdj6lPrSwLEIlwykU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-17_03,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170154
X-Proofpoint-GUID: gB97k7Rhni0oFGgZ3PRoXvBZUXyiIG86
X-Proofpoint-ORIG-GUID: gB97k7Rhni0oFGgZ3PRoXvBZUXyiIG86
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/10/2023 18:30, Joao Martins wrote:
> On 17/10/2023 18:13, Jason Gunthorpe wrote:
>> On Tue, Oct 17, 2023 at 05:51:49PM +0100, Joao Martins wrote:
>>  
>>> Perhaps that could be rewritten as e.g.
>>>
>>> 	ret = -EINVAL;
>>> 	iopt_for_each_contig_area(&iter, area, iopt, iova, last_iova) {
>>> 		// do iommu_read_and_clear_dirty();
>>> 	}
>>>
>>> 	// else fail.
>>>
>>> Though OTOH, the places you wrote as to fail are skipped instead.
>>
>> Yeah, if consolidating the areas isn't important (it probably isn't)
>> then this is the better API
>>
> 
> Doing it in a single iommu_read_and_clear_dirty() saves me from manipulating the
> bitmap address in an atypical way. Considering that the first bit in each u8 is
> the iova we initialize the bitmap, so if I call it in multiple times in a single
> IOVA range (in each individual area as I think you suggested) then I need to
> align down the iova-length to the minimum granularity of the bitmap, which is an
> u8 (32k).

Or I can do the reverse, which is to iterate the bitmap like right now, and
iterate over individual iopt areas from within the iova-bitmap iterator, and
avoid this. That's should be a lot cleaner:

diff --git a/drivers/iommu/iommufd/io_pagetable.c
b/drivers/iommu/iommufd/io_pagetable.c
index 991c57458725..179afc6b74f2 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -415,6 +415,7 @@ int iopt_map_user_pages(struct iommufd_ctx *ictx, struct
io_pagetable *iopt,

 struct iova_bitmap_fn_arg {
        unsigned long flags;
+       struct io_pagetable *iopt;
        struct iommu_domain *domain;
        struct iommu_dirty_bitmap *dirty;
 };
@@ -423,16 +424,34 @@ static int __iommu_read_and_clear_dirty(struct iova_bitmap
*bitmap,
                                        unsigned long iova, size_t length,
                                        void *opaque)
 {
+       struct iopt_area *area;
+       struct iopt_area_contig_iter iter;
        struct iova_bitmap_fn_arg *arg = opaque;
        struct iommu_domain *domain = arg->domain;
        struct iommu_dirty_bitmap *dirty = arg->dirty;
        const struct iommu_dirty_ops *ops = domain->dirty_ops;
        unsigned long flags = arg->flags;
+       unsigned long last_iova = iova + length - 1;
+       int ret = -EINVAL;

-       return ops->read_and_clear_dirty(domain, iova, length, flags, dirty);
+       iopt_for_each_contig_area(&iter, area, arg->iopt, iova, last_iova) {
+               unsigned long last = min(last_iova, iopt_area_last_iova(area));
+
+               ret = ops->read_and_clear_dirty(domain, iter.cur_iova,
+                                               last - iter.cur_iova + 1,
+                                               flags, dirty);
+               if (ret)
+                       break;
+       }
+
+       if (!iopt_area_contig_done(&iter))
+               ret = -EINVAL;
+
+       return ret;
 }

 static int iommu_read_and_clear_dirty(struct iommu_domain *domain,
+                                     struct io_pagetable *iopt,
                                      unsigned long flags,
                                      struct iommu_hwpt_get_dirty_iova *bitmap)
 {
@@ -453,6 +472,7 @@ static int iommu_read_and_clear_dirty(struct iommu_domain
*domain,

        iommu_dirty_bitmap_init(&dirty, iter, &gather);

+       arg.iopt = iopt;
        arg.flags = flags;
        arg.domain = domain;
        arg.dirty = &dirty;
