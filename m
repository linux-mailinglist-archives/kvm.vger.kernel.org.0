Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B397B7D501E
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 14:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234354AbjJXMnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 08:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233306AbjJXMnW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 08:43:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2BC123
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 05:43:18 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39OCKOEP004493;
        Tue, 24 Oct 2023 12:42:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=AMaAOP+wSBdBpwp9xZTIaNyeVRkQxquTaZ+C28/2J44=;
 b=llEJls5Kz890VRzEKCDp1q0PcPICBAdBo1lKfBczzUFcrgledDdCdYpL76cK8xxKmvoO
 JqoEqEyaw4Spcgr8lNdmuIRFXQwe0mov19z+OYg1hjGlc/eLCh9vzs6vQlrMKTfNY4OI
 2YHfrHgzANm25dryzi6Ao4VHI3aoi8PcsddLdZBHzutBvm6eB1npbv2ppWWQ97l9T0bh
 KNXNWo8UpRgoxSRVW73mYcyYL88+ePKfIP/5lMmq4cmt0u4FDiP2qG6vM02UjdIvvmdM
 0MzSgZ3Nb63QUFLvbJKpu26CufVxoCvBntpnp9Q5fllY5e2wQmG/DOh8TUkoMGAMslBZ Pg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv76u5b3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 12:42:36 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39OA4v3O015083;
        Tue, 24 Oct 2023 12:42:35 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tv53579w2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 12:42:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i1D25q1yefcmS/gWgJQWW/pmhqAAyqQiAHZiVNiuAP1x3hX5jtXH46u8+e8/OnHQaO3OOOf9Z++orhFZ4peGgiLW8vHxIk945wMMk/3wJCW33FxHDimbFQolXlklOu/yvrQCuE9UCCRLe7BmpMp6slCqQXv/SyPxNjIc83cPCgz3cm4QYtir+NeK0Xccr/XMPhlStgO/OYewVzJmZM9y9QJI4J0ydfgTzB4BaEYByQSwEOA9U1PWb2NDfVKg8pY0VM1KEDDzWLfPmxI1PaiOeELOGESXcJ50BW815uEknUDpdXaBLSKmZco11Zg1FhQCnaRZONaiLCnLf27HdcOTtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AMaAOP+wSBdBpwp9xZTIaNyeVRkQxquTaZ+C28/2J44=;
 b=KGXKFKVxMvcvOXlP9+SmY62fxcDEnj0+7GB0dgWwerqQT0GO/04kVh4hHWiEJUu8gdJj+P6rm744y+ZiyJa1dPQTDqg0pYrYDFlY3ni+CLuKFFXgkP0yK9x3O2u4dnfzO1xU4zreDIFNLmDG23ntMENqwmdOxON4wgbI7ia1WmbYQfwM8xsoxC16R2CBAgCI/JTPhnw6ShIc2DiiPY/2ePo1oCiw9ibEobK5k0AIcEZIlAcMEe91/TLlx0bhhD06BW+4Re2nQYDmnK5oClmo3jHtVVjK964UxOksQDKxIlEN+jr1W2cDfBS+aLBqFDSHVZoCWsXjRa7C4qmdm6TyVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AMaAOP+wSBdBpwp9xZTIaNyeVRkQxquTaZ+C28/2J44=;
 b=NMvt83nbfJLJKZMK2bCPuPmRoUzi7BOQpH40WEaTdAM9Y+yob+Vfg97I0lgLaZu3Hkxlbd0STlXOg7nvU4+iYnQ5JFDBJZk3sr5LhVq+w1tyU7VN4bDA8Kc5mYUy/AgVsibE/PWu240wP+NGUBN4I4M3zUK4lHS9N/tj89Y7+G0=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DS7PR10MB4896.namprd10.prod.outlook.com (2603:10b6:5:3a0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Tue, 24 Oct
 2023 12:42:32 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac%3]) with mapi id 15.20.6907.032; Tue, 24 Oct 2023
 12:42:32 +0000
