Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55EFB308BF1
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 18:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbhA2Rtn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 12:49:43 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48930 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbhA2Rrt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 12:47:49 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10THi3D3122185;
        Fri, 29 Jan 2021 17:46:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=SUJ6y01c6Ok/vuc/vPauoEjA0tIxs7jFTJ1d3FYtZV4=;
 b=fHtQxXGs+cvEWSyfEYAlzUi7WY3YBMQgKXKYSxPX7esmCNh742OW421x2K2yvqjm/bQR
 K6U6vLFaPrZLmD6U9OTVpB8JSH+hERRZkUp9XDOTi4eoyNBWQW8qcJJykz7XlvXUzwb3
 BsykZXF08HIOrF5WS6V+o7lhf9l4AQxt2nZFqNFMoyk7jTio8FZuNFNcV0/0sFYZe+Q8
 ut6/wq4X9CWrGe53DplUQPLSK4u7mJLUvzIid2IA6Dqw60qmxIj3JjFT6YDeZ/OZaP/F
 YpmlFJFUqdlqXjXC7SjmokxT0HV5yAHxU0koyI22AKnm+BD8g4zzozaVKFMqLnD2K1v7 gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 368b7rajfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:46:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10THkIr6149230;
        Fri, 29 Jan 2021 17:46:50 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by userp3030.oracle.com with ESMTP id 368wr280pc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:46:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aGj9h9sjoe+6+ViXtXFcOkgSWcauOOvsCmRlZ3qW2YMfQaHjidY+nzmBKZww/d8IlTly2+gSLMn2n0kVuvA1Gpi/H7iFVP1kkE8MoWHunNdNXFYa1bMz6TBaetkKLbAyV1uJ8r7/B3XjbB92SPsp6byHJVAraCN4+bIpn2T/W/NFlxblUHUKg/otqr6NLtM0ROIbfFyh40fZgKK2Q1/ipgMrd9ceh7FGt37E/AlT8V21ELxPVLPv4ysVKEuy3i8ihOs8T7yBPPg59ivKya5koC75QeG5P2d34w5TwysFyqvl/THtXThiH8IFseXg/6nENMwElqzYvayEMmgvP9+sDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUJ6y01c6Ok/vuc/vPauoEjA0tIxs7jFTJ1d3FYtZV4=;
 b=jKZP3fzrJsYqZ5JKb9IILcREEQ9D/tDCh00zQ0Mmotnw3qxEV4frqJ31AgZzLsWlcr62jz90I8bxWgA8awg1GkKTseVif0oRgyL4atY9gfn/np7FabhrHBaYrj0uZB4wAWwczLt815UzF9cu9sGuue7ZgnSLcYYJ2BVwuD7eq8Xlbu3+WwrSB+16wbH4l9UzzZiANvzUpSvAgJsnE2dysjgPiTpoALg9Jsl66NZwrKyzrLsAguiuhAX1NKPmEr+EYR89VevxEflS1XpFo1jZJiNTTeJidJPoybZdvwwh85oNqMz9rQa/vPp4BREhgLi5WykNISMsx3KF6ddxZX6xOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUJ6y01c6Ok/vuc/vPauoEjA0tIxs7jFTJ1d3FYtZV4=;
 b=kOPp0puN6AtawISIsP5fHkcoAweVSIHTo7wfxIACccL7vbiRkP9JC/wERL4AUZaWERPFmJg8NoXGPQZvm7hwhjeFkvt6BdMV/AmFvSid2rI5DFYb4zcFQfi5rrZhgr360naZ4vaZ0CLlNbMnTb1MKe/6GFhuet8mySOfZc+gb5Q=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB2044.namprd10.prod.outlook.com (2603:10b6:3:110::17)
 by DM6PR10MB3897.namprd10.prod.outlook.com (2603:10b6:5:1fd::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 17:46:47 +0000
Received: from DM5PR10MB2044.namprd10.prod.outlook.com
 ([fe80::3c1b:996a:6c0f:5bbe]) by DM5PR10MB2044.namprd10.prod.outlook.com
 ([fe80::3c1b:996a:6c0f:5bbe%6]) with mapi id 15.20.3805.019; Fri, 29 Jan 2021
 17:46:47 +0000
Date:   Fri, 29 Jan 2021 11:46:42 -0600
From:   Venu Busireddy <venu.busireddy@oracle.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH v6 6/6] sev/i386: Enable an SEV-ES guest based on SEV
 policy
