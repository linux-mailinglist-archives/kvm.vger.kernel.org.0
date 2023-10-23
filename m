Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3227D3F06
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 20:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbjJWSVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 14:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbjJWSVJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 14:21:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7478410A
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 11:21:02 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39NI0GMm021493;
        Mon, 23 Oct 2023 18:20:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=0tryJjvSriVQ2zGG7dwJQjo2/iU1IcOE5tiZrNtIF/0=;
 b=jGJ19TyiZEZFfxFALd9glwJ+epzjJsudNo0kocaZcDO2S6sMJ802uNxvnf8wSlndnnQJ
 zsQsnfvyX5wwJ10VEoVUcekNPAjxyVGtWoYeZdmJrvQBk6x/b0iSm3wNAz1UXg5+C+S+
 ml0/H/aJKpTa7NcSL/yJWpfVLZjMa5jgtB1rR26yCoxKyA1grp73c0g8BqY3VbgNuiRk
 iugP4AGfu/nWel4UmEymNUl6sNRdeqjPgvZVAjo21Xs2dUPUww+dPHeKhwruxp7tX3ZJ
 JF35T3l+l/xKuQPgRmXDR67ZIvCtL011UbhWHYTAKbF1gkiq+aaEHH3ZUD9BdOOn7kO4 3w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv581ks7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 18:20:36 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39NHCpLL001577;
        Mon, 23 Oct 2023 18:20:34 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tv53at9m1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 18:20:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MWmn8LP3RxeJo9ZZ7yfp3zxlL/S3WS2dMTHmon3EJY1BYAvwAI6j1b/M/RfjlbLx6LIrySSpK5dlcc1+kdMIvseqfbLbKOteTQIOHuyZckF3PSMHs/gD3VOsrQKbcY0pDCvaRsF2OY/oagebS4sq1dhi76deA0dusY527Qff0BaFAjcoYwAMWReB5MZ3xCwAGiO3CePAGjTizfO9kHpZsi7SZsNOtOfHbq2mHKYp8XYCIgYkgDtf9uMwb76iVGkKKzJgBtEQc35Nu7JKDP7ZlYFgM9qmarIZS9Kg0hlj1PovEFQ5RZ7X0r7J2m/3K2bCHATFDnIkFTDYuT/VX5xr8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0tryJjvSriVQ2zGG7dwJQjo2/iU1IcOE5tiZrNtIF/0=;
 b=Yo+myer0FJO8V7pLMIKKtTD82a7UID/PanGDyAp/lGFJ07UGE7afL+sAH2tSEvnXZ2YB9XaSb8IGexA4ODv/yx7LcSmSEL+PAG1B6lLrZNXJLGg0Z2+cMAYIHVnyLgYAVgl3IGWkyg6O7jqDx8r/ewc+fTtPK3kNfVzhiVtv9ULuxI7h2a007hqqX2fPRqTq4jRjYrYrds2IimC6L5MKuGfCO+KUCAra4/AMXfc7EE4gM5pxNNNfrqh9o2ZkwVMn75P+2xY3gpdrlKyTaVHdrt9KOCCdIl/hLwgG+eecMb4hj7egDaF/yp3Q6iFs6IBw/rexXZCQZtF3e9UVJRTdKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0tryJjvSriVQ2zGG7dwJQjo2/iU1IcOE5tiZrNtIF/0=;
 b=e9BaxegBjKK/V69a1RLVz7zruNTmwELQE3XF6u4VNoIAUPwVlcnJSvS//5AnRQeF73VoG4673qe5QBroJLZHiNeJA2Ab+Z1hvMT3aSlvVJLSIrmddIk2OaIh2mzzTCXP71jyXJNqIAm9ae4fOjSCI5+ffVcQ1S4/d+ru6TcQb7s=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SA2PR10MB4731.namprd10.prod.outlook.com (2603:10b6:806:11e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Mon, 23 Oct
 2023 18:20:32 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac%3]) with mapi id 15.20.6907.032; Mon, 23 Oct 2023
 18:20:32 +0000
