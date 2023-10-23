Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F597D41DF
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 23:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjJWVq7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 17:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjJWVq6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 17:46:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E5EBD
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 14:46:56 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39NLiVNA030798;
        Mon, 23 Oct 2023 21:46:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=9kvu0WiXJbfyao/EW2MXPU7g0Hd2PidESGXl4T1biZ8=;
 b=Fb5GZlJgFihd8HaxyxhpVZ1o1Br/CciXNruy3b5KWobqgGPfKhHbc/c7+qxdNRP8iPct
 /kxv0fjKndGE7O2vGK8YnOHM7Ji3+QSZD1duWZb+bUxj6Hc3lvDyM0mkvr5gLbtH3qLt
 qAaUYyl0T/2ebD5dPnSGqvfjvms0GIqY83Ka0rT21tIGo1gzasHOPCB75QfxoaKASyK5
 jd2peuyNy70acdTgUkTx0nbGY9FGAAHZYK2FZEc+lpjzp9jdyKcEPhON7jw2Db4e+ybz
 6NtbjJxZpyzmNJ7o1rX/ddfYGrPdf9hpB/n15Qre84AE0G79GY3X4aviSjwuQsUqHn7L nw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv6ham3n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 21:46:28 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39NJr8MA014205;
        Mon, 23 Oct 2023 21:46:27 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tvbfhtsu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 21:46:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WC1qmGn71eIrdQfEe3NB+NEw1mPzRxy5lQjlimFfoIJ7P1iX8y9sKxVXY1fyHOOmMgVUBfD+iq3vwP1aZRVLrdw+O7QFP0761aZF+68n6sF1MDasE2aN2hiVcxul4bVQqJaU3FehergcdrvNPlxciDR/lCtbpR3b21vmPlxOkWXMnnN8uEcDFHjgDWOP7s6X/dfgUgk2Ii/9nAn/04ILqL4sbgGo2CIwL3NKr9di2LxDUY45fGBTAI16ztjwAu4uE9KcBygoo/2U/K57fBsUElzDl43u+WZFvolfTBy6sRlPMrY+LR/PZF6YlfsKBqJb/FWsz1klxP7chveiOdzaeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9kvu0WiXJbfyao/EW2MXPU7g0Hd2PidESGXl4T1biZ8=;
 b=gSjq+bo5Qo4+28H57Br7NYpbnXowlH9zdYURQr5cZvKQ3aBPhW1qVckVtMzlnC1N9tP5v4Qc+9FQUGUF7A8JCHba19mrUGeGLtbZfWrhTldjZHbzH98kuITxBw+Moey1QnkYAlYIFOrtIk+/0mY3E6PJFiYDjzBraHIsi70yp/Qo77kQA+F2Qr5f9jAMbQ87+Cyl4m8ZSxM6uZBRPwAR0o0ZAPCvtmN49NrTmZccIU4Nq7M5yrAPq8E7/84A9PO/mY7F9XJwW9MVGOm8/T27HatSqpZM07TwSjUT2KpyEDxpZkclFmtWoBuv3Q2Jdt42/NIirJpwFfjzCjDQfmvk2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9kvu0WiXJbfyao/EW2MXPU7g0Hd2PidESGXl4T1biZ8=;
 b=GTIWtyMYZYdo7lopseAwRwYzVSpQkUJYf3fXCkIo/lw5X6Otg7+liwZmSgrJRFdMnFloik+F/3t3tlCGIfq/+yV9BiVDyjIjn36IAHHIrFnhA+65cqC7CllsY154pRcuGaYFfn4Eks/LxWANa6QgPsY5XXmsynBo5x/elp4Q8IU=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN6PR10MB7468.namprd10.prod.outlook.com (2603:10b6:208:47b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Mon, 23 Oct
 2023 21:46:25 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac%3]) with mapi id 15.20.6907.032; Mon, 23 Oct 2023
 21:46:25 +0000
