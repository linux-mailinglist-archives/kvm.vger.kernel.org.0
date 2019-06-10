Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 118DF3B99D
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2019 18:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbfFJQgm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 12:36:42 -0400
Received: from mail-io1-f50.google.com ([209.85.166.50]:35299 "EHLO
        mail-io1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbfFJQgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 12:36:42 -0400
Received: by mail-io1-f50.google.com with SMTP id m24so7405252ioo.2
        for <kvm@vger.kernel.org>; Mon, 10 Jun 2019 09:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ucla-edu.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3TNuV7TWP4ZMoquQRe0paXGS/Rg437XqjWW13LgE41U=;
        b=TTAMKQUs3a+M+N6uff5dZM0fEKs9Q5etH8JsCOhWOn98L5Muj0nXoZE228hnTwTH5Y
         UVfetaRQvAdUQMXEQ23GObq4FtjvGQDWvMWSWl0lafNCrPmwf0VL4R731x0kYFcRAv4E
         7VLTu8MVKDb2/oeFyE9ARubDWFlXMv1WPhEC8LS7nxlHKlMJDyt3fD/kWcaytUoUB5Yf
         J6nUudg28UfEwGPbLWQgArC4RnrsRYeLVEa9XyR3Ix/0N5mWzj0b3nhx3+h+3pClGdYe
         5pTXXvG6bvWrNFijuqCg/aqkixYGeAV7q5qSluHfMaY4t+XzBLamYDP6J/GKQxQvnz9U
         mxqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3TNuV7TWP4ZMoquQRe0paXGS/Rg437XqjWW13LgE41U=;
        b=FUUjQlGRPho8zeb7NkG6MNcQ8MWfjogeG+fU458Y1M+t+S9xKvPyy1dRuLix6e6aEP
         xaQXvyfm84op9kShzJ5rsdzJhYBpi5C6tSX3jHah+ZsDDErNKhjTr64yXHf8PlUQNx/s
         0O3CW/n+p8Z4WeyunuKmH61M66Wet5jx4i8POXvEjeApkGSp9kfxJGuBTpeiE3sSfI2y
         dwvGr3/AiqYi+QDXdGe9bbHIZLC40+CxQ0ITdfERnj9b564R6Qvz9NuLjTQ/fdHqSK4W
         V0vnosnh0DBQcYItN6zLz2hHzmPmxVj9SoX1y3v20G1CnYQP6M33CEDREOG3u3JFZ4Km
         bEdA==
X-Gm-Message-State: APjAAAXLuNQdxSI+AVH1SGJY+y8VVJ2wub8ypdY6wnMhDyBCtNQjaI5K
        tps0N3NefBEzn1VUNba6KhKzOmi6gRJ5KmdhW0HqoLOM
X-Google-Smtp-Source: APXvYqzG81RHz3LQn4FSl0d00L4W0NnCBbjzWZREyIuxmmm0zIC08QXnYa2tNioe5pZPz1GWWkXy9IIhRoDJ/sL7c+8=
X-Received: by 2002:a6b:8f93:: with SMTP id r141mr26337663iod.145.1560184601170;
 Mon, 10 Jun 2019 09:36:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAJrNScSLdAu=3Hh32mcG2nYvhby0U=Jy4UQ3h3pGbuJ0p0PCaA@mail.gmail.com>
 <20190610123126.GJ14257@stefanha-x1.localdomain>
In-Reply-To: <20190610123126.GJ14257@stefanha-x1.localdomain>
From:   ivo welch <ivo.welch@ucla.edu>
Date:   Mon, 10 Jun 2019 09:36:30 -0700
Message-ID: <CAJrNScTTbpijwxrC+RRp2c=x31OnAF9xVmVGuMf4LLR6UDWe7w@mail.gmail.com>
Subject: Re: need developer for small project
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

thank you, stefan.  I hope it won't be me that will make use of this
info.  I am going to guess that this sort of project may take 20 hours
for someone without background, and 2 hours for someone who already
played with it, and most of my 20 hours would be wrestling with short
magic incantations and bugs.

best,

/ivo
