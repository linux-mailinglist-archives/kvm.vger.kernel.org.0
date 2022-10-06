Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2789D5F7176
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 00:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbiJFW6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 18:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiJFW6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 18:58:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C91BEF86
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 15:58:38 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 296Lctrf003461;
        Thu, 6 Oct 2022 22:57:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=kF0rBLYpg/GiYatxxy3SsS+0rKa4Z9X3UdcfHRveehQ=;
 b=LOBvfGdSEOul1CAeLrb9AxXfOietOmMDhxPng2eMEC4nJKOSy00alG0pRiY+3wlLauuL
 LfskBbvf0uax0roCrJrndvoORGkwMNFKhsnLLIDyP13zIYBDbsFtWfOM842qtJVcpii1
 twyer0GoXiTt7aGm5SHgcZKbnQF17Wg0zX+bUBdsVYRxpK2Euo5+Sw2jZZAD0q83aoQo
 MEsImjGHoRepOzauSIPAM4QLayDdRCWwbiSglBqmG3m04js7No51PvvMR/JfXKA6UkrI
 FHONup26LJe+WeJZiI7JCHJ9CraLLqWvJkNuuskvEE2D5ANi1zH3TVkDA5vUhq7pbdP5 VA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k15up51ar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Oct 2022 22:57:45 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 296KQBRY020661;
        Thu, 6 Oct 2022 22:57:45 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc06kggp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Oct 2022 22:57:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4ISaFY9/ZRt40JgVkIjlw/y9/QGceelx3839eFaqIoHSJurgjCK/xQkOqPGKqsNxpsgbZQg6lIqLcGPYQT1L5++dJA1+jiCSQFUJgS+0uXe9RoRpZgwB1YFKaqMtIiXO7QRsA46z9rxn6GY08IkOWM98MMjejB9BHC2RDPECDt6DoCBvTBVplUG5W9+HjtEI7ME7iUdRITqaWtStImBITZMHLTTlDCs/0Yb7Sn9TgcI3DALGw70g5Vh4z4CMzsMHIB7rcDxnjcxpLATIdmkPC4JOPxxRVDzYIPD1/w24uLk+J+sq3oPDlw/xnbZL3wCIoCkG6E6Ba3EPrysbOgOUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kF0rBLYpg/GiYatxxy3SsS+0rKa4Z9X3UdcfHRveehQ=;
 b=DpAH3V5jLBs+PHGY/5EF5KGgjBb5XQzOmW4Xooy0siRi2oRpp46vxVj5YdvQ8jDOqNhQNwdtWM/G2IMNogDONWXmkwkgtuE4Bb0ey2wukosm/LFa4qLioJ9q55ZA0q1dg1FlIfG3HAWFMse6y3o3sFxfj3oNbeCA+ou8M7YVlZPwGwd2Lt+VBuTBvi0Pqm5hR83gShfHTfORQP5rVkSuREYBnHpvIfg+Bl4UrGqq0Qb06ULILBN5geZ5wBKEJE+hTcdNFG8bDDzcqnpf9QI9ft43rG8yxGpD08LxCLQ85iF+fIUn4sE9vaFtHabh7xJ5aFXTgpg+9RUc2lYrmnBjrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kF0rBLYpg/GiYatxxy3SsS+0rKa4Z9X3UdcfHRveehQ=;
 b=CHG0a8icXYOc46j8LXFKwmndrQxcLgcYRfh6CnxJbbXePggeXJ69MMuEt+bhWQ1ANtAXi3spDgekZ/5ADgxC/k0FPJJ+OXP4LuPqW3AnZnWtz9rNPVFnyAHJfHxdGBs4dSvLBopk4lSvucNZK1X/P+fbTGDJb6ORQZ7Qn89w5qc=
Received: from BYAPR10MB3240.namprd10.prod.outlook.com (2603:10b6:a03:155::17)
 by PH0PR10MB5403.namprd10.prod.outlook.com (2603:10b6:510:e3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Thu, 6 Oct
 2022 22:57:42 +0000
Received: from BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::8cbc:1639:7698:1528]) by BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::8cbc:1639:7698:1528%4]) with mapi id 15.20.5676.034; Thu, 6 Oct 2022
 22:57:41 +0000
