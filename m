Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55033516F29
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 13:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384823AbiEBMBG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 08:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239965AbiEBMBD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 08:01:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4271B796
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 04:57:35 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2428tWwR018740;
        Mon, 2 May 2022 11:57:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=rY3o/xlyFOXTFd5uJuRmwlg6LoWCqwmI77dyHjGM1PY=;
 b=no32j41eWeUmIbWcYOP8FZpJ8d3UEzFtv4DOSX26sIgfp88Gev6O3b2EMRHnG8kg/go0
 0VqmfGP7iZABYRo6RQVZ7MK+DLJIUZ1mQKobNcxCKdVMGnNx+NfkfbOMmcxOqSxVials
 tcAPIaZfi5usVLCJQ7Qvub5mmDHHCKjcXnJY9kn8MiHUEI7fZVI7c5VWecz4FI7CrvDD
 p8prem9uuV2HRo3zmeP2+79sgxwuvltPpvV8Q5VJlHuEqLMgwx4htmZglPa9sj7+vD4f
 x0P26A6vIp1iCdhkzn8SrL4uabHiA1CQ6sTWUm9GSCvdlq2BoP3iAAljYSb9ZoChyBBO MA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frwnt2xu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 May 2022 11:57:14 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 242BuNSj003170;
        Mon, 2 May 2022 11:57:13 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj7xsu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 May 2022 11:57:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VygvmBMxSAaJRgf/01mszO69gnCiu2sBq3oOIDGS775W63A9NFz5F/6O2q7E+daRVDgLP0HRbUWYgwcGwi9dEejPaZVU1+lhKlx1jetCIbXuzJ+IZwU0oiNA1vbIfQF5TZWwlcX+KUpbkPv56qcymu/ZHhDqvYcaYTtOdlSsKTQBmS3gHAoudX68F8AgEJ3hfPzRECMZFyfCiB29fFUxm3OV9LsqRYTg3+4aiGq6QC5tcq9n8KdgVvqe97XbDMbEEbi38GvfiQAcZScTH5CZ7hAnlQdfqHxpRIZHK5TFRImHi34RQcvkIk+S0TKoZZ63nr6hY26rYL2IdFFEzg5wiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rY3o/xlyFOXTFd5uJuRmwlg6LoWCqwmI77dyHjGM1PY=;
 b=fWh/TxaVyL9sPTMnFRJSWUGKiFwDUGyVJPY+yQFAIbsrDa6Y1HiZ6BmFZWQGAvb2DKQndNFDVg73xUYOGdfmIrdidMnvHUL5rLVxG/S7E4D/rbqK6E9yc65/xE3+YTK+lHp9h9zD2LBDj42CUPoQvrz3IF473UnkpLmcfcfmjV7ZCA15ZvCt2zDbEsiY5aBfI1xJKkJ8YTQalaTPIMxcLlbkuH4O/NQfNwtWxSQIA15+pxHkpxyUFTElP+nrf91CfMWrGgP8OiZtI2Jsny6pta/x51eRIVam7Fid7kdAEb0yzML56aGCsFB8x45X9bhvHB4fv9oHziNlT9rs9eM4IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rY3o/xlyFOXTFd5uJuRmwlg6LoWCqwmI77dyHjGM1PY=;
 b=CXIZtcntEMf0zhpGsN24jRHp/huFUyBUXikCIPI1MP9+v/ZKdZ2JaZrqbNQBw2fIRq/u9stPKd8B7nS8eHq4vGfurzgGihuCQ8B10yFgmqLMJdG1pXRlT65Hyfcq3Qf1XSFNyr0ssFSBMcoI8hpCdk2EJpo5v5qDsYT+x2Sm1g4=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM6PR10MB2891.namprd10.prod.outlook.com (2603:10b6:5:61::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Mon, 2 May
 2022 11:57:11 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Mon, 2 May 2022
 11:57:11 +0000
Message-ID: <5febc7d2-fbe1-d734-09ba-0dcc17a401b8@oracle.com>
Date:   Mon, 2 May 2022 12:57:02 +0100
Subject: Re: [PATCH RFC 15/19] iommu/arm-smmu-v3: Add
 set_dirty_tracking_range() support
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
To:     Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-16-joao.m.martins@oracle.com>
 <BN9PR11MB5276AEDA199F2BC7F13035B98CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f37924f3-ee44-4579-e4e2-251bb0557bfc@oracle.com>
 <a0331f20-9cf4-708e-a30d-6198dadd1b23@arm.com>
 <e1c92dad-c672-51c6-5acc-1a50218347ff@oracle.com>
 <20220429122352.GU8364@nvidia.com>
 <bed35e91-3b47-f312-4555-428bb8a7bd89@oracle.com>
 <20220429161134.GB8364@nvidia.com>
 <e238dd28-2449-ec1e-ee32-08446c4383a9@oracle.com>
 <cab0cf66-5e9c-346e-6eb5-ea1f996fbab3@arm.com>
 <8b01b261-7385-8247-4d19-3ac2dd2306b1@oracle.com>
In-Reply-To: <8b01b261-7385-8247-4d19-3ac2dd2306b1@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0300.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::17) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 622d9329-855a-498d-eab6-08da2c32e3f0
X-MS-TrafficTypeDiagnostic: DM6PR10MB2891:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB289153D802A1BFEB9B5C7970BBC19@DM6PR10MB2891.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gy4cxtgZf9ErQnmGE6Qvwp5pjNq22pwEPW13bRie3mwfTUR7alGBYz23RCyJaH9e8vfbKaHaOc4RnmXRVuuNxMOQBf6+kQMqizbs82d+awjZ64d6NngTMD2upJvIMrjiWEn5yazoty7BFo2JohNiXeSYF5kSo5spe39begwUMLRV+WAjXe58UK3yqNQOTnx0xHtyeHrFYF3hK8wraPjy7DUEjg1Lhhr1LjWtMa7gPPZi3hUi9R7ykrpDVpCGOObHXeLVbVTkil6vUchY/vkT39wHH3PKupMNsCngcrOE0mw11+HqUY+XyPNmHBZSTASoRZRurm8Cu63X+XPylYcN9+EQXXuVsaW+08YKqyQXuRtx3rxxSoj47F0qVHmkRhRDu9ulJ7domjZd4dAqdUq9X5ZSXoLzUPuw9LRma1Nnfz2SoiY7g5knKdP/3UcaQU7yKSlrcpdDX17Zb0a+clJLqDEbEr+dErH14DATZeBpXRRtCBPs/Sg7fFZTRV2LwydRvnsAUdz8Ez0yGCc7VaDN1ToFKc08fJLHYvXEB2enYnNL7glEhiXQr1QU9r48IHkmkmhsYPz0tDiDhL60axbXgLMmLW+uSQfnuM4SISrD2DN/AP5S5s+aKi19zCycfhN0M/T0A9NB4cl92oc9X1U8/8eZMy/ArPTqgP4vwv5IzGuYi3tD657x+JuycvOmql5SkAQFb15GTXUCMwvjIRX1W2fMejE2VJOgKGqIXN2mFuI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(508600001)(2906002)(6512007)(83380400001)(6506007)(6666004)(38100700002)(7416002)(26005)(110136005)(8936002)(31686004)(54906003)(36756003)(2616005)(31696002)(53546011)(316002)(186003)(5660300002)(4326008)(66946007)(8676002)(66556008)(66476007)(86362001)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cVpJV2d6ZWkrSUdlNzhZU0tPS1J1dUtJU2ttUmxGWFdDQVlyb29rMVdjRmJr?=
 =?utf-8?B?aHhzaG1tekhzclJ4ekRiS1RyNlIwdExiVnMzbDEzZzFQeGwyTjVMRGpiVzBP?=
 =?utf-8?B?RU1zVTZKUHh4c29uTXBJazVTT0l3ZTByamRRNUZMaHFxVThHQWxTRkJnVWYz?=
 =?utf-8?B?NFdqOGlTdCswS2tyaVlZcVlJWi9UNSs2dmlST0VzVTB6TUcvVG1HaGozK2Qy?=
 =?utf-8?B?Ynd3ZGVYYTFMakhSNWhITElrM2E0bmQwb0sxbSt5Rk1ObEZFTUJYb1dGeS9w?=
 =?utf-8?B?VCtGUURaanJaUW9KdmMram5tZlBrcjdiemlZTXZWRlBmUGl1YWszUnZvSWdI?=
 =?utf-8?B?bzhhV0MwZE9BazN2aXdXRDlHMnA0L0xvYVdQWmtuK1hEd3YzVis3NUlPa3VL?=
 =?utf-8?B?THBXRXFIUmVSS1l1UEw0M21CWnYxQVN0UTRHeWwwNWZVWTFBZ3NZeFl3VXF6?=
 =?utf-8?B?SjZuVnFFNGdnZkprMk5mdkNVR1RPdDVIM1ZJMWJaNEhNbDRRQUROZlIyWWtX?=
 =?utf-8?B?MmtYVUVFWXcrOTREQ0xLR1VjV01CdVozaW9TSzdvYTQ3dDU1NkF2aVBVOGd1?=
 =?utf-8?B?dURuY3N2cXgwN3pyZ0tweG9OMCt3YUJyclJxcVg5bXpIajhVa21IMlgwQUNB?=
 =?utf-8?B?WXJ2RzhUVW95dVdncjRwdWxFN0t4dUU2Qlk1WThuTllJYTAyUUtIWm94Qitt?=
 =?utf-8?B?V3lFTzFyQ3FZanBGeFlMZkw4ait6dHpIODhJRmM4YnBFTkR0RG12bmpDWk13?=
 =?utf-8?B?bjJDODg2RW40VGVST1ZWOHBRZG5RWTVOQjR0MEJINEZiam5qTmdHT3FFcFYy?=
 =?utf-8?B?ZjljazBVQnhieG4xL3hKVHg1SXMwdW5nUFg1VUlSU1lRYnY5MGhYT29WZFpu?=
 =?utf-8?B?M2gwMW4xdDVqK2Q5c2pFbXRzT0tkdHBxeUczZ2hHbzlqK1Z6QzBQSERROEZp?=
 =?utf-8?B?a0hybk5jRWp0N3lmV2ZpMWRZd0xhdmtyb0NMbzAvTURPc1R6QmtOaXNheUFn?=
 =?utf-8?B?cXRnUEdpWHArZHJNeEJqK1luaUhaam9WdlpmY3hOYWp6QUVvUWNrd3gybWRO?=
 =?utf-8?B?a2RUS1hzM0lxQVR2azdNbEs3Tm81SncxYk9udmh1NkFhSkFRdkdsTS9NMVZU?=
 =?utf-8?B?N0ZuTG9uOVNmd3BUekIrNVBLSjZ3MFgxMnBZbTF6RzVkRm5xR0RWeW9FSm1T?=
 =?utf-8?B?VmlQbG5Yd3RocTRQNlJhNFBYM0VybnFsUVRrWmU2NVBDalpsbU5jSEp4NlRk?=
 =?utf-8?B?SGljSWR3YkJqSms0bDdQOG52eCtxM2lGcmdrSGNmeVN1YzA3bDlyZXRFVFlZ?=
 =?utf-8?B?REVxVXI3SmloeFBaWWVlbGJCTkxNK3R4dllNSTVhSUZTZ3l5WTNPQVZrMTVV?=
 =?utf-8?B?VVlrVWpuWWI5UkxwOStqc0hFMXcvMmNUNVhzbXNNVEhQWU1zMmhJcDdZMGdN?=
 =?utf-8?B?S0ZXcUNqU3oyRlk5Zi9aVmMyeGRSRXlaZWJXRE13Z2lWTHVlcU4xN2JKOG9O?=
 =?utf-8?B?NzRZWUZkRFlUOFhjenMydjVHb0Z6ZW9GMm5KRnd2emhnQjE3RFJpMDZHV0hY?=
 =?utf-8?B?cUhlSlZQZi9lL0Y0RHNYcWhkZi9NRkQ4dERmdTZzZ08rVTVWT09iL1N0V2Ns?=
 =?utf-8?B?dGtNaDJNL0Z3Y3lVaGpOL0hBK3lWMmFleCtVb2NENFNnV2xXUEN6dkFrM3lZ?=
 =?utf-8?B?bzhhMEZIOFM5N3AwMW1CMUJpMDdMeGRwT0dBT1YvZVlsbzlHYjFnL3RmcEgy?=
 =?utf-8?B?S1AyUTRTNS8yVG5ZWFpBbXgwdzVHdGk2UDlncFVTeTRDcDZSLzNtOWpPbXgz?=
 =?utf-8?B?S1QxTzN3MExQdERzVUhmcDQzRWVhMTROS003cmpsK3pRYk5KSGFWMDJ1UndT?=
 =?utf-8?B?dTFMeENBYXFpS0xPODhpV25aaVljVlREejhiTW53Y3hwR1JJRVhCaUduc1BG?=
 =?utf-8?B?NXBVK3E4dmZUWjQyaUIzMHFwT20zajNIVHpLYXpVQU52SStBU21WWmxsSUxY?=
 =?utf-8?B?QkhLSVhlczRSeWYxSTlnMDNGWmVLMm05bGRVQVRMVFZUWmtPcW11M3JqNGJL?=
 =?utf-8?B?eS92NTIvV2UwR0RSdVorc25SL1FVY3B1LzFHdjhRTGZNMW4wRXlxYVpBSTFP?=
 =?utf-8?B?K2x1T1dEaWdzMmRXYThxMlpaVXBoQWR4dTIyTjJMMllWeW9OWCtiQ0NBOHhq?=
 =?utf-8?B?YnYzWmpLY3BMN3psNFZ1bGpZczdCRWhPQkV4cmUxdW50c0haTldKeis3QUQ0?=
 =?utf-8?B?bGY3MmJ1cVA0c3ZtbW5CbkZGWlFBdzN5NEU3SDdBeDdPNWFacnZ3LzBKOUNZ?=
 =?utf-8?B?b2I1OW9hSU9DUzFDL1RpKzZoa2VVUm1GdVFOVmVTUUhJUmJmTnlkUDMzeUg4?=
 =?utf-8?Q?2lRKfBOXMWFzm7rE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 622d9329-855a-498d-eab6-08da2c32e3f0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 11:57:11.3205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HqoAjOp5mkSghrs/zOi4pJY+IOb3L0MsxuLdmD0ePabyYdoCKRCuq5MGzMPXRK0yuVZm3sL6xrjPUlTjKvxKcEbgVSM5ion+tsLeBzKMYGY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2891
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-02_03:2022-05-02,2022-05-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 mlxlogscore=557 mlxscore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205020093
X-Proofpoint-ORIG-GUID: eIQ06VjTqPsVrbwzw1uldgSkWg96iQid
X-Proofpoint-GUID: eIQ06VjTqPsVrbwzw1uldgSkWg96iQid
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[my mua made the message a tad crooked with the quotations]

