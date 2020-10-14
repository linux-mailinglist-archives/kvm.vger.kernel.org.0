Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF71C28EAB5
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 04:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgJOCEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 22:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgJOCEh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Oct 2020 22:04:37 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8BEC0610CF
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 15:25:37 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id dn5so1044716edb.10
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 15:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u6oCs/9cz9zpdxxwRUYUm1kSBmkyW+u+MezXxhay8qc=;
        b=gW7j1C0VbGjDq2pb7kmXH0xuHfgsrcWmVnw7BNVz/Tby5/EWLlBSYuBTYmw17rDAqg
         lylbJ+o7UaR1mbiUY/egwQXmpuAYlVsKg/KEJAFHM0AKmH7VjwvYUAavAORKxt4CGi8g
         M7gYE3jmVYpGvmVyGdCJ066k4QR6/4VTZrtzhL0Kf6EH0ce9c1QIYuPlcrPZ7dtjJu8/
         Gh+8T2NmhdI6B3Pen0YfzFvoYdbu/Dy9QpcRvzpe6AxR+rchzzx5vGlJywIP/1UBe2bk
         66kkB2VI1PTPWeg7Iqud8PKlE0vqJ5bVtOtFWTOAktts6jlF64c/PpMGGLMcl86iJ4mY
         vmCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u6oCs/9cz9zpdxxwRUYUm1kSBmkyW+u+MezXxhay8qc=;
        b=F4hipNBAo6CPYT89eHlmB3F9xmCHAb0FypvdG/VtflJbpdnDJKJG6qdLjMxx4tGOgB
         H2mZaaReSVVZs2sxEihV6LZGCgd6Dt2ZozGVaZT6RA05fJqKaVxdugPU7OKZFiIuAgt9
         GPDo6hLWshAvEZEDIvWT0wpTBOW5aIhKpTaxEA0vHW7tx4cqThJbPBOOYZONEgIhFAYu
         LI942Lhps3/iYfoxyBec2GSJQEiPLtr2kXLnxaSADCtv22fcCtZYF9W3hMCQwONlUseE
         O/MLF+zL/cah5xnEuu564Uk6TWQWakcMGqzUniwyKqEVot/6OSf55LwI/DnLqvJ1Uv2K
         mUsg==
X-Gm-Message-State: AOAM533iDgifzox6tgaCzwiWCARDu+9Mag14e5UNbpFBFMHO9+bwkEmV
        7q+EuCuclU1eE5G5LN4e7vff9bj6S3k7L9x5s006OA==
X-Google-Smtp-Source: ABdhPJwHdi4HqJ28TwinJvmyYBdUNtOckKs21QUkcH2wM5UlBfHQVhUGhI4kpBB80wiBW3IH4Rhy4jEkZvU0KukYURg=
X-Received: by 2002:a50:8e1e:: with SMTP id 30mr1288139edw.354.1602714336584;
 Wed, 14 Oct 2020 15:25:36 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1602093760.git.yuleixzhang@tencent.com> <bdd0250e-4e14-f407-a584-f39af12c4e09@oracle.com>
 <CACZOiM2qKhogXQ_DXzWjGM5UCeCuEqT6wnR=f2Wi_T45_uoYHQ@mail.gmail.com>
 <b963565b-61d8-89d3-1abd-50cd8c8daad5@oracle.com> <CACZOiM26GPtqkGyecG=NGuB3etipV5-KgN+s19_U1WJrFxtYPQ@mail.gmail.com>
 <98be093d-c869-941a-6dd9-fb16356f763b@oracle.com>
In-Reply-To: <98be093d-c869-941a-6dd9-fb16356f763b@oracle.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 14 Oct 2020 15:25:25 -0700
Message-ID: <CAPcyv4jZ7XTnYd7vLQ18xij7d+80jU0zLs+ykS2frY-LMPS=Nw@mail.gmail.com>
Subject: Re: [PATCH 00/35] Enhance memory utilization with DMEMFS
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     yulei zhang <yulei.kernel@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Haiwei Li <lihaiwei.kernel@gmail.com>,
        Yulei Zhang <yuleixzhang@tencent.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Jane Y Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 12, 2020 at 4:00 AM Joao Martins <joao.m.martins@oracle.com> wrote:
[..]
> On 10/10/20 9:15 AM, yulei zhang wrote:
> > On Fri, Oct 9, 2020 at 7:53 PM Joao Martins <joao.m.martins@oracle.com> wrote:
> >> On 10/9/20 12:39 PM, yulei zhang wrote:
> >>> Joao, thanks a lot for the feedback. One more thing needs to mention
> >>> is that dmemfs also support fine-grained
> >>> memory management which makes it more flexible for tenants with
> >>> different requirements.
> >>>
> >> So as DAX when it allows to partition a region (starting 5.10). Meaning you have a region
> >> which you dedicated to userspace. That region can then be partitioning into devices which
> >> give you access to multiple (possibly discontinuous) extents with at a given page
> >> granularity (selectable when you create the device), accessed through mmap().
> >> You can then give that device to a cgroup. Or you can return that memory back to the
> >> kernel (should you run into OOM situation), or you recreate the same mappings across
> >> reboot/kexec.
> >>
> >> I probably need to read your patches again, but can you extend on the 'dmemfs also support
> >> fine-grained memory management' to understand what is the gap that you mention?
> >>
> > sure, dmemfs uses bitmap to track the memory usage in the reserved
> > memory region in
> > a given page size granularity. And for each user the memory can be
> > discrete as well.
> >
> That same functionality of tracking reserved region usage across different users at any
> page granularity is covered the DAX series I mentioned below. The discrete part -- IIUC
> what you meant -- is then reduced using DAX ABI/tools to create a device file vs a filesystem.

Put another way. Linux already has a fine grained memory management
system, the page allocator. Now, with recent device-dax extensions, it
also has a coarse grained memory management system for  physical
address-space partitioning and a path for struct-page-less backing for
VMs. What feature gaps remain vs dmemfs, and can those gaps be closed
with incremental improvements to the 2 existing memory-management
systems?
