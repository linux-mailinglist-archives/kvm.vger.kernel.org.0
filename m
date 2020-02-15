Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD44715FCEB
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2020 06:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725810AbgBOFeL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Feb 2020 00:34:11 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38824 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgBOFeL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Feb 2020 00:34:11 -0500
Received: by mail-ed1-f67.google.com with SMTP id p23so13801652edr.5;
        Fri, 14 Feb 2020 21:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VoLbzQnWuWhgQvIu/ihsEdqU9Gv5bRRjTaIt273JgVw=;
        b=ouje4b6XyVh8L3CyU5EmYSuFqC+kINVYAvRemNoBWfYn4BEIQj3DbWo7sNuJP0bWT+
         vEhANWoadxcbmIrrIJ5PaLrRRI+XPokWEvxVTPO9ELVWGU3Kq46+/jpBHTZP66b9PMEQ
         nYpdxtfY24W3VUhP/35N0apOK5+TVTY3skouBdZn23T5Y3EV8zncWvcI4eBpgyYrS5E1
         p6jmKb0yUnEABx1o8mk1x+p18+TUjCSKAK0hpdSOglKU/D54ERYwGszVlVM8u8F5KNBQ
         KsXWkf41p0aQpm2jZa8TauoAZjbgG14dtHRslZx6m9gtc/5GjvBRv5awFH/g1pRzosGa
         lKgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VoLbzQnWuWhgQvIu/ihsEdqU9Gv5bRRjTaIt273JgVw=;
        b=fhevcECeLwFeYwxUrobOs9cfXP4UqRLWkRn11gDmz1Kj4KQFwQIAsbP79QsycPfckD
         oAkcEYUZoP0BwC4v7LUrmGe612u5USC3lz8WyzvyVI4yF6U5dbynshQ7zJT/dRWBff1/
         mv2Jn65g0BRUa7ECUupIsd38mEaEfSG+pkiQyy9k82YkO7CcSeEwDr0CKYJEhH7FLr8m
         as9hOYzNuFxwACdcOT1xvNCyl6pOz8Qa4ScR29whsMGyvNYSamzmeWpC+EEC3uCsdRa7
         wIBBzpyR2YM+cfF0MzZTiNVJAt7UqE3/HNyw1S300moHvKDP2gQKAYwnDHgzIjDrW2th
         9whg==
X-Gm-Message-State: APjAAAUuZjPQbgwESPyYH1/3CyAEPwGxr9aPJeFN+qZjymmQ2xXTYU/t
        L7lhB2CbiM18GJrq0LHEPdJzfalJDLZkJg8EuA==
X-Google-Smtp-Source: APXvYqxMU400tyc2NMgWHEhslnRUFnWgMaf0SCN2dokHv0Sc2+DfucSVowVhgXpFFqvrZZ0Rypwd8WIE7nj28smJH+c=
X-Received: by 2002:a17:906:a898:: with SMTP id ha24mr6100472ejb.374.1581744849130;
 Fri, 14 Feb 2020 21:34:09 -0800 (PST)
MIME-Version: 1.0
References: <fdc45fbc0b9c4c38ab539c1abf0f1e4a@huawei.com>
In-Reply-To: <fdc45fbc0b9c4c38ab539c1abf0f1e4a@huawei.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Date:   Sat, 15 Feb 2020 13:33:57 +0800
Message-ID: <CAB5KdOYgfhZX7ya3G3YFOpLehzagYfajBE+mVOgOd7dvD3vXqA@mail.gmail.com>
Subject: Re: [PATCH] KVM: Add the check and free to avoid unknown errors.
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> =E4=BA=8E2020=E5=B9=B42=E6=9C=8815=E6=97=
=A5=E5=91=A8=E5=85=AD =E4=B8=8A=E5=8D=8810:00=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi:
> Haiwei Li <lihaiwei.kernel@gmail.com> wrote:
> > From: Haiwei Li <lihaiwei@tencent.com>
> >
> > If 'kvm_create_vm_debugfs()' fails in 'kzalloc(sizeof(*stat_data), ...)=
', 'kvm_destroy_vm_debugfs()' will be called by the final fput(file) in 'kv=
m_dev_ioctl_create_vm()'.
> >
> > Add the check and free to avoid unknown errors.
>
> Add the check and free? According to the code,it seem what you mean is "a=
dd the check against free" ?

Right, i can change the description.

>
> >
> > Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> >
> >       if (kvm->debugfs_stat_data) {
> > -             for (i =3D 0; i < kvm_debugfs_num_entries; i++)
> > +             for (i =3D 0; i < kvm_debugfs_num_entries; i++) {
> > +                     if (!kvm->debugfs_stat_data[i])
> > +                             break;
> >                       kfree(kvm->debugfs_stat_data[i]);
> > +             }
> >               kfree(kvm->debugfs_stat_data);
> >       }
> >   }
>
> If (!kvm->debugfs_stat_data[i]) is checked in kfree() internal. And break=
 early seems have no different effect.
> Could you please explain what unknown errors may occur? And how? Thanks.

I get the free() code. It is just like what you said. Thanks a lot.
Break early is useful. If kvm->debugfs_stat_data[i] is null, breaking
early can reduce the check.

>