On 5/2/22 12:52, Joao Martins wrote:
> On 4/29/22 20:20, Robin Murphy wrote:
>> On 2022-04-29 17:40, Joao Martins wrote:
>>> On 4/29/22 17:11, Jason Gunthorpe wrote:
>>>> On Fri, Apr 29, 2022 at 03:45:23PM +0100, Joao Martins wrote:
>>>>> On 4/29/22 13:23, Jason Gunthorpe wrote:
>>>>>> On Fri, Apr 29, 2022 at 01:06:06PM +0100, Joao Martins wrote:
>>>>>>
>>>>>>>> TBH I'd be inclined to just enable DBM unconditionally in
>>>>>>>> arm_smmu_domain_finalise() if the SMMU supports it. Trying to toggle it
>>>>>>>> dynamically (especially on a live domain) seems more trouble that it's
>>>>>>>> worth.
>>>>>>>
>>>>>>> Hmmm, but then it would strip userland/VMM from any sort of control (contrary
>>>>>>> to what we can do on the CPU/KVM side). e.g. the first time you do
>>>>>>> GET_DIRTY_IOVA it would return all dirtied IOVAs since the beginning
>>>>>>> of guest time, as opposed to those only after you enabled dirty-tracking.
>>>>>>
>>>>>> It just means that on SMMU the start tracking op clears all the dirty
>>>>>> bits.
>>>>>>
>>>>> Hmm, OK. But aren't really picking a poison here? On ARM it's the difference
>>>>> from switching the setting the DBM bit and put the IOPTE as writeable-clean (which
>>>>> is clearing another bit) versus read-and-clear-when-dirty-track-start which means
>>>>> we need to re-walk the pagetables to clear one bit.
>>>>
>>>> Yes, I don't think a iopte walk is avoidable?
>>>>
>>> Correct -- exactly why I am still more learning towards enable DBM bit only at start
>>> versus enabling DBM at domain-creation while clearing dirty at start.
>>
>> I'd say it's largely down to whether you want the bother of 
>> communicating a dynamic behaviour change into io-pgtable. The big 
>> advantage of having it just use DBM all the time is that you don't have 
>> to do that, and the "start tracking" operation is then nothing more than 
>> a normal "read and clear" operation but ignoring the read result.
>>
>> At this point I'd much rather opt for simplicity, and leave the fancier 
>> stuff to revisit later if and when somebody does demonstrate a 
>> significant overhead from using DBM when not strictly needed.
> OK -- I did get the code simplicity part[*]. Albeit my concern is that last
> point: if there's anything fundamentally affecting DMA performance then
> any SMMU user would see it even if they don't care at all about DBM (i.e. regular
> baremetal/non-vm iommu usage).
> 

I can switch the SMMUv3 one to the always-enabled DBM bit.

> [*] It was how I had this initially PoC-ed. And really all IOMMU drivers dirty tracking
> could be simplified to be always-enabled, and start/stop is essentially flushing/clearing
> dirties. Albeit I like that this is only really used (by hardware) when needed and any
> other DMA user isn't affected.