Message-ID: <0c6f392e-facd-4259-8286-443dfbbcf221@oracle.com>
Date:   Mon, 23 Oct 2023 19:20:26 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/18] IOMMUFD Dirty Tracking
Content-Language: en-US
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
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
 <20231021162321.GK3952@nvidia.com> <ZTXOJGKefAwH70M4@Asurada-Nvidia>
 <4e7c8e8d-f22d-40e8-ad41-1e334bb78496@oracle.com>
 <ZTa2uRBLt4EcZKVP@Asurada-Nvidia>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <ZTa2uRBLt4EcZKVP@Asurada-Nvidia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0367.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SA2PR10MB4731:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f1de34f-65a9-4342-da0e-08dbd3f4be0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4DQUP1WxCJ/CMiDSYfGA+05ElTUdIt/t0eO9X09ptycepw/Hiqb3qMBOUeye2p11qxV4JwMwUiXXM/hNRRq2atT0fo45pcL/ViZ226+O79QLO/p0FZZtdNWsRmXHVkavB7yXk/Bq//113UCkS4RIk1DLENu2w2nu6IL0aA9i80lWZTcYUuBRjREVX5YfsQXqD9zBjKQm9KIi7fGE0o5p6T6whsiq4qyLDo2jHmnIZdMmoYklVnffOUYQX7Br+N3BhL9AOedEi+hPurYYF0LINKD2snp9nR8UT27+u0GYTVFwUKLOpD/SDcKE8vWyN3lWUQV9r9TIossuHyrEuDsANqpbvDGmfgIYKH9Ria4wG8WNzXtLvGru7zDQWSsEGIlH51l2i6ad5ciZflkIvFHWIv8VGymGnv/q8aADY/orhM73xkEa6QEGjwZ+LYKXezOkPXn9v6FWfiHSxWBDnBskXt23a8NSsNnC0sexoXFFXPEN9Alx0+PHrcsdEjr86ZbtJGy1Rhxpe1aX5S5swKevJt7P3qto9WQO+kYEj855joAhGU4xd10VpLS1UeRIfd6RZWig4o7KnqotqRQgLatg7kAeUM+vP8KWBmbwVTmsgRQdCIjoTb3I29YhS6R3gxFfjNTkdq18yBqd7LHenDtBEpFqbBlItXrVdjK8XOSii2A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(346002)(136003)(376002)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(86362001)(2906002)(66556008)(2616005)(316002)(66476007)(54906003)(6916009)(66946007)(38100700002)(478600001)(6506007)(53546011)(6486002)(6666004)(83380400001)(6512007)(41300700001)(31696002)(36756003)(5660300002)(7416002)(4326008)(8676002)(8936002)(26005)(31686004)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHZLOUpiRmVCdDQyREdiQzY2UnRSeDc3ZDJlemR1MEVzYUs4bFhFbGIxU0dY?=
 =?utf-8?B?TlN1eHhoQmhIc1hZb3BzNERvVmNobFVMeWlGZTlsTk0xR1NOeVdROFppOENN?=
 =?utf-8?B?TU1sZE91V0FBa3VuY1haSlQ5TXpaSHYrM0FwcFpNb1FlNDhTOGVjZXJDdGRo?=
 =?utf-8?B?UmN4OWNtRTdkMzRReUlRdjJrblJSSmpMSExOSzAyVzNDSUFqY3oxSEl5bmU5?=
 =?utf-8?B?VWNaQVZYamVnTUxJSGZPREVvRnp5b2cxLzN2TVRCVldTUGZLOEhoaVhqVFJv?=
 =?utf-8?B?UkNheUV0TkRwQWNTKzR3bkJWVzNvNjFrRzRxV3BxM1g0TUEzSG01U0lkVVpx?=
 =?utf-8?B?OHlqVytWMFBwYzRBZlhkUklHTStIVEdDNlVjeGRlUVFhekFwR2MvK0w1dVVm?=
 =?utf-8?B?cHBHOVZXWGNsZnlGQ1I0TGRDaWtxOGU3clYvMW5mRFVGOFpRbFZiUWd4YVlQ?=
 =?utf-8?B?d0NzelQ5cm5vUmRDeC9ZSkNDMy9NSEFUYWUwVEhuUkVMMHdUV2VkOWk5N2dH?=
 =?utf-8?B?MHZGZGJHU2lzQUxlWmE4NmNlM3VGbUpBM1MyWStlZkplcXZ6L3E3NXVyejNT?=
 =?utf-8?B?SEhwQzU1WUF5UDJsZ0RpM0daOTRGcFJKZVo5SzhITlF0b1hzd3d0QmxjYkE4?=
 =?utf-8?B?V0ZGNStMQ2RxZ3pKY2NwbHNDdTRHcFNJUUZnS1VWRTNuaGo1OTEyVlNwUE5M?=
 =?utf-8?B?b0tVRTM1c3dyWDNuSkhxTzBQaVpUU2t4Wk41LzNNZzZLaGZVWFhNTGtwZXJD?=
 =?utf-8?B?QUEwZnprWWJQVjdzQXJkbXZXMU5Pb1JRSE9xN2hjaFJrYW9tYk5NYS9HNGRY?=
 =?utf-8?B?WHJ2NG5SKzBMU0krYXlBd0ZKcDByb3dUNGdKRmI2N3ZKaXlWZk1CNXdKN3lG?=
 =?utf-8?B?UjRNQ1RTUWw2TVZLdUpOMVJ2TEE4RGVNY25kdkk3L3ZrbUxFZFZsdUd1NE1y?=
 =?utf-8?B?T2kzbkFjRzVqZXE1c3QwTXN1K2hLMktlaHhYNjNlbWMrYklJTW9MSFpFM3Zq?=
 =?utf-8?B?UHRXOHczR2k1N0JySWQ5RjJHTGZsRXhBQWtiUHVzVjJ5dDFxZzhQUGcraEZP?=
 =?utf-8?B?czVTS1RXY1FjSWlJaXcyNVJ2ZmZjcmhGSTl5eEl3VUFHeXpkR21vMkFlam9q?=
 =?utf-8?B?L1lMN0hiQ0lLdmd5NldtSDkvYitHLzA2SFU3TTFjdUlyYzA1T3B6bG0veXd3?=
 =?utf-8?B?d2hZR0I4cExCTzl4bmp6ZThycEJSd3FkSzJYS3dVRytoZUlDQjdaZmRBalVX?=
 =?utf-8?B?ZzFZMXYzN2x3bWFlMm1abmRvYnlGd0Q4YUI2aVhqVi9GNkNQTUJaUnZ3cjZW?=
 =?utf-8?B?b0pmZlMrSGFaa0FYMW81N3UzR1BkOTlVU0VDVDZ3NVZyUVM1UVFrcmlwQUtj?=
 =?utf-8?B?Y3RPd2NWOGh3MzhRK0FsVUNvdUdvL0hJVktxWm51K1lhS3MzVXFneWk2RGFJ?=
 =?utf-8?B?NjdmSWhXY2h3aThNYTFuNmZ2OGJtZG5XZnFOZG1zMHV1T2dQNFhML2VNYUkw?=
 =?utf-8?B?dHhXVEYvU21ma1RvWFBBcFNQRkRHanJ5UXFOOVZhRmpGOWxtV0o5RGowdVNS?=
 =?utf-8?B?bFlBRkxIVTc2U1FvL0tYNW9YbXhnUUw4QWYxd08yeDB5eVZPSHIrWUlmOFRH?=
 =?utf-8?B?WWhZNnZQc3VKd1Bqa1dzby9pczBzZFMvSHNWWmFQNzVYU2JONW1mSHc2YmNW?=
 =?utf-8?B?RjRXOERHb21ub1EyMzdHTXZ3c3NJMnp2L3d6K2FlemQ2c0R0a09mVHdZWDgw?=
 =?utf-8?B?Ti9aSXczbExLZDUvK2hRK3JORXV0Z0ZvUXFDZWNKdUtiYlViSWdRaWdWR3Q1?=
 =?utf-8?B?eWpVUmNpR0JUbG43Q2V1eVVZWmdTVDc2Z0p6SEczV1hYQXFaQXZQdll0MURC?=
 =?utf-8?B?TEEzZ3pLRnpjOFM4Y1Z4ZjZScXB2Y3EzMmx6UDJ6cnFNSjd4Yk9WQk1uS1ZK?=
 =?utf-8?B?M0h1R1p6QVdQR3dWNWgxTVA1bjZGbkthMkVMUEY0NWE3K0R3RHFEdHlYUnBi?=
 =?utf-8?B?dzV4U3ZGTUQ1RGsrQTJBQm1NOXVDNCs0Ry9kWEQ4ZWI2Z2hTQU5RMVU1ZDBP?=
 =?utf-8?B?dFVYdXp0dW95V0pxWTEwQVhYODdSWXlCUU1oWURHN2ZWRmw0T3hFQVNDOHdj?=
 =?utf-8?B?L241a3lzTU9vVEFHU2hKa2pROVI4L1F3WjFqK0hpUnRYbzBVOG5lQ0twRHM4?=
 =?utf-8?B?YVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?bWhOQXdpRVFIWWNnckgxTlMzSDIwSmVUdkpsWlhyNjU4dlNlMmowNU5LUkdR?=
 =?utf-8?B?QnA4QjVRVUt3Ymg4QzZNaW96SU1sc0dHbmpPd05mS1ZBczRiOUNaOGRVRGFX?=
 =?utf-8?B?aGhBNzBDQjRNeVJZRmhxbzdENXRuUUZtNXoxMDVvSmtyNkprK3VVRkRQVWN0?=
 =?utf-8?B?WEpreVhuT1g2UXNRN0p5WlZNdEdxTTloeld5b2VadFRnY2NWWHcyN2EvaVdv?=
 =?utf-8?B?SDQvamF2MGZSa245MWVWbW94QXc0OWd4Sk81bzVOT2dJQmkwYzRZZlFkRi8z?=
 =?utf-8?B?Rk5FOHVPNEFDZ1FDM01Na0lnVVIzZnE3ZWV6cXpEYmdJUDZLVjg1cWI1TE00?=
 =?utf-8?B?TjFnYlVJUU9kNmZ5WjhLUTFoSDhNQ2hSWEVSanZ3Uko0bUdkUnNWWGlrRWNU?=
 =?utf-8?B?dW9UTWZxODFobUF4TFhHYUt1R2wrVnRlQUExVS9CTG1XckdKT3dLM2svaUNk?=
 =?utf-8?B?S25ZRjI4eThMdnZHbS9NMWc2Yi8vbkRRU2ZqRzIwR0oyZ015Nlp1aU9PQWRo?=
 =?utf-8?B?dGVjNDJBVlVKaDZsM0J4YXVSeXpQN3NZbVJBd3ZKa0lDeklZOTRZTTJOQTc5?=
 =?utf-8?B?dC8xUlNCNXJBMlZ5bFhsRWthM0hjT0ZsTFJaTjl1cEpRWVIva1NRZUNQcUtz?=
 =?utf-8?B?K2JhMS9KUDRqSjIwWTB5b2ZJR0FCWThzdFRKZXJ6R012UmtGeGtwK2kvOHc3?=
 =?utf-8?B?QXcyNFIrMHphcnNRakR5UnB3Z1JhTkEvUDJPNUx3Q1VxcEtJdkxyNHdla2dL?=
 =?utf-8?B?WjV2SlBoN0RwMXU3Z3c1aEN1QWZ5Z0NFekgydGQ2MXFEamEvM3hpUnk1dDdB?=
 =?utf-8?B?c01zTmYvS044WTBTcmtsemxmU1dNNmhEdC82enhwdU5PUDlXVVJwU3VsSEJN?=
 =?utf-8?B?blVMVkJHajZnMFh6OGF4T2hCWjFxZ3d2RXVDS1FMUmVXenBIS2tvYzBVa0dO?=
 =?utf-8?B?dmVyZDJMbS9aRy8xVDlnVXVXV1d0T1pDZjJKMUx0cHA2NFFIdzJxbndtSXpY?=
 =?utf-8?B?cnAyMVB0TEJsM2dqZUY4N0k3a0ZqbEs1OVdnTXJoRW1DcHRMQjhuUDRkcWRj?=
 =?utf-8?B?MUpKVWRzWVBSbmlxVHZuQTMzWDVzdUk4enRaSlZKS1UyRFd2MjlGUUJFTE1x?=
 =?utf-8?B?MlV6UUNRVTNLWDZqK2xEbjJHL0crcjBUdk9oRmsxNGVNWXc0RlkxN2pxNVh5?=
 =?utf-8?B?M05tTDlTS0xuYlU5eHlOT3RjYWNqNHg1bDBLUGJIblFqZjRRT1hsSDBYRlYr?=
 =?utf-8?B?Mm5HeEdCZ2Q5ZnVTMVBmVFVkY2hQZFY1NExMRDhVbDdaUHB3bk1HcUowV2tB?=
 =?utf-8?B?SE9vZXNGdjZlaDhMelBaSk9OSUNjTVVFcDd2YUZ3MGxJTzR3WlNVRVZ3aTFF?=
 =?utf-8?B?NjdXMGlBcWYzc2RyNlJHYXFHMndUaUxMM1l4dTNxR2x2ZjFWaUwxZTc3MFBw?=
 =?utf-8?Q?JQ3qHUsV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f1de34f-65a9-4342-da0e-08dbd3f4be0e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 18:20:31.9314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jsRWlGmRljGnou74LEHvr9pMjfJvES7CjPc//O4jArkukIgHU2PsKlmNofa0FTTkaJxpP5BpeHuxc/ATqah2U8TIwi12ft8lw7/z5iilIks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4731
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-23_17,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310230160
X-Proofpoint-GUID: 5KRVbF3ATlKqE1wDY88tifN1_N6hNfnd
X-Proofpoint-ORIG-GUID: 5KRVbF3ATlKqE1wDY88tifN1_N6hNfnd
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/10/2023 19:10, Nicolin Chen wrote:
> On Mon, Oct 23, 2023 at 10:15:24AM +0100, Joao Martins wrote:
> 
>> It comes from the GET_DIRTY_BITMAP selftest ("iommufd/selftest: Test
>> IOMMU_HWPT_GET_DIRTY_BITMAP") because I use test_bit/set_bit/BITS_PER_BYTE in
>> bitmap validation to make sure all the bits are set/unset as expected. I think
>> some time ago I had an issue on my environment that the selftests didn't build
>> in-tree with the kernel unless it has the kernel headers installed in the
>> system/path (between before/after commit 0d7a91678aaa ("selftests: iommu: Use
>> installed kernel headers search path")) so I was mistakenly using:
>>
>> CFLAGS="-I../../../../tools/include/ -I../../../../include/uapi/
>> -I../../../../include/"
>>
>> Just for the iommufd selftests, to replace what was prior to the commit plus
>> `tools/include`:
>>
>> diff --git a/tools/testing/selftests/iommu/Makefile
>> b/tools/testing/selftests/iommu/Makefile
>> index 7cb74d26f141..32c5fdfd0eef 100644
>> --- a/tools/testing/selftests/iommu/Makefile
>> +++ b/tools/testing/selftests/iommu/Makefile
>> @@ -1,7 +1,6 @@
>>  # SPDX-License-Identifier: GPL-2.0-only
>>  CFLAGS += -Wall -O2 -Wno-unused-function
>> -CFLAGS += -I../../../../include/uapi/
>> -CFLAGS += -I../../../../include/
>> +CFLAGS += $(KHDR_INCLUDES)
> 
> You'd need to run "make headers" before building the test.
> 

Eventually I noticed (some time ago), I just didn't undo the scripting

>> ... Which is what is masking your reported build problem for me.
>> [The tests will build and run fine though once having the above]
>>
>> The usage of non UAPI kernel headers in selftests isn't unprecedented as I
>> understand (if you grep for 'linux/bitmap.h') you will see a whole bunch. But
>> maybe it isn't supposed to be used. Nonetheless the brokeness assumption was on
>> my environment, and I have fixed up the environment now. Except for the above
>> that you are reporting
> 
> Selftest is a user space program, so only uapi headers are
> allowed 

But OTOH selftests are in-tree and meant to exercise kernel code, so tieing them
up could make sense.

> unless you could find similar helpers in a library.
> 
Not in a library, but radix-tree, kvm selftests and nfit (NVDIMM) seem to use
similar non-uapi header (just talking about bitmap/bitops) more could be used.
But it still doesn't make it OK nonetheless and it's not even worth starting a
precedent in these selftests for no good reason.

>> Perhaps the simpler change is to just import those two functions into the
>> iommufd_util.h, since the selftest doesn't require any other non-UAPI headers. I
>> have also had a couple more warnings/issues (in other patches), so I will need a
>> v6 address to address everything.
> 
> Yea, thanks
> Nic
