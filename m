Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768227CB19D
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 19:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbjJPRxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 13:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbjJPRxe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 13:53:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02FEA2
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 10:53:31 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39GGwqV9010058;
        Mon, 16 Oct 2023 17:53:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=1W8X5HaXoQ5jQGRX+7IVI4dK8lFBwOMrlV7TqOfupH8=;
 b=QDCVUEMUh0AZTrfHBRXmbC9HNa78XZZAgwQ+WfT1Q9N3qL5VR5um7rDt3HivbzZySHCq
 ujumRXSkvJW8lwJbQcnz0f4DwPxhqK+gJMzs/J7RE7X2XTtBkqWDCK1ToNTf6vPx7w2i
 mNAH7hZ4Zz3yymRJZ2Flnxc8Cl419xDotLK9WOXVxiIa7K/Y+cXCxe8IpfgVC5tpO1sO
 CUo1VacXfX2O+18rHTtbc2neuMfxy19u9YEfdc9Et/VmRcPt/Z+0DqcKYz/seEjOx2WE
 xalYYojU/6FCLzyu4lcUXWWqURzhAdh7zTAAPxMElkUtlVqxrvjVvPSLX0fB2NQVztXm OQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1cbeae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 17:52:59 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39GGnONt021695;
        Mon, 16 Oct 2023 17:52:58 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg4yxdcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 17:52:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jfYAd+EChoRhymaLImGfq5ZwSwvfe9j7kE+Tf6t5U4/EfOsAIqz6x9o8ZzSA2+Wy4uwvbU6WVM7Y0VOLjMLE9Ejh67WnqyfYPzEm+zMDkno1Yh5aACcaoPYZhLEriJqJsALznAO6c66V4dlm1h7FGqW4vU2RfWckCUunwsAFQHxWMuBVwBtKKfyRP5C8Tzs0s3zu5sfh7M2VVTF153Wu7ujAlXV0FxAPX/tgWLB8j46vQpKQsMptt/JEPes/REEneHYnp9DOhH6Psy4U3UrXULgocIHKvhzn4scdlOoCzBJc1VCu5e+Pus6bIOCpA3aYGoA3BPyfiFuLVdJ5CTFOVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1W8X5HaXoQ5jQGRX+7IVI4dK8lFBwOMrlV7TqOfupH8=;
 b=dJBUT8CxFJhCODarXkKYVn0KqekMDgtCtJGdF7qFFn6j/1oNadJxZ5lWGnTG7Vr+XopdGa1tRVIuQW9EwFz4cdHj1NVia0ExPDa+LF1uwuS3dY3/Ifmvttv9q1pXikKgye0pj3hx1kpkRQPplSmGJpWkpOx3MsNEt3T8xj6q/sLk2AwxQ5LUDMFt+s+Ms4i57NgkQz7Bakz6i8iqE+IDq2iMdDo4ZKAZ/Dz46YS7wBlpR51yIQMMslVRdiZapZAcwmhCBuVuMzmqDITSjw74fJSBlRg+peP48vo6BzCcW+Wo26v+wfBnZMQ5auKXUqAV5beztVv2U1xivQZcjosWKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1W8X5HaXoQ5jQGRX+7IVI4dK8lFBwOMrlV7TqOfupH8=;
 b=CzD9LqmV3pxQhh1TVvNNkE9ngLwY01SngAbKOPM6SaQTq4kZCSe7/FzauDXQ3F1Thh8Cco7TzH385Yy4Dv1eMDdc543su4l2LmL9SMJVSVa6QQ4aiOrcbCdzi97JgTbj5iicdJ4KOKGKwIdxW5IoAYn0jxfsfWiMCmo/i1NNTCs=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by PH8PR10MB6409.namprd10.prod.outlook.com (2603:10b6:510:1c4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Mon, 16 Oct
 2023 17:52:56 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.034; Mon, 16 Oct 2023
 17:52:56 +0000
Message-ID: <8a13a2e5-9bc1-4aeb-ad39-657ee95d5a21@oracle.com>
Date:   Mon, 16 Oct 2023 18:52:50 +0100
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
References: <20231013154821.GX3952@nvidia.com>
 <8a70e930-b0ef-4495-9c02-8235bf025f05@oracle.com>
 <11453aad-5263-4cd2-ac03-97d85b06b68d@oracle.com>
 <20231013171628.GI3952@nvidia.com>
 <77579409-c318-4bba-8503-637f4653c220@oracle.com>
 <20231013144116.32c2c101.alex.williamson@redhat.com>
 <57e8b3ed-4831-40ff-a938-ee266da629c2@oracle.com>
 <20231013155134.6180386e.alex.williamson@redhat.com>
 <20231014000220.GK3952@nvidia.com>
 <1d5b592e-bcb2-4553-b6d8-5043b52a37fa@oracle.com>
 <20231016163457.GV3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231016163457.GV3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0242.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::13) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|PH8PR10MB6409:EE_
