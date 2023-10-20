Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC937D0E4E
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 13:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377008AbjJTLV2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 07:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376933AbjJTLV1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 07:21:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE8618F
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 04:21:24 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KAi5fl021111;
        Fri, 20 Oct 2023 11:20:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=tuNGUZiM/u1SHwpPLSoCaTP5gRY9dChRjZ4WikEt5vM=;
 b=n/y3PLf6mfkrZsrhzrhlI9h7hWtNwAV/y115/ieF3WRgA3YIwlpXMjvkyU81dTIsxv+q
 nMia/Tu32QIkqOCCTa9aqp57jC/WPctZ+wS8isuJx+/ZjTK8dmXPeW9AKPaEfwZcGQty
 fL+SXHG0CjgOyBLG+yki8PIJERtNvBUFPOUks/minLqCigUIyITGMhijKSboyp4vfHTQ
 pwp2HpPDwDYxi8YDjP3yagimh9W7NN64WJs7SBYRWo2PlCVO4PGRThNObhBtRhDSsoWF
 xRNXpITSfhFZ9dsjaysSBkP7Gsn4hQY/FOuRy3RyEUsbBxwVIK3JjS9nk2wipYQRJOpR vg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tubwb9mff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 11:20:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39K9d2Wd013990;
        Fri, 20 Oct 2023 11:20:53 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tubwf6sf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 11:20:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=brIhjF1phAd0Kw3d3YXS5Ds3/cn9WYZ3NWr9xMlKWL3BUV3VFw5CLzHFGa1HGC9jMYyFMgPxHO4soQDjZoNfZcbMnABIaRTbukOtT19+TlfFNe/a4iRU6Nw6q+ORRxejIxfW453dOTEzwKMuNeUHJrZUDNBklvAGRxlnCd1TE+dKQkRIqiaJ++yebE2OvdFuBy87uv0CnpVHiNfsNsGQXJTiT2YFgQ4025NIZn6WQ+h8BiUHf5qntk9EKsZXSXlYzhEQqra/lJEq97XRBsJJ0KyFzBczTqvpX12Wzkqb6ACB80nfry23SGvYRZnqXHRWSv0wqGW9+Z3LKEDrdEqpvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tuNGUZiM/u1SHwpPLSoCaTP5gRY9dChRjZ4WikEt5vM=;
 b=JZrZHtL0VyxOiNtdSNW6xD1wfbmmDIC5oBISWpbyru4nSHIEtxJGq6cD5EF87ys1kDsZDLDY7yDC8PvGZIMExOAHObTwfrEruVphZvVeN+XXomnq0u939bAYvWBVrAagH/YwOBEYCUw3U2FRyFH5IGs8tHiMlVzGT+vt/ehKVMoAyBJvdmNY2SZ7fR8HeDktpDnK6P3xAcALqEtXf8SlXM3IdFU4ekERTO8xo2LS3AqZQMrgHvmiS0+Gy4PD7tp8aNixNIwM718d2WbcaHMkgZ15WV3H24CLxK+A3o1BbAkt2fxHHj21TsiDHDP0ggHxCXThoBWBAsZXi2vw61tDJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tuNGUZiM/u1SHwpPLSoCaTP5gRY9dChRjZ4WikEt5vM=;
 b=lpJbYeJxJG4oM/4DwljT6gus8N/tpMORtYl4h4ED36nqEn3QmnBbym9SSd4xQ105WW72gqLMPgQh5FsaqIVALfPKhwa/70bj+vVxZ9AoGXRelvfqr56YHiQVAjj1+mafCRiDKC4uywbEz77DMsHt5Nux+dPag2Iio1Ycz5AfXLg=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SN7PR10MB6406.namprd10.prod.outlook.com (2603:10b6:806:26a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.41; Fri, 20 Oct
 2023 11:20:50 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 11:20:49 +0000
Message-ID: <395aa01c-b982-4ff3-aa05-9fa0ea50bfee@oracle.com>
Date:   Fri, 20 Oct 2023 12:20:44 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/18] iommu/amd: Access/Dirty bit support in IOPTEs
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
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
 <b5d304b9-d54f-4abd-bfeb-de853458d2af@oracle.com>
