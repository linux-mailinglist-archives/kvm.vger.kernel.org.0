Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2FD7C2937
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 23:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfI3V7r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 17:59:47 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:45096 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfI3V7r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 17:59:47 -0400
Received: by mail-ua1-f68.google.com with SMTP id j5so4737961uak.12
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 14:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QtvBdRQvi1GH0t6lRFmlMlveMzJkrpmQEmG0i+pGsaA=;
        b=tVGXXjv39mIHjDE8vkeaxDpBLSJTrjk0DQI3r8U1Tq3B3PLMJQQ1HSLscmpgLMoG/q
         GUvWf5+0GWYee9ePx6k1nipidvubKzt1p+d8KQX4JKFqvLZb0LF2cgZ4yzdnZBHpVVKn
         TxjN0QSDf64YxFyJL/hq4V4ScjryBUpp1rAnkuDkEQ9kLpN6gJ3Q+eYR8aQcJnQYwJP8
         AOrEVEPvSp2XXdJg2CV3KZ98w7tuc/IsVtfp2WHr8JyAFgdnsYEG0kf0S2TDv7n7Yv/8
         1sbw14NrtfuW1frpWa+oJ8tYnEesbQGff9u7axg7vPZXUhsc3nJ/QXIKCFiG6hcc2YKt
         tNsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QtvBdRQvi1GH0t6lRFmlMlveMzJkrpmQEmG0i+pGsaA=;
        b=HFTqOz9m/SCpjBAq7ny2lyEw5Wsx53Ff5HtLIgAhTNf7pL8Gq0NedkEeB/zTpMh/na
         3L0DVX1QdZq+0rJHYNMmw+9xsiyuH5wdKiddmDQyDucTOwIXJK5Gw9Rn2/X4OXqhsQC6
         bqY5IK0L+pOkel374MGurQD9ghPH50Mobzp1se1aV/Qt1LKoHXdgpVSU79TVYzbykmTu
         d8XhDfHBVQH70ZXIBlMewLLWYdRLxH8HuPtlhpNJJo0kDPXvf1G6KwJrqKMElD9v/0bp
         4Swri5u4ZDqldioXrKPM4u4qXtZCCIPcBh0wb5uKMTafeaEIUP/S4936B53MpbJyFoGo
         lQsg==
X-Gm-Message-State: APjAAAWSv+6EBGL/79biPmTd1WMpFnZG5yLVA4er9irzWqeMFLhF+6IW
        nUizb2+WA2QkhSg4SoIP9jyzaw3QXk6Y+6akO7KN
X-Google-Smtp-Source: APXvYqxrgOLUkrBWGYd7LUi01TPfr5SHcJMXNSkmDWYsJ3R89XLi6pDv6N/sv22wYx+0GbYBCqlEejnS+QzOf3ex0N4=
X-Received: by 2002:ab0:6046:: with SMTP id o6mr12343745ual.75.1569880785522;
 Mon, 30 Sep 2019 14:59:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAGG=3QUL_OrjaWn+gF4z-R8brR2=3661hGk0uUAK2y8Dff7Mvg@mail.gmail.com>
 <CALMp9eTm4sbr2GK+mM_ibazA9i9d4-eBcMhtZmfTf6HQbbD_Bg@mail.gmail.com>
In-Reply-To: <CALMp9eTm4sbr2GK+mM_ibazA9i9d4-eBcMhtZmfTf6HQbbD_Bg@mail.gmail.com>
From:   Bill Wendling <morbo@google.com>
Date:   Mon, 30 Sep 2019 14:59:34 -0700
Message-ID: <CAGG=3QWN8+b0pB9xWnhJsCqPmu+8VDDEdCeSbi=HJCZfRW-8jg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] lib: use an argument which doesn't require
 default argument promotion
To:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 10, 2019 at 9:43 AM Jim Mattson <jmattson@google.com> wrote:
>
> On Mon, Sep 9, 2019 at 4:12 PM Bill Wendling <morbo@google.com> wrote:
> >
> > Clang warns that passing an object that undergoes default argument
> > promotion to "va_start" is undefined behavior:
> >
> > lib/report.c:106:15: error: passing an object that undergoes default
> > argument promotion to 'va_start' has undefined behavior
> > [-Werror,-Wvarargs]
> >         va_start(va, pass);
> >
> > Using an "unsigned" type removes the need for argument promotion.
> >
> > Signed-off-by: Bill Wendling <morbo@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
