Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111E27D0BF7
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 11:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376678AbjJTJfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 05:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376780AbjJTJfK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 05:35:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5462DD6A
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 02:35:08 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39K6n2DT004631;
        Fri, 20 Oct 2023 09:34:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=wk6VOMEYETBlQSHuSF/NiRhAMK8hkLtirn8UXjkfRfg=;
 b=m/nlX6ut8/uqSsWl1+g2Ddb2/mNU3SFxDbW9jldIfzqiRJbCa+wozZVT6k4HiyqjXFaU
 E15CvKdk8yl45HeejOxF/qyDzizubotAX3B2H7bxVq4awprgLvZNBI5mP8c3U2mLWvbS
 BeM9neNFzBeek/n43XgMhjfZzRqcQZwqRL6EPP16JAwaz+RT+vpIdEein8/Yg5LATOB/
 9a9W2ZEN7ra14PmYyNricYOEx00vGdNMPuFkukEkWCyDs2Icd26GHrKS5Umv/JgDNNfv
 lS1BXjQtknTZbomkXQTncwdTYhshokpcle2hJqgiQgYJ9gKr3iCE95gIvDHTcXeaOvqB VA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tubwdhd0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 09:34:43 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39K9Pw0i031552;
        Fri, 20 Oct 2023 09:34:41 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tubwdkude-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 09:34:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQ9lbe4+xELmhRESwSGzuoxOOS94IU/Zooy2SbbSlUd+AjRN91nSqjiAgQMAaOM4pqLrwbHJL1BLCr9+Sxja9ToA9dDLb7JI5TBdLFq8H7l2F35QS/zeWgwga359cI7a0g9xtTUf02OeNTr9UEfh8K8Rp7ku7M11LRGJF/RotvbC7KPdHJrHexakkrn1Bqnl9JAJmrVde7PltdXWMPmsOCY1xcAog4T/v9ORtRnmqhCeBawNz+PvroUati19D+UNtUBRz+9TkLiTHGQ7X0NJmW/w7UbOoVILc8FP+mZ3anAvP9rPcrzxVqFjksydC79b2Lo3VgZKDfR5noDgs5vKiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wk6VOMEYETBlQSHuSF/NiRhAMK8hkLtirn8UXjkfRfg=;
 b=gaE3his7d2gJd+dMHnzOA2CDaHB5AzOo6NNWsBYDuaJgmg/jXqtwG63+WtCKFtkLloQJndaJb2QEAwikXgebAgezYqjq8rBG5+AIgfNvBtg+yOd3HkQAL4fYXNCObRceEzoiYDm4O70bULSlWGx9vJmRC6hWkmeam3hx5QDsk6LqPGqKEDQQndEdIVl/EUPkpsRb9X6bov1VXYGIzN/P4dsOCaIgWqEuZI0OP7Y71btbqQp1ZJabzlyTLEm9W3XcyEFUCa0J9QBEAwhx4Pdqo+digdUBhbTasp53USlhFtbbuXQOtMSA8TzeEvqS+sLqRnqlcSNJPVyUVTS095CT5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wk6VOMEYETBlQSHuSF/NiRhAMK8hkLtirn8UXjkfRfg=;
 b=Mz3FIXci9EvbD5Q8jig3lKIJDO22AfgSfQYS6yKFbmE7GUnu+Cb9KKDPEnMI8ydA6sfP2uJkbgXWeHXP2L8A5s5xIAsnyBzmiwnY675SptUqfSkHNmexVZ6Uz2+pfbT+VTDnYuGLs1UXaTVxKgOAAKR8vTA31qzhOGOJ+5r00eM=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM3PR10MB7947.namprd10.prod.outlook.com (2603:10b6:0:40::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Fri, 20 Oct
 2023 09:34:39 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 09:34:39 +0000
Message-ID: <b5d304b9-d54f-4abd-bfeb-de853458d2af@oracle.com>
Date:   Fri, 20 Oct 2023 10:34:34 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/18] iommu/amd: Access/Dirty bit support in IOPTEs
Content-Language: en-US
To:     Baolu Lu <baolu.lu@linux.intel.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-12-joao.m.martins@oracle.com>
 <20231018231111.GP3952@nvidia.com>
 <2a8b0362-7185-4bca-ba06-e6a4f8de940b@oracle.com>
 <f2109ca9-b194-43f2-bed0-077d03242d1a@oracle.com>
 <31612252-e6e1-4bfc-8b82-620e79422cbc@linux.intel.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <31612252-e6e1-4bfc-8b82-620e79422cbc@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR07CA0034.eurprd07.prod.outlook.com
 (2603:10a6:205:1::47) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|DM3PR10MB7947:EE_
