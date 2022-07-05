Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2625665CF
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 11:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiGEJGI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 05:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiGEJGH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 05:06:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096056459;
        Tue,  5 Jul 2022 02:06:06 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26595F7I016132;
        Tue, 5 Jul 2022 09:05:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=QX8pf2CiwCf0L17LMrd4SNfExE5AX/TgPa8iykl7tz8=;
 b=h8j8JDzMgGzdZaeMppfbxw8QVxdLbDkKdsVdIee/DOD4nUrPKsALi5cySdp970+ezZ+z
 VfUQ3PrybcTihktIjD1M/bKaZTVtzoiFl4q4eR9vhcnrfl9AYOsmjXnr1pk5t4YUBoCd
 UAeUJFz8s9lEia1khdd6eqpO9iuzxhpqZbrpLcwLlw++5ABhSGqj/tm0mF4eGz6LgCy3
 0cxLa8WSttfPOvFqNP2NIORsGlVQcwovQw72+IBJ1e3HIEocqFBwa9FlKEG6M07qP7GS
 H+Ft5sTgQHlrT9HMFDD1KZ3OC3idIUUzrILWEZWB6GGsHUVpMn4XuKDdyuZSemY8HVl0 sQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h2ct2dchj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jul 2022 09:05:45 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26591Oc0035297;
        Tue, 5 Jul 2022 09:05:45 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h2cf89vdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jul 2022 09:05:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MehaloN2mN3m2Xtq9vHbHGIrQ3P0Wo4aa4OCRyaUOajkY3/1nC8QIfLyJxWlwSKpm/tHKPk5S3I2ujFAAl64gPStcf8FGlhwAK0BNmUAlA5LomP6T7f+rZwZz6ixZ1bvlD+yE59vMH0sUeQ0q/xkjbJ1H6+VpmKLFeXZeBNH2/JVKqiXcKJ4XDLHbfpS6DQuoE7b+Q7t2artB7Uk8HrJ+swgAEmAjrM3ex2WF6nNikrRolH1TVB5KwfcWdS/N01N+UFIzz8/31vfNJbJz6aL1M3VMhmM5mJA1K/2vNYHBIi0sIxTpRREEAj9ol44FpmsLU/FXUHVL3XaEvjUeknn0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QX8pf2CiwCf0L17LMrd4SNfExE5AX/TgPa8iykl7tz8=;
 b=Njjx/hCJWr0hFw3q/HY1AnTfCKcRyDCv/nZ+/IXvkmTYBCHQHMLcH6frFnflvxgVJJprkkwWC35Eh6yGTYqp0EzMq6aZlis2c54TNuiG+5tmk+5NBdz3ljFJOKPEJGafwwS+UuLT2YJoUXStWyDG0KM7inM789/2PDCgKeRsXo5dSsFrE095KlYo5FWff6A/gVv6Z/aqqemXXE3F3L23i3cbGQta0QeqTfNwdr5K5XhZ1ZJIvm0abz4J6UOWl0CN9pm7+aLh3fGbwhuKA3DXgmlg9dZztHC8DtDz+4yvUj/gKX5wp7KXPSDsXtfB5tWK4JIhTXqrdJcZw+Xalmy9Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QX8pf2CiwCf0L17LMrd4SNfExE5AX/TgPa8iykl7tz8=;
 b=Zn3+Mphag6WTP7ZZuaY0V3CDDyjW7N6IjbRwnH1l5BdwpJZFmCNGBvD7EYJ7gSpeaItMUN6Dmy7KjALOABpoR4PH4FnrTyQx39UWgpn05SH1TeOMi2u2mWzW8eWr89LT7nxpRvWNav0+Rrq4/bv2TVZSCYa0W6FPBwCH3X8oh8s=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN6PR10MB1748.namprd10.prod.outlook.com
 (2603:10b6:405:9::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Tue, 5 Jul
 2022 09:05:42 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 09:05:42 +0000
Date:   Tue, 5 Jul 2022 12:05:28 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Longfang Liu <liulongfang@huawei.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Longfang Liu <liulongfang@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] vfio: hisi_acc_vfio_pci: fix integer overflow check in
 hisi_acc_vf_resume_write()
