Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFF12F473C
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 10:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbhAMJIt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 04:08:49 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:41739 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727429AbhAMJIs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 04:08:48 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 41186580714;
        Wed, 13 Jan 2021 04:08:01 -0500 (EST)
Received: from imap1 ([10.202.2.51])
  by compute6.internal (MEProxy); Wed, 13 Jan 2021 04:08:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type; s=fm1; bh=8TUZAUR19+RgfF2LD2QbIbb4344h7xW
        yLryfiiF4+Wg=; b=GjiV9JUKhozImXGRj2UStagLBEu7dB1vJ4SclmXDjY6KOG5
        eWiaVIEWJm44NwnUPgu11ucYRaK9mRQoKF+KfKHeZbUv4G//4nL3Vj/jhkC0QumC
        skfVb+jhBQaKX63UTAx1wjRL0cqQ9GS04Fi3GYTO7DZkTbvbTRskShQykM2mW330
        X9wZOCp/rigWNNIadb9mBdq5tsQcAlYiE+ZrSNv7DD2temwGzRm3PEyi3Cc2Y3dF
        QM7k/AIPfHTG0Q/EeJVKwXFfXjMSmdQ0w3Thi7L4Ifn0cmWizzkBd/kO5paEB4Es
        q0DEl58q3KX4gCsKObojnehp1d5pmUQ+g9YRJDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=8TUZAU
        R19+RgfF2LD2QbIbb4344h7xWyLryfiiF4+Wg=; b=OfxGTmZdwGJkXGiRdGcT18
        f+tDpOIdG8CsbMUyxJklCoLmx6E6WGzEsCuONltJmvkp8QBYDQoR/ppH0PVW1ZZv
        S/qRhthA7NlmffhzDtg1SpivIWKKPWGKkZdXoSkVyXeAZsIfwnmUTTYN7sW3DOX/
        H/5mTWImBHfJxiFqdVF10eyp4gdMLZMDcCvkvjv8eUHGQhGXNWR6+xwrHTvLXkEY
        heaQptcpqYTV9x1VcmmzCimAdypqdfSkRhczS7pgZFgvU6qQb7g4sCWZYTDuauHB
        JMHDdCsSxm1ZgyIZlnHcB23la8q9lDDtG7jGO3m/J1KIvCKM1j8d+k+G1yLVu82g
        ==
X-ME-Sender: <xms:b7j-X_pefl-uVHg34MC_duOvhcegjYk1g2B2Hb7Sapnge-BNIbhtnQ>
    <xme:b7j-X5ookdSP0Gc1yAQL2Uxo7Wx6pfNNsr44TYDs53djgxmpnf7WgrUWcIyJQYuBr
    CPIPxARfFcWvVYTrGs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedukedrtdefucetufdoteggodetrfdotffvucfrrh
    hofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdflihgrgihunhcu
    jggrnhhgfdcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqeenucggtf
    frrghtthgvrhhnpeefvdeiffetkeduleeiheegheeliedukedvgeelvdettdeuteeugfet
    heejgeetgfenucffohhmrghinhepohhpvghnghhrohhuphdrohhrghenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehjihgrgihunhdrhigrnhhg
    sehflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:b7j-X8P9oN2SWYL9H9NeGLbTVfi1nabE4rsEWfLs0TVFy5Jpxajwmw>
    <xmx:b7j-Xy6qMFCPXcnt87gdXZ_cTkrtLaRNqUYbnAM-qamqcrgpIEXq_w>
    <xmx:b7j-X-6NSeB5YQYmrTFEGpZfMazvfwjhCGY3nSDS-6LBdLoXuERyQQ>
    <xmx:cLj-X9RacJ7nbQcDAgAj61RRqAQBqOEnuk4dbereF8DUoBie7-4EVD_B-_g>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 04BF3C204F9; Wed, 13 Jan 2021 04:07:59 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-45-g4839256-fm-20210104.001-g48392560
Mime-Version: 1.0
Message-Id: <1ff91e13-3b0b-4a92-97bb-027efa5945c6@www.fastmail.com>
In-Reply-To: <c108febd-1fce-c66d-2140-002d8feb0db9@redhat.com>
References: <20201221005318.11866-1-jiaxun.yang@flygoat.com>
 <20201221005318.11866-8-jiaxun.yang@flygoat.com>
 <c108febd-1fce-c66d-2140-002d8feb0db9@redhat.com>
Date:   Wed, 13 Jan 2021 17:07:36 +0800
From:   "Jiaxun Yang" <jiaxun.yang@flygoat.com>
To:     "Thomas Huth" <thuth@redhat.com>,
        "BALATON Zoltan via" <qemu-devel@nongnu.org>
Cc:     "Kevin Wolf" <kwolf@redhat.com>, "Fam Zheng" <fam@euphon.net>,
        kvm@vger.kernel.org,
        "Viktor Prutyanov" <viktor.prutyanov@phystech.edu>,
        "Laurent Vivier" <lvivier@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Alistair Francis" <alistair@alistair23.me>,
        "Greg Kurz" <groug@kaod.org>,
        "Wainer dos Santos Moschetta" <wainersm@redhat.com>,
        "Max Reitz" <mreitz@redhat.com>, qemu-ppc@nongnu.org,
        "Paolo Bonzini" <pbonzini@redhat.com>, qemu-block@nongnu.org,
        =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
        "David Gibson" <david@gibson.dropbear.id.au>
Subject: Re: [PATCH 7/9] accel/kvm: avoid using predefined PAGE_SIZE
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On Wed, Jan 13, 2021, at 3:19 PM, Thomas Huth wrote:
> On 21/12/2020 01.53, Jiaxun Yang wrote:
> > As per POSIX specification of limits.h [1], OS libc may define
> > PAGE_SIZE in limits.h.
> > 
> > To prevent collosion of definition, we discard PAGE_SIZE from
> > defined by libc and take QEMU's variable.
> > 
> > [1]: https://pubs.opengroup.org/onlinepubs/7908799/xsh/limits.h.html
> > 
> > Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > ---
> >   accel/kvm/kvm-all.c | 3 +++
> >   1 file changed, 3 insertions(+)
> > 
> > diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> > index 389eaace72..3feb17d965 100644
> > --- a/accel/kvm/kvm-all.c
> > +++ b/accel/kvm/kvm-all.c
> > @@ -58,6 +58,9 @@
> >   /* KVM uses PAGE_SIZE in its definition of KVM_COALESCED_MMIO_MAX. We
> >    * need to use the real host PAGE_SIZE, as that's what KVM will use.
> >    */
> > +#ifdef PAGE_SIZE
> > +#undef PAGE_SIZE
> > +#endif
> >   #define PAGE_SIZE qemu_real_host_page_size
> 
> If I get that right, the PAGE_SIZE macro is only used one time in this 
> file... so it's maybe easier to get rid of the macro completely and replace 
> the single occurance with qemu_real_host_page_size directly?

It is also used in kernel headers included here.

Thanks.

- Jiaxun

> 
>   Thomas
> 
>

-- 
- Jiaxun