Message-ID: <2b4beb4c-3936-4a75-9ecd-6d04e872bd90@oracle.com>
Date:   Tue, 24 Oct 2023 13:42:27 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 12/18] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>, iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231020222804.21850-13-joao.m.martins@oracle.com>
 <ad8fcbd4-aa5c-4bff-bfc8-a2e8fa1c1cf5@intel.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <ad8fcbd4-aa5c-4bff-bfc8-a2e8fa1c1cf5@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0067.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::31) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|DS7PR10MB4896:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d18fd42-043d-4c2b-f185-08dbd48eb0eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yELfywU/x1ZONVPAFmXeIGLt1PwtQ8FvIjj2MyHpSD24CiqWaNLkvK1eKOagzCEiDotFdkHVeuJxvRd+iDILIZcX2Odvq9bnpKtqkUsbUcwHySjYARDQo/QDdDXjLV7Q0Rj5njaMD24qUeO4AtWlVCJEF/Ak4ivCVXOF3k708f74oaTRQdWxXn3w+c6+IXgevPy0RkzSvUCaEm5oPNb5FByS1Ovp6qgVKK/KQaig+IAW89jOj5y1oEEqbeFMKELU/HFDXUmRJwus3Wwld4w1SVWlJryRoRgyBxNTsCAo5mSHRQ2AYFy0sOOsPy8iFBsJp5GrmUBidnbLEPsCppcqxqktkavmml7yqRcCrmy8xHMh+XyxpqdBbq6rTokh40FFv0kOap1i2N4YbpyCjUglaJErnaB/7SMV15XOpLJBecQ/pZ8I0Z5Df3DgsBaw8KPRMsaQY3lWVpAdwagvIQi9uBo/KN/XGXjMPzyW6IiJTlnBJnrfwXw6Q1j5NrhrXuMexpJ3neJrBbK/5rpobqFUszwq3j2wA4HH6UGGhciJ7G6mIa3tQi79IblJmtgoSmqPFL+WY1s+442BVVWsFsNDXschlfq3U5V0jkW3o3lGxDTUstBTA6dro2aVuiCV3BEl/APiGADM0e4xQNCDmNXY3HqjFhwfyTHpaPxCPJRY99K8rbR9ifSxgQqJUQ43bC+r4RFV7lob3o09DvepeUqKyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(376002)(346002)(136003)(39860400002)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(6666004)(6506007)(5660300002)(8676002)(8936002)(4326008)(53546011)(6512007)(31696002)(2906002)(83380400001)(36756003)(7416002)(30864003)(26005)(2616005)(38100700002)(86362001)(6486002)(316002)(478600001)(66946007)(31686004)(66476007)(54906003)(41300700001)(66556008)(14143004)(45980500001)(43740500002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y1ZyclFPZTlvUXcwVFhzZFZ4SjN2cjFvMlVoUHd4SXR2eVhtbnBySHZ5SkJF?=
 =?utf-8?B?OVN6SDI5Z0QrUzdpcjRJK2hjdE9lL1h1MFZKb3hzNDkwS3dQUHNQaTVHKzB3?=
 =?utf-8?B?Wi95WkV3QmJSRjZFR09tRnRPWlBlODBnSnVkbld4bTduN1FPL1plak42aml1?=
 =?utf-8?B?S0FvaUhBVDlySDVKWS9wMEdrZDYxdG9uQktPeUY0TzVXMVhhSkNlcHlxRGkv?=
 =?utf-8?B?SXZPRXFaWnEyZ1B2aGF0bGdrd016Vk9iakhicGx6L0ZTcDMzQU9aU1dxQmlN?=
 =?utf-8?B?blQ0d1UzUDNobjJZTGNsS0FtWitRRTc1UnhYcHU0ZFUzSWZ2OEd2NEVnTGdk?=
 =?utf-8?B?TlpPNVNrcWxZMitteXBPS0ZlYTd3ZVMvUDVYQWJ3YnQ0V1d2bE5CUWlPRHZ1?=
 =?utf-8?B?Z1NmSHRtN0VGTVRaYTgzMFJpcXMwMnYwVTJQbE1IaVNOZUVQam0rWGhwTjRJ?=
 =?utf-8?B?VytlaWZiYlVCZUNoR0g3NXk0bXFhSm43bGhLQzJjUFl5T0lObkEzSHh3R0JO?=
 =?utf-8?B?VjNTQWE5Q1lVY1N4UUpHd1p4RTdyZml3cWt5QmpkZmRhNmRKRjdVcmZQazhP?=
 =?utf-8?B?V2xlSjFQQTlpVllDR3hUNkh6b2huR2JOMnU2Si9XQmdRVm5WY1JZVXo1dElv?=
 =?utf-8?B?WEt1YXZvWmJESkpXYmcwUnZCbFpwdDRGalRhcGpnZG03RnRvNHRKREFCbzB1?=
 =?utf-8?B?WUJoS3pLdFFSV1p6UWpIZTdjeUVLbHpmem5oS1VjbnpMb2FHOWlaeHpoVnRs?=
 =?utf-8?B?Zm1pOVdXQWtPcHl6ZXoxZS9qcG5TYVJmUjBkTDFPY3lPNnNXcGE0TTVwVHll?=
 =?utf-8?B?ZE00NXE3cTYwVTRneXNqZG9leDIvTnFZamdic3pJMnhyRmRRUFRpcVZML203?=
 =?utf-8?B?WFZreUpTQkhkL201eTlXaVRQREZZY2hpc1hRb1pRMzNRNGpzNzJtU0FjbXRw?=
 =?utf-8?B?WlpQaDllcHVESW56WDIydzdTbEpCa2dqU1V0L0ZUeCtIc2V2cEdwWko0ZUQw?=
 =?utf-8?B?Z0tUcDFJWHh1WlZPb04zV2t0ZkZwSTRJSHdIak1xTnRtTTVONVRibkEyNmR0?=
 =?utf-8?B?MzBoRlJKT3hVc3FYaHErUjlaQThrdkw3VlBKRjc0RVY5ZEpnK1d6b1k0R21w?=
 =?utf-8?B?S0VaNmhxL0RNOXNHaE50N2docngvbmJQUlY4N002WTlJaW4zVGNESzA3KzVJ?=
 =?utf-8?B?SUQvRUY4VnRWL2h6bUZlZE51aTNZdVZqUlFRT1o5cWF3SlhyTGxZa1FxRTBD?=
 =?utf-8?B?RnpIcUkyTU5MM094elNYQ3pXTis3eEIwaW1MYitkZUJzOTRrUjQvcWlBdDVr?=
 =?utf-8?B?Y1JDaEVWK0dDMUhpdmpvRzBROVViTnhHLzJxWE9nYzNLYkU5ZUh5SjBneW0z?=
 =?utf-8?B?dStnTjZKRG9mcHJYejh0NTkwbjZlVXU0THhXRzBaTFE3VUFiOUFkbmhObnN6?=
 =?utf-8?B?RlZEWnNhUXR4MzdJSFVYNUNlMnE1NUVubXFBYmNaTk85YWNoRksrcEQ4Q3c0?=
 =?utf-8?B?SEg5WFN0QytZdDI3MHZ1TEpiNklScHpRSW9Ta0NiN0pCdWhRb0RzYUlOSDI4?=
 =?utf-8?B?TGRlYXRKQW5BOFFIS1Uvdk5FV0ZWbzUxcE84MGhTa2JWaEpPZmNCNjF2cVQ2?=
 =?utf-8?B?THpzUmNrWVlZc1lNUjZGVFd2a2p3dmY3NklNOWNJOCt0MVNQekRSdTRVdzYx?=
 =?utf-8?B?YnJLaWZ4ZjBEMDZqZmJrM1E2SzdFc3ZodHFSY2F4dWxLZzJic0NkVmxaWEVu?=
 =?utf-8?B?VjUrMndWclRxTDVpUlU2eDFVTWhGOFBXYmdtMXRkNFNXbEdqb0NyYXJORUtk?=
 =?utf-8?B?YzVOOFBSVXgrRjUvVEwrMEZ6bCtSVGJyajh0YU1nY1p0SjgzMm1NWXhDazVw?=
 =?utf-8?B?bTduTGtFR0ZwT0R6Y0YwU1o0b3l3bXFHVWpOaEl1WFhPSzlza3ZFUUE0NGIy?=
 =?utf-8?B?Z3prZTV5Y3l0Qy9GZGxFRGhSYW5qVVlscTc0RHo1WHZLZjhxYUtSd3FkQTFC?=
 =?utf-8?B?eGlvVlpvdTlnUFVZUFJUNWE4eEdyQVYzaEVJSGxHQk01WlRlbTdCc3JXdjgw?=
 =?utf-8?B?Qkx2V3dnZVpsY3RYc1pHR1htQm9HZGhER3h5STdsU29BWHgrSlRhSzUreGRs?=
 =?utf-8?B?aWpnVDFaMmo2OXM4UTJCWTRqUk1XY2F2VllYWjZGUUNwcGhuVDRmdldob1dt?=
 =?utf-8?B?cEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?YWwyaWRnZnZaeWI4bjhNNVZITGNLK2crZytwS1duaEhkYjVPYnpYaEJPWDE3?=
 =?utf-8?B?QjB6ay9YdEhMbVNRdXpQVVJEMXdMTHZPaDBYNU43eFN1dVkzSWxKdlN2eEl1?=
 =?utf-8?B?SlFoTTBORlNwWXU2OSthTnR4ZEtZL2hnV0dRNDdNQ2p0TXZHRkN1dkxPNWFH?=
 =?utf-8?B?UXVOV25QOWQ1VG1TT1JqdlUzbzkzd01QNjRHQUZGMnJQUlRGK3hrUWRFUFdo?=
 =?utf-8?B?cXl2NmhUZkVjZ0Y4MS9oTjhhaEJMSzU1VWRCL05wZTQ4V1g5dEZzbVhmQmRB?=
 =?utf-8?B?RTdKZko2WW11L010ZFVyQmRBVzNRTkQvYVJTcjRQL3N0SW9nelFOYUt1cXIz?=
 =?utf-8?B?TVFMNll5cVI4eWY0QXNoS3g2akxXY25DVDBFMTlZa01HTHVQSHJqMW9HOTRt?=
 =?utf-8?B?WkZ1ajh1OFVSa0srMFg4eVUwTC8wS3ZJZEphcmUrRk4vc1FRUWl5VHdDWlhx?=
 =?utf-8?B?OWZFVGJscHQzSkxnL01WY3Z5amhWSlJISk5sQUltL0tlRHpWZDBEYnZ1OUR2?=
 =?utf-8?B?d3pqTVVlRW5saVA2SExJM3pkakdGRGtJMXJJWFVsWXQ1NFFFMEEyaGtYT3VJ?=
 =?utf-8?B?RXlwdWV4OHh6Ui9nRllaNGhVb3JPcmNNajlORy9QdERTQVl2Qkh4MW1uSk8w?=
 =?utf-8?B?N25Gb3kvdWxVL0dzb3VEaTFmNEpINWxOd2ZlanQ0WWFXWUNiQ2pzWDZjQzFH?=
 =?utf-8?B?ZTRKNGkyQ1M0VDczVXpRNzZPSTdMZ2E2NjlXUUd3c1RKVWxXMjNGbVNyYjB5?=
 =?utf-8?B?TmEyUTI0bWRFZzZzcnlja3l4VWNIMmpjb0g3OGV2NTMzejh4cmZwZjBpMDMy?=
 =?utf-8?B?bExaQjhJQ2RCWVJkbXRpRFNWUUUza21kcWo2dmpGaVlKYmRuNkgyY1UrYURM?=
 =?utf-8?B?QXQzd2k2ZVBUM25ZejZKb1ZSUjgxd3FsdXZnS3RrRlN2QjRmblpOVjhrVHJE?=
 =?utf-8?B?RjQ5Zmwrem9CcDVJQVpCNDN6SGo3ZHoxK3pnZnJlTUp1d3I5ZG16K0dCYkUz?=
 =?utf-8?B?WndLTUl1WTd6VFZXOUlmM0JwTHBvQ3hVRnlIMzlFWEc1a3hYYUZ1ZE0vc0c4?=
 =?utf-8?B?ZUgxZlJqTWRFUXo0aXpTZjE4WDNySnhzYUprNk1BZkFRcEtUTXFlb1ArM0Q3?=
 =?utf-8?B?K0dFd0k4UDkzUGNCVHNjQVNUQnJRTG5NaDZ2VWdWQTVkWlpjSGRyM2d5UGNT?=
 =?utf-8?B?WnNDSHhFRkdvMFhzOWkwOXIrSVIvZzA4cEd5UEd1eG45TXA1eWUwOWV0TTYw?=
 =?utf-8?B?bHB6c1ZtTW9MSngyVlZ1M1BJOWVQMXlaSzBlcU1nQjl2QnRDVjhML0FkbE9M?=
 =?utf-8?B?VGU1Q1ZhSUM4bDkrNDdndjJocXFZbFBWa2ZicGdmYU8rSXdEOUJwZC9sekI0?=
 =?utf-8?B?dWQ3WjNDQ1ZmTmwvR1RHK2pSa2w2eWtxeTVQUW5yVUlkQmJaNzdqT0xKZmRw?=
 =?utf-8?Q?6RoCb835?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d18fd42-043d-4c2b-f185-08dbd48eb0eb
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2023 12:42:32.3909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dA2XE2ti1aTVGJpJE4UX1JRL2fBBEB2Ff03x2iSR+3RWMKz2/8jn0wJucA20LqdDcF5NK0Y+DvyfuxfRj1+bIus+O/sqkszApw85AubmWCg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4896
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-24_11,2023-10-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 spamscore=0 malwarescore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310240108
X-Proofpoint-GUID: 7OJHUBpfC3jm7DmIsWry48M_01PtANjS
X-Proofpoint-ORIG-GUID: 7OJHUBpfC3jm7DmIsWry48M_01PtANjS
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/2023 13:34, Yi Liu wrote:
> On 2023/10/21 06:27, Joao Martins wrote:
>> IOMMU advertises Access/Dirty bits for second-stage page table if the
>> extended capability DMAR register reports it (ECAP, mnemonic ECAP.SSADS).
>> The first stage table is compatible with CPU page table thus A/D bits are
>> implicitly supported. Relevant Intel IOMMU SDM ref for first stage table
>> "3.6.2 Accessed, Extended Accessed, and Dirty Flags" and second stage table
>> "3.7.2 Accessed and Dirty Flags".
>>
>> First stage page table is enabled by default so it's allowed to set dirty
>> tracking and no control bits needed, it just returns 0. To use SSADS, set
>> bit 9 (SSADE) in the scalable-mode PASID table entry and flush the IOTLB
>> via pasid_flush_caches() following the manual. Relevant SDM refs:
>>
>> "3.7.2 Accessed and Dirty Flags"
>> "6.5.3.3 Guidance to Software for Invalidations,
>>   Table 23. Guidance to Software for Invalidations"
>>
>> PTE dirty bit is located in bit 9 and it's cached in the IOTLB so flush
>> IOTLB to make sure IOMMU attempts to set the dirty bit again. Note that
>> iommu_dirty_bitmap_record() will add the IOVA to iotlb_gather and thus the
>> caller of the iommu op will flush the IOTLB. Relevant manuals over the
>> hardware translation is chapter 6 with some special mention to:
>>
>> "6.2.3.1 Scalable-Mode PASID-Table Entry Programming Considerations"
>> "6.2.4 IOTLB"
>>
>> Select IOMMUFD_DRIVER only if IOMMUFD is enabled, given that IOMMU dirty
>> tracking requires IOMMUFD.
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>> ---
>>   drivers/iommu/intel/Kconfig |   1 +
>>   drivers/iommu/intel/iommu.c | 104 +++++++++++++++++++++++++++++++++-
>>   drivers/iommu/intel/iommu.h |  17 ++++++
>>   drivers/iommu/intel/pasid.c | 108 ++++++++++++++++++++++++++++++++++++
>>   drivers/iommu/intel/pasid.h |   4 ++
>>   5 files changed, 233 insertions(+), 1 deletion(-)
> 
> normally, the subject of commits to intel iommu driver is started
> with 'iommu/vt-d'. So if there is a new version, please rename it.
> Also, SL is a bit eld naming, please use SS (second stage)
> 
> s/iommu/intel: Access/Dirty bit support for SL domains/iommu/vt-d: Access/Dirty
> bit support for SS domains
> 
OK

>> diff --git a/drivers/iommu/intel/Kconfig b/drivers/iommu/intel/Kconfig
>> index 2e56bd79f589..f5348b80652b 100644
>> --- a/drivers/iommu/intel/Kconfig
>> +++ b/drivers/iommu/intel/Kconfig
>> @@ -15,6 +15,7 @@ config INTEL_IOMMU
>>       select DMA_OPS
>>       select IOMMU_API
>>       select IOMMU_IOVA
>> +    select IOMMUFD_DRIVER if IOMMUFD
>>       select NEED_DMA_MAP_STATE
>>       select DMAR_TABLE
>>       select SWIOTLB
>> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
>> index 017aed5813d8..d7ba1732130b 100644
>> --- a/drivers/iommu/intel/iommu.c
>> +++ b/drivers/iommu/intel/iommu.c
>> @@ -300,6 +300,7 @@ static int iommu_skip_te_disable;
>>   #define IDENTMAP_AZALIA        4
>>     const struct iommu_ops intel_iommu_ops;
>> +const struct iommu_dirty_ops intel_dirty_ops;
>>     static bool translation_pre_enabled(struct intel_iommu *iommu)
>>   {
>> @@ -4079,8 +4080,10 @@ intel_iommu_domain_alloc_user(struct device *dev, u32
>> flags)
>>   {
>>       struct iommu_domain *domain;
>>       struct intel_iommu *iommu;
>> +    bool dirty_tracking;
>>   -    if (flags & (~IOMMU_HWPT_ALLOC_NEST_PARENT))
>> +    if (flags & (~(IOMMU_HWPT_ALLOC_NEST_PARENT|
>> +               IOMMU_HWPT_ALLOC_DIRTY_TRACKING)))
>>           return ERR_PTR(-EOPNOTSUPP);
>>         iommu = device_to_iommu(dev, NULL, NULL);
>> @@ -4090,6 +4093,10 @@ intel_iommu_domain_alloc_user(struct device *dev, u32
>> flags)
>>       if ((flags & IOMMU_HWPT_ALLOC_NEST_PARENT) && !ecap_nest(iommu->ecap))
>>           return ERR_PTR(-EOPNOTSUPP);
>>   +    dirty_tracking = (flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING);
>> +    if (dirty_tracking && !slads_supported(iommu))
>> +        return ERR_PTR(-EOPNOTSUPP);
>> +
>>       /*
>>        * domain_alloc_user op needs to fully initialize a domain
>>        * before return, so uses iommu_domain_alloc() here for
>> @@ -4098,6 +4105,15 @@ intel_iommu_domain_alloc_user(struct device *dev, u32
>> flags)
>>       domain = iommu_domain_alloc(dev->bus);
>>       if (!domain)
>>           domain = ERR_PTR(-ENOMEM);
>> +
>> +    if (!IS_ERR(domain) && dirty_tracking) {
>> +        if (to_dmar_domain(domain)->use_first_level) {
>> +            iommu_domain_free(domain);
>> +            return ERR_PTR(-EOPNOTSUPP);
>> +        }
>> +        domain->dirty_ops = &intel_dirty_ops;
>> +    }
>> +
>>       return domain;
>>   }
>>   @@ -4121,6 +4137,9 @@ static int prepare_domain_attach_device(struct
>> iommu_domain *domain,
>>       if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
>>           return -EINVAL;
>>   +    if (domain->dirty_ops && !slads_supported(iommu))
>> +        return -EINVAL;
>> +
>>       /* check if this iommu agaw is sufficient for max mapped address */
>>       addr_width = agaw_to_width(iommu->agaw);
>>       if (addr_width > cap_mgaw(iommu->cap))
>> @@ -4375,6 +4394,8 @@ static bool intel_iommu_capable(struct device *dev, enum
>> iommu_cap cap)
>>           return dmar_platform_optin();
>>       case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
>>           return ecap_sc_support(info->iommu->ecap);
>> +    case IOMMU_CAP_DIRTY_TRACKING:
>> +        return slads_supported(info->iommu);
>>       default:
>>           return false;
>>       }
>> @@ -4772,6 +4793,9 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain
>> *domain,
>>       if (!pasid_supported(iommu) || dev_is_real_dma_subdevice(dev))
>>           return -EOPNOTSUPP;
>>   +    if (domain->dirty_ops)
>> +        return -EINVAL;
>> +
>>       if (context_copied(iommu, info->bus, info->devfn))
>>           return -EBUSY;
>>   @@ -4830,6 +4854,84 @@ static void *intel_iommu_hw_info(struct device *dev,
>> u32 *length, u32 *type)
>>       return vtd;
>>   }
>>   +static int intel_iommu_set_dirty_tracking(struct iommu_domain *domain,
>> +                      bool enable)
>> +{
>> +    struct dmar_domain *dmar_domain = to_dmar_domain(domain);
>> +    struct device_domain_info *info;
>> +    int ret;
>> +
>> +    spin_lock(&dmar_domain->lock);
>> +    if (dmar_domain->dirty_tracking == enable)
>> +        goto out_unlock;
>> +
>> +    list_for_each_entry(info, &dmar_domain->devices, link) {
>> +        ret = intel_pasid_setup_dirty_tracking(info->iommu, info->domain,
>> +                             info->dev, IOMMU_NO_PASID,
>> +                             enable);
>> +        if (ret)
>> +            goto err_unwind;
>> +
>> +    }
>> +
>> +    dmar_domain->dirty_tracking = enable;
>> +out_unlock:
>> +    spin_unlock(&dmar_domain->lock);
>> +
>> +    return 0;
>> +
>> +err_unwind:
>> +    list_for_each_entry(info, &dmar_domain->devices, link)
>> +        intel_pasid_setup_dirty_tracking(info->iommu, dmar_domain,
>> +                      info->dev, IOMMU_NO_PASID,
>> +                      dmar_domain->dirty_tracking);
>> +    spin_unlock(&dmar_domain->lock);
>> +    return ret;
>> +}
>> +
>> +static int intel_iommu_read_and_clear_dirty(struct iommu_domain *domain,
>> +                        unsigned long iova, size_t size,
>> +                        unsigned long flags,
>> +                        struct iommu_dirty_bitmap *dirty)
>> +{
>> +    struct dmar_domain *dmar_domain = to_dmar_domain(domain);
>> +    unsigned long end = iova + size - 1;
>> +    unsigned long pgsize;
>> +
>> +    /*
>> +     * IOMMUFD core calls into a dirty tracking disabled domain without an
>> +     * IOVA bitmap set in order to clean dirty bits in all PTEs that might
>> +     * have occurred when we stopped dirty tracking. This ensures that we
>> +     * never inherit dirtied bits from a previous cycle.
>> +     */
>> +    if (!dmar_domain->dirty_tracking && dirty->bitmap)
>> +        return -EINVAL;
>> +
>> +    do {
>> +        struct dma_pte *pte;
>> +        int lvl = 0;
>> +
>> +        pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &lvl,
>> +                     GFP_ATOMIC);
>> +        pgsize = level_size(lvl) << VTD_PAGE_SHIFT;
>> +        if (!pte || !dma_pte_present(pte)) {
>> +            iova += pgsize;
>> +            continue;
>> +        }
>> +
>> +        if (dma_sl_pte_test_and_clear_dirty(pte, flags))
>> +            iommu_dirty_bitmap_record(dirty, iova, pgsize);
>> +        iova += pgsize;
>> +    } while (iova < end);
>> +
>> +    return 0;
>> +}
>> +
>> +const struct iommu_dirty_ops intel_dirty_ops = {
>> +    .set_dirty_tracking    = intel_iommu_set_dirty_tracking,
>> +    .read_and_clear_dirty   = intel_iommu_read_and_clear_dirty,
>> +};
>> +
>>   const struct iommu_ops intel_iommu_ops = {
>>       .capable        = intel_iommu_capable,
>>       .hw_info        = intel_iommu_hw_info,
>> diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
>> index c18fb699c87a..27bcfd3bacdd 100644
>> --- a/drivers/iommu/intel/iommu.h
>> +++ b/drivers/iommu/intel/iommu.h
>> @@ -48,6 +48,9 @@
>>   #define DMA_FL_PTE_DIRTY    BIT_ULL(6)
>>   #define DMA_FL_PTE_XD        BIT_ULL(63)
>>   +#define DMA_SL_PTE_DIRTY_BIT    9
>> +#define DMA_SL_PTE_DIRTY    BIT_ULL(DMA_SL_PTE_DIRTY_BIT)
>> +
>>   #define ADDR_WIDTH_5LEVEL    (57)
>>   #define ADDR_WIDTH_4LEVEL    (48)
>>   @@ -539,6 +542,9 @@ enum {
>>   #define sm_supported(iommu)    (intel_iommu_sm && ecap_smts((iommu)->ecap))
>>   #define pasid_supported(iommu)    (sm_supported(iommu) &&            \
>>                    ecap_pasid((iommu)->ecap))
>> +#define slads_supported(iommu) (sm_supported(iommu) &&                 \
> 
> how about ssads_supporte.
> 
I've changed it

>> +                ecap_slads((iommu)->ecap))
>> +
> 
> remove this empty line.
>
OK

