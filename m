Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7AF98A8B4
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2019 22:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfHLU4H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 16:56:07 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:40400 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbfHLU4H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 16:56:07 -0400
Received: by mail-ot1-f65.google.com with SMTP id c34so24239952otb.7
        for <kvm@vger.kernel.org>; Mon, 12 Aug 2019 13:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yEhYtlqx3isPppAlKvPH5QInxYeigAvCLguvPFMHc8U=;
        b=GvH5lrvIAAKcYun7yRC8SDdua3RI8viU0eBaf+6otOFBpCpzupg3pkPDPUEy/1xrXQ
         OPqAc6S9iobVBwK5a/Afj+iPegbRa257wSViB6S2zob3GV+yqTaTUsRudTC6kOE/dP2d
         rUAqbFjYxnpJHQ+HL/c//eTP1JQ8jj/+sZ8dLP1nGltc0R54UGZNetLNCQFvNYGvAgf6
         QHdoH35fdNjFsTRPNUBHzAz5Wni8BNL0469msCrLu5GMx2oACcBLf2uNZwV/rlxujwWL
         rQcOOp1gZC/2dYVqK2HspIzHHbarzQf1+k1VcCnoWLDbNO7Im/4ofxUWqlENdr6CIVpU
         CXXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yEhYtlqx3isPppAlKvPH5QInxYeigAvCLguvPFMHc8U=;
        b=g8cqVwP9sO4u9ZhS6DLEtdxZKLKjcvtmROl0evY8sIwKa1PRcoHOTlMtuXbl7h5Wan
         zgo9dpPpGJ2tccUn/NR9wXivNyHIRVccNSnR7ctZI2awrG89tzdpr59U3nFe/0tJBYlO
         tFV71KndWhKJ5X8SvwDTypWQwryZ73hlNlZHW2Z8CJlj2mcd8DNuPNhinMs01B3oBZrw
         NQQ6E73uHEi3GYmwwyK2gOptvQ63YtntD38BbFwHDpfG0sv3jbTlK+9SXot8VrBUvuNH
         EgUHmcoM3/IbrHA3G+6Nohc6eM+QEZaGzq2hrT+cL+0IoHRZcf5JVwYwOMsCmwfIXneE
         Lu7g==
X-Gm-Message-State: APjAAAUkxvpG9vYVkytQAmkYhGx6RBKZ+Jv7yvaLRC8TzZUJiWgx8RqG
        ADd+H9uhqMrClJeCbMrKEMeK3NQae9NYbcFRpUAc4g==
X-Google-Smtp-Source: APXvYqxwVUDUJKPykTlJoJIAe7teD9eBcVqKjT6eveMf2e+O5c92wWdS07aWZ62aimqSth0qIbY0i9WcKyYJFxWO15s=
X-Received: by 2002:a02:cb51:: with SMTP id k17mr4219145jap.4.1565643366183;
 Mon, 12 Aug 2019 13:56:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190808005255.106299-1-egranata@chromium.org> <20190810081540.GA30426@infradead.org>
In-Reply-To: <20190810081540.GA30426@infradead.org>
From:   Enrico Granata <egranata@google.com>
Date:   Mon, 12 Aug 2019 13:55:55 -0700
Message-ID: <CAPR809tiAhWqrNz0E5KrFtn-QrMTKv7vQtYq=_mrOH0VWfi0Eg@mail.gmail.com>
Subject: Re: [PATCH] vhost: do not reference a file that does not exist
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Enrico Granata <egranata@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        trivial@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fair enough, yeah.

I think what I found confusing was that the file had a precise
(directly actionable in a file browser, if you will) path. If it was
just listed as a filename, or a project name, it might have been more
obvious that one shouldn't expect to find it within the kernel tree
and just go look it up in your favorite search engine.

The right incantation to get your hands on that file is a web search,
not a local file navigation, and to my perception a full and seemingly
valid path pointed in the direction of doing the wrong thing.

It's not a huge deal, obviously, and it may be that I was the only one
confused by that. If so, feel free to disregard the patch.

Thanks,
- Enrico

Thanks,
- Enrico


On Sat, Aug 10, 2019 at 1:15 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Aug 07, 2019 at 05:52:55PM -0700, egranata@chromium.org wrote:
> > From: Enrico Granata <egranata@google.com>
> >
> > lguest was removed from the mainline kernel in late 2017.
> >
> > Signed-off-by: Enrico Granata <egranata@google.com>
>
> But this particular file even has an override in the script looking
> for dead references, which together with the content of the overal
> contents makes me thing the dangling reference is somewhat intentional.
