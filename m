Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E480B540000
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 15:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244679AbiFGN05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 09:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244716AbiFGN0y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 09:26:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0D0C3D2B
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 06:26:46 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2579ejUJ027046;
        Tue, 7 Jun 2022 13:26:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=9uITkF2uU2TJ7clSii/loo2NKU3z3MQDlZxxr76CmnE=;
 b=wuqAsverWUZ/tI7IaqvjESmbGxFzGYwFeqA2aMvPh9qAyHtHATur0SM9TaLXy5oniNaD
 hWxcmOJ2O8IgjmJVtvJEJ2Isb/wY91/A5hTrfpYBF+1dabiJ6i8ygee0T2dLwYZvsH4a
 QBMxkRvUZqCmucK+9rKxb757xAZSa3KUF9KVOmbcgo4OKM6lGxJVBNsBPQizb5cnbUvO
 gC0yYRsAUI8YReqxvZgcK0uXBdnxIEhR5gYU5vOqAjgvyjt2y0EVYE0ClSJVukJA4BG7
 Z6ithksnulymhnzck0kcF6r1BG/BXrObYDJIsECIOV8kGy8nJ9dJpCvOCGjRwkptXoSD KA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gfydqnrku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jun 2022 13:26:32 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 257DC8xT028666;
        Tue, 7 Jun 2022 13:26:30 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gfwu2ngpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jun 2022 13:26:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YMsPclhagjdX/1JfoUiI1bgNtSmH+gYN9b1ZogroM84VvxfYZknChr1liT8+FZJyv5+6dIgUy2VGN4etD1FH10qAio6LJbLp0Ppx4vzvxPoUOjqY0S6YO/Yco+/Mhmg1Dx4S+DEsFmodxJ4VX+1d0iyJ3VCpRq56miK7vkFf4ALaCruLzCeHf1RbHbCmbJ9SJMgFYOFhpls76sKwuxnPAGK3RJVZEnCCpSzqDt/ol31Sy0a6fl7zDuR3RT56f4B3uwCbtG//HRD2/wyjajtnpVDxl8qylbNSxGolPW75AoJUvRF6OMSo097tWA5ZAXC4S/V91g/5gGjCq69JWuweQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9uITkF2uU2TJ7clSii/loo2NKU3z3MQDlZxxr76CmnE=;
 b=Xm3nWlXgmQvRAvWdKq0z+6AavbIX+vAG3xMwjb42uiBv0catrrb5Q/phwxa6xQ+ScXT/kxGBITxeXqFzYiy6DitaCTXnYCggfdTQb9fQ8eZK+3ov3uXwWbPeAIv4kjXLScmFhViAKPJkekXU2484e2JKBfuIhgVDjMXckVrbI73l56MFZ8XLFDVOXFvB3yTmM9HfMRUJ9fK4FwBPhCVRKPRw7qF1Mj7BITemyW6kZYB9KYxVonQBBvzdhaB6QWw7RkWWgkxcCSOvxMb2ez+HzF6bLhXe3Ab+tbmtM1wlnc/WsFoF7UcnWFaXS/aCQEbrYFATvFYGnUSUlAdhp7jvRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9uITkF2uU2TJ7clSii/loo2NKU3z3MQDlZxxr76CmnE=;
 b=TcrZ7l0m1PWks+DScczjNBFNizqsx0x808ZNWsbGGd72xbR71BMpsfA+yYyquTJMDtxBkeNlwSpVcDKCu+gv8GYnqrBXs/N8AYuv6TdQFV7cbM8mz2Z5Y4aL9s5RbnmqkxbYkLvhvcS3S7MkpOv6vHjzWWCEtK1wdr5YDtY/CW4=
