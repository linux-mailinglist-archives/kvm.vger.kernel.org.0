Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499F9346CF9
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 23:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbhCWW2m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 18:28:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39256 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234162AbhCWW02 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 18:26:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NMPMUR058585;
        Tue, 23 Mar 2021 22:25:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : content-type :
 mime-version; s=corp-2020-01-29;
 bh=2hswp5xsTg1FWNafEWxY2a9ec4jaKF/bFlNfNMV64dY=;
 b=scxgKNjejuPZw8y2QwfBNEnEpoUIteY1OIVA739tZGnbFDFaQXmRVMnJprQH9thP0QkN
 DXQpRY/xfZ/rACyMCi4yN47p5lKSACB96LA+vRoPvW9rr80V73cHJ9PIs7lvUvWbhOt0
 m6ZfkC/euuy3ublVJ1UWUOQTHrcNSoLI5ZQPmIT6BWV3gjYa+pn5x3HfgKqY/H/TiQFM
 yopdocdnW/ZinQkbJuWA+5d8B9zF4jSE6wzdgKdGURLcMnHdtcDjRo01SvF5d8s3BVoO
 n5qJtdcQSjPE47S5pMgPPnVdkm4kP/NjtY2310BBvuVE4c7ThTAZHoWIau5idXknwikM RQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37d8fr8vkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 22:25:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NMOkI8039411;
        Tue, 23 Mar 2021 22:25:59 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by userp3030.oracle.com with ESMTP id 37dtyy26rg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 22:25:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nCg1oxa/mSNrqZ4Y/6WjYLaqN05AEDbgpF4G/zTC2+lSBLzCYMmk6acpL2DOCMLbAKQ1C/qXXuP2l7JHV0sQO23BJ8PD8hn0Zh0CZiQHpdD5Zg79EAO9VTzYgv6FFEPcNFzu1Zz0UEqQzKPLf4QGEo6W1NEVaIOlmE6ezH+R0Ekg08B9UhahyC0WUp9TlB3QATo4eFzCvuoabJ1I11JBPhPP5djwIZmWWGdqOrTuTpodO2RO/h4fk9PfOqfwNEtMAlbQB30Gty+6jOI/GSCgtMJanXNy+H74H9Px6Vc3FTFLKeDc4+KauHE510/+DnQ/Z6Nnl5fw+nHIkfqMaW+fog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2hswp5xsTg1FWNafEWxY2a9ec4jaKF/bFlNfNMV64dY=;
 b=kr7rBcKoftxNAWeFrE/J05oaaJ4gZYsVij8oafo/9ygE/2kQUlCH/3Ifc1ahmcuKPleqNYu+rMeVFAs+ALAczVxrV6lH/3VBBAofHEMDnbbub9HVIkX+mEXzoOhorcUv1vkqj7YNRvC+2Jz2qyYhfmtSS8uupOCFtQ5La/Uq/b/S+/Uia9npsVu8pGzBd+KvZH6lBRdwiNZh9M8sebPCSq9zPRosZpk9DRxaHnFUtGR0HbVuq9eln68jjTDxbw5xmvDhwwH1KB6wXsVGMmqJaGkzC3m7+ITZTuvGy5Bv2K6vH145Yt9O2ZLpecAFqL1plQ45D7UfTfLIq0jLmtwZ2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2hswp5xsTg1FWNafEWxY2a9ec4jaKF/bFlNfNMV64dY=;
 b=wUsyjY3Q9PZEZOGHLCCNTPmNkESOl93gI0MqwIksrQ6S5MyXV1lWMAkTIFt2EKkOflZafRzpQLi6E+36pbfb06QeSHRhakqZB8Yyk39M1+4P9e9DZS46bH93p0GQc7UpQELRBzv+lGGBGV5Jr1TjItjv5izCVO5BJeOXaVFeKn0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR10MB1774.namprd10.prod.outlook.com (2603:10b6:301:9::13)
 by CO1PR10MB4483.namprd10.prod.outlook.com (2603:10b6:303:98::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Tue, 23 Mar
 2021 22:25:57 +0000
Received: from MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183]) by MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183%3]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 22:25:56 +0000
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Steven Sistare <steven.sistare@oracle.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] vfio/type1: Batch page pinning
In-Reply-To: <20210323133254.33ed9161@omen.home.shazbot.org>
References: <20210219161305.36522-1-daniel.m.jordan@oracle.com>
 <20210219161305.36522-4-daniel.m.jordan@oracle.com>
 <20210323133254.33ed9161@omen.home.shazbot.org>