X-MS-Office365-Filtering-Correlation-Id: 10b7c972-5778-4b47-408c-08dbd14fc834
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OEmSH5yuoA3yLKSZJH7O/OGwrhnW96VzAJ6ByJzW4n7WxIKrqsHU6mtvR/Vo0QXo0lD0oVtl1OHVSViV+aF85SPrizwXZqxNHlf0FYdoURI/Pe4HQ/Ltx5IyaQjoMSOsmvsFr94gNG4gwy8VBpg5TJ8/A74gUZWqH+3o/E193dzpBwQgyE6Sv7IyWri/5WvncAJvJ2JAm57zZvTbfAUIzVUfm8CXlRp2HQvs6NZ59U0ztu6q417/GanmQ6lffQsbQhUkxvCJhv6Z3TLOd0R5Q1AnwRq93n88Wf3QLnbGNYZSyf3TJ8rt5qsz+eFc/AmbgSaFv1OdG1AH6qbBibtrzuZdLxugDNDB1bbHU1DEjF9nRxjflWWhL65+ehf7LJX13tBpstX4/7jEtI1nJURoiY0f3BELsiIZm5h0NYOXGXHR1r00jrbWFBxxc8aZlkq19/yPEPuIqiJeHtpG7xnEP4ts73u4fplQgv4MY4dU4rVXd2DEqExCfz5UW/Ndrbt0gifqO8S+/V4MXuqAlLvZsz/G/GPpa/PhwEFRUEKUwOwrn9Q8qz0HEFzIcR5Z6PDtRIiTieo31zqUDhax6j6I7ihIUcJ9tJZ5ue9OLY0b4D/xJQl425Mjl8l4C/Ug0shVedTfy+JAnrJuqbiKz0zYCtdxunBsHOBCHFIo4Kub7Mg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(376002)(136003)(346002)(396003)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(31686004)(6666004)(7416002)(4326008)(5660300002)(8676002)(8936002)(41300700001)(83380400001)(26005)(6512007)(6506007)(2906002)(38100700002)(53546011)(2616005)(86362001)(36756003)(31696002)(54906003)(66476007)(66556008)(66946007)(6916009)(478600001)(6486002)(316002)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eEdsU1BnOVRhQUMvNzh2a0l2UkkrSXJzTjg4MFhLTThjZTFDSWx2RURBOWgw?=
 =?utf-8?B?K2FVRGlndnhaSDM5UWFwemcxVkRIT0ZuSGtjN1pLeWJnQmJuYmoxNHd0cGNK?=
 =?utf-8?B?U0FreWdhMUpZaHhGdXpzQnJucDhSVnd5bVc2bWN0QnFGNm0zaTdpeDZEeEUz?=
 =?utf-8?B?UnJ4WGRuNUk3UVJFK3FPb2NuVVFTRWpQV25qbGJSaGJ4bWlPZVcyZElGT01N?=
 =?utf-8?B?L0t0N3JwREo0VW5hang3Ym1UYk9VSUdXcnJGT2d0RzkvTlU3V3F2bVcrM0VI?=
 =?utf-8?B?VS9Lam5wUWg2ZGoycm9YRkN2ZFc1L3hibUw3K2s2ZTZKUkQybUtXZEszaEVF?=
 =?utf-8?B?ajNNdVQ3RGtCVkVsQWFsZFJFQmlCd0NraHFTWGJYR1htVlJtd3V2L2dkQi9D?=
 =?utf-8?B?WW45SzJyZTgrV3k2cW1kRmpya1hiak9qV0tQOG0wb0NHeGgwcC93OWt5UzZ5?=
 =?utf-8?B?YWlPdVhOZzc1eWUzMTJKZUtDR0I0eDI1eTk2c0FkcG1GZklERU1aTnpPM1or?=
 =?utf-8?B?RmpmTEZhNjF5Mm1CR2VSSFRGZnlONzRuOTZiYVVpa3prQXpUVzl5SHROb0Rj?=
 =?utf-8?B?cVA1cHJkRWtxMWg3aWgvS3NsVlRUc1VKbFY1UUh5cTZVR05Ka2RTMUZlRGdP?=
 =?utf-8?B?dXFWYkdodFQrUDZseWJNV3VkL0RWZlgrUzRrbVRnSy9CL0U5dU5XQloyeVlB?=
 =?utf-8?B?VTk0eE1NU1RRVDFwRU5jbXlLQUR2MVlHNnl5VEtSbzhCclgxMmFnd3RRSW40?=
 =?utf-8?B?WnhaRzBFZTA1VzlvdkI1cUlwdHZMN3Ewc21MNXlabnFGMmFBOEVkcGNzanhy?=
 =?utf-8?B?cjhMeExiamZwaC91VlUwVEtLWnFuV0hMNDlKNDdlczh1UklJUCt4MHdLVms4?=
 =?utf-8?B?QUVSeTNkUUYwN0E2SDhKUjlnRXhkYmdNK0NmNHZ4M1Bhb0tESUIrWG9rRVdP?=
 =?utf-8?B?bmxyVjRrdEU5ekhGalBzRDhzSmNmbkt6ZUVSZHVuSVNhUDF6cHM2c3lsdGJL?=
 =?utf-8?B?Tm1YUmNjTkNqOVc3YzFaRVZ4YitxaWpRZ0RKekJlajFMNzJTbjZQUGJFWjMx?=
 =?utf-8?B?NGRjTnh0SS91TkVMcDdWMTE0WmdUeURKOHpPTnAyWGNZNWdmTzRkcWZ1MjlM?=
 =?utf-8?B?ZUhWdGdoQ3NlaEs4a3hFcllacGlwTkNVM0ErRUZoZ3VXMjRKV0NqT2JyYlh1?=
 =?utf-8?B?U3NlNW9PdUVZTTE1QllocjEzNnFYd2k3bG9CeldzSjdESDBiOG5ISlN5OE5J?=
 =?utf-8?B?bW02a3E1YzN2WFZPR01OdllRbDcyWk1WVll6WFNvZUYwRFVYcGttZlZiQ0NE?=
 =?utf-8?B?Nk8wRi9iU1ZHVTRwbW1iOExuZnl3UnRoTldLUEJ3Y1pEV1laeGswQjgxYXQ1?=
 =?utf-8?B?OFh3YUx1L0VBeVd3eTdxTFg4RFUwUG1MNWhGWnhhamZQUzZac3ZKL0JNVmVu?=
 =?utf-8?B?S2t3aUQxQnlucVNJK2hQcUtOTi9iT3ArVStRcUFqS3lOcEc0UG9xb2J1WXkv?=
 =?utf-8?B?SG9LUzBlRXpmTTBuZm01K0RPL2ZtcHZMZnRhendLakZKM1NFWDdjeUh1UFo0?=
 =?utf-8?B?YTZCblc2YWE2MnZTR2JNQjBHN2hwb0ZYcGlQandZeXZmbXd5VmVVTEUwU0Z1?=
 =?utf-8?B?bE40a1pjN3lhM2d2Qlhha0N0UU4zOXNwVldTYnlYSExnU09HbDFWZTh6QTVC?=
 =?utf-8?B?cDJkeFI2NFNqU2krMTR1bExWOUJPRTVSenQ0V2VzWE5teFhUaHM4WFR1M2c5?=
 =?utf-8?B?RHQvOVFBcWI3WXNmL0RLcUF4S2Ftakczb3lLK0FSWEZ2VEtwSU81bmZhd0g5?=
 =?utf-8?B?MTE1SjM3ZGxaQXNENFJ5VFhYYnFTRFpiWWlmSDBJUGsrSUVGcTRsZGlBTDFM?=
 =?utf-8?B?N2JzY0phMnB1b1lwVTY1TDNvMnY4TXhTZU9ZUWxHZFBNVFE3bHVHZUdUcStM?=
 =?utf-8?B?Tk5QeldXVisxcWEyZWZXYVRXSW54TXRPVFhJUTBJemNxZlNvTkx6VUlPRzZH?=
 =?utf-8?B?N3FKWFZqWDlMK1hVYU9wMFA0TVBpWFdWajVQdFFreFA3QytpaVZLbm84TUVn?=
 =?utf-8?B?WW5SdDN1NUo5UWo4MnB5aHJ3bk9pWVdkOW9wR09wUVYwR3dhZmhBZHlZVDRP?=
 =?utf-8?B?c1VycGYyWXZXcjl6cFl2U2c4c0hNS3F6N3hBM1JJRDZNQnpiaDNuWFJLbExB?=
 =?utf-8?B?TFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?OWhncjBvWm9SKzRrNmdaRnlaaXFkV0tnUUIzRUpBNHh4aW9kT0hIbnJqK0RJ?=
 =?utf-8?B?SkhBREtMaDRtcWdieXBVbXBQMmF5akQ3NEkweWUzRmZzemR0WTNBYThZZWx4?=
 =?utf-8?B?SDUyWE4zc2NzQlBPUFVCNVlDOEJiQ0dXZWQrQ0FiTzFWS3k1QkIxcnBKaGg1?=
 =?utf-8?B?NGpZblg3aFJjLzMvb29wVkUvdklZZlVZdkNTVGtRb1hlM3J2S2N1VnJCTGZm?=
 =?utf-8?B?OXdBZnYvUDJnMzNQbEJ3SzErQUw3RnJPN0pXODJ6V01hWEtIVzBNQjRRUFkv?=
 =?utf-8?B?TjllbTB1UURudmRjNmZ6bE9JWTVSRHBPYkgzNVJKcWdvamh4R1RyYUF6b2FK?=
 =?utf-8?B?R0hFZnVXN2RNU0lHcE1WRmN5RTRmb3NPUldLN2pkWGt0c095cWVISjhoYUpk?=
 =?utf-8?B?aWpjL3cvM3NEaVBIU05Bc3IrSW5GaEU4WHBJTm9tY0ZRNEhtVHZsZkNMMERy?=
 =?utf-8?B?ZzRCamlGcjFreTJDWkZuV1VlMWoyVkxLOFl0Z2RiY0ZzUUhRWTJnZmtVZDRI?=
 =?utf-8?B?U1pjYnlvVE1kd2dUWWhtb1hpSC9FeHhSNDVMVElNbkZWZXZWbGNXUkxmY0Ix?=
 =?utf-8?B?Z0lqYUcvYmlLcTBsR1pMbXJmQ0FJTGVOQ01tRFhEQVBoNXEvYlZmNklWY2xx?=
 =?utf-8?B?ak15WS9DVU9FREdlZXpSaklrUis1MXZEYTYzR0ZDVW5KUm9rQU9NZE1CYzQv?=
 =?utf-8?B?cVhONkNZYklxbmlMT3h6cjFjOU5nLzlKZCsrSlh4cUFhSkpWL3BRV0ErL2V6?=
 =?utf-8?B?NzlmdVgvbW03MEU0blZzNm5ZbGNkZE1zTm9JVklSTXFteVpxN0hocFdReWlP?=
 =?utf-8?B?VExaQ2hWZDhRMHMrdFY1eTRkeDdDZkRBZzY4cnJsR0paTGNyZVd0T2ZaVU9v?=
 =?utf-8?B?OU5oZ3AyUlE0dzQ4ODdOOTdsQlpUM2ZjM2RVZ2hJMmt0bkg0azhncER5c3dI?=
 =?utf-8?B?NUdHMnhYcEZQRVFnWGpXYkhXTXF0N0hVY0dMZ3RpYkw5V1BOcUg1aGZ0SU40?=
 =?utf-8?B?UkNNcjJTUEREV2kzajhBRnBUZWx0NDlrRHBrV2cwYzdWNytVQlA2cFhocGF2?=
 =?utf-8?B?TGthRFJZMTJHSVpTWThiM1RHUjlZZDg1VmVUWndON3pBc29RYnZKdDB3QjJy?=
 =?utf-8?B?S2FIQ3RaWHpmbGkrb3VSOVEwelkxN1R0Sm1WRndEdk5xN3RRbzZFTzJ2YjQ0?=
 =?utf-8?B?bGUwcmdTbWVQTWdRMEpLbEVFK3MrMnc5ei9EemV1VUxlNVlLb2Q2aEVtRnpG?=
 =?utf-8?B?STNldU1IU2dVdVh2RlBaWHVwcnhhTyt4K1czQi96RnVpWlpjUnBrWVUrRlBs?=
 =?utf-8?B?NWV4NG5EKzRjT0tuRDRDTjV0RjBDR0hqeGRWUFZxRTJVSGEzSVk1QUlsWncz?=
 =?utf-8?B?eEhPYW9QN243RGVZOGM4VXY5Q1pCY2tlczl2QTMzTXBZVHVsR0grc1g0amda?=
 =?utf-8?Q?X8ugDe2e?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10b7c972-5778-4b47-408c-08dbd14fc834
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 09:34:39.6392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yxYBFj+FoJnqVLLRw1bgDAmTRa5pbxgSUWQzo8yF9W+pdmAUu1NUczdSgwCj+tSuQltSILUs3yd5+CyGxMraLQTX8+kdynLED4BjAEyRCTQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR10MB7947
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_07,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310200079
X-Proofpoint-ORIG-GUID: wVZm2WEz6DZ3uORhvumm6qt12NtpwgjQ
X-Proofpoint-GUID: wVZm2WEz6DZ3uORhvumm6qt12NtpwgjQ
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/10/2023 03:21, Baolu Lu wrote:
> On 10/19/23 7:58 PM, Joao Martins wrote:
>> On 19/10/2023 01:17, Joao Martins wrote:
>>> On 19/10/2023 00:11, Jason Gunthorpe wrote:
>>>> On Wed, Oct 18, 2023 at 09:27:08PM +0100, Joao Martins wrote:
>>>>> +static int iommu_v1_read_and_clear_dirty(struct io_pgtable_ops *ops,
>>>>> +                     unsigned long iova, size_t size,
>>>>> +                     unsigned long flags,
>>>>> +                     struct iommu_dirty_bitmap *dirty)
>>>>> +{
>>>>> +    struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
>>>>> +    unsigned long end = iova + size - 1;
>>>>> +
>>>>> +    do {
>>>>> +        unsigned long pgsize = 0;
>>>>> +        u64 *ptep, pte;
>>>>> +
>>>>> +        ptep = fetch_pte(pgtable, iova, &pgsize);
>>>>> +        if (ptep)
>>>>> +            pte = READ_ONCE(*ptep);
>>>> It is fine for now, but this is so slow for something that is such a
>>>> fast path. We are optimizing away a TLB invalidation but leaving
>>>> this???
>>>>
>>> More obvious reason is that I'm still working towards the 'faster' page table
>>> walker. Then map/unmap code needs to do similar lookups so thought of reusing
>>> the same functions as map/unmap initially. And improve it afterwards or when
>>> introducing the splitting.
>>>
>>>> It is a radix tree, you walk trees by retaining your position at each
>>>> level as you go (eg in a function per-level call chain or something)
>>>> then ++ is cheap. Re-searching the entire tree every time is madness.
>>> I'm aware -- I have an improved page-table walker for AMD[0] (not yet for Intel;
>>> still in the works),
>> Sigh, I realized that Intel's pfn_to_dma_pte() (main lookup function for
>> map/unmap/iova_to_phys) does something a little off when it finds a non-present
>> PTE. It allocates a page table to it; which is not OK in this specific case (I
>> would argue it's neither for iova_to_phys but well maybe I misunderstand the
>> expectation of that API).
> 
> pfn_to_dma_pte() doesn't allocate page for a non-present PTE if the
> target_level parameter is set to 0. See below line 932.
> 
>  913 static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
>  914                           unsigned long pfn, int *target_level,
>  915                           gfp_t gfp)
>  916 {
> 
> [...]
> 
>  927         while (1) {
>  928                 void *tmp_page;
>  929
>  930                 offset = pfn_level_offset(pfn, level);
>  931                 pte = &parent[offset];
>  932                 if (!*target_level && (dma_pte_superpage(pte) ||
> !dma_pte_present(pte)))
>  933                         break;
> 
> So both iova_to_phys() and read_and_clear_dirty() are doing things
> right:
> 
>     struct dma_pte *pte;
>     int level = 0;
> 
>     pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT,
>                              &level, GFP_KERNEL);
>     if (pte && dma_pte_present(pte)) {
>         /* The PTE is valid, check anything you want! */
>         ... ...
>     }
> 
> Or, I am overlooking something else?

You're right, thanks for the keeping me straight -- I was already doing the
right thing. I've forgotten about it in the midst of the other code -- Probably
worth a comment in the caller to make it obvious.

	Joao
