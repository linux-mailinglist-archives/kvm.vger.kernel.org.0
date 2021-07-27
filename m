Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCA63D70D8
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 10:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235940AbhG0IHN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 04:07:13 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:57164 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235931AbhG0IHM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Jul 2021 04:07:12 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R85ic8027811;
        Tue, 27 Jul 2021 08:07:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=Z1OpGm01sCTD2WyrlRfaAl9xgs97bjbo+WpFWUIkFvM=;
 b=qRcXPakWn06bqiTy7dyKX7tn+//g8guKsv43OdAWhKGnI3+zHo5MbjC4P+Y9nvQeC9eV
 4oDyGdmVyLewS+R9LWSE6twqwfWsMLhYWhKLRi5XSIGxN6j6Ej9PEMmraxyId9zb0WtE
 dRwO29USiPMwB3591k2amog9XyHSb3Efmc39ysg/1kqOWUGNjarlaotJrQVPs3CErbhS
 uTmLwhMluMhNed0ZO4nUatisY6xaDLX+HYrVJMLARlOREvDI2wSUbbKfljpk0DSHbxEb
 bWM/e7Kdn4+VOF7i+lWRGNhh2hSqz9EBMLndT8BCSUNVAFP4uHmi5CxcV8inAwy/IZ/q hg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=Z1OpGm01sCTD2WyrlRfaAl9xgs97bjbo+WpFWUIkFvM=;
 b=GgWy98aKFlGvjufCTUcNsKlSqcHsKumlrgtySdKRXMNI54gtt88f9oWtVzpjBtSBQpKk
 TqANYjvNub6tAAcuzxsVvOONdea60iJ691E7nrMM3Ajh78Tq4UIRRdHc1Vh1TzrsXoUO
 DDjSZSlpQoM3e25qIonndX2orQDqkFQ8DHQm79cYcO4ZtWTyO1htCy0tCUhXR3+FC6hE
 wtkbvNQlzsmTUBe6fMBlmW2g37x5gwGTVO9arAQmGlHkLbmTzYIbwalO6TglkYK5+c50
 N96Lt3EmAGrksg8V4tEEE/vOsTJu0iDRjIzxF6gfMuV5vzxAhKmVF3KYCGYFin9ZARKw uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a235392ar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 08:07:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R86jBk048620;
        Tue, 27 Jul 2021 08:07:08 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by userp3020.oracle.com with ESMTP id 3a234v1c59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 08:07:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bn9w7BrnrdkRAK9Sparifi4b8AVN1btCnZkruTM54r3Z06vH9LfpMFNI7wYlIH/wNBcuKY802m+Y55MNaJ0R/2k6gzfzBgJ5BsE91Fpt+2Xz8Hioz4OFI7Q6D6iJSeX8rTKAQeJlI7XehsjKyXVMfdorEN86VwHHzBVqj+80RVfWoamObnumc5ygK5Ap5F72xJFioL0O+D0JUklJPT2NMhBgV8KSTAjZVmq3pJ2CXaKo81RuWkjPUrQwGcClv9xkrsWj09MQZKHVoav7PtFEcN1NjXi+5FdSjaFyTVG12IhtVOKRrRN3QCGgE+TSVV0IlBUrxBFCpngAJXRHD1riWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z1OpGm01sCTD2WyrlRfaAl9xgs97bjbo+WpFWUIkFvM=;
 b=mUnoOyDpiT5/vTf+HYHmzJ2cgcxOqr2w/5+z8B9RRHgvzvtTWA96zk3dP5kRYOMhNe+ke1aFr1M9d6eHJWZ4GWoBvfp0Ey8rDVLiIyCQ7hchlqIsaaowuPEJrMMJ3EJMcTn3NqQjp4j40OTdUZ9Me4RYX5nmKcDX8PEkEbGVfI2Q0q4H6V4AgXThfQBu7P2fvb8aSSPrWF6yA7hkycf0Eu257ZYI1ZmUH7c1UW+k0izT6ZDw7wDPM2VkBEmeMPng0i2s26AKR2je8lyCovmva1vEf3nmeQSsVN4HTm2DJxTJkSCBkibjFtiYAnd18kY/2lmU6qPlhgzg70zxjV3EOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z1OpGm01sCTD2WyrlRfaAl9xgs97bjbo+WpFWUIkFvM=;
 b=mQGKSPomqsDzESV2SLgLJ1jAbaxk8PetTujasNPicP2asS+I4WmLU5AFHMazo7skEYA+gW856tLyjw93ftMgUbxfCPZIl58095LX/aouQe7i3/Z3i+E28zzFBmHPZjNxMA1tVf1fO5PZrrMCgbY6lOcPeGsb8Y7fZliRaPnNGk0=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1950.namprd10.prod.outlook.com
 (2603:10b6:300:10d::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 08:07:07 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 08:07:06 +0000
Date:   Tue, 27 Jul 2021 11:06:50 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ben Gardon <bgardon@google.com>, kvm <kvm@vger.kernel.org>
Subject: Re: [bug report] KVM: x86/mmu: Use an rwlock for the x86 MMU
Message-ID: <20210727080650.GN25548@kadam>
References: <20210726075238.GA10030@kili>
 <CANgfPd-H3a7zdEeV2rtyCTcHinYOwTB=KFFRXYSnYCG8e+tq6w@mail.gmail.com>
 <YP9QWT4FXYxOg2s8@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YP9QWT4FXYxOg2s8@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0033.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::21)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JN2P275CA0033.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Tue, 27 Jul 2021 08:07:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e56ab905-eaa5-4d39-7da9-08d950d586a0
