Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D92A7D0E57
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 13:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377043AbjJTLZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 07:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376999AbjJTLZf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 07:25:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B6F91
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 04:25:34 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KAim5C025197;
        Fri, 20 Oct 2023 11:24:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=X0XV2FfMVpDA5too5ak0u2U9e5O5tkOtQgT3A+B2WC4=;
 b=YlfaWvClTNwHW7joA9yenCOJOaYCt8RlSezM+ypuhR19IBBYnVlOjI7TUYjdH8okIsqQ
 4hK7C/+6Gf5QK0bQDNgsMbYetVBY/VLnL8A9keIROvJME59oV300AJ4dN03bBE2zc9Gq
 gZu0PWGAhtVoiPFRU65ZUlA7HznSF9nEmqNgfp0K/V8IzVYnd4kPpp1OzsjvvEr215SW
 6ba28NGCI52J8TEyRym4OcCGIrjm0Gd8BubOEWCW2IISxYu9fnUEvuyQpH7+aUBbM6G3
 qhEKqIzJRPP/RBDP5DQCultsQUi1howTe4E0icHc23UQUXl2DVxQ4NmtzKw0qkSVz3Vy Aw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tubwd9m4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 11:24:37 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39KAUIaE025729;
        Fri, 20 Oct 2023 11:24:35 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tubwd6s74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 11:24:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UX2zGXD1fgIVR9iGEHrNGgrCSR9zWTjw8mzPrz+4CU29U2BjImXhJRdGQZwHeofra1V7wFhGsi0wYBxH8sGQs+LYx8O6cie10rNhQIxS+cSw6IxlgMKqYuQxKMwYbcWv7GmdDTftvFIfPSTVW/XQfXM0/jvK4mAcFPDct815lk/uewskOkHoeSQUkU7Og97wpN1EZXVzslj6bwQnA0RQhF9mxP0jzncYY96DbqNLVOecdtdarZmom4I0sYkvF98dFPquz0vaeCrm8oFk05C1R0GVHYuTImbAfn8ePFEPTbd0jTglJ85PyjleLPkzNzY6+Spw2Qnc37JfywlC0pDhww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X0XV2FfMVpDA5too5ak0u2U9e5O5tkOtQgT3A+B2WC4=;
 b=PF6JjOANjgeNaW3VsgvqshQgeT+QdBwJTFBALLtEqjYSPKwC2YEYXPszjhQ7n9g5DytEYbDvQGIjV2cVO5pbTuQFWYYWAY+OMikDJ7LQJJvRgNufrMOpEbn9oo1ONUvVlAF+iIOA34rfltjc6B70Ax0LWZHcnJhlJhCjyEfggu99G6K4LW31Iu0Ewnh1Bjqvcolaf6Nlly7dyLnXcZgabhn9+mgu2Bf2C6lgzIRyznq1rL8NoBAF90G3zTTMCs0s56mYreBJbtEExWaUYDP30U1usx6TgnU2WvKMEDZij05WG1FX0bfT8mkgRNZXknE2/GwchZlfPcMpkPGZ1LGxlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0XV2FfMVpDA5too5ak0u2U9e5O5tkOtQgT3A+B2WC4=;
 b=faAEt4k8LJIfxhuyy/gv0/fSy26gVVqLBGRz5aQdwk4E95zkm4boOcdtVJwS0iGs649DPMxi5VtAouwn9lFfjwKAJ4OPI0/oS6WxYt2KipI8TTuTwPhRymSPj4yKziH2Dc0saE+WjZWYu01m5w0LvGtrR3VaIObnc7vo0XO2dJE=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SN7PR10MB6406.namprd10.prod.outlook.com (2603:10b6:806:26a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.41; Fri, 20 Oct
 2023 11:24:34 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 11:24:33 +0000
Message-ID: <684f8539-b710-4615-ba4a-c8c22d1b9a11@oracle.com>
Date:   Fri, 20 Oct 2023 12:24:29 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/18] iommu: Add iommu_domain ops for dirty tracking
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-5-joao.m.martins@oracle.com>
 <BN9PR11MB5276CF5FAF3F9A914DCD8A2E8CDBA@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <BN9PR11MB5276CF5FAF3F9A914DCD8A2E8CDBA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0496.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::21) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SN7PR10MB6406:EE_
