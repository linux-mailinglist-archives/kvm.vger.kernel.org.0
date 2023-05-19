Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18A98709985
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 16:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbjESOWj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 10:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbjESOWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 10:22:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EB6187
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 07:22:35 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34JCiX0C008027;
        Fri, 19 May 2023 14:21:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=490U+Ch/2pDSeTSBt8VEjmBc9swruHqNtIkLbyuLKH4=;
 b=0zzZCDiNLZ3IwNnyQJ0MGYqrb01h1qfRwGpYEHMecEx9eZ0oBNFNWlKNNNrEcLI5lJdr
 RjGkv2YVy/NknzYHV1dMYh5hMd+//EmuLR2zCNQOzOXV5TGiIsSDWbFYYtdhwRj9T0+I
 F1wZq2SPZluq6EZuWhJ+Xi5lyVvCkHefeUO7WJDxPlk/IX+6mD9GmUHEw+dKS/y8Jkt/
 wsABBKTWq+uvio5If0gsgvRtEqD2R4C0GEfP5xraPTCbT8LuxocrqBPS83zMbJ5vHLwd
 GROfKXTV64sz/imBC4Gna57z+kfbVm3BR7MaeuULO3eR2m7FzH/MCRtvAcYw5hEmZMIH wA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qnkuxafuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 14:21:41 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34JCRKMR024982;
        Fri, 19 May 2023 14:21:40 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qj108565d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 14:21:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OJlX7fiQGFpSJac58KPoyqkaFfftE3CdXV5vc2yH5tEle2a1QLn70KthpYocKyO1rFOwDeOeLTAtdhMk7ehHTI5qAJqO1PAeeSN7RNtI52dfa0YhzA92N1lFkhEdussgjSuVmU+pCIbjCzoTb9xeBoeFuuGP/UwVSuLkADJLPlc6SnAVuOy7Zyr6mi9r3Zl5wbPD0mu5Hz9C9kSQyh7MAlAg016/Y5ZL6WhSnYIWl/cgpr5ZH8xT+A3w4hbzMvU1/WdU3M/Hc6Qxj2OLCWGzp2y60NQcALOABRl8Qf8qZwATsv+oew0VbC3wbE9Kkm0s4pzs4uNpo37uAXKlTMpGRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=490U+Ch/2pDSeTSBt8VEjmBc9swruHqNtIkLbyuLKH4=;
 b=VgGcAn/4XYWUGDpBAaXLUcYx5X/+yEnuQ93sfookQZZEtKOCrtJnHO0AMyohcRN/NPFnwZcQn/OzPmy0VCZiH+GTSBL9uN3sj+18K1xWLioJRdwear3rUJBDjSbZClzOdzKUvt7EaCmQZA6Ry62VA1YhwC9iffu60Eu/uktnYUcdMgrRLjRqWxNTSbdYbnQ5mh6G7LdzJNXNZCwo0gIJE3JJ8qxeGlbIfvuqu9mH2xa08o99Ci1PUnNaaufIMrzppFOs9/iHPYpKxCdWAMoMXC180Av/8xFHS67waIoYs+6FyZ1arFB7KHTfaEQd1wtxEEUzTINo2xJSdIIZNzlEeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=490U+Ch/2pDSeTSBt8VEjmBc9swruHqNtIkLbyuLKH4=;
 b=gb6RXK7fbten0zgiJbF9mcJlV8utaXdkSeLse6HisbobdnLqah4ijBVhwS7W/CEMbDxv48eF6U4264hJnQu8iuNENYphNb/ZFILYtkV9kuRcSinbyGOY6BXK9YGxzBdc/wtRgLyQ73PJIEdNi59503AQsB2U8t/nN+e6D/tGAoM=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM4PR10MB6840.namprd10.prod.outlook.com (2603:10b6:8:104::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 14:21:38 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b%3]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 14:21:38 +0000