X-MS-TrafficTypeDiagnostic: MWHPR10MB1950:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1950D145D1221DAD01B055CB8EE99@MWHPR10MB1950.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4n4cxhSIaatdMlvuzJVN53UkxOY+AsTvM3VMEpZo9IHbNaS02MEv+1+gMwasR3sIK5pRbJYP8IhU9Hl9dqRRdeBEhv97RDRxTej3EE2RdNqhEEw/+P0f+QnRA1/U5CgWji2t4HMJES8pJghiQa+NJHtoMgmkU/tYCkurgGdMlfFocn1hUhVfbOGTG1LMZb2Ire/Y3AWkpc5y959DVq1cEwZkNQtr3DMpTEuesiuL/2sog23IEw+8q5g2flYLBkI5sb/Ktxe+XAPT1wSanqp1o9d2CXBhX6kUHJguozdIRGcPgXU49hdSOWanBlrAmtZ5CUmDX/M7pcxPkZwhhMq6hkMdvJErmRXKsp1kEekWv0F8X5/LlxXfayQT0MlMayHsZoUdbUFZ0XKRFss7JflcuhibM4VcIwPOFSVt8Es5v1RaqqE8zGw7VY77C47Cbm0m4+nBUScG7mehjCFJrdmiA5utAHFxYP0TYa5aIEa/fqO+UUQoWn6npDd+8rRI8VQa/XOgT6kPe2/T5hdGMZmUC3cdAYMNLAN/KsrIoYder58MAbXS89DAFPtnncHfT3qnOJ2w4I923JPWEjdPGKQJUm+bQgXYmgm1hS3/tVilfeIZukVagpO4R4lNoCiEKSSQLxFPD5O35FCWMM2+rqK7qOrMBjVMEtdS317ychixHdMQZ++oQM7FKcKThUoUHnjaR7rVVihKFPZ8h2E1YvhD+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(366004)(136003)(39860400002)(956004)(38100700002)(38350700002)(55016002)(4326008)(2906002)(54906003)(8936002)(6666004)(33716001)(6916009)(186003)(9576002)(86362001)(83380400001)(66476007)(66946007)(44832011)(26005)(8676002)(5660300002)(316002)(52116002)(6496006)(1076003)(33656002)(478600001)(66556008)(4744005)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3V9cRYq/E5Z2k5A83QPsvGAEEMP1sSygIFPJWK1S6zqybCyPIa5srx3qkEzo?=
 =?us-ascii?Q?fonKxpLJvvym+4jXChJf2vT/S7IytY2fo1HlQEAWDPNbxnU5rqk5VmP/JAYc?=
 =?us-ascii?Q?Q7QKRb9Jdqj3e/N9da+MyeIxsb/oWufTZjefZfgzAPER4MPtCYyQoBk5Cf7c?=
 =?us-ascii?Q?JhO+zzazMGuKHAupnfQZ0nPb8171v0MPBrf2MWJR0mWW5c1+XAjwMWQwP5Zq?=
 =?us-ascii?Q?GmSS4/rx29m3QUxPPu+7Gca53eBvfmcDR101dan7YpI6M0BcxLssSlEfq4+7?=
 =?us-ascii?Q?2BHnv/gy1QOzkidt+col4nexAh31qwb7d7Q1LozOHngfs4B+5Pw3Oh9jgl9k?=
 =?us-ascii?Q?usiGypMlbpenUo7BdutEYujqxPc3SfQnFx5kj2U8y0qReEPYF4EJEcSRbNIc?=
 =?us-ascii?Q?v8ku24L5QLGOpxJjVywHmTTASCho++o9rfNkHQc8XkCFuF2PE54PxFzDyXpf?=
 =?us-ascii?Q?c7dWZxCbbRTs8XsxRxBBbLkmTC12sr0oVCtJp5Yiaxjz9nKBOYN8RTP6Aj/b?=
 =?us-ascii?Q?RfyONLfvdrXn70wUpYEOhh9kaV/RGYwzre7bo5e/8sVU2/LIj6ZZucRrd7Hd?=
 =?us-ascii?Q?Pu6wXDbn2yr/1kBvMDooRaXqLT3XW5bFjtaYBe6wh3C+fHYYfh0xIKpi8Jny?=
 =?us-ascii?Q?n2P4Q/leKweU86idXirB1Olra3f3IXrATV9ygTYJJUZsWPV4gJdBHy7Czmpe?=
 =?us-ascii?Q?0G+rfA4WCI9f6lulb8SQR9DlFpMCh0iX6vpy9wEU8LeKVm+ZDfU6CjyBKT2U?=
 =?us-ascii?Q?POr9h27UcLogPGQaGuq+k0zymYFcxhyTlzet0/2CMuq1+iAYx7v+9MOAl0Ci?=
 =?us-ascii?Q?UPhWf+jwHoL0N0MEi1meVqnE6uFDamlCv/gw1FYZmOv8vkEd7LghDBr1bcdk?=
 =?us-ascii?Q?glJzIc3sonh4AXcrDjIhQHdH1OhSYOKLZTf7k+kgJLHtap+IT4LYZ3yiLPsf?=
 =?us-ascii?Q?6Pma9SKZcf0F2vEIAL3R3EEgwV5cj7kl1KJIQWR9usn1T8J6+M+1KRJMpcwT?=
 =?us-ascii?Q?1+lgneK55FmeIH9rTqwhHhfOJI6dj3uzw+fZ8if9nbJwOh7ksnF7RoBkz7Cf?=
 =?us-ascii?Q?AGJDLubf4gM2cqUm0KI7qyTy5eM3KDjBnfp0F3T+ygvZZL0TrujfcTftSOw5?=
 =?us-ascii?Q?Cc4n2j245RnFa7UW/qrVc3DQ7oAvzWY2++GzDtcBRxVB7g28BJl3AFy7koVs?=
 =?us-ascii?Q?nrV9ZINDJ1Chb0WVh5x0R0MIk/yCjMVyAqQLtCEbgWMidgs1gYrYlLOOpZlN?=
 =?us-ascii?Q?GVHP39a3EomvR/aBAZYY1JwXO2YJFr5Qb16Y0m7GBhVskXC2ACHuWsMuS/f1?=
 =?us-ascii?Q?ubCasZsxdRSKSbMr4flLPL3x?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e56ab905-eaa5-4d39-7da9-08d950d586a0
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 08:07:06.8025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZboKF2dNeaec9JrJthrXUI3Ii06/MJT8M3lk8DjnRo4yMiooi0o6eLu5P4a4d3pHgJXW71TO6I6cOaDlFbYs4s+Xxdi8wjfToMkFWFfo+QM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1950
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270046
X-Proofpoint-GUID: NkENsWa8fnA29NOyfikI4OURXdOYk_4u
X-Proofpoint-ORIG-GUID: NkENsWa8fnA29NOyfikI4OURXdOYk_4u
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yeah.  Thanks so much.  This is a new Smatch warning I'm working on.
It triggers a warning whenever __might_sleep() or __might_sleep() are
called and the prempt count is non-zero.  I didn't know what the
"preempt_offset" argument was for.

I'll modify the check to only warn when "preempt_offset" is zero.

regards,
dan carpenter


