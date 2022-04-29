Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653C25147FB
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 13:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358250AbiD2LYI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 07:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358249AbiD2LYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 07:24:00 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A1619C2B
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 04:20:40 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TBDbd1015475;
        Fri, 29 Apr 2022 11:20:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=TIegjJXNv2NElwW/iiMQ4LWfCyQoKifs6i/R8UZew10=;
 b=HT+IjqUac+zSvRmRODNAnR/XQ4Qd+qSAZkatQcQg0j5s9w8zXtoPaBodHxr8sxMRU+ym
 RUZ+TCsLnlJVgL5lTskBwc4qIjSjMB3KxDvcmhcadNviH4hE/prwGxmsMutlYbD112o+
 P1GsxKHoAdTxBnDhNmRXNQkLnKBB65qTbiRK/IQrRJlBAo98ENfN1o2KGzn+OIV4PTsY
 VGu/EIoDhqH/OvFE/AD5ekOt+BKc1NZ0Z0dIy+N6mpPUGK4H7Ej449h7XyDVpxpX2itk
 VijbmI+WIdltFLSoail75l/8j+6NKX/mS75Xw3agAEb5X0DdlnPW0A+kCb7qKZDewQbQ CQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9axe55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 11:20:18 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23TBAfbs022147;
        Fri, 29 Apr 2022 11:20:16 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5yq2tw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 11:20:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jm+PIHo7GoGXWWHFG8PmLT0BNmG1Qb8OBZNZKjswWU0ty/hXW7/ENRdUM9GYc5DngL/GNt13tMmv6EGO3kqRjq7HBqe3iBink696wVwlWb/hfUiRA3M9S4NJqlDWsODP31xIsT2KFdWmOnjbizrJhPRNrHHZdl3myDG4n4TA3JrmuWc5JpRI5BAKlsumoks9M0vZFNGBsB74QBpC1NinCZaxPaUP6BRbXUPfOvdpACURbi9R+u4Ft0G0FMSiNE/ifEgERzqY9VZAowTIztg4uhqmIXC37S8ecGB+z85mjwyd9/l+iRjYMWJWuiwQ/zXYbbKqS24ajwj+x1/Oow5J9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TIegjJXNv2NElwW/iiMQ4LWfCyQoKifs6i/R8UZew10=;
 b=Lpq2A/L0sr+JJJrai5E4arJvUGsyGv0Cy/gRVnhozHBTnqGh1Mk/T03W94/iiEAdoyLNpkCR6raECZBfdhg0LcPNwMV+JY+TTjRD++kWddpeXOJR61oPN26ZQ7PY8gNb6z21vN0aJpAmdqvhZA3v/Xfq0EyZErSPE3nM8eb66pUPteGKfoAUrb/NYdzkP3KfluGikWr/kijDqhVtBLVGNTPNSJ6p4l8Nq7/w0tH06zfKsyw17YFsOgnLg8AhkirXTxU/09A6eSFKR0LDqNkYpttEwGzN9OJcIITyihi0CCoryRB4G1p4Z3LBmBnt1Mb6nBCpxzotZ95iA26+vry5Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TIegjJXNv2NElwW/iiMQ4LWfCyQoKifs6i/R8UZew10=;
 b=QrRQg7h9yF3DXRRYYxdsBrrrKjBQCEta7mrObCH1A1W3h7rlqA17hfPD9MVjk/c54Mz4e2HdM42GUfdVe28EfSvF402fMITTUnOGsp4IPLs7uv79oXd6FXHjL4H2NoNlE9WsP19zwqinIFfBOdgClxVLq9rVTp+NpQcKfiEbCDw=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM5PR10MB1658.namprd10.prod.outlook.com (2603:10b6:4:4::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Fri, 29 Apr 2022 11:20:14 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 11:20:14 +0000
Message-ID: <31bcc393-8dc0-685e-4e25-c2009ed491e1@oracle.com>
Date:   Fri, 29 Apr 2022 12:20:07 +0100
Subject: Re: [PATCH RFC 18/19] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-19-joao.m.martins@oracle.com>
 <BN9PR11MB52765037DF7BDE1EA9A6558A8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <BN9PR11MB52765037DF7BDE1EA9A6558A8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0012.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::17) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1535539-8367-43fe-a6ee-08da29d23b50