Message-ID: <219f2d71-858e-4fa5-9ab0-f1efb515d066@oracle.com>
Date:   Mon, 23 Oct 2023 22:46:19 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 16/18] iommufd/selftest: Test
 IOMMU_HWPT_GET_DIRTY_BITMAP
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     iommu@lists.linux.dev, Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231020222804.21850-17-joao.m.martins@oracle.com>
 <ZTbSx9mDWf7QwgjF@Asurada-Nvidia>
 <0a641e15-a6e4-4113-932d-ba2caa236653@oracle.com>
 <ZTbZiKhkrSaxpqNU@Asurada-Nvidia>
 <455beefa-9b1c-427a-a33f-a64f8e764f8e@oracle.com>
In-Reply-To: <455beefa-9b1c-427a-a33f-a64f8e764f8e@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0008.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::20) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|MN6PR10MB7468:EE_
X-MS-Office365-Filtering-Correlation-Id: 5adb3d67-7177-4cfb-478f-08dbd4118164
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cZVC1s02Ng93IdESCdDd866PRntA73m+k/IyYXzAa9gCt2BKY3fKyolUJ9sybVvls0ae4O3FMYReHUprrkXSbWixAdn4JYRzSj1Ym1U2jlMYf3NSoyaODLGDKoQoUSI9VYueWOTDvnsUFENI7Wtygt2TQUhwq+YqueiLzXr7o/LXspxRvGVHQI08noFF2mYlv7vpmg3fhxftlQHPl8+DA7Fw3tObeSJti76y1mcWOr/kqClSpuAHjAgybN0cuBt8ZQXrWsTEdDLM5bBLfIIg/U/nd8UaSeD2W5fiCruzT01O9HkSQ5YlcVO1/8xFinV+hKp5JDsY472+u4d2KXgnRlNz+grEO6Lfr6G1cr+8AVLLO1Mf9g9ptHSBpxb7y5VzJJQdCLSQmWEDhp0iVCbDgg+dO6Y6GSt4PpB5l7D/i/2GNSC/P9DlEVYekuiuOTCgpGSu00vvxiBQ26Qutl8EMCVZnn3VeQjqtKEJCWVE+ikcXNMGJklJCG+9AT7tP3bXG0sfht/x1+nW6AVrvFLGPGl5+rFTEdSVJTPnT+D4ysGaF/yAPyi3UmYRKb/CtQzv6EvzuvQpx9JlhtkWsM5KpoannOD80uB7bUDumhBgFbB2oLsFevVY++sULqNj4vB4ahG8WMZlnhtUAJWQrcRQ8auLaZrbUxjDSJ4ojCI21mA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(376002)(366004)(136003)(346002)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(6916009)(316002)(4326008)(83380400001)(54906003)(66476007)(66556008)(8676002)(6486002)(66946007)(5660300002)(6666004)(31686004)(6506007)(6512007)(2906002)(7416002)(86362001)(36756003)(41300700001)(478600001)(8936002)(31696002)(53546011)(26005)(2616005)(38100700002)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?em5Ba3dxSTZtMi9BY3RSMDE4bzU3TWtQdkRHNUZDbGN6YVFFdTdlSWRhWUNo?=
 =?utf-8?B?Z1plSnNiamRmdW9JbXJEV1JZbVRlYloyejdMZ3dxM3htVjBFK20wVzIxbVBv?=
 =?utf-8?B?SUJHeE9sTkFuWnVuTzBLb2YwUjRWY3Y0ay9hZ2Q3S052WSsxUjR5cVg3L3pJ?=
 =?utf-8?B?Tkt1SWljQkIxU3piWUVWQjdkT0k1dVlaYUpKdmQyUnhhY3dwMlpJQm9KaUwx?=
 =?utf-8?B?RjE3eGxIRXBoQlVDRXlSZ09tU2t1R3dQaEZFSHVTK1RDVmFnOFllblBpd3kz?=
 =?utf-8?B?Q3dteTNJcFA3cmR5TUJyc2ZBRXBoajhIQVhBZ3I3cFpYaUFkRXhGV0E3Nk9I?=
 =?utf-8?B?RHVYRWFkV2oxMlhWZ0xpa1hxWXJVWjZibHB4Z2tnMDk5WFliSzd6RWFqWEwx?=
 =?utf-8?B?L29wUlBjVTd3aFN2NVRYYzFsczJTOXg3bUVCTE5xT1NNZXoxTHhaalVSMEY2?=
 =?utf-8?B?bXRBblJwYkpWOEgvV2p4KzNpZ2lnQUhBM0JrMWl5enBxTHFVUStBRDdHMU1x?=
 =?utf-8?B?eEVkSVBCcFEyNlFCWDl3SHRzaVd1NVY4MFZOakFkeWlmN2FMOExuR21HUGZN?=
 =?utf-8?B?VDlVcU5PSlE0V1ZhazQvVEMzWUhQa3pZWnpaN2c5ZUlNRmc4d1ZNOFhrQ1Bt?=
 =?utf-8?B?NFRxdlRoOWczL1lWUVZnVHo0Q3hPbTN5YzJ4YW84MG9XYSt4dmY4S3lXR3dP?=
 =?utf-8?B?eFFZQzVoVmdyMnRtV0VOSHNqbUhVZHBuTTcwaWF3ZWFBMDhQMkthZ1dEaXBO?=
 =?utf-8?B?U2RZTzJZeFI0K2pnQk10Nmk5TU5zc3FoT1NDT3lCbGtIeWIvcW5vWWF6d1ph?=
 =?utf-8?B?eExsdHhrVHRQVExqTDdSWm41dWhlY2NwQk1mVE1heDJibHJ5cjdPaG5HUVNm?=
 =?utf-8?B?VmFDTFhtWkdiSU41NGExQ0tzRHVPTFQ3ejJlelp0bHE0dUpVZXI2NFp6R3NO?=
 =?utf-8?B?UkN6cm42NDYybzNYaWVCV2I0RXJkSFpuRWh3ZjNuOWV5SVFWdlR4WHc5NFJJ?=
 =?utf-8?B?R1hmN25ERUpyTkZKL01xMVBJL0luRjlJalpCVTBPejZVQmFVZzN6VmtOdlpK?=
 =?utf-8?B?RUpBbXlIVTU0N2pxbnlHb0xnU05YYjhLN1JUcXRNWGpOSGlCRGY2bnN2WUYy?=
 =?utf-8?B?VlNEWTJZYk5HOHZPMTl3c09nUFJNdGRqY3ZTOXJrc3VlZ3VBUEV5b3hnSHla?=
 =?utf-8?B?TjhFb1FSNmMwenQ5aEFRc2V0Mi9oN0ZMZFZjZmJQOUoxNVlRS0Vjd0lCdktZ?=
 =?utf-8?B?NVZ3NnBqSzNKNC93ZFVwYS9PSUtYeEZDYjVXQjMvc3Y2dXF3MWZod24raFow?=
 =?utf-8?B?YkFKRlVtaTE3cTd1OXBWNU9za3ZxOXB5SGtjY3VHZzVqU2s0bHRFVkhoYURw?=
 =?utf-8?B?LzhLaTlTOTZDSFNmYjVQdlVTY0NMZm9wRzVMNE5kckpTNks0WFpHT0FVN3hY?=
 =?utf-8?B?dTFNWittN2pUMnhROThVZlB2TUVJaGVMSnpKWC9HUStvQkIrY0ljUEhZRytE?=
 =?utf-8?B?SWp4ZGNKckNoWDhoSjY1ZktFODZMaVdEOG03MGp0Z2lMSXQ1aUc1YTU0VUdP?=
 =?utf-8?B?YzhJL0RkSDhLdnQvZWRFTnAxVlFId0VnODdVdzF0bDVmWFJzSlo4WXlQb3BP?=
 =?utf-8?B?eVJlNjZwdWlPemRRYWFBRElCcTlFUEwrK1c1TUNKdmN6YXdmZnVmamFFWmll?=
 =?utf-8?B?dnl6c1JNUDJod2t5K2hTWHV6cndSSHFCZ05rL1hHUVFFV05ISENNRitoandt?=
 =?utf-8?B?V0VxemJ5dGJ2aXYyeUVjYnJWdlNVSk9oOUVranNscWlOdzFIeXNqYU5xc0N6?=
 =?utf-8?B?THg0Rmh3bjVwUCtHLzM5K21tbFlwRFhQd29iTTNNek9xdFJ0M2lCTlJlMlFO?=
 =?utf-8?B?Nnh1a1BOUjdWQ1owUDg1eUxnV1ZMWWpQNmw4cFdvQU1USm9QWGt0VW9sRXpY?=
 =?utf-8?B?ekpFMmZHQ1dudlNiRVhkUXEzWWhTT2hmaGhLTWFBbzlYdkY5aU1DZmIyWEtH?=
 =?utf-8?B?RUFZOWhPazhuQnhheEQxZW1pd2FUaEx3M1A1cmJuOS8wVGNobkNqNlRxVndR?=
 =?utf-8?B?OVRpV2NyRWo2YWRUdjV2RkRZUGN5dHZUb0ZGVE9UV0hzWkRDVm9FYTg2cmxB?=
 =?utf-8?B?Mk9ETHpMZU12ZzcxVUVHdURIeTVBSzVuTElPdlFYeXpBV2FzVi9Ha3NkczRZ?=
 =?utf-8?B?SEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZFQ3eFJ4MTBxejVOeDRFMmxDSERzNUgyQ1paRVRIcDQvY1g0WnVkNnF4eVpq?=
 =?utf-8?B?c1FVN0dDdm5mM3czbTIrOVhVN1hGVmRjc21VU1JKOWdWSHhpVHd3SDVDSkI3?=
 =?utf-8?B?bVViTVh1SFNPWk9hQ3k1UUdqdTJzQW4zbUFvVGpWNWp3b2U2ZlpkZUw3UENw?=
 =?utf-8?B?KzhYVlgyWGZ0K1JodExwcHkzaTlKSmJLeHo1cXMrbGdxSmZtK1Uxd3dLaEp6?=
 =?utf-8?B?UFdKeWk0dTc5NmYrSHppeUxLaURIYjhQVW0yWHNHM2tGcW1VNkRpbXVjS0lt?=
 =?utf-8?B?N0dHTEVaUFp4Sk1NWVlKUE5TT3hySGF0Q0xOcDRJaWw3cXI3WkE5VVRRbnY5?=
 =?utf-8?B?VlV2OXk5dWREN21CbG1GSUR5WnlseHE1cG1heU92Y0xQR2M0aGZ6TThhVjll?=
 =?utf-8?B?YVhnWksxTWFvaUlQaTByaUlYdXMycytjcjBpdTBSM0k1ZFZuNmd5UHZkUnY1?=
 =?utf-8?B?dU14eWIyU0tKMXB0YTRBY1hvYzc4YU5oeEtIK3BWVVltczJXcEQ3dlZPVmxY?=
 =?utf-8?B?SWZYUzBBS2JPWEs4MWpOUk5HWTFLUmZKYm5IMkRGYkxRbnY3cnFibFovQ1NB?=
 =?utf-8?B?OHlKY3RtUWR1c3BaWFRKM1UwV3h6bllQcEFCNjBwVlVZNVZGN3pFd1h3OFlq?=
 =?utf-8?B?MmxHRXQxQ0dicmRBU2Y3anVDczA0NWo1VGhOQXYzSVNjUzc2MWlEYWk0Qkhj?=
 =?utf-8?B?OTNFK2puckpDUHRWL3ZIa3d5ZFIxcXJ4ekdQK21iSksrdE5xTHJsZ01ab3Az?=
 =?utf-8?B?NElHWk45L0FNMFNVcjU5QzJQemlLVnl3emxDZExhSU5NemFNWlNuUythclhT?=
 =?utf-8?B?UnRlTTBYSWpSaCs1TTAzT3ZFZUZYTTV3UXN0QXI5REJjS3pOTFFzUUp3UnJo?=
 =?utf-8?B?RkhSWWF0ZlViQkpaWGV1UE91TGVXcHZmcE9seVVFb2lxTDFaR1kzUy9ZR2pY?=
 =?utf-8?B?SGhTZFVHczVIeE5hYnlMUDlzaXYwWDRSWVYxdGRxR29iV1luVENlMzhUSFp0?=
 =?utf-8?B?M21HbmRWMjVxVlJMQkNPYWxCUTZIVUxlbHJOTmlxbmY0OWVDajZoOVZQaEVv?=
 =?utf-8?B?T21LQWpvNWdYeXlIMXhaNTg3NWFYaXRyaUh5elp4alNIYmVTWVUwa0hBelJN?=
 =?utf-8?B?TnFNREZrL1dLdEJSeHZGbUhsQUhlWEJ5SHFBckNubytmb3NEa2h2SjlkQUUy?=
 =?utf-8?B?STNNbkVBMnlVRDAyY0dnS1pCWFMzWitETFNDSGVuUFpIYnlrTTdYckRoWHNG?=
 =?utf-8?B?dnFvZWlNWkJGcmFNczRxQTU1UTJMaWNCVlI2SmlCekJxUENOOWpFcVhnZklI?=
 =?utf-8?B?TFJLWGpKY0x0dFVjZmljREhOcDVGNkl5VDRWdGUwcTV1enpyOW5OTU9iblVD?=
 =?utf-8?B?WXJKczdtZDNXRG5MVk9SOEFmMWFXODMvdkl4YUFkQnNieFBWeUtyZHplTG5M?=
 =?utf-8?Q?mMVrzkfJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5adb3d67-7177-4cfb-478f-08dbd4118164
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 21:46:25.5410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E4nA1Hv65BZ+dqEpK1pGAdOB8DzsZDa03o5I5NVMyAQGqE1DhbOmKdAIxgkfI1Y0/o8BKdxWrJNP42yPm9jFhKsPTXqjDn267t665jqXlUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7468
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-23_21,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310230191
X-Proofpoint-GUID: n5ix26Nw0NyT7NOB96Fh7IYo-e2CFVm5
X-Proofpoint-ORIG-GUID: n5ix26Nw0NyT7NOB96Fh7IYo-e2CFVm5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/10/2023 21:50, Joao Martins wrote:
> On 23/10/2023 21:37, Nicolin Chen wrote:
>> On Mon, Oct 23, 2023 at 09:15:32PM +0100, Joao Martins wrote:
>>> On 23/10/2023 21:08, Nicolin Chen wrote:
>>>> On Fri, Oct 20, 2023 at 11:28:02PM +0100, Joao Martins wrote:
>>>>
>>>>> +static int iommufd_test_dirty(struct iommufd_ucmd *ucmd,
>>>>> +                             unsigned int mockpt_id, unsigned long iova,
>>>>> +                             size_t length, unsigned long page_size,
>>>>> +                             void __user *uptr, u32 flags)
>>>>> +{
>>>>> +       unsigned long i, max = length / page_size;
>>>>> +       struct iommu_test_cmd *cmd = ucmd->cmd;
>>>>> +       struct iommufd_hw_pagetable *hwpt;
>>>>> +       struct mock_iommu_domain *mock;
>>>>> +       int rc, count = 0;
>>>>> +
>>>>> +       if (iova % page_size || length % page_size ||
>>>>> +           (uintptr_t)uptr % page_size)
>>>>> +               return -EINVAL;
>>>>> +
>>>>> +       hwpt = get_md_pagetable(ucmd, mockpt_id, &mock);
>>>>> +       if (IS_ERR(hwpt))
>>>>> +               return PTR_ERR(hwpt);
>>>>> +
>>>>> +       if (!(mock->flags & MOCK_DIRTY_TRACK)) {
>>>>> +               rc = -EINVAL;
>>>>> +               goto out_put;
>>>>> +       }
>>>>> +
>>>>> +       for (i = 0; i < max; i++) {
>>>>> +               unsigned long cur = iova + i * page_size;
>>>>> +               void *ent, *old;
>>>>> +
>>>>> +               if (!test_bit(i, (unsigned long *) uptr))
>>>>> +                       continue;
>>>>
>>>> Is it okay to test_bit on a user pointer/page? Should we call
>>>> get_user_pages or so?
>>>>
>>> Arggh, let me fix that.
>>>
>>> This is where it is failing the selftest for you?
>>>
>>> If so, I should paste a snippet for you to test.
>>
>> Yea, the crash seems to be caused by this. Possibly some memory
>> debugging feature that I turned on caught this?
>>
>> I tried a test fix and the crash is gone (attaching at EOM).
>>
>> However, I still see other failures:
>> # #  RUN           iommufd_dirty_tracking.domain_dirty128M.get_dirty_bitmap ...
>> # # iommufd_utils.h:292:get_dirty_bitmap:Expected nr (32768) == out_dirty (13648)
>> # # get_dirty_bitmap: Test terminated by assertion
>> # #          FAIL  iommufd_dirty_tracking.domain_dirty128M.get_dirty_bitmap
>> # not ok 147 iommufd_dirty_tracking.domain_dirty128M.get_dirty_bitmap
>> # #  RUN           iommufd_dirty_tracking.domain_dirty256M.enforce_dirty ...
>> # #            OK  iommufd_dirty_tracking.domain_dirty256M.enforce_dirty
>> # ok 148 iommufd_dirty_tracking.domain_dirty256M.enforce_dirty
>> # #  RUN           iommufd_dirty_tracking.domain_dirty256M.set_dirty_tracking ...
>> # #            OK  iommufd_dirty_tracking.domain_dirty256M.set_dirty_tracking
>> # ok 149 iommufd_dirty_tracking.domain_dirty256M.set_dirty_tracking
>> # #  RUN           iommufd_dirty_tracking.domain_dirty256M.device_dirty_capability ...
>> # #            OK  iommufd_dirty_tracking.domain_dirty256M.device_dirty_capability
>> # ok 150 iommufd_dirty_tracking.domain_dirty256M.device_dirty_capability
>> # #  RUN           iommufd_dirty_tracking.domain_dirty256M.get_dirty_bitmap ...
>> # # iommufd_utils.h:292:get_dirty_bitmap:Expected nr (65536) == out_dirty (8923)
>>
>>
>> Maybe page_size isn't the right size?
>>
> 
> You are probably just not copying it right.
> 
> The bitmap APIs treat the pointer as one big array of ulongs and set the right
> word of it, so your copy_from_user needs to make sure it is copying from the
> right offset.
> 
> Given that the tests (of different sizes) exercise the boundaries of the bitmap
> it eventually exposes. The 256M specifically it could be that I an testing the 2
> PAGE_SIZE bitmap, that I offset on purpose (as part of the test).
> 
> Let me play with it in the meantime and I will paste an diff based on yours.

This is based on your snippet, except that we just copy the whole thing instead
of per chunk.  Should make it less error-prone than to calculate offsets. Could
you try it out and see if it works for you? Meanwhile I found out that I was
checking the uptr (bitmap pointer) alignment against page_size which didn't make
sense.

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 8a2c7df85441..d8551c9d5b6c 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -1098,14 +1098,14 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd,
unsigned int mockpt_id,
                              unsigned long page_size, void __user *uptr,
                              u32 flags)
 {
-       unsigned long i, max = length / page_size;
+       unsigned long bitmap_size, i, max = length / page_size;
        struct iommu_test_cmd *cmd = ucmd->cmd;
        struct iommufd_hw_pagetable *hwpt;
        struct mock_iommu_domain *mock;
        int rc, count = 0;
+       void *tmp;

-       if (iova % page_size || length % page_size ||
-           (uintptr_t)uptr % page_size)
+       if (iova % page_size || length % page_size || !uptr)
                return -EINVAL;

        hwpt = get_md_pagetable(ucmd, mockpt_id, &mock);
@@ -1117,11 +1117,24 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd,
unsigned int mockpt_id,
                goto out_put;
        }

+       bitmap_size = max / BITS_PER_BYTE;
+
+       tmp = kvzalloc(bitmap_size, GFP_KERNEL_ACCOUNT);
+       if (!tmp) {
+               rc = -ENOMEM;
+               goto out_put;
+       }
+
+       if (copy_from_user(tmp, uptr, bitmap_size)) {
+               rc = -EFAULT;
+               goto out_free;
+       }
+
        for (i = 0; i < max; i++) {
                unsigned long cur = iova + i * page_size;
                void *ent, *old;

-               if (!test_bit(i, (unsigned long *)uptr))
+               if (!test_bit(i, (unsigned long *)tmp))
                        continue;

                ent = xa_load(&mock->pfns, cur / page_size);
@@ -1138,6 +1151,8 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd,
unsigned int mockpt_id,

        cmd->dirty.out_nr_dirty = count;
        rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+out_free:
+       kvfree(tmp);
 out_put:
        iommufd_put_object(&hwpt->obj);
        return rc;
