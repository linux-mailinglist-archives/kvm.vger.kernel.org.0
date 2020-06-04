Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2457A1EEB14
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 21:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbgFDTZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 15:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728976AbgFDTZG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 15:25:06 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B426BC08C5C0
        for <kvm@vger.kernel.org>; Thu,  4 Jun 2020 12:25:05 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id g3so7190966ilq.10
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 12:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NbRk0Np2RyEeRH9dbEqIpL8yNJC/z12gVw4fgEEaAMo=;
        b=u3M9sN/IXt2i7f51ms44wcx6VueK56R5jjDi1EhydAqd363IGhxfzmeL0NaaS0VDKZ
         LT3tpByq66dNFY2IfXpAvX+pUorSPfIjGsVB1859eLQdxjM/VlmM+e6CWuL30UGQhC7K
         YQKEksG3uOkNi41rgdJ85kME1PIvIEb4BRzrRRfQ8pNpUmhGI0VKYt8BnHnBwPZFuTmA
         288Voau9XPcStXZ99IiGx9aGt7TmfOx88Wcu73nVl90rLmJS6BucaU4U8JytXmEebCWr
         v1W1Kjv5Pl5f9LBg8XH+2ZKC0GCarljHbOfzGXa/Vs0ag78JzyHR1/0N06Z9xg9rzSbJ
         WBqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NbRk0Np2RyEeRH9dbEqIpL8yNJC/z12gVw4fgEEaAMo=;
        b=ZNaVoYkmNPaJBTSFmmJtyNRHgD23v82d+ZmBWNshCIFzrCL92bQBnvviddwbExAG2Z
         rtVKgKZJZZD4Ap3FwxteU7UX71W9+peQV3qZajCD/qKZ3NiJCnNUowJaYkNYzJOoq+pl
         /eQyc3G+GwtfqQNslMjGy+m/W3M5L0ugdcKXwmB6DuZCTT6SuK3upGdA8aAHAPkSulxH
         RY1KU78JuOBBpfUyN8FEexAiA4tGm9+f9abLVrrsA2CKFlD7FRXO7qekTSvduzigWTT/
         ZteI45OOZ3zVzXn0Ve6UePhRYzUfzrrQtb+qHKVE3PVK5H64T3BNGh/syCVUlTBtbtcs
         USsQ==
X-Gm-Message-State: AOAM531XIgNxi+KgaNl9/sX+qGNVJr+2F6Q/ciuZP4Y4IIbRoy8SEtUR
        YzeWfGiBZ3hkMseLiQZj9zrxsnzaUyEg7vafPMB5Fw==
X-Google-Smtp-Source: ABdhPJwKoN5r5L9R54HbykuC0DorU7y/W2B3N9E1pyD/bJ0BVDTWE/MGa2wTOsc6+Qu1lN6eOLHr9/7eCovbejyU7M0=
X-Received: by 2002:a92:c048:: with SMTP id o8mr5413126ilf.202.1591298704710;
 Thu, 04 Jun 2020 12:25:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200326200634.222009-1-dancol@google.com> <20200401213903.182112-1-dancol@google.com>
 <alpine.LRH.2.21.2006041354381.1812@namei.org> <CAEjxPJ4GvTXQY_BzLugnrXrPnehqwnmqxn21mjVDhpk4kYV3Aw@mail.gmail.com>
In-Reply-To: <CAEjxPJ4GvTXQY_BzLugnrXrPnehqwnmqxn21mjVDhpk4kYV3Aw@mail.gmail.com>
From:   Lokesh Gidra <lokeshgidra@google.com>
Date:   Thu, 4 Jun 2020 12:24:53 -0700
Message-ID: <CA+EESO5GZtSNEyXkmLGS6vNQDDGqrwhmzEpcueQydr99=n+apQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/3] SELinux support for anonymous inodes and UFFD
To:     Stephen Smalley <stephen.smalley.work@gmail.com>
Cc:     James Morris <jmorris@namei.org>,
        Daniel Colascione <dancol@google.com>,
        Tim Murray <timmurray@google.com>,
        SElinux list <selinux@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Paul Moore <paul@paul-moore.com>,
        Nick Kralevich <nnk@google.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adding a colleague from the Android kernel team.

On Thu, Jun 4, 2020 at 11:52 AM Stephen Smalley
<stephen.smalley.work@gmail.com> wrote:
>
> On Wed, Jun 3, 2020 at 11:59 PM James Morris <jmorris@namei.org> wrote:
> >
> > On Wed, 1 Apr 2020, Daniel Colascione wrote:
> >
> > > Daniel Colascione (3):
> > >   Add a new LSM-supporting anonymous inode interface
> > >   Teach SELinux about anonymous inodes
> > >   Wire UFFD up to SELinux
> > >
> > >  fs/anon_inodes.c                    | 191 ++++++++++++++++++++++------
> > >  fs/userfaultfd.c                    |  30 ++++-
> > >  include/linux/anon_inodes.h         |  13 ++
> > >  include/linux/lsm_hooks.h           |  11 ++
> > >  include/linux/security.h            |   3 +
> > >  security/security.c                 |   9 ++
> > >  security/selinux/hooks.c            |  53 ++++++++
> > >  security/selinux/include/classmap.h |   2 +
> > >  8 files changed, 267 insertions(+), 45 deletions(-)
> >
> > Applied to
> > git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git secure_uffd_v5.9
> > and next-testing.
> >
> > This will provide test coverage in linux-next, as we aim to get this
> > upstream for v5.9.
> >
> > I had to make some minor fixups, please review.
>
> LGTM and my userfaultfd test case worked.
