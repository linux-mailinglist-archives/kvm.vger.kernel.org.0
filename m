Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1936F518365
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 13:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbiECLnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 07:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233066AbiECLnS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 07:43:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0223525E
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 04:39:47 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 243B8MGr029440;
        Tue, 3 May 2022 11:39:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=BrZHOJ3Ak3N2ruF35M2+qJSRf4Bi3VxMmsIXicDgTFo=;
 b=Kgcj3s8LEHsqNCtlOWUNb4y5E53xVM1kGe56KIMctS3KJbqCQHMBhOysnO6ANYMTuhPZ
 I7wTt2IwODsRzQNHsirWJBZns3FrLNliHP3mstVwxWzgB+mKYEbbGn5sEGKd9aDLUt5B
 5p1JFuXsCPzbrbIiUnZ5UzeI07FtlRRfub5EBVoPSjj41ciu5Tbph/dj5DwDKAmITx7U
 uPpE9rzwFGmqWA3O8v19dBvWZBwsVFWx2G7D/RxwdmENQmWTzRmWgVlMLgLErjsIHGRX
 iIuJOOrqklamtS+ahV9cplHt8NH+tjwK/QiHl0KeKvYSzDKgQ6yAsyTH6cEaunUKPIPq xA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruq0dgar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 11:39:39 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 243BVUra002750;
        Tue, 3 May 2022 11:39:38 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fs1a4mbjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 11:39:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PCzXHbvTRFWNA68fumCixe4HxmJA/m+96qNxE5kH28ZyNu+GZqt9WPDW427P9Plkay2M1/cH8m4/CEgt8Q2CSxBP2PG1bQ7O8324KiPfLu3aTYeZprspmdcShaRo+Y/gTVJVxXUbmGNUfYyhfXRZFVKjE4uOIMNVR79sRyyyZtX2RUjoRwCF8WmDiQG8JimKPE81daxlfOK7ZmGk58Kz8g4Ts+47zyjtAtLDirZuGZCJLBsjIbxTVa7G8Z94jKsnRNWVIWYYQXJY0vPdRag7hE38b/f4gi91xoqh1XZO3C+Wf/DNyw6jQ7Ro0EUFLTKX2GtgXf6OmcTwmZPDQYDA6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BrZHOJ3Ak3N2ruF35M2+qJSRf4Bi3VxMmsIXicDgTFo=;
 b=jrGj13fUKMjCuRSG/z2l5+XwNMbw600kJf/flJ9oDmeyo4k/4JlQu1CVnMNx/uiNxLdmgD5O2N8KI8NnfNLq9z5lEAcC4TRkmOypa7Bae4JzSSnFE2Pjl1Np1ZVE25QNIxsFCEFXitIK85Gn1zLfK7ctfRy0dGCo73dLnoKkYruED1U+IMsiIv1tasacyxxYfzFIjsCbThfl2OeAwQf1ggquZpZt6CusWfkeaJOaBgOeRqgi2EB8jjThuwMOyxup3ByanIDGdHaaRGhL6/iZWurW9R8ui3kGa7ska31+bbGKOildQeyXBuUCkMFW7LgqxtnE/wBpapzXRtM/oiZ6kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BrZHOJ3Ak3N2ruF35M2+qJSRf4Bi3VxMmsIXicDgTFo=;
 b=vGmINpctoId/6W+YSCZShUu64Hm3h9YA50A18i4TUQu98mHuoyreEDK7TUeLJYA/q4/vxB27XEa4xMVRimNN3XijshMCqHav3159Q+wEM5fBcK/tkJ1Y1bFmk/XPGTKptzJLvn5bxv41yi0jEXp9M1wQAZvEJX6Gk5FjNy0+bQo=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH2PR10MB4200.namprd10.prod.outlook.com (2603:10b6:610:a5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 11:39:36 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Tue, 3 May 2022
 11:39:35 +0000
Message-ID: <edfb253b-7f48-abad-f39e-f2937f97afbe@oracle.com>
Date:   Tue, 3 May 2022 12:39:27 +0100
Subject: Re: [PATCH RFC] vfio: Introduce DMA logging uAPIs for VFIO device
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
        maorg@nvidia.com, cohuck@redhat.com, kevin.tian@intel.com,
        cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, eric.auger@redhat.com
References: <20220501123301.127279-1-yishaih@nvidia.com>
 <20220502130701.62e10b00.alex.williamson@redhat.com>
 <20220502192541.GS8364@nvidia.com>
 <20220502135837.49ad40aa.alex.williamson@redhat.com>
 <20220502220447.GT8364@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220502220447.GT8364@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0336.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::17) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e879bb56-12b7-4bf1-cf5d-08da2cf9991b
