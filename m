Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971A528A7B3
	for <lists+kvm@lfdr.de>; Sun, 11 Oct 2020 16:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387961AbgJKOL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Oct 2020 10:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgJKOLz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Oct 2020 10:11:55 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F4FC0613CE
        for <kvm@vger.kernel.org>; Sun, 11 Oct 2020 07:11:55 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id a4so14255836lji.12
        for <kvm@vger.kernel.org>; Sun, 11 Oct 2020 07:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EbMJEKt9eTLHmHaJUMiW2DhPkTQLllPYPo11qQ19vqc=;
        b=VwFQEW+MA+vk3KOHAnZ9RVYMNyrl/CBEEU9DwY0RhQCk8Fd7VREXwzYh5qnzBz75Bi
         hwNZRtvbDPcUeveJ+puH8GNwt2t8IjAkvmPCq1/Rv+1O48zzBpivnDjdQtqnwLsRhm+F
         FSV8wFTSDfN2XzKf6CyGs7vuuxdm6FCaS17SkHBhaB8gPrPg6+JXKHag4P6Tf0wq2vEZ
         nRxcewgXEyfb8LvxO78H4VNFIqEH0a6KJxyrNZSQrrpY/V2nThgE+IM0bEXeFFZsS10T
         RqPsGxk5E0dqeMwFaaPP7aAKAHWq18cQnSWSBKNYSvunR60O8/zftuFW0YLf4Li/8H1A
         T8Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EbMJEKt9eTLHmHaJUMiW2DhPkTQLllPYPo11qQ19vqc=;
        b=ObJaIBVwUm5Ty1GQ3UgYPhWFjmidDOTbKx1M2emQPgQZM3qO9zYcp+d9mJUMe+G7W0
         4P73ZeIgv62NT7YltfQ0VmeYX7SOYEng/v3KSPt+sj6cedaR0E+WjDRJjFTZZl8ZWEai
         C+ocfIRIABi0lUcLQMMrJru3XPuQwK2Rqmmt8FAkFyhWfvgj+YCF5yoiWBYnfE70Zmmm
         eLXkJTwcaaEpi4d6L6e8EoKzRPjspS3MUNlh9uqL9CpLm8MT3NiALAGkSDH/Yu63Doee
         FMeRzplw68KuVW+pRzUdck3dJYNM6nFMY337rSsje80Sa1i5QTGAYtKsnWdoGCRngwaQ
         vtbg==
X-Gm-Message-State: AOAM530eu9Zq7q8bYvQjjBdOa6fV2K9BjO+ZeLd5HydiLtxgs1QL3qRT
        Wpf7EQHJ0xyIRg0XhIgeyQOOLBrEGxOE9opwndA=
X-Google-Smtp-Source: ABdhPJxgRCiezPh0DkXDi4N9xHZs2IAqqtQfmwr4RO6QX/433VQxrQuWMt1y5v0dAxA2Ea1OaP8ESzABOe9eA/3piAY=
X-Received: by 2002:a2e:9f4d:: with SMTP id v13mr5977931ljk.379.1602425513594;
 Sun, 11 Oct 2020 07:11:53 -0700 (PDT)
MIME-Version: 1.0
References: <CA+-xGqMd4_58_+QKetjOsubBqrDnaYF+YWE3TC3kEcNGxPiPfg@mail.gmail.com>
 <47ead258320536d00f9f32891da3810040875aff.camel@redhat.com>
In-Reply-To: <47ead258320536d00f9f32891da3810040875aff.camel@redhat.com>
From:   harry harry <hiharryharryharry@gmail.com>
Date:   Sun, 11 Oct 2020 10:11:39 -0400
Message-ID: <CA+-xGqOm2sWbxR=3W1pWrZNLOt7EE5qiNWxMz=9=gmga15vD2w@mail.gmail.com>
Subject: Re: Why guest physical addresses are not the same as the
 corresponding host virtual addresses in QEMU/KVM? Thanks!
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     qemu-devel@nongnu.org, mathieu.tarral@protonmail.com,
        stefanha@redhat.com, libvir-list@redhat.com, kvm@vger.kernel.org,
        pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Maxim,

Thanks much for your reply.

On Sun, Oct 11, 2020 at 3:29 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> On Sun, 2020-10-11 at 01:26 -0400, harry harry wrote:
> > Hi QEMU/KVM developers,
> >
> > I am sorry if my email disturbs you. I did an experiment and found the
> > guest physical addresses (GPAs) are not the same as the corresponding
> > host virtual addresses (HVAs). I am curious about why; I think they
> > should be the same. I am very appreciated if you can give some
> > comments and suggestions about 1) why GPAs and HVAs are not the same
> > in the following experiment; 2) are there any better experiments to
> > look into the reasons? Any other comments/suggestions are also very
> > welcome. Thanks!
> >
> > The experiment is like this: in a single vCPU VM, I ran a program
> > allocating and referencing lots of pages (e.g., 100*1024) and didn't
> > let the program terminate. Then, I checked the program's guest virtual
> > addresses (GVAs) and GPAs through parsing its pagemap and maps files
> > located at /proc/pid/pagemap and /proc/pid/maps, respectively. At
> > last, in the host OS, I checked the vCPU's pagemap and maps files to
> > find the program's HVAs and host physical addresses (HPAs); I actually
> > checked the new allocated physical pages in the host OS after the
> > program was executed in the guest OS.
> >
> > With the above experiment, I found GPAs of the program are different
> > from its corresponding HVAs. BTW, Intel EPT and other related Intel
> > virtualization techniques were enabled.
> >
> > Thanks,
> > Harry
> >
> The fundemental reason is that some HVAs (e.g. QEMU's virtual memory addresses) are already allocated
> for qemu's own use (e.g qemu code/heap/etc) prior to the guest starting up.
>
> KVM does though use quite effiecient way of mapping HVA's to GPA. It uses an array of arbitrary sized HVA areas
> (which we call memslots) and for each such area/memslot you specify the GPA to map to. In theory QEMU
> could allocate the whole guest's memory in one contiguous area and map it as single memslot to the guest.
> In practice there are MMIO holes, and various other reasons why there will be more that 1 memslot.

It is still not clear to me why GPAs are not the same as the
corresponding HVAs in my experiment. Since two-dimensional paging
(Intel EPT) is used, GPAs should be the same as their corresponding
HVAs. Otherwise, I think EPT may not work correctly. What do you
think?

Thanks,
Harry
