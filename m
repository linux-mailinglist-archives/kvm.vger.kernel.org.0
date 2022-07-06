Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADBB3567E07
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 07:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbiGFFwE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 01:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiGFFwD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 01:52:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EED1220F1;
        Tue,  5 Jul 2022 22:52:02 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2662wNal028684;
        Wed, 6 Jul 2022 05:51:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=UHbKSmwBfWq6/ZMcMq5WQwsAM2/YO6+zMIfPSp+TDFw=;
 b=MErEmDTSPMBZwpqYW58CaSsPb6ta0zrqPq0EMJDdPu+DKdhCC4bSKKAAQxZzDfpV91hw
 dGYIkc4pJq4PKp0P1EUokKC4pvd0vvWeCMlBcq1K37wdcW+71v6rKpsJRavIu50bJuMb
 ypfHqUcBREbxPeio2EmtEz24TD3t+rLvSUX6pmFRzGCeiHzkaUkh5CC6z7TwD3DEnUoE
 lYKE521m/Q8LHHYYSqgirlgosm9+KmkeXvNhdzyOPKV4xVp3nwSx/uWMt6uOARxV1jAw
 23wCDZUuHQInBfXp0ketJTpBpk+DPkQQEl6bw8ayqM5gUfBl1C7ymDUVxPZw4MzBGbD2 ow== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubygx6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jul 2022 05:51:50 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2665jEtn020182;
        Wed, 6 Jul 2022 05:51:48 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h4ud4jgcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jul 2022 05:51:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dwXr4ItwwC+PUmkD72aKH8zLsjlf64sF4ulGm0kD+AvAh4E0SMuIawPvHx5Gb9QUDg6OvdM9UcM0yXTCz/ne/1DDtTq+Uj4VJcMam7ta4U/KF89GYFzMAMyVxkK9EKObw8N9Dsb77iJF18kbcOCNH6ssX/D0EFK+yxMp72l1Bo15jh4tAf7Ct/MsVgNQ4efS4+aZZ7R73wqVpZWKDLCC+pJ1ldXy+uwB+JuWX27iCyIbsuRnbtZpQkuoo4lS6VuLrCCWR9T/dVCZR89ZuTz8YkygmC75tn6OIGAaDQQerk/9Cv0j1dSAl99gkyrojzT0bbA6lO2Aq2WeVIv1aFOHeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UHbKSmwBfWq6/ZMcMq5WQwsAM2/YO6+zMIfPSp+TDFw=;
 b=oLBrUQKN3jkzmz8ek3e34o6MxThxNiOk5bJV2Qhk3LfRgzFA6ZYdxUB+N8mmL2c12pSrXuOO8oitOAH8bkf6EY3sFBCK0wBhvCd3lpptT9r0cCdziTpeFsGD/1SpaY5MPzQxg8f5Ce1/uAJ7VSXbjwoSRXZv8y0Y1dlzUq/WbU1GWSt+KNcsOKB245e/lIvvtoxsgg8fMSvmYpESfvqg1Ouleorzyxz239Bcuxs+Q4ITYmT98+QG8z6GIGx1u4j4hBPV9CJuF0gHvCRWoPhT5VebJzMss8J4F25S0QQ2SFpmPm9FimVyttcYsdt364vhtTOCX0dnwWef5xRSLsqCgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UHbKSmwBfWq6/ZMcMq5WQwsAM2/YO6+zMIfPSp+TDFw=;
 b=0JDidOP8QyuVHqlWbgklv1LnjPO8/5Ly1iSLd51vKzURm8qmunc+c0ItFmgJF/V/J5XEHc1kHf0L+JkotFzZtMrdy/iHRZFAEaZJCQNeeFQgmCmiYW9dLsWwv6sQDLuS+8Lp1nN6lQRar91u1USCqQO1YpAX7DmZXJb3CDoWQ9Y=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN6PR1001MB2226.namprd10.prod.outlook.com
 (2603:10b6:405:32::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Wed, 6 Jul
 2022 05:51:46 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5395.021; Wed, 6 Jul 2022
 05:51:45 +0000
Date:   Wed, 6 Jul 2022 08:51:24 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Longfang Liu <liulongfang@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] vfio: hisi_acc_vfio_pci: fix integer overflow check in
 hisi_acc_vf_resume_write()
