Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84AD02C37F
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 11:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfE1Jtg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 05:49:36 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:33268 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbfE1Jtg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 05:49:36 -0400
Received: by mail-ot1-f65.google.com with SMTP id 66so17188067otq.0;
        Tue, 28 May 2019 02:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KRi+/C+vm5cztpsXfUVeLkDOVPLB4aZqwygYNrBno1g=;
        b=Q7xG41YYF2ZmuxUb2X+ltjAzjeK7pLMfwEBHv5e2w+/MmZh8X55fZsTHT9XwciLR/E
         HuUQGjJdVYrVQVkKmY8LlYkvwBKwRNYDjTDClmfRqzoL4jelnRiuxN9nY1CE8DeXQjbm
         uW/8GSxTyhDXHpg7QNQnWu+TRA69AeqJj3mOkdLzAnVLLY34nt8Mg9u+dSa/lGR0mmQ4
         JccPa4WCrMn9BC8uWe+Ufn2UXLgq+ojI+X2vf7wEFZnM/T4hy5jvbyFK5zDSmHkFTTfN
         pCgwp28ud4+Ut+QR/L2fuLRGXw+t5nbiVMf95C2wK8bIYx/jRFcU5iAPGuqOXpmI0DZs
         PNfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KRi+/C+vm5cztpsXfUVeLkDOVPLB4aZqwygYNrBno1g=;
        b=oPimW8BBAV6IalFCxN+/0bcPyNQIqmoZC/QyPGdOR2BnS3NwaN/lcR36IYIrd1dHQ3
         D9ypzcfTY/jDF+SVLLYk/DD973fpmIxcan+K5TH7tNjm9tu3dG2Cd5pWxq0sz371Pdrc
         70KjcAHrdeBStcz46Gql2Fph7NyNB128978JD4+7TlNoiE0MIj08smL4wdFU6vm7A442
         bVHobaWKa9Dq/GS6UVen/W2FovJ6VCNlY40EtsjXEzPo1deXLpL4FVQTyZPmuR6DBj0n
         Mrv4q/Ha4JV/1i2aGmtQHPTgDk83iv8OE4K5mpXLPe9u0z4v5Frrf7BoQrtAhy2GyRpP
         QBFQ==
X-Gm-Message-State: APjAAAUqP4bWJGRq0a/4OOC3XYivjlNwBmVn4+gbiXIcTbifwnslVt7P
        esrNNybYA/MUltEBH8ExnSpKyazeEpB9CSQLg0g=
X-Google-Smtp-Source: APXvYqycJLHbMUrxyQVmE6fOyNT7aMXGE36q+p+fIGphy4C5ccLTEuNFk0FznlB9kOMyYpFlF5BuYnw4Rhffeot+1ZY=
X-Received: by 2002:a9d:5a11:: with SMTP id v17mr17618810oth.254.1559036975223;
 Tue, 28 May 2019 02:49:35 -0700 (PDT)
MIME-Version: 1.0
References: <20180130013919.GA19959@hori1.linux.bs1.fc.nec.co.jp>
 <1517284444-18149-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <87inbbjx2w.fsf@e105922-lin.cambridge.arm.com> <20180207011455.GA15214@hori1.linux.bs1.fc.nec.co.jp>
 <87fu6bfytm.fsf@e105922-lin.cambridge.arm.com> <20180208121749.0ac09af2b5a143106f339f55@linux-foundation.org>
 <87wozhvc49.fsf@concordia.ellerman.id.au> <e673f38a-9e5f-21f6-421b-b3cb4ff02e91@oracle.com>
In-Reply-To: <e673f38a-9e5f-21f6-421b-b3cb4ff02e91@oracle.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 28 May 2019 17:49:28 +0800
Message-ID: <CANRm+CxAgWVv5aVzQ0wdP_A7QQgqfy7nN_SxyaactG7Mnqfr2A@mail.gmail.com>
Subject: Re: [PATCH v2] mm: hwpoison: disable memory error handling on 1GB hugepage
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Punit Agrawal <punit.agrawal@arm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Xiao Guangrong <xiaoguangrong@tencent.com>,
        lidongchen@tencent.com, yongkaiwu@tencent.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cc Paolo,
Hi all,
On Wed, 14 Feb 2018 at 06:34, Mike Kravetz <mike.kravetz@oracle.com> wrote:
>
> On 02/12/2018 06:48 PM, Michael Ellerman wrote:
> > Andrew Morton <akpm@linux-foundation.org> writes:
> >
> >> On Thu, 08 Feb 2018 12:30:45 +0000 Punit Agrawal <punit.agrawal@arm.com> wrote:
> >>
> >>>>
> >>>> So I don't think that the above test result means that errors are properly
> >>>> handled, and the proposed patch should help for arm64.
> >>>
> >>> Although, the deviation of pud_huge() avoids a kernel crash the code
> >>> would be easier to maintain and reason about if arm64 helpers are
> >>> consistent with expectations by core code.
> >>>
> >>> I'll look to update the arm64 helpers once this patch gets merged. But
> >>> it would be helpful if there was a clear expression of semantics for
> >>> pud_huge() for various cases. Is there any version that can be used as
> >>> reference?
> >>
> >> Is that an ack or tested-by?
> >>
> >> Mike keeps plaintively asking the powerpc developers to take a look,
> >> but they remain steadfastly in hiding.
> >
> > Cc'ing linuxppc-dev is always a good idea :)
> >
>
> Thanks Michael,
>
> I was mostly concerned about use cases for soft/hard offline of huge pages
> larger than PMD_SIZE on powerpc.  I know that powerpc supports PGD_SIZE
> huge pages, and soft/hard offline support was specifically added for this.
> See, 94310cbcaa3c "mm/madvise: enable (soft|hard) offline of HugeTLB pages
> at PGD level"
>
> This patch will disable that functionality.  So, at a minimum this is a
> 'heads up'.  If there are actual use cases that depend on this, then more
> work/discussions will need to happen.  From the e-mail thread on PGD_SIZE
> support, I can not tell if there is a real use case or this is just a
> 'nice to have'.

1GB hugetlbfs pages are used by DPDK and VMs in cloud deployment, we
encounter gup_pud_range() panic several times in product environment.
Is there any plan to reenable and fix arch codes?

In addition, https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kvm/mmu.c#n3213
The memory in guest can be 1GB/2MB/4K, though the host-backed memory
are 1GB hugetlbfs pages, after above PUD panic is fixed,
try_to_unmap() which is called in MCA recovery path will mark the PUD
hwpoison entry. The guest will vmexit and retry endlessly when
accessing any memory in the guest which is backed by this 1GB poisoned
hugetlbfs page. We have a plan to split this 1GB hugetblfs page by 2MB
hugetlbfs pages/4KB pages, maybe file remap to a virtual address range
which is 2MB/4KB page granularity, also split the KVM MMU 1GB SPTE
into 2MB/4KB and mark the offensive SPTE w/ a hwpoison flag, a sigbus
will be delivered to VM at page fault next time for the offensive
SPTE. Is this proposal acceptable?

Regards,
Wanpeng Li