Message-ID: <20210129174642.GF231819@dt>
References: <cover.1611682609.git.thomas.lendacky@amd.com>
 <c69f81c6029f31fc4c52a9f35f1bd704362476a5.1611682609.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c69f81c6029f31fc4c52a9f35f1bd704362476a5.1611682609.git.thomas.lendacky@amd.com>
X-Originating-IP: [209.17.40.36]
X-ClientProxiedBy: CH0PR04CA0066.namprd04.prod.outlook.com
 (2603:10b6:610:74::11) To DM5PR10MB2044.namprd10.prod.outlook.com
 (2603:10b6:3:110::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dt (209.17.40.36) by CH0PR04CA0066.namprd04.prod.outlook.com (2603:10b6:610:74::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Fri, 29 Jan 2021 17:46:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ddaa2468-290b-49b1-fe12-08d8c47dd99d
X-MS-TrafficTypeDiagnostic: DM6PR10MB3897:
X-Microsoft-Antispam-PRVS: <DM6PR10MB38979242351181A8FE0B596FE6B99@DM6PR10MB3897.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GczcCJvouEqyc9DPkIEK5t3cOdEKyZ1FwAS9Sb2Mc1vCdmqdxfelIo9HjXFA3d1Pis7NGL06GpE387uZHHc+nUmeWk/T9Z52Da04DH4anxAjhRBDIDsThjAxR0wcmy/IggPDqUsw0XyhXWPRVSY16VaMy5SkACAwU9/NjKXgsa189acHQpAQV/qoPoKF4GQ+ekOmmrhk8mLUM7zMb3ZwLfFLJV/lpDjWzPXy5rHYESnMpGLPmkVw6Z/ZZYS8MkrwhweQNcuKtLNhTt8+ChSj5ULFAAFuiqLkRc5uZbAUC+jfKoiAlpRfONiolJh31D872VmL4LM33G5V02kzEpnZHQeHJSRMOjgaAh/BvgwJ0hmR6NWxbRK0ntTkb/IwpgXEzFWoE12F7zklNDN2e3OQxvDv6RsNjYU9UT170VYjXMQfmorNQlcELaA/IexZ1ZZU6b54vAZyrm6cFYH0wNq13VPjxnfZ1KfQxKJecZ1yIPTcyOw+JgTIKnUAldHQjzowyhKCeHMMGlIKVLEwgYhMNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB2044.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(346002)(396003)(376002)(316002)(6916009)(956004)(9686003)(6666004)(66946007)(44832011)(66556008)(86362001)(5660300002)(66476007)(8936002)(54906003)(33716001)(53546011)(2906002)(1076003)(16526019)(186003)(7416002)(4326008)(83380400001)(33656002)(55016002)(8676002)(9576002)(6496006)(52116002)(26005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XWTcIpje3nyb4eB1DB4Zmu2dNzxSX6j8yu0Ae0xhX72dFsqcsr4WJE7uh6GL?=
 =?us-ascii?Q?h+5+ggxhasRp7x7IqfN1Dd9OeG7ziQ/QCEpUYnhe4FazMUdPnQoZJ5Xtbv50?=
 =?us-ascii?Q?StV2UL5w8/ckCobvdvdEPurvIhmiIuBwNSfM76NMoVm29JqYz+kos+PpvtCo?=
 =?us-ascii?Q?0/9YoTLs1BKItqKqWJfni/3iZ43QkCP+5ym9ZcNICf4j0VCB2l7lX3XE7Fjl?=
 =?us-ascii?Q?89XnSZviuJ/rByTeFylpWZJcrUKOWIFQqbNlv9S+9BkEfYM2yZxANIP3yQ5T?=
 =?us-ascii?Q?k5vsXN+kogKCr/KOv8AN5CjlVcUUc6OYe1Jud43uLamidHloiO4m0zrPUPsW?=
 =?us-ascii?Q?rwE4nznSTSPzOo0Z/Ui5e/RqvFxVVRSyi/4WQWwQ8XMPmVooPBsbBU92Uph/?=
 =?us-ascii?Q?VqUEb4j3szz3rYd+0EH6R6jDiCWrsQedTnObnN11OSgxZFBzRXmj9N21+KEG?=
 =?us-ascii?Q?u1LONeKIDZO/7X+npe06/ZBGyi/NduLSLcphqRswiAKuRqb6pJ6Qo/V4n9N9?=
 =?us-ascii?Q?AWJtUHMzXHqvqraYuR9Gb80kq6/tHdZFp0zBsd0KXwtXEUGZNze/IE9+AI7b?=
 =?us-ascii?Q?vIxQcyYYERbGZERZxx9NUatK/ZhmdWpxnc1HiOC/q7ran4gqHvfT5Gm7YiqV?=
 =?us-ascii?Q?QxoVlwA/Hgv0EzWbWp4ze1q1AAVZZy+n/RC3FzVfE3675pYVnbmk8mDZZkiJ?=
 =?us-ascii?Q?HbC9kcd5BiaCN9Hg/YqH/jcEHt15eyI6wJXKbtXGIx5xmBkuznb9mTX0qjL4?=
 =?us-ascii?Q?KkZlXkMf+ZXl/FNG+T+QltDs4OSnFSzJue13vBc+EC4OPMgoMPUuza86YCW6?=
 =?us-ascii?Q?aPnhZrNRkaxgLC374mzcilILNlgErwcgnn9o7EWgkhemENEeBA6NYFQ6N3GB?=
 =?us-ascii?Q?u8lCLjBcuZlhLQMQt3a1+N/T1syWnWAeaboDxCoz6MJBJGliXsvuqPY7tK4Z?=
 =?us-ascii?Q?vOgYLSHUnqcZHCAAAG4LL3ewu4PRNn5dEld1TxNYhxpd2N12EnaUnArPkqFr?=
 =?us-ascii?Q?M8fqSx48jQcbtJwJAYp+OsgVISxbSEr2w4tOOrAkaK0b/r4jZDoeLEiaGEFU?=
 =?us-ascii?Q?PuplAyon?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddaa2468-290b-49b1-fe12-08d8c47dd99d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB2044.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 17:46:47.6130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HswHFtTbFT6W2g3ZmKLRWkfb8SKGYVfs574b28ZHhRf69iVdpoZBGzpl/Fz6QdM8Ma7YBEearwEyIRDFquKOOeztDxf58GgLUD0wd7vAuNI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3897
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290087
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-01-26 11:36:49 -0600, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Update the sev_es_enabled() function return value to be based on the SEV
> policy that has been specified. SEV-ES is enabled if SEV is enabled and
> the SEV-ES policy bit is set in the policy object.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Richard Henderson <richard.henderson@linaro.org>
> Cc: Eduardo Habkost <ehabkost@redhat.com>
> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>

> ---
>  target/i386/sev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index badc141554..62ecc28cf6 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -371,7 +371,7 @@ sev_enabled(void)
>  bool
>  sev_es_enabled(void)
>  {
> -    return false;
> +    return sev_enabled() && (sev_guest->policy & SEV_POLICY_ES);
>  }
>  
>  uint64_t
> -- 
> 2.30.0
> 