Message-ID: <YsP+2CWqMudArkqF@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: AM0PR01CA0114.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::19) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd2f61b7-ea11-4ad2-ea4e-08da5e6589ae
X-MS-TrafficTypeDiagnostic: BN6PR10MB1748:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GaFFQKQwP/p59qqgQgVAFMyW9Yqpq8A6MPVvXFMKJvOKfjNTUxNLh9+pu96DurU65M8bvY4t4Dlw/T5uOxJm47WtoDvZeiKtA7RQdQRVrZuRCwUAbeI8svtx0nC717w29IdXFLAjYE31XkpcweqSFBcXIHWXaq9d25BE6MKye8SEivvCFzTbJDp5NyL1uJEMI3bIJo83xYx1U6FcbLVbY3LxjWOWjiSfghJ+rlWzqNZ0dl/6Cqp5GCDaO9pzogjNMSiSuW6m0zEkDM8gDKC0NXDtA4h45SBzi94sGqp9dDpFTeJtlVHHxK4Er2uR9GNKPJSdxf+YMYnuTZH3rZU1yhpSajt58xg2ce2LtqDdjEfn+Ziu727qAWWaqet6JBOBlUXB+0qFId6YYoOdm2MrDLe/frhiKdQt4FGFRvgm03kXDK7eo6/p5h4zcVCRlLvf4D7l8udbvW/22r9y/4QxpapVjTbBfiqrP2dF7Dz00CgJhG+JyGCJ2mPHy1KACOoYMFrGzoGWfeLQjT7jjnMbpqUQc873LpmOYw4XIveW+MQzpFfuynzLsnUSeosrrfnpALGC7J63SsXcUbcq58RKZS8+/m1LW16oNeHSc46AQd8lAMWW46xrZMqAPJ/PI9clb7ehirjkzavfzqqADewW2AWv/416B+I9S6MFSkMzkU9cCn2donfKXeCaAfRDCYiqufnAWNC7HmRsGPG0HuiM10M8nJRXbrhzNMPrAy64xGOsdrfpBtdCETj0Am3kpOjsD6ZVTroXHtTk3s+Gnb4LLoz1uscqyrPRBMvn+LTXBEz7IdS7vFANCyfPjMVfOamr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(136003)(396003)(376002)(346002)(39860400002)(6666004)(52116002)(6506007)(66946007)(8676002)(33716001)(4326008)(66476007)(86362001)(6486002)(6916009)(41300700001)(66556008)(54906003)(316002)(6512007)(83380400001)(9686003)(186003)(38100700002)(478600001)(44832011)(2906002)(5660300002)(8936002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+x5ceaXlxJPjP5OUc1+bt+ZmeKCYRDh0Pf++sZuFgAZe8OFPtRe/lU8ojIPC?=
 =?us-ascii?Q?roeUMXJXkMoEKzzvTWQVTO8acqYX55/kOb9xDvaocMaVJfurlHZ49GHcxKP9?=
 =?us-ascii?Q?5/IU2pyzhN5PVuqRXG68YP0E/qyr7VfjvLHnSuyzogNI+FSVfwWl+rJ72MEe?=
 =?us-ascii?Q?wJ+DgaDWOTo8BSOA0VINNjW7VmYcO4hoTeqB8+75Q07bPjB01E9TD32roWUt?=
 =?us-ascii?Q?u1VtamMY/3MDDGiEhtyKi8mqH9XRq5Ot8YRwhwyoD0IkZ+jUQnSL0WhTG80I?=
 =?us-ascii?Q?78Isj9qm0/4CzfHOyNfEtAa4sIGkRbQPmfc0WD7bcE5uUro4u3Xvtc/zPf0o?=
 =?us-ascii?Q?5XiDOUwmwq/qDfh/Hy63geKKWln2H+KMrj26UD65RRqSYbW+a9uGlVJ39rIm?=
 =?us-ascii?Q?tEgFE0Vrn+4U1llGXANcjdKz/p8YyFJQGDca7pSXlzqfcNdy0ImzLG9xb6Kv?=
 =?us-ascii?Q?M9QxAD9fVXY8AMEkCmaOCg+vbfOQnCzqoXyYDPAxG9upW9Yq5nStDWgFE/uD?=
 =?us-ascii?Q?YjHIwWebxHC656C2bDIyMDd8hGn2wtn+3AcxVkZgomu6n8eWZ0jKNWauzqOb?=
 =?us-ascii?Q?5aZtS+C2Bw9X0S+ma4vbyG0+/mE52NKs+GFgDhau2ZUZbxHuXIQ3Tr0GInLP?=
 =?us-ascii?Q?aaR3wUqXNUm6/iug1G3uJTRH/tU8KSf+bSHB5pJo+9ujvplgUZZq45nHttgt?=
 =?us-ascii?Q?QOrAknVfXWuQ6VZOX+8OO2vkPlx1KdKI3dMFnObSXqQMTQmkNYZkJSj0SIJu?=
 =?us-ascii?Q?wpTL3d2QyWqfmYBzB6pcG8DHjSbVfs0Vx3soB9Desb552PFSrlt5eHUVDp18?=
 =?us-ascii?Q?e2O7xq/8vVdJB5GBv8WlQOIXYauOaINE3qkIn8RuHZBGVJZNhxHHBz0bGAdE?=
 =?us-ascii?Q?ge8LHa2+fAAS/ME2QfoPYqkGcKJjJhPSCXqnp6EBdliNIFjCQmrN8PZJHfFU?=
 =?us-ascii?Q?lE+AhmIeXrJRlvpRl5q57cVD2j7eMhcbkIrG96B24hZlzg+3ohe42OlDcEta?=
 =?us-ascii?Q?ofB56JgySj46Z8nokz8eW/VtNCz+r2n46N9GccaZ81QnVmepYJrG4JXTA2H3?=
 =?us-ascii?Q?wnW+rYg/QOoxupA9tGP1NpDMw2PnSauctWZsBqSsah8lghyXh4fJqDfYJnPW?=
 =?us-ascii?Q?lguAbtbTyqSkGWKkJi20dJQr4hCD7i2JacI6paUCtLxbB23nxI22tSzbecoe?=
 =?us-ascii?Q?Y30qDfrNpaeFA8UOZ6GGsI7H8ZJEIOnhlXjXGw2psGdx/J+iWPlO8qNGf0uh?=
 =?us-ascii?Q?m7oRSXMJ6Et/06juYyHZanBGcqIHJspDZfs4qW7oolw6aFg3O1VmvpnIX8U6?=
 =?us-ascii?Q?B7c9Ciu/PWfl6+pEXSXkUWTr6LHlWzUqaQvkELTVvJrNru9omrm0dubA9RF8?=
 =?us-ascii?Q?dSAWukUK7vyYXiA2Ln01d4H6ULu9OPA9ipiirGmPVJ9V+hcYx6JJt7Y98i7D?=
 =?us-ascii?Q?fAokPAAUFi1B7gbcXBKHt6M2uWUPscDRMJCSnS3CsDFQmT1SOss/YW9EsQWe?=
 =?us-ascii?Q?S5KogksPhJuLWhSTpNz6vx384t8MZTduizst2M2zajQNRvvqC24HAIwfd8+4?=
 =?us-ascii?Q?CY6EswsM4MvcRRl4v0+pxXvFUuuCTlztIe5DaQ15bHVwQXC/hEvEs2B59rqr?=
 =?us-ascii?Q?RkjIUCxF9HWSPWjCtWGMplU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd2f61b7-ea11-4ad2-ea4e-08da5e6589ae
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 09:05:42.3495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hHtg7V6Hk7J3idpqAsoUQ5XItEXqG5YzGAvcNBNS6++eu+wMnxQjNgK5b/uh3Wl5IJmpbpsana3hTpAntnZe05VV5hM1HqTnD20O13i3tpA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1748
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-05_07:2022-06-28,2022-07-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2207050038
X-Proofpoint-GUID: 2b-4pNnahvIcQ8y3pPLAXdJlYkxFa2p9
X-Proofpoint-ORIG-GUID: 2b-4pNnahvIcQ8y3pPLAXdJlYkxFa2p9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The casting on this makes the integer overflow check slightly wrong.
"len" is an unsigned long. "*pos" and "requested_length" are signed
long longs.  Imagine "len" is ULONG_MAX and "*pos" is 2.
"ULONG_MAX + 2 = 1".  That's an integer overflow.  However, if we cast
the ULONG_MAX to long long then "-1 + 2 = 1".  That's not an integer
overflow.

It's simpler if "requested_length" length is an unsigned value so we
don't have to worry about negatives.

I believe that the checks in the VFS layer and the check for "*pos < 0"
probably prevent this bug in real life, but it's safer to just be sure.

Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
It is strange that we are doing:

	pos = &filp->f_pos;

instead of using the passed in value of pos.  The VFS layer ensures
that the passed in value of "*pos + len" cannot overflow in
rw_verify_area() so normally this check could have been removed.

 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index ea762e28c1cc..dcc34488b0c0 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -701,7 +701,7 @@ static ssize_t hisi_acc_vf_resume_write(struct file *filp, const char __user *bu
 					size_t len, loff_t *pos)
 {
 	struct hisi_acc_vf_migration_file *migf = filp->private_data;
-	loff_t requested_length;
+	unsigned long requested_length;
 	ssize_t done = 0;
 	int ret;
 
@@ -709,8 +709,8 @@ static ssize_t hisi_acc_vf_resume_write(struct file *filp, const char __user *bu
 		return -ESPIPE;
 	pos = &filp->f_pos;
 
-	if (*pos < 0 ||
-	    check_add_overflow((loff_t)len, *pos, &requested_length))
+	if (*pos < 0 || *pos > ULONG_MAX ||
+	    check_add_overflow(len, (unsigned long)*pos, &requested_length))
 		return -EINVAL;
 
 	if (requested_length > sizeof(struct acc_vf_data))
-- 
2.35.1