X-MS-TrafficTypeDiagnostic: DM5PR10MB1658:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB16580CD211D1C2C652F17D56BBFC9@DM5PR10MB1658.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uww4o8EncilOW+lXnE1ncBhu3bxWLVLxtfBbCXNsvoJ2nltFTnVenkQqtfH6vI64VPc8iJ1Lw3ptkQBIril1/lbuJE/TXhj8ExcXfjRbnZ7OTMrWZvx15E6RXZGtuT+VTbO9aS0UrOl04n475ADGNoDiZ4tmcOfHJpjdNzJeolLioFkXevIEeHs6ydW07eGlNOnO0AZrJxF1Evg13XNHmVHJzlghNfGFFg8gAPvX0e/1KxpbNtifdNZPTI/IJgCoEo3Y3OLdeqeKze7/ThR1vqjjpdNN8IsBttwkhIB9NiO8ANhaZe4QVlXJ50+Kzy7ly5fgARSRq2jMWdkqHjNIGLHO2Y4rvavjaws9rR6RffC5Zbv4qq+iWWF3H9P4fPa1P52HHurV02Zp0QoADIf2hLtp5jjO+5cPFCwbNUEAtUUPfcsw2qhLPSQoYUrCy68S6SuoEXIUnJ6K3WjGCDdx0u4Cjgx3avTOfu92FSmGuqXjCwQ9dr+OTdnB/E/Q0L7zwGsINLcrH1C5Nv+43VigjaiUOpeSAnfLC2qCISQ3gsz1dlLMzVFsypzebtG0l2/48UYjDc2avV6NxS16G6XTNH6YMzAyh7cy6iYqVKJqhEYddgKDx2LX3oNgJgZJus8uX5gcpknnd7hGQ6LH9u8PnwcvL6EvpHPchaf3HjboD3mXyoUFrEKKtJkpp1wcH5nAB3yY8hNUrGWoxt1+CE6CHyTFPR97cUzo0jLoBYUNHmo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(26005)(6666004)(6506007)(6512007)(36756003)(2906002)(66556008)(66946007)(66476007)(5660300002)(2616005)(53546011)(31686004)(83380400001)(6916009)(54906003)(6486002)(508600001)(31696002)(8676002)(316002)(86362001)(38100700002)(7416002)(8936002)(4326008)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnI0d05GeWJkK3MrbmRTYWxuUGx5eE00N2xsQkd3RlpxSlNMdTB0cStuc0c0?=
 =?utf-8?B?cGJqaWEvZTluQ2dTV2NWT2U2TmNOcVBncG5HZ2NKZEtqcjZtTkhOeGlYS1FU?=
 =?utf-8?B?Y2J5eVFGdldwVkhaK21NSlhFNzFyanpHOFQxN1VNYW1ieTAyQVQrcDBtbjl0?=
 =?utf-8?B?T2ZvVVdDZklweEZDVEpnemdSVXVkWkRsVVZudWtMZmErNms3Tm1zZEpIdkpv?=
 =?utf-8?B?dm1LRXBuVHA1Qi81bklYd252Q1VPWnlYNUhoSlhaQTlRME9BZ0g3MEZ2TjNv?=
 =?utf-8?B?dFpCNCtOVHpqYTdBVjBHZ2RWc0k3R1g1Ymk2VUxSMkdPSllDMEwvTnYxc3hB?=
 =?utf-8?B?alBLUGtseXJUQmozbnpZbGFJNEhBbU1zZGNHZ2JkTWMrUEhzSjYxeWtJbmRn?=
 =?utf-8?B?K3dmMWRlYy9wc2pvdFZkc2w5aUM0RHFXSkNhZlA2cVdhUmFLRjNKT3Y5SkZH?=
 =?utf-8?B?VUs0emFIcVJvY01yV0R0dlBLU29tdXdWWVV2SzhsYVc2dGFUY0R2bFA0UHBq?=
 =?utf-8?B?S0J3SmNOWUhrem9ZYkVhYzhMT3NWQTF0MXNBajlvTjlZUStjL2xHdmsxSDB3?=
 =?utf-8?B?ME82bFhBVDUrTXM5bENyaDZ0a0I1TVZKck9iU3lFUG9XZkRpdjNPQzJySGwr?=
 =?utf-8?B?M0ZMY1hwUVpib2JpMitTaFRycHZaRXROQUszODhybTFRbzNJZzhHdG95REdz?=
 =?utf-8?B?Rm9EckZnMVZJbGpBUWo4c3A5U3dTWXJZbTZQdjJyTFNGdWJvTXlPMU9CM3lZ?=
 =?utf-8?B?NU5Sd2VCc0tkSkhPdlo0enJZYUZxZ2tyeDFjNXdwMktHNkJrUjg5TkpjRDdV?=
 =?utf-8?B?c095dXRmZG8xVGNlWnJ3V2dzT2NYTmZheFFqUEV0TDBtaW9WUzExMjNranJW?=
 =?utf-8?B?MVpqSVJ0aTlvcE5BK3ZGSSsvWDY1M2x0aGFGUDBUSUxuTnNUY1hIb2ZKdnNZ?=
 =?utf-8?B?c3czekdiZENuOUR3L3YvRmxnbHp5ZU84a1ovbkFTVXFIcllSUTBxTlRNVW5F?=
 =?utf-8?B?S0p1YzBJZURxVyszZE8xU25wQytrdTRBUEMvc1hGaXovbm8zVElkbnE0TUZU?=
 =?utf-8?B?KzUvcytURzBjOGFpQWtjS1Z1NkZIQlY1VWdORjBFdUN2anFKa0s0WUZUakk3?=
 =?utf-8?B?YWxYV0ZPQmMrWUNVQ1B1WHlzTVBNMlB0QlBuRmNGRU1OK2IwNjNkVjlwOTF2?=
 =?utf-8?B?VTU4L0R1ZFh5Ry9VSVcyYzBkcVRwNDM1OStUMEovUWZ3VWRSZWJHdkVpbUMw?=
 =?utf-8?B?WHNRV3JNWFI3cERHeW9PaE1iOHVJWVRYM0MxWWExVnN3SE11dGRwcm9PK0JI?=
 =?utf-8?B?K3FoQTRBeEZic0ZWZWMzTCt6TEN2S3BETmlISDc1OGhRTDZoVTFLOWxock42?=
 =?utf-8?B?T0lXUmpKUTlIQmV3NUFVb2FwdyszbmtvTGkzbGVqSXZkS3hneE1SUGIwTHRv?=
 =?utf-8?B?V3QvZUJzYVNNdzBVZWNOR3hhVDFTYm8yVmNVeUx4emMzVlBOR2N2OUdnNkg5?=
 =?utf-8?B?a0F2L0hzdEpHdUVRK1dmMGtPUXFxUlRXNUJGcGFJMExIVTBOa0gvaWJNb1E0?=
 =?utf-8?B?bXVsYjgwc0ZSM2tSdGJHQnhWM1RSd2l1Lzc4SThISGQ3K0dDOExieXBkSTZt?=
 =?utf-8?B?VXNBb3E4c0w3VTJ0ZU9neGlKVFBzaFUxdFZvVmpkbjFsU3Z5MFFpajlXNElH?=
 =?utf-8?B?cjE3bDZpc09hUVNra0ZObzFLV2RJS2JCQzhUdTVUV1NuRDVlcEdQbjJiSUpI?=
 =?utf-8?B?OWNIMlhEY2dyWUFzOFNpSHQzQ1FFMTc3ZDdBVGVEb2JoV3U5Y1EyR25hMURs?=
 =?utf-8?B?ZHlxSjZwY3hFWWF2YnJ1aXBmNmlZdUdPZzRjM1dYR0YvQytXZlhyLzA4RE9x?=
 =?utf-8?B?Y1ZQUkRaT2IvYTRRNEhmUDhmcFp1aU5MNFRJTnZ2WEwyb2pxMk1Xanc2L01j?=
 =?utf-8?B?emNjTWVMWlZYWnoyQUJ4SUZJYW05MXViQWRvWEJBMnRINVZpa25vbjBTd01x?=
 =?utf-8?B?Vkp6SHh1UElBWWNaTTI4RW1pSDlremtucDYwZi9HQWUyZVpIdVlLK1FzQVdU?=
 =?utf-8?B?N0JkR3psT3BUaWRUTGdZd3c0YnhaZWM2MjRRLy8zN3Jyc1RiaHlnVzVDSGlJ?=
 =?utf-8?B?UWtZMzRKRWNlcTFtVDZKaC92OEFqYVNSUGJ1Tk5McS9CT0lNTDJ2NnF6R2hC?=
 =?utf-8?B?Sk1HQ3pUVCtCSDFUSDRiTFQ1L3lwTExabEkrQU9ZWDI0WUNjNXNGV0RoSFVz?=
 =?utf-8?B?c3RxTW9qQnVuYkdqeWY3S0FJWmxkL3IxR2ZaZ0c2OW90aWlvTHhqWGdHcGk0?=
 =?utf-8?B?MEV2RlhWS2k4RWtTU3VZc3BJejJvd3UxV3hsOFRQSE9rR0NLdGl4K0dSVlRF?=
 =?utf-8?Q?/Q7htWmmbaFPVXLQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1535539-8367-43fe-a6ee-08da29d23b50
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 11:20:14.2920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yck1kCf+ywehXnWIiaiuGGXDcTtUjzOMEoNkGYhMuzll9ZFeMdpl5S0DXN0mZCAK1OxH2hyawhzzGOZKXwQPc3r345f6gIv269DaCdHFil4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1658
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-29_04:2022-04-28,2022-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204290065
X-Proofpoint-ORIG-GUID: 6mCC1aUMbCGln2ZCnqzHNCPsUxNJyX94
X-Proofpoint-GUID: 6mCC1aUMbCGln2ZCnqzHNCPsUxNJyX94
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 10:03, Tian, Kevin wrote:
>> From: Joao Martins <joao.m.martins@oracle.com>
>> Sent: Friday, April 29, 2022 5:10 AM
>>
>> IOMMU advertises Access/Dirty bits if the extended capability
>> DMAR register reports it (ECAP, mnemonic ECAP.SSADS). The first
>> stage table, though, has not bit for advertising, unless referenced via
> 
> first-stage is compatible to CPU page table thus a/d bit support is
> implied. 