Message-ID: <9dbeec9f-f537-25a8-d2ad-81d3ed01ae77@oracle.com>
Date:   Thu, 6 Oct 2022 18:57:36 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Laine Stump <laine@redhat.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <BN9PR11MB52762909D64C1194F4FCB4528C479@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d5e33ebb-29e6-029d-aef4-af5c4478185a@redhat.com>
 <Yyoa+kAJi2+/YTYn@nvidia.com>
 <20220921120649.5d2ff778.alex.williamson@redhat.com>
 <YytbiCx3CxCnP6fr@nvidia.com>
 <2be93527-d71f-9370-2a68-fac0215d4cd4@oracle.com>
 <YyuZwnksf70lj84L@nvidia.com> <Yz777bJZjTyLrHEQ@nvidia.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Yz777bJZjTyLrHEQ@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1P222CA0005.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::10) To BYAPR10MB3240.namprd10.prod.outlook.com
 (2603:10b6:a03:155::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB3240:EE_|PH0PR10MB5403:EE_
X-MS-Office365-Filtering-Correlation-Id: a7ae2a3d-4914-4670-dd38-08daa7ee2c39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tFUIed9znQpjO5k1XQ3n1cWf+RPCjRyLP9mYW/RNA3izuazUybfKYpHhvTph3AsaNfRyAphVvVGN9AGqHdDa8/vHxUIvITE73ipehX4Ag+q8aHw6x0UaKBXPc2TFwVQ6huXP5YtQ/C8YhJ1DU8j55MLjcmLEY7TaD/J3MspTkwSeeKXzSXFlK1p8WBPMDp7uMfJqtUd3hWZJFO4ybWDhWPHxUkIVdBj7pJX3e7OrfdrU3jCaqmdp+K1c2B3i413DD5+G7guJ9LlKk5Oc6P4tYR58rrQJtNr9X8hQeDMuZcgiTdlff100jRYpbM6bpyGl+kRQg5jsEl/IM9jgnio4L3x76DQ8C64nrrLtKruo5pnzErX073JAf+p3+EVh5QrwYXd87AhhRGKUip/jB4GButKdUg3GUlRuYmNGSrKJdT5o0v9fY9LrfHfRwBy163NhInkpkZ1rHNhzDEixy4X71Jw7oZsnk9jBJkkFx1jORG5Pu6vZ9uDwIyqiFfXL49QcSUd2VSQYhGtkElKeHxBl1b0XDpJW1144nhnurXkGqV9OCJYht7G8OufE2h+HM/eD3ablyqLXfo5qOyu6G9wGBo3WS0MyMJrxsmrsNMN3ATZThjweXT8gjqWQpUrZnhN8buYago6/lyakSmRit9zVOO5ecGHwGsnvagD0hrVV+vtjEnAO+SgFMki5aDP2YDKwU69yLMT6aTIyMDSIfcEbJrg4c/YDxNAxWysppaddyNw4OwCC3FPa0X95qVmToXXPipr2yIMQcxzli3j5Evojn3BNRzDI1ZAnBd3L+6h1NQcDI9ad1KHlqfB30eyXOno9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(136003)(346002)(39860400002)(366004)(451199015)(6486002)(316002)(478600001)(54906003)(38100700002)(6916009)(31686004)(86362001)(31696002)(6512007)(186003)(44832011)(36756003)(26005)(8936002)(8676002)(53546011)(6666004)(5660300002)(41300700001)(83380400001)(36916002)(2906002)(66476007)(6506007)(7416002)(66556008)(2616005)(4326008)(66946007)(41533002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QmJhTHV0eEE0Z2RVcCs1Tm90MHV3U3FvaUlOTmY3bFRqMzNnZHZTRStPMlZR?=
 =?utf-8?B?TlFHckJ6WFV1aEFPT0FTNEo2YVhzZjY5dlZRMGNkUUQxdGRNUHhoZEw5V0pz?=
 =?utf-8?B?azhValczM2w5NGxNdHpsMk9JYWZCeTZlMzJWVVN5NFZXMDBCS29EUlpQQzlG?=
 =?utf-8?B?UWRCeHRBdENYQUZrcUs4cFFNRHRTVFBBVlpKcENWOXZ2dVdrZEVwbFNiWXI5?=
 =?utf-8?B?dDlwQWNwckFxcGJFTjIvbjF6cWNrWm40QWRjWUlZdWttSzRXZHdXUENTZ0lv?=
 =?utf-8?B?ZHhCcEdWeDF1eFU2KzI1TTNQU1VUR3E5Yk9WNjZjRnpJT3Z3YVF2R05mcTI2?=
 =?utf-8?B?cElrbXB4d3dXTkFKZmNYaGVlcW5vQVY5VmRKVUczWjlRWUw1RlU5RHNlM3d0?=
 =?utf-8?B?dXhxZmxlOWxkWWFGWXNiZ1RsVzQySlJLdlE3S2w0MHE2Qjg1QnJMMXJyRGQ1?=
 =?utf-8?B?SnlwQWtKd1d6ZTJESGZhbnBNbmJYZkJRbnlOUFlLdXQxRmNYNTA4WmdIS293?=
 =?utf-8?B?K2lMYSsxbkNRb2tWMG1vTDI4TllraGRyNVVPemRkTkhnMjV0TWJ6cUdPRGRs?=
 =?utf-8?B?MHlMVVo2NW9KVEJMZnhJRW9IOGY3VFFrekVwWmV3Z05WK1NscWlFRVluUmY4?=
 =?utf-8?B?VFIrQzQyNFBTOWNES0dRRWxCdzVPL3crZGlXMmVQWUJSOWZJbVcxejBmVjlm?=
 =?utf-8?B?VHdER0NBNEUxTU5VUUpqY2trMUtRRjMzLzFMOHNQcTJmODdoV1dsT24yOGtw?=
 =?utf-8?B?VkFOZm1ycnU1THdMOXJvOHdYTjRrbVdUS2VJeXgyTndrY2VqZW16RFozRm1E?=
 =?utf-8?B?ZDU1cWhEd2VsVUg4MmFSQ1N6cUZVNHU3ald5S0hzWk9ETitFdSsxZUx2N3Fy?=
 =?utf-8?B?Z1NQSytnSWI1d1BsZmZwcHJ1a3RaUW94Ny96SnJwVVdjTFp3STdFWTFmS1E4?=
 =?utf-8?B?WGE3WDRMZWlna2E4anNIUmsxVzNhbWNsN29hQlM1RTNkbkZBODBOSEVYUWpX?=
 =?utf-8?B?UjFMWCtMTWcwUkFZRk1HRFBiRWRhSDBPRkM0VS95Z2twRzVYRGMzRzhoU2Zs?=
 =?utf-8?B?Q1BydXdjRnBKakUzRnlyL0VNQlB3enNyenZYeVFDZlRoWGhNRDlCYXFBKy8x?=
 =?utf-8?B?TDZocjlKMGVRS0p1cGtKWm1yNmppTWRKSk9lb2d3Y053c1JEYjFoSGxoRldq?=
 =?utf-8?B?TlcyWThNM3d4ZmU4TVhTVEkrU2JILzNOSDNtYnNOMkhOaUU4b3hXd1Bzd2J1?=
 =?utf-8?B?SldncWMwTGpRL0J0b2RKdjNNRThjdTVackl3M25JUlNBdE45cURwbFhjYTBD?=
 =?utf-8?B?cWtBNjV6dXNRZk9rL2dpbjJGVGsxNzJBdVBMVlhrb0diUVVlamFJV0UwNFFZ?=
 =?utf-8?B?aE90MFkzNjVBVGpFZzRwdkFkVjJ4dW0xRSs5S0t4alFGYmh2aWJjSVZiMFFh?=
 =?utf-8?B?aXlGSG1aYm83WTJyV1RpZVdvMUVzRHg1RHQ0dUk0NDlIN3B3RlExd1pDMThR?=
 =?utf-8?B?WVd5Q0RmSzM5UndmbUFtOHErRkw0RTI2TnU3NGRYWG1yaU5vZEVSb0tYZmF6?=
 =?utf-8?B?c1ZTdzQ3VlR6a1FBc0cwVnRZNUVJcWpkTXVBZW9zZ3crZXFBb0JGVk1Gek53?=
 =?utf-8?B?YUtMNVNScC8wUklyU0dtWFVESGE2M2I3aW5pSzZ3d2p4UW4vMWxYekUyTlJD?=
 =?utf-8?B?elpSeEpKZ1hKbHRKbEJncVFOWE9vZncySUM1S1l0TFFWNUJybHg2cG9oS3NP?=
 =?utf-8?B?Ri9ubEJHQ3JOWERMZnlXRHg2Q3lzZExUSXBPZUNDSlp6UkFialhwbTBMQ0g3?=
 =?utf-8?B?eTM5bFZqZGtMUWUzTkg1YitxenM4MTdZRU1YOGxqc1ByVThEQmpLcWtDK1I2?=
 =?utf-8?B?SXZtQ3dQcnJYTTIzQ3huN3Mzc2JkdzNwYWxyQ3JyVFJmaEM5UFZ0d3BMSWVs?=
 =?utf-8?B?S3BUV2JKMEpOYmxab01OVTRHbEp2LzJROFNRb2JXYk1RQUZKcG50QTJGS2Mv?=
 =?utf-8?B?eXdBWXFjSDdCYkRWZ1FHV3lSTHBJY0tjV2VhdTZzT3Q5eWNEY2xkUGl4U0VI?=
 =?utf-8?B?dEtFMGNENGp0QlpHL2x2VHZNWDN5bzFCYnB6Zzl1TW82OWplcW94cjBWSnhT?=
 =?utf-8?B?aDJXazhsTjJYa0Z6Qk9qa3A1b1RPYlFkWE02cTF3blptaFVOb0FoZnhxKys3?=
 =?utf-8?B?ekE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?c3VvM05EYW8yMHBvY2QzWlNVTTFoVHZJUHk2VWQvaEdZYzRtN09VL1B5amZw?=
 =?utf-8?B?cHAxNnV4b0VIZGxuWVpzVkhPYk1IdDhWaUZpRDhVOUxQTi9DaTR4SnJFeUsx?=
 =?utf-8?B?SlB5K3pxYmVSTXAzanpLbFZpRmZTSC9UZFlyQTBYZVlPeVp6ZmpaYVV2ZEN1?=
 =?utf-8?B?M1VoRnA2VkRyZ0JIem1mcktRY3J5WlJNVThpMXRDVEt5ai9mVW1mQ2RkeFpR?=
 =?utf-8?B?Uno4QlNqbC84UTJ2cG5WOVFUU3dQb2QxNzBiU3dXTmtORWI0TE5MUWpVVTA4?=
 =?utf-8?B?UkVRbks1dE56MUVFckp2emh0cVlMTmRqSC9pWjJCV0YySUtvVWFQNGd3R1lE?=
 =?utf-8?B?T2p0aURkTWtwUlFubjE3cGFzME1rZWdNeWZyOVR6eHg2NnRsb0xiellDcDB4?=
 =?utf-8?B?TjBjaFRSdGRUUVhrOUtEM2xqL2xNN0lFVFRIdi9EMXRidHhCcVE0dVpBSU1L?=
 =?utf-8?B?ejVVQWJXdXk2VkxjdUcwMS9JOU5TZzkrTUdHclJNaWpiWUk0ZkRscERPNkV0?=
 =?utf-8?B?ZndmNkNYWFkvcDJoeWVCWEtkN1lpbVRyUTZ6dnBvK2N3MklwUTJOc1NET25w?=
 =?utf-8?B?T0xNQ292d2V1ZEdVekVyNFh2ZFNJQzhySVJKSk9RcVEvT0dIampoUjIrOXZY?=
 =?utf-8?B?dVRQaW9QK1k0Y2hNRGtZVlVqQ1J0ZVZFUk5RZmc3MEZWbEs1QTc4Y2h6UUdo?=
 =?utf-8?B?OXVXdzNMeXRVN0FkdTY4Q1M0NHoyTW9BWXQraGJmRVdpYVJ1by91M3pLdEhB?=
 =?utf-8?B?NUdsbHRwRHFEZ21kWVN5K3h1UFpQRUxIc0RkL1pyUEZBcmM2c01RdEt5SEht?=
 =?utf-8?B?SnZMVXdMR3ZYeGdqTlYzc3pxVERGK1Q1TGJ6Ui8yekxDdm53d0ZoN1M1RkVu?=
 =?utf-8?B?WWZaeDhjaThYVkdFNXR4ZTRCR25IK2Z6ZS85Qkl4SEI5RnVObHhDZHJhT1M0?=
 =?utf-8?B?eDVZbzFNaG9hL0JybEJua24zR1VKT0t4aEMwVTUrZ2RRRG5BaktUdFlBVkha?=
 =?utf-8?B?WjBQbk9rSnlpMmhhdURGOFFPUGdJcWh6dzhWbGdMMk0vUlQxakVXSEZvZUsr?=
 =?utf-8?B?eFpKck0rTzROeEhHdTdBUHF3Q2trL0RERDhuYUNlSkxLSUF0VGxKTjBWcjdo?=
 =?utf-8?B?eEdLU3hvMVM2N1RRckRHNkhZTklVc2NCa09BTHF3RURSODlNdHE2MkdsOEVm?=
 =?utf-8?B?YUZjbnN4aEtKcS9wdjF1aHFIM0Y2aHJoMFJjSml3WUhwcDQ0Z0NWalc2WVZt?=
 =?utf-8?B?SUo2Ym5NK1M5TjFIY29hVDJwamw3Mjd1UG14RDZaNUFFWEVoYjRqK1kwWldk?=
 =?utf-8?B?WXYrKzNUUEw3N0RSQmNxYjZLdU92VXlXbjA1aHpRK1BiZGVWditjU2hLenJB?=
 =?utf-8?B?TmVhOFYrVjF4QXZ1eDdPVXNNNUN4YWtnZjg4WTcwWlBEMnJFSXowKzgvbWJY?=
 =?utf-8?B?bDMzZFJzQkl6bGQ3YURoUC85TUppeEl1SzY2aWQ1YVVxaXpnUWcwY01FVWFG?=
 =?utf-8?B?ckhHakpCSlpEWXFIajZqcmtndElHNCthdnFsdDhhQ1lxSkxoOVhXWFcwd04r?=
 =?utf-8?B?UFhxR2Zmb09sc3hRTWtad2R4UXRJcjZuRmFrNGM1V2xEY1E0N05Cd1diSDNR?=
 =?utf-8?B?dkIxKzRxZjlJang1aUZXYU1MZUpkanF2YUQ5RGhFdEtNRWQ4ajFnVU1nVnRG?=
 =?utf-8?B?dVlFR2Jhb2NkS21rYkVzTm5GVExsaXRYZWR2QjkxMWhEd2RkNHQ1UTdtZUcy?=
 =?utf-8?B?cU1PUTgra1RVYnpmb0xEVU5VMnBaRWhPYi93NUxma09yUHVvUXZHeGJWczFO?=
 =?utf-8?B?TElyOHRablB5bWluRjYxSHpvcVk0VjBjU1FkSUZlTEVkMi84T0V5Z3EzN04r?=
 =?utf-8?B?ZEtLeDMwRzI0dEphWEh1MU12MFB1dUV3UFlpaHJtTFVpM2EzY3d2dVh3Y1Jw?=
 =?utf-8?B?RkhGRUFjUGN1akpwS3JWeDJ5SElJekUxdk5xV2U2a0U2MmNBcWpqWFB3Sjd0?=
 =?utf-8?B?T3pkTlFJbjJSMUllZUx0UGh5RFVjZDRoT3M1Q0J0aXEzV3ZyT2h5RFV5QWY3?=
 =?utf-8?Q?mFLxjQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7ae2a3d-4914-4670-dd38-08daa7ee2c39
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 22:57:41.7703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J1u67PIDDgpTVaCM6i1/au8E06XQVt2eOAPEpd7cfD22fDOSJ9gzZW0STSQz13CW1KmJFiQ+ByMfiMsDuhRql59/ad3OAkbHvTlLFxEKDRM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5403
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-06_05,2022-10-06_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210060135
X-Proofpoint-GUID: bAAXSmrKH0cTl0BAsKPR6Bngq8vKBetx
X-Proofpoint-ORIG-GUID: bAAXSmrKH0cTl0BAsKPR6Bngq8vKBetx
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/6/2022 12:01 PM, Jason Gunthorpe wrote:
> On Wed, Sep 21, 2022 at 08:09:54PM -0300, Jason Gunthorpe wrote:
>> On Wed, Sep 21, 2022 at 03:30:55PM -0400, Steven Sistare wrote:
>>
>>>> If Steve wants to keep it then someone needs to fix the deadlock in
>>>> the vfio implementation before any userspace starts to appear. 
>>>
>>> The only VFIO_DMA_UNMAP_FLAG_VADDR issue I am aware of is broken pinned accounting
>>> across exec, which can result in mm->locked_vm becoming negative. I have several 
>>> fixes, but none result in limits being reached at exactly the same time as before --
>>> the same general issue being discussed for iommufd.  I am still thinking about it.
>>
>> Oh, yeah, I noticed this was all busted up too.
>>
>>> I am not aware of a deadlock problem.  Please elaborate or point me to an
>>> email thread.
>>
>> VFIO_DMA_UNMAP_FLAG_VADDR open codes a lock in the kernel where
>> userspace can tigger the lock to be taken and then returns to
>> userspace with the lock held.
>>
>> Any scenario where a kernel thread hits that open-coded lock and then
>> userspace does-the-wrong-thing will deadlock the kernel.
>>
>> For instance consider a mdev driver. We assert
>> VFIO_DMA_UNMAP_FLAG_VADDR, the mdev driver does a DMA in a workqueue
>> and becomes blocked on the now locked lock. Userspace then tries to
>> close the device FD.
>>
>> FD closure will trigger device close and the VFIO core code
>> requirement is that mdev driver device teardown must halt all
>> concurrent threads touching vfio_device. Thus the mdev will try to
>> fence its workqeue and then deadlock - unable to flush/cancel a work
>> that is currently blocked on a lock held by userspace that will never
>> be unlocked.
>>
>> This is just the first scenario that comes to mind. The approach to
>> give userspace control of a lock that kernel threads can become
>> blocked on is so completely sketchy it is a complete no-go in my
>> opinion. If I had seen it when it was posted I would have hard NAK'd
>> it.
>>
>> My "full" solution in mind for iommufd is to pin all the memory upon
>> VFIO_DMA_UNMAP_FLAG_VADDR, so we can continue satisfy DMA requests
>> while the mm_struct is not available. But IMHO this is basically
>> useless for any actual user of mdevs.
>>
>> The other option is to just exclude mdevs and fail the
>> VFIO_DMA_UNMAP_FLAG_VADDR if any are present, then prevent them from
>> becoming present while it is asserted. In this way we don't need to do
>> anything beyond a simple check as the iommu_domain is already fully
>> populated and pinned.
> 
> Do we have a solution to this?

Not yet, but I have not had time until now.  Let me try some things tomorrow 
and get back to you.  Thanks for thinking about it.

- Steve

> If not I would like to make a patch removing VFIO_DMA_UNMAP_FLAG_VADDR
> 
> Aside from the approach to use the FD, another idea is to just use
> fork.
> 
> qemu would do something like
> 
>  .. stop all container ioctl activity ..
>  fork()
>     ioctl(CHANGE_MM) // switch all maps to this mm
>     .. signal parent.. 
>     .. wait parent..
>     exit(0)
>  .. wait child ..
>  exec()
>  ioctl(CHANGE_MM) // switch all maps to this mm
>  ..signal child..
>  waitpid(childpid)
> 
> This way the kernel is never left without a page provider for the
> maps, the dummy mm_struct belonging to the fork will serve that role
> for the gap.
> 
> And the above is only required if we have mdevs, so we could imagine
> userspace optimizing it away for, eg vfio-pci only cases.
> 
> It is not as efficient as using a FD backing, but this is super easy
> to implement in the kernel.
> 
> Jason
