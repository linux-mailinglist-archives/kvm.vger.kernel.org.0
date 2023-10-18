Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31487CDC3B
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 14:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjJRMsx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 08:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbjJRMsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 08:48:52 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA259A3
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 05:48:50 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39IBJJfk000358;
        Wed, 18 Oct 2023 12:48:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=B8R3z37H0C1FvihOjQ1mBuUhLBDUdoPXWB0VL9lKDMI=;
 b=T0XEHW+ammuOHkTSyDa2PwXtI51V+g97dc6t92uhuix9VwwExUtwqENXAh/dTVTfTd9U
 hFJwjhQ5FRkjTBPxwl3SgfoLpiGQEsZZ8vkbQqT1JGTl6+vUS8UER2QWaKOzEKHK5Ihz
 sGNKfPePm0/vWYU+fNVkXq5PtqQo4RvAfiHNTHoIcDOGytaSJXX5mqbhyuLi0aaubMN6
 /7A9tn8usYCLzh43WmKAVM33UGaa+EtiCjtXd3Y9aq6zFfg/NA6dqJwvpVIjAnTx4df8
 GDvPfViCLUOGtmmWYXH/Zokkl5KtZ0I6/HYRm5bPFJ3hfXYS+0wqZ6x/I9SIBRFzEvWs DA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk3jqf6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 12:48:15 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39IBbOj2027313;
        Wed, 18 Oct 2023 12:48:15 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg558eut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 12:48:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TWW/1JhHOnmW4kGWPCwi0/nYwmM1UuaKAE5QmTfUhuraVXG+vTQxjDxo4pWlwqpqCp4LGhU1UqTKGyZlM7YxzcSvPCJkFzajz+DTcUd8+HjNAeacpsL9V2le1kTiqlHyymZf+XMaMIB7cS8atgFCseSH8XKfTz1x1y6uNRpnHNGaZvrK+NKnBIUYQcbQGXeE6OK6VM7LPoGe7DLI5+qAbXWqRCpuNi+RFqYNjWVciw+vKONCqdKVy+ChfaH68Uo0rRh17wtYEO8vtXBvGGzN8hmkvUJ000DJlfKGKHYDoGpf48fvD0wH5talUH1wW3BsR/bKduJ9zqLDE7gMQhstkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B8R3z37H0C1FvihOjQ1mBuUhLBDUdoPXWB0VL9lKDMI=;
 b=mX4rdQZLUVD/3gZS9pCts84jqDc2Ri8L7w40b2s/LMcV0BK4dLjwfS+FpLu+JV41nrpES/kC/40OPZ5QXQn4ryF2Cv+S6UQah3futVzflBoAWjNjG1gLktn8qGENepVzq3YxxFsRo394WngEqdxCcj5ihKywaNf2LLjMyyY68eJZb0hidUOJMRB9kT2ZBLw7KyLHshdFnIdk+k76tVzWF9WwWPbx8SExODpJ3qTZ7Jrv77qlo35uBO5LJsIoaNh+dhZBG4SimgfRhrHrPKY0zQHkyEPlC5YWEHX4UuXX2LYyp8Hy91GEIUt1mhBsW+17/iYYRcxyS27KfieS9ieY+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B8R3z37H0C1FvihOjQ1mBuUhLBDUdoPXWB0VL9lKDMI=;
 b=zGaafWtkvkPiXQrPSpIUcsaNp7COvagI8XED0O0sjOakUj68mE1qEYTT/M9Tyg45pW9pG2RRHf0rAfM5o1a2DDRGzr4gg6RoGZAGjnDbBBo+44+wzyPgA0BxhaqlfpYkRqWx4yVp1Ig4SB5W33WnhsIjZ/iJGP6zjU4oDPeuekM=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DS0PR10MB7125.namprd10.prod.outlook.com (2603:10b6:8:f0::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.21; Wed, 18 Oct 2023 12:48:10 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.022; Wed, 18 Oct 2023
 12:48:10 +0000
Message-ID: <c8cde19b-60e0-4750-8bdb-8a97be26468e@oracle.com>
Date:   Wed, 18 Oct 2023 13:48:04 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/19] vfio: Move iova_bitmap into iommu core
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, kvm@vger.kernel.org
References: <77579409-c318-4bba-8503-637f4653c220@oracle.com>
 <20231013144116.32c2c101.alex.williamson@redhat.com>
 <57e8b3ed-4831-40ff-a938-ee266da629c2@oracle.com>
 <20231013155134.6180386e.alex.williamson@redhat.com>
 <20231014000220.GK3952@nvidia.com>
 <1d5b592e-bcb2-4553-b6d8-5043b52a37fa@oracle.com>
 <20231016163457.GV3952@nvidia.com>
 <8a13a2e5-9bc1-4aeb-ad39-657ee95d5a21@oracle.com>
 <20231016180556.GW3952@nvidia.com>
 <5ecbeadb-2b95-4832-989d-fddef9718dbb@oracle.com>
 <20231018120339.GR3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231018120339.GR3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0023.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::33) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|DS0PR10MB7125:EE_
