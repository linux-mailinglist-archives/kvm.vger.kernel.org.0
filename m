Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF01A7D2E41
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 11:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbjJWJ3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 05:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233068AbjJWJ24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 05:28:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83FFDF
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 02:28:53 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39N6jirR017401;
        Mon, 23 Oct 2023 09:28:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=0tJt3PJF53sg65+w8B1XWvH8WMdos8OW7YxBdoyoA/s=;
 b=o0UGnKke0P2L2E3H3XIsk/9xx7HBbTrYVytgZwMI6etMoF1qzTOTTsyN1XQjMo/pFMwm
 Enu+PDmkr7HPxpniirySqYAcO4BPaaDhIjl63Ip//ZgF4uhZ9bdGbyjUrhgk2Nji65nT
 4NrW38Jzo9U7rk9XuziALy8P6vMOF4DwB3YA363VKYp+jCHabmuTHGuUM9i3M0P8yAv2
 36PhkDm+3pBIE1B/nig7E2S/g+3KsYduhMsjjBlhhy5u3Mp6P6d8ZIgYk4b7wdMy6vw4
 4aEUh9NXCjuP6/Jt//V15dhltTBw1p+vcGk2uGBaBbf/iA0nlz2I4KMGrZ6znaIFq4hL DQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv52dtpbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 09:28:22 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39N7WuoR015083;
        Mon, 23 Oct 2023 09:28:21 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tv533qxq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 09:28:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JJrQ/5iNYHabAN6Q8pr6X4Da0okvp+6KfpyC/OOyjbBisfP3FzogzL2X+I9fhllA+fCEiKmqNW8CoX5vV1vS9vZeLOYoVnAZP3z9X6M8be0PGzRmyYR5QgvPd+30XH8b5DRTpk+oJ2I6ulfikH/oxwga56v80TlDw/V9ZmXaSlvWvQ9i4rbJDuS9sHZv5gd+gsbVtzdpOWBd2D10HFyPwdqtPa3k/L4KMm4lCf2CuNNhxDZCxJWNK9EAkV/GsvvwpjNNi/Gp2n2m45S5UNNAlLbuPL3jJlkFb2HxSBOSbcs9iTGC3nIvyuhfz2XTqMH5tcPizuVR4kLwjZMjfzHkMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0tJt3PJF53sg65+w8B1XWvH8WMdos8OW7YxBdoyoA/s=;
 b=SKyeIUmorICW+dlsoNel9X5xNQA8LxNHFf5YSnBlvPnU4XZaV/nicQbcGBkcIbKH8uBqLi4kIZQke170UzkgnvQVuNFfZK38t+gbpM4D/UheOn87uWCrhBmwHUrpN9wpU8LLOEfklBF29ethiV0UJp4zc8ixQsfq+vjvXyHCSD0X7q4BBBNbViUk/Qz/NjcSiKQEkDVWv8B/qWQTLLP4T/EBv4ROxT5BcKMnUAmxVGloaKS19X9UnrvPUrN/BlNLxt53JlNsDGnqJFfS4NknyKUjcwwsPYOx/4rTwHlXQ2nyyx9hKgczFPfkh2BuxdrLzJyDowYQlMrdlcemrPi13A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0tJt3PJF53sg65+w8B1XWvH8WMdos8OW7YxBdoyoA/s=;
 b=jbhf/Ar3KlUCh6qH2QJtkkf+2ziKXqWlQ1W/9A4pHzRkPCndCIacrSUTREZTk55KSTZfL+I7hH9hTsArUVvjfgMNkCxpncEKvvO7TF6XlrUOm/rw4bov4sCpqaR2VNPg1nTS1XgVzRMBNQFK+Qtz+lAay7zb6o6P8lIv1DNrm5I=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SA1PR10MB6343.namprd10.prod.outlook.com (2603:10b6:806:256::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Mon, 23 Oct
 2023 09:28:19 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac%3]) with mapi id 15.20.6907.032; Mon, 23 Oct 2023
 09:28:19 +0000