X-MS-Office365-Filtering-Correlation-Id: 8681cfdc-56fa-4d3f-d6bd-08dbd15f22b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9ydysds85A6wJFR+Vd2JRKD9DBOYT2lHqismD2AkKTjMK5+i6HGXc3E26NangkwCsop6+9Ycz5qg+RB86HG44Kj9rfdA+gs/vQ6csXWjhJj+NYqQZ8bj0UHlCQLERbRjmCSqgPySDTT+EQKDSnOcsteogu9PRB/1j94y6bxArpP/Ej8TmjKrDZB3aNWNbgQ6Iyq/CDDZfERksfYr2V1s9b34fip6cBWyCNLkUHPM0asqthQgclWRLDvyt5xsGTjk+x+8o1j5FQmCB0ofKsANd3cr+99d9cYgtqyUPezkpUh1S6IQir55iKcURNKjgCRISn3riXBKRPmq/wE1GHym4n2/pwDIcVGPKnENWr4W8ArIA+Xq0StvngANCcsVlFzfF+SwDNs+UuGvGtbcW6/B1p0cGZ65R8l8s7jCEU8NW44lXpl4rN/S3UuI9PlK4d3PJURL4z3/IVYEOANtnuf48mUUCQ8psuB+M3t4NypWnXfFh6HPaEzUqCaQbBccPWMYorS8+JDy+tX61KMA+5YA1MywM+j1lY2KtDHb8e0UJjFL6/PAIPDxinW3hl/V9337JfUtG0MfU8uiqkO7Mp0VlJfAfLlqpwUwgQXVJ6z7Z8oFi7t1sc2hJCxgLsXqPpAydfeDui9+nwgGFGCzU/YZuOkotbTBP7jaAL+GFZsftt4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(376002)(136003)(346002)(396003)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(31686004)(36756003)(66946007)(66476007)(6916009)(66556008)(31696002)(2616005)(38100700002)(86362001)(54906003)(316002)(53546011)(26005)(6512007)(6506007)(6666004)(4326008)(2906002)(8936002)(6486002)(5660300002)(478600001)(41300700001)(7416002)(8676002)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3lONFI5UDgzcVJBRmtBWkkybm9HczZJQzV3eGdFZUd2bTRlUHpucnBoQndF?=
 =?utf-8?B?RlZ0SUxmNkNZcXRMV2lpQ1FBN0kvbUN0d25DeWpZcEwyVzZLUU02TlBnY3Qr?=
 =?utf-8?B?QUVlTHlnVDU1SGhEMzAyS1NzTWRuN0Q3MUNZQjhVL3BIQ1JrT2VZdkJDVzgy?=
 =?utf-8?B?NmtrVVZHQlA2MWsycndmUmR4VGtzZENFcWExeE12Ym9tbWEra2Rhb1Z1NGZX?=
 =?utf-8?B?T1Nyd2h2Y2VROFFNMjMyeFRGZTRMNzNCUlZubW4zRkxqWUY5RlJRZ1RMUUha?=
 =?utf-8?B?ZzBXNmNsdFlyY0NuUGtQY3RKYXc0TllIdEs5dmsrQ2orR2tBSTNYTXpKdEtS?=
 =?utf-8?B?dnozNzN5a0ZwL1VvSmRYaEtYck5iL05SVGZYR0tsWjB1MHVYaWE2TitTaDVB?=
 =?utf-8?B?Ri9QVUtBdzVxYTdtamt1WnhSekhTeUdTU3A3MWZkdTZlMGI1UDYxTHdvRE51?=
 =?utf-8?B?ZGlsQVhWMnVVV003bGZVRWErdVhhSXJyeXZ1SVp0TmV3M2NIajZEanYzU1Yx?=
 =?utf-8?B?U25MNTVEdTFpbmcwcUJhTGdIc3ZyUDVGOERxZTNVU2huMjdTUGJ2SExNQkh0?=
 =?utf-8?B?OVpEcjJ5aUNrb0VjNTc4eFFNcEo1S3haamVxWVZRUThwVE1Qa1l4bTcyVXYw?=
 =?utf-8?B?MnVHL0g4T2xXZVNHSzFxNVZuN0RnVTFyanQraEk3MGtpMGlPOU1XZW4rZlpv?=
 =?utf-8?B?c1JTNVcwVCsyRXBvbE1BcDRjcnFDaVREYk5qUStkR1ZzcUZrNnBWTnlWNm1j?=
 =?utf-8?B?dHdhWXRSbG9wL0ExREZUQ0xrZkNHUzBDNzlzaTRaNVNCY1pQdlBZS1VsUEVS?=
 =?utf-8?B?UkdJcjhva2hlbzlxaGJyWUFhc3pUNkJjYkluRTBKYXVCKzZPNk5XZnRzaG5l?=
 =?utf-8?B?VHM0VDliTDZMT2hYL29SbWthTkt1RG44a2V2d1FEZ2UxUFZPVHNnTFJ4VkJi?=
 =?utf-8?B?NWFPa2xRalYzaUFNaENxYXA2REluTWR1ang5OHhJWVAvSmtraDNuUmpzdTM2?=
 =?utf-8?B?NHUwZnltT29pU3NaV0d3ck5DOFpuL1FpMlJPS1dCQytkUFFlSVo1Z0tQdE9X?=
 =?utf-8?B?N0ptVklKR0cvTUc5SXo0T01IazAzZVcxT0xGdnZpWEl1d2FocTkxV3o5ZU93?=
 =?utf-8?B?bUtDdGJjRE1KOWxqSUZ0Y0VUelBNNlc3UFRZeit1RkN0OCtLaWhTYlJLeU1p?=
 =?utf-8?B?dzhmZnlyWTEvTnpxdStia2ZZcHJsQnVqblpHZFBlWHp1R2F2amZzQkJscTFX?=
 =?utf-8?B?SEtHUGRTNkhvYWcvcWhrcmJaWTVLR3J0Y3hMS2g5UFJhd2JKYzBURjEwRzd6?=
 =?utf-8?B?U1hsdi9GRnVLL1BqNGlhTTYvNUYyenpUWlQvRDVuR05ETzA1bllub2NqeVJM?=
 =?utf-8?B?Z3o0b00wbDR4cEZOTWk4MEhxdG8yQ2FHRzNBQW5rdENQQyszZU9LaUxGUzRt?=
 =?utf-8?B?R2JFcGJIMUpoamVDdUVyZFJwbk1pQVoxNjIyZXpHaER5bmVOM2ZYN2ZUOGhl?=
 =?utf-8?B?OTR6NUdVd1RkQzZHWG5sTkl6Y2g1aFNmM2phdTIvdnRNcnQ1N0pxSE5iZzFl?=
 =?utf-8?B?L2NhazRkL2k5a2NlWWN2M3VsSnFoRHBLTng5dEtzWCtoN21zQS9PZlJMVVEy?=
 =?utf-8?B?L2JaakZSSlorbllVdzFnV2NyNE94MWpFL3JtME5TbWhWZUJ3VlBjQUVMRml5?=
 =?utf-8?B?ek1NK0pVdFkvL2txRE9LNWNlQUErbjRYai9mWU1DdEY0RENVMVB5Mk5BTUZr?=
 =?utf-8?B?dC9lWWEzTEp1UkJOT0lGZllYM0VRSXY0Z3RGY2ZyS3lTdW5jcDEyTGFtSVJM?=
 =?utf-8?B?ZXMxelRwTTdpeG4wcEE5MlFEczJOeit5TUN4aVc0dHlHaHpaeWJhR0c1Wmpn?=
 =?utf-8?B?cStKU3V4Nk5NU0wvb1BQeU45T2wwaU9mU1dEbDFZVTg2ZndNR3pLamlvYVF0?=
 =?utf-8?B?cCtBUmZXU293Yi94Yk02VVp2ZGFCZWZJanlPYUVKN3hJOGVFaS8zOUFyaXpU?=
 =?utf-8?B?U1Q0YStKQXQ2VWdqZXA3djVmenJoSk9xZGlwMnlIRFlCK25xT0ROd1pHTnVn?=
 =?utf-8?B?TzJNQ0JxdVVCcU1PTmhOaiswMjdNdW13eFFiU1NydS9OeUpJNzZyL2ZhRldP?=
 =?utf-8?B?Q3Zzd0M5WjB1TlpFdTJIUjkzL0tkYkxCaU5RUUZidXlPWDhpcDNlMFFSNTVG?=
 =?utf-8?B?VWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?clp6VXFqWGFSZUxpYnUvUEFKRytqVzBnMnErVjVjODMreDRURVY1Q1A5S3JT?=
 =?utf-8?B?c2VHZ3ZkUHREMkZzNXhxdzNsNTFPTEIxcDkxaFZJRUNJSWZwckVla2Vya0F4?=
 =?utf-8?B?Qlc4TUxnNDZoV3Y4RCs0bzMzbzNYcUpNVE9BWFlCL1pacGJISWEvdVRSbTc0?=
 =?utf-8?B?bFFSakplYW05cXFkQVBDUjlmbTUxbGpoL3FoaFhKMEovaTd4RHZPOFViaDhE?=
 =?utf-8?B?d3g2MktZcDlxVzgwZElKNjM2dUFtS01CZDR1ZSs5eFdyU0JUUkFxUWhKUExv?=
 =?utf-8?B?WStWeTBRNzllL1lGU25qSCs3eEZuS1VUSGloOFlCdkVuQWtTaVJJYzRKN3ly?=
 =?utf-8?B?QVF6SVd0ZDFyeEVManFWclRkbGRHSDE3MzAySHRhOEs5am9XZUlEUHM4Ymwr?=
 =?utf-8?B?ZkFNUkduelJPWlczSXZ1VXBwaFFuYU9rbDFEcVpMcVFhdWxDd2FUWWUrQTRU?=
 =?utf-8?B?VWh4YXIzR1E3Zm9zMWE5VW8xUDEvNnN4djZ5VzFMYndOVTU2d09YWGNwMUFL?=
 =?utf-8?B?RUgxMXkwODQrK3VVeWlyWEVKYU13WnlSWHhwTmRkMmQ5N3RZUUZFL1hER0Vx?=
 =?utf-8?B?TDRhc0prRFZaczFLd1VqUnRsajhvY1pYUXFSSmVqNXQvTmdHdC9uTDQrNzY3?=
 =?utf-8?B?UzFSdDlzOVNvWTk0cTZoMG5ESGljV3pQa1UxNCt0NTY2aUJRNzF0TTF6ZnBo?=
 =?utf-8?B?WS9SWk1KdW50MElvOHR2VXhtTG5rbHRsL1Y2ekJvczRYbG9vZERmNEdYVEJU?=
 =?utf-8?B?MEM2RVR4QnBSN0Z2K0ZIcU9DcDFlYzJUVXNtbHpsQWxJZ3h3Rnp1SXFYaFZD?=
 =?utf-8?B?anhhaXNWZUZDaW1Uc1c3VzQ4YnJncU55aE5adm05ZXFJdTQ4NTMyR0tadnB2?=
 =?utf-8?B?eWtXaXkzR3pSL240UXk3MmRvZFZqTGlEcFdWTzNGaFBzVzF3UFJrNEdqa1E4?=
 =?utf-8?B?bTNmeitOOHJRNDRWTWF4NnlTdW5Pb0tNbXA3eUtSRXpuNlpmbFc5SGZRenJJ?=
 =?utf-8?B?Qm5Ja0pCZ1dxdE1CRFhiaEdZKzlkZHZmSzRuTkZiU3JkTm5hZ0x6WjFPTlZR?=
 =?utf-8?B?NjNmbEdmK1R1azVUVHVDYWN6QUVGc3lOTmdDRkp2amQyRmlZWVF5NzlZY3Y4?=
 =?utf-8?B?NEdWU3RDVFJNeGtENy9XOGxJWmtxemw3eGNOZG1FZ0dOcy90TVl4cUZNenhl?=
 =?utf-8?B?ZitFdFNZdUlIcXBRZmU1WlFhYkpnVWQyb2xmYkdzKzByYmVUd3ZYYlFFd0lw?=
 =?utf-8?B?dlBpdU9HbTk2Q05SbG9mRnZQdkMraEFiRWFpTElPWUowazltZFlzK0tldU9h?=
 =?utf-8?B?MkQyTXlxbk5qRHNzSWlFMDF0RW9ZdkttZFdBdXNuaTRzczYvNStrR0dlS2hG?=
 =?utf-8?B?MWlhTFAvT2hrQm84N1dDekM3ekx4c25rcnlqeWRSNFA5YWdFS1VRcG82STNy?=
 =?utf-8?Q?iN2knHfb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8681cfdc-56fa-4d3f-d6bd-08dbd15f22b3
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 11:24:33.9268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JL90bf4ZH1gngzilje9C0UPVfCLHsdUPhsMpqXvX/Ruzt4l1LT4EMBSbfhWrWcuri9ncgcFhq77x/1l0jN/YLeibHZ2i0FOe5OT/Yhp1D2Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6406
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310200095
X-Proofpoint-ORIG-GUID: dHvE6BXxcPk7DiH2NXG5Gyg4yW_I0jya
X-Proofpoint-GUID: dHvE6BXxcPk7DiH2NXG5Gyg4yW_I0jya
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20/10/2023 06:54, Tian, Kevin wrote:
>> From: Joao Martins <joao.m.martins@oracle.com>
>> Sent: Thursday, October 19, 2023 4:27 AM
>>
>> Add to iommu domain operations a set of callbacks to perform dirty
>> tracking, particulary to start and stop tracking and to read and clear the
>> dirty data.
>>
>> Drivers are generally expected to dynamically change its translation
>> structures to toggle the tracking and flush some form of control state
>> structure that stands in the IOVA translation path. Though it's not
>> mandatory, as drivers can also enable dirty tracking at boot, and just
>> clear the dirty bits before setting dirty tracking. For each of the newly
>> added IOMMU core APIs:
>>
>> iommu_cap::IOMMU_CAP_DIRTY: new device iommu_capable value when
>> probing for
>> capabilities of the device.
> 
> IOMMU_CAP_DIRTY_TRACKING is more readable.
> 
OK

>> @@ -671,6 +724,9 @@ struct iommu_fwspec {
>>  /* ATS is supported */
>>  #define IOMMU_FWSPEC_PCI_RC_ATS			(1 << 0)
>>
>> +/* Read but do not clear any dirty bits */
>> +#define IOMMU_DIRTY_NO_CLEAR			(1 << 0)
>> +
> 
> better move to the place where iommu_dirty_ops is defined.
> 
OK

> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
