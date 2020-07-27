Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9A122EBF9
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 14:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgG0MWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 08:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727078AbgG0MWd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 08:22:33 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF94C061794
        for <kvm@vger.kernel.org>; Mon, 27 Jul 2020 05:22:33 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id f1so14122985wro.2
        for <kvm@vger.kernel.org>; Mon, 27 Jul 2020 05:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=PJtv9+b4qef2V2ddA3Ij4b7HKuwebvVv0UYsG1HebhY=;
        b=LpLH9wwgF2Cy9jhKSAZpRcWejV2RF0BwExuO6OP95H7V7eEkw0k0crQIw8kmYQ5uqI
         sog0nVQB4+4+OLzyHftZ8ngklY7eW0MWzQ4pwX8jLDDP1zyIvtjG4IRPhYZZ2eW8Rfo8
         CQXBL70BIMmD/xmHjtlCr1Ya7L58GPOcFGRttEolrVB2bPyJTV0tHDm99achWMQAbsDy
         IFOc4Yzb/faYi5/Z6CcD2F7Qs7q4NgdQSjibiSPm3Nxu5JajcK2weL15/yDlVTJkr1lM
         HzJ+/H1LtMCGGeyjP+/tBVtWSuF6kfLhX5TlJ9Vty8YO7rvv1sRWbW5KoI5Fp56e5Lo6
         rqow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=PJtv9+b4qef2V2ddA3Ij4b7HKuwebvVv0UYsG1HebhY=;
        b=VZIN4dP5qn9jX08YqPlTB0lJN0BWYLRVzmv1MFCwZeS9MVz17XxjfTBaN1FerG7OnS
         /4eZXpdlksWLjOgBa2sNAZyah4cRqvXO3O3uNMvZxdr2cQb7etiYveCH7mO/p3sz6eEw
         kxY3CzWra323EIrLouKkx47Euj0wYuWywL403Fr5Q3SBJ9yRofO7rpTo7W76CFN5GAJm
         P4N+4xF1K2HGYntXwdSxy7zX7zDIgMgckLiuliBZxaHMUSfKExoyNcdLUhDLEBoRtmXj
         +dXG3M8mkFnEDP0H832hNepS7PoCEqdxehb/JqP/W8wdBEYYeXqULpSGIjN44NOx41TL
         +/bA==
X-Gm-Message-State: AOAM533ebpHv8sU+J/5FVRND5E3KVyhsShuHuYiZZG6bfRRyn8kvwzaK
        RyzkwaraQseaMFrZTDFLpJmZag==
X-Google-Smtp-Source: ABdhPJxn1TV9ljTjA0sDmdsrf/iqlWwUQ4uLBLFn80ei1d5r6fV+HideVSzN8QDgf06+k0LXrDSAfQ==
X-Received: by 2002:a05:6000:118c:: with SMTP id g12mr19870255wrx.212.1595852551660;
        Mon, 27 Jul 2020 05:22:31 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id q2sm8442957wro.8.2020.07.27.05.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 05:22:30 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 9F7791FF7E;
        Mon, 27 Jul 2020 13:22:29 +0100 (BST)
References: <86d42090-f042-06a1-efba-d46d449df280@arrikto.com>
 <20200715112342.GD18817@stefanha-x1.localdomain>
 <CAJSP0QU78mAK-DiOYXvTOEa3=CAEy1rQtyTBe5rrKDs=yfptAg@mail.gmail.com>
 <874kq1w3bz.fsf@linaro.org>
 <20200727101403.GF380177@stefanha-x1.localdomain>
 <87h7tt45dr.fsf@linaro.org>
 <20200727073311-mutt-send-email-mst@kernel.org>
User-agent: mu4e 1.5.5; emacs 28.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Nikos Dragazis <ndragazis@arrikto.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        "John G. Johnson" <john.g.johnson@oracle.com>,
        Andra-Irina Paraschiv <andraprs@amazon.com>,
        kvm <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        Maxime Coquelin <maxime.coquelin@redhat.com>,
        Alexander Graf <graf@amazon.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>,
        Jag Raman <jag.raman@oracle.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>
Subject: Re: Inter-VM device emulation (call on Mon 20th July 2020)
In-reply-to: <20200727073311-mutt-send-email-mst@kernel.org>
Date:   Mon, 27 Jul 2020 13:22:29 +0100
Message-ID: <87eeox406y.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Michael S. Tsirkin <mst@redhat.com> writes:

> On Mon, Jul 27, 2020 at 11:30:24AM +0100, Alex Benn=C3=83=C2=A9e wrote:
>>=20
>> Stefan Hajnoczi <stefanha@redhat.com> writes:
>>=20
>> > On Tue, Jul 21, 2020 at 11:49:04AM +0100, Alex Benn=C3=83=C2=A9e wrote:
>> >> Stefan Hajnoczi <stefanha@gmail.com> writes:
<snip>
>> >> Another thing that came across in the call was quite a lot of
>> >> assumptions about QEMU and Linux w.r.t virtio. While our project will
>> >> likely have Linux as a guest OS we are looking specifically at enabli=
ng
>> >> virtio for Type-1 hypervisors like Xen and the various safety certifi=
ed
>> >> proprietary ones. It is unlikely that QEMU would be used as the VMM f=
or
>> >> these deployments. We want to work out what sort of common facilities
>> >> hypervisors need to support to enable virtio so the daemons can be
>> >> re-usable and maybe setup with a minimal shim for the particular
>> >> hypervisor in question.
>> >
>> > The vhost-user protocol together with the backend program conventions
>> > define the wire protocol and command-line interface (see
>> > docs/interop/vhost-user.rst).
>> >
>> > vhost-user is already used by other VMMs today. For example,
>> > cloud-hypervisor implements vhost-user.
>>=20
>> Ohh that's a new one for me. I see it is a KVM only project but it's
>> nice to see another VMM using the common rust-vmm backend. There is
>> interest in using rust-vmm to implement VMMs for type-1 hypervisors but
>> we need to work out if there are two many type-2 concepts backed into
>> the lower level rust crates.
>>=20
>> > I'm sure there is room for improvement, but it seems like an increment=
al
>> > step given that vhost-user already tries to cater for this scenario.
>> >
>> > Are there any specific gaps you have identified?
>>=20
>> Aside from the desire to limit the shared memory footprint between the
>> backend daemon and a guest not yet.
>
> So it's certainly nice for security but not really a requirement for a
> type-1 HV, right?

Not a requirement per-se but type-1 setups don't assume a "one userspace
to rule them all" approach.

>> I suspect the eventfd mechanism might just end up being simulated by the
>> VMM as a result of whatever comes from the type-1 interface indicating a
>> doorbell has been rung. It is after all just a FD you consume numbers
>> over right?
>
> Does not even have to be numbers. We need a way to be woken up, a way to
> stop/start listening for wakeups and a way to detect that there was a
> wakeup while we were not listening.
>
> Though there are special tricks for offloads where we poke through
> layers in order to map things directly to hardware.
>
>> Not all setups will have an equivalent of a Dom0 "master" guest to do
>> orchestration. Highly embedded are likely to have fixed domains created
>> as the firmware/hypervisor start up.
>>=20
>> >
>> > Stefan
>>=20
>>=20
>> --=20
>> Alex Benn=C3=83=C2=A9e


--=20
Alex Benn=C3=A9e
