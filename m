Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA2C07CC82E
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 17:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344215AbjJQPzX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 11:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344027AbjJQPzV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 11:55:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419C595
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 08:55:20 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39HFsjri024729;
        Tue, 17 Oct 2023 15:54:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Bf77684C8SrvLqyPKouyVbnJxQ+2K423UNd5iMcbugc=;
 b=rPsOIGal5e8sEATD95gjW1Avw1OknOnudc5GeBpdIFZ3zL7wMRXDdlIsNGrQzOaaBePe
 2ZaAvZArchWVDqVM69U2DsimzBfeZFTRpYJafKE4PKFBgGN2erFwY9aFMViL/T522lTI
 r6T3A455Dr44VF1IjlP73DcGQPG/T2kxXSq8Nx2u3Y+Qrh2yb1qM7XoH+aOGIs4MYyZn
 vPsYMf09ma/jViKiNPkJmr429dvNY92WNQGZiqKcYdNsJe+XSb16ZY3UBBixSgVtaxz3
 WYIaGePWgib8yvbm9Bo+HDdfkJnH7aD/rh3VgAELT8kiHbdoDCCGBlP2OFUu6pGLEw5d xg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk3jnjh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 15:54:55 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39HEqCGK027137;
        Tue, 17 Oct 2023 15:54:54 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg5420h4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 15:54:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CL5FSl+82WBAyIo0x9lHdl7LfjR7ffah890P90kggf4DhYxAYalRwUrLxO75HoJwa/YMeIWRQ1MPKaNNnWHadSTH0n6OjoWMWjBDwV1aqroVbFh1mZv+vNXe1eFevo4n9Edafm7DQxsTFwcTJtfz8u6XXUyNfHfY891lIa2iM4NdXgY+/dIxRxOZxvwJanEbk6eG/WQ+PlYU5naeHSXTXQwzAwR6pbk5F5Y+64LtyxsIA/7pQXsbVFzbBjpXfVS+PEil1P05+DDwQGiIj4TObXGcSYNy9qvinP28URsM/wiPC8UjVsKZwPpuRZBgZlU7xG7NE4h4Ywg3/cJKsCVESg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bf77684C8SrvLqyPKouyVbnJxQ+2K423UNd5iMcbugc=;
 b=YNOMWTQe9MdI1bqYfIkRr8B5gmbgB5PTvKZpx9YhtjZUr8g/IutEapbc0mzSQjgemjsXZtz101ha3so+OtLfY3zQyn7ZyFv/WhrsSms/l+CgZ4TWLqWNpvj508SxD+WcUQf2OkZvQyCXULopZZ/xgILz+88qdys8nwFYHYdhMipaFeR+IIc/1803FsOQiqxTs1P4WpRp1QJVzoNMxA845aUzZ92tfHzc9Lff3B/DCr13J3fNhX2Y39zWuXjg+F/Ovaz/hEAzWBTHAtXauA9lOGnGbf5/NvcD7EIwagbtw8+qncsr6huEENk4hdx9hVEQ5Mfz0rbau2CaaItlQYvPGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bf77684C8SrvLqyPKouyVbnJxQ+2K423UNd5iMcbugc=;
 b=PBt9AXt2YauaZx3AKQgru0EZlet23Y4ycoqsm60UGedIL1jUpuXWwStmmSm3b73anLW6DjYoU68c6A2U+hiajiR0Dj981uaQwE9gjVjPalWhkwEpEQ2NzKHZlmHBZMpo+C6J7vpm22b69bn84G9kL95LoqJuVRHxIDqv466TbXc=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM4PR10MB6863.namprd10.prod.outlook.com (2603:10b6:8:104::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Tue, 17 Oct
 2023 15:54:52 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.038; Tue, 17 Oct 2023
 15:54:52 +0000
Message-ID: <2f697aae-c68d-42a2-8564-658436d111da@oracle.com>
Date:   Tue, 17 Oct 2023 16:54:45 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/19] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Baolu Lu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-20-joao.m.martins@oracle.com>
 <d8553024-b880-42db-9f1f-8d2d3591469c@linux.intel.com>
 <83f9e278-8249-4f10-8542-031260d43c4c@oracle.com>
 <10bb7484-baaf-4d32-b40d-790f56267489@oracle.com>
 <a83cb9a7-88de-41af-8ef0-1e739eab12c2@linux.intel.com>
 <e797b35b-6a17-4114-a886-95e6402ad03c@oracle.com>
 <20231017131003.GZ3952@nvidia.com>
 <832449ab-1704-43a0-828c-5b6eba2b84af@oracle.com>
 <20231017153130.GE3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231017153130.GE3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO0P265CA0015.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:355::6) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|DM4PR10MB6863:EE_
