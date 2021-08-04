Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1EE3DFE7E
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 11:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237261AbhHDJ55 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 05:57:57 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:61116 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236659AbhHDJ5y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 05:57:54 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1749udCV029444;
        Wed, 4 Aug 2021 09:57:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=QTIME2K0YoAmey4CmQAouxmwwriOumnGyd67nLYaSuo=;
 b=ZZoU2oH86RTh0lMyH/owI1/zJGDQxyIj6aumW8Efx+6YwMlhyFDea4ZTGi3x/nOOaAqI
 hm8ivbQMBq8saFxU9aNmhNMmi3wtKV5EykEqwFeX9OtkoG3UamnQFO2Ax8iSTYIST+7s
 pRbLYOb3F4Rt08BxokI3GYhWyhIG4JiS/+DkgcBNueTQzNbtQ7kl0vJHV+o9cNL8y5/G
 DpAZ9DHjSb2JcFH1I+u1sLWcQDMoRckE3XZEBTTBxLXS3P60cY+7CafQjgWxoTfZjwej
 itLA50w52TC+O1zORPetJJMVmRiYGH4HruVAVFPMN9pR05LsISQIHgQN+eKpOGgNNRnj aA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=QTIME2K0YoAmey4CmQAouxmwwriOumnGyd67nLYaSuo=;
 b=KlrYX0L907ypzRnx+yWHZcXLmPWodGvrTpEbJ6CA+3gXxu7sxIvKvAva3MGJ0YpqXfvE
 0CH0tpDVmyQOMzEJnSAP3y5Zqlub+p3wW0BRz8QTZdmeSLzT87Nz4dUiR7Y6PqVIcxx0
 X6i3lxZNhhsP7sNiOlGrDem0SodjoDwm93L5zFtFv9AISb7gT8KZocaeKjmQdiCpeAGc
 jZLqaNSXUkOl5FJ3XeCyzX3B+6j6LX9HlSIW6ZqyqyPrZ1ZZBNroue0N2eCmfhZBzduY
 VfAzNtjNYyu4P2QiVkNudFFPXLRm6WAXPd7PAyJPOYuT0KldYlgep+NQX+WcAojgNjMH 0g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7hxpgtfu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Aug 2021 09:57:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1749tXUc168365;
        Wed, 4 Aug 2021 09:57:38 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3030.oracle.com with ESMTP id 3a4un1d2ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Aug 2021 09:57:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TQulh4IT4sZbgh+kwudHKHQD42vSrj3uSQBWvilFsU/AkKlDLhFlZwkSRHfZ8sff2KThFeLxlfPhHFq4rYXg30qMeO9PtzL5gB/kFqJPY3U5jB2wWYpwRMPShUxkhXd3qf8vLwt8i3zmZFDUG16g2Sjt6obABxMKSort51WlRhcQ185Djnvp7RhVAi9DYqGLdBJOj5hwG0T37daFHnBOLeLllZ4dv/zAWiEmcjKfw/AM1LARaQF1oS/s6C9iQYUCUSxctJLJTrrC6NPUi3LpT3QLYHHiMbGu8rOURY9ZMH+lheYaGYaqomb0gZhmft8L42UQ8BAuWg6NpwDIN5qQ+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QTIME2K0YoAmey4CmQAouxmwwriOumnGyd67nLYaSuo=;
 b=hZzpEV8/Q5tkx+iDemoyLnZV8s4vDo7dNKSUP/EGVqpo9OziGPKfLCedAHdFUd6q+jaLVbf7yM2wzY/gD4TvJQ4u77lx5dd6NaSywfhS4D0Wb7Xq/2TVo8YrsmP94QUlpl05cFeySRrc61zHvS9nlD4nB+Gz0/1cqFkHTJW/9lXaOFgYpThccQPyxtBuN6ODz21ptodf+o1dD8z6MlHRH3mQ4ywmYv3YfPXJcWzkaZRxnAAf2v1D6OHguHBA+Vz+bp4l2x68ivPyuPUif5yqQ7sJ/wi04sgHdspVF9RH+IqUyn4LzLWBNiCshCY01wkSfn2j1UNVhvonMjHrW7nkJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QTIME2K0YoAmey4CmQAouxmwwriOumnGyd67nLYaSuo=;
 b=BphtmGrn1Ocy6ZsGUsk+QVSWPTfbCXYZ/WijiAZZTn1NIzrKKeFd0MbuzudCmq7uJXR9mWr5ESMSS80s9JYMrS5hByXRrv5WpExHxvR0iibhakRtWFOa8n/iXguqwyqXWW45ZszgPnHHf5gG9bgrOxK07EY3Fs3hThEODisbXM8=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2208.namprd10.prod.outlook.com
 (2603:10b6:301:2c::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Wed, 4 Aug
 2021 09:57:36 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4373.026; Wed, 4 Aug 2021
 09:57:36 +0000
Date:   Wed, 4 Aug 2021 12:57:25 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     jroedel@suse.de
Cc:     kvm@vger.kernel.org
Subject: [bug report] x86/sev: Split up runtime #VC handler for correct state
 tracking
Message-ID: <20210804095725.GA8011@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZRAP278CA0012.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::22) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kili (102.222.70.252) by ZRAP278CA0012.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Wed, 4 Aug 2021 09:57:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3eee23cb-734e-40af-9a2c-08d9572e493f
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2208:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB220811F09247003C2E67EE148EF19@MWHPR1001MB2208.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3j5yYzB3/htqs9GEat8PSk8cx/9xG8aCUyjMrCfFIwwGDBbl8SUGgnXeTAEx6zGSGt1sFNCjbXzLzSGVx+RPGsK1SS/auTSAoNmVvQDpWz16bOrigkZx4+LIZcT+FyB5xzLr3sOcj4nDRUoaal6R0VI7XH+eV+3+tOgUOZCosomeP2GZwNWeIoADhAG0P5j5DscGhgQhIEoxXK1MdedrUpFhezmyBdAd7d2iOlXOaPvMEB48rRpAT9+vSbWyxBp5Flh+42yMKYTqQDZL7k9eYiPUD1k4gRCD1UnzlvYapsjJhPgLoar4G/fOAxds2m0DqttK9iHLF9GbHgIUyxxcfgTs/YCws6fRiA/lBXNfZJtWZfkUip5BOITnmq+8P8h8+aBtTWBj4azJ5isIgAYhx/A2zLIKLSM5+g80YLGTTtyYDbzcUqYoLaKDk+2Z13jx8dl9idV3v1v6wnRDPaxk/9m4k/rjFql6tg7QpeiYgix+wr4IeYoLgBgI+9kzq0lWhcnJF0BHOGyeoqYhGJpx87IZrYDv9WoP9OwuCnBJKmLuja8KnU085GKLckcVIqYWMVo9SzAzHLHXOQJB9P/NGkyoRHGJa1TP+hk8wzEdAh44Zse8R8FVvD9LjwWMf2bg0xqBUrxY9A1kIDcQ8b85xyjvqsUzrym7jxdtLe/VWDz/Gvt4OF+Yc6zJQWn8ts5Yuu+f0eSlCIrFF+RrlNiCtw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(55016002)(186003)(38100700002)(8936002)(6916009)(1076003)(38350700002)(956004)(26005)(2906002)(4326008)(9576002)(33656002)(9686003)(86362001)(5660300002)(6496006)(66476007)(66946007)(66556008)(6666004)(8676002)(83380400001)(52116002)(44832011)(316002)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BHxt3ubXrsnPc9gYxy6PQzXa8pMUmAWeesIDAIMBUufZUC54UpwjjLojjFuF?=
 =?us-ascii?Q?cIwO7wY/pBMa/KmpU+gr1ae6Z7H9e7hYxDahK50P7f2aRD4bJ2yk3J/JutTF?=
 =?us-ascii?Q?v65vCplFxnYUGBqPrpcyhFG5OSaXkDzaQZFO/CrH8/cQ0QI0IA/Q0q4PeVVW?=
 =?us-ascii?Q?eJPyGL+PUpErkHLJia9y/2qPKCqXUftByS5XScsRznCeQPJianUvXCiDY6l9?=
 =?us-ascii?Q?Fg78aUCo1Qcu1VEJ+yOeLNLh0mcoY86KmzLm3e4VwlPVykYh6E+ofLfH/4bE?=
 =?us-ascii?Q?DTlYiS9Sdbqc7jCE9pXyGgowVEf+FtAn/gUNglitArrtgo4e1My4Dem/ApA5?=
 =?us-ascii?Q?zCwcLYcKFW3dkOy63p+2E6LX2p/NmRmTXqMrFgd4Z20CLIAg7iYHH5oSBKVQ?=
 =?us-ascii?Q?X87QDnCcCMNIAZY/9uC88mW33Vr8eKnrnGPIc8TkdRoLtZA5ZPm51t2hw0cz?=
 =?us-ascii?Q?VrqDwhSKUiFlYa4zhGFqqR6fUtHmSmFW8Giidy/I4wYPz48xKh54GY0kXSZD?=
 =?us-ascii?Q?P1EzMPHucchDMfbLemTMKMtTIwHxXdX5pDIq1CXAS5BaWTQ1xhgRumJp+24C?=
 =?us-ascii?Q?iiuZ1YeH3JGhS6pFwhTBvpkNFm6e6xGIz2PSbztw8qp21/ixUV7Jv24hQeD8?=
 =?us-ascii?Q?lfJNZaZDj1QbYLGSKE7oNsEv9rxNDAxgjgCgIwf2E7OmIFVUoNdjepwMi9jo?=
 =?us-ascii?Q?BSCvooFxlW1sCVPwGwUXNGr1cCXjdtBI71rTLOMkg0T5ikwARGknkYU5M/R1?=
 =?us-ascii?Q?aLJP6TuyfFhmHt1hkeVNetaH5IpxixDatrXdSrbUNS3yKX+E+pgsA+Lwi8ym?=
 =?us-ascii?Q?vzaaVv10g4lpOcEUYkrRBUp3cesrJyB3SGfeMO7Ra4nVlVc18SoG4yvzx5/R?=
 =?us-ascii?Q?3KtNGeMVPlO8JXAlrEphothMrLkZhIno2Q22ibtOkwz/hFicU8J5brlZ2lP2?=
 =?us-ascii?Q?TqPvgqDQby7Mxl7Rw0xJCq4SeyBNlQpzpIC2iAo/Zcf8SVRJRSH9CtYUQMGV?=
 =?us-ascii?Q?dWktlaF8+otHdGwNmWrW+BU0geXooNfIjAPEZN+imhevkBw35kefj17chfeW?=
 =?us-ascii?Q?g4JroYRYbt1ZZcrYyGkYrxWYemNeHKPZpfwsXYmg8KizPTSluS6WEaN83h32?=
 =?us-ascii?Q?GDV08x1Vl908BW0SiK6Hbp/UwZwSriPhcOC45q07hpYL/JhTKCHgDaEkTUEk?=
 =?us-ascii?Q?tM9oVzBnW0u1v/kly1lh40d7SH18H5U7RKDjREotoevQa+E36WxPuOI2FHYv?=
 =?us-ascii?Q?6NKYolaAjH30CqQ+uAoGHh9CcUXEVpdfKaslLSUlgOP1yWO2sv+bBC6gyjRh?=
 =?us-ascii?Q?dhVRDGp6arkcp91xj8WLSijt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eee23cb-734e-40af-9a2c-08d9572e493f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 09:57:35.9952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X+pbBinf11I4pvmxDnIOXCAcnqCwPw59JEuLKFPycVPgAWr8wRvy+KgEDr/dVwxBIKIPtleWFlV4J6RELoAEv2m82hwlyfP+QmpBg83wuZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2208
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=847 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108040050
X-Proofpoint-GUID: SdzTv7EBluyO8OYcD7zfYU0Lx73OQ5VY
X-Proofpoint-ORIG-GUID: SdzTv7EBluyO8OYcD7zfYU0Lx73OQ5VY
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Joerg Roedel,

