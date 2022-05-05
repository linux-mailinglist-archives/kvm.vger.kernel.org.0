Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9500751BC90
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 11:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245544AbiEEJ7Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 05:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354708AbiEEJ7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 05:59:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E38140D7
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 02:55:30 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2456UMre013507;
        Thu, 5 May 2022 09:55:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=PeXQxzNfSewY/taWyYR+m1fd5mhLL6SnOQvzbabDEpc=;
 b=dEmbjaK/kkxHrcwIOODMnb7Fkp+ueFEu6g9it/7Up46I47d+TMy3UqbzXbIFjnM+iAMD
 f155cu6mMduCRsiB6Cfze6Q2u294MfgTevWweFI4/rAxfXLJp4E5Z95FPIjrUQH3t8Pw
 Lm5cScOSY4r9KziCIQj3Y8S/aATmyCQ9R8B9XBiy+7LlVL8VHZ3m3zZMScv44y1D7vHu
 Xk7AZtSuWrJaqfOwkHMeRrpETUPXKdfEbDIkBVrgCtDqfWcY6LtpdfOkkqgOsw1ZLYc2
 OyXi6K2gIKuQ3WGvtivjWl+EtmmliYDPD70u9CwHvvo63Vo9+QqEST7A4y82VGZD90ui Dw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frvqsjvg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 May 2022 09:55:08 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2459pQFZ020195;
        Thu, 5 May 2022 09:55:08 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fs1a6rchn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 May 2022 09:55:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sjdz3/tIIoqlJEZROMk7o3Ca1FPjqcRkVIyGFRs2wigp8cg2rbTJd7jpxqnDInMLd64jUUxs4lhgU3geiFYd3VM1wjcK/W3RC5R++kbTeEblznJh2D9lKgRXBsndOgR6pRP5xWnHqdIqHVNDqg2BYlAItCG4w726/WBmpuWV1894ljoo7NcdEg2CndZRooRGkXq2YpjKrb8dY6Bb+nqNCQCZz+oFJ/1tqlMA0JF1ho3cn4auNSF/xOJt/Uflrqutz2zgz0jO2fblHEZ/Z+pKtOZbOeFrdZUac6+8+M+WEOq6DGsaDMCEfvCmRyQevbeDHI6vVhEvh7sSuMo0Csfv9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PeXQxzNfSewY/taWyYR+m1fd5mhLL6SnOQvzbabDEpc=;
 b=Vfu9F3SVZrp2QovqumVtO3HI7rZbZ28EYEpip03XESh+tFBeYF/bRhPH9e1ZjnVWg+2TwCqB1Pwl+CISIKWsgc4l3OPZOvBQfQXMzUjW2SLMfkFQ0BYVuXuJmWnE6SI/7M9bkZ265Wemgci3xV8B2yXFrtw1iObobT0Brcphg/ZqPO5o+fBSkQZwuJDTRL4ZNNLV7UKqcNX97uM9cYt7+J3bGquufIftYe+xET6O32ZpSM4/CltmTgQQftcElJiqXuGAaMhB8ywtZn7caGi6+2VHda5R4M2Rrqjfy9xXiNORkftZ/tzaNxjw49DS0jxp87qd6s+1T29lnRiA4I9CkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PeXQxzNfSewY/taWyYR+m1fd5mhLL6SnOQvzbabDEpc=;
 b=NjnlZDTLADzstmP9WU0xPrnmMKjobggXU7cavqyXyd38CCXt3JhGOVxMv44eP8Nf29Jm6g/2QZBvljGWQ4ArQYryjUsFoCPYx9KQwXZ/aXOcdea6ws6VAHVrE2g6qFqVfWJb2iD/xzqS6Y82p5DJdF3+y3emhqVhheqlBwMjSjs=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Thu, 5 May
 2022 09:55:05 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 09:55:05 +0000
Message-ID: <90b6d741-7b18-e3e7-ab42-363ba58a96b0@oracle.com>
Date:   Thu, 5 May 2022 10:54:57 +0100
Subject: Re: [PATCH RFC 04/10] intel_iommu: Second Stage Access Dirty bit
 support
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>,
        "John G . Johnson" <john.g.johnson@oracle.com>, kvm@vger.kernel.org