>>     struct pasid_entry;
>>   struct pasid_state_entry;
> 
> Regards,
> Yi Liu
> 
>> @@ -592,6 +598,7 @@ struct dmar_domain {
>>                        * otherwise, goes through the second
>>                        * level.
>>                        */
>> +    u8 dirty_tracking:1;        /* Dirty tracking is enabled */
>>         spinlock_t lock;        /* Protect device tracking lists */
>>       struct list_head devices;    /* all devices' list */
>> @@ -781,6 +788,16 @@ static inline bool dma_pte_present(struct dma_pte *pte)
>>       return (pte->val & 3) != 0;
>>   }
>>   +static inline bool dma_sl_pte_test_and_clear_dirty(struct dma_pte *pte,
>> +                           unsigned long flags)
>> +{
>> +    if (flags & IOMMU_DIRTY_NO_CLEAR)
>> +        return (pte->val & DMA_SL_PTE_DIRTY) != 0;
>> +
>> +    return test_and_clear_bit(DMA_SL_PTE_DIRTY_BIT,
>> +                  (unsigned long *)&pte->val);
>> +}
>> +
>>   static inline bool dma_pte_superpage(struct dma_pte *pte)
>>   {
>>       return (pte->val & DMA_PTE_LARGE_PAGE);
>> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
>> index 8f92b92f3d2a..9a01d46a56e1 100644
>> --- a/drivers/iommu/intel/pasid.c
>> +++ b/drivers/iommu/intel/pasid.c
>> @@ -277,6 +277,11 @@ static inline void pasid_set_bits(u64 *ptr, u64 mask, u64
>> bits)
>>       WRITE_ONCE(*ptr, (old & ~mask) | bits);
>>   }
>>   +static inline u64 pasid_get_bits(u64 *ptr)
>> +{
>> +    return READ_ONCE(*ptr);
>> +}
>> +
>>   /*
>>    * Setup the DID(Domain Identifier) field (Bit 64~79) of scalable mode
>>    * PASID entry.
>> @@ -335,6 +340,36 @@ static inline void pasid_set_fault_enable(struct
>> pasid_entry *pe)
>>       pasid_set_bits(&pe->val[0], 1 << 1, 0);
>>   }
>>   +/*
>> + * Enable second level A/D bits by setting the SLADE (Second Level
>> + * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
>> + * entry.
>> + */
>> +static inline void pasid_set_ssade(struct pasid_entry *pe)
>> +{
>> +    pasid_set_bits(&pe->val[0], 1 << 9, 1 << 9);
>> +}
>> +
>> +/*
>> + * Disable second level A/D bits by clearing the SLADE (Second Level
>> + * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
>> + * entry.
>> + */
>> +static inline void pasid_clear_ssade(struct pasid_entry *pe)
>> +{
>> +    pasid_set_bits(&pe->val[0], 1 << 9, 0);
>> +}
>> +
>> +/*
>> + * Checks if second level A/D bits specifically the SLADE (Second Level
>> + * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
>> + * entry is set.
>> + */
>> +static inline bool pasid_get_ssade(struct pasid_entry *pe)
>> +{
>> +    return pasid_get_bits(&pe->val[0]) & (1 << 9);
>> +}
>> +
>>   /*
>>    * Setup the WPE(Write Protect Enable) field (Bit 132) of a
>>    * scalable mode PASID entry.
>> @@ -627,6 +662,8 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
>>       pasid_set_translation_type(pte, PASID_ENTRY_PGTT_SL_ONLY);
>>       pasid_set_fault_enable(pte);
>>       pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
>> +    if (domain->dirty_tracking)
>> +        pasid_set_ssade(pte);
>>         pasid_set_present(pte);
>>       spin_unlock(&iommu->lock);
>> @@ -636,6 +673,77 @@ int intel_pasid_setup_second_level(struct intel_iommu
>> *iommu,
>>       return 0;
>>   }
>>   +/*
>> + * Set up dirty tracking on a second only or nested translation type.
>> + */
>> +int intel_pasid_setup_dirty_tracking(struct intel_iommu *iommu,
>> +                     struct dmar_domain *domain,
>> +                     struct device *dev, u32 pasid,
>> +                     bool enabled)
>> +{
>> +    struct pasid_entry *pte;
>> +    u16 did, pgtt;
>> +
>> +    spin_lock(&iommu->lock);
>> +
>> +    pte = intel_pasid_get_entry(dev, pasid);
>> +    if (!pte) {
>> +        spin_unlock(&iommu->lock);
>> +        dev_err_ratelimited(dev,
>> +                    "Failed to get pasid entry of PASID %d\n",
>> +                    pasid);
>> +        return -ENODEV;
>> +    }
>> +
>> +    did = domain_id_iommu(domain, iommu);
>> +    pgtt = pasid_pte_get_pgtt(pte);
>> +    if (pgtt != PASID_ENTRY_PGTT_SL_ONLY && pgtt != PASID_ENTRY_PGTT_NESTED) {
>> +        spin_unlock(&iommu->lock);
>> +        dev_err_ratelimited(dev,
>> +                    "Dirty tracking not supported on translation type %d\n",
>> +                    pgtt);
>> +        return -EOPNOTSUPP;
>> +    }
>> +
>> +    if (pasid_get_ssade(pte) == enabled) {
>> +        spin_unlock(&iommu->lock);
>> +        return 0;
>> +    }
>> +
>> +    if (enabled)
>> +        pasid_set_ssade(pte);
>> +    else
>> +        pasid_clear_ssade(pte);
>> +    spin_unlock(&iommu->lock);
>> +
>> +    if (!ecap_coherent(iommu->ecap))
>> +        clflush_cache_range(pte, sizeof(*pte));
>> +
>> +    /*
>> +     * From VT-d spec table 25 "Guidance to Software for Invalidations":
>> +     *
>> +     * - PASID-selective-within-Domain PASID-cache invalidation
>> +     *   If (PGTT=SS or Nested)
>> +     *    - Domain-selective IOTLB invalidation
>> +     *   Else
>> +     *    - PASID-selective PASID-based IOTLB invalidation
>> +     * - If (pasid is RID_PASID)
>> +     *    - Global Device-TLB invalidation to affected functions
>> +     *   Else
>> +     *    - PASID-based Device-TLB invalidation (with S=1 and
>> +     *      Addr[63:12]=0x7FFFFFFF_FFFFF) to affected functions
>> +     */
>> +    pasid_cache_invalidation_with_pasid(iommu, did, pasid);
>> +
>> +    iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
>> +
>> +    /* Device IOTLB doesn't need to be flushed in caching mode. */
>> +    if (!cap_caching_mode(iommu->cap))
>> +        devtlb_invalidation_with_pasid(iommu, dev, pasid);
>> +
>> +    return 0;
>> +}
>> +
>>   /*
>>    * Set up the scalable mode pasid entry for passthrough translation type.
>>    */
>> diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
>> index 4e9e68c3c388..958050b093aa 100644
>> --- a/drivers/iommu/intel/pasid.h
>> +++ b/drivers/iommu/intel/pasid.h
>> @@ -106,6 +106,10 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
>>   int intel_pasid_setup_second_level(struct intel_iommu *iommu,
>>                      struct dmar_domain *domain,
>>                      struct device *dev, u32 pasid);
>> +int intel_pasid_setup_dirty_tracking(struct intel_iommu *iommu,
>> +                     struct dmar_domain *domain,
>> +                     struct device *dev, u32 pasid,
>> +                     bool enabled);
>>   int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
>>                      struct dmar_domain *domain,
>>                      struct device *dev, u32 pasid)