Ah! That clarifies something which the manual wasn't quite so clear about :)
I mean I understood what you just said from reading the manual but was
not was /really 100% sure/

> But for dirty tracking I'm I'm fine with only supporting it
> with second-stage as first-stage will be used only for guest in the
> nesting case (though in concept first-stage could also be used for
> IOVA when nesting is disabled there is no plan to do so on Intel
> platforms).
> 
Cool.

>> a scalable-mode PASID Entry. Relevant Intel IOMMU SDM ref for first stage
>> table "3.6.2 Accessed, Extended Accessed, and Dirty Flags" and second
>> stage table "3.7.2 Accessed and Dirty Flags".
>>
>> To enable it scalable-mode for the second-stage table is required,
>> solimit the use of dirty-bit to scalable-mode and discarding the
>> first stage configured DMAR domains. To use SSADS, we set a bit in
> 
> above is inaccurate. dirty bit is only supported in scalable mode so
> there is no limit per se.
> 
OK.

>> the scalable-mode PASID Table entry, by setting bit 9 (SSADE). When
> 
> "To use SSADS, we set bit 9 (SSADE) in the scalable-mode PASID table
> entry"
> 
/me nods

>> doing so, flush all iommu caches. Relevant SDM refs:
>>
>> "3.7.2 Accessed and Dirty Flags"
>> "6.5.3.3 Guidance to Software for Invalidations,
>>  Table 23. Guidance to Software for Invalidations"
>>
>> Dirty bit on the PTE is located in the same location (bit 9). The IOTLB
> 
> I'm not sure what information 'same location' here tries to convey...
> 