The patch be1a5408868a: "x86/sev: Split up runtime #VC handler for
correct state tracking" from Jun 18, 2021, leads to the following
static checker warning:

	arch/x86/kernel/kvm.c:153 kvm_async_pf_task_wait_schedule()
	warn: sleeping in atomic context

arch/x86/kernel/sev.c
  1416           * Handle #DB before calling into !noinstr code to avoid recursive #DB.
  1417           */
  1418          if (vc_is_db(error_code)) {
  1419                  exc_debug(regs);
  1420                  return;
  1421          }
  1422  
  1423          irq_state = irqentry_nmi_enter(regs);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
preempt disabled inside irqentry_nmi_enter().

  1424  
  1425          instrumentation_begin();
  1426  
  1427          if (!vc_raw_handle_exception(regs, error_code)) {
                     ^^^^^^^^^^^^^^^^^^^^^^^^

These sleeping in atomic static checker warnings come with a lot of
caveats because the call tree is very long and it's easy to have false
positives.

--> vc_raw_handle_exception()
    --> vc_forward_exception()
        --> exc_page_fault()

Page faults always sleep right?

  1428                  /* Show some debug info */
  1429                  show_regs(regs);
  1430  
  1431                  /* Ask hypervisor to sev_es_terminate */
  1432                  sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
  1433  
  1434                  /* If that fails and we get here - just panic */
  1435                  panic("Returned from Terminate-Request to Hypervisor\n");
  1436          }
  1437  
  1438          instrumentation_end();
  1439          irqentry_nmi_exit(regs, irq_state);
  1440  }

regards,
dan carpenter