X-MS-Office365-Filtering-Correlation-Id: bc9cff56-66c5-45a4-c963-08dbcfd87b98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dNRmCSXVntu0qRiTrLpGa+F1zX6WWR3pdEODqj7HP/rPc0OP91OboqLBL8KoFMfrPft7zLBgXQ9bFzuGGdfMpjjn6n00pNOetOiroaUpmF44A3a1ecTBunnlUtLGa/k1oOmMP1/bcF5P6epKGM0MFBbftFx9h7uJO8qqjOI1773vYcZnOc5nshVOe650/Rx6/AVz5aphZVErQaVnWKIqZbWpdmIf2YTbDmFODVcByW/xdX1E+KN88WMbT3P7K3viNDWofRPdg3RgYyO7kBBbFRU+OYh1M5Q9Ckjo8J9/XLsznV2zzFADkOWtob0xYsspyFyRoC+uOuJeJYyN2JYMG+VuqnKKrMgiDda4LhZ14J15NwdlzRFc68vE9uEJbDfvJnDIC33IRnWtJz0OwmY6inkRTwRk6nZKrZLYEV7RXTCkes/9Hh/7xvHRfbognNsR37gKsqiWrBADiqokL3BRUcpXiFmiqDdDPHUPxkmgQ4QfR023l+kxMAvCKnWIkg10U8Ls5+DuNm+RYjkAZCUdYkd3zYM78rAhBBGkFzHExtpai4e26igFCdQoiTfFREpsxKe7ZHCjMHnsDHEAe5s4ox1Pd0D1AH4tm+CTxlStbtjalzhLjUiim0j+UOnmtU/yHWUW/0OwlxIT2JhyanDwPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(346002)(366004)(39860400002)(136003)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(7416002)(6512007)(31686004)(6506007)(2906002)(4326008)(8676002)(8936002)(6666004)(41300700001)(5660300002)(66476007)(66946007)(54906003)(66556008)(6916009)(316002)(6486002)(478600001)(53546011)(26005)(38100700002)(2616005)(36756003)(31696002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2d6V2xxZExldFZGSFVWSVVSanZEWDlsS2dndWhzdU1JQkl3SlBueXJwNXBH?=
 =?utf-8?B?c29TRnEvK294M2tiNWhSVUIyZU1HbmVhODB6a0dQcEozemltUExKdFdSYnBY?=
 =?utf-8?B?MzlhYTVRdjRzNTc2YXl5VklyK3ArR3NHQmJoTDdTOG5jejhEZE5xdnZlT3Ny?=
 =?utf-8?B?TmI0SFo1MzVuZTFJWlVEbzVTV3RiRWNNaEJBVTVwUHNCVEx2R0lwb1NnVTNr?=
 =?utf-8?B?eHpRQ2ROQ1JyNVB1QkJZVGgzZ203VHIxZ1lPZmorcFo2dDVHS1c1QkFxOXN2?=
 =?utf-8?B?MmpjWlpaNG41RzhNVE9OaFpxMis0eEV5RkZlY0ppZnpQL0N4Y0ltdFdjaVlv?=
 =?utf-8?B?ZC9vU1JCYWp2Zzh1SklCdWdYVkZrN2g4U25BRXlOSnlZR1Q5clFKbFV0TDBN?=
 =?utf-8?B?ZkZaR0NWNFpRdDhOUjlKK3lGTHNZTFBTMEFmK2VGVC95SHBoeHlxUkRNdlJ4?=
 =?utf-8?B?bWhRa2JzRVdaRDJNc2dyTDFJRy9GQVN2VGxTY3JRODJKYnFhM3ZGMHV6T1d4?=
 =?utf-8?B?ejY2bDlYLy9DYytUek5nZGZicmp3cVNkeEM3SERSNjlvQm5kcVhIUWFCNG9H?=
 =?utf-8?B?dDJ1SEFYYzhKa3VvRGRyLzlDbzRSbTFvRHJLQ1FCS0grMnF2N01oUkpBeGFS?=
 =?utf-8?B?WGQyazFlZmVKenlUQTgrRUQrVGhSaEV5TzFXSnZ6STdDTnFpTkVabDFJL0tN?=
 =?utf-8?B?Tit5UEppSFVjZ2l6RnQ2alFUSktXRVpnamh5Tk16b3F4MGR5WFZmN2tiN3BS?=
 =?utf-8?B?aWFtQ2YvOS9ObTFkQy9TSHVKSlE0VEQvd2s0aDdYNVdtMGV6N2U3YVZ0WWlX?=
 =?utf-8?B?OHY0dGFTWGJraDJadHErSHhISXZsVW9BUnB2VUhUZ3UrQld4bXo4TnRXWFh3?=
 =?utf-8?B?cFBScHNDZjM5bGYyK2w2VkQ5cmdkNTR6Zjd6Z1F5YlNieUpiWFRxU3h5SVdJ?=
 =?utf-8?B?UHNKN1BjUGo4b0NxV0ZSc2doY2taNXFWRkp4bUFLa2xIdjVWZ0lRbzdqQnMz?=
 =?utf-8?B?NkxkVkZjUjhPOHFMZlNtQzdaaDR4aitaUFNnaTFpS3JkcG9YbitNOFEzWlJX?=
 =?utf-8?B?dnJMTlBrRjhrU0tWS0tZV041dnpLQ0tJYlF5MUFwdkRuWEtEdHpPOEFnMnk5?=
 =?utf-8?B?T0YwYUFEaXlzWG5QVjJBMzh4UUZPTGVyLzFmL0VtYmpkemZ6Q2VyeVU5WlYz?=
 =?utf-8?B?NE01aGdOdHNRN0g2QnNheURXV3oxNzVqeFhOc3BKLytrWmZ4MlJ3YjJ1ZVZs?=
 =?utf-8?B?azBCQ1NnamNsaXdUdmdFMm1xTW9SamF3S0lzSXhtS1F5VE53OGVJZXhHNW1x?=
 =?utf-8?B?a0lXWTFjMGozNXh4Rm8rS1E1bC9uZFFxbDZuZE1GWnNoWUpOZjlVNjl1NXhG?=
 =?utf-8?B?eXh1YVhjYllUd1d0bVk2YXM3T2FsZlRPeUlFUC9nMnRwejFCQmNEbDRLM1Qx?=
 =?utf-8?B?UWlWU0JwN2RDSFpvTnpXM2FIc21oM2ZwTWQySnY0MUhmOFZvOGFpbTFsS01P?=
 =?utf-8?B?SWtSeklnRlFaKzZ0OFN2ZjU5aEZWMDV2RDNnNEhxcitma25ya3ZuMnZtU3Ru?=
 =?utf-8?B?aGhwSkRIT3MxQXpobXMrYzdNbE9wdWlCRHd3SlpBcVc1RTVQTUNRZEIzLzIr?=
 =?utf-8?B?SVdMSVEzTXNNSWk1bWJrM0czb2lPZ1F3aFhFeTJMajBwc2phb3NOcUNIU1d0?=
 =?utf-8?B?cE90d0dTMU5oVzhWYjhDaDV2WVFlVkRTQjBrT3ZpSWNNVlFLVzB3dHdHR1J1?=
 =?utf-8?B?a0JueHZqRk1raExuOVNPcnI3UzR0SWhRUEl1WnVXb00zTlBXa01nUVBlcXMr?=
 =?utf-8?B?cStpUHdLTEZsWXJwRjVQcWdaRjhTSStzem5NL09qb2hiczVrYTI3WS92OEFN?=
 =?utf-8?B?T2dOMjh5R3dKU1lyK2R3amVYVWFZeFFSRTM5VmxQKzVqSDFaaEpWWk5sUmRU?=
 =?utf-8?B?K2x4Q0NLYzU1MUxnMzEwZWt2VHpzQTJXelppNzNNcitkZEs0d3JzMndIUldi?=
 =?utf-8?B?RWJWUisrSzZrV2pkdDVITTc1aW81U1o2c0pZVllYenFrb0ZRbTh5OElKblVO?=
 =?utf-8?B?Vlk3REhOYmRsdWdFdU5GcmpBZkpiVUozZk9hYjg0cVFWNWZuNW92ZkZLeDVu?=
 =?utf-8?B?dkxaOGVkZGgwNHlCWmlxQld3aWRWbDVBV0pwbms2bVR1ZjA4Sk9FSGZuMEhw?=
 =?utf-8?B?V3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZEo0RmI0VHpna3MyNDdFTHp5VVF0c0pwWENKdTd2OUVGSDNyUS9iOHhpdGhz?=
 =?utf-8?B?cHVsd3l5TTBHTjNra2hMd2Mrak8wR0E5Yi9HYkFwSy91MFVaU2pPZVRyQW8r?=
 =?utf-8?B?c3V2NURTWC9LOG1JM2Z1RkVwRkJpTjFQRFZ4VlBGU0QzRkZBRzFwZHNsUllx?=
 =?utf-8?B?MTIrU2trVGR3Rlo3dTR5WGluYkZRM0UwcHlKc0gvZzl6bnhOVmZrazdxNE8v?=
 =?utf-8?B?TGpKUzFEZVNtdGtJeG02NEFkU09vaXRSWkVoZDJqaklsakpVZkJPSStSNzhN?=
 =?utf-8?B?TFFSenVvZjMrOHR4ZnhBbGtDTndDaFN4YVJ5bSt0eHFObWpHZEIwYzZ1TXFP?=
 =?utf-8?B?RmZWaGozN2dEVnZHK2FvSVhOU0VYenNBZ0hPQ3JEdXdCVnI1R2VqenBaWXVF?=
 =?utf-8?B?SXJUejRHSUx5OUJrb21WTGFVRWxyb2dibUNzQzBNTHA2bVlUSWl1NFQ4M0Va?=
 =?utf-8?B?MVZmN2xIZU5Lc0V3blZHTklNUDM3bU9Uek81UUE5Nlc3QTVod3kvQzVmSTlk?=
 =?utf-8?B?LzN5dzlVZHZCUC9FY3ZlTlUxUWZPaHkwcUEwQ1V1b3l6a3R3ampka1d3T3JJ?=
 =?utf-8?B?amdkaVNKMlhMTmxhK0FvNksreTR6bHJaandKU2hNeEpCMndIdWtNRjNLc1NJ?=
 =?utf-8?B?eCtkT0FlOG1PbTdlUUFhbzFhQnlUOVpvaDFPNjNmOVFlME5iSHgyMTNpbDdw?=
 =?utf-8?B?ZlB3V3BNUU52SzR0dXd4VEM3NmVMOXlMV2l4SXJKZVpWcHU5QlRtckJMZy9n?=
 =?utf-8?B?Qm05ZHdSRnlwMkRkTFVreEVRZVJ2RDZvVVJ0T2c3djc3S1RSQXUwVHhzeVAx?=
 =?utf-8?B?RmdIYXBodklOSU9EelJZSUtBTW15N0JxZFlEb2EyTi8xVTVGdEpiK1N0clNa?=
 =?utf-8?B?dGloZU5rRXVDckFZSlMzR2JaOXNMYVptdTF0OW5PZVdoNmhMWFlCendKTlhq?=
 =?utf-8?B?Q254YzNPWmtXM0VRaDEvMzlvUVNPMy9kM1ZyVk4yZVhsRjVJZFk4YmRsajdJ?=
 =?utf-8?B?ZlBtYk1EZ1ZtckJlNVNJVlBCSlRFMW1LejVwVTJRdGlPZ0F2UVhVejNTckd6?=
 =?utf-8?B?UXBsRlErQ1ZMOHBNb01lZTZ2RFpEREM5blFROS9UYm5sT2dxT1V4TVNSSjRD?=
 =?utf-8?B?aEI2UHgzQnYxQ0FNRWdiaE41S3RkSDM5ZFdUdCtXN1R2KzN3eGZWNjM4a0xj?=
 =?utf-8?B?U2FzSGMyZ0FGMG1MQ0hnaFRSTUhCZmZFVjlDVE1xNk8wU1dZUjhZWXhpcmd5?=
 =?utf-8?B?ODJnampRdWxad0RkUys4V29MSmlaR0hXMUNTZXlVRnJyY1JraUx1T3NsQzJZ?=
 =?utf-8?B?aG1ZcnRsNi9URFJSWW02Z2hPMUZrZVVrcWZLNitWTVJCNnc3Z1ZrWlVxcjA2?=
 =?utf-8?B?NGVvdHJwMTh0cXUxOWpkRFJkcllTNzNrekloYzBJUEFpRHA2R2tDMXkwekNV?=
 =?utf-8?Q?NhDQlY04?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc9cff56-66c5-45a4-c963-08dbcfd87b98
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 12:48:10.3086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X+ssdeOtH0SjArNFsW73F0KhAo+6LaeQFpBNnk4OKrkOdQla0/Lgor4GNbzthPWbQxLni/2EE4jnq18Mo6fZUvD/VCu7JLH7ZcQY8IR3QUc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7125
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-18_11,2023-10-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310180106
X-Proofpoint-GUID: 8kChYAb1SNFnTRtlZbmRPjkHs8WTQZKZ
X-Proofpoint-ORIG-GUID: 8kChYAb1SNFnTRtlZbmRPjkHs8WTQZKZ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/10/2023 13:03, Jason Gunthorpe wrote:
> On Wed, Oct 18, 2023 at 11:19:07AM +0100, Joao Martins wrote:
>> On 16/10/2023 19:05, Jason Gunthorpe wrote:
>>> On Mon, Oct 16, 2023 at 06:52:50PM +0100, Joao Martins wrote:
>>>> On 16/10/2023 17:34, Jason Gunthorpe wrote:
>>>>> On Mon, Oct 16, 2023 at 05:25:16PM +0100, Joao Martins wrote:
>>>>>> diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
>>>>>> index 99d4b075df49..96ec013d1192 100644
>>>>>> --- a/drivers/iommu/iommufd/Kconfig
>>>>>> +++ b/drivers/iommu/iommufd/Kconfig
>>>>>> @@ -11,6 +11,13 @@ config IOMMUFD
>>>>>>
>>>>>>           If you don't know what to do here, say N.
>>>>>>
>>>>>> +config IOMMUFD_DRIVER
>>>>>> +       bool "IOMMUFD provides iommu drivers supporting functions"
>>>>>> +       default IOMMU_API
>>>>>> +       help
>>>>>> +         IOMMUFD will provides supporting data structures and helpers to IOMMU
>>>>>> +         drivers.
>>>>>
>>>>> It is not a 'user selectable' kconfig, just make it
>>>>>
>>>>> config IOMMUFD_DRIVER
>>>>>        tristate
>>>>>        default n
>>>>>
>>>> tristate? More like a bool as IOMMU drivers aren't modloadable
>>>
>>> tristate, who knows what people will select. If the modular drivers
>>> use it then it is forced to a Y not a M. It is the right way to use kconfig..
>>>
>> Making it tristate will break build bisection in this module with errors like this:
>>
>> [I say bisection, because aftewards when we put IOMMU drivers in the mix, these
>> are always builtin, so it ends up selecting IOMMU_DRIVER=y.]
>>
>> ERROR: modpost: missing MODULE_LICENSE() in drivers/iommu/iommufd/iova_bitmap.o
>>
>> iova_bitmap is no module, and making it tristate allows to build it as a module
>> as long as one of the selectors of is a module. 'bool' is actually more accurate
>> to what it is builtin or not.
> 
> It is a module if you make it tristate, add the MODULE_LICENSE

It's not just that. It can't work as a module when CONFIG_VFIO=y and another
user is CONFIG_MLX5_VFIO_PCI=m. CONFIG_VFIO uses the API so this is that case
where IS_ENABLED(CONFIG_IOMMUFD_DRIVER) evaluates to true but it is only
technically used by a module so it doesn't link it in. You could have the header
file test for its presence of being a module instead of just IS_ENABLED() . But
then this is useless as CONFIG_VFIO code is what drives the whole VFIO driver
dirty tracking so it must override it as =y.

This extra kconfig change at the end should fix it. But I am a bit skeptical of
these last minute module-user changes, as it is getting a bit too nuanced from
what was a relatively non invasive change.

I would like to reiterate that there's no actual module user, making a bool is a
bit more clear on its usage on what it actually is (you would need IOMMU drivers
to be modules, which I think is a big gamble that is happening anytime soon?)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 6bda6dbb4878..1db519cce815 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -7,6 +7,7 @@ menuconfig VFIO
        select VFIO_GROUP if SPAPR_TCE_IOMMU || IOMMUFD=n
        select VFIO_DEVICE_CDEV if !VFIO_GROUP
        select VFIO_CONTAINER if IOMMUFD=n
+       select IOMMUFD_DRIVER
        help
          VFIO provides a framework for secure userspace device drivers.
          See Documentation/driver-api/vfio.rst for more details.

diff --git a/drivers/iommu/iommufd/iova_bitmap.c
b/drivers/iommu/iommufd/iova_bitmap.c
index f54b56388e00..350f6b615e91 100644
--- a/drivers/iommu/iommufd/iova_bitmap.c
+++ b/drivers/iommu/iommufd/iova_bitmap.c
@@ -7,6 +7,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
+#include <linux/module.h>

 #define BITS_PER_PAGE (PAGE_SIZE * BITS_PER_BYTE)

@@ -424,3 +425,5 @@ void iova_bitmap_set(struct iova_bitmap *bitmap,
        } while (cur_bit <= last_bit);
 }
 EXPORT_SYMBOL_GPL(iova_bitmap_set);
+
+MODULE_LICENSE("GPL v2");
