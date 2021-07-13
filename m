Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C503C67E2
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 03:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233870AbhGMBNA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 21:13:00 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:5050 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233856AbhGMBM7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Jul 2021 21:12:59 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16D15qcT015402;
        Tue, 13 Jul 2021 01:08:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=3B6cHqYTowbOTbSTyzn2axoZNIZlNWJOMyUnuxwsz6I=;
 b=FhDLiUE/zhUzhe8Z9s0QpXpRSQpJf6OWXwSK0D9s3ChKbYlBciG7FgGXc3VIokBQ2b3Q
 KeNPStadZf5sn/AXNcjOxuKW3ZYhY19UtHExLKxOhRIqjkd6KkIJeeoo4wLqvnHjrCsh
 4xcOsGr3PYHTnnZWnYsfp0FR4KGAk9E30I9vAqr1HKcqmT2TwRXz8unM3h59fJFJvYfn
 jK6hPcorvpm2pnc0Plcuy3IMP04Dkj0vlW9wrqmerAxh0b8ZQstX4vuqWPXu9IUBFJPh
 c9449Vq8QwWLciETOdsvFihn/yc6/mM01OQRkysHaSEp2QPx7YAQMVH52frAEmZTHK8I /g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rpd8sd0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 01:08:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16D14whw035107;
        Tue, 13 Jul 2021 01:08:45 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3020.oracle.com with ESMTP id 39qnavyj7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 01:08:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nswK2OeKCa4FHtz5K+jOnGHn4VpxmcR41NaPm+CKP7z8V9EOR5eJ65Ho+P2OwRL4UkRVzxjG3sSjMvK3yN1NXe3wSUoAZdJpt6nPbIJqM2jEqzARwPbDNZAgQfL/Yk/2+rNHrCGslrJ7wQk/ZrWllCkcIOPvfZ3b6cttzL37/n33zkg9VVt57SWEeW8+yvGJnHn+G2pFTRh6GIPPzj4eQUxVvDhKIi6HyCvJ69TWU/UztLofjTeLbOxxAhG9ow/6CsB1plLrprM8Va69SzmUgkP+EYtSi4cjcZmkkjBqWIWIa6aDsdjkdpf1gsDJYFp+RxPa4tlGBoIwYSnYGr8FUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3B6cHqYTowbOTbSTyzn2axoZNIZlNWJOMyUnuxwsz6I=;
 b=ncq211w++Ps3JSWtOt603EoJLGb2lshE5Y+GxoDmsZEL0R12ojaH+qyNIHx45ksJL0qgRtgt+iknkh1cqQO5FoRiOVJVwsrUoODESDZUyr2HQKO1b8VkQcSOVShxEVcyxmfGHMfDtpRLApdPv01dJtvcNUNw2jdWUIXLMYt9yVDy1Lu0zNGQOgxJkb7sgnVm/OWNiGNGZ35FUBQuPJe1AkjZyXFQ9KRX2mIHyiWrSHSpeR2A46ZxInBb7veCIg1Q0Og1PNCJ769UvvvplPAvk1ZDEe8ZnAjwOrIBWb/TSKTt+DE6BHIezbgpYrkXl8MaIpzNo+ymP9ZVCzoXCYeiqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3B6cHqYTowbOTbSTyzn2axoZNIZlNWJOMyUnuxwsz6I=;
 b=JuOcz6nshmg/vP6oFoQDTBX4lLhwYugvvJDpyKJpj9jBL984cpgU0EzZa6yvLnGHk2d/dFDHSUB+aCAV+vuO7KPDkyXp0UXfwzCK/qFAfZZGFgp74kvKvZbMeyQJFKmY9mieC4+cRfwKS5fBtazCndbAFtonRxDe4/eugtIvNbM=
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL0PR10MB2931.namprd10.prod.outlook.com (2603:10b6:208:73::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.26; Tue, 13 Jul
 2021 01:08:40 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 01:08:40 +0000
Subject: Re: [syzbot] general protection fault in try_grab_compound_head
To:     Sean Christopherson <seanjc@google.com>,
        Mike Kravetz <mike.kravetz@oracle.com>
Cc:     syzbot <syzbot+a3fcd59df1b372066f5a@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, bp@alien8.de, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mark.rutland@arm.com, masahiroy@kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rostedt@goodmis.org,
        sedat.dilek@gmail.com, syzkaller-bugs@googlegroups.com,
        vitor@massaru.org, vkuznets@redhat.com, wanpengli@tencent.com,
        will@kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
References: <0000000000009e89e205c63dda94@google.com>
 <87fswpot3i.ffs@nanos.tec.linutronix.de> <YOy0HAnhsXJ4W210@google.com>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <9afe2365-4448-51b1-f711-a81ec79be817@oracle.com>
Date:   Tue, 13 Jul 2021 02:08:31 +0100
In-Reply-To: <YOy0HAnhsXJ4W210@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0462.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::18) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO2P265CA0462.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a2::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Tue, 13 Jul 2021 01:08:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0b5737c-9274-436b-b6f8-08d9459ac044
X-MS-TrafficTypeDiagnostic: BL0PR10MB2931:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR10MB293158F38A1D72957E39DDBABB149@BL0PR10MB2931.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JLv67sk41yLeLI3XRh+45H9RuOtc4IryZ9++/IKOEcweJMtKvJ5AL7rMroj0h1sZkozCT7nJenLS3L9f/ON04GsCoSkgL+bVUvNs9rUANDfCehbMZp8DK70C9GifXsHbnEzr6ftU+A3qxTeJYeTerSvHDNLpVsg09TeUpOh3TddJznFco3Vwt49xr/him8dXnjCCgFmOAdnLigQRxeWft8CR2hNZo0NTNSgy+HTMPauOb/MN2SYs8HKvfHlrcjfhgSopKsP4iCtGQmhB3wFHwAwlw5We5+8VKqQ1PlUsjy5lFR0uTwUarxJKOoV84KiCyY6cWlDh1VRGq2R0s0cLJXnzaGSOz53YKOttSwff7hVMsDUIr9eh4Rj3PHyfsK8nVJcIRGvrCn9qNkJpCJZQhOAzZlJsuVNAJ/76zFDILOd3Goy1JViHCbqAB+B5FBwi+eQm29TIGBOgccbEt/gWUPwwJdB8syOknbNlUV62m4znXesnExxf12pT/xlxZNZBeFRGx3jLmhU7UV92YtJVeCvMi0qkljnptiv7CUgqXpHQoCUsu0K3Mu6f0tdhGsmfMt3Vok/cS8lrSD4fvqdFPwF5UEKR4B1esxnpFB75Nms91vKVsjQlJnGu08x6V7LoGSFw7S3CTlFVR1VPl1sU6PEWa6uAbwItw6LyuqXNwykYom48FK30EBgbZcfkAPBFbB7p5XKx/tVGAgLHBzQnhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(366004)(39860400002)(396003)(316002)(956004)(5660300002)(16576012)(2616005)(8936002)(2906002)(7416002)(4326008)(26005)(186003)(8676002)(31686004)(86362001)(31696002)(36756003)(478600001)(6486002)(6636002)(66476007)(83380400001)(66556008)(53546011)(110136005)(66946007)(54906003)(6666004)(38100700002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UzlIL25wSml1WFJZQnRJTlBjMkVYakxNMkUxRENPOEN6UjVRb05ZdUwvM01M?=
 =?utf-8?B?ckhaUEd2RWlJNGo4U1NBMisyVmxiVmdoL0JJdmkvUXlHZzBjWEdDV0dScnk1?=
 =?utf-8?B?cVlrZFVJQndtakYxNXlIVlU4MWswS3lad2toZ0JscjJyK05jWmNTRmhpQmZw?=
 =?utf-8?B?OEhGSzdWNGE4YitIRHV1UnFTUG44MXpKOW5pMVR3RjBRc1Z3eTBCSGNOWndr?=
 =?utf-8?B?cGZBRzREZzRhOTJyYmhsamcrK1o2blNnWCtwcmxERTRHUER1L1crRVNSQ1NG?=
 =?utf-8?B?TnRZS2V6ZWFuWU1qaWlObkMxQlFQSVJpR2pPR2FCOElzNlZWa3E1RkV4dEFG?=
 =?utf-8?B?M3hJOG9wOUJVSVVaTmY5ZGlqUFNHQXhva2Q1M3BTaVRRd2NxeUhxS3JkdU04?=
 =?utf-8?B?RUVjaFlZaFI5RjhJK0w4bHJUeTBkV09oaHBQbDQ4c0JtOEVGRG9JTlZCR3l6?=
 =?utf-8?B?dFNweEt0TXQ4bDBGVzhLcE5Da0p2K2o4SFA5RnRuN2U2MDJEZEQzemRmUjRN?=
 =?utf-8?B?eWlEeEdHMko1TDN6bXV0djdXZFJ6NVdOdHB6SlJHSzRUN2YwV2F2MVJ3REd6?=
 =?utf-8?B?M3YrQ3VXQWc4ZG94WlREODFMWmM2aEJvWXc3Uys1QXpCVXBZZm5TUmxOb2Jl?=
 =?utf-8?B?WllWdG9ybXVveUlnS0FVdGlmRG9ad1hueUxsRmlKTjVXNUZlZVh1eFgyaHFo?=
 =?utf-8?B?eWxMS1daY2h2Wjd0YldUcFBrQWtjb2FRTlN0QngwTzVHMTM3UUx4ZERBZ0Ew?=
 =?utf-8?B?R2dTZnRUSVBNMGlqeFozL1d0VlA2WGo2TGFwTk01eXJiSkRmdVFBNE1mOWJP?=
 =?utf-8?B?UWhxN1BDR01GZ2JCMDlxV3pXQWVpQk9uVUhGdDBmeDhTR096NmJRb2VDMkxz?=
 =?utf-8?B?ZjVqd2lmYVE1T0w3cW5Xcjk4UDRqalo3bEFMclJpTk1lbFNRbFVROXc5eVdC?=
 =?utf-8?B?dmJuZEJYZG91UTdMWU5aWmRoWGtWRm9DWVBsZGNWc3BOK2xEMEF2emNLYSt1?=
 =?utf-8?B?WVlTY1BVakZRaTBYL2JlbVYvaWNkTHlHdENpcXV6UE1nRmtEeUl0eU1NclBZ?=
 =?utf-8?B?L2QxSDhrdExQRVl5blVHWTNrTDNhSy9oZ09adE9veG5jYS85aWdIdjh3UFZB?=
 =?utf-8?B?RjNycWVQbWFwZ3JqYmZTazRiMzVzeUxDWGtkNll5UW9CY3MweFJUWnFFV0Va?=
 =?utf-8?B?QzZZcjg5bnUzRHFkOWlvWnQvYWlhRVF6bWJjcWVxMnZxVUd1TFI4ZGYvZjhE?=
 =?utf-8?B?TGpHeHhOWEwzV2p4RCtUZ1JWVG11dGp6UDN4akMvbldBZHhMdG5FUkZOSStN?=
 =?utf-8?B?YVZDV2U3UHppc1gwVkNOZ2hXa0xkNzhnSnJacEVzNVllT3VudWxCUkdxdU01?=
 =?utf-8?B?MlhCVHFubG9jOE9SRHErbTluSDhBL3F6WjNKbEVKQ3RWZlpPWm04S1ZoeDVD?=
 =?utf-8?B?b3k0N1RrRVpiQVk2NDR4R2RNSmg2TUhkdFdSa2VoNlZYWUNIZVlQR21vcFEw?=
 =?utf-8?B?RTlhRk9KL2VWbUI0S1BZOXpyQ3ZTTk0xS3pmdGI3dmZyckxOWW5iZUJCSzFj?=
 =?utf-8?B?RHIzRkJaSVp2VFRRYXQ1bmZsSUc4bm9YVXhseHNFbEtqQ0h1MHhrK1RQbjhp?=
 =?utf-8?B?SU5yRWx6N0piNlBtZG5oU29WYmxxZGgwUzQ1ckJLM2tpUDRNR2l1QkFNY2RM?=
 =?utf-8?B?TmUxTW5KandDNzZLTGlwUE1wMjZWNi9qZ1pBdG9CRmpjMzBDdEYyZnAydE5N?=
 =?utf-8?Q?JxvBnA8nR0CfdDscM0eKTIjv9nfZGMpdYY6m3h2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0b5737c-9274-436b-b6f8-08d9459ac044
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 01:08:40.4924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nW706F6Sa7UXdKclgk/AwWdj2CdITX4QFBFKPKz/0YvLvdd38Su9iqqliyakXH/QYC/LK2Kxuz0zYkSHC65RWwkZaAtYniInO0Qq1T0ugBg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2931
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10043 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107130005
X-Proofpoint-GUID: 4kHa2qbmx-ZRqp-OvB4jyeA2d-Dh1wRd
X-Proofpoint-ORIG-GUID: 4kHa2qbmx-ZRqp-OvB4jyeA2d-Dh1wRd
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/12/21 10:29 PM, Sean Christopherson wrote:
> On Thu, Jul 08, 2021, Thomas Gleixner wrote:
>> On Sat, Jul 03 2021 at 13:24, syzbot wrote:
>>> syzbot has bisected this issue to:
>>>
>>> commit 997acaf6b4b59c6a9c259740312a69ea549cc684
>>> Author: Mark Rutland <mark.rutland@arm.com>
>>> Date:   Mon Jan 11 15:37:07 2021 +0000
>>>
>>>     lockdep: report broken irq restoration
>>
>> That's the commit which makes the underlying problem visible:
>>
>>        raw_local_irq_restore() called with IRQs enabled
>>
>> and is triggered by this call chain:
>>
>>  kvm_wait arch/x86/kernel/kvm.c:860 [inline]
>>  kvm_wait+0xc3/0xe0 arch/x86/kernel/kvm.c:837
> 
> And the bug in kvm_wait() was fixed by commit f4e61f0c9add ("x86/kvm: Fix broken
> irq restoration in kvm_wait").  The bisection is bad, syzbot happened into the
> kvm_wait() WARN and got distracted.  The original #GP looks stable, if someone
> from mm land has bandwidth.
> 

I've bisected this to (my) recent commit 82e5d378b0e47 ("mm/hugetlb: refactor subpage
recording").

I have this fix below and should formally submit tomorrow after more testing.
My apologies for the trouble.

	Joao

------>8------

Subject: mm/hugetlb: fix refs calculation from unaligned @vaddr

commit 82e5d378b0e47 ("mm/hugetlb: refactor subpage recording")
refactored the count of subpages but missed an edge case when @vaddr is
less than a PAGE_SIZE close to vma->vm_end. It would errousnly set @refs
to 0 and record_subpages_vmas() wouldn't set the pages array element to
its value, consequently causing the reported #GP by syzbot.

Fix it by aligning down @vaddr in @refs calculation.

Reported-by: syzbot+a3fcd59df1b372066f5a@syzkaller.appspotmail.com
Fixes: 82e5d378b0e47 ("mm/hugetlb: refactor subpage recording")
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a86a58ef132d..cbc448c1a3c8 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4949,8 +4949,9 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct
*vma,
                        continue;
                }

-               refs = min3(pages_per_huge_page(h) - pfn_offset,
-                           (vma->vm_end - vaddr) >> PAGE_SHIFT, remainder);
+               /* [vaddr .. vm_end] may not be aligned to PAGE_SIZE */
+               refs = min3(pages_per_huge_page(h) - pfn_offset, remainder,
+                   (vma->vm_end - ALIGN_DOWN(vaddr, PAGE_SIZE)) >> PAGE_SHIFT);

                if (pages || vmas)
                        record_subpages_vmas(mem_map_offset(page, pfn_offset),
