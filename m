Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F8331699C
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 16:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbhBJPAB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 10:00:01 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60186 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbhBJO77 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 09:59:59 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11AEwZXB114447;
        Wed, 10 Feb 2021 14:58:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=oB2eoEiluld5d9aCEG1fhFVyi34FAPtv3ChPM3tG8LY=;
 b=rrAO1rIg+uEJlbQaBmBOzsVLrQcu8N4txLIs63ex0t/HUWRRcaxL/rvdpMW4Qw/8PuRn
 p/vvpHwTdEVOc7ry6FYLonTTS6fTog8ntUXqNaEN8LMGx9aBqxZXznCAc9dq3TNj9nYU
 JzYiBXWbH9aQDG5BxuwuLtSB+SHLc9uOqhDbuV7IZcGKWn4YBlX6BI1LYbyWL0ROs8hG
 0ckcdSAuv3fKx28Gq+06bjRZLk7F9stZi89cg0rUVyTrJ7vEcf5NdyB6RK91Otr4QCPn
 g1LuqS7kEBSG8KtHsli5boJjbpCkh1ygF4TT/G099jfuORduz5hdNunH8368auSw646Z gA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36hjhqupnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 14:58:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11AEt33W161467;
        Wed, 10 Feb 2021 14:58:46 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by userp3030.oracle.com with ESMTP id 36j51xnxfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 14:58:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C1HbVm7AyQIF5rn4mI8S3o8vX1/Yl0jlzywohWh65Gp7w+ZxncPI6CHrVI4ZROsMp4S3hS0ibKdTH7ZT5AFopGQIff+JwuhU1y1J+eAVDCRfxN1WlP8mzm4tZJpW/51gVDch70jLvkiOzoYO1/lXGlkTrWIJ+OJb88eWAcIoxj80Mb7+qKM5zVacvmy7z146oFx22bDYNolx3ATAESVc1UuqJx58t3BPiO2+wLg0nrJBkWrNxvKWyref2es7A3X1M7rpBz0j6d8FnWHzsPIK3HDLyxvYDY7eoTfqnJ2T0J5tQGmC5MZwC4yNdKWXvud9IAW1ViEf/TJAgESkve2CNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oB2eoEiluld5d9aCEG1fhFVyi34FAPtv3ChPM3tG8LY=;
 b=JJvL0R78gJD757woXkPf1ALy4rODWZjkbH+pNOoBU3ofvl/jmDdDbH5Tq1guK0BFiXoxVNEUjQUevj8P7fbVxxmocnFqCxesfZVfhNRIngtec+3Fg19z2g4MYEog94yassHyUdSnmTz+0mY8j5I+dSRqdAoPHm6HaC/KO6mE1946jOf8HmHTA7XxSYwjdyyaR7jCke3zHZZWKIKVCH4ddpy7jFFu8ItCNYLz5Np7d/o1AOBF4A7/HETM8uJp4X9Zh/CgJlbFAYVvWD7canhnMv2+Y36S/iICq5jW07WJI8htcv4hlHdLd7kh9TcdrF8XK8ukYlzlJf9yQBi9MMtPnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oB2eoEiluld5d9aCEG1fhFVyi34FAPtv3ChPM3tG8LY=;
 b=HAfKE3ODUj+52e4FmfK84gWb20mAOU/br2fadZQIsRS1JCN6r5u9gDBSgdrOmwUPzrs0NG7vCoEXojDOecKi/8Fzwe/cRDsoBaUj3wNRCKb6GgWo/+vBxq80UzFa2pz7JklADO+9+Ct1w6vaphvmxyfcS4/q4NlxSxXq5o8Z4mo=