Message-ID: <d65cb92a-8d2c-41a3-83b1-899310db1a20@oracle.com>
Date:   Mon, 23 Oct 2023 10:28:13 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/18] iommufd: Add IOMMU_HWPT_GET_DIRTY_BITMAP
Content-Language: en-US
To:     Arnd Bergmann <arnd@arndb.de>, iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Baolu Lu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231020222804.21850-8-joao.m.martins@oracle.com>
 <b7834d1e-d198-45ee-b15d-12bd235bc57f@app.fastmail.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <b7834d1e-d198-45ee-b15d-12bd235bc57f@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0007.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:150::12) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SA1PR10MB6343:EE_
X-MS-Office365-Filtering-Correlation-Id: ff6b2ebc-46e7-4cf6-9449-08dbd3aa64a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qhh3+4lHiyf6CnfSYXbh4CdrA+a4yWxJM+SiGlEvkQclcuoAYoWyze79IptLlTcrAq9mXiCjFAcQ4io0oQy6UatHmr5mkbmlUOHLOrHVmElYO8Xwl9H4esQKOmOazyI+E3sUClPTf8p2DQtlkYK93EpqinVLsLbFprgwyn1eDzGfT8w2KISv8G/9yBdE23cr7exKfF3GxwKTB4iqJsMlVDObQMHzXXWPbRQJbuFfo9ws0uyJmVb4LqdpYnWHhPOH46E6vFSjs7ka8ybV10F7l+v8/RMddvOvM6D7e1XyjojKcgL2PKDDPw6yFnDwfkPyyvZhbELCEfOs9CTtHS6FW4MYN0ytn1f508P0fyDYrJ7XSmn/2+4WVbCyjyFp2kuFZSn4si7cXXgSDsGw3yq5Z+3R7HPE50LZ3N4I2XkdYIGgx5AK8v9/sO7xULM3M6d5w4P/rASkD4LcvFlWZq9kjgYVmgHBpu4mksF32hmh+tMN9bUHWMlFcl31hecj/UhUTLS2L1OR8dYewYwYadQNSGOY4MkJ6QtKNBbEIc3x6cFGAXzj6RCioNNjwL3vNseNMKdMaq/nsVr0bz7k3Ba/JEe04bgM1rhp1t/gimLDccljDLCuDGNk65XQzMlW8gKDARgAAzoGPPkfDakl4SfOkX7tA661HhUDJhGLuMegkR4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(136003)(366004)(396003)(376002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(66556008)(66476007)(66946007)(54906003)(86362001)(41300700001)(5660300002)(316002)(31696002)(6666004)(6506007)(6512007)(6486002)(478600001)(8936002)(36756003)(4326008)(8676002)(2906002)(7416002)(38100700002)(26005)(2616005)(53546011)(83380400001)(31686004)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2w0MU1qTnNWNENqUDVwSTV2K0R3RUVQaHRuRnJMa011RGEzUmU3QzZYYU1x?=
 =?utf-8?B?ODJGcVFobWdKc0JETDNRTTgxejRhTHAxTU16UnUvc1hHR0tJdW1taFJ0eXl4?=
 =?utf-8?B?RW1QbnpvMVdKQno2Wkh3dERuRGtTdE9WL2w4MjdCM29GK3hmdFFyNjAwKzFD?=
 =?utf-8?B?cDNLU0VKV3JqcER0YkJhSDVsaTVOOFlHTmFTTCtIdmpvcDNhbUpTMktPTmJY?=
 =?utf-8?B?dkIwWEkwSTVER2xaMER5akRlTnIxamEzNjcyOFFIN244blN2eXlYU01CMjBL?=
 =?utf-8?B?UkpXY0dhL0hDckZtdG5QMnNEWlFGTm50Z1lIT3Rxa0VQb2t0SmJBWi82NEUx?=
 =?utf-8?B?My9WcUV1QUlFdldqeUhOOE0wNVFaWWFHSXRZUkxra3BTVnhPNWJIbGpZa1BF?=
 =?utf-8?B?WVd1bnZqTDRNVG9XYlByWGU0aW5uSHVLS0MxS1dtZ0JYQm1NM2Jvb0t1ajY3?=
 =?utf-8?B?Wk1lRk5halIrdFViekZTUjRlSmgydjJOR2psam1BYThSY084VHY1dVFBbjBS?=
 =?utf-8?B?WVYwQzlyelNSWVg0eG1JRW9LWVI1QzAxd3R5ZjRJQmdqUTkweW1HQnZRZENE?=
 =?utf-8?B?blg4eW9xUVNVUGE1OEpzeFpyNk5mWUFDTW9WcmgrTDZNMVErMTc2aU93amc3?=
 =?utf-8?B?YXVoMzgvS3JCeEhHT2haNjFrcUF5dDM1TVF1SG5Id1ZFMTlMQklFMDlBVzJz?=
 =?utf-8?B?bVRhMTJXMTJZZ3diQjN6YUN5MWtCYVRmbi92Mm1KcnlQWVNuUEFSOHIzN3Yv?=
 =?utf-8?B?cm9qTEZZSUd6eTd1a0ZGZEJqd3FrYnFLdng3SkhDUTMzZWZuNlJzOEtQajFi?=
 =?utf-8?B?SFJFVU91dkdTOTRxSFdVSkM4T0c5REt3QmlPbWI4c25MWmRnZ0FTSk5NVkNU?=
 =?utf-8?B?blFESm9SQk01MVhRTmdXalhRaVg4dlVibHEzSERCUHN3dFQzM21PSTF1bExP?=
 =?utf-8?B?bkpuYjZ3TGU2bmlLcmUwMWtleENYaE1sbE5zMVcrSUdMOWFWM01oc1A0Ti9h?=
 =?utf-8?B?QUlaKzJQVUY5a2JocmFUZm1YejQ3Q0kwTmhFWnJHMkd0UFJHc3ZETmg4M0po?=
 =?utf-8?B?NUZVOVdnWTRQaFdEZHArL0FvTktkQTMvMEJHRWJ5VlNhUXd3ekdTdlRrSjM2?=
 =?utf-8?B?cXVCRFZZbkF4Uk0xeUhtaFNBN0RiZVkxbG5rVlRvcjZKWEZhNFRXWFZ4MlNJ?=
 =?utf-8?B?SnRodmZMcFozcnhrVE5XZHFRNTduU1R5SWRVQ3gydEJncis2RWQvazIxQWVs?=
 =?utf-8?B?WTN3dHFMUElTbEZva2NkNFFSVWpYQXAyZHF6V0VxMk9ZMG5PTzJEdDdCaytk?=
 =?utf-8?B?SzFsOFJxT1pLOExCeGZLaEhaUy9kTUUxM2dvMkdvK0lVQXJxcnI3d3VpNTJP?=
 =?utf-8?B?OGM1UDVUeXVFYm45VmN6R3JuY0t3elM1Yms5Yit0SGtEdnBmbnc4NndNRVpQ?=
 =?utf-8?B?bmRabzNxbGJ2M3VLSk9jSzExYWI1cGZIWGRvaURXMHV1WE1LU013TDhOZXpR?=
 =?utf-8?B?YVdKSG51ZVFqUS81Mm8wUVMweE1WSEEwak1ocDRCY2tJdytvd1RMV2FTdEpB?=
 =?utf-8?B?SkZsaXBjUUo3SnJBcWZiMDNMYVpCbnhSc1NjVDlsaFRvT0JENlpDYXJieGZG?=
 =?utf-8?B?dXdDaThoY3R1Q0hXeWRoei9ZNEZjdHZIRlBZZ04zN0dWWUZ0QVpTTXd6enh0?=
 =?utf-8?B?TDJQRlptZ2JUMnQycDI4d0RsTnhxSzljRmRtQUhaL1NXczVkVXU2VmxvU3Jy?=
 =?utf-8?B?a1ZCZmo4bldNbktPTzgwSko0ZmkzRkpYbllyWU5vV1BYaXQ2USt0SVpIUUJq?=
 =?utf-8?B?Y09tQWlpZitsZmVJRHV5NDRDYkhJVGxPcTV5d1dHOC9hZTVFSHNYT1N3VHVF?=
 =?utf-8?B?SnJ5b3Jrd0Y4K3E0cXN5OXFBUnFUU25VVEVEMmpMVmZCRVRITUFkTVltdXh4?=
 =?utf-8?B?Y0h2R1ZqYTkwdWd0NmFtOWxjdHpTei9oZkpPaTVuRUFSeXBZNjdtQ0F3UmxX?=
 =?utf-8?B?UEdZUmtwZDNnbk5ZYUM4emk3YWhLWW10SWU2RDQ0YXNXYXBFbU5jdUlnUWU1?=
 =?utf-8?B?eFc5cUlMY0hGL2RSeTRWVXhESFl2dEJPdFRUaE9HR2tvby8vVTRQRm5Ga0Vn?=
 =?utf-8?B?d0s4U2ltNXpMRjZnSHJjeWNjQUFITE5ZRFRqekx1TTFVK3lUMGwxZXU5eCtX?=
 =?utf-8?B?Nnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Z0dqR1g0cVRLSHJRQ3J1WEJ3UllGUnloZnRJQ0xORFRPMXZtZk5UYXJxSlcr?=
 =?utf-8?B?em9HTUlqeVQ4cEQ3NDc3MTUySWZUSVRQQzNDaUdGajNPOXZvZ0lDWjNSdW9V?=
 =?utf-8?B?bW5ySFFMTXRrekZ0WHRUL25YeUhnK1k0amFId3lOdi8rZ1BTQ0ZZK3NBd0NZ?=
 =?utf-8?B?bnZsZHZnbzhTVWJMMlJKd2dFcVlOOUhpQzliRXpJM1U1b1B0RzJkc1pVVGFO?=
 =?utf-8?B?a05rMzM1MkE4cjZqcFV1UEx1dFowbXdSODVNMFRRUWNlZXY5djBWTzZzOXJr?=
 =?utf-8?B?eFdpc1I0b0Ryc3dXTWdaRUt6WU01ZE5DelZ5V0pmMjdMbTEzVEhJK21neXlQ?=
 =?utf-8?B?NGZRYkVvcVZSdkxSYjNSOG16YlNlZm1XMlkxSkNaZHhrTDV0dWptbzROaTdO?=
 =?utf-8?B?OGdxVm1FM3N5dHpGVDVtOFltOXRNcitVdFg3WjlMMHZWbWE4dWZHWlRnUFN6?=
 =?utf-8?B?b0dFc2I0dkt3MWlKMVYvSkNnN0VPOVFLTy9MUnFodmhxY01WUXkwZTFwVlJP?=
 =?utf-8?B?WmZHcHZTUnVNVlQwWWphbXpEMnk3Rml1VGRmdVBtYlZYbDhSR1FidTlaRExF?=
 =?utf-8?B?ajJES3ZBWTdTVW9Sd1hiQUJuYnhIYUwyeDdralcrU2lVcXFoNW9NeDZJNSs2?=
 =?utf-8?B?TStYRVJhNmlaSDRYYm8rTkx1MGNqdWwzTkxKSndIdERDZWIvQzQ0UENWMUY2?=
 =?utf-8?B?NEZoTFlHNXFOd0UyaU1xemhtSDBCYkUrM0xQVUhHRHZEUTdCWjgxdWNxbG1L?=
 =?utf-8?B?bi9QUXlTa3dxeDg5Qk1wL2pjWDI1RWRDTFpXOE9FYWk3YlNldUorNHJJSFls?=
 =?utf-8?B?T0hTNnZpcytjd21hUUVrbmFBaUhhRkFIWEVvQm9vTHd3YXBnTWp0U3lDVE5L?=
 =?utf-8?B?bzJ0VU1KU1pNMkFHTTRhZytEM1hRYSt3MnVYdlNhdEpRZGI1ak9IcjY4ZjFD?=
 =?utf-8?B?NkE4RXZZSXQzSXRTUXpqZktlazJWc1Q4U0hZbm9BcUI2WUhncEw5LzQxUnoy?=
 =?utf-8?B?QXp5YUZXTDNoZ0tBWitPUkZ4UVRzV0t1SkV5S2c1U1RVcTZHdG1jSW9ZQ0lu?=
 =?utf-8?B?ZXJ1b1ZhZkhFQWlFOGlnb254WDVUZ1dQV0oyOTdYWVo4Y2RRZmUwZW9rUVJj?=
 =?utf-8?B?M3pETi9mWjJhb1JlNzBzdm1HUTJORWpHRmRPU0dJSUh3MkY3QWdwL0NrQk9P?=
 =?utf-8?B?TnlLWEhRQlpXOHhvZXVmWGdCWUpGbzBpY1g0c0tPQ1NpQ2o5WW5Ma1BiZysx?=
 =?utf-8?B?eEFKdERDT1AvNFFBUmRnWWF1WG9HQVp4VkFkOXR1M2dRbnJjMGVRWW9EVW9B?=
 =?utf-8?B?VWlEUDZ2SG1IaG5OQktPNitKYmRTN1FreHM5S0o5Qjg4WExUNEhSZ1AxMVo4?=
 =?utf-8?B?d1oxOXIxSkR2R0thcWpGaXZuSFdKNEp4YXZKUmQxbG5IaWlCWXpWcHVKYUpE?=
 =?utf-8?B?NEJ0dTFpWmtma3ljNW5kRGRMZ3kzWFc1bUpPcUFRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff6b2ebc-46e7-4cf6-9449-08dbd3aa64a5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 09:28:19.1243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hSa4+bt4qLRzqC5rPmygB6nuWeqQZTDljHeDn91VwtBEr81AecztUfTt60GkBZ8RSDm0MRzLumrLy8b1oWGVVPlx99ZK11RDxBrEUcgLhJU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6343
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-23_07,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 spamscore=0 malwarescore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310230081
X-Proofpoint-ORIG-GUID: 1xpHAAtQ_0s9X_bRoTnLmwy0xTnH0B1g
X-Proofpoint-GUID: 1xpHAAtQ_0s9X_bRoTnLmwy0xTnH0B1g
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 23/10/2023 10:09, Arnd Bergmann wrote:
> On Sat, Oct 21, 2023, at 00:27, Joao Martins wrote:
> 
>> +int iommufd_check_iova_range(struct iommufd_ioas *ioas,
>> +			     struct iommu_hwpt_get_dirty_bitmap *bitmap)
>> +{
>> +	unsigned long npages;
>> +	size_t iommu_pgsize;
>> +	int rc = -EINVAL;
>> +
>> +	if (!bitmap->page_size)
>> +		return rc;
>> +
>> +	npages = bitmap->length / bitmap->page_size;
> 
> 
> The 64-bit division causes a link failure on 32-bit architectures:
> 
> arm-linux-gnueabi-ld: drivers/iommu/iommufd/hw_pagetable.o: in function `iommufd_check_iova_range':
> hw_pagetable.c:(.text+0x77e): undefined reference to `__aeabi_uldivmod'
> arm-linux-gnueabi/bin/arm-linux-gnueabi-ld: drivers/iommu/iommufd/hw_pagetable.o: in function `iommufd_hwpt_get_dirty_bitmap':
> hw_pagetable.c:(.text+0x84c): undefined reference to `__aeabi_uldivmod'
> 
> I think it is safe to assume that the length of the bitmap
> does not overflow an 'unsigned long', 

Also I do check for the overflow but comes later; I should move the overflow
check from iopt_read_and_clear_dirty_data() into here as it's the only entry
point of that function, while deleting the duplicated alignment check from
iopt_read_and_clear_dirty_data().

> so it's probably
> best to add a range check plus type cast, rather than an
> expensive div_u64() here.
> 
OK

>> +/**
>> + * struct iommu_hwpt_get_dirty_bitmap - ioctl(IOMMU_HWPT_GET_DIRTY_BITMAP)
>> + * @size: sizeof(struct iommu_hwpt_get_dirty_bitmap)
>> + * @hwpt_id: HW pagetable ID that represents the IOMMU domain
>> + * @flags: Must be zero
>> + * @iova: base IOVA of the bitmap first bit
>> + * @length: IOVA range size
>> + * @page_size: page size granularity of each bit in the bitmap
>> + * @data: bitmap where to set the dirty bits. The bitmap bits each
>> + *        represent a page_size which you deviate from an arbitrary iova.
>> + *
>> + * Checking a given IOVA is dirty:
>> + *
>> + *  data[(iova / page_size) / 64] & (1ULL << ((iova / page_size) % 64))
>> + *
>> + * Walk the IOMMU pagetables for a given IOVA range to return a bitmap
>> + * with the dirty IOVAs. In doing so it will also by default clear any
>> + * dirty bit metadata set in the IOPTE.
>> + */
>> +struct iommu_hwpt_get_dirty_bitmap {
>> +	__u32 size;
>> +	__u32 hwpt_id;
>> +	__u32 flags;
>> +	__u32 __reserved;
>> +	__aligned_u64 iova;
>> +	__aligned_u64 length;
>> +	__aligned_u64 page_size;
>> +	__aligned_u64 *data;
>> +};
>> +#define IOMMU_HWPT_GET_DIRTY_BITMAP _IO(IOMMUFD_TYPE, \
>> +					IOMMUFD_CMD_HWPT_GET_DIRTY_BITMAP)
>> +
> 
> This is a flawed definition for an ioctl data structure. While
> it appears that you have tried hard to follow the recommendations
> in Documentation/driver-api/ioctl.rst, you accidentally added
> a pointer here, which breaks compat mode handling because of
> the uninitialized padding after the 32-bit 'data' pointer.
> 
Right

> The correct fix here is to use a __u64 value for the pointer
> itself and convert it like:
> 
> diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
> index a26f8ae1034dd..3f6db5b18c266 100644
> --- a/drivers/iommu/iommufd/io_pagetable.c
> +++ b/drivers/iommu/iommufd/io_pagetable.c
> @@ -465,7 +465,7 @@ iommu_read_and_clear_dirty(struct iommu_domain *domain,
>  		return -EOPNOTSUPP;
>  
>  	iter = iova_bitmap_alloc(bitmap->iova, bitmap->length,
> -				 bitmap->page_size, bitmap->data);
> +				 bitmap->page_size, u64_to_user_ptr(bitmap->data));
>  	if (IS_ERR(iter))
>  		return -ENOMEM;
>  
> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> index 50f98f01fe100..7fbf2d8a3c9b8 100644
> --- a/include/uapi/linux/iommufd.h
> +++ b/include/uapi/linux/iommufd.h
> @@ -538,7 +538,7 @@ struct iommu_hwpt_get_dirty_bitmap {
>  	__aligned_u64 iova;
>  	__aligned_u64 length;
>  	__aligned_u64 page_size;
> -	__aligned_u64 *data;
> +	__aligned_u64 data;
>  };

This was meant to be like this from the beginning but it appears I've made the
the mistake since the first version. Thanks for both; I will fix it and respin
it for v6.
