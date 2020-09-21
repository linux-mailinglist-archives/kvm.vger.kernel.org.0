Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3930127198A
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 05:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgIUDOD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Sep 2020 23:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgIUDOC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Sep 2020 23:14:02 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D213CC061755
        for <kvm@vger.kernel.org>; Sun, 20 Sep 2020 20:14:02 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id n61so11049642ota.10
        for <kvm@vger.kernel.org>; Sun, 20 Sep 2020 20:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8aBX0e8MybfbRf9E9EhaedKgS25sIo9HOpoJ6pUXAGU=;
        b=PUHdGvorlL2i9zupsfvVz4sGGnKhy7+AGKxT6ND6luuAim5sw3vYWadYoTXPlgAjwu
         98uwknN2I9uyfiiqT87KLLkBgUYIhyDne9VWGWG4vWl/6rxYY1gj+jgXbF/qcpxaHty6
         5icQreOfB7tPwXI9BOISj01AEmVtgQJ2u1qytNhv0wkEmCgwbZB6/pTG3IWWERL6CBdn
         3gOGtLUbggzM2EJLjcUNpU9eSw7x0NhILPEP2+JVOp2gTJb7R0PMRBy8wzvzx8FkFz0s
         /om40frzmcGk8ftuufVhrmkwkSbE8JHgAx97rzF19XSjYCSAL6s+CxFCZK8YrgQUe4h0
         vUlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8aBX0e8MybfbRf9E9EhaedKgS25sIo9HOpoJ6pUXAGU=;
        b=jKMnd95tSgfgwMOFH2smwWZk+kN41vm7fnXoWol38/nm+w/x4sv1kBjZ1H0flNRzax
         0gfWed96JoUVqSmTFYZbfi8GF3HUwukK/9UsDaruU3zHhxYoIg9lhdfTdgOopFhxWQB7
         ul7ga847bBZGxBGgjZT3vaefjWSfSvTPB48Hc0QLVWM0i+yXgNIyRPpdkYsPMG3WDhkE
         NLrXa+6gqEmNOaeHCczWbhUPpgAeFcKoRKkhQM1MxHusqjrAaMIvpwph5ycg8RzY7CEN
         R0gMOXpnJ6drFebxTWNSHrSjPJ9yevdgYADg1AU892QeaIPXZbNMbLeKqrFoUa77LPoj
         Cb1w==
X-Gm-Message-State: AOAM531Kl5Spq+dI82eF1P5nof5vD9NhOs+JOHrgdtjcvsilwX84QX+N
        5L/SgO44j2BOoO10f/C3ejNB0AK+aFRpchOZcac=
X-Google-Smtp-Source: ABdhPJxBDZF0UH6EzssN52fIJt6mt9SNIw6N7EcbQTdx6Dr4ycxhp0rW8f+f1+fXqc9dEIRW6lYNOvQviCD0wRbumOM=
X-Received: by 2002:a05:6830:1be6:: with SMTP id k6mr15840481otb.185.1600658042302;
 Sun, 20 Sep 2020 20:14:02 -0700 (PDT)
MIME-Version: 1.0
References: <0C23CC2D-B770-43D0-8215-20CE591F2E8F@bytedance.com>
 <CAAsfjH7KNZTJO+=Hp7em00F6=y0c69B_cekq_xT1GPxdC3a6yw@mail.gmail.com> <CA+3C=r-M=6BNnyCmW8m=AC_39OC4S593vZzc1oYbdS5U8dD0Kg@mail.gmail.com>
In-Reply-To: <CA+3C=r-M=6BNnyCmW8m=AC_39OC4S593vZzc1oYbdS5U8dD0Kg@mail.gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 21 Sep 2020 11:13:51 +0800
Message-ID: <CANRm+Czy48pdnRg2-=3u+tA+aqqYBSWy=gCjRui9h3K2zNMzvw@mail.gmail.com>
Subject: Re: [RFC] KVM: X86: implement Passthrough IPI
To:     Yang Zhang <yang.zhang.wz@gmail.com>
Cc:     Qiao Deng <dengqiao.joey@bytedance.com>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        zhouyibo@bytedance.com, zhanghaozhong@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 21 Sep 2020 at 10:51, Yang Zhang <yang.zhang.wz@gmail.com> wrote:
>
> Hi Paolo and Radim
>
> Any comments with this patch? From our daily business(including
> TikTok), we observed huge improvement with this patch(especially in
> the condition of heavy futex). The only concern is the security. It is
> ok to us since we are private cloud. But we really want to push it
> back upstream since it really helps a lot. So how about we turn it off
> by default. Is it acceptable to you?

You can passthrough anything you want for customized private cloud to
get the bare-metal performance, however, these codes should keep out
of the tree.

    Wanpeng