Authentication-Results: 8bytes.org; dkim=none (message not signed)
 header.d=none;8bytes.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2999.namprd10.prod.outlook.com (2603:10b6:a03:85::27)
 by SJ0PR10MB4640.namprd10.prod.outlook.com (2603:10b6:a03:2af::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Wed, 10 Feb
 2021 14:58:44 +0000
Received: from BYAPR10MB2999.namprd10.prod.outlook.com
 ([fe80::e180:1ba2:d87:456]) by BYAPR10MB2999.namprd10.prod.outlook.com
 ([fe80::e180:1ba2:d87:456%4]) with mapi id 15.20.3846.027; Wed, 10 Feb 2021
 14:58:44 +0000
Date:   Wed, 10 Feb 2021 09:58:35 -0500
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Joerg Roedel <joro@8bytes.org>, daniel.kiper@oracle.com
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/7] x86/seves: Support 32-bit boot path and other updates
Message-ID: <20210210145835.GE358613@fedora>
References: <20210210102135.30667-1-joro@8bytes.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210102135.30667-1-joro@8bytes.org>
X-Originating-IP: [209.6.208.110]
X-ClientProxiedBy: BL1PR13CA0225.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::20) To BYAPR10MB2999.namprd10.prod.outlook.com
 (2603:10b6:a03:85::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fedora (209.6.208.110) by BL1PR13CA0225.namprd13.prod.outlook.com (2603:10b6:208:2bf::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.11 via Frontend Transport; Wed, 10 Feb 2021 14:58:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c4019b3-d276-4fde-bcd6-08d8cdd45ad5
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4640EBA5D7C6A297F93161B5898D9@SJ0PR10MB4640.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: boPC7ud8Pe76Vstx7ywP4l348Wh40B9RPCWCqHN6eFDhbJxqPI/kNtzz52uoZQ5O51xpz0ujVGdF1jf+un8VGh0Ruyq7egvjZdhEEwqe6pWiljgq/BaWchcZiZtf2mkX+nDvnusnw07xStdCuvJmajIabaFNF0hxsle0X1z+KnOC+IqACLAEogSN6YaAlh4Q/DqTMp872tKMsQD3PiiZMmAaxCFZNVewP/ehXCD4JS/qarfd7Q28n6OwmT339Wa1pMsomS7S9BKIDgf26qyUfsaJvUEJeOXj+OVjIkrJKqwLunZyh457mrwsHIRcz3SWpqClw9o1GQxMLbmU6iVLtT0IXecs7Rtfpbw22H8Q/cHJfvW2X8tFrjrsUZfWw1XEu+2NR8B9OMVmpTk79JuKNVY8P77plF3hPyMNvIjyZroF2qFg5UEHrghmqgAiOIIha+PJAjpfHqfRN9MGM67HxxrnUyK63o8TCRXlE7GO60dUDfuuozQyxgvQGKEhCEYDwWpURSrqelfKimrFNnAzIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2999.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(366004)(346002)(396003)(6636002)(54906003)(52116002)(6496006)(478600001)(4326008)(55016002)(316002)(8676002)(9686003)(5660300002)(956004)(7416002)(26005)(9576002)(1076003)(33656002)(86362001)(186003)(16526019)(6666004)(15650500001)(66946007)(33716001)(8936002)(83380400001)(66556008)(2906002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9uyEd0NZhDCW5w/pXPgXAV94fMAdzTPUcFACNHwoTwMjxhryKx1hZtV+pbgy?=
 =?us-ascii?Q?3gIqMVUua4y6aGVN+zKWgY9kpOlSDxMfXcs5svPTxbK7JRzzJ/aU1C5vQQad?=
 =?us-ascii?Q?4ppyPrSfqi1Gx0jloy8ZM/5yrdQFRVaSxAvkksobg/zmrqGHVfBPcFkuPmZW?=
 =?us-ascii?Q?uIe06uPeUeim+9LBFEns2qMfh1OeVEIrq+L0iadVKZCgmQ5vHr+WMDJ8IEhX?=
 =?us-ascii?Q?Y1YHe5ESa6KHiiQJXUsGA4QqG56qOCkMoSlg2ZEzaXxDT9ocaGfHznhQRxfP?=
 =?us-ascii?Q?HyYEkk76hLMIY4vYHya9Kt51pZ12FvfBvt/MleEgKYpuo11GolHk41P8oPJe?=
 =?us-ascii?Q?njzDWE9mqsxY95piu4IssHU2u7M8J96JmPALS20g2aRKmT3cRk6muE/Zj5rH?=
 =?us-ascii?Q?IA9I6B6ZBxJXnmXucjrK5IUD04awXkXN4/F9x+Yzhs155/Xk7jwqyo5WV6vT?=
 =?us-ascii?Q?Mm1UBazZWhj/dKW2JjcBFlxVVYPf7pJDYnqpRb7lpuvtO33OKSFu6A1NIHgm?=
 =?us-ascii?Q?Jl2qv9dU3npJGCRiEHmZOhdS3a9iLn8ukZF1H1uDuSb4w00LbNt7bDMXdmRw?=
 =?us-ascii?Q?Q2UO34Lrmc7Egt76JOUogVEPgM+nBE+IVcGQSFj9Kk3MlyUlmRH5dkzkIrhQ?=
 =?us-ascii?Q?WMNSn0a9J5IEsEpYPga1hTa9JURYYXebSePQYr3mSsH1snmjMsMptEceiMyi?=
 =?us-ascii?Q?T76KjfiGOcLBsyukw4PRA4Qv7clboEp70iMAcDGodl4sP2ZGfn4QKABZlCWm?=
 =?us-ascii?Q?+YC9exT0ftgPsmcTj7EOVrA6qYvn62AqBZW8ttEmpllPwpxAHifG7pdysD8x?=
 =?us-ascii?Q?asQqNEGvF92OINAEp80BBqLGTWrXFU46OXXLN6OW/l9XxqITysdLBkdQhm9l?=
 =?us-ascii?Q?ZlD138M0ciBdsD4bUvTonUw//D1urc/KLC6pp2cvo0NNasfvhmOG39rFRmiq?=
 =?us-ascii?Q?VSsZLjTT9xMHa3El3ho11+nInFGyNK6VrdWJy/9t0XpE5IdUeaY9ee03v8if?=
 =?us-ascii?Q?FgLlzyj5rKd/1kLjIANwWCYmyZYCpZFTm/pyae0hqyZm6iYegHgvcgGyPiI7?=
 =?us-ascii?Q?tU6cTkmvCxcwkixhb8aRJ4Zjvp7g33m4IkiBTts4muy6gDRbqifLQkucJbrA?=
 =?us-ascii?Q?6H2qzsgL8x/656rjyzBTymSZJiVsKtGKuQAO7jp/GS0tUp4yFS2r9H8Fa3K4?=
 =?us-ascii?Q?FZd/7nWxqoyj7DjvNbEBg3z6yq6ZlWcKoW0BRqkVgz6EBT6xwRBlTs3E4i2P?=
 =?us-ascii?Q?qbmzz4K73W5lTY/LNFZ3jRqksN9CZ/EQqU9gBDe59roolIHFMNOl5T1LLqfc?=
 =?us-ascii?Q?3yZcx32CMJgJG0yTCZ1xkthH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c4019b3-d276-4fde-bcd6-08d8cdd45ad5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2999.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 14:58:43.8528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FFCgMEYT1QfSRkEIvm9s4wUuaOBKSf9pDJtnTAYk309wQT1cPtRPlM2nN05TKimbEC3pJTd4wdmwlmZBK6lomA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4640
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100143
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1011 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100144
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021 at 11:21:28AM +0100, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Hi,
> 
> these patches add support for the 32-bit boot in the decompressor
> code. This is needed to boot an SEV-ES guest on some firmware and grub
> versions. The patches also add the necessary CPUID sanity checks and a

Could you expand a bit please?

What GRUB versions are we talking about (CC-ing Daniel Kiper, who owns
GRUB).

By 'some firmware' we talking SeaBIOS?

> 32-bit version of the C-bit check.
> 
> Other updates included here:
> 
> 	1. Add code to shut down exception handling in the
> 	   decompressor code before jumping to the real kernel.
> 	   Once in the real kernel it is not safe anymore to jump
> 	   back to the decompressor code via exceptions.
> 
> 	2. Replace open-coded hlt loops with proper calls to
> 	   sev_es_terminate().
> 
> Please review.
> 
> Thanks,
> 
> 	Joerg
> 
> Joerg Roedel (7):
>   x86/boot/compressed/64: Cleanup exception handling before booting
>     kernel
>   x86/boot/compressed/64: Reload CS in startup_32
>   x86/boot/compressed/64: Setup IDT in startup_32 boot path
>   x86/boot/compressed/64: Add 32-bit boot #VC handler
>   x86/boot/compressed/64: Add CPUID sanity check to 32-bit boot-path
>   x86/boot/compressed/64: Check SEV encryption in 32-bit boot-path
>   x86/sev-es: Replace open-coded hlt-loops with sev_es_terminate()
> 
>  arch/x86/boot/compressed/head_64.S     | 168 ++++++++++++++++++++++++-
>  arch/x86/boot/compressed/idt_64.c      |  14 +++
>  arch/x86/boot/compressed/mem_encrypt.S | 114 ++++++++++++++++-
>  arch/x86/boot/compressed/misc.c        |   7 +-
>  arch/x86/boot/compressed/misc.h        |   6 +
>  arch/x86/boot/compressed/sev-es.c      |  12 +-
>  arch/x86/kernel/sev-es-shared.c        |  10 +-
>  7 files changed, 307 insertions(+), 24 deletions(-)
> 
> -- 
> 2.30.0
> 
