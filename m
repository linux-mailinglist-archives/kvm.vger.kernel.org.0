Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA72308BED
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 18:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbhA2Rt2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 12:49:28 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48340 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbhA2RrS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 12:47:18 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10THifS7122477;
        Fri, 29 Jan 2021 17:46:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=wOSVOvlGWiTzPlsf5TSqedDTaW0X5Ehny0iUHqnV+ew=;
 b=ygrxjPJPLBc6QqOn3evBBmjuyrxGHZyrZeg/08h3/7b7m3PP1Pu+MAO7cl7TNHOIrVtF
 XOXVFetqb/VZ1di8w18joqgVfs3DDZ1VpJutqXVRX5A4ZXradlXJIHhOzTLGFcSrQABA
 TAspsgA+fCqduiYCYCtMGqQXoxsLf3FHpaxgbQHOrNYfHWbK+Ca9DcI5On+wn7smm+2Y
 e+g1iOc3XNmqXx1/hSfuWli3WrXIY4a9rReit0qqKhJvUUy9IPyBhqvNEz8cnDk0HF96
 lPAxDOMAWerPuJfhcPtkqS/I6VqI4qLiVks2HIFZ/MQWBeLrKHb7u5y/SWUhyiDpWPZf Cw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 368b7rajd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:46:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10THii9S184942;
        Fri, 29 Jan 2021 17:46:07 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by aserp3020.oracle.com with ESMTP id 36ceug6n37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:46:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dVaHOfDwOC4gDfFTPyKdTmFuG8L9xlEBKoiz7YTFEWB14gTq8wI/I7vOj/P2hLWdgTUjWRzpIQO23WzMUYJ6H+2fvAqXQlOP8sy0WRNz5hms/31SsiQJmqZ5Wl6QvSd0bS3K3QHrdj8NyiSpVuK5UPFM3f9jwqFVwXY5tZtuwUnFd/9I5bfrPloan17J9Sg+tHSaJqkk/3r5H4IVZAmnsF14yt6h2VpnSxpsLfQ0XsYBg/bEJyQz4W/xU505S6AHPq0IBkKBA1waFCo8lkYAp/b/OC8IfyEeWBegmR7lBvo3zHX/+TMTx5jXKs05nSOnHh9v6/3oameFCPDKKJbVWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wOSVOvlGWiTzPlsf5TSqedDTaW0X5Ehny0iUHqnV+ew=;
 b=QgG0LiddJ93Y+4DrGSBZAYqjZtkQZyvE/DivuWZUPFKT0xeE93r1hlkRkDqalITB8sSERzd71DHhMjwaXxnNx7nUCLoLfOmINOD8p69aEV87TIcVSD1uDFMWdcZuJLQkMv0LLlihG2gPWPKptpCMpbHRVS/kPZCUAyD64X7xmZ0hEE5MMiEF3jhBviHZwUbu8v/sg1sesMPuowp0CKwqp2UKK+RHUlTCNN9CgdjyJzpTgLpQu7t6Vd1NoAXJvIwOi/Dacx9NF+vAF8P1NhhzCWpjghr37fQXRnfdiE0OQwcSpP3drJ+msGe/YT04RYuyBKHDYwDjbB+KoV2czAIcmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wOSVOvlGWiTzPlsf5TSqedDTaW0X5Ehny0iUHqnV+ew=;
 b=XFnNiBXT4HlvUve3OSkMVYvFGN6j78pcI9Q8dzx9Vg3L5iZOrrzzMw6ccZy20jw0MS88ep3lwq3qO6QJmIYwW/aAzMV9Dhe/QiVJyny93kPAj6ENkwqrJrh5RbDT9bvGpB6zPEKQGfQhiepVjsp8J6U8pbhOA7UODgEKCiY7VRU=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB2044.namprd10.prod.outlook.com (2603:10b6:3:110::17)
 by DM6PR10MB3018.namprd10.prod.outlook.com (2603:10b6:5:6d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 17:46:05 +0000
Received: from DM5PR10MB2044.namprd10.prod.outlook.com
 ([fe80::3c1b:996a:6c0f:5bbe]) by DM5PR10MB2044.namprd10.prod.outlook.com
 ([fe80::3c1b:996a:6c0f:5bbe%6]) with mapi id 15.20.3805.019; Fri, 29 Jan 2021
 17:46:05 +0000
Date:   Fri, 29 Jan 2021 11:46:01 -0600
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
Subject: Re: [PATCH v6 5/6] kvm/i386: Use a per-VM check for SMM capability
Message-ID: <20210129174601.GE231819@dt>
References: <cover.1611682609.git.thomas.lendacky@amd.com>
 <f851903809e9d4e6a22d5dfd738dac8da991e28d.1611682609.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f851903809e9d4e6a22d5dfd738dac8da991e28d.1611682609.git.thomas.lendacky@amd.com>
X-Originating-IP: [209.17.40.36]
X-ClientProxiedBy: CH2PR07CA0056.namprd07.prod.outlook.com
 (2603:10b6:610:5b::30) To DM5PR10MB2044.namprd10.prod.outlook.com
 (2603:10b6:3:110::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dt (209.17.40.36) by CH2PR07CA0056.namprd07.prod.outlook.com (2603:10b6:610:5b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Fri, 29 Jan 2021 17:46:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02818058-f558-4ef9-6ded-08d8c47dc046
X-MS-TrafficTypeDiagnostic: DM6PR10MB3018:
X-Microsoft-Antispam-PRVS: <DM6PR10MB3018E7A9A74A1533174A8640E6B99@DM6PR10MB3018.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: My/W3fo9fuZeV0E+uYl4E+Cfuzipn6T0Un/Dx3OgiEJ7GkYU7UPULTSY+21tBWZ26SEKavRawMq09NcKVk4hchIyLvNdItGpQkM7BycWEg+R3epwe1+gC0WCi4uXp71XXCT0cs1js9dhuAs5UOLIFZFbxud3ZqR6WO77goLxgioW9XPCVAAr7f+RSYYPDn8I7gws+fEmu4uH8JteK6EnihtVwgecc4ZuRwfSXdyuk384gztKj7JHyVM3diFPTMWJOdNGWjklrnjcsKouerFzhl1/0+6Ko3VCstZkaPpEtnLiMLKfOOPGiP7q8IDlIvyvgsaKlnxLXJLdGke2xPhiRGhtxm0s4NVI+Y/l1R9dkjW9aQ6LvWhhUrGNbI/CLdUTCllrcxFZw8XBCqkWFJOUhNvt8jN0016aoy3AZfync0pdXiZfVELNMsZ6JdxkWFXnpUrFm4RehmUwrQU6HXZR6DkN0Wa0THizW04Mni80ASpcvoaaGQHJdr5hb3AOv6xZ/k8tpR31Fxzv0acUN8V6uQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB2044.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(346002)(136003)(376002)(33656002)(55016002)(186003)(9576002)(16526019)(7416002)(8936002)(86362001)(9686003)(2906002)(1076003)(54906003)(6916009)(6496006)(4326008)(5660300002)(52116002)(66946007)(44832011)(66556008)(956004)(53546011)(26005)(8676002)(478600001)(33716001)(83380400001)(316002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?r1/xXE67ObBOL93kClCe7GkNR0jN1ETWDlI72pb9KB52glpz+wRZ9C2lazLF?=
 =?us-ascii?Q?xjusajcdW0eBQRlesMgr4k2q9pQR+4JviO11/a9+gHUmzBmxfM+z+cAmPbwx?=
 =?us-ascii?Q?aN66+2S4UG5f9e0Yf0vXqgpHFHACO8XAGv4yEd0SFbI+YfOer7VsjI0RnSsu?=
 =?us-ascii?Q?31xeFVd6Mc6lU0G/VhZRFmbpp0sRUv1f0E5Wl2CRZScsdo5EOUEosqPwKX8l?=
 =?us-ascii?Q?vb+Y/JvEC2ST8DntUVXzmWsIU+0KGnY1WytqC28ppFneAFebYs0Cw0r3s+u6?=
 =?us-ascii?Q?dob9R26J4RXiNxupZUU6+Ei6KEQj8Q2HYNwF+HFEdP39SKkzEwjLpl5g4dCz?=
 =?us-ascii?Q?lXCggCraq9kZ21+i7N/I1GjoqN+j1AiM0cGiPLUKMrNRne/K99UTd4uaJQDq?=
 =?us-ascii?Q?jOCcueH3JYXzRSAnS/B1lzTtghJhYQ8VYBNPme+e6nefWyqJH8obdgIhWKHN?=
 =?us-ascii?Q?xMaXo9jB9JwBnysS+zquQWutVxbXHUsUERe5zxk6c1znhPcr7r8OmTPxG9mz?=
 =?us-ascii?Q?Vc98ze0BGlS3INlCvXo+u1W5I4Te4z8m8XMerxunhiO7HlddPLN8xYBoN11S?=
 =?us-ascii?Q?GRNviBiNVv2Mp3omGLiaoGvgPiN2Ek/ty0VqGnUqujYOWEmBAkI1HMmiJt3y?=
 =?us-ascii?Q?jQuD+/WCjAqodiZKljR8u1jmU6dgrc6rCgmZEVqz/WwA0Lwb5ZVML1J0KMHB?=
 =?us-ascii?Q?U9i7RLF1/DFkT+guiHxA/YPu3aUON9kwia7b8LZVbBkJNCSu/DvfP8nZEGRP?=
 =?us-ascii?Q?qPqeY+t9FsOZnvSgBCDsaGw9s541uKLtRTfNSuyoyyNwOG9OakwsJV95baKw?=
 =?us-ascii?Q?juNyzghwapevClswLnPqGlf9dPqeLb8F6sVisenVi6966w4w9A+KPT4hz6bF?=
 =?us-ascii?Q?NyqlHUD24BVU6jTst66Bh0B1jVEYE3qVuHBwUyvPUzJ64pyFlUFrQ4/6DRwN?=
 =?us-ascii?Q?n4NRuIjBQZdqHrKtWGpclAO4+0fvro1bHamhGUVWc/GNLnO1cHs6bqm7V7Fa?=
 =?us-ascii?Q?YD5Dl0pOTvsy+xvyQaCEgnJPBZL3v7F2W5SZl5Y3pHUhkAz5zwBt4rTXjvHB?=
 =?us-ascii?Q?tEkqPFI+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02818058-f558-4ef9-6ded-08d8c47dc046
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB2044.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 17:46:05.0671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BNSq29mSPfRE9sSGvNlY6lGg7lIrJFezilGZVz4GdM1GOLk/w5rkzV/8dEZ2IO2/2ijtoK5YBch1V18EyrSvjTiWuqlq90/ltce5rNJXxWY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3018
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101290087
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-01-26 11:36:48 -0600, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> SMM is not currently supported for an SEV-ES guest by KVM. Change the SMM
> capability check from a KVM-wide check to a per-VM check in order to have
> a finer-grained SMM capability check.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Richard Henderson <richard.henderson@linaro.org>
> Cc: Eduardo Habkost <ehabkost@redhat.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>

> ---
>  target/i386/kvm/kvm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index bb6bfc19de..37fca43cd9 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -135,7 +135,7 @@ int kvm_has_pit_state2(void)
>  
>  bool kvm_has_smm(void)
>  {
> -    return kvm_check_extension(kvm_state, KVM_CAP_X86_SMM);
> +    return kvm_vm_check_extension(kvm_state, KVM_CAP_X86_SMM);
>  }
>  
>  bool kvm_has_adjust_clock_stable(void)
> -- 
> 2.30.0
> 