In-Reply-To: <b5d304b9-d54f-4abd-bfeb-de853458d2af@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::6) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SN7PR10MB6406:EE_
X-MS-Office365-Filtering-Correlation-Id: ea993212-1753-4675-4c2a-08dbd15e9d21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hJBBLu+L4CfxZFty1PjQDid8NL7L7SjoUQpzX0qyuz8xVolvq9d3BQbw/hDiM610VJH36Ck7j8Up4sKJwGo7TvgZbjn2bDkI6DufJYKZvdQCXOeAq/cDD5EgT4NWzvIyuL7NJ8n7ikhbAgqpDl7vDWNOwFRPEuXqZDgZ5zR9FzFE0HVcw5HA9y5MfLEWHM743nG3rNmHszspdAa5nYu4+Ut3L8YZRGDFdzeu5IxgnQR8P+mf6Yc3ELDbIiMvL2smr2LeQdcrS47/E3Bdw+1c/q4nEdxt+VNZHKMP5KvQ8i3N64fRc/tCJI6FqrR/FREaiF0EsVC9jTVZrmbx0qCQ2P+4Bur18g27BDrALiwnF5QPfm3PKl7E0Hw2RClUDxAJYCPvaU2RXdgaoRBiGD8Uru9Q5fX7FIU607UYRDak4lSaXOJwLUozHT1TWep/cVfy6UyM6Fck86emGkw8m02/Ii9JQn5YQ3NwVOIP1OLl0iR17hb+uqtHmQ6I7hvZeZ67LvTNwk721D/bi3rQ+piraAG37T8nmHeXXhPMXEiFxc2ele2VYkjpL+A0ujYbKUz3AxNhMEJfwoAm2GAi0esJxbayjODfP1fxqTpNTMXqLj9taYnlpSXS7ZazcOCmGtFNKzVSopyR0sh/OeW4ljjDxnDE2Ctijhu5rlTGMVIYHQc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(376002)(136003)(346002)(396003)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(31686004)(36756003)(66946007)(66476007)(6916009)(66556008)(31696002)(2616005)(38100700002)(86362001)(54906003)(316002)(53546011)(83380400001)(26005)(6512007)(6506007)(6666004)(4326008)(2906002)(8936002)(6486002)(5660300002)(478600001)(41300700001)(7416002)(8676002)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eVk0YXZyNXpCaVYrMXFsdFRpeXN6YVVuSG1QZnY0Zmt6U3dYR2lvNTFRcEI5?=
 =?utf-8?B?dUduc0Z1eU5TUzFwT1IvTHNZOTZjRTdXMXlTRHpaamtCVnlIUzNkNTVDVGwr?=
 =?utf-8?B?dEFVaThHaXVNQTVsZCtzelYvKyszNHc1N1h5V2t3THI3dXozZnl3MmdJLzhB?=
 =?utf-8?B?L2ZQRUhhZHNvL0U2R3lMSC9ac3dqcUpORVh2TVI1QzYzTXNKbFhWTmQvR3Jo?=
 =?utf-8?B?ZFBSYUNZak0zSWd6dTZKSGtJbm02WE8xSnJUTWFJWWg0Z2h0U3dHZk9VbUk0?=
 =?utf-8?B?eGxBbDJYa1lRR1NGbER1VjZYMHRpNnp1TTBiUk5CcHpUdU0xYkxrdkZFbTY3?=
 =?utf-8?B?bTVEdU8rNnlaRnRUWTBuQWpHYnpndm9QZGJNYUJ5ajJPZzRMbWFCNndXMUpV?=
 =?utf-8?B?OFNFN1BmblpRaW5RT2tZWGpIdDRTVUpiY2Y3ZmVVOEVHQ1UwSXRVY20zZjBy?=
 =?utf-8?B?dWJjMm1vRDhoelE1UGtIdG5heERNMEFZaGU1YzdlTUxkZnJPSHR3Zml6LzZw?=
 =?utf-8?B?T3RvWGlTVURDNHBST3JKd1FzY2I0N3VIMjFZUjlYKzhieWZLYVI5OWxxZ0xI?=
 =?utf-8?B?SEtCak5qRjR1SGdvbzF3RG4zM1E0V1o5eFREdG8vcjR6b3dHSXBwVXNsRWtV?=
 =?utf-8?B?a0NUNmltdFpFOHJoN0tkYnVrL28wdXdNQkhTc0x3b0krdW5vaXhVMlpwWkMr?=
 =?utf-8?B?QjN0cDRTQTRvejlvQmZ5UmQyMXFxaU96c0hJbEhLWSt3cFNnQUpHWXFZbHFu?=
 =?utf-8?B?anZZSWR4bzJIL0Zrcys5UDFYVGFCTExyVS9hQ3hNSGI0dUVNcTRLMUhTMVRQ?=
 =?utf-8?B?a0RYbXRBTitjOXNFWW9Jbi9WWFVGek1Tb2VvNysvVzNCQ2RRa0FpMThYNUVB?=
 =?utf-8?B?eHRiUGNNV1M5M3loTm55MlNXaDhwQW9mZHhoZm1jaGJWbDZVeUV1SUNYTHFs?=
 =?utf-8?B?Yk1LV1AyRUV2dU5CdVpCUFFWMVgzS0RwbGx5bzRSak5HR1M4VnY0K2RyS0tu?=
 =?utf-8?B?SE1lSVdCSm5YVDExYXZpYytSN1huSXlyNmpmZnUxbmVSZUxNdUV2NU41TE4y?=
 =?utf-8?B?amNPbXRCQ1NpYVRQZjlKL1diNXpPeHdqSTJuanU3c0Vrb05obmwwM2JiVnZD?=
 =?utf-8?B?ZXZMNjNlZWlxN1ByL0phTmFuTXp6SHo3UzlaSng2c1hTeFRSaC9VTlU4UDVi?=
 =?utf-8?B?SUpBeXZhZHRuODRiTTJaUEthQ0Z2bXdybmJRdyt3cVBxS1FkUFEya21mdTBi?=
 =?utf-8?B?UlVGSnZxdE1aUlpIRkdCK3BIQm5XdDFQWHBEZUlaM2dZRmlXL3UrdnVDZ3ZB?=
 =?utf-8?B?Y3h4TlphamlEaGlScEZmb01VSzc4RE85dkZFRnV2MDdSaDZBR2QwY1g0dS9w?=
 =?utf-8?B?YkhtTkQ2TTQwOWJWOUUyaXZTSTJSK3hWMTdxUmRHR1JBcDBPQ1ZDREpITjZ0?=
 =?utf-8?B?WUhNZ1BPSW83WktYU0ZRcFg3eFdZQnpmbHlJVzAyYit1VndKS1BEUlRkRDBP?=
 =?utf-8?B?UVBLc3UxYk5QUldmMzVscVZiOEV3MER0dHBSTFpFZGpvUkgxbEtSREowTFZZ?=
 =?utf-8?B?UEFsZTlhcC9LRklnVWpvT2NJR0V5d3A1WlA1NHJBL283bGJ5bkhvZzRVRTBv?=
 =?utf-8?B?RC9Zc2l0RXNVZlcrRVVZV1FJOWYxMmJXQmhRQkMyZ3N3V2EzaXpPU2R0QWZq?=
 =?utf-8?B?clhPWjkyRHpPL2JYcDlMVXg3Yng3U2dneStLVVlweXBMV1hTYU5wNTE5aWFD?=
 =?utf-8?B?WXBvR1JDMWFKTm5QMW9zbVZQMS9sdjNVTHpYU2cxQkJpMkpvSEptUThKNDRI?=
 =?utf-8?B?dGJhUVlwVE5EQnpycjlJT25GelZSbDR0cktGdS9KRHQ3Rktjc3RpaUdVZzhq?=
 =?utf-8?B?ZXd5K2lHM2lPemRiNnZSenl5TEFneFdvbkIvR2wvTCtrbC85TnJmdkUxQncv?=
 =?utf-8?B?ZnA3cHUvQ25MSStubzB2d0wvVW0wbWltN2FSS2o3L3VpZGpVRzFJYVRxcXZC?=
 =?utf-8?B?MDAvWmhBMkREOFFaZU8vNFBiYXYxdkVKTVRqdGVmeUhMRkhxQ2YxNUl1MmN6?=
 =?utf-8?B?YnFRQkthZlVxZFp0Q253YU1wQ2t2RU9OaGJmUW5SU2M1eEJRbVdUZDVhUmgw?=
 =?utf-8?B?SUk3NG9xK2UzSGF4aU91RGQyRVFsRjVKaHJQOWxSMzc2bUk3ZzdNUjN5V0o2?=
 =?utf-8?B?MEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?UDZ3ZzFEZlVudGNPd0x4WU9hOVJ3Q1lSN05CUVZwVEZ0TFBscGRRNXIrNWVu?=
 =?utf-8?B?RWRiaW1udkVVVmpUV2RSZ0hxTkNvaTFxNm1JREpINjJRd3U0N1VRK0h4Qy9Y?=
 =?utf-8?B?M0dwak9HeEdZY2sxalNaQlpZTFF6OXBNVW9PMnZGMURhd1Y5MnY4cUJtQ2My?=
 =?utf-8?B?M3hTMmgzVlN0QUF3ZWl0RlhyYnBLZ0NQQTQ3QXFTQjhtMFo0V1hXSVJ2V1BW?=
 =?utf-8?B?SWNURlJFbFhNSElPVktVMW0vMjd5aVJmMkhidk1UeGpzb0gwbUF5NXlJNm5r?=
 =?utf-8?B?MXc0anB1UlJUclVuUEl4bGlMMDY1Z28yVysyTDhZd0Z2MnJiamlPdFArUWFx?=
 =?utf-8?B?bWRLSHl6eVoramR5dlplanp2RUZVMWF6b1ZscjAwZkxRbjZLcUtIRjdUNEZM?=
 =?utf-8?B?dStiNDIrNUUrbm9MQ0hEV0Yra2hnVTZMQUFZZ0ZFK1d4Nyt5UHlXQkMwRUds?=
 =?utf-8?B?aks0RFVFTGZjTEY1S2RCVi83YmlSUWk4bDNHWEk4QWtpQzV6bEw3clgwYkdE?=
 =?utf-8?B?WHo3QnFhY3N3SVArTGdwSGJ3U1VQK242Qlo5THNxVS9PVHNjWDlKbi8vUUhT?=
 =?utf-8?B?VkRTVEZSdENObUtrVjl4Vjk2YzVLOTVRa2tRTmRldmxkckxXUWhJREJMSTZO?=
 =?utf-8?B?Q3NHWXZKbHlKRlFKWE83d3c5VlBBaGhNS25PS3ZGWldVUE43TDRoTGoxOUZR?=
 =?utf-8?B?Um0ya0ZtdU9pRGFIWEhaclZBUGZaZmhIdUkwclUzb2Ywak9QM1FwN3BLTDN6?=
 =?utf-8?B?NldqSklBTXRuK3UzbE55aFF4MVppWFRnOFVRNURWSVpSMjlKZDhYZEtZVzEz?=
 =?utf-8?B?Vi9JMkVNM1B6OWFCKzJqcFFzMzJpM09kajFZcHhPdWlrZ2t2ZlN0blFBZFVi?=
 =?utf-8?B?TEZETWVEdkhUMWN1cit5QzFweHk2eDNkSHZwTmtaWERTYXllYitmZlVtbm40?=
 =?utf-8?B?TFBsbDJERHBOcFJ0Q3pFcHNYMy9UZklGdzB6YjJ5cjNodFk3VFRjdGNQek9z?=
 =?utf-8?B?a0RzenVyTFh1MzFxZGRwTVQ5MnVSQ1NidWhtbEFmSk1PcWNjSkp0MVNwbGNp?=
 =?utf-8?B?TnJYMUVuY2NPUzlFdlVGRDNqZ1FCcHloOU90UTdJYjZxWmFhSWc3aXA1TjNa?=
 =?utf-8?B?a2J2dDluTy9WK3ZDSmlBTG5GaWRYMGNCWGFhRGZpY0Qwbld5RGNiTnJnUnZj?=
 =?utf-8?B?em5adStEVWw2ais2Tml4S1FLVE1sZjRZRHgrNUw1eVpFb3FCWExFc0NpZ0lB?=
 =?utf-8?B?MDUxYnVGVVY0aVVpNTQ3MW1SVnovNDhZWUJlc0VYOTQ2RDV2QnlJRy9Sb0wr?=
 =?utf-8?B?bGpTa2pleDJNZ01iZTNCYWQwNVlzMGlsWWtsS1ZKV2RIQ0pINUxZQ2hMaGRS?=
 =?utf-8?B?VU1VVXJ1WDFtRGVlNmJZTVk2VWltOEUxQTBkd1JrZEZHU1pIc0EwWW5aQVFK?=
 =?utf-8?Q?JGJinesK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea993212-1753-4675-4c2a-08dbd15e9d21
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 11:20:49.8347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TvsSQfPn4d0HYHtcZnhjGRsYUuQ0faj90hqwhZvj7qDuCDJqTMNNCsL/aUNgfZYqidW8fnYNWxjL0isxHcgnA9Cgx7bG/1lGj3q4r2g7fKs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6406
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310200094
X-Proofpoint-GUID: QcwfPmi72xMD-ZWS27gBP44SKeScettQ
X-Proofpoint-ORIG-GUID: QcwfPmi72xMD-ZWS27gBP44SKeScettQ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/10/2023 10:34, Joao Martins wrote:
> On 20/10/2023 03:21, Baolu Lu wrote:
>> On 10/19/23 7:58 PM, Joao Martins wrote:
>>> On 19/10/2023 01:17, Joao Martins wrote:
>>>> On 19/10/2023 00:11, Jason Gunthorpe wrote:
>>>>> On Wed, Oct 18, 2023 at 09:27:08PM +0100, Joao Martins wrote:
>>>>>> +static int iommu_v1_read_and_clear_dirty(struct io_pgtable_ops *ops,
>>>>>> +                     unsigned long iova, size_t size,
>>>>>> +                     unsigned long flags,
>>>>>> +                     struct iommu_dirty_bitmap *dirty)
>>>>>> +{
>>>>>> +    struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
>>>>>> +    unsigned long end = iova + size - 1;
>>>>>> +
>>>>>> +    do {
>>>>>> +        unsigned long pgsize = 0;
>>>>>> +        u64 *ptep, pte;
>>>>>> +
>>>>>> +        ptep = fetch_pte(pgtable, iova, &pgsize);
>>>>>> +        if (ptep)
>>>>>> +            pte = READ_ONCE(*ptep);
>>>>> It is fine for now, but this is so slow for something that is such a
>>>>> fast path. We are optimizing away a TLB invalidation but leaving
>>>>> this???
>>>>>
>>>> More obvious reason is that I'm still working towards the 'faster' page table
>>>> walker. Then map/unmap code needs to do similar lookups so thought of reusing
>>>> the same functions as map/unmap initially. And improve it afterwards or when
>>>> introducing the splitting.
>>>>
>>>>> It is a radix tree, you walk trees by retaining your position at each
>>>>> level as you go (eg in a function per-level call chain or something)
>>>>> then ++ is cheap. Re-searching the entire tree every time is madness.
>>>> I'm aware -- I have an improved page-table walker for AMD[0] (not yet for Intel;
>>>> still in the works),
>>> Sigh, I realized that Intel's pfn_to_dma_pte() (main lookup function for
>>> map/unmap/iova_to_phys) does something a little off when it finds a non-present
>>> PTE. It allocates a page table to it; which is not OK in this specific case (I
>>> would argue it's neither for iova_to_phys but well maybe I misunderstand the
>>> expectation of that API).
>>
>> pfn_to_dma_pte() doesn't allocate page for a non-present PTE if the
>> target_level parameter is set to 0. See below line 932.
>>
>>  913 static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
>>  914                           unsigned long pfn, int *target_level,
>>  915                           gfp_t gfp)
>>  916 {
>>
>> [...]
>>
>>  927         while (1) {
>>  928                 void *tmp_page;
>>  929
>>  930                 offset = pfn_level_offset(pfn, level);
>>  931                 pte = &parent[offset];
>>  932                 if (!*target_level && (dma_pte_superpage(pte) ||
>> !dma_pte_present(pte)))
>>  933                         break;
>>
>> So both iova_to_phys() and read_and_clear_dirty() are doing things
>> right:
>>
>>     struct dma_pte *pte;
>>     int level = 0;
>>
>>     pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT,
>>                              &level, GFP_KERNEL);
>>     if (pte && dma_pte_present(pte)) {
>>         /* The PTE is valid, check anything you want! */
>>         ... ...
>>     }
>>
>> Or, I am overlooking something else?
> 
> You're right, thanks for the keeping me straight -- I was already doing the
> right thing. I've forgotten about it in the midst of the other code -- Probably
> worth a comment in the caller to make it obvious.

For what is worth, this is the improved page-table walker I have in staging (as
a separate patch) alongside AMD. It is quite similar, except AMD IOMMU has a
bigger featureset in the PTEs page size it can represent, but the crux of the
walking is the same, bearing different coding style in the IOMMU drivers.

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 97558b420e35..f6990962af2a 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4889,14 +4889,52 @@ static int intel_iommu_set_dirty_tracking(struct
iommu_domain *domain,
        return ret;
 }

+static int walk_dirty_dma_pte_level(struct dmar_domain *domain, int level,
+                                   struct dma_pte *pte, unsigned long start_pfn,
+                                   unsigned long last_pfn, unsigned long flags,
+                                   struct iommu_dirty_bitmap *dirty)
+{
+       unsigned long pfn, page_size;
+
+       pfn = start_pfn;
+       pte = &pte[pfn_level_offset(pfn, level)];
+
+       do {
+               unsigned long level_pfn = pfn & level_mask(level);
+               unsigned long level_last;
+
+               if (!dma_pte_present(pte))
+                       goto next;
+
+               if (level > 1 && !dma_pte_superpage(pte)) {
+                       level_last = level_pfn + level_size(level) - 1;
+                       level_last = min(level_last, last_pfn);
+                       walk_dirty_dma_pte_level(domain, level - 1,
+                                                phys_to_virt(dma_pte_addr(pte)),
+                                                pfn, level_last,
+                                                flags, dirty);
+               } else {
+                       page_size = level_size(level) << VTD_PAGE_SHIFT;
+
+                       if (dma_sl_pte_test_and_clear_dirty(pte, flags))
+                               iommu_dirty_bitmap_record(dirty,
+                                                         pfn << VTD_PAGE_SHIFT,
+                                                         page_size);
+               }
+next:
+               pfn = level_pfn + level_size(level);
+       } while (!first_pte_in_page(++pte) && pfn <= last_pfn);
+
+       return 0;
+}
+
 static int intel_iommu_read_and_clear_dirty(struct iommu_domain *domain,
                                            unsigned long iova, size_t size,
                                            unsigned long flags,
                                            struct iommu_dirty_bitmap *dirty)
 {
        struct dmar_domain *dmar_domain = to_dmar_domain(domain);
-       unsigned long end = iova + size - 1;
-       unsigned long pgsize;
+       unsigned long start_pfn, last_pfn;

        /*
         * IOMMUFD core calls into a dirty tracking disabled domain without an
@@ -4907,24 +4945,14 @@ static int intel_iommu_read_and_clear_dirty(struct
iommu_domain *domain,
        if (!dmar_domain->dirty_tracking && dirty->bitmap)
                return -EINVAL;

-       do {
-               struct dma_pte *pte;
-               int lvl = 0;
-
-               pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &lvl,
-                                    GFP_ATOMIC);
-               pgsize = level_size(lvl) << VTD_PAGE_SHIFT;
-               if (!pte || !dma_pte_present(pte)) {
-                       iova += pgsize;
-                       continue;
-               }

-               if (dma_sl_pte_test_and_clear_dirty(pte, flags))
-                       iommu_dirty_bitmap_record(dirty, iova, pgsize);
-               iova += pgsize;
-       } while (iova < end);
+       start_pfn = iova >> VTD_PAGE_SHIFT;
+       last_pfn = (iova + size - 1) >> VTD_PAGE_SHIFT;

-       return 0;
+       return walk_dirty_dma_pte_level(dmar_domain,
+                                       agaw_to_level(dmar_domain->agaw),
+                                       dmar_domain->pgd, start_pfn, last_pfn,
+                                       flags, dirty);
 }

 const struct iommu_dirty_ops intel_dirty_ops = {