X-MS-Office365-Filtering-Correlation-Id: e867d52c-c39a-4dd5-eb03-08dbcf296677
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bdjig9oZ+BQbvWkg139LbOWZHnz0LX9UE0C7miFAzir4PtY/PSQRYYRCL9FWKEsDSAjy4tzkT3WxIQKuCccthwZWFYowxBzJLABbDC2KKzaoN+lxcfqMVi3ET7866oimbqBU9YVUmFrpa7YyY1Y6xD0kQAxMkQoNLA1tSXyMJeOJz10M3kAVeuT+MMkAXISYWJcuAJgBg+K2pbqbccVMtIt4amGiptClsxS138VwMUw15MLQ4aXdplVgvhv83LoJ1f3T0euzg9IBdFmzE9ecj1b+aJCVf73tm0W+trZWPepOvJ13iYeJcV/tWw8cw9tCy8qo3IgqUK7imfGwWDxE+UgzEPA0GN1Kgi7zP/TpEIgTMmH2i14kTgbsMeIURvcW7xBRAFqgadv7BzXXqOd2ElblJqcrQ9KQYI/OPHyNaRKWQNVYciWSW78JKtuW/UeOJarnU5KCa+bu3F6RhAbkxvRH/vm6z+rGDwxB9JYBk5596jNDHkL6lui+TQFgZgUuxVq16qlkGTP6b7eLs11RtuVeBovnrTPPF0NBS1ql8r7GwHb6C5VfMb2MHDWsVQYtgEEn2wGra6zujtGgq7orQG8+3CfWF4FicP6Z5Zjt4WKVobPlocNNr1U4TU1pWQZhOJQd/Hrf0PxB5xLsUE06CnZJ+dpZ1grNcvPl8p3Udkk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(396003)(346002)(376002)(39860400002)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(31686004)(53546011)(6506007)(83380400001)(26005)(38100700002)(2616005)(66899024)(6512007)(86362001)(31696002)(2906002)(4326008)(5660300002)(8676002)(6666004)(6486002)(36756003)(66946007)(54906003)(8936002)(41300700001)(6916009)(316002)(66556008)(66476007)(7416002)(478600001)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWJXMFE0dVdVSHZoR2hETCtVc2dqY2JxaVZDOEZ0aklxdGhJRkc5ek9jNzAw?=
 =?utf-8?B?RFU5VVVnZlh4RjFDVjJ4eVRTU2djSk16emI0RTJ1Wk84NnlHTDdLbGhIODZE?=
 =?utf-8?B?S0JCTFN0blpnSDc0NDM2ZHowMStKRXJiazFPbmlBcUtrMGM3QkhQalNVd1o2?=
 =?utf-8?B?SFdBb0ZVR0RZVGtNY3l4clAzSVZnOURNVUloNWdNMStFeU5rR1RlNmZrNGJR?=
 =?utf-8?B?QmRVbUlta3FlTDdXVlM3cnN3bDh2Zy9iQlF0cGF5RnJKL3pEWHBXSDlJLzB0?=
 =?utf-8?B?T21VSWhNSXcyVWMzclM3bk5iU0xENVhZMGpUaGJBWGs5T1pLVFpFM1RBYWEy?=
 =?utf-8?B?SS9pL1ZualBtRiswMzVsTWc2OFp3K0tVQ29MMVBjWXFORUkzcG9mTnUvSmIw?=
 =?utf-8?B?M2JoSHpmOTJYYS9iT1l6N0lOYm1CdmtGWXF5dFNwTzdhSEVBaEMxcFU1Q0Ft?=
 =?utf-8?B?ZlBkcCtraWpNWHFTdTRTYi9RNDlac0ZTQy9hYnBCclg1Rkk4Qk5IaE5KaTdo?=
 =?utf-8?B?UHBFcUs1ejQzOUc4WWExS05CdGJ6NTR5d0lldTU4dytlZ3pyZXdFK3pXa1pL?=
 =?utf-8?B?SWZuVTlwR29sZXZoUURkSlpSYmszejdxdTZaanNHWG12eFVoekZoUk9EYlU2?=
 =?utf-8?B?dmkydEMwbExNU1VDV2Y0TnpqOXpxOWdQUE1kUXdjN1RWWFMzZnQ1N1I1VThF?=
 =?utf-8?B?TnBFNFhJMGhleTdHWkV5R2dGK2EybDlPUUEwNlE1aTRLcE5XdnFqcllvY20r?=
 =?utf-8?B?WWVqbjdYOTdNLzcyelRuREY1dkl2dDNsZitsVzVvTlFIL2NuR3ZFNXRhTGNL?=
 =?utf-8?B?Q1doelZ5Njh3M3BhYXphZFNZN1Y2bEt2dXh6dy80cUlhMVNPSkJ4Wm04Ri9W?=
 =?utf-8?B?bUVKZ1BDMjdWZks0OFZLNi9zbGZGN0VKL1ErM0laeCtwbWZsdEdDQyswWDJV?=
 =?utf-8?B?bnJVdXNJUm14ZDVxM00vUnZBcjVRemcrZTZCUWRtRG5xU1AvYkpRNVdGSmJa?=
 =?utf-8?B?WmFUdHhzQU94eE9SOGZPWCtKbGtqT2lYczZOS1ZsWFFEanZDK0M3dEplQzNi?=
 =?utf-8?B?R2h3amtxUWtUTFZrT3ZlLzB3enlxMm9tbzVqN0gwczBOblcrVHpLSkFBOFFM?=
 =?utf-8?B?Z2Z5eDkrSnRocHI1L0ZuTXowM1dTeDJsQzdWOUd6Y3ZReFB1R0Rmakc3UjVP?=
 =?utf-8?B?aXBmdTBmSTJiZ2kyS2RxektLTjhoaU1IL3ErN0d2VnlDZVlTcmttN3hmeTdD?=
 =?utf-8?B?SC9qRm4yVnhDVEtWbUljeW5sT2g5WlJpVFUxUkZCMG1SNXYyTkZNbFA1WUxT?=
 =?utf-8?B?cTkvUmRKWklZREwyakdMNURDWWtqVlRKbzAvNVcyTzZFOTgyU2toeEZvRHA5?=
 =?utf-8?B?cm56WXF6V3VRRC9wenV5SVhjMC9HYWlDNHptV2ZPa0NFRUpZeS9KV05UczYz?=
 =?utf-8?B?L1Z3c2poTlVuL09qMm5EUEJGQTlYaHR1NjBVYnBDcWQyRTFMVW4zWGtLc0pX?=
 =?utf-8?B?M3hjK0JWczV5QytwQmdwbW8walB3N2w4RHdocVFMVjRYWDRjVldJTHlONlFw?=
 =?utf-8?B?d1JXUnd2TTVYdXZtbEpyZGNsQTJKVGV0N09GUmY3MElEaXc0SXBxTGN3WlJE?=
 =?utf-8?B?bXYvT0Y0dnlGemtKcEZzaDVMNUloNG1PS2JySEFqbVU2eHFxdjAxRmZXYkpQ?=
 =?utf-8?B?RmJ2VXZuQnZZMDdOZU1vMkJ5T2NUcmtFc2l1RzZhcjEwUk9qUUlNVHJFSlZp?=
 =?utf-8?B?RmxKSWhKU1Q3RHNXZlFTQktsZkpoa0tod2JnYlkxU3JzM0ltcUxHTkRxNFgz?=
 =?utf-8?B?N0RJQjRqSkdtaVB4TGhFcEtURXlTeWhZcXpBV2RlZld2VlhSa2x2ZTg2b2RI?=
 =?utf-8?B?NFZrMWpjMDd4TmNHU1ZaNFpRbWtaNDRybG5xQ0ZLSTRFaTJxNm5nd29FVTc5?=
 =?utf-8?B?Y3Qxa21JUUtqOEhMM2F0TTF5blczNWQ3bU81alRCVFBsYnpIaEVQYVFXaTEz?=
 =?utf-8?B?cTMxc0xuSllrZGh3ZTh0d2xPYXFsb1ZnbmIwMEo3NFZRRWd2KytrbVgyWm50?=
 =?utf-8?B?TFJXM1RER21MSk9SQlBFL3ZEKytUbHpzbENnR3NvMWl3ZENneWF3amRoYzI4?=
 =?utf-8?B?Ti9ZTURWcFBCOHZZc3RTTk1CSThZU2Jpc2FJYU9EUXphcTZRZ2o0amZSclVl?=
 =?utf-8?B?cXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?cFNyWkpBWnRabThNQVBlY3c1eXp2TDM5WDUxTnM4KzY1emN6RFBmWXBvd2Ev?=
 =?utf-8?B?TCtPRDNMb2lqTFM1ZXBFaG1DSXZRd3hrTzh1L0xRUUQxNjRpSjhaRjBvNlR1?=
 =?utf-8?B?OThUeFFMZ3N1OGVTc3ZPWFlnNUExUVE3YTNCOG1idmVYNzh6TDM0TVkySnhx?=
 =?utf-8?B?em1HNWdRUDkvNlNJZXVkZ0Y1MmNJUVdxTXZMVmNhT2xmQnFBWkFIb3ZuSjY3?=
 =?utf-8?B?UDNSSXM4K05mTG82ek9pSjJydUNlaG5rQ3ZHallrQnBRMVZZNTVzaUtlQzkx?=
 =?utf-8?B?ZjRBYzBLbjBFUnphN01WREU5blgyVGM0WHpFeVp2cnd3YVBXaVdJdzNCK3gy?=
 =?utf-8?B?VTBHSHJudDVNV2Q0TERHSGtnVThzd1FkaDhnRC9laDl6UU02NXBlZUk0VWZv?=
 =?utf-8?B?K1cvQm9KL2ZyV3BaU3doYWRUMzJlZFZlSHhqQ1dmKzVJQ2ZaVXJJd3hiVHJu?=
 =?utf-8?B?dU5nckpQWXBsaEtXNmRtcGM5MUxXQTZZdzVUd1J1T29SSlo5RW1WcC9hd0xO?=
 =?utf-8?B?dldHN3N0Q2lqWGcwcEVXQUlib2U4Z2RVeWI2SU80WWNJbzZjdDBzSXJUdXdD?=
 =?utf-8?B?WFRXYlRxeThyK1ZBUGd5bEQ3enpuNjBkcXhJRjBFelF1K1VYQXFWK0hGbGpC?=
 =?utf-8?B?a2xkYlhja21hckJoL2hDc3dBZS8vRWViVVR0KytFQTR4VFVRa2NhWDVaaWF6?=
 =?utf-8?B?R1ZCdlg5SzhrTGgxbWhMMVU0QUgxRDhNZkZ5b0duTkU5S2ZTWEtiZm1BSG5E?=
 =?utf-8?B?UkJ5SDZWNmVDbVVUZkMyT21yQmh0NWNrZXNWY2lmbVVwbDNYMXVRbEQ2RVFp?=
 =?utf-8?B?SWJaQmZaNktUR2x6WHJGdHhTMzJRRTZCQTVUSjRNN1lHSjI0bC9xRGsvOG4r?=
 =?utf-8?B?ekxPeThKR3R4UDE4ZjBWMmRGVHpnVEtyS2RtY1NmZFdCY3ZzbGovcEVVekFr?=
 =?utf-8?B?QUwwc3FaQytuSys5a2tybnYyTy9hUzNMV2pjNGhKZlFKUUJZN3lNRzZGcHFq?=
 =?utf-8?B?OTNGcngwUFJ0UkYwcGo4LytQVTcvZnlYbGxOckpsTVpMZmw3R1dYSG9mYkdZ?=
 =?utf-8?B?R2dqLyttMmlncS9DNFlFZEpUUE8zdWpjenZBVmpBMWh6VEtiLy9NMkh0ZmJL?=
 =?utf-8?B?YTRqNjlxUlM1NXFnZUY4cVNWaWxaYWJ3UUtncWw0dmw5eFRRNnBDQ0JvdUVX?=
 =?utf-8?B?cE9Ib2NIbERIZm41N0xiSjUyN0pnNk1BTXdxcHQzWW5lMnZpWDZSN2FieHJV?=
 =?utf-8?B?aW5uR0xycU40SlB1eWhmVzBvV3FFV2NrNUtLYW9CU3hCTzBIcUl5VktlN2J0?=
 =?utf-8?B?Z25vbHRqN2l4bmswNmRjUi9ub0NKc25UekVpeTNENHRrS2ZSZkZmZGZjUVJM?=
 =?utf-8?B?SzQrTlUxYUxXRVdCLzh3Q0R4NEVqWUVTUkhPZWRlVU55bGZTZlhDL0lGWTV4?=
 =?utf-8?Q?NUEZXAI+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e867d52c-c39a-4dd5-eb03-08dbcf296677
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 15:54:52.4809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 51wi9pVRCig7dAZ1EP24JR9ASPh+VDI0l8p1ICZCps9KvFA92hSXMMUXH17HX2w848FFKPHZZkPsresRdld94SdW3UmTKvtaBr6E6PBJBO8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6863
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-17_03,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170134
X-Proofpoint-GUID: ZTJrCiKwt1uublNbjPuQWUkT11Mr4l2L
X-Proofpoint-ORIG-GUID: ZTJrCiKwt1uublNbjPuQWUkT11Mr4l2L
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 17/10/2023 16:31, Jason Gunthorpe wrote:
> On Tue, Oct 17, 2023 at 03:11:46PM +0100, Joao Martins wrote:
>> On 17/10/2023 14:10, Jason Gunthorpe wrote:
>>> On Tue, Oct 17, 2023 at 12:22:34PM +0100, Joao Martins wrote:
>>>> On 17/10/2023 03:08, Baolu Lu wrote:
>>>>> On 10/17/23 12:00 AM, Joao Martins wrote:
>>>>>>>> The iommu_dirty_bitmap is defined in iommu core. The iommu driver has no
>>>>>>>> need to understand it and check its member anyway.
>>>>>>>>
>>>>>>> (...) The iommu driver has no need to understand it. iommu_dirty_bitmap_record()
>>>>>>> already makes those checks in case there's no iova_bitmap to set bits to.
>>>>>>>
>>>>>> This is all true but the reason I am checking iommu_dirty_bitmap::bitmap is to
>>>>>> essentially not record anything in the iova bitmap and just clear the dirty bits
>>>>>> from the IOPTEs, all when dirty tracking is technically disabled. This is done
>>>>>> internally only when starting dirty tracking, and thus to ensure that we cleanup
>>>>>> all dirty bits before we enable dirty tracking to have a consistent snapshot as
>>>>>> opposed to inheriting dirties from the past.
>>>>>
>>>>> It's okay since it serves a functional purpose. Can you please add some
>>>>> comments around the code to explain the rationale.
>>>>>
>>>>
>>>> I added this comment below:
>>>>
>>>> +       /*
>>>> +        * IOMMUFD core calls into a dirty tracking disabled domain without an
>>>> +        * IOVA bitmap set in order to clean dirty bits in all PTEs that might
>>>> +        * have occured when we stopped dirty tracking. This ensures that we
>>>> +        * never inherit dirtied bits from a previous cycle.
>>>> +        */
>>>>
>>>> Also fixed an issue where I could theoretically clear the bit with
>>>> IOMMU_NO_CLEAR. Essentially passed the read_and_clear_dirty flags and let
>>>> dma_sl_pte_test_and_clear_dirty() to test and test-and-clear, similar to AMD:
>>>
>>> How does all this work, does this leak into the uapi? 
>>
>> UAPI is only ever expected to collect/clear dirty bits while dirty tracking is
>> enabled. And it requires valid bitmaps before it gets to the IOMMU driver.
>>
>> The above where I pass no dirty::bitmap (but with an iotlb_gather) is internal
>> usage only. Open to alternatives if this is prone to audit errors e.g. 1) via
>> the iommu_dirty_bitmap structure, where I add one field which if true then
>> iommufd core is able to call into iommu driver on a "clear IOPTE" manner or 2)
>> via the ::flags ... the thing is that ::flags values is UAPI, so it feels weird
>> to use these flags for internal purposes.
> 
> I think NULL to mean clear but not record is OK, it doesn't matter too
> much but ideally this would be sort of hidden in the iova APIs..

And it is hidden? unless you mean by hidden that there's explicit IOVA APIs that
do this?

Currently, iopt_clear_dirty_data() does this 'internal-only' usage of
iommu_read_and_clear() and does this stuff.
