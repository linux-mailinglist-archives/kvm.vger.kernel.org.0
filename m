Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628D056A679
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 17:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236117AbiGGPAD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 11:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236378AbiGGO7p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 10:59:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1F1599FC;
        Thu,  7 Jul 2022 07:59:05 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267Eqb8V026145;
        Thu, 7 Jul 2022 14:58:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=PkaSnhjvXXRaGa4X/wn6DVz10/4aL0t4Wh7Cbn9Diqk=;
 b=kwz1VMzJiihpyouCDEh7ddfZ1VotX+//67AfL/fb/iVjU//FOYLuykzq82/wuZMPANI+
 Cu5yNObMpe0BXk6djEN7/p1L0d3CZzAwcbXJSwHRO3ctGSVtv6WDfWYQf7L+TbdetxIx
 aZAGyj7+vWh6bUS9bRUofQBZhWljwsNts0dRucJFzwDyu4T6wy7YNgDj8p+1hvL9K+qE
 6/eRfAQAv2XxR1dbTJN+3kDJkFDZDqh+Dr7Sa35SPF0FAl+TseCZxZClgbQ65dq1N8YH
 iIB7GEmf1r1ixhnKk60J8WckWKHy9VBTy/p43BXjOnavWQy/U21oESNgdUe/0kgl71b1 eQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubywas6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 14:58:52 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 267EtLxP031075;
        Thu, 7 Jul 2022 14:58:51 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h4ud725br-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 14:58:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FFb8MwjcoQj1O2hvlHJwo4Ohv5c2At7xl7ToGOjn8WhVm++VfKIKAmRzFypT9zb1eabF9rqmXyPaj5u8WTa1la2+ad58w3AMsH/4BXNtzzo9w0xkTrrj5VHD4LrgFQ69SwWyX3RFGloOuERtQluR4TUoFj/tIc9tns6PLecye6iO419zKKiO13SaKWslA8pq527CgUmE7XmJCyRnbo/0UdyHK7wgkzXZ2OPBb7DVW54aM2KBbzdd3MrZjUNaJWw0O1n97lqyVDBdl07twbc19P2KhKb+XTXECAg/Kns4AjYx+Cz/wjURCWRJfGZ1vWk7aGIrbqLk7tn3rWkaEDjS1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PkaSnhjvXXRaGa4X/wn6DVz10/4aL0t4Wh7Cbn9Diqk=;
 b=es91dg4cwBwR0l0I9lvMVk3INmxqHguCyXiqhwIqNllxQ4UGI2oMS5tRYGYZ94oUoFtDJGcVzae8IuOD0mxWCoeSghyLUUA4GJwoTdvl2G0MPfpIkkdJo1cZ00RPqLrw96t6iBNyNMiWtvYokCSoi6ohpCkTsyCDNXeXEnZJ1/E8cSrjwPmaJAwszDiQmlFAjRjnoz8Q1+93ufaP9ZJRv+o2On3sUq0ZdNGF9p0UNLtrHhKr0NhA290Zz2OnVj0UmPrAanRz+l8WsHMnXSnpd0LFZoIk89Yr+wIzrmVB7ZvBEpILI0zAP9wM1MANcVM+TCFYEe+zIOf9bi0vYrn53g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PkaSnhjvXXRaGa4X/wn6DVz10/4aL0t4Wh7Cbn9Diqk=;
 b=Mb9rCgT7er4v7UuqboJoKE+ofYrjQWGkBm8ujLMqlBg0bulo/t9T7YFyF4gUJixXKjdTTIceGuFpz18+JGkLMuf+rGYtIMdFpvBnV9d4YvG2fmCsXIddxsELgZaYhhc5qcE9gFDMGzfw0Z3Q6rB1AbpJOWj11g4tKy8lvXg8uWU=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CY4PR1001MB2151.namprd10.prod.outlook.com
 (2603:10b6:910:42::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Thu, 7 Jul
 2022 14:58:45 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5417.016; Thu, 7 Jul 2022
 14:58:44 +0000
Date:   Thu, 7 Jul 2022 17:58:24 +0300
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
Message-ID: <20220707145824.GH2316@kadam>
References: <YsP+2CWqMudArkqF@kili>
 <20220705180649.GI23621@ziepe.ca>
 <20220706055124.GA2338@kadam>
 <20220706161812.GJ23621@ziepe.ca>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706161812.GJ23621@ziepe.ca>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0041.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::16)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e521d20e-e9c7-4ba0-0573-08da60293032
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2151:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4xRSrSVYqAesKJLWr+fm1MVVbDFdacf8WL/rgV/3+zQuNqgFWnc/ZUEYIqJM6uzxHZJ6r+ZScfCXpLH09twfeCatS04FMaQgIIZjCYGjqkWV7zlC9Fqsrw8LXBC7hPJDax5rtEWdcqhKBhaeWKkktmWGFNKU0iZqQ/AYYBdQXq5auZlamni8HAaK5gSM8zdBTvbUZCKtSWy1PdkK0t07wT3/LrlZpReDoY48PpxaIQr/3yhyRmMfLRTehYgxy49NS0MdKzEQQ8LbVnBEtcq3cZU1Y4pPiQ8Nl6wlNxdIStBooP6Lhw1Osa+aH0CB0aC7k6FrIXIoL4QX6B7JJ2Jg1s9QeEcAtOFiSRYpTXUTAJ/vBHGD01KAqQQiKjQyeT4VNCaCSVoY/gh156EHnw61x099ga6NO+3+8UGLP9NRvpr51lVbwloiSusmQRWvN3AAEivd6cvoglqL2KbXz1NCHyuHIf5mXXC9WCLsnqQsKe9iSHGLRMj7Jv5S7yJiy5cYeNVKRaiwUtCWNBwq5DcJ1W3y0eEVzxjvWgJyfernmkSS4bFQMz5rZc3Z2s1k75tlvf+ejaZQutXIri0cvwRACtsf9KAHpj2qLBHAfi7cPIkFmL2IKr8dGsNdleFs7maA9ZKEW2hDM+n4US0Ge9I3wdjKJ22xQc1ZjWTBSYZ2hI4uyq+tJ3LMroqIabncXicXXVPyWqmrYstRP6W4aT+0q3882ss1y/mxQiqhF4ew+I1hQUNZ1V6lw8UnmgQyfbwVq/W4zmxopFUXayLKuOf5o/8rIxhB6fU4MVkhH8iBod5VybFta3ggPJ7ctaLN87OS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(376002)(366004)(396003)(39860400002)(136003)(86362001)(6666004)(33656002)(33716001)(5660300002)(38100700002)(6486002)(7416002)(38350700002)(44832011)(2906002)(316002)(41300700001)(478600001)(8936002)(4744005)(54906003)(6916009)(4326008)(66946007)(8676002)(66556008)(66476007)(83380400001)(186003)(26005)(52116002)(6512007)(9686003)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gCIeCjh3dv6Mczg+7R7Tg0OdLtw0xf5fmTuw7rds3Zt6ut+wjNIDEQALVjf2?=
 =?us-ascii?Q?vev0KQ1otGKYig/w0fy2kVhXiPT2wOi1j13AKKYvB9pVLXOiJVSAUs6nEcPH?=
 =?us-ascii?Q?zxAsQG7dJu3Va6d6leXO18Q5PT+dBEa7zlJsZ6TiKS2M5sH9ek/NoafcIOFS?=
 =?us-ascii?Q?RD0jmxsm0NTC1PoCnA8cQ4xsfrAExBnZ7dOEkEgNNdU2I5Yjej6Bu/JRv/sn?=
 =?us-ascii?Q?RcpgvIsmBkyRKYEbvhyW9Mm40azRDWE2GlAgunvf52kLoIQnAQmtIAv5gMSX?=
 =?us-ascii?Q?OlGUU7RpGquoNmMK9E/Q3a4o4t6QF6U7ax0ipItpIE6zky+8wgWJg/rl+dI8?=
 =?us-ascii?Q?LDHqgjZyPmeT0X6HQ10mpnaJOtUPuPE8dViljRZmN9WArrOfsipF+anliiRA?=
 =?us-ascii?Q?+qHfdYWWGZqYuJYFflxVtMRRXFuN1LZPvRDKgAPNToxEJeT89cY6fQOmHXzd?=
 =?us-ascii?Q?/PDz1ovyP6PxLHaHgLk8IwlG8m4c04hNZsJ7KdQAq7VZA7n0JPR0k4Tx2ULt?=
 =?us-ascii?Q?XMZAwSlY3WXlbHqazJcE7h3cgS5Yj0TqcQ+fM/Va9sIrJXKWrDzw2r11j4Wh?=
 =?us-ascii?Q?TO/gtPyRMSepv0eKLyqQ1SJgPYEomrcgpqs8QDcrRRaT5SJg0DkasbgzhZT8?=
 =?us-ascii?Q?vjJC8b87bqFfaxhbE/XaPMj/Q2m3sAcfk+OkbhH/hhgalSVh4Tw2mzcnRujM?=
 =?us-ascii?Q?/oukUmjoP8WRAkjhwSufL/D0bvvJTM9dfMpTVpS03UjvPdS3WGDZoA2ySaFy?=
 =?us-ascii?Q?KUb8QME4o5d5l1ujqG5kAGBkpIUFQQV/Bip2s5wFBK83HEGsKTfkLuT4eLOO?=
 =?us-ascii?Q?IraEO9WDosysVxqnc6Jys0Cer5XxK5d3k7ZXDgduMNieZ4d3fnI76v1v3yKc?=
 =?us-ascii?Q?AiC+8XnBXuo4+hIgFHjKoK8NZ50RnypJXxGxaGc+ALuBJlE+ijvzdRVQTfnN?=
 =?us-ascii?Q?uo+KOJQEndfObfxpEYa/5qhPrQ+WEl99naKXng5UKroAdbopQxfF1f1SnnqX?=
 =?us-ascii?Q?Orz/M0VucDqqNa/PZkuLEvkpCqj4XcH+ylm0KBkerTf+ajvDE1s1dR2ax+Kr?=
 =?us-ascii?Q?3gEr9QImwBW029LP6zLOGt84qYevQhDasQEeIicyQlE8RsKELf4ng3YTwGeD?=
 =?us-ascii?Q?8Um7/SbpSlfWw9UZSPJQWAletxCZTPXqHUyEVuO9SM+nvYLooo5pVy5Fg7nO?=
 =?us-ascii?Q?YBXGKN/Ur1QTF/lwI/PNqNOC9YAIAuZWcd3YFg7M2QmCL0Yxrf6ZLu3v90Oy?=
 =?us-ascii?Q?W8vO4zTYq59lSWfJ63LT/BJTDJE5Hv7tyKy3G4xskPWCCEluFdb0EZERTYbM?=
 =?us-ascii?Q?Oorj+A+iUTFGVkg2jhzwseaKJAX0sEYnakwRirORsQ+gybESTvK9/5+vGQoI?=
 =?us-ascii?Q?MwIZD9nU2eZ0Zj1R1Ap+s0k1oRCZ0fnSSJhed1sPUiK9Wv34/S7Flw1sN20U?=
 =?us-ascii?Q?cBYvajWbjoq5Nw4FXOzaOLVz+ETg9iVC3E5rFgrTkUEtUyBIa2eo1km7mJ1E?=
 =?us-ascii?Q?iewfzHlbi0vmskgByUWy4PgryxkfuBkixUHPL4mH12yMFAgN0ZeQbsRmHam9?=
 =?us-ascii?Q?2R8Bf3K2eH3zDBWfANy9AvlXBBBRNU2jJ6soA/W2PRsOkGKvXilk719CvYaN?=
 =?us-ascii?Q?ug=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e521d20e-e9c7-4ba0-0573-08da60293032
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 14:58:44.8606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ZoUAzgzRm3383malHeFlg6MVfLejdZyxA87dDMkf7JolHieCsj9X2fWg84qAwa2/dtO3OmjHVkZVRDHy9wb8yB0yvYaPwFzmtxgbF8GOac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2151
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-07_12:2022-06-28,2022-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207070059
X-Proofpoint-ORIG-GUID: CXlE8yDhZsNtwJEm-XcRFXX-a-BdD165
X-Proofpoint-GUID: CXlE8yDhZsNtwJEm-XcRFXX-a-BdD165
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 06, 2022 at 01:18:12PM -0300, Jason Gunthorpe wrote:
> On Wed, Jul 06, 2022 at 08:51:24AM +0300, Dan Carpenter wrote:
>
> > > This code was copy and pasted from drivers/vfio/pci/mlx5/main.c, so it
> > > should be fixed too
> > 
> > Sure.
> > 
> > I created a static checker warning for this type of thing but it didn't
> > catch the issue in drivers/vfio/pci/mlx5/main.c because Smatch says that
> > the bug is impossible.  Which is true.
> 
> How come it is different?

No, it doesn't find either one.  I don't think it's a real bug because
of the rw_verify_area() thing.  But I wrote the check based on noticing
it during review just to see if there were similar issues and didn't
find anything.

regards,
dan carpenter


