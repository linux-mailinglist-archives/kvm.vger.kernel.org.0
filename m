Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06A2AD4520
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2019 18:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbfJKQMI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Oct 2019 12:12:08 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:32781 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728106AbfJKQMI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Oct 2019 12:12:08 -0400
Received: by mail-io1-f67.google.com with SMTP id z19so22756358ior.0
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2019 09:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Ghhqs13l9J7awMoeppSlLIlZ02dv1lserL3qmUd8Yc=;
        b=R7SLHD+KbtAcFOZ2K/ro1NWDlJcYk/bwzvOb2JxJckYY9ZMVUn5anX9JG01I+M+s7q
         bqcS97/eSTn/gF4em547qWA6lcVmN1zQKISm4stpmkY4rR4ME2HtKwL4ickt6x9ckVQX
         CQxPHGAquR70e40aeUbqMB2qWjeMZzgXDrX8aEbtzjIbW12+naqrwNh7Urg4YJ60J35t
         aHbGwzG0rhnPBGzpaVf4XX60pJ8UjyJY5Yfvd+hdaatWZeJS7Fjm8YlMlfOV3WMzloBk
         1bMQPYCc3D41/RISVQdAOFcc8/ZHbLVgVTdDkqwtNXk+c3VFVZNo3cx84Y/Nq9WGVqvv
         CFiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Ghhqs13l9J7awMoeppSlLIlZ02dv1lserL3qmUd8Yc=;
        b=IUrC1iQwjDoVOnwdmf7g4tf8IdTLd0XB3BDpKMswBpkq9oIYL6JgDhww2uUAyCZLly
         BVQ3kcYQZCgplJfVGUYip04M8VmqKHRpaAima7Txsmnp4t3eyxDdJo9NQb1OG2jtzjK+
         qIrst6WDaK7cAio+GASH8Vk8+MXOHkL3MJBorFb4NcGqucmbvAjfP0SfIl02G/Ubjwq1
         kTL6GoHnSV4ReJvcFgHpY+pkVktm4kJkgoLjZlFqV2jQL1FhnDX3qd701u7OB3FRgTrb
         G42MLl/oeBaOSQDRCgoAezfxoxirA/nZ+jTfU1utezm/C+zF2LD5KRG5Wt+/55bOHXQw
         ldVA==
X-Gm-Message-State: APjAAAUsuTF7WfPhPpNepLJliPXeWoxCApu55PQBRAtXRciBO0a0QBJH
        rtTYkka86SvJ3bWknLWxQzcjOaZvvw+xbPZIV1X1+g==
X-Google-Smtp-Source: APXvYqy1GKGDk37Br2W2LVX7etbPq5VAbhtNTZMlhZelUrM8IH8+uBKGWoxqHoVE1V8iJjt+/XsQn3O2JKLxXsVaLzM=
X-Received: by 2002:a6b:6f0a:: with SMTP id k10mr8802754ioc.118.1570810326613;
 Fri, 11 Oct 2019 09:12:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190917085304.16987-1-weijiang.yang@intel.com>
 <CALMp9eSTz+XbmLtWZLqWvSNjjb4Ado4s+SfABtRuVNQBXUHStQ@mail.gmail.com> <20191011075033.GA11817@local-michael-cet-test>
In-Reply-To: <20191011075033.GA11817@local-michael-cet-test>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 11 Oct 2019 09:11:54 -0700
Message-ID: <CALMp9eTnS+-FtoO29XFQ8-1=gczXYP0eDPUKZssJ73-=gf1MGg@mail.gmail.com>
Subject: Re: [PATCH v5 0/9] Enable Sub-page Write Protection Support
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        yu.c.zhang@intel.com, alazar@bitdefender.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 11, 2019 at 12:48 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
>
> On Thu, Oct 10, 2019 at 02:42:51PM -0700, Jim Mattson wrote:
> > On Tue, Sep 17, 2019 at 1:52 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
> > >
> > > EPT-Based Sub-Page write Protection(SPP)is a HW capability which allows
> > > Virtual Machine Monitor(VMM) to specify write-permission for guest
> > > physical memory at a sub-page(128 byte) granularity. When this
> > > capability is enabled, the CPU enforces write-access check for sub-pages
> > > within a 4KB page.
> > >
> > > The feature is targeted to provide fine-grained memory protection for
> > > usages such as device virtualization, memory check-point and VM
> > > introspection etc.
> > >
> > > SPP is active when the "sub-page write protection" (bit 23) is 1 in
> > > Secondary VM-Execution Controls. The feature is backed with a Sub-Page
> > > Permission Table(SPPT), SPPT is referenced via a 64-bit control field
> > > called Sub-Page Permission Table Pointer (SPPTP) which contains a
> > > 4K-aligned physical address.
> > >
> > > To enable SPP for certain physical page, the gfn should be first mapped
> > > to a 4KB entry, then set bit 61 of the corresponding EPT leaf entry.
> > > While HW walks EPT, if bit 61 is set, it traverses SPPT with the guset
> > > physical address to find out the sub-page permissions at the leaf entry.
> > > If the corresponding bit is set, write to sub-page is permitted,
> > > otherwise, SPP induced EPT violation is generated.
> >
> > How do you handle sub-page permissions for instructions emulated by kvm?
> How about checking if the gpa is SPP protected, if it is, inject some
> exception to guest?
The SPP semantics are well-defined. If a kvm-emulated instruction
tries to write to a sub-page that is write-protected, then an
SPP-induced EPT violation should be synthesized.
