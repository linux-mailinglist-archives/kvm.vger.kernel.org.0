Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314827D1731
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 22:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbjJTUmJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 16:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjJTUmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 16:42:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A8AC0
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 13:42:05 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KD8wQ1029236;
        Fri, 20 Oct 2023 20:41:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=b5wh8loEkEcewDJwqVRuWLlwCjydcobm/7s+d0/xalE=;
 b=prD9BU5fIUZZs91avp2e1gaaCpKB9rGDEfg4ibfh9xK7S2hLFD0YF7hwUPhRl3RuYstJ
 uicsRMa9cLefzcVaG8U2uVmoM6GZ4bhNMM5Fz6W9zw7hFOlmq0CiqQCQl8hJ80p2zODB
 ATUYvW3otGc//xqSDmkf375d4GfnbEhm8cI81Nhg901bSnfobbKeIgXMUO7NisqEjneH
 L7ybYaxwqIc6662gIPAJ+7VVtjNXadQEWkOgBkEtsoqaFmqkfL3gIAaGgjgbm+f7pFUc
 oO8lF7PQvWFQByK3QbQPwaoMshmZOQR7KViC7Cvdcalt/IrCvyWOG8CriaalzKo51fdd cg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tubwajnvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 20:41:41 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39KIgIDn014239;
        Fri, 20 Oct 2023 20:41:40 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tubwfrvv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 20:41:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jW0NQLPQhza/jJTIWznQHdcEPytiURmLcK+26U4qb+RUXUbgXuGp7zLmRzoc378XaXglCq48UapdGPhOBUcPeh0yg/EDFTuV4CXxum9pgCXOH8epG3hzkP1X6jJf4Qi+lmEb/jrsgFEjPlSM7BIlzFXF9Bq1l9W5ZiV2AbI/6JqMah3IjGjh4enXMzcRmdS7JXmRvNEXEtAqqYw3hCcetwWDF71l5cveWeW9a3dUBWRF1KKj4JDuJS8ti3jTKZkfa/nWB0xdPrjlhtlfwaebrNDlE/RUnSN2Tlb77gzWlIlI5XEB6Kyo2I+M3SvVdOPwC+rhI0/zN3v/ppdN5GEIZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b5wh8loEkEcewDJwqVRuWLlwCjydcobm/7s+d0/xalE=;
 b=Z9EqXIrJJrGOy1GwxJ0vMHZwrhIPRTcFNE8SRSuCXd7TIKXliA82YLV3ERsw3D5yunbuKopx9rAan9QDTpSrcA2C9rqAKqxsiYMYNuPkHnOqL6YJB8sIjeKpkPYSFwMOpU7cuDtYSgqoiAV8VkdF+lleCPFvRwhkkhFOM1eQYFziktdJp+1f8/3vzwd+utixl7xsWITBz4vdvJ2nJT8p3A5d+nmDt8BCrVd7PlYlLsFo92eIJoLTIyTuBErXy80+HJa1JxJ51fzofj3SDiW1WQ7TL2cybO/bq+cArnH9g+tV0nRqARmxqUCP/miRpcoxHo5J2ckJ3643sLzTzi9HXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b5wh8loEkEcewDJwqVRuWLlwCjydcobm/7s+d0/xalE=;
 b=ol1aqhn70s1QhNb62LxC4JwBomrzEUO1yq83QaNuNwAjDrg2uYUdebwU+QW5Zxlac5Kteyvzci6CJByQSHIM9NqUpBIhxOmWpgP8nhthQa2ttpHgG8gbuNkffPWjxcIRm2UQDi/mXOWCCuGWXKRCNu4Y/Qv1picU70QtB7WxBxI=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN0PR10MB5983.namprd10.prod.outlook.com (2603:10b6:208:3c9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21; Fri, 20 Oct
 2023 20:41:38 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 20:41:38 +0000
Message-ID: <cceb6452-3401-4bd1-9734-816a0fe6cb1f@oracle.com>
Date:   Fri, 20 Oct 2023 21:41:33 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/18] iommufd: Add IOMMU_HWPT_SET_DIRTY
Content-Language: en-US
To:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-7-joao.m.martins@oracle.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231018202715.69734-7-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0061.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::25) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|MN0PR10MB5983:EE_
X-MS-Office365-Filtering-Correlation-Id: 023ec51c-b879-4190-e357-08dbd1acf504
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: doxwKxo2dIIND0p5VSkh+Xmkx0CHJcd2sa7OxVj+FyhAqiU7lQ8tNkRmx4KPGnO5oh0O1iESgb6BqgKTGZOwks1LolVXlut32EaSfUXFIrKJKEyy2d4N466gsGQqwaQi4sxYQAtvsfy4FvpY5xqqs/cM5efPdEPwRbcMDs5PpyN5qzGq0C7TAMqfUWvoyyIGhg0K1KBXgqP1MBq7IM/cqD+uJxKGwAE390mQ2LmUpim0hQ1QFy5CF05IjQN5sVevD6TVokAeMbAYJHYWu7qpEIW9AkyMpvgr1uxP6Qsc6iUpDzHZzDOC++cp6eMNrVsjx6MAWnfJjmdhxoO7kVMiFeoVGXkBfXkUD/yfItOVVjdhuMUKijAtWeffT8JqduPTzwI1PjuNb5w0pi3d6QPDmCNW2EUNswdUlIlfcmK2ofKH+yTJvNzqS+WDQfsVCZC6dxZDX8EyvKe9KOXj6GvncVZ+X7M5VKPf0IDU04R9PbP4u2bDZrpW0QWL0LXrbIKEJbg5r83joyzMqirfobBfZr8itnS4ov7UNPr51QZgpVVw1ImOy7G9vh5PTSe09febgnMitZz5dopnkVKIRLehoJQFu5iQ7xr4luAPN6vH4+4gQSLAMqxwL+Qtepj2jddFqtnBOP535jr5l+l5MUBrslEpAHxwDaMWMHnJLqAGUE8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(346002)(136003)(39860400002)(396003)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(36756003)(31686004)(53546011)(110136005)(2616005)(66946007)(316002)(66556008)(54906003)(86362001)(38100700002)(66476007)(31696002)(6512007)(83380400001)(6666004)(26005)(478600001)(6506007)(8936002)(4326008)(6486002)(2906002)(8676002)(7416002)(41300700001)(5660300002)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDk3Qy9oSC9IV1B6SStXNUdRNGJGNnliZlNKNHcyNUxjbEtWc1orTjF1dHZW?=
 =?utf-8?B?aHpvYkVPckZ0dlVrK2Q1bTg4SFZZVjRnUVUwdHNqZ0lxT1RpR29aS3c4WXU1?=
 =?utf-8?B?bXpQYWYrSytncHh0S20xUzdqd1c0T1l4YUNxdWZJTEFZVHF5N2MvRWhqSUZk?=
 =?utf-8?B?R2hSak1Ic1ZaUktZeENlTUkzMVNRK20xSFBRcC9tMmJ0anZteDAwaE1SNUVr?=
 =?utf-8?B?NEVLWjkvaCt1dVQ1aXMrK0d6R3JzU2g2VktCSjQ4L3JmZlk3dXRiZGNiQnk3?=
 =?utf-8?B?YklrTlg1L0h2dmFiMldxU2FVQzNFK2NnSzRoS2g3TElBazZ3bUI1aTBDVmY4?=
 =?utf-8?B?d245TmZFckRPb3Q0ZHk2ZldNeTRkcU5tcG1lNHpJdGJObVo5bmM4MS9BdmpF?=
 =?utf-8?B?ZEdGT1FheXVYa29lRS9vZTc3MlVXeUtuQ1RUd1lqY3BrMDFBelJ5a3Nuc3dV?=
 =?utf-8?B?U1ZJdFBRaDlkZEFiYUJabzZSTEFjOUdrY3ltZG5rd1FjZHIrb0c0a2EvQTZK?=
 =?utf-8?B?bm1qWUxVbUxEQWg2d0JabVlvT2dnSjRzKzdaS2ZSeTJXcHQxNVZ4ekI5eWFl?=
 =?utf-8?B?RFIxUDQyNUZiaDFOdzNaa3FnWjNSUGVUZ1doOEpRajJKVVI1L2JlclZLY21y?=
 =?utf-8?B?ZFhWMGViYjVpVERjRGthZTNRWEJTbTZCRW8zbkZMRFpBTnErS0RyczN0WkQy?=
 =?utf-8?B?aHYwRkY0K2ZpeE4ycG0ySHdvL0p6ZWJBRFZjNWY3dnE5RkJveHJhdkVLaVBM?=
 =?utf-8?B?U0krd2FldVNUeXY5WXgrcDczN3NRQjkvbm14aExHQW1xYmRZRUI1ZHdLdUxK?=
 =?utf-8?B?YVV5WXJObGtsbnd6c2RaMU1idHZrczZMeGxEOWJNZ2lsd25Ya05oQjd3L0t4?=
 =?utf-8?B?c2FzYUtWWHYxc2xobkg0RXEzR20wRkxPZkpMTGdTK1hjeElhNTg1NTY1VGEz?=
 =?utf-8?B?U2x3ajZZNkoxSmJZUkhEMWhKeVovdlliRTkrU0R6Z1lGQ3BjU0hBWkxtQ1ll?=
 =?utf-8?B?NXNrZ1ZWdWRIN3p2a1JCUHFKbnJlTHpQcUtCajdLUW1EbGh6Rlg4dTdFNmRG?=
 =?utf-8?B?NG8rbDRTYkRyTkMrTUVJVnJhWFpaRkd2Z3draU5sWUcvbkNxQXlZUE5NQ2NO?=
 =?utf-8?B?RmlpTm5lQ3J0dFo1UzdISW12R0NOT0FwNU1ndzVQNW5EdHlXYmRGZUY3cldP?=
 =?utf-8?B?cjN0TE1KYkQzL2tNbnEwTVpOcUhzVFBJYnMxRFJISmFha3lhSFFXbmJMYk9U?=
 =?utf-8?B?S3RwVUo0ZG4vUlNLaFJJUFppeEtHTW9uWmJwc2tLUEREaWYxUWZtWmhMc2I1?=
 =?utf-8?B?eDQ1L0lsQy84Wm92a2ozbGIva3FPY1VSajNlbGpPSkZGaUNHQmRXa296R0pp?=
 =?utf-8?B?d0RjM1hCc0ZaZ1Vod1BHWGZ2SnZaaXhjMVZBbzd1UXBDZzQ2WnpTQkxDODhE?=
 =?utf-8?B?RDM0S0RpNEZkTTBSSk9pN0NwanRqQmpJOWFLRXIydXNUd2VsZWZYTHlZdHM5?=
 =?utf-8?B?bHFNc21yZVFjcHY5YXVJUXdaTHU1a1lvMDJKTVBYYnNUenkrWGIwSitiQ01i?=
 =?utf-8?B?eEpxc21iOTJYQWpTcnZENVZCMEFTRHBhVjJ3VWd0S2NGdngxQi9HQlVuYmVT?=
 =?utf-8?B?YUJpaWU1NEhOcGZpckYvYmpHQXFyS2trOXorUHpVMkRsMUMxV2IzRDU2Wkcr?=
 =?utf-8?B?TEpmYmZHNXlrWjRkdjF6L3dza21aKzMwQ1Jsdzd1R1BsRUEyTGEzaEdRTlJU?=
 =?utf-8?B?eW02WkF2MHA0NmRjcWJsYm82ZTFtL3F4UUhZNEs0eTZJR0xrKzg2eDkzVU5C?=
 =?utf-8?B?TEVTaGw5eXhzUFZDZmxpdm1nbElEdnJ6ajZGcEpmMlVCajdiN3VtNTFkdzRm?=
 =?utf-8?B?ZUdSQ1laWlM4MlFZWHhqMFZVQkNFeWVCZ0NPT1BYdEV5d2JHcVpTTnNZRnBH?=
 =?utf-8?B?cU84UFVKZ2RVelpOR2JpSDdNT3Z6L05LcXFIU2F4VzhPNVlCZk0xbllpQmJq?=
 =?utf-8?B?YlVwdnJoWGhwYWdDMFdBMjBMUjNZNlJXbCtneUVoOUZPaytRdVZWeS9GL3da?=
 =?utf-8?B?V2VYNGZvc0wyS1FOOHYxZ3BETXoyOG92Ymt5YWlPQVB1Tm5RZUswUi9iUm4v?=
 =?utf-8?B?RUdVVi83K1VibHVEV3pFd3I3UytUNFZQS3V5QTB6YjFEZm11K3JPdURldko1?=
 =?utf-8?B?Qnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?MlRHS2JiTmx3TU03ckxFbXZZT0RzRVExNDBCaHh2akVCWUI3d1VQZjNqbncw?=
 =?utf-8?B?R0oyVmtER2dGTlhXSE5PSDBEUzVtVDd6ZjRBS2ZUZHBzQUUvNEpicGVPWHdS?=
 =?utf-8?B?YVY3Ym9FR1VubnBzUmp5MTB6TUdCanBUVzFIcnZkMG1xMDhjR1hNdERJZlZ4?=
 =?utf-8?B?ZkRnbE1hT3N6VFFMNEJtNWppUElXaCsrVHQydWRLVjdVRHNFU0gxWXMrWUo5?=
 =?utf-8?B?Uk1vVlVwcE9HdlhmRjcwODV6M1p0bzdIVjhYYTkzT1hIcG5haUoyRVB3anJM?=
 =?utf-8?B?WmcrWkxSbC9nZzFoMmxBSlh4S1p3dGdaR3loZHV6TVFtU3ovT2hhb2d5dGx2?=
 =?utf-8?B?VlE4TkpvQVBaRkp4eFAwUUljSmtlUUVySDJxMlh6YW1LRjcxY2FUUnBSL3JV?=
 =?utf-8?B?UjZnbzNhbldmVmI5cm04TFdwNlJOQk1uckgxNlo0YTdjR0o2SGlnSGJrK2Yw?=
 =?utf-8?B?QUJvT1JTRFhiRUYva1NjNkdFN2FvTFFsNnhOUWg5ZTZZT2V1cktxaTBPNHBQ?=
 =?utf-8?B?cXZFbzNSMVZFN2c0b2dQc0lIMWx5RWhjTVNSTXNKci9ITkd5TXZEaC9Lcm0r?=
 =?utf-8?B?MXJXUHZVeVgrcXV3WUhGUlVzL3krdUtnakRJNEorbXBEWTJPNXRKcndJT3Nm?=
 =?utf-8?B?bFExb1BWTDVXdkU1R3JCOWp4L2xsVlk4am50MkU0ek1VL2drVVlzUVRxcXE1?=
 =?utf-8?B?cTkzNTNvRWR3Ti84Nm40N0krcVFsOEZHc1BwRzd1VFJpbkdFR2VaRTRTU0Ur?=
 =?utf-8?B?VEpvMkhEMVNnWHhYaFFQR3QwUVV1OE1rYlNCYkFuU3QxSjFKWmFkWjZGbW41?=
 =?utf-8?B?WFZyNWo4bmN2YVBKMUdDUWNBbFlGTWpWYzYzdElPRFlBUWdWbm15TmJ2L2xr?=
 =?utf-8?B?U0JTMXpIbHRnbUtYQWUrdlJpUGJaTlY0ampKaHZ4c2FENktZMzl2QTR4TVFk?=
 =?utf-8?B?NjEyMVVjd1JJbnRiVXRzSXE1MTdSWWlPR2lUQzBrUldXcDY5bi9CZDBaZ3R2?=
 =?utf-8?B?Z3Y2VkIrMGxndUZ4MDNxaTdZb3hiYWlKQ1B1eG5MK0dYNXZINVIwWnpuZTNw?=
 =?utf-8?B?cFhLTWpId1hRU1oxc0NTdzcvcHhGN1o1T2JxWFNyeFEvb1NiV1lGM1dpb2po?=
 =?utf-8?B?TlpLNmkrWTdSeUR0bWl4TDc5cTdKRDNIazRhVno4dklFM1ZVNmhtR1BjNUs5?=
 =?utf-8?B?TUNmRHpQanp1OVE2aHJ1VXVGRlc0Z2pUNDdkWkR2UU9FalR4enpRYk9nV0o4?=
 =?utf-8?B?clJuSW5FbmN0Ump2MndDckVxUERZWmd5ejVzTmo0WWJCaDhLT3U1WGtuME5V?=
 =?utf-8?B?RmhhL29pMzVvV25qdXVmRTRzdloyeTdyRzdNdllzWC9WdmJPaytWZGs2MmVa?=
 =?utf-8?B?R3Nkd1dXdHhkZFJHTHVNN1F0UXdhV01XVTVEWUhoQkhYVTZqUUdBbVBjNnl2?=
 =?utf-8?Q?XEAnY+uo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 023ec51c-b879-4190-e357-08dbd1acf504
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 20:41:38.3227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3iTy4x4Nj+23vs00vLHQDQFCdmTf+7dV4CuvSRRuWiHn5hp+rN2p3gpvGf9HybVK6TZrfjgnHg1SGlIGpzbUudZYgMTCvk24DDBG2ZbxDxA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5983
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=905 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310200174
X-Proofpoint-GUID: vNTQLTAIliSBS7GGCQtX9Ix2w2YLAob1
X-Proofpoint-ORIG-GUID: vNTQLTAIliSBS7GGCQtX9Ix2w2YLAob1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/10/2023 21:27, Joao Martins wrote:
> +
> +/*
> + * enum iommufd_set_dirty_flags - Flags for steering dirty tracking
> + * @IOMMU_DIRTY_TRACKING_ENABLE: Enables dirty tracking
> + */
> +enum iommufd_hwpt_set_dirty_flags {
> +	IOMMU_DIRTY_TRACKING_ENABLE = 1,
> +};
> +
> +/**
> + * struct iommu_hwpt_set_dirty - ioctl(IOMMU_HWPT_SET_DIRTY)
> + * @size: sizeof(struct iommu_hwpt_set_dirty)
> + * @flags: Flags to control dirty tracking status.
> + * @hwpt_id: HW pagetable ID that represents the IOMMU domain.
> + *
> + * Toggle dirty tracking on an HW pagetable.
> + */
> +struct iommu_hwpt_set_dirty {
> +	__u32 size;
> +	__u32 flags;
> +	__u32 hwpt_id;
> +	__u32 __reserved;
> +};
> +#define IOMMU_HWPT_SET_DIRTY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HWPT_SET_DIRTY)
>  #endif

Notice a docs inconsistency with the docs compared to other ioctls which pass
flags. So applying the snippet below to this patch. Will be doing similar thing
to GET_DIRTY_BITMAP patch, except that the GET_DIRTY_BITMAP patch says "Must be
zero", and then change into a similar comment as below when I introduce the
NO_CLEAR flag.

 /**
  * struct iommu_hwpt_set_dirty_tracking - ioctl(IOMMU_HWPT_SET_DIRTY_TRACKING)
  * @size: sizeof(struct iommu_hwpt_set_dirty_tracking)
- * @flags: Flags to control dirty tracking status.
+ * @flags: Combination of enum iommufd_hwpt_set_dirty_tracking_flags
  * @hwpt_id: HW pagetable ID that represents the IOMMU domain.
  *
  * Toggle dirty tracking on an HW pagetable.