Received: from BYAPR10MB2869.namprd10.prod.outlook.com (2603:10b6:a03:85::17)
 by CY4PR10MB1976.namprd10.prod.outlook.com (2603:10b6:903:11f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.18; Tue, 7 Jun
 2022 13:26:28 +0000
Received: from BYAPR10MB2869.namprd10.prod.outlook.com
 ([fe80::9d7b:4d6c:8fd9:766b]) by BYAPR10MB2869.namprd10.prod.outlook.com
 ([fe80::9d7b:4d6c:8fd9:766b%7]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 13:26:28 +0000
Date:   Tue, 7 Jun 2022 06:26:25 -0700
From:   Elena <elena.ufimtseva@oracle.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     qemu-devel@nongnu.org, jag.raman@oracle.com,
        john.g.johnson@oracle.com, john.levon@nutanix.com, mst@redhat.com,
        pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: ioregionfd with io_uring IORING_OP_URING_CMD
Message-ID: <20220607132625.GA181696@heatpiped>
References: <Yp4V61lfTTN3QsT4@stefanha-x1.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yp4V61lfTTN3QsT4@stefanha-x1.localdomain>
X-ClientProxiedBy: SJ0PR13CA0132.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::17) To BYAPR10MB2869.namprd10.prod.outlook.com
 (2603:10b6:a03:85::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03acdee1-d457-42f7-4f2d-08da48895400
X-MS-TrafficTypeDiagnostic: CY4PR10MB1976:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1976AEAFA04720281D7B494B8CA59@CY4PR10MB1976.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3l7fd7z3uXoxkwDqE+tqWY17gZ+hpGEVd2BNjJ6R9ALu5mr0kizoXvHtBdaC5CtME0l4tLvHYIJGP8pKP98e/BOl2v7oGNx+E+AqAJ7D/SHfQzWHTbaqQDcRZpGqHlnotmBm2zLjqo42AGrdSuatj6RT01NvM4VNBkFFDpOud1NYti/N3STMlmQu7bYB9XEpfRTIdsR1A5bq5G/G2Uq7TKO7E8z6H0gBtz+q8wSiKltK/CUbpAZpX7uHpFdavr12FWB1rJxrrBpOkFZRvDRD/Lou8+0N++DsyJai+WGHh3oF20HKBUhkkfve8rCLz6WSOElTLLQJxbEI0nHnpN5Wp/YOdIeZA+ng1jtm+uoBGKT9rjtRlCdf437eXG4ZSxV+Y3YqHGwROmdBHBF8rnq1EkH2V1bvd+jIFqenrVYK6exDzhFGdyXMHJZdpvobs07ueOhEKuEEKJ9nVHa1xSKmwzfQAEQSD3GutRSmnUAuF23BiWPl4qnm+N1Jt8yqixrz1O+PUCnBzVhQg+Oo4wUbE9TwqNU97wkQs0iRHX1AR6NoiNOrhUeeUNuyeIXx4wxx5Tit2aGflt67sikqskPUQ4IrQGzDtPLDX2Zw+9pzNcSLmX431O5ahBRwMmeBZTRaiN1SouK3aK0wOBBKcne5ShIkCEQyj/wZ66dGu2WrwzGSq3vsDScsciHPEVNsYBMNZy0vuaeLyrKQ7aDpDk/JbHzEZWTw36TtZmyd4HeXrDU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2869.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6486002)(33656002)(316002)(186003)(33716001)(2906002)(1076003)(9686003)(6512007)(6506007)(86362001)(52116002)(6666004)(38100700002)(6916009)(966005)(5660300002)(83380400001)(8936002)(66476007)(8676002)(66556008)(4326008)(508600001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3A/VZjvMvor2TZZ8PP7QOjmt2zjst13PyAusYO/fzlFWL0v6+vU0oIii1+ep?=
 =?us-ascii?Q?/TTtIayLrN4vrttX+Q4Si+cCdjkLktuJuCzUT++RDbqKiN/K8nOGK6ykrFXK?=
 =?us-ascii?Q?R0oze+vtddWDyJyWz3dlOWUV5+CO9tVbtYksM59TO0Hw7yG0YJ29aGdYXcEB?=
 =?us-ascii?Q?HKgdKPV4vQCJsFY5/pP+mTWpv0tAHq4iA7/aexaNhSBq4ed00mXXwOWjHKIx?=
 =?us-ascii?Q?zWcm94ZLbJnisPkrYmy8nrlpdvisGibnPNH2gZH5hQ7rGx3rk2wsB2+6JRcY?=
 =?us-ascii?Q?j9z8MbFlt8vjRAkYf1gnVJU3PoqVydhUmi8US0AZ/5TEnG/UDXAeOLvB1s8l?=
 =?us-ascii?Q?GPVBUiBbNF4zrgsB6QBwC8HYvG2B4fqOs8DskjCkSJuq0lu7v3nIBd7HynqL?=
 =?us-ascii?Q?/ReRf0VEmLhR5CC1Fik43RC/ipP4a23/CG4Dbt5KkMZ1lknBmnmw9y1HsTN6?=
 =?us-ascii?Q?4kRhBVb+2kpxHQQG0N8ls0vFeiwFnKoyZVxCbHvPpW5WaSqVIHLKLbshtPjj?=
 =?us-ascii?Q?VxnG0LkoWdosNRMfwq8M8lQLBVNVJDB7asa/iFOdi0+ZmeekOTbnyWrz3iUI?=
 =?us-ascii?Q?pVy6lt1g12DPTuFaXZewT5FxMmEj2VIEwdCCLduNpen5Osc9iuAjagnYFprm?=
 =?us-ascii?Q?FkSQPd/ws55yY0bvsYB74m5jvdMf+CbefHxxm7uKxBOjuBAfry19nMN7zbOj?=
 =?us-ascii?Q?sFk+L9s8iykEfacjfDrBdCZJ2s+sDzfbS49QNZznvUG5md2QCUq89wp2TiBN?=
 =?us-ascii?Q?ssjyV6iZqFWEspTneRAa9E93wwIYCmmZDcYQGMrBZQ4jciEf5CpxGUhYHTJn?=
 =?us-ascii?Q?EvrHM6tJ7daYQfTr4KX9UILNEgqxgqx5DIi1YRIH9PxvweSGONxksJ1H164r?=
 =?us-ascii?Q?z2wuJwZwVSR55URWJ0NtZo0lN3WhOVvt7/W92fNxE/XoJiP9tSabCgubUAHC?=
 =?us-ascii?Q?fe2et2jlA9U4CYT6/zP1PUL589Vh3s0x4S4iUg6wMUYsUrtXp7MoyEoaaoD4?=
 =?us-ascii?Q?aAVXdyM/YYbYwb8OXReNTEuzuAFNkOmhQr1oUSS3CsOQHt1CgsXeDiXPNeKi?=
 =?us-ascii?Q?OCFC56eOp1avrUiLUOyb0L37V274gyqh44KB1JxHZ4i3G3cdMjNg+InR05Dd?=
 =?us-ascii?Q?/vW7fVkEnYhD+tb5dVz4OLlsfUKGMG0Z/VZWTX3a16BHyGqcuAPzdYpme6wr?=
 =?us-ascii?Q?sPutckfdA1pjvM3IpgvQ6viNG4AlWGjDY5XlIFPbqKtYJBg1mFLMATEJxSxC?=
 =?us-ascii?Q?+ru304Wl0S6fxsIiULRJddyoCeM/YLqaqbXdGxYnmV0X8C8HwMoBQ1cX4BCD?=
 =?us-ascii?Q?Hg0chgv/VJs5OlBzfVpbywEuyAB2vkqXhxaYMAuvxnWly1v0UH9iX2GemwV7?=
 =?us-ascii?Q?ghh6mAh4QiOahyTnzkj6rd0OoyYS21Q63DLSpP6rlO3ywqC1PwOvEY7N9+xo?=
 =?us-ascii?Q?sIh3FqZH9WTGGjNiyGiluDWwP5rTbqK1QPd7MhSVKI+WsDEVn2/n0YrrgqFv?=
 =?us-ascii?Q?qmicIYOfAaqh2aFE4Yb8r/QpYSO+GDV/kgEBkpcqFMaUvvIiUNTSyuMWr2pg?=
 =?us-ascii?Q?PLDuMe56PRzJQ5bHm674zP/eq67IZK+hCKSlywa7LWKgYtmLAVu2vIW1J6W3?=
 =?us-ascii?Q?KKQlrbos8OZrNjGRyd4F19YtFVrwqrT97eVnp3HjVFPGTC9WxYlE7lREZ3Ih?=
 =?us-ascii?Q?G0ZtdwbCY3r1mhCdKu3m5zgCD+JwCu+HWT1/ck2T8ghl3kT3scCuC0rFTGTr?=
 =?us-ascii?Q?1gcfkWxl7VIRcT79OAe1jvG+Pu4PMwfYzpEMbBuKg1ov9+s9fO3mz/abHk95?=
X-MS-Exchange-AntiSpam-MessageData-1: cNeXcY0yE3kzqOY2rQwO7gdAD8kZOBhWQtk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03acdee1-d457-42f7-4f2d-08da48895400
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2869.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 13:26:28.6340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 02uis73BQ/cN7Yw2QYx6NIgV5BigAT4iCHjTqBA1WGhfavQc/Z6HFVcYuRq8vXLXBzRkoosly97yE0dNhaVUMB6hD9lVyOF7mEF04YCOAgM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1976
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-07_06:2022-06-07,2022-06-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=918
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206070055
X-Proofpoint-GUID: HZMiFalGreTTYxv5a7K4i2D55U4j9_hQ
X-Proofpoint-ORIG-GUID: HZMiFalGreTTYxv5a7K4i2D55U4j9_hQ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 06, 2022 at 03:57:47PM +0100, Stefan Hajnoczi wrote:
> Hi,
> During Elena Afanasova's Outreachy project we discussed whether
> ioregionfd should be a custom struct file_operations (anon inode) or a
> userspace-provided file (socketpair, UNIX domain socket, etc).
>

Hello Stefan,

> Back then it seemed more flexible and simpler to let userspace provide
> the file. It may be worth revisiting this decision in light of the
> recent io_uring IORING_OP_URING_CMD feature, which fits for this
> performance-critical interface.
>
And Paolo was asking about io_uring in the review of the initial
patches.

> IORING_OP_URING_CMD involves a new struct file_operations->uring_cmd()
> callback. It's a flexible userspace interface like ioctl(2) but designed
> to be asynchronous. ioregionfd can provide a uring_cmd() that reads a
> ioregionfd response from userspace and then writes the next ioregionfd
> request to userspace.
> 
> This single operation merges the request/response so only 1 syscall is
> necessary per KVM MMIO/PIO exit instead of a read() + write(). Bypassing
> the net/socket infrastructure is likely to help too.
> 
> It would be interesting to benchmark this and compare it against the
> existing userspace-provided file approach. Although it's not the same
> scenario, results for the Linux NVMe driver using ->uring_cmd() are
> promising:
> https://www.snia.org/educational-library/enabling-asynchronous-i-o-passthru-nvme-native-applications-2021
> 
Yes, looks interesting, we were thinking about adding this.

> The downside is it requires more code than general purpose I/O. In
> addition to ->uring_cmd(), it's also worth implementing struct
> file_operations read/write/poll so traditional file I/O syscalls work
> for simple applications that don't want to use io_uring.
> 
> It's possible to add ->uring_cmd() later but as a userspace developer I
> would prefer the ->uring_cmd() approach, so I'm not sure it's worth
> committing to the existing userspace-provided file approach?

Makes total sense. I am going to start working on this and will
come back with more questions.

Thank you!
Elena
> 
> Stefan