The PASID table *and* the dirty bit are both on bit 9.
(On AMD for example it's on different bits)

That's what 'location' meant, not the actual storage of those bits of course :)

>> caches some attributes when SSADE is enabled and dirty-ness information,
> 
> be direct that the dirty bit is cached in IOTLB thus any change of that
> bit requires flushing IOTLB
> 
OK, will make it clearer.

>> so we also need to flush IOTLB to make sure IOMMU attempts to set the
>> dirty bit again. Relevant manuals over the hardware translation is
>> chapter 6 with some special mention to:
>>
>> "6.2.3.1 Scalable-Mode PASID-Table Entry Programming Considerations"
>> "6.2.4 IOTLB"
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>> Shouldn't probably be as aggresive as to flush all; needs
>> checking with hardware (and invalidations guidance) as to understand
>> what exactly needs flush.
> 
> yes, definitely not required to flush all. You can follow table 23
> for software guidance for invalidations.
> 
/me nods

>> ---
>>  drivers/iommu/intel/iommu.c | 109
>> ++++++++++++++++++++++++++++++++++++
>>  drivers/iommu/intel/pasid.c |  76 +++++++++++++++++++++++++
>>  drivers/iommu/intel/pasid.h |   7 +++
>>  include/linux/intel-iommu.h |  14 +++++
>>  4 files changed, 206 insertions(+)
>>
>> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
>> index ce33f85c72ab..92af43f27241 100644
>> --- a/drivers/iommu/intel/iommu.c
>> +++ b/drivers/iommu/intel/iommu.c
>> @@ -5089,6 +5089,113 @@ static void intel_iommu_iotlb_sync_map(struct
>> iommu_domain *domain,
>>  	}
>>  }
>>
>> +static int intel_iommu_set_dirty_tracking(struct iommu_domain *domain,
>> +					  bool enable)
>> +{
>> +	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
>> +	struct device_domain_info *info;
>> +	unsigned long flags;
>> +	int ret = -EINVAL;
>> +
>> +	spin_lock_irqsave(&device_domain_lock, flags);
>> +	if (list_empty(&dmar_domain->devices)) {
>> +		spin_unlock_irqrestore(&device_domain_lock, flags);
>> +		return ret;
>> +	}
> 
> or return success here and just don't set any dirty bitmap in
> read_and_clear_dirty()?
> 
Yeap.

> btw I think every iommu driver needs to record the tracking status
> so later if a device which doesn't claim dirty tracking support is
> attached to a domain which already has dirty_tracking enabled
> then the attach request should be rejected. once the capability
> uAPI is introduced.
> 
Good point.

>> +
>> +	list_for_each_entry(info, &dmar_domain->devices, link) {
>> +		if (!info->dev || (info->domain != dmar_domain))
>> +			continue;
> 
> why would there be a device linked under a dmar_domain but its
> internal domain pointer doesn't point to that dmar_domain?
> 
I think I got a little confused when using this list with something else.
Let me fix that.

>> +
>> +		/* Dirty tracking is second-stage level SM only */
>> +		if ((info->domain && domain_use_first_level(info->domain))
>> ||
>> +		    !ecap_slads(info->iommu->ecap) ||
>> +		    !sm_supported(info->iommu) || !intel_iommu_sm) {
> 
> sm_supported() already covers the check on intel_iommu_sm.
> 
/me nods, removed it.

>> +			ret = -EOPNOTSUPP;
>> +			continue;
>> +		}
>> +
>> +		ret = intel_pasid_setup_dirty_tracking(info->iommu, info-
>>> domain,
>> +						     info->dev,
>> PASID_RID2PASID,
>> +						     enable);
>> +		if (ret)
>> +			break;
>> +	}
>> +	spin_unlock_irqrestore(&device_domain_lock, flags);
>> +
>> +	/*
>> +	 * We need to flush context TLB and IOTLB with any cached
>> translations
>> +	 * to force the incoming DMA requests for have its IOTLB entries
>> tagged
>> +	 * with A/D bits
>> +	 */
>> +	intel_flush_iotlb_all(domain);
>> +	return ret;
>> +}
>> +
>> +static int intel_iommu_get_dirty_tracking(struct iommu_domain *domain)
>> +{
>> +	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
>> +	struct device_domain_info *info;
>> +	unsigned long flags;
>> +	int ret = 0;
>> +
>> +	spin_lock_irqsave(&device_domain_lock, flags);
>> +	list_for_each_entry(info, &dmar_domain->devices, link) {
>> +		if (!info->dev || (info->domain != dmar_domain))
>> +			continue;
>> +
>> +		/* Dirty tracking is second-stage level SM only */
>> +		if ((info->domain && domain_use_first_level(info->domain))
>> ||
>> +		    !ecap_slads(info->iommu->ecap) ||
>> +		    !sm_supported(info->iommu) || !intel_iommu_sm) {
>> +			ret = -EOPNOTSUPP;
>> +			continue;
>> +		}
>> +
>> +		if (!intel_pasid_dirty_tracking_enabled(info->iommu, info-
>>> domain,
>> +						 info->dev, PASID_RID2PASID))
>> {
>> +			ret = -EINVAL;
>> +			break;
>> +		}
>> +	}
>> +	spin_unlock_irqrestore(&device_domain_lock, flags);
>> +
>> +	return ret;
>> +}
> 
> All above can be translated to a single status bit in dmar_domain.
> 
Yes.

I wrestled a bit over making this a domains_op, which would then tie in
into a tracking bit in the iommu domain (or driver representation of it).
Which is why you see a get_dirty_tracking() helper here and in amd IOMMU counterpart.
But I figured I would tie in into the capability part.

>> +
>> +static int intel_iommu_read_and_clear_dirty(struct iommu_domain
>> *domain,
>> +					    unsigned long iova, size_t size,
>> +					    struct iommu_dirty_bitmap *dirty)
>> +{
>> +	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
>> +	unsigned long end = iova + size - 1;
>> +	unsigned long pgsize;
>> +	int ret;
>> +
>> +	ret = intel_iommu_get_dirty_tracking(domain);
>> +	if (ret)
>> +		return ret;
>> +
>> +	do {
>> +		struct dma_pte *pte;
>> +		int lvl = 0;
>> +
>> +		pte = pfn_to_dma_pte(dmar_domain, iova >>
>> VTD_PAGE_SHIFT, &lvl);
> 
> it's probably fine as the starting point but moving forward this could
> be further optimized so there is no need to walk from L4->L3->L2->L1
> for every pte.
> 

Yes. This is actually part of my TODO on Performance (in the cover letter).

Both AMD and Intel could use its own dedicated lookup.