X-MS-Office365-Filtering-Correlation-Id: fe4c9973-7a94-4c81-2261-08dbce70ba56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hkm+MFTDqwosjmqB5lUBN0drM8pUYIsT3AFsB6D/ZMSuMYIo2rC7v35iF++v2RIIflyLD3xU9iw4pd2iyO1ht7dQRy9hJLXngh/3/nkMVTbRXTQViLo8BIHzVOGeYj5untDXAYGZbGzgCRV9vySplov1pO+a46VG96o/PwPxCnibeI+NRHR0QvQwnqtPLTCBGltEnxOi6+XyKCuvbusnx1CTN4sChaAtXDDQupA69b+q4dDnhY2wC8/3u2fwV0wrfpJi6yLITpnhMtHzrigM1NEz/marfm9+ygmfE3IBSpHTwZ1eUMwm3Wyb92I1GKkQLAF6jzW43Ihyu442vttCQCFOizjgVYEerbMzk0wvD9ret3Yo6DmswxEAx57lYqH99eWBFwGUCxlahpCu52aYugL/Srmn5mnEG4JKrR6b02nhdrV4Yu7fH2NnNpxMFBFMXXf9oFjvBIuBWiGG984mOL3vsBRNXgX2b9S/MSvhNagMCU6tjTx6WWyG2eeOTNuaQdhhCwC1R6DHjA6qxlsYBDQr8snQOkby09WPmps1h1T2zfb2ZAloUkXciHsc8dQFePDqbfdhWZgsMLLI4wBRXvFYHPhtLPJlBh31cxAlKfU+rEcNpqKjIXNjRKZiwHzASuuJ4/10RBaGpo0RmI/7dA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(376002)(136003)(346002)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(6486002)(478600001)(6512007)(6506007)(53546011)(6666004)(2616005)(26005)(2906002)(7416002)(6916009)(4326008)(66476007)(5660300002)(66946007)(41300700001)(54906003)(8936002)(66556008)(316002)(8676002)(86362001)(36756003)(31696002)(38100700002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?KytkVjhqdVc0bkhTVUErS1RLc0FFYWViaGZKSVNjeUNKc2tBeGJzYXp3WTdD?=
 =?utf-8?B?YTJvTE44amw4WE9lNTNKZ0lEVnpNKzJ0RWFzOVlsczJRdHBQazV2ZGd4YkFw?=
 =?utf-8?B?UmVHanNZYnNRdlBuTmVLNVR6eTFmbjVocmk5SnIxTWswanNqdTVTVm05NHp5?=
 =?utf-8?B?bWpTbGdOc25FemZQYnFRTnFpRUlGdkpBbUZoalRvT0J6cmpOWFljNjdnV1dL?=
 =?utf-8?B?bDIxaFhveThMRkhFV1ZsMHdiVkhTbGdLaitZZC9PenREVDdlaGFHdXA3V1Nt?=
 =?utf-8?B?RUY0MGh5Sis1L1RuRzNUNU9jZllLM0R3UnhBSHRSdXJYOWNSQXpadUovek5H?=
 =?utf-8?B?cWpvT2IzUnk2cjR2Y2g1c0UwZXF5MDRTbU9QRElMWkdFcmgrbUFBVk0xNTM0?=
 =?utf-8?B?QTlxdE9PTHpGTWhFL0xqZ1pTdmwxViszM216eSt0NEkxR1VDMmRBMlNaZFdo?=
 =?utf-8?B?djRzaW52NmpmSTNORTlvWFgvaGpNQXZ1SXZUcG1CQXgwRHllRzJHalRUMVRW?=
 =?utf-8?B?L25nNFZMZHo5ZFpySTFmQWw4RlR1dXlQODlNNWNQZkpRd3lMVEcvTlhvOVU0?=
 =?utf-8?B?em54WnBzTi9wWFNDN0p3WUVBNWxDdFBiTjNVdUU4cnZleXVlQTRPdHdaeDdu?=
 =?utf-8?B?UzV3U3Z6UlRVK1hWR0w2Y2VwRFJCSGRhQXpXR0lTQU5EV1F5eVhTeVBVVytH?=
 =?utf-8?B?YjlqMnBUU0RTekFuQkZoR05XUkVxdm9XRkpjZEk2d2FSdFNqcndnclp4cWZx?=
 =?utf-8?B?RjYrYXJyTnVUeWVJMnhibzJpdDVmcjFQZlBsUk11aFNmakhLeFBZMjk0R3Mr?=
 =?utf-8?B?dlFrUVhaNEpLZEpwNTBQNkJSRFozNXRsQzM4TTFHeUFQRC9SY0VsejJSanBw?=
 =?utf-8?B?VXAwQ05GaTBTV2MyUHJKc3ZOeUNrRTBrOHQ1MVV4ZjhqZDV6SHNFY0pmZmow?=
 =?utf-8?B?K0ZXSzRrNkZtOGhoUkZDZjkzekFKaUxSOXFuZVROWjl4T0NobndxM2VrZlFN?=
 =?utf-8?B?R01UbHJ1bWZJRVpEdVNwUys0ZjlZT2xsVnJXUG1rQWpIbUdOSC9nQytkVkxx?=
 =?utf-8?B?V0pPUmw3MHU4ZksxSzk5cWtEcllnY1hkQ1MwOS8wMTRYVzBoVTRxTGxCSFlL?=
 =?utf-8?B?UkY2M2hJTE9mUkNmeWVFTTY4a1B2ZWNCbzRwNExQVy9uVzIyeTBBZncxa2U4?=
 =?utf-8?B?VUZvcUVoelg5SUFVT1ZyYk41MnBSTlA1V2FZVVRWU1orMVV1QmR4ZzBtQnBR?=
 =?utf-8?B?MzQrUnJPK25EeEhNbFBPbHlwVXg5dnVtWUdRS2pqMFRzM3EvMjZsQmtSSlpP?=
 =?utf-8?B?V0lMUFZQbnI1Rm0ra01JQ2U0U0tXc0lqOTUzQ0FvZyswZlFJem55cnhGNmNq?=
 =?utf-8?B?R2QrZEFJN2dCL25DVWpOMTg1U3gxbS9QVDMxemV1RXhWa2xUWVI3ZHFQd0xH?=
 =?utf-8?B?c0JOcTJJRlU4SUNxMm4rQWRyMW5ETkxudHRuT0hCdEczNi8yTmpnK0lkZVBm?=
 =?utf-8?B?QVlpN09leWxwQ3B5NWRQcGNhZmgrZlA5NXIrYWxYUi9iRmN3SjZWanJ5b0Ra?=
 =?utf-8?B?ZTBsdmswSzVJbWxTeFA4VkJ2WmRuUCsvVlVMNGxJUE1peHpjMVZlbUVhMVVa?=
 =?utf-8?B?SEdPZDBncjNVQWNOUTROL3NWTGNCQmJDUVJDb2dvaE1tMTBGYmFIZnF0cy9Z?=
 =?utf-8?B?N3NpYUM2ZjFvUmFFMUJINXRvNXI0WllEaTdKTzBkdU5GU1FNc1djb3pzUEJJ?=
 =?utf-8?B?L0xvdkM3R3IvZCtPV3hIeUk2T0tIVGc2dy8xZUF3OEZOSEFuYVNFUDd5Y2VM?=
 =?utf-8?B?YnowazJwZjNzWUhhb1owUGp1cHV1NWMybTFRYWI2UDZKa24rUUdOdlBHQmo4?=
 =?utf-8?B?MlZmUFZrM2NkT2F2WW4rUlZaSjk4MnU2WTBMckJyMkI4akw5MlpQQTZIWXZo?=
 =?utf-8?B?ZjRNclFkWW9ZbkFBbzMzamlHS1lkUU1kK3N6WEZhTytwSlNVVUJiT05aaTc0?=
 =?utf-8?B?bjdXVHpJUDdUZ0FiOGVCMGROTUJEcms3UHE5Y1ZZcmNaR0RBajc0c3F1aUZ6?=
 =?utf-8?B?cnNxMlZEY05YU3VOME40L3habmgwWHNxTURiQ21URDB2YjRPcDhQVGx1YmRC?=
 =?utf-8?B?RjIrK0ExNkZvVUEwMERQTS9sQ3ovWnkzNU9JVzBuTjcwWG1KalJjUTNVN1ls?=
 =?utf-8?B?NkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?TmlFY2V4OE14QjJWMEQ3VzRYS0tnbXlRTTZqZXZUd1lXdEFBdzZwSUh3UXp0?=
 =?utf-8?B?TUFqTXZGejgxWXJBR1BQdFJnMnBxY3EraGJ6eUdZQzlaUC9kb1lFZWEzTVpz?=
 =?utf-8?B?elY4U2QxekFVbEo2U29Da1lwMjR4a0w5ZlNKOG5NU1E3QUJIUng3NnJmaWVJ?=
 =?utf-8?B?bVpUTUVkeVNhNzZHc0w5Wko1Z2U4Z05valFDNnBWclRHaVBUYVBMUHRKTEVJ?=
 =?utf-8?B?MkdoSXcySk0reFZrdm81QlMwTlRBQUU3TUxDR3B6SWdLMlNqNzIwbzRNOG85?=
 =?utf-8?B?OHd1WWk2UzgxZzNMV2Y5MHBmNlAzVmxrc1VjYllXOHlQRTg5ZXhyT1pqUmdk?=
 =?utf-8?B?bG5NbG1Ma2tYWmRPY1UycFNYUXErblliWjcyZFp2YTNiK3huY2IraFVFcUJq?=
 =?utf-8?B?SFhCVDRZWnByM21Pdm1TYVN6d2lBa0Z6REltaUpyRTVhTndZSlIranh0ZkND?=
 =?utf-8?B?bkt5OTRYMXZkdzdnZHU1VGdFVHZQTUkyd0V1NnorcGk2dmlZbjZxM1JpZGlM?=
 =?utf-8?B?NTlTU1A4NmNSOFJFclhRWTc4MElTeTR4TXV3QXRmQXpSTUxHTU1XTkV4VTYy?=
 =?utf-8?B?SVRDUUJ0YmI0NkhqWStBMkNqNlhuOHhYbEJWdUU1WGVWczA5VFVFUGIyejVh?=
 =?utf-8?B?R0svY0VhUGJMWlZyK1RTdHFLVEVvcVhrZTdnTUVVRW00R0t6VU9hNjNuRUt6?=
 =?utf-8?B?Y2M4Zmo5TU5UNVRubXljRFV2bWhydGRkb0I5UU0zQVF6bFpZYlFrUXR4aG1K?=
 =?utf-8?B?d2hvbE11bTRlQ1F0dkZQekJZcHFIR3VYekJCQjRhUVYwMXo0V083V1hhZWpT?=
 =?utf-8?B?bWhqMGtTc0pnQkdqTW1xSkNQZHQ5a2RiLzB0ZDU0VzV3UmNpWFgrYkFiNUpK?=
 =?utf-8?B?SnJVQ3AwSHhxRGdPRVp0emEzeXZ2eDZaY2FuNXFIOHlHcWl3ekFxQlh2WmNl?=
 =?utf-8?B?M1h6S3hEdFR1WHNoTHFKZHIza2hVWUZyOHl3N2wyQUJkSzBuend6Y2M0Q3dw?=
 =?utf-8?B?dkpTbUNIaWs5R3o1bm9qQjllUlFKK2tXN3pWZkVVMGdGeWhBb1R1NVRpK1R6?=
 =?utf-8?B?dVA3YWlDTThpYVZDWnVMekpJSmVWWU5CeXJTOURORUJOMXU1QWFxRjhwM0N6?=
 =?utf-8?B?WE95TTFvWjl0MFN6V1VoRUUzdGUxajZxak5GQWZPQjZPaWxiVzREaHFJWnpW?=
 =?utf-8?B?a1VYTHk2L2lRcVBhR0JSSkJ0dlZxeklBZ3c0SHppWjNtcVRiMU9HNnYvQ1lt?=
 =?utf-8?B?TzZHV3FNbk1HNGo2Zmgyc1hFZDdkTmtNWGRnelV5dExaeGhKRngrckFHcUUv?=
 =?utf-8?B?YTU1dFJUeS9xRTEvbHdZeEZuTUNkUXovc3ZzcnJSOUkrRkpzVzdTSTJHR0pK?=
 =?utf-8?B?azNkNGM2UHQ5aDBiZUtZUENDNit6QjVxUzFRS1Jzck1qZ1lpOXUzUzFTS3Zm?=
 =?utf-8?Q?Xv8Njywj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe4c9973-7a94-4c81-2261-08dbce70ba56
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 17:52:56.3502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cJo432wG/Lmn9Qt1/StAfijLBl6DeBtvJ997bsggtV/jE82vKZ6vfzEMv2UVNEzQnQ7Y9D33n3jH2NupRqe91CK4eyBfVSgddPpyZZxN5qE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6409
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_10,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310160155
X-Proofpoint-ORIG-GUID: tMfUIGq-0YDEJ5eVS_w45wP0qQ_KkdHw
X-Proofpoint-GUID: tMfUIGq-0YDEJ5eVS_w45wP0qQ_KkdHw
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/2023 17:34, Jason Gunthorpe wrote:
> On Mon, Oct 16, 2023 at 05:25:16PM +0100, Joao Martins wrote:
>>>> I think Jason is describing this would eventually be in a built-in
>>>> portion of IOMMUFD, but I think currently that built-in portion is
>>>> IOMMU.  So until we have this IOMMUFD_DRIVER that enables that built-in
>>>> portion, it seems unnecessarily disruptive to make VFIO select IOMMUFD
>>>> to get this iova bitmap support.  Thanks,
>>>
>>> Right, I'm saying Joao may as well make IOMMUFD_DRIVER right now for
>>> this
>>
>> So far I have this snip at the end.
>>
>> Though given that there are struct iommu_domain changes that set a dirty_ops
>> (which require iova-bitmap).
> 
> Drivers which set those ops need to select IOMMUFD_DRIVER..
> 

My problem is more of the generic/vfio side (headers and structures of iommu
core) not really IOMMU driver nor IOMMUFD.

> Perhaps (at least for ARM) they should even be coded
> 
>  select IOMMUFD_DRIVER if IOMMUFD
> 
> And then #ifdef out the dirty tracking bits so embedded systems don't
> get the bloat with !IOMMUFD
>
Right

>> diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
>> index 99d4b075df49..96ec013d1192 100644
>> --- a/drivers/iommu/iommufd/Kconfig
>> +++ b/drivers/iommu/iommufd/Kconfig
>> @@ -11,6 +11,13 @@ config IOMMUFD
>>
>>           If you don't know what to do here, say N.
>>
>> +config IOMMUFD_DRIVER
>> +       bool "IOMMUFD provides iommu drivers supporting functions"
>> +       default IOMMU_API
>> +       help
>> +         IOMMUFD will provides supporting data structures and helpers to IOMMU
>> +         drivers.
> 
> It is not a 'user selectable' kconfig, just make it
> 
> config IOMMUFD_DRIVER
>        tristate
>        default n
> 
tristate? More like a bool as IOMMU drivers aren't modloadable

> ie the only way to get it is to build a driver that will consume it.
> 
>> diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
>> index 8aeba81800c5..34b446146961 100644
>> --- a/drivers/iommu/iommufd/Makefile
>> +++ b/drivers/iommu/iommufd/Makefile
>> @@ -11,3 +11,4 @@ iommufd-y := \
>>  iommufd-$(CONFIG_IOMMUFD_TEST) += selftest.o
>>
>>  obj-$(CONFIG_IOMMUFD) += iommufd.o
>> +obj-$(CONFIG_IOMMUFD_DRIVER) += iova_bitmap.o
> 
> Right..
> 
>> diff --git a/drivers/vfio/iova_bitmap.c b/drivers/iommu/iommufd/iova_bitmap.c
>> similarity index 100%
>> rename from drivers/vfio/iova_bitmap.c
>> rename to drivers/iommu/iommufd/iova_bitmap.c
>> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
>> index 6bda6dbb4878..1db519cce815 100644
>> --- a/drivers/vfio/Kconfig
>> +++ b/drivers/vfio/Kconfig
>> @@ -7,6 +7,7 @@ menuconfig VFIO
>>         select VFIO_GROUP if SPAPR_TCE_IOMMU || IOMMUFD=n
>>         select VFIO_DEVICE_CDEV if !VFIO_GROUP
>>         select VFIO_CONTAINER if IOMMUFD=n
>> +       select IOMMUFD_DRIVER
> 
> As discussed use a if (IS_ENABLED) here and just disable the
> bitmap code if something else didn't enable it.
> 

I'm adding this to vfio_main:

	if (!IS_ENABLED(CONFIG_IOMMUFD_DRIVER))
		return -EOPNOTSUPP;


> VFIO isn't a consumer of it
> 

(...) The select IOMMUFD_DRIVER was there because of VFIO PCI vendor drivers not
VFIO core. for the 'disable bitmap code' I can add ifdef-ry in iova_bitmap.h to
add scalfold definitions to error-out/nop if CONFIG_IOMMUFD_DRIVER=n when moving
to iommufd/

> The question you are asking is on the driver side implementing it, and
> it should be conditional if IOMMUFD is turned on.

For the IOMMU driver side sure IOMMUFD should be required as it's the sole entry
point of this

But as discussed earlier IOMMUFD=m|y dependency really only matters for IOMMU
dirty tracking, but not for VFIO device dirty tracking.

For your suggested scheme to work VFIO PCI drivers still need to select
IOMMUFD_DRIVER as they require it
