Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A47FC1A459E
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 13:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgDJLZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 07:25:03 -0400
Received: from mail-qv1-f47.google.com ([209.85.219.47]:37900 "EHLO
        mail-qv1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgDJLZC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 07:25:02 -0400
Received: by mail-qv1-f47.google.com with SMTP id p60so770757qva.5
        for <kvm@vger.kernel.org>; Fri, 10 Apr 2020 04:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=EyRGokCM/wVUU/nXIGOSGIM3r9LXN2RB/WA9Dd31/fo=;
        b=ROQfgV0cUD7XVup63svo3RL/AkZxQJ+fzf0+St66kLDv734ApzcVHDh3HUmeuG8KXk
         cqlatVQcoyIjdBaIz8liOq6Ir26yPxe1mV9FN+t/Kk0ZwlJRYFRHiBq6O4Ot+99XKAAq
         B9i3YLywbDhnkff++HQgj9XsQZTd48kpcGHK+TIVp01fy4P1A9qhsZtgIMR9W0o3m+r6
         LlPBX/1yvrlvdvpwVcFmj5eDWlB+/1vEN0lFr5B82oh2JK/4+Ay3O/MfhMHO/+FHrZi0
         lp5izN+65oGZrTYrdxCe/yZPneFZoty3FxRgFgmCJRzeoHn+a6LAH8uNpLsGEyZINxrN
         3Low==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=EyRGokCM/wVUU/nXIGOSGIM3r9LXN2RB/WA9Dd31/fo=;
        b=HbFtPQI2KYlWokXurSHxNGc5U5dEKR3+MBN/3JRX7t/0tPuH4Ds6OOgeP96OvneqcU
         uz6gdd7e2q3pm91F6uRgh4UklPG4YoS4QCxhU+KQyvXfn3QDZO1T1LfwshBQCZv/JCF9
         NfUnlezgz1+iKG45T9seCoVxq0u10G17aYHJQWuG+kZa0xsiy0AxOJL2KZh1AuTZUz7Y
         i701naAvOG0TiVB4kzwHZFvedOAUQyyVAZgD14x/anG2ILTt2nujPfbBCZtC4mzLyVMX
         8ap4dSM1LRjRbBtvDxCrHhLiGd2ce8mOYHvx9YMDPhCqU0Bga9ENJX6xpv7Mp7lGC3aO
         nn1w==
X-Gm-Message-State: AGi0PuZvXSrtuUZMlikyPqkTQez0qH0SiIuRyWVmVSEzXd6PiO+V2UK6
        PVzZVRl+Nn1aZvgEZgh3SDS2Nkj6qBRMww==
X-Google-Smtp-Source: APiQypL29YhpcmDiwkdJuLx+IPWrg86N797Ulso1EMGSj4X4L7yWUcYHhSm1qb8MPtacyC7NLU6jWA==
X-Received: by 2002:ad4:4665:: with SMTP id z5mr4803594qvv.32.1586517902125;
        Fri, 10 Apr 2020 04:25:02 -0700 (PDT)
Received: from [192.168.1.183] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id p9sm1349995qkg.34.2020.04.10.04.25.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Apr 2020 04:25:01 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Subject: Re: KCSAN + KVM = host reset
Date:   Fri, 10 Apr 2020 07:25:00 -0400
Message-Id: <AC8A5393-B817-4868-AA85-B3019A1086F9@lca.pw>
References: <CANpmjNMR4BgfCxL9qXn0sQrJtQJbEPKxJ5_HEa2VXWi6UY4wig@mail.gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "paul E. McKenney" <paulmck@kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
In-Reply-To: <CANpmjNMR4BgfCxL9qXn0sQrJtQJbEPKxJ5_HEa2VXWi6UY4wig@mail.gmail.com>
To:     Marco Elver <elver@google.com>
X-Mailer: iPhone Mail (17D50)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Apr 10, 2020, at 5:47 AM, Marco Elver <elver@google.com> wrote:
>=20
> That would contradict what you said about it working if KCSAN is
> "off". What kernel are you attempting to use in the VM?

Well, I said set KCSAN debugfs to =E2=80=9Coff=E2=80=9D did not help, i.e., i=
t will reset the host running kvm.sh. It is the vanilla ubuntu 18.04 kernel i=
n VM.

github.com/cailca/linux-mm/blob/master/kvm.sh=