Date:   Tue, 23 Mar 2021 18:25:45 -0400
Message-ID: <87y2ed7biu.fsf@oracle.com>
Content-Type: text/plain
X-Originating-IP: [98.229.125.203]
X-ClientProxiedBy: MN2PR08CA0009.namprd08.prod.outlook.com
 (2603:10b6:208:239::14) To MWHPR10MB1774.namprd10.prod.outlook.com
 (2603:10b6:301:9::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from parnassus (98.229.125.203) by MN2PR08CA0009.namprd08.prod.outlook.com (2603:10b6:208:239::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 23 Mar 2021 22:25:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e953ef21-85ca-4bfa-5a45-08d8ee4aa0b7
X-MS-TrafficTypeDiagnostic: CO1PR10MB4483:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB448388C3807CB7F9376B5F42D9649@CO1PR10MB4483.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u0bQ7cx1nDuO9tp3HcLSdlIpzuIEzKWjEUzuCRa157TZsaq+ohk+qHDg2GRMVTargUPAV7CdQkepF3FDtJOaLhcAr/WdNU0G+HvG3Qp6XiRkMj+35jJfn4liFzLf5FhgMiRc8PznoU0JPjGAkwfNqu4FOqIxLkiaaxiimSeABjpgLDXGRTgrLgGSFyGehvcp20rUcMzRd06kzukMmH4zOUIc9hJzykV8E3q4GtpotTGTFLb/hE1KLFQT9uEb+PAd2UheQQUMC7pDND19vpJBf4r13rxQ8FqEv0RkAbXY5ahapYgvJDi1WuaKbJAj0E0Ek9a01Dt49SkktR7KMTuGSdxA/n7iCGrVLyAbTFOeoaymPyU+IwqEOBDLiadzQBq5a87azgEO9pfzR7Fvhyt8hrFRPovhZH/FckC8/YFO2OZVbPRQ/7xRzIbiR6ybnViZY779wOFIWOT/fbjBkUdQirylFizwTOkDNeFccdH5jyyd3wsXUautNPhhSTyI0ucpqGKonb2obM/gMzzv54mTFoAWPK/b/h5n4pma+9OAU5IJkPStB7XBGgZgg5qQfv7iKaamv1AiVaefOI3t+zm9XuVg9sArsRoC0a9oLcdrxWtu44wRnASWDvAbPdYBDWGEI7f+q0ftbQcVoLLGSkfGJOj+9R6/PFn2Guw3U1KEjpY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1774.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(136003)(346002)(376002)(52116002)(66946007)(6666004)(6916009)(4326008)(186003)(8936002)(5660300002)(66476007)(8676002)(83380400001)(6496006)(66556008)(36756003)(26005)(316002)(2616005)(2906002)(956004)(6486002)(54906003)(478600001)(38100700001)(86362001)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?R6h7mGtR52BxhhlSHjVGeqdaliRm1czJVuXbJ7beQVek5RNcjFHna+WUcATG?=
 =?us-ascii?Q?30jeSg16IIXckKJpCxOQDrAhnAJ6cytBn4VsS8ZWXOjEfjgYWTBxWQO8q41J?=
 =?us-ascii?Q?Y+I4+4CTeX3LWvtLEZbaLpgLE58UVWOISy0V6EheXK+7qkPkkllt593pKnr2?=
 =?us-ascii?Q?TeB7uS8ommLdIY3ZWxiY3bi0t5/L7K2rHGuphVO7GlsZDQLsG1dF2TRH807l?=
 =?us-ascii?Q?d6fn84dnkYVlQz9smzqkD1XbCPlfGmXtxBbDHTzb5PAGuhzV0XFcP3K3vdyp?=
 =?us-ascii?Q?dd2wc6dBgc/zshVQSwotHw0Ool4O37jKBi6KbI/x3ry58vK4ZP8wwm9qAtrP?=
 =?us-ascii?Q?B80inimaMlZ2/0NQEl/QJLqkBivTaIcuANYVwHhA7yVBRZ5blnJPNdEGwNEe?=
 =?us-ascii?Q?nQO+mUK92PF+eeI6UqzfDcoPVvLOSumJJNVUErA//8kB9CMMZx/5kkKxgq9F?=
 =?us-ascii?Q?5ywTuNBWQ/yIyz+j4OcoSNgDaQhPmiumcAERTag9NJ8OlpbsA/EjGG6+nmjw?=
 =?us-ascii?Q?HpyCXvnwe5sPCFSE+8CACU34qGasCNwRTF1MfmD/URWtKxn8h77FJSyL/v4Z?=
 =?us-ascii?Q?IcW6lnk9UCKPihzZP6EWz2xBLxe0nBp05kd95upkhF1GuXrSuJLvW5RqMDO8?=
 =?us-ascii?Q?dApPC2xmT4sp5B9W2tCfnQ7O0wfRm2GqNk2DvvpVClPFrDhYVvw87FZLV9Zz?=
 =?us-ascii?Q?mJMp8EGG8PWQPhQ6WMAgw7R7fGZhSHqBCt46SWx7/fU9OFCY5WNBxPKTns79?=
 =?us-ascii?Q?F2BQCI7LpgxkmAkBPS9tKUrJ8lWQFwzoTK3QSiWO+0wwaKS2BuKgdw6SU7my?=
 =?us-ascii?Q?nfpVtGz+bd1LzwcwzNb9aM2TRxFAQZTa6iXq5AvBVECQv43ntdmjEe53eEJ7?=
 =?us-ascii?Q?4g2YA8QjybnubM+237a2An3vnUGIFxqmO5bxYCuxwZFCOs/YiOUtmhjoP65v?=
 =?us-ascii?Q?Tp7zcmcv/4+HzjJ3t28m0/dy4X7mfVHWtIDE2Fp1I9oJ3xpR9EKVF4U+bH/p?=
 =?us-ascii?Q?Y0Xhzg2iz36fOJMyCgKooMPWnGT42sjgInWSwNQ/5wi1HOO7rttiqYYOivAx?=
 =?us-ascii?Q?26ZfNTveNQY2e4OCs5Ve9OqURWlUwS3YOEvvNYSzbIMKriX37ZgnioRSw6BA?=
 =?us-ascii?Q?pDBic1SWYYQBPBE60E6dN+TVk0sz0fimSApVpdGUncmZgBq4uzKADb5nhQwO?=
 =?us-ascii?Q?70i8xkujOGFr3+J2t/zef+8LRE+Hl/pWWqr+TrFiWSdJhPCg6m3CXTng/z1S?=
 =?us-ascii?Q?F9T7CLsSks/Zlpyjl0VqXxXNOI22o/Imi/TJ8EjXEvm5O+c1TWjm7OrKpQ+E?=
 =?us-ascii?Q?BVvoBlfLNK5UMmUqZELXonA5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e953ef21-85ca-4bfa-5a45-08d8ee4aa0b7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1774.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 22:25:56.7045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QRbjMan011mbSR+fLON6xs0vGxNCE6JmlITEr0Wy1DKhlkRs83RgFQEEQGeMnqWmgDPuxJ9gBhb566UZpseuwEWe21FYgTDMbQtD7V7u2qg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4483
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230166
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230165
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

Alex Williamson <alex.williamson@redhat.com> writes:
> I've found a bug in this patch that we need to fix.  The diff is a
> little difficult to follow,

It was an awful diff, I remember...

> so I'll discuss it in the resulting function below...
>
> (1) Imagine the user has passed a vaddr range that alternates pfnmaps
> and pinned memory per page.
>
>
> static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>                                   long npage, unsigned long *pfn_base,
>                                   unsigned long limit, struct vfio_batch *batch)
> {
>         unsigned long pfn;
>         struct mm_struct *mm = current->mm;
>         long ret, pinned = 0, lock_acct = 0;
>         bool rsvd;
>         dma_addr_t iova = vaddr - dma->vaddr + dma->iova;
>
>         /* This code path is only user initiated */
>         if (!mm)
>                 return -ENODEV;
>
>         if (batch->size) {
>                 /* Leftover pages in batch from an earlier call. */
>                 *pfn_base = page_to_pfn(batch->pages[batch->offset]);
>                 pfn = *pfn_base;
>                 rsvd = is_invalid_reserved_pfn(*pfn_base);
>
> (4) We're called again and fill our local variables from the batch.  The
>     batch only has one page, so we'll complete the inner loop below and refill.
>
> (6) We're called again, batch->size is 1, but it was for a pfnmap, the pages
>     array still contains the last pinned page, so we end up incorrectly using
>     this pfn again for the next entry.
>
>         } else {
>                 *pfn_base = 0;
>         }
>
>         while (npage) {
>                 if (!batch->size) {
>                         /* Empty batch, so refill it. */
>                         long req_pages = min_t(long, npage, batch->capacity);
>
>                         ret = vaddr_get_pfns(mm, vaddr, req_pages, dma->prot,
>                                              &pfn, batch->pages);
>                         if (ret < 0)
>                                 goto unpin_out;
>
> (2) Assume the 1st page is pfnmap, the 2nd is pinned memory

Just to check we're on the same wavelength, I think you can hit this bug
with one less call to vfio_pin_pages_remote() if the 1st page in the
vaddr range is pinned memory and the 2nd is pfnmap.  Then you'd have the
following sequence:

vfio_pin_pages_remote() call #1:

 - In the first batch refill, you'd get a size=1 batch with pinned
   memory and complete the inner loop, breaking at "if (!batch->size)".
   
 - In the second batch refill, you'd get another size=1 batch with a
   pfnmap page, take the "goto unpin_out" in the inner loop, and return
   from the function with the batch still containing a single pfnmap
   page.

vfio_pin_pages_remote() call #2:

 - *pfn_base is set from the first element of the pages array, which
    unfortunately has the non-pfnmap pfn.

Did I follow you?

>
>                         batch->size = ret;
>                         batch->offset = 0;
>
>                         if (!*pfn_base) {
>                                 *pfn_base = pfn;
>                                 rsvd = is_invalid_reserved_pfn(*pfn_base);
>                         }
>                 }
>
>                 /*
>                  * pfn is preset for the first iteration of this inner loop and
>                  * updated at the end to handle a VM_PFNMAP pfn.  In that case,
>                  * batch->pages isn't valid (there's no struct page), so allow
>                  * batch->pages to be touched only when there's more than one
>                  * pfn to check, which guarantees the pfns are from a
>                  * !VM_PFNMAP vma.
>                  */
>                 while (true) {
>                         if (pfn != *pfn_base + pinned ||
>                             rsvd != is_invalid_reserved_pfn(pfn))
>                                 goto out;
>
> (3) On the 2nd page, both tests are probably true here, so we take this goto,
>     leaving the batch with the next page.
>
> (5) Now we've refilled batch, but the next page is pfnmap, so likely both of the
>     above tests are true... but this is a pfnmap'ing!
>
> (7) Do we add something like if (batch->size == 1 && !batch->offset) {
>     put_pfn(pfn, dma->prot); batch->size = 0; }?

Yes, that could work, maybe with a check for a pfnmap mapping (rsvd)
instead of those two conditions.

I'd rejected two approaches where the batch stores pfns instead of
pages.  Allocating two pages (one for pages, one for pfns) seems
overkill, though the allocation is transient.  Using a union for "struct
page **pages" and "unsigned long *pfns" seems fragile due to the sizes
of each type needing to match, and possibly slow from having to loop
over the array twice (once to convert them all after pin_user_pages and
again for the inner loop).  Neither seem much better, at least to me,
even with this bug as additional motivation.

It'd be better if pup returned pfns in some form, but that's another
issue entirely.

>
>                         /*
>                          * Reserved pages aren't counted against the user,
>                          * externally pinned pages are already counted against
>                          * the user.
>                          */
>                         if (!rsvd && !vfio_find_vpfn(dma, iova)) {
>                                 if (!dma->lock_cap &&
>                                     mm->locked_vm + lock_acct + 1 > limit) {
>                                         pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
>                                                 __func__, limit << PAGE_SHIFT);
>                                         ret = -ENOMEM;
>                                         goto unpin_out;
>                                 }
>                                 lock_acct++;
>                         }
>
>                         pinned++;
>                         npage--;
>                         vaddr += PAGE_SIZE;
>                         iova += PAGE_SIZE;
>                         batch->offset++;
>                         batch->size--;
>
>                         if (!batch->size)
>                                 break;
>
>                         pfn = page_to_pfn(batch->pages[batch->offset]);
>                 }
>
>                 if (unlikely(disable_hugepages))
>                         break;
>         }
>
> out:
>         ret = vfio_lock_acct(dma, lock_acct, false);
>
> unpin_out:
>         if (ret < 0) {
>                 if (pinned && !rsvd) {
>                         for (pfn = *pfn_base ; pinned ; pfn++, pinned--)
>                                 put_pfn(pfn, dma->prot);
>                 }
>                 vfio_batch_unpin(batch, dma);
>
> (8) These calls to batch_unpin are rather precarious as well, any time batch->size is
>     non-zero, we risk using the pages array for a pfnmap.  We might actually want the
>     above change in (7) moved into this exit path so that we can never return a potential
>     pfnmap batch.

Yes, the exit path seems like the right place for the fix.

>
>                 return ret; }
>
>         return pinned;
> }
>
> This is a regression that not only causes incorrect mapping for the
> user, but also allows the user to trigger bad page counts, so we need
> a fix for v5.12.

Sure, I can test a fix after I get your thoughts on the above.

Daniel
