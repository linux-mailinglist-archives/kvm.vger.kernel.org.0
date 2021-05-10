Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6327C37956E
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 19:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbhEJRZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 13:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232835AbhEJRYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 13:24:53 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DDDC06175F
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 10:23:47 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id q186so2126703ljq.8
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 10:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qjZ3geuBOqlKdDEgFutiZBTMkGdRIMIVW70XxRX+Dxw=;
        b=vJJFx+iXeURlAYbc9tWZCuLYqTtOMYMWSEW+fw1kxssIkflP5jlF5rqd6r3iaBnnXr
         ftMvtPSTN+cGcK/e7yDsOLKNTQyE5AeQd45wV9VkuiicpwGeuQwjKdnhpgohRIqb6J7v
         myLW+3zs+JNponDbp/r5s9eB9RkzUtUJL/SRFL2dV1FqItCpGWEjlbh6QHpbLIoBu4Ar
         lTer2XJ88n7g8b6/cX2p8b/VMJTqfKnqN2UZBM+JzX+aNeaaRErtRldWTqLsupPiKsXT
         0qO/xZ/8QEcWu0Db3v5TvM9cEz+hdt+Vtv2EgmHN4B85DRCz8gGYWFzljqCkHPX+OxKG
         FFgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qjZ3geuBOqlKdDEgFutiZBTMkGdRIMIVW70XxRX+Dxw=;
        b=KPCmTdXmkfvcVsVZjQV+yffvgDENzmICUTYaESWz33Ax2tYV2aA8OmrvVbcRhwO2AY
         A7MPMoK0V7gmSmGShcuO2XrroMlksQNjPYI68Uowo/p1p1TEKWCQj+uWwt32EFx2/sXP
         D2SiDwjHkVvLmVqKF/62TZqBNgWVF7q5n19yMxl600vsZ9LEXt6npvuD/1e40HPUSjkm
         In8ZogOfVrP6McSWFRh9810mLMT34sQ/86/UdxzKV1xD7dieV1UteJKnNh8EOUWFUDMb
         GQQ3mpzn9BzAtt+7d85jP6rCGdnepoGYbZdHJNpRnnXuOR/qPJ7UoN1XK0rfTLi4l6oC
         YkaQ==
X-Gm-Message-State: AOAM532cqfOGXgJKGTEkGR4msdcRUtKd3JNH6NNjMqdYDvxYj+nJZUET
        4X+fTOTEeV+YCm9svWK8LEXJAeOnf9qcvgmk+z39rA==
X-Google-Smtp-Source: ABdhPJyV8r4T6sAXK3f7SoBsKNghh9O8FC8xpC786adlgtglNdeGiERREDMjb1CU5uQtmGXbNHfn7RuMyQWIDk6p1l8=
X-Received: by 2002:a2e:9a54:: with SMTP id k20mr21613855ljj.448.1620667425476;
 Mon, 10 May 2021 10:23:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210507190559.425518-1-dmatlack@google.com> <20210507201443.nvtmntp3tgeapwnw@gator.home>
 <CALzav=dk_Z=hQE1Bjpfg8B3su7h2Jvk6RZoEFqBn+qqxmwzHMQ@mail.gmail.com> <20210510063236.5ekmlulazelvl2s6@gator>
In-Reply-To: <20210510063236.5ekmlulazelvl2s6@gator>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 10 May 2021 10:23:19 -0700
Message-ID: <CALzav=fptvvuY==LQ7pzA3y4aoEz4N+2TpiVvjTueZNyj8uwgw@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Print a message if /dev/kvm is missing
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 9, 2021 at 11:32 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Fri, May 07, 2021 at 01:51:45PM -0700, David Matlack wrote:
> > > >  static void vm_open(struct kvm_vm *vm, int perm)
> > > >  {
> > > > -     vm->kvm_fd = open(KVM_DEV_PATH, perm);
> > >
> > > I don't think we should change this one, otherwise the user provided
> > > perms are ignored.
> >
> > Good catch. I don't see any reason to exclude this case, but we do need
> > to pass `perm` down to open_kvm_dev_path_or_exit().
> >
>
> I've reviewed v2 and gave it an r-b, since I don't have overly strong
> opinion about this, but I actually liked that open_kvm_dev_path_or_exit()
> didn't take any arguments. To handle this case I would have either left
> it open coded, like it was, or created something like
>
> int _open_kvm_dev_path_or_exit(int flags)
> {
>    int fd = open(KVM_DEV_PATH, flags);
>    if (fd < 0)
>      ...exit skip...
>    return fd;
> }
>
> int open_kvm_dev_path_or_exit(void)
> {
>   return _open_kvm_dev_path_or_exit(O_RDONLY);
> }

I agree so long as hiding O_RDONLY does not decrease code readability.
I could not find any place in KVM where the R/W permissions on
/dev/kvm played a role, so I'm inclined to agree it's better to hide
the permissions.

I'll send another version with this change along with the comment fix.

Thanks.

>
> Thanks,
> drew
>
