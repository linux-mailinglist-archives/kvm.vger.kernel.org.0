Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE293E022D
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 15:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238417AbhHDNmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 09:42:39 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:47434 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237426AbhHDNmi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 09:42:38 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 174Dfcs2008367;
        Wed, 4 Aug 2021 13:42:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=Qu5v+0eNyBFzHTOBxZ6W1D/4aHKjOkQs3qFosl65yAg=;
 b=lzqRpfp9RHPikTMj0VesHHYM7S5BqMNjSvH4ry42jWGy7JgyKQQT+TBnnJo9CDBWNZgE
 9aSxo4nhCgNh2JfjJOxcETxvAr8K1h08bXl9TsA/s3OZFGOrpgr6CrEDSsjA9K/9igQy
 sTD1djc4SgfWBaeDFcGUpI5WlcE0Tb/8OWI9JgXTDgqYke4ZWnfgMSIem7BG8kYCP7Eh
 2KdZqpB3wc28BNnXUUnk24XZq8CeEUPZptAld/dEtUWkCxZBBx9aEOFp6B+oSArQiWJR
 7LBH7OGDNq/8RGzHA6IUbxBD+AZge0e5bFMpmPxyYOdHQChSZIB1fsDzQVZ6pLPfUQh+ iQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=Qu5v+0eNyBFzHTOBxZ6W1D/4aHKjOkQs3qFosl65yAg=;
 b=Gv7+6CDVrQu1PyDgKTw8vDziymj1CAUiweukaxCsGg5mFsAH4x0EPkwNFMG3i4IlwtZe
 mrSxxHdgraA0uVZ3xF79w16OZ+C2UI1A8VOx3tbLenhPwePqsKDw7L26uBNv7RZJHWhx
 SdixQ45XThIzuyTQaIMshkso4e7Qeooas7ukT26OEAM9sd+uSZCEblBeDp6EOpAvHuqu
 ECAd1Si/IWv6u1nWci1mqSaX9RPd3FKeRoXLLsPq0B1MQTzAMZUQgMlO+1lOuPQhA4Ok
 BrYUWwjqOusFI3g27y8mSAa0Kr1OGOWWqiL3tVPum8s04yIZQ+EDo3ix4HQ8gQtRHR9b cA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7aq0a1b8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Aug 2021 13:42:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 174DeAqP093559;
        Wed, 4 Aug 2021 13:42:23 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by aserp3030.oracle.com with ESMTP id 3a78d6r28h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Aug 2021 13:42:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZvgHP8SfY5vFMWaZYoISQ/pemCHhSF1j+EM1ANxUEuRXk2WmsevlZ8ScHwMWnK1Cp6GOFKpc5UZnIId9r0RW82ALi0IXviyTHL9S65Lnd2XOFlEfORX4xO7wSTbrWc0dC8BsyOgvmpXoz3xuZtHELiPRTGEHynCO7KXvvJF7QjX+zSWd1WS57VlheQ+/Bk8d3S8hWL9jqP1h87aySPF22RVOR+Y9/q0ncfFWPMX96qAE+Ury3zxtVYhSJyNNgP0F0EHGTmT4sYilxrFyuGSaqH7fIfOR6EgFVCNTxd36MqltfEot7JpQvs+x0cHTQwHAdG61pUXUB+eR7h9NWXZmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qu5v+0eNyBFzHTOBxZ6W1D/4aHKjOkQs3qFosl65yAg=;
 b=b1KpRobnFrZpwhW3RqHCP9IQulP84Ml23AO3RFy7AH/crkgUCZHzQ+B2g1CxFTX83HRx+wsaG1ANh2FVqlzkP7J7F7cnBLORlWEws9kAoMYafXG3B4Cw3Eg4X6AwRvSfJ2lMqwZ3krPzrR3AcvaSbw6HWivaF3Zi/T8ZfnEZQrh9mCygzPHSxzpt6/BmtuUbPcyvPSbpOBOXzyS1yFfl1F3zVqXVgCk1Ejyeh5Okpcfp+AW8GMfFzBSLWhXiYheG7fd/SdBQz2XYBqoWvyEBaH51W0wPr4CRZcp8B6Z2sKJhc9TQKOcvX6+ICJb2VP+o5d3ehh3PgtQiZvAAeT66hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qu5v+0eNyBFzHTOBxZ6W1D/4aHKjOkQs3qFosl65yAg=;
 b=Lr/WIiKQ6OApHy2c3MmdE0HciH+w2qdRWZa+cBI+PjmrNsiPyCiB4cwQSD5s8z7JWS2Zr6TgG57yodqyEmgNF+z3sI5BZV8mYOFVJNNf0O+CGloQVzI5qBPDSRUD8/OsFE0d8I7Xv8HpTCQS51Rr+nLAv/ZSHa+naVSFjalO/Mo=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4449.namprd10.prod.outlook.com
 (2603:10b6:303:9d::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Wed, 4 Aug
 2021 13:42:21 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4373.026; Wed, 4 Aug 2021
 13:42:21 +0000
Date:   Wed, 4 Aug 2021 16:42:03 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     kvm@vger.kernel.org
Subject: Re: [bug report] x86/sev: Split up runtime #VC handler for correct
 state tracking
Message-ID: <20210804134203.GG22532@kadam>
References: <20210804095725.GA8011@kili>
 <YQqKS7ayK1qkmNzv@suse.de>
 <20210804125834.GF22532@kadam>
 <YQqXhadHZ1Ya/NEn@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQqXhadHZ1Ya/NEn@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0026.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::10)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JNAP275CA0026.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Wed, 4 Aug 2021 13:42:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 325b94f2-6f50-4629-b802-08d9574daf1f