Message-ID: <cf153fd9-235d-94c2-df65-d815b9aecf62@oracle.com>
Date:   Fri, 19 May 2023 15:21:29 +0100
Subject: Re: [PATCH RFCv2 09/24] iommufd: Add IOMMU_HWPT_SET_DIRTY
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
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
 <20230518204650.14541-10-joao.m.martins@oracle.com>
 <ZGd+aNMNyd9ZXF2L@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <ZGd+aNMNyd9ZXF2L@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0173.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::17) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|DM4PR10MB6840:EE_
X-MS-Office365-Filtering-Correlation-Id: a9778489-2e69-4a1d-0f01-08db58745b70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dZjXvIsjvcoQlCaPTSH3vNH+0veHGseEgVHiKYppB6zXvgxRa95+EiRsq5aMiuCaZKULzZ8H9RsnIGu5PRfPfWsFqy6c2XX87pCkSCr+QqM/k5rsk487ippJT1DcznMeulG4+0WWbsq/rEIYzyZLx5s4sHWi+CDcJN1d5xn4eFYMes7C60fEr3kHc9la2JpyA3tt4kpctFCbwgLzbNseOUh1L3sTxlynW1qGwZbe/km4nwB9LxvlRnFtf53PvWhfiMy+bSYepEfAkpENEwBE5M7SCQEnUmD2GCU5dRT5dEyaxPauBDwNfp7Q7pwp0UBKf9D//TZ4uPYyQUGMUc3XizN8SRn1UpgIPTt4wy525dlKbW1GQkklkihv8QeSQzIErYuyWP9WOIsH5DG5M4ZJsvpkCdZ9sufWUSO1FH71oIQUMPBBtq/Uy7+voRcMfjIlABUCfZCRrN/53BugvYuljgS3K/TZRD1vQcMxYWWweKEreb7kwKQzDvWcsBz0eHbsgeKiGgG/yOE0TnUHTxv8d/r5qWRJ2zUudtmlMzGt8vJmBwfzPXxjxvs2oWpN//dIDeM5dS6bktvxMlRfiGw2yrAtImeDHodaltELzEpT9qgvnzudF4LhJg4V8DHa5HYDL9F6h4aOKZgEsW6HaNXLqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(366004)(346002)(396003)(136003)(451199021)(66556008)(66946007)(6916009)(4326008)(66476007)(31686004)(54906003)(8936002)(8676002)(478600001)(316002)(6666004)(41300700001)(6486002)(2906002)(86362001)(31696002)(53546011)(6506007)(6512007)(26005)(38100700002)(83380400001)(2616005)(186003)(7416002)(36756003)(5660300002)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MG02THJoN2hIczM2L2k2WGJTdmFFYzR5c0RIS1dEZjcyMFMra205L09RN2ZB?=
 =?utf-8?B?dFI0SENnU3lUOEkxYlFhclJTLzhzZm5tUmhKY21uL2tkMk5peVZvbHl0SjZq?=
 =?utf-8?B?OCs1MGNxYkFOSUlvdFpvMW54djU5UEdoaGIrWWJoalNFWTcrYjRLOEhIL3hG?=
 =?utf-8?B?ZlRaWnhKNUlXdTBrMlByZHlTZjQ5akMwOUxDQk44cktLTFF1T0NsVDVQTHdo?=
 =?utf-8?B?U2xpUmtueEw1K0RWT0tVV0N2N09RV1phakRYeUkzU25hOUI1ZmVjRGNwQ3Zx?=
 =?utf-8?B?OWFHKytDQ3V4aDcyUTFCU0J0NzNueFFDckRjdFFOa0dkV2tCSm5CSEQxd09q?=
 =?utf-8?B?UzBRZm1FSTdzVjVYT3c2ZlpDVGtBQWtiNHp6bi9KZnFtVjRaN2N2cEJtUnVV?=
 =?utf-8?B?ZW9VWmd6a2RVcWFIbWVvVjc0bjQrVHJ2Z0U2WDcvZk9WaktNenI0TWZlcUJr?=
 =?utf-8?B?aU5TK1pvMXU3TGFJRGlQOURaN3JzNE9nRXpQcDhDYzBEWWJ6VVM0dGpuNUpN?=
 =?utf-8?B?dEF5clZvQk9uVGdYMFhwYldiSGFaSDliQ1dsV0ZQVnNHSHk3V09wazU1eHdG?=
 =?utf-8?B?UE0rVWczUmwwaHg3TExRbEpWclhrVTlxUmpSUkhoampISWZ6TldIbjVjbno3?=
 =?utf-8?B?c2U0UVgxMC85WUdBMzNzcUtHc3oyckxwVUFpZG9NT0Z5dGZiUUVxYWc2ZXlC?=
 =?utf-8?B?cXk5aDdzbnArQytZVmNwM3V5RzRLaWFHQ1gwdUhsSHZYUXZtVTZZVmFReGQy?=
 =?utf-8?B?dnhvL250TGpvZkZ4RFdMRkh6NzYvVW5SY3pvZjJTZTdLUGNlRTg1aGdzUDBH?=
 =?utf-8?B?cHBjRGVUN21CeFk5VFZlTVNSTTQzU0I0MU52ZVVaNkp3SjA4UGUxZWlvV2Js?=
 =?utf-8?B?b0U4cnB4ZkRaK1lTRWJIbDRQaXFLajFLRGZQcXVwTHpKZjNrcGhydlVGbEkr?=
 =?utf-8?B?MzI2Ni8wdUp2UWNWZjFXdEtkd0tUWlA3S3N4U2NOZXVUZFk5empReU1qWmNS?=
 =?utf-8?B?OTNQWHN2NG41U292Y2NXQ2UxRVdxSWVNQmE1VVhIOTdjRWtRSU8zaGZyVmJT?=
 =?utf-8?B?cjUzNUt4R2hKb3VzWHNaVWtNcjJ0OTVuaEpaZzc2MW94MXpTYldDT3hmTmJY?=
 =?utf-8?B?ZmRyVzZNanZnNjJ6NXBVWml4RjczS1ZVRGg4SC9QZDNkS25JMEVsMzFmYWtD?=
 =?utf-8?B?WUxBc21CMjZJY3U3djNHOTYvek54Yk1CTGtSUkN5N29LdkFIQ2dkNEVwTG92?=
 =?utf-8?B?NDlzQjZNQkMyZzFzdUg4RnR5V1lxQXZ1amt0NksyYU5tL0x4RU95RlZjanVD?=
 =?utf-8?B?V1RqazMwTjNoMVVVcWRyeWFVZkY0eXlpQ2U0QWFjWWg5OFU2ZUxIcUNNR2JM?=
 =?utf-8?B?TnVhRldiU0dqWjI3WWtxRStVN1RYNld0U3phcXh5RlUxQ3JUNjhZOFVwTS9X?=
 =?utf-8?B?c0UxcTl3QnN2NDVkWTh2U2h5UG80YXgwNkJ0TlBPK09IM2Q1TExmRi8yOUw0?=
 =?utf-8?B?TS9PRngwbG9FYU9pVFR1RVYvS05PbXByUkQ4V0g4azlWNjUyQlJkSTZSMTRk?=
 =?utf-8?B?VU1BZ2xDbFoyVVhnbnBlNHpXdUtZZTIwZnNLUDNXVmQxRzFrZlhpOHk3WTJu?=
 =?utf-8?B?dlNmdk9BZDNrUzZ3a1d1QjE3Zm05WmxOeXhIUjZzNXBKZ1RDT01VdkVKaHho?=
 =?utf-8?B?M294YjZpeCtVMzhaTmpXc0Z3WG1iNUpISTBCajU4WC92YnhKOTNjZSthMGM2?=
 =?utf-8?B?VktlN2RxRWVudVVNVER0MVRjZS9HVTRmcURPcTJnaVBUeXEzSUdCZTJQYjhw?=
 =?utf-8?B?QmxLYnpCQURlclNnajAydUk2Z1NRL00rK1hDbHBzMUtuTVcxdkdJUXRFdDl2?=
 =?utf-8?B?Y3dRdHRzZzdKUmc3UTRLVzFvV2djb1E4NWxST0hoKzdTcTVzTmh2U21lSHVt?=
 =?utf-8?B?VjlNdllJTGZvYjFhZ0locUZnbFJhaFgyWVE0dFl1YnlOV0ZJd3FwVXNnTko1?=
 =?utf-8?B?amFOM2I3OWpDaGR2RzEwcFpScVVFaVRIVUw0TGJZZk1iLzRqSWNja0ozWk5z?=
 =?utf-8?B?emtocmQ1TFpKbmtENjRKNXVvbHpIUkQreTdLUUxhQ2E3cDNpd0J0TTIzdCt5?=
 =?utf-8?B?Z0o3WG5UK3d0NVduekdIOHYxS1lZVHVaOE1IUGNSQWxuUFNIazRmb0dPY2Fn?=
 =?utf-8?B?b2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Y29iVktUc080NDNNenZSYk0rMzA0eld1WlNZRml5Y1pPcFBVZFg1N1VYT0NB?=
 =?utf-8?B?QWVleFZyM1NQdDdjaFBQVnA5bi9WbHN2NExuMVpUbzB4a0UxR1Mzdk5TY3Zn?=
 =?utf-8?B?aks0QXBjY3Zwd0pRMGtWd1I4VDdNQjRJbG5LdHRHdFpkeWRLNjVZdXJvU1ph?=
 =?utf-8?B?N2JUd1g4Y3dNOTBxU251VWxjZTZtOEtjRmVnRUEyZ2hzTU1WOU1kZWxWdTkw?=
 =?utf-8?B?UStwWGlhYW9Ub0pxRlhhdDkzSTR3M0oyWUNLeHdYeFZPV3F5cWpoNFhMNk9Z?=
 =?utf-8?B?ditYMjBqZkxnL2FxZm13dEFySDZnY1BJTk9xWnVJWmtCZWRUclMveGs0UFJr?=
 =?utf-8?B?MkNTS0hZUTJ2QklRUXhZY2JrUDV5TitWV0IwcUZ2Y3lpRkJHOTlYU2FkbzAr?=
 =?utf-8?B?Ykk4OStVQmtTRmxuZWh0bTIwVENkZm9hRjhTdWlsc28zTkg1QzVDd2RTZTJz?=
 =?utf-8?B?QUNOS0d4a3UzWTcvdWZPOVE2QkUvWlRXQ2U1bGVOM0lsSnlheVR2SFgveTZx?=
 =?utf-8?B?OXhiOTNkU0ZTVFpWQ2pyWWltNm82V0pOSmhTUENRaHYvRkhWMlVNSTBNT2Np?=
 =?utf-8?B?SDlSL05tVGlLQ3p3Ykk3MEVQVmNSOW9wdGhPL3Roclkrb0c2MlJqeFhlL1Jr?=
 =?utf-8?B?MGFWNGhhN0FCRDVpdXJiS3hUZnVZU0R4cW9NUEVUaDRUdnBKUUYxSmIvQVRW?=
 =?utf-8?B?Y1BjNHhpRVpZTGVVcUpqOWtyekFVckhOUzFqelF4VW1oL0pXYTN6QW1KNGFk?=
 =?utf-8?B?eGtEblhWUlNPUjJXTjdDK2k4NW1vdERvR3c4ZjlVZlN5a1B2bDNtbXVaTFE0?=
 =?utf-8?B?SGJWK2NERkdhK1I5WXcyeE1LaDhETHFhVTV2a0dpd01zMXVCVG16WG9WVWFL?=
 =?utf-8?B?M1prai9FbnZndmE3ZzRHa2NCTm5zS1F3Y240VkVMVTlzamVRM1d4RzBtN3VU?=
 =?utf-8?B?ZWU0QmNBV2toUzdRTmZtbGpMaDZQYlowcmt4YkVSK20zdU1NaDVrZllmQ09x?=
 =?utf-8?B?alBHT0MvUUljTXh5ZWlLUDFLVDB3cjgwSG9pU052TWxNZEJMZ1pRcXJWZ3Qv?=
 =?utf-8?B?OWlhQWxHMkhjV0F2R3JCbjFpTDFuRnZxUVErQXhPRjN2RjV0b0hUMHVrU1Yz?=
 =?utf-8?B?WUdPNE9pYmViblJxRTdtRGFHMWpXNU5NUnU3d093eTVLdWxnTE5QaHZKZ2hT?=
 =?utf-8?B?ZmZMbkU3V056ckozbXVvenkycUUzQ3p4YmRNSUs5M3p0bWM3bW1wbktudFYw?=
 =?utf-8?B?aVJuamQ5MWxtRFF6YUlJbmZZeUtuVW1XaldLU0hhRFYxV0RsN3RGNkVtdmVp?=
 =?utf-8?B?dWNYbmdSd0FTUFhFYWlianBPMmNhZ0x3ci9WZVpIdGM0UWxNYmlYZDlYYUpt?=
 =?utf-8?B?Z2xYcWNZV1J1YW5BbHpRdVFENVFyM2VXUlNrSG1rb1FBKzJIN1RjQlBzL1FD?=
 =?utf-8?B?S2MyRGoyNnAyRHlRWlNFWThQbitRRjdUcWxSU2hRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9778489-2e69-4a1d-0f01-08db58745b70
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 14:21:37.8797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D0K+bTDAk5oUhfjraM+fDUVnbIxF0Xy8v2l1n1bPLN1zWYBUP7p/bwQWDwS5DQ0umk20uc8EG6uSN3RVer/haEMj8NYdW9AboIfFXdirQHE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6840
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-19_10,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=536 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305190121
X-Proofpoint-ORIG-GUID: YDsIZxiuGQGIO7RnLUpVNKElDNQWFIYl
X-Proofpoint-GUID: YDsIZxiuGQGIO7RnLUpVNKElDNQWFIYl
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/05/2023 14:49, Jason Gunthorpe wrote:
> On Thu, May 18, 2023 at 09:46:35PM +0100, Joao Martins wrote:
>> +int iopt_set_dirty_tracking(struct io_pagetable *iopt,
>> +			    struct iommu_domain *domain, bool enable)
>> +{
>> +	const struct iommu_domain_ops *ops = domain->ops;
>> +	struct iommu_dirty_bitmap dirty;
>> +	struct iommu_iotlb_gather gather;
>> +	struct iopt_area *area;
>> +	int ret = 0;
>> +
>> +	if (!ops->set_dirty_tracking)
>> +		return -EOPNOTSUPP;
>> +
>> +	iommu_dirty_bitmap_init(&dirty, NULL, &gather);
>> +
>> +	down_write(&iopt->iova_rwsem);
>> +	for (area = iopt_area_iter_first(iopt, 0, ULONG_MAX);
>> +	     area && enable;
> 
> That's a goofy way to write this.. put this in a function and don't
> call it if enable is not set.
> 
I'll move this into a iopt_clear_dirty_data()

There's also another less positive aspect here on the implicit assumption I made
that a dirty::bitmap == NULL means we do not care about recording dirty bitmap.
Which is OK. But I use that field being NULL as means to ignore the iommu driver
status control to just clear the remnant dirty bits that could have been done
until we disable dirty tracking. I'm thinking in making this into a flags value,
but keeping internally only, I am not sure this should be exposed to userspace.

> Why is this down_write() ?
> 
> You can see that this locking already prevents racing dirty read with
> domain unmap.
> 
> This domain cannot be removed from the iopt eg through
> iopt_table_remove_domain() because this is holding the object
> reference on the hwpt
> 
> The area cannot be unmapped because this is holding the
> &iopt->iova_rwsem
> 
> There is no other way to call unmap..

down_read(&iopt->iova_rwsem) is more approprite;
iopt_read_and_clear_dirty_data() does so already.

But I should iterating over areas there too, which I wrongly not doing.

> You do have to check that area->pages != NULL though

OK