References: <20220428211351.3897-1-joao.m.martins@oracle.com>
 <20220428211351.3897-5-joao.m.martins@oracle.com>
 <YnLd5b3GssL0l/uE@xz-m1.local>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <YnLd5b3GssL0l/uE@xz-m1.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P190CA0011.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5402a549-eb08-4004-098f-08da2e7d549e
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB532783EDDE6AE3BACB18E844BBC29@DS7PR10MB5327.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +0ujqOSrW0zhS+8gpmeMfOIVUObJG/imbE1+AMdcrO+/C7KzXlbylt+QHCkqd4VeQrJFtl0/U443ZpiQ+DBT00UOvgVlAvMP3/ZEQZQPkAcXaA4PtQe5PGlHJcDVB8W3h+rNBSwVXanjpx/+qRCywFu67U3r+0rHsMq8ep2N7QzI8QKp05EZoGIj6VO0bjQ+vWZnX5YWqWOdZ7UDEwJcfCy5hIEoClfEgZagkaAdrVblbpi0QIi92kynBSrUl9HUDKrzxIntqzy06umzyj17E61f6cZJf102o+AnaYtucTLE8p/wZVBPG0IFsdalcWVZ0yKks5kHkrt+Dql4B09EVkToEtP2hXD+zOsLstxaWlRex6JuX6tNFTCGVjiYM7SzG33X0mtlZV7ggfF/iP/CVe9Rtd0t+PNQddHy6sNG0PtBzeWjxEtwqQ+XfKo9OnBP2qUx83DzABjBcjcXC+tunRe+ygm+NFZFvHZfublmGMGy1YmGvv6YN8flQoceFV2NN9rDiOO/fS8vse42GGnNnOzAbrXrwO1WuIOUtUwHGODZp5II3mJ2db5mcwE16f/1nmdf6RPdVL4O2F+18hL11Hz8Eoc1XDxNxkF1hUIduKljWZBXUsdQOQAHrTl5Z/jcPh9q82spmQ/ZicIILrwfd1YbJZchy4+B192j69chIwguHyJKqcbTqXC1aWYTw+A/DP+vJtZL4juvb1j7R7tL8jewYgVG37nAs0EOiidOp6Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(2616005)(26005)(186003)(5660300002)(38100700002)(6512007)(31686004)(36756003)(2906002)(54906003)(6666004)(4744005)(83380400001)(6506007)(6916009)(316002)(86362001)(31696002)(8936002)(508600001)(4326008)(6486002)(8676002)(66946007)(66476007)(66556008)(53546011)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UHhOUSsrMDFHMy8yMHFXdlkxb1pBYlZHNkdrRjBDRlR6NWlCc204TnlrRjlo?=
 =?utf-8?B?RlJUMGUrbGRnS1pNQy9zeC9QMnJVN0duSVQxYnhYZDdkWFhucWplYzQ5bXdU?=
 =?utf-8?B?TFBNaTNqSm5MTEdqY0daaEhXSXEzKzd6dmhNYlJGcWdSby8xOXNESFRtWWpw?=
 =?utf-8?B?TFR3NVFwN0JleEM4ZzlpSnpieXEzOWZxRnVFVnhXSFpFaXpyNXhQWGVTeHlQ?=
 =?utf-8?B?bFVnS2pTMzNkem94UnRYTmI3WWRabGlQTllKbHdtSnZaSDhYZ1ZyTjNCcCtB?=
 =?utf-8?B?elUveTZqeW9VUW1aMk00dDhKZ0h6NVJGWGFLbUpHWVc3R3lEdW5FZ0tVV0Nn?=
 =?utf-8?B?V3JKV296UGEycXNpWWZ3aXl2NGtPMVZ4L0pWd1RvdFpPdUxCSlpKeitaMS9a?=
 =?utf-8?B?LzQzMkFlRlUvdjV5VnlVMnJnZjFzKzUzNngwczFqa0lRRzNjNE1laUZCRGdI?=
 =?utf-8?B?UnJJdG1wRDlON21mVjRROVpPOG5qMzVzZk1JSmViYlZ0VitpUjRENEI2T2lk?=
 =?utf-8?B?RTRSckk2UloybXpncmZkRzdTNkJoYi9LamtFVlZVL3BKWDJPa1dISS85TkNO?=
 =?utf-8?B?VTFNd0ZPNjF2bFhQMTFlZTUrd1I0S3J5K3liNEk1VGxrTFd5VW1yMkNDNUw1?=
 =?utf-8?B?Qk9yWWlVR1FhZ0lTK0pZNXA2ZE5hS3VmVk4wVW5yYllSY0xuTlNlNHl2NFpE?=
 =?utf-8?B?alF1OEdtcnJkTklXeXpCVkVMcWJqc1RNRkwzWE9Bb1ltUm1POFZpYll4Zmsv?=
 =?utf-8?B?c2xlejRBbU5aWWNuaitHcHZ1aUh5dytYZU9NNTllekp1VnBLSmpCZkx3L0Rv?=
 =?utf-8?B?ZVR6QWhvTFg2ZWo0NDVKRCtEdkpVeXpkVlZoOUxlSGgxSlN6WTIrbzAxUFov?=
 =?utf-8?B?Ym5TTUNVSnFZV3ZBaUd4QnZKaWlZbmZGWlhZY1ZUUjI5bDZVMUxIZlFjNDR0?=
 =?utf-8?B?RC9INUF6U1RZdGVIWGNoa2x4UnkvekpJU09xS0JzSlRSMkI3M1l3ZXM2czRD?=
 =?utf-8?B?NnNNd3UxWUFORER3VThpc1ZJamxGdGdiemhzd1YwdklhU0o5U3JRSXlqRXc1?=
 =?utf-8?B?cjNhQ21pSlcxMnpFNk1aTGRULzVpZ2UrNVBOa01BK2dZdVhTQXRnT0ZaTFVL?=
 =?utf-8?B?NlFtU3BPVnNqWm50UWpTNU81NGhDYzFJMTd1dnpibjk5SlpwNXhFTVNJRVpD?=
 =?utf-8?B?ZDJoYnhWbktKUUtWc0VaeTJaYnZmbmpGNVM3ZzlTQng3MXRUeVA0b2IyNVlD?=
 =?utf-8?B?TFIwcENmdTIxbVJ4YitwbjhVVGl5THQ2RmJSd1VVU2JBcmVDTHBPRVhyYlpM?=
 =?utf-8?B?aW1KTW42dXhpZVpwOEdkeEloVzZZMDlPRk0xb0g3a1BVSEJqK05GT3JxdEVH?=
 =?utf-8?B?bWJwTzVzSTFraUl2Wk80empyVmRndktxcWRSZTZuL3lVcjFTK0Fmc1dUNnI5?=
 =?utf-8?B?OXlUQlFsNDFycmMrdmpsdXBuVHNKSjBTaTc2SnFmRDl6c2lha0ZHaWVrRGVZ?=
 =?utf-8?B?c0JUOTFmaFpaWkg3RXdjQVFZUVJ4elNnU3JudHhmV0dEazhVZmkzMkswV3B5?=
 =?utf-8?B?Mkd3TlZvOGlvbHhsYXpha1JyZU1iSTNVcjBYUGRDbkhKVDQ2b1VodEF3dm5B?=
 =?utf-8?B?SFQ2RERSRUUydk1mOEt0WnlKL252aXpkYUZQcXphYzJIeC90MFhnbVRWeU1C?=
 =?utf-8?B?T2xaNE1YY2FIU2tlM0lRQUZZeUVvejdnTjNNc0xKU3Y4eE03aXBka0pSZFpH?=
 =?utf-8?B?TjgrdG1JNHZsamMyQzZMYkpRcGtRTmh5THJmU29MeDBNT01oKzhYNmNRTVJU?=
 =?utf-8?B?YXpaZzR6U1pYRXhwZzVwdEUrVXJFc1hZeFVZMHQxOW9IMXI3OUh4ckVvN3NW?=
 =?utf-8?B?T0VWQWlGcnlOR3VPSzRLbkRSclBKQzk2RFpHSjFka2dsOVoyQVBKcGVBL01U?=
 =?utf-8?B?c0g5Rk4xa2NBNzZySGd0eWRCNmtZUXJZY3NDckRuYkovZ0R2RVRQRUY4d3ZG?=
 =?utf-8?B?ZVdEeHFrUTV1RlBzVXlnZUdGdTFiM2lDREUrQmZ0S0Y0T0dQOVdES1VoOUpY?=
 =?utf-8?B?QVROeitEYzdKRXMxbDQ4OUtCamFYWW0zL0R0T0JUbXVaS1pkdm96c0FpVWdj?=
 =?utf-8?B?cmIra0poVTE4dkVjUEczL0t5MzJLVDdIbDlTR2VCcmJISGp5cFE3c0pxWlFn?=
 =?utf-8?B?VFpqWFM5dFRjR0xqblJVbjhiNG9DbmlWbGI0RHNuQUVlS0tzYnBaaVd5NVRi?=
 =?utf-8?B?ZGJ0clFoMVlkNXo2dUdIMjg5YTR6UkNwNDg1VGVyYktKS3hpY0laKzdwcmtN?=
 =?utf-8?B?bCtaWUczRVdkZ1JNd3o4UmJWQS8xdm44RFd6WUNndG9CL1VCdnRuSGVJbGdr?=
 =?utf-8?Q?m1BfftGBqDpIPVRg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5402a549-eb08-4004-098f-08da2e7d549e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 09:55:05.5060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P98J8QNgg3VjnVGvTURRFn15oOupJka7Yy5TrrwkUjM8FWG/MYDOdG2vkv7iia7LwwSZnSMy0YT2J+hvMORSjG+nQk7kpf2+/20FGr1ig/U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5327
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-05_04:2022-05-05,2022-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205050069
X-Proofpoint-GUID: ufGjmbVh4hxqv-9Xc7wZzHjr6_ZUfTK2
X-Proofpoint-ORIG-GUID: ufGjmbVh4hxqv-9Xc7wZzHjr6_ZUfTK2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/4/22 21:11, Peter Xu wrote:
> Hi, Joao,
> 
> On Thu, Apr 28, 2022 at 10:13:45PM +0100, Joao Martins wrote:
>> +/* Get the content of a spte located in @base_addr[@index] */
>> +static uint64_t vtd_set_slpte(dma_addr_t base_addr, uint32_t index,
>> +                              uint64_t slpte)
>> +{
>> +
>> +    if (dma_memory_write(&address_space_memory,
>> +                         base_addr + index * sizeof(slpte), &slpte,
>> +                         sizeof(slpte), MEMTXATTRS_UNSPECIFIED)) {
>> +        slpte = (uint64_t)-1;
>> +        return slpte;
>> +    }
>> +
>> +    return vtd_get_slpte(base_addr, index);
>> +}
> 
> Could I ask when the write succeeded, why need to read slpte again?

We don't, I should delete this.

Perhaps I was obsessed that what I set is what I get in the end and this
was a remnant of it.