Message-ID: <20220706055124.GA2338@kadam>
References: <YsP+2CWqMudArkqF@kili>
 <20220705180649.GI23621@ziepe.ca>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705180649.GI23621@ziepe.ca>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0072.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::23)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf3e24ea-cef5-440b-a58d-08da5f139c12
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2226:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eegubxnzwJpcZTArXqYCeHEaG6bjF3qBuwZDXJPcsPMg0bUJ6IHlExoniBXP/dJwYWMpyF9QgqRDE25Mzrk3Wys16JWy3tQLeZKE3eV0A+moGIOXuNQwwnO4UowbNOx9vi+SsXq7irDCNQc/hUokojRBHWRa78tzDWTHgo9+qfgTiTxtxpvE4azWba5SqAywNWF+/JDptZhyEstW7M7bpqLbDJEJv0TO0Z6S4q4fJD9RQ0ykgtbWJfkJiU+Qx0TZj555T7zM/soXPUspkAXy55NBIlIndYmj4aH2x49LfLxoBsbmFxroIrRBrNxnb+tv6ZUCHHdZd6G9wb5iTRlDJ4AuSKewrJWh8rxEsqVCtSMhojE4ZvGxZV/Wj/kx9hAsitf/lTU23Nt51ZwkkwHpBEF8UA06cLzh8Map+XaLy4U4vZ/i3z1zNT8MELLzY25EUXDKzbRtkUROVnczqIfEOPatiFyE/TW3QBj7VtQ0eF/1upmU28lZOvRoqdt14GYxFR0o3MFNHhcBHEzFpWnmyT3DHHHajAgF8bP3OMKlX+4uT1p8FjMAXcJQ/AVUYwSNbRrw0ooGRo8xGl/xqGEsitxKGUd+DSZuLmOsbIhQ/5RaVfwMLEkHGbcw51lYtFRLVwslMmHj6udIGWYApaNAdeZoFdFdGqkIZJwYGkf3Dcgtl4hrlfRNrDbFJCjiBPGXtWWv11Jfre+PHSrTtmkjgqQr89A/lDQ5yip6sBVmyTvNaoUd+zWF+8fU1s/By2mHVUMnaHZFxibg5jZ6+QQpO836+fSWsFtjHqx23k0eDRevY53wXKr7pU8Zs5ckRZ6+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(396003)(39860400002)(136003)(366004)(346002)(66556008)(4326008)(66476007)(316002)(6916009)(66946007)(6666004)(478600001)(6486002)(6506007)(41300700001)(8676002)(54906003)(33716001)(2906002)(44832011)(5660300002)(7416002)(8936002)(52116002)(33656002)(86362001)(38100700002)(6512007)(9686003)(1076003)(26005)(38350700002)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?biuFbNpMcg6T8fOaaFNp6/Nhni+frgf7GhHGhlE6z7V5fXNxKPiXA4OuWZ1Z?=
 =?us-ascii?Q?bD1DYu7vjpHub2TV2xXTqAY8f+ozIz+O+BzvalCmcWiuekRqnL8H3TE3qRsP?=
 =?us-ascii?Q?f/9jcmiv5kJQknON3JKdjd/9EWbRqYe8U2mdCqrPucVbwqGrBJSB965i9FVs?=
 =?us-ascii?Q?mZtUjylUOpXAcMBokH5mthghZpIoHjnaEfJvahVTyEFXMnyK8gaHR5+LKCXr?=
 =?us-ascii?Q?/0kiQ+K0U85IOxqyk+E1AiEEcwMAqMWZP4rlCXWkgRK5i2uBrKonhQv1sgBm?=
 =?us-ascii?Q?Rp1yJwyIhq6ChHcoEq6I6HupbR8mnKZChV7S86dkEOWGxgZPrizNeM7lV+91?=
 =?us-ascii?Q?97jJH1mY+GYJpiBiGCY+dSTinKFNIuBqMguGs1SrPEr5xRcvH3ytwhzDLdi+?=
 =?us-ascii?Q?ulVcE+7Tr69qSPSRP2q7FNsm/mXSwfjKHll3WHk5NaR6shp8TDodl2nmyOoG?=
 =?us-ascii?Q?+Xtx482qcrM37vGUPyIHeO1eMOSFUwS0H7qe0LbbgJhHkmGbvzF852+dI3ff?=
 =?us-ascii?Q?CAKE5zXH88OBVKp7uuGo6IlII41CbXSQwICE5qCvDviBFpqQkWFvwo1pxUVa?=
 =?us-ascii?Q?WjqjuEcCRuinEplxD0dYyNze4nYpZSyA8Y6Is/+loqyHuqJe5NxSmByPZ5wA?=
 =?us-ascii?Q?TvJf+q63iKLuXRxoQFCT3iJnMNWmFnmbhLFLyKi2Csv/dnC4zdGqOzQXrVv2?=
 =?us-ascii?Q?232sIMIConRtpBDq8bDTQjjnq/rPX7uJiZVHc32GBWRlHBnTGvDn1GrIItSu?=
 =?us-ascii?Q?omvw1rV/cXiyuLlQ2OdIi2AO/b7xXfHemQJu1jQe5MiQ2R9AuyvhPbUdoxoB?=
 =?us-ascii?Q?JS/TFRcXg1PwCKavKHyfQqI6cq69HO9GYhnlETGkCtPyofUnxqXTd/JGF1LI?=
 =?us-ascii?Q?O0aZSoRo8tIzLwzzipDyytC2nzvv0ftXti+4P0qks/6TkcVp1yYI31DS8BPs?=
 =?us-ascii?Q?6CS/sK6+etjgXFNPO2Wr1rG1Rajrr43rtoRk+EPm3nfDrr6llyhzXnJ1E8CW?=
 =?us-ascii?Q?UdD0wZ46n37tMc80pBFZQjHCrN+Kl26I+iRRrOKdweEbmZ7guAiIc7nOiz9k?=
 =?us-ascii?Q?Rt2jHHTM5TM0Dkqa8ZXswIeeaqCdK+f+sQ0RRjj0oFjNLN4T4eWiePCvcxiF?=
 =?us-ascii?Q?nPdzoQ+LXVD49DGfgnfxsYezOLyGwFp2/c/kXQEFC30ExdYi0wyDX396x0A7?=
 =?us-ascii?Q?AoHlQZfQB1pabp7ELnUIit5RV7nQTD9c1sDyzLd8M+Y+4qVZTlsktftfSuUP?=
 =?us-ascii?Q?pVb/YB+D/DQzoHdiJsKj2uk8XHAs8n8cBAjEXNe9AUcCiQ86+NCxXWPNjALB?=
 =?us-ascii?Q?EPZ2/8lGyoXfKsvuHF5GWSqTv6axATp//KGyKJWFL4cqjw96z0iwXDNzrumc?=
 =?us-ascii?Q?yUFsvQLjZOk1exYKzkhHXsIBbNtTRKPPpg3eUmDcYrJB7njzRFY3D0Sj7oNy?=
 =?us-ascii?Q?4jk6iM2mvRWO5wO/Uz/k38fC8VVmEL1nZkKMlMUC2gc1+/qyrvXUvLppRGfU?=
 =?us-ascii?Q?UTEmVd27ebD/ff+WMblLyG+QAb6oFpKQKQhHAFQ7+Pg8ngeJ0Azw2pMYQE+p?=
 =?us-ascii?Q?u2n6AxceCNW7QuZ5IK3OWApdpVmfS67ODMKDK8LK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf3e24ea-cef5-440b-a58d-08da5f139c12
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 05:51:45.8518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SB5Bnrke4epSiOdbXggOO1PBYN5YjujEETbJUHADiij5fk3egLt7hCKsYGi1bFBjgfxDx0k+wwiPr8m9CZOdQAcbPt0UJzUbTi9HROidDN8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2226
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-06_02:2022-06-28,2022-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207060021
X-Proofpoint-GUID: 1C3Rr0vS1IrZX-jQSSPDBsRBC8nEnvP-
X-Proofpoint-ORIG-GUID: 1C3Rr0vS1IrZX-jQSSPDBsRBC8nEnvP-
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 05, 2022 at 03:06:49PM -0300, Jason Gunthorpe wrote:
> On Tue, Jul 05, 2022 at 12:05:28PM +0300, Dan Carpenter wrote:
> > The casting on this makes the integer overflow check slightly wrong.
> > "len" is an unsigned long. "*pos" and "requested_length" are signed
> > long longs.  Imagine "len" is ULONG_MAX and "*pos" is 2.
> > "ULONG_MAX + 2 = 1". 
> 
> I wonder if this can happen, len is a kernel controlled value bounded
> by a memory allocation..
> 

Oh.  Smatch uses a model which says that all read/writes come from
vfs_write().  The problem with tracking kernel read/writes is that
recursion is tricky.  So Smatch just deletes those from the DB.

> > Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> 
> This code was copy and pasted from drivers/vfio/pci/mlx5/main.c, so it
> should be fixed too

Sure.

I created a static checker warning for this type of thing but it didn't
catch the issue in drivers/vfio/pci/mlx5/main.c because Smatch says that
the bug is impossible.  Which is true.

Smatch doesn't really parse rw_verify_area() accurately.  I just hard
coded that function as accepting values 0-1000000000 for both *ppos and
count.

regards,
dan carpenter