X-MS-TrafficTypeDiagnostic: CH2PR10MB4200:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB42002A50AFFEBD4BCA44514DBBC09@CH2PR10MB4200.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kk9a3+rsLLaNa1UR8G4hZAKP1RUAfRa/e0dSCX2ub37P9FnBbGquRqayNIv5JoIyckOZuPzJNI9/m0CVPlqrRCDMh8GIaTKSwAq3GsHkEhvYMJGs4HWbHv9uL3orybBkmVLgnvy8qwfq01HB+CCz+WeX5qJ2L620d/O/zFWxTVG+SCcNrODS+4QBqkI6WVsWWKAFcWOxiL5sKMp/VzKP94RudjlNDkyZfxMzEHEN3g/aFCo9K8L0lok0xfXA4dW7u45l+FF6Ln9TL7a9yzFe02/wVd/Smqd3Goh0ucjKSaetjbnkHIm0w6QMm72EqwsagJL/PwyoT+X+4omDqvdawgLtVxCejKuBmD+QjLGK/MIrowjpKBZWmdhs9OKF7YsNVrLHDbPHMsJZfK0CUNsm9jXpBSGU976HwI8mS+6A9yB0L3AYJlDYi1ZCJIYq4tj/EhUxEaqnaDKJZPTGbydKq93313Fn6xc+26viScrBatl6hNPG5g4VUT94yDFoJZPL1tTlmyrlDO4Nl1ptb82nG1Hmy9/8JVIAPhsd/W5byWpRpT8i3NFzytXWCrDM9heiJeHo9CKjdz45o6Gsj7BsRECyqlFSArB05Mxb6wvKMsAPQH7y6DdBoit1hKeyrqRISs4Zfdiqdw6YKefvfqInKJrnp9orezjns1vOGDqAWGtanL5HxhoIAE3BzutrgdvSGgD+DfwkorEMC6cgS4oV7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(5660300002)(2906002)(4326008)(8676002)(7416002)(508600001)(66556008)(66476007)(8936002)(38100700002)(316002)(6486002)(6666004)(186003)(31686004)(86362001)(2616005)(36756003)(26005)(83380400001)(110136005)(6512007)(31696002)(6506007)(53546011)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MEtQNmM1SC8rL3U4aTlIWGNJZzF3ZERaL0k1UXhtY2RPM3dxelh6R2UvTGNT?=
 =?utf-8?B?VGZTZ3RsVERET0xyVlRhcnYvcFo5T0ZJZEt1M2RReHdZK2RYblRPdmUrcWhE?=
 =?utf-8?B?c0VLcWE2MDZ2YkUzUlJJdHZpK1dlMUtIa2wxY2svTHc5a2xlQjVHSUEzbTda?=
 =?utf-8?B?bGF0OER4a1prM2FwQndpakd0d1Jtald3QTRLa2ZNZ2hhbDMrT1JnOU1WVkRa?=
 =?utf-8?B?UDR3UGlJekpwckZab25GNDJlVXlWOTFWZmd0bU9UM1RLWHdRaTVGQ1JvZnRs?=
 =?utf-8?B?VWZnRVdPa3ZKOFl0RU16bWpnSkJEYTU0d2Z4S2crRWZEUDVqYWF1djhNQ2c1?=
 =?utf-8?B?R2JtcTlXaDFsalJQdjgzaTBrcnNibCtmd096NmUvR2MzWFFUeDJuRU4xNWM4?=
 =?utf-8?B?b1N4dWhKTWkrVzZxUDFFQjZzZkp4Z1ZobndFaUNndW1qOThvR0l3cEFkQXkr?=
 =?utf-8?B?Z3lPWGtNRWNlQ3A2OHQwUDdIS0lJQzV2d0xmRjVpU1kwSlluREM4bTZVSWpq?=
 =?utf-8?B?VnU0a2U0b2laeC9hNWh2TVBzWlAyYVA4NHU3emorUUk4NGV6bFJmSGszVzdh?=
 =?utf-8?B?S1BIU2NGWGoxZmR2cHE0WlBXb21nNDJ2cU9jVHllc1JTbVZnclIwSmJjQktq?=
 =?utf-8?B?M2wwL3RqNi85c2dDYkdtNUlheVZKR1cyWm9MQmpxbjVFR2MrNS96RmJFeExs?=
 =?utf-8?B?TjVzaXl2RWNROXZiN3kxbmFUSEpFdVdXU3ZOUVFSRmtSVXNONmtpdjVkK1RI?=
 =?utf-8?B?ck9uVCtEZHlJbGQxUGhZUXAvL05IeTU3em95Zy9tbkgwb3lPN2Y4cjZDU1JG?=
 =?utf-8?B?RTFSOFdhcWxLSHA3OTMxRmIxdFcxdksyTHBRWGZqR01IRXM0UEM4WE1kMlBt?=
 =?utf-8?B?SlFaWXZNT0hJcUozSVNJVStaL0FoNkRUNXZVRTBYY0ZYcVA0WExlOVlqSFRO?=
 =?utf-8?B?TGF0dDBFb244Nk5namVQVGwvUTBuanhVU09QbURyWWlUVE5VcmUyYnhCRmRw?=
 =?utf-8?B?MDBkKzY5Y3VwRDBTdVYvT2k0N2Y1VW1DN1J6aGh5QmY1UUVJVjNDclpKa0g0?=
 =?utf-8?B?NElrc0JXR0pjdjRLak5VMFhrUHRta1dQdm1iSEQyZ0RyUmxxNFlIMVdWZUNn?=
 =?utf-8?B?TDRVMTFqRVBhM2t6dVU3VFJ3SnBVbUQxd0c0Rk9NRkRxRVE0M1FYaGVwZ1lZ?=
 =?utf-8?B?eGlyOWxlQ25tdC83b3ZjVi9mcldNY1NpTmhsaWtOOTU2MjFOSjlBaGNIOGRl?=
 =?utf-8?B?cTZKTjM1R3FOTWVCRE94cVJlWUVEYzROUC9ROTJZekhBbFBNRHduaHdVeC9n?=
 =?utf-8?B?VGh3ZUFpa2V3aDREcVpUV0FpU3VvMTVKbEM0dEo4cjhIZzQ4Q1pCWVJISzYw?=
 =?utf-8?B?b1JrYkFmbzhCRGw1TXlQWWZIYmxNT0pjMTJKSXFEem1UaTA3ZXpyOGxaU25Y?=
 =?utf-8?B?SGxqeHdGMGNvSzlFSWxYNW9YR2RBNUhobWRDMWVLNk51UHBvck8rcm1jVzdI?=
 =?utf-8?B?aTRZZnBMWnlaamtqV0ZpK1hTbUJlNGZucFZIcGxNaVdxTmdydmxqZkttUlRQ?=
 =?utf-8?B?WlArWEVJZDduL09JeG1NYVhPaTRkaVRzbG1iMU4wamw1MFpGUVplNGxIZ1Vo?=
 =?utf-8?B?c2JwelBXaGN2Rkpyckc5YkdvN3pjRHFJUnVqVXhobEtIVkhRVmVtYkNxRnNw?=
 =?utf-8?B?cWtHczhsekZLa0tERWZ2YUd6T3haNktyM0lNWVhXb1RRQUpFOXplQ2w0ZTds?=
 =?utf-8?B?aWZnS1ErK2xzVThSNkxUQjJwR0diRVRFWW9GNElSMkdaVzFDMzRoZzFqNW92?=
 =?utf-8?B?UHZWTU5Nd3N1RkJKcC9lN1BFUlUwSk93MVFQVS9TVjNCMWUzZlEvRjlxVXcz?=
 =?utf-8?B?SHlyRElVZ0tqcTd2NEFrSFFsOWlYbTlCV1Z3QnNkNTFXRGVDRDdORFFIVCtH?=
 =?utf-8?B?VjI5Z1NYU3RZSC9hNlNSZllwSEVjWXVGM0Q0cy9kcmdWWmFNYWE3VGlhZjgw?=
 =?utf-8?B?VnB6UUhVTDFRYTFwSXpsQzhKaktvQXRkYTYrTTlJQ0VlZzI3TDRFTFJiNERK?=
 =?utf-8?B?eUN1YUxoR3pia3J3L1pSRkJmOGVuS2ZnZ3I2YzNtSWxIOWhEZGphTlVMbk1u?=
 =?utf-8?B?NFl1bHN4enZxMkJuWURtTEl6YVdBa1BpTkE4VWZoem5LOWM4UmttUmk5SWt4?=
 =?utf-8?B?NmRSN295R2NZOWhZMldibWpOWXpYajZZVU45Tkw5N2l1dDJ6eUp3dlQrSm1p?=
 =?utf-8?B?NVpMSVpwVUx4Mi9nUUo1MEY2cXVNK3U3Y0oxVXlicUUrMHhuSTl4c29OdFpN?=
 =?utf-8?B?OERzcExvc1VON0xWZFBYbGlmdFVEQlhVWTU4NE56MU9TVTlMdDV4NncrUENN?=
 =?utf-8?Q?4COdpiZUhudwNPOc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e879bb56-12b7-4bf1-cf5d-08da2cf9991b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 11:39:35.5124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S5EN3+rcb71sAFqaey99AKL9/fIw5hO1WmBaU7eui8lPQpsdzPA82rRxfGUoLoZyiYJT+DCZfs86+D83B5NaUQGSs4aVvgcDxL8qmW3xWK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4200
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-03_03:2022-05-02,2022-05-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205030086
X-Proofpoint-ORIG-GUID: yZd292kq99a2wyf7EtolK10CQE30VoIG
X-Proofpoint-GUID: yZd292kq99a2wyf7EtolK10CQE30VoIG
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/2/22 23:04, Jason Gunthorpe wrote:
> On Mon, May 02, 2022 at 01:58:37PM -0600, Alex Williamson wrote:
>> On Mon, 2 May 2022 16:25:41 -0300
>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>> On Mon, May 02, 2022 at 01:07:01PM -0600, Alex Williamson wrote:
>>>>> +/*
>>>>> + * Upon VFIO_DEVICE_FEATURE_SET stop device DMA logging that was started
>>>>> + * by VFIO_DEVICE_FEATURE_DMA_LOGGING_START
>>>>> + */
>>>>> +#define VFIO_DEVICE_FEATURE_DMA_LOGGING_STOP 4  
>>>>
>>>> This seems difficult to use from a QEMU perspective, where a vfio
>>>> device typically operates on a MemoryListener and we only have
>>>> visibility to one range at a time.  I don't see any indication that
>>>> LOGGING_START is meant to be cumulative such that userspace could
>>>> incrementally add ranges to be watched, nor clearly does LOGGING_STOP
>>>> appear to have any sort of IOVA range granularity.    
>>>
>>> Correct, at least mlx5 HW just cannot do a change tracking operation,
>>> so userspace must pre-select some kind of IOVA range to monitor based
>>> on the current VM configuration.
>>>
>>>> Is userspace intended to pass the full vCPU physical address range
>>>> here, and if so would a single min/max IOVA be sufficient?    
>>>
>>> At least mlx5 doesn't have enough capacity for that. Some reasonable
>>> in-between of the current address space, and maybe a speculative extra
>>> for hot plug.
>>

Though one knows (in the interim abstractions) at start of guest, the
underlying memory map e.g. that you can only have <this much> for
hotpluggable memory.

Albeit I can't remember (need to check) if a memory listener infra gets
propagated with everything at start (including the non present stuff like
hotplug MR).

>>> I'm expecting VFIO devices to use the same bitmap library as the IOMMU
>>> drivers so we have a consistent reporting.
>>
>> I haven't reviewed that series in any detail yet, but it seems to
>> impose the same bitmap size and reporting to userspace features as
>> type1 based in internal limits of bitmap_set().  Thanks,
> 
> It goes page by page, so the bitmap_set() can't see more than 4k of
> bitmap at a time, IIRC.

It allows a bitmap big enough to marshal 64G of IOVA space to it,
albeit it only does a section at a time (128M) i.e. one 4K page or iow
32K bits at a time. However the callers will only set bits in the bitmap
for a given PTE page size, so we are always limited by PTE page size being
recorded at the bitmap page-size granularity.

The limit is implicitly bound by the IOVA range being passed in and bitmap
page size. So this means it's the bitmap size necessary to record an iova range
of length ULONG_MAX.