X-MS-TrafficTypeDiagnostic: CO1PR10MB4449:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB44494CA2728B885A7DB13D0E8EF19@CO1PR10MB4449.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nUBVSvStiOEc783M+qMcpb5ILHpoEyXeS+1/IDM6r5dF5C24+62Jc1jKHXcodgjS+wWVSJ/pBiUE7xWpflq6EopcTSGwgK6OrXXXuaigESJbe4Ujp/YeKB/MgU48qQUe55Ub6272kxyzgKtihSy+m+p1tpQnyHveSYrIJCXseu9RYdzmn0LAGaX+Eckk6PEERqgTlthVeLRUUYv7GL0ILjg6ZIbOWLAjE0hIRw7mDUjbyZXr4p6GDOfirv9FVGi6QPxgoMUp0BEu+fAz6JkbzBFL2ERHcfavM11osa7G1ZxdN4FVPf6wVMxHDCqAGT7v40OqAs9AfRmlYp6V+AzfdowyAJM+OJPJUmXu2t77kgm4olILw+8lgZX7Nx3Czqc4Z6VIYFMlTmqsahD7BftvXnWS/av8hxf8zprOYvKJvY0EZbDJLZ5lp7HMSXZvKoV0+647YAl/cxbTj6crlGstfcs11VGNsWDMeA575Dm/wzyDccYbVMu9gcp+xX+QUsdfMwJSgKyIdEuW8yOEPVdcj2wQzKp+JpRA8aLcYzHAOI2+LvW2fiDOLnOoUjnt8Lw3rXjRQvOZxfZ1gu7aMFUL1BMYVkQMXBGZEchY4yX8KtDeP+ol4OX5xe/13zVGT4Zgmr5Wd1M/ZV7RPIOaOcx0QjL3SmpcIx4r4oRKAYoJk9BTyDZdh70IeTcmmchwCVBUeNk01r5ZarbksaFELhM02w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(316002)(508600001)(83380400001)(9686003)(55016002)(2906002)(4326008)(66946007)(26005)(66476007)(8936002)(66556008)(8676002)(33716001)(186003)(86362001)(6916009)(33656002)(38100700002)(44832011)(9576002)(6496006)(956004)(1076003)(4744005)(52116002)(38350700002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xH326xD1Ycwcav8Ceghdg6A4/GWKqbaNZ2gZkL2SMrThUPPV6VABFigWdQVb?=
 =?us-ascii?Q?0hsv6TgpvVUGv/HajCNPp1uGi/bYtk1VKU6e3nkxu2mw2ot8WrhZneOLwMj/?=
 =?us-ascii?Q?81eKs4cYfyOa7hbNuXKK5ZT0/koHilF6jd1Ud4axlPmjU9CxcNPYWflz7TEw?=
 =?us-ascii?Q?9XRoWAEpJXYLiwmhA7/dcGVUCIwveiEg6qtM8k86BH6IHmDwBgFpklz3Njap?=
 =?us-ascii?Q?XW90QOyDqoVGyVL8AXQW8OnbldZPag16IYUsdO/PpyVRD6IY3w1ae/+5DrGs?=
 =?us-ascii?Q?09Wrl2JXkJJa2ed/6DNNKoUV2gLXGum0KYZjU4wTBqeyfpWPgV2QNgxW/VUE?=
 =?us-ascii?Q?HR9vvV3sVpUmjcB1aY2KdhDFbXwN/1Yr7xijV7rIHKlrhaKtv7qsSEs8JZW7?=
 =?us-ascii?Q?L/belA850JR5pJa7C423u665VyQCYVkd/uiryBHSMEweS4vld1G8sbiIM6Mx?=
 =?us-ascii?Q?34ImjyWAlPsUSkP9f753W3GQMvRz4jp2IEFkNpd3nj3+fc6MxLTyfWLJdIfV?=
 =?us-ascii?Q?sXHzH5JdtMPKrFg9584z+GafL16+y0Hyy2ppBZB75Hzf2Gs0pYW//dBqO2kJ?=
 =?us-ascii?Q?uel6RJ5X4Flg+02ISbOUUo73SNbSOSYwUQv2URSQkozOe2FWfD3atZkcApsk?=
 =?us-ascii?Q?ATggDlwjUmQjRVIOAyD6+nNZYQrhQ6arR0gUbSDp1gfHyj5ZFbT5ECrloZpN?=
 =?us-ascii?Q?nsC5zcF00Ao+4NI2xe/NuybsnUf9OpVbMakWXe79psMwyhDj56t5oH3UTFSB?=
 =?us-ascii?Q?gmeRJ7Ho4xqbu8k5FIInnZcVeaN+7M66GQMdBLPkYfb3yBUiZRqL8eoGxuT4?=
 =?us-ascii?Q?Sa0UrTQ5pO3gJAE3XaXQQmbSYVJ+FoZLcPa4kzGfXLY3u4PlaDQfI0Nu9yAc?=
 =?us-ascii?Q?DM08/nRfVtX7QA7yzoXpWDVnG4gbjCHMSWPg/RuG/cXhx2ymVxnE3ulS1yvJ?=
 =?us-ascii?Q?reztJm4f9LFsIjX1SU/kYX1MsSiw0dMNfLUxTBgYIV4D0P26vZ7XdnWoZ8NW?=
 =?us-ascii?Q?MCNGwYzkIt5Z1DT90QpW1D79I4UKROuMaa+RJSgJmf5SudbtX7eMTCY2U1P3?=
 =?us-ascii?Q?/HshrnMdqIZ/B085aE5gFuiRnzE95WF1mwJi0Xs+J0/YXcdwpCl3Cqi9cTAT?=
 =?us-ascii?Q?1a3JQwf75Q5WjOho/v6yQNvzF5wxLQqwH62yTqKvdzQZGJTgJXI5UFk0CW+1?=
 =?us-ascii?Q?/By6NLT+waxVy7pG3XTSGJZ9VEtfSWXQx6hQHsSXA8Ni7s4eG2DD5c13PuXY?=
 =?us-ascii?Q?Ppml9x/CnRchNp5+T7xJ0yTvVIzy7pfyapAFLBdvoFBQCghYFsC0K+wEMixe?=
 =?us-ascii?Q?phigibZvS/YchUZsxyNyUyFL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 325b94f2-6f50-4629-b802-08d9574daf1f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 13:42:21.3384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RY3UP+OLxd3fq0yBu4SykpF+j4nm7Bb4fL3IliTZZzBx8SAOGpqErNkgWuf5XNZXamfxhMdN2sllcn7/lldFdHXP7RN9QID25UImzworZrs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4449
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108040074
X-Proofpoint-ORIG-GUID: tsbr0Iww33Rnus3bpvOzrZr_aFbZMzfP
X-Proofpoint-GUID: tsbr0Iww33Rnus3bpvOzrZr_aFbZMzfP
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 04, 2021 at 03:35:01PM +0200, Joerg Roedel wrote:
> On Wed, Aug 04, 2021 at 03:58:34PM +0300, Dan Carpenter wrote:
> > Hm...  Ok.  Let give you the rest of the call tree then because I'm not
> > seeing where it checks preempt count.
> 
> The check is in faulthandler_disabled(), it checks for in_atomic().
> 

That check is later after the caller tree that I pasted as already
called schedule().

regards,
dan carpenter

